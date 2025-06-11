Return-Path: <kvm+bounces-48996-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18C57AD52C0
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 12:54:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5A9A63AB7CA
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 10:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90BEF28851A;
	Wed, 11 Jun 2025 10:49:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 307E5286413;
	Wed, 11 Jun 2025 10:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749638968; cv=none; b=Y9DepGxwJlzM87nbljGEJpwkfvbuIH4tm1W5+yAaBD3lTUwpnit6dr0Np8j3WCyB5tmW1DbPHGTqzxBzmKVdzkHo/NaOSfzwPLhxK3b6INtWbwtpLNIjVGmBjKINylyhwsXz7FdqlgAnrDvRizj/V0XWGP8brqKMnpsi8MDuHCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749638968; c=relaxed/simple;
	bh=d3REiul/B42sWUzRYrzcMY6pIhWyL5vq024XPwNsi88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1cUXrSx5ZzL0GpS+jxhf4KNTsg0lh67WWenPMavt+XY8ZOtCDixGHq6hKjnnaQTZSNiQL/D1oPP7Lxco6xNaLkUyF8W+0PrEL0SnNt7Gwow1eItPg5ciL/eLzHbD4n1ymnfK527RZHmUFJnIijfXUlyE7cI/Wxt64UHgCG2kkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F04561655;
	Wed, 11 Jun 2025 03:49:05 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.67.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 627BF3F673;
	Wed, 11 Jun 2025 03:49:22 -0700 (PDT)
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
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>
Subject: [PATCH v9 06/43] arm64: RME: Define the user ABI
Date: Wed, 11 Jun 2025 11:48:03 +0100
Message-ID: <20250611104844.245235-7-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250611104844.245235-1-steven.price@arm.com>
References: <20250611104844.245235-1-steven.price@arm.com>
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
Changes since v8:
 * Minor improvements to documentation following review.
 * Bump the magic numbers to avoid conflicts.
Changes since v7:
 * Add documentation of new ioctls
 * Bump the magic numbers to avoid conflicts
Changes since v6:
 * Rename some of the symbols to make their usage clearer and avoid
   repetition.
Changes from v5:
 * Actually expose the new VCPU capability (KVM_ARM_VCPU_REC) by bumping
   KVM_VCPU_MAX_FEATURES - note this also exposes KVM_ARM_VCPU_HAS_EL2!
---
 Documentation/virt/kvm/api.rst    | 73 ++++++++++++++++++++++++++++++-
 arch/arm64/include/uapi/asm/kvm.h | 49 +++++++++++++++++++++
 include/uapi/linux/kvm.h          | 10 +++++
 3 files changed, 131 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1bd2d42e6424..65543289f75c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3542,6 +3542,11 @@ Possible features:
 	  Depends on KVM_CAP_ARM_EL2_E2H0.
 	  KVM_ARM_VCPU_HAS_EL2 must also be set.
 
+	- KVM_ARM_VCPU_REC: Allocate a REC (Realm Execution Context) for this
+	  VCPU. This must be specified on all VCPUs created in a Realm VM.
+	  Depends on KVM_CAP_ARM_RME.
+	  Requires KVM_ARM_VCPU_FINALIZE(KVM_ARM_VCPU_REC).
+
 4.83 KVM_ARM_PREFERRED_TARGET
 -----------------------------
 
@@ -5115,6 +5120,7 @@ Recognised values for feature:
 
   =====      ===========================================
   arm64      KVM_ARM_VCPU_SVE (requires KVM_CAP_ARM_SVE)
+  arm64      KVM_ARM_VCPU_REC (requires KVM_CAP_ARM_RME)
   =====      ===========================================
 
 Finalizes the configuration of the specified vcpu feature.
@@ -6469,6 +6475,30 @@ the capability to be present.
 
 `flags` must currently be zero.
 
+4.144 KVM_ARM_VCPU_RMM_PSCI_COMPLETE
+------------------------------------
+
+:Capability: KVM_CAP_ARM_RME
+:Architectures: arm64
+:Type: vcpu ioctl
+:Parameters: struct kvm_arm_rmm_psci_complete (in)
+:Returns: 0 if successful, < 0 on error
+
+::
+
+  struct kvm_arm_rmm_psci_complete {
+	__u64 target_mpidr;
+	__u32 psci_status;
+	__u32 padding[3];
+  };
+
+Where PSCI functions are handled by user space, the RMM needs to be informed of
+the target of the operation using `target_mpidr`, along with the status
+(`psci_status`). The RMM v1.0 specification defines two functions that require
+this call: PSCI_CPU_ON and PSCI_AFFINITY_INFO.
+
+If the kernel is handling PSCI then this is done automatically and the VMM
+doesn't need to call this ioctl.
 
 .. _kvm_run:
 
@@ -8528,7 +8558,7 @@ ENOSYS for the others.
 When enabled, KVM will exit to userspace with KVM_EXIT_SYSTEM_EVENT of
 type KVM_SYSTEM_EVENT_SUSPEND to process the guest suspend request.
 
