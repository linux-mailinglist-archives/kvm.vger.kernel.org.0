Return-Path: <kvm+bounces-46276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C4BA5AB487A
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 02:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2B30E7A6F8C
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 00:33:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 753C278F4B;
	Tue, 13 May 2025 00:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E7+A/sRU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46A13F9FB
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 00:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747096453; cv=none; b=DL8UnqsecMkAYGV5OjTlC/llHuj4h53A2cqsLq/89wXbn8NUPY8nOw0kGMlsGtR7Zgv/090DbY85bhizlVijqyMUXjTuQlero1ZrlUB70xr9Sk1sM1H8XnUjpZrkWRWfXgM0eATEtVSf2aJDhlI11QY4dV3TE+eLhqD3i9vKz8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747096453; c=relaxed/simple;
	bh=fU7pBdKdDLvcMx8zh+viNeC2gR91xPbL999COyMNtfI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=qifoMUMYTzBIdGutQghXXdk2CSF4EcHCB1lpnQFkO8f7zhXVxn20iQ4iKlVdqIAgZIbQpT7NbJwNHoUjf/gkhGhOW2IsKCp380RhIzO+HiGLPK0+VwqlFR4cEYP+Js3O8IaLS7ZxXqXywLFjMUgVZdgwJbKmUTZhZjP65z0poDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E7+A/sRU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747096450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MuVgDh54fhNKdyszi5Ue5nINMoJxAHC1Wn8pfTLezZ8=;
	b=E7+A/sRUhHUEQihYzYD/FUduoPFmD5WrsAS5XHAS8Sb7wjrF3LTcVLoenez9s2uPZJmRDg
	UO3dFKs27+cEcOnzC9YOAmpWpNlRs/928KGDcNwrGm00bIPKhHmYpvNb8Tjx52PQq6YBdS
	L5AJi86VWZc4GjqisxopxGXMSBZQf+o=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-CGc7Rjx4NxanebS-3SxP-g-1; Mon, 12 May 2025 20:34:06 -0400
X-MC-Unique: CGc7Rjx4NxanebS-3SxP-g-1
X-Mimecast-MFC-AGG-ID: CGc7Rjx4NxanebS-3SxP-g_1747096445
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-6f6e7c6a3fbso81873356d6.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 17:34:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747096445; x=1747701245;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MuVgDh54fhNKdyszi5Ue5nINMoJxAHC1Wn8pfTLezZ8=;
        b=jntpjV47ZdXkNNyXwQFdOjHj3pHUpdyWviDKxCxBdBo0EgKo+7THbq0XXBRAPXDhWX
         WwkW755DghFeQL03ZLhGoRRbH1gmJ15y/QALX7BdXYOqO7EUYnT8aJOIIsIQloeDdSh0
         oGlI7ug9yQwhhyMjElWyFs9OlKXknz53nfclWp0jPD9ol0h7Cviwpu00FyDRdVq8/oNY
         MhrohmjG1ilEt1MYkUTxw4z4KFAS6o3oNbNlKHcIjRclrQRPVfAyUDwgnQwAOG4cdioB
         UYBTKrm0Z5LqvGlwOQM64WpMC+tdp2voDuqaNqHWJediuXP1QZN/fBiBeOfOd3JlHLpf
         ImJQ==
X-Gm-Message-State: AOJu0YxfKcjtalX83fjteY9fnveGxzG4aIxw1QwNVDFCmPdZjY/RJdhI
	IGRVCO1XxUukUcSTf01TF+bQUBOpwL4Wdg+VMdqWsR6sX3F6jr2IVd6GqWTcleIGwHcmA8uMmc7
	QeG+0yxqivf2c1v/gHAARQXnahC+cLOgy9IVxUqXZg8ZnpoHxnw==
X-Gm-Gg: ASbGnctwHpQq0gLDrw3jrk9qWg4JFjo6qSK+sSXuZeEbuv6jskfvWXFMZCmrpEFRIeS
	tfmPwQ5khOtAyGGtM3pmVRqxwbAR26wcR1PwfhyCCApdYXm3oriSFPaepSmVoYlkIc68Hc2uNEg
	yiQ+Xj8uTXBc0PV+tKzX0waaRROufYmEhQJ2Hw11XsK1Gw3SKmmo7k6+/nj6hLFoFjC8e439H2b
	anOFiYbGR97wiXYRWPdwJx3tztf1L3ITEKA3g7EuIch3MK8koX6edf8Ujl/AWVV5cKOfTGFNTGz
	XdIgl+RiD2Fn3Cg6uci8LFWKQmVaExOwCXxst7VNx77DMlgEe0ns/oAfpg0=
