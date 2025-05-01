Return-Path: <kvm+bounces-45175-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 59BC3AA64EC
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 22:53:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D979C1BC18D8
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 20:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B90F253949;
	Thu,  1 May 2025 20:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WMRUeRsI"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D3B21ABDA
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 20:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746132804; cv=none; b=hMII8VT4sIpeOMzVVzvIqO3NiIg895LLYwlNAQMi2tfvaQY/s3qK/RedyO/3C8QH5+hyzHZ+VAEldmRPzdbhcAW4EGTgJLVNyX89voSnsUrfFkZ8e57YiQ4cbAqPo/IRULiij32bltsjogZf7iI8yALBEgQbPLE9G7EdjjAvRpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746132804; c=relaxed/simple;
	bh=sDgdV7kEfpesjMxgSV9BAFx0Lp7HNF0MC0At1JAXWGU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lU8lfxhEeeb867XbM0sjye5OOt2lMz80llOQTKjGqw9ZzbySzqzWC7XOPp8Yznl29IYSQWPZCszd3j3AhzLFTD/ago1m6tozsImVwCO6GFji/FwTPKr1xYfXDMnom3G/233otxRrJXW3DEBmczfQhqxZJwI+jdPBhWiqCmg1ar0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WMRUeRsI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746132801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5P0E5k2AlWaMfQ5n+Z0U4ZG+1HEMantVwxdfw0oDYeo=;
	b=WMRUeRsI4DVnCeZ93xlOtayzn35OKJTq/KmImMnaPnSkip+3qLW3pn59iOvAT/ubgvppZr
	yMIUyh6Duknc8UMsCBHtlJKS4paYPyMrjjRniD0FgR7z1mCdRNkAoNe1SmYn+dc+W5BnJb
	xkcvI0DTEy4kO/UZdhBIQDpHr8BxFOw=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211--650xxfXPhaHRV7YkBGUHA-1; Thu, 01 May 2025 16:53:20 -0400
X-MC-Unique: -650xxfXPhaHRV7YkBGUHA-1
X-Mimecast-MFC-AGG-ID: -650xxfXPhaHRV7YkBGUHA_1746132800
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-4853364ad97so18087861cf.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 13:53:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746132800; x=1746737600;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5P0E5k2AlWaMfQ5n+Z0U4ZG+1HEMantVwxdfw0oDYeo=;
        b=b7alGXDap3qll1Bvj2R0H3H9Y8lPI/3MfacJ50l2KDfTC2J9QfNz+VeytG2OdJytB1
         iaDjTBKPnDrNxb8Jr3nkY5C9NvC8mTn7QonFjQplo88DrAZfuXC+xhMpwSEgQPdkCzZE
         O2HDNZjeVoH5NyAEf7pFka/cLQjnzL5A30/GWbmC21wTVRzftPl0Ts6vD5F7cBLBES8f
         D/jS1CgFEMm3zBzMd65N+x+Gz/0wo4Z8vQKs8ZngVf9xLp3pV3P0XdTx7TRUCvbp4FDu
         9OYGYLLyzoetEHrZzVkNCeTJnPwBjyqm2ezME9isd/9gTDwoyU7hgLpAkI+EMDAQxbpw
         2cCg==
X-Gm-Message-State: AOJu0YzjlhH0Gi4cHAlkDqFt+NOn8zqc0PhhNk9Uy8HeZQnl6RB9wc3F
	cJwLFs1G0EUI+I3fVYrurl+jmOe1c3nrk+IRSfBlzA6K1DkdSAMDjB9eD+mYocMwrm0aEShoa1P
	7yKjfAQIMEPTj4Y2inPLg6dPEVVlFZ8xHGOZevKd638i+t1ZMDQ==
