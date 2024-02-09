Return-Path: <kvm+bounces-8438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE40084F81E
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 16:05:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25FB71F296D6
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 15:05:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71CA6DCE7;
	Fri,  9 Feb 2024 15:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uXYiho1k"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419A736B17
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707491102; cv=none; b=HghEE/RttF+b8NdfXYH75getrxUiEvFAFieyTu/hy4ZMOlO7AorfR21IFrIMRxbIs+cxo3lcWg1dAdMgann0F+UOMbzhEYSoRN64/ulMjmqpf+Ks78lR4GsrHSVTbsOnwmlX6gHn6LK4G9Kk8YdsUjUQZ0GYHYBqc/AacRP3Hfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707491102; c=relaxed/simple;
	bh=RH+NuY+D6aHD+wcrZU8Dadzd1nSEDNtwzxcILsjJCaQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lzjlzDvTZiuQx6G0LFW3FgcZUqdVmFPUMamw9V2nj3A15Rj5sJe4R+sFBQPJKaOMVRh/lgoar2D0nMPb1goAkAsphyh1lkH8gkcTdv0YloppRmk8EAsMK1bz7wKMiuF00b0p1JdF/7HFENW8GXN5UXrafxdAYHqtOX7LRpYbuaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uXYiho1k; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-604b6d55dfcso10852547b3.1
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 07:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707491099; x=1708095899; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=be0Sgf7TyAr8aMe2h7QxmV6L47RdFNqX/VIAvjQGSD4=;
        b=uXYiho1kJ0Qf5HJT6Ob0DzHaYjmTib4Qn/JXaGRvWmZ5gh9Bhd+f7EFgSu1xoAVbit
         W4cdOvKBblLANu4QEzsKgyeCWru91VJTBQJOiMFKQ2RrgbwIHsasaKRhfjgmuQtkueKu
         x+CK2yfmkJIROscL0Px1j64XEGbVxoz+6rbrNT3HAPV1fhRwcXG+mNig3tSkHc960hcq
         GgZKyPpWNiRxtkDbBSSwFIjI9a9KUDchl4eXYrEH2F3v8GEu3mW6Q0IdDch2MwsNRchE
         /U5LDKBxguEcZi7i/EHFYojiU0MZtYZCSfVQJDCa+IbzYFZW1G6DwyKIXSTdwZmN/djb
         9OKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707491099; x=1708095899;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=be0Sgf7TyAr8aMe2h7QxmV6L47RdFNqX/VIAvjQGSD4=;
        b=REG+dO4eOysD39bFESsEYucWe7Cyv23TWzE0JXV8/UbagEH0j6ZZvLKqtG0i7b/Ak1
         6AsH1ZxBQiKBd/tJ1M3OmA/gR0td+HQFjB8pxDrx50nVoWlthW6p5QYEnvVL2H3xFQxL
         xbmizGQS4e3ia/haAVjt/JO2JlyYSxI/A95ClLqh3NPLgPWjymNKR/yGTgpgvlZvRzbW
         BQgVxnoKnSNfO3PAVgYhZxZTG/CyvR3c5DsbYBGidodtaQjOMlsawT+AUb+dpLoM8pse
         bd///fzH+REzTC23aX4kejGVZIRfFwxC1YrSCKlj/DCsdrQxhyWLgy08/sL9XxxH/U8i
         Va5A==
X-Gm-Message-State: AOJu0Yz+6MntSvVnbAzpeKIKmY6BW43JobtoaSy+Xv0EkQHOp6EDEKLe
	iCDBzu6uMPXNKM+5WBPXLMEbRqcAlFe+BCwayerbJ+mKlQes2xi8tO727uZrfBVQMk7EXUq1D1H
	paQ==
X-Google-Smtp-Source: AGHT+IEp0zYmZOYMN1hp14T5hBMvMTHWqCOz/d1f2OAn/8Se/MwK1MovKkUjd+34jVqVXgYnUJUU1MpMmm0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ea07:0:b0:5ff:6e82:ea31 with SMTP id
 t7-20020a0dea07000000b005ff6e82ea31mr206587ywe.3.1707491099217; Fri, 09 Feb
 2024 07:04:59 -0800 (PST)