X-Received: by 2002:a05:6214:f03:b0:6f2:a4cf:5fd7 with SMTP id 6a1803df08f44-6f6e4848aa4mr231130856d6.45.1747096445496;
        Mon, 12 May 2025 17:34:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF8aGvObkI3NF7VMdyY5mR4dqP88kLTJMkaUNYqYbYgo2VKQhOvw1mD6AuqFsDuxk5hHuobFw==
X-Received: by 2002:a05:6214:f03:b0:6f2:a4cf:5fd7 with SMTP id 6a1803df08f44-6f6e4848aa4mr231130676d6.45.1747096445084;
        Mon, 12 May 2025 17:34:05 -0700 (PDT)
Received: from ?IPv6:2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38? ([2607:fea8:fc01:8d8d:5c3d:ce6:f389:cd38])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f6e3a0c5eesm59058176d6.61.2025.05.12.17.34.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 17:34:04 -0700 (PDT)
Message-ID: <9ac64e89dc5467e15c397e7bc14f775c693f91d7.camel@redhat.com>
Subject: Re: [PATCH 1/3] x86: KVM: VMX: Wrap GUEST_IA32_DEBUGCTL read/write
 with access functions
From: mlevitsk@redhat.com
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav
 Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
 Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
 linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 12 May 2025 20:34:03 -0400
In-Reply-To: <aBuV7JmMU3TcsqFW@google.com>
References: <20250416002546.3300893-1-mlevitsk@redhat.com>
	 <20250416002546.3300893-2-mlevitsk@redhat.com>
	 <aAgnRx2aMbNKOlXY@google.com>
	 <14eab14d368e68cb9c94c655349f94f44a9a15b4.camel@redhat.com>
	 <aBuV7JmMU3TcsqFW@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-05-07 at 10:18 -0700, Sean Christopherson wrote:
> On Thu, May 01, 2025, mlevitsk@redhat.com=C2=A0wrote:
> > On Tue, 2025-04-22 at 16:33 -0700, Sean Christopherson wrote:
> > > > @@ -2653,11 +2654,17 @@ static int prepare_vmcs02(struct kvm_vcpu *=
vcpu, struct vmcs12 *vmcs12,
> > > > =C2=A0	if (vmx->nested.nested_run_pending &&
> > > > =C2=A0	=C2=A0=C2=A0=C2=A0 (vmcs12->vm_entry_controls & VM_ENTRY_LOA=
D_DEBUG_CONTROLS)) {
> > > > =C2=A0		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
> > > > -		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl);
> > > > +		new_debugctl =3D vmcs12->guest_ia32_debugctl;
> > > > =C2=A0	} else {
> > > > =C2=A0		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
> > > > -		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugc=
tl);
> > > > +		new_debugctl =3D vmx->nested.pre_vmenter_debugctl;
> > > > =C2=A0	}
> > > > +
> > > > +	if (CC(!vmx_set_guest_debugctl(vcpu, new_debugctl, false))) {
> > >=20
> > > The consistency check belongs in nested_vmx_check_guest_state(), only=
 needs to
> > > check the VM_ENTRY_LOAD_DEBUG_CONTROLS case, and should be posted as =
a separate
> > > patch.
> >=20
> > I can move it there. Can you explain why though you want this? Is it be=
cause of the
> > order of checks specified in the PRM?
>=20
> To be consistent with how KVM checks guest state.=C2=A0 The two checks in=
 prepare_vmcs02()
> are special cases.=C2=A0 vmx_guest_state_valid() consumes a huge variety =
of state, and
> so replicating all of its logic for vmcs12 isn't worth doing.=C2=A0 The c=
heck on the
> kvm_set_msr() for guest_ia32_perf_global_ctrl exists purely so that KVM d=
oesn't
> simply ignore the return value.
>=20
> And to a lesser degree, because KVM assumes that guest state has been san=
itized
> after nested_vmx_check_guest_state() is called.=C2=A0 Violating that risk=
s introducing
> bugs, e.g. consuming vmcs12->guest_ia32_debugctl before it's been vetted =
could
> theoretically be problematic.
>=20
> > Currently GUEST_IA32_DEBUGCTL of the host is *written* in prepare_vmcs0=
2.=C2=A0
> > Should I also move this write to nested_vmx_check_guest_state?
>=20
> No.=C2=A0 nested_vmx_check_guest_state() verifies the incoming vmcs12 sta=
te,
> prepare_vmcs02() merges the vmcs12 state with KVM's desires and fills vmc=
s02.
>=20
> > Or should I write the value blindly in prepare_vmcs02 and then check th=
e value
> > of 'vmx->msr_ia32_debugctl' in nested_vmx_check_guest_state and fail if=
 the value
> > contains reserved bits?=C2=A0
>=20
> I don't follow.=C2=A0 nested_vmx_check_guest_state() is called before pre=
pare_vmcs02().

My mistake, I for some reason thought that nested_vmx_check_guest_state is =
called from
prepare_vmcs02(). Your explanation now makes sense.


>=20
> > > > +bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool =
host_initiated)
> > > > +{
> > > > +	u64 invalid =3D data & ~vmx_get_supported_debugctl(vcpu, host_ini=
tiated);
> > > > +
> > > > +	if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
> > > > +		kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
> > > > +		data &=3D ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
> > > > +		invalid &=3D ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
> > > > +	}
> > > > +
> > > > +	if (invalid)
> > > > +		return false;
> > > > +
> > > > +	if (is_guest_mode(vcpu) && (get_vmcs12(vcpu)->vm_exit_controls &
> > > > +					VM_EXIT_SAVE_DEBUG_CONTROLS))
> > > > +		get_vmcs12(vcpu)->guest_ia32_debugctl =3D data;
> > > > +
> > > > +	if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.eve=
nt &&
> > > > +	=C2=A0=C2=A0=C2=A0 (data & DEBUGCTLMSR_LBR))
> > > > +		intel_pmu_create_guest_lbr_event(vcpu);
> > > > +
> > > > +	__vmx_set_guest_debugctl(vcpu, data);
> > > > +	return true;
> > >=20
> > > Return 0/-errno, not true/false.
> >=20
> > There are plenty of functions in this file and KVM that return boolean.
>=20
> That doesn't make them "right".=C2=A0 For helpers that are obvious predic=
ates, then
> absolutely use a boolean return value.=C2=A0 The names for nested_vmx_che=
ck_eptp()
> and vmx_control_verify() aren't very good, e.g. they should be
> nested_vmx_is_valid_eptp() and vmx_is_valid_control(), but the intent is =
good.
>=20
> But for flows like modifying guest state, KVM should return 0/-errno.
>=20
> > e.g:=C2=A0
> >=20
> > static bool nested_vmx_check_eptp(struct kvm_vcpu *vcpu, u64 new_eptp)
> > static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
> > static bool nested_evmcs_handle_vmclear(struct kvm_vcpu *vcpu, gpa_t vm=
ptr)
> > static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> > 						=C2=A0struct vmcs12 *vmcs12)
>=20
> These two should return 0/-errno.
>=20
> =C2=A0
> > static bool nested_vmx_check_eptp(struct kvm_vcpu *vcpu, u64 new_eptp)
> > static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)
>=20
> Probably should return 0/-errno, but nested_get_vmcs12_pages() is a bit o=
f a mess.

