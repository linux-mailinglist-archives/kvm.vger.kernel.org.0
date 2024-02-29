Return-Path: <kvm+bounces-10356-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 530C786C0C0
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:37:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4F219B26A50
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:37:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5439542A8D;
	Thu, 29 Feb 2024 06:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LDSaGNsW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6AD2E84E
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188664; cv=none; b=NfjuGWTMD6W9qyVoT0v8QnOAhhAscztrck27dRPY7m50j7AWd7Mvni4Ex6CaRNJnNHlvxIyXLBsCnSkcC100nuk3KIgjmZxMxatQc8tQATGHvq0MBRzHcuRRWKyaKmCfxFOk5XgSiYVW5Zo1s7UrIhVtckfzsz6hAu4QvK7qAUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188664; c=relaxed/simple;
	bh=xIX4uAbo6o1IsOVeDfh85i+9729UXIwu7t6YI35Mqk0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e6YgefHKIVP2dcKkl2dNKZxE/hNqVfw6VisZDkeeJu0Ikjkb2hqCep0KGCpw/9fIJrT5gvf7CmlQTNRXfTwTfEwQvBpa7vaDTnSHq6ayHSrMxWA/bofM+HBO7+V8761vUz7lwd8xdj6LIzsTED5BiTrLc14ppqalS2PllrnqQj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LDSaGNsW; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188661; x=1740724661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xIX4uAbo6o1IsOVeDfh85i+9729UXIwu7t6YI35Mqk0=;
  b=LDSaGNsWRaTl0jN4z0kg+0ZEARGAX7Fo4muNQajvZ62f/nJ5fYZf8scs
   QQ5D+K3YIoV1qIqlhgwGFgg9s4rptqvU7luu1HVxtI3AYwL5xDG26fIOA
   WkcDT44qe2mia6m1nGbLDplNHp5XHTnCtvFo51ogv2RxxZMNMzNC/10mr
   qw1PEcOewuS9rV3GBgaqZfmBAnxJJBytFf6JOSfmkTnaKBRjwYUBex7sL
   Zn5n3ygtA+dY8AQ97+cL1NpmXDwyVEz9fi1XBDqz7rUw5kip94mtlxckv
   z6DesAduCbnElxkJZbRhmU4zd56534bfIhYM5T0n8dbeatIafU0AZUVyd
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3802442"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3802442"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:37:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8074517"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:37:34 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 01/65] linux-headers: Update to Linux v6.8-rc5
Date: Thu, 29 Feb 2024 01:36:22 -0500
Message-Id: <20240229063726.610065-2-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Guest memfd support in QEMU requires corresponding KVM guest memfd APIs,
which lands in Linux from v6.8-rc1.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/standard-headers/drm/drm_fourcc.h     |  10 +-
 include/standard-headers/linux/ethtool.h      |  41 +++--
 .../standard-headers/linux/virtio_config.h    |   8 +-
 include/standard-headers/linux/virtio_pci.h   |  68 +++++++++
 include/standard-headers/linux/virtio_pmem.h  |   7 +
 linux-headers/asm-generic/unistd.h            |  15 +-
 linux-headers/asm-mips/mman.h                 |   2 +-
 linux-headers/asm-mips/unistd_n32.h           |   5 +
 linux-headers/asm-mips/unistd_n64.h           |   5 +
 linux-headers/asm-mips/unistd_o32.h           |   5 +
 linux-headers/asm-powerpc/unistd_32.h         |   5 +
 linux-headers/asm-powerpc/unistd_64.h         |   5 +
 linux-headers/asm-riscv/kvm.h                 |  40 +++++
 linux-headers/asm-s390/unistd_32.h            |   5 +
 linux-headers/asm-s390/unistd_64.h            |   5 +
 linux-headers/asm-x86/kvm.h                   |   3 +
 linux-headers/asm-x86/unistd_32.h             |   5 +
 linux-headers/asm-x86/unistd_64.h             |   5 +
 linux-headers/asm-x86/unistd_x32.h            |   5 +
 linux-headers/linux/iommufd.h                 |  79 ++++++++++
 linux-headers/linux/kvm.h                     | 140 +++++++-----------
 linux-headers/linux/userfaultfd.h             |  29 +++-
 linux-headers/linux/vfio.h                    |   1 +
 23 files changed, 381 insertions(+), 112 deletions(-)

