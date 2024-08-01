Return-Path: <kvm+bounces-22917-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F76594482D
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 11:26:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5BF7FB28C89
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2024 09:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE98A1A073F;
	Thu,  1 Aug 2024 09:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PR/h/wUY"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC804170A35;
	Thu,  1 Aug 2024 09:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722504149; cv=none; b=o3Zywd+QbMgPhLkrXCaRxh3HupWOf8aC45pq2ma9jaPuKkAI6eS20OOAquqdFsp3qPabjKjBIcbRhW59/c3FfHwltWpMzVIlu+crLip97L8NEDj2cQFRNJyrOf3UU3i5koI+IzkzixZVdRfO2YvT9FfZKai8HyElO8PJgv3tABI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722504149; c=relaxed/simple;
	bh=Mc7TZVN9UAGLw7VMT6n/xlZTGIZNfGL0jqmWlwOCfQU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rJuXA4FoLPpcMeFMMycU8rWkz/2i2mlxrP8jpISDDFlXlWxR/1VQwqVbHrBqlbDFSTpC8duTniGXBIlFefRlNVZ2zBtAmToQbfIl1ZGgSfWdAx1322mtgPajdq7jn2V70iXYav+waZANcCWuQi2sCb7JQlKmcOdn1+l0EGbdfb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PR/h/wUY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F533C4AF0E;
	Thu,  1 Aug 2024 09:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722504149;
	bh=Mc7TZVN9UAGLw7VMT6n/xlZTGIZNfGL0jqmWlwOCfQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PR/h/wUYmBOxUigR0crqXKV7l4oISoea3m9SnyUXZBxL6Ra9ceMay+u9osGVSQai4
	 IxSydy/9k2bRO9TA5UsmqYMtZoP4IIzRfEx4fidaBLt+bz00Saz09S2nqHbrVDtHk8
	 XNm85AZ9wWL5VYN5cHDi4N0HvGd5GiUMxcu8pErh3CV8hk6dAc5s7xlMQfoozav9hV
	 9CQEPQso1KZ6asJMMbgxIXjiw/Ldr2oJFJNp+Slj4ysfpO9mx1GWOdxuuCIiZA6lkU
	 hoAbVFLyFPSDKG1V/f677Rzr6bolJMXShQz8wB1aaLO7LPavZ5VtfqjzE0Z6Fu2sHI
	 Lhbi1lqI7akLQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1sZRya-00HKNZ-Hh;
	Thu, 01 Aug 2024 10:20:00 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v2 4/8] KVM: arm64: Add save/restore support for FPMR
Date: Thu,  1 Aug 2024 10:19:51 +0100
Message-Id: <20240801091955.2066364-5-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240801091955.2066364-1-maz@kernel.org>
References: <20240801091955.2066364-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, tabba@google.com, joey.gouly@arm.com, broonie@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Just like the rest of the FP/SIMD state, FPMR needs to be context
switched.

The only interesting thing here is that we need to treat the pKVM
part a bit differently, as the host FP state is never written back
to the vcpu thread, but instead stored locally and eagerly restored.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h       | 10 ++++++++++
 arch/arm64/kvm/fpsimd.c                 |  1 +
 arch/arm64/kvm/hyp/include/hyp/switch.h |  3 +++
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  9 +++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c        |  9 +++++++++
 arch/arm64/kvm/hyp/vhe/switch.c         |  3 +++
 6 files changed, 35 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 021f7a1845f2..a6b684c08fe7 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -599,6 +599,16 @@ struct kvm_host_data {
 		struct cpu_sve_state *sve_state;
 	};
 
+	union {
+		/* HYP VA pointer to the host storage for FPMR */
+		u64	*fpmr_ptr;
+		/*
+		 * Used by pKVM only, as it needs to provide storage
+		 * for the host
+		 */
+		u64	fpmr;
+	};
+
 	/* Ownership of the FP regs */
 	enum {
 		FP_STATE_FREE,
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 4cb8ad5d69a8..ea5484ce1f3b 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -63,6 +63,7 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	 */
 	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
 	*host_data_ptr(fpsimd_state) = kern_hyp_va(&current->thread.uw.fpsimd_state);
+	*host_data_ptr(fpmr_ptr) = kern_hyp_va(&current->thread.uw.fpmr);
 
 	vcpu_clear_flag(vcpu, HOST_SVE_ENABLED);
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f59ccfe11ab9..84a135ba21a9 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -404,6 +404,9 @@ static bool kvm_hyp_handle_fpsimd(struct kvm_vcpu *vcpu, u64 *exit_code)
 	else
 		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);
 
+	if (kvm_has_fpmr(kern_hyp_va(vcpu->kvm)))
+		write_sysreg_s(__vcpu_sys_reg(vcpu, FPMR), SYS_FPMR);
+
 	/* Skip restoring fpexc32 for AArch64 guests */
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
 		write_sysreg(__vcpu_sys_reg(vcpu, FPEXC32_EL2), fpexc32_el2);
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f43d845f3c4e..87692b566d90 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -62,6 +62,8 @@ static void fpsimd_sve_flush(void)
 
 static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 {
+	bool has_fpmr;
+
 	if (!guest_owns_fp_regs())
 		return;
 
@@ -73,11 +75,18 @@ static void fpsimd_sve_sync(struct kvm_vcpu *vcpu)
 	else
 		__fpsimd_save_state(&vcpu->arch.ctxt.fp_regs);
 
+	has_fpmr = kvm_has_fpmr(kern_hyp_va(vcpu->kvm));
+	if (has_fpmr)
+		__vcpu_sys_reg(vcpu, FPMR) = read_sysreg_s(SYS_FPMR);
+
 	if (system_supports_sve())
 		__hyp_sve_restore_host();
 	else
 		__fpsimd_restore_state(*host_data_ptr(fpsimd_state));
 
+	if (has_fpmr)
+		write_sysreg_s(*host_data_ptr(fpmr), SYS_FPMR);
+
 	*host_data_ptr(fp_owner) = FP_STATE_HOST_OWNED;
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 6af179c6356d..2466dd231362 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -198,6 +198,15 @@ static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 	} else {
 		__fpsimd_save_state(*host_data_ptr(fpsimd_state));
 	}
+
+	if (kvm_has_fpmr(vcpu->kvm)) {
+		u64 fpmr = read_sysreg_s(SYS_FPMR);
+
+		if (unlikely(is_protected_kvm_enabled()))
+			*host_data_ptr(fpmr) = fpmr;
+		else
+			**host_data_ptr(fpmr_ptr) = fpmr;
+	}
 }
 
 static const exit_handler_fn hyp_exit_handlers[] = {
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 77010b76c150..80581b1c3995 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -312,6 +312,9 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
 {
 	__fpsimd_save_state(*host_data_ptr(fpsimd_state));
+
+	if (kvm_has_fpmr(vcpu->kvm))
+		**host_data_ptr(fpmr_ptr) = read_sysreg_s(SYS_FPMR);
 }
 
 static bool kvm_hyp_handle_tlbi_el2(struct kvm_vcpu *vcpu, u64 *exit_code)
-- 
2.39.2


