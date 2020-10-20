Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA89294175
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 19:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395415AbgJTR3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 13:29:46 -0400
Received: from mga07.intel.com ([134.134.136.100]:41785 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395372AbgJTR3q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Oct 2020 13:29:46 -0400
IronPort-SDR: uc0mmsROVs05X7I3NqbYfXOl+3Mym/ZhP60Z3YiozDN2Y21ITNLwTUtdKAhPd8xhWGkBeumDEj
 m1s1pjOkr7qA==
X-IronPort-AV: E=McAfee;i="6000,8403,9780"; a="231444215"
X-IronPort-AV: E=Sophos;i="5.77,398,1596524400"; 
   d="scan'208";a="231444215"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 10:29:44 -0700
IronPort-SDR: SqScpvwPfGLx6n+SNpJqcFwJ5diV55xjIwuTyl5Nj4lHyQ6jjy/9E+bKyXG/2D4j+S5hy1npEo
 SpapDIzAUVXw==
X-IronPort-AV: E=Sophos;i="5.77,398,1596524400"; 
   d="scan'208";a="533155421"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2020 10:29:44 -0700
Date:   Tue, 20 Oct 2020 10:29:44 -0700
From:   Ira Weiny <ira.weiny@intel.com>
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
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv2 08/16] KVM: Use GUP instead of copy_from/to_user() to
 access guest memory
Message-ID: <20201020172944.GA165907@iweiny-DESK2.sc.intel.com>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-9-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020061859.18385-9-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 20, 2020 at 09:18:51AM +0300, Kirill A. Shutemov wrote:
> New helpers copy_from_guest()/copy_to_guest() to be used if KVM memory
> protection feature is enabled.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  include/linux/kvm_host.h |  4 ++
>  virt/kvm/kvm_main.c      | 90 +++++++++++++++++++++++++++++++---------
>  2 files changed, 75 insertions(+), 19 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 05e3c2fb3ef7..380a64613880 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -504,6 +504,7 @@ struct kvm {
>  	struct srcu_struct irq_srcu;
>  	pid_t userspace_pid;
>  	unsigned int max_halt_poll_ns;
> +	bool mem_protected;
>  };
>  
>  #define kvm_err(fmt, ...) \
> @@ -728,6 +729,9 @@ void kvm_set_pfn_dirty(kvm_pfn_t pfn);
>  void kvm_set_pfn_accessed(kvm_pfn_t pfn);
>  void kvm_get_pfn(kvm_pfn_t pfn);
>  
> +int copy_from_guest(void *data, unsigned long hva, int len, bool protected);
> +int copy_to_guest(unsigned long hva, const void *data, int len, bool protected);
> +
>  void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
>  int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>  			int len);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cf88233b819a..a9884cb8c867 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2313,19 +2313,70 @@ static int next_segment(unsigned long len, int offset)
>  		return len;
>  }
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
> +		put_page(page);
> +		len -= seg;
> +		hva += seg;
> +		offset = 0;

Why is data not updated on each iteration?

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
> +		if (npages != 1)
> +			return -EFAULT;
> +		memcpy(page_address(page) + offset, data, seg);
> +		put_page(page);
> +		len -= seg;
> +		hva += seg;
> +		offset = 0;

Same question?  Doesn't this result in *data being copied to multiple pages?

Ira

> +	}
> +
> +	return 0;
> +}
> +
>  static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> -				 void *data, int offset, int len)
> +				 void *data, int offset, int len,
> +				 bool protected)
>  {
> -	int r;
>  	unsigned long addr;
>  
>  	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
>  	if (kvm_is_error_hva(addr))
>  		return -EFAULT;
> -	r = __copy_from_user(data, (void __user *)addr + offset, len);
> -	if (r)
> -		return -EFAULT;
> -	return 0;
> +	return copy_from_guest(data, addr + offset, len, protected);
>  }
>  
>  int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
> @@ -2333,7 +2384,8 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>  {
>  	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>  
> -	return __kvm_read_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_read_guest_page(slot, gfn, data, offset, len,
> +				     kvm->mem_protected);
>  }
>  EXPORT_SYMBOL_GPL(kvm_read_guest_page);
>  
> @@ -2342,7 +2394,8 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
>  {
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  
> -	return __kvm_read_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_read_guest_page(slot, gfn, data, offset, len,
> +				     vcpu->kvm->mem_protected);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
>  
> @@ -2415,7 +2468,8 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
>  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
>  
>  static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
> -			          const void *data, int offset, int len)
> +			          const void *data, int offset, int len,
> +				  bool protected)
>  {
>  	int r;
>  	unsigned long addr;
> @@ -2423,7 +2477,8 @@ static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
>  	addr = gfn_to_hva_memslot(memslot, gfn);
>  	if (kvm_is_error_hva(addr))
>  		return -EFAULT;
> -	r = __copy_to_user((void __user *)addr + offset, data, len);
> +
> +	r = copy_to_guest(addr + offset, data, len, protected);
>  	if (r)
>  		return -EFAULT;
>  	mark_page_dirty_in_slot(memslot, gfn);
> @@ -2435,7 +2490,8 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
>  {
>  	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>  
> -	return __kvm_write_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_write_guest_page(slot, gfn, data, offset, len,
> +				      kvm->mem_protected);
>  }
>  EXPORT_SYMBOL_GPL(kvm_write_guest_page);
>  
> @@ -2444,7 +2500,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  {
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  
> -	return __kvm_write_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_write_guest_page(slot, gfn, data, offset, len,
> +				      vcpu->kvm->mem_protected);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
>  
> @@ -2560,7 +2617,7 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  	if (unlikely(!ghc->memslot))
>  		return kvm_write_guest(kvm, gpa, data, len);
>  
> -	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
> +	r = copy_to_guest(ghc->hva + offset, data, len, kvm->mem_protected);
>  	if (r)
>  		return -EFAULT;
>  	mark_page_dirty_in_slot(ghc->memslot, gpa >> PAGE_SHIFT);
> @@ -2581,7 +2638,6 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  				 unsigned long len)
>  {
>  	struct kvm_memslots *slots = kvm_memslots(kvm);
> -	int r;
>  	gpa_t gpa = ghc->gpa + offset;
>  
>  	BUG_ON(len + offset > ghc->len);
> @@ -2597,11 +2653,7 @@ int kvm_read_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  	if (unlikely(!ghc->memslot))
>  		return kvm_read_guest(kvm, gpa, data, len);
>  
> -	r = __copy_from_user(data, (void __user *)ghc->hva + offset, len);
> -	if (r)
> -		return -EFAULT;
> -
> -	return 0;
> +	return copy_from_guest(data, ghc->hva + offset, len, kvm->mem_protected);
>  }
>  EXPORT_SYMBOL_GPL(kvm_read_guest_offset_cached);
>  
> -- 
> 2.26.2
> 
> 
