Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBFC836460B
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 16:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239579AbhDSO0j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 10:26:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbhDSO0h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 10:26:37 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D264AC061761
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 07:26:05 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 12so56079488lfq.13
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 07:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9S0Wtbq4es5oYYPpSLSAT/39jDBxRK85obPsvkL2qUw=;
        b=esWeQJK9FvJxBiDnuuwK9c4Efnqbdt1lBBJgNBak/jqhFCoVL1cuozpyz50hNpbSmd
         HMgHelsPCYu1ktEGO4GVisbbcAvHpEseTEB3W88F/PG5nGdR0XNjNsVZWF4Swvg77pIz
         Z0GMahYBXyHfnfjCO2cK2bGVW8vrHbD/+wKTktdf7KN7JbKGPwXbzCfjqLcY3MGUBtsm
         av/Gl4y/evv+AXR6Yi3ZcfUWdnnOAT5WHNbHIfjHyUx80U9mmboGjMSOMpEMxBL2rCz6
         G3soJyBYDWYTxf9pqRZVqnJk8z5iNeTMtlKD1PJjR3b2FQUWsLHnJMsmM+IN8S5XY7Dr
         dryQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9S0Wtbq4es5oYYPpSLSAT/39jDBxRK85obPsvkL2qUw=;
        b=Xy7F2ZUwznGeJgZR7g38PehOU3x350IpE8l4Dh7NAFVpJsQBQsWDyXU9x1ApbLiQMk
         lUyx8Os6JP65iYPd/nCnv+3J/XAtO/6no6fMtM9W+S3QrgMMYC2bDPutjUiAQjtZ/vGA
         jEKOXQYz75EawAZ/Q7nSk7ztK2+Fsd/3paVwvgWg6x43BILcqWynJjIeysuy8jKsLEmP
         ZgS9MXvKsUYEUmDrpF56Wcw5bEwTI48SquU6vFj7qBX2jijfDz3R49ZBysFQCfA2tQOc
         nFu8aqE6KWHbb2SuFutIKi9pZIGZ55R2AlJtHVpS92mfeYQ+ldxlITtQcHugado4azGg
         OnUA==
X-Gm-Message-State: AOAM532t+yOJKeuj7dYUlvCFEA3rU1DfLmh9TqW7ShPI0PvuOjFOb1mI
        afRQ10xXMxF/r9D0ljd7FQJ3NQ==
X-Google-Smtp-Source: ABdhPJxhu0nZM6ElfDMRFqixFroO8cvi/vlk9OkMyp0mMAj7EEGNq0e0G/+4JJNcVe7fumUPSfFMYw==
X-Received: by 2002:a05:6512:110d:: with SMTP id l13mr12523932lfg.612.1618842364357;
        Mon, 19 Apr 2021 07:26:04 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id a27sm241053lfo.190.2021.04.19.07.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 07:26:03 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id A028A102567; Mon, 19 Apr 2021 17:26:02 +0300 (+03)
Date:   Mon, 19 Apr 2021 17:26:02 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Sean Christopherson <seanjc@google.com>
Cc:     "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
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
Message-ID: <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
 <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
 <YHnJtvXdrZE+AfM3@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHnJtvXdrZE+AfM3@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 16, 2021 at 05:30:30PM +0000, Sean Christopherson wrote:
> On Fri, Apr 16, 2021, Kirill A. Shutemov wrote:
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 1b404e4d7dd8..f8183386abe7 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -8170,6 +8170,12 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
> >  		kvm_sched_yield(vcpu->kvm, a0);
> >  		ret = 0;
> >  		break;
> > +	case KVM_HC_ENABLE_MEM_PROTECTED:
> > +		ret = kvm_protect_memory(vcpu->kvm);
> > +		break;
> > +	case KVM_HC_MEM_SHARE:
> > +		ret = kvm_share_memory(vcpu->kvm, a0, a1);
> 
> Can you take a look at a proposed hypercall interface for SEV live migration and
> holler if you (or anyone else) thinks it will have extensibility issues?
> 
> https://lkml.kernel.org/r/93d7f2c2888315adc48905722574d89699edde33.1618498113.git.ashish.kalra@amd.com

Will look closer. Thanks.

> > @@ -1868,11 +1874,17 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
> >  		flags |= FOLL_WRITE;
> >  	if (async)
> >  		flags |= FOLL_NOWAIT;
> > +	if (kvm->mem_protected)
> > +		flags |= FOLL_ALLOW_POISONED;
> 
> This is unsafe, only the flows that are mapping the PFN into the guest should
> use ALLOW_POISONED, e.g. __kvm_map_gfn() should fail on a poisoned page.

