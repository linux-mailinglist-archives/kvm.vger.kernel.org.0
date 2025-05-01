Return-Path: <kvm+bounces-45173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66711AA64D8
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 22:41:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C26C3AEB79
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 747AD2528E9;
	Thu,  1 May 2025 20:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RVaJBMDu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBD5225A5B
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 20:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746132087; cv=none; b=KrApYVug6imwXeJx7mQsS9Yp/w1m9eBGVADCIjbWW1/LtnUoWCt6KCYU+Yn3L+dSa0cO4qtntrw4Vv+j4cTrcWb1Cxm4+zOk2+5VR4uRECbLFHppzaA9fn1u8Q2E5kW0exknHOEaGhmK69RyUyRyn4xA8oumBgSfZLqf7A2AnLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746132087; c=relaxed/simple;
	bh=ZluM+82HYwqbswiIyD/2FaM5UbGgIj1w9ThrLFQLkQ8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Od+Kh63UPiIO5O0erNBrKjxm3CfMtR1H2r80Ev6Bnym2Nk5LtDc4yYlujnZMHv5vybvLP+qGQaKWwGccgJSYNEK7Js1v5sEb6vEr/wIRgagW6pFjCkkDT81yy0qvaYpBJ33OWKwc9sg8HGbz1Y+5Gr16hKiHniyBwB0kT0rKm6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RVaJBMDu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746132084;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hDh6BZdRx6SbbMEEDIPz7yPlA5iRhs5NfAPHn1HWJJw=;
	b=RVaJBMDulqvwvkvQx+M9pdj51gOmkEoVwCfCm90agcQd+bnaRr9JJA6H96yrU0EplI+jo/
	g3OqoBbO9stUxRmaAVuXyvWYGDpcHmFOUQI+uawvfXdwEk/Hbwd/IxhDyXh7JJjSYWcIlY
	p7m/MUAYgCEAE0MdHroI5bHNFt5QQn0=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-Ub9QsjdhMHOzmMKOK-mNeg-1; Thu, 01 May 2025 16:41:23 -0400
X-MC-Unique: Ub9QsjdhMHOzmMKOK-mNeg-1
X-Mimecast-MFC-AGG-ID: Ub9QsjdhMHOzmMKOK-mNeg_1746132083
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-7c543ab40d3so95282585a.2
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 13:41:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746132083; x=1746736883;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hDh6BZdRx6SbbMEEDIPz7yPlA5iRhs5NfAPHn1HWJJw=;
        b=O/P0/saqiPBS/y9LMhG0iUWbZuoIH7KGj09Ma7BiqzNPcfBvL+iP2EKEudT2+zLLiw
         hrLEjO870Fou4brrLHYW/e76fR4Ku2rQPV8PDT8nAsvYA7Juk61aoExJgg7RszdObJTs
         ZdkhU/Psm5Q/4HZ/lLPmAY83OBnBC3ZsAReYRGnVgKkXYFEk3FIrSx/t8IMq3U11mRpb
         13r825q+sZSKiTloYCd5KE9n87Gm7X21ju9Rp9Ihhrm/00KLJxtRi/Yz10StMD3O6m+L
         10nOVNKJ9DBYIcQNyeMliSRwpzpWJhbBJ5WYcatQT91Lu0YOV/EdzM8gm5ONRPfj411w
         Zj8w==
X-Gm-Message-State: AOJu0YzcoGrT7ggagco4qpbAsNimRLx3kF5VNed0yrykdugXr2YHVZhy
	RzHCSvYBzkpe57oT6MtarT8F96Qb+UmgU1tGdmRpbjTPgHbwkBEy23Uu9bq5LYe1weUn1ro5KjS
	FWrel7dMCVZ4pVbD/cYEkGCz5M8YlcUjrJhba2Zx0mx2/4e9ZQw==
X-Gm-Gg: ASbGnctifbPxRySL14kXTnxFE7rGJ3+PjYouWdpDwvXUO2/h5Tv9/2YK/EtyRY+yBN8
	MlWrre6YhYBu/Fm42bEv4+agFMs7bN2sx0eXgVCmK0H4ZD5ty6MjCovjHLS0E9clMq/RY3sFOSS
	IVbT/nipjJHtneL9o4sTgcw7Q44QtlC9OBJV0uVhIiMz1BQRv2ynmSOMmirplArHc9dCBZNA64H
	5UHP1eFJRpXgoSj7ljYnUAL3Is57aUAeN+I+EiFh17Uv7Nry3+lJMwopaY8n343H+8F68vRCBT3
	WT5KFDNIfUnbBky4gAcsNgi4gKD2nJ5IXrU28l3DWKQiyME847ucL8BBjYk=
