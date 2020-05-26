Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1681E31F1
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 00:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391771AbgEZWCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 18:02:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391342AbgEZWB5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 May 2020 18:01:57 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9EEC03E96D
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 15:01:56 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id z6so26430956ljm.13
        for <kvm@vger.kernel.org>; Tue, 26 May 2020 15:01:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qag45C4jUwpmbt3GI6yD8VqouXjmVOjCWEB+Fx5ejgk=;
        b=q55Stn1jyAS3ook2XuAjV3C7ys7h/UH0Bdx0mqbz3n/sefDwW58i2H5R6IxeleSN9h
         ZyZtwrVOn8VcG206QOLk0EDadrDLSqPA6uFwLQMO/Eaumx2FOX8E93UNcryBanjKMezH
         +1m+GF9eksL+eft3c9Xu8vKhCNWAZe8x8W7pDdh/r4qYoPf9/6hAYUwUuwOelmvytpbR
         fTAVEDv2yxlKqnpN4nboyBngLxM4i4+KkyG1sk0w9Wor8begjAI4yLnWcbVUkcebm9Iv
         Vg6oRcH8tpr6ce+ZU4WJZNL+CCVH926moZYffjZU+MzGVHkiLKV7uc6uJOdItvLaaUmg
         oqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qag45C4jUwpmbt3GI6yD8VqouXjmVOjCWEB+Fx5ejgk=;
        b=ix4xzbgqUN3oPfgT9Dq8coLt3Dtfk8bsQcf4tSqDaUNmWHuv8p1s7DiYQNifFBUz0x
         CahyGfJ4n8jUHCgotJJucTBOyzaKFSd25ntb3ma/pgKDEClKdo6Ff2Meo9G9Ut/Fk4ts
         P1k/7FG+ryx9uMO2EbFX4lAJoDociEAxuh6uLGEVBEOUqEbhwD7mFQyPm7WnHmleOgge
         pLRQSt6ergEZqQNg6DZ9G6EwTJULYXzVJFoO2UCWMdhpU0+ll38k9s3g6EPwWov6XFO+
         5HhDWfOMukGjRz924IJXkAsprFp1JP7TyXlGaxEXHzWxmvgz2oLre2ZcbNA+ukg5kfhI
         Rl9A==
X-Gm-Message-State: AOAM530FvpySPd+OK/nu3xOcj/7h1rTrtD/oBy3ZT9qisvWw0uxbcj8/
        J6FreRVym/cjWvHWVOCFrf2hjQ==
X-Google-Smtp-Source: ABdhPJyYP9bBnWpXhfnB+k7sBQ1h7ulh57l600zRR2fE+qbCiK3i+MThs6w+YABeGChhe0iesQxifA==
X-Received: by 2002:a2e:a58a:: with SMTP id m10mr1475050ljp.346.1590530514418;
        Tue, 26 May 2020 15:01:54 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id f9sm253876ljf.99.2020.05.26.15.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 15:01:53 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 9B97F10230F; Wed, 27 May 2020 01:01:55 +0300 (+03)
Date:   Wed, 27 May 2020 01:01:55 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Mike Rapoport <rppt@kernel.org>
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
Message-ID: <20200526220155.34xmakrh7ipqynht@box>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
 <20200522125214.31348-8-kirill.shutemov@linux.intel.com>
 <20200526061552.GD13247@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526061552.GD13247@kernel.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 26, 2020 at 09:15:52AM +0300, Mike Rapoport wrote:
> On Fri, May 22, 2020 at 03:52:05PM +0300, Kirill A. Shutemov wrote:
> > The new VMA flag that indicate a VMA that is not accessible to userspace
> > but usable by kernel with GUP if FOLL_KVM is specified.
> > 
> > The FOLL_KVM is only used in the KVM code. The code has to know how to
> > deal with such pages.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  include/linux/mm.h  |  8 ++++++++
> >  mm/gup.c            | 20 ++++++++++++++++----
> >  mm/huge_memory.c    | 20 ++++++++++++++++----
> >  mm/memory.c         |  3 +++
> >  mm/mmap.c           |  3 +++
> >  virt/kvm/async_pf.c |  4 ++--
> >  virt/kvm/kvm_main.c |  9 +++++----
> >  7 files changed, 53 insertions(+), 14 deletions(-)
> > 
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index e1882eec1752..4f7195365cc0 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -329,6 +329,8 @@ extern unsigned int kobjsize(const void *objp);
> >  # define VM_MAPPED_COPY	VM_ARCH_1	/* T if mapped copy of data (nommu mmap) */
> >  #endif
> >  
> > +#define VM_KVM_PROTECTED 0
> 
> With all the ideas about removing pages from the direct mapi floating
> around I wouldn't limit this to KVM.
> 
> VM_NOT_IN_DIRECT_MAP would describe such areas better, but I realise
> it's very far from perfect and nothing better does not comes to mind :)

I don't like VM_NOT_IN_DIRECT_MAP.

It's not only about direct mapping, but about userspace mapping as well.
For the same reason other naming proposals don't fit as well.

> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index f609e9ec4a25..d56c3f6efc99 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -112,6 +112,9 @@ pgprot_t vm_get_page_prot(unsigned long vm_flags)
> >  				(VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)]) |
> >  			pgprot_val(arch_vm_get_page_prot(vm_flags)));
> >  
> > +	if (vm_flags & VM_KVM_PROTECTED)
> > +		ret = PAGE_NONE;
> 
> Nit: vma_is_kvm_protected()?

Which VMA? :P

-- 
 Kirill A. Shutemov
