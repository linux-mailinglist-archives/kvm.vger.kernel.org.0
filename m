Return-Path: <kvm+bounces-45765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 993B5AAEEF6
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:03:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0119188D536
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92FFA291146;
	Wed,  7 May 2025 23:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RL4q8DCU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3350C1C32
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746659018; cv=none; b=AQ/RdRYCEMVP/WREHEBFXLL9a59HcgsCMorVLHNpT0BCGSsqM1uIzGQc/Gyc0KPCRV72qwOMIrKa/fr06x04Hs7WQFPdMWSNohz0waSTbZYwJrRRQKmymDKLFEEOKE1EVpyZLIJ2Z1//0jfckMKSBpvTCbubGn1sPzSO39+7bNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746659018; c=relaxed/simple;
	bh=2XmKf4r7PMI/+F7HCnW1whR1EZIc9+PIVrLSuf10zLg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XJXOCDlrfFYxmlKcDpm3/J0pSomHdcKLacxypkUC7xVo6m+o74E4MxXCojuOz9qXHitEu1z5tvduCddE4e9MJLfBYvE8etahSdNpFA2rzgqyZi3P3uihfYMsXg3eNDzd2hv6ye/p8gpYMM9tXS/62K2NpHWsfUXWooSfOGl5wa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RL4q8DCU; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-30a29af28d1so363701a91.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746659016; x=1747263816; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qq49Dart3v0WlvGRUo03jrUoC30OnK8nNG5A8WXCnUA=;
        b=RL4q8DCU2mrJB6GqiSrdmEZevzvoOlIcvzfk5BLQQi6eQyvZKYyUw4CIN/rb4UxGLK
         JK156ocbFzwGywLoaKvqzcXMyjydcuwNLbrjHB/lRbVsUKl4xQBw6hxicsRgPBZLKbrH
         lUyoi/Zh+OEsaneK0qiCTv0tP8nZ0kKajbUC7fuVL8vnf3TIf8t2MwrIat+sS5L0B7Yw
         KlHCPGxD/L+dfBqfBAVGEt4FphreATdtgFhbZQCH8he/rs0mvnhaAJFAorZllMrpU35f
         qRh0gD4Rbr62VlCKQe6UeqKf0A2/afxZkghCJ9w+EHDwdAET4Gl0xs4keN2dUTjdh1kG
         m6EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746659016; x=1747263816;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Qq49Dart3v0WlvGRUo03jrUoC30OnK8nNG5A8WXCnUA=;
        b=jpw73NUvNTt3B0jO0TZdjbnhItqQ1us4nHSugCu/ut+bcgieG8SbHpXLmahfX2oH9d
         2wG6+gBzD4HnYz0BYbJzLLwuqoc8CzU3qA2gKGsGo21MvcCK5K4RQ4zNlDrzJ6Ogfb6t
         cj/ZsgGVlLfpY/t/Nwlx5hj1+ZJgEoUI3O6J9BpqtwN/Xcx5Piyl6pE2q2RQZtGR7Tjl
         wIP4nSjlwtfRJ6x2A6zzj33fSLIy7+bhBQ2BVKzHSn4cPJnlFZnETyW3uksor9A6wunz
         PX/zyYp8ofJTQ+tXVHGlGyf9/sZdyiu3HFmJsL3S3EwpC+/qdAJISlD4S8tzEvlxK8EB
         X4sg==
X-Gm-Message-State: AOJu0Ywkn6fEbaai9rA7WWOQIE8hF0mB8pigFLVvkua9sLz+FDJ5mb4a
	Ga4oiBft4Ib8K92Nu+fHs6fsnDHavdeZyFCnLGCLD/fxC5dIJyrVDEX4jBEucR96Y/DMqAwamVO
	jDw==
