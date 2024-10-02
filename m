Return-Path: <kvm+bounces-27812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B76F98DFD3
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 17:53:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9E92B1F2A398
	for <lists+kvm@lfdr.de>; Wed,  2 Oct 2024 15:53:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D6F51D0DF9;
	Wed,  2 Oct 2024 15:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FPYg4SPp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE4742AA2
	for <kvm@vger.kernel.org>; Wed,  2 Oct 2024 15:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727884378; cv=none; b=d7fxF1yGTbMSdH9PLosztLc0ZyMRL7AWYjgzHFDfQlgc7TYZ/E9GGeOwBSq15bfczuRkTmeBepLuxk6vyKTGmnR0bov7nMlg9eEtPzT36Pemy8uZkoNrbmVMrjqpJ9eoK9D7wVXQ2IIkwc7BT0RVWta7f5fG/I0U/Fqe4NN7RUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727884378; c=relaxed/simple;
	bh=jgyYNHVGUJHqurtjL+tFw+Bf0SDAQlYN4jDbAjN3kwg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qgQ76PNZw73bTnEorIEQeYZf0bdKpCGEwdkQasDHwpMO2Jt6E0amY16gor4NVTArvSJymB5xtPpHwgosvRAMuiVrXdM+ymzw8hzA3FLTkxphpk0jR5a4RfkCJdS9bVBeAXmMH0OQcxVOqrSYJriV45mAOLRsTHD9PfWGpiOQCXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FPYg4SPp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2e148d4550bso4842a91.1
        for <kvm@vger.kernel.org>; Wed, 02 Oct 2024 08:52:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727884376; x=1728489176; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XXJXQs/xEx4lHkiALypwDMfhGbvgouY1MUMfF7pgmg8=;
        b=FPYg4SPp9SLRLBTYspP5d34L3KQcIf4iK83LYJV27li5lc/XFvCYyF99ZGN8hOv3/4
         CNU0tPbjoNwNay8qGOdI0ASQRiFc2dgXsgQOYq8yVNipPz3iXfS6QR5tCXKb+/gw1PLR
         utgm4e9MgQhRu/AEOgshN9TQGaGuVubUZKR8kOxYdukOH4VfO2V+oePHKWSzvJhJzBb9
         1LAuWsjaijyS979gOQi76Z/DTOphoNT11OUH17Ho2oobB4f6vtWYy5LD+FUVqSYkqP98
         PN0h+MCl0mWfrdGrWcLZIDhTwjlgETuc0JRYnB2kPNiWpRWdzvYca1ZlB7qwg9EowVyb
         htrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727884376; x=1728489176;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XXJXQs/xEx4lHkiALypwDMfhGbvgouY1MUMfF7pgmg8=;
        b=O2aEtuhB/9NCxnpdJSq0qeU/8xSzsHw0v4ZbQLuxJMWnYIxrOymiHj8tM4EFsX7cwo
         i50pyQesItbT9ST6dqgXBUaH1IPb6bcsr30s0/8MHt/oIxFLLg+lVRs4dCzwId2i1I9g
         A5M/lJwvnTZJguSwOl+QVpnzLyYXcnfncpY3R9Ix0otI9ymB7aojofEinODqHRXIGlv2
         AQKYJTn12T44nmw1z3D67x5ooGJMQkxN+ZnN93rlCWKk7o/ggFH7Z3Dr2X6wWbR1P9Dc
         F0YSH/MJJcJMBf/v3R50DRHSzvJM7YNhIG4v3t8QUkD/yopDdh9t5IkgmSgHb4xpx9is
         W5CA==
X-Forwarded-Encrypted: i=1; AJvYcCWCbMJwf06XjiKhdtZp8nQfDO69Rkk/or9ibfUdBjJXjJa7LFFwrjFEdA9Kg1P+eGXVJGQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtXJwom6zMo7IQLlBxjfYunve6/J6RSfaRZ3xmt0ZK9qHSBYcd
	WI/DW63bJOvnBnA1Pkk4MwCbhFE9CfvtChpw4xT9LPC4jXehxN0qJslkC3BZzp0iEEy3o6juAq7
	/uQ==
