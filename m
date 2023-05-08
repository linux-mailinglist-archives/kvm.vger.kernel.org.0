Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 401EA6FB238
	for <lists+kvm@lfdr.de>; Mon,  8 May 2023 16:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbjEHOFw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 10:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234411AbjEHOFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 10:05:48 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90F1238F28
        for <kvm@vger.kernel.org>; Mon,  8 May 2023 07:05:40 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b9a6eeea78cso34288138276.0
        for <kvm@vger.kernel.org>; Mon, 08 May 2023 07:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683554739; x=1686146739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jcl8cYiE8GBONZ/kHylHxTzdCz6iJZwPGQYSWy24JYA=;
        b=o8mfj/R750kMfA2bvKpyJZuf/ZhVeSnXBF4/wapKjmLIWy2rqeeSrAOt5X+YjYxuNh
         OyItG8a6SQBaYR3ol78KhlI6eh/Q0yN90HXJhxbVGAtpEUWsNrYhxsckDEtq7PX0t1EO
         f0JB4uXPde4Ox7tQXsrWT/ya3dTEG/JI0bIE5xqIVrID3KZMsDfqqnqBT9Za2r4APAZX
         B2RpVJzivT+iO2b+LbU+0Zontf8zI/Ed9ngpy3ey89L83c7xn7vHODjkZU8knTdQD3t/
         n78u+Am85L+2PUzMWncpwoOAYV0GlSklrJfhHVJlIR1I82Kkd1Qrpj4q6M6s9sph6PlJ
         aA7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683554739; x=1686146739;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jcl8cYiE8GBONZ/kHylHxTzdCz6iJZwPGQYSWy24JYA=;
        b=jAxM/jjfaOcfItfG9It7XA8rFj1cdxAWxDnU1M2/54xhxQmgUsIJgXLZPRTcfEe3vx
         Yi/0hspXAVjdr0n/2nUA8QxLmbBIKtpGad+0peu8+80n0R/jDKNOsDRL4GAJFdjzXoW+
         bdATAd1DGJOC9Qiz2PfQO41e/7lPfBFILgQ3BCLBPfe/3yK7sKHW4CXdP7LvCuyvXl1v
         +ev842ooVSqrg2rwZ/dWjE3lZDt6xDTF5XzCo/+daScdwWBI9PpEC2xnOK6LzCoc0ETQ
         u4Zp9aVDg3ymMAxBSOp8Aa5by0eCETD9Mnl18XZ4U0hDJERZ3N48jNmmcd0+y1x6bsLk
         aT3g==
X-Gm-Message-State: AC+VfDyNosus1bCW/tcumeGmC1aieVvpFpNwNAToVamZyQsh6BX+wufw
        c+LxreFkHj/lKj1vZVXSEDuUVM4dRls=
X-Google-Smtp-Source: ACHHUZ7FCpMclh8b9aJYyQEcgnuYE0OwetS8XqokoS1TJPz66KwW2xxY/XhdC86wb/WWcOzl5JiJiPlwO6k=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:10c:b0:55c:a5db:869 with SMTP id
 bd12-20020a05690c010c00b0055ca5db0869mr10528119ywb.4.1683554739792; Mon, 08
 May 2023 07:05:39 -0700 (PDT)
Date:   Mon, 8 May 2023 07:05:32 -0700
In-Reply-To: <ZFYyt2fF6alyKlzO@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com> <20230311002258.852397-6-seanjc@google.com>
 <ZBP7oZ1lkJhlSNpY@yzhao56-desk.sh.intel.com> <ZFQYbHTYgG4HJ+ac@google.com>
 <ZFX1PaKIa44WtSNX@yzhao56-desk.sh.intel.com> <ZFYyt2fF6alyKlzO@yzhao56-desk.sh.intel.com>
Message-ID: <ZFkBrLuBY5fOU6qX@google.com>
Subject: Re: [PATCH v2 05/27] drm/i915/gvt: Verify VFIO-pinned page is THP
 when shadowing 2M gtt entry
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Zhi Wang <zhi.a.wang@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, May 06, 2023, Yan Zhao wrote:
> On Sat, May 06, 2023 at 02:35:41PM +0800, Yan Zhao wrote:
> > > > Maybe the checking of PageTransHuge(cur_page) and bailing out is not necessary.
> > > > If a page is not transparent huge, but there are 512 contigous 4K
> > > > pages, I think it's still good to map them in IOMMU in 2M.
> > > > See vfio_pin_map_dma() who does similar things.
> > > 
> > > I agree that bailing isn't strictly necessary, and processing "blindly" should
> > > Just Work for HugeTLB and other hugepage types.  I was going to argue that it
> > > would be safer to add this and then drop it at the end, but I think that's a
> > > specious argument.  If not checking the page type is unsafe, then the existing
> > > code is buggy, and this changelog literally states that the check for contiguous
> > > pages guards against any such problems.
> > > 
> > > I do think there's a (very, very theoretical) issue though.  For "CONFIG_SPARSEMEM=y
> > > && CONFIG_SPARSEMEM_VMEMMAP=n", struct pages aren't virtually contiguous with respect
> > > to their pfns, i.e. it's possible (again, very theoretically) that two struct pages
> > > could be virtually contiguous but physically discontiguous.  I suspect I'm being
> > > ridiculously paranoid, but for the efficient cases where pages are guaranteed to
> > > be contiguous, the extra page_to_pfn() checks should be optimized away by the
> > > compiler, i.e. there's no meaningful downside to the paranoia.
> > To make sure I understand it correctly:
> > There are 3 conditions:
> > (1) Two struct pages aren't virtually contiguous, but there PFNs are contiguous.
> > (2) Two struct pages are virtually contiguous but their PFNs aren't contiguous.
> >     (Looks this will not happen?)
> > (3) Two struct pages are virtually contiguous, and their PFNs are contiguous, too.
> >     But they have different backends, e.g.
> >     PFN 1 and PFN 2 are contiguous, while PFN 1 belongs to RAM, and PFN 2
> >     belongs to DEVMEM.
> > 
> > I think you mean condition (3) is problematic, am I right?
> Oh, I got it now.
> You are saying about condition (2), with "CONFIG_SPARSEMEM=y &&
> CONFIG_SPARSEMEM_VMEMMAP=n".
> Two struct pages are contiguous if one is at one section's tail and another at
> another section's head, but the two sections aren't for contiguous PFNs.

Yep, exactly.
