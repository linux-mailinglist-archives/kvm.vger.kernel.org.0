Return-Path: <kvm+bounces-9056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 43B62859F84
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 10:21:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ED65D1F23090
	for <lists+kvm@lfdr.de>; Mon, 19 Feb 2024 09:21:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4286E25778;
	Mon, 19 Feb 2024 09:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gHP6sHos"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84D9823746;
	Mon, 19 Feb 2024 09:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708334424; cv=none; b=Xv4kz5XUaPb0O4qGA29AsTVHViAHe3V67877dN6+7qZqS9MVj3DENlBl6YGm0UwKRbe4nmup40uJvzMepVwGYeVazdJraXZNjhhBVYlKPkv5BE7ZiYJ02Y8gToigI6xfDR03WgmQ/GJdAgWa9+oVN7PGhKWf7CVNkLRtFpt33rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708334424; c=relaxed/simple;
	bh=sBCU4sUiSq3xPDA9YV2MrPVNgqWjyvQaOeV9pveINik=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=I5WcdaqKlGKk5erZlFAFpxOCCCY4zo0Oipazlon2qPirVYTDNSImEl+gW73Q1KocbbHq+B1qiaYTzlYW5dPDUdes3t5SCuJ2tTbiXf9ypKk/cGnv5++cD02TxbqmYkUdX1pWqEU8qn+rAchhjlsrRXUBFe6rVMdBST4DmwJuOL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gHP6sHos; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59717C43330;
	Mon, 19 Feb 2024 09:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708334424;
	bh=sBCU4sUiSq3xPDA9YV2MrPVNgqWjyvQaOeV9pveINik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHP6sHos3qi5m/Adz27AeJehnp1YvIuCy9DdAjRPisyFjvNSwsXcKMTt5B3k0SVPD
	 8L8/K6MVWzBOVoF/PesCbHVJUMAd9LDqY+TtOf3baj6LRJwiApjdhthYU8s+ZqVqhA
	 St90vosCa9W7kgsr2cNQGEYreZo16uj6CSoD8a2kiDLaFBESx7iCF3xyhr5U5XFOzx
	 odzrdR4YhIz5JZ6njG1HJCkT3qhLNtxjZanP33bADHfPUVhTMHTTMj5h3Xiypa+nvG
	 oa/tuHvOpUZMe8zSjYUxHsLLpscFoHJhRkmGy5BGAI6MWGpBQ+MtMDIdg+P7lB6l3W
	 7oKNIzhNy/Rcg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rbzp0-004WBZ-DT;
	Mon, 19 Feb 2024 09:20:22 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 05/13] KVM: arm64: nv: Add trap forwarding for ERET and SMC
Date: Mon, 19 Feb 2024 09:20:06 +0000
Message-Id: <20240219092014.783809-6-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240219092014.783809-1-maz@kernel.org>
References: <20240219092014.783809-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Honor the trap forwarding bits for both ERET and SMC, using a new
helper that checks for common conditions.

Co-developed-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Jintack Lim <jintack.lim@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_nested.h |  1 +
 arch/arm64/kvm/emulate-nested.c     | 27 +++++++++++++++++++++++++++
 arch/arm64/kvm/handle_exit.c        |  7 +++++++
 3 files changed, 35 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index c77d795556e1..dbc4e3a67356 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -60,6 +60,7 @@ static inline u64 translate_ttbr0_el2_to_ttbr0_el1(u64 ttbr0)
 	return ttbr0 & ~GENMASK_ULL(63, 48);
 }
 
+extern bool forward_smc_trap(struct kvm_vcpu *vcpu);
 
 int kvm_init_nv_sysregs(struct kvm *kvm);
 
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 4697ba41b3a9..2d80e81ae650 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2117,6 +2117,26 @@ bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index)
 	return true;
 }
 
+static bool forward_traps(struct kvm_vcpu *vcpu, u64 control_bit)
+{
+	bool control_bit_set;
+
+	if (!vcpu_has_nv(vcpu))
+		return false;
+
+	control_bit_set = __vcpu_sys_reg(vcpu, HCR_EL2) & control_bit;
+	if (!is_hyp_ctxt(vcpu) && control_bit_set) {
+		kvm_inject_nested_sync(vcpu, kvm_vcpu_get_esr(vcpu));
+		return true;
+	}
+	return false;
+}
+
+bool forward_smc_trap(struct kvm_vcpu *vcpu)
+{
+	return forward_traps(vcpu, HCR_TSC);
+}
+
 static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 {
 	u64 mode = spsr & PSR_MODE_MASK;
@@ -2155,6 +2175,13 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	u64 spsr, elr, mode;
 	bool direct_eret;
 
+	/*
+	 * Forward this trap to the virtual EL2 if the virtual
+	 * HCR_EL2.NV bit is set and this is coming from !EL2.
+	 */
+	if (forward_traps(vcpu, HCR_NV))
+		return;
+
 	/*
 	 * Going through the whole put/load motions is a waste of time
 	 * if this is a VHE guest hypervisor returning to its own
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 0646c623d1da..1ccdfe40c691 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -55,6 +55,13 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 
 static int handle_smc(struct kvm_vcpu *vcpu)
 {
+	/*
+	 * Forward this trapped smc instruction to the virtual EL2 if
+	 * the guest has asked for it.
+	 */
+	if (forward_smc_trap(vcpu))
+		return 1;
+
 	/*
 	 * "If an SMC instruction executed at Non-secure EL1 is
 	 * trapped to EL2 because HCR_EL2.TSC is 1, the exception is a
-- 
2.39.2


