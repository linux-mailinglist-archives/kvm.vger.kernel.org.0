Return-Path: <kvm+bounces-55486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 95F7BB310DB
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 09:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35BE43BE087
	for <lists+kvm@lfdr.de>; Fri, 22 Aug 2025 07:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28E7C2EA48A;
	Fri, 22 Aug 2025 07:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rKZZ4g+b"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7C01A9F83
	for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 07:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755849367; cv=none; b=BTQVrI7TntlDmlPTfK80NwTCfPyY3130mf00kdYgzfqho6YEvyT9GJJlLeWX0rnXEmyNkRjPBS9AYYUwT2wLGV+iusanxodXbWchdKy0jdjiK5bgVxcE41vUIPhxEcQ0R7x4l+KM22vQRbsRduC/FK07JClb30EGktZ+xbj0jTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755849367; c=relaxed/simple;
	bh=Az8JUhBwX6/JhkCUo+K9ENK6vRMh2E6HoMbbZ1g2NaA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p9Vlwq+/+JmQZahAMru69FenhP+vF+VPaHmLsHYMlYjxLUrNWrozP0OdZ3rop8ypH7EqlR/c75cxwRoeqX+XL5bN2bdyvALRiTMGFRWz8tWeYQp30+ZvH/GyOdcRMo601u5l9WRIaaKCCzs4pwqVrE7vi4UDl1tByqYT0BNXCa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rKZZ4g+b; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6188b7532f3so3202556a12.2
        for <kvm@vger.kernel.org>; Fri, 22 Aug 2025 00:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755849363; x=1756454163; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Szwa3+x61AjR+V+P9JR802YOlHoy4d5KMmU1As6SE3w=;
        b=rKZZ4g+bNKRCdGMzgUxnRBj8fRoLQ9Ujfvvtg+wm80YY3I25NSQFEmReKOFIm7w8hJ
         VyVXL3G4LG0/3AfnWEGBQ0rbfws/HjYL+qUToTam+waMbE76qdehnNhUG+hr7DqrJjDf
         +1a0h2jjq/odO3cN+fGNk/VyAWj4H30BXEiiYuavp3CiMisGDMu1XS7IQQrAraD6lr6M
         DNS8GHSSDTM7M1X4j7ydjyC33wKJXsB2kpDXZd/t6Or6CU2cm8JG8JkKiajLrOjb8dLI
         4Lucl3S3ZsUA1wUHwECjHIIZyX0GJBToCjPDTqtCA9nBJbkSxCxR61CiFFFBPzOxAabD
         iHig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755849363; x=1756454163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Szwa3+x61AjR+V+P9JR802YOlHoy4d5KMmU1As6SE3w=;
        b=a1bph1mVvjuYdT9HuWdLxMwZqkz6iwXlR+2Li38zl0s8SPF5WIZZS6up/iPXHdMn+K
         JdhHy98t4QBHCuOXokKUVx3SrG3v2xZFYEVC0apFGpFrlbqjrDGIHkzf998idtqgxbSI
         Y2aIBQc7p7vXfPDBpbrNLnYYxS7MuX1KzC8tNhMBxLw9ieRqjReNTRmQVVwc4O7cMNk2
         miIfo0lSfC0lKsRJuZYiLS5wls2ryVNH6lM49NBYe03QyYp3018GbyvXg7FuSyp2hOdy
         7vZQK0Z9TsLjUOSj43gpnApOjfQsVxnqyDKZpiX59rBSCoL0tJ15eyU1FtHaCjQ8wRBa
         yDuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVyuOaEbK1MD+cJGcsRKcX6xGBKN7BdaUEHxCctmVoITR7OmnCj4eOATxJQKpXcdq9rh3k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRMHmbOf9OQ8+YNwdp5hAHg6QMa+U2hPJOW8KjzXVME4cx4tf3
	gYfubNkowTbhdUuGUiltn4V922BtbrN1l6cDRUMjg10WyU8fdlomFCOyhw/kq4u46nlM0pQrX4K
	x9964llmMnqiVzctWJYIjhcsGQtOtXusCHUDh1Or7+A==
