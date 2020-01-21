Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4572B144111
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 16:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729052AbgAUP47 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 10:56:59 -0500
Received: from mga17.intel.com ([192.55.52.151]:15145 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726714AbgAUP47 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jan 2020 10:56:59 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Jan 2020 07:56:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,346,1574150400"; 
   d="scan'208";a="279945631"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 21 Jan 2020 07:56:57 -0800
Date:   Tue, 21 Jan 2020 07:56:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v3 09/21] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200121155657.GA7923@linux.intel.com>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-10-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109145729.32898-10-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 09, 2020 at 09:57:17AM -0500, Peter Xu wrote:
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
> calling kvm_write_*() APIs.  We need to make sure that we have the
> slots_lock held when accessing the userspace address.
> 
> Another trivial change is that we don't need to explicitly clear the
> identity page table root in init_rmode_identity_map() because no
> matter what we'll write to the whole page with 4M huge page entries.
> 
> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 +-
>  arch/x86/kvm/svm.c              |  3 +-
>  arch/x86/kvm/vmx/vmx.c          | 68 ++++++++++++++++-----------------
>  arch/x86/kvm/x86.c              | 18 +++++++--
>  4 files changed, 51 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index eb6673c7d2e3..f536d139b3d2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1618,7 +1618,8 @@ void __kvm_request_immediate_exit(struct kvm_vcpu *vcpu);
>  
>  int kvm_is_in_guest(void);
>  
> -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size);
> +int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size,
> +			    unsigned long *uaddr);

No need for a new param, just return a "void __user *" (or "void *" if the
__user part requires lots of casting) and use ERR_PTR() to encode errors in
the return value.  I.e. return the userspace address.

The refactoring to return the address should be done in a separate patch as
prep work for the move to __copy_to_user().

>  bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu);
>  bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 8f1b715dfde8..03a344ce7b66 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1698,7 +1698,8 @@ static int avic_init_access_page(struct kvm_vcpu *vcpu)
>  	ret = __x86_set_memory_region(kvm,
>  				      APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
>  				      APIC_DEFAULT_PHYS_BASE,
> -				      PAGE_SIZE);
> +				      PAGE_SIZE,
> +				      NULL);
>  	if (ret)
>  		goto out;
>  
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 7e3d370209e0..62175a246bcc 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3441,34 +3441,28 @@ static bool guest_state_valid(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -static int init_rmode_tss(struct kvm *kvm)
> +static int init_rmode_tss(struct kvm *kvm, unsigned long *uaddr)

uaddr is not a pointer to an unsigned long, it's a pointer to a TSS.  Given
that it's dereferenced as a "void __user *", it's probably best passed as
exactly that.

This code also needs to be tested by doing unrestricted_guest=0 when
loading kvm_intel, because it's obviously broken.  __x86_set_memory_region()
takes an "unsigned long *", interpreted as a "pointer to a usersepace
address", i.e. a "void __user **".  But the callers are treating the param
as a "unsigned long in userpace", e.g. init_rmode_identity_map() declares
uaddr as an "unsigned long *", when really it should be declaring a
straight "unsigned long" and passing "&uaddr".  The only thing that saves
KVM from dereferencing a bad pointer in __x86_set_memory_region() is that
uaddr is initialized to NULL 

>  {
> -	gfn_t fn;
> +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
>  	u16 data = 0;
>  	int idx, r;
>  
> -	idx = srcu_read_lock(&kvm->srcu);
> -	fn = to_kvm_vmx(kvm)->tss_addr >> PAGE_SHIFT;
> -	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
> -	if (r < 0)
> -		goto out;
> +	for (idx = 0; idx < 3; idx++) {
> +		r = __copy_to_user((void __user *)uaddr + PAGE_SIZE * idx,
> +				   zero_page, PAGE_SIZE);
> +		if (r)
> +			return -EFAULT;
> +	}
> +
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
> +	r = __copy_to_user((void __user *)uaddr + TSS_IOPB_BASE_OFFSET,
> +			   &data, sizeof(data));
> +	if (r)
> +		return -EFAULT;
> +
>  	data = ~0;
> -	r = kvm_write_guest_page(kvm, fn, &data,
> -				 RMODE_TSS_SIZE - 2 * PAGE_SIZE - 1,
> -				 sizeof(u8));
> -out:
> -	srcu_read_unlock(&kvm->srcu, idx);
> +	r = __copy_to_user((void __user *)uaddr - 1, &data, sizeof(data));
> +
>  	return r;

Why not "return __copy_to_user();"?

>  }
>  
> @@ -3478,6 +3472,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
>  	int i, r = 0;
>  	kvm_pfn_t identity_map_pfn;
>  	u32 tmp;
> +	unsigned long *uaddr = NULL;

Again, not a pointer to an unsigned long.

>  	/* Protect kvm_vmx->ept_identity_pagetable_done. */
>  	mutex_lock(&kvm->slots_lock);
> @@ -3490,21 +3485,21 @@ static int init_rmode_identity_map(struct kvm *kvm)
>  	identity_map_pfn = kvm_vmx->ept_identity_map_addr >> PAGE_SHIFT;
>  
>  	r = __x86_set_memory_region(kvm, IDENTITY_PAGETABLE_PRIVATE_MEMSLOT,
> -				    kvm_vmx->ept_identity_map_addr, PAGE_SIZE);
> +				    kvm_vmx->ept_identity_map_addr, PAGE_SIZE,
> +				    uaddr);
>  	if (r < 0)
>  		goto out;
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
> +		r = __copy_to_user((void __user *)uaddr + i * sizeof(tmp),
> +				   &tmp, sizeof(tmp));
> +		if (r) {
> +			r = -EFAULT;
>  			goto out;
> +		}
>  	}
>  	kvm_vmx->ept_identity_pagetable_done = true;
>  
> @@ -3537,7 +3532,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
>  	if (kvm->arch.apic_access_page_done)
>  		goto out;
>  	r = __x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
> -				    APIC_DEFAULT_PHYS_BASE, PAGE_SIZE);
> +				    APIC_DEFAULT_PHYS_BASE, PAGE_SIZE, NULL);
>  	if (r)
>  		goto out;
>  
> @@ -4478,19 +4473,22 @@ static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
>  static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
>  {
>  	int ret;
> +	unsigned long *uaddr = NULL;
>  
>  	if (enable_unrestricted_guest)
>  		return 0;
>  
>  	mutex_lock(&kvm->slots_lock);
>  	ret = __x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, addr,
> -				      PAGE_SIZE * 3);
> -	mutex_unlock(&kvm->slots_lock);
> -
> +				      PAGE_SIZE * 3, uaddr);
>  	if (ret)
> -		return ret;
> +		goto out;
> +
>  	to_kvm_vmx(kvm)->tss_addr = addr;
> -	return init_rmode_tss(kvm);
> +	ret = init_rmode_tss(kvm, uaddr);
> +out:
> +	mutex_unlock(&kvm->slots_lock);

