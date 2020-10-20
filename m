Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538AE2936C7
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 10:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388794AbgJTI0F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 04:26:05 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15222 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727721AbgJTI0E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 04:26:04 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f8e9f0f0001>; Tue, 20 Oct 2020 01:25:51 -0700
Received: from [10.2.55.194] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 20 Oct
 2020 08:26:00 +0000
Subject: Re: [RFCv2 08/16] KVM: Use GUP instead of copy_from/to_user() to
 access guest memory
To:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
CC:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        "Mike Rapoport" <rppt@kernel.org>, <x86@kernel.org>,
        <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-9-kirill.shutemov@linux.intel.com>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <c8b0405f-14ed-a1bb-3a91-586a30bdf39b@nvidia.com>
Date:   Tue, 20 Oct 2020 01:25:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201020061859.18385-9-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603182351; bh=5/RIiwrg/kwRCxpNdVtWHZqmoZuaCJ2eMO81U5k4uNg=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=jA7YNc6K59qJ2qJl63qxH6XOqxVibVg3wXzlN9B3DF5MnIzprOJOZS5QinsYhBsaq
         lC3ZMKDCtIszMB8/e2kZ3NtpGuVT1Ju86yCfJF/zrpLk4noeN7DescjqLuTfuybAoy
         TMLFD/CsAesk39hnMO4yLBFs63QywTfz+hJvzSkp11YSBk0XNfbrYVIhWGEp0//Zl2
         f3TWSjFXxCnb4WcZCZJlW8SCuMfpoEZq4wk4f2yo/kF3YO3izugrNhJRyl60SAyoTd
         kVeKR03Y9bMq6wLwEcRoh37yFOmzc7D8L/Y+OXrvaG6qzQ0691M+ornUnxjc+fNOTN
         NZn5rmSsiUtnA==
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/19/20 11:18 PM, Kirill A. Shutemov wrote:
> New helpers copy_from_guest()/copy_to_guest() to be used if KVM memory
> protection feature is enabled.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>   include/linux/kvm_host.h |  4 ++
>   virt/kvm/kvm_main.c      | 90 +++++++++++++++++++++++++++++++---------
>   2 files changed, 75 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 05e3c2fb3ef7..380a64613880 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -504,6 +504,7 @@ struct kvm {
>   	struct srcu_struct irq_srcu;
>   	pid_t userspace_pid;
>   	unsigned int max_halt_poll_ns;
> +	bool mem_protected;
>   };
>   
>   #define kvm_err(fmt, ...) \
> @@ -728,6 +729,9 @@ void kvm_set_pfn_dirty(kvm_pfn_t pfn);
>   void kvm_set_pfn_accessed(kvm_pfn_t pfn);
>   void kvm_get_pfn(kvm_pfn_t pfn);
>   
> +int copy_from_guest(void *data, unsigned long hva, int len, bool protected);
> +int copy_to_guest(unsigned long hva, const void *data, int len, bool protected);
> +
>   void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
>   int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>   			int len);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cf88233b819a..a9884cb8c867 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2313,19 +2313,70 @@ static int next_segment(unsigned long len, int offset)
>   		return len;
>   }
>   
> +int copy_from_guest(void *data, unsigned long hva, int len, bool protected)
> +{
> +	int offset = offset_in_page(hva);
> +	struct page *page;
> +	int npages, seg;
> +
> +	if (!protected)
> +		return __copy_from_user(data, (void __user *)hva, len);
> +
> +	might_fault();
> +	kasan_check_write(data, len);
> +	check_object_size(data, len, false);
> +
> +	while ((seg = next_segment(len, offset)) != 0) {
> +		npages = get_user_pages_unlocked(hva, 1, &page, 0);
> +		if (npages != 1)
> +			return -EFAULT;
> +		memcpy(data, page_address(page) + offset, seg);

Hi Kirill!

OK, so the copy_from_guest() is a read-only case for gup, which I think is safe
from a gup/pup + filesystem point of view, but see below about copy_to_guest()...

> +		put_page(page);
> +		len -= seg;
> +		hva += seg;
> +		offset = 0;
> +	}
> +
> +	return 0;
> +}
> +
> +int copy_to_guest(unsigned long hva, const void *data, int len, bool protected)
> +{
> +	int offset = offset_in_page(hva);
> +	struct page *page;
> +	int npages, seg;
> +
> +	if (!protected)
> +		return __copy_to_user((void __user *)hva, data, len);
> +
> +	might_fault();
> +	kasan_check_read(data, len);
> +	check_object_size(data, len, true);
> +
> +	while ((seg = next_segment(len, offset)) != 0) {
> +		npages = get_user_pages_unlocked(hva, 1, &page, FOLL_WRITE);


Should copy_to_guest() use pin_user_pages_unlocked() instead of gup_unlocked?
We wrote a  "Case 5" in Documentation/core-api/pin_user_pages.rst, just for this
situation, I think:


CASE 5: Pinning in order to write to the data within the page
-------------------------------------------------------------
Even though neither DMA nor Direct IO is involved, just a simple case of "pin,
write to a page's data, unpin" can cause a problem. Case 5 may be considered a
superset of Case 1, plus Case 2, plus anything that invokes that pattern. In
other words, if the code is neither Case 1 nor Case 2, it may still require
FOLL_PIN, for patterns like this:

Correct (uses FOLL_PIN calls):
     pin_user_pages()
     write to the data within the pages
     unpin_user_pages()


thanks,
-- 
John Hubbard
NVIDIA

> +		if (npages != 1)
> +			return -EFAULT;
> +		memcpy(page_address(page) + offset, data, seg);
> +		put_page(page);
> +		len -= seg;
> +		hva += seg;
> +		offset = 0;
> +	}
> +
> +	return 0;
> +}
> +
>   static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> -				 void *data, int offset, int len)
> +				 void *data, int offset, int len,
> +				 bool protected)
>   {
> -	int r;
>   	unsigned long addr;
>   
>   	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
>   	if (kvm_is_error_hva(addr))
>   		return -EFAULT;
> -	r = __copy_from_user(data, (void __user *)addr + offset, len);
> -	if (r)
> -		return -EFAULT;
> -	return 0;
> +	return copy_from_guest(data, addr + offset, len, protected);
>   }
>   
>   int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
> @@ -2333,7 +2384,8 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>   {
>   	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>   
> -	return __kvm_read_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_read_guest_page(slot, gfn, data, offset, len,
> +				     kvm->mem_protected);
>   }
>   EXPORT_SYMBOL_GPL(kvm_read_guest_page);
>   
> @@ -2342,7 +2394,8 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
>   {
>   	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>   
> -	return __kvm_read_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_read_guest_page(slot, gfn, data, offset, len,
> +				     vcpu->kvm->mem_protected);
>   }
>   EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
>   
> @@ -2415,7 +2468,8 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
>   EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
>   
>   static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
> -			          const void *data, int offset, int len)
> +			          const void *data, int offset, int len,
> +				  bool protected)
>   {
>   	int r;
>   	unsigned long addr;
> @@ -2423,7 +2477,8 @@ static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
>   	addr = gfn_to_hva_memslot(memslot, gfn);
>   	if (kvm_is_error_hva(addr))
>   		return -EFAULT;
> -	r = __copy_to_user((void __user *)addr + offset, data, len);
> +
> +	r = copy_to_guest(addr + offset, data, len, protected);
>   	if (r)
>   		return -EFAULT;
>   	mark_page_dirty_in_slot(memslot, gfn);
> @@ -2435,7 +2490,8 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
>   {
>   	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>   
> -	return __kvm_write_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_write_guest_page(slot, gfn, data, offset, len,
> +				      kvm->mem_protected);
>   }
>   EXPORT_SYMBOL_GPL(kvm_write_guest_page);
>   
> @@ -2444,7 +2500,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>   {
>   	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>   
> -	return __kvm_write_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_write_guest_page(slot, gfn, data, offset, len,
> +				      vcpu->kvm->mem_protected);
>   }
>   EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
>   
> @@ -2560,7 +2617,7 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>   	if (unlikely(!ghc->memslot))
>   		return kvm_write_guest(kvm, gpa, data, len);
>   
> -	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
> +	r = copy_to_guest(ghc->hva + offset, data, len, kvm->mem_protected);
>   	if (r)
>   		return -EFAULT;
>   	mark_page_dirty_in_slot(ghc->memslot, gpa >> PAGE_SHIFT);
> @@ -2581,7 +2638,6 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>   				 unsigned long len)
>   {
>   	struct kvm_memslots *slots = kvm_memslots(kvm);
> -	int r;
>   	gpa_t gpa = ghc->gpa + offset;
>   
>   	BUG_ON(len + offset > ghc->len);
> @@ -2597,11 +2653,7 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>   	if (unlikely(!ghc->memslot))
>   		return kvm_read_guest(kvm, gpa, data, len);
>   
> -	r = __copy_from_user(data, (void __user *)ghc->hva + offset, len);
> -	if (r)
> -		return -EFAULT;
> -
> -	return 0;
> +	return copy_from_guest(data, ghc->hva + offset, len, kvm->mem_protected);
>   }
>   EXPORT_SYMBOL_GPL(kvm_read_guest_offset_cached);
>   
> 

