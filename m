Return-Path: <kvm+bounces-45712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8758AAAE316
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 16:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 787C818843B1
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 14:32:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F11257ACF;
	Wed,  7 May 2025 14:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gje4drZu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1264014A639
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 14:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746628318; cv=none; b=iQLlrSgsESzWG2KHThPY2u1emUUeLp5dEkyTDB0Lz/z8+2/aNkq8sioFU/eVa7ne4eown0s1Vm1UVmt/yceqL6YKeZ+1EW+5Rja3hHP59n8gbrhvB8x/SYKtkPDATsC4pK4uV8I2hbpFx7zGYD4lDlFD47qpDgpE5LooNeEuTh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746628318; c=relaxed/simple;
	bh=7yYilKzlRb1wobk4T7efVzhPGY1UJUSDmY6Z/erQisE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IB9s2aL+ArLMFvEw7+ey23F8Y6QT+ekeI4+tNhvIgDeM/AbqNCjsYKPpjEpCGmwNmhVk2n3LBtVWgqGmTQLRcLD33ObzBNS4iYXUIr3ABxgd8sG8VGBfiTN8FLBBZY+xivva177sQvpMy/jsFuPo2nWSWPVff4qIfVTfylla7wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gje4drZu; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746628315;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZInm4rjLgHBhDeLY8L35ue/0BVIVN7gqyBXxwnozS9Y=;
	b=gje4drZuCDjP668Z5sSRrsL4OZ6176Fpp5RAJq4xc+jfPROQt9jGW55mijBnQGWkmfhAk9
	tH+aArog1k/6ql9FmmowA8tcphdBn01fSAPE2NpGFhE0ViZsRAbOxDoEckOmW0Vlgycsaa
	gVr4oj9KKtY+FtH6IlP7QMCqNfwA5/0=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-kwwW4yMmP7CuwPf-BDEKQA-1; Wed, 07 May 2025 10:31:54 -0400
X-MC-Unique: kwwW4yMmP7CuwPf-BDEKQA-1
X-Mimecast-MFC-AGG-ID: kwwW4yMmP7CuwPf-BDEKQA_1746628313
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6f53913e2b6so26132236d6.2
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 07:31:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746628313; x=1747233113;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZInm4rjLgHBhDeLY8L35ue/0BVIVN7gqyBXxwnozS9Y=;
        b=hWDhzAnhsnCFng5witU7Jpfr/0kEyObxAh9QE6joUN5xJZPyBrSdvvP39cWA41wuZv
         yW+NVPDR2axhDMLW+7SMXF5HnByzCfjjBabWEYEhwQXshQWt5I2g0KpaDnJmrtNPLOWC
         JoXmVc413LRZIO79SXua/FrcQNtwjNfPCvcOo4c9FGWrtT0S2DiekVw38RcCAn8JYE1C
         Bw7JIgXJ1U0l8qd9/HBvxUP+OrFxPlZj+FCTbLun5UrA5HGl5fuGVR1oGl2dH3ePCR0o
         jaxR2BTICxPT0Rh64MYRXA8+zXJ+C0cnt53rVN72gEp547lkCA7Ii0JXB4YVWW7SUw+u
         BDbA==
X-Gm-Message-State: AOJu0Yxb9c9t4d3AtHgRo3JoAoslNeXmjYdf5F/S8hRzhP5hfWtEi1Y5
	l+zxvlaDye6pGU382lKlQu9zJ2kt1V+MHAO2UTAGJ8TkawNYrHq7lr40lD+nF6kCORHSO+u9U0V
	p8LUTx1vkLXfOpAG1SWg990HUSrnEc5m3eQW3tiqxV3QjY37eNw==
X-Gm-Gg: ASbGncv6I8X6SAWo6vUwd+el28klHKOJT2Qn6QaRRrdez9qPIM1EVd8ifBV28iDS5M2
	pL8+uN7y45NnNQFKGYeTjw0eji7p16hHAXaWm95toI4fUCUwEjd/t14ciBf7YFVXhQqoiKcCxk+
	FFFamve9aqGNxXhp7of6ieSicwuDwfvQy+tCzdE89WKs9q/VsjBNcWnkD+W+GXv5nTSJ/PKt5js
	gs93MDGmz3XkNpE9oVLm8pncXumEPvKOjMnu/mId1xcQ42g7Y0GzphD6dZrtLG/J1BaQ+ze3N9k
	notIUj86nA3W/F04SlZdaXDrahMGI4UUx91z14pAvHt/QxrImG1VXJu7uSM=
