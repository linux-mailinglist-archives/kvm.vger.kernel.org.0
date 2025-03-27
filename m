Return-Path: <kvm+bounces-42123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 14369A73441
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 15:22:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A0E49174801
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 14:21:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C70DA21767D;
	Thu, 27 Mar 2025 14:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L7vHl9GU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA7121422C
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 14:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743085263; cv=none; b=O60V2WUyEUfa6KIb0zA7mNzWE8o9qgoCYFCQr5Up6ymxrfsTAsjEGchdYmKt7Acg9hbFO0Cm5WtdeOtKBCVH1WWIjQUE51kLU0ivKBYFf5dKzo4RxA5uKDIj3ozV9IlepKWc3E1lmKcgq3vlRJNad7JvnOwgjwgk22sXInzy62c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743085263; c=relaxed/simple;
	bh=MpgBP5KF/hwwzLGRr1MLHbY3huNA0Re6KBdULunHCGk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HSjNJOKoSSApE05wHiZeVD6Dbpw/PIJrALsmjPyMEixz2VFsOKD99Wbd7J6crbgkQji0owYno/WWrOt3DUSfDWYepWkpVoT7Mk7q0VmeKR+gXziaoUIGgD/hRt7DAx4cYmjuBGhsKaZlC1BuZ6VeNG/8rwcwkYc8oe8ad1c5qhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L7vHl9GU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3032ea03448so1987796a91.2
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 07:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743085261; x=1743690061; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0E1KoF9n8W5T1UdiJVOslWaohgAmLtobQZJ+uL0v3qI=;
        b=L7vHl9GUAo+kzqGIC/WLY29+4lIOBDy/CFf2CQrMZDTPQDcjTjjTAnG/TV/gj3NXrn
         w7ZPz86cjJGnTDyrL8ubs3+K0PaLmcAghVs6KqgFxfxNuQc0+BxFAahT/ogiZ4cZJN2q
         CKMsjdeZqmj1S/S3c4pdyDJMCG3A0b82lj0cuJ/HNgd3B62aIusvjUiGnijkQRQ29NMv
         6QpbbipIdlkxohV5TjVkQ6YIzdeVIwjh2dHBGW7bhaFn1weUDlG0VOtMp5xZoRKgjVw4
         pmOr8WpZmUVTOl6eKl98Lc/aee3qfmcyvWfMQ7EGq5GeBJbLiny6v0VAXKC1hZBVm7u8
         8fkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743085261; x=1743690061;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0E1KoF9n8W5T1UdiJVOslWaohgAmLtobQZJ+uL0v3qI=;
        b=efX/R4XbTVSgavtadw0NRcamyKEi1V/AGzgFPEQLyg2jzZ9aOpTJ7gcyB1dSCtD0YO
         v0XEULGB/29v8zT37FUG981LGZvKTHGr1IrU4bRzbErM/U4gvDW5z9nBV/zMM8CgBtbm
         PIxHOSj+bEC+uZsQ3uS3ysf8OHIc5KJ8DRCr3EIuhVg+FV8qQsjgobDEt0X+Uh2NV8xt
         ClTdYfnMjdvdHPPnXvacsN/Cz2Qv5VwDDbpWcnkFn7HKqaKYFz/jgvyRURSnLV6bjmei
         fLwIExvGDLeFU5QSNkAHUpqWJOfedUAJjPSUxBKR7cKR1OC7iFlEfcN6YPaNGorYk4sI
         r9ZQ==
X-Gm-Message-State: AOJu0Yxn9a1zKSo9TcjroL3DwzE+h9y8Qd2ocakI/izz45VTL7GpyTPz
	YsUR+u2lo8Lu0VaPEOuzAEbBQZG29ynLQd99AfIef7OuMRsfVyPpm3s61pN/+PELN3LvisOH/HY
	RkA==
X-Google-Smtp-Source: AGHT+IGjINpB6+Pi/38se0y66/Kxl0D00XXdmz1ICOtv45IJ6mKvfRj6KwYZKVkrKlBUJ3mL4ZLZg8a3fOE=
X-Received: from pgct9.prod.google.com ([2002:a05:6a02:5289:b0:ad7:adb7:8c14])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:158a:b0:1f1:432:f4a3
 with SMTP id adf61e73a8af0-1fea2f2cadamr6860864637.23.1743085260932; Thu, 27
 Mar 2025 07:21:00 -0700 (PDT)
Date: Thu, 27 Mar 2025 07:20:58 -0700
In-Reply-To: <4732241e-b706-481b-a73a-01ef77622d8a@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <4732241e-b706-481b-a73a-01ef77622d8a@amd.com>
Message-ID: <Z-Veys6h0OSx4L_e@google.com>
Subject: Re: RESEND: SEV-SNP Alternate Injection
From: Sean Christopherson <seanjc@google.com>
To: "Melody (Huibo) Wang" <huibo.wang@amd.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"svsm-devel@coconut-svsm.dev" <svsm-devel@coconut-svsm.dev>, Jon Lange <jlange@microsoft.com>, 
	Thomas Lendacky <Thomas.Lendacky@amd.com>, David Kaplan <David.Kaplan@amd.com>, 
	Joerg Roedel <jroedel@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 26, 2025, Melody (Huibo) Wang wrote:
> Hi,
>=20
> I am currently enabling Alternate Injection for SEV-SNP guests and have
> encountered a design issue.
>=20
> The Alternate Injection specification which is a preliminary spec support=
s
> only the SVSM APIC protocol through a subset of X2APIC MSRs, Timer suppor=
t is
> configurable, If timer functionality is not supported, the guest must rel=
y on
> the hypervisor to emulate timer support through use of the #HV Timer GHCB
> protocol.
>=20
> When the OVMF firmware starts, it is in XAPIC mode by default and then, l=
ater
> during the init phase it switches the guest to X2APIC. However, with
> Alternate Injection enabled, the OVMF in its very first phase - SEC - doe=
s
> XAPIC accesses. The SVSM uses a so-called SVSM APIC protocol which uses a
> subset of the X2APIC MSRs.
>=20
> The OVMF, however, thinks it starts off in XAPIC memory-mapped mode. Ther=
e's
> a protocol mismatch of sorts. With Alternate Injection enabled in the SEC
> phase, it requires X2APIC. The registers (timer registers) - not handled =
by
> SVSM will get routed to KVM, which at that point is operating the guest i=
n
> XAPIC mode until the PEI phase switches to X2APIC.
>=20
> One potential solution is to have KVM enable X2APIC as soon as Alternate
> Injection is activated. While we could start X2APIC during the creation o=
f
> the vCPU, APM Volume 2, Figure 16-32 states that we must transition from
> XAPIC mode to X2APIC mode first.
>=20
> More specifically:
>=20
> =E2=80=9CIf the feature is present, the local APIC is placed into x2APIC =
mode by
> setting bit 10 in the Local APIC Base register (MSR 01Bh). Before enterin=
g
> x2APIC mode, the local APIC must first be enabled (AE=3D1, EXTD=3D0).=E2=
=80=9D
>=20
> Therefore, I am uncertain if enabling X2APIC directly during vCPU creatio=
n is
> permissible.
>=20
> Do you have any suggestions for a better solution?

Fix OVMF.  Or change the AMD architectural specs.  Don't hack KVM.

>=20
> Please feel free to ask questions if some concepts are unclear and I'll
> gladly expand on them.
>=20
> Thanks,
> Melody

