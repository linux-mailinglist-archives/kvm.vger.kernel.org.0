Return-Path: <kvm+bounces-45751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A207CAAE7A1
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 19:18:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9617E3ADF1F
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 17:18:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B3D28C5C3;
	Wed,  7 May 2025 17:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hxZuZ3r7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C70289838
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 17:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746638320; cv=none; b=RqcEp/kZAR/nGNDOFHud7hIlmLjIXJ+SnyQipbb6o/+zJwpqh6nG5LkQlKJo3cOlnECIu8BMS2zx4iRLFDC3GccboZCIOPHVQ9wWJwDBmveI2pA9SYVAZwzPjs2IBaXsAdXg5liUEdRrVMAKWb3yB2ZhrVoxK0D2XWg6eNXmaCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746638320; c=relaxed/simple;
	bh=6TlXcixluNZBX/cBcVtudohfU6ZkVmPkiJmfN2wbluo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m81tYlUBEcUdXNoXsq5/lFvh3pNuOXUjyEBZ01l6UkxtM6kRcT+qDQamENwQ5v8YqMcjLGj2R12ZsIg3QpYtp0I6REr016kHby+CmbYxUeIL3OFvPggDvNITCk7YLtO9jqx7BHhWXDsVNSQuycQY12bJSTqQjXjc592e4o5PlKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hxZuZ3r7; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736c7d0d35aso174340b3a.1
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 10:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746638318; x=1747243118; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pG2jzoW6yflVwdmuJU0J3q47K/+FWuNpEk3e+XtfNkY=;
        b=hxZuZ3r7eTxurUn67KZ2gm8cw3qrBmR5yGjhb7cwhPZYBPDdug+p6ym5/sM63QQafp
         XKMX9jNpqa2PWTXgK9PKDYAUhthzNwAX4Z9Y8lmmWTrrf9j62X8Raykw69GT8dfxorvB
         9C+xhc6s/NmdFwgtx/AaBAXIvC+FkVbynj4XPwkzfnuRYishujdkk19cPDZ6fj3HJ2Sl
         agX2M5tdvJsVtqJfXiULFTe4m+T1zOz1Aie/xJVD3XbNKuE73AtP9WizxPzDWmbLv5lO
         h6b4CTFYPu7aZaitEMlAJdPdNROM1XMLmg1gdZ/oEQY+4/C9OS66YXjOgLJKRcDeb894
         HAAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746638318; x=1747243118;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pG2jzoW6yflVwdmuJU0J3q47K/+FWuNpEk3e+XtfNkY=;
        b=co7yEA30KuUPm+E0MAq1d2ev5l+dcGV1n01+JBd1N+G3IoA6dQHaAjw15ub2Xfzeql
         YP0iSSx7PHAtxQunZ+Nmbz0ye6TpYnSSuYSfGtJN37Z4j0VVNMs8Cghsfxtgel6OHNn5
         MkotH5jGQo3rpUywJ4/jDs9tuRjLHEniKchgpbfl2HYanER2FSmekXfU78WL1lalKG+r
         +ZaYJFoCf0oj7XUBz5f4ONgHK+qtpJIe1b8OsaPPiJrGm8NNo/km2glESf5ib4dB1Q2A
         S0djU086XIdb2Apc3IplIDRKQ1z067QCWNm89xoRqmE8sSCr1mcoJySV/8wcSMSjfFpr
         aIIQ==
X-Gm-Message-State: AOJu0YyFPM3cYbgXbhsSayLcPSl3TfyOb5/5ABJC6CiV2hrYaM4rHcm3
	N0JQcxswx3czCQ71ozsFQ49+2EPqMsgBbLSWY6udqXaG5IoaQvW2nGBkeJMLpiBXhG7gJDyIi6p
	XyA==
