Return-Path: <kvm+bounces-24778-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A5D895A1E5
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 17:51:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55FF228C5E4
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 15:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA2831B3B19;
	Wed, 21 Aug 2024 15:41:39 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C95F71B3B0D;
	Wed, 21 Aug 2024 15:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724254899; cv=none; b=GJGl63NE9yLgzzIf/1O83UIOwkcrxgHPi3UDZBO4Rtu9hGB0UfXsLofvMScJgKBViekdbWKofJn04waecTRFwLvQQgv7spiq0NPWQdwEt83yq0SsTxbY7GPiR5oL1Is3lTsEcl718cWTglj9+FiFzpye7ZXkPXjm9l6TwptYH3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724254899; c=relaxed/simple;
	bh=hp23XkhVnaPW5SWKLNZ9FsLfYgv5XrdnVKzJFL1GJrY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cRpVT0VSYNZPvpCcnbwsgZ+5CkiaIK0k1PYxM1+zzVYKLco9VvG2Ph/YtI2lDDcKHu6gJHk95iUpTRjoVBPhPAEkkbxie/nrRzW2fD/SiVxdAf/G07kKUauNvE4p6tQoREi2G0z8w9k8x1s+4L2XyRSn7oMXBHjZhJByCHDirFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 71B17DA7;
	Wed, 21 Aug 2024 08:42:03 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.37.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DDF213F73B;
	Wed, 21 Aug 2024 08:41:33 -0700 (PDT)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
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
	Alper Gun <alpergun@google.com>,
	Steven Price <steven.price@arm.com>
Subject: [PATCH v4 41/43] arm64: RME: Provide accurate register list
Date: Wed, 21 Aug 2024 16:38:42 +0100
Message-Id: <20240821153844.60084-42-steven.price@arm.com>
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

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Userspace can set a few registers with KVM_SET_ONE_REG (9 GP registers
at runtime, and 3 system registers during initialization). Update the
register list returned by KVM_GET_REG_LIST.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/guest.c      | 40 ++++++++++++++++++-------
 arch/arm64/kvm/hypercalls.c |  4 +--
 arch/arm64/kvm/sys_regs.c   | 58 ++++++++++++++++++++++++++++---------
 3 files changed, 75 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index b12b5e4ddd8c..1ac0a552550c 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -73,6 +73,17 @@ static u64 core_reg_offset_from_id(u64 id)
 	return id & ~(KVM_REG_ARCH_MASK | KVM_REG_SIZE_MASK | KVM_REG_ARM_CORE);
 }
 
+static bool kvm_realm_validate_core_reg(u64 off)
+{
+	switch (off) {
+	case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
+	     KVM_REG_ARM_CORE_REG(regs.regs[7]):
+	case KVM_REG_ARM_CORE_REG(regs.pc):
+		return true;
+	}
+	return false;
+}
+
 static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
 {
 	int size;
@@ -115,6 +126,9 @@ static int core_reg_size_from_offset(const struct kvm_vcpu *vcpu, u64 off)
 	if (vcpu_has_sve(vcpu) && core_reg_offset_is_vreg(off))
 		return -EINVAL;
 
+	if (kvm_is_realm(vcpu->kvm) && !kvm_realm_validate_core_reg(off))
+		return -EPERM;
+
 	return size;
 }
 
@@ -600,8 +614,6 @@ static const u64 timer_reg_list[] = {
 	KVM_REG_ARM_PTIMER_CVAL,
 };
 
