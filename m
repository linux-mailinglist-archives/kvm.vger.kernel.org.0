Return-Path: <kvm+bounces-15549-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 24F188AD3C4
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 20:18:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 436D31C20BA7
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 18:18:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF416154441;
	Mon, 22 Apr 2024 18:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pKbnRnEV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8221E15442B
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 18:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713809886; cv=none; b=nwGnoEqhA3bq+BsymfomBbgdvxRhAiNGSu05157F4kaPoBvUFeGXnplYhTKUCoZP/KPAxAb1+1Aor6MLluhM574jpC8oMVqPq4FmIwEebUV/siyOKiuuITjo+QYHUPS81oAjQRsxJm7x3UmhyuCVtnod9ib5glRdxrE1HeOlxlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713809886; c=relaxed/simple;
	bh=EqSTPNMowwCgymn+v0WtAz03SumIq2vQhNLhAloGFtY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=qTG4RMR5rsQhQ5AiBCIskqdnN8HQt92yf+bEkPkME5JyQYh7YD9+heJrg5t6Ap1jgnOEr3Il6nIylmKd6tDObUzGBYE3JsouvY7Xi9QA3KiwLl+EN2RKfGMTk71Q4FDHTJFuhvmZOcmWUIhGfnD3qDsY6Rp4a7nI7mT2Qk06EuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pKbnRnEV; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de45daf49deso10578938276.2
        for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 11:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713809883; x=1714414683; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=oI5PsFH5OqKQcxn/PnstoUW6QKwHJtSKvuBDm6LMOPQ=;
        b=pKbnRnEV65ACHdGVwgFVSUZzRLua3oGnFQMaL2/i4rbgRF51NDYA18+BcNwylo9hNU
         XWlhNR3iD52iUng3JBx7RTqc9mcK5LBXJWs50pkm8vqAeOOmZTerUqj6zydKrCQTFzAd
         qPjYK0uB7VgUigjnRZ2urSNTGAVE8NyQEnUhK+jzyJ1DC1fdxk9Y6yj2Zr7myQ2whFl3
         UQJ7NtYgJtL9CFBaocVMIjaD90QBIQLAJoZlbjcPZE0MOqN/Dsb3Zppk9SKzzIqUuEcK
         Cv+o5aagoChNb3AIeSyD4eQ0B6LY0iu7OBbHQ55OkPGjikbnUnoDqZEQZQ/oDJLnJ2Pg
         skdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713809883; x=1714414683;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oI5PsFH5OqKQcxn/PnstoUW6QKwHJtSKvuBDm6LMOPQ=;
        b=dKX1B5X+Q7U5/o7japPqluMjprtUepkmYg122Ez0ceT2kUAaNcXBk+/OYimeALPI4G
         IAeghhmk4ERneSsISUCcoshKyj3eFsdlmses/LAP+gzeTm2PlVl5jxhJ1zwZHogckPoh
         kjPkKIvx5N+VM+SD/iOgmBgWw/v7j5VRVGcR/YtjBiDz9zBueaejuUV6fp1GgG1huXPx
         jmZ+BcvdzL9A081Hf/Dg1FqX8ENOW9grbvobrADFKHNCtrAWZq0P58ZNu9nt+r5df+ZK
         5Mdi1L1w1sOaOFjZjRY/iEUAzmhreVG82zbvbjMOYHnUS659a8Xq50PWVgtbk8StaOzR
         O0pA==
X-Gm-Message-State: AOJu0YwG5980BZWAZE/aMJp/FBq01aMxVYaVXSHguTLrMIQZ5mu/Axap
	mzNDFKdZ1WgH2I9aGuR9uaUCJQO7DsrXRKDvQQJk6UoK79wjBQsmN35vTBrBNr9H9U0AmMurUAl
	D0a2CeiS0rT45c5DhBvvKwK9K9gXq2M8IDlw8YYuayrWz/NGxp9QpHFCgMQj8pqM2T6C1lnceEY
	2/puW6OZ2TL/npA5+w2VOto9Twd5VfZiy4bsvIlBV0rTghk1ZgBwVjHYQ=
