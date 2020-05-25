Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2328C1E1149
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 17:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404040AbgEYPIu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 11:08:50 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52969 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2403981AbgEYPIu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 11:08:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590419328;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CTLLh1uZ3rB9t96YvZiIHbsPN4kI/Teg0A2XT4qFGnM=;
        b=S8W+1G/QGDuCSYT1mhQi8wfaUxcyYiphY8N4bc20wCZcAYDVqPmMwPhWTPIPPcYqbsJAsg
        aGQAIA+s+s9ODLuN1/WCjjbl1Rb5BdufPnBJR0+oijrwRgDTRUfy1H8wX1YhFEy2l+BUcM
        +jexvYDb0eAOt3ZTG+P0kUdJrT53Glw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-h3Mb5XgDNiCgLgwkm1ET9w-1; Mon, 25 May 2020 11:08:47 -0400
X-MC-Unique: h3Mb5XgDNiCgLgwkm1ET9w-1
Received: by mail-ed1-f70.google.com with SMTP id o7so7561110edq.7
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=CTLLh1uZ3rB9t96YvZiIHbsPN4kI/Teg0A2XT4qFGnM=;
        b=NxMmCRHWdAcgYDgKb/t69Re/vps2m12jpqR5WBjPOKjs8GqSWdtX5Yo2cgUWDvRVQZ
         4a4XCe5HFa29g7R/V72PxM1QasABKV5KCpnYCqgLrsyx5RZrwsFPukSUYT7cBOGxJy3m
         jJv7cIe89ml447z2xsIrDaw04T5e9FpbYCfAwBYkcQBfKJaBQG8apBZ+aZuPXUxLig5W
         MELrOOnDsC9k9wnc4K78Z/5zIDq7PtFg88TeY3oB+v7UBUbD/eJk+lZpuaqdaSuYcIuE
         TooxXRV+db5fwrKJWnez9+Zwa5JF4wj0gQYFa74BqmFEY8YYvWc+9CFekQO0N3nxp28y
         pXVw==
X-Gm-Message-State: AOAM530MDjK1h8w/ygoJpahiF7pbfUf4j7coThNV0mfivrrpI6XEEloR
        egSYszl/Bog7Wxc2ho295zxBUJDleJUuGZ3DUDFRwB5frCns1LWSj+MjGrsq/jaJyPLRDXBb0Yf
        1Odn6/OT97JLx
X-Received: by 2002:a17:906:4886:: with SMTP id v6mr19876279ejq.11.1590419325765;
        Mon, 25 May 2020 08:08:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbBRZUjU1pInBhDziWR5Z6PRnOtkNXxRDhC3eFBRiqcIivF7wux8NTv/3xiI19Ir6SJyNR9w==
X-Received: by 2002:a17:906:4886:: with SMTP id v6mr19876229ejq.11.1590419325389;
        Mon, 25 May 2020 08:08:45 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o59sm11682875edb.51.2020.05.25.08.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:08:44 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe\, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen\, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [RFC 06/16] KVM: Use GUP instead of copy_from/to_user() to access guest memory
In-Reply-To: <20200522125214.31348-7-kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com> <20200522125214.31348-7-kirill.shutemov@linux.intel.com>
Date:   Mon, 25 May 2020 17:08:43 +0200
Message-ID: <87a71w832c.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

"Kirill A. Shutemov" <kirill@shutemov.name> writes:

> New helpers copy_from_guest()/copy_to_guest() to be used if KVM memory
> protection feature is enabled.
>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  include/linux/kvm_host.h |  4 +++
>  virt/kvm/kvm_main.c      | 78 ++++++++++++++++++++++++++++++++++------
>  2 files changed, 72 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 131cc1527d68..bd0bb600f610 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -503,6 +503,7 @@ struct kvm {
>  	struct srcu_struct srcu;
>  	struct srcu_struct irq_srcu;
>  	pid_t userspace_pid;
> +	bool mem_protected;
>  };
>  
>  #define kvm_err(fmt, ...) \
> @@ -727,6 +728,9 @@ void kvm_set_pfn_dirty(kvm_pfn_t pfn);
>  void kvm_set_pfn_accessed(kvm_pfn_t pfn);
>  void kvm_get_pfn(kvm_pfn_t pfn);
>  
> +int copy_from_guest(void *data, unsigned long hva, int len);
> +int copy_to_guest(unsigned long hva, const void *data, int len);
> +
>  void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
>  int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>  			int len);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 731c1e517716..033471f71dae 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2248,8 +2248,48 @@ static int next_segment(unsigned long len, int offset)
>  		return len;
>  }
>  
> +int copy_from_guest(void *data, unsigned long hva, int len)
> +{
> +	int offset = offset_in_page(hva);
> +	struct page *page;
> +	int npages, seg;
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
> +	}
> +
> +	return 0;
> +}
> +
> +int copy_to_guest(unsigned long hva, const void *data, int len)
> +{
> +	int offset = offset_in_page(hva);
> +	struct page *page;
> +	int npages, seg;
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
> +	}
> +	return 0;
> +}
> +
>  static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> -				 void *data, int offset, int len)
> +				 void *data, int offset, int len,
> +				 bool protected)
>  {
>  	int r;
>  	unsigned long addr;
> @@ -2257,7 +2297,10 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
>  	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
>  	if (kvm_is_error_hva(addr))
>  		return -EFAULT;
> -	r = __copy_from_user(data, (void __user *)addr + offset, len);
> +	if (protected)
> +		r = copy_from_guest(data, addr + offset, len);
> +	else
> +		r = __copy_from_user(data, (void __user *)addr + offset, len);
>  	if (r)
>  		return -EFAULT;
>  	return 0;
> @@ -2268,7 +2311,8 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
>  {
>  	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>  
> -	return __kvm_read_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_read_guest_page(slot, gfn, data, offset, len,
> +				     kvm->mem_protected);
>  }
>  EXPORT_SYMBOL_GPL(kvm_read_guest_page);
>  
> @@ -2277,7 +2321,8 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
>  {
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  
> -	return __kvm_read_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_read_guest_page(slot, gfn, data, offset, len,
> +				     vcpu->kvm->mem_protected);

Personally, I would've just added 'struct kvm' pointer to 'struct
kvm_memory_slot' to be able to extract 'mem_protected' info when
needed. This will make the patch much smaller.

>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
>  
> @@ -2350,7 +2395,8 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
>  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
>  
>  static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
> -			          const void *data, int offset, int len)
> +			          const void *data, int offset, int len,
> +				  bool protected)
>  {
>  	int r;
>  	unsigned long addr;
> @@ -2358,7 +2404,11 @@ static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
>  	addr = gfn_to_hva_memslot(memslot, gfn);
>  	if (kvm_is_error_hva(addr))
>  		return -EFAULT;
> -	r = __copy_to_user((void __user *)addr + offset, data, len);
> +
> +	if (protected)
> +		r = copy_to_guest(addr + offset, data, len);
> +	else
> +		r = __copy_to_user((void __user *)addr + offset, data, len);

All users of copy_to_guest() will have to have the same 'if (protected)'
check, right? Why not move the check to copy_to/from_guest() then?

>  	if (r)
>  		return -EFAULT;
>  	mark_page_dirty_in_slot(memslot, gfn);
> @@ -2370,7 +2420,8 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
>  {
>  	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
>  
> -	return __kvm_write_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_write_guest_page(slot, gfn, data, offset, len,
> +				      kvm->mem_protected);
>  }
>  EXPORT_SYMBOL_GPL(kvm_write_guest_page);
>  
> @@ -2379,7 +2430,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
>  {
>  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
>  
> -	return __kvm_write_guest_page(slot, gfn, data, offset, len);
> +	return __kvm_write_guest_page(slot, gfn, data, offset, len,
> +				      vcpu->kvm->mem_protected);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
>  
> @@ -2495,7 +2547,10 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  	if (unlikely(!ghc->memslot))
>  		return kvm_write_guest(kvm, gpa, data, len);
>  
> -	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
> +	if (kvm->mem_protected)
> +		r = copy_to_guest(ghc->hva + offset, data, len);
> +	else
> +		r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
>  	if (r)
>  		return -EFAULT;
>  	mark_page_dirty_in_slot(ghc->memslot, gpa >> PAGE_SHIFT);
> @@ -2530,7 +2585,10 @@ int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
>  	if (unlikely(!ghc->memslot))
>  		return kvm_read_guest(kvm, ghc->gpa, data, len);
>  
> -	r = __copy_from_user(data, (void __user *)ghc->hva, len);
> +	if (kvm->mem_protected)
> +		r = copy_from_guest(data, ghc->hva, len);
> +	else
> +		r = __copy_from_user(data, (void __user *)ghc->hva, len);
>  	if (r)
>  		return -EFAULT;

-- 
Vitaly

