Return-Path: <kvm+bounces-60711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43E49BF845D
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 21:34:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED77E5459FF
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 19:34:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B388726E6F9;
	Tue, 21 Oct 2025 19:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2LhhMSc7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58063261B8D
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 19:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761075241; cv=none; b=sAPOdRroC9CsDmuTFOeTV4Dw4ZmRIRA4FKOy8tYhlHESQxSzyI5ngtWgZ32ILG5ygMVgA5Om1At2i6ItwYUiWrg7wuiHXWBTMRcFYDpMXHA6Q+XG53MZLU3PL/LrK7monHmSBxDugoAy2jwECmoxZ1xtvRRPE+vcNo7U/nwBdJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761075241; c=relaxed/simple;
	bh=Jmo60ouuYJyaCON46Bbir7bs2eO0nEeiqXvXsQBeOmc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k1OzNrMEiJYnYRqz0dArZ/4H2ixmpQYcPCVLkCu1YyWvOPyFr/MIkPZ318ifDY5Tw28l9U8cEoX0QrAprh1y/WSL6jEobNFaivebobQfjB5ICnkWx2FeKnmlXJhHPmfbnCZBeabZZ9825F/ICqPQ8Rn+u7VhBxtsCmlSpiQQNbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2LhhMSc7; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32eb18b5500so9901947a91.2
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 12:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761075240; x=1761680040; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OxAGpaGFizaUdm1oA6q4kgeLpiRGaPXMSx3pjnxQYAU=;
        b=2LhhMSc7fl2vemHoBpY4ELPINr3vJS05fVLhLpyCsEpDGegdg+2nsZwYuwwb7C+Gtk
         gnlta1wzHnGtpA+6tZOC9e1Ztsj6N0wqcJ+znDMDlYkTcDPndMZ0N1wK5QLybDUriyxQ
         hLrwXlO69NCI6eDxn9zEwpFNc7mEtCCR7Aih1LZMKTxYRgN5d0yVGm/Qob4y8jQ/8rBe
         iqCr3spIt2tHUxVjW3B9eCrZkQcIAxmYOd/SpG0+xqmBMmDKXNqMzt3s5j+Mel5/Qtv6
         0khrd3tY7rSkCq0/H0uP7mjP1xPt9A1UxlKUscZEwvz1kS/mIXFD35rtZfkNGE2V6hbX
         NXZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761075240; x=1761680040;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OxAGpaGFizaUdm1oA6q4kgeLpiRGaPXMSx3pjnxQYAU=;
        b=wJCtU0aJyhiOVmufH7Zrj0Aya8n9MhqbvaJRJwzImiUL12DML9ZNQhWm0JzTRqd/nd
         cXAOrQLaEy4iGUNsGJjuEdjLWOcZ4lvmmOmj4CIKMqBOsvpYDJmmzo35JFeKGCwcOhnS
         /k4PTR8wsVgjKKX3TVEcTeXqQyBj/uxaaXxPeRnUnbtJ5pFa7PeD4yfYrooa2WzzISFB
         WuxmssnVbg+WCkfO0sXAyFRfXOkPk9KVwn7Ht5WKmJ7mIS1sL3EwP/GfAsqZwx0dLUIs
         vnl1rztsmTyDX6+K1fSqTGlfCsK/zzjcIPb7bXPIH48OKzuYm+0hGLEK0rbbnd2uuqcA
         Vstg==
X-Forwarded-Encrypted: i=1; AJvYcCXCozTivzPdrw4gAj9iuKUG6Xgdv2z69I0BkCorA1Q6IrIi1Z7yQoLyzA3Ddz8p7k3HT/I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKf0FblFA9cF+6qvKG7X2Sh4fhDKzcTIfFU4/iRAAk4T7LnwH/
	8LozYpcQQwcKyO2W34We1kGds34y3RYN9b2eFkgJjmTdDphgMBG4vnVgBGOaWcYGh8sWBan56fm
	ABmKicQ==
X-Google-Smtp-Source: AGHT+IHSrQv6xgm8MkIzOyimwD//KertndJT1pQ3EAcAV+QSpCXDsLKtCXbyXx5Mixor2PXIbXQQ2JlXZ5s=
X-Received: from pjbgg16.prod.google.com ([2002:a17:90b:a10:b0:33b:51fe:1a97])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec4:b0:33b:cfab:2f2a
 with SMTP id 98e67ed59e1d1-33bcfab2f31mr29914558a91.33.1761075239604; Tue, 21
 Oct 2025 12:33:59 -0700 (PDT)
