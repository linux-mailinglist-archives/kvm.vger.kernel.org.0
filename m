Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E90D546C602
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 22:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhLGVI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 16:08:29 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:32930 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232821AbhLGVI3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Dec 2021 16:08:29 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7KMR4n024398;
        Tue, 7 Dec 2021 21:04:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mGRTelPnkWz1SaMCvg4ZOgc6JOLgI/SJzLS/zDzBT84=;
 b=fgWTqnmDdkuU0VcLCBl4uI4YwGrw5Ez76kLdnGm9TuTFBrTjD0gYNwiinEZyUTsE4eD3
 4nhpHt+zPVNUuLx5paSaWyPex6VWmrJBkEE39a3TPLp8vu3erUpmj52J2cCQNLoRRbet
 glSyB9s+9yoLi02kARLYIG4UwaXrXjv1lUl1hYnjInOvjwDLNLFg+zoj/vVfdoHoOMOc
 7v5/E6ogB/057K6JrUrtrbBuJYX8dNMg5UKL6Jjq3UrG3iL7AS3fBybEugALT6TFOUop
 K3qJl7PSuhrTuHN+oR2fVOIU1zOzYytWw0ZyV5WdLrtpXkWFWtkdqx2mr1/yo4i4q6Xu KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctekg0qqy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:04:53 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B7KPW3u008966;
        Tue, 7 Dec 2021 21:04:52 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ctekg0qqm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:04:52 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B7Kvoui031438;
        Tue, 7 Dec 2021 21:04:51 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma05wdc.us.ibm.com with ESMTP id 3cqyyamrm8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Dec 2021 21:04:51 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B7L4oxM17695062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Dec 2021 21:04:50 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4A97BAE063;
        Tue,  7 Dec 2021 21:04:50 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8EF51AE067;
        Tue,  7 Dec 2021 21:04:46 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.152.43])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  7 Dec 2021 21:04:46 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 04/12] Update linux headers
Date:   Tue,  7 Dec 2021 16:04:17 -0500
Message-Id: <20211207210425.150923-5-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211207210425.150923-1-mjrosato@linux.ibm.com>
References: <20211207210425.150923-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YJ-EhBIbJLCoLPahAaZrHHWDGy4knLuN
X-Proofpoint-ORIG-GUID: aVu4SjDLKtdi8TRcU2Ulq0F14im0Rbw_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0 impostorscore=0
 clxscore=1015 suspectscore=0 priorityscore=1501 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070128
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a placeholder that pulls in 5.16-rc4 + unmerged kernel changes
required by this item.  A proper header sync can be done once the
associated kernel code merges.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 include/standard-headers/asm-x86/kvm_para.h   |   1 +
 include/standard-headers/drm/drm_fourcc.h     | 121 +++++++++++++++++-
 include/standard-headers/linux/ethtool.h      |  31 +++++
 include/standard-headers/linux/fuse.h         |  15 ++-
 include/standard-headers/linux/pci_regs.h     |   6 +
 include/standard-headers/linux/virtio_gpu.h   |  18 ++-
 include/standard-headers/linux/virtio_ids.h   |  24 ++++
 include/standard-headers/linux/virtio_mem.h   |   9 +-
 include/standard-headers/linux/virtio_vsock.h |   3 +-
 linux-headers/asm-arm64/unistd.h              |   1 +
 linux-headers/asm-generic/unistd.h            |  22 +++-
 linux-headers/asm-mips/unistd_n32.h           |   2 +
 linux-headers/asm-mips/unistd_n64.h           |   2 +
 linux-headers/asm-mips/unistd_o32.h           |   2 +
 linux-headers/asm-powerpc/unistd_32.h         |   2 +
 linux-headers/asm-powerpc/unistd_64.h         |   2 +
 linux-headers/asm-s390/kvm.h                  |   1 +
 linux-headers/asm-s390/unistd_32.h            |   2 +
 linux-headers/asm-s390/unistd_64.h            |   2 +
 linux-headers/asm-x86/kvm.h                   |   5 +
 linux-headers/asm-x86/unistd_32.h             |   3 +
 linux-headers/asm-x86/unistd_64.h             |   3 +
 linux-headers/asm-x86/unistd_x32.h            |   3 +
 linux-headers/linux/kvm.h                     |  41 +++++-
 linux-headers/linux/vfio.h                    |  22 ++++
 linux-headers/linux/vfio_zdev.h               |  51 ++++++++
 26 files changed, 370 insertions(+), 24 deletions(-)

diff --git a/include/standard-headers/asm-x86/kvm_para.h b/include/standard-headers/asm-x86/kvm_para.h
index 204cfb8640..f0235e58a1 100644
--- a/include/standard-headers/asm-x86/kvm_para.h
+++ b/include/standard-headers/asm-x86/kvm_para.h
@@ -8,6 +8,7 @@
  * should be used to determine that a VM is running under KVM.
  */
 #define KVM_CPUID_SIGNATURE	0x40000000
+#define KVM_SIGNATURE "KVMKVMKVM\0\0\0"
 
 /* This CPUID returns two feature bitmaps in eax, edx. Before enabling
  * a particular paravirtualization, the appropriate feature bit should
diff --git a/include/standard-headers/drm/drm_fourcc.h b/include/standard-headers/drm/drm_fourcc.h
index 352b51fd0a..2c025cb4fe 100644
--- a/include/standard-headers/drm/drm_fourcc.h
+++ b/include/standard-headers/drm/drm_fourcc.h
@@ -103,6 +103,12 @@ extern "C" {
 /* 8 bpp Red */
 #define DRM_FORMAT_R8		fourcc_code('R', '8', ' ', ' ') /* [7:0] R */
 