X-Google-Smtp-Source: AGHT+IGf7GrnMA0ECrA5Cc+xFBVRuZ0noNkL8FCy7GwGt33Tt3DR9TcVbBH2Tlv+OXVWcHLSD3Da30W7ftU=
X-Received: from pjbst8.prod.google.com ([2002:a17:90b:1fc8:b0:2fc:13d6:b4cb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38c5:b0:2fe:80cb:ac05
 with SMTP id 98e67ed59e1d1-30b32a5612emr1426077a91.9.1746659016471; Wed, 07
 May 2025 16:03:36 -0700 (PDT)
Date: Wed, 7 May 2025 16:03:34 -0700
In-Reply-To: <71af8435d2085b3f969cb3e73cff5bfacd243819.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250416002546.3300893-1-mlevitsk@redhat.com> <20250416002546.3300893-4-mlevitsk@redhat.com>
 <aAgpD_5BI6ZcCN29@google.com> <2b1ec570a37992cdfa2edad325e53e0592d696c8.camel@redhat.com>
 <71af8435d2085b3f969cb3e73cff5bfacd243819.camel@redhat.com>
Message-ID: <aBvmxjxUrXEBa3sc@google.com>
Subject: Re: [PATCH 3/3] x86: KVM: VMX: preserve host's DEBUGCTLMSR_FREEZE_IN_SMM
 while in the guest mode
From: Sean Christopherson <seanjc@google.com>
To: mlevitsk@redhat.com
Cc: kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 01, 2025, mlevitsk@redhat.com wrote:
> On Thu, 2025-05-01 at 16:41 -0400, mlevitsk@redhat.com wrote:
> > On Tue, 2025-04-22 at 16:41 -0700, Sean Christopherson wrote:
> > > On Tue, Apr 15, 2025, Maxim Levitsky wrote:
> > > > Pass through the host's DEBUGCTL.DEBUGCTLMSR_FREEZE_IN_SMM to the g=
uest
> > > > GUEST_IA32_DEBUGCTL without the guest seeing this value.
> > > >=20
> > > > Note that in the future we might allow the guest to set this bit as=
 well,
> > > > when we implement PMU freezing on VM own, virtual SMM entry.
> > > >=20
> > > > Since the value of the host DEBUGCTL can in theory change between V=
M runs,
> > > > check if has changed, and if yes, then reload the GUEST_IA32_DEBUGC=
TL with
> > > > the new value of the host portion of it (currently only the
> > > > DEBUGCTLMSR_FREEZE_IN_SMM bit)
> > >=20
> > > No, it can't.=C2=A0 DEBUGCTLMSR_FREEZE_IN_SMM can be toggled via IPI =
callback, but
> > > IRQs are disabled for the entirety of the inner run loop.=C2=A0 And i=
f I'm somehow
> > > wrong, this change movement absolutely belongs in a separate patch.
>=20
>=20
> Hi,
>=20
> You are right here - reading MSR_IA32_DEBUGCTLMSR in the inner loop is a
> performance regression.
>=20
> Any ideas on how to solve this then? Since currently its the common code =
that
> reads the current value of the MSR_IA32_DEBUGCTLMSR and it doesn't leave =
any
> indication about if it changed I can do either
>=20
> 1. store old value as well, something like 'vcpu->arch.host_debugctl_old'=
 Ugly IMHO.
>=20
> 2. add DEBUG_CTL to the set of the 'dirty' registers, e.g add new bit for=
 kvm_register_mark_dirty
> It looks a bit overkill to me
>=20
> 3. Add new x86 callback for something like .sync_debugctl(). I vote for t=
his option.
>=20
> What do you think/prefer?

I was going to say #3 as well, but I think I have a better idea.

DR6 has a similar problem; the guest's value needs to be loaded into hardwa=
re,
but only somewhat rarely, and more importantly, never on a fastpath reentry=
.

Forced immediate exits also have a similar need: some control logic in comm=
on x86
needs instruct kvm_x86_ops.vcpu_run() to do something.

Unless I've misread the DEBUGCTLMSR situation, in all cases, common x86 onl=
y needs
to a single flag to tell vendor code to do something.  The payload for that=
 action
is already available.

So rather than add a bunch of kvm_x86_ops hooks that are only called immedi=
ately
before kvm_x86_ops.vcpu_run(), expand @req_immediate_exit into a bitmap of =
flags
to communicate what works needs to be done, without having to resort to a f=
ield
in kvm_vcpu_arch that isn't actually persistent.

The attached patches are relatively lightly tested, but the DR6 tests from =
the
recent bug[*] pass, so hopefully they're correct?

The downside with this approach is that it would be difficult to backport t=
o LTS
kernels, but given how long this has been a problem, I'm not super concerne=
d about
optimizing for backports.

If they look ok, feel free to include them in the next version.  Or I can p=
ost
them separately if you want.

> > > > +		__vmx_set_guest_debugctl(vcpu, vmx->msr_ia32_debugctl);
> > >=20
> > > I would rather have a helper that explicitly writes the VMCS field, n=
ot one that
> > > sets the guest value *and* writes the VMCS field.
> >=20
> > >=20
> > > The usage in init_vmcs() doesn't need to write vmx->msr_ia32_debugctl=
 because the
> > > vCPU is zero allocated, and this usage doesn't change vmx->msr_ia32_d=
ebugctl.
> > > So the only path that actually needs to modify vmx->msr_ia32_debugctl=
 is
> > > vmx_set_guest_debugctl().
> >=20
> > But what about nested entry? nested entry pretty much sets the MSR to a
> > value given by the guest.
> >=20
> > Also technically the intel_pmu_legacy_freezing_lbrs_on_pmi also changes=
 the
> > guest value by emulating what the real hardware does.

Drat, sorry, my feedback was way too terse.  What I was trying to say is th=
at if
we cache the guest's msr_ia32_debugctl, then I would rather have this:

--
static void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu)
{
	u64 val =3D vmx->msr_ia32_debugctl |
		  vcpu->arch.host_debugctl & DEBUGCTLMSR_FREEZE_IN_SMM);

	vmcs_write64(GUEST_IA32_DEBUGCTL, val);
}

