Return-Path: <kvm+bounces-54729-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F208B273C9
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 02:27:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1AE161C25026
	for <lists+kvm@lfdr.de>; Fri, 15 Aug 2025 00:27:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A2B12030A;
	Fri, 15 Aug 2025 00:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TceXqJpC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A728199E89
	for <kvm@vger.kernel.org>; Fri, 15 Aug 2025 00:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755217553; cv=none; b=DHFS9ohFeI0d0yFjGQCaZMORETs+D0BCaKmxsAPpTpDWNfciuAf7bhSlK0tAyodIWg8olNSRNVO1HOIad5LLHjFhYUEnRcQA4UVFqmRjijAb3LK4kVLwpSp+xuTzWQ9kL7wtLbJELi5IUjC+VaKbSC/yZ1APdCRdhrja6LnkPSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755217553; c=relaxed/simple;
	bh=CHCI/ngYYBC1COGAK8r8VM0IZNhXNZ2RzvpfNBDz1gg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k4XuEnxTEv2391EeZrOUDkFLP+ZrmFxv7H7HdvvTbILzUeH0DgLhhyeDlhfl8U/gaIXQpfAiJnpk9yWIF/CAapVaDalVo1uLPlHvSNNV1f/3U/LS0XSXMumBnh2gsgW8fT2vlaqFoH9WwM+QBMz8IX0Cg2zVT9Q+p8VwpmBdIWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TceXqJpC; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24457f42254so31933055ad.0
        for <kvm@vger.kernel.org>; Thu, 14 Aug 2025 17:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755217551; x=1755822351; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M2ABSosJujOM+r1OH0MuqdS0SbZUaaviufYwXH1bqZI=;
        b=TceXqJpCbO9IhAvYW5T9LNeRtoFEJP96vmHRe7tkY8oyrmC9qnosnM82FtySBz8h+X
         I8zyIZabA6sQybzljTxJS/Ya31QD+hOoI3XERGoIX8JVKLA/2pKB832dFgtv1Ld99/aw
         zBVe6az3R3E/sJxTuiDg0EyZueVhn7Rf+eW3bAMJ2Ih1xUp70QdZK59iXX3/npLSUmaY
         jvFTwbfZ6pP6O0j61BOrv6lM7MSpKZWYzhqaXi3ZgMjsLjHG+N9EOGaDkhCzEsC46lji
         wejvddD5mbesBL3TbCF2Z19WF1oyhBwIClqJJqu24QaMvtidy0pDs02qoLzprmy1k/8G
         BeJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755217551; x=1755822351;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M2ABSosJujOM+r1OH0MuqdS0SbZUaaviufYwXH1bqZI=;
        b=Pa+cD95PiSD2TqWUjAFZsE4h6zFY/w3PSsJzQTa8wRdvds0a0BRBBLX0TLM/qwTraw
         eq30VUTGXEaJS8yOfJkwcw0cqeCWSax/dLtmbRHTdvLWywydFxcK+t5n074d8HjnpHS0
         g8aIGAAWOvSe2y/3BFrUzITiSRXRDUdnFdRpskucnzvrrFDFfbodr22+ts3rM5yP7r1c
         7uM9ZPdLn/7wg7NrmVJtR8ngHzoWvfRSsy1U7Byn3QWw3q5eOjgRst9WLI0MSYyFv6WT
         qXHYqZpd9687vp1QTn3k/4qSGRX/LI0NaMR2Hv5Wf82LkHLoqZZqFewM7qD/kQ9X1DjR
         ZBpA==
X-Gm-Message-State: AOJu0YzSEcBrV3QxpIKe95YxzRgFPvVkK76c+tmNK5iwUlBJ4Wx6Go8o
	5e+MWIBgGL51OpuH74Azvmx5iplYzFPQ1ZybmYrJAgrEn3Ar+VjxE25vCoY9p012tNC/vG9cTTN
	tcsEgHg==
