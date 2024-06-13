Return-Path: <kvm+bounces-19620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 641E2907D54
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 22:19:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82D161C255AC
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 20:18:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B84213B28D;
	Thu, 13 Jun 2024 20:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="weacD/Kg"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0583112EBF3
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 20:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718309918; cv=none; b=nxXyFvoganoUrHrO86uCdy69E9ZZKHojNT8mw4Xs3k7lbZ/POCy8x75blq98rQ/RZufhS598WuGy11fH/77vj7UMCNk2/+gjG9vYqGzfQDOvCCkNuMdYaxTmS/OqY/4aAbsy7SiQK/QMXwa5Zdlb4RGGBwAZ4CvtBSfWA9idfk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718309918; c=relaxed/simple;
	bh=gX4aZmWAZW3HJQOKcBfNqsdwGbwcOZkvOnnGRnA8O0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n10fW8+jhMyw8fNUJaIcMQ/908vGU7oGXetfcCr1cQc+82XAo7aiBeydXItzI5hRd5vI6i0iWgx/Ny3UTwDXX8WHKTxcdEQlx/vdrSiTcP+CDX1ecA+bUXbVgJuPi8xSIriC4k5dJkT3Mur3guT5wdKnaN9LumeMYrbd9VGRXeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=weacD/Kg; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1718309915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MpECG6XJpqVZFNL7F+Rlj6vrbksIYtP3wZCZoUtfX3Q=;
	b=weacD/KgxZUUwEOSw5siOOMuuO1mbt4Q6TQFan881BjKr095aP01cKR69OSzda/XmozwWD
	fberdjPPUSbAIK+deKuR9ymDKvecaSLTptWUIqvp8zuITCBAbAb5mJgBoi9MMZhg+PVnsS
	rGUrQwS0itokXfntZO+irD+ZkxERQ2c=
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: yuzenghui@huawei.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: tabba@google.com
X-Envelope-To: oliver.upton@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	kvm@vger.kernel.org,
	Fuad Tabba <tabba@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 03/15] KVM: arm64: nv: Handle CPACR_EL1 traps
Date: Thu, 13 Jun 2024 20:17:44 +0000
Message-ID: <20240613201756.3258227-4-oliver.upton@linux.dev>
In-Reply-To: <20240613201756.3258227-1-oliver.upton@linux.dev>
References: <20240613201756.3258227-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Marc Zyngier <maz@kernel.org>

Handle CPACR_EL1 accesses when running a VHE guest. In order to
limit the cost of the emulation, implement it ass a shallow exit.

In the other cases:

- this is a nVHE L1 which will write to memory, and we don't trap

- this is a L2 guest:

  * the L1 has CPTR_EL2.TCPAC==0, and the L2 has direct register
   access

  * the L1 has CPTR_EL2.TCPAC==1, and the L2 will trap, but the
    handling is defered to the general handling for forwarding

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/vhe/switch.c | 32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index d7af5f46f22a..fed36457fef9 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -262,10 +262,40 @@ static bool kvm_hyp_handle_eret(struct kvm_vcpu *vcpu, u64 *exit_code)
 	return true;
 }
 
+static bool kvm_hyp_handle_cpacr_el1(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	u64 esr = kvm_vcpu_get_esr(vcpu);
+	int rt;
+
+	if (!is_hyp_ctxt(vcpu) || esr_sys64_to_sysreg(esr) != SYS_CPACR_EL1)
+		return false;
+
+	rt = kvm_vcpu_sys_get_rt(vcpu);
+
+	if ((esr & ESR_ELx_SYS64_ISS_DIR_MASK) == ESR_ELx_SYS64_ISS_DIR_READ) {
+		vcpu_set_reg(vcpu, rt, __vcpu_sys_reg(vcpu, CPTR_EL2));
+	} else {
+		vcpu_write_sys_reg(vcpu, vcpu_get_reg(vcpu, rt), CPTR_EL2);
+		__activate_cptr_traps(vcpu);
+	}
+
+	__kvm_skip_instr(vcpu);
+
+	return true;
+}
+
+static bool kvm_hyp_handle_sysreg_vhe(struct kvm_vcpu *vcpu, u64 *exit_code)
+{
+	if (kvm_hyp_handle_cpacr_el1(vcpu, exit_code))
+		return true;
+
+	return kvm_hyp_handle_sysreg(vcpu, exit_code);
+}
+
 static const exit_handler_fn hyp_exit_handlers[] = {
 	[0 ... ESR_ELx_EC_MAX]		= NULL,
 	[ESR_ELx_EC_CP15_32]		= kvm_hyp_handle_cp15_32,
-	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg,
+	[ESR_ELx_EC_SYS64]		= kvm_hyp_handle_sysreg_vhe,
 	[ESR_ELx_EC_SVE]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_FP_ASIMD]		= kvm_hyp_handle_fpsimd,
 	[ESR_ELx_EC_IABT_LOW]		= kvm_hyp_handle_iabt_low,
-- 
2.45.2.627.g7a2c4fd464-goog