X-Gm-Gg: ASbGncs5Ct1U7aqsVmi6vZYN3CqT6bGZOaVU/16C9M5/+2Pv1DKTiZld28tibSM7m5H
	Z2bPt/Bh1jP7UU3l+Moz8G/5xOKHWj4e3xGwGo7/d7afuO0/NtXLH4NlhaE12ILjYOg8viQjH/v
	3wRIIPS9Ozu1oUg1xg9aIzlxgx9oGrB3ENgcSTMcC0LMwHIjmyA6bGXJ9Asdg/0lNUA+p9Ri+24
	mBfDoqG
X-Google-Smtp-Source: AGHT+IEGlXFB2VgzPVaxsYH+hNmAsUWM3LXReJXTH5m9LDwmYrw8I7I2udE/H9dX4DKeue/OTYF5bEV9W0xsKj9MdHU=
X-Received: by 2002:a05:6402:42ce:b0:618:35c5:64d9 with SMTP id
 4fb4d7f45d1cf-61c1b3b910amr1639914a12.1.1755849363521; Fri, 22 Aug 2025
 00:56:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250617163351.2640572-1-alex.bennee@linaro.org>
 <20250617163351.2640572-11-alex.bennee@linaro.org> <19837997-57c3-47b7-ab25-f8bad6bd3d4f@linaro.org>
In-Reply-To: <19837997-57c3-47b7-ab25-f8bad6bd3d4f@linaro.org>
From: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
Date: Fri, 22 Aug 2025 10:55:37 +0300
X-Gm-Features: Ac12FXzysBykHD9AJKQFv_CgJk4g-Amfu2g5g4l_2aU9o7bjhIilWFp9_-DY6aE
Message-ID: <CAAjaMXbnNeMwt2qQNX+kMA=7=tCrcUjV2=18zpwERKP=bCZJ-g@mail.gmail.com>
Subject: Re: [RFC PATCH 10/11] kvm/arm: implement a basic hypercall handler
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	qemu-devel@nongnu.org, Cornelia Huck <cohuck@redhat.com>, qemu-arm@nongnu.org, 
	Mark Burton <mburton@qti.qualcomm.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
	Alexander Graf <graf@amazon.com>, kvm@vger.kernel.org, 
	Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2025 at 10:13=E2=80=AFAM Philippe Mathieu-Daud=C3=A9