That's true for TDX. I prototyped with pure KVM with minimal modification
to the guest. We had to be more permissive for the reason. It will go
away for TDX.

> > -static int __kvm_read_guest_page(struct kvm_memory_slot *slot, gfn_t gfn,
> > -				 void *data, int offset, int len)
> > +int copy_from_guest(struct kvm *kvm, void *data, unsigned long hva, int len)
> > +{
> > +	int offset = offset_in_page(hva);
> > +	struct page *page;
> > +	int npages, seg;
> > +	void *vaddr;
> > +
> > +	if (!IS_ENABLED(CONFIG_HAVE_KVM_PROTECTED_MEMORY) ||
> > +	    !kvm->mem_protected) {
> > +		return __copy_from_user(data, (void __user *)hva, len);
> > +	}
> > +
> > +	might_fault();
> > +	kasan_check_write(data, len);
> > +	check_object_size(data, len, false);
> > +
> > +	while ((seg = next_segment(len, offset)) != 0) {
> > +		npages = get_user_pages_unlocked(hva, 1, &page,
> > +						 FOLL_ALLOW_POISONED);
> > +		if (npages != 1)
> > +			return -EFAULT;
> > +
> > +		if (!kvm_page_allowed(kvm, page))
> > +			return -EFAULT;
> > +
> > +		vaddr = kmap_atomic(page);
> > +		memcpy(data, vaddr + offset, seg);
> > +		kunmap_atomic(vaddr);
> 
> Why is KVM allowed to access a poisoned page?  I would expect shared pages to
> _not_ be poisoned.  Except for pure software emulation of SEV, KVM can't access
> guest private memory.

Again, it's not going to be in TDX implementation.


> I like the idea of using "special" PTE value to denote guest private memory,
> e.g. in this RFC, HWPOISON.  But I strongly dislike having KVM involved in the
> manipulation of the special flag/value.
> 
> Today, userspace owns the gfn->hva translations and the kernel effectively owns
> the hva->pfn translations (with input from userspace).  KVM just connects the
> dots.
> 
> Having KVM own the shared/private transitions means KVM is now part owner of the
> entire gfn->hva->pfn translation, i.e. KVM is effectively now a secondary MMU
> and a co-owner of the primary MMU.  This creates locking madness, e.g. KVM taking
> mmap_sem for write, mmu_lock under page lock, etc..., and also takes control away
> from userspace.  E.g. userspace strategy could be to use a separate backing/pool
> for shared memory and change the gfn->hva translation (memslots) in reaction to
> a shared/private conversion.  Automatically swizzling things in KVM takes away
> that option.
> 
> IMO, KVM should be entirely "passive" in this process, e.g. the guest shares or
> protects memory, userspace calls into the kernel to change state, and the kernel
> manages the page tables to prevent bad actors.  KVM simply does the plumbing for
> the guest page tables.

That's a new perspective for me. Very interesting.

Let's see how it can look like:

 - KVM only allows poisoned pages (or whatever flag we end up using for
   protection) in the private mappings. SIGBUS otherwise.

 - Poisoned pages must be tied to the KVM instance to be allowed in the
   private mappings. Like kvm->id in the current prototype. SIGBUS
   otherwise.

 - Pages get poisoned on fault in if the VMA has a new vmflag set.

 - Fault in of a poisoned page leads to hwpoison entry. Userspace cannot
   access such pages.

 - Poisoned pages produced this way get unpoisoned on free.

 - The new VMA flag set by userspace. mprotect(2)?

 - Add a new GUP flag to retrive such pages from the userspace mapping.
   Used only for private mapping population.

 - Shared gfn ranges managed by userspace, based on hypercalls from the
   guest.

 - Shared mappings get populated via normal VMA. Any poisoned pages here
   would lead to SIGBUS.

So far it looks pretty straight-forward.

The only thing that I don't understand is at way point the page gets tied
to the KVM instance. Currently we do it just before populating shadow
entries, but it would not work with the new scheme: as we poison pages
on fault it they may never get inserted into shadow entries. That's not
good as we rely on the info to unpoison page on free.

Maybe we should tie VMA to the KVM instance on setting the vmflags?
I donno.

Any comments?

-- 
 Kirill A. Shutemov
