Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E96F5B665E
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 06:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbiIMELP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 00:11:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiIMELN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 00:11:13 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91D6C40E22
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 21:11:12 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id k9so18794155wri.0
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 21:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=CVbSa+/qoRHiRq48IgUS3irpZOjrJDEoYacMrNQAtOE=;
        b=duGTUBwr7IU1If9T6F9LAshp5l73d5fJ2R+vTkprg/tyemXx34dXvA88VvFZyHTyQV
         OU4kwDzMCnE8C2bPP8wNvZaseK7PfgYr2JKAnJfndUKXxG08+EzAr2kMl8ALl1PKs+ZD
         +cU0j1JloAUNmi9IEV/oByNE4fSEiLydbPjqHmfFFdxAnbBellfWTw6ABnaZav8Qu05N
         BCtKCViC4JngjL1jOevVvHhjvFUZqauiTwvq6itbHgECYm1CqDx9tOvQGXKfLy4lB+WG
         k+wYZZ2RGqbuRLqA8W9grIAOP6Zr8h/ahClTUNYHpkbeabfw69y8XAo/xCxvaait17OH
         40Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=CVbSa+/qoRHiRq48IgUS3irpZOjrJDEoYacMrNQAtOE=;
        b=Bt2/wTWMhv4JjZoPlFN9TsfmTCPfXbOtKbF5qwvA95Y3dSv6dOsfKGJcIF/tGAdFJr
         ExAHQJNix0NXowKZeKuNPUB2t+J6u1JfzsyejS9nXgKKq8mPyBVf2ToErKZskD+fOFUD
         xREmC04sXU85J407HcsYWSnFxv1iySP8FliRdTsrs3iPnixDhGe0ivEjvIbIFFbgA/zP
         PHftGpmF5GqzNal168m9huUBApzSTQ/6gsuje/7azf12ZT2gzMQE4oDEx8BMazamy50d
         LEXcN28Fm6XOJeq4VdNQKXWuNvo5MjTSo/LkU7ukvctgf0KFVSePhe1kUnvgzrFrGQGm
         QXbQ==
X-Gm-Message-State: ACgBeo1ykqOCQezja8EP2SWqlOJpJwMwNKq6P0pZaNDfilVIG6jYrmVy
        lquIYWQTY8wwJ57qKXXX9rp78EMSYpWB2qyOABj5UA==
X-Google-Smtp-Source: AA6agR5gH2VCKDnM+Ue9zmgPKtM7MNJrX54DRWkE+hNVUsK6TWIw8+oDlVQ2ylRk9OAf5b10MjfzYxGJzELYkEt7dTw=
X-Received: by 2002:adf:f54a:0:b0:228:951a:2949 with SMTP id
 j10-20020adff54a000000b00228951a2949mr16641246wrp.240.1663042271021; Mon, 12
 Sep 2022 21:11:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220810193033.1090251-1-pcc@google.com> <20220810193033.1090251-7-pcc@google.com>
 <874jxcv9xn.wl-maz@kernel.org>
In-Reply-To: <874jxcv9xn.wl-maz@kernel.org>
From:   Peter Collingbourne <pcc@google.com>
Date:   Mon, 12 Sep 2022 21:10:59 -0700
Message-ID: <CAMn1gO6ZHrQkkYOaicDftUbRSYgngUa4bPKFTLk_q0qxuGz6Zw@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] KVM: arm64: permit all VM_MTE_ALLOWED mappings
 with MTE enabled
To:     Marc Zyngier <maz@kernel.org>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvmarm@lists.cs.columbia.edu, Cornelia Huck <cohuck@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 12, 2022 at 9:23 AM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 10 Aug 2022 20:30:32 +0100,
> Peter Collingbourne <pcc@google.com> wrote:
> >
> > Certain VMMs such as crosvm have features (e.g. sandboxing) that depend
> > on being able to map guest memory as MAP_SHARED. The current restriction
> > on sharing MAP_SHARED pages with the guest is preventing the use of
> > those features with MTE. Now that the races between tasks concurrently
> > clearing tags on the same page have been fixed, remove this restriction.
> >
> > Signed-off-by: Peter Collingbourne <pcc@google.com>
> > ---
> >  arch/arm64/kvm/mmu.c | 8 --------
> >  1 file changed, 8 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> > index d54be80e31dd..fc65dc20655d 100644
> > --- a/arch/arm64/kvm/mmu.c
> > +++ b/arch/arm64/kvm/mmu.c
> > @@ -1075,14 +1075,6 @@ static void sanitise_mte_tags(struct kvm *kvm, kvm_pfn_t pfn,
> >
> >  static bool kvm_vma_mte_allowed(struct vm_area_struct *vma)
> >  {
> > -     /*
> > -      * VM_SHARED mappings are not allowed with MTE to avoid races
> > -      * when updating the PG_mte_tagged page flag, see
> > -      * sanitise_mte_tags for more details.
> > -      */
> > -     if (vma->vm_flags & VM_SHARED)
> > -             return false;
> > -
> >       return vma->vm_flags & VM_MTE_ALLOWED;
> >  }
> >
>
> Can you provide a pointer to some VMM making use of this functionality
> and enabling MTE? A set of crosvm patches (for example) would be
> useful to evaluate this series.

Hi Marc,

I've been using a modified crosvm to test this series. Please find
below a link to the proposed crosvm patches which make use of the
series:
https://chromium-review.googlesource.com/c/crosvm/crosvm/+/3892141

Peter
