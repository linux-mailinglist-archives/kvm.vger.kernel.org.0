Return-Path: <kvm+bounces-24760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FAA495A1BE
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 17:46:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CE2C286E43
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 15:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D9171C1AA7;
	Wed, 21 Aug 2024 15:40:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 342881C1743;
	Wed, 21 Aug 2024 15:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724254832; cv=none; b=DSIWkMXZvXwuQHYCFhHu9o0f2S/DVstvCAIU4izIpqe8aOODA+b4kkUVyQhcVs4AqjGaDXUCuVtxP1K6ipuBeRzglgyIPvSvldMWh2yP0Ip7d8eqN2K02Zl2mz6U+nVtZk1Z4HFFOTlxr2MhscW9wTCsGliyu3abDBRvMx6Rr54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724254832; c=relaxed/simple;
	bh=mCSJQKRmMj4eH3lcee/RC+ZfT7vVkL1yagLwnVsCNiw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jfOzabRgobC+j4cEMJ6K/NLvMfa7/oERn7QGwUXWWc9Bld+acVkEnjEVxlaTZDwIlTB3Jv1us46z12DQwDf7VCcgXGFVIldqDDzWxiGgK15D+PK582jeDmZNc/9t8QB9MSBAKclcuz5I2lWkQzrfe/+oJqE+AQwvt7d02aWjlhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC0F6152B;
	Wed, 21 Aug 2024 08:40:56 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.37.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F36D33F73B;
	Wed, 21 Aug 2024 08:40:27 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>
Subject: [PATCH v4 23/43] KVM: arm64: Validate register access for a Realm VM
Date: Wed, 21 Aug 2024 16:38:24 +0100
Message-Id: <20240821153844.60084-24-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240821153844.60084-1-steven.price@arm.com>
References: <20240821153844.60084-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RMM only allows setting the lower GPRS (x0-x7) and PC for a realm
guest. Check this in kvm_arm_set_reg() so that the VMM can receive a
suitable error return if other registers are accessed.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/guest.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 11098eb7eb44..8066d3f05403 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -783,12 +783,38 @@ int kvm_arm_get_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	return kvm_arm_sys_reg_get_reg(vcpu, reg);
 }
 
+/*
+ * The RMI ABI only enables setting the lower GPRs (x0-x7) and PC.
+ * All other registers are reset to architectural or otherwise defined reset
+ * values by the RMM, except for a few configuration fields that correspond to
+ * Realm parameters.
+ */
+static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
+				   const struct kvm_one_reg *reg)
+{
+	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE) {
+		u64 off = core_reg_offset_from_id(reg->id);
+
+		switch (off) {
+		case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
+		     KVM_REG_ARM_CORE_REG(regs.regs[7]):
+		case KVM_REG_ARM_CORE_REG(regs.pc):
+			return true;
+		}
+	}
+
+	return false;
+}
+
 int kvm_arm_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 {
 	/* We currently use nothing arch-specific in upper 32 bits */
 	if ((reg->id & ~KVM_REG_SIZE_MASK) >> 32 != KVM_REG_ARM64 >> 32)
 		return -EINVAL;
 
+	if (kvm_is_realm(vcpu->kvm) && !validate_realm_set_reg(vcpu, reg))
+		return -EINVAL;
+
 	switch (reg->id & KVM_REG_ARM_COPROC_MASK) {
 	case KVM_REG_ARM_CORE:	return set_core_reg(vcpu, reg);
 	case KVM_REG_ARM_FW:
-- 
2.34.1


