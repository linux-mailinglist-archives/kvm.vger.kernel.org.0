Return-Path: <kvm+bounces-19195-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E5C39022E3
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 15:45:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A2DAD286E29
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2024 13:44:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5792212F5B6;
	Mon, 10 Jun 2024 13:42:49 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65C231422D9;
	Mon, 10 Jun 2024 13:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718026968; cv=none; b=uT0I8f6ZpDlGFNwrzqqSr2WWuC7Y5npztB7VEnB2azaIgaYe4KQtQC1L2sXVvYpWsdZwSA079HArUWS0cHKr855mtMOvjIecP964AhbuIyVUKMmIqpOQ7BRmnJIPvW3yLnyY1SBrKycu1b3YMVlEUDm6my3qOvnEaRreGowjydA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718026968; c=relaxed/simple;
	bh=2eBjFNweEqM7Lx+IYgi2UK6N3WN76ioYfOXGjdkOjbw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uU0z1zRK/1x8GAsxckQBRU++j5qCv84dWk8QhioDlrZIiWniXzknj+8panO1QggVssSJqghsxVRTzn8tfVmqaUlknITz7AJ+Vb5ZWO7N8sQHhPLqOF0Qrwz4dTZtxCsgUqxLfjgDFaoKfvcrUYc4Z5pMHU8RrwJA7bqMMaG8fHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 89D981688;
	Mon, 10 Jun 2024 06:43:11 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 332E53F58B;
	Mon, 10 Jun 2024 06:42:44 -0700 (PDT)
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v3 08/43] arm64: RME: Define the user ABI
Date: Mon, 10 Jun 2024 14:41:27 +0100
Message-Id: <20240610134202.54893-9-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240610134202.54893-1-steven.price@arm.com>
References: <20240610134202.54893-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is one (multiplexed) CAP which can be used to create, populate and
then activate the realm.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 Documentation/virt/kvm/api.rst    |  1 +
 arch/arm64/include/uapi/asm/kvm.h | 49 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          | 11 +++++++
 3 files changed, 61 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a71d91978d9e..dd53beb8fe14 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5064,6 +5064,7 @@ Recognised values for feature:
 
   =====      ===========================================
   arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
+  arm64      KVM_ARM_VCPU_REC (requires KVM_CAP_ARM_RME)
   =====      ===========================================
 
 Finalizes the configuration of the specified vcpu feature.
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 964df31da975..080331008b79 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -108,6 +108,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
 #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
+#define KVM_ARM_VCPU_REC		8 /* VCPU REC state as part of Realm */
 
 struct kvm_vcpu_init {
 	__u32 target;
@@ -418,6 +419,54 @@ enum {
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
+/* KVM_CAP_ARM_RME on VM fd */
+#define KVM_CAP_ARM_RME_CONFIG_REALM		0
+#define KVM_CAP_ARM_RME_CREATE_RD		1
+#define KVM_CAP_ARM_RME_INIT_IPA_REALM		2
+#define KVM_CAP_ARM_RME_POPULATE_REALM		3
+#define KVM_CAP_ARM_RME_ACTIVATE_REALM		4
+
+#define KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256		0
+#define KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA512		1
+
+#define KVM_CAP_ARM_RME_RPV_SIZE 64
+
+/* List of configuration items accepted for KVM_CAP_ARM_RME_CONFIG_REALM */
+#define KVM_CAP_ARM_RME_CFG_RPV			0
+#define KVM_CAP_ARM_RME_CFG_HASH_ALGO		1
+
+struct kvm_cap_arm_rme_config_item {
+	__u32 cfg;
+	union {
+		/* cfg == KVM_CAP_ARM_RME_CFG_RPV */
+		struct {
+			__u8	rpv[KVM_CAP_ARM_RME_RPV_SIZE];
+		};
+
+		/* cfg == KVM_CAP_ARM_RME_CFG_HASH_ALGO */
+		struct {
+			__u32	hash_algo;
+		};
+
+		/* Fix the size of the union */
+		__u8	reserved[256];
+	};
+};
+
+#define KVM_ARM_RME_POPULATE_FLAGS_MEASURE	BIT(0)
+struct kvm_cap_arm_rme_populate_realm_args {
+	__u64 populate_ipa_base;
+	__u64 populate_ipa_size;
+	__u32 flags;
+	__u32 reserved[3];
+};
+
+struct kvm_cap_arm_rme_init_ipa_args {
+	__u64 init_ipa_base;
+	__u64 init_ipa_size;
+	__u32 reserved[4];
+};
+
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
 #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d03842abae57..44c68e36f230 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -918,6 +918,8 @@ struct kvm_enable_cap {
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
 
+#define KVM_CAP_ARM_RME 300 /* FIXME: Large number to prevent conflicts */
+
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
 	__u32 pin;
@@ -1548,4 +1550,13 @@ struct kvm_create_guest_memfd {
 	__u64 reserved[6];
 };
 
+/* Available with KVM_CAP_ARM_RME, only for VMs with KVM_VM_TYPE_ARM_REALM  */
+struct kvm_arm_rmm_psci_complete {
+	__u64 target_mpidr;
+	__u32 psci_status;
+	__u32 padding[3];
+};
+
+#define KVM_ARM_VCPU_RMM_PSCI_COMPLETE	_IOW(KVMIO, 0xd2, struct kvm_arm_rmm_psci_complete)
+
 #endif /* __LINUX_KVM_H */
-- 
2.34.1


