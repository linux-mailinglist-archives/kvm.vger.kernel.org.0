Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80102364AFB
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 22:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237575AbhDSUJu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 16:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhDSUJs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 16:09:48 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B09FC06174A
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 13:09:18 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id n10so7236614plc.0
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 13:09:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gb9E5yRE8jl+5yYmAYn0DVQ42fjAt3W7XVC5pZ1tYmo=;
        b=q54c/1fzMP5xu7hFOqEyTZl3TzZXzLIMiQykRd/M9KpoviafurGheqHD3qXHNM/DLo
         ZcUldoiyYKZfKWLXVpI7Tm/ddkle9LF+1W2325PKcf9CliRcM5yKeDlT1GWyyxoHSMfE
         pN9Fg95HBkfFN4pUCylm5Bxc23Ipcx1/pkcU83iZcJuUSs8yxwYS38SSkPy3l2XlhsJG
         KMTp8cTIFRXBKa5hhVTNDnFesGNmy7SMy/D1caMJKFZp5hfAhPZeq48Za+O1F3Q7dIPg
         bOGp31j9+5LDF5uxtQp4grECteCxwgUHF+YBSTlzS4xaSDjCAd3RjEfY121m+ISc+rce
         D/NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gb9E5yRE8jl+5yYmAYn0DVQ42fjAt3W7XVC5pZ1tYmo=;
        b=SIT3hi/feT7gDlQWjYAf8woKAes7YpoYlriUA5AK5WqWQqeqVl5wmG0ojlMd8mOQS7
         WuUTxjlH4PbaZuyOemF4tXh2oUHBFpLkSdcMZL4GdCHWzWjzEQviBkzv5UTRjMFRk1lz
         kj8zUoX4bXsR0Jx8Oe2d0VtIe4MxTuHm8vLlPZmLh0lVnsDvG8LFGQEwbh6JJrz1Mhgg
         nX1rB41myW5vZ4ykr+0jsaqwSrvzVoAQNoSu1OqlJpOooguunktl/hhBNpwQ+/HvkEaC
         fNe8NvShzBElBpB4OefRotPGdsghekCfzkMmE8nXwIzqI+m6JZBArxYZfUTU3TUXaq29
         pytg==
X-Gm-Message-State: AOAM532htftwvtmCxFHlyjUO1IcP6dr98+p4+ZDgD/loc9xGrvnU7KG+
        fH6S2NoLYpXbQLv5bf6YoZN95g==
X-Google-Smtp-Source: ABdhPJx/XBc4RPZAjoHoXF9FrMurB1D8OXmaNslhgNLxWjVKSBzQSl3H3a1DS82M1aSEpJmLS9kosg==
X-Received: by 2002:a17:90b:3742:: with SMTP id ne2mr882039pjb.38.1618862957632;
        Mon, 19 Apr 2021 13:09:17 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id x17sm602750pjr.0.2021.04.19.13.09.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 13:09:16 -0700 (PDT)
Date:   Mon, 19 Apr 2021 20:09:13 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Kirill A. Shutemov" <kirill@shutemov.name>
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
Message-ID: <YH3jaf5ThzLZdY4K@google.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
 <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
 <YHnJtvXdrZE+AfM3@google.com>
 <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
 <YH2pam5b837wFM3z@google.com>
 <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
 <YH3HWeOXFiCTZN4y@google.com>
 <20210419185354.v3rgandtrel7bzjj@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419185354.v3rgandtrel7bzjj@box>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021, Kirill A. Shutemov wrote:
> On Mon, Apr 19, 2021 at 06:09:29PM +0000, Sean Christopherson wrote:
> > On Mon, Apr 19, 2021, Kirill A. Shutemov wrote:
> > > On Mon, Apr 19, 2021 at 04:01:46PM +0000, Sean Christopherson wrote:
> > > > But fundamentally the private pages, are well, private.  They can't be shared
> > > > across processes, so I think we could (should?) require the VMA to always be
> > > > MAP_PRIVATE.  Does that buy us enough to rely on the VMA alone?  I.e. is that
> > > > enough to prevent userspace and unaware kernel code from acquiring a reference
> > > > to the underlying page?
> > > 
> > > Shared pages should be fine too (you folks wanted tmpfs support).
> > 
> > Is that a conflict though?  If the private->shared conversion request is kicked
> > out to userspace, then userspace can re-mmap() the files as MAP_SHARED, no?
> > 
> > Allowing MAP_SHARED for guest private memory feels wrong.  The data can't be
> > shared, and dirty data can't be written back to the file.
> 
> It can be remapped, but faulting in the page would produce hwpoison entry.

It sounds like you're thinking the whole tmpfs file is poisoned.  My thought is
that userspace would need to do something like for guest private memory:

	mmap(NULL, guest_size, PROT_READ|PROT_WRITE, MAP_PRIVATE | MAP_GUEST_ONLY, fd, 0);

The MAP_GUEST_ONLY would be used by the kernel to ensure the resulting VMA can
only point at private/poisoned memory, e.g. on fault, the associated PFN would
be tagged with PG_hwpoison or whtaever.  @fd in this case could point at tmpfs,
but I don't think it's a hard requirement.

On conversion to shared, userspace could then do:

	munmap(<addr>, <size>)
	mmap(<addr>, <size>, PROT_READ|PROT_WRITE, MAP_SHARED | MAP_FIXED_NOREPLACE, fd, <offset>);

or

	mmap(<addr>, <size>, PROT_READ|PROT_WRITE, MAP_SHARED | MAP_FIXED, fd, <offset>);

or

	ioctl(kvm, KVM_SET_USER_MEMORY_REGION, <delete private range>);
	mmap(NULL, <size>, PROT_READ|PROT_WRITE, MAP_SHARED, fd, <offset>);
	ioctl(kvm, KVM_SET_USER_MEMORY_REGION, <add shared range>);

Combinations would also work, e.g. unmap the private range and move the memslot.
The private and shared memory regions could also be backed differently, e.g.
tmpfs for shared memory, anonymous for private memory.

> I don't see other way to make Google's use-case with tmpfs-backed guest
> memory work.

The underlying use-case is to be able to access guest memory from more than one
process, e.g. so that communication with the guest isn't limited to the VMM
process associated with the KVM instances.  By definition, guest private memory
can't be accessed by the host; I don't see how anyone, Google included, can have
any real requirements about

> > > The poisoned pages must be useless outside of the process with the blessed
> > > struct kvm. See kvm_pfn_map in the patch.
> > 
> > The big requirement for kernel TDX support is that the pages are useless in the
> > host.  Regarding the guest, for TDX, the TDX Module guarantees that at most a
> > single KVM guest can have access to a page at any given time.  I believe the RMP
> > provides the same guarantees for SEV-SNP.
> > 
> > SEV/SEV-ES could still end up with corruption if multiple guests map the same
> > private page, but that's obviously not the end of the world since it's the status
> > quo today.  Living with that shortcoming might be a worthy tradeoff if punting
> > mutual exclusion between guests to firmware/hardware allows us to simplify the
> > kernel implementation.
> 
> The critical question is whether we ever need to translate hva->pfn after
> the page is added to the guest private memory. I believe we do, but I
> never checked. And that's the reason we need to keep hwpoison entries
> around, which encode pfn.

As proposed in the TDX RFC, KVM would "need" the hva->pfn translation if the
guest private EPT entry was zapped, e.g. by NUMA balancing (which will fail on
the backend).  But in that case, KVM still has the original PFN, the "new"
translation becomes a sanity check to make sure that the zapped translation
wasn't moved unexpectedly.

Regardless, I don't see what that has to do with kvm_pfn_map.  At some point,
gup() has to fault in the page or look at the host PTE value.  For the latter,
at least on x86, we can throw info into the PTE itself to tag it as guest-only.
No matter what implementation we settle on, I think we've failed if we end up in
a situation where the primary MMU has pages it doesn't know are guest-only.

> If we don't, it would simplify the solution: kvm_pfn_map is not needed.
> Single bit-per page would be enough.
