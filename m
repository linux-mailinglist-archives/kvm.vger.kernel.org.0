Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90E9C32C690
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355504AbhCDA3O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:29:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345098AbhCCQse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Mar 2021 11:48:34 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99912C061760
        for <kvm@vger.kernel.org>; Wed,  3 Mar 2021 08:47:07 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id t9so4492740pjl.5
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 08:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=quBPDIsZ4Pg/fHm1dZ2YOsP83yrlR5G0gmwAov0iPyo=;
        b=nfnyTmPdcBN35cVH4mQoqKGQwKxUIU+7bFPPpRTO/bfdltKL1RD81f4xmocbhz/sHy
         ukGt1KfjKrIK3SD/vETYWTLmLsFk5wdrsbenp+/QiTwEvJj8dBcXxyaGwsBiSJ+f3Su4
         CSvnmbzeeCsAedpiEBYNKTTRJH1JIcs6lEoreSCCdmtHKHpUwW84yAf4otQCfxdiwDBk
         Bg2MiLTEDe+yKxI9r+U+0WJ15+GgklyS8cLL8yv6nDGt4xm6SePOB5U3ePru+ZRSmgU4
         z6/yT7Da/3gvHycP89VebSJps7CUECkgtkdV6ckfDkpMEs/NYj43P1MxBmYb9MCpWOCB
         ep3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=quBPDIsZ4Pg/fHm1dZ2YOsP83yrlR5G0gmwAov0iPyo=;
        b=jP3XTe1GVGSurBIKz1+hRMERlNS2ftHfYdqmxaA0Xb1KM2+VNIKGfwcb+aM5w+y+3v
         4FFkQl6x91+TteJUQ5Sqx0JsnLHzcNyqD5DTuhDZlvu9AgH2AvEZZD8jVdnhXULafRGv
         6o//WqvFSNhdB9EgYpbmXO8vwfu0HO7OcGZdtanlIJmqCQRXavdv2/THEvyNJPeXavt+
         D0NmMn03evjpQBYxIxHh4BqvKejuaRBz9D0FJ6E9DoVZTyu7mqcC+r7ERG9AO2orFJfm
         6WM5FlLgCX8wVluiDYPEq2A4DDG+PGkYw7NKzSL6JWQHKdcdkSog6glMY0CUIdBOQ0gu
         AbVQ==
X-Gm-Message-State: AOAM5305n3uEfZ/oXALihyWRvZRgwhItxfMezmq2groqOpWkyxIGuNcx
        oCd5amLkA3j1sxZ++HiimX60sQ==
X-Google-Smtp-Source: ABdhPJzfAf5L6Yvs7GUoW/T2RWwJONBtnku3HRK5pysZy15dBYKacthlXUZTDpbKT9JIpvcwi1FyMQ==
X-Received: by 2002:a17:902:464:b029:e2:ebb4:9251 with SMTP id 91-20020a1709020464b02900e2ebb49251mr3407638ple.29.1614790026969;
        Wed, 03 Mar 2021 08:47:06 -0800 (PST)
Received: from google.com ([2620:15c:f:10:805d:6324:3372:6183])
        by smtp.gmail.com with ESMTPSA id u17sm32036pgl.80.2021.03.03.08.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 08:47:06 -0800 (PST)
Date:   Wed, 3 Mar 2021 08:46:59 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 03/15] KVM: x86/mmu: Ensure MMU pages are available when
 allocating roots
Message-ID: <YD+9gwhfFCS7Xghe@google.com>
References: <20210302184540.2829328-1-seanjc@google.com>
 <20210302184540.2829328-4-seanjc@google.com>
 <CANgfPd95G-01ObzeKeMTUu0yXBJ=0+ZGQwr_5WCNH-NmR03f9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd95G-01ObzeKeMTUu0yXBJ=0+ZGQwr_5WCNH-NmR03f9w@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 02, 2021, Ben Gardon wrote:
> > @@ -3241,16 +3237,10 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
> >
> >         if (is_tdp_mmu_enabled(vcpu->kvm)) {
> >                 root = kvm_tdp_mmu_get_vcpu_root_hpa(vcpu);
> > -
> > -               if (!VALID_PAGE(root))
> > -                       return -ENOSPC;
> >                 vcpu->arch.mmu->root_hpa = root;
> >         } else if (shadow_root_level >= PT64_ROOT_4LEVEL) {
> >                 root = mmu_alloc_root(vcpu, 0, 0, shadow_root_level,
> >                                       true);
> > -
> > -               if (!VALID_PAGE(root))
> > -                       return -ENOSPC;
> 
> There's so much going on in mmu_alloc_root that removing this check
> makes me nervous, but I think it should be safe.

Just think of it as a variant of kvm_mmu_get_page(), then all your fears will
melt away. ;-)

> I checked though the function because I was worried it might yield
> somewhere in there, which could result in the page cache being emptied
> and the allocation failing, but I don't think mmu_alloc_root this
> function will yield.

Ugh, mmu_alloc_root() won't yield, but get_zeroed_page() used to allocate pae_root
and lm_root on-demand in mmu_alloc_shadow_roots() will.  The two options are
(a) allocate the fake roots before taking the lock and (b) allocate them from
vcpu->arch.mmu_shadow_page_cache.  I probably prefer (a).  (b) will slide
directly into the existing code, but would require bumping the min number of
objects for mmu_shadow_page_cache in mmu_topup_memory_caches().  I'd prefer not
to have yet more code that has to deal with this insanity.
