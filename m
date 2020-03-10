Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2A918012B
	for <lists+kvm@lfdr.de>; Tue, 10 Mar 2020 16:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgCJPGj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 11:06:39 -0400
Received: from mga12.intel.com ([192.55.52.136]:63162 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgCJPGi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 11:06:38 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 08:06:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,537,1574150400"; 
   d="scan'208";a="276984234"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 10 Mar 2020 08:06:38 -0700
Date:   Tue, 10 Mar 2020 08:06:37 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200310150637.GB7600@linux.intel.com>
References: <20200309214424.330363-1-peterx@redhat.com>
 <20200309214424.330363-4-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309214424.330363-4-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 09, 2020 at 05:44:13PM -0400, Peter Xu wrote:
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 40b1e6138cd5..fc638a164e03 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3467,34 +3467,26 @@ static bool guest_state_valid(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> -static int init_rmode_tss(struct kvm *kvm)
> +static int init_rmode_tss(struct kvm *kvm, void __user *ua)
>  {
> -	gfn_t fn;
> +	const void *zero_page = (const void *) __va(page_to_phys(ZERO_PAGE(0)));
>  	u16 data = 0;

"data" doesn't need to be intialized to zero, it's set below before it's used.

>  	int idx, r;

nit: I'd prefer to rename "idx" to "i" to make it more obvious it's a plain
ole loop counter.  Reusing the srcu index made me do a double take :-)

>  
> -	idx = srcu_read_lock(&kvm->srcu);
> -	fn = to_kvm_vmx(kvm)->tss_addr >> PAGE_SHIFT;
> -	r = kvm_clear_guest_page(kvm, fn, 0, PAGE_SIZE);
> -	if (r < 0)
> -		goto out;
> +	for (idx = 0; idx < 3; idx++) {
> +		r = __copy_to_user(ua + PAGE_SIZE * idx, zero_page, PAGE_SIZE);
> +		if (r)
> +			return -EFAULT;
> +	}

Can this be done in a single __copy_to_user(), or do those helpers not like
crossing page boundaries?

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
> +	r = __copy_to_user(ua + TSS_IOPB_BASE_OFFSET, &data, sizeof(u16));
> +	if (r)
> +		return -EFAULT;
> +
>  	data = ~0;
> -	r = kvm_write_guest_page(kvm, fn, &data,
> -				 RMODE_TSS_SIZE - 2 * PAGE_SIZE - 1,
> -				 sizeof(u8));
> -out:
> -	srcu_read_unlock(&kvm->srcu, idx);
> +	r = __copy_to_user(ua + RMODE_TSS_SIZE - 1, &data, sizeof(u8));
> +
>  	return r;
>  }
>  
> @@ -3503,6 +3495,7 @@ static int init_rmode_identity_map(struct kvm *kvm)
>  	struct kvm_vmx *kvm_vmx = to_kvm_vmx(kvm);
>  	int i, r = 0;
>  	kvm_pfn_t identity_map_pfn;
> +	void __user *uaddr;
>  	u32 tmp;
>  
>  	/* Protect kvm_vmx->ept_identity_pagetable_done. */
> @@ -3515,22 +3508,24 @@ static int init_rmode_identity_map(struct kvm *kvm)
>  		kvm_vmx->ept_identity_map_addr = VMX_EPT_IDENTITY_PAGETABLE_ADDR;
>  	identity_map_pfn = kvm_vmx->ept_identity_map_addr >> PAGE_SHIFT;
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
>  			goto out;
> +		}
>  	}
>  	kvm_vmx->ept_identity_pagetable_done = true;
>  
> @@ -3557,19 +3552,22 @@ static void seg_setup(int seg)
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
> @@ -3581,7 +3579,7 @@ static int alloc_apic_access_page(struct kvm *kvm)
>  	kvm->arch.apic_access_page_done = true;
>  out:
>  	mutex_unlock(&kvm->slots_lock);
> -	return r;
> +	return ret;
>  }
>  
>  int allocate_vpid(void)
> @@ -4503,7 +4501,7 @@ static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
>  
>  static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
>  {
> -	int ret;
> +	void __user *ret;
>  
>  	if (enable_unrestricted_guest)
>  		return 0;
> @@ -4513,10 +4511,12 @@ static int vmx_set_tss_addr(struct kvm *kvm, unsigned int addr)
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
> index 5de200663f51..fe485d4ba6c7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9756,7 +9756,33 @@ void kvm_arch_sync_events(struct kvm *kvm)
>  	kvm_free_pit(kvm);
>  }
>  
> -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
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
> + *   - An error number if error happened, or,
> + *   - For installation: the HVA of the newly mapped memory slot, or,
> + *   - For uninstallation: zero if we successfully uninstall a slot.

Maybe tweak this so the return it stands out?  And returning zero on
uninstallation is no longer true in kvm/queue, at least not without further
modifications (as is it'll return 0xdead000000000000 on 64-bit).  The
0xdead shenanigans won't trigger IS_ERR(), so I think this can simply be:

 * Returns:
 *   hva:    on success
 *   -errno: on error

With the blurb below calling out that hva is bogus uninstallation.

> + *
> + * The caller should always use IS_ERR() to check the return value
> + * before use.  NOTE: KVM internal memory slots are guaranteed and
> + * won't change until the VM is destroyed. This is also true to the
> + * returned HVA when installing a new memory slot.  The HVA can be
> + * invalidated by either an errornous userspace program or a VM under
> + * destruction, however as long as we use __copy_{to|from}_user()
> + * properly upon the HVAs and handle the failure paths always then
> + * we're safe.
> + */
> +void __user * __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
> +				      u32 size)
>  {
>  	int i, r;
>  	unsigned long hva;
> @@ -9765,12 +9791,12 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
>  
>  	/* Called with kvm->slots_lock held.  */
>  	if (WARN_ON(id >= KVM_MEM_SLOTS_NUM))
> -		return -EINVAL;
> +		return ERR_PTR(-EINVAL);
>  
>  	slot = id_to_memslot(slots, id);
>  	if (size) {
>  		if (slot->npages)
> -			return -EEXIST;
> +			return ERR_PTR(-EEXIST);
>  
>  		/*
>  		 * MAP_SHARED to prevent internal slot pages from being moved
> @@ -9779,10 +9805,10 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
>  		hva = vm_mmap(NULL, 0, size, PROT_READ | PROT_WRITE,
>  			      MAP_SHARED | MAP_ANONYMOUS, 0);
>  		if (IS_ERR((void *)hva))
> -			return PTR_ERR((void *)hva);
> +			return (void __user *)hva;
>  	} else {
>  		if (!slot->npages)
> -			return 0;
> +			return ERR_PTR(0);
>  
>  		hva = 0;
>  	}
> @@ -9798,13 +9824,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
>  		m.memory_size = size;
>  		r = __kvm_set_memory_region(kvm, &m);
>  		if (r < 0)
> -			return r;
> +			return ERR_PTR(r);
>  	}
>  
>  	if (!size)
>  		vm_munmap(old.userspace_addr, old.npages * PAGE_SIZE);
>  
> -	return 0;
> +	return (void __user *)hva;
>  }
>  EXPORT_SYMBOL_GPL(__x86_set_memory_region);
>  
> -- 
> 2.24.1
> 
