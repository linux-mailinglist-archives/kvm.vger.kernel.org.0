Return-Path: <kvm+bounces-12511-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F9748871B9
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 18:10:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A12A81F22481
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 17:10:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A18AA6026F;
	Fri, 22 Mar 2024 17:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="taIzpTuT"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51925FBB3;
	Fri, 22 Mar 2024 17:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711127409; cv=none; b=Cv1vkkxEc+qt6nF5zrs1Wc9AFF1KYjVNvMWnCNXfhI0fZvwaDOyvVi9Q2RtWmw1UjsDQ5MsAg1gB9ngaFhoZBBXVnCJAymYlNoClLRYDnRKFMcwyXzhSeIMbJzLVnAh4AD9oCOeQTddzbiquWZ8TRvDUFqxu2Wpl/ybhy2yAIH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711127409; c=relaxed/simple;
	bh=cEH2I6cJrwITa9Xq6BXzrY044eCA7MlALrT8LCNqqvI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FORAWuazrPNV73W1EB0VfqpXycBMXD9zkYWz2+tHQCb+n219KPFtcsRPVBrYRXQdG2ueOmOhn0EQaYUTcmSCaqbt7YxBwfQACo5LcatmQo0qWhH4MDksQo5WcpPMdgZ1qU0NCd0dmBmIaA5+N6Ga7sRf0NuqLzY8EtdgPPWRKvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=taIzpTuT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5831AC433B1;
	Fri, 22 Mar 2024 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711127409;
	bh=cEH2I6cJrwITa9Xq6BXzrY044eCA7MlALrT8LCNqqvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=taIzpTuTk5pRQhCfPJjpty9PjFR0idaZXzegyUARAc/GTSBj/u/EvY9Rovm9C0bDo
	 cyMEO2XYq/sq5TO0tXueiy9WgCVGGmekCG6myxrGH/S5k7uJKxcCMdL5tc6F+9JPfx
	 HMZyQEQzfKuhCVsOkdHKfqM8LHxXN03w+Pqa187FWN0caXeinQjPSYyY8lv5P/BbwU
	 DyRTRo1+wMQSMsIeF0a9ko6JDBmtyJ4vLR1FFXMsk1GrldsGLLYy6cag6ZfuwGSqQz
	 L4i+xn8A8lyubCVjP7LaS0wBYByZ/dGSpW+G8l3tvRcQhV47Pv9P5hPVfxeKoDX/BL
	 xylcEkrUohz+Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rniP9-00EZPz-CI;
	Fri, 22 Mar 2024 17:10:07 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Dongli Zhang <dongli.zhang@oracle.com>
Subject: [PATCH v2 2/5] KVM: arm64: Exclude host_debug_data from vcpu_arch
Date: Fri, 22 Mar 2024 17:09:42 +0000
Message-Id: <20240322170945.3292593-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240322170945.3292593-1-maz@kernel.org>
References: <20240322170945.3292593-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, james.clark@arm.com, anshuman.khandual@arm.com, broonie@kernel.org, dongli.zhang@oracle.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Keeping host_debug_state on a per-vcpu basis is completely
pointless. The lifetime of this data is only that of the inner
run-loop, which means it is never accessed outside of the core
EL2 code.

Move the structure into kvm_host_data, and save over 500 bytes
per vcpu.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h         | 31 +++++++++++++----------
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h |  4 +--
 arch/arm64/kvm/hyp/nvhe/debug-sr.c        |  8 +++---
 3 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index ca6ef663950d..8c149e4ae99d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -543,6 +543,19 @@ struct kvm_cpu_context {
  */
 struct kvm_host_data {
 	struct kvm_cpu_context host_ctxt;
+
+	/*
+	 * host_debug_state contains the host registers which are
+	 * saved and restored during world switches.
+	 */
+	 struct {
+		/* {Break,watch}point registers */
+		struct kvm_guest_debug_arch regs;
+		/* Statistical profiling extension */
+		u64 pmscr_el1;
+		/* Self-hosted trace */
+		u64 trfcr_el1;
+	} host_debug_state;
 };
 
 struct kvm_host_psci_config {
@@ -637,11 +650,10 @@ struct kvm_vcpu_arch {
 	 * We maintain more than a single set of debug registers to support
 	 * debugging the guest from the host and to maintain separate host and
 	 * guest state during world switches. vcpu_debug_state are the debug
-	 * registers of the vcpu as the guest sees them.  host_debug_state are
-	 * the host registers which are saved and restored during
-	 * world switches. external_debug_state contains the debug
-	 * values we want to debug the guest. This is set via the
-	 * KVM_SET_GUEST_DEBUG ioctl.
+	 * registers of the vcpu as the guest sees them.
+	 *
+	 * external_debug_state contains the debug values we want to debug the
+	 * guest. This is set via the KVM_SET_GUEST_DEBUG ioctl.
 	 *
 	 * debug_ptr points to the set of debug registers that should be loaded
 	 * onto the hardware when running the guest.
@@ -653,15 +665,6 @@ struct kvm_vcpu_arch {
 	struct user_fpsimd_state *host_fpsimd_state;	/* hyp VA */
 	struct task_struct *parent_task;
 
-	struct {
-		/* {Break,watch}point registers */
-		struct kvm_guest_debug_arch regs;
-		/* Statistical profiling extension */
-		u64 pmscr_el1;
-		/* Self-hosted trace */
-		u64 trfcr_el1;
-	} host_debug_state;
-
 	/* VGIC state */
 	struct vgic_cpu vgic_cpu;
 	struct arch_timer_cpu timer_cpu;
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index eec0f8ccda56..d00093699aaf 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -137,7 +137,7 @@ static inline void __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
 
 	host_ctxt = host_data_ptr(host_ctxt);
 	guest_ctxt = &vcpu->arch.ctxt;
-	host_dbg = &vcpu->arch.host_debug_state.regs;
+	host_dbg = host_data_ptr(host_debug_state.regs);
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
 
 	__debug_save_state(host_dbg, host_ctxt);
@@ -156,7 +156,7 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 
 	host_ctxt = host_data_ptr(host_ctxt);
 	guest_ctxt = &vcpu->arch.ctxt;
-	host_dbg = &vcpu->arch.host_debug_state.regs;
+	host_dbg = host_data_ptr(host_debug_state.regs);
 	guest_dbg = kern_hyp_va(vcpu->arch.debug_ptr);
 
 	__debug_save_state(guest_dbg, guest_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 7746ea507b6f..53efda0235cf 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -83,10 +83,10 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	/* Disable and flush SPE data generation */
 	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_SPE))
-		__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
+		__debug_save_spe(host_data_ptr(host_debug_state.pmscr_el1));
 	/* Disable and flush Self-Hosted Trace generation */
 	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
-		__debug_save_trace(&vcpu->arch.host_debug_state.trfcr_el1);
+		__debug_save_trace(host_data_ptr(host_debug_state.trfcr_el1));
 }
 
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
@@ -97,9 +97,9 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_SPE))
-		__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
+		__debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
 	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
-		__debug_restore_trace(vcpu->arch.host_debug_state.trfcr_el1);
+		__debug_restore_trace(*host_data_ptr(host_debug_state.trfcr_el1));
 }
 
 void __debug_switch_to_host(struct kvm_vcpu *vcpu)
-- 
2.39.2


