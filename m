Return-Path: <kvm+bounces-7182-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CC8983DF4D
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 17:56:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B437C28BBD9
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 16:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CFC41EB4F;
	Fri, 26 Jan 2024 16:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Oa/vmMZT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60FA1DFF7
	for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 16:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706288162; cv=none; b=Oh+I/P51EH5zWlCG3TX8pX8NiMaLTHC1H+TokBirdv0z5t+VSAv2fTbysr4XFibRZix0uJnUSrN7+tlZBhTPb7pLj7/w+CZloT5y68LVw2ldsGDis4SNMqF8bA8i2v937wSxRKNdWJWGX+Ygr+4c2Y4ZHROJyA2WRxZ1WW3SeH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706288162; c=relaxed/simple;
	bh=BHaM5+kfieorDZaZIR04yxElayRPoejdSS1Hl9A5ue4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FuN0YV55ZKvoR9wmGTdGSTFwLunQWubwGxX0nXT8x1IBOLLw1mCGihNhEH3DoVNXE/W7NHNzT5yKSi1Pm1mxVl4V67MG7c32lT3LTXc9Azp/TwrHJ1TGygZdE6pgFGeNj6NZ3VE2+t8o50BghCCs8vjnZ5No9EV9EMou6ETLr4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Oa/vmMZT; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-5ff82dc16e0so7451927b3.2
        for <kvm@vger.kernel.org>; Fri, 26 Jan 2024 08:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706288160; x=1706892960; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6+singdRz7n9EZ1BAZjnJO5oBT2nIvUykwVKfWaIwAg=;
        b=Oa/vmMZTqK2y3RijFusirEoEnoiEwR2Xdaia/j0NorESrc2PHoFW/SltfGUrQN9UUY
         PhR2EwMn9QvUapd99KwQaMeHLjLfXf1U8XiBCYmsriuwh1I9DiE6BGbPHCAwi9B63aUM
         E3Cf8ohrnPLITwGAusj4+akY/hH9SDsjAFBWsmavz/d7HJVds0moE26R2r6ACudjawf0
         QyBMOoTjvOzke2BaQPHrH3XEnaWp1N8SpE5t7j0GSDoV2wbLr6xotzHxmiIvj15he2rk
         21qf5KGXmhp8AoPBofEehlkTJl6HDQwHEPQhq/hGJL2wr5h7OfZ8Z0cxlSWNkIX5gz+P
         gIHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706288160; x=1706892960;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6+singdRz7n9EZ1BAZjnJO5oBT2nIvUykwVKfWaIwAg=;
        b=H+DDfitN+OZ6z3vCfjGjXbL0dwFK6zOf8kPX4wjrwa9Tp17Op0ITg0h02Q/KK1pTpT
         Tm5gfBmiZEHHjQ3q8Xpr98vlO3CzYYz6xLiM1XtmbREuQ9dq9Dhzky3LJWfd7DVJ53P9
         n8gQDUAn+Ab/ONO6ywWhhpNqKqkC7w7am3a3SPcCm2VCXwNqoFXRNml/h22/Z7t8yUQK
         tF3/h+B0ahu6he1S/EGpFvCHivQpNcjojO3R9nuh7LvQpClz0S9/q2nrFsv6PV/VQB6J
         YZUsWVwVgyGc7SMinum64VJpV4zQMD9N2J0zamUcK6KX2MgqTLhpcE26/EVw63gXc08y
         ck9A==
X-Gm-Message-State: AOJu0Yzmpi3/TwDtg4X94WZHt1I0GXzGaMgT9hPFkHtdN9eCY/JkooQt
	ktDunl8LSfd4WclQpNGnSzTDHwOdhgcCa6gEDqaiTaiNRQKxj/jNUX27vlarIOezSXd5540+V3y
	tyA==
X-Google-Smtp-Source: AGHT+IGvnOxygM0B4M/PTW5WzXnKuJI5Wy/wEwSD7ujk2LTYygTAj90uu4Y8MEVsEOlBeJ3hcefGV1VZf6Q=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:10c:b0:5f9:abfe:243c with SMTP id
 bd12-20020a05690c010c00b005f9abfe243cmr13112ywb.3.1706288159824; Fri, 26 Jan
 2024 08:55:59 -0800 (PST)
Date: Fri, 26 Jan 2024 08:55:58 -0800
In-Reply-To: <20240126161633.62529-1-haoyuwu254@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240126161633.62529-1-haoyuwu254@gmail.com>
Message-ID: <ZbPkHvuJv0EdJhVN@google.com>
Subject: Re: [PATCH] KVM: Fix LDR inconsistency warning caused by APIC_ID
 format error