Unnecessary, see below.

> +	return ret;
>  }
>  
>  static int vmx_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index c4d3972dcd14..ff97782b3919 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9584,7 +9584,15 @@ void kvm_arch_sync_events(struct kvm *kvm)
>  	kvm_free_pit(kvm);
>  }
>  
> -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> +/*
> + * If `uaddr' is specified, `*uaddr' will be returned with the
> + * userspace address that was just allocated.  `uaddr' is only
> + * meaningful if the function returns zero, and `uaddr' will only be
> + * valid when with either the slots_lock or with the SRCU read lock
> + * held.  After we release the lock, the returned `uaddr' will be invalid.

This is all incorrect.  Neither of those locks has any bearing on the
validity of the hva.  slots_lock does as the name suggests and prevents
concurrent writes to the memslots.  The SRCU lock ensures the implicit
memslots lookup in kvm_clear_guest_page() won't result in a use-after-free
due to derefencing old memslots.

Neither of those has anything to do with the userspace address, they're
both fully tied to KVM's gfn->hva lookup.  As Paolo pointed out, KVM's
mapping is instead tied to the lifecycle of the VM.  Note, even *that* has
no bearing on the validity of the mapping or address as KVM only increments
mm_count, not mm_users, i.e. guarantees the mm struct itself won't be freed
but doesn't ensure the vmas or associated pages tables are valid.

Which is the entire point of using __copy_{to,from}_user(), as they
gracefully handle the scenario where the process has not valid mapping
and/or translation for the address.

> + */
> +int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size,
> +			    unsigned long *uaddr)
>  {
>  	int i, r;
>  	unsigned long hva;

Note, hva is a straight "unsigned long".

> @@ -9608,6 +9616,8 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
>  			      MAP_SHARED | MAP_ANONYMOUS, 0);
>  		if (IS_ERR((void *)hva))
>  			return PTR_ERR((void *)hva);
> +		if (uaddr)
> +			*uaddr = hva;
>  	} else {
>  		if (!slot->npages)
>  			return 0;

@uaddr should be to zero here.  Actually returning the address as a void *
will force this case to be handled correctly.

> @@ -9651,10 +9661,10 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  		 */
>  		mutex_lock(&kvm->slots_lock);
>  		__x86_set_memory_region(kvm, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT,
> -					0, 0);
> +					0, 0, NULL);
>  		__x86_set_memory_region(kvm, IDENTITY_PAGETABLE_PRIVATE_MEMSLOT,
> -					0, 0);
> -		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0);
> +					0, 0, NULL);
> +		__x86_set_memory_region(kvm, TSS_PRIVATE_MEMSLOT, 0, 0, NULL);
>  		mutex_unlock(&kvm->slots_lock);
>  	}
>  	if (kvm_x86_ops->vm_destroy)
> -- 
> 2.24.1
> 