-#define NUM_TIMER_REGS ARRAY_SIZE(timer_reg_list)
-
 static bool is_timer_reg(u64 index)
 {
 	switch (index) {
@@ -616,9 +628,14 @@ static bool is_timer_reg(u64 index)
 	return false;
 }
 
+static unsigned long num_timer_regs(struct kvm_vcpu *vcpu)
+{
+	return kvm_is_realm(vcpu->kvm) ? 0 : ARRAY_SIZE(timer_reg_list);
+}
+
 static int copy_timer_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-	for (int i = 0; i < NUM_TIMER_REGS; i++) {
+	for (int i = 0; i < num_timer_regs(vcpu); i++) {
 		if (put_user(timer_reg_list[i], uindices))
 			return -EFAULT;
 		uindices++;
@@ -656,6 +673,9 @@ static unsigned long num_sve_regs(const struct kvm_vcpu *vcpu)
 	if (!vcpu_has_sve(vcpu) || !kvm_arm_vcpu_sve_finalized(vcpu))
 		return 0;
 
+	if (kvm_is_realm(vcpu->kvm))
+		return 1; /* KVM_REG_ARM64_SVE_VLS */
+
 	return slices * (SVE_NUM_PREGS + SVE_NUM_ZREGS + 1 /* FFR */)
 		+ 1; /* KVM_REG_ARM64_SVE_VLS */
 }
@@ -683,6 +703,9 @@ static int copy_sve_reg_indices(const struct kvm_vcpu *vcpu,
 		return -EFAULT;
 	++num_regs;
 
+	if (kvm_is_realm(vcpu->kvm))
+		return num_regs;
+
 	for (i = 0; i < slices; i++) {
 		for (n = 0; n < SVE_NUM_ZREGS; n++) {
 			reg = KVM_REG_ARM64_SVE_ZREG(n, i);
@@ -721,7 +744,7 @@ unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu)
 	res += num_sve_regs(vcpu);
 	res += kvm_arm_num_sys_reg_descs(vcpu);
 	res += kvm_arm_get_fw_num_regs(vcpu);
-	res += NUM_TIMER_REGS;
+	res += num_timer_regs(vcpu);
 
 	return res;
 }
@@ -755,7 +778,7 @@ int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 	ret = copy_timer_indices(vcpu, uindices);
 	if (ret < 0)
 		return ret;
-	uindices += NUM_TIMER_REGS;
+	uindices += num_timer_regs(vcpu);
 
 	return kvm_arm_copy_sys_reg_indices(vcpu, uindices);
 }
@@ -795,12 +818,7 @@ static bool validate_realm_set_reg(struct kvm_vcpu *vcpu,
 	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_CORE) {
 		u64 off = core_reg_offset_from_id(reg->id);
 
-		switch (off) {
-		case KVM_REG_ARM_CORE_REG(regs.regs[0]) ...
-		     KVM_REG_ARM_CORE_REG(regs.regs[7]):
-		case KVM_REG_ARM_CORE_REG(regs.pc):
-			return true;
-		}
+		return kvm_realm_validate_core_reg(off);
 	} else {
 		switch (reg->id) {
 		case KVM_REG_ARM_PMCR_EL0:
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 5763d979d8ca..28b4166cf234 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -407,14 +407,14 @@ void kvm_arm_teardown_hypercalls(struct kvm *kvm)
 
 int kvm_arm_get_fw_num_regs(struct kvm_vcpu *vcpu)
 {
-	return ARRAY_SIZE(kvm_arm_fw_reg_ids);
+	return kvm_is_realm(vcpu->kvm) ? 0 : ARRAY_SIZE(kvm_arm_fw_reg_ids);
 }
 
 int kvm_arm_copy_fw_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(kvm_arm_fw_reg_ids); i++) {
+	for (i = 0; i < kvm_arm_get_fw_num_regs(vcpu); i++) {
 		if (put_user(kvm_arm_fw_reg_ids[i], uindices++))
 			return -EFAULT;
 	}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f92b78039dce..3510c7a684f1 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4357,18 +4357,18 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
 				    sys_reg_descs, ARRAY_SIZE(sys_reg_descs));
 }
 
-static unsigned int num_demux_regs(void)
+static unsigned int num_demux_regs(struct kvm_vcpu *vcpu)
 {
-	return CSSELR_MAX;
+	return kvm_is_realm(vcpu->kvm) ? 0 : CSSELR_MAX;
 }
 
-static int write_demux_regids(u64 __user *uindices)
+static int write_demux_regids(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
 	u64 val = KVM_REG_ARM64 | KVM_REG_SIZE_U32 | KVM_REG_ARM_DEMUX;
 	unsigned int i;
 
 	val |= KVM_REG_ARM_DEMUX_ID_CCSIDR;
-	for (i = 0; i < CSSELR_MAX; i++) {
+	for (i = 0; i < num_demux_regs(vcpu); i++) {
 		if (put_user(val | i, uindices))
 			return -EFAULT;
 		uindices++;
@@ -4376,6 +4376,23 @@ static int write_demux_regids(u64 __user *uindices)
 	return 0;
 }
 
+static unsigned int num_invariant_regs(struct kvm_vcpu *vcpu)
+{
+	return kvm_is_realm(vcpu->kvm) ? 0 : ARRAY_SIZE(invariant_sys_regs);
+}
+
+static int write_invariant_regids(struct kvm_vcpu *vcpu, u64 __user *uindices)
+{
+	unsigned int i;
+
+	for (i = 0; i < num_invariant_regs(vcpu); i++) {
+		if (put_user(sys_reg_to_index(&invariant_sys_regs[i]), uindices))
+			return -EFAULT;
+		uindices++;
+	}
+	return 0;
+}
+
 static u64 sys_reg_to_index(const struct sys_reg_desc *reg)
 {
 	return (KVM_REG_ARM64 | KVM_REG_SIZE_U64 |
@@ -4399,11 +4416,27 @@ static bool copy_reg_to_user(const struct sys_reg_desc *reg, u64 __user **uind)
 	return true;
 }
 
+static bool kvm_realm_sys_reg_hidden_user(const struct kvm_vcpu *vcpu, u64 reg)
+{
+	if (!kvm_is_realm(vcpu->kvm))
+		return false;
+
+	switch (reg) {
+	case SYS_ID_AA64DFR0_EL1:
+	case SYS_PMCR_EL0:
+		return false;
+	}
+	return true;
+}
+
 static int walk_one_sys_reg(const struct kvm_vcpu *vcpu,
 			    const struct sys_reg_desc *rd,
 			    u64 __user **uind,
 			    unsigned int *total)
 {
+	if (kvm_realm_sys_reg_hidden_user(vcpu, reg_to_encoding(rd)))
+		return 0;
+
 	/*
 	 * Ignore registers we trap but don't save,
 	 * and for which no custom user accessor is provided.
@@ -4441,29 +4474,26 @@ static int walk_sys_regs(struct kvm_vcpu *vcpu, u64 __user *uind)
 
 unsigned long kvm_arm_num_sys_reg_descs(struct kvm_vcpu *vcpu)
 {
-	return ARRAY_SIZE(invariant_sys_regs)
-		+ num_demux_regs()
+	return num_invariant_regs(vcpu)
+		+ num_demux_regs(vcpu)
 		+ walk_sys_regs(vcpu, (u64 __user *)NULL);
 }
 
 int kvm_arm_copy_sys_reg_indices(struct kvm_vcpu *vcpu, u64 __user *uindices)
 {
-	unsigned int i;
 	int err;
 
-	/* Then give them all the invariant registers' indices. */
-	for (i = 0; i < ARRAY_SIZE(invariant_sys_regs); i++) {
-		if (put_user(sys_reg_to_index(&invariant_sys_regs[i]), uindices))
-			return -EFAULT;
-		uindices++;
-	}
+	err = write_invariant_regids(vcpu, uindices);
+	if (err)
+		return err;
+	uindices += num_invariant_regs(vcpu);
 
 	err = walk_sys_regs(vcpu, uindices);
 	if (err < 0)
 		return err;
 	uindices += err;
 
-	return write_demux_regids(uindices);
+	return write_demux_regids(vcpu, uindices);
 }
 
 #define KVM_ARM_FEATURE_ID_RANGE_INDEX(r)			\
-- 
2.34.1