Date: Fri, 9 Feb 2024 07:04:57 -0800
In-Reply-To: <CABgObfYa5eKj_8qyRfimqG7DXpbxe-eSM6pCwR6Hq97eZEtX6A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240123001555.4168188-1-michal.wilczynski@intel.com>
 <20240125005710.GA8443@yjiang5-mobl.amr.corp.intel.com> <CABgObfYaUHXyRmsmg8UjRomnpQ0Jnaog9-L2gMjsjkqChjDYUQ@mail.gmail.com>
 <42d31df4-2dbf-44db-a511-a2d65324fded@intel.com> <CABgObfYa5eKj_8qyRfimqG7DXpbxe-eSM6pCwR6Hq97eZEtX6A@mail.gmail.com>
Message-ID: <ZcY_GbqcFXH2pR5E@google.com>
Subject: Re: [PATCH v2] KVM: x86: nSVM/nVMX: Fix handling triple fault on RSM instruction
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Michal Wilczynski <michal.wilczynski@intel.com>, 
	Yunhong Jiang <yunhong.jiang@linux.intel.com>, mlevitsk@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dedekind1@gmail.com, yuan.yao@intel.com, Zheyu Ma <zheyuma97@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 08, 2024, Paolo Bonzini wrote:
> On Thu, Feb 8, 2024 at 2:18=E2=80=AFPM Wilczynski, Michal
> <michal.wilczynski@intel.com> wrote:
> > Hi, I've tested the patch and it seems to work, both on Intel and AMD.
> > There was a problem with applying this chunk though:
> >
> > diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/=
kvm-x86-ops.h
> > index ac8b7614e79d..3d18fa7db353 100644
> > --- a/arch/x86/include/asm/kvm-x86-ops.h
> > +++ b/arch/x86/include/asm/kvm-x86-ops.h
> > @@ -119,7 +119,8 @@ KVM_X86_OP(setup_mce)
> >  #ifdef CONFIG_KVM_SMM
> >  KVM_X86_OP(smi_allowed)
> >  KVM_X86_OP()                 // <- This shouldn't be there I guess ?
> > -KVM_X86_OP(leave_smm)
> > +KVM_X86_OP(leave_smm_prepare)
> > +KVM_X86_OP(leave_smm_commit)
> >  KVM_X86_OP(enable_smi_window)
> >  #endif
> >  KVM_X86_OP_OPTIONAL(dev_get_attr)
> >
> > Anyway I was a bit averse to this approach as I noticed in the git log
> > that callbacks like e.g post_leave_smm() used to exist, but they were l=
ater
> > removed, so I though the maintainers don't like introducing extra
> > callbacks.
>=20
> If they are needed, it's fine. In my opinion a new callback is easier
> to handle and understand than new state.

Yeah, we ripped out post_leave_smm() because its sole usage at the time was=
 buggy,
and having a callback without a purpose would just be dead code.

> > > 2) otherwise, if the problem is that we have not gone through the
> > > vmenter yet, then KVM needs to do that and _then_ inject the triple
> > > fault. The fix is to merge the .triple_fault and .check_nested_events
> > > callbacks, with something like the second attached patch - which
> > > probably has so many problems that I haven't even tried to compile it=
.
> >
> > Well, in this case if we know that RSM will fail it doesn't seem to me
> > like it make sense to run vmenter just do kill the VM anyway, this woul=
d
> > be more confusing.
>=20
> Note that the triple fault must not kill the VM, it's just causing a
> nested vmexit from L2 to L1. KVM's algorithm to inject a
> vmexit-causing event is always to first ensure that the VMCS02 (VMCB02
> for AMD) is consistent, and only then trigger the vmexit. So if patch
> 2 or something like it works, that would be even better.
>=20
> > I've made the fix this way based on our discussion with Sean in v1, and
> > tried to mark the RSM instruction with a flag, as a one that needs
> > actual HW VMenter to complete succesfully, and based on that informatio=
n
> > manipulate nested_run_pending.

