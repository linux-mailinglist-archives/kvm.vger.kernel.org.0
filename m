Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52BE01E1B18
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 08:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgEZGQC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 02:16:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:60640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726775AbgEZGQC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 02:16:02 -0400
Received: from kernel.org (unknown [87.70.212.59])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5545C207CB;
        Tue, 26 May 2020 06:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590473761;
        bh=OxSFsKg1PycFHLkeCq0fALukk6xQ/Qv8MqdKEfRKfi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kjXWSk+yDAClp/K1lADNvHh0cBh0iJQ49Oq8CqmlRNsbbevhKuqwgLoJPfXLHwUuU
         VAuZWwmgY8mKawGezWHkpFgAcMyP0QXZ+1ffbhqAigOXinrM9aKxaAL5GSkEDdMEy9
         fRmF7ahduAJGkjY7Bf6bAjCi6VcdaxX2doQzDisQ=
Date:   Tue, 26 May 2020 09:15:52 +0300
From:   Mike Rapoport <rppt@kernel.org>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFC 07/16] KVM: mm: Introduce VM_KVM_PROTECTED
Message-ID: <20200526061552.GD13247@kernel.org>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-8-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200522125214.31348-8-kirill.shutemov@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 22, 2020 at 03:52:05PM +0300, Kirill A. Shutemov wrote:
> The new VMA flag that indicate a VMA that is not accessible to userspace
> but usable by kernel with GUP if FOLL_KVM is specified.
> 
> The FOLL_KVM is only used in the KVM code. The code has to know how to
> deal with such pages.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  include/linux/mm.h  |  8 ++++++++
>  mm/gup.c            | 20 ++++++++++++++++----
>  mm/huge_memory.c    | 20 ++++++++++++++++----
>  mm/memory.c         |  3 +++
>  mm/mmap.c           |  3 +++
>  virt/kvm/async_pf.c |  4 ++--
>  virt/kvm/kvm_main.c |  9 +++++----
>  7 files changed, 53 insertions(+), 14 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e1882eec1752..4f7195365cc0 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -329,6 +329,8 @@ extern unsigned int kobjsize(const void *objp);
>  # define VM_MAPPED_COPY	VM_ARCH_1	/* T if mapped copy of data (nommu mmap) */
>  #endif
>  
> +#define VM_KVM_PROTECTED 0

With all the ideas about removing pages from the direct mapi floating
around I wouldn't limit this to KVM.

VM_NOT_IN_DIRECT_MAP would describe such areas better, but I realise
it's very far from perfect and nothing better does not comes to mind :)


>  #ifndef VM_GROWSUP
>  # define VM_GROWSUP	VM_NONE
>  #endif
> @@ -646,6 +648,11 @@ static inline bool vma_is_accessible(struct vm_area_struct *vma)
>  	return vma->vm_flags & VM_ACCESS_FLAGS;
>  }
>  
> +static inline bool vma_is_kvm_protected(struct vm_area_struct *vma)

Ditto

> +{
> +	return vma->vm_flags & VM_KVM_PROTECTED;
> +}
> +
>  #ifdef CONFIG_SHMEM
>  /*
>   * The vma_is_shmem is not inline because it is used only by slow
> @@ -2773,6 +2780,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>  #define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below */
>  #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
>  #define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
> +#define FOLL_KVM	0x80000 /* access to VM_KVM_PROTECTED VMAs */

Maybe

FOLL_DM		0x80000  /* access  memory dropped from the direct map */

>  /*
>   * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
> diff --git a/mm/gup.c b/mm/gup.c
> index 87a6a59fe667..bd7b9484b35a 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c

...

> diff --git a/mm/mmap.c b/mm/mmap.c
> index f609e9ec4a25..d56c3f6efc99 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -112,6 +112,9 @@ pgprot_t vm_get_page_prot(unsigned long vm_flags)
>  				(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]) |
>  			pgprot_val(arch_vm_get_page_prot(vm_flags)));
>  
> +	if (vm_flags & VM_KVM_PROTECTED)
> +		ret = PAGE_NONE;

Nit: vma_is_kvm_protected()?

> +
>  	return arch_filter_pgprot(ret);
>  }
>  EXPORT_SYMBOL(vm_get_page_prot);
> diff --git a/virt/kvm/async_pf.c b/virt/kvm/async_pf.c
> index 15e5b037f92d..7663e962510a 100644
> --- a/virt/kvm/async_pf.c
> +++ b/virt/kvm/async_pf.c
> @@ -60,8 +60,8 @@ static void async_pf_execute(struct work_struct *work)
>  	 * access remotely.
>  	 */
>  	down_read(&mm->mmap_sem);
> -	get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE, NULL, NULL,
> -			&locked);
> +	get_user_pages_remote(NULL, mm, addr, 1, FOLL_WRITE | FOLL_KVM, NULL,
> +			      NULL, &locked);
>  	if (locked)
>  		up_read(&mm->mmap_sem);
>  
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 033471f71dae..530af95efdf3 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1727,7 +1727,7 @@ unsigned long kvm_vcpu_gfn_to_hva_prot(struct kvm_vcpu *vcpu, gfn_t gfn, bool *w
>  
>  static inline int check_user_page_hwpoison(unsigned long addr)
>  {
> -	int rc, flags = FOLL_HWPOISON | FOLL_WRITE;
> +	int rc, flags = FOLL_HWPOISON | FOLL_WRITE | FOLL_KVM;
>  
>  	rc = get_user_pages(addr, 1, flags, NULL, NULL);
>  	return rc == -EHWPOISON;
> @@ -1771,7 +1771,7 @@ static bool hva_to_pfn_fast(unsigned long addr, bool write_fault,
>  static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
>  			   bool *writable, kvm_pfn_t *pfn)
>  {
> -	unsigned int flags = FOLL_HWPOISON;
> +	unsigned int flags = FOLL_HWPOISON | FOLL_KVM;
>  	struct page *page;
>  	int npages = 0;
>  
> @@ -2255,7 +2255,7 @@ int copy_from_guest(void *data, unsigned long hva, int len)
>  	int npages, seg;
>  
>  	while ((seg = next_segment(len, offset)) != 0) {
> -		npages = get_user_pages_unlocked(hva, 1, &page, 0);
> +		npages = get_user_pages_unlocked(hva, 1, &page, FOLL_KVM);
>  		if (npages != 1)
>  			return -EFAULT;
>  		memcpy(data, page_address(page) + offset, seg);
> @@ -2275,7 +2275,8 @@ int copy_to_guest(unsigned long hva, const void *data, int len)
>  	int npages, seg;
>  
>  	while ((seg = next_segment(len, offset)) != 0) {
> -		npages = get_user_pages_unlocked(hva, 1, &page, FOLL_WRITE);
> +		npages = get_user_pages_unlocked(hva, 1, &page,
> +						 FOLL_WRITE | FOLL_KVM);
>  		if (npages != 1)
>  			return -EFAULT;
>  		memcpy(page_address(page) + offset, data, seg);
> -- 
> 2.26.2
> 
> 

-- 
Sincerely yours,
Mike.
