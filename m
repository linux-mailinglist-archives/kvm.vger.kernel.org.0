Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B7148F18E
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 21:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240588AbiANUjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 15:39:12 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51556 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240197AbiANUjI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 15:39:08 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20EIwK3n030246;
        Fri, 14 Jan 2022 20:39:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=XaNM1fqmdZcdqWo7Eh3x3bdX8zX9AY1Dk1Z53n5/LB4=;
 b=Cq4E+7K4DOSZKJwC1ESUuB8eNQvyYlzwMYn6i2hSsHCVJoY6itXgXV366OA/o9t9YG0F
 IJ3YVG5rNDzM0/0huDw1HFkkps7tg/u1KjLrBUXuv+Gu4OvsTnKX7k1yEr5vZJLCsM0W
 TIJvx31YlpWtX0PGnmtI1MEJYmzEYRcpkD6OmDvHATbUkVDa7l7QdsJjc3gvauQftPaH
 7ytl2ltcN/B+h9YNlqXqJyIbj/eCtnRgyxQR7nI3tTg72Xx+ps6SvZiOwcGsWeGEykfe
 V4KLVeKTtf99vE+NMyCzcpiNleFEE33e0f2QMN+zDqCRipKR5Z/8cmlBy3MtriCLURgr YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkewyhucm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:39:00 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20EKVhw4029371;
        Fri, 14 Jan 2022 20:39:00 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkewyhuby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:38:59 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20EKLZNb022007;
        Fri, 14 Jan 2022 20:38:58 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04wdc.us.ibm.com with ESMTP id 3df28cqmxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 14 Jan 2022 20:38:58 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20EKcuPV15401596
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jan 2022 20:38:56 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7A99C606E;
        Fri, 14 Jan 2022 20:38:55 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 974FAC605D;
        Fri, 14 Jan 2022 20:38:54 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.65.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jan 2022 20:38:54 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 1/9] Update linux headers
