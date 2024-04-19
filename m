Return-Path: <kvm+bounces-15231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CBFDA8AACD2
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:30:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 64E9F1F2210C
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4CD480020;
	Fri, 19 Apr 2024 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BqmcjUya"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6577E59F;
	Fri, 19 Apr 2024 10:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713522592; cv=none; b=VkMExKigSYOogrdTG/k3JfmFhKmOK6MKH+4eMYQU08BnDSJq9VmcsfhdxpcHffP7oTcLzFS/GPeNaV9a25oQEKVX5O+ov5H7YzyfI5kikvGPNIHIw8zM/JeItaC3KwOehJopD1tbrjFod3hv7o7xyD3tWPHdI90E70JAmpzAa1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713522592; c=relaxed/simple;
	bh=xE8hNSFxmpy+AAOQpa+KgTdZLT8PINd+Cx6eo/7x5E0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KXf4lacIfRGONNn2gMrm75aFvX8HLmy+W50gvXsi8HEC+FU0lfOuGHsf2GAD+bFqAnKWR6jHtY4KcM6mV5vxBVpD+zNX4yArzbdw4akczKrULZLiOZFmw2zdzqvw2cv4XEcgKadJmEkDkw9vrN5MffH6elW58SluWZY4P5XByEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BqmcjUya; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552F7C32782;
	Fri, 19 Apr 2024 10:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713522592;
	bh=xE8hNSFxmpy+AAOQpa+KgTdZLT8PINd+Cx6eo/7x5E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BqmcjUyaoXFUnlWplV2gxlK8xDZ0fIKFkj7dJWyKEqcoDH84kzjQMYKQlKyt2rGmD
	 X8PWHNtbDIwer12xJm5hp0C22uGaZ6MDA8p1ocRk1IOh6AeMHcx+ZtGAeYgQqKzRhz
	 1ZYJ31l0x9LlH9Ul8H+KoytMLBI+JXvDWs1N3qvXdCl4YYa7Z4N/dVXxcZeZf8sJUm
	 Qf0P4aFM4kMvdUN9EhqpIUIbD1MrrqKUeHJD9FivO3fqmlhc5jTJzxJZm7ifQ0kLsV
	 fXbqZ0dBF1eCMocCXmhI1E4a9j+lDOSk5irOhqfd1CsH30hJuUolya3KCvA3nRcZOj
	 vG4xD7+rjnJVg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rxlV8-00636W-7n;
	Fri, 19 Apr 2024 11:29:50 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jintack Lim <jintack.lim@linaro.org>
Subject: [PATCH v4 06/15] KVM: arm64: nv: Add trap forwarding for ERET and SMC
Date: Fri, 19 Apr 2024 11:29:26 +0100
Message-Id: <20240419102935.1935571-7-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240419102935.1935571-1-maz@kernel.org>
References: <20240419102935.1935571-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, tabba@google.com, smostafa@google.com, will@kernel.org, catalin.marinas@arm.com, jintack.lim@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Honor the trap forwarding bits for both ERET and SMC, using a new
helper that checks for common conditions.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
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
index 15221e481ccd..6a88ec024e2f 100644
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


