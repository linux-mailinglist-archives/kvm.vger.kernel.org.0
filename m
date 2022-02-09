Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978984AE8C7
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 06:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239825AbiBIFHm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 00:07:42 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242647AbiBIEwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 23:52:02 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14893C0613CA
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 20:52:04 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id i21so755575pfd.13
        for <kvm@vger.kernel.org>; Tue, 08 Feb 2022 20:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PR9huqMPKoKBRfN5n+K9Fdcj8rjbPiaTb5ftDSq6ZW8=;
        b=tQaAa/Eoya61ibJVdVxszqGG/UfmlZZiGR7xPsfkCDCEkdWlPtzGXjJApJX5e+FU9+
         wmn39wUvZIjraVZ+MZFPURdjeDgkcL2Ky+XpOYKD90Qr2JSLE4h7QDc8WD8aboPNBK4z
         74YHsm0O699dnj3zabAnBzANeZ0MyIJAj140UZqIxCqL5aOnbKkBgiAQ40c+6rjuzah7
         Mih047zYSw7TfkZGwqxqvV7SeHajB7IsYZRetsE9/ZBa+GFsdGgdPyQyoxkbvYKat+jh
         OqHjGLs+zpREYER9xZHySaCZ1+bLpAFxt3vfiHtS2RL3UtVB/y9BrkN58Kh1nsUx25hr
         mbzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PR9huqMPKoKBRfN5n+K9Fdcj8rjbPiaTb5ftDSq6ZW8=;
        b=6dXQG8B336B/gBlePu1T92aFIvxQmrt2koDbroFKjCAzr+fHNAe7PIv6VT3Lis/pA1
         I7VOWoTavqczKk2CUo9Q9uo/yLaRECSalUyO63aFtDpJgM5mO08PNudirN715oYWiZXp
         sKJfPFC33FP8v1y83aALXyK1sXhj4EoHMSWfhXrMEp1OJfW5QVXMi7Zrx7o/3P3eXHiH
         GcYTYpVIK55L52EgCIa4ugHn53CuKUxGoC82gWptTV7C/azz2/HJjrbVF+1sFRV7S6mW
         YUJfGbnlLDRh4vtawtK3FwFqRD0aEMfS5oNkYnwgND70YYi/ZsOBh9REEDNq/SmcEBmY
         5Uhw==
X-Gm-Message-State: AOAM533zdQJKwxkofEEGgc2u9ge2gcq/Y0AFMiRxmHSPqVlCxj44O1RE
        n0H8CZBWy290z/cPbRNZvudEnChkWgDBNFIPHFDylg==
X-Google-Smtp-Source: ABdhPJyJlqEofZ7FNvhCVWK/Fj3kLxyOD4l5cf2Tx4Vqf1uOnZGRpCs5oYUnLgprJaxq8w4j07PtbuNWc1rPBvp8/4I=
X-Received: by 2002:a63:2b4d:: with SMTP id r74mr547546pgr.514.1644382323360;
 Tue, 08 Feb 2022 20:52:03 -0800 (PST)
MIME-Version: 1.0
References: <20220106042708.2869332-1-reijiw@google.com> <20220106042708.2869332-24-reijiw@google.com>
 <CA+EHjTxYqPvyUz96hoJWe43raST1X7oKhdR7PeZDuwuuD9QcYQ@mail.gmail.com> <CAAeT=FxKgH_a7vthT3ai_TiCu9UCj+PNJ6SarHDF+R5tcR--Dg@mail.gmail.com>
In-Reply-To: <CAAeT=FxKgH_a7vthT3ai_TiCu9UCj+PNJ6SarHDF+R5tcR--Dg@mail.gmail.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 8 Feb 2022 20:51:47 -0800
Message-ID: <CAAeT=Fz5noen=eFJZVAsRdzJY98Gno27U4kv_sLDBHXY_ZVKRA@mail.gmail.com>
Subject: Re: [RFC PATCH v4 23/26] KVM: arm64: Trap disabled features of ID_AA64MMFR1_EL1
To:     Fuad Tabba <tabba@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
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

Hi Fuad,

> > The series might be missing an entry for ID_AA64MMFR0_EL1, Debug
> > Communications Channel registers, ID_AA64MMFR0_FGT -> MDCR_EL2_TDCC.

Looking at Arm ARM, it appears any of the registers that can be
trapped by MDCR_EL2_TDCC are present even when FEAT_FGT is not
implemented (I understand MDCR_EL2_TDCC is available when FEAT_FGT
is implemented though).  So, this is not something that the
framework is trying to address.

Thanks,
Reiji

>
> I will add them in v5 series.
> Thank you so much for all the review comments!
>
> Thanks,
> Reiji
>
>
> >
> > Cheers,
> > /fuad
