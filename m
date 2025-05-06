Return-Path: <kvm+bounces-45637-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 72ABAAACB5C
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 18:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3FF23A7DCF
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 16:46:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CCB72882AC;
	Tue,  6 May 2025 16:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QnfE+Pn2"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02792874F0;
	Tue,  6 May 2025 16:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746549853; cv=none; b=ssm9XvMjLRpQnH8xHeqn4BJvB5dZ0O79nSArLnYy9UaXbg7eXNOLRrcog5aAEHsKV8e+H6x6PAa6f1cc+mQUZrjHwgqCoBjmxq4SsqPe5DwpA7VZSPV4K1pPetKa3C+OJEPRIpVjsgcMyEvHjtyyRZ76lbwycVcBfTu9xt0XxR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746549853; c=relaxed/simple;
	bh=Y0zjLJEGkJrxaxp4SDctGpq7uyiWPRxobc1+3u1ZYhU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MT4FBRKFIpsdCdat8UBkhmFJFRTmfzFntI5aZfXsaknREgs2f9JdckZJpUm1wK7nEOf5y7/xXbj6T0HAeuoUjSOeUTuqjwBHJiLdF/YUEBvRW2UjFWXZR79HF3nPeQNqvLSYaGCDEkTpEdfu24xBdrPmClr/i2Ah+Gi+NmgFsG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QnfE+Pn2; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0282C4CEEB;
	Tue,  6 May 2025 16:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746549853;
	bh=Y0zjLJEGkJrxaxp4SDctGpq7uyiWPRxobc1+3u1ZYhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnfE+Pn2iGJXtZ6akqbzwmun/WrXpt4zH3y1dzyi9zAIJNA73ndrUggFcMERtQnL8
	 nWWHuqeHUBRa/cPESclt9mqvKEr4ewKsubmLsMAJ6wTH6PHCxKqxjOnt45yo8gFM0Y
	 CaISxUeqDVq/Rnb4PmNdjf5oHdzMHgNMfI7aPV6/DEk98+ixFwtzl5GWvSLHNhzMiz
	 QNRxr7zVy7Mk8lH/RbDms6aAcHlwhixLwIq2+bpISilo7M+Av31TNi0Qx4bx0gzPnd
	 fs8M7C3TkQr6gvwQYqcX7dCgv8qEIoy6/FjSQDX2jOVl/tG3csh8Q3LwyzHcciZ40u
	 O2RNCGfiEsPZg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1uCLOt-00CJkN-St;
	Tue, 06 May 2025 17:44:11 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ben Horgan <ben.horgan@arm.com>
Subject: [PATCH v4 25/43] KVM: arm64: Unconditionally configure fine-grain traps
Date: Tue,  6 May 2025 17:43:30 +0100
Message-Id: <20250506164348.346001-26-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250506164348.346001-1-maz@kernel.org>
References: <20250506164348.346001-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, mark.rutland@arm.com, tabba@google.com, will@kernel.org, catalin.marinas@arm.com, ben.horgan@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

From: Mark Rutland <mark.rutland@arm.com>

... otherwise we can inherit the host configuration if this differs from
the KVM configuration.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
[maz: simplified a couple of things]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 39 ++++++++++---------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 027d05f308f75..925a3288bd5be 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -107,7 +107,8 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 
 #define update_fgt_traps_cs(hctxt, vcpu, kvm, reg, clr, set)		\
 	do {								\
-		u64 c = 0, s = 0;					\
+		u64 c = clr, s = set;					\
+		u64 val;						\
 									\
 		ctxt_sys_reg(hctxt, reg) = read_sysreg_s(SYS_ ## reg);	\
 		if (vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu))		\
@@ -115,14 +116,10 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 									\
 		compute_undef_clr_set(vcpu, kvm, reg, c, s);		\
 									\
-		s |= set;						\
-		c |= clr;						\
-		if (c || s) {						\
-			u64 val = __ ## reg ## _nMASK;			\
-			val |= s;					\
-			val &= ~c;					\
-			write_sysreg_s(val, SYS_ ## reg);		\
-		}							\
+		val = __ ## reg ## _nMASK;				\
+		val |= s;						\
+		val &= ~c;						\
+		write_sysreg_s(val, SYS_ ## reg);			\
 	} while(0)
 
 #define update_fgt_traps(hctxt, vcpu, kvm, reg)		\
@@ -175,33 +172,27 @@ static inline void __activate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 		update_fgt_traps(hctxt, vcpu, kvm, HAFGRTR_EL2);
 }
 
-#define __deactivate_fgt(htcxt, vcpu, kvm, reg)				\
+#define __deactivate_fgt(htcxt, vcpu, reg)				\
 	do {								\
-		if ((vcpu_has_nv(vcpu) && !is_hyp_ctxt(vcpu)) ||	\
-		    kvm->arch.fgu[reg_to_fgt_group_id(reg)])		\
-			write_sysreg_s(ctxt_sys_reg(hctxt, reg),	\
-				       SYS_ ## reg);			\
+		write_sysreg_s(ctxt_sys_reg(hctxt, reg),		\
+			       SYS_ ## reg);				\
 	} while(0)
 
 static inline void __deactivate_traps_hfgxtr(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *hctxt = host_data_ptr(host_ctxt);
-	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 
 	if (!cpus_have_final_cap(ARM64_HAS_FGT))
 		return;
 
-	__deactivate_fgt(hctxt, vcpu, kvm, HFGRTR_EL2);
-	if (cpus_have_final_cap(ARM64_WORKAROUND_AMPERE_AC03_CPU_38))
-		write_sysreg_s(ctxt_sys_reg(hctxt, HFGWTR_EL2), SYS_HFGWTR_EL2);
-	else
-		__deactivate_fgt(hctxt, vcpu, kvm, HFGWTR_EL2);
-	__deactivate_fgt(hctxt, vcpu, kvm, HFGITR_EL2);
-	__deactivate_fgt(hctxt, vcpu, kvm, HDFGRTR_EL2);
-	__deactivate_fgt(hctxt, vcpu, kvm, HDFGWTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, HFGRTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, HFGWTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, HFGITR_EL2);
+	__deactivate_fgt(hctxt, vcpu, HDFGRTR_EL2);
+	__deactivate_fgt(hctxt, vcpu, HDFGWTR_EL2);
 
 	if (cpu_has_amu())
-		__deactivate_fgt(hctxt, vcpu, kvm, HAFGRTR_EL2);
+		__deactivate_fgt(hctxt, vcpu, HAFGRTR_EL2);
 }
 
 static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
-- 
2.39.2


