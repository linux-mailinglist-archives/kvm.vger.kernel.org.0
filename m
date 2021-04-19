Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16132364861
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 18:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232530AbhDSQlB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 12:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhDSQlA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 12:41:00 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579E0C06174A
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:40:30 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id o5so7064754ljc.1
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 09:40:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7qgajl+Ts0WA14/+MR4yZYdGuCNBKk27XxFLHdnlWBM=;
        b=tmcl1KeHSfdAvcTnu3xcwjhs3lTJkxdanGoHQdVn22mYltJ4AHvfoXFt0tMfNexgXv
         rWnEwqoY5kfb37n3WFpyzezRSeotdXTiYGdxjs811N03Z20IkRWUpJdJmadW0IU/prdz
         7m4UJjtd/kZb06jGi687QrPcj2Qsb8yhOxEU4QckPu5nrO8LoCXB0MwvuQEpCv08O7Dj
         Ya3L/jh4TT+uYnbRNuzP8BwE3A9YnrF0IRNisyM5sQg2nI8uwTWxw6XRM2wbYUzWWheh
         uSjCftFUYSPBu05dl4LUM3VJrWikLnERkR/Jr3ZZv73OJOfM5Cfl8iIIdKJp8C3otx0v
         F2fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7qgajl+Ts0WA14/+MR4yZYdGuCNBKk27XxFLHdnlWBM=;
        b=Y0tOLvRfuOY40cD5TWdqPSwP6lZeSDPqorY2xu5RUxh4U7mG8dg3cHlltS9ppzpvb+
         ISb00aNO6CjUfblmirzgklRSxunqQRSVmX9QZEkeSlQQga7igBMQfh6N5cSIaiFhaPd5
         7c/NCnK2B3pMiJXcpaU54uscKQ6PbN7HjHqgAHuFE2iM+S05LQZBGOgpqskf145VFfZn
         Ymy5OPcaklHsZ4XTN8Qe54YIuvGCm0Ug8nEPYah4K5nVqJcZwZJS1bTIUDeo+HozEDXX
         Z8sK5efcKPEb2BzFDbUvmh/9rCbQBG8ZArKCAuq9hMsGTBvCfxWmaRKqIEQmI/2pAHCS
         jX7Q==
X-Gm-Message-State: AOAM533+O0qcwlsN3nJtPRdWChQ2Sfx+5IO22h/8ekxbVazo3/wkFhP1
        rZMJEm8rBzHQasf5IBqXk+DPXg==
X-Google-Smtp-Source: ABdhPJxyFZ702VWBGMXtkldZHHPhJHXJ6yGWWX3vW2hKxm3cIbMLzL6SZ0/QxdmkfR9Ceq4eLYoVSA==
X-Received: by 2002:a2e:bf19:: with SMTP id c25mr12228435ljr.201.1618850428779;
        Mon, 19 Apr 2021 09:40:28 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id j14sm1873783lfg.134.2021.04.19.09.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 09:40:27 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 1E51D102567; Mon, 19 Apr 2021 19:40:27 +0300 (+03)
Date:   Mon, 19 Apr 2021 19:40:27 +0300
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
Message-ID: <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
 <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
 <YHnJtvXdrZE+AfM3@google.com>
 <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
 <YH2pam5b837wFM3z@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YH2pam5b837wFM3z@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021 at 04:01:46PM +0000, Sean Christopherson wrote:
> On Mon, Apr 19, 2021, Kirill A. Shutemov wrote:
> > On Fri, Apr 16, 2021 at 05:30:30PM +0000, Sean Christopherson wrote:
> > > I like the idea of using "special" PTE value to denote guest private memory,
> > > e.g. in this RFC, HWPOISON.  But I strongly dislike having KVM involved in the
> > > manipulation of the special flag/value.
> > > 
> > > Today, userspace owns the gfn->hva translations and the kernel effectively owns
> > > the hva->pfn translations (with input from userspace).  KVM just connects the
> > > dots.
> > > 
> > > Having KVM own the shared/private transitions means KVM is now part owner of the
> > > entire gfn->hva->pfn translation, i.e. KVM is effectively now a secondary MMU
> > > and a co-owner of the primary MMU.  This creates locking madness, e.g. KVM taking
> > > mmap_sem for write, mmu_lock under page lock, etc..., and also takes control away
> > > from userspace.  E.g. userspace strategy could be to use a separate backing/pool
> > > for shared memory and change the gfn->hva translation (memslots) in reaction to
> > > a shared/private conversion.  Automatically swizzling things in KVM takes away
> > > that option.
> > > 
> > > IMO, KVM should be entirely "passive" in this process, e.g. the guest shares or
> > > protects memory, userspace calls into the kernel to change state, and the kernel
> > > manages the page tables to prevent bad actors.  KVM simply does the plumbing for
> > > the guest page tables.
> > 
> > That's a new perspective for me. Very interesting.
> > 
> > Let's see how it can look like:
> > 
> >  - KVM only allows poisoned pages (or whatever flag we end up using for
> >    protection) in the private mappings. SIGBUS otherwise.
> > 
> >  - Poisoned pages must be tied to the KVM instance to be allowed in the
> >    private mappings. Like kvm->id in the current prototype. SIGBUS
> >    otherwise.
> > 
> >  - Pages get poisoned on fault in if the VMA has a new vmflag set.
> > 
> >  - Fault in of a poisoned page leads to hwpoison entry. Userspace cannot
> >    access such pages.
> > 
> >  - Poisoned pages produced this way get unpoisoned on free.
> > 
> >  - The new VMA flag set by userspace. mprotect(2)?
> 
> Ya, or mmap(), though I'm not entirely sure a VMA flag would suffice.  The
> notion of the page being private is tied to the PFN, which would suggest "struct
> page" needs to be involved.

PG_hwpoison will be set on the page, so it's tied to pfn.

> But fundamentally the private pages, are well, private.  They can't be shared
> across processes, so I think we could (should?) require the VMA to always be
> MAP_PRIVATE.  Does that buy us enough to rely on the VMA alone?  I.e. is that
> enough to prevent userspace and unaware kernel code from acquiring a reference
> to the underlying page?

Shared pages should be fine too (you folks wanted tmpfs support).

The poisoned pages must be useless outside of the process with the blessed
struct kvm. See kvm_pfn_map in the patch.

> >  - Add a new GUP flag to retrive such pages from the userspace mapping.
> >    Used only for private mapping population.
> 
> >  - Shared gfn ranges managed by userspace, based on hypercalls from the
> >    guest.
> > 
> >  - Shared mappings get populated via normal VMA. Any poisoned pages here
> >    would lead to SIGBUS.
> > 
> > So far it looks pretty straight-forward.
> > 
> > The only thing that I don't understand is at way point the page gets tied
> > to the KVM instance. Currently we do it just before populating shadow
> > entries, but it would not work with the new scheme: as we poison pages
> > on fault it they may never get inserted into shadow entries. That's not
> > good as we rely on the info to unpoison page on free.
> 
> Can you elaborate on what you mean by "unpoison"?  If the page is never actually
> mapped into the guest, then its poisoned status is nothing more than a software
> flag, i.e. nothing extra needs to be done on free.

Normally, poisoned flag preserved for freed pages as it usually indicate
hardware issue. In this case we need return page to the normal circulation.
So we need a way to differentiate two kinds of page poison. Current patch
does this by adding page's pfn to kvm_pfn_map. But this will not work if
we uncouple poisoning and adding to shadow PTE.

-- 
 Kirill A. Shutemov
