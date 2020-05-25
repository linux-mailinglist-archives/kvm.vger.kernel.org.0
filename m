Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2351E1181
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 17:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404057AbgEYPR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 11:17:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404018AbgEYPR5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 11:17:57 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3720CC061A0E
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:17:57 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id v16so21157443ljc.8
        for <kvm@vger.kernel.org>; Mon, 25 May 2020 08:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KmCwnA7a5dVJlIQoJdDfHmomwFfTjqYUrhRIWlT2Nyk=;
        b=WuGyrHUzog4bt26/4hOGUWDImSEp43kS8zG/1GJTSqmzUyTPyXIuKgZFMo4Sp080SY
         fX35jcmj9TBOukdtUSSzCyyweXoAU+OtgxRlhrX18a6u2IIdlI0HWc0YD/uihmNkARC6
         FFTTZ7e093d3qTTm3OghNQHI7gph1gQ7tvOAVxA5OQVWY0+BuWHpdmk5bkRwE7Qayxz6
         GQGEVgrMr1mFs+J5zx84vFQaUUig81891dMsKvu23wBViUbwF3eCeU9rY3q1ED2q6i/7
         znqGwrvifOcSNfzyygJK1Vecby2bQR340gP0iACEkEq+9faR2GYQ964je3o/conEY8DO
         lcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KmCwnA7a5dVJlIQoJdDfHmomwFfTjqYUrhRIWlT2Nyk=;
        b=FhFNe9T0/M+nn1YqV1QchD98ED/YhiwwBnUqB+GtVczR6nmxAZXWBKYpVwu3Tr8af1
         0c8EbzpaCnsQjmOrX3Vqj3aacnIFrbFoXuD+NrjhzmpiykXG6thPqGHGe951kb654u7J
         23w1qzCU6MVhHIE64LVh98LkIZ5wTmF1dve/OiA1Ngovtn7Y5TV60WP5w8EaMjHoHEtu
         Zx8RO58IYRNPQyxaFEfJgj7yDspH+31y68PE2LI1Z5YpN6+zjRaRvlq4EsPiIaD7Mphv
         qHNXVtdKM1e2xh3VGdn1KCkyNhNgq7p7vcs7ogILO6n8uexRWeJqwEbnfRzX7UhNKbkP
         z1gg==
X-Gm-Message-State: AOAM533g0V3Gdpo9AfdtEugvOOsXbKDaQpVB7nLJFq0fcDkqi9XFL0y9
        yGwneTACzgd2AbUgdsL4hci/7A==
X-Google-Smtp-Source: ABdhPJz4Z11nGMXKBdzLwDq5RYdn3XVkZC6lsZEQkZwhYr4AviDn5phADtHDSbzOkyRQItFlkiSDBQ==
X-Received: by 2002:a2e:8e91:: with SMTP id z17mr11191455ljk.144.1590419875635;
        Mon, 25 May 2020 08:17:55 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id k27sm4373301lfe.88.2020.05.25.08.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 08:17:55 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 0498010230F; Mon, 25 May 2020 18:17:56 +0300 (+03)
Date:   Mon, 25 May 2020 18:17:55 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
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
Subject: Re: [RFC 06/16] KVM: Use GUP instead of copy_from/to_user() to
 access guest memory
Message-ID: <20200525151755.yzbmemtrii455s6k@box>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-7-kirill.shutemov@linux.intel.com>
 <87a71w832c.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a71w832c.fsf@vitty.brq.redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 25, 2020 at 05:08:43PM +0200, Vitaly Kuznetsov wrote:
