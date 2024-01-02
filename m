Return-Path: <kvm+bounces-5479-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0325822563
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 00:09:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 557092847A8
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 23:09:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57D7E1774C;
	Tue,  2 Jan 2024 23:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="28GPKSOM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE0317732
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 23:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-5e8e0c7f9a8so120656467b3.0
        for <kvm@vger.kernel.org>; Tue, 02 Jan 2024 15:09:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704236964; x=1704841764; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VmfarTfri1+432ZBbDvSTJInqX46gfjfsyuzVGEGM+I=;
        b=28GPKSOMOdjuD9h/tyueP0ff69ywGGnJhxZ1yQ1UQvgWYurHQsK9aegBQawrikt6xP
         sd73obUhHCEXKCfSKHG3XAat2NQj5tuOPQ3422X2G8tvHDh89r6L80x6E++gu0M+llcc
         gmVECCABa1QBbyMQ71coX9I7xrniQrJtbogVp4l8MV97qsA5qp6WEhIVi1EzmfpajSV6
         FWMg28bo+mXyZjfUQ1LAxVmVb+dmGBQCIyTt1AQbLEXTVwP4DVvsG3WfZCDC9zRRDOfo
         Iegk4u2K5evC8n7e57cR/Y6/ibbtBTqDXnhZorgmhaBYWbqN8LNS1tFHo0ywfc49K0uK
         lU4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704236964; x=1704841764;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VmfarTfri1+432ZBbDvSTJInqX46gfjfsyuzVGEGM+I=;
        b=AH6AyKfmXjkjjbeNQt/JhO2BtYErUYqm3uzndebCd5wq4Xac9gBmyr0PlKIK5jRqW9
         aR1YfuzNSX7/s/8WGRET0v8QNLWz1DmjdJ1swTev+6LIAuAOZ6ZVMikrM60GZnvnv9fK
         E62xCvTR9snVtDSMCSWDXZ8Pn/TrO7bws5tip/pqsd3x8y1OSmxgoEtC2W4kAR4xLtJ+
         7F6LY9U9bYA20SnCVoSXW/8nJJsQzjr5Q/RlvD+zVYxlf4411P1Qkg11t6FISJ8xnUyz
         NPA40IFHjHCACE/eoLvw4sUkO9yfm2gpwV0yxQlYCE+N6PiL8VPhStDefrqYdVwzdpId
         5mDA==
X-Gm-Message-State: AOJu0YzLB5RYXJUpOVZ6Z7tmjR/b2SKtkRmY7xz0EVUHizUsxiAPoVK+
	c5dYARMbSIQlfTje0BFRQRucraW09DZ0+EVlIw==
X-Google-Smtp-Source: AGHT+IHGHfDd0wPfxNtcpYgXmKZ2cyY1GdW1PZSPN3Jvr3UiQugVcTtpaaSq9eNVSBtnDRNY6MvL2mAaecQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:3a0:b0:5d6:f1d2:2e5e with SMTP id
 bh32-20020a05690c03a000b005d6f1d22e5emr117443ywb.0.1704236964270; Tue, 02 Jan
 2024 15:09:24 -0800 (PST)
Date: Tue, 2 Jan 2024 15:09:22 -0800
In-Reply-To: <CABOYnLwfWmOUfP-uW9ALCxEXbzaSGVZn6GeEyfvPr-R-XdmrSQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CABOYnLwfWmOUfP-uW9ALCxEXbzaSGVZn6GeEyfvPr-R-XdmrSQ@mail.gmail.com>
Message-ID: <ZZSXotY3NRbki_hW@google.com>
Subject: Re: KMSAN: uninit-value in em_ret_far
From: Sean Christopherson <seanjc@google.com>
To: xingwei lee <xrivendell7@gmail.com>
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com, bp@alien8.de, 
	hpa@zytor.com, kvm@vger.kernel.org, mingo@redhat.com, pbonzini@redhat.com, 
	Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 25, 2023, xingwei lee wrote:
> Hello I found a bug in latest upstream 6.7-rc7 titled "KMSAN:
> uninit-value in em_ret_far=E2=80=9D and maybe is realted with kvm.
>=20
> If you fix this issue, please add the following tag to the commit:
> Reported-by: xingwei lee <xrivendell7@gmail.com>
>=20
> kernel: mainline 861deac3b092f37b2c5e6871732f3e11486f7082
> kernel config: https://syzkaller.appspot.com/text?tag=3DKernelConfig&x=3D=
4a65fa9f077ead01
> with KMSAN enabled
> compiler: Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2=
.40
> run the repro.c for about 3minus and it crashed!
>=20
> TITLE: KMSAN: uninit-value in em_ret_far
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> BUG: KMSAN: uninit-value in emulator_recalc_and_set_mode
> arch/x86/kvm/emulate.c:797 [inline]
> BUG: KMSAN: uninit-value in assign_eip_far arch/x86/kvm/emulate.c:833 [in=
line]
> BUG: KMSAN: uninit-value in em_ret_far+0x348/0x350 arch/x86/kvm/emulate.c=
:2258
> emulator_recalc_and_set_mode arch/x86/kvm/emulate.c:797 [inline]
> assign_eip_far arch/x86/kvm/emulate.c:833 [inline]

This is a known issue[1].  It's effectively a false positive, even though t=
here
is technically uninitialized data in scope.  The proposed fix[2] from Julia=
n
should resolve this (the patch is on my radar for 6.9).

[1] https://lore.kernel.org/all/9362077ac7f24ec684d338543e269e83aee7c897.ca=
mel@cyberus-technology.de
[2] https://lore.kernel.org/all/20231009092054.556935-1-julian.stecklina@cy=
berus-technology.de