X-Received: by 2002:a05:620a:4449:b0:7c5:79c6:645d with SMTP id af79cd13be357-7cad5b2e27emr57531785a.11.1746132082815;
        Thu, 01 May 2025 13:41:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFsabKjC2otznGEEqKo8X7z7SA1slbiHHBrdbKLBLDW/ocQgBJR4T/mXNdryiQbbDuhpRBQyQ==
X-Received: by 2002:a05:620a:4449:b0:7c5:79c6:645d with SMTP id af79cd13be357-7cad5b2e27emr57529985a.11.1746132082442;
        Thu, 01 May 2025 13:41:22 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cad23b5c0csm89171685a.3.2025.05.01.13.41.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 13:41:22 -0700 (PDT)
Message-ID: <2b1ec570a37992cdfa2edad325e53e0592d696c8.camel@redhat.com>
Subject: Re: [PATCH 3/3] x86: KVM: VMX: preserve host's
 DEBUGCTLMSR_FREEZE_IN_SMM while in the guest mode
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav
 Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 01 May 2025 16:41:21 -0400
In-Reply-To: <aAgpD_5BI6ZcCN29@google.com>
References: <20250416002546.3300893-1-mlevitsk@redhat.com>
	 <20250416002546.3300893-4-mlevitsk@redhat.com>
	 <aAgpD_5BI6ZcCN29@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Tue, 2025-04-22 at 16:41 -0700, Sean Christopherson wrote:
> On Tue, Apr 15, 2025, Maxim Levitsky wrote:
> > Pass through the host's DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM to the guest
> > GUEST_IA32_DEBUGCTL without the guest seeing this value.
> >=20
> > Note that in the future we might allow the guest to set this bit as wel=
l,
> > when we implement PMU freezing on VM own, virtual SMM entry.
> >=20
> > Since the value of the host DEBUGCTL can in theory change between VM ru=
ns,
> > check if has changed, and if yes, then reload the GUEST_IA32_DEBUGCTL w=
ith
> > the new value of the host portion of it (currently only the
> > DEBUGCTLMSR_FREEZE_IN_SMM bit)
>=20
> No, it can't.  DEBUGCTLMSR_FREEZE_IN_SMM can be toggled via IPI callback,=
 but