X-Google-Smtp-Source: AGHT+IEKODLHt0IICOPUeVBmNrFEXzRI0P6fCZGRCIutCpq1JEBl/VDOZ6TtUkQgtYk3XxRPPL+MJTGy5Ijvtnur4w==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6902:1146:b0:dc7:49a9:6666 with
 SMTP id p6-20020a056902114600b00dc749a96666mr3364862ybu.3.1713809883531; Mon,
 22 Apr 2024 11:18:03 -0700 (PDT)
Date: Mon, 22 Apr 2024 18:17:16 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240422181716.237284-1-coltonlewis@google.com>
Subject: [PATCH v4] KVM: arm64: Add early_param to control WFx trapping
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add an early_params to control WFI and WFE trapping. This is to
control the degree guests can wait for interrupts on their own without
being trapped by KVM. Options for each param are trap, notrap, and
default. trap enables the trap. notrap disables the trap. default
preserves current behavior, disabling the trap if only a single task
is running and enabling otherwise.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
v4:

* Fixed inaccurate names that incorrectly implied this controls interrupts
  themselves instead of instructions waiting for interrupts and events
* Split into two separate params as interrupts (WFI) and events (WFE) do
  different things and may warrant separate controls.
* Document new params in Documentation/admin-guide/kernel-parameters.txt


v3:
https://lore.kernel.org/kvmarm/20240410175437.793508-1-coltonlewis@google.com/

v2:
https://lore.kernel.org/kvmarm/20240319164341.1674863-1-coltonlewis@google.com/

v1:
https://lore.kernel.org/kvmarm/20240129213918.3124494-1-coltonlewis@google.com/

 .../admin-guide/kernel-parameters.txt         | 22 +++++++-
 arch/arm64/include/asm/kvm_emulate.h          | 24 ++++++++-
 arch/arm64/include/asm/kvm_host.h             |  7 +++
 arch/arm64/kvm/arm.c                          | 54 +++++++++++++++++--
 4 files changed, 101 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 31b3a25680d0..f8d16c792e66 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2653,6 +2653,27 @@
 			[KVM,ARM] Allow use of GICv4 for direct injection of
 			LPIs.

+	kvm-arm.wfe_trap_policy=
+			[KVM,ARM] Control when to set wfe instruction trap.
+
+			trap: set wfe instruction trap
+
+			notrap: clear wfe instruction trap
+
+			default: set wfe instruction trap only if multiple
+				 tasks are running on the CPU
+
+	kvm-arm.wfi_trap_policy=
+			[KVM,ARM] Control when to set wfi instruction trap.
+
+			trap: set wfi instruction trap
+
+			notrap: clear wfi instruction trap
+
+			default: set wfi instruction trap only if multiple
+				 tasks are running on the CPU
+
+
 	kvm_cma_resv_ratio=n [PPC]
 			Reserves given percentage from system memory area for
 			contiguous memory allocation for KVM hash pagetable
@@ -7394,4 +7415,3 @@
 				memory, and other data can't be written using
 				xmon commands.
 			off	xmon is disabled.
-
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index b804fe832184..efd0a3fb6f00 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -109,9 +109,13 @@ static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 	return (unsigned long *)&vcpu->arch.hcr_el2;
 }

-static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
+static inline void vcpu_clear_wfe_trap(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 &= ~HCR_TWE;
+}
+
+static inline void vcpu_clear_wfi_trap(struct kvm_vcpu *vcpu)
+{
 	if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
 	    vcpu->kvm->arch.vgic.nassgireq)
 		vcpu->arch.hcr_el2 &= ~HCR_TWI;
@@ -119,12 +123,28 @@ static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
 		vcpu->arch.hcr_el2 |= HCR_TWI;
 }