X-Google-Smtp-Source: AGHT+IHNCQDIvuUM0kgE3VfsIGDY89jbI56rsZBS6XJ21z3kKEZ3wjjgmbannD/iW6mRw5+d+JuSV9Fidl4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:514e:b0:2e0:876c:8cb6 with SMTP id
 98e67ed59e1d1-2e184523937mr17881a91.2.1727884376008; Wed, 02 Oct 2024
 08:52:56 -0700 (PDT)
Date: Wed, 2 Oct 2024 08:52:54 -0700
In-Reply-To: <20241002124324.14360-1-mankku@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <Zu0vvRyCyUaQ2S2a@google.com> <20241002124324.14360-1-mankku@gmail.com>
Message-ID: <Zv1gbzT1KTYpNgY1@google.com>
Subject: Re: [PATCH 1/1] KVM: nVMX: update VPPR on vmlaunch/vmresume
From: Sean Christopherson <seanjc@google.com>
To: "Markku =?utf-8?Q?Ahvenj=C3=A4rvi?=" <mankku@gmail.com>
Cc: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	janne.karhunen@gmail.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	mingo@redhat.com, pbonzini@redhat.com, tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 02, 2024, Markku Ahvenj=C3=A4rvi wrote:
> Hi Sean,
>=20
> > On Fri, Sep 20, 2024, Markku Ahvenj=C3=A4rvi wrote:
> > > Running certain hypervisors under KVM on VMX suffered L1 hangs after
> > > launching a nested guest. The external interrupts were not processed =
on
> > > vmlaunch/vmresume due to stale VPPR, and L2 guest would resume withou=
t
> > > allowing L1 hypervisor to process the events.
> > >=20
> > > The patch ensures VPPR to be updated when checking for pending
> > > interrupts.
> >
> > This is architecturally incorrect, PPR isn't refreshed at VM-Enter.
>=20
> I looked into this and found the following from Intel manual:
>=20
> "30.1.3 PPR Virtualization
>=20
> The processor performs PPR virtualization in response to the following
> operations: (1) VM entry; (2) TPR virtualization; and (3) EOI virtualizat=
ion.
>=20
> ..."
>=20
> The section "27.3.2.5 Updating Non-Register State" further explains the V=
M
> enter:
>=20
> "If the =E2=80=9Cvirtual-interrupt delivery=E2=80=9D VM-execution control=
 is 1, VM entry loads
> the values of RVI and SVI from the guest interrupt-status field in the VM=
CS
> (see Section 25.4.2). After doing so, the logical processor first causes =
PPR
> virtualization (Section 30.1.3) and then evaluates pending virtual interr=
upts
> (Section 30.2.1). If a virtual interrupt is recognized, it may be deliver=
ed in
> VMX non-root operation immediately after VM entry (including any specifie=
d
> event injection) completes; ..."
>=20
> According to that, PPR is supposed to be refreshed at VM-Enter, or am I
> missing something here?

Huh, I missed that.  It makes sense I guess; VM-Enter processes pending vir=
tual
interrupts, so it stands that VM-Enter would refresh PPR as well.

Ugh, and looking again, KVM refreshes PPR every time it checks for a pendin=
g
interrupt, including the VM-Enter case (via kvm_apic_has_interrupt()) when =
nested
posted interrupts are in use:

	/* Emulate processing of posted interrupts on VM-Enter. */
	if (nested_cpu_has_posted_intr(vmcs12) &&
	    kvm_apic_has_interrupt(vcpu) =3D=3D vmx->nested.posted_intr_nv) {
		vmx->nested.pi_pending =3D true;
		kvm_make_request(KVM_REQ_EVENT, vcpu);
		kvm_apic_clear_irr(vcpu, vmx->nested.posted_intr_nv);
	}

I'm still curious as to what's different about your setup, but certainly no=
t
curious enough to hold up a fix.

Anyways, back to the code, I think we can and should shoot for a more compl=
ete
cleanup (on top of a minimal fix).  As Chao suggested[*], the above nested =
posted
interrupt code shouldn't exist, as KVM should handle nested posted interrup=
ts as
part of vmx_check_nested_events(), which honors event priority.  And I see =
a way,
albeit a bit of an ugly way, to avoid regressing performance when there's p=
ending
nested posted interrupt at VM-Enter.

