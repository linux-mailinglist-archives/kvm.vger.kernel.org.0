Return-Path: <kvm+bounces-15239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A66428AACDB
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:31:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 601EC282A13
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 10:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F59381729;
	Fri, 19 Apr 2024 10:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uj1i38ds"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10197FBAF;
	Fri, 19 Apr 2024 10:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713522593; cv=none; b=kRLKATwP+WRcxipEpXxI9/sCf927Uim4PwhsmWZXpMtMikr3cJzIqkkvsSBf8fCsQXEmM2X22XMhjapNZahiCumlfjmV8cwXB/3ad0z8BScHb9U1ScjL+uuw+nCUQn1vkwTPOsznURnJ6ljzJ3Ko5psRVi6G/cR+GEa8uJJAT0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713522593; c=relaxed/simple;
	bh=3mtQOeqT5hkTI2xaw9Qk8k1KFnpFiefVFxYHDiC8HeM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=E0mImwKGc3+pJLHm8yjQ+E6MMdAD0xvvZvIykwH8cjYTEKMI4JR6clasJ0il1FcQ6iLXDRKqzMi9/CrzWOaTIThp9UO2XPCi6o8bKqtPqUUYy2FWojQTnCmXBya+wByHp4zbKYt7xa5qkQ/I9RZH9vGrB6+IAFRJYU3nL8dJAqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Uj1i38ds; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90DE1C3277B;
	Fri, 19 Apr 2024 10:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713522593;
	bh=3mtQOeqT5hkTI2xaw9Qk8k1KFnpFiefVFxYHDiC8HeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uj1i38ds2XG5KPJghO7zrdheHgTFxnNz+F9EZBEIwPRkiTi+ZklEUR71F5mjZeILt
	 OY92HxZR3Ll4ETYYw9up1ydb/rBHgiC5yEE83BNXCaw9Bl2QCZJqGfScIvc2BHI3oH
	 5GGLYsm/CyBTZkDBPh1G/5c0FXx1jis7UWJWiNRCxhkMtOV9fdOwMLd+LXnlgAzJQD
	 4Wk3etYvgsoRUFVoQpyVPsYZRdsLu9JqX+Xlp2c114mnQpP/GaMT9WHjie6bTwej9l
	 RGIaDb1MAEVkqyu3lhXxKCVnexgR1nI/Q/9dvn9W0HOT8YcsK3sVJ2XhD6OF8AxE8C
	 NM7sqEaKbQSag==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1rxlV9-00636W-SZ;
	Fri, 19 Apr 2024 11:29:51 +0100
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
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH v4 13/15] KVM: arm64: nv: Handle ERETA[AB] instructions
Date: Fri, 19 Apr 2024 11:29:33 +0100
Message-Id: <20240419102935.1935571-14-maz@kernel.org>
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
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, joey.gouly@arm.com, tabba@google.com, smostafa@google.com, will@kernel.org, catalin.marinas@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that we have some emulation in place for ERETA[AB], we can
plug it into the exception handling machinery.

As for a bare ERET, an "easy" ERETAx instruction is processed as
a fixup, while something that requires a translation regime
transition or an exception delivery is left to the slow path.

Reviewed-by: Joey Gouly <joey.gouly@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/emulate-nested.c | 22 ++++++++++++++++++++--
 arch/arm64/kvm/handle_exit.c    |  3 ++-
 arch/arm64/kvm/hyp/vhe/switch.c | 13 +++++++++++--
 3 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 63a74c0330f1..72d733c74a38 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2172,7 +2172,7 @@ static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
 
 void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 {
-	u64 spsr, elr;
+	u64 spsr, elr, esr;
 
 	/*
 	 * Forward this trap to the virtual EL2 if the virtual
@@ -2181,12 +2181,30 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	if (forward_traps(vcpu, HCR_NV))
 		return;
 
+	/* Check for an ERETAx */
+	esr = kvm_vcpu_get_esr(vcpu);
+	if (esr_iss_is_eretax(esr) && !kvm_auth_eretax(vcpu, &elr)) {
+		/*
+		 * Oh no, ERETAx failed to authenticate.  If we have
+		 * FPACCOMBINE, deliver an exception right away.  If we
+		 * don't, then let the mangled ELR value trickle down the
+		 * ERET handling, and the guest will have a little surprise.
+		 */
+		if (kvm_has_pauth(vcpu->kvm, FPACCOMBINE)) {
+			esr &= ESR_ELx_ERET_ISS_ERETA;
+			esr |= FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_FPAC);
+			kvm_inject_nested_sync(vcpu, esr);
+			return;
+		}
+	}
+
 	preempt_disable();
 	kvm_arch_vcpu_put(vcpu);
 
 	spsr = __vcpu_sys_reg(vcpu, SPSR_EL2);
 	spsr = kvm_check_illegal_exception_return(vcpu, spsr);
-	elr = __vcpu_sys_reg(vcpu, ELR_EL2);
+	if (!esr_iss_is_eretax(esr))
+		elr = __vcpu_sys_reg(vcpu, ELR_EL2);
 
 	trace_kvm_nested_eret(vcpu, elr, spsr);
 
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 1ba2f788b2c3..407bdfbb572b 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -248,7 +248,8 @@ static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
 
 static int kvm_handle_eret(struct kvm_vcpu *vcpu)
 {
-	if (esr_iss_is_eretax(kvm_vcpu_get_esr(vcpu)))
+	if (esr_iss_is_eretax(kvm_vcpu_get_esr(vcpu)) &&
+	    !vcpu_has_ptrauth(vcpu))
 		return kvm_handle_ptrauth(vcpu);
 
 	/*
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 26395171621b..8e1d98b691c1 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -208,7 +208,8 @@ void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
 
 static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	u64 spsr, mode;
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+	u64 spsr, elr, mode;
 
 	/*
 	 * Going through the whole put/load motions is a waste of time
@@ -242,10 +243,18 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 		return false;
 	}
 
+	/* If ERETAx fails, take the slow path */
+	if (esr_iss_is_eretax(esr)) {
+		if (!(vcpu_has_ptrauth(vcpu) && kvm_auth_eretax(vcpu, &elr)))
+			return false;
+	} else {
+		elr = read_sysreg_el1(SYS_ELR);
+	}
+
 	spsr = (spsr & ~(PSR_MODE_MASK | PSR_MODE32_BIT)) | mode;
 
 	write_sysreg_el2(spsr, SYS_SPSR);
-	write_sysreg_el2(read_sysreg_el1(SYS_ELR), SYS_ELR);
+	write_sysreg_el2(elr, SYS_ELR);
 
 	return true;
 }
-- 
2.39.2


