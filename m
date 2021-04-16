Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84CE13626CA
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 19:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242401AbhDPRbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 13:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234404AbhDPRbA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Apr 2021 13:31:00 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BB7C061574
        for <kvm@vger.kernel.org>; Fri, 16 Apr 2021 10:30:36 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id j32so4884631pgm.6
        for <kvm@vger.kernel.org>; Fri, 16 Apr 2021 10:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=q5wMI7x8R3NVGtWXjOVwyo6hiimn4/q3w0CIc2jmNSo=;
        b=Z3/jKZUp1MokdrU6UgufTOWM2iZW3g+TEeyk6mG6eAJL8MH3sL2xRRsNxhzcnhJF+v
         hxkdN3/IfpjNT7upq8oMWCmWqKtdiSywMe6CQAedn1ax71Ap71zKE58ovuIOHbq6yyl/
         h1buwHVecsDPzxv/XOxdZZQOknN1dwQ8GElJV1iDtLoKaddtZ8CMe0UAFaItm34sXBH1
         +CoKkizmcXszQ3kcobnJpKIrSqJu8zu25Bf7c94wvcSe81NY2zAVBi46S7jsdJxPZKnp
         Rehzj/EbXo7Ih9UDQjWUkGiK/QQG/NCQ8tqEN7aGwclphMdv0ux9nZ3AX/jw3nwGF8ZI
         QNug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=q5wMI7x8R3NVGtWXjOVwyo6hiimn4/q3w0CIc2jmNSo=;
        b=iRCNk+QBpCmHEydG8YV2nnZqOiysFGmOPMih7p2t+lw8XHDX52xU5MjqC9JwdBUbeQ
         2StnR5zfKqSo2EeNdZ1tUtnfIzuVGVMjg465fbrVsCpr0sWiD/WVpZNkeNxziSgXctj8
         lDaplLdUXn61S22UvBnjzIMtLLx9Lidb7dA+D8gIh178QXr9tcmOyJtabc9Nanlgnme0
         RT6rPSCFXarUFDCjlwNBkksumKorgyeYCda2W/7SPIFiWwfE/BaYd/NNUONm4lFSA3lg
         maNngLRpiyXMH7PPtBGNnKwbOYo8oC3HyaAgdPNSbz0xZHNTCdNImPSh7/nutzJpBtwi
         tmvg==
X-Gm-Message-State: AOAM531BIpOjO8dvXyT3SV4ZVT5ll7dHxd1cbqoBVLrTWWjm0G8Bl/BB
        AutgkqBt9xvwviqMe0oHk9hoEQ==
X-Google-Smtp-Source: ABdhPJw1W57hS0urdalMCM5IzHRZOUpaR8Ra7DL1Debf6bpFzc/MHd7aB7tcCvtEBTvchwXnldSgtA==
X-Received: by 2002:a05:6a00:2301:b029:247:7208:1d6f with SMTP id h1-20020a056a002301b029024772081d6fmr8835755pfh.43.1618594235257;
        Fri, 16 Apr 2021 10:30:35 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 14sm5584986pgz.48.2021.04.16.10.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 10:30:34 -0700 (PDT)
Date:   Fri, 16 Apr 2021 17:30:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 13/13] KVM: unmap guest memory using poisoned pages
Message-ID: <YHnJtvXdrZE+AfM3@google.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
 <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 16, 2021, Kirill A. Shutemov wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1b404e4d7dd8..f8183386abe7 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -8170,6 +8170,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
>  		kvm_sched_yield(vcpu->kvm, a0);
>  		ret = 0;
>  		break;
> +	case KVM_HC_ENABLE_MEM_PROTECTED:
> +		ret = kvm_protect_memory(vcpu->kvm);
> +		break;
> +	case KVM_HC_MEM_SHARE:
> +		ret = kvm_share_memory(vcpu->kvm, a0, a1);

