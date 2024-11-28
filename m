Return-Path: <kvm+bounces-32625-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB499DB028
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 01:00:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D6AAFB21BAF
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 00:00:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DFD412E1CD;
	Thu, 28 Nov 2024 00:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QAUGab6p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DD4198822
	for <kvm@vger.kernel.org>; Thu, 28 Nov 2024 00:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732752024; cv=none; b=bdv5qUis1fa4Kz+LMeHBwSSR3ChxJI/6K7PWvMpTaUUkCBDsucGHivPDy62f1DN9XYWXx27NSSrZt1LkuW7W8TsI74XwythlO71UXp2zMpKIhTkhvib3P0IOk5a/ohR9PojwSnSGcwKpy4+GIjkH8MzfjHp3ZkWI6NpmLYiojC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732752024; c=relaxed/simple;
	bh=60X2QqhkkeYS8hGGfm/Ce9fbK9z9mTYJiXf1RRhJU/o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DdpLz+/k3ARNbwOjbKt46d27BX5L54Dm6YaTj5nKnYP5IE2m6UF6QOJsaTBPQi8So1oAxQOHtIaD7TQElenVaVoLJxOt8bjSaFbE88e5RvUVmA66mBlp+0Je7RMhGv2TeKPVBDxgGHeOdidVBDioDEoWhAHCuMyKCLPTlcXCPxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QAUGab6p; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2edeef8a994so305155a91.2
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 16:00:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732752021; x=1733356821; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Wv87RMF9Fk3hXzQcgARrFuwIxaN0uH6QDV4kBFbXro=;
        b=QAUGab6p/zMEJGXpIxC5Go5fQbUy1PtmxAc+sQBG+cU/cgnXR04oc3aOLdt5olaHBO
         hk2NM9wMAB+u51jvtFBxgwPPb5AECWLtfhQh3aFYPuaUsCq9iax5Pk9BLmT9hx6cnKqf
         th4eNPynoeIBofm+l04x4/sNwVQDDyxNV42BcAUmAd2fGGbFHGM7G6HQP7QGVt2ivijd
         xm3h1AH4wTCwpA4W0go2CGInRTOh8nhnsL53E71UNNO1HxeNdbmWCRjAbTW74kamIYfq
         Khrv2IFfOqBVhbwp7pFjtYTKwJmTFpsX2LkO9tjMFCtRzJZlw0dl7K+1zkE3XbaamL07
         F+6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732752021; x=1733356821;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1Wv87RMF9Fk3hXzQcgARrFuwIxaN0uH6QDV4kBFbXro=;
        b=FMHcBoaJ6oaC7lhQ4owITMBE8yePchAIaoM44Y4UE1gXvA0oOK8AkDZl5YsL0ddg1O
         g8s/0Xi9WlpsatpWDyzbMrpdLWMt2D88tTvdLWqhS4jImkEgInIaF/IkSj58sLcOQv/e
         kuXgXWDRZRiSMeaSVRq6oCftgh4+ZEqazqTSRVI+ZVg3Lkmp5/Z1D/a5I1GBMWoA9kGj
         HHT70dYbTbUatOCotfmEhiiymFw4rwfx3a69dcuYsN1p8pfyNqFqDDpQSai2gxmqwlQ8
         YBCty1X3ppg0H8Qoo9MUXUUx4sjFYO2InTPJ8Ys+1NeMIGDj/rxXV8PHj9Qljry3H+S3
         bSIA==
X-Gm-Message-State: AOJu0YyhUr750BP3Dv9ku3fFCDJIWPNAsDbaGX8zpBac4CKFLJakUlvf
	f/edDHbj5Ma4tTfNiMxEKpG10ePdjDUArZsAZ8zxoH3v+XrqduGcdHPasE5rHpeHtD290Cn0BBV
	iSQ==
