Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A49553F5C59
	for <lists+kvm@lfdr.de>; Tue, 24 Aug 2021 12:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236435AbhHXKtP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Aug 2021 06:49:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:5085 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236416AbhHXKtO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Aug 2021 06:49:14 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="196860693"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="196860693"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 03:48:30 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="526582378"
Received: from yizhanli-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.172.236])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 03:48:21 -0700
Date:   Tue, 24 Aug 2021 18:48:21 +0800
From:   Yu Zhang <yu.c.zhang@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Message-ID: <20210824104821.gwbxdvu43lhviuwl@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824005248.200037-1-seanjc@google.com>
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 23, 2021 at 05:52:48PM -0700, Sean Christopherson wrote:

Thanks a lot for sharing these ideas. Lots of questions are inlined below. :)

> The goal of this RFC is to try and align KVM, mm, and anyone else with skin in the
> game, on an acceptable direction for supporting guest private memory, e.g. for
> Intel's TDX.  The TDX architectural effectively allows KVM guests to crash the
> host if guest private memory is accessible to host userspace, and thus does not

What about incorrect/malicious accesses from host kernel? Should the direct mapping
also be removed for guest private memory?

> play nice with KVM's existing approach of pulling the pfn and mapping level from
> the host page tables.
> 
> This is by no means a complete patch; it's a rough sketch of the KVM changes that
> would be needed.  The kernel side of things is completely omitted from the patch;
> the design concept is below.
> 
> There's also fair bit of hand waving on implementation details that shouldn't
> fundamentally change the overall ABI, e.g. how the backing store will ensure
> there are no mappings when "converting" to guest private.
> 
> Background
> ==========
> 
> This is a loose continuation of Kirill's RFC[*] to support TDX guest private
> memory by tracking guest memory at the 'struct page' level.  This proposal is the
> result of several offline discussions that were prompted by Andy Lutomirksi's
> concerns with tracking via 'struct page':
> 
>   1. The kernel wouldn't easily be able to enforce a 1:1 page:guest association,
>      let alone a 1:1 pfn:gfn mapping.

May I ask why? Doesn't FOLL_GUEST in Kirill's earlier patch work? Or just
because traversing the host PT to get a PFN(for a PageGuest(page)) is too
heavy?

> 
>   2. Does not work for memory that isn't backed by 'struct page', e.g. if devices
>      gain support for exposing encrypted memory regions to guests.

Do you mean that a page not backed by 'struct page' might be mapped to other
user space? I thought the VM_GUEST flags for the VMA could prevent that(though
I may possiblely be wrong). Could you explain more? Thanks!

> 
>   3. Does not help march toward page migration or swap support (though it doesn't
>      hurt either).
> 
> [*] https://lkml.kernel.org/r/20210416154106.23721-1-kirill.shutemov@linux.intel.com
> 
> Concept
> =======
> 
> Guest private memory must be backed by an "enlightened" file descriptor, where
> "enlightened" means the implementing subsystem supports a one-way "conversion" to
> guest private memory and provides bi-directional hooks to communicate directly
> with KVM.  Creating a private fd doesn't necessarily have to be a conversion, e.g. it
> could also be a flag provided at file creation, a property of the file system itself,
> etc...
> 
> Before a private fd can be mapped into a KVM guest, it must be paired 1:1 with a
> KVM guest, i.e. multiple guests cannot share a fd.  At pairing, KVM and the fd's
> subsystem exchange a set of function pointers to allow KVM to call into the subsystem,
> e.g. to translate gfn->pfn, and vice versa to allow the subsystem to call into KVM,
> e.g. to invalidate/move/swap a gfn range.

So the gfn->pfn translation is done by the fd's subsystem? Again, could you
please elaborate how?

And each private memory region would need a seperate group of callbacks? 