Heh, you misunderstood my suggestion.

 : But due to nested_run_pending being (unnecessarily) buried in vendor str=
ucts, it
 : might actually be easier to do a cleaner fix.  E.g. add yet another flag=
 to track
 : that a hardware VM-Enter needs to be completed in order to complete inst=
ruction
 : emulation.

I didn't mean add a flag to the emulator to muck with nested_run_pending, I=
 meant
add a flag to kvm_vcpu_arch to be a superset of nested_run_pending.  E.g. a=
s a
first step, something like the below.  And then as follow up, see if it's d=
oable
to propagate nested_run_pending =3D> insn_emulation_needs_vmenter so that t=
he
nested_run_pending checks in {svm,vmx}_{interrupt,nmi,smi}_allowed() can be
dropped.

---
 arch/x86/include/asm/kvm_host.h |  8 ++++++
 arch/x86/kvm/smm.c              | 10 ++++++--
 arch/x86/kvm/x86.c              | 44 +++++++++++++++++++++++++--------
 3 files changed, 50 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h
index d271ba20a0b2..bb4250551619 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -769,6 +769,14 @@ struct kvm_vcpu_arch {
 	u64 ia32_misc_enable_msr;
 	u64 smbase;
 	u64 smi_count;
+
+	/*
+	 * Tracks if a successful VM-Enter is needed to complete emulation of
+	 * an instruction, e.g. to ensure emulation of RSM or nested VM-Enter,
+	 * which can directly inject events, completes before KVM attempts to
+	 * inject new events.
+	 */
+	bool insn_emulation_needs_vmenter;
 	bool at_instruction_boundary;
 	bool tpr_access_reporting;
 	bool xfd_no_write_intercept;
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index dc3d95fdca7d..c6e597b8c794 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -640,8 +640,14 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
=20
 #ifdef CONFIG_X86_64
 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
-		return rsm_load_state_64(ctxt, &smram.smram64);
+		ret =3D rsm_load_state_64(ctxt, &smram.smram64);
 	else
 #endif
-		return rsm_load_state_32(ctxt, &smram.smram32);
+		ret =3D rsm_load_state_32(ctxt, &smram.smram32);
+
+	if (ret !=3D X86EMUL_CONTINUE)
+		return ret;
+
+	vcpu->arch.insn_emulation_needs_vmenter =3D true;
+	return X86EMUL_CONTINUE;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bf10a9073a09..21a7183bbf69 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10195,6 +10195,30 @@ int kvm_check_nested_events(struct kvm_vcpu *vcpu)
 	return kvm_x86_ops.nested_ops->check_events(vcpu);
 }
