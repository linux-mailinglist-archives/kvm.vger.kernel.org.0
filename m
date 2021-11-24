Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A393945CA4E
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 17:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242229AbhKXQsD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 11:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241782AbhKXQsC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 11:48:02 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1424C061574
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 08:44:52 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so5515548pju.3
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 08:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G0XEOHQMGnJK/8jzhumR1dUDWBiMpAvYusRY69A+QEY=;
        b=eKZc15RFplIM1j+sc6nPMLo59g2hHqww5v6Ch0Ogt/sb5WaGNlNpE+Rs3fn936v5lE
         /Ud+RsF/XuWccx7dCQ7EyPY8kpZ0I+PN9phBLbgsB+gzia/f/pPM/RywK9SN/tXJLV7k
         51opGqL28LBGKnfkdEZqfz/c2eL0n+kgusNELgPhpOP3iP+hQZsMPCDHBFm74MR09tPR
         oG/fh0qQPDlbArNQFYgO2gOihsBqB4aVTyzq6YML6Kyeof0O5GeGxKmvV8lj4RXmrHPq
         jMV/Xjlimauhw3+H/g6W8AKtqqbifVnmECZCqTNAENX5QWkUcJtpWeZAAtbIIkSDdu/u
         2d5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G0XEOHQMGnJK/8jzhumR1dUDWBiMpAvYusRY69A+QEY=;
        b=qFpXFqcBEMR4MLV3bx9CBuQO6Mw6frRbPHyRnaV7N+5hhhJWkeaVpq1y+ON7A0ABlq
         9E1VEAuxHXib+yCNDCyyuzhyKW0jZBiK6LSAGhtQ3mH/TrCUU/cyh9Z6inEsnZlUMpq3
         3zj7wAFYUYInzJeYcL2/EFrHcRBVGPblCklbIRbQt2eAYSN68Y+ARYSm4QMYDQGxD+k6
         TZrczgIMKaOgUPPEUqaatiVDsHvES8yu8bO17JM50O9E9Z27jbDynmCa+9jRozeqe1Q9
         lKPPgnSwt0tXi0YLAs229djwfQknj6Vx8BlZRdBGa5O08zunprDj/j8vQhd4QlMwT00v
         IMaA==
X-Gm-Message-State: AOAM532X2SFOzhJ4PsILh2p3WBmiAb6b3Up9F+UP3btiP91tOUgu+N+C
        udjvKyHp45T+wm2NiAKuMd1ah1L2gLgm3Rt1LNVFXQ==
X-Google-Smtp-Source: ABdhPJykkFs1jEUeGODGlA7xKP0OubpatAx4WM/2/8+q/u0xJvkZku4bnMmyPdKIKUWU0zS3NOMpnWmjGnWJ2Zg38BA=
X-Received: by 2002:a17:90b:380d:: with SMTP id mq13mr10825100pjb.110.1637772292285;
 Wed, 24 Nov 2021 08:44:52 -0800 (PST)
MIME-Version: 1.0
References: <20211117064359.2362060-1-reijiw@google.com> <YZ0WfQDGT5d8+6i1@monolith.localdoman>
 <CAAeT=FwTrWts=jdO2SzAECKKp5-1gGc5UR22Mf=xpx_8qOcbHw@mail.gmail.com> <YZ4Yg2R+r7q/iHpu@monolith.localdoman>
In-Reply-To: <YZ4Yg2R+r7q/iHpu@monolith.localdoman>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Wed, 24 Nov 2021 08:44:36 -0800
Message-ID: <CAAeT=FwSYVDEUgkDVMxR9tJCbyERmyZ5zOV0xJ9Xc0MmXiS9mw@mail.gmail.com>
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

> > > The API documentation for KVM_ARM_VCPU_INIT states:
> > >
> > > "Userspace can call this function multiple times for a given vcpu,
> > > including after the vcpu has been run. This will reset the vcpu to its
> > > initial state. All calls to this function after the initial call must use
> > > the same target and same set of feature flags, otherwise EINVAL will be
> > > returned."
> > >
> > > The consequences of that, according to my understanding:
> > >
> > > 1. Any changes to the VCPU features made by KVM are observable by
> > > userspace.
> > >
> > > 2. The features in KVM weren't designed and implemented to be disabled
> > > after being enabled.
> > >
> > > With that in mind, I have two questions:
> > >
> > > 1. What happens when userspace disables a feature via the ID registers
> > > which is set in vcpu->arch.features? Does the feature bit get cleared from
> > > vcpu->arch.features? Does it stay set? If it gets cleared, is it now
> > > possible for userspace to call KVM_ARM_VCPU_INIT again with a different set
> > > of VCPU features (it doesn't look possible to me after looking at the
> > > code). If it stays set, what does it mean when userspace calls
> > > KVM_ARM_VCPU_INIT with a different set of features enabled than what is
> > > present in the ID registers? Should the ID registers be changed to match
> > > the features that userspace set in the last KVM_ARM_VCPU_INIT call (it
> > > looks to me that the ID registers are not changed)?
> >
> > KVM will not allow userspace to set the ID register value that conflicts
> > with CPU features that are configured by the initial KVM_ARM_VCPU_INIT
> > (or there are a few more APIs).
> > KVM_SET_ONE_REG for such requests will fail.
> >
> >
> > > 2. What happens to vcpu->arch.features when userspace enables a feature via
> > > the ID registers which is not present in the bitmap?
> >
> > The answer for this question is basically the same as above.
> > Userspace is not allowed to enable a feature via the ID registers
> > which is not present in the bit map.
> >
> > The cover lever included a brief explanation of this, but I will
> > try to improve the explanation:-)
>
> So the ID registers are used to set the version of a feature which is present in
> the VCPU features bitmap, not to enable or a disable a VCPU feature. Thank you
> for the explanation!

Yes, that is correct for the CPU features that can be enabled by
KVM_ARM_VCPU_INIT (or KVM_ENABLE_CAP).

For the other CPU features that are indicated in ID registers on
the host, userspace can disable (hide) the features (or lower the
level of features) for the guest by updating its ID registers.

Thanks,
Reiji