The other aspect of this code is that I don't think we need to limit the ch=
eck
to APICv, i.e. KVM can simply check kvm_apic_has_interrupt() after VM-Enter
succeeds (the funky pre-check is necessary to read RVI from vmcs01, with th=
e
event request deferred until KVM knows VM-Enter will be successful).

Arguably, that's probably more correct, as PPR virtualization should only o=
ccur
if VM-Enter is successful (or at least guest past the VM-Fail checks).

So, for an immediate fix, I _think_ we can do:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a8e7bc04d9bf..784b61c9810b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3593,7 +3593,8 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mo=
de(struct kvm_vcpu *vcpu,
         * effectively unblock various events, e.g. INIT/SIPI cause VM-Exit
         * unconditionally.
         */
-       if (unlikely(evaluate_pending_interrupts))
+       if (unlikely(evaluate_pending_interrupts) ||
+           kvm_apic_has_interrupt(vcpu))
                kvm_make_request(KVM_REQ_EVENT, vcpu);
=20
        /*

and then eventually make nested_vmx_enter_non_root_mode() look like the bel=
ow.

Can you verify that the above fixes your setup?  If it does, I'll put toget=
her a
small series with that change and the cleanups I have in mind.

Thanks much!

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a8e7bc04d9bf..77f0695784d8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3483,7 +3483,6 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mo=
de(struct kvm_vcpu *vcpu,
        struct vcpu_vmx *vmx =3D to_vmx(vcpu);
        struct vmcs12 *vmcs12 =3D get_vmcs12(vcpu);
        enum vm_entry_failure_code entry_failure_code;
-       bool evaluate_pending_interrupts;
        union vmx_exit_reason exit_reason =3D {
                .basic =3D EXIT_REASON_INVALID_STATE,
                .failed_vmentry =3D 1,
@@ -3502,13 +3501,6 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_m=
ode(struct kvm_vcpu *vcpu,
=20
        kvm_service_local_tlb_flush_requests(vcpu);
=20
-       evaluate_pending_interrupts =3D exec_controls_get(vmx) &
-               (CPU_BASED_INTR_WINDOW_EXITING | CPU_BASED_NMI_WINDOW_EXITI=
NG);
-       if (likely(!evaluate_pending_interrupts) && kvm_vcpu_apicv_active(v=
cpu))
-               evaluate_pending_interrupts |=3D vmx_has_apicv_interrupt(vc=
pu);
-       if (!evaluate_pending_interrupts)
-               evaluate_pending_interrupts |=3D kvm_apic_has_pending_init_=
or_sipi(vcpu);
-
        if (!vmx->nested.nested_run_pending ||
            !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
                vmx->nested.pre_vmenter_debugctl =3D vmcs_read64(GUEST_IA32=
_DEBUGCTL);
@@ -3591,9 +3583,13 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_m=
ode(struct kvm_vcpu *vcpu,
         * Re-evaluate pending events if L1 had a pending IRQ/NMI/INIT/SIPI
         * when it executed VMLAUNCH/VMRESUME, as entering non-root mode ca=
n
         * effectively unblock various events, e.g. INIT/SIPI cause VM-Exit
-        * unconditionally.
+        * unconditionally.  Take care to pull data from vmcs01 as appropri=
ate,
+        * e.g. when checking for interrupt windows, as vmcs02 is now loade=
d.
         */
-       if (unlikely(evaluate_pending_interrupts))
+       if ((__exec_controls_get(&vmx->vmcs01) & (CPU_BASED_INTR_WINDOW_EXI=
TING |
+                                                 CPU_BASED_NMI_WINDOW_EXIT=
ING)) ||
+           kvm_apic_has_pending_init_or_sipi(vcpu) ||
+           kvm_apic_has_interrupt(vcpu))
                kvm_make_request(KVM_REQ_EVENT, vcpu);
=20
        /*


[*] https://lore.kernel.org/all/Zp%2FC5IlwfzC5DCsl@chao-email