X-Gm-Gg: ASbGncv8ZNn7tsocypSWztxwkM8nzNzQwuMUVQbRgB9rwSZVcaK6MPWRT/84kvvcUks
	/MyqCmkKZVTi3WV914JGD2rX1w7Sr4znU+EPZ8Cfgwaygm4Q+DBWHrfCZNS9N+uveoZ25QJu7WL
	YBDmYkgxgv/irZE0yIzC5CwSPuRcVXVdLaCHc0sqm+uQblecMShJu8pVZoG3BSZnZX2/62Hq1bu
	acEBPQ9HIxvTodws/Gt+wGopWpjRKcwCaiAxuqy3te+qOOAgyUSry0Y1h+oH6nW9OU6v82M6N0V
	6hGr+6hLjU7udMqy9bUvEu7E3xuTNNKUWJSB3oIL1uaFSHk2uqK1tNupS4c=
X-Received: by 2002:ac8:60c4:0:b0:476:964a:e338 with SMTP id d75a77b69052e-48c31a21a97mr4871301cf.28.1746132799693;
        Thu, 01 May 2025 13:53:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCgam0reS3mkWmKQOnjrpukFL6CG5qUSmU3pyvNgght0bHcb9KgjGJ8GWELvI5SrCPh8TCxQ==
X-Received: by 2002:ac8:60c4:0:b0:476:964a:e338 with SMTP id d75a77b69052e-48c31a21a97mr4870991cf.28.1746132799319;
        Thu, 01 May 2025 13:53:19 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-48b98720a0dsm8346791cf.58.2025.05.01.13.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 13:53:18 -0700 (PDT)
Message-ID: <71af8435d2085b3f969cb3e73cff5bfacd243819.camel@redhat.com>
Subject: Re: [PATCH 3/3] x86: KVM: VMX: preserve host's
 DEBUGCTLMSR_FREEZE_IN_SMM while in the guest mode
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav
 Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date: Thu, 01 May 2025 16:53:17 -0400
In-Reply-To: <2b1ec570a37992cdfa2edad325e53e0592d696c8.camel@redhat.com>
References: <20250416002546.3300893-1-mlevitsk@redhat.com>
	 <20250416002546.3300893-4-mlevitsk@redhat.com>
	 <aAgpD_5BI6ZcCN29@google.com>
	 <2b1ec570a37992cdfa2edad325e53e0592d696c8.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2025-05-01 at 16:41 -0400, mlevitsk@redhat.com wrote:
> On Tue, 2025-04-22 at 16:41 -0700, Sean Christopherson wrote:
> > On Tue, Apr 15, 2025, Maxim Levitsky wrote:
> > > Pass through the host's DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM to the gue=
st
> > > GUEST_IA32_DEBUGCTL without the guest seeing this value.
> > >=20
> > > Note that in the future we might allow the guest to set this bit as w=
ell,
> > > when we implement PMU freezing on VM own, virtual SMM entry.
> > >=20
> > > Since the value of the host DEBUGCTL can in theory change between VM =
runs,
> > > check if has changed, and if yes, then reload the GUEST_IA32_DEBUGCTL=
 with
> > > the new value of the host portion of it (currently only the
> > > DEBUGCTLMSR_FREEZE_IN_SMM bit)
> >=20
> > No, it can't.=C2=A0 DEBUGCTLMSR_FREEZE_IN_SMM can be toggled via IPI ca=
llback, but
> > IRQs are disabled for the entirety of the inner run loop.=C2=A0 And if =
I'm somehow
> > wrong, this change movement absolutely belongs in a separate patch.


Hi,

You are right here - reading MSR_IA32_DEBUGCTLMSR in the inner loop is a pe=
rformance
regression.


Any ideas on how to solve this then? Since currently its the common code th=
at
reads the current value of the MSR_IA32_DEBUGCTLMSR and it doesn't leave an=
y indication
about if it changed I can do either

1. store old value as well, something like 'vcpu->arch.host_debugctl_old' U=
gly IMHO.

2. add DEBUG_CTL to the set of the 'dirty' registers, e.g add new bit for k=
vm_register_mark_dirty
It looks a bit overkill to me

3. Add new x86 callback for something like .sync_debugctl(). I vote for thi=
s option.

What do you think/prefer?

Best regards,
	Maxim Levitsky