From: Sean Christopherson <seanjc@google.com>
To: Haoyu Wu <haoyuwu254@gmail.com>
Cc: pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, zheyuma97@gmail.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 27, 2024, Haoyu Wu wrote:
> Syzkaller detected a warning in the kvm_recalculate_logical_map()
> function. This function employs VCPU_ID as the current x2APIC_ID
> following the apic_x2apic_mode() check. However, the LDR value,
> as computed using the current x2APIC_ID,  fails to align with the LDR
> value that is actually set.
>=20
> Syzkaller scenario:
> 1) Set up VCPU's
> 2) Set the APIC_BASE to 0xd00
> 3) Set the APIC status for a specific state
>=20
> The issue arises within kvm_apic_state_fixup, a function responsible
> for adjusting and correcting the APIC state. Initially, it verifies
> whether the current vcpu operates in x2APIC mode by examining the
> vcpu's mode. Subsequently, the function evaluates
> vcpu->kvm->arch.x2apic_format to ascertain if the preceding kvm version
> supports x2APIC mode. In cases where kvm is compatible with x2APIC mode,
> the function compares APIC_ID and VCPU_ID for equality. If they are not
> equal, it processes APIC_ID according to the set value. The error
> manifests when vcpu->kvm->arch.x2apic_format is false; under these
> circumstances, kvm_apic_state_fixup converts APIC_ID to the xAPIC format
> and invokes kvm_apic_calc_x2apic_ldr to compute the LDR. This leads to by
> passing consistency checks between VCPU_ID and APIC_ID and results in
> calling incorrect functions for LDR calculation.

Please just provide the syzkaller reproducer.

> Obviously, the crux of the issue hinges on the transition of the APIC
> state and the associated operations for transitioning APIC_ID. In the
> current kernel design, APIC_ID defaults to VCPU_ID in x2APIC mode, a
> specification not required in xAPIC mode. kvm_apic_state_fixup initiates
> by assessing the current status of both VCPU and KVM to identify their
> respective APIC modes. However, subsequent evaluations focus solely on
> the APIC mode of VCPU. To address this, a feasible minor modification
> involves advancing the comparison between APIC_ID and VCPU_ID,
> positioning it prior to the evaluation of vcpu=E2=86=92kvm=E2=86=92arch.x=
2apic_format.
>
> Signed-off-by: Haoyu Wu <haoyuwu254@gmail.com>
> ---
>  arch/x86/kvm/lapic.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 3242f3da2..16c97d57d 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2933,16 +2933,16 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *=
vcpu,
>  		u32 *ldr =3D (u32 *)(s->regs + APIC_LDR);
>  		u64 icr;
> =20
> -		if (vcpu->kvm->arch.x2apic_format) {
> -			if (*id !=3D vcpu->vcpu_id)
> -				return -EINVAL;
> -		} else {
> +		if (*id !=3D vcpu->vcpu_id)
> +			return -EINVAL;

This will break userspace.  As shown below, if userspace is using the legac=
y
format, the incoming ID will be vcpu_id << 24.

This is a known issue[*], and apparently I had/have a patch?  I'll try to d=
redge
that up.  I suspect what I intended to was this, but I haven't yet found a =
branch
or stash, or anything else that captured what I intended to do.  *sigh*

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3242f3da2457..d25e31c04fbd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2933,16 +2933,16 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vc=
pu,
                u32 *ldr =3D (u32 *)(s->regs + APIC_LDR);
                u64 icr;
=20
-               if (vcpu->kvm->arch.x2apic_format) {
-                       if (*id !=3D vcpu->vcpu_id)
-                               return -EINVAL;
-               } else {
+               if (!vcpu->kvm->arch.x2apic_format) {
                        if (set)
                                *id >>=3D 24;
                        else
                                *id <<=3D 24;
                }
=20
+               if (*id !=3D vcpu->vcpu_id)
+                       return -EINVAL;
+
                /*
                 * In x2APIC mode, the LDR is fixed and based on the id.  A=
nd
                 * ICR is internally a single 64-bit register, but needs to=
 be

[*] https://lore.kernel.org/all/ZHk3TGyB2Vze4+Ou@google.com

> +		if (!vcpu->kvm->arch.x2apic_format) {
>  			if (set)
>  				*id >>=3D 24;
>  			else
>  				*id <<=3D 24;
>  		}
> =20
> +

Spurious whitespace.

>  		/*
>  		 * In x2APIC mode, the LDR is fixed and based on the id.  And
>  		 * ICR is internally a single 64-bit register, but needs to be
> --=20
> 2.34.1
>=20

