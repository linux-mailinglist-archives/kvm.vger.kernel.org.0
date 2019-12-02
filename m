Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F84110F156
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 21:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbfLBUKi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 15:10:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:57328 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbfLBUKh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 15:10:37 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Dec 2019 12:10:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,270,1571727600"; 
   d="scan'208";a="208248149"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 02 Dec 2019 12:10:36 -0800
Date:   Mon, 2 Dec 2019 12:10:36 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
Message-ID: <20191202201036.GJ4063@linux.intel.com>
References: <20191129213505.18472-1-peterx@redhat.com>
 <20191129213505.18472-5-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191129213505.18472-5-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 29, 2019 at 04:34:54PM -0500, Peter Xu wrote:
> This patch is heavily based on previous work from Lei Cao
> <lei.cao@stratus.com> and Paolo Bonzini <pbonzini@redhat.com>. [1]
> 
> KVM currently uses large bitmaps to track dirty memory.  These bitmaps
> are copied to userspace when userspace queries KVM for its dirty page
> information.  The use of bitmaps is mostly sufficient for live
> migration, as large parts of memory are be dirtied from one log-dirty
> pass to another.  However, in a checkpointing system, the number of
> dirty pages is small and in fact it is often bounded---the VM is
> paused when it has dirtied a pre-defined number of pages. Traversing a
> large, sparsely populated bitmap to find set bits is time-consuming,
> as is copying the bitmap to user-space.
> 
> A similar issue will be there for live migration when the guest memory
> is huge while the page dirty procedure is trivial.  In that case for
> each dirty sync we need to pull the whole dirty bitmap to userspace
> and analyse every bit even if it's mostly zeros.
> 
> The preferred data structure for above scenarios is a dense list of
> guest frame numbers (GFN).  This patch series stores the dirty list in
> kernel memory that can be memory mapped into userspace to allow speedy
> harvesting.
> 
> We defined two new data structures:
> 
>   struct kvm_dirty_ring;
>   struct kvm_dirty_ring_indexes;
> 
> Firstly, kvm_dirty_ring is defined to represent a ring of dirty
> pages.  When dirty tracking is enabled, we can push dirty gfn onto the
> ring.
> 
> Secondly, kvm_dirty_ring_indexes is defined to represent the
> user/kernel interface of each ring.  Currently it contains two
> indexes: (1) avail_index represents where we should push our next
> PFN (written by kernel), while (2) fetch_index represents where the
> userspace should fetch the next dirty PFN (written by userspace).
> 
> One complete ring is composed by one kvm_dirty_ring plus its
> corresponding kvm_dirty_ring_indexes.
> 
> Currently, we have N+1 rings for each VM of N vcpus:
> 
>   - for each vcpu, we have 1 per-vcpu dirty ring,
>   - for each vm, we have 1 per-vm dirty ring

Why?  I assume the purpose of per-vcpu rings is to avoid contention between
threads, but the motiviation needs to be explicitly stated.  And why is a
per-vm fallback ring needed?

If my assumption is correct, have other approaches been tried/profiled?
E.g. using cmpxchg to reserve N number of entries in a shared ring.  IMO,
adding kvm_get_running_vcpu() is a hack that is just asking for future
abuse and the vcpu/vm/as_id interactions in mark_page_dirty_in_ring()
look extremely fragile.  I also dislike having two different mechanisms
for accessing the ring (lock for per-vm, something else for per-vcpu).

> Please refer to the documentation update in this patch for more
> details.
> 
> Note that this patch implements the core logic of dirty ring buffer.
> It's still disabled for all archs for now.  Also, we'll address some
> of the other issues in follow up patches before it's firstly enabled
> on x86.
> 
> [1] https://patchwork.kernel.org/patch/10471409/
> 
> Signed-off-by: Lei Cao <lei.cao@stratus.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---

...

> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> new file mode 100644
> index 000000000000..9264891f3c32
> --- /dev/null
> +++ b/virt/kvm/dirty_ring.c
> @@ -0,0 +1,156 @@
> +#include <linux/kvm_host.h>
> +#include <linux/kvm.h>
> +#include <linux/vmalloc.h>
> +#include <linux/kvm_dirty_ring.h>
> +
> +u32 kvm_dirty_ring_get_rsvd_entries(void)
> +{
> +	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
> +}
> +
> +int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring)
> +{
> +	u32 size = kvm->dirty_ring_size;

Just pass in @size, that way you don't need @kvm.  And the callers will be
less ugly, e.g. the initial allocation won't need to speculatively set
kvm->dirty_ring_size.

> +
> +	ring->dirty_gfns = vmalloc(size);
> +	if (!ring->dirty_gfns)
> +		return -ENOMEM;
> +	memset(ring->dirty_gfns, 0, size);
> +
> +	ring->size = size / sizeof(struct kvm_dirty_gfn);
> +	ring->soft_limit =
> +	    (kvm->dirty_ring_size / sizeof(struct kvm_dirty_gfn)) -

And passing @size avoids issues like this where a local var is ignored.

> +	    kvm_dirty_ring_get_rsvd_entries();
> +	ring->dirty_index = 0;
> +	ring->reset_index = 0;
> +	spin_lock_init(&ring->lock);
> +
> +	return 0;
> +}
> +

