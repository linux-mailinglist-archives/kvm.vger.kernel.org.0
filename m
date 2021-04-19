Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54FC33647AD
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:02:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242091AbhDSQC1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242024AbhDSQCW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 12:02:22 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CE88C061763
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:01:51 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id h11so5838923pfn.0
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D+scCxaF/k3XnD2sscAAiRoJE5CZQjd/qu5mFzNH7gg=;
        b=i6RwnX5xqtSrZgM5rvmPeRmsfWNxhgopBYEi7XmYe2x+pC/K41omM/bvXmWAVKQdQY
         lzyWCwQbk11DZ3Geq6gmuYxwk0ELNs7jLPwq+wZYFINt7uY6uHeRzZeqXSB6GuVtClOA
         T/QiaTut2wOhP/aP+L6oWxJPjRQX/NcOKzvG3dsWlR6j98FCd85cnQHmT+GLhSUQ+eLK
         sTJRB51lTBIsffNdMn97QnCUyrA6Ego1GbUSI1/LFLZlqp9RfFKBr1WqljqJyIHL2DX1
         oJfkMteb3JLrkZxNM6c8IJPJiXC4uWjDX/CntY5u9HWERN4m8Otuu8VxDKFGVIw3genw
         SV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D+scCxaF/k3XnD2sscAAiRoJE5CZQjd/qu5mFzNH7gg=;
        b=RBTCkXnEM+iJgugB+UPqbaP8bfyutIEXNpB9r3yIzV3CGzdscVng7yVJrZcbenDUmT
         at6I+j76THA+Bt9lLA1uSv/lkasfrD1DasiE+shKvWSS/iHL3D9vTPMeyj9u6HCPtnT4
         3dANl5bWvxeKza+Rb7oIfmkl4GofG2vWeYSvX16nkOH9zh3gUKAyd9YskVABrFovuLY2
         0Af/H9oEU0cDCYQ25OShpfUC466nsKoMFSN4CHCoNYva+EnpIIO2akp3BD7lxfP9L5J7
         8EUvltymYuveimYmcfy+8f8OwaOo0iDjhqJGp4LXOY5cBMqa+n4wEmtX7KYaDgO+/i6A
         Imtw==
X-Gm-Message-State: AOAM532on7yxFe047mYehRplSdV6lwz8Zwv53uNDQ5ckRW9q9k2IlesE
        iRHptkW0U+MORN7u/e/BM/erBw==
X-Google-Smtp-Source: ABdhPJwKrlTLKHLyKD4kCvVe40T/+hXPu2uy1xeYbvr2iGbcZ8V8usWVWgakEo//6lEuJdOUeoFa8g==
X-Received: by 2002:a62:7d07:0:b029:21b:d1bc:f6c8 with SMTP id y7-20020a627d070000b029021bd1bcf6c8mr20258928pfc.45.1618848110621;
        Mon, 19 Apr 2021 09:01:50 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id l17sm13229762pgi.66.2021.04.19.09.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 09:01:49 -0700 (PDT)
Date:   Mon, 19 Apr 2021 16:01:46 +0000
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
Message-ID: <YH2pam5b837wFM3z@google.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
 <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
 <YHnJtvXdrZE+AfM3@google.com>
 <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021, Kirill A. Shutemov wrote:
> On Fri, Apr 16, 2021 at 05:30:30PM +0000, Sean Christopherson wrote:
> > I like the idea of using "special" PTE value to denote guest private memory,
> > e.g. in this RFC, HWPOISON.  But I strongly dislike having KVM involved in the
> > manipulation of the special flag/value.
> > 
> > Today, userspace owns the gfn->hva translations and the kernel effectively owns
> > the hva->pfn translations (with input from userspace).  KVM just connects the
> > dots.
> > 
> > Having KVM own the shared/private transitions means KVM is now part owner of the
> > entire gfn->hva->pfn translation, i.e. KVM is effectively now a secondary MMU
> > and a co-owner of the primary MMU.  This creates locking madness, e.g. KVM taking
> > mmap_sem for write, mmu_lock under page lock, etc..., and also takes control away
> > from userspace.  E.g. userspace strategy could be to use a separate backing/pool
> > for shared memory and change the gfn->hva translation (memslots) in reaction to
> > a shared/private conversion.  Automatically swizzling things in KVM takes away
> > that option.
> > 
> > IMO, KVM should be entirely "passive" in this process, e.g. the guest shares or
> > protects memory, userspace calls into the kernel to change state, and the kernel
> > manages the page tables to prevent bad actors.  KVM simply does the plumbing for
> > the guest page tables.
> 
> That's a new perspective for me. Very interesting.
> 
> Let's see how it can look like:
> 
>  - KVM only allows poisoned pages (or whatever flag we end up using for
>    protection) in the private mappings. SIGBUS otherwise.
> 
>  - Poisoned pages must be tied to the KVM instance to be allowed in the
>    private mappings. Like kvm->id in the current prototype. SIGBUS
>    otherwise.
> 
>  - Pages get poisoned on fault in if the VMA has a new vmflag set.
> 
>  - Fault in of a poisoned page leads to hwpoison entry. Userspace cannot
>    access such pages.
> 
>  - Poisoned pages produced this way get unpoisoned on free.
> 
>  - The new VMA flag set by userspace. mprotect(2)?

Ya, or mmap(), though I'm not entirely sure a VMA flag would suffice.  The
notion of the page being private is tied to the PFN, which would suggest "struct
page" needs to be involved.

But fundamentally the private pages, are well, private.  They can't be shared
across processes, so I think we could (should?) require the VMA to always be
MAP_PRIVATE.  Does that buy us enough to rely on the VMA alone?  I.e. is that
enough to prevent userspace and unaware kernel code from acquiring a reference
to the underlying page?

>  - Add a new GUP flag to retrive such pages from the userspace mapping.
>    Used only for private mapping population.

>  - Shared gfn ranges managed by userspace, based on hypercalls from the
>    guest.
> 
>  - Shared mappings get populated via normal VMA. Any poisoned pages here
>    would lead to SIGBUS.
> 
> So far it looks pretty straight-forward.
> 
> The only thing that I don't understand is at way point the page gets tied
> to the KVM instance. Currently we do it just before populating shadow
> entries, but it would not work with the new scheme: as we poison pages
> on fault it they may never get inserted into shadow entries. That's not
> good as we rely on the info to unpoison page on free.

Can you elaborate on what you mean by "unpoison"?  If the page is never actually
mapped into the guest, then its poisoned status is nothing more than a software
flag, i.e. nothing extra needs to be done on free.  If the page is mapped into
the guest, then KVM can be made responsible for reinitializing the page with
keyid=0 when the page is removed from the guest.

The TDX Module prevents mapping the same PFN into multiple guests, so the kernel
doesn't actually have to care _which_ KVM instance(s) is associated with a page,
it only needs to prevent installing valid PTEs in the host page tables.

> Maybe we should tie VMA to the KVM instance on setting the vmflags?
> I donno.
> 
> Any comments?
> 
> -- 
>  Kirill A. Shutemov
