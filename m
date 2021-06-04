Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB3639BF23
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 19:54:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhFDR4O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 13:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhFDR4N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Jun 2021 13:56:13 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6860C061766
        for <kvm@vger.kernel.org>; Fri,  4 Jun 2021 10:54:26 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id w33so15323855lfu.7
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 10:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vfnMx6/ZkVtuDtw0ciVv336EcMYRTKWQaVjz13KGQBA=;
        b=ChYC78odqFlVqgQXf/c6yHOpnVBZtmXzFxuqS35xMwqNbape5bLR94ccnEN/5pAfmt
         zvPpXm9i6mQkb4wVF8rYpc2dAtbJrXTgFxV8ZG3xKWr4iRevT+m461E6ToFSJLVXQbwV
         iEMEuejQGu7Y602TkvBEu9wjXFBgshdu8fSFqLNfXIrHPiDgBwTBuq+UMjlVOS/VjPa1
         SwreIV6OTW+6Q5NNevnIAnOSxMl1X45/JLfdfG9vs2JqiptSkkm4Uee5oubG/YIJMTeS
         90bz9lFTqtiL98Xpng9HqipuFivQfBKa8DJAuMig48wIE6BIv954uZq1h7o60+5TeUJ8
         H/UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vfnMx6/ZkVtuDtw0ciVv336EcMYRTKWQaVjz13KGQBA=;
        b=KZ2B+glXz0WGJ+gnwDkwg36XW/DX2SNDLIz3dcjm8zyJ6iZqGtE2L4e0K/Yk2c+OOq
         Lg8cTk8yxGg6mP10erUMocb11bFM05O42F9qYN5sD+8jW1t29km83LkfQcjkMv3FAACK
         SlVzri2kRLcGEYJUEv/eAxHHIoSMuaMJFQs1LKp5kfh+/BfFCwz/scyqlzRX3za9BhLk
         wC4/fsl5SXAGCSBsUdQDpOqA90/zBzkiWo+LkyCzAVIzOxlqAXtLVbSEDGNVpQE4V1iQ
         SyytxK3idqP25PM+ovkuNeY3j3LNnDnN10WFI9LSpOLyMt51qduJmSnTibr0n8q1bGrp
         FLlA==
X-Gm-Message-State: AOAM533OFLxrLfLUxF7XlqSlkksZQkeELVtjv3jz3ZeNQpoI82OUywWM
        aIOc+nNpylJC7t5X5wkkSL1uBA==
X-Google-Smtp-Source: ABdhPJx2420HovtN/qRonmRPoIm+EcUaptic2C/wU9XyGpKIwbM4srVXzeKyGuud0ZGiopeZxd9HCw==
X-Received: by 2002:a05:6512:3d8a:: with SMTP id k10mr3570387lfv.473.1622829265214;
        Fri, 04 Jun 2021 10:54:25 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id n15sm670569lft.169.2021.06.04.10.54.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 10:54:24 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id ECFB41027A9; Fri,  4 Jun 2021 20:54:36 +0300 (+03)
Date:   Fri, 4 Jun 2021 20:54:36 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Steve Rutherford <srutherford@google.com>,
        Peter Gonda <pgonda@google.com>,
        David Hildenbrand <david@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFCv2 13/13] KVM: unmap guest memory using poisoned pages
Message-ID: <20210604175436.ltlvlzxoakzqe2zu@box.shutemov.name>
References: <20210419142602.khjbzktk5tk5l6lk@box.shutemov.name>
 <YH2pam5b837wFM3z@google.com>
 <20210419164027.dqiptkebhdt5cfmy@box.shutemov.name>
 <YH3HWeOXFiCTZN4y@google.com>
 <20210419185354.v3rgandtrel7bzjj@box>
 <YH3jaf5ThzLZdY4K@google.com>
 <20210419225755.nsrtjfvfcqscyb6m@box.shutemov.name>
 <YH8L0ihIzL6UB6qD@google.com>
 <20210521123148.a3t4uh4iezm6ax47@box>
 <b367e721-d613-c171-20e7-fe9ea096e411@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b367e721-d613-c171-20e7-fe9ea096e411@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 04, 2021 at 10:16:49AM -0700, Andy Lutomirski wrote:
> On 5/21/21 5:31 AM, Kirill A. Shutemov wrote:
> > Hi Sean,
> > 
> > The core patch of the approach we've discussed before is below. It
> > introduce a new page type with the required semantics.
> > 
> > The full patchset can be found here:
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git kvm-unmapped-guest-only
> > 
> > but only the patch below is relevant for TDX. QEMU patch is attached.
> > 
> > CONFIG_HAVE_KVM_PROTECTED_MEMORY has to be changed to what is appropriate
> > for TDX and FOLL_GUEST has to be used in hva_to_pfn_slow() when running
> > TDX guest.
> > 
> > When page get inserted into private sept we must make sure it is
> > PageGuest() or SIGBUS otherwise. Inserting PageGuest() into shared is
> > fine, but the page will not be accessible from userspace.
> 
> I may have missed a detail, and I think Sean almost said this, but:
> 
> I don't think that a single bit like this is sufficient.  A KVM host can
> contain more than one TDX guest, and, to reliably avoid machine checks,
> I think we need to make sure that secure pages are only ever mapped into
> the guest to which they belong, as well as to the right GPA.  If a KVM
> user host process creates a PageGuest page, what stops it from being
> mapped into two different guests?  The refcount?

TDX module ensures that a pfn can only be used once as private memory.

> After contemplating this a bit, I have a somewhat different suggestion,
> at least for TDX.  In TDX, a guest logically has two entirely separate
> physical address spaces: the secure address space and the shared address
> space.  They are managed separately, they have different contents, etc.
> Normally one would expect a given numerical address (with the secure
> selector bit masked off) to only exist in one of the two spaces, but
> nothing in the architecture fundamentally requires this.  And switching
> a page between the secure and shared states is a heavyweight operation.
> 
> So what if KVM actually treated them completely separately?  The secure
> address space doesn't have any of the complex properties that the shared
> address space has.  There are no paravirt pages there, no KSM pages
> there, no forked pages there, no MAP_ANONYMOUS pages there, no MMIO
> pages there, etc.  There could be a KVM API to allocate and deallocate a
> secure page, and that would be it.
> 
> This could be inefficient if a guest does a bunch of MapGPA calls and
> makes the shared address space highly sparse.  That could potentially be
> mitigated by allowing a (shared) user memory region to come with a
> bitmap of which pages are actually mapped.  Pages in the unmapped areas
> are holes, and KVM won't look through to the QEMU page tables.
> 
> Does this make any sense?  It would completely eliminate all this
> PageGuest stuff -- a secure page would be backed by a *kernel*
> allocation (potentially a pageable allocation a la tmpfs if TDX ever
> learns how to swap, but that's no currently possible nor would it be
> user visible), so the kernel can straightforwardly guarantee that user
> pagetables will not contain references to secure pages and that GUP will
> not be called on them.

It doesn't fit in KVM design AFAICS: userspace own guest memory mapping.

And it's not future-proof: the private memory has to be subject of Linux
memory management in the future. For instance, it should be possible to
migrate such memory. Having the memory hiden within kernel makes it
difficult: existing API is not suitable to handle it.

> I'm not sure how this would map to SEV.  Certainly, with some degree of
> host vs guest cooperation, SEV could work the same way, and the
> migration support is pushing SEV in that direction.

-- 
 Kirill A. Shutemov
