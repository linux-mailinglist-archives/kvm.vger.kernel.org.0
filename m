Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B2E364E57
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 00:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhDSW6f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 18:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbhDSW62 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 18:58:28 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64363C06138A
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 15:57:58 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id f41so35162722lfv.8
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 15:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HQJiSq5gQpYM2NV6elfqwANOqTUiSWOPSA/1L0jGErQ=;
        b=Y5/43Y+Kw5fgiJwOTdWXv2swOI+fI+/U7o7oTMg677UwTq0hx0Aur4nKS3kwzthchf
         uOjPETfIyFzokHZF951u0cmKSbDImPJOsUUsgEFSDgJG7Ke0ltxUxYR/5aPUDcm/8vnk
         DKlMu/5tvRSmBd99rk6EkAhay5BAair/4HfZce5BA+JXIn3fWz6JL87ZFXZWw3UPjCpL
         XqWuqEfm9xB+IiGhTSHpINZmpB3aRobIBHznPpr+lOeujR0THu0yU4uHrxxkxzI8HJSl
         n7Ic+qYzeSPpIUQYfihi6MVrxbPvdob4BCP9SR38EvsyE/7fprRP5CSze1BnIvWvRyZ5
         ba/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HQJiSq5gQpYM2NV6elfqwANOqTUiSWOPSA/1L0jGErQ=;
        b=BpFVPDNVIJE+xPdKZhH7PGGLev3HBDpgrQ4808Z+UaLSTJX/GLwrYxDO/DGd9SxK+u
         CYeLJ2nsoXacU0w8uh/iJUZ3MtandfymCo91PqqelMgzderWhePiwsiWVu548FkzCfbz
         TREu1lLYUCYDfnPpxwH07723PUl7LNM4ObbVp5XAvvjiILJeA8FqPPpK1gxz/PvLbTzl
         01tPYkk15tolyz9Opo7g+8Gh0n/klnVHdGMztP643t/JjoXjWzjIaCLUZdI22Xn+HIq/
         CLBqy7c0v510C91WkU2+vFjkkz9YXuZ4zNoLH2ceaXeTNR1HFm+Y50WMQ2QAQc2PGvin
         ATnQ==
X-Gm-Message-State: AOAM532o6NufPMGYUgV39TXQE9DO8WuSYNTh2/j+MdBsXn8Mk18JI91c
        Of22oCO7krxSQU7vMy4qWHzmlg==
X-Google-Smtp-Source: ABdhPJzoZNOZ0t2EKALbcciOjjIYuhq/fAibShB1K6ejYUTS58/jpemU5gIufFql1g/r5iia9VdyRQ==
X-Received: by 2002:ac2:58c6:: with SMTP id u6mr13437813lfo.419.1618873076874;
        Mon, 19 Apr 2021 15:57:56 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id b24sm1958685lff.207.2021.04.19.15.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 15:57:56 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 8598A10256D; Tue, 20 Apr 2021 01:57:55 +0300 (+03)
Date:   Tue, 20 Apr 2021 01:57:55 +0300
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
Message-ID: <20210419225755.nsrtjfvfcqscyb6m@box.shutemov.name>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
 <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
 <YHnJtvXdrZE+AfM3@google.com>
 <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
 <YH2pam5b837wFM3z@google.com>
 <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
 <YH3HWeOXFiCTZN4y@google.com>
 <20210419185354.v3rgandtrel7bzjj@box>
 <YH3jaf5ThzLZdY4K@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH3jaf5ThzLZdY4K@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021 at 08:09:13PM +0000, Sean Christopherson wrote:
> On Mon, Apr 19, 2021, Kirill A. Shutemov wrote:
> > On Mon, Apr 19, 2021 at 06:09:29PM +0000, Sean Christopherson wrote:
> > > On Mon, Apr 19, 2021, Kirill A. Shutemov wrote:
> > > > On Mon, Apr 19, 2021 at 04:01:46PM +0000, Sean Christopherson wrote:
> > > > > But fundamentally the private pages, are well, private.  They can't be shared
> > > > > across processes, so I think we could (should?) require the VMA to always be
> > > > > MAP_PRIVATE.  Does that buy us enough to rely on the VMA alone?  I.e. is that
> > > > > enough to prevent userspace and unaware kernel code from acquiring a reference
> > > > > to the underlying page?
> > > > 
> > > > Shared pages should be fine too (you folks wanted tmpfs support).
> > > 
> > > Is that a conflict though?  If the private->shared conversion request is kicked
> > > out to userspace, then userspace can re-mmap() the files as MAP_SHARED, no?
> > > 
> > > Allowing MAP_SHARED for guest private memory feels wrong.  The data can't be
> > > shared, and dirty data can't be written back to the file.
> > 
> > It can be remapped, but faulting in the page would produce hwpoison entry.
> 
> It sounds like you're thinking the whole tmpfs file is poisoned.