-static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
+static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
+{
+	vcpu_clear_wfe_trap(vcpu);
+	vcpu_clear_wfi_trap(vcpu);
+}
+
+static inline void vcpu_set_wfe_trap(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 |= HCR_TWE;
+}
+
+static inline void vcpu_set_wfi_trap(struct kvm_vcpu *vcpu)
+{
 	vcpu->arch.hcr_el2 |= HCR_TWI;
 }

+static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
+{
+	vcpu_set_wfe_trap(vcpu);
+	vcpu_set_wfi_trap(vcpu);
+}
+
 static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 21c57b812569..315ee7bfc1cb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -67,6 +67,13 @@ enum kvm_mode {
 	KVM_MODE_NV,
 	KVM_MODE_NONE,
 };
+
+enum kvm_wfx_trap_policy {
+	KVM_WFX_NOTRAP_SINGLE_TASK, /* Default option */
+	KVM_WFX_NOTRAP,
+	KVM_WFX_TRAP,
+};
+
 #ifdef CONFIG_KVM
 enum kvm_mode kvm_get_mode(void);
 #else
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a25265aca432..5106ba5a8a39 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -46,6 +46,8 @@
 #include <kvm/arm_psci.h>

 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
+static enum kvm_wfx_trap_policy kvm_wfi_trap_policy = KVM_WFX_NOTRAP_SINGLE_TASK;
+static enum kvm_wfx_trap_policy kvm_wfe_trap_policy = KVM_WFX_NOTRAP_SINGLE_TASK;

 DECLARE_KVM_HYP_PER_CPU(unsigned long, kvm_hyp_vector);

@@ -423,6 +425,12 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)

 }

+static bool kvm_should_clear_wfx_trap(enum kvm_wfx_trap_policy p)
+{
+	return (p == KVM_WFX_NOTRAP && kvm_vgic_global_state.has_gicv4)
+		|| (p == KVM_WFX_NOTRAP_SINGLE_TASK && single_task_running());
+}
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_s2_mmu *mmu;
@@ -456,10 +464,15 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);

-	if (single_task_running())
-		vcpu_clear_wfx_traps(vcpu);
+	if (kvm_should_clear_wfx_trap(kvm_wfi_trap_policy))
+		vcpu_clear_wfi_trap(vcpu);
 	else
-		vcpu_set_wfx_traps(vcpu);
+		vcpu_set_wfi_trap(vcpu);
+
+	if (kvm_should_clear_wfx_trap(kvm_wfe_trap_policy))
+		vcpu_clear_wfe_trap(vcpu);
+	else
+		vcpu_set_wfe_trap(vcpu);

 	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_disable(vcpu);
@@ -2654,6 +2667,41 @@ static int __init early_kvm_mode_cfg(char *arg)
 }
 early_param("kvm-arm.mode", early_kvm_mode_cfg);

+static int __init early_kvm_wfx_trap_policy_cfg(char *arg, enum kvm_wfx_trap_policy *p)
+{
+	if (!arg)
+		return -EINVAL;
+
+	if (strcmp(arg, "trap") == 0) {
+		*p = KVM_WFX_TRAP;
+		return 0;
+	}
+
+	if (strcmp(arg, "notrap") == 0) {
+		*p = KVM_WFX_NOTRAP;
+		return 0;
+	}
+
+	if (strcmp(arg, "default") == 0) {
+		*p = KVM_WFX_NOTRAP_SINGLE_TASK;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int __init early_kvm_wfi_trap_policy_cfg(char *arg)
+{
+	return early_kvm_wfx_trap_policy_cfg(arg, &kvm_wfi_trap_policy);
+}
+early_param("kvm-arm.wfi_trap_policy", early_kvm_wfi_trap_policy_cfg);
+
+static int __init early_kvm_wfe_trap_policy_cfg(char *arg)
+{
+	return early_kvm_wfx_trap_policy_cfg(arg, &kvm_wfe_trap_policy);
+}
+early_param("kvm-arm.wfe_trap_policy", early_kvm_wfe_trap_policy_cfg);
+
 enum kvm_mode kvm_get_mode(void)
 {
 	return kvm_mode;
--
2.44.0.769.g3c40516874-goog

