Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB0A67E3AE
	for <lists+kvm@lfdr.de>; Fri, 27 Jan 2023 12:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233880AbjA0LlX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Jan 2023 06:41:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbjA0LlK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Jan 2023 06:41:10 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCE2320D1B;
        Fri, 27 Jan 2023 03:40:42 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ADE761691;
        Fri, 27 Jan 2023 03:40:53 -0800 (PST)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 30A043F64C;
        Fri, 27 Jan 2023 03:40:09 -0800 (PST)
From:   Suzuki K Poulose <suzuki.poulose@arm.com>
To:     kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc:     suzuki.poulose@arm.com,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Joey Gouly <Joey.Gouly@arm.com>, Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, linux-coco@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [RFC kvmtool 08/31] linux: Update kernel headers for RME support
Date:   Fri, 27 Jan 2023 11:39:09 +0000
Message-Id: <20230127113932.166089-9-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127113932.166089-1-suzuki.poulose@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127113932.166089-1-suzuki.poulose@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Update the RME specific ABI bits from the kernel headers.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/aarch64/include/asm/kvm.h | 64 +++++++++++++++++++++++++++++++++++
 include/linux/kvm.h           | 22 +++++++++---
 include/linux/virtio_blk.h    | 19 -----------
 include/linux/virtio_net.h    | 14 ++++----
 include/linux/virtio_ring.h   | 16 +++------
 5 files changed, 93 insertions(+), 42 deletions(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 316917b9..653a08fb 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -108,6 +108,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_SVE		4 /* enable SVE for this CPU */
 #define KVM_ARM_VCPU_PTRAUTH_ADDRESS	5 /* VCPU uses address authentication */
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
+#define KVM_ARM_VCPU_REC		7 /* VCPU REC state as part of Realm */
 
 struct kvm_vcpu_init {
 	__u32 target;
@@ -400,6 +401,69 @@ enum {
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
+/* KVM_CAP_ARM_RME kvm_enable_cap->args[0] points to this */
+#define KVM_CAP_ARM_RME_CONFIG_REALM		0
+#define KVM_CAP_ARM_RME_CREATE_RD		1
+#define KVM_CAP_ARM_RME_INIT_IPA_REALM		2
+#define KVM_CAP_ARM_RME_POPULATE_REALM		3
+#define KVM_CAP_ARM_RME_ACTIVATE_REALM		4
+
+#define KVM_CAP_ARM_RME_MEASUREMENT_ALGO_ZERO	(0x01ULL << 7)
+#define KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA256 0
+#define KVM_CAP_ARM_RME_MEASUREMENT_ALGO_SHA512 1
+
+#define KVM_CAP_ARM_RME_RPV_SIZE 64
+
+/* List of configuration items accepted for KVM_CAP_ARM_RME_CONFIG_REALM */
+#define KVM_CAP_ARM_RME_CFG_RPV			0
+#define KVM_CAP_ARM_RME_CFG_HASH_ALGO		1
+#define KVM_CAP_ARM_RME_CFG_SVE			2
+#define KVM_CAP_ARM_RME_CFG_DBG			3
+#define KVM_CAP_ARM_RME_CFG_PMU			4
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
+		/* cfg == KVM_CAP_ARM_RME_CFG_SVE */
+		struct {
+			__u32	sve_vq;
+		};
+
+		/* cfg == KVM_CAP_ARM_RME_CFG_DBG */
+		struct {
+			__u32	num_brps;
+			__u32	num_wrps;
+		};
+
+		/* cfg == KVM_CAP_ARM_RME_CFG_PMU */
+		struct {
+			__u32	num_pmu_cntrs;
+		};
+		/* Fix the size of the union */
+		__u8	reserved[256];
+	};
+};
+
+struct kvm_cap_arm_rme_populate_realm_args {
+	__u64 populate_ipa_base;
+	__u64 populate_ipa_size;
+};
+
+struct kvm_cap_arm_rme_init_ipa_args {
+	__u64 init_ipa_base;
+	__u64 init_ipa_size;
+};
+
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
 #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 0d5d4419..789c7f89 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -903,14 +903,25 @@ struct kvm_ppc_resize_hpt {
 #define KVM_S390_SIE_PAGE_OFFSET 1
 
 /*
- * On arm64, machine type can be used to request the physical
- * address size for the VM. Bits[7-0] are reserved for the guest
- * PA size shift (i.e, log2(PA_Size)). For backward compatibility,
- * value 0 implies the default IPA size, 40bits.
+ * On arm64, machine type can be used to request both the machine type and
+ * the physical address size for the VM.
+ *
+ * Bits[11-8] are reserved for the ARM specific machine type.
+ *
+ * Bits[7-0] are reserved for the guest PA size shift (i.e, log2(PA_Size)).
+ * For backward compatibility, value 0 implies the default IPA size, 40bits.
  */
+#define KVM_VM_TYPE_ARM_SHIFT		8
+#define KVM_VM_TYPE_ARM_MASK		(0xfULL << KVM_VM_TYPE_ARM_SHIFT)
+#define KVM_VM_TYPE_ARM(_type)		\
+	(((_type) << KVM_VM_TYPE_ARM_SHIFT) & KVM_VM_TYPE_ARM_MASK)
+#define KVM_VM_TYPE_ARM_NORMAL		KVM_VM_TYPE_ARM(0)
+#define KVM_VM_TYPE_ARM_REALM		KVM_VM_TYPE_ARM(1)
+
 #define KVM_VM_TYPE_ARM_IPA_SIZE_MASK	0xffULL
 #define KVM_VM_TYPE_ARM_IPA_SIZE(x)		\
 	((x) & KVM_VM_TYPE_ARM_IPA_SIZE_MASK)
+
 /*
  * ioctls for /dev/kvm fds:
  */
@@ -1177,7 +1188,8 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_VM_DISABLE_NX_HUGE_PAGES 220
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
-#define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
+
+#define KVM_CAP_ARM_RME 300 // FIXME: Large number to prevent conflicts
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
index 58e70b24..d888f013 100644
--- a/include/linux/virtio_blk.h
+++ b/include/linux/virtio_blk.h
@@ -40,7 +40,6 @@
 #define VIRTIO_BLK_F_MQ		12	/* support more than one vq */
 #define VIRTIO_BLK_F_DISCARD	13	/* DISCARD is supported */
 #define VIRTIO_BLK_F_WRITE_ZEROES	14	/* WRITE ZEROES is supported */
-#define VIRTIO_BLK_F_SECURE_ERASE	16 /* Secure Erase is supported */
 
 /* Legacy feature bits */
 #ifndef VIRTIO_BLK_NO_LEGACY
@@ -122,21 +121,6 @@ struct virtio_blk_config {
 	__u8 write_zeroes_may_unmap;
 
 	__u8 unused1[3];
-
-	/* the next 3 entries are guarded by VIRTIO_BLK_F_SECURE_ERASE */
-	/*
-	 * The maximum secure erase sectors (in 512-byte sectors) for
-	 * one segment.
-	 */
-	__virtio32 max_secure_erase_sectors;
-	/*
-	 * The maximum number of secure erase segments in a
-	 * secure erase command.
-	 */
-	__virtio32 max_secure_erase_seg;
-	/* Secure erase commands must be aligned to this number of sectors. */
-	__virtio32 secure_erase_sector_alignment;
-
 } __attribute__((packed));
 
 /*
@@ -171,9 +155,6 @@ struct virtio_blk_config {
 /* Write zeroes command */
 #define VIRTIO_BLK_T_WRITE_ZEROES	13
 
-/* Secure erase command */
-#define VIRTIO_BLK_T_SECURE_ERASE	14
-
 #ifndef VIRTIO_BLK_NO_LEGACY
 /* Barrier before this op. */
 #define VIRTIO_BLK_T_BARRIER	0x80000000
diff --git a/include/linux/virtio_net.h b/include/linux/virtio_net.h
index 6cb842ea..29ced555 100644
--- a/include/linux/virtio_net.h
+++ b/include/linux/virtio_net.h
@@ -56,7 +56,7 @@
 #define VIRTIO_NET_F_MQ	22	/* Device supports Receive Flow
 					 * Steering */
 #define VIRTIO_NET_F_CTRL_MAC_ADDR 23	/* Set MAC address */
-#define VIRTIO_NET_F_NOTF_COAL	53	/* Device supports notifications coalescing */
+#define VIRTIO_NET_F_NOTF_COAL	53	/* Guest can handle notifications coalescing */
 #define VIRTIO_NET_F_HASH_REPORT  57	/* Supports hash report */
 #define VIRTIO_NET_F_RSS	  60	/* Supports RSS RX steering */
 #define VIRTIO_NET_F_RSC_EXT	  61	/* extended coalescing info */
@@ -364,24 +364,24 @@ struct virtio_net_hash_config {
  */
 #define VIRTIO_NET_CTRL_NOTF_COAL		6
 /*
- * Set the tx-usecs/tx-max-packets parameters.
+ * Set the tx-usecs/tx-max-packets patameters.
+ * tx-usecs - Maximum number of usecs to delay a TX notification.
+ * tx-max-packets - Maximum number of packets to send before a TX notification.
  */
 struct virtio_net_ctrl_coal_tx {
-	/* Maximum number of packets to send before a TX notification */
 	__le32 tx_max_packets;
-	/* Maximum number of usecs to delay a TX notification */
 	__le32 tx_usecs;
 };
 
 #define VIRTIO_NET_CTRL_NOTF_COAL_TX_SET		0
 
 /*
- * Set the rx-usecs/rx-max-packets parameters.
+ * Set the rx-usecs/rx-max-packets patameters.
+ * rx-usecs - Maximum number of usecs to delay a RX notification.
+ * rx-max-frames - Maximum number of packets to receive before a RX notification.
  */
 struct virtio_net_ctrl_coal_rx {
-	/* Maximum number of packets to receive before a RX notification */
 	__le32 rx_max_packets;
-	/* Maximum number of usecs to delay a RX notification */
 	__le32 rx_usecs;
 };
 
diff --git a/include/linux/virtio_ring.h b/include/linux/virtio_ring.h
index f8c20d3d..476d3e5c 100644
--- a/include/linux/virtio_ring.h
+++ b/include/linux/virtio_ring.h
@@ -93,21 +93,15 @@
 #define VRING_USED_ALIGN_SIZE 4
 #define VRING_DESC_ALIGN_SIZE 16
 
-/**
- * struct vring_desc - Virtio ring descriptors,
- * 16 bytes long. These can chain together via @next.
- *
- * @addr: buffer address (guest-physical)
- * @len: buffer length
- * @flags: descriptor flags
- * @next: index of the next descriptor in the chain,
- *        if the VRING_DESC_F_NEXT flag is set. We chain unused
- *        descriptors via this, too.
- */
+/* Virtio ring descriptors: 16 bytes.  These can chain together via "next". */
 struct vring_desc {
+	/* Address (guest-physical). */
 	__virtio64 addr;
+	/* Length. */
 	__virtio32 len;
+	/* The flags as indicated above. */
 	__virtio16 flags;
+	/* We chain unused descriptors via this, too */
 	__virtio16 next;
 };
 
-- 
2.34.1

