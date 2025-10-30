Return-Path: <kvm+bounces-61477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05930C2001D
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 13:28:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 09B733B3C1A
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 12:27:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D83A1325488;
	Thu, 30 Oct 2025 12:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SIXIKIPU"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E1D31A068;
	Thu, 30 Oct 2025 12:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761827233; cv=none; b=Kgxny2EAYMjerMsDQDOPQ335C9Tng7yWM1KQtheCouACH+j+C2agD3GfLGBafo1a+ipSJcVyWPzjPDDHrd+CVeMygUvT64g2wHR1NTiIAiWNR5sYXnBYrUOGxErNBlt3DidrG0H0sOmACJMWW6dWlMLZXJQOXRWMdwoxVclVG9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761827233; c=relaxed/simple;
	bh=quI+MXewqLox811sEJGEWZFPLVZMqZcSPVJ2hRZJyH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzgH4D6c9vNHrm63HTSTHOkY33CCyeZTkat0dnaD6CpWOnyhWTGam04kPkDtEBmTAz5ltdwKfuNZ9eabEgImZrodyeU6nd7CrcODF5dtvyp5y6r2TP4CickgnA+umNBAsCYh+m7JnGV87T/SZlQb3Wu1TVI9Z97neSKZFscrxpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SIXIKIPU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF14C113D0;
	Thu, 30 Oct 2025 12:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761827232;
	bh=quI+MXewqLox811sEJGEWZFPLVZMqZcSPVJ2hRZJyH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SIXIKIPU7h2OGS1tFMdWRUfqDtUh/Y4zJ7xdpUNlaRq2yS0lH0T+7NJmImbJzolV3
	 5BkMdzqRnx/bO33JR/RO7eTpi3UFJnSv0R4off5W4MGMpJukA4O0HTMMDd6Od2LqUV
	 1WXPui8nomFYPnVQGmpAA1PUGYZ++/aVxziER5qPtfrQZ6yZATMERAxoP54myJfih6
	 jD7bZOYkCe0hIeJJ03nZk6SSbpKPvoqAp44CDgIEfmpq6zgHURYgBsrV0FKzQ5kwG3
	 CDojk4gKvgyR+c1ZF8XR3QnIRfTSbkCKKfGqXXbyfKSHmMZ4SiT4MacQ6/Bm35hRa2
	 UjA8tRlMHQWnA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1vERkE-00000000yNP-39fN;
	Thu, 30 Oct 2025 12:27:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v2 3/3] KVM: arm64: Limit clearing of ID_{AA64PFR0,PFR1}_EL1.GIC to userspace irqchip
Date: Thu, 30 Oct 2025 12:27:07 +0000
Message-ID: <20251030122707.2033690-4-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251030122707.2033690-1-maz@kernel.org>
References: <20251030122707.2033690-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Now that the idreg's GIC field is in sync with the irqchip, limit
the runtime clearing of these fields to the pathological case where
we do not have an in-kernel GIC.

While we're at it, use the existing API instead of open-coded
accessors to access the ID regs.

Fixes: 5cb57a1aff755 ("KVM: arm64: Zero ID_AA64PFR0_EL1.GIC when no GICv3 is presented to the guest")
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ad82264c6cbe1..8ae2bca816148 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5609,11 +5609,13 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
 
 	guard(mutex)(&kvm->arch.config_lock);
 
-	if (!(static_branch_unlikely(&kvm_vgic_global_state.gicv3_cpuif) &&
-	      irqchip_in_kernel(kvm) &&
-	      kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)) {
-		kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] &= ~ID_AA64PFR0_EL1_GIC_MASK;
-		kvm->arch.id_regs[IDREG_IDX(SYS_ID_PFR1_EL1)] &= ~ID_PFR1_EL1_GIC_MASK;
+	if (!irqchip_in_kernel(kvm)) {
+		u64 val;
+
+		val = kvm_read_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1) & ~ID_AA64PFR0_EL1_GIC;
+		kvm_set_vm_id_reg(kvm, SYS_ID_AA64PFR0_EL1, val);
+		val = kvm_read_vm_id_reg(kvm, SYS_ID_PFR1_EL1) & ~ID_PFR1_EL1_GIC;
+		kvm_set_vm_id_reg(kvm, SYS_ID_PFR1_EL1, val);
 	}
 
 	if (vcpu_has_nv(vcpu)) {
-- 
2.47.3


