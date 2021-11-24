Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D702045CA7F
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 18:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240995AbhKXREK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 12:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233492AbhKXREG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 12:04:06 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81FAC061574
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 09:00:56 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id p18so2332231plf.13
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 09:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ccD0ntUVVYkwYlyadNBt1sjxaVIrP/hx7EjWxQNG1N8=;
        b=GOWk964Yosu4ck30FptZ70D1KfKid+USBLbkj8qHTGA21vV6GE7GYqSTOdM2HFjGeW
         2SxyiSkj0+IfbN3/2320KZDe3R7YEgaSwjdsvCkNh6MfmUBbb9k4SZ0rPYhB4qCeCqMb
         t/ZHRtkalvm2Q23Mu0NnH41nyx2BZihuqFVmuuUbsg3TWXJiz66zbOwFC/14Xb0PLQI+
         9FhNtTngAmj5DY4E/DkWHD40NtKCuujkZtfK2C8PahXspP61IoOPNfbRsBJ5mkj9dFFh
         lSYRq5586zAHmDgxQR8/n35KSbN2KVgpG0/QkTPRAHlbLz1CWRdIr9ou8r5QwD9PLIcQ
         Y29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ccD0ntUVVYkwYlyadNBt1sjxaVIrP/hx7EjWxQNG1N8=;
        b=IdBjHrW+J8Zbahy3+5e2oHagkyMYjxIwUJNZAtGA2kRiE3cdcUsoAi7A695fyxaVvc
         HJQ0LKRBJAtVgND0aKTZnvheuHjyWyBS7m1QWnnwRlEqCnpFgZg3X+Oqb3tcZqV5fjEk
         LF+RHiEOoKgme8RtSlTmm2DshMXub3RdlAtj9zi59v/XCVaioOuZl/qz0SyAAhNSznsc
         h7UGQwS/dfFluW7kgOcizhSfmF3aTp8WJf2A0WWBw8F073SQorvXBdf6sYo/v0Mm1AMQ
         41c/zJNdcdp3kAK2E4kLGIxMJ3h/58a5ozjkzNaSiBgYO20rrE0EdFhjw63McWExLgTN
         L9Lw==
X-Gm-Message-State: AOAM5312VP94bSBOUDhL+3C8In0Sl6Q5Pgu/mM0LGG3nNolX2WvbQXgo
        KtnOMiKFm1K6quCtPQQKK40qpZvyX/Kgq9XgtrQB5Q==
X-Google-Smtp-Source: ABdhPJx4hHfvg7PjcL9qHntLsSw4S293Gegpji2gVZVbaMxcedLFto0w5R8opTR+gtpycaYJ0aXlQUScJRfPuAzPG2I=
X-Received: by 2002:a17:902:d703:b0:144:e012:d550 with SMTP id
 w3-20020a170902d70300b00144e012d550mr19489170ply.38.1637773256073; Wed, 24
 Nov 2021 09:00:56 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <YZ0QMK1QFjw/uznl@monolith.localdoman>
 <CAAeT=FxeXmgM3Pyt_brYRdehMrKHQwZut5xTbHOv-9um7anhYw@mail.gmail.com> <YZ4Y/r8BM2hnrlYQ@monolith.localdoman>
In-Reply-To: <YZ4Y/r8BM2hnrlYQ@monolith.localdoman>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 24 Nov 2021 09:00:39 -0800
Message-ID: <CAAeT=FzhCmBTF2QpCdNVjtVT_Ct0mo2_05uTny73U4B3fTyVZg@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/29] KVM: arm64: Make CPU ID registers writable
 by userspace
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Will Deacon <will@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Peng Liang <liangpeng10@huawei.com>,
        Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Alex,

> > > I started reviewing the series, but I ended up being very confused, see
> > > below.
> > >
> > > On Tue, Nov 16, 2021 at 10:43:30PM -0800, Reiji Watanabe wrote:
> > > > In KVM/arm64, values of ID registers for a guest are mostly same as
> > > > its host's values except for bits for feature that KVM doesn't support
> > > > and for opt-in features that userspace didn't configure.  Userspace
> > > > can use KVM_SET_ONE_REG to a set ID register value, but it fails
> > > > if userspace attempts to modify the register value.
> > > >
> > > > This patch series adds support to allow userspace to modify a value of
> > > > ID registers (as long as KVM can support features that are indicated
> > > > in the registers) so userspace can have more control of configuring
> > > > and unconfiguring features for guests.
> > >
> > > What not use VCPU features? Isn't that why the field
> > > kvm_vcpu_init->features exists in the first place? This cover letter does
> > > nothing to explaing why any changes are needed.
> > >
> > > Do you require finer grained control over certain feature that you cannot
> > > get with the 32 * 7 = 224 feature flag bits from kvm_vcpu_init? Does using
> > > the ID registers simplify certain aspects of the implementation?
> >
> > Since some features are not binary in nature (e.g. AA64DFR0_EL1.BRPs
> > fields indicate number of breakpoints minus 1), using
> > kvm_vcpu_init->features to configure such features is inconvenient.
>
> I see, this makes a lot of sense and this looks like a nice solution to
> that problem.
>
> >
> > One of the reasons why we want the finer grained control is that
> > we want to expose a uniform set/level of features for a group of
> > guests on systems with different ARM CPUs.
>
> So here you are talking specifically about KVM not checking that all VCPUs
> have the same feature bits set in vcpu->arch.features, which makes it
> possible for userspace to set different features for different VCPUs,
> right?

Yes, that is correct.  For features that can be configured by
KVM_ARM_VCPU_INIT, userspace can configure different features
for different vCPUs by using KVM_ARM_VCPU_INIT as before.

Thanks,
Reiji