X-Google-Smtp-Source: AGHT+IEkXQbqCRD8HRA5WYiikSGcIbX1BI2E42grwI+QpW4s0TZ41inyJORuRHkLarSfOJH8WDG3sSlB5eU=
X-Received: from pfnd23.prod.google.com ([2002:aa7:8157:0:b0:732:858a:729f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2a09:b0:73e:30dc:bb9b
 with SMTP id d2e1a72fcca58-7409cedc8b4mr5638494b3a.2.1746638318238; Wed, 07
 May 2025 10:18:38 -0700 (PDT)
Date: Wed, 7 May 2025 10:18:36 -0700
In-Reply-To: <14eab14d368e68cb9c94c655349f94f44a9a15b4.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250416002546.3300893-1-mlevitsk@redhat.com> <20250416002546.3300893-2-mlevitsk@redhat.com>
 <aAgnRx2aMbNKOlXY@google.com> <14eab14d368e68cb9c94c655349f94f44a9a15b4.camel@redhat.com>
Message-ID: <aBuV7JmMU3TcsqFW@google.com>
Subject: Re: [PATCH 1/3] x86: KVM: VMX: Wrap GUEST_IA32_DEBUGCTL read/write
 with access functions
From: Sean Christopherson <seanjc@google.com>
To: mlevitsk@redhat.com
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 01, 2025, mlevitsk@redhat.com wrote:
> On Tue, 2025-04-22 at 16:33 -0700, Sean Christopherson wrote:
> > > @@ -2653,11 +2654,17 @@ static int prepare_vmcs02(struct kvm_vcpu *vc=
pu, struct vmcs12 *vmcs12,
> > >  	if (vmx->nested.nested_run_pending &&
> > >  	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
> > >  		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
> > > -		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl);
> > > +		new_debugctl =3D vmcs12->guest_ia32_debugctl;
> > >  	} else {
> > >  		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
> > > -		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugctl=
);
> > > +		new_debugctl =3D vmx->nested.pre_vmenter_debugctl;
> > >  	}
> > > +
> > > +	if (CC(!vmx_set_guest_debugctl(vcpu, new_debugctl, false))) {
> >=20
> > The consistency check belongs in nested_vmx_check_guest_state(), only n=
eeds to
> > check the VM_ENTRY_LOAD_DEBUG_CONTROLS case, and should be posted as a =
separate
> > patch.
>=20
> I can move it there. Can you explain why though you want this? Is it beca=
use of the
> order of checks specified in the PRM?

To be consistent with how KVM checks guest state.  The two checks in prepar=
e_vmcs02()
are special cases.  vmx_guest_state_valid() consumes a huge variety of stat=
e, and
so replicating all of its logic for vmcs12 isn't worth doing.  The check on=
 the
kvm_set_msr() for guest_ia32_perf_global_ctrl exists purely so that KVM doe=
sn't
simply ignore the return value.

And to a lesser degree, because KVM assumes that guest state has been sanit=
ized
after nested_vmx_check_guest_state() is called.  Violating that risks intro=
ducing
bugs, e.g. consuming vmcs12->guest_ia32_debugctl before it's been vetted co=
uld
theoretically be problematic.

> Currently GUEST_IA32_DEBUGCTL of the host is *written* in prepare_vmcs02.=
=C2=A0
> Should I also move this write to nested_vmx_check_guest_state?

No.  nested_vmx_check_guest_state() verifies the incoming vmcs12 state,
prepare_vmcs02() merges the vmcs12 state with KVM's desires and fills vmcs0=
2.

> Or should I write the value blindly in prepare_vmcs02 and then check the =
value
> of 'vmx->msr_ia32_debugctl' in nested_vmx_check_guest_state and fail if t=
he value
> contains reserved bits?=C2=A0

I don't follow.  nested_vmx_check_guest_state() is called before prepare_vm=
cs02().

> > > +bool vmx_set_guest_debugctl(struct kvm_vcpu *vcpu, u64 data, bool ho=
st_initiated)
> > > +{
> > > +	u64 invalid =3D data & ~vmx_get_supported_debugctl(vcpu, host_initi=
ated);
> > > +
> > > +	if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
> > > +		kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
> > > +		data &=3D ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
> > > +		invalid &=3D ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
> > > +	}
> > > +
> > > +	if (invalid)
> > > +		return false;
> > > +
> > > +	if (is_guest_mode(vcpu) && (get_vmcs12(vcpu)->vm_exit_controls &
> > > +					VM_EXIT_SAVE_DEBUG_CONTROLS))
> > > +		get_vmcs12(vcpu)->guest_ia32_debugctl =3D data;
> > > +
> > > +	if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event=
 &&
> > > +	    (data & DEBUGCTLMSR_LBR))
> > > +		intel_pmu_create_guest_lbr_event(vcpu);
> > > +
> > > +	__vmx_set_guest_debugctl(vcpu, data);
> > > +	return true;
> >=20
> > Return 0/-errno, not true/false.
>=20
> There are plenty of functions in this file and KVM that return boolean.

That doesn't make them "right".  For helpers that are obvious predicates, t=
hen
absolutely use a boolean return value.  The names for nested_vmx_check_eptp=
()
and vmx_control_verify() aren't very good, e.g. they should be
nested_vmx_is_valid_eptp() and vmx_is_valid_control(), but the intent is go=
od.

But for flows like modifying guest state, KVM should return 0/-errno.

> e.g:=C2=A0
>=20
> static bool nested_vmx_check_eptp(struct kvm_vcpu *vcpu, u64 new_eptp)
> static inline bool vmx_control_verify(u32 control, u32 low, u32 high)
> static bool nested_evmcs_handle_vmclear(struct kvm_vcpu *vcpu, gpa_t vmpt=
r)
> static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
> 						=C2=A0struct vmcs12 *vmcs12)

These two should return 0/-errno.

=20
> static bool nested_vmx_check_eptp(struct kvm_vcpu *vcpu, u64 new_eptp)
> static bool nested_get_vmcs12_pages(struct kvm_vcpu *vcpu)

Probably should return 0/-errno, but nested_get_vmcs12_pages() is a bit of =
a mess.

> ...
>=20
>=20
> I personally think that functions that emulate hardware should return boo=
lean
> values or some hardware specific status code (e.g VMX failure code) becau=
se
> the real hardware never returns -EINVAL and such.

Real hardware absolutely "returns" granular error codes.  KVM even has info=
rmal
mappings between some of them, e.g. -EINVAL =3D=3D #GP, -EFAULT =3D=3D #PF,=
 -EOPNOTSUPP =3D=3D #UD,
BUG() =3D=3D 3-strike #MC.

And hardware has many more ways to report errors to software. E.g. VMLAUNCH=
 can
#UD, #GP(0), VM-Exit, VMfailInvalid, or VMFailValid with 30+ unique reasons=
.  #MC
has a crazy number of possible error encodings.  And so on and so forth.

Software visible error codes aside, comparing individual KVM functions to a=
n
overall CPU is wildly misguided.  A more appropriate comparison would be be=
tween
a KVM function and the ucode for a single instruction/operation.  I highly,=
 highly
doubt ucode flows are limited to binary yes/no outputs.

