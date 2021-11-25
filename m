Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D5B45D45D
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 06:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239227AbhKYFix (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 00:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244237AbhKYFgx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 00:36:53 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28E1C061746
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 21:33:42 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so4767596pjb.5
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 21:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F9g4xULBwZ+ZoDl9tIJMXCBnfTmSTJxIQ0HNhTAXC/I=;
        b=fb+3v4ffk4g5s+KvWydS5QdlR+7lURUkJlUA0vsYZyVV/03IP1SYtTmmVO3PLOU7PZ
         3HZkI9Evg/ca6OsxRLiP6FEPNyc6dFCgzCRrQfcDcd2EQrLuDcIv3+MXP2i1nQg4IFJ8
         iQ23tGUl8ZF76E8CNCXakDy//DCeYfRHz9TLeGtge+717P6PSWw3imuSdk3C71ripq/Z
         Q+VuSlKfNud7ln5leGQt920UtvwW7/sW4a++aRP+SYtEsmSilbwDLI5o/Xnz7ySE0die
         UYop0U6tXfzBnX1ghJcRfJuo9tvpKFA8OUNqYQZ56dRTl03CUlLc18RwGhR6Z+j0PGwB
         DvKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F9g4xULBwZ+ZoDl9tIJMXCBnfTmSTJxIQ0HNhTAXC/I=;
        b=G2XUctNSG3daK8Vo/WXG18IQm0UujrYUkyKhCTERiTefAR3rRBgKamSKh8KD9pQd26
         Jy/v+sXXqkzQr88dtuN0CE1e0IMB91h0Q1lShR3lUaT4nwE/+8IQgsZCu0yEk0PLTMrx
         WdYfefGpZuMml4OstMSmCMyaBh4xpEftKIQ593jCS8arRbYM1YieaepQ63fwcQDhNxuS
         iDu8jawKuA9l+A2YG2eNq3gAX2cH4Yb207RMq0/iJDVdhlnEi1aMwl4c6tU0d7OVzOWT
         IYJ7acVrfptGldqY4/HP/HdPe4FFfhjhuW31W7FTDSjDngynnqh5JASHrVJt/DxTLqW5
         DjsQ==
X-Gm-Message-State: AOAM533MxrW1WPcoubON4ctOBiNUMZ3nKGax/YVixM79a9EP04pFOVIF
        ON6984+vmBvSZjSqG0fv9hojqv8uYS2FEVLPjE33ZQ==
X-Google-Smtp-Source: ABdhPJxSwEoay0qQlzFoarAjVDlXI8Nd+iv7hTVgKv5MYQhPEnhjw+KnkNvlyZ+hMZ/rE7RdtbS4YCNKfxNC8WoF4ik=
X-Received: by 2002:a17:902:ab47:b0:141:95b2:7eaf with SMTP id
 ij7-20020a170902ab4700b0014195b27eafmr26064371plb.40.1637818422185; Wed, 24
 Nov 2021 21:33:42 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <20211117064359.2362060-12-reijiw@google.com>
 <cda3eb28-1cf6-da6e-1769-104c29f81d4a@redhat.com>
In-Reply-To: <cda3eb28-1cf6-da6e-1769-104c29f81d4a@redhat.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 24 Nov 2021 21:33:26 -0800
Message-ID: <CAAeT=Fz1vCJhypbiUbSkMGhf3mmn9gyaSJgXYETrBD0zyyHeSg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 11/29] KVM: arm64: Make ID_DFR0_EL1 writable
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

On Wed, Nov 24, 2021 at 5:46 AM Eric Auger <eauger@redhat.com> wrote:
>
> Hi Reiji,
>
> On 11/17/21 7:43 AM, Reiji Watanabe wrote:
> > This patch adds id_reg_info for ID_DFR0_EL1 to make it writable
> > by userspace.
> >
> > Return an error if userspace tries to set PerfMon field of the
> > register to a value that conflicts with the PMU configuration.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 52 ++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 46 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 0faf458b0efb..fbd335ac5e6b 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -665,6 +665,27 @@ static int validate_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> >       return 0;
> >  }
> >
> > +static int validate_id_dfr0_el1(struct kvm_vcpu *vcpu,
> > +                             const struct id_reg_info *id_reg, u64 val)
> > +{
> > +     bool vcpu_pmu, dfr0_pmu;
> > +     unsigned int perfmon;
> > +
> > +     perfmon = cpuid_feature_extract_unsigned_field(val, ID_DFR0_PERFMON_SHIFT);
> > +     if (perfmon == 1 || perfmon == 2)
> > +             /* PMUv1 or PMUv2 is not allowed on ARMv8. */
> > +             return -EINVAL;
> > +
> > +     vcpu_pmu = kvm_vcpu_has_pmu(vcpu);
> > +     dfr0_pmu = id_reg_has_pmu(val, ID_DFR0_PERFMON_SHIFT, ID_DFR0_PERFMON_8_0);
> > +
> > +     /* Check if there is a conflict with a request via KVM_ARM_VCPU_INIT */
> > +     if (vcpu_pmu ^ dfr0_pmu)
> > +             return -EPERM;
> This breaks the migration on ThunderX v2 as vcpu_pmu == true and
> dfr0_pmu == false

Yes, this is the same (incorrect) assumption as the selftest.
I will fix this as well.

Regards,
Reiji