+/* 10 bpp Red */
+#define DRM_FORMAT_R10		fourcc_code('R', '1', '0', ' ') /* [15:0] x:R 6:10 little endian */
+
+/* 12 bpp Red */
+#define DRM_FORMAT_R12		fourcc_code('R', '1', '2', ' ') /* [15:0] x:R 4:12 little endian */
+
 /* 16 bpp Red */
 #define DRM_FORMAT_R16		fourcc_code('R', '1', '6', ' ') /* [15:0] R little endian */
 
@@ -372,6 +378,12 @@ extern "C" {
 
 #define DRM_FORMAT_RESERVED	      ((1ULL << 56) - 1)
 
+#define fourcc_mod_get_vendor(modifier) \
+	(((modifier) >> 56) & 0xff)
+
+#define fourcc_mod_is_vendor(modifier, vendor) \
+	(fourcc_mod_get_vendor(modifier) == DRM_FORMAT_MOD_VENDOR_## vendor)
+
 #define fourcc_mod_code(vendor, val) \
 	((((uint64_t)DRM_FORMAT_MOD_VENDOR_## vendor) << 56) | ((val) & 0x00ffffffffffffffULL))
 
@@ -899,9 +911,9 @@ drm_fourcc_canonicalize_nvidia_format_mod(uint64_t modifier)
 
 /*
  * The top 4 bits (out of the 56 bits alloted for specifying vendor specific
- * modifiers) denote the category for modifiers. Currently we have only two
- * categories of modifiers ie AFBC and MISC. We can have a maximum of sixteen
- * different categories.
+ * modifiers) denote the category for modifiers. Currently we have three
+ * categories of modifiers ie AFBC, MISC and AFRC. We can have a maximum of
+ * sixteen different categories.
  */
 #define DRM_FORMAT_MOD_ARM_CODE(__type, __val) \
 	fourcc_mod_code(ARM, ((uint64_t)(__type) << 52) | ((__val) & 0x000fffffffffffffULL))
@@ -1016,6 +1028,109 @@ drm_fourcc_canonicalize_nvidia_format_mod(uint64_t modifier)
  */
 #define AFBC_FORMAT_MOD_USM	(1ULL << 12)
 
+/*
+ * Arm Fixed-Rate Compression (AFRC) modifiers
+ *
+ * AFRC is a proprietary fixed rate image compression protocol and format,
+ * designed to provide guaranteed bandwidth and memory footprint
+ * reductions in graphics and media use-cases.
+ *
+ * AFRC buffers consist of one or more planes, with the same components
+ * and meaning as an uncompressed buffer using the same pixel format.
+ *
+ * Within each plane, the pixel/luma/chroma values are grouped into
+ * "coding unit" blocks which are individually compressed to a
+ * fixed size (in bytes). All coding units within a given plane of a buffer
+ * store the same number of values, and have the same compressed size.
+ *
+ * The coding unit size is configurable, allowing different rates of compression.
+ *
+ * The start of each AFRC buffer plane must be aligned to an alignment granule which
+ * depends on the coding unit size.
+ *
+ * Coding Unit Size   Plane Alignment
+ * ----------------   ---------------
+ * 16 bytes           1024 bytes
+ * 24 bytes           512  bytes
+ * 32 bytes           2048 bytes
+ *
+ * Coding units are grouped into paging tiles. AFRC buffer dimensions must be aligned
+ * to a multiple of the paging tile dimensions.
+ * The dimensions of each paging tile depend on whether the buffer is optimised for
+ * scanline (SCAN layout) or rotated (ROT layout) access.
+ *
+ * Layout   Paging Tile Width   Paging Tile Height
+ * ------   -----------------   ------------------
+ * SCAN     16 coding units     4 coding units
+ * ROT      8  coding units     8 coding units
+ *
+ * The dimensions of each coding unit depend on the number of components
+ * in the compressed plane and whether the buffer is optimised for
+ * scanline (SCAN layout) or rotated (ROT layout) access.
+ *
+ * Number of Components in Plane   Layout      Coding Unit Width   Coding Unit Height
+ * -----------------------------   ---------   -----------------   ------------------
+ * 1                               SCAN        16 samples          4 samples
+ * Example: 16x4 luma samples in a 'Y' plane
+ *          16x4 chroma 'V' values, in the 'V' plane of a fully-planar YUV buffer
+ * -----------------------------   ---------   -----------------   ------------------
+ * 1                               ROT         8 samples           8 samples
+ * Example: 8x8 luma samples in a 'Y' plane
+ *          8x8 chroma 'V' values, in the 'V' plane of a fully-planar YUV buffer
+ * -----------------------------   ---------   -----------------   ------------------
+ * 2                               DONT CARE   8 samples           4 samples
+ * Example: 8x4 chroma pairs in the 'UV' plane of a semi-planar YUV buffer
+ * -----------------------------   ---------   -----------------   ------------------
+ * 3                               DONT CARE   4 samples           4 samples
+ * Example: 4x4 pixels in an RGB buffer without alpha
+ * -----------------------------   ---------   -----------------   ------------------
+ * 4                               DONT CARE   4 samples           4 samples
+ * Example: 4x4 pixels in an RGB buffer with alpha
+ */
+
+#define DRM_FORMAT_MOD_ARM_TYPE_AFRC 0x02
+
+#define DRM_FORMAT_MOD_ARM_AFRC(__afrc_mode) \
+	DRM_FORMAT_MOD_ARM_CODE(DRM_FORMAT_MOD_ARM_TYPE_AFRC, __afrc_mode)
+
+/*
+ * AFRC coding unit size modifier.
+ *
+ * Indicates the number of bytes used to store each compressed coding unit for
+ * one or more planes in an AFRC encoded buffer. The coding unit size for chrominance
+ * is the same for both Cb and Cr, which may be stored in separate planes.
+ *
+ * AFRC_FORMAT_MOD_CU_SIZE_P0 indicates the number of bytes used to store
+ * each compressed coding unit in the first plane of the buffer. For RGBA buffers
+ * this is the only plane, while for semi-planar and fully-planar YUV buffers,
+ * this corresponds to the luma plane.
+ *
+ * AFRC_FORMAT_MOD_CU_SIZE_P12 indicates the number of bytes used to store
+ * each compressed coding unit in the second and third planes in the buffer.
+ * For semi-planar and fully-planar YUV buffers, this corresponds to the chroma plane(s).
+ *
+ * For single-plane buffers, AFRC_FORMAT_MOD_CU_SIZE_P0 must be specified
+ * and AFRC_FORMAT_MOD_CU_SIZE_P12 must be zero.
+ * For semi-planar and fully-planar buffers, both AFRC_FORMAT_MOD_CU_SIZE_P0 and
+ * AFRC_FORMAT_MOD_CU_SIZE_P12 must be specified.
+ */
+#define AFRC_FORMAT_MOD_CU_SIZE_MASK 0xf
+#define AFRC_FORMAT_MOD_CU_SIZE_16 (1ULL)
+#define AFRC_FORMAT_MOD_CU_SIZE_24 (2ULL)
+#define AFRC_FORMAT_MOD_CU_SIZE_32 (3ULL)
+
+#define AFRC_FORMAT_MOD_CU_SIZE_P0(__afrc_cu_size) (__afrc_cu_size)
+#define AFRC_FORMAT_MOD_CU_SIZE_P12(__afrc_cu_size) ((__afrc_cu_size) << 4)
+
+/*
+ * AFRC scanline memory layout.
+ *
+ * Indicates if the buffer uses the scanline-optimised layout
+ * for an AFRC encoded buffer, otherwise, it uses the rotation-optimised layout.
+ * The memory layout is the same for all planes.
+ */
+#define AFRC_FORMAT_MOD_LAYOUT_SCAN (1ULL << 8)
+
 /*
  * Arm 16x16 Block U-Interleaved modifier
  *
diff --git a/include/standard-headers/linux/ethtool.h b/include/standard-headers/linux/ethtool.h
index 053d3fafdf..688eb8dc39 100644
--- a/include/standard-headers/linux/ethtool.h
+++ b/include/standard-headers/linux/ethtool.h
@@ -603,6 +603,7 @@ enum ethtool_link_ext_state {
 	ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE,
 	ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED,
 	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
+	ETHTOOL_LINK_EXT_STATE_MODULE,
 };
 
 /* More information in addition to ETHTOOL_LINK_EXT_STATE_AUTONEG. */
@@ -639,6 +640,8 @@ enum ethtool_link_ext_substate_link_logical_mismatch {
 enum ethtool_link_ext_substate_bad_signal_integrity {
 	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
 	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_REFERENCE_CLOCK_LOST,
+	ETHTOOL_LINK_EXT_SUBSTATE_BSI_SERDES_ALOS,
 };
 
 /* More information in addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE. */
@@ -647,6 +650,11 @@ enum ethtool_link_ext_substate_cable_issue {
 	ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE,
 };
 
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_MODULE. */
+enum ethtool_link_ext_substate_module {
+	ETHTOOL_LINK_EXT_SUBSTATE_MODULE_CMIS_NOT_READY = 1,
+};
+
 #define ETH_GSTRING_LEN		32
 
 /**
@@ -704,6 +712,29 @@ enum ethtool_stringset {
 	ETH_SS_COUNT
 };
 
+/**
+ * enum ethtool_module_power_mode_policy - plug-in module power mode policy
+ * @ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH: Module is always in high power mode.
+ * @ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO: Module is transitioned by the host
+ *	to high power mode when the first port using it is put administratively
+ *	up and to low power mode when the last port using it is put
+ *	administratively down.
+ */
+enum ethtool_module_power_mode_policy {
+	ETHTOOL_MODULE_POWER_MODE_POLICY_HIGH = 1,
+	ETHTOOL_MODULE_POWER_MODE_POLICY_AUTO,
+};
+
+/**
+ * enum ethtool_module_power_mode - plug-in module power mode
+ * @ETHTOOL_MODULE_POWER_MODE_LOW: Module is in low power mode.
+ * @ETHTOOL_MODULE_POWER_MODE_HIGH: Module is in high power mode.
+ */
+enum ethtool_module_power_mode {
+	ETHTOOL_MODULE_POWER_MODE_LOW = 1,
+	ETHTOOL_MODULE_POWER_MODE_HIGH,
+};
+
 /**
  * struct ethtool_gstrings - string set for data tagging
  * @cmd: Command number = %ETHTOOL_GSTRINGS
diff --git a/include/standard-headers/linux/fuse.h b/include/standard-headers/linux/fuse.h
index cce105bfba..e021060cee 100644
--- a/include/standard-headers/linux/fuse.h
+++ b/include/standard-headers/linux/fuse.h
@@ -181,6 +181,12 @@
  *  - add FUSE_OPEN_KILL_SUIDGID
  *  - extend fuse_setxattr_in, add FUSE_SETXATTR_EXT
  *  - add FUSE_SETXATTR_ACL_KILL_SGID
+ *
+ *  7.34
+ *  - add FUSE_SYNCFS
+ *
+ *  7.35
+ *  - add FOPEN_NOFLUSH
  */
 
 #ifndef _LINUX_FUSE_H
@@ -212,7 +218,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 33
+#define FUSE_KERNEL_MINOR_VERSION 35
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -283,12 +289,14 @@ struct fuse_file_lock {
  * FOPEN_NONSEEKABLE: the file is not seekable
  * FOPEN_CACHE_DIR: allow caching this directory
  * FOPEN_STREAM: the file is stream-like (no file position at all)
+ * FOPEN_NOFLUSH: don't flush data cache on close (unless FUSE_WRITEBACK_CACHE)
  */
 #define FOPEN_DIRECT_IO		(1 << 0)
 #define FOPEN_KEEP_CACHE	(1 << 1)
 #define FOPEN_NONSEEKABLE	(1 << 2)
 #define FOPEN_CACHE_DIR		(1 << 3)
 #define FOPEN_STREAM		(1 << 4)
+#define FOPEN_NOFLUSH		(1 << 5)
 
 /**
  * INIT request/reply flags
@@ -505,6 +513,7 @@ enum fuse_opcode {
 	FUSE_COPY_FILE_RANGE	= 47,
 	FUSE_SETUPMAPPING	= 48,
 	FUSE_REMOVEMAPPING	= 49,
+	FUSE_SYNCFS		= 50,
 
 	/* CUSE specific operations */
 	CUSE_INIT		= 4096,
@@ -967,4 +976,8 @@ struct fuse_removemapping_one {
 #define FUSE_REMOVEMAPPING_MAX_ENTRY   \
 		(PAGE_SIZE / sizeof(struct fuse_removemapping_one))
 
+struct fuse_syncfs_in {
+	uint64_t	padding;
+};
+
 #endif /* _LINUX_FUSE_H */
diff --git a/include/standard-headers/linux/pci_regs.h b/include/standard-headers/linux/pci_regs.h
index e709ae8235..ff6ccbc6ef 100644
--- a/include/standard-headers/linux/pci_regs.h
+++ b/include/standard-headers/linux/pci_regs.h
@@ -504,6 +504,12 @@
 #define  PCI_EXP_DEVCTL_URRE	0x0008	/* Unsupported Request Reporting En. */
 #define  PCI_EXP_DEVCTL_RELAX_EN 0x0010 /* Enable relaxed ordering */
 #define  PCI_EXP_DEVCTL_PAYLOAD	0x00e0	/* Max_Payload_Size */
+#define  PCI_EXP_DEVCTL_PAYLOAD_128B 0x0000 /* 128 Bytes */
+#define  PCI_EXP_DEVCTL_PAYLOAD_256B 0x0020 /* 256 Bytes */
+#define  PCI_EXP_DEVCTL_PAYLOAD_512B 0x0040 /* 512 Bytes */
+#define  PCI_EXP_DEVCTL_PAYLOAD_1024B 0x0060 /* 1024 Bytes */
+#define  PCI_EXP_DEVCTL_PAYLOAD_2048B 0x0080 /* 2048 Bytes */
+#define  PCI_EXP_DEVCTL_PAYLOAD_4096B 0x00a0 /* 4096 Bytes */
 #define  PCI_EXP_DEVCTL_EXT_TAG	0x0100	/* Extended Tag Field Enable */
 #define  PCI_EXP_DEVCTL_PHANTOM	0x0200	/* Phantom Functions Enable */
 #define  PCI_EXP_DEVCTL_AUX_PME	0x0400	/* Auxiliary Power PM Enable */
diff --git a/include/standard-headers/linux/virtio_gpu.h b/include/standard-headers/linux/virtio_gpu.h
index 1357e4774e..2da48d3d4c 100644
--- a/include/standard-headers/linux/virtio_gpu.h
+++ b/include/standard-headers/linux/virtio_gpu.h
@@ -59,6 +59,11 @@
  * VIRTIO_GPU_CMD_RESOURCE_CREATE_BLOB
  */
 #define VIRTIO_GPU_F_RESOURCE_BLOB       3
+/*
+ * VIRTIO_GPU_CMD_CREATE_CONTEXT with
+ * context_init and multiple timelines
+ */
+#define VIRTIO_GPU_F_CONTEXT_INIT        4
 
 enum virtio_gpu_ctrl_type {
 	VIRTIO_GPU_UNDEFINED = 0,
@@ -122,14 +127,20 @@ enum virtio_gpu_shm_id {
 	VIRTIO_GPU_SHM_ID_HOST_VISIBLE = 1
 };
 
-#define VIRTIO_GPU_FLAG_FENCE (1 << 0)
+#define VIRTIO_GPU_FLAG_FENCE         (1 << 0)
+/*
+ * If the following flag is set, then ring_idx contains the index
+ * of the command ring that needs to used when creating the fence
+ */
+#define VIRTIO_GPU_FLAG_INFO_RING_IDX (1 << 1)
 
 struct virtio_gpu_ctrl_hdr {
 	uint32_t type;
 	uint32_t flags;
 	uint64_t fence_id;
 	uint32_t ctx_id;
-	uint32_t padding;
+	uint8_t ring_idx;
+	uint8_t padding[3];
 };
 
 /* data passed in the cursor vq */
@@ -269,10 +280,11 @@ struct virtio_gpu_resource_create_3d {
 };
 
 /* VIRTIO_GPU_CMD_CTX_CREATE */
+#define VIRTIO_GPU_CONTEXT_INIT_CAPSET_ID_MASK 0x000000ff
 struct virtio_gpu_ctx_create {
 	struct virtio_gpu_ctrl_hdr hdr;
 	uint32_t nlen;
-	uint32_t padding;
+	uint32_t context_init;
 	char debug_name[64];
 };
 
diff --git a/include/standard-headers/linux/virtio_ids.h b/include/standard-headers/linux/virtio_ids.h
index 4fe842c3a3..80d76b75bc 100644
--- a/include/standard-headers/linux/virtio_ids.h
+++ b/include/standard-headers/linux/virtio_ids.h
@@ -54,7 +54,31 @@
 #define VIRTIO_ID_SOUND			25 /* virtio sound */
 #define VIRTIO_ID_FS			26 /* virtio filesystem */
 #define VIRTIO_ID_PMEM			27 /* virtio pmem */
+#define VIRTIO_ID_RPMB			28 /* virtio rpmb */
 #define VIRTIO_ID_MAC80211_HWSIM	29 /* virtio mac80211-hwsim */
+#define VIRTIO_ID_VIDEO_ENCODER		30 /* virtio video encoder */
+#define VIRTIO_ID_VIDEO_DECODER		31 /* virtio video decoder */
+#define VIRTIO_ID_SCMI			32 /* virtio SCMI */
+#define VIRTIO_ID_NITRO_SEC_MOD		33 /* virtio nitro secure module*/
+#define VIRTIO_ID_I2C_ADAPTER		34 /* virtio i2c adapter */
+#define VIRTIO_ID_WATCHDOG		35 /* virtio watchdog */
+#define VIRTIO_ID_CAN			36 /* virtio can */
+#define VIRTIO_ID_DMABUF		37 /* virtio dmabuf */
+#define VIRTIO_ID_PARAM_SERV		38 /* virtio parameter server */
+#define VIRTIO_ID_AUDIO_POLICY		39 /* virtio audio policy */
 #define VIRTIO_ID_BT			40 /* virtio bluetooth */
+#define VIRTIO_ID_GPIO			41 /* virtio gpio */
+
+/*
+ * Virtio Transitional IDs
+ */
+
+#define VIRTIO_TRANS_ID_NET		1000 /* transitional virtio net */
+#define VIRTIO_TRANS_ID_BLOCK		1001 /* transitional virtio block */
+#define VIRTIO_TRANS_ID_BALLOON		1002 /* transitional virtio balloon */
+#define VIRTIO_TRANS_ID_CONSOLE		1003 /* transitional virtio console */
+#define VIRTIO_TRANS_ID_SCSI		1004 /* transitional virtio SCSI */
+#define VIRTIO_TRANS_ID_RNG		1005 /* transitional virtio rng */
+#define VIRTIO_TRANS_ID_9P		1009 /* transitional virtio 9p console */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
diff --git a/include/standard-headers/linux/virtio_mem.h b/include/standard-headers/linux/virtio_mem.h
index 05e5ade75d..18c74c527c 100644
--- a/include/standard-headers/linux/virtio_mem.h
+++ b/include/standard-headers/linux/virtio_mem.h
@@ -68,9 +68,10 @@
  * explicitly triggered (VIRTIO_MEM_REQ_UNPLUG).
  *
  * There are no guarantees what will happen if unplugged memory is
- * read/written. Such memory should, in general, not be touched. E.g.,
- * even writing might succeed, but the values will simply be discarded at
- * random points in time.
+ * read/written. In general, unplugged memory should not be touched, because
+ * the resulting action is undefined. There is one exception: without
+ * VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE, unplugged memory inside the usable
+ * region can be read, to simplify creation of memory dumps.
  *
  * It can happen that the device cannot process a request, because it is
  * busy. The device driver has to retry later.
@@ -87,6 +88,8 @@
 
 /* node_id is an ACPI PXM and is valid */
 #define VIRTIO_MEM_F_ACPI_PXM		0
+/* unplugged memory must not be accessed */
+#define VIRTIO_MEM_F_UNPLUGGED_INACCESSIBLE	1
 
 
 /* --- virtio-mem: guest -> host requests --- */
diff --git a/include/standard-headers/linux/virtio_vsock.h b/include/standard-headers/linux/virtio_vsock.h
index 3a23488e42..467e751b17 100644
--- a/include/standard-headers/linux/virtio_vsock.h
+++ b/include/standard-headers/linux/virtio_vsock.h
@@ -97,7 +97,8 @@ enum virtio_vsock_shutdown {
 
 /* VIRTIO_VSOCK_OP_RW flags values */
 enum virtio_vsock_rw {
-	VIRTIO_VSOCK_SEQ_EOR = 1,
+	VIRTIO_VSOCK_SEQ_EOM = 1,
+	VIRTIO_VSOCK_SEQ_EOR = 2,
 };
 
 #endif /* _LINUX_VIRTIO_VSOCK_H */
diff --git a/linux-headers/asm-arm64/unistd.h b/linux-headers/asm-arm64/unistd.h
index f83a70e07d..ce2ee8f1e3 100644
--- a/linux-headers/asm-arm64/unistd.h
+++ b/linux-headers/asm-arm64/unistd.h
@@ -20,5 +20,6 @@
 #define __ARCH_WANT_SET_GET_RLIMIT
 #define __ARCH_WANT_TIME32_SYSCALLS
 #define __ARCH_WANT_SYS_CLONE3
+#define __ARCH_WANT_MEMFD_SECRET
 
 #include <asm-generic/unistd.h>
diff --git a/linux-headers/asm-generic/unistd.h b/linux-headers/asm-generic/unistd.h
index f211961ce1..4557a8b608 100644
--- a/linux-headers/asm-generic/unistd.h
+++ b/linux-headers/asm-generic/unistd.h
@@ -673,15 +673,15 @@ __SYSCALL(__NR_madvise, sys_madvise)
 #define __NR_remap_file_pages 234
 __SYSCALL(__NR_remap_file_pages, sys_remap_file_pages)
 #define __NR_mbind 235
-__SC_COMP(__NR_mbind, sys_mbind, compat_sys_mbind)
+__SYSCALL(__NR_mbind, sys_mbind)
 #define __NR_get_mempolicy 236
-__SC_COMP(__NR_get_mempolicy, sys_get_mempolicy, compat_sys_get_mempolicy)
+__SYSCALL(__NR_get_mempolicy, sys_get_mempolicy)
 #define __NR_set_mempolicy 237
-__SC_COMP(__NR_set_mempolicy, sys_set_mempolicy, compat_sys_set_mempolicy)
+__SYSCALL(__NR_set_mempolicy, sys_set_mempolicy)
 #define __NR_migrate_pages 238
-__SC_COMP(__NR_migrate_pages, sys_migrate_pages, compat_sys_migrate_pages)
+__SYSCALL(__NR_migrate_pages, sys_migrate_pages)
 #define __NR_move_pages 239
-__SC_COMP(__NR_move_pages, sys_move_pages, compat_sys_move_pages)
+__SYSCALL(__NR_move_pages, sys_move_pages)
 #endif
 
 #define __NR_rt_tgsigqueueinfo 240
@@ -873,8 +873,18 @@ __SYSCALL(__NR_landlock_add_rule, sys_landlock_add_rule)
 #define __NR_landlock_restrict_self 446
 __SYSCALL(__NR_landlock_restrict_self, sys_landlock_restrict_self)
 
+#ifdef __ARCH_WANT_MEMFD_SECRET
+#define __NR_memfd_secret 447
+__SYSCALL(__NR_memfd_secret, sys_memfd_secret)
+#endif
+#define __NR_process_mrelease 448
+__SYSCALL(__NR_process_mrelease, sys_process_mrelease)
+
+#define __NR_futex_waitv 449
+__SYSCALL(__NR_futex_waitv, sys_futex_waitv)
+
 #undef __NR_syscalls
-#define __NR_syscalls 447
+#define __NR_syscalls 450
 
 /*
  * 32 bit systems traditionally used different
diff --git a/linux-headers/asm-mips/unistd_n32.h b/linux-headers/asm-mips/unistd_n32.h
index 09cd297698..790309211a 100644
--- a/linux-headers/asm-mips/unistd_n32.h
+++ b/linux-headers/asm-mips/unistd_n32.h
@@ -376,5 +376,7 @@
 #define __NR_landlock_create_ruleset (__NR_Linux + 444)
 #define __NR_landlock_add_rule (__NR_Linux + 445)
 #define __NR_landlock_restrict_self (__NR_Linux + 446)
+#define __NR_process_mrelease (__NR_Linux + 448)
+#define __NR_futex_waitv (__NR_Linux + 449)
 
 #endif /* _ASM_UNISTD_N32_H */
diff --git a/linux-headers/asm-mips/unistd_n64.h b/linux-headers/asm-mips/unistd_n64.h
index 780e0cead6..d68a3cc573 100644
--- a/linux-headers/asm-mips/unistd_n64.h
+++ b/linux-headers/asm-mips/unistd_n64.h
@@ -352,5 +352,7 @@
 #define __NR_landlock_create_ruleset (__NR_Linux + 444)
 #define __NR_landlock_add_rule (__NR_Linux + 445)
 #define __NR_landlock_restrict_self (__NR_Linux + 446)
+#define __NR_process_mrelease (__NR_Linux + 448)
+#define __NR_futex_waitv (__NR_Linux + 449)
 
 #endif /* _ASM_UNISTD_N64_H */
diff --git a/linux-headers/asm-mips/unistd_o32.h b/linux-headers/asm-mips/unistd_o32.h
index 06a2b3b55e..18cfa981c7 100644
--- a/linux-headers/asm-mips/unistd_o32.h
+++ b/linux-headers/asm-mips/unistd_o32.h
@@ -422,5 +422,7 @@
 #define __NR_landlock_create_ruleset (__NR_Linux + 444)
 #define __NR_landlock_add_rule (__NR_Linux + 445)
 #define __NR_landlock_restrict_self (__NR_Linux + 446)
+#define __NR_process_mrelease (__NR_Linux + 448)
+#define __NR_futex_waitv (__NR_Linux + 449)
 
 #endif /* _ASM_UNISTD_O32_H */
diff --git a/linux-headers/asm-powerpc/unistd_32.h b/linux-headers/asm-powerpc/unistd_32.h
index cd5a8a41b2..c8a97e6f51 100644
--- a/linux-headers/asm-powerpc/unistd_32.h
+++ b/linux-headers/asm-powerpc/unistd_32.h
@@ -429,6 +429,8 @@
 #define __NR_landlock_create_ruleset 444
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
+#define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-powerpc/unistd_64.h b/linux-headers/asm-powerpc/unistd_64.h
index 8458effa8d..5dd37251b8 100644
--- a/linux-headers/asm-powerpc/unistd_64.h
+++ b/linux-headers/asm-powerpc/unistd_64.h
@@ -401,6 +401,8 @@
 #define __NR_landlock_create_ruleset 444
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
+#define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-s390/kvm.h b/linux-headers/asm-s390/kvm.h
index f053b8304a..d8259ff9a1 100644
--- a/linux-headers/asm-s390/kvm.h
+++ b/linux-headers/asm-s390/kvm.h
@@ -130,6 +130,7 @@ struct kvm_s390_vm_cpu_machine {
 #define KVM_S390_VM_CPU_FEAT_PFMFI	11
 #define KVM_S390_VM_CPU_FEAT_SIGPIF	12
 #define KVM_S390_VM_CPU_FEAT_KSS	13
+#define KVM_S390_VM_CPU_FEAT_ZPCI_INTERP 14
 struct kvm_s390_vm_cpu_feat {
 	__u64 feat[16];
 };
diff --git a/linux-headers/asm-s390/unistd_32.h b/linux-headers/asm-s390/unistd_32.h
index 0c3cd299e4..8c60e40ab1 100644
--- a/linux-headers/asm-s390/unistd_32.h
+++ b/linux-headers/asm-s390/unistd_32.h
@@ -419,5 +419,7 @@
 #define __NR_landlock_create_ruleset 444
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
+#define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
 
 #endif /* _ASM_S390_UNISTD_32_H */
diff --git a/linux-headers/asm-s390/unistd_64.h b/linux-headers/asm-s390/unistd_64.h
index 8dfc08b5e6..5793aa2a83 100644
--- a/linux-headers/asm-s390/unistd_64.h
+++ b/linux-headers/asm-s390/unistd_64.h
@@ -367,5 +367,7 @@
 #define __NR_landlock_create_ruleset 444
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
+#define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
 
 #endif /* _ASM_S390_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index a6c327f8ad..5a776a08f7 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -295,6 +295,7 @@ struct kvm_debug_exit_arch {
 #define KVM_GUESTDBG_USE_HW_BP		0x00020000
 #define KVM_GUESTDBG_INJECT_DB		0x00040000
 #define KVM_GUESTDBG_INJECT_BP		0x00080000
+#define KVM_GUESTDBG_BLOCKIRQ		0x00100000
 
 /* for KVM_SET_GUEST_DEBUG */
 struct kvm_guest_debug_arch {
@@ -503,4 +504,8 @@ struct kvm_pmu_event_filter {
 #define KVM_PMU_EVENT_ALLOW 0
 #define KVM_PMU_EVENT_DENY 1
 
+/* for KVM_{GET,SET,HAS}_DEVICE_ATTR */
+#define KVM_VCPU_TSC_CTRL 0 /* control group for the timestamp counter (TSC) */
+#define   KVM_VCPU_TSC_OFFSET 0 /* attribute for the TSC offset */
+
 #endif /* _ASM_X86_KVM_H */
diff --git a/linux-headers/asm-x86/unistd_32.h b/linux-headers/asm-x86/unistd_32.h
index 66e96c0c68..9c9ffe312b 100644
--- a/linux-headers/asm-x86/unistd_32.h
+++ b/linux-headers/asm-x86/unistd_32.h
@@ -437,6 +437,9 @@
 #define __NR_landlock_create_ruleset 444
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
+#define __NR_memfd_secret 447
+#define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-x86/unistd_64.h b/linux-headers/asm-x86/unistd_64.h
index b8ff6f14ee..084f1eef9c 100644
--- a/linux-headers/asm-x86/unistd_64.h
+++ b/linux-headers/asm-x86/unistd_64.h
@@ -359,6 +359,9 @@
 #define __NR_landlock_create_ruleset 444
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
+#define __NR_memfd_secret 447
+#define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/unistd_x32.h b/linux-headers/asm-x86/unistd_x32.h
index 06a1097c15..a2441affc2 100644
--- a/linux-headers/asm-x86/unistd_x32.h
+++ b/linux-headers/asm-x86/unistd_x32.h
@@ -312,6 +312,9 @@
 #define __NR_landlock_create_ruleset (__X32_SYSCALL_BIT + 444)
 #define __NR_landlock_add_rule (__X32_SYSCALL_BIT + 445)
 #define __NR_landlock_restrict_self (__X32_SYSCALL_BIT + 446)
+#define __NR_memfd_secret (__X32_SYSCALL_BIT + 447)
+#define __NR_process_mrelease (__X32_SYSCALL_BIT + 448)
+#define __NR_futex_waitv (__X32_SYSCALL_BIT + 449)
 #define __NR_rt_sigaction (__X32_SYSCALL_BIT + 512)
 #define __NR_rt_sigreturn (__X32_SYSCALL_BIT + 513)
 #define __NR_ioctl (__X32_SYSCALL_BIT + 514)
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index bcaf66cc4d..f61f357899 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -269,6 +269,7 @@ struct kvm_xen_exit {
 #define KVM_EXIT_AP_RESET_HOLD    32
 #define KVM_EXIT_X86_BUS_LOCK     33
 #define KVM_EXIT_XEN              34
+#define KVM_EXIT_RISCV_SBI        35
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -397,13 +398,23 @@ struct kvm_run {
 		 * "ndata" is correct, that new fields are enumerated in "flags",
 		 * and that each flag enumerates fields that are 64-bit aligned
 		 * and sized (so that ndata+internal.data[] is valid/accurate).
+		 *
+		 * Space beyond the defined fields may be used to store arbitrary
+		 * debug information relating to the emulation failure. It is
+		 * accounted for in "ndata" but the format is unspecified and is
+		 * not represented in "flags". Any such information is *not* ABI!
 		 */
 		struct {
 			__u32 suberror;
 			__u32 ndata;
 			__u64 flags;
-			__u8  insn_size;
-			__u8  insn_bytes[15];
+			union {
+				struct {
+					__u8  insn_size;
+					__u8  insn_bytes[15];
+				};
+			};
+			/* Arbitrary debug data may follow. */
 		} emulation_failure;
 		/* KVM_EXIT_OSI */
 		struct {
@@ -469,6 +480,13 @@ struct kvm_run {
 		} msr;
 		/* KVM_EXIT_XEN */
 		struct kvm_xen_exit xen;
+		/* KVM_EXIT_RISCV_SBI */
+		struct {
+			unsigned long extension_id;
+			unsigned long function_id;
+			unsigned long args[6];
+			unsigned long ret[2];
+		} riscv_sbi;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1112,6 +1130,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1223,11 +1242,16 @@ struct kvm_irqfd {
 
 /* Do not use 1, KVM_CHECK_EXTENSION returned it before we had flags.  */
 #define KVM_CLOCK_TSC_STABLE		2
+#define KVM_CLOCK_REALTIME		(1 << 2)
+#define KVM_CLOCK_HOST_TSC		(1 << 3)
 
 struct kvm_clock_data {
 	__u64 clock;
 	__u32 flags;
-	__u32 pad[9];
+	__u32 pad0;
+	__u64 realtime;
+	__u64 host_tsc;
+	__u32 pad[4];
 };
 
 /* For KVM_CAP_SW_TLB */
@@ -1965,7 +1989,9 @@ struct kvm_stats_header {
 #define KVM_STATS_TYPE_CUMULATIVE	(0x0 << KVM_STATS_TYPE_SHIFT)
 #define KVM_STATS_TYPE_INSTANT		(0x1 << KVM_STATS_TYPE_SHIFT)
 #define KVM_STATS_TYPE_PEAK		(0x2 << KVM_STATS_TYPE_SHIFT)
-#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_PEAK
+#define KVM_STATS_TYPE_LINEAR_HIST	(0x3 << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_LOG_HIST		(0x4 << KVM_STATS_TYPE_SHIFT)
+#define KVM_STATS_TYPE_MAX		KVM_STATS_TYPE_LOG_HIST
 
 #define KVM_STATS_UNIT_SHIFT		4
 #define KVM_STATS_UNIT_MASK		(0xF << KVM_STATS_UNIT_SHIFT)
@@ -1988,8 +2014,9 @@ struct kvm_stats_header {
  * @size: The number of data items for this stats.
  *        Every data item is of type __u64.
  * @offset: The offset of the stats to the start of stat structure in
- *          struture kvm or kvm_vcpu.
- * @unused: Unused field for future usage. Always 0 for now.
+ *          structure kvm or kvm_vcpu.
+ * @bucket_size: A parameter value used for histogram stats. It is only used
+ *		for linear histogram stats, specifying the size of the bucket;
  * @name: The name string for the stats. Its size is indicated by the
  *        &kvm_stats_header->name_size.
  */
@@ -1998,7 +2025,7 @@ struct kvm_stats_desc {
 	__s16 exponent;
 	__u16 size;
 	__u32 offset;
-	__u32 unused;
+	__u32 bucket_size;
 	char name[];
 };
 
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index e680594f27..96b18b872a 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -1002,6 +1002,28 @@ struct vfio_device_feature {
  */
 #define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
 
+/*
+ * Provide support for enabling interpretation of zPCI instructions.  This
+ * feature is only valid for s390x PCI devices.  Data provided when setting
+ * and getting this feature is futher described in vfio_zdev.h
+ */
+#define VFIO_DEVICE_FEATURE_ZPCI_INTERP		(1)
+
+/*
+ * Provide support for enbaling adapter interruption forwarding for zPCI
+ * devices.  This feature is only valid for s390x PCI devices.  Data provided
+ * when setting and getting this feature is further described in vfio_zdev.h
+ */
+#define VFIO_DEVICE_FEATURE_ZPCI_AIF		(2)
+
+/*
+ * Provide support for enabling guest I/O address translation assistance for
+ * zPCI devices.  This feature is only valid for s390x PCI devices.  Data
+ * provided when setting and getting this feature is further described in
+ * vfio_zdev.h
+ */
+#define VFIO_DEVICE_FEATURE_ZPCI_IOAT		(3)
+
 /* -------- API for Type1 VFIO IOMMU -------- */
 
 /**
diff --git a/linux-headers/linux/vfio_zdev.h b/linux-headers/linux/vfio_zdev.h
index b4309397b6..b4c2ba8e71 100644
--- a/linux-headers/linux/vfio_zdev.h
+++ b/linux-headers/linux/vfio_zdev.h
@@ -47,6 +47,9 @@ struct vfio_device_info_cap_zpci_group {
 	__u16 noi;		/* Maximum number of MSIs */
 	__u16 maxstbl;		/* Maximum Store Block Length */
 	__u8 version;		/* Supported PCI Version */
+	/* End of version 1 */
+	__u8 dtsm;		/* Supported IOAT Designations */
+	/* End of version 2 */
 };
 
 /**
@@ -75,4 +78,52 @@ struct vfio_device_info_cap_zpci_pfip {
 	__u8 pfip[];
 };
 
+/**
+ * VFIO_DEVICE_FEATURE_ZPCI_INTERP
+ *
+ * This feature is used for enabling zPCI instruction interpretation for a
+ * device.  No data is provided when setting this feature.  When getting
+ * this feature, the following structure is provided which details whether
+ * or not interpretation is active and provides the guest with host device
+ * information necessary to enable interpretation.
+ */
+struct vfio_device_zpci_interp {
+	__u64 flags;
+#define VFIO_DEVICE_ZPCI_FLAG_INTERP 1
+	__u32 fh;		/* Host device function handle */
+};
+
+/**
+ * VFIO_DEVICE_FEATURE_ZPCI_AIF
+ *
+ * This feature is used for enabling forwarding of adapter interrupts directly
+ * from firmware to the guest.  When setting this feature, the flags indicate
+ * whether to enable/disable the feature and the structure defined below is
+ * used to setup the forwarding structures.  When getting this feature, only
+ * the flags are used to indicate the current state.
+ */
+struct vfio_device_zpci_aif {
+	__u64 flags;
+#define VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT 1
+#define VFIO_DEVICE_ZPCI_FLAG_AIF_HOST 2
+	__u64 ibv;		/* Address of guest interrupt bit vector */
+	__u64 sb;		/* Address of guest summary bit */
+	__u32 noi;		/* Number of interrupts */
+	__u8 isc;		/* Guest interrupt subclass */
+	__u8 sbo;		/* Offset of guest summary bit vector */
+};
+
+/**
+ * VFIO_DEVICE_FEATURE_ZPCI_IOAT
+ *
+ * This feature is used for enabling guest I/O translation assistance for
+ * passthrough zPCI devices using instruction interpretation.  When setting
+ * this feature, the iota specifies a KVM guest I/O translation anchor.  When
+ * getting this feature, the most recently set anchor (or 0) is returned in
+ * iota.
+ */
+struct vfio_device_zpci_ioat {
+	__u64 iota;
+};
+
 #endif
-- 
2.27.0