X-Received: by 2002:a05:6214:1c4d:b0:6e8:9797:f94e with SMTP id 6a1803df08f44-6f542aca9b5mr70435106d6.35.1746628313237;
        Wed, 07 May 2025 07:31:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFv9vy/0zgWY0FOElispXKGe875zqwYTTf4hH58cpmRPofLggcU9gWmVhEWS0Fy5x9wRdGMgg==
X-Received: by 2002:a05:6214:1c4d:b0:6e8:9797:f94e with SMTP id 6a1803df08f44-6f542aca9b5mr70434696d6.35.1746628312848;
        Wed, 07 May 2025 07:31:52 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f5427813f7sm14408406d6.71.2025.05.07.07.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 07:31:52 -0700 (PDT)
Message-ID: <ed4580b66a80359f3c4354c1effd5c267eba5189.camel@redhat.com>
Subject: Re: [PATCH 3/3] x86: KVM: VMX: preserve host's
 DEBUGCTLMSR_FREEZE_IN_SMM while in the guest mode
From: mlevitsk@redhat.com
To: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>, Sean Christopherson
	 <seanjc@google.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav
 Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 07 May 2025 10:31:51 -0400
In-Reply-To: <181eae79-735d-414e-9a46-caa321602204@linux.intel.com>
References: <20250416002546.3300893-1-mlevitsk@redhat.com>
	 <20250416002546.3300893-4-mlevitsk@redhat.com>
	 <aAgpD_5BI6ZcCN29@google.com>
	 <2b1ec570a37992cdfa2edad325e53e0592d696c8.camel@redhat.com>
	 <71af8435d2085b3f969cb3e73cff5bfacd243819.camel@redhat.com>
	 <181eae79-735d-414e-9a46-caa321602204@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-05-07 at 13:27 +0800, Mi, Dapeng wrote:
>=20
> On 5/2/2025 4:53 AM, mlevitsk@redhat.com=C2=A0wrote:
> > On Thu, 2025-05-01 at 16:41 -0400, mlevitsk@redhat.com=C2=A0wrote:
> > > On Tue, 2025-04-22 at 16:41 -0700, Sean Christopherson wrote:
> > > > On Tue, Apr 15, 2025, Maxim Levitsky wrote:
> > > > > Pass through the host's DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM to the=
 guest
> > > > > GUEST_IA32_DEBUGCTL without the guest seeing this value.
> > > > >=20
> > > > > Note that in the future we might allow the guest to set this bit =
as well,
> > > > > when we implement PMU freezing on VM own, virtual SMM entry.
> > > > >=20
> > > > > Since the value of the host DEBUGCTL can in theory change between=
 VM runs,
> > > > > check if has changed, and if yes, then reload the GUEST_IA32_DEBU=
GCTL with
> > > > > the new value of the host portion of it (currently only the
> > > > > DEBUGCTLMSR_FREEZE_IN_SMM bit)
> > > > No, it can't.=C2=A0 DEBUGCTLMSR_FREEZE_IN_SMM can be toggled via IP=
I callback, but
> > > > IRQs are disabled for the entirety of the inner run loop.=C2=A0 And=
 if I'm somehow
> > > > wrong, this change movement absolutely belongs in a separate patch.
> >=20
> > Hi,
> >=20
> > You are right here - reading MSR_IA32_DEBUGCTLMSR in the inner loop is =
a performance
> > regression.
> >=20
> >=20
> > Any ideas on how to solve this then? Since currently its the common cod=
e that
> > reads the current value of the MSR_IA32_DEBUGCTLMSR and it doesn't leav=
e any indication
> > about if it changed I can do either
> >=20
> > 1. store old value as well, something like 'vcpu->arch.host_debugctl_ol=
d' Ugly IMHO.
> >=20
> > 2. add DEBUG_CTL to the set of the 'dirty' registers, e.g add new bit f=
or kvm_register_mark_dirty
> > It looks a bit overkill to me
> >=20
> > 3. Add new x86 callback for something like .sync_debugctl(). I vote for=
 this option.
> >=20
> > What do you think/prefer?
>=20
> Hmm, not sure if I missed something, but why to move the reading host
> debug_ctrl MSR from the original place into inner loop? The interrupt has
> been disabled before reading host debug_ctrl for original code, suppose
> host debug_ctrl won't changed after reading it?

No, no, I propose to keep the call in the same place it is now,
just to wrap it with a callback which can compare the value with
previous value and then update the vmcs field if needed.


Best regards,
	Maxim Levitsky

