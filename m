Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4FF462C31
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 06:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238319AbhK3Ffh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 00:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbhK3Ffh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 00:35:37 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC082C061574
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 21:32:18 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id m24so14000686pls.10
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 21:32:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QGmUKm3NhxCjFePG5xO2YhN6YsO3FoC7iXWsjnJHwHo=;
        b=PFdJDx1SbT8kd3PEwcKKljTxVqsslq0DJuyzEOVW3ilQguSRQwcELJjwXCrtM1KNoW
         qGYTXFUZSmHkKmgbn4wYkGekaiwSOn3Vp8mhRyOrWoqs7pZhWc6h4F74KuBpuZyJFBUO
         UG3HidICy3RFanV8sAP6OEiIVVdU7i9rLWUFb76Mld/rb5u90CTqpwH3af+fRSYnvzXM
         /yggRmDPpGDWiNXl9of2CdstKMrNc7wMNEn3J5hHufSI/WUXtSLDgc90XkjxZOJXO9yX
         2haM3H/HedA8EEZanDtIAPhjbxL+KMJROzhpvB8csFGXsNSwhAoDFPK2I3rffG6FIxiM
         Y4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QGmUKm3NhxCjFePG5xO2YhN6YsO3FoC7iXWsjnJHwHo=;
        b=JSe8ggFnDPa1bG7bnaqwbYeDlS6xoAqM2qg5NBjkVAJBXV9LVdTY0JLyICa20Ql6S2
         hCCev0x4bN9VwAAkHz4G37jZnX0was2Xkk+YDj7nOpsOuRiDEwt7iR0GKZyLg42O/2D0
         eP9KhqTRmKwe4I50Re8aKl74E3+J1eVm09XXGzuBqpba0wmVdtIJwaWcfkk0nKny5yOJ
         xP+0fzcg/uotY940o1tq8n4eOgWs44+tjD0folASwBg2iV/slXCMWI6rDqMMPfOyKG5M
         rr8c0UsrYe8A0URyEVkGBEwwls2al+qpiLRwIr7WzMoH/UayFZ5D/Mkuz+45sdBbwYeo
         fiHg==
X-Gm-Message-State: AOAM5308HZfetO5Wp1adU1lLM2/Uwtn1l/+DRfOpjham5i9YVVKGIP9t
        krwP45eU13k1h87oqySO3yT4ZfGpw9pEcG0W+mGwfQ==
X-Google-Smtp-Source: ABdhPJzi7lZO+A4usdDJUDRkuM27dnjVekY7ejDZrKXSvifVE/ZQ5d0WxjFExBKgXMH0ur+dxWW9YAwhhOSI65DoXdg=
X-Received: by 2002:a17:902:ab47:b0:141:95b2:7eaf with SMTP id
 ij7-20020a170902ab4700b0014195b27eafmr64331524plb.40.1638250338059; Mon, 29
 Nov 2021 21:32:18 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-10-reijiw@google.com>
 <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
In-Reply-To: <d09e53a7-b8df-e8fd-c34a-f76a37d664d6@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 29 Nov 2021 21:32:02 -0800
Message-ID: <CAAeT=FzM=sLF=PkY_shhcYmfo+ReGEBN8XX=QQObavXDtwxFJQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 09/29] KVM: arm64: Hide IMPLEMENTATION DEFINED PMU
 support for the guest
To:     Eric Auger <eauger@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
        Peter Shier <pshier@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On Thu, Nov 25, 2021 at 12:30 PM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > When ID_AA64DFR0_EL1.PMUVER or ID_DFR0_EL1.PERFMON is 0xf, which
> > means IMPLEMENTATION DEFINED PMU supported, KVM unconditionally
> > expose the value for the guest as it is.  Since KVM doesn't support
> > IMPLEMENTATION DEFINED PMU for the guest, in that case KVM should
> > exopse 0x0 (PMU is not implemented) instead.
> s/exopse/expose
> >
> > Change cpuid_feature_cap_perfmon_field() to update the field value
> > to 0x0 when it is 0xf.
> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> guest should not use it as a PMUv3?

> is it wrong to expose the guest with a Perfmon value of 0xF? Then the
> guest should not use it as a PMUv3?

For the value 0xf in ID_AA64DFR0_EL1.PMUVER and ID_DFR0_EL1.PERFMON,
Arm ARM says:
  "IMPLEMENTATION DEFINED form of performance monitors supported,
   PMUv3 not supported."

Since the PMU that KVM supports for guests is PMUv3, 0xf shouldn't
be exposed to guests (And this patch series doesn't allow userspace
to set the fields to 0xf for guests).

Thanks,
Reiji

>
> Eric
> >
> > Fixes: 8e35aa642ee4 ("arm64: cpufeature: Extract capped perfmon fields")
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/include/asm/cpufeature.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> > index ef6be92b1921..fd7ad8193827 100644
> > --- a/arch/arm64/include/asm/cpufeature.h
> > +++ b/arch/arm64/include/asm/cpufeature.h
> > @@ -553,7 +553,7 @@ cpuid_feature_cap_perfmon_field(u64 features, int field, u64 cap)
> >
> >       /* Treat IMPLEMENTATION DEFINED functionality as unimplemented */
> >       if (val == ID_AA64DFR0_PMUVER_IMP_DEF)
> > -             val = 0;
> > +             return (features & ~mask);
> >
> >       if (val > cap) {
> >               features &= ~mask;
> >
>