X-Google-Smtp-Source: AGHT+IF2i3npz9Mfljfj5wXFhjCB7HDgCwdS9LSNUmrUlj+mX8Afsqi1jKNWUKb0jaKGi5mvyIRSmy9e0M4=
X-Received: from pjbsz15.prod.google.com ([2002:a17:90b:2d4f:b0:312:1e70:e233])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2986:b0:240:7c39:9e25
 with SMTP id d9443c01a7336-2446d889e8amr1786155ad.27.1755217551058; Thu, 14
 Aug 2025 17:25:51 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 14 Aug 2025 17:25:24 -0700
In-Reply-To: <20250815002540.2375664-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250815002540.2375664-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.rc1.163.g2494970778-goog
Message-ID: <20250815002540.2375664-5-seanjc@google.com>
Subject: [PATCH 6.6.y 04/20] KVM: nVMX: Defer SVI update to vmcs01 on EOI when
 L2 is active w/o VID
From: Sean Christopherson <seanjc@google.com>
To: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Sasha Levin <sashal@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Chao Gao <chao.gao@intel.com>

[ Upstream commit 04bc93cf49d16d01753b95ddb5d4f230b809a991 ]

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
Link: https://lore.kernel.org/r/20241128000010.4051275-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
[sean: resolve minor syntactic conflict in lapic.h, account for lack of
       kvm_x86_call(), drop sanity check due to lack of wants_to_run]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c      | 11 +++++++++++
 arch/x86/kvm/lapic.h      |  1 +
 arch/x86/kvm/vmx/nested.c |  5 +++++
 arch/x86/kvm/vmx/vmx.c    | 16 ++++++++++++++++
 arch/x86/kvm/vmx/vmx.h    |  1 +
 5 files changed, 34 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index cbf85a1ffb74..ba1c2a7f74f7 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -803,6 +803,17 @@ static inline void apic_clear_isr(int vec, struct kvm_=
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
+	static_call(kvm_x86_hwapic_isr_update)(vcpu, apic_find_highest_isr(apic))=
;
+}
+EXPORT_SYMBOL_GPL(kvm_apic_update_hwapic_isr);
+
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu)
 {
 	/* This may race with setting of irr in __apic_accept_irq() and
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0a0ea4b5dd8c..0dd069b8d6d1 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -124,6 +124,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr=
_data *msr_info);
 int kvm_apic_get_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s);
 enum lapic_mode kvm_get_apic_mode(struct kvm_vcpu *vcpu);
+void kvm_apic_update_hwapic_isr(struct kvm_vcpu *vcpu);
 int kvm_lapic_find_highest_irr(struct kvm_vcpu *vcpu);
=20
 u64 kvm_get_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d3e346a574f1..fdf7503491f9 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4900,6 +4900,11 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm=
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
 	    (enable_shadow_vmcs || evmptr_is_valid(vmx->nested.hv_evmcs_vmptr)))
 		vmx->nested.need_vmcs12_to_shadow_sync =3D true;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cde01eb1f5e3..4563e7a9a851 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6839,6 +6839,22 @@ static void vmx_hwapic_isr_update(struct kvm_vcpu *v=
cpu, int max_isr)
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
+		 */
+		to_vmx(vcpu)->nested.update_vmcs01_hwapic_isr =3D true;
+		return;
+	}
+
 	if (max_isr =3D=3D -1)
 		max_isr =3D 0;
=20
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 6be1627d888e..88c5b7ebf9d3 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -177,6 +177,7 @@ struct nested_vmx {
 	bool reload_vmcs01_apic_access_page;
 	bool update_vmcs01_cpu_dirty_logging;
 	bool update_vmcs01_apicv_status;
+	bool update_vmcs01_hwapic_isr;
=20
 	/*
 	 * Enlightened VMCS has been enabled. It does not mean that L1 has to
--=20
2.51.0.rc1.163.g2494970778-goog