> IRQs are disabled for the entirety of the inner run loop.  And if I'm som=
ehow
> wrong, this change movement absolutely belongs in a separate patch.
>=20
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/svm/svm.c |  2 ++
> >  arch/x86/kvm/vmx/vmx.c | 28 +++++++++++++++++++++++++++-
> >  arch/x86/kvm/x86.c     |  2 --
> >  3 files changed, 29 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index cc1c721ba067..fda0660236d8 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -4271,6 +4271,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct =
kvm_vcpu *vcpu,
> >  	svm->vmcb->save.rsp =3D vcpu->arch.regs[VCPU_REGS_RSP];
> >  	svm->vmcb->save.rip =3D vcpu->arch.regs[VCPU_REGS_RIP];
> > =20
> > +	vcpu->arch.host_debugctl =3D get_debugctlmsr();
> > +
> >  	/*
> >  	 * Disable singlestep if we're injecting an interrupt/exception.
> >  	 * We don't want our modified rflags to be pushed on the stack where
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index c9208a4acda4..e0bc31598d60 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -2194,6 +2194,17 @@ static u64 vmx_get_supported_debugctl(struct kvm=
_vcpu *vcpu, bool host_initiated
> >  	return debugctl;
> >  }
> > =20
> > +static u64 vmx_get_host_preserved_debugctl(struct kvm_vcpu *vcpu)
>=20
> No, just open code handling DEBUGCTLMSR_FREEZE_IN_SMM, or make it a #defi=
ne.
> I'm not remotely convinced that we'll ever want to emulate DEBUGCTLMSR_FR=
EEZE_IN_SMM,
> and trying to plan for that possibility and adds complexity for no immedi=
ate value.

Hi,

The problem here is a bit different: we indeed are very unlikely to emulate=
 the
DEBUGCTLMSR_FREEZE_IN_SMM but however,=C2=A0when I wrote this patch I was s=
ure that this bit is=C2=A0
mandatory with PMU version of 2 or more,=C2=A0 but looks like it is optiona=
l after all:

"
Note that system software must check if the processor supports the IA32_DEB=
UGCTL.FREEZE_WHILE_SMM
control bit. IA32_DEBUGCTL.FREEZE_WHILE_SMM is supported if IA32_PERF_CAPAB=
IL-
ITIES.FREEZE_WHILE_SMM[Bit 12] is reporting 1. See Section 20.8 for details=
 of detecting the presence of
IA32_PERF_CAPABILITIES MSR."

KVM indeed doesn't set the bit 12 of IA32_PERF_CAPABILITIES.

However, note that the Linux kernel silently sets this bit without checking=
 the aforementioned capability=C2=A0
bit and ends up with a #GP exception, which it silently ignores.... (I chec=
ked this with a trace...)

This led me to believe that this bit should be unconditionally supported,
meaning that KVM should at least fake setting it without triggering a #GP.

Since that is not the case, I can revert to the simpler model of exclusivel=
y using GUEST_IA32_DEBUGCTL=C2=A0
while hiding the bit from the guest, however I do vote to keep the guest/ho=
st separation.

>=20
> > +{
> > +	/*
> > +	 * Bits of host's DEBUGCTL that we should preserve while the guest is
> > +	 * running.
> > +	 *
> > +	 * Some of those bits might still be emulated for the guest own use.
> > +	 */
> > +	return DEBUGCTLMSR_FREEZE_IN_SMM;
> >=20
> >  u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
> >  {
> >  	return to_vmx(vcpu)->msr_ia32_debugctl;
> > @@ -2202,9 +2213,11 @@ u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu=
)
> >  static void __vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data)
> >  {
> >  	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> > +	u64 host_mask =3D vmx_get_host_preserved_debugctl(vcpu);
> > =20
> >  	vmx->msr_ia32_debugctl =3D data;
> > -	vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> > +	vmcs_write64(GUEST_IA32_DEBUGCTL,
> > +		     (vcpu->arch.host_debugctl & host_mask) | (data & ~host_mask));
> >  }
> > =20
> >  bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host=
_initiated)
> > @@ -2232,6 +2245,7 @@ bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu=
, u64 data, bool host_initiated
> >  	return true;
> >  }
> > =20
> > +
>=20
> Spurious newline.
>=20
> >  /*
> >   * Writes msr value into the appropriate "register".
> >   * Returns 0 on success, non-0 otherwise.
> > @@ -7349,6 +7363,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bo=
ol force_immediate_exit)
> >  {
> >  	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> >  	unsigned long cr3, cr4;
> > +	u64 old_debugctl;
> > =20
> >  	/* Record the guest's net vcpu time for enforced NMI injections. */
> >  	if (unlikely(!enable_vnmi &&
> > @@ -7379,6 +7394,17 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, b=
ool force_immediate_exit)
> >  		vmcs_write32(PLE_WINDOW, vmx->ple_window);
> >  	}
> > =20
> > +	old_debugctl =3D vcpu->arch.host_debugctl;
> > +	vcpu->arch.host_debugctl =3D get_debugctlmsr();
> > +
> > +	/*
> > +	 * In case the host DEBUGCTL had changed since the last time we
> > +	 * read it, update the guest's GUEST_IA32_DEBUGCTL with
> > +	 * the host's bits.
> > +	 */
> > +	if (old_debugctl !=3D vcpu->arch.host_debugctl)
>=20
> This can and should be optimized to only do an update if a host-preserved=
 bit
> is toggled.

True, I will do this in the next version.

>=20
> > +		__vmx_set_guest_debugctl(vcpu, vmx->msr_ia32_debugctl);
>=20
> I would rather have a helper that explicitly writes the VMCS field, not o=
ne that
> sets the guest value *and* writes the VMCS field.

>=20
> The usage in init_vmcs() doesn't need to write vmx->msr_ia32_debugctl bec=
ause the
> vCPU is zero allocated, and this usage doesn't change vmx->msr_ia32_debug=
ctl.
> So the only path that actually needs to modify vmx->msr_ia32_debugctl is
> vmx_set_guest_debugctl().


But what about nested entry? nested entry pretty much sets the MSR to a val=
ue given by the guest.

Also technically the intel_pmu_legacy_freezing_lbrs_on_pmi also changes the=
 guest value by emulating what the real hardware does.

Best regards,
	Maxim Levitsky


>=20
> > +
> >  	/*
> >  	 * We did this in prepare_switch_to_guest, because it needs to
> >  	 * be within srcu_read_lock.
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index 844e81ee1d96..05e866ed345d 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -11020,8 +11020,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vc=
pu)
> >  		set_debugreg(0, 7);
> >  	}
> > =20
> > -	vcpu->arch.host_debugctl =3D get_debugctlmsr();
> > -
> >  	guest_timing_enter_irqoff();
> > =20
> >  	for (;;) {
> > --=20
> > 2.26.3
> >=20


