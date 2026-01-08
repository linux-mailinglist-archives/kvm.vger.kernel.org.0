Return-Path: <kvm+bounces-67428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B51BED052C2
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 18:48:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 855C030E3CC8
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 17:32:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 296002E7F1E;
	Thu,  8 Jan 2026 17:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FeM/bJyz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE3229BD95;
	Thu,  8 Jan 2026 17:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767893559; cv=none; b=CeHVQOPzTFeI4dkE71JQQC7yHpZrNFgfdrzLOJWsWwPg1S6jGiaJE5tHfJYOOWvcPUctsY/hGbWaCQ5sPeblB/CfSI5GjXPkFBqLBQ30pcmp+iLQTp2jDyz6wH5Vz82LZDTdudOlYxcLY48IByMdeJDgW6F/obHWBrsD39O/dCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767893559; c=relaxed/simple;
	bh=il8COfiF1FhMwmH8tRnlXmaXeF2Tmchwrjdh9u49mVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ka4pQDbpAB3WOBiatEY6p2QyYopT3QCIenaAmUWuXTeH7zxIBtH5Vja9uJBkDQdzgWliCSyS8TGaJoYvdpu53OMqxk550APtv9qvplWQlid7OMBYYXzVNbFW2jf3uzKuGRaTIlcLrbpZ185wO5yD2/Yf7KBDb8yyeaGf25sJIGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FeM/bJyz; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1BBC19424;
	Thu,  8 Jan 2026 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767893559;
	bh=il8COfiF1FhMwmH8tRnlXmaXeF2Tmchwrjdh9u49mVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeM/bJyzo8gacN12ll2CLwrsW5eevGOScKJX8pwU3V5uhMNcvFg9CRnc2+Ko8iqlG
	 zcM+mzqXNh30oan+n9RwX9CORddctNXJU1YwGobFJsoE56cAfSrraEaW1hJvahxxGZ
	 gojPSMn3jxaVTAUoefgAiOU4deOMcMOb8G/8ag3FpPVmqZE9aSg64+34s0WhiCGFYr
	 ilaHNL+d+MEP9Fw3IcAC1haoh37cpbcn6g7A7FvLLsmgIQ/Wl7VFysK44Fd8KMxHa1
	 rSvz4mi/MjpoqURVNByZxU7sAXl06CMvS31KdmZtn+GmqOkdN3mJNFDnv0B3LcPn3y
	 /zFsgBlEe328A==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vdtsD-00000000W9F-09Vi;
	Thu, 08 Jan 2026 17:32:37 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Yao Yuan <yaoyuan@linux.alibaba.com>
Subject: [PATCH v4 3/9] KVM: arm64: Add a generic synchronous exception injection primitive
Date: Thu,  8 Jan 2026 17:32:27 +0000
Message-ID: <20260108173233.2911955-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260108173233.2911955-1-maz@kernel.org>
References: <20260108173233.2911955-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com, ben.horgan@arm.com, yaoyuan@linux.alibaba.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Maybe in a surprising way, we don't currently have a generic way
to inject a synchronous exception at the EL the vcpu is currently
running at.

Extract such primitive from the UNDEF injection code.

Reviewed-by: Ben Horgan <ben.horgan@arm.com>
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h |  1 +
 arch/arm64/kvm/inject_fault.c        | 10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index c9eab316398e2..df20d47f0d256 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -45,6 +45,7 @@ bool kvm_condition_valid32(const struct kvm_vcpu *vcpu);
 void kvm_skip_instr32(struct kvm_vcpu *vcpu);
 
 void kvm_inject_undefined(struct kvm_vcpu *vcpu);
+void kvm_inject_sync(struct kvm_vcpu *vcpu, u64 esr);
 int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u64 esr);
 int kvm_inject_sea(struct kvm_vcpu *vcpu, bool iabt, u64 addr);
 void kvm_inject_size_fault(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index dfcd66c655179..7102424a3fa5e 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -162,12 +162,16 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
 }
 
+void kvm_inject_sync(struct kvm_vcpu *vcpu, u64 esr)
+{
+	pend_sync_exception(vcpu);
+	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
+}
+
 static void inject_undef64(struct kvm_vcpu *vcpu)
 {
 	u64 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
-	pend_sync_exception(vcpu);
-
 	/*
 	 * Build an unknown exception, depending on the instruction
 	 * set.
@@ -175,7 +179,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_trap_il_is32bit(vcpu))
 		esr |= ESR_ELx_IL;
 
-	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
+	kvm_inject_sync(vcpu, esr);
 }
 
 #define DFSR_FSC_EXTABT_LPAE	0x10
-- 
2.47.3


