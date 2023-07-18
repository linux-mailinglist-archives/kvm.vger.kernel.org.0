Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2037584C6
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 20:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjGRS3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 14:29:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjGRS3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 14:29:30 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B0BDA
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 11:29:29 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id d2e1a72fcca58-666ecf9a081so6037594b3a.2
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 11:29:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1689704969; x=1692296969;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S7o51YlRNS3zPl1LsUYTJR0KoGseri+clhYp1sqA+7o=;
        b=i3PLfLk9r7NY7Uevj6PA3cYqDyv4GmY8ZTpAyOTEMVm18YLHoILcZ61oG+F9iFTHtV
         OX8jgLzmPYLYjT5nTvuf48EZuGhjT3nXDpUtIzZoLmFT/vwScgj8TKUey6e+GcVODdO/
         aR6/yFWorh49MLpPBPS4KJKiFuCN20/QPxl/yYbUzWAditSFcUD4YBXKid/OyWwMGSU4
         hTdhkYgK99mIeIotW/7zP2M7qvX9TABdVEY82e39977TCXOnZTAAMs6Q2HmEVszoN4iv
         VRVVMQY0DZtRHIz7VWFEh8j8Dqyv1YGRYWzfSCH0PzDWSbsFyOPnQYwqfHvs+eC+iMQF
         VveA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689704969; x=1692296969;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S7o51YlRNS3zPl1LsUYTJR0KoGseri+clhYp1sqA+7o=;
        b=WEEK/KSdlak1MnafND5zvkOJk2RBnoD6cTnqCgSQ83LBZ0o5R7RNrnbcrHTqZqNLG8
         CIzaVKnrh0AS4avZemDFHtZp7mWcGSYEzF6Zi0w068HL0MIPMo9K2+Su7GUqDxlA0p0o
         rVBtRmh0ZzMvlbsm47B9TjNhVBqmJxSCtTpkAE+Nfy7OG/cH3Fan/GTxpp4ErB9iNR84
         j25bhFb9RfcVakUY0neqmHyCmIPHxttt1DEHwTkOKfD1mvQCNTj0JglBxtJYWCgY/6kb
         /kfs5cV4Giuvh+BdZpGniCMjE3D1IfHYd8eGMFQvly+Hp7B5ZxJloyJPTcM2of/pnOeR
         H64A==
X-Gm-Message-State: ABy/qLZ+LNUBfwvW0Yqja+bnGVANUWFNRJ94O9iJvWpuXjvGKd31FmD7
        RIglPDF9yisQ9k2mbc/2agFy1Q==
X-Google-Smtp-Source: APBJJlGRXuPRhwkyVNmCMc2KhNqjSUeDWEj142071UHQ2p4xg0uemtxHiHrQn61P1ux7F7gEcQuZIA==
X-Received: by 2002:a05:6a00:3a1d:b0:668:8705:57cf with SMTP id fj29-20020a056a003a1d00b00668870557cfmr19016531pfb.25.1689704968961;
        Tue, 18 Jul 2023 11:29:28 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id u21-20020aa78395000000b0065434edd521sm1797726pfm.196.2023.07.18.11.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 11:29:28 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qLpRu-002ayW-Jq;
        Tue, 18 Jul 2023 15:29:26 -0300
Date:   Tue, 18 Jul 2023 15:29:26 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alistair Popple <apopple@nvidia.com>, ajd@linux.ibm.com,
        catalin.marinas@arm.com, fbarrat@linux.ibm.com,
        iommu@lists.linux.dev, jhubbard@nvidia.com, kevin.tian@intel.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au,
        nicolinc@nvidia.com, npiggin@gmail.com, robin.murphy@arm.com,
        seanjc@google.com, will@kernel.org, x86@kernel.org,
        zhi.wang.linux@gmail.com
Subject: Re: [PATCH 3/4] mmu_notifiers: Call arch_invalidate_secondary_tlbs()
 when invalidating TLBs
Message-ID: <ZLbaBpfaAqigFzIT@ziepe.ca>
References: <cover.b4454f7f3d0afbfe1965e8026823cd50a42954b4.1689666760.git-series.apopple@nvidia.com>
 <791a6c1c4a79de6f99bffc594b53a39a6234e87f.1689666760.git-series.apopple@nvidia.com>
 <20230718111759.5642b4c4ffd72ddd9c8aa29f@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230718111759.5642b4c4ffd72ddd9c8aa29f@linux-foundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 18, 2023 at 11:17:59AM -0700, Andrew Morton wrote:
> On Tue, 18 Jul 2023 17:56:17 +1000 Alistair Popple <apopple@nvidia.com> wrote:
> 
> > The arch_invalidate_secondary_tlbs() is an architecture specific mmu
> > notifier used to keep the TLB of secondary MMUs such as an IOMMU in
> > sync with the CPU page tables. Currently it is called from separate
> > code paths to the main CPU TLB invalidations. This can lead to a
> > secondary TLB not getting invalidated when required and makes it hard
> > to reason about when exactly the secondary TLB is invalidated.
> > 
> > To fix this move the notifier call to the architecture specific TLB
> > maintenance functions for architectures that have secondary MMUs
> > requiring explicit software invalidations.
> > 
> > This fixes a SMMU bug on ARM64. On ARM64 PTE permission upgrades
> > require a TLB invalidation. This invalidation is done by the
> > architecutre specific ptep_set_access_flags() which calls
> > flush_tlb_page() if required. However this doesn't call the notifier
> > resulting in infinite faults being generated by devices using the SMMU
> > if it has previously cached a read-only PTE in it's TLB.
> 
> This sounds like a pretty serious bug.  Can it happen in current
> released kernels?  If so, is a -stable backport needed?

There are currently no in-kernel drivers using the IOMMU SVA API, so
the impact for -stable is sort of muted. But it is serious if you are
unlucky to hit it.

Jason