int vmx_set_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated)
{
	u64 invalid =3D data & ~vmx_get_supported_debugctl(vcpu, host_initiated);

	if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
		kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
		data &=3D ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
		invalid &=3D ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
	}

	if (invalid)
		return 1;

	if (is_guest_mode(vcpu) && (get_vmcs12(vcpu)->vm_exit_controls &
					VM_EXIT_SAVE_DEBUG_CONTROLS))
		get_vmcs12(vcpu)->guest_ia32_debugctl =3D data;

	if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
	    (data & DEBUGCTLMSR_LBR))
		intel_pmu_create_guest_lbr_event(vcpu);

	vmx->msr_ia32_debugctl =3D data;
	vmx_guest_debugctl_write(vcpu);
	return 0;
}
--

So that the path that refreshes vmcs.GUEST_IA32_DEBUGCTL on VM-Entry doesn'=
t have
to feed in vmx->msr_ia32_debugctl, because the only value that is ever writ=
ten to
hardware is vmx->msr_ia32_debugctl.

However, I'm not entirely convinced that we need to cache the guest value,
because toggling DEBUGCTLMSR_FREEZE_IN_SMM should be extremely rare.  So so=
mething
like this?

--
static void vmx_guest_debugctl_write(struct kvm_vcpu *vcpu, u64 val)
{
	val |=3D vcpu->arch.host_debugctl & DEBUGCTLMSR_FREEZE_IN_SMM);

	vmcs_write64(GUEST_IA32_DEBUGCTL, val);
}

int vmx_set_debugctl(struct kvm_vcpu *vcpu, u64 data, bool host_initiated)
{
	u64 invalid =3D data & ~vmx_get_supported_debugctl(vcpu, host_initiated);

	if (invalid & (DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR)) {
		kvm_pr_unimpl_wrmsr(vcpu, MSR_IA32_DEBUGCTLMSR, data);
		data &=3D ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
		invalid &=3D ~(DEBUGCTLMSR_BTF|DEBUGCTLMSR_LBR);
	}

	if (invalid)
		return 1;

	if (is_guest_mode(vcpu) && (get_vmcs12(vcpu)->vm_exit_controls &
					VM_EXIT_SAVE_DEBUG_CONTROLS))
		get_vmcs12(vcpu)->guest_ia32_debugctl =3D data;

	if (intel_pmu_lbr_is_enabled(vcpu) && !to_vmx(vcpu)->lbr_desc.event &&
	    (data & DEBUGCTLMSR_LBR))
		intel_pmu_create_guest_lbr_event(vcpu);

	vmx_guest_debugctl_write(vcpu, data);
	return 0;
}
--

And then when DEBUGCTLMSR_FREEZE_IN_SMM changes:

	if (<is DEBUGCTLMSR_FREEZE_IN_SMM toggled>)
		vmx_guest_debugctl_write(vmcs_read64(GUEST_IA32_DEBUGCTL) &
					 ~DEBUGCTLMSR_FREEZE_IN_SMM);

And the LBR crud doesn't need to call into the "full" vmx_set_debugctl() (o=
r we
don't even need that helper?).

Side topic, we really should be able to drop @host_initiated, because KVM's=
 ABI
is effectively that CPUID must be set before MSRs, i.e. allowing the host t=
o stuff
unsupported bits isn't necessary.  But that's a future problem.