> 
> Mapping a private fd in host userspace is disallowed, i.e. there is never a host
> virtual address associated with the fd and thus no userspace page tables pointing
> at the private memory.
> 
> Pinning _from KVM_ is not required.  If the backing store supports page migration
> and/or swap, it can query the KVM-provided function pointers to see if KVM supports
> the operation.  If the operation is not supported (this will be the case initially
> in KVM), the backing store is responsible for ensuring correct functionality.
> 
> Unmapping guest memory, e.g. to prevent use-after-free, is handled via a callback
> from the backing store to KVM.  KVM will employ techniques similar to those it uses
> for mmu_notifiers to ensure the guest cannot access freed memory.
> 
> A key point is that, unlike similar failed proposals of the past, e.g. /dev/mktme,
> existing backing stores can be englightened, a from-scratch implementations is not
> required (though would obviously be possible as well).
> 
> One idea for extending existing backing stores, e.g. HugeTLBFS and tmpfs, is
> to add F_SEAL_GUEST, which would convert the entire file to guest private memory
> and either fail if the current size is non-zero or truncate the size to zero.

Have you discussed memfd_secret(if host direct mapping is also to be removed)? 

And how does this F_SEAL_GUEST work?

> 
> KVM
> ===
> 
> Guest private memory is managed as a new address space, i.e. as a different set of
> memslots, similar to how KVM has a separate memory view for when a guest vCPU is
> executing in virtual SMM.  SMM is mutually exclusive with guest private memory.
> 
> The fd (the actual integer) is provided to KVM when a private memslot is added
> via KVM_SET_USER_MEMORY_REGION.  This is when the aforementioned pairing occurs.

My understanding of KVM_SET_USER_MEMORY_REGION is that, this ioctl is to
facilitate the binding of HVA and GPA ranges. But if there's no HVAs for
a private region at all, why do we need a memslot for it? Besides to keep
track of the private GFN ranges, and provide the callbacks, is there any
other reason?

Another question is: why do we need a whole new address space, instead of
one address space accommodating memslot types?

> 
> By default, KVM memslot lookups will be "shared", only specific touchpoints will
> be modified to work with private memslots, e.g. guest page faults.  All host
> accesses to guest memory, e.g. for emulation, will thus look for shared memory
> and naturally fail without attempting copy_to/from_user() if the guest attempts

Becasue gfn_to_hva() will fail first?

> to coerce KVM into access private memory.  Note, avoiding copy_to/from_user() and
> friends isn't strictly necessary, it's more of a happy side effect.
> 
> A new KVM exit reason, e.g. KVM_EXIT_MEMORY_ERROR, and data struct in vcpu->run
> is added to propagate illegal accesses (see above) and implicit conversions

Sorry, illegal accesses from VM?

Do you actually mean a KVM page fault caused by private access from VM, which
implicitly notifies KVM to mark it as private(e.g. by bouncing to Qemu, which
then creates a private memory region and ioctls into KVM)?

If the answer is yes, how about naming the exit reason as KVM_EXIT_MEMORY_PRIVATE?
Meanwhile, is Qemu also supposed to invoke some system call into host kernel
before ioctls into KVM? I'm still confused where the kernel callbacks like
the gfn_to_pfn() come from(and how they function)... :)

