Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18F7F1B6594
	for <lists+kvm@lfdr.de>; Thu, 23 Apr 2020 22:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgDWUjp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Apr 2020 16:39:45 -0400
Received: from mga05.intel.com ([192.55.52.43]:49524 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbgDWUjp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Apr 2020 16:39:45 -0400
IronPort-SDR: 2IQp2gPFueeTo17yy5Scm5COEeKY9WhjQyNTYngkw4Re5Oe4v0zhSMk/hXQusQDeUyaCCTXiHD
 OC/thd7/G4EA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2020 13:39:44 -0700
IronPort-SDR: PAytE2gd3PBGaQ1vc8eGBqEXx4D7ZP6om29YOEArslB7dEk2ZEyvxu6H5jlS9TrOay2cxKyWBa
 mzhGhdIVBhdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,309,1583222400"; 
   d="scan'208";a="292396043"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by orsmga008.jf.intel.com with ESMTP; 23 Apr 2020 13:39:44 -0700
Date:   Thu, 23 Apr 2020 13:39:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH v8 03/14] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20200423203944.GS17824@linux.intel.com>
References: <20200331190000.659614-1-peterx@redhat.com>
 <20200331190000.659614-4-peterx@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331190000.659614-4-peterx@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 31, 2020 at 02:59:49PM -0400, Peter Xu wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1b6d9ac9533c..faa702c4d37b 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9791,7 +9791,32 @@ void kvm_arch_sync_events(struct kvm *kvm)
>  	kvm_free_pit(kvm);
>  }
>  
> -int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
> +#define  ERR_PTR_USR(e)  ((void __user *)ERR_PTR(e))

Heh, my first thought when reading the below code was "cool, I didn't know
there was ERR_PTR_USR!".  This probably should be in include/linux/err.h,
or maybe a new arch specific implementation if it's not universally safe.

An alternative, which looks enticing given that proper user variants will
be a bit of an explosion, would be to do:

  static void *____x86_set_memory_region(...)
  {
	<actual function>
  }

  void __user *__x86_set_memory_region(...)
  {
	return (void __user *)____x86_set_memory_region(...);
  }

A second alternative would be to return an "unsigned long", i.e. force the
one function that actually accesses the hva to do the cast.  I think I like
this option the best as it would minimize the churn in
__x86_set_memory_region().  Callers can use IS_ERR_VALUE() to detect failure.

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

I think it's important to call out that it returns '0' on uninstall, e.g.
otherwise it's not clear how a caller can detect failure.

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
> @@ -9800,12 +9825,12 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
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
> @@ -9814,10 +9839,10 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
>  		hva = vm_mmap(NULL, 0, size, PROT_READ | PROT_WRITE,
>  			      MAP_SHARED | MAP_ANONYMOUS, 0);
>  		if (IS_ERR((void *)hva))

IS_ERR_VALUE() can be used to avoid the double cast.

> -			return PTR_ERR((void *)hva);
> +			return (void __user *)hva;

If we still want to go down the route of ERR_PTR_USR, then an ERR_CAST_USR
seems in order.

>  	} else {
>  		if (!slot || !slot->npages)
> -			return 0;
> +			return ERR_PTR_USR(0);

"return ERR_PTR_USR(NULL)" or "return NULL" would be more intuitive.  Moot
point if the return is changed to "unsigned long".

>  
>  		/*
>  		 * Stuff a non-canonical value to catch use-after-delete.  This
> @@ -9838,13 +9863,13 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
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
> 2.24.1
> 