=20
+static int kvm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection=
)
+{
+	if (vcpu->arch.insn_emulation_needs_vmenter)
+		return -EBUSY;
+
+	return static_call(kvm_x86_interrupt_allowed)(vcpu, for_injection);
+}
+
+static int kvm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	if (vcpu->arch.insn_emulation_needs_vmenter)
+		return -EBUSY;
+
+	return static_call(kvm_x86_smi_allowed)(vcpu, for_injection)
+}
+
+static int kvm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
+{
+	if (vcpu->arch.insn_emulation_needs_vmenter)
+		return -EBUSY;
+
+	return x86_nmi_static_call(kvm_x86_nmi_allowed)(vcpu, for_injection);
+}
+
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -10384,7 +10408,7 @@ static int kvm_check_and_inject_events(struct kvm_v=
cpu *vcpu,
 	 */
 #ifdef CONFIG_KVM_SMM
 	if (vcpu->arch.smi_pending) {
-		r =3D can_inject ? static_call(kvm_x86_smi_allowed)(vcpu, true) : -EBUSY=
;
+		r =3D can_inject ? kvm_smi_allowed(vcpu, true) : -EBUSY;
 		if (r < 0)
 			goto out;
 		if (r) {
@@ -10398,7 +10422,7 @@ static int kvm_check_and_inject_events(struct kvm_v=
cpu *vcpu,
 #endif
=20
 	if (vcpu->arch.nmi_pending) {
-		r =3D can_inject ? static_call(kvm_x86_nmi_allowed)(vcpu, true) : -EBUSY=
;
+		r =3D can_inject ? kvm_nmi_allowed(vcpu, true) : -EBUSY;
 		if (r < 0)
 			goto out;
 		if (r) {
@@ -10406,14 +10430,14 @@ static int kvm_check_and_inject_events(struct kvm=
_vcpu *vcpu,
 			vcpu->arch.nmi_injected =3D true;
 			static_call(kvm_x86_inject_nmi)(vcpu);
 			can_inject =3D false;
-			WARN_ON(static_call(kvm_x86_nmi_allowed)(vcpu, true) < 0);
+			WARN_ON_ONCE(kvm_nmi_allowed() < 0);
 		}
 		if (vcpu->arch.nmi_pending)
 			static_call(kvm_x86_enable_nmi_window)(vcpu);
 	}
=20
 	if (kvm_cpu_has_injectable_intr(vcpu)) {
-		r =3D can_inject ? static_call(kvm_x86_interrupt_allowed)(vcpu, true) : =
-EBUSY;
+		r =3D can_inject ? kvm_interrupt_allowed(vcpu, true) : -EBUSY;
 		if (r < 0)
 			goto out;
 		if (r) {
@@ -10422,7 +10446,7 @@ static int kvm_check_and_inject_events(struct kvm_v=
cpu *vcpu,
 			if (!WARN_ON_ONCE(irq =3D=3D -1)) {
 				kvm_queue_interrupt(vcpu, irq, false);
 				static_call(kvm_x86_inject_irq)(vcpu, false);
-				WARN_ON(static_call(kvm_x86_interrupt_allowed)(vcpu, true) < 0);
+				WARN_ON(kvm_interrupt_allowed(vcpu, true) < 0);
 			}
 		}
 		if (kvm_cpu_has_injectable_intr(vcpu))
@@ -10969,6 +10993,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) !=3D kvm_vcpu_apicv_active(=
vcpu)) &&
 			     (kvm_get_apic_mode(vcpu) !=3D LAPIC_MODE_DISABLED));
=20
+		vcpu->arch.insn_emulation_needs_vmenter =3D false;
+
 		exit_fastpath =3D static_call(kvm_x86_vcpu_run)(vcpu);
 		if (likely(exit_fastpath !=3D EXIT_FASTPATH_REENTER_GUEST))
 			break;
@@ -13051,14 +13077,12 @@ static inline bool kvm_vcpu_has_events(struct kvm=
_vcpu *vcpu)
 		return true;
=20
 	if (kvm_test_request(KVM_REQ_NMI, vcpu) ||
-	    (vcpu->arch.nmi_pending &&
-	     static_call(kvm_x86_nmi_allowed)(vcpu, false)))
+	    (vcpu->arch.nmi_pending && kvm_nmi_allowed(vcpu, false)))
 		return true;
=20
 #ifdef CONFIG_KVM_SMM
 	if (kvm_test_request(KVM_REQ_SMI, vcpu) ||
-	    (vcpu->arch.smi_pending &&
-	     static_call(kvm_x86_smi_allowed)(vcpu, false)))
+	    (vcpu->arch.smi_pending && kvm_smi_allowed(vcpu, false)))
 		return true;
 #endif
=20
@@ -13136,7 +13160,7 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu=
)
=20
 int kvm_arch_interrupt_allowed(struct kvm_vcpu *vcpu)
 {
-	return static_call(kvm_x86_interrupt_allowed)(vcpu, false);
+	return kvm_interrupt_allowed(vcpu, false);
 }
=20
 unsigned long kvm_get_linear_rip(struct kvm_vcpu *vcpu)

base-commit: f8fe663bc413d2a14ab9a452638a99b975011a9d
--=20