> >=20
> > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > ---
> > > =C2=A0arch/x86/kvm/svm/svm.c |=C2=A0 2 ++
> > > =C2=A0arch/x86/kvm/vmx/vmx.c | 28 +++++++++++++++++++++++++++-
> > > =C2=A0arch/x86/kvm/x86.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 --
> > > =C2=A03 files changed, 29 insertions(+), 3 deletions(-)
> > >=20
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index cc1c721ba067..fda0660236d8 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -4271,6 +4271,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struc=
t kvm_vcpu *vcpu,
> > > =C2=A0	svm->vmcb->save.rsp =3D vcpu->arch.regs[VCPU_REGS_RSP];
> > > =C2=A0	svm->vmcb->save.rip =3D vcpu->arch.regs[VCPU_REGS_RIP];
> > > =C2=A0
> > > +	vcpu->arch.host_debugctl =3D get_debugctlmsr();
> > > +
> > > =C2=A0	/*
> > > =C2=A0	 * Disable singlestep if we're injecting an interrupt/exceptio=
n.
> > > =C2=A0	 * We don't want our modified rflags to be pushed on the stack=
 where
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index c9208a4acda4..e0bc31598d60 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -2194,6 +2194,17 @@ static u64 vmx_get_supported_debugctl(struct k=
vm_vcpu *vcpu, bool host_initiated
> > > =C2=A0	return debugctl;
> > > =C2=A0}
> > > =C2=A0
> > > +static u64 vmx_get_host_preserved_debugctl(struct kvm_vcpu *vcpu)
> >=20
> > No, just open code handling DEBUGCTLMSR_FREEZE_IN_SMM, or make it a #de=
fine.
> > I'm not remotely convinced that we'll ever want to emulate DEBUGCTLMSR_=
FREEZE_IN_SMM,
> > and trying to plan for that possibility and adds complexity for no imme=
diate value.
>=20
> Hi,
>=20
> The problem here is a bit different: we indeed are very unlikely to emula=
te the
> DEBUGCTLMSR_FREEZE_IN_SMM but however,=C2=A0when I wrote this patch I was=
 sure that this bit is=C2=A0
> mandatory with PMU version of 2 or more,=C2=A0 but looks like it is optio=
nal after all:
>=20
> "
> Note that system software must check if the processor supports the IA32_D=
EBUGCTL.FREEZE_WHILE_SMM
> control bit. IA32_DEBUGCTL.FREEZE_WHILE_SMM is supported if IA32_PERF_CAP=
ABIL-
> ITIES.FREEZE_WHILE_SMM[Bit 12] is reporting 1. See Section 20.8 for detai=
ls of detecting the presence of
> IA32_PERF_CAPABILITIES MSR."
>=20
> KVM indeed doesn't set the bit 12 of IA32_PERF_CAPABILITIES.
>=20
> However, note that the Linux kernel silently sets this bit without checki=
ng the aforementioned capability=C2=A0
> bit and ends up with a #GP exception, which it silently ignores.... (I ch=
ecked this with a trace...)
>=20
> This led me to believe that this bit should be unconditionally supported,
> meaning that KVM should at least fake setting it without triggering a #GP=
.
>=20
> Since that is not the case, I can revert to the simpler model of exclusiv=
ely using GUEST_IA32_DEBUGCTL=C2=A0
> while hiding the bit from the guest, however I do vote to keep the guest/=
host separation.
>=20
> >=20
> > > +{
> > > +	/*
> > > +	 * Bits of host's DEBUGCTL that we should preserve while the guest =
is
> > > +	 * running.
> > > +	 *
> > > +	 * Some of those bits might still be emulated for the guest own use=
.
> > > +	 */
> > > +	return DEBUGCTLMSR_FREEZE_IN_SMM;
> > >=20
> > > =C2=A0u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
> > > =C2=A0{
> > > =C2=A0	return to_vmx(vcpu)->msr_ia32_debugctl;
> > > @@ -2202,9 +2213,11 @@ u64 vmx_get_guest_debugctl(struct kvm_vcpu *vc=
pu)
> > > =C2=A0static void __vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64=
 data)
