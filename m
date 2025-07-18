Return-Path: <kvm+bounces-52885-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BDF2B0A1A9
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 13:12:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 778C94E5D59
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 11:12:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64B5D2C15B5;
	Fri, 18 Jul 2025 11:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QmUVK2AB"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A6B2C0303;
	Fri, 18 Jul 2025 11:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752837137; cv=none; b=Mkq+nY3eF2A0l76DsVvgQpbpQex58UfMXfFHnp/fz8LZBfUZajpoKyH/vF/tGDx+hnA98c99ZpNzaLEUbZq6eJHaVTIMGKuesyJ3vqRx86DwWV41R6wuqNQuoPxPH8AuMiBgAGhPq1QWx+Gvf4rTZMq+X2pIv6maUJPdTkg09N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752837137; c=relaxed/simple;
	bh=n/axFc2QmqJ/f05WQ9SbxLtmn/ojktUTYjQymh5s7Sw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kkm963pE0TOzuEmo1Mk5YSahWT1kzOXeeQc7Go1JFzZirf2UaoqF8JRULn1uC/Nm/4PY0hoSWhV8MVIZ/Yml5cb8HxhzKoFo4ohGJr1VItbwg572BMBuDNf6PISRAgKg5t+C8jiBNrTsZQWaLNlm73RKpOzxlw3gm6IxDJLE4LQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QmUVK2AB; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D04AC4CEEB;
	Fri, 18 Jul 2025 11:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752837137;
	bh=n/axFc2QmqJ/f05WQ9SbxLtmn/ojktUTYjQymh5s7Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QmUVK2AB9ZreR0lKtb17Aha4agZQaoG6oIlFpMJXD/unXo7lpODQ9GiaPlNqV9FHr
	 KoCeByobyBa5r1P/9fuZGzhPKTg6/2iwlACgZwH/hFWoiTlFH3+V5nLORInM33ouVP
	 k0An57Uj0wquilG+dUUlodx+SP8wqn76IvgF+Pp/+hD7hYbWwNSopybDbyS71baWjD
	 RvAjXm3zpsWI222HVPxsrgglURgKgYcYCO/NPuTXIqk8CAM9WeuT3AsUhcLUP23jNY
	 D0l+oSbCJUUJ3TbgYJKSISYa0PFH9HvDwA6iyEi7Kr9y6Y7fq84eWZ3bd49Ek3yeBC
	 fB42tUvtxv48g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1ucj0h-00Gt2B-40;
	Fri, 18 Jul 2025 12:12:15 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvm@vger.kernel.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eric.auger@redhat.com>
Subject: [PATCH 3/4] KVM: arm64: Enforce the sorting of the GICv3 system register table
Date: Fri, 18 Jul 2025 12:11:53 +0100
Message-Id: <20250718111154.104029-4-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250718111154.104029-1-maz@kernel.org>
References: <20250718111154.104029-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com, eric.auger@redhat.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In order to avoid further embarassing bugs, enforce that the GICv3
sysreg table is actually sorted, just like all the other tables.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/sys_regs.c        | 6 +++++-
 arch/arm64/kvm/vgic-sys-reg-v3.c | 6 ++++++
 arch/arm64/kvm/vgic/vgic.h       | 1 +
 3 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f8b10966d0c3e..9d8c47e706b96 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5329,8 +5329,9 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
 
 int __init kvm_sys_reg_table_init(void)
 {
+	const struct sys_reg_desc *gicv3_regs;
 	bool valid = true;
-	unsigned int i;
+	unsigned int i, sz;
 	int ret = 0;
 
 	/* Make sure tables are unique and in order. */
@@ -5341,6 +5342,9 @@ int __init kvm_sys_reg_table_init(void)
 	valid &= check_sysreg_table(cp15_64_regs, ARRAY_SIZE(cp15_64_regs), false);
 	valid &= check_sysreg_table(sys_insn_descs, ARRAY_SIZE(sys_insn_descs), false);
 
+	gicv3_regs = vgic_v3_get_sysreg_table(&sz);
+	valid &= check_sysreg_table(gicv3_regs, sz, false);
+
 	if (!valid)
 		return -EINVAL;
 
diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 1850f1727eb93..bdc2d57370b27 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -443,6 +443,12 @@ static const struct sys_reg_desc gic_v3_icc_reg_descs[] = {
 	EL2_REG(ICH_LR15_EL2, ich_reg),
 };
 
+const struct sys_reg_desc *vgic_v3_get_sysreg_table(unsigned int *sz)
+{
+	*sz = ARRAY_SIZE(gic_v3_icc_reg_descs);
+	return gic_v3_icc_reg_descs;
+}
+
 static u64 attr_to_id(u64 attr)
 {
 	return ARM64_SYS_REG(FIELD_GET(KVM_REG_ARM_VGIC_SYSREG_OP0_MASK, attr),
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 5fe554d40c8ef..6ea817d8a804a 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -315,6 +315,7 @@ int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 int vgic_v3_cpu_sysregs_uaccess(struct kvm_vcpu *vcpu,
 				struct kvm_device_attr *attr, bool is_write);
 int vgic_v3_has_cpu_sysregs_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr);
+const struct sys_reg_desc *vgic_v3_get_sysreg_table(unsigned int *sz);
 int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 				    u32 intid, u32 *val);
 int kvm_register_vgic_device(unsigned long type);
-- 
2.39.2