No. File is not poisoned. Pages got poisoned when they are faulted into
flagged VMA. Different VM can use the same file as long as offsets do not
overlap.

> My thought is that userspace would need to do something like for guest
> private memory:
> 
> 	mmap(NULL, guest_size, PROT_READ|PROT_WRITE, MAP_PRIVATE | MAP_GUEST_ONLY, fd, 0);
> 
> The MAP_GUEST_ONLY would be used by the kernel to ensure the resulting VMA can
> only point at private/poisoned memory, e.g. on fault, the associated PFN would
> be tagged with PG_hwpoison or whtaever.  @fd in this case could point at tmpfs,
> but I don't think it's a hard requirement.
> 
> On conversion to shared, userspace could then do:
> 
> 	munmap(<addr>, <size>)
> 	mmap(<addr>, <size>, PROT_READ|PROT_WRITE, MAP_SHARED | MAP_FIXED_NOREPLACE, fd, <offset>);
> 
> or
> 
> 	mmap(<addr>, <size>, PROT_READ|PROT_WRITE, MAP_SHARED | MAP_FIXED, fd, <offset>);
> 

I played with this variant before, but initiated from kernel. Should work
fine.

> or
> 
> 	ioctl(kvm, KVM_SET_USER_MEMORY_REGION, <delete private range>);
> 	mmap(NULL, <size>, PROT_READ|PROT_WRITE, MAP_SHARED, fd, <offset>);
> 	ioctl(kvm, KVM_SET_USER_MEMORY_REGION, <add shared range>);
> 
> Combinations would also work, e.g. unmap the private range and move the memslot.
> The private and shared memory regions could also be backed differently, e.g.
> tmpfs for shared memory, anonymous for private memory.

Right. Kernel has to be flexible enough to provide any of the schemes.

> 
> > I don't see other way to make Google's use-case with tmpfs-backed guest
> > memory work.
> 
> The underlying use-case is to be able to access guest memory from more than one
> process, e.g. so that communication with the guest isn't limited to the VMM
> process associated with the KVM instances.  By definition, guest private memory
> can't be accessed by the host; I don't see how anyone, Google included, can have
> any real requirements about
> 
> > > > The poisoned pages must be useless outside of the process with the blessed
> > > > struct kvm. See kvm_pfn_map in the patch.
> > > 
> > > The big requirement for kernel TDX support is that the pages are useless in the
> > > host.  Regarding the guest, for TDX, the TDX Module guarantees that at most a
> > > single KVM guest can have access to a page at any given time.  I believe the RMP
> > > provides the same guarantees for SEV-SNP.
> > > 
> > > SEV/SEV-ES could still end up with corruption if multiple guests map the same
> > > private page, but that's obviously not the end of the world since it's the status
> > > quo today.  Living with that shortcoming might be a worthy tradeoff if punting
> > > mutual exclusion between guests to firmware/hardware allows us to simplify the
> > > kernel implementation.
> > 
> > The critical question is whether we ever need to translate hva->pfn after
> > the page is added to the guest private memory. I believe we do, but I
> > never checked. And that's the reason we need to keep hwpoison entries
> > around, which encode pfn.
> 
> As proposed in the TDX RFC, KVM would "need" the hva->pfn translation if the
> guest private EPT entry was zapped, e.g. by NUMA balancing (which will fail on
> the backend).  But in that case, KVM still has the original PFN, the "new"
> translation becomes a sanity check to make sure that the zapped translation
> wasn't moved unexpectedly.
> 
> Regardless, I don't see what that has to do with kvm_pfn_map.  At some point,
> gup() has to fault in the page or look at the host PTE value.  For the latter,
> at least on x86, we can throw info into the PTE itself to tag it as guest-only.
> No matter what implementation we settle on, I think we've failed if we end up in
> a situation where the primary MMU has pages it doesn't know are guest-only.

I try to understand if it's a problem if KVM sees a guest-only PTE, but
it's for other VM. Like two VM's try to use the same tmpfs file as guest
memory. We cannot insert the pfn into two TD/SEV guest at once, but can it
cause other problems? I'm not sure.

-- 
 Kirill A. Shutemov