> > > =C2=A0{
> > > =C2=A0	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> > > +	u64 host_mask =3D vmx_get_host_preserved_debugctl(vcpu);
> > > =C2=A0
> > > =C2=A0	vmx->msr_ia32_debugctl =3D data;
> > > -	vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> > > +	vmcs_write64(GUEST_IA32_DEBUGCTL,
> > > +		=C2=A0=C2=A0=C2=A0=C2=A0 (vcpu->arch.host_debugctl & host_mask) | =
(data & ~host_mask));
> > > =C2=A0}
> > > =C2=A0
> > > =C2=A0bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bo=
ol host_initiated)
> > > @@ -2232,6 +2245,7 @@ bool vmx_set_guest_debugctl(struct kvm_vcpu *vc=
pu, u64 data, bool host_initiated
> > > =C2=A0	return true;
> > > =C2=A0}
> > > =C2=A0
> > > +
> >=20
> > Spurious newline.
> >=20
> > > =C2=A0/*
> > > =C2=A0 * Writes msr value into the appropriate "register".
> > > =C2=A0 * Returns 0 on success, non-0 otherwise.
> > > @@ -7349,6 +7363,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, =
bool force_immediate_exit)
> > > =C2=A0{
> > > =C2=A0	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> > > =C2=A0	unsigned long cr3, cr4;
> > > +	u64 old_debugctl;
> > > =C2=A0
> > > =C2=A0	/* Record the guest's net vcpu time for enforced NMI injection=
s. */
> > > =C2=A0	if (unlikely(!enable_vnmi &&
> > > @@ -7379,6 +7394,17 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu,=
 bool force_immediate_exit)
> > > =C2=A0		vmcs_write32(PLE_WINDOW, vmx->ple_window);
> > > =C2=A0	}
> > > =C2=A0
> > > +	old_debugctl =3D vcpu->arch.host_debugctl;
> > > +	vcpu->arch.host_debugctl =3D get_debugctlmsr();
> > > +
> > > +	/*
> > > +	 * In case the host DEBUGCTL had changed since the last time we
> > > +	 * read it, update the guest's GUEST_IA32_DEBUGCTL with
> > > +	 * the host's bits.
> > > +	 */
> > > +	if (old_debugctl !=3D vcpu->arch.host_debugctl)
> >=20
> > This can and should be optimized to only do an update if a host-preserv=
ed bit
> > is toggled.
>=20
> True, I will do this in the next version.
>=20
> >=20
> > > +		__vmx_set_guest_debugctl(vcpu, vmx->msr_ia32_debugctl);
> >=20
> > I would rather have a helper that explicitly writes the VMCS field, not=
 one that
> > sets the guest value *and* writes the VMCS field.
>=20
> >=20
> > The usage in init_vmcs() doesn't need to write vmx->msr_ia32_debugctl b=
ecause the
> > vCPU is zero allocated, and this usage doesn't change vmx->msr_ia32_deb=
ugctl.
> > So the only path that actually needs to modify vmx->msr_ia32_debugctl i=
s
> > vmx_set_guest_debugctl().
>=20
>=20
> But what about nested entry? nested entry pretty much sets the MSR to a v=
alue given by the guest.
>=20
> Also technically the intel_pmu_legacy_freezing_lbrs_on_pmi also changes t=
he guest value by emulating what the real hardware does.
>=20
> Best regards,
> 	Maxim Levitsky
>=20
>=20
> >=20
> > > +
> > > =C2=A0	/*
> > > =C2=A0	 * We did this in prepare_switch_to_guest, because it needs to
> > > =C2=A0	 * be within srcu_read_lock.
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > index 844e81ee1d96..05e866ed345d 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -11020,8 +11020,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *=
vcpu)
> > > =C2=A0		set_debugreg(0, 7);
> > > =C2=A0	}
> > > =C2=A0
> > > -	vcpu->arch.host_debugctl =3D get_debugctlmsr();
> > > -
> > > =C2=A0	guest_timing_enter_irqoff();
> > > =C2=A0
> > > =C2=A0	for (;;) {
> > > --=20
> > > 2.26.3
> > >=20
>=20