Can you take a look at a proposed hypercall interface for SEV live migration and
holler if you (or anyone else) thinks it will have extensibility issues?

https://lkml.kernel.org/r/93d7f2c2888315adc48905722574d89699edde33.1618498113.git.ashish.kalra@amd.com

> +		break;
>  	default:
>  		ret = -KVM_ENOSYS;
>  		break;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index fadaccb95a4c..cd2374802702 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -436,6 +436,8 @@ static inline int kvm_arch_vcpu_memslots_id(struct kvm_vcpu *vcpu)
>  }
>  #endif
>  
> +#define KVM_NR_SHARED_RANGES 32
> +
>  /*
>   * Note:
>   * memslots are not sorted by id anymore, please use id_to_memslot()
> @@ -513,6 +515,10 @@ struct kvm {
>  	pid_t userspace_pid;
>  	unsigned int max_halt_poll_ns;
>  	u32 dirty_ring_size;
> +	bool mem_protected;
> +	void *id;
> +	int nr_shared_ranges;
> +	struct range shared_ranges[KVM_NR_SHARED_RANGES];

Hard no for me.  IMO, anything that requires KVM to track shared/pinned pages in
a separate tree/array is non-starter.  More specific to TDX #MCs, KVM should not
be the canonical reference for the state of a page.

>  };
>  
>  #define kvm_err(fmt, ...) \

...

> @@ -1868,11 +1874,17 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
>  		flags |= FOLL_WRITE;
>  	if (async)
>  		flags |= FOLL_NOWAIT;
> +	if (kvm->mem_protected)
> +		flags |= FOLL_ALLOW_POISONED;

This is unsafe, only the flows that are mapping the PFN into the guest should
use ALLOW_POISONED, e.g. __kvm_map_gfn() should fail on a poisoned page.

>  
>  	npages = get_user_pages_unlocked(addr, 1, &page, flags);
>  	if (npages != 1)
>  		return npages;
>  
> +	if (IS_ENABLED(CONFIG_HAVE_KVM_PROTECTED_MEMORY) &&
> +	    kvm->mem_protected && !kvm_page_allowed(kvm, page))
> +		return -EHWPOISON;
> +
>  	/* map read fault as writable if possible */
>  	if (unlikely(!write_fault) && writable) {
>  		struct page *wpage;

...

> @@ -2338,19 +2350,93 @@ static int next_segment(unsigned long len, int offset)
>  		return len;
>  }
>  
> -static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> -				 void *data, int offset, int len)
> +int copy_from_guest(struct kvm *kvm, void *data, unsigned long hva, int len)
> +{
> +	int offset = offset_in_page(hva);
> +	struct page *page;
> +	int npages, seg;
> +	void *vaddr;
> +
> +	if (!IS_ENABLED(CONFIG_HAVE_KVM_PROTECTED_MEMORY) ||
> +	    !kvm->mem_protected) {
> +		return __copy_from_user(data, (void __user *)hva, len);
> +	}
> +
> +	might_fault();
> +	kasan_check_write(data, len);
> +	check_object_size(data, len, false);
> +
> +	while ((seg = next_segment(len, offset)) != 0) {
> +		npages = get_user_pages_unlocked(hva, 1, &page,
> +						 FOLL_ALLOW_POISONED);
> +		if (npages != 1)
> +			return -EFAULT;
> +
> +		if (!kvm_page_allowed(kvm, page))
> +			return -EFAULT;
> +
> +		vaddr = kmap_atomic(page);
> +		memcpy(data, vaddr + offset, seg);
> +		kunmap_atomic(vaddr);

Why is KVM allowed to access a poisoned page?  I would expect shared pages to
_not_ be poisoned.  Except for pure software emulation of SEV, KVM can't access
guest private memory.

> +
> +		put_page(page);
> +		len -= seg;
> +		hva += seg;
> +		data += seg;
> +		offset = 0;
> +	}
> +
> +	return 0;
> +}