I am not going to argue with you about this, let it be.

>=20
> > ...
> >=20
> >=20
> > I personally think that functions that emulate hardware should return b=
oolean
> > values or some hardware specific status code (e.g VMX failure code) bec=
ause
> > the real hardware never returns -EINVAL and such.
>=20
> Real hardware absolutely "returns" granular error codes.=C2=A0 KVM even h=
as informal
> mappings between some of them, e.g. -EINVAL =3D=3D #GP, -EFAULT =3D=3D #P=
F, -EOPNOTSUPP =3D=3D #UD,
> BUG() =3D=3D 3-strike #MC.
>=20
> And hardware has many more ways to report errors to software. E.g. VMLAUN=
CH can
> #UD, #GP(0), VM-Exit, VMfailInvalid, or VMFailValid with 30+ unique reaso=
ns.=C2=A0 #MC
> has a crazy number of possible error encodings.=C2=A0 And so on and so fo=
rth.
>=20
> Software visible error codes aside, comparing individual KVM functions to=
 an
> overall CPU is wildly misguided.=C2=A0 A more appropriate comparison woul=
d be between
> a KVM function and the ucode for a single instruction/operation.=C2=A0 I =
highly, highly
> doubt ucode flows are limited to binary yes/no outputs.

I don't think you understood my point - I just pointed out that real hardwa=
re will never return
things like -EINVAL.

I never have claimed that real hardware never does return error codes - it =
of course does,=C2=A0
like indeed VMX can return something like 77 different error codes.

So I said that functions that emulate hardware should return either boolean=
 in case hardware
only accepts/rejects the action, or hardware specific error codes, because
I think that its a bit confusing to map hardware error codes and kernel err=
or codes.

In case of MSR write, hardware response is more or less boolean - hardware =
either accepts
the write or raises #GP.


Yes I understand that hardware can in theory also #UD, or silently ignore w=
rite, etc,
so I am not going to argue about this, let it be.

AFAIK the KVM convention for msr writes is that 1 is GP, 0 success, and neg=
ative value
exits as a KVM internal error to userspace. Not very developer friendly IMH=
O, there is
a room for improvement here.

And I see that we now also have KVM_MSR_RET_UNSUPPORTED and KVM_MSR_RET_FIL=
TERED.

Thanks for the review,
Best regards,
	Maxim Levitsky

>=20