diff --git a/include/standard-headers/drm/drm_fourcc.h b/include/standard-headers/drm/drm_fourcc.h
index 3afb70160f0b..b72917073d8d 100644
--- a/include/standard-headers/drm/drm_fourcc.h
+++ b/include/standard-headers/drm/drm_fourcc.h
@@ -53,7 +53,7 @@ extern "C" {
  * Format modifiers may change any property of the buffer, including the number
  * of planes and/or the required allocation size. Format modifiers are
  * vendor-namespaced, and as such the relationship between a fourcc code and a
- * modifier is specific to the modifer being used. For example, some modifiers
+ * modifier is specific to the modifier being used. For example, some modifiers
  * may preserve meaning - such as number of planes - from the fourcc code,
  * whereas others may not.
  *
@@ -78,7 +78,7 @@ extern "C" {
  *   format.
  * - Higher-level programs interfacing with KMS/GBM/EGL/Vulkan/etc: these users
  *   see modifiers as opaque tokens they can check for equality and intersect.
- *   These users musn't need to know to reason about the modifier value
+ *   These users mustn't need to know to reason about the modifier value
  *   (i.e. they are not expected to extract information out of the modifier).
  *
  * Vendors should document their modifier usage in as much detail as
@@ -539,7 +539,7 @@ extern "C" {
  * This is a tiled layout using 4Kb tiles in row-major layout.
  * Within the tile pixels are laid out in 16 256 byte units / sub-tiles which
  * are arranged in four groups (two wide, two high) with column-major layout.
- * Each group therefore consits out of four 256 byte units, which are also laid
+ * Each group therefore consists out of four 256 byte units, which are also laid
  * out as 2x2 column-major.
  * 256 byte units are made out of four 64 byte blocks of pixels, producing
  * either a square block or a 2:1 unit.
@@ -1102,7 +1102,7 @@ drm_fourcc_canonicalize_nvidia_format_mod(uint64_t modifier)
  */
 
 /*
- * The top 4 bits (out of the 56 bits alloted for specifying vendor specific
+ * The top 4 bits (out of the 56 bits allotted for specifying vendor specific
  * modifiers) denote the category for modifiers. Currently we have three
  * categories of modifiers ie AFBC, MISC and AFRC. We can have a maximum of
  * sixteen different categories.
@@ -1418,7 +1418,7 @@ drm_fourcc_canonicalize_nvidia_format_mod(uint64_t modifier)
  * Amlogic FBC Memory Saving mode
  *
  * Indicates the storage is packed when pixel size is multiple of word
- * boudaries, i.e. 8bit should be stored in this mode to save allocation
+ * boundaries, i.e. 8bit should be stored in this mode to save allocation
  * memory.
  *
  * This mode reduces body layout to 3072 bytes per 64x32 superblock with
diff --git a/include/standard-headers/linux/ethtool.h b/include/standard-headers/linux/ethtool.h
index 99fcddf04f88..dfb54eff6f7f 100644
--- a/include/standard-headers/linux/ethtool.h
+++ b/include/standard-headers/linux/ethtool.h
@@ -1266,6 +1266,8 @@ struct ethtool_rxfh_indir {
  *	hardware hash key.
  * @hfunc: Defines the current RSS hash function used by HW (or to be set to).
  *	Valid values are one of the %ETH_RSS_HASH_*.
+ * @input_xfrm: Defines how the input data is transformed. Valid values are one
+ *	of %RXH_XFRM_*.
  * @rsvd8: Reserved for future use; see the note on reserved space.
  * @rsvd32: Reserved for future use; see the note on reserved space.
  * @rss_config: RX ring/queue index for each hash value i.e., indirection table
@@ -1285,7 +1287,8 @@ struct ethtool_rxfh {
 	uint32_t   indir_size;
 	uint32_t   key_size;
 	uint8_t	hfunc;
-	uint8_t	rsvd8[3];
+	uint8_t	input_xfrm;
+	uint8_t	rsvd8[2];
 	uint32_t	rsvd32;
 	uint32_t   rss_config[];
 };
@@ -1992,6 +1995,15 @@ static inline int ethtool_validate_duplex(uint8_t duplex)
 
 #define WOL_MODE_COUNT		8
 
+/* RSS hash function data
+ * XOR the corresponding source and destination fields of each specified
+ * protocol. Both copies of the XOR'ed fields are fed into the RSS and RXHASH
+ * calculation. Note that this XORing reduces the input set entropy and could
+ * be exploited to reduce the RSS queue spread.
+ */
+#define	RXH_XFRM_SYM_XOR	(1 << 0)
+#define	RXH_XFRM_NO_CHANGE	0xff
+
 /* L2-L4 network traffic flow types */
 #define	TCP_V4_FLOW	0x01	/* hash or spec (tcp_ip4_spec) */
 #define	UDP_V4_FLOW	0x02	/* hash or spec (udp_ip4_spec) */
@@ -2128,18 +2140,6 @@ enum ethtool_reset_flags {
  *	refused. For drivers: ignore this field (use kernel's
  *	__ETHTOOL_LINK_MODE_MASK_NBITS instead), any change to it will
  *	be overwritten by kernel.
- * @supported: Bitmap with each bit meaning given by
- *	%ethtool_link_mode_bit_indices for the link modes, physical
- *	connectors and other link features for which the interface
- *	supports autonegotiation or auto-detection.  Read-only.
- * @advertising: Bitmap with each bit meaning given by
- *	%ethtool_link_mode_bit_indices for the link modes, physical
- *	connectors and other link features that are advertised through
- *	autonegotiation or enabled for auto-detection.
- * @lp_advertising: Bitmap with each bit meaning given by
- *	%ethtool_link_mode_bit_indices for the link modes, and other
- *	link features that the link partner advertised through
- *	autonegotiation; 0 if unknown or not applicable.  Read-only.
  * @transceiver: Used to distinguish different possible PHY types,
  *	reported consistently by PHYLIB.  Read-only.
  * @master_slave_cfg: Master/slave port mode.
@@ -2181,6 +2181,21 @@ enum ethtool_reset_flags {
  * %set_link_ksettings() should validate all fields other than @cmd
  * and @link_mode_masks_nwords that are not described as read-only or
  * deprecated, and must ignore all fields described as read-only.
+ *
+ * @link_mode_masks is divided into three bitfields, each of length
+ * @link_mode_masks_nwords:
+ * - supported: Bitmap with each bit meaning given by
+ *	%ethtool_link_mode_bit_indices for the link modes, physical
+ *	connectors and other link features for which the interface
+ *	supports autonegotiation or auto-detection.  Read-only.
+ * - advertising: Bitmap with each bit meaning given by
+ *	%ethtool_link_mode_bit_indices for the link modes, physical
+ *	connectors and other link features that are advertised through
+ *	autonegotiation or enabled for auto-detection.
+ * - lp_advertising: Bitmap with each bit meaning given by
+ *	%ethtool_link_mode_bit_indices for the link modes, and other
+ *	link features that the link partner advertised through
+ *	autonegotiation; 0 if unknown or not applicable.  Read-only.
  */
 struct ethtool_link_settings {
 	uint32_t	cmd;
diff --git a/include/standard-headers/linux/virtio_config.h b/include/standard-headers/linux/virtio_config.h
index bfd1ca643e7f..45be0fa1bcdb 100644
--- a/include/standard-headers/linux/virtio_config.h
+++ b/include/standard-headers/linux/virtio_config.h
@@ -52,7 +52,7 @@
  * rest are per-device feature bits.
  */
 #define VIRTIO_TRANSPORT_F_START	28
-#define VIRTIO_TRANSPORT_F_END		41
+#define VIRTIO_TRANSPORT_F_END		42
 
 #ifndef VIRTIO_CONFIG_NO_LEGACY
 /* Do we get callbacks when the ring is completely used, even if we've
@@ -112,4 +112,10 @@
  * This feature indicates that the driver can reset a queue individually.
  */
 #define VIRTIO_F_RING_RESET		40
+
+/*
+ * This feature indicates that the device support administration virtqueues.
+ */
+#define VIRTIO_F_ADMIN_VQ		41
+
 #endif /* _LINUX_VIRTIO_CONFIG_H */
diff --git a/include/standard-headers/linux/virtio_pci.h b/include/standard-headers/linux/virtio_pci.h
index b7fdfd066878..3e2bc2c97e6e 100644
--- a/include/standard-headers/linux/virtio_pci.h
+++ b/include/standard-headers/linux/virtio_pci.h
@@ -175,6 +175,9 @@ struct virtio_pci_modern_common_cfg {
 
 	uint16_t queue_notify_data;	/* read-write */
 	uint16_t queue_reset;		/* read-write */
+
+	uint16_t admin_queue_index;	/* read-only */
+	uint16_t admin_queue_num;		/* read-only */
 };
 
 /* Fields in VIRTIO_PCI_CAP_PCI_CFG: */
@@ -215,7 +218,72 @@ struct virtio_pci_cfg_cap {
 #define VIRTIO_PCI_COMMON_Q_USEDHI	52
 #define VIRTIO_PCI_COMMON_Q_NDATA	56
 #define VIRTIO_PCI_COMMON_Q_RESET	58
+#define VIRTIO_PCI_COMMON_ADM_Q_IDX	60
+#define VIRTIO_PCI_COMMON_ADM_Q_NUM	62
 
 #endif /* VIRTIO_PCI_NO_MODERN */
 
+/* Admin command status. */
+#define VIRTIO_ADMIN_STATUS_OK		0
+
+/* Admin command opcode. */
+#define VIRTIO_ADMIN_CMD_LIST_QUERY	0x0
+#define VIRTIO_ADMIN_CMD_LIST_USE	0x1
+
+/* Admin command group type. */
+#define VIRTIO_ADMIN_GROUP_TYPE_SRIOV	0x1
+
+/* Transitional device admin command. */
+#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_WRITE	0x2
+#define VIRTIO_ADMIN_CMD_LEGACY_COMMON_CFG_READ		0x3
+#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_WRITE		0x4
+#define VIRTIO_ADMIN_CMD_LEGACY_DEV_CFG_READ		0x5
+#define VIRTIO_ADMIN_CMD_LEGACY_NOTIFY_INFO		0x6
+
+struct QEMU_PACKED virtio_admin_cmd_hdr {
+	uint16_t opcode;
+	/*
+	 * 1 - SR-IOV
+	 * 2-65535 - reserved
+	 */
+	uint16_t group_type;
+	/* Unused, reserved for future extensions. */
+	uint8_t reserved1[12];
+	uint64_t group_member_id;
+};
+
+struct QEMU_PACKED virtio_admin_cmd_status {
+	uint16_t status;
+	uint16_t status_qualifier;
+	/* Unused, reserved for future extensions. */
+	uint8_t reserved2[4];
+};
+
+struct QEMU_PACKED virtio_admin_cmd_legacy_wr_data {
+	uint8_t offset; /* Starting offset of the register(s) to write. */
+	uint8_t reserved[7];
+	uint8_t registers[];
+};
+
+struct QEMU_PACKED virtio_admin_cmd_legacy_rd_data {
+	uint8_t offset; /* Starting offset of the register(s) to read. */
+};
+
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_END 0
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_DEV 0x1
+#define VIRTIO_ADMIN_CMD_NOTIFY_INFO_FLAGS_OWNER_MEM 0x2
+
+#define VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO 4
+
+struct QEMU_PACKED virtio_admin_cmd_notify_info_data {
+	uint8_t flags; /* 0 = end of list, 1 = owner device, 2 = member device */
+	uint8_t bar; /* BAR of the member or the owner device */
+	uint8_t padding[6];
+	uint64_t offset; /* Offset within bar. */
+};
+
+struct virtio_admin_cmd_notify_info_result {
+	struct virtio_admin_cmd_notify_info_data entries[VIRTIO_ADMIN_CMD_MAX_NOTIFY_INFO];
+};
+
 #endif
diff --git a/include/standard-headers/linux/virtio_pmem.h b/include/standard-headers/linux/virtio_pmem.h
index fc029de7988e..1a2576d0178e 100644
--- a/include/standard-headers/linux/virtio_pmem.h
+++ b/include/standard-headers/linux/virtio_pmem.h
@@ -14,6 +14,13 @@
 #include "standard-headers/linux/virtio_ids.h"
 #include "standard-headers/linux/virtio_config.h"
 
+/* Feature bits */
+/* guest physical address range will be indicated as shared memory region 0 */
+#define VIRTIO_PMEM_F_SHMEM_REGION 0
+
+/* shmid of the shared memory region corresponding to the pmem */
+#define VIRTIO_PMEM_SHMEM_REGION_ID 0
+
 struct virtio_pmem_config {
 	uint64_t start;
 	uint64_t size;
diff --git a/linux-headers/asm-generic/unistd.h b/linux-headers/asm-generic/unistd.h
index 756b013fb832..75f00965ab15 100644
--- a/linux-headers/asm-generic/unistd.h
+++ b/linux-headers/asm-generic/unistd.h
@@ -829,8 +829,21 @@ __SYSCALL(__NR_futex_wait, sys_futex_wait)
 #define __NR_futex_requeue 456
 __SYSCALL(__NR_futex_requeue, sys_futex_requeue)
 
+#define __NR_statmount   457
+__SYSCALL(__NR_statmount, sys_statmount)
+
+#define __NR_listmount   458
+__SYSCALL(__NR_listmount, sys_listmount)
+
+#define __NR_lsm_get_self_attr 459
+__SYSCALL(__NR_lsm_get_self_attr, sys_lsm_get_self_attr)
+#define __NR_lsm_set_self_attr 460
+__SYSCALL(__NR_lsm_set_self_attr, sys_lsm_set_self_attr)
+#define __NR_lsm_list_modules 461
+__SYSCALL(__NR_lsm_list_modules, sys_lsm_list_modules)
+
 #undef __NR_syscalls
-#define __NR_syscalls 457
+#define __NR_syscalls 462
 
 /*
  * 32 bit systems traditionally used different
diff --git a/linux-headers/asm-mips/mman.h b/linux-headers/asm-mips/mman.h
index c6e1fc77c996..9c48d9a21aa0 100644
--- a/linux-headers/asm-mips/mman.h
+++ b/linux-headers/asm-mips/mman.h
@@ -88,7 +88,7 @@
 #define MADV_HUGEPAGE	14		/* Worth backing with hugepages */
 #define MADV_NOHUGEPAGE 15		/* Not worth backing with hugepages */
 
-#define MADV_DONTDUMP	16		/* Explicity exclude from the core dump,
+#define MADV_DONTDUMP	16		/* Explicitly exclude from core dump,
 					   overrides the coredump filter bits */
 #define MADV_DODUMP	17		/* Clear the MADV_NODUMP flag */
 
diff --git a/linux-headers/asm-mips/unistd_n32.h b/linux-headers/asm-mips/unistd_n32.h
index 994b6f008f54..ce2e050a9ba4 100644
--- a/linux-headers/asm-mips/unistd_n32.h
+++ b/linux-headers/asm-mips/unistd_n32.h
@@ -385,5 +385,10 @@
 #define __NR_futex_wake (__NR_Linux + 454)
 #define __NR_futex_wait (__NR_Linux + 455)
 #define __NR_futex_requeue (__NR_Linux + 456)
+#define __NR_statmount (__NR_Linux + 457)
+#define __NR_listmount (__NR_Linux + 458)
+#define __NR_lsm_get_self_attr (__NR_Linux + 459)
+#define __NR_lsm_set_self_attr (__NR_Linux + 460)
+#define __NR_lsm_list_modules (__NR_Linux + 461)
 
 #endif /* _ASM_UNISTD_N32_H */
diff --git a/linux-headers/asm-mips/unistd_n64.h b/linux-headers/asm-mips/unistd_n64.h
index 41dcf5877a1b..5bfb3733ffdf 100644
--- a/linux-headers/asm-mips/unistd_n64.h
+++ b/linux-headers/asm-mips/unistd_n64.h
@@ -361,5 +361,10 @@
 #define __NR_futex_wake (__NR_Linux + 454)
 #define __NR_futex_wait (__NR_Linux + 455)
 #define __NR_futex_requeue (__NR_Linux + 456)
+#define __NR_statmount (__NR_Linux + 457)
+#define __NR_listmount (__NR_Linux + 458)
+#define __NR_lsm_get_self_attr (__NR_Linux + 459)
+#define __NR_lsm_set_self_attr (__NR_Linux + 460)
+#define __NR_lsm_list_modules (__NR_Linux + 461)
 
 #endif /* _ASM_UNISTD_N64_H */
diff --git a/linux-headers/asm-mips/unistd_o32.h b/linux-headers/asm-mips/unistd_o32.h
index ae9d334d96e3..02eaecd020ec 100644
--- a/linux-headers/asm-mips/unistd_o32.h
+++ b/linux-headers/asm-mips/unistd_o32.h
@@ -431,5 +431,10 @@
 #define __NR_futex_wake (__NR_Linux + 454)
 #define __NR_futex_wait (__NR_Linux + 455)
 #define __NR_futex_requeue (__NR_Linux + 456)
+#define __NR_statmount (__NR_Linux + 457)
+#define __NR_listmount (__NR_Linux + 458)
+#define __NR_lsm_get_self_attr (__NR_Linux + 459)
+#define __NR_lsm_set_self_attr (__NR_Linux + 460)
+#define __NR_lsm_list_modules (__NR_Linux + 461)
 
 #endif /* _ASM_UNISTD_O32_H */
diff --git a/linux-headers/asm-powerpc/unistd_32.h b/linux-headers/asm-powerpc/unistd_32.h
index b9b23d66d7d9..bbab08d6ec26 100644
--- a/linux-headers/asm-powerpc/unistd_32.h
+++ b/linux-headers/asm-powerpc/unistd_32.h
@@ -438,6 +438,11 @@
 #define __NR_futex_wake 454
 #define __NR_futex_wait 455
 #define __NR_futex_requeue 456
+#define __NR_statmount 457
+#define __NR_listmount 458
+#define __NR_lsm_get_self_attr 459
+#define __NR_lsm_set_self_attr 460
+#define __NR_lsm_list_modules 461
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-powerpc/unistd_64.h b/linux-headers/asm-powerpc/unistd_64.h
index cbb4b3e8f7c2..af34cde70f20 100644
--- a/linux-headers/asm-powerpc/unistd_64.h
+++ b/linux-headers/asm-powerpc/unistd_64.h
@@ -410,6 +410,11 @@
 #define __NR_futex_wake 454
 #define __NR_futex_wait 455
 #define __NR_futex_requeue 456
+#define __NR_statmount 457
+#define __NR_listmount 458
+#define __NR_lsm_get_self_attr 459
+#define __NR_lsm_set_self_attr 460
+#define __NR_lsm_list_modules 461
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-riscv/kvm.h b/linux-headers/asm-riscv/kvm.h
index 60d3b21dead7..7499e88a947c 100644
--- a/linux-headers/asm-riscv/kvm.h
+++ b/linux-headers/asm-riscv/kvm.h
@@ -139,6 +139,33 @@ enum KVM_RISCV_ISA_EXT_ID {
 	KVM_RISCV_ISA_EXT_ZIHPM,
 	KVM_RISCV_ISA_EXT_SMSTATEEN,
 	KVM_RISCV_ISA_EXT_ZICOND,
+	KVM_RISCV_ISA_EXT_ZBC,
+	KVM_RISCV_ISA_EXT_ZBKB,
+	KVM_RISCV_ISA_EXT_ZBKC,
+	KVM_RISCV_ISA_EXT_ZBKX,
+	KVM_RISCV_ISA_EXT_ZKND,
+	KVM_RISCV_ISA_EXT_ZKNE,
+	KVM_RISCV_ISA_EXT_ZKNH,
+	KVM_RISCV_ISA_EXT_ZKR,
+	KVM_RISCV_ISA_EXT_ZKSED,
+	KVM_RISCV_ISA_EXT_ZKSH,
+	KVM_RISCV_ISA_EXT_ZKT,
+	KVM_RISCV_ISA_EXT_ZVBB,
+	KVM_RISCV_ISA_EXT_ZVBC,
+	KVM_RISCV_ISA_EXT_ZVKB,
+	KVM_RISCV_ISA_EXT_ZVKG,
+	KVM_RISCV_ISA_EXT_ZVKNED,
+	KVM_RISCV_ISA_EXT_ZVKNHA,
+	KVM_RISCV_ISA_EXT_ZVKNHB,
+	KVM_RISCV_ISA_EXT_ZVKSED,
+	KVM_RISCV_ISA_EXT_ZVKSH,
+	KVM_RISCV_ISA_EXT_ZVKT,
+	KVM_RISCV_ISA_EXT_ZFH,
+	KVM_RISCV_ISA_EXT_ZFHMIN,
+	KVM_RISCV_ISA_EXT_ZIHINTNTL,
+	KVM_RISCV_ISA_EXT_ZVFH,
+	KVM_RISCV_ISA_EXT_ZVFHMIN,
+	KVM_RISCV_ISA_EXT_ZFA,
 	KVM_RISCV_ISA_EXT_MAX,
 };
 
@@ -157,9 +184,16 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_EXPERIMENTAL,
 	KVM_RISCV_SBI_EXT_VENDOR,
 	KVM_RISCV_SBI_EXT_DBCN,
+	KVM_RISCV_SBI_EXT_STA,
 	KVM_RISCV_SBI_EXT_MAX,
 };
 
+/* SBI STA extension registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_sbi_sta {
+	unsigned long shmem_lo;
+	unsigned long shmem_hi;
+};
+
 /* Possible states for kvm_riscv_timer */
 #define KVM_RISCV_TIMER_STATE_OFF	0
 #define KVM_RISCV_TIMER_STATE_ON	1
@@ -241,6 +275,12 @@ enum KVM_RISCV_SBI_EXT_ID {
 #define KVM_REG_RISCV_VECTOR_REG(n)	\
 		((n) + sizeof(struct __riscv_v_ext_state) / sizeof(unsigned long))
 
+/* Registers for specific SBI extensions are mapped as type 10 */
+#define KVM_REG_RISCV_SBI_STATE		(0x0a << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_STA		(0x0 << KVM_REG_RISCV_SUBTYPE_SHIFT)
+#define KVM_REG_RISCV_SBI_STA_REG(name)		\
+		(offsetof(struct kvm_riscv_sbi_sta, name) / sizeof(unsigned long))
+
 /* Device Control API: RISC-V AIA */
 #define KVM_DEV_RISCV_APLIC_ALIGN		0x1000
 #define KVM_DEV_RISCV_APLIC_SIZE		0x4000
diff --git a/linux-headers/asm-s390/unistd_32.h b/linux-headers/asm-s390/unistd_32.h
index c093e6d5f911..a3ece69d8241 100644
--- a/linux-headers/asm-s390/unistd_32.h
+++ b/linux-headers/asm-s390/unistd_32.h
@@ -429,5 +429,10 @@
 #define __NR_futex_wake 454
 #define __NR_futex_wait 455
 #define __NR_futex_requeue 456
+#define __NR_statmount 457
+#define __NR_listmount 458
+#define __NR_lsm_get_self_attr 459
+#define __NR_lsm_set_self_attr 460
+#define __NR_lsm_list_modules 461
 
 #endif /* _ASM_S390_UNISTD_32_H */
diff --git a/linux-headers/asm-s390/unistd_64.h b/linux-headers/asm-s390/unistd_64.h
index 114c0569a49a..8c5fd93495ce 100644
--- a/linux-headers/asm-s390/unistd_64.h
+++ b/linux-headers/asm-s390/unistd_64.h
@@ -377,5 +377,10 @@
 #define __NR_futex_wake 454
 #define __NR_futex_wait 455
 #define __NR_futex_requeue 456
+#define __NR_statmount 457
+#define __NR_listmount 458
+#define __NR_lsm_get_self_attr 459
+#define __NR_lsm_set_self_attr 460
+#define __NR_lsm_list_modules 461
 
 #endif /* _ASM_S390_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 2b3a8f7bd2c0..003fb745347c 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -560,4 +560,7 @@ struct kvm_pmu_event_filter {
 /* x86-specific KVM_EXIT_HYPERCALL flags. */
 #define KVM_EXIT_HYPERCALL_LONG_MODE	BIT(0)
 
+#define KVM_X86_DEFAULT_VM	0
+#define KVM_X86_SW_PROTECTED_VM	1
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/linux-headers/asm-x86/unistd_32.h b/linux-headers/asm-x86/unistd_32.h
index 329649c377be..5c9c329e9390 100644
--- a/linux-headers/asm-x86/unistd_32.h
+++ b/linux-headers/asm-x86/unistd_32.h
@@ -447,6 +447,11 @@
 #define __NR_futex_wake 454
 #define __NR_futex_wait 455
 #define __NR_futex_requeue 456
+#define __NR_statmount 457
+#define __NR_listmount 458
+#define __NR_lsm_get_self_attr 459
+#define __NR_lsm_set_self_attr 460
+#define __NR_lsm_list_modules 461
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-x86/unistd_64.h b/linux-headers/asm-x86/unistd_64.h
index 4583606ce684..d9aab7ae87d8 100644
--- a/linux-headers/asm-x86/unistd_64.h
+++ b/linux-headers/asm-x86/unistd_64.h
@@ -369,6 +369,11 @@
 #define __NR_futex_wake 454
 #define __NR_futex_wait 455
 #define __NR_futex_requeue 456
+#define __NR_statmount 457
+#define __NR_listmount 458
+#define __NR_lsm_get_self_attr 459
+#define __NR_lsm_set_self_attr 460
+#define __NR_lsm_list_modules 461
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/unistd_x32.h b/linux-headers/asm-x86/unistd_x32.h
index 146d74d8e4b0..63cdd1ee43df 100644
--- a/linux-headers/asm-x86/unistd_x32.h
+++ b/linux-headers/asm-x86/unistd_x32.h
@@ -321,6 +321,11 @@
 #define __NR_futex_wake (__X32_SYSCALL_BIT + 454)
 #define __NR_futex_wait (__X32_SYSCALL_BIT + 455)
 #define __NR_futex_requeue (__X32_SYSCALL_BIT + 456)
+#define __NR_statmount (__X32_SYSCALL_BIT + 457)
+#define __NR_listmount (__X32_SYSCALL_BIT + 458)
+#define __NR_lsm_get_self_attr (__X32_SYSCALL_BIT + 459)
+#define __NR_lsm_set_self_attr (__X32_SYSCALL_BIT + 460)
+#define __NR_lsm_list_modules (__X32_SYSCALL_BIT + 461)
 #define __NR_rt_sigaction (__X32_SYSCALL_BIT + 512)
 #define __NR_rt_sigreturn (__X32_SYSCALL_BIT + 513)
 #define __NR_ioctl (__X32_SYSCALL_BIT + 514)
diff --git a/linux-headers/linux/iommufd.h b/linux-headers/linux/iommufd.h
index 806d98d09c01..72e8f4b9dd0e 100644
--- a/linux-headers/linux/iommufd.h
+++ b/linux-headers/linux/iommufd.h
@@ -49,6 +49,7 @@ enum {
 	IOMMUFD_CMD_GET_HW_INFO,
 	IOMMUFD_CMD_HWPT_SET_DIRTY_TRACKING,
 	IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP,
+	IOMMUFD_CMD_HWPT_INVALIDATE,
 };
 
 /**
@@ -613,4 +614,82 @@ struct iommu_hwpt_get_dirty_bitmap {
 #define IOMMU_HWPT_GET_DIRTY_BITMAP _IO(IOMMUFD_TYPE, \
 					IOMMUFD_CMD_HWPT_GET_DIRTY_BITMAP)
 
+/**
+ * enum iommu_hwpt_invalidate_data_type - IOMMU HWPT Cache Invalidation
+ *                                        Data Type
+ * @IOMMU_HWPT_INVALIDATE_DATA_VTD_S1: Invalidation data for VTD_S1
+ */
+enum iommu_hwpt_invalidate_data_type {
+	IOMMU_HWPT_INVALIDATE_DATA_VTD_S1,
+};
+
+/**
+ * enum iommu_hwpt_vtd_s1_invalidate_flags - Flags for Intel VT-d
+ *                                           stage-1 cache invalidation
+ * @IOMMU_VTD_INV_FLAGS_LEAF: Indicates whether the invalidation applies
+ *                            to all-levels page structure cache or just
+ *                            the leaf PTE cache.
+ */
+enum iommu_hwpt_vtd_s1_invalidate_flags {
+	IOMMU_VTD_INV_FLAGS_LEAF = 1 << 0,
+};
+
+/**
+ * struct iommu_hwpt_vtd_s1_invalidate - Intel VT-d cache invalidation
+ *                                       (IOMMU_HWPT_INVALIDATE_DATA_VTD_S1)
+ * @addr: The start address of the range to be invalidated. It needs to
+ *        be 4KB aligned.
+ * @npages: Number of contiguous 4K pages to be invalidated.
+ * @flags: Combination of enum iommu_hwpt_vtd_s1_invalidate_flags
+ * @__reserved: Must be 0
+ *
+ * The Intel VT-d specific invalidation data for user-managed stage-1 cache
+ * invalidation in nested translation. Userspace uses this structure to
+ * tell the impacted cache scope after modifying the stage-1 page table.
+ *
+ * Invalidating all the caches related to the page table by setting @addr
+ * to be 0 and @npages to be U64_MAX.
+ *
+ * The device TLB will be invalidated automatically if ATS is enabled.
+ */
+struct iommu_hwpt_vtd_s1_invalidate {
+	__aligned_u64 addr;
+	__aligned_u64 npages;
+	__u32 flags;
+	__u32 __reserved;
+};
+
+/**
+ * struct iommu_hwpt_invalidate - ioctl(IOMMU_HWPT_INVALIDATE)
+ * @size: sizeof(struct iommu_hwpt_invalidate)
+ * @hwpt_id: ID of a nested HWPT for cache invalidation
+ * @data_uptr: User pointer to an array of driver-specific cache invalidation
+ *             data.
+ * @data_type: One of enum iommu_hwpt_invalidate_data_type, defining the data
+ *             type of all the entries in the invalidation request array. It
+ *             should be a type supported by the hwpt pointed by @hwpt_id.
+ * @entry_len: Length (in bytes) of a request entry in the request array
+ * @entry_num: Input the number of cache invalidation requests in the array.
+ *             Output the number of requests successfully handled by kernel.
+ * @__reserved: Must be 0.
+ *
+ * Invalidate the iommu cache for user-managed page table. Modifications on a
+ * user-managed page table should be followed by this operation to sync cache.
+ * Each ioctl can support one or more cache invalidation requests in the array
+ * that has a total size of @entry_len * @entry_num.
+ *
+ * An empty invalidation request array by setting @entry_num==0 is allowed, and
+ * @entry_len and @data_uptr would be ignored in this case. This can be used to
+ * check if the given @data_type is supported or not by kernel.
+ */
+struct iommu_hwpt_invalidate {
+	__u32 size;
+	__u32 hwpt_id;
+	__aligned_u64 data_uptr;
+	__u32 data_type;
+	__u32 entry_len;
+	__u32 entry_num;
+	__u32 __reserved;
+};
+#define IOMMU_HWPT_INVALIDATE _IO(IOMMUFD_TYPE, IOMMUFD_CMD_HWPT_INVALIDATE)
 #endif
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 549fea3a978a..17839229b2ac 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -16,76 +16,6 @@
 
 #define KVM_API_VERSION 12
 
-/* *** Deprecated interfaces *** */
-
-#define KVM_TRC_SHIFT           16
-
-#define KVM_TRC_ENTRYEXIT       (1 << KVM_TRC_SHIFT)
-#define KVM_TRC_HANDLER         (1 << (KVM_TRC_SHIFT + 1))
-
-#define KVM_TRC_VMENTRY         (KVM_TRC_ENTRYEXIT + 0x01)
-#define KVM_TRC_VMEXIT          (KVM_TRC_ENTRYEXIT + 0x02)
-#define KVM_TRC_PAGE_FAULT      (KVM_TRC_HANDLER + 0x01)
-
-#define KVM_TRC_HEAD_SIZE       12
-#define KVM_TRC_CYCLE_SIZE      8
-#define KVM_TRC_EXTRA_MAX       7
-
-#define KVM_TRC_INJ_VIRQ         (KVM_TRC_HANDLER + 0x02)
-#define KVM_TRC_REDELIVER_EVT    (KVM_TRC_HANDLER + 0x03)
-#define KVM_TRC_PEND_INTR        (KVM_TRC_HANDLER + 0x04)
-#define KVM_TRC_IO_READ          (KVM_TRC_HANDLER + 0x05)
-#define KVM_TRC_IO_WRITE         (KVM_TRC_HANDLER + 0x06)
-#define KVM_TRC_CR_READ          (KVM_TRC_HANDLER + 0x07)
-#define KVM_TRC_CR_WRITE         (KVM_TRC_HANDLER + 0x08)
-#define KVM_TRC_DR_READ          (KVM_TRC_HANDLER + 0x09)
-#define KVM_TRC_DR_WRITE         (KVM_TRC_HANDLER + 0x0A)
-#define KVM_TRC_MSR_READ         (KVM_TRC_HANDLER + 0x0B)
-#define KVM_TRC_MSR_WRITE        (KVM_TRC_HANDLER + 0x0C)
-#define KVM_TRC_CPUID            (KVM_TRC_HANDLER + 0x0D)
-#define KVM_TRC_INTR             (KVM_TRC_HANDLER + 0x0E)
-#define KVM_TRC_NMI              (KVM_TRC_HANDLER + 0x0F)
-#define KVM_TRC_VMMCALL          (KVM_TRC_HANDLER + 0x10)
-#define KVM_TRC_HLT              (KVM_TRC_HANDLER + 0x11)
-#define KVM_TRC_CLTS             (KVM_TRC_HANDLER + 0x12)
-#define KVM_TRC_LMSW             (KVM_TRC_HANDLER + 0x13)
-#define KVM_TRC_APIC_ACCESS      (KVM_TRC_HANDLER + 0x14)
-#define KVM_TRC_TDP_FAULT        (KVM_TRC_HANDLER + 0x15)
-#define KVM_TRC_GTLB_WRITE       (KVM_TRC_HANDLER + 0x16)
-#define KVM_TRC_STLB_WRITE       (KVM_TRC_HANDLER + 0x17)
-#define KVM_TRC_STLB_INVAL       (KVM_TRC_HANDLER + 0x18)
-#define KVM_TRC_PPC_INSTR        (KVM_TRC_HANDLER + 0x19)
-
-struct kvm_user_trace_setup {
-	__u32 buf_size;
-	__u32 buf_nr;
-};
-
-#define __KVM_DEPRECATED_MAIN_W_0x06 \
-	_IOW(KVMIO, 0x06, struct kvm_user_trace_setup)
-#define __KVM_DEPRECATED_MAIN_0x07 _IO(KVMIO, 0x07)
-#define __KVM_DEPRECATED_MAIN_0x08 _IO(KVMIO, 0x08)
-
-#define __KVM_DEPRECATED_VM_R_0x70 _IOR(KVMIO, 0x70, struct kvm_assigned_irq)
-
-struct kvm_breakpoint {
-	__u32 enabled;
-	__u32 padding;
-	__u64 address;
-};
-
-struct kvm_debug_guest {
-	__u32 enabled;
-	__u32 pad;
-	struct kvm_breakpoint breakpoints[4];
-	__u32 singlestep;
-};
-
-#define __KVM_DEPRECATED_VCPU_W_0x87 _IOW(KVMIO, 0x87, struct kvm_debug_guest)
-
-/* *** End of deprecated interfaces *** */
-
-
 /* for KVM_SET_USER_MEMORY_REGION */
 struct kvm_userspace_memory_region {
 	__u32 slot;
@@ -95,6 +25,19 @@ struct kvm_userspace_memory_region {
 	__u64 userspace_addr; /* start of the userspace allocated memory */
 };
 
+/* for KVM_SET_USER_MEMORY_REGION2 */
+struct kvm_userspace_memory_region2 {
+	__u32 slot;
+	__u32 flags;
+	__u64 guest_phys_addr;
+	__u64 memory_size;
+	__u64 userspace_addr;
+	__u64 guest_memfd_offset;
+	__u32 guest_memfd;
+	__u32 pad1;
+	__u64 pad2[14];
+};
+
 /*
  * The bit 0 ~ bit 15 of kvm_userspace_memory_region::flags are visible for
  * userspace, other bits are reserved for kvm internal use which are defined
@@ -102,6 +45,7 @@ struct kvm_userspace_memory_region {
  */
 #define KVM_MEM_LOG_DIRTY_PAGES	(1UL << 0)
 #define KVM_MEM_READONLY	(1UL << 1)
+#define KVM_MEM_GUEST_MEMFD	(1UL << 2)
 
 /* for KVM_IRQ_LINE */
 struct kvm_irq_level {
@@ -265,6 +209,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_RISCV_CSR        36
 #define KVM_EXIT_NOTIFY           37
 #define KVM_EXIT_LOONGARCH_IOCSR  38
+#define KVM_EXIT_MEMORY_FAULT     39
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -514,6 +459,13 @@ struct kvm_run {
 #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
 			__u32 flags;
 		} notify;
+		/* KVM_EXIT_MEMORY_FAULT */
+		struct {
+#define KVM_MEMORY_EXIT_FLAG_PRIVATE	(1ULL << 3)
+			__u64 flags;
+			__u64 gpa;
+			__u64 size;
+		} memory_fault;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -941,9 +893,6 @@ struct kvm_ppc_resize_hpt {
  */
 #define KVM_GET_VCPU_MMAP_SIZE    _IO(KVMIO,   0x04) /* in bytes */
 #define KVM_GET_SUPPORTED_CPUID   _IOWR(KVMIO, 0x05, struct kvm_cpuid2)
-#define KVM_TRACE_ENABLE          __KVM_DEPRECATED_MAIN_W_0x06
-#define KVM_TRACE_PAUSE           __KVM_DEPRECATED_MAIN_0x07
-#define KVM_TRACE_DISABLE         __KVM_DEPRECATED_MAIN_0x08
 #define KVM_GET_EMULATED_CPUID	  _IOWR(KVMIO, 0x09, struct kvm_cpuid2)
 #define KVM_GET_MSR_FEATURE_INDEX_LIST    _IOWR(KVMIO, 0x0a, struct kvm_msr_list)
 
@@ -1197,6 +1146,11 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_EAGER_SPLIT_CHUNK_SIZE 228
 #define KVM_CAP_ARM_SUPPORTED_BLOCK_SIZES 229
 #define KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES 230
+#define KVM_CAP_USER_MEMORY2 231
+#define KVM_CAP_MEMORY_FAULT_INFO 232
+#define KVM_CAP_MEMORY_ATTRIBUTES 233
+#define KVM_CAP_GUEST_MEMFD 234
+#define KVM_CAP_VM_TYPES 235
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1287,6 +1241,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
 #define KVM_XEN_HVM_CONFIG_EVTCHN_SEND		(1 << 5)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE_UPDATE_FLAG	(1 << 6)
+#define KVM_XEN_HVM_CONFIG_PVCLOCK_TSC_UNSTABLE	(1 << 7)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -1479,6 +1434,8 @@ struct kvm_vfio_spapr_tce {
 					struct kvm_userspace_memory_region)
 #define KVM_SET_TSS_ADDR          _IO(KVMIO,   0x47)
 #define KVM_SET_IDENTITY_MAP_ADDR _IOW(KVMIO,  0x48, __u64)
+#define KVM_SET_USER_MEMORY_REGION2 _IOW(KVMIO, 0x49, \
+					 struct kvm_userspace_memory_region2)
 
 /* enable ucontrol for s390 */
 struct kvm_s390_ucas_mapping {
@@ -1503,20 +1460,8 @@ struct kvm_s390_ucas_mapping {
 			_IOW(KVMIO,  0x67, struct kvm_coalesced_mmio_zone)
 #define KVM_UNREGISTER_COALESCED_MMIO \
 			_IOW(KVMIO,  0x68, struct kvm_coalesced_mmio_zone)
-#define KVM_ASSIGN_PCI_DEVICE     _IOR(KVMIO,  0x69, \
-				       struct kvm_assigned_pci_dev)
 #define KVM_SET_GSI_ROUTING       _IOW(KVMIO,  0x6a, struct kvm_irq_routing)
-/* deprecated, replaced by KVM_ASSIGN_DEV_IRQ */
-#define KVM_ASSIGN_IRQ            __KVM_DEPRECATED_VM_R_0x70
-#define KVM_ASSIGN_DEV_IRQ        _IOW(KVMIO,  0x70, struct kvm_assigned_irq)
 #define KVM_REINJECT_CONTROL      _IO(KVMIO,   0x71)
-#define KVM_DEASSIGN_PCI_DEVICE   _IOW(KVMIO,  0x72, \
-				       struct kvm_assigned_pci_dev)
-#define KVM_ASSIGN_SET_MSIX_NR    _IOW(KVMIO,  0x73, \
-				       struct kvm_assigned_msix_nr)
-#define KVM_ASSIGN_SET_MSIX_ENTRY _IOW(KVMIO,  0x74, \
-				       struct kvm_assigned_msix_entry)
-#define KVM_DEASSIGN_DEV_IRQ      _IOW(KVMIO,  0x75, struct kvm_assigned_irq)
 #define KVM_IRQFD                 _IOW(KVMIO,  0x76, struct kvm_irqfd)
 #define KVM_CREATE_PIT2		  _IOW(KVMIO,  0x77, struct kvm_pit_config)
 #define KVM_SET_BOOT_CPU_ID       _IO(KVMIO,   0x78)
@@ -1533,9 +1478,6 @@ struct kvm_s390_ucas_mapping {
 *  KVM_CAP_VM_TSC_CONTROL to set defaults for a VM */
 #define KVM_SET_TSC_KHZ           _IO(KVMIO,  0xa2)
 #define KVM_GET_TSC_KHZ           _IO(KVMIO,  0xa3)
-/* Available with KVM_CAP_PCI_2_3 */
-#define KVM_ASSIGN_SET_INTX_MASK  _IOW(KVMIO,  0xa4, \
-				       struct kvm_assigned_pci_dev)
 /* Available with KVM_CAP_SIGNAL_MSI */
 #define KVM_SIGNAL_MSI            _IOW(KVMIO,  0xa5, struct kvm_msi)
 /* Available with KVM_CAP_PPC_GET_SMMU_INFO */
@@ -1588,8 +1530,6 @@ struct kvm_s390_ucas_mapping {
 #define KVM_SET_SREGS             _IOW(KVMIO,  0x84, struct kvm_sregs)
 #define KVM_TRANSLATE             _IOWR(KVMIO, 0x85, struct kvm_translation)
 #define KVM_INTERRUPT             _IOW(KVMIO,  0x86, struct kvm_interrupt)
-/* KVM_DEBUG_GUEST is no longer supported, use KVM_SET_GUEST_DEBUG instead */
-#define KVM_DEBUG_GUEST           __KVM_DEPRECATED_VCPU_W_0x87
 #define KVM_GET_MSRS              _IOWR(KVMIO, 0x88, struct kvm_msrs)
 #define KVM_SET_MSRS              _IOW(KVMIO,  0x89, struct kvm_msrs)
 #define KVM_SET_CPUID             _IOW(KVMIO,  0x8a, struct kvm_cpuid)
@@ -2263,4 +2203,24 @@ struct kvm_s390_zpci_op {
 /* flags for kvm_s390_zpci_op->u.reg_aen.flags */
 #define KVM_S390_ZPCIOP_REGAEN_HOST    (1 << 0)
 
+/* Available with KVM_CAP_MEMORY_ATTRIBUTES */
+#define KVM_SET_MEMORY_ATTRIBUTES              _IOW(KVMIO,  0xd2, struct kvm_memory_attributes)
+
+struct kvm_memory_attributes {
+	__u64 address;
+	__u64 size;
+	__u64 attributes;
+	__u64 flags;
+};
+
+#define KVM_MEMORY_ATTRIBUTE_PRIVATE           (1ULL << 3)
+
+#define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest_memfd)
+
+struct kvm_create_guest_memfd {
+	__u64 size;
+	__u64 flags;
+	__u64 reserved[6];
+};
+
 #endif /* __LINUX_KVM_H */
diff --git a/linux-headers/linux/userfaultfd.h b/linux-headers/linux/userfaultfd.h
index 953c75fedae9..4283de22d5b6 100644
--- a/linux-headers/linux/userfaultfd.h
+++ b/linux-headers/linux/userfaultfd.h
@@ -41,7 +41,8 @@
 			   UFFD_FEATURE_WP_HUGETLBFS_SHMEM |	\
 			   UFFD_FEATURE_WP_UNPOPULATED |	\
 			   UFFD_FEATURE_POISON |		\
-			   UFFD_FEATURE_WP_ASYNC)
+			   UFFD_FEATURE_WP_ASYNC |		\
+			   UFFD_FEATURE_MOVE)
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
@@ -50,6 +51,7 @@
 	((__u64)1 << _UFFDIO_WAKE |		\
 	 (__u64)1 << _UFFDIO_COPY |		\
 	 (__u64)1 << _UFFDIO_ZEROPAGE |		\
+	 (__u64)1 << _UFFDIO_MOVE |		\
 	 (__u64)1 << _UFFDIO_WRITEPROTECT |	\
 	 (__u64)1 << _UFFDIO_CONTINUE |		\
 	 (__u64)1 << _UFFDIO_POISON)
@@ -73,6 +75,7 @@
 #define _UFFDIO_WAKE			(0x02)
 #define _UFFDIO_COPY			(0x03)
 #define _UFFDIO_ZEROPAGE		(0x04)
+#define _UFFDIO_MOVE			(0x05)
 #define _UFFDIO_WRITEPROTECT		(0x06)
 #define _UFFDIO_CONTINUE		(0x07)
 #define _UFFDIO_POISON			(0x08)
@@ -92,6 +95,8 @@
 				      struct uffdio_copy)
 #define UFFDIO_ZEROPAGE		_IOWR(UFFDIO, _UFFDIO_ZEROPAGE,	\
 				      struct uffdio_zeropage)
+#define UFFDIO_MOVE		_IOWR(UFFDIO, _UFFDIO_MOVE,	\
+				      struct uffdio_move)
 #define UFFDIO_WRITEPROTECT	_IOWR(UFFDIO, _UFFDIO_WRITEPROTECT, \
 				      struct uffdio_writeprotect)
 #define UFFDIO_CONTINUE		_IOWR(UFFDIO, _UFFDIO_CONTINUE,	\
@@ -222,6 +227,9 @@ struct uffdio_api {
 	 * asynchronous mode is supported in which the write fault is
 	 * automatically resolved and write-protection is un-set.
 	 * It implies UFFD_FEATURE_WP_UNPOPULATED.
+	 *
+	 * UFFD_FEATURE_MOVE indicates that the kernel supports moving an
+	 * existing page contents from userspace.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -239,6 +247,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_WP_UNPOPULATED		(1<<13)
 #define UFFD_FEATURE_POISON			(1<<14)
 #define UFFD_FEATURE_WP_ASYNC			(1<<15)
+#define UFFD_FEATURE_MOVE			(1<<16)
 	__u64 features;
 
 	__u64 ioctls;
@@ -347,6 +356,24 @@ struct uffdio_poison {
 	__s64 updated;
 };
 
+struct uffdio_move {
+	__u64 dst;
+	__u64 src;
+	__u64 len;
+	/*
+	 * Especially if used to atomically remove memory from the
+	 * address space the wake on the dst range is not needed.
+	 */
+#define UFFDIO_MOVE_MODE_DONTWAKE		((__u64)1<<0)
+#define UFFDIO_MOVE_MODE_ALLOW_SRC_HOLES	((__u64)1<<1)
+	__u64 mode;
+	/*
+	 * "move" is written by the ioctl and must be at the end: the
+	 * copy_from_user will not read the last 8 bytes.
+	 */
+	__s64 move;
+};
+
 /*
  * Flags for the userfaultfd(2) system call itself.
  */
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index 8e175ece31ce..b4be37b2255c 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -1219,6 +1219,7 @@ enum vfio_device_mig_state {
 	VFIO_DEVICE_STATE_RUNNING_P2P = 5,
 	VFIO_DEVICE_STATE_PRE_COPY = 6,
 	VFIO_DEVICE_STATE_PRE_COPY_P2P = 7,
+	VFIO_DEVICE_STATE_NR,
 };
 
 /**
-- 
2.34.1