>=20
>=20
> >=20
> > Best regards,
> > 	Maxim Levitsky
> >=20
> > > > > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > > > > ---
> > > > > =C2=A0arch/x86/kvm/svm/svm.c |=C2=A0 2 ++
> > > > > =C2=A0arch/x86/kvm/vmx/vmx.c | 28 +++++++++++++++++++++++++++-
> > > > > =C2=A0arch/x86/kvm/x86.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 --
> > > > > =C2=A03 files changed, 29 insertions(+), 3 deletions(-)
> > > > >=20
> > > > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > > > index cc1c721ba067..fda0660236d8 100644
> > > > > --- a/arch/x86/kvm/svm/svm.c
> > > > > +++ b/arch/x86/kvm/svm/svm.c
> > > > > @@ -4271,6 +4271,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(s=
truct kvm_vcpu *vcpu,
> > > > > =C2=A0	svm->vmcb->save.rsp =3D vcpu->arch.regs[VCPU_REGS_RSP];
> > > > > =C2=A0	svm->vmcb->save.rip =3D vcpu->arch.regs[VCPU_REGS_RIP];
> > > > > =C2=A0
> > > > > +	vcpu->arch.host_debugctl =3D get_debugctlmsr();
> > > > > +
> > > > > =C2=A0	/*
> > > > > =C2=A0	 * Disable singlestep if we're injecting an interrupt/exce=
ption.
> > > > > =C2=A0	 * We don't want our modified rflags to be pushed on the s=
tack where
> > > > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > > > index c9208a4acda4..e0bc31598d60 100644
> > > > > --- a/arch/x86/kvm/vmx/vmx.c
> > > > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > > > @@ -2194,6 +2194,17 @@ static u64 vmx_get_supported_debugctl(stru=
ct kvm_vcpu *vcpu, bool host_initiated
> > > > > =C2=A0	return debugctl;
> > > > > =C2=A0}
> > > > > =C2=A0
> > > > > +static u64 vmx_get_host_preserved_debugctl(struct kvm_vcpu *vcpu=
)
> > > > No, just open code handling DEBUGCTLMSR_FREEZE_IN_SMM, or make it a=
 #define.
> > > > I'm not remotely convinced that we'll ever want to emulate DEBUGCTL=
MSR_FREEZE_IN_SMM,
> > > > and trying to plan for that possibility and adds complexity for no =
immediate value.
> > > Hi,
> > >=20
> > > The problem here is a bit different: we indeed are very unlikely to e=
mulate the
> > > DEBUGCTLMSR_FREEZE_IN_SMM but however,=C2=A0when I wrote this patch I=
 was sure that this bit is=C2=A0
> > > mandatory with PMU version of 2 or more,=C2=A0 but looks like it is o=
ptional after all:
> > >=20
> > > "
> > > Note that system software must check if the processor supports the IA=
32_DEBUGCTL.FREEZE_WHILE_SMM
> > > control bit. IA32_DEBUGCTL.FREEZE_WHILE_SMM is supported if IA32_PERF=
_CAPABIL-
> > > ITIES.FREEZE_WHILE_SMM[Bit 12] is reporting 1. See Section 20.8 for d=
etails of detecting the presence of
> > > IA32_PERF_CAPABILITIES MSR."
> > >=20
> > > KVM indeed doesn't set the bit 12 of IA32_PERF_CAPABILITIES.
> > >=20
> > > However, note that the Linux kernel silently sets this bit without ch=
ecking the aforementioned capability=C2=A0
> > > bit and ends up with a #GP exception, which it silently ignores.... (=
I checked this with a trace...)
> > >=20
> > > This led me to believe that this bit should be unconditionally suppor=
ted,
> > > meaning that KVM should at least fake setting it without triggering a=
 #GP.
> > >=20
> > > Since that is not the case, I can revert to the simpler model of excl=
usively using GUEST_IA32_DEBUGCTL=C2=A0
> > > while hiding the bit from the guest, however I do vote to keep the gu=
est/host separation.
> > >=20
> > > > > +{
> > > > > +	/*
> > > > > +	 * Bits of host's DEBUGCTL that we should preserve while the gu=
est is
> > > > > +	 * running.
> > > > > +	 *
> > > > > +	 * Some of those bits might still be emulated for the guest own=
 use.
> > > > > +	 */
> > > > > +	return DEBUGCTLMSR_FREEZE_IN_SMM;
> > > > >=20
> > > > > =C2=A0u64 vmx_get_guest_debugctl(struct kvm_vcpu *vcpu)
> > > > > =C2=A0{
> > > > > =C2=A0	return to_vmx(vcpu)->msr_ia32_debugctl;
> > > > > @@ -2202,9 +2213,11 @@ u64 vmx_get_guest_debugctl(struct kvm_vcpu=
 *vcpu)
> > > > > =C2=A0static void __vmx_set_guest_debugctl(struct kvm_vcpu *vcpu,=
 u64 data)
> > > > > =C2=A0{
> > > > > =C2=A0	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> > > > > +	u64 host_mask =3D vmx_get_host_preserved_debugctl(vcpu);
> > > > > =C2=A0
> > > > > =C2=A0	vmx->msr_ia32_debugctl =3D data;
> > > > > -	vmcs_write64(GUEST_IA32_DEBUGCTL, data);
> > > > > +	vmcs_write64(GUEST_IA32_DEBUGCTL,
> > > > > +		=C2=A0=C2=A0=C2=A0=C2=A0 (vcpu->arch.host_debugctl & host_mask=
) | (data & ~host_mask));
> > > > > =C2=A0}
> > > > > =C2=A0
> > > > > =C2=A0bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data=
, bool host_initiated)
> > > > > @@ -2232,6 +2245,7 @@ bool vmx_set_guest_debugctl(struct kvm_vcpu=
 *vcpu, u64 data, bool host_initiated
> > > > > =C2=A0	return true;
> > > > > =C2=A0}
> > > > > =C2=A0
> > > > > +
> > > > Spurious newline.
> > > >=20
> > > > > =C2=A0/*
> > > > > =C2=A0 * Writes msr value into the appropriate "register".
> > > > > =C2=A0 * Returns 0 on success, non-0 otherwise.
> > > > > @@ -7349,6 +7363,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vc=
pu, bool force_immediate_exit)
> > > > > =C2=A0{
> > > > > =C2=A0	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
> > > > > =C2=A0	unsigned long cr3, cr4;
> > > > > +	u64 old_debugctl;
> > > > > =C2=A0
> > > > > =C2=A0	/* Record the guest's net vcpu time for enforced NMI injec=
tions. */
> > > > > =C2=A0	if (unlikely(!enable_vnmi &&
> > > > > @@ -7379,6 +7394,17 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *v=
cpu, bool force_immediate_exit)
> > > > > =C2=A0		vmcs_write32(PLE_WINDOW, vmx->ple_window);
> > > > > =C2=A0	}
> > > > > =C2=A0
> > > > > +	old_debugctl =3D vcpu->arch.host_debugctl;
> > > > > +	vcpu->arch.host_debugctl =3D get_debugctlmsr();
> > > > > +
> > > > > +	/*
> > > > > +	 * In case the host DEBUGCTL had changed since the last time we
> > > > > +	 * read it, update the guest's GUEST_IA32_DEBUGCTL with
> > > > > +	 * the host's bits.
> > > > > +	 */
> > > > > +	if (old_debugctl !=3D vcpu->arch.host_debugctl)
> > > > This can and should be optimized to only do an update if a host-pre=
served bit
> > > > is toggled.
> > > True, I will do this in the next version.
> > >=20
> > > > > +		__vmx_set_guest_debugctl(vcpu, vmx->msr_ia32_debugctl);
> > > > I would rather have a helper that explicitly writes the VMCS field,=
 not one that
> > > > sets the guest value *and* writes the VMCS field.
> > > > The usage in init_vmcs() doesn't need to write vmx->msr_ia32_debugc=
tl because the
> > > > vCPU is zero allocated, and this usage doesn't change vmx->msr_ia32=
_debugctl.
> > > > So the only path that actually needs to modify vmx->msr_ia32_debugc=
tl is
> > > > vmx_set_guest_debugctl().
> > >=20
> > > But what about nested entry? nested entry pretty much sets the MSR to=
 a value given by the guest.
> > >=20
> > > Also technically the intel_pmu_legacy_freezing_lbrs_on_pmi also chang=
es the guest value by emulating what the real hardware does.
> > >=20
> > > Best regards,
> > > 	Maxim Levitsky
> > >=20
> > >=20
> > > > > +
> > > > > =C2=A0	/*
> > > > > =C2=A0	 * We did this in prepare_switch_to_guest, because it need=
s to
> > > > > =C2=A0	 * be within srcu_read_lock.
> > > > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > > > index 844e81ee1d96..05e866ed345d 100644
> > > > > --- a/arch/x86/kvm/x86.c
> > > > > +++ b/arch/x86/kvm/x86.c
> > > > > @@ -11020,8 +11020,6 @@ static int vcpu_enter_guest(struct kvm_vc=
pu *vcpu)
> > > > > =C2=A0		set_debugreg(0, 7);
> > > > > =C2=A0	}
> > > > > =C2=A0
> > > > > -	vcpu->arch.host_debugctl =3D get_debugctlmsr();
> > > > > -
> > > > > =C2=A0	guest_timing_enter_irqoff();
> > > > > =C2=A0
> > > > > =C2=A0	for (;;) {
> > > > > --=20
> > > > > 2.26.3
> > > > >=20
> >=20
>=20


