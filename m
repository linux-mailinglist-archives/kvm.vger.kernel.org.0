Return-Path: <kvm+bounces-66117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C6B2CC7233
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:43:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 21CED303938E
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 10:43:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F26341059;
	Wed, 17 Dec 2025 10:12:18 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6314833F8B1;
	Wed, 17 Dec 2025 10:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966338; cv=none; b=sViR4UoDbmmLsegKB9tlJj/Fx31ejtpTJ0Wcii6zScUMWWE04Da6wtjleq9NEKhDPYqlz3tIfFx/vtQfsWbT+ThVO3njuEh261XQQ4GIjQs66ui1nW2jjK8xGwBZhBe0WvZc/4sNB+ZTbEbLUcN+ZVyCGzYY8p2GeuDXXGgpv+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966338; c=relaxed/simple;
	bh=4HnoiFuOoUG9YTkUM9INTs6SxKrNJnE1BJ1e2Hf5ScA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZIKj4cNirtTc2lhQr1QVHW89XOG5Nz8OQ1qNDm1K+RnAjx6jjV7FWaiOxgz+qbFUQcFcOVDnlwpDDT16rmVdJhbT50Pp55bH1n9k73g8U0QwmK1fqcTAa3U7mKuU5OdKZnOgUC9feCO5x6KBFEiuYuckYjEpOIfPweNmVWO+jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9F7781517;
	Wed, 17 Dec 2025 02:12:08 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DDDE73F73B;
	Wed, 17 Dec 2025 02:12:10 -0800 (PST)
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
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v12 06/46] arm64: RMI: Define the user ABI
Date: Wed, 17 Dec 2025 10:10:43 +0000
Message-ID: <20251217101125.91098-7-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251217101125.91098-1-steven.price@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is one CAP which identified the presence of CCA, and two ioctls.
One ioctl is used to populate memory and the other is used when user
space is providing the PSCI implementation to identify the target of the
operation.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v11:
 * Completely reworked to be more implicit. Rather than having explicit
   CAP operations to progress the realm construction these operations
   are done when needed (on populating and on first vCPU run).
 * Populate and PSCI complete are promoted to proper ioctls.
Changes since v10:
 * Rename symbols from RME to RMI.
Changes since v9:
 * Improvements to documentation.
 * Bump the magic number for KVM_CAP_ARM_RME to avoid conflicts.
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
 Documentation/virt/kvm/api.rst | 57 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h       | 23 ++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 01a3abef8abb..2d5dc7e48954 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6517,6 +6517,54 @@ the capability to be present.
 
 `flags` must currently be zero.
 
+4.144 KVM_ARM_VCPU_RMI_PSCI_COMPLETE
+------------------------------------
+
+:Capability: KVM_CAP_ARM_RMI
+:Architectures: arm64
+:Type: vcpu ioctl
+:Parameters: struct kvm_arm_rmi_psci_complete (in)
+:Returns: 0 if successful, < 0 on error
+
+::
+
+  struct kvm_arm_rmi_psci_complete {
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
+
+4.145 KVM_ARM_RMI_POPULATE
+--------------------------
+
+:Capability: KVM_CAP_ARM_RMI
+:Architectures: arm64
+:Type: vm ioctl
+:Parameters: struct kvm_arm_rmi_populate (in)
+:Returns: number of bytes populated, < 0 on error
+
+::
+
+  struct kvm_arm_rmi_populate {
+	__u64 base;
+	__u64 size;
+	__u64 source_uaddr;
+	__u32 flags;
+	__u32 reserved;
+  };
+
+Populate a region of protected address space by copying the data from the user
+space pointer provided. This is only valid before any VCPUs have been run.
+The ioctl might not populate the entire region and user space may have to
+repeatedly call it (with updated pointers) to populate the entire region.
 
 .. _kvm_run:
 
@@ -8765,6 +8813,15 @@ helpful if user space wants to emulate instructions which are not
 This capability can be enabled dynamically even if VCPUs were already
 created and are running.
 
+7.47 KVM_CAP_ARM_RMI
+--------------------
+
+:Architectures: arm64
+:Target: VM
+:Parameters: None
+
+This capability indicates that support for CCA realms is available.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index dddb781b0507..8e66ba9c81db 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -974,6 +974,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_GUEST_MEMFD_FLAGS 244
 #define KVM_CAP_ARM_SEA_TO_USER 245
 #define KVM_CAP_S390_USER_OPEREXEC 246
+#define KVM_CAP_ARM_RMI 247
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1628,4 +1629,26 @@ struct kvm_pre_fault_memory {
 	__u64 padding[5];
 };
 
+/* Available with KVM_CAP_ARM_RMI, only for VMs with KVM_VM_TYPE_ARM_REALM  */
+struct kvm_arm_rmi_psci_complete {
+	__u64 target_mpidr;
+	__u32 psci_status;
+	__u32 padding[3];
+};
+
+#define KVM_ARM_VCPU_RMI_PSCI_COMPLETE	_IOW(KVMIO, 0xd6, struct kvm_arm_rmi_psci_complete)
+
+/* Available with KVM_CAP_ARM_RMI, only for VMs with KVM_VM_TYPE_ARM_REALM */
+struct kvm_arm_rmi_populate {
+	__u64 base;
+	__u64 size;
+	__u64 source_uaddr;
+	__u32 flags;
+	__u32 reserved;
+};
+
+#define KVM_ARM_RMI_POPULATE_FLAGS_MEASURE	(1 << 0)
+
+#define KVM_ARM_RMI_POPULATE	_IOW(KVMIO, 0xd7, struct kvm_arm_rmi_populate)
+
 #endif /* __LINUX_KVM_H */
-- 
2.43.0


