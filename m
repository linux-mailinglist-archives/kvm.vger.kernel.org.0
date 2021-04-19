Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5073B3649A1
	for <lists+kvm@lfdr.de>; Mon, 19 Apr 2021 20:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240681AbhDSSKH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Apr 2021 14:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbhDSSKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Apr 2021 14:10:04 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002C4C06174A
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 11:09:34 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id w10so24828928pgh.5
        for <kvm@vger.kernel.org>; Mon, 19 Apr 2021 11:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JUnfh0pPTrADDE5ELA+4XLvS6WL0YCiwkGF+Ud8ird8=;
        b=gVSJkZhYfwM6kw+ptrMrrBqiowP0QK/MTQrX80iGcTyqt0Nui8BfDhHTZfkAKzObwu
         ZeFuyE4ol8P5d++A0LiroAJ6mp+xlu8ICWB2rkgZoaa4qE429e+7Vtsj2fK3naZebWpJ
         NK4tdLZs4JwFPzTsYaIvfHzqgn8ujWJrhXXQDc+YCvgxrjUvVkGt2bHRzrIZ/uEmDRzB
         oILq+PtO7IdOMY9865se4DdwVTSKOjYXZUzrcAHB1ZTo85rJMsIkGjtutPBNkkdlxo3I
         1J6w0E4Tih1MEpMU3r08b6+M3T8s/jK6ynpmm1idIAIZQkxzLnvVQHKnSeDpGbBLE0dd
         LSrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JUnfh0pPTrADDE5ELA+4XLvS6WL0YCiwkGF+Ud8ird8=;
        b=UmfLjEm6ElxujKnfdF2QaNOBBgj3Pl334bi4PqJ+nxbXtRvBBbRAumx9JeDDCY2Ffz
         PCE0eoITbMzhadxW8CeewDn+621u+p6fdE/17VXA9xOVs+DU1nfszLVO66ATFLvAzFeQ
         t7SY2lHa8JFIaxAiFrUkYvacp9c+Lwrd5yh/2rWaV5qEZrHi4Hohb1F+OG3yw7LJMWaA
         cTMdAs8QcrhZPl2hBaF5D+WdVOt5cTI7SRRLl4jrUXIHERCxLr6ilsZud7+PWSHefRpx
         NNvjI4zO6Oi4RatstX9B2B3/TffFVA7swMgI5Jb/yns5ypTgL/kzQvkLqa0ngtEogp/5
         BhQw==
X-Gm-Message-State: AOAM532rcKJ4jQRKu6+P57r8xGjqehQCo/YuGSIDgoXFlXwxkUGcfEWZ
        oGUpcpbxFwbhXOCYukncJvumHg==
X-Google-Smtp-Source: ABdhPJx2AIFxFdpQljQJ12l5gqvXUH3In64e71gFGnOtU1ZW8Q5a+YB0Qhi9EgSdz37xacvEnTRocA==
X-Received: by 2002:a62:d108:0:b029:25d:497e:2dfd with SMTP id z8-20020a62d1080000b029025d497e2dfdmr10132772pfg.29.1618855774343;
        Mon, 19 Apr 2021 11:09:34 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id 63sm5957168pfx.202.2021.04.19.11.09.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 11:09:33 -0700 (PDT)
Date:   Mon, 19 Apr 2021 18:09:29 +0000
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
Message-ID: <YH3HWeOXFiCTZN4y@google.com>
References: <20210416154106.23721-1-kirill.shutemov@linux.intel.com>
 <20210416154106.23721-14-kirill.shutemov@linux.intel.com>
 <YHnJtvXdrZE+AfM3@google.com>
 <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
 <YH2pam5b837wFM3z@google.com>
 <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021, Kirill A. Shutemov wrote:
> On Mon, Apr 19, 2021 at 04:01:46PM +0000, Sean Christopherson wrote:
> > But fundamentally the private pages, are well, private.  They can't be shared
> > across processes, so I think we could (should?) require the VMA to always be
> > MAP_PRIVATE.  Does that buy us enough to rely on the VMA alone?  I.e. is that
> > enough to prevent userspace and unaware kernel code from acquiring a reference
> > to the underlying page?
> 
> Shared pages should be fine too (you folks wanted tmpfs support).

Is that a conflict though?  If the private->shared conversion request is kicked
out to userspace, then userspace can re-mmap() the files as MAP_SHARED, no?

Allowing MAP_SHARED for guest private memory feels wrong.  The data can't be
shared, and dirty data can't be written back to the file.

> The poisoned pages must be useless outside of the process with the blessed
> struct kvm. See kvm_pfn_map in the patch.

The big requirement for kernel TDX support is that the pages are useless in the
host.  Regarding the guest, for TDX, the TDX Module guarantees that at most a
single KVM guest can have access to a page at any given time.  I believe the RMP
provides the same guarantees for SEV-SNP.

SEV/SEV-ES could still end up with corruption if multiple guests map the same
private page, but that's obviously not the end of the world since it's the status
quo today.  Living with that shortcoming might be a worthy tradeoff if punting
mutual exclusion between guests to firmware/hardware allows us to simplify the
kernel implementation.

> > >  - Add a new GUP flag to retrive such pages from the userspace mapping.
> > >    Used only for private mapping population.
> > 
> > >  - Shared gfn ranges managed by userspace, based on hypercalls from the
> > >    guest.
> > > 
> > >  - Shared mappings get populated via normal VMA. Any poisoned pages here
> > >    would lead to SIGBUS.
> > > 
> > > So far it looks pretty straight-forward.
> > > 
> > > The only thing that I don't understand is at way point the page gets tied
> > > to the KVM instance. Currently we do it just before populating shadow
> > > entries, but it would not work with the new scheme: as we poison pages
> > > on fault it they may never get inserted into shadow entries. That's not
> > > good as we rely on the info to unpoison page on free.
> > 
> > Can you elaborate on what you mean by "unpoison"?  If the page is never actually
> > mapped into the guest, then its poisoned status is nothing more than a software
> > flag, i.e. nothing extra needs to be done on free.
> 
> Normally, poisoned flag preserved for freed pages as it usually indicate
> hardware issue. In this case we need return page to the normal circulation.
> So we need a way to differentiate two kinds of page poison. Current patch
> does this by adding page's pfn to kvm_pfn_map. But this will not work if
> we uncouple poisoning and adding to shadow PTE.

Why use PG_hwpoison then?