...
  
> @@ -2693,6 +2775,41 @@ void kvm_vcpu_mark_page_dirty(struct kvm_vcpu *vcpu, gfn_t gfn)
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_mark_page_dirty);
>  
> +int kvm_protect_memory(struct kvm *kvm)
> +{
> +	if (mmap_write_lock_killable(kvm->mm))
> +		return -KVM_EINTR;
> +
> +	kvm->mem_protected = true;
> +	kvm_arch_flush_shadow_all(kvm);
> +	mmap_write_unlock(kvm->mm);
> +
> +	return 0;
> +}
> +
> +int kvm_share_memory(struct kvm *kvm, unsigned long gfn, unsigned long npages)
> +{
> +	unsigned long end = gfn + npages;
> +
> +	if (!npages || !IS_ENABLED(CONFIG_HAVE_KVM_PROTECTED_MEMORY))
> +		return 0;
> +
> +	__kvm_share_memory(kvm, gfn, end);
> +
> +	for (; gfn < end; gfn++) {
> +		struct page *page = gfn_to_page(kvm, gfn);
> +		unsigned long pfn = page_to_pfn(page);
> +
> +		if (page == KVM_ERR_PTR_BAD_PAGE)
> +			continue;
> +
> +		kvm_share_pfn(kvm, pfn);

I like the idea of using "special" PTE value to denote guest private memory,
e.g. in this RFC, HWPOISON.  But I strongly dislike having KVM involved in the
manipulation of the special flag/value.

Today, userspace owns the gfn->hva translations and the kernel effectively owns
the hva->pfn translations (with input from userspace).  KVM just connects the
dots.

Having KVM own the shared/private transitions means KVM is now part owner of the
entire gfn->hva->pfn translation, i.e. KVM is effectively now a secondary MMU
and a co-owner of the primary MMU.  This creates locking madness, e.g. KVM taking
mmap_sem for write, mmu_lock under page lock, etc..., and also takes control away
from userspace.  E.g. userspace strategy could be to use a separate backing/pool
for shared memory and change the gfn->hva translation (memslots) in reaction to
a shared/private conversion.  Automatically swizzling things in KVM takes away
that option.

IMO, KVM should be entirely "passive" in this process, e.g. the guest shares or
protects memory, userspace calls into the kernel to change state, and the kernel
manages the page tables to prevent bad actors.  KVM simply does the plumbing for
the guest page tables.

> +		put_page(page);
> +	}
> +
> +	return 0;
> +}
> +
>  void kvm_sigset_activate(struct kvm_vcpu *vcpu)
>  {
>  	if (!vcpu->sigset_active)
> diff --git a/virt/kvm/mem_protected.c b/virt/kvm/mem_protected.c
> new file mode 100644
> index 000000000000..81882bd3232b
> --- /dev/null
> +++ b/virt/kvm/mem_protected.c
> @@ -0,0 +1,110 @@
> +#include <linux/kvm_host.h>
> +#include <linux/mm.h>
> +#include <linux/rmap.h>
> +
> +static DEFINE_XARRAY(kvm_pfn_map);
> +
> +static bool gfn_is_shared(struct kvm *kvm, unsigned long gfn)
> +{
> +	bool ret = false;
> +	int i;
> +
> +	spin_lock(&kvm->mmu_lock);

Taking mmu_lock for write in the page fault path is a non-starter.  The TDP MMU
is being converted to support concurrent faults, which is a foundational pillar
of its scalability.

> +	for (i = 0; i < kvm->nr_shared_ranges; i++) {
> +		if (gfn < kvm->shared_ranges[i].start)
> +			continue;
> +		if (gfn >= kvm->shared_ranges[i].end)
> +			continue;
> +
> +		ret = true;
> +		break;
> +	}
> +	spin_unlock(&kvm->mmu_lock);
> +
> +	return ret;
> +}

