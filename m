Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D272C213053
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 02:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgGCAF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 20:05:58 -0400
Received: from mga04.intel.com ([192.55.52.120]:10479 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbgGCAF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 20:05:58 -0400
IronPort-SDR: 2l7bylSz02M8OAF7WwFdW18l7jWuInVDYqcmItxch72oFWyFbgPGCkVtBKYSPTY8CCcE4p6BQ3
 lYx4IcHSe9pw==
X-IronPort-AV: E=McAfee;i="6000,8403,9670"; a="144572776"
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="144572776"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 17:05:57 -0700
IronPort-SDR: T7XbuntX1HLfrkphgH8TZLgoyJLtop12joHGUzzu6C34I1Z1fjcR8OFmzleapQBXub2OhbllzD
 sTH/mhfcEN2g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,306,1589266800"; 
   d="scan'208";a="321662315"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by FMSMGA003.fm.intel.com with ESMTP; 02 Jul 2020 17:05:57 -0700
Date:   Thu, 2 Jul 2020 17:05:57 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v10 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200703000557.GM3575@linux.intel.com>
References: <20200601115957.1581250-1-peterx@redhat.com>
 <20200601115957.1581250-4-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601115957.1581250-4-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 01, 2020 at 07:59:46AM -0400, Peter Xu wrote:
> Originally, we have three code paths that can dirty a page without
> vcpu context for X86:
> 
>   - init_rmode_identity_map
>   - init_rmode_tss
>   - kvmgt_rw_gpa
> 
> init_rmode_identity_map and init_rmode_tss will be setup on
> destination VM no matter what (and the guest cannot even see them), so
> it does not make sense to track them at all.
> 
> To do this, allow __x86_set_memory_region() to return the userspace
> address that just allocated to the caller.  Then in both of the
> functions we directly write to the userspace address instead of
> calling kvm_write_*() APIs.
> 
> Another trivial change is that we don't need to explicitly clear the
> identity page table root in init_rmode_identity_map() because no
> matter what we'll write to the whole page with 4M huge page entries.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 +-
>  arch/x86/kvm/svm/avic.c         | 11 +++--
>  arch/x86/kvm/vmx/vmx.c          | 84 ++++++++++++++++-----------------
>  arch/x86/kvm/x86.c              | 44 +++++++++++++----
>  4 files changed, 86 insertions(+), 56 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 42a2d0d3984a..39477f8f3f2c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1650,7 +1650,8 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
>  
>  int kvm_is_in_guest(void);
>  
> -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size);
> +void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
> +				     u32 size);
>  bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu);
>  bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index e80daa98682f..86e9621ba026 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -235,7 +235,9 @@ static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
>   */
>  static int avic_update_access_page(struct kvm *kvm, bool activate)
>  {
> -	int ret = 0;
> +	void __user *ret;
> +	int r = 0;
> +
>  
>  	mutex_lock(&kvm->slots_lock);
>  	/*
> @@ -251,13 +253,16 @@ static int avic_update_access_page(struct kvm *kvm, bool activate)
>  				      APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
>  				      APIC_DEFAULT_PHYS_BASE,
>  				      activate ? PAGE_SIZE : 0);
> -	if (ret)
> +	if (IS_ERR(ret)) {
> +		r = PTR_ERR(ret);
>  		goto out;
> +	}
> +
>  
>  	kvm->arch.apic_access_page_done = activate;
>  out:
>  	mutex_unlock(&kvm->slots_lock);
> -	return ret;
> +	return r;
>  }
>  
>  static int avic_init_backing_page(struct kvm_vcpu *vcpu)
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index c2c6335a998c..c44637e8e9d6 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3442,34 +3442,26 @@ static bool guest_state_valid(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -static int init_rmode_tss(struct kvm *kvm)
> +static int init_rmode_tss(struct kvm *kvm, void __user *ua)
>  {
> -	gfn_t fn;
> -	u16 data = 0;
> -	int idx, r;
> +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
> +	u16 data;
> +	int i, r;
> +
> +	for (i = 0; i < 3; i++) {
> +		r = __copy_to_user(ua + PAGE_SIZE * i, zero_page, PAGE_SIZE);
> +		if (r)

No need to capture the return in 'r'.

> +			return -EFAULT;
> +	}
>  
> -	idx = srcu_read_lock(&kvm->srcu);
> -	fn = to_kvm_vmx(kvm)->tss_addr >> PAGE_SHIFT;
> -	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
> -	if (r < 0)
> -		goto out;
>  	data = TSS_BASE_SIZE + TSS_REDIRECTION_SIZE;
> -	r = kvm_write_guest_page(kvm, fn++, &data,
> -			TSS_IOPB_BASE_OFFSET, sizeof(u16));
> -	if (r < 0)
> -		goto out;
> -	r = kvm_clear_guest_page(kvm, fn++, 0, PAGE_SIZE);
> -	if (r < 0)
> -		goto out;
> -	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
> -	if (r < 0)
> -		goto out;
> +	r = __copy_to_user(ua + TSS_IOPB_BASE_OFFSET, &data, sizeof(u16));
> +	if (r)

Same here.

> +		return -EFAULT;
> +
>  	data = ~0;
> -	r = kvm_write_guest_page(kvm, fn, &data,
> -				 RMODE_TSS_SIZE - 2 * PAGE_SIZE - 1,
> -				 sizeof(u8));
> -out:
> -	srcu_read_unlock(&kvm->srcu, idx);
> +	r = __copy_to_user(ua + RMODE_TSS_SIZE - 1, &data, sizeof(u8));

Not that it really matters, but this should match the behavior of the other
__copy_to_user() calls, i.e. explicitly return -EFAULT.  Or switch the
others to return the result.  The mixed usage is odd.

> +
>  	return r;
>  }
>  
> @@ -3477,7 +3469,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
>  {
>  	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
>  	int i, r = 0;
> -	kvm_pfn_t identity_map_pfn;
> +	void __user *uaddr;
>  	u32 tmp;
>  
>  	/* Protect kvm_vmx->ept_identity_pagetable_done. */
> @@ -3488,24 +3480,25 @@ static int init_rmode_identity_map(struct kvm *kvm)
>  
>  	if (!kvm_vmx->ept_identity_map_addr)
>  		kvm_vmx->ept_identity_map_addr = VMX_EPT_IDENTITY_PAGETABLE_ADDR;
> -	identity_map_pfn = kvm_vmx->ept_identity_map_addr >> PAGE_SHIFT;
>  
> -	r = __x86_set_memory_region(kvm, IDENTITY_PAGETABLE_PRIVATE_MEMSLOT,
> -				    kvm_vmx->ept_identity_map_addr, PAGE_SIZE);
> -	if (r < 0)
> +	uaddr = __x86_set_memory_region(kvm,
> +					IDENTITY_PAGETABLE_PRIVATE_MEMSLOT,
> +					kvm_vmx->ept_identity_map_addr,
> +					PAGE_SIZE);
> +	if (IS_ERR(uaddr)) {
> +		r = PTR_ERR(uaddr);
>  		goto out;
> +	}
>  
> -	r = kvm_clear_guest_page(kvm, identity_map_pfn, 0, PAGE_SIZE);
> -	if (r < 0)
> -		goto out;
>  	/* Set up identity-mapping pagetable for EPT in real mode */
>  	for (i = 0; i < PT32_ENT_PER_PAGE; i++) {
>  		tmp = (i << 22) + (_PAGE_PRESENT | _PAGE_RW | _PAGE_USER |
>  			_PAGE_ACCESSED | _PAGE_DIRTY | _PAGE_PSE);
> -		r = kvm_write_guest_page(kvm, identity_map_pfn,
> -				&tmp, i * sizeof(tmp), sizeof(tmp));
> -		if (r < 0)
> +		r = __copy_to_user(uaddr + i * sizeof(tmp), &tmp, sizeof(tmp));
> +		if (r) {
> +			r = -EFAULT;

Another case where capturing the result is unnecessary.  I don't have a
preference as to whether the result of __copy_{to,from}_user() is returned
directly or morphed to -EFAULT, but we should be consistent, especially
within a single patch.

>  			goto out;
> +		}
>  	}
>  	kvm_vmx->ept_identity_pagetable_done = true;
>  
> @@ -3532,19 +3525,22 @@ static void seg_setup(int seg)
>  static int alloc_apic_access_page(struct kvm *kvm)
>  {
>  	struct page *page;
> -	int r = 0;
> +	void __user *r;
> +	int ret = 0;
>  
>  	mutex_lock(&kvm->slots_lock);
>  	if (kvm->arch.apic_access_page_done)
>  		goto out;
>  	r = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
>  				    APIC_DEFAULT_PHYS_BASE, PAGE_SIZE);

Naming the new 'void __user *hva' would yield a smaller differ and would
probably help readers in the future.

> -	if (r)
> +	if (IS_ERR(r)) {
> +		ret = PTR_ERR(r);
>  		goto out;
> +	}
>  
>  	page = gfn_to_page(kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
>  	if (is_error_page(page)) {
> -		r = -EFAULT;
> +		ret = -EFAULT;
>  		goto out;
>  	}
>  
> @@ -3556,7 +3552,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
>  	kvm->arch.apic_access_page_done = true;
>  out:
>  	mutex_unlock(&kvm->slots_lock);
> -	return r;
> +	return ret;
>  }
>  
>  int allocate_vpid(void)
> @@ -4483,7 +4479,7 @@ static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
>  
>  static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
>  {
> -	int ret;
> +	void __user *ret;
>  
>  	if (enable_unrestricted_guest)
>  		return 0;
> @@ -4493,10 +4489,12 @@ static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
>  				      PAGE_SIZE * 3);
>  	mutex_unlock(&kvm->slots_lock);
>  
> -	if (ret)
> -		return ret;
> +	if (IS_ERR(ret))
> +		return PTR_ERR(ret);
> +
>  	to_kvm_vmx(kvm)->tss_addr = addr;
> -	return init_rmode_tss(kvm);
> +
> +	return init_rmode_tss(kvm, ret);
>  }
>  
>  static int vmx_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index ac7b0e6f4000..5c106ca948ed 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9826,7 +9826,32 @@ void kvm_arch_sync_events(struct kvm *kvm)
>  	kvm_free_pit(kvm);
>  }
>  
> -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> +#define  ERR_PTR_USR(e)  ((void __user *)ERR_PTR(e))
> +
> +/**
> + * __x86_set_memory_region: Setup KVM internal memory slot
> + *
> + * @kvm: the kvm pointer to the VM.
> + * @id: the slot ID to setup.
> + * @gpa: the GPA to install the slot (unused when @size == 0).
> + * @size: the size of the slot. Set to zero to uninstall a slot.
> + *
> + * This function helps to setup a KVM internal memory slot.  Specify
> + * @size > 0 to install a new slot, while @size == 0 to uninstall a
> + * slot.  The return code can be one of the following:
> + *
> + *   HVA:           on success (uninstall will return a bogus HVA)
> + *   -errno:        on error
> + *
> + * The caller should always use IS_ERR() to check the return value
> + * before use.  Note, the KVM internal memory slots are guaranteed to
> + * remain valid and unchanged until the VM is destroyed, i.e., the
> + * GPA->HVA translation will not change.  However, the HVA is a user
> + * address, i.e. its accessibility is not guaranteed, and must be
> + * accessed via __copy_{to,from}_user().
> + */
> +void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
> +				      u32 size)
>  {
>  	int i, r;
>  	unsigned long hva, uninitialized_var(old_npages);
> @@ -9835,12 +9860,12 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
>  
>  	/* Called with kvm->slots_lock held.  */
>  	if (WARN_ON(id >= KVM_MEM_SLOTS_NUM))
> -		return -EINVAL;
> +		return ERR_PTR_USR(-EINVAL);
>  
>  	slot = id_to_memslot(slots, id);
>  	if (size) {
>  		if (slot && slot->npages)
> -			return -EEXIST;
> +			return ERR_PTR_USR(-EEXIST);
>  
>  		/*
>  		 * MAP_SHARED to prevent internal slot pages from being moved
> @@ -9849,17 +9874,18 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
>  		hva = vm_mmap(NULL, 0, size, PROT_READ | PROT_WRITE,
>  			      MAP_SHARED | MAP_ANONYMOUS, 0);
>  		if (IS_ERR((void *)hva))
> -			return PTR_ERR((void *)hva);
> +			return (void __user *)hva;
>  	} else {
> -		if (!slot || !slot->npages)
> -			return 0;
> -
>  		/*
>  		 * Stuff a non-canonical value to catch use-after-delete.  This
>  		 * ends up being 0 on 32-bit KVM, but there's no better
>  		 * alternative.
>  		 */
>  		hva = (unsigned long)(0xdeadull << 48);
> +
> +		if (!slot || !slot->npages)
> +			return (void __user *)hva;

My clever shenanigans got discarded, so this weirdness happily is gone. 

> +
>  		old_npages = slot->npages;
>  	}
>  
> @@ -9873,13 +9899,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
>  		m.memory_size = size;
>  		r = __kvm_set_memory_region(kvm, &m);
>  		if (r < 0)
> -			return r;
> +			return ERR_PTR_USR(r);
>  	}
>  
>  	if (!size)
>  		vm_munmap(hva, old_npages * PAGE_SIZE);
>  
> -	return 0;
> +	return (void __user *)hva;
>  }
>  EXPORT_SYMBOL_GPL(__x86_set_memory_region);
>  
> -- 
> 2.26.2
> 
