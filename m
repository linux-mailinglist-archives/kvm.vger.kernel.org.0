Return-Path: <kvm+bounces-37505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3113A2AD06
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 16:51:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 628A3169E11
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 15:50:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72ECF1F4182;
	Thu,  6 Feb 2025 15:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kwBhFRIb"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C932594B5;
	Thu,  6 Feb 2025 15:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738856984; cv=none; b=ef6DbP34nfG9HXYWtJtEcQqI9r/2xF9aQgr6llByHNFxKmLu6nQAivUslZ7NJsVE1pPENkvLVGooT6YT9nSi2y85MAUinH6DacEUDhIaB//HbVM4StrTF7qxfqlLrUowT/UtleTMot4zSu46jGK1J/PcYCtLUBn6AnWIfXauTpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738856984; c=relaxed/simple;
	bh=ScLfH9JCdakxFSIYbsxrMFuSUWUanHf/RQHVMVBJ67Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Le4h1fvuYKyG9x4J3nRN3a9t9Mr4WR1g+RSBXyVJ39YqBO25zag5T8vn9qMIPoI/toILmLNJbmDrIu25yXk6bMsiEhBM1lVhZE49snFu6qgoocz5gEB3xGA69bjqF3K6HRyAUEmP3piiEymCtxOoFzwHLfIQre6wxHgfZl4YFNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kwBhFRIb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF2BC4CEE8;
	Thu,  6 Feb 2025 15:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738856984;
	bh=ScLfH9JCdakxFSIYbsxrMFuSUWUanHf/RQHVMVBJ67Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwBhFRIbmIxfthT2PBmz2o/j6qEKW53hZti1GARgmHCKm1Jba5xrYY/Joqh9Dewcf
	 EJUDdewinf6E8rMrWwJckFBZt6NP5nUhGO2kiaSNVtsIo1IaFzoLKSU8e4FUdb6PxF
	 ftlIA3yYZOQTaKQdavmub2XQPLfHGuPg6QertHH4sMVp8rNYurPCu/zVgCixeLxvoi
	 IdYilIXkTsTCLHn/8aIGxf3lOz9W1GCYtP/wZVcEQtnRapqVhPpOBbQB2kkYz7zDEE
	 6YP35fPK5TfPWJPRYk2nC4G3fZukqi/PWdJcGpkt26oDbo+QjhjRhxaDQTp+BHq/5o
	 mZ5B5QiGRPWwA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tg48M-001BOX-HB;
	Thu, 06 Feb 2025 15:49:42 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 14/16] KVM: arm64: nv: Fold GICv3 host trapping requirements into guest setup
Date: Thu,  6 Feb 2025 15:49:23 +0000
Message-Id: <20250206154925.1109065-15-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250206154925.1109065-1-maz@kernel.org>
References: <20250206154925.1109065-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, andre.przywara@arm.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

Popular HW that is able to use NV also has a broken vgic implementation
that requires trapping.

On such HW, propagate the host trap bits into the guest's shadow
ICH_HCR_EL2 register, making sure we don't allow an L2 guest to bring
the system down.

This involves a bit of tweaking so that the emulation code correctly
poicks up the shadow state as needed, and to only partially sync
ICH_HCR_EL2 back with the guest state to capture EOIcount.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/vgic/vgic-v3-nested.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-v3-nested.c b/arch/arm64/kvm/vgic/vgic-v3-nested.c
index 643bd8a8e0669..5350a4650b7a5 100644
--- a/arch/arm64/kvm/vgic/vgic-v3-nested.c
+++ b/arch/arm64/kvm/vgic/vgic-v3-nested.c
@@ -296,9 +296,19 @@ static void vgic_v3_create_shadow_state(struct kvm_vcpu *vcpu,
 					struct vgic_v3_cpu_if *s_cpu_if)
 {
 	struct vgic_v3_cpu_if *host_if = &vcpu->arch.vgic_cpu.vgic_v3;
+	u64 val = 0;
 	int i;
 
-	s_cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
+	/*
+	 * If we're on a system with a broken vgic that requires
+	 * trapping, propagate the trapping requirements.
+	 *
+	 * Ah, the smell of rotten fruits...
+	 */
+	if (static_branch_unlikely(&vgic_v3_cpuif_trap))
+		val = host_if->vgic_hcr & (ICH_HCR_EL2_TALL0 | ICH_HCR_EL2_TALL1 |
+					   ICH_HCR_EL2_TC | ICH_HCR_EL2_TDIR);
+	s_cpu_if->vgic_hcr = __vcpu_sys_reg(vcpu, ICH_HCR_EL2) | val;
 	s_cpu_if->vgic_vmcr = __vcpu_sys_reg(vcpu, ICH_VMCR_EL2);
 	s_cpu_if->vgic_sre = host_if->vgic_sre;
 
@@ -335,6 +345,7 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 {
 	struct shadow_if *shadow_if = get_shadow_if();
 	struct vgic_v3_cpu_if *s_cpu_if = &shadow_if->cpuif;
+	u64 val;
 	int i;
 
 	__vgic_v3_save_vmcr_aprs(s_cpu_if);
@@ -345,7 +356,10 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 	 * Translate the shadow state HW fields back to the virtual ones
 	 * before copying the shadow struct back to the nested one.
 	 */
-	__vcpu_sys_reg(vcpu, ICH_HCR_EL2) = s_cpu_if->vgic_hcr;
+	val = __vcpu_sys_reg(vcpu, ICH_HCR_EL2);
+	val &= ~ICH_HCR_EL2_EOIcount_MASK;
+	val |= (s_cpu_if->vgic_hcr & ICH_HCR_EL2_EOIcount_MASK);
+	__vcpu_sys_reg(vcpu, ICH_HCR_EL2) = val;
 	__vcpu_sys_reg(vcpu, ICH_VMCR_EL2) = s_cpu_if->vgic_vmcr;
 
 	for (i = 0; i < 4; i++) {
@@ -354,7 +368,7 @@ void vgic_v3_put_nested(struct kvm_vcpu *vcpu)
 	}
 
 	for_each_set_bit(i, &shadow_if->lr_map, kvm_vgic_global_state.nr_lr) {
-		u64 val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
+		val = __vcpu_sys_reg(vcpu, ICH_LRN(i));
 
 		val &= ~ICH_LR_STATE;
 		val |= s_cpu_if->vgic_lr[i] & ICH_LR_STATE;
-- 
2.39.2