-7.37 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
+7.42 KVM_CAP_ARM_WRITABLE_IMP_ID_REGS
 -------------------------------------
 
 :Architectures: arm64
@@ -8557,6 +8587,47 @@ given VM.
 When this capability is enabled, KVM resets the VCPU when setting
 MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is preserved.
 
+7.44 KVM_CAP_ARM_RME
+--------------------
+
+:Architectures: arm64
+:Target: VM
+:Parameters: args[0] provides an action, args[1] points to a structure in
+	     memory for some actions.
+:Returns: 0 on success, negative value on error
+
+Used to configure and set up the memory for a Realm. The available actions are:
+
+================================= =============================================
+ KVM_CAP_ARM_RME_CONFIG_REALM     Takes struct arm_rme_config as args[1] and
+                                  configures realm parameters prior to it being
+                                  created.
+
+                                  Options are ARM_RME_CONFIG_RPV to set the
+                                  "Realm Personalization Value" and
+                                  ARM_RME_CONFIG_HASH_ALGO to set the hash
+                                  algorithm.
+
+ KVM_CAP_ARM_RME_CREATE_REALM     Request the RMM to create the realm. The
+                                  realm's configuration parameters must be set
+                                  first.
+
+ KVM_CAP_ARM_RME_INIT_RIPAS_REALM Takes struct arm_rme_init_ripas as args[1]
+                                  and sets the RIPAS (Realm IPA State) to
+                                  RIPAS_RAM of a specified area of the realm's
+                                  IPA.
+
+ KVM_CAP_ARM_RME_POPULATE_REALM   Takes struct arm_rme_populate_realm as
+                                  args[1] and populates a region of protected
+                                  address space by copying the data from the
+                                  shared alias.
+
+ KVM_CAP_ARM_RME_ACTIVATE_REALM   Request the RMM to activate the realm. No
+                                  changes can be made to the Realm's memory,
+                                  IPA state or configuration parameters.  No
+                                  new VCPUs should be created after this step.
+================================= =============================================
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ed5f3892674c..9b5d67ecbc5e 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -106,6 +106,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
 #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
 #define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
+#define KVM_ARM_VCPU_REC		9 /* VCPU REC state as part of Realm */
 
 struct kvm_vcpu_init {
 	__u32 target;
@@ -429,6 +430,54 @@ enum {
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
+/* KVM_CAP_ARM_RME on VM fd */
+#define KVM_CAP_ARM_RME_CONFIG_REALM		0
+#define KVM_CAP_ARM_RME_CREATE_REALM		1
+#define KVM_CAP_ARM_RME_INIT_RIPAS_REALM	2
+#define KVM_CAP_ARM_RME_POPULATE_REALM		3
+#define KVM_CAP_ARM_RME_ACTIVATE_REALM		4
+
+/* List of configuration items accepted for KVM_CAP_ARM_RME_CONFIG_REALM */
+#define ARM_RME_CONFIG_RPV			0
+#define ARM_RME_CONFIG_HASH_ALGO		1
+
+#define ARM_RME_CONFIG_HASH_ALGO_SHA256		0
+#define ARM_RME_CONFIG_HASH_ALGO_SHA512		1
+
+#define ARM_RME_CONFIG_RPV_SIZE 64
+
+struct arm_rme_config {
+	__u32 cfg;
+	union {
+		/* cfg == ARM_RME_CONFIG_RPV */
+		struct {
+			__u8	rpv[ARM_RME_CONFIG_RPV_SIZE];
+		};
+
+		/* cfg == ARM_RME_CONFIG_HASH_ALGO */
+		struct {
+			__u32	hash_algo;
+		};
+
+		/* Fix the size of the union */
+		__u8	reserved[256];
+	};
+};
+
+#define KVM_ARM_RME_POPULATE_FLAGS_MEASURE	(1 << 0)
+struct arm_rme_populate_realm {
+	__u64 base;
+	__u64 size;
+	__u32 flags;
+	__u32 reserved[3];
+};
+
+struct arm_rme_init_ripas {
+	__u64 base;
+	__u64 size;
+	__u64 reserved[2];
+};
+
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
 #define   KVM_ARM_VCPU_PMU_V3_IRQ		0
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d00b85cb168c..3690664e272c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -934,6 +934,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
+#define KVM_CAP_ARM_RME 243
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1586,4 +1587,13 @@ struct kvm_pre_fault_memory {
 	__u64 padding[5];
 };
 
+/* Available with KVM_CAP_ARM_RME, only for VMs with KVM_VM_TYPE_ARM_REALM  */
+struct kvm_arm_rmm_psci_complete {
+	__u64 target_mpidr;
+	__u32 psci_status;
+	__u32 padding[3];
+};
+
+#define KVM_ARM_VCPU_RMM_PSCI_COMPLETE	_IOW(KVMIO, 0xd6, struct kvm_arm_rmm_psci_complete)
+
 #endif /* __LINUX_KVM_H */
-- 
2.43.0