> "Kirill A. Shutemov" <kirill@shutemov.name> writes:
> 
> > New helpers copy_from_guest()/copy_to_guest() to be used if KVM memory
> > protection feature is enabled.
> >
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  include/linux/kvm_host.h |  4 +++
> >  virt/kvm/kvm_main.c      | 78 ++++++++++++++++++++++++++++++++++------
> >  2 files changed, 72 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 131cc1527d68..bd0bb600f610 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -503,6 +503,7 @@ struct kvm {
> >  	struct srcu_struct srcu;
> >  	struct srcu_struct irq_srcu;
> >  	pid_t userspace_pid;
> > +	bool mem_protected;
> >  };
> >  
> >  #define kvm_err(fmt, ...) \
> > @@ -727,6 +728,9 @@ void kvm_set_pfn_dirty(kvm_pfn_t pfn);
> >  void kvm_set_pfn_accessed(kvm_pfn_t pfn);
> >  void kvm_get_pfn(kvm_pfn_t pfn);
> >  
> > +int copy_from_guest(void *data, unsigned long hva, int len);
> > +int copy_to_guest(unsigned long hva, const void *data, int len);
> > +
> >  void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
> >  int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
> >  			int len);
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 731c1e517716..033471f71dae 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2248,8 +2248,48 @@ static int next_segment(unsigned long len, int offset)
> >  		return len;
> >  }
> >  
> > +int copy_from_guest(void *data, unsigned long hva, int len)
> > +{
> > +	int offset = offset_in_page(hva);
> > +	struct page *page;
> > +	int npages, seg;
> > +
> > +	while ((seg = next_segment(len, offset)) != 0) {
> > +		npages = get_user_pages_unlocked(hva, 1, &page, 0);
> > +		if (npages != 1)
> > +			return -EFAULT;
> > +		memcpy(data, page_address(page) + offset, seg);
> > +		put_page(page);
> > +		len -= seg;
> > +		hva += seg;
> > +		offset = 0;
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int copy_to_guest(unsigned long hva, const void *data, int len)
> > +{
> > +	int offset = offset_in_page(hva);
> > +	struct page *page;
> > +	int npages, seg;
> > +
> > +	while ((seg = next_segment(len, offset)) != 0) {
> > +		npages = get_user_pages_unlocked(hva, 1, &page, FOLL_WRITE);
> > +		if (npages != 1)
> > +			return -EFAULT;
> > +		memcpy(page_address(page) + offset, data, seg);
> > +		put_page(page);
> > +		len -= seg;
> > +		hva += seg;
> > +		offset = 0;
> > +	}
> > +	return 0;
> > +}
> > +
> >  static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> > -				 void *data, int offset, int len)
> > +				 void *data, int offset, int len,
> > +				 bool protected)
> >  {
> >  	int r;
> >  	unsigned long addr;
> > @@ -2257,7 +2297,10 @@ static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> >  	addr = gfn_to_hva_memslot_prot(slot, gfn, NULL);
> >  	if (kvm_is_error_hva(addr))
> >  		return -EFAULT;
> > -	r = __copy_from_user(data, (void __user *)addr + offset, len);
> > +	if (protected)
> > +		r = copy_from_guest(data, addr + offset, len);
> > +	else
> > +		r = __copy_from_user(data, (void __user *)addr + offset, len);
> >  	if (r)
> >  		return -EFAULT;
> >  	return 0;
> > @@ -2268,7 +2311,8 @@ int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
> >  {
> >  	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> >  
> > -	return __kvm_read_guest_page(slot, gfn, data, offset, len);
> > +	return __kvm_read_guest_page(slot, gfn, data, offset, len,
> > +				     kvm->mem_protected);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_read_guest_page);
> >  
> > @@ -2277,7 +2321,8 @@ int kvm_vcpu_read_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn, void *data,
> >  {
> >  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> >  
> > -	return __kvm_read_guest_page(slot, gfn, data, offset, len);
> > +	return __kvm_read_guest_page(slot, gfn, data, offset, len,
> > +				     vcpu->kvm->mem_protected);
> 
> Personally, I would've just added 'struct kvm' pointer to 'struct
> kvm_memory_slot' to be able to extract 'mem_protected' info when
> needed. This will make the patch much smaller.

Okay, can do.

Other thing I tried is to have per-slot flag to indicate that it's
protected. But Sean pointed that it's all-or-nothing feature and having
the flag in the slot would be misleading.

> >  }
> >  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_page);
> >  
> > @@ -2350,7 +2395,8 @@ int kvm_vcpu_read_guest_atomic(struct kvm_vcpu *vcpu, gpa_t gpa,
> >  EXPORT_SYMBOL_GPL(kvm_vcpu_read_guest_atomic);
> >  
> >  static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
> > -			          const void *data, int offset, int len)
> > +			          const void *data, int offset, int len,
> > +				  bool protected)
> >  {
> >  	int r;
> >  	unsigned long addr;
> > @@ -2358,7 +2404,11 @@ static int __kvm_write_guest_page(struct kvm_memory_slot *memslot, gfn_t gfn,
> >  	addr = gfn_to_hva_memslot(memslot, gfn);
> >  	if (kvm_is_error_hva(addr))
> >  		return -EFAULT;
> > -	r = __copy_to_user((void __user *)addr + offset, data, len);
> > +
> > +	if (protected)
> > +		r = copy_to_guest(addr + offset, data, len);
> > +	else
> > +		r = __copy_to_user((void __user *)addr + offset, data, len);
> 
> All users of copy_to_guest() will have to have the same 'if (protected)'
> check, right? Why not move the check to copy_to/from_guest() then?

Good point.

> >  	if (r)
> >  		return -EFAULT;
> >  	mark_page_dirty_in_slot(memslot, gfn);
> > @@ -2370,7 +2420,8 @@ int kvm_write_guest_page(struct kvm *kvm, gfn_t gfn,
> >  {
> >  	struct kvm_memory_slot *slot = gfn_to_memslot(kvm, gfn);
> >  
> > -	return __kvm_write_guest_page(slot, gfn, data, offset, len);
> > +	return __kvm_write_guest_page(slot, gfn, data, offset, len,
> > +				      kvm->mem_protected);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_write_guest_page);
> >  
> > @@ -2379,7 +2430,8 @@ int kvm_vcpu_write_guest_page(struct kvm_vcpu *vcpu, gfn_t gfn,
> >  {
> >  	struct kvm_memory_slot *slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
> >  
> > -	return __kvm_write_guest_page(slot, gfn, data, offset, len);
> > +	return __kvm_write_guest_page(slot, gfn, data, offset, len,
> > +				      vcpu->kvm->mem_protected);
> >  }
> >  EXPORT_SYMBOL_GPL(kvm_vcpu_write_guest_page);
> >  
> > @@ -2495,7 +2547,10 @@ int kvm_write_guest_offset_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
> >  	if (unlikely(!ghc->memslot))
> >  		return kvm_write_guest(kvm, gpa, data, len);
> >  
> > -	r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
> > +	if (kvm->mem_protected)
> > +		r = copy_to_guest(ghc->hva + offset, data, len);
> > +	else
> > +		r = __copy_to_user((void __user *)ghc->hva + offset, data, len);
> >  	if (r)
> >  		return -EFAULT;
> >  	mark_page_dirty_in_slot(ghc->memslot, gpa >> PAGE_SHIFT);
> > @@ -2530,7 +2585,10 @@ int kvm_read_guest_cached(struct kvm *kvm, struct gfn_to_hva_cache *ghc,
> >  	if (unlikely(!ghc->memslot))
> >  		return kvm_read_guest(kvm, ghc->gpa, data, len);
> >  
> > -	r = __copy_from_user(data, (void __user *)ghc->hva, len);
> > +	if (kvm->mem_protected)
> > +		r = copy_from_guest(data, ghc->hva, len);
> > +	else
> > +		r = __copy_from_user(data, (void __user *)ghc->hva, len);
> >  	if (r)
> >  		return -EFAULT;
> 
> -- 
> Vitaly
> 
> 

-- 
 Kirill A. Shutemov