> to userspace (see below).  Note, the new exit reason + struct can also be to
> support several other feature requests in KVM[1][2].
> 
> The guest may explicitly or implicity request KVM to map a shared/private variant
> of a GFN.  An explicit map request is done via hypercall (out of scope for this
> proposal as both TDX and SNP ABIs define such a hypercall).  An implicit map request
> is triggered simply by the guest accessing the shared/private variant, which KVM
> sees as a guest page fault (EPT violation or #NPF).  Ideally only explicit requests
> would be supported, but neither TDX nor SNP require this in their guest<->host ABIs.

Well, I am wondering, should we assume all guest pages as shared or private by
default? I mean, if all guest pages are private when the VM is created, maybe
the private memslots can be initialized in VM creation time, and be deleted/splited
later(e.g. in response to guest sharing  hypercalls)?

It may simplify the logic, but may also restrict the VM type(e.g. to be TD guest).

> 
> For implicit or explicit mappings, if a memslot is found that fully covers the
> requested range (which is a single gfn for implicit mappings), KVM's normal guest
> page fault handling works with minimal modification.
> 
> If a memslot is not found, for explicit mappings, KVM will exit to userspace with
> the aforementioned dedicated exit reason.  For implict _private_ mappings, KVM will
> also immediately exit with the same dedicated reason.  For implicit shared mappings,
> an additional check is required to differentiate between emulated MMIO and an
> implicit private->shared conversion[*].  If there is an existing private memslot
> for the gfn, KVM will exit to userspace, otherwise KVM will treat the access as an
> emulated MMIO access and handle the page fault accordingly.
> 
> [1] https://lkml.kernel.org/r/YKxJLcg/WomPE422@google.com
> [2] https://lkml.kernel.org/r/20200617230052.GB27751@linux.intel.com
> 
> Punching Holes
> ==============
> 
> The expected userspace memory model is that mapping requests will be handled as
> conversions, e.g. on a shared mapping request, first unmap the private gfn range,
> then map the shared gfn range.  A new KVM ioctl() will likely be needed to allow
> userspace to punch a hole in a memslot, as expressing such an operation isn't
> possible with KVM_SET_USER_MEMORY_REGION.  While userspace could delete the
> memslot, then recreate three new memslots, doing so would be destructive to guest
> data as unmapping guest private memory (from the EPT/NPT tables) is destructive
> to the data for both TDX and SEV-SNP guests.

May I ask why? Thanks!

> 
> Pros (vs. struct page)
> ======================
> 
> Easy to enforce 1:1 fd:guest pairing, as well as 1:1 gfn:pfn mapping.
> 
> Userspace page tables are not populated, e.g. reduced memory footprint, lower
> probability of making private memory accessible to userspace.
> 
> Provides line of sight to supporting page migration and swap.
> 
> Provides line of sight to mapping MMIO pages into guest private memory.
> 
> Cons (vs. struct page)
> ======================
> 
> Significantly more churn in KVM, e.g. to plumb 'private' through where needed,
> support memslot hole punching, etc...
> 
> KVM's MMU gets another method of retrieving host pfn and page size.

And the method is provided by host kernel? How does this method work?

[...]
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index a272ccbddfa1..771080235b2d 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -2896,6 +2896,9 @@ int kvm_mmu_max_mapping_level(struct kvm *kvm,
>  	if (max_level == PG_LEVEL_4K)
>  		return PG_LEVEL_4K;
>  
> +	if (memslot_is_private(slot))
> +		return slot->private_ops->pfn_mapping_level(...);
> +

Oh, any suggestion how host kernel decides the mapping level here?

>  	host_level = host_pfn_mapping_level(kvm, gfn, pfn, slot);
>  	return min(host_level, max_level);
>  }
> @@ -3835,9 +3838,11 @@ static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>  
>  static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault, int *r)
>  {
> -	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
> +	struct kvm_memory_slot *slot;
>  	bool async;
>  
> +	slot = __kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn, fault->private);
> +
>  	/*
>  	 * Retry the page fault if the gfn hit a memslot that is being deleted
>  	 * or moved.  This ensures any existing SPTEs for the old memslot will
> @@ -3846,8 +3851,19 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  	if (slot && (slot->flags & KVM_MEMSLOT_INVALID))
>  		goto out_retry;
>  
> +	/*
> +	 * Exit to userspace to map the requested private/shared memory region
> +	 * if there is no memslot and (a) the access is private or (b) there is
> +	 * an existing private memslot.  Emulated MMIO must be accessed through
> +	 * shared GPAs, thus a memslot miss on a private GPA is always handled
> +	 * as an implicit conversion "request".
> +	 */

For (b), do you mean this fault is for a GFN which marked as private, but now
converted to a shared? If true, could we just disallow it if no explict sharing
hypercall is triggered?

> +	if (!slot &&
> +	    (fault->private || __kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn, true)))
> +		goto out_convert;
> +
>  	if (!kvm_is_visible_memslot(slot)) {
> -		/* Don't expose private memslots to L2. */
> +		/* Don't expose KVM's internal memslots to L2. */
>  		if (is_guest_mode(vcpu)) {
>  			fault->pfn = KVM_PFN_NOSLOT;
>  			fault->map_writable = false;
> @@ -3890,6 +3906,12 @@ static bool kvm_faultin_pfn(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
>  out_retry:
>  	*r = RET_PF_RETRY;
>  	return true;
> +
> +out_convert:
> +	vcpu->run->exit_reason = KVM_EXIT_MAP_MEMORY;
> +	/* TODO: fill vcpu->run with more info. */
> +	*r = 0;
> +	return true;
>  }


B.R.
Yu