Date:   Fri, 14 Jan 2022 15:38:41 -0500
Message-Id: <20220114203849.243657-2-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220114203849.243657-1-mjrosato@linux.ibm.com>
References: <20220114203849.243657-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4o2kzUgAVFIBehjrWzFVoxoGBt2ih4kX
X-Proofpoint-GUID: B4NeMqn6tgT7dRZXNIVW_pn9qfl1K0Ec
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_06,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 phishscore=0 malwarescore=0 clxscore=1015
 suspectscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 adultscore=0
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201140120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a placeholder that pulls in 5.17 + unmerged kernel changes
required by this item.  A proper header sync can be done once the
associated kernel code merges.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 include/standard-headers/asm-x86/kvm_para.h   |  1 +
 include/standard-headers/drm/drm_fourcc.h     | 11 ++++
 include/standard-headers/linux/ethtool.h      |  1 +
 include/standard-headers/linux/fuse.h         | 60 +++++++++++++++++--
 include/standard-headers/linux/pci_regs.h     |  4 ++
 include/standard-headers/linux/virtio_iommu.h |  8 ++-
 linux-headers/asm-mips/unistd_n32.h           |  1 +
 linux-headers/asm-mips/unistd_n64.h           |  1 +
 linux-headers/asm-mips/unistd_o32.h           |  1 +
 linux-headers/asm-powerpc/unistd_32.h         |  1 +
 linux-headers/asm-powerpc/unistd_64.h         |  1 +
 linux-headers/asm-s390/kvm.h                  |  1 +
 linux-headers/asm-s390/unistd_32.h            |  1 +
 linux-headers/asm-s390/unistd_64.h            |  1 +
 linux-headers/linux/kvm.h                     |  1 +
 linux-headers/linux/vfio.h                    | 22 +++++++
 linux-headers/linux/vfio_zdev.h               | 51 ++++++++++++++++
 17 files changed, 162 insertions(+), 5 deletions(-)

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
index 2c025cb4fe..4888f85f69 100644
--- a/include/standard-headers/drm/drm_fourcc.h
+++ b/include/standard-headers/drm/drm_fourcc.h
@@ -313,6 +313,13 @@ extern "C" {
  */
 #define DRM_FORMAT_P016		fourcc_code('P', '0', '1', '6') /* 2x2 subsampled Cr:Cb plane 16 bits per channel */
 
+/* 2 plane YCbCr420.
+ * 3 10 bit components and 2 padding bits packed into 4 bytes.
+ * index 0 = Y plane, [31:0] x:Y2:Y1:Y0 2:10:10:10 little endian
+ * index 1 = Cr:Cb plane, [63:0] x:Cr2:Cb2:Cr1:x:Cb1:Cr0:Cb0 [2:10:10:10:2:10:10:10] little endian
+ */
+#define DRM_FORMAT_P030		fourcc_code('P', '0', '3', '0') /* 2x2 subsampled Cr:Cb plane 10 bits per channel packed */
+
 /* 3 plane non-subsampled (444) YCbCr
  * 16 bits per component, but only 10 bits are used and 6 bits are padded
  * index 0: Y plane, [15:0] Y:x [10:6] little endian
@@ -853,6 +860,10 @@ drm_fourcc_canonicalize_nvidia_format_mod(uint64_t modifier)
  * and UV.  Some SAND-using hardware stores UV in a separate tiled
  * image from Y to reduce the column height, which is not supported
  * with these modifiers.
+ *
+ * The DRM_FORMAT_MOD_BROADCOM_SAND128_COL_HEIGHT modifier is also
+ * supported for DRM_FORMAT_P030 where the columns remain as 128 bytes
+ * wide, but as this is a 10 bpp format that translates to 96 pixels.
  */
 
 #define DRM_FORMAT_MOD_BROADCOM_SAND32_COL_HEIGHT(v) \
diff --git a/include/standard-headers/linux/ethtool.h b/include/standard-headers/linux/ethtool.h
index 688eb8dc39..38d5a4cd6e 100644
--- a/include/standard-headers/linux/ethtool.h
+++ b/include/standard-headers/linux/ethtool.h
@@ -231,6 +231,7 @@ enum tunable_id {
 	ETHTOOL_RX_COPYBREAK,
 	ETHTOOL_TX_COPYBREAK,
 	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
+	ETHTOOL_TX_COPYBREAK_BUF_SIZE,
 	/*
 	 * Add your fresh new tunable attribute above and remember to update
 	 * tunable_strings[] in net/ethtool/common.c
diff --git a/include/standard-headers/linux/fuse.h b/include/standard-headers/linux/fuse.h
index 23ea31708b..bda06258be 100644
--- a/include/standard-headers/linux/fuse.h
+++ b/include/standard-headers/linux/fuse.h
@@ -184,6 +184,16 @@
  *
  *  7.34
  *  - add FUSE_SYNCFS
+ *
+ *  7.35
+ *  - add FOPEN_NOFLUSH
+ *
+ *  7.36
+ *  - extend fuse_init_in with reserved fields, add FUSE_INIT_EXT init flag
+ *  - add flags2 to fuse_init_in and fuse_init_out
+ *  - add FUSE_SECURITY_CTX init flag
+ *  - add security context to create, mkdir, symlink, and mknod requests
+ *  - add FUSE_HAS_INODE_DAX, FUSE_ATTR_DAX
  */
 
 #ifndef _LINUX_FUSE_H
@@ -215,7 +225,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 34
+#define FUSE_KERNEL_MINOR_VERSION 36
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -286,12 +296,14 @@ struct fuse_file_lock {
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
@@ -332,6 +344,11 @@ struct fuse_file_lock {
  *			write/truncate sgid is killed only if file has group
  *			execute permission. (Same as Linux VFS behavior).
  * FUSE_SETXATTR_EXT:	Server supports extended struct fuse_setxattr_in
+ * FUSE_INIT_EXT: extended fuse_init_in request
+ * FUSE_INIT_RESERVED: reserved, do not use
+ * FUSE_SECURITY_CTX:	add security context to create, mkdir, symlink, and
+ *			mknod
+ * FUSE_HAS_INODE_DAX:  use per inode DAX
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -363,6 +380,11 @@ struct fuse_file_lock {
 #define FUSE_SUBMOUNTS		(1 << 27)
 #define FUSE_HANDLE_KILLPRIV_V2	(1 << 28)
 #define FUSE_SETXATTR_EXT	(1 << 29)
+#define FUSE_INIT_EXT		(1 << 30)
+#define FUSE_INIT_RESERVED	(1 << 31)
+/* bits 32..63 get shifted down 32 bits into the flags2 field */
+#define FUSE_SECURITY_CTX	(1ULL << 32)
+#define FUSE_HAS_INODE_DAX	(1ULL << 33)
 
 /**
  * CUSE INIT request/reply flags
@@ -445,8 +467,10 @@ struct fuse_file_lock {
  * fuse_attr flags
  *
  * FUSE_ATTR_SUBMOUNT: Object is a submount root
+ * FUSE_ATTR_DAX: Enable DAX for this file in per inode DAX mode
  */
 #define FUSE_ATTR_SUBMOUNT      (1 << 0)
+#define FUSE_ATTR_DAX		(1 << 1)
 
 /**
  * Open flags
@@ -732,6 +756,8 @@ struct fuse_init_in {
 	uint32_t	minor;
 	uint32_t	max_readahead;
 	uint32_t	flags;
+	uint32_t	flags2;
+	uint32_t	unused[11];
 };
 
 #define FUSE_COMPAT_INIT_OUT_SIZE 8
@@ -748,7 +774,8 @@ struct fuse_init_out {
 	uint32_t	time_gran;
 	uint16_t	max_pages;
 	uint16_t	map_alignment;
-	uint32_t	unused[8];
+	uint32_t	flags2;
+	uint32_t	unused[7];
 };
 
 #define CUSE_INIT_INFO_MAX 4096
@@ -856,9 +883,12 @@ struct fuse_dirent {
 	char name[];
 };
 
-#define FUSE_NAME_OFFSET offsetof(struct fuse_dirent, name)
-#define FUSE_DIRENT_ALIGN(x) \
+/* Align variable length records to 64bit boundary */
+#define FUSE_REC_ALIGN(x) \
 	(((x) + sizeof(uint64_t) - 1) & ~(sizeof(uint64_t) - 1))
+
+#define FUSE_NAME_OFFSET offsetof(struct fuse_dirent, name)
+#define FUSE_DIRENT_ALIGN(x) FUSE_REC_ALIGN(x)
 #define FUSE_DIRENT_SIZE(d) \
 	FUSE_DIRENT_ALIGN(FUSE_NAME_OFFSET + (d)->namelen)
 
@@ -975,4 +1005,26 @@ struct fuse_syncfs_in {
 	uint64_t	padding;
 };
 
+/*
+ * For each security context, send fuse_secctx with size of security context
+ * fuse_secctx will be followed by security context name and this in turn
+ * will be followed by actual context label.
+ * fuse_secctx, name, context
+ */
+struct fuse_secctx {
+	uint32_t	size;
+	uint32_t	padding;
+};
+
+/*
+ * Contains the information about how many fuse_secctx structures are being
+ * sent and what's the total size of all security contexts (including
+ * size of fuse_secctx_header).
+ *
+ */
+struct fuse_secctx_header {
+	uint32_t	size;
+	uint32_t	nr_secctx;
+};
+
 #endif /* _LINUX_FUSE_H */
diff --git a/include/standard-headers/linux/pci_regs.h b/include/standard-headers/linux/pci_regs.h
index ff6ccbc6ef..318f3f1f9e 100644
--- a/include/standard-headers/linux/pci_regs.h
+++ b/include/standard-headers/linux/pci_regs.h
@@ -1086,7 +1086,11 @@
 
 /* Designated Vendor-Specific (DVSEC, PCI_EXT_CAP_ID_DVSEC) */
 #define PCI_DVSEC_HEADER1		0x4 /* Designated Vendor-Specific Header1 */
+#define  PCI_DVSEC_HEADER1_VID(x)	((x) & 0xffff)
+#define  PCI_DVSEC_HEADER1_REV(x)	(((x) >> 16) & 0xf)
+#define  PCI_DVSEC_HEADER1_LEN(x)	(((x) >> 20) & 0xfff)
 #define PCI_DVSEC_HEADER2		0x8 /* Designated Vendor-Specific Header2 */
+#define  PCI_DVSEC_HEADER2_ID(x)		((x) & 0xffff)
 
 /* Data Link Feature */
 #define PCI_DLF_CAP		0x04	/* Capabilities Register */
diff --git a/include/standard-headers/linux/virtio_iommu.h b/include/standard-headers/linux/virtio_iommu.h
index b9443b83a1..366379c2f0 100644
--- a/include/standard-headers/linux/virtio_iommu.h
+++ b/include/standard-headers/linux/virtio_iommu.h
@@ -16,6 +16,7 @@
 #define VIRTIO_IOMMU_F_BYPASS			3
 #define VIRTIO_IOMMU_F_PROBE			4
 #define VIRTIO_IOMMU_F_MMIO			5
+#define VIRTIO_IOMMU_F_BYPASS_CONFIG		6
 
 struct virtio_iommu_range_64 {
 	uint64_t					start;
@@ -36,6 +37,8 @@ struct virtio_iommu_config {
 	struct virtio_iommu_range_32		domain_range;
 	/* Probe buffer size */
 	uint32_t					probe_size;
+	uint8_t					bypass;
+	uint8_t					reserved[3];
 };
 
 /* Request types */
@@ -66,11 +69,14 @@ struct virtio_iommu_req_tail {
 	uint8_t					reserved[3];
 };
 
+#define VIRTIO_IOMMU_ATTACH_F_BYPASS		(1 << 0)
+
 struct virtio_iommu_req_attach {
 	struct virtio_iommu_req_head		head;
 	uint32_t					domain;
 	uint32_t					endpoint;
-	uint8_t					reserved[8];
+	uint32_t					flags;
+	uint8_t					reserved[4];
 	struct virtio_iommu_req_tail		tail;
 };
 
diff --git a/linux-headers/asm-mips/unistd_n32.h b/linux-headers/asm-mips/unistd_n32.h
index 4b3e7ad1ec..790309211a 100644
--- a/linux-headers/asm-mips/unistd_n32.h
+++ b/linux-headers/asm-mips/unistd_n32.h
@@ -377,5 +377,6 @@
 #define __NR_landlock_add_rule (__NR_Linux + 445)
 #define __NR_landlock_restrict_self (__NR_Linux + 446)
 #define __NR_process_mrelease (__NR_Linux + 448)
+#define __NR_futex_waitv (__NR_Linux + 449)
 
 #endif /* _ASM_UNISTD_N32_H */
diff --git a/linux-headers/asm-mips/unistd_n64.h b/linux-headers/asm-mips/unistd_n64.h
index 488d9298d9..d68a3cc573 100644
--- a/linux-headers/asm-mips/unistd_n64.h
+++ b/linux-headers/asm-mips/unistd_n64.h
@@ -353,5 +353,6 @@
 #define __NR_landlock_add_rule (__NR_Linux + 445)
 #define __NR_landlock_restrict_self (__NR_Linux + 446)
 #define __NR_process_mrelease (__NR_Linux + 448)
+#define __NR_futex_waitv (__NR_Linux + 449)
 
 #endif /* _ASM_UNISTD_N64_H */
diff --git a/linux-headers/asm-mips/unistd_o32.h b/linux-headers/asm-mips/unistd_o32.h
index f47399870a..18cfa981c7 100644
--- a/linux-headers/asm-mips/unistd_o32.h
+++ b/linux-headers/asm-mips/unistd_o32.h
@@ -423,5 +423,6 @@
 #define __NR_landlock_add_rule (__NR_Linux + 445)
 #define __NR_landlock_restrict_self (__NR_Linux + 446)
 #define __NR_process_mrelease (__NR_Linux + 448)
+#define __NR_futex_waitv (__NR_Linux + 449)
 
 #endif /* _ASM_UNISTD_O32_H */
diff --git a/linux-headers/asm-powerpc/unistd_32.h b/linux-headers/asm-powerpc/unistd_32.h
index 11d54696dc..c8a97e6f51 100644
--- a/linux-headers/asm-powerpc/unistd_32.h
+++ b/linux-headers/asm-powerpc/unistd_32.h
@@ -430,6 +430,7 @@
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
 #define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-powerpc/unistd_64.h b/linux-headers/asm-powerpc/unistd_64.h
index cf740bab13..5dd37251b8 100644
--- a/linux-headers/asm-powerpc/unistd_64.h
+++ b/linux-headers/asm-powerpc/unistd_64.h
@@ -402,6 +402,7 @@
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
 #define __NR_process_mrelease 448
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
index 8f97d98128..8c60e40ab1 100644
--- a/linux-headers/asm-s390/unistd_32.h
+++ b/linux-headers/asm-s390/unistd_32.h
@@ -420,5 +420,6 @@
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
 #define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
 
 #endif /* _ASM_S390_UNISTD_32_H */
diff --git a/linux-headers/asm-s390/unistd_64.h b/linux-headers/asm-s390/unistd_64.h
index 021ffc30e6..5793aa2a83 100644
--- a/linux-headers/asm-s390/unistd_64.h
+++ b/linux-headers/asm-s390/unistd_64.h
@@ -368,5 +368,6 @@
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
 #define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
 
 #endif /* _ASM_S390_UNISTD_64_H */
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 02c5e7b7bb..f61f357899 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1130,6 +1130,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
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