X-Google-Smtp-Source: AGHT+IH8qr0McVoY1OYESPY8pKUef+QtKFcMlcZRCo89T+hFxklKL4qiL2AbXQ115oFKFUHUvmbfkB6p9b0=
X-Received: from pjbsj16.prod.google.com ([2002:a17:90b:2d90:b0:2ea:29de:af10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f8a:b0:2ea:4e67:5648
 with SMTP id 98e67ed59e1d1-2ee08eb071amr7814059a91.12.1732752021021; Wed, 27
 Nov 2024 16:00:21 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 16:00:10 -0800
In-Reply-To: <20241128000010.4051275-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128000010.4051275-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128000010.4051275-3-seanjc@google.com>
Subject: [PATCH v2 2/2] KVM: nVMX: Defer SVI update to vmcs01 on EOI when L2
 is active w/o VID
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, 
	"=?UTF-8?q?Markku=20Ahvenj=C3=A4rvi?=" <mankku@gmail.com>, Janne Karhunen <janne.karhunen@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Chao Gao <chao.gao@intel.com>

If KVM emulates an EOI for L1's virtual APIC while L2 is active, defer
updating GUEST_INTERUPT_STATUS.SVI, i.e. the VMCS's cache of the highest
in-service IRQ, until L1 is active, as vmcs01, not vmcs02, needs to track
vISR.  The missed SVI update for vmcs01 can result in L1 interrupts being
incorrectly blocked, e.g. if there is a pending interrupt with lower
priority than the interrupt that was EOI'd.

This bug only affects use cases where L1's vAPIC is effectively passed
through to L2, e.g. in a pKVM scenario where L2 is L1's depriveleged host,
as KVM will only emulate an EOI for L1's vAPIC if Virtual Interrupt
Delivery (VID) is disabled in vmc12, and L1 isn't intercepting L2 accesses
to its (virtual) APIC page (or if x2APIC is enabled, the EOI MSR).

WARN() if KVM updates L1's ISR while L2 is active with VID enabled, as an
EOI from L2 is supposed to affect L2's vAPIC, but still defer the update,
to try to keep L1 alive.  Specifically, KVM forwards all APICv-related
VM-Exits to L1 via nested_vmx_l1_wants_exit():

	case EXIT_REASON_APIC_ACCESS:
	case EXIT_REASON_APIC_WRITE:
	case EXIT_REASON_EOI_INDUCED:
		/*
		 * The controls for "virtualize APIC accesses," "APIC-
		 * register virtualization," and "virtual-interrupt
		 * delivery" only come from vmcs12.
		 */
		return true;

Fixes: c7c9c56ca26f ("x86, apicv: add virtual interrupt delivery support")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/kvm/20230312180048.1778187-1-jason.cj.chen@in=
tel.com
Reported-by: Markku Ahvenj=C3=A4rvi <mankku@gmail.com>
Closes: https://lore.kernel.org/all/20240920080012.74405-1-mankku@gmail.com
Cc: Janne Karhunen <janne.karhunen@gmail.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
[sean: drop request, handle in VMX, write changelog]
Tested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c      | 11 +++++++++++
 arch/x86/kvm/lapic.h      |  1 +
 arch/x86/kvm/vmx/nested.c |  5 +++++
 arch/x86/kvm/vmx/vmx.c    | 21 +++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h    |  1 +
 5 files changed, 39 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 39ae2f5f9866..c9af285b4b81 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -816,6 +816,17 @@ static inline void apic_clear_isr(int vec, struct kvm_=
lapic *apic)
 	}
 }
=20
+void kvm_apic_update_hwapic_isr(struct kvm_vcpu *vcpu)
+{
+	struct kvm_lapic *apic =3D vcpu->arch.apic;
+
+	if (WARN_ON_ONCE(!lapic_in_kernel(vcpu)) || !apic->apicv_active)
+		return;
+
+	kvm_x86_call(hwapic_isr_update)(apic->vcpu, apic_find_highest_isr(apic));
+}
+EXPORT_SYMBOL_GPL(kvm_apic_update_hwapic_isr);
+
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 {
 	/* This may race with setting of irr in __apic_accept_irq() and
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 24add38beaf0..1a8553ebdb42 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -118,6 +118,7 @@ void kvm_apic_send_ipi(struct kvm_lapic *apic, u32 icr_=
low, u32 icr_high);
 int kvm_apic_set_base(struct kvm_vcpu *vcpu, u64 value, bool host_initiate=
d);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
+void kvm_apic_update_hwapic_isr(struct kvm_vcpu *vcpu);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
=20
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index aa78b6f38dfe..103baa8e4cf8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5050,6 +5050,11 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm=
_exit_reason,
 		kvm_make_request(KVM_REQ_APICV_UPDATE, vcpu);
 	}
=20
+	if (vmx->nested.update_vmcs01_hwapic_isr) {
+		vmx->nested.update_vmcs01_hwapic_isr =3D false;
+		kvm_apic_update_hwapic_isr(vcpu);
+	}
+
 	if ((vm_exit_reason !=3D -1) &&
 	    (enable_shadow_vmcs || nested_vmx_is_evmptr12_valid(vmx)))
 		vmx->nested.need_vmcs12_to_shadow_sync =3D true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 22cb11ab8709..01abcdcbbf70 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6867,6 +6867,27 @@ void vmx_hwapic_isr_update(struct kvm_vcpu *vcpu, in=
t max_isr)
 	u16 status;
 	u8 old;
=20
+	/*
+	 * If L2 is active, defer the SVI update until vmcs01 is loaded, as SVI
+	 * is only relevant for if and only if Virtual Interrupt Delivery is
+	 * enabled in vmcs12, and if VID is enabled then L2 EOIs affect L2's
+	 * vAPIC, not L1's vAPIC.  KVM must update vmcs01 on the next nested
+	 * VM-Exit, otherwise L1 with run with a stale SVI.
+	 */
+	if (is_guest_mode(vcpu)) {
+		/*
+		 * KVM is supposed to forward intercepted L2 EOIs to L1 if VID
+		 * is enabled in vmcs12; as above, the EOIs affect L2's vAPIC.
+		 * Note, userspace can stuff state while L2 is active; assert
+		 * that VID is disabled if and only if the vCPU is in KVM_RUN
+		 * to avoid false positives if userspace is setting APIC state.
+		 */
+		WARN_ON_ONCE(vcpu->wants_to_run &&
+			     nested_cpu_has_vid(get_vmcs12(vcpu)));
+		to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr =3D true;
+		return;
+	}
+
 	if (max_isr =3D=3D -1)
 		max_isr =3D 0;
=20
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 43f573f6ca46..892302022094 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -176,6 +176,7 @@ struct nested_vmx {
 	bool reload_vmcs01_apic_access_page;
 	bool update_vmcs01_cpu_dirty_logging;
 	bool update_vmcs01_apicv_status;
+	bool update_vmcs01_hwapic_isr;
=20
 	/*
 	 * Enlightened VMCS has been enabled. It does not mean that L1 has to
--=20
2.47.0.338.g60cca15819-goog