Date: Tue, 21 Oct 2025 12:33:58 -0700
In-Reply-To: <38df6c8bfd384e5fefa8eb6fbc27c35b99c685ed.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016222816.141523-1-seanjc@google.com> <20251016222816.141523-2-seanjc@google.com>
 <e16f198e6af0b03fb0f9cfcc5fd4e7a9047aeee1.camel@intel.com>
 <d1628f0e-bbe9-48b0-8881-ad451d4ce9c5@intel.com> <aPehbDzbMHZTEtMa@google.com>
 <38df6c8bfd384e5fefa8eb6fbc27c35b99c685ed.camel@intel.com>
Message-ID: <aPfgJjcuMgkXfe51@google.com>
Subject: Re: [PATCH v4 1/4] KVM: TDX: Synchronize user-return MSRs immediately
 after VP.ENTER
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"kas@kernel.org" <kas@kernel.org>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	wenlong hou <houwenlong.hwl@antgroup.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 21, 2025, Rick P Edgecombe wrote:
> On Tue, 2025-10-21 at 08:06 -0700, Sean Christopherson wrote:
> >  I think we should be synchronizing only after a successful VP.ENTER wi=
th a real
> > > > TD exit, but today instead we synchronize after any attempt to VP.E=
NTER.
> >=20
> > Well this is all completely @#($*#.=C2=A0 Looking at the TDX-Module sou=
rce, if the
> > TDX-Module synthesizes an exit, e.g. because it suspects a zero-step at=
tack, it
> > will signal a "normal" exit but not "restore" VMM state.
>=20
> Oh yea, good point. So there is no way to tell from the return code if th=
e
> clobbering happened.
>=20
> >=20
> > > If the MSR's do not get clobbered, does it matter whether or not they=
 get
> > > restored.
> >=20
> > It matters because KVM needs to know the actual value in hardware.=C2=
=A0 If KVM thinks
> > an MSR is 'X', but it's actually 'Y', then KVM could fail to write the =
correct
> > value into hardware when returning to userspace and/or when running a d=
ifferent
> > vCPU.
> >=20
> > Taking a step back, the entire approach of updating the "cache" after t=
he fact is
> > ridiculous.=C2=A0 TDX entry/exit is anything but fast; avoiding _at mos=
t_ 4x WRMSRs at
> > the start of the run loop is a very, very premature optimization.=C2=A0=
 Preemptively
> > load hardware with the value that the TDX-Module _might_ set and call i=
t good.
> >=20
> > I'll replace patches 1 and 4 with this, tagged for stable@.
>=20
> Seems reasonable to me in concept, but there is a bug. It looks like some
> important MSR isn't getting restored right and the host gets into a bad s=
tate.
> The first signs start with triggering this:
>=20
> asmlinkage __visible noinstr struct pt_regs *fixup_bad_iret(struct pt_reg=
s
> *bad_regs)
> {
> 	struct pt_regs tmp, *new_stack;
>=20
> 	/*
> 	 * This is called from entry_64.S early in handling a fault
> 	 * caused by a bad iret to user mode.  To handle the fault
> 	 * correctly, we want to move our stack frame to where it would
> 	 * be had we entered directly on the entry stack (rather than
> 	 * just below the IRET frame) and we want to pretend that the
> 	 * exception came from the IRET target.
> 	 */
> 	new_stack =3D (struct pt_regs *)__this_cpu_read(cpu_tss_rw.x86_tss.sp0) =
-
> 1;
>=20
> 	/* Copy the IRET target to the temporary storage. */
> 	__memcpy(&tmp.ip, (void *)bad_regs->sp, 5*8);
>=20
> 	/* Copy the remainder of the stack from the current stack. */
> 	__memcpy(&tmp, bad_regs, offsetof(struct pt_regs, ip));
>=20
> 	/* Update the entry stack */
> 	__memcpy(new_stack, &tmp, sizeof(tmp));
>=20
> 	BUG_ON(!user_mode(new_stack)); <---------------HERE
>=20
> Need to debug.

/facepalm

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 63abfa251243..cde91a995076 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -801,8 +801,8 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu)
         * state.
         */
        for (i =3D 0; i < ARRAY_SIZE(tdx_uret_msrs); i++)
-               kvm_set_user_return_msr(i, tdx_uret_msrs[i].slot,
-                                       tdx_uret_msrs[i].defval);
+               kvm_set_user_return_msr(tdx_uret_msrs[i].slot,
+                                       tdx_uret_msrs[i].defval, -1ull);
 }
=20
 static void tdx_prepare_switch_to_host(struct kvm_vcpu *vcpu)