<philmd@linaro.org> wrote:
>
> On 17/6/25 18:33, Alex Benn=C3=A9e wrote:
> > For now just deal with the basic version probe we see during startup.
> >
> > Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> > ---
> >   target/arm/kvm.c        | 44 ++++++++++++++++++++++++++++++++++++++++=
+
> >   target/arm/trace-events |  1 +
> >   2 files changed, 45 insertions(+)
> >
> > diff --git a/target/arm/kvm.c b/target/arm/kvm.c
> > index 0a852af126..1280e2c1e8 100644
> > --- a/target/arm/kvm.c
> > +++ b/target/arm/kvm.c
> > @@ -1507,6 +1507,43 @@ static int kvm_arm_handle_sysreg_trap(ARMCPU *cp=
u,
> >       return -1;
> >   }
> >
> > +/*
> > + * The guest is making a hypercall or firmware call. We can handle a
> > + * limited number of them (e.g. PSCI) but we can't emulate a true
> > + * firmware. This is an abbreviated version of
> > + * kvm_smccc_call_handler() in the kernel and the TCG only arm_handle_=
psci_call().
> > + *
> > + * In the SplitAccel case we would be transitioning to execute EL2+
> > + * under TCG.
> > + */
> > +static int kvm_arm_handle_hypercall(ARMCPU *cpu,
> > +                                    int esr_ec)
> > +{
> > +    CPUARMState *env =3D &cpu->env;
> > +    int32_t ret =3D 0;
> > +
> > +    trace_kvm_hypercall(esr_ec, env->xregs[0]);
> > +
> > +    switch (env->xregs[0]) {
> > +    case QEMU_PSCI_0_2_FN_PSCI_VERSION:
> > +        ret =3D QEMU_PSCI_VERSION_1_1;
> > +        break;
> > +    case QEMU_PSCI_0_2_FN_MIGRATE_INFO_TYPE:
> > +        ret =3D QEMU_PSCI_0_2_RET_TOS_MIGRATION_NOT_REQUIRED; /* No tr=
usted OS */
> > +        break;
> > +    case QEMU_PSCI_1_0_FN_PSCI_FEATURES:
> > +        ret =3D QEMU_PSCI_RET_NOT_SUPPORTED;
> > +        break;
> > +    default:
> > +        qemu_log_mask(LOG_UNIMP, "%s: unhandled hypercall %"PRIx64"\n"=
,
> > +                      __func__, env->xregs[0]);
> > +        return -1;
> > +    }
> > +
> > +    env->xregs[0] =3D ret;
> > +    return 0;
> > +}
> > +
> >   /**
> >    * kvm_arm_handle_hard_trap:
> >    * @cpu: ARMCPU
> > @@ -1538,6 +1575,13 @@ static int kvm_arm_handle_hard_trap(ARMCPU *cpu,
> >       switch (esr_ec) {
> >       case EC_SYSTEMREGISTERTRAP:
> >           return kvm_arm_handle_sysreg_trap(cpu, esr_iss, elr);
> > +    case EC_AA32_SVC:
> > +    case EC_AA32_HVC:
> > +    case EC_AA32_SMC:
> > +    case EC_AA64_SVC:
> > +    case EC_AA64_HVC:
> > +    case EC_AA64_SMC:
>
> Should we increment $pc for SVC/SMC?
> The instruction operation pseudocode [*] is:
>
>    preferred_exception_return =3D ThisInstrAddr(64);
>

Here's what the trusted firmware handler does.

The exception return address is modified by the :

https://github.com/ARM-software/arm-trusted-firmware/blob/da6b3a181c03a492e=
e52182b0466d0b7cc4091dd/bl31/aarch64/runtime_exceptions.S#L456-L480

    > * returns:
    > *   -1: unhandled trap, UNDEF injection into lower EL
    > *    0: handled trap, return to the trapping instruction (repeating i=
t)
    > *    1: handled trap, return to the next instruction

An SMC-aware trap handler should do the same


> [*]
> https://developer.arm.com/documentation/ddi0602/2022-06/Shared-Pseudocode=
/AArch64-Exceptions?lang=3Den
>
> > +        return kvm_arm_handle_hypercall(cpu, esr_ec);
> >       default:
> >           qemu_log_mask(LOG_UNIMP, "%s: unhandled EC: %x/%x/%x/%d\n",
> >                   __func__, esr_ec, esr_iss, esr_iss2, esr_il);
> > diff --git a/target/arm/trace-events b/target/arm/trace-events
> > index 69bb4d370d..10cdba92a3 100644
> > --- a/target/arm/trace-events
> > +++ b/target/arm/trace-events
> > @@ -15,3 +15,4 @@ arm_gt_update_irq(int timer, int irqstate) "gt_update=
_irq: timer %d irqstate %d"
> >   kvm_arm_fixup_msi_route(uint64_t iova, uint64_t gpa) "MSI iova =3D 0x=
%"PRIx64" is translated into 0x%"PRIx64
> >   kvm_sysreg_read(const char *name, uint64_t val) "%s =3D> 0x%" PRIx64
> >   kvm_sysreg_write(const char *name, uint64_t val) "%s <=3D  0x%" PRIx6=
4
> > +kvm_hypercall(int ec, uint64_t arg0) "%d: %"PRIx64
>
>