...

> +void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
> +{
> +	if (ring->dirty_gfns) {

Why condition freeing the dirty ring on kvm->dirty_ring_size, this
obviously protects itself.  Not to mention vfree() also plays nice with a
NULL input.

> +		vfree(ring->dirty_gfns);
> +		ring->dirty_gfns = NULL;
> +	}
> +}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 681452d288cd..8642c977629b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -64,6 +64,8 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/kvm.h>
>  
> +#include <linux/kvm_dirty_ring.h>
> +
>  /* Worst case buffer size needed for holding an integer. */
>  #define ITOA_MAX_LEN 12
>  
> @@ -149,6 +151,10 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
>  				    struct kvm_vcpu *vcpu,
>  				    struct kvm_memory_slot *memslot,
>  				    gfn_t gfn);
> +static void mark_page_dirty_in_ring(struct kvm *kvm,
> +				    struct kvm_vcpu *vcpu,
> +				    struct kvm_memory_slot *slot,
> +				    gfn_t gfn);
>  
>  __visible bool kvm_rebooting;
>  EXPORT_SYMBOL_GPL(kvm_rebooting);
> @@ -359,11 +365,22 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>  	vcpu->preempted = false;
>  	vcpu->ready = false;
>  
> +	if (kvm->dirty_ring_size) {
> +		r = kvm_dirty_ring_alloc(vcpu->kvm, &vcpu->dirty_ring);
> +		if (r) {
> +			kvm->dirty_ring_size = 0;
> +			goto fail_free_run;

This looks wrong, kvm->dirty_ring_size is used to free allocations, i.e.
previous allocations will leak if a vcpu allocation fails.

> +		}
> +	}
> +
>  	r = kvm_arch_vcpu_init(vcpu);
>  	if (r < 0)
> -		goto fail_free_run;
> +		goto fail_free_ring;
>  	return 0;
>  
> +fail_free_ring:
> +	if (kvm->dirty_ring_size)
> +		kvm_dirty_ring_free(&vcpu->dirty_ring);
>  fail_free_run:
>  	free_page((unsigned long)vcpu->run);
>  fail:
> @@ -381,6 +398,8 @@ void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
>  	put_pid(rcu_dereference_protected(vcpu->pid, 1));
>  	kvm_arch_vcpu_uninit(vcpu);
>  	free_page((unsigned long)vcpu->run);
> +	if (vcpu->kvm->dirty_ring_size)
> +		kvm_dirty_ring_free(&vcpu->dirty_ring);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
>  
> @@ -690,6 +709,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	struct kvm *kvm = kvm_arch_alloc_vm();
>  	int r = -ENOMEM;
>  	int i;
> +	struct page *page;
>  
>  	if (!kvm)
>  		return ERR_PTR(-ENOMEM);
> @@ -705,6 +725,14 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  
>  	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
>  
> +	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +	if (!page) {
> +		r = -ENOMEM;
> +		goto out_err_alloc_page;
> +	}
> +	kvm->vm_run = page_address(page);
> +	BUILD_BUG_ON(sizeof(struct kvm_vm_run) > PAGE_SIZE);
> +
>  	if (init_srcu_struct(&kvm->srcu))
>  		goto out_err_no_srcu;
>  	if (init_srcu_struct(&kvm->irq_srcu))
> @@ -775,6 +803,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  out_err_no_irq_srcu:
>  	cleanup_srcu_struct(&kvm->srcu);
>  out_err_no_srcu:
> +	free_page((unsigned long)page);
> +	kvm->vm_run = NULL;

No need to nullify vm_run.

> +out_err_alloc_page:
>  	kvm_arch_free_vm(kvm);
>  	mmdrop(current->mm);
>  	return ERR_PTR(r);
> @@ -800,6 +831,15 @@ static void kvm_destroy_vm(struct kvm *kvm)
>  	int i;
>  	struct mm_struct *mm = kvm->mm;
>  
> +	if (kvm->dirty_ring_size) {
> +		kvm_dirty_ring_free(&kvm->vm_dirty_ring);
> +	}

Unnecessary parantheses.

> +
> +	if (kvm->vm_run) {
> +		free_page((unsigned long)kvm->vm_run);
> +		kvm->vm_run = NULL;
> +	}
> +
>  	kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
>  	kvm_destroy_vm_debugfs(kvm);
>  	kvm_arch_sync_events(kvm);
> @@ -2301,7 +2341,7 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
>  {
>  	if (memslot && memslot->dirty_bitmap) {
>  		unsigned long rel_gfn = gfn - memslot->base_gfn;
> -
> +		mark_page_dirty_in_ring(kvm, vcpu, memslot, gfn);
>  		set_bit_le(rel_gfn, memslot->dirty_bitmap);
>  	}
>  }
> @@ -2649,6 +2689,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
