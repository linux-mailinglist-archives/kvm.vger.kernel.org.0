Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9744AA234
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242879AbiBDVT4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:19:56 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:28456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242594AbiBDVTm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Feb 2022 16:19:42 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 214KLDKF009912;
        Fri, 4 Feb 2022 21:19:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=sr813gsL2J9nI0eE5YMrwHQgKrtLt2GAzPTu0hMe2VA=;
 b=kbDRHjuEIHFrXG5tq0kYyivgpAYdarG2kMbjHQ40iL1ld3oj9QxiCiZ7Ih90cDxg9OQ2
 evncm2Wbi1BNhzoSU0ShZFOsiujwSAh1P+eS6wj3D4dP5TwuKhZLPmOv3O2BQEM3uYpp
 ZQ57ZxU3jmmj4dyijaXMifEQZJtWKF/1X5bLwxrw7suP+hT/uq79nCsZKUAIaqiQHc4K
 AhktjbdrI6sQRIYuHv5I2b5au81oZs1Yt1qdBpuvBWTyNUmMeybcvp30GU2akiOBYrEI
 8xCj6pkpj08kzIvi5YVNYQRmpHaA6SFOQhfWmDAwNg6NTXxNK3mxshEGrlnDFeBB8nrL vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx4739e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:33 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 214LIosS030207;
        Fri, 4 Feb 2022 21:19:32 GMT
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e0qx4738r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:32 +0000
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 214LDNd2006266;
        Fri, 4 Feb 2022 21:19:31 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03wdc.us.ibm.com with ESMTP id 3e0r0yayj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Feb 2022 21:19:31 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 214LJRKT22479148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Feb 2022 21:19:27 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 249D3C605D;
        Fri,  4 Feb 2022 21:19:27 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7130BC6055;
        Fri,  4 Feb 2022 21:19:25 +0000 (GMT)
Received: from li-c92d2ccc-254b-11b2-a85c-a700b5bfb098.ibm.com.com (unknown [9.211.82.52])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  4 Feb 2022 21:19:25 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        pmorel@linux.ibm.com, richard.henderson@linaro.org,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@linux.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH v3 1/8] Update linux headers
Date:   Fri,  4 Feb 2022 16:19:11 -0500
Message-Id: <20220204211918.321924-2-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220204211918.321924-1-mjrosato@linux.ibm.com>
References: <20220204211918.321924-1-mjrosato@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _x8y1afmY5K__ZDZRktnMijtfylKGjE5
X-Proofpoint-GUID: uGuSRZBWh5_YWvRQUAKnfGGFtWydlY4F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-04_07,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 clxscore=1015 impostorscore=0 adultscore=0
 mlxscore=0 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202040117
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a placeholder that pulls in 5.17-rc2 + unmerged kernel changes
required by this item.  A proper header sync can be done once the
associated kernel code merges.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 include/standard-headers/asm-x86/kvm_para.h   |   1 +
 include/standard-headers/drm/drm_fourcc.h     |  11 ++
 include/standard-headers/linux/ethtool.h      |   1 +
 include/standard-headers/linux/fuse.h         |  60 +++++++-
 include/standard-headers/linux/pci_regs.h     | 142 +++++++++---------
 include/standard-headers/linux/virtio_iommu.h |   8 +-
 linux-headers/asm-generic/unistd.h            |   5 +-
 linux-headers/asm-mips/unistd_n32.h           |   2 +
 linux-headers/asm-mips/unistd_n64.h           |   2 +
 linux-headers/asm-mips/unistd_o32.h           |   2 +
 linux-headers/asm-powerpc/unistd_32.h         |   2 +
 linux-headers/asm-powerpc/unistd_64.h         |   2 +
 linux-headers/asm-s390/kvm.h                  |   1 +
 linux-headers/asm-s390/unistd_32.h            |   2 +
 linux-headers/asm-s390/unistd_64.h            |   2 +
 linux-headers/asm-x86/kvm.h                   |  19 ++-
 linux-headers/asm-x86/unistd_32.h             |   1 +
 linux-headers/asm-x86/unistd_64.h             |   1 +
 linux-headers/asm-x86/unistd_x32.h            |   1 +
 linux-headers/linux/kvm.h                     |  18 +++
 linux-headers/linux/vfio.h                    |  22 +++
 linux-headers/linux/vfio_zdev.h               |  51 +++++++
 22 files changed, 280 insertions(+), 76 deletions(-)

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
index ff6ccbc6ef..bee1a9ed6e 100644
--- a/include/standard-headers/linux/pci_regs.h
+++ b/include/standard-headers/linux/pci_regs.h
@@ -301,23 +301,23 @@
 #define  PCI_SID_ESR_FIC	0x20	/* First In Chassis Flag */
 #define PCI_SID_CHASSIS_NR	3	/* Chassis Number */
 
-/* Message Signalled Interrupt registers */
+/* Message Signaled Interrupt registers */
 
-#define PCI_MSI_FLAGS		2	/* Message Control */
+#define PCI_MSI_FLAGS		0x02	/* Message Control */
 #define  PCI_MSI_FLAGS_ENABLE	0x0001	/* MSI feature enabled */
 #define  PCI_MSI_FLAGS_QMASK	0x000e	/* Maximum queue size available */
 #define  PCI_MSI_FLAGS_QSIZE	0x0070	/* Message queue size configured */
 #define  PCI_MSI_FLAGS_64BIT	0x0080	/* 64-bit addresses allowed */
 #define  PCI_MSI_FLAGS_MASKBIT	0x0100	/* Per-vector masking capable */
 #define PCI_MSI_RFU		3	/* Rest of capability flags */
-#define PCI_MSI_ADDRESS_LO	4	/* Lower 32 bits */
-#define PCI_MSI_ADDRESS_HI	8	/* Upper 32 bits (if PCI_MSI_FLAGS_64BIT set) */
-#define PCI_MSI_DATA_32		8	/* 16 bits of data for 32-bit devices */
-#define PCI_MSI_MASK_32		12	/* Mask bits register for 32-bit devices */
-#define PCI_MSI_PENDING_32	16	/* Pending intrs for 32-bit devices */
-#define PCI_MSI_DATA_64		12	/* 16 bits of data for 64-bit devices */
-#define PCI_MSI_MASK_64		16	/* Mask bits register for 64-bit devices */
-#define PCI_MSI_PENDING_64	20	/* Pending intrs for 64-bit devices */
+#define PCI_MSI_ADDRESS_LO	0x04	/* Lower 32 bits */
+#define PCI_MSI_ADDRESS_HI	0x08	/* Upper 32 bits (if PCI_MSI_FLAGS_64BIT set) */
+#define PCI_MSI_DATA_32		0x08	/* 16 bits of data for 32-bit devices */
+#define PCI_MSI_MASK_32		0x0c	/* Mask bits register for 32-bit devices */
+#define PCI_MSI_PENDING_32	0x10	/* Pending intrs for 32-bit devices */
+#define PCI_MSI_DATA_64		0x0c	/* 16 bits of data for 64-bit devices */
+#define PCI_MSI_MASK_64		0x10	/* Mask bits register for 64-bit devices */
+#define PCI_MSI_PENDING_64	0x14	/* Pending intrs for 64-bit devices */
 
 /* MSI-X registers (in MSI-X capability) */
 #define PCI_MSIX_FLAGS		2	/* Message Control */
@@ -335,10 +335,10 @@
 
 /* MSI-X Table entry format (in memory mapped by a BAR) */
 #define PCI_MSIX_ENTRY_SIZE		16
-#define PCI_MSIX_ENTRY_LOWER_ADDR	0  /* Message Address */
-#define PCI_MSIX_ENTRY_UPPER_ADDR	4  /* Message Upper Address */
-#define PCI_MSIX_ENTRY_DATA		8  /* Message Data */
-#define PCI_MSIX_ENTRY_VECTOR_CTRL	12 /* Vector Control */
+#define PCI_MSIX_ENTRY_LOWER_ADDR	0x0  /* Message Address */
+#define PCI_MSIX_ENTRY_UPPER_ADDR	0x4  /* Message Upper Address */
+#define PCI_MSIX_ENTRY_DATA		0x8  /* Message Data */
+#define PCI_MSIX_ENTRY_VECTOR_CTRL	0xc  /* Vector Control */
 #define  PCI_MSIX_ENTRY_CTRL_MASKBIT	0x00000001
 
 /* CompactPCI Hotswap Register */
@@ -470,7 +470,7 @@
 
 /* PCI Express capability registers */
 
-#define PCI_EXP_FLAGS		2	/* Capabilities register */
+#define PCI_EXP_FLAGS		0x02	/* Capabilities register */
 #define  PCI_EXP_FLAGS_VERS	0x000f	/* Capability version */
 #define  PCI_EXP_FLAGS_TYPE	0x00f0	/* Device/Port type */
 #define   PCI_EXP_TYPE_ENDPOINT	   0x0	/* Express Endpoint */
@@ -484,7 +484,7 @@
 #define   PCI_EXP_TYPE_RC_EC	   0xa	/* Root Complex Event Collector */
 #define  PCI_EXP_FLAGS_SLOT	0x0100	/* Slot implemented */
 #define  PCI_EXP_FLAGS_IRQ	0x3e00	/* Interrupt message number */
-#define PCI_EXP_DEVCAP		4	/* Device capabilities */
+#define PCI_EXP_DEVCAP		0x04	/* Device capabilities */
 #define  PCI_EXP_DEVCAP_PAYLOAD	0x00000007 /* Max_Payload_Size */
 #define  PCI_EXP_DEVCAP_PHANTOM	0x00000018 /* Phantom functions */
 #define  PCI_EXP_DEVCAP_EXT_TAG	0x00000020 /* Extended tags */
@@ -497,7 +497,7 @@
 #define  PCI_EXP_DEVCAP_PWR_VAL	0x03fc0000 /* Slot Power Limit Value */
 #define  PCI_EXP_DEVCAP_PWR_SCL	0x0c000000 /* Slot Power Limit Scale */
 #define  PCI_EXP_DEVCAP_FLR     0x10000000 /* Function Level Reset */
-#define PCI_EXP_DEVCTL		8	/* Device Control */
+#define PCI_EXP_DEVCTL		0x08	/* Device Control */
 #define  PCI_EXP_DEVCTL_CERE	0x0001	/* Correctable Error Reporting En. */
 #define  PCI_EXP_DEVCTL_NFERE	0x0002	/* Non-Fatal Error Reporting Enable */
 #define  PCI_EXP_DEVCTL_FERE	0x0004	/* Fatal Error Reporting Enable */
@@ -522,7 +522,7 @@
 #define  PCI_EXP_DEVCTL_READRQ_2048B 0x4000 /* 2048 Bytes */
 #define  PCI_EXP_DEVCTL_READRQ_4096B 0x5000 /* 4096 Bytes */
 #define  PCI_EXP_DEVCTL_BCR_FLR 0x8000  /* Bridge Configuration Retry / FLR */
-#define PCI_EXP_DEVSTA		10	/* Device Status */
+#define PCI_EXP_DEVSTA		0x0a	/* Device Status */
 #define  PCI_EXP_DEVSTA_CED	0x0001	/* Correctable Error Detected */
 #define  PCI_EXP_DEVSTA_NFED	0x0002	/* Non-Fatal Error Detected */
 #define  PCI_EXP_DEVSTA_FED	0x0004	/* Fatal Error Detected */
@@ -530,7 +530,7 @@
 #define  PCI_EXP_DEVSTA_AUXPD	0x0010	/* AUX Power Detected */
 #define  PCI_EXP_DEVSTA_TRPND	0x0020	/* Transactions Pending */
 #define PCI_CAP_EXP_RC_ENDPOINT_SIZEOF_V1	12	/* v1 endpoints without link end here */
-#define PCI_EXP_LNKCAP		12	/* Link Capabilities */
+#define PCI_EXP_LNKCAP		0x0c	/* Link Capabilities */
 #define  PCI_EXP_LNKCAP_SLS	0x0000000f /* Supported Link Speeds */
 #define  PCI_EXP_LNKCAP_SLS_2_5GB 0x00000001 /* LNKCAP2 SLS Vector bit 0 */
 #define  PCI_EXP_LNKCAP_SLS_5_0GB 0x00000002 /* LNKCAP2 SLS Vector bit 1 */
@@ -549,7 +549,7 @@
 #define  PCI_EXP_LNKCAP_DLLLARC	0x00100000 /* Data Link Layer Link Active Reporting Capable */
 #define  PCI_EXP_LNKCAP_LBNC	0x00200000 /* Link Bandwidth Notification Capability */
 #define  PCI_EXP_LNKCAP_PN	0xff000000 /* Port Number */
-#define PCI_EXP_LNKCTL		16	/* Link Control */
+#define PCI_EXP_LNKCTL		0x10	/* Link Control */
 #define  PCI_EXP_LNKCTL_ASPMC	0x0003	/* ASPM Control */
 #define  PCI_EXP_LNKCTL_ASPM_L0S 0x0001	/* L0s Enable */
 #define  PCI_EXP_LNKCTL_ASPM_L1  0x0002	/* L1 Enable */
@@ -562,7 +562,7 @@
 #define  PCI_EXP_LNKCTL_HAWD	0x0200	/* Hardware Autonomous Width Disable */
 #define  PCI_EXP_LNKCTL_LBMIE	0x0400	/* Link Bandwidth Management Interrupt Enable */
 #define  PCI_EXP_LNKCTL_LABIE	0x0800	/* Link Autonomous Bandwidth Interrupt Enable */
-#define PCI_EXP_LNKSTA		18	/* Link Status */
+#define PCI_EXP_LNKSTA		0x12	/* Link Status */
 #define  PCI_EXP_LNKSTA_CLS	0x000f	/* Current Link Speed */
 #define  PCI_EXP_LNKSTA_CLS_2_5GB 0x0001 /* Current Link Speed 2.5GT/s */
 #define  PCI_EXP_LNKSTA_CLS_5_0GB 0x0002 /* Current Link Speed 5.0GT/s */
@@ -582,7 +582,7 @@
 #define  PCI_EXP_LNKSTA_LBMS	0x4000	/* Link Bandwidth Management Status */
 #define  PCI_EXP_LNKSTA_LABS	0x8000	/* Link Autonomous Bandwidth Status */
 #define PCI_CAP_EXP_ENDPOINT_SIZEOF_V1	20	/* v1 endpoints with link end here */
-#define PCI_EXP_SLTCAP		20	/* Slot Capabilities */
+#define PCI_EXP_SLTCAP		0x14	/* Slot Capabilities */
 #define  PCI_EXP_SLTCAP_ABP	0x00000001 /* Attention Button Present */
 #define  PCI_EXP_SLTCAP_PCP	0x00000002 /* Power Controller Present */
 #define  PCI_EXP_SLTCAP_MRLSP	0x00000004 /* MRL Sensor Present */
@@ -595,7 +595,7 @@
 #define  PCI_EXP_SLTCAP_EIP	0x00020000 /* Electromechanical Interlock Present */
 #define  PCI_EXP_SLTCAP_NCCS	0x00040000 /* No Command Completed Support */
 #define  PCI_EXP_SLTCAP_PSN	0xfff80000 /* Physical Slot Number */
-#define PCI_EXP_SLTCTL		24	/* Slot Control */
+#define PCI_EXP_SLTCTL		0x18	/* Slot Control */
 #define  PCI_EXP_SLTCTL_ABPE	0x0001	/* Attention Button Pressed Enable */
 #define  PCI_EXP_SLTCTL_PFDE	0x0002	/* Power Fault Detected Enable */
 #define  PCI_EXP_SLTCTL_MRLSCE	0x0004	/* MRL Sensor Changed Enable */
@@ -617,7 +617,7 @@
 #define  PCI_EXP_SLTCTL_EIC	0x0800	/* Electromechanical Interlock Control */
 #define  PCI_EXP_SLTCTL_DLLSCE	0x1000	/* Data Link Layer State Changed Enable */
 #define  PCI_EXP_SLTCTL_IBPD_DISABLE	0x4000 /* In-band PD disable */
-#define PCI_EXP_SLTSTA		26	/* Slot Status */
+#define PCI_EXP_SLTSTA		0x1a	/* Slot Status */
 #define  PCI_EXP_SLTSTA_ABP	0x0001	/* Attention Button Pressed */
 #define  PCI_EXP_SLTSTA_PFD	0x0002	/* Power Fault Detected */
 #define  PCI_EXP_SLTSTA_MRLSC	0x0004	/* MRL Sensor Changed */
@@ -627,15 +627,15 @@
 #define  PCI_EXP_SLTSTA_PDS	0x0040	/* Presence Detect State */
 #define  PCI_EXP_SLTSTA_EIS	0x0080	/* Electromechanical Interlock Status */
 #define  PCI_EXP_SLTSTA_DLLSC	0x0100	/* Data Link Layer State Changed */
-#define PCI_EXP_RTCTL		28	/* Root Control */
+#define PCI_EXP_RTCTL		0x1c	/* Root Control */
 #define  PCI_EXP_RTCTL_SECEE	0x0001	/* System Error on Correctable Error */
 #define  PCI_EXP_RTCTL_SENFEE	0x0002	/* System Error on Non-Fatal Error */
 #define  PCI_EXP_RTCTL_SEFEE	0x0004	/* System Error on Fatal Error */
 #define  PCI_EXP_RTCTL_PMEIE	0x0008	/* PME Interrupt Enable */
 #define  PCI_EXP_RTCTL_CRSSVE	0x0010	/* CRS Software Visibility Enable */
-#define PCI_EXP_RTCAP		30	/* Root Capabilities */
+#define PCI_EXP_RTCAP		0x1e	/* Root Capabilities */
 #define  PCI_EXP_RTCAP_CRSVIS	0x0001	/* CRS Software Visibility capability */
-#define PCI_EXP_RTSTA		32	/* Root Status */
+#define PCI_EXP_RTSTA		0x20	/* Root Status */
 #define  PCI_EXP_RTSTA_PME	0x00010000 /* PME status */
 #define  PCI_EXP_RTSTA_PENDING	0x00020000 /* PME pending */
 /*
@@ -646,7 +646,7 @@
  * Use pcie_capability_read_word() and similar interfaces to use them
  * safely.
  */
-#define PCI_EXP_DEVCAP2		36	/* Device Capabilities 2 */
+#define PCI_EXP_DEVCAP2		0x24	/* Device Capabilities 2 */
 #define  PCI_EXP_DEVCAP2_COMP_TMOUT_DIS	0x00000010 /* Completion Timeout Disable supported */
 #define  PCI_EXP_DEVCAP2_ARI		0x00000020 /* Alternative Routing-ID */
 #define  PCI_EXP_DEVCAP2_ATOMIC_ROUTE	0x00000040 /* Atomic Op routing */
@@ -658,7 +658,7 @@
 #define  PCI_EXP_DEVCAP2_OBFF_MSG	0x00040000 /* New message signaling */
 #define  PCI_EXP_DEVCAP2_OBFF_WAKE	0x00080000 /* Re-use WAKE# for OBFF */
 #define  PCI_EXP_DEVCAP2_EE_PREFIX	0x00200000 /* End-End TLP Prefix */
-#define PCI_EXP_DEVCTL2		40	/* Device Control 2 */
+#define PCI_EXP_DEVCTL2		0x28	/* Device Control 2 */
 #define  PCI_EXP_DEVCTL2_COMP_TIMEOUT	0x000f	/* Completion Timeout Value */
 #define  PCI_EXP_DEVCTL2_COMP_TMOUT_DIS	0x0010	/* Completion Timeout Disable */
 #define  PCI_EXP_DEVCTL2_ARI		0x0020	/* Alternative Routing-ID */
@@ -670,9 +670,9 @@
 #define  PCI_EXP_DEVCTL2_OBFF_MSGA_EN	0x2000	/* Enable OBFF Message type A */
 #define  PCI_EXP_DEVCTL2_OBFF_MSGB_EN	0x4000	/* Enable OBFF Message type B */
 #define  PCI_EXP_DEVCTL2_OBFF_WAKE_EN	0x6000	/* OBFF using WAKE# signaling */
-#define PCI_EXP_DEVSTA2		42	/* Device Status 2 */
-#define PCI_CAP_EXP_RC_ENDPOINT_SIZEOF_V2	44	/* v2 endpoints without link end here */
-#define PCI_EXP_LNKCAP2		44	/* Link Capabilities 2 */
+#define PCI_EXP_DEVSTA2		0x2a	/* Device Status 2 */
+#define PCI_CAP_EXP_RC_ENDPOINT_SIZEOF_V2 0x2c	/* end of v2 EPs w/o link */
+#define PCI_EXP_LNKCAP2		0x2c	/* Link Capabilities 2 */
 #define  PCI_EXP_LNKCAP2_SLS_2_5GB	0x00000002 /* Supported Speed 2.5GT/s */
 #define  PCI_EXP_LNKCAP2_SLS_5_0GB	0x00000004 /* Supported Speed 5GT/s */
 #define  PCI_EXP_LNKCAP2_SLS_8_0GB	0x00000008 /* Supported Speed 8GT/s */
@@ -680,7 +680,7 @@
 #define  PCI_EXP_LNKCAP2_SLS_32_0GB	0x00000020 /* Supported Speed 32GT/s */
 #define  PCI_EXP_LNKCAP2_SLS_64_0GB	0x00000040 /* Supported Speed 64GT/s */
 #define  PCI_EXP_LNKCAP2_CROSSLINK	0x00000100 /* Crosslink supported */
-#define PCI_EXP_LNKCTL2		48	/* Link Control 2 */
+#define PCI_EXP_LNKCTL2		0x30	/* Link Control 2 */
 #define  PCI_EXP_LNKCTL2_TLS		0x000f
 #define  PCI_EXP_LNKCTL2_TLS_2_5GT	0x0001 /* Supported Speed 2.5GT/s */
 #define  PCI_EXP_LNKCTL2_TLS_5_0GT	0x0002 /* Supported Speed 5GT/s */
@@ -691,12 +691,12 @@
 #define  PCI_EXP_LNKCTL2_ENTER_COMP	0x0010 /* Enter Compliance */
 #define  PCI_EXP_LNKCTL2_TX_MARGIN	0x0380 /* Transmit Margin */
 #define  PCI_EXP_LNKCTL2_HASD		0x0020 /* HW Autonomous Speed Disable */
-#define PCI_EXP_LNKSTA2		50	/* Link Status 2 */
-#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	52	/* v2 endpoints with link end here */
-#define PCI_EXP_SLTCAP2		52	/* Slot Capabilities 2 */
+#define PCI_EXP_LNKSTA2		0x32	/* Link Status 2 */
+#define PCI_CAP_EXP_ENDPOINT_SIZEOF_V2	0x32	/* end of v2 EPs w/ link */
+#define PCI_EXP_SLTCAP2		0x34	/* Slot Capabilities 2 */
 #define  PCI_EXP_SLTCAP2_IBPD	0x00000001 /* In-band PD Disable Supported */
-#define PCI_EXP_SLTCTL2		56	/* Slot Control 2 */
-#define PCI_EXP_SLTSTA2		58	/* Slot Status 2 */
+#define PCI_EXP_SLTCTL2		0x38	/* Slot Control 2 */
+#define PCI_EXP_SLTSTA2		0x3a	/* Slot Status 2 */
 
 /* Extended Capabilities (PCI-X 2.0 and Express) */
 #define PCI_EXT_CAP_ID(header)		(header & 0x0000ffff)
@@ -742,7 +742,7 @@
 #define PCI_EXT_CAP_MCAST_ENDPOINT_SIZEOF 40
 
 /* Advanced Error Reporting */
-#define PCI_ERR_UNCOR_STATUS	4	/* Uncorrectable Error Status */
+#define PCI_ERR_UNCOR_STATUS	0x04	/* Uncorrectable Error Status */
 #define  PCI_ERR_UNC_UND	0x00000001	/* Undefined */
 #define  PCI_ERR_UNC_DLP	0x00000010	/* Data Link Protocol */
 #define  PCI_ERR_UNC_SURPDN	0x00000020	/* Surprise Down */
@@ -760,11 +760,11 @@
 #define  PCI_ERR_UNC_MCBTLP	0x00800000	/* MC blocked TLP */
 #define  PCI_ERR_UNC_ATOMEG	0x01000000	/* Atomic egress blocked */
 #define  PCI_ERR_UNC_TLPPRE	0x02000000	/* TLP prefix blocked */
-#define PCI_ERR_UNCOR_MASK	8	/* Uncorrectable Error Mask */
+#define PCI_ERR_UNCOR_MASK	0x08	/* Uncorrectable Error Mask */
 	/* Same bits as above */
-#define PCI_ERR_UNCOR_SEVER	12	/* Uncorrectable Error Severity */
+#define PCI_ERR_UNCOR_SEVER	0x0c	/* Uncorrectable Error Severity */
 	/* Same bits as above */
-#define PCI_ERR_COR_STATUS	16	/* Correctable Error Status */
+#define PCI_ERR_COR_STATUS	0x10	/* Correctable Error Status */
 #define  PCI_ERR_COR_RCVR	0x00000001	/* Receiver Error Status */
 #define  PCI_ERR_COR_BAD_TLP	0x00000040	/* Bad TLP Status */
 #define  PCI_ERR_COR_BAD_DLLP	0x00000080	/* Bad DLLP Status */
@@ -773,20 +773,20 @@
 #define  PCI_ERR_COR_ADV_NFAT	0x00002000	/* Advisory Non-Fatal */
 #define  PCI_ERR_COR_INTERNAL	0x00004000	/* Corrected Internal */
 #define  PCI_ERR_COR_LOG_OVER	0x00008000	/* Header Log Overflow */
-#define PCI_ERR_COR_MASK	20	/* Correctable Error Mask */
+#define PCI_ERR_COR_MASK	0x14	/* Correctable Error Mask */
 	/* Same bits as above */
-#define PCI_ERR_CAP		24	/* Advanced Error Capabilities */
-#define  PCI_ERR_CAP_FEP(x)	((x) & 31)	/* First Error Pointer */
+#define PCI_ERR_CAP		0x18	/* Advanced Error Capabilities & Ctrl*/
+#define  PCI_ERR_CAP_FEP(x)	((x) & 0x1f)	/* First Error Pointer */
 #define  PCI_ERR_CAP_ECRC_GENC	0x00000020	/* ECRC Generation Capable */
 #define  PCI_ERR_CAP_ECRC_GENE	0x00000040	/* ECRC Generation Enable */
 #define  PCI_ERR_CAP_ECRC_CHKC	0x00000080	/* ECRC Check Capable */
 #define  PCI_ERR_CAP_ECRC_CHKE	0x00000100	/* ECRC Check Enable */
-#define PCI_ERR_HEADER_LOG	28	/* Header Log Register (16 bytes) */
-#define PCI_ERR_ROOT_COMMAND	44	/* Root Error Command */
+#define PCI_ERR_HEADER_LOG	0x1c	/* Header Log Register (16 bytes) */
+#define PCI_ERR_ROOT_COMMAND	0x2c	/* Root Error Command */
 #define  PCI_ERR_ROOT_CMD_COR_EN	0x00000001 /* Correctable Err Reporting Enable */
 #define  PCI_ERR_ROOT_CMD_NONFATAL_EN	0x00000002 /* Non-Fatal Err Reporting Enable */
 #define  PCI_ERR_ROOT_CMD_FATAL_EN	0x00000004 /* Fatal Err Reporting Enable */
-#define PCI_ERR_ROOT_STATUS	48
+#define PCI_ERR_ROOT_STATUS	0x30
 #define  PCI_ERR_ROOT_COR_RCV		0x00000001 /* ERR_COR Received */
 #define  PCI_ERR_ROOT_MULTI_COR_RCV	0x00000002 /* Multiple ERR_COR */
 #define  PCI_ERR_ROOT_UNCOR_RCV		0x00000004 /* ERR_FATAL/NONFATAL */
@@ -795,52 +795,52 @@
 #define  PCI_ERR_ROOT_NONFATAL_RCV	0x00000020 /* Non-Fatal Received */
 #define  PCI_ERR_ROOT_FATAL_RCV		0x00000040 /* Fatal Received */
 #define  PCI_ERR_ROOT_AER_IRQ		0xf8000000 /* Advanced Error Interrupt Message Number */
-#define PCI_ERR_ROOT_ERR_SRC	52	/* Error Source Identification */
+#define PCI_ERR_ROOT_ERR_SRC	0x34	/* Error Source Identification */
 
 /* Virtual Channel */
-#define PCI_VC_PORT_CAP1	4
+#define PCI_VC_PORT_CAP1	0x04
 #define  PCI_VC_CAP1_EVCC	0x00000007	/* extended VC count */
 #define  PCI_VC_CAP1_LPEVCC	0x00000070	/* low prio extended VC count */
 #define  PCI_VC_CAP1_ARB_SIZE	0x00000c00
-#define PCI_VC_PORT_CAP2	8
+#define PCI_VC_PORT_CAP2	0x08
 #define  PCI_VC_CAP2_32_PHASE		0x00000002
 #define  PCI_VC_CAP2_64_PHASE		0x00000004
 #define  PCI_VC_CAP2_128_PHASE		0x00000008
 #define  PCI_VC_CAP2_ARB_OFF		0xff000000
-#define PCI_VC_PORT_CTRL	12
+#define PCI_VC_PORT_CTRL	0x0c
 #define  PCI_VC_PORT_CTRL_LOAD_TABLE	0x00000001
-#define PCI_VC_PORT_STATUS	14
+#define PCI_VC_PORT_STATUS	0x0e
 #define  PCI_VC_PORT_STATUS_TABLE	0x00000001
-#define PCI_VC_RES_CAP		16
+#define PCI_VC_RES_CAP		0x10
 #define  PCI_VC_RES_CAP_32_PHASE	0x00000002
 #define  PCI_VC_RES_CAP_64_PHASE	0x00000004
 #define  PCI_VC_RES_CAP_128_PHASE	0x00000008
 #define  PCI_VC_RES_CAP_128_PHASE_TB	0x00000010
 #define  PCI_VC_RES_CAP_256_PHASE	0x00000020
 #define  PCI_VC_RES_CAP_ARB_OFF		0xff000000
-#define PCI_VC_RES_CTRL		20
+#define PCI_VC_RES_CTRL		0x14
 #define  PCI_VC_RES_CTRL_LOAD_TABLE	0x00010000
 #define  PCI_VC_RES_CTRL_ARB_SELECT	0x000e0000
 #define  PCI_VC_RES_CTRL_ID		0x07000000
 #define  PCI_VC_RES_CTRL_ENABLE		0x80000000
-#define PCI_VC_RES_STATUS	26
+#define PCI_VC_RES_STATUS	0x1a
 #define  PCI_VC_RES_STATUS_TABLE	0x00000001
 #define  PCI_VC_RES_STATUS_NEGO		0x00000002
 #define PCI_CAP_VC_BASE_SIZEOF		0x10
-#define PCI_CAP_VC_PER_VC_SIZEOF	0x0C
+#define PCI_CAP_VC_PER_VC_SIZEOF	0x0c
 
 /* Power Budgeting */
-#define PCI_PWR_DSR		4	/* Data Select Register */
-#define PCI_PWR_DATA		8	/* Data Register */
+#define PCI_PWR_DSR		0x04	/* Data Select Register */
+#define PCI_PWR_DATA		0x08	/* Data Register */
 #define  PCI_PWR_DATA_BASE(x)	((x) & 0xff)	    /* Base Power */
 #define  PCI_PWR_DATA_SCALE(x)	(((x) >> 8) & 3)    /* Data Scale */
 #define  PCI_PWR_DATA_PM_SUB(x)	(((x) >> 10) & 7)   /* PM Sub State */
 #define  PCI_PWR_DATA_PM_STATE(x) (((x) >> 13) & 3) /* PM State */
 #define  PCI_PWR_DATA_TYPE(x)	(((x) >> 15) & 7)   /* Type */
 #define  PCI_PWR_DATA_RAIL(x)	(((x) >> 18) & 7)   /* Power Rail */
-#define PCI_PWR_CAP		12	/* Capability */
+#define PCI_PWR_CAP		0x0c	/* Capability */
 #define  PCI_PWR_CAP_BUDGET(x)	((x) & 1)	/* Included in system budget */
-#define PCI_EXT_CAP_PWR_SIZEOF	16
+#define PCI_EXT_CAP_PWR_SIZEOF	0x10
 
 /* Root Complex Event Collector Endpoint Association  */
 #define PCI_RCEC_RCIEP_BITMAP	4	/* Associated Bitmap for RCiEPs */
@@ -964,7 +964,7 @@
 #define  PCI_SRIOV_VFM_MI	0x1	/* Dormant.MigrateIn */
 #define  PCI_SRIOV_VFM_MO	0x2	/* Active.MigrateOut */
 #define  PCI_SRIOV_VFM_AV	0x3	/* Active.Available */
-#define PCI_EXT_CAP_SRIOV_SIZEOF 64
+#define PCI_EXT_CAP_SRIOV_SIZEOF 0x40
 
 #define PCI_LTR_MAX_SNOOP_LAT	0x4
 #define PCI_LTR_MAX_NOSNOOP_LAT	0x6
@@ -1017,12 +1017,12 @@
 #define   PCI_TPH_LOC_NONE	0x000	/* no location */
 #define   PCI_TPH_LOC_CAP	0x200	/* in capability */
 #define   PCI_TPH_LOC_MSIX	0x400	/* in MSI-X */
-#define PCI_TPH_CAP_ST_MASK	0x07FF0000	/* st table mask */
-#define PCI_TPH_CAP_ST_SHIFT	16	/* st table shift */
-#define PCI_TPH_BASE_SIZEOF	12	/* size with no st table */
+#define PCI_TPH_CAP_ST_MASK	0x07FF0000	/* ST table mask */
+#define PCI_TPH_CAP_ST_SHIFT	16	/* ST table shift */
+#define PCI_TPH_BASE_SIZEOF	0xc	/* size with no ST table */
 
 /* Downstream Port Containment */
-#define PCI_EXP_DPC_CAP			4	/* DPC Capability */
+#define PCI_EXP_DPC_CAP			0x04	/* DPC Capability */
 #define PCI_EXP_DPC_IRQ			0x001F	/* Interrupt Message Number */
 #define  PCI_EXP_DPC_CAP_RP_EXT		0x0020	/* Root Port Extensions */
 #define  PCI_EXP_DPC_CAP_POISONED_TLP	0x0040	/* Poisoned TLP Egress Blocking Supported */
@@ -1030,19 +1030,19 @@
 #define  PCI_EXP_DPC_RP_PIO_LOG_SIZE	0x0F00	/* RP PIO Log Size */
 #define  PCI_EXP_DPC_CAP_DL_ACTIVE	0x1000	/* ERR_COR signal on DL_Active supported */
 
-#define PCI_EXP_DPC_CTL			6	/* DPC control */
+#define PCI_EXP_DPC_CTL			0x06	/* DPC control */
 #define  PCI_EXP_DPC_CTL_EN_FATAL	0x0001	/* Enable trigger on ERR_FATAL message */
 #define  PCI_EXP_DPC_CTL_EN_NONFATAL	0x0002	/* Enable trigger on ERR_NONFATAL message */
 #define  PCI_EXP_DPC_CTL_INT_EN		0x0008	/* DPC Interrupt Enable */
 
-#define PCI_EXP_DPC_STATUS		8	/* DPC Status */
+#define PCI_EXP_DPC_STATUS		0x08	/* DPC Status */
 #define  PCI_EXP_DPC_STATUS_TRIGGER	    0x0001 /* Trigger Status */
 #define  PCI_EXP_DPC_STATUS_TRIGGER_RSN	    0x0006 /* Trigger Reason */
 #define  PCI_EXP_DPC_STATUS_INTERRUPT	    0x0008 /* Interrupt Status */
 #define  PCI_EXP_DPC_RP_BUSY		    0x0010 /* Root Port Busy */
 #define  PCI_EXP_DPC_STATUS_TRIGGER_RSN_EXT 0x0060 /* Trig Reason Extension */
 
-#define PCI_EXP_DPC_SOURCE_ID		10	/* DPC Source Identifier */
+#define PCI_EXP_DPC_SOURCE_ID		 0x0A	/* DPC Source Identifier */
 
 #define PCI_EXP_DPC_RP_PIO_STATUS	 0x0C	/* RP PIO Status */
 #define PCI_EXP_DPC_RP_PIO_MASK		 0x10	/* RP PIO Mask */
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
 
diff --git a/linux-headers/asm-generic/unistd.h b/linux-headers/asm-generic/unistd.h
index 4557a8b608..1c48b0ae3b 100644
--- a/linux-headers/asm-generic/unistd.h
+++ b/linux-headers/asm-generic/unistd.h
@@ -883,8 +883,11 @@ __SYSCALL(__NR_process_mrelease, sys_process_mrelease)
 #define __NR_futex_waitv 449
 __SYSCALL(__NR_futex_waitv, sys_futex_waitv)
 
+#define __NR_set_mempolicy_home_node 450
+__SYSCALL(__NR_set_mempolicy_home_node, sys_set_mempolicy_home_node)
+
 #undef __NR_syscalls
-#define __NR_syscalls 450
+#define __NR_syscalls 451
 
 /*
  * 32 bit systems traditionally used different
diff --git a/linux-headers/asm-mips/unistd_n32.h b/linux-headers/asm-mips/unistd_n32.h
index 4b3e7ad1ec..1f14a6fad3 100644
--- a/linux-headers/asm-mips/unistd_n32.h
+++ b/linux-headers/asm-mips/unistd_n32.h
@@ -377,5 +377,7 @@
 #define __NR_landlock_add_rule (__NR_Linux + 445)
 #define __NR_landlock_restrict_self (__NR_Linux + 446)
 #define __NR_process_mrelease (__NR_Linux + 448)
+#define __NR_futex_waitv (__NR_Linux + 449)
+#define __NR_set_mempolicy_home_node (__NR_Linux + 450)
 
 #endif /* _ASM_UNISTD_N32_H */
diff --git a/linux-headers/asm-mips/unistd_n64.h b/linux-headers/asm-mips/unistd_n64.h
index 488d9298d9..e5a8ebec78 100644
--- a/linux-headers/asm-mips/unistd_n64.h
+++ b/linux-headers/asm-mips/unistd_n64.h
@@ -353,5 +353,7 @@
 #define __NR_landlock_add_rule (__NR_Linux + 445)
 #define __NR_landlock_restrict_self (__NR_Linux + 446)
 #define __NR_process_mrelease (__NR_Linux + 448)
+#define __NR_futex_waitv (__NR_Linux + 449)
+#define __NR_set_mempolicy_home_node (__NR_Linux + 450)
 
 #endif /* _ASM_UNISTD_N64_H */
diff --git a/linux-headers/asm-mips/unistd_o32.h b/linux-headers/asm-mips/unistd_o32.h
index f47399870a..871d57168f 100644
--- a/linux-headers/asm-mips/unistd_o32.h
+++ b/linux-headers/asm-mips/unistd_o32.h
@@ -423,5 +423,7 @@
 #define __NR_landlock_add_rule (__NR_Linux + 445)
 #define __NR_landlock_restrict_self (__NR_Linux + 446)
 #define __NR_process_mrelease (__NR_Linux + 448)
+#define __NR_futex_waitv (__NR_Linux + 449)
+#define __NR_set_mempolicy_home_node (__NR_Linux + 450)
 
 #endif /* _ASM_UNISTD_O32_H */
diff --git a/linux-headers/asm-powerpc/unistd_32.h b/linux-headers/asm-powerpc/unistd_32.h
index 11d54696dc..585c7fefbc 100644
--- a/linux-headers/asm-powerpc/unistd_32.h
+++ b/linux-headers/asm-powerpc/unistd_32.h
@@ -430,6 +430,8 @@
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
 #define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
+#define __NR_set_mempolicy_home_node 450
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-powerpc/unistd_64.h b/linux-headers/asm-powerpc/unistd_64.h
index cf740bab13..350f7ec0ac 100644
--- a/linux-headers/asm-powerpc/unistd_64.h
+++ b/linux-headers/asm-powerpc/unistd_64.h
@@ -402,6 +402,8 @@
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
 #define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
+#define __NR_set_mempolicy_home_node 450
 
 
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
index 8f97d98128..8e644d65f5 100644
--- a/linux-headers/asm-s390/unistd_32.h
+++ b/linux-headers/asm-s390/unistd_32.h
@@ -420,5 +420,7 @@
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
 #define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
+#define __NR_set_mempolicy_home_node 450
 
 #endif /* _ASM_S390_UNISTD_32_H */
diff --git a/linux-headers/asm-s390/unistd_64.h b/linux-headers/asm-s390/unistd_64.h
index 021ffc30e6..51da542fec 100644
--- a/linux-headers/asm-s390/unistd_64.h
+++ b/linux-headers/asm-s390/unistd_64.h
@@ -368,5 +368,7 @@
 #define __NR_landlock_add_rule 445
 #define __NR_landlock_restrict_self 446
 #define __NR_process_mrelease 448
+#define __NR_futex_waitv 449
+#define __NR_set_mempolicy_home_node 450
 
 #endif /* _ASM_S390_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 5a776a08f7..bf6e96011d 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -373,9 +373,23 @@ struct kvm_debugregs {
 	__u64 reserved[9];
 };
 
-/* for KVM_CAP_XSAVE */
+/* for KVM_CAP_XSAVE and KVM_CAP_XSAVE2 */
 struct kvm_xsave {
+	/*
+	 * KVM_GET_XSAVE2 and KVM_SET_XSAVE write and read as many bytes
+	 * as are returned by KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2)
+	 * respectively, when invoked on the vm file descriptor.
+	 *
+	 * The size value returned by KVM_CHECK_EXTENSION(KVM_CAP_XSAVE2)
+	 * will always be at least 4096. Currently, it is only greater
+	 * than 4096 if a dynamic feature has been enabled with
+	 * ``arch_prctl()``, but this may change in the future.
+	 *
+	 * The offsets of the state save areas in struct kvm_xsave follow
+	 * the contents of CPUID leaf 0xD on the host.
+	 */
 	__u32 region[1024];
+	__u32 extra[0];
 };
 
 #define KVM_MAX_XCRS	16
@@ -438,6 +452,9 @@ struct kvm_sync_regs {
 
 #define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE	0x00000001
 
+/* attributes for system fd (group 0) */
+#define KVM_X86_XCOMP_GUEST_SUPP	0
+
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
diff --git a/linux-headers/asm-x86/unistd_32.h b/linux-headers/asm-x86/unistd_32.h
index 9c9ffe312b..87e1e977af 100644
--- a/linux-headers/asm-x86/unistd_32.h
+++ b/linux-headers/asm-x86/unistd_32.h
@@ -440,6 +440,7 @@
 #define __NR_memfd_secret 447
 #define __NR_process_mrelease 448
 #define __NR_futex_waitv 449
+#define __NR_set_mempolicy_home_node 450
 
 
 #endif /* _ASM_UNISTD_32_H */
diff --git a/linux-headers/asm-x86/unistd_64.h b/linux-headers/asm-x86/unistd_64.h
index 084f1eef9c..147a78d623 100644
--- a/linux-headers/asm-x86/unistd_64.h
+++ b/linux-headers/asm-x86/unistd_64.h
@@ -362,6 +362,7 @@
 #define __NR_memfd_secret 447
 #define __NR_process_mrelease 448
 #define __NR_futex_waitv 449
+#define __NR_set_mempolicy_home_node 450
 
 
 #endif /* _ASM_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/unistd_x32.h b/linux-headers/asm-x86/unistd_x32.h
index a2441affc2..27098db7fb 100644
--- a/linux-headers/asm-x86/unistd_x32.h
+++ b/linux-headers/asm-x86/unistd_x32.h
@@ -315,6 +315,7 @@
 #define __NR_memfd_secret (__X32_SYSCALL_BIT + 447)
 #define __NR_process_mrelease (__X32_SYSCALL_BIT + 448)
 #define __NR_futex_waitv (__X32_SYSCALL_BIT + 449)
+#define __NR_set_mempolicy_home_node (__X32_SYSCALL_BIT + 450)
 #define __NR_rt_sigaction (__X32_SYSCALL_BIT + 512)
 #define __NR_rt_sigreturn (__X32_SYSCALL_BIT + 513)
 #define __NR_ioctl (__X32_SYSCALL_BIT + 514)
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 02c5e7b7bb..002503dc8b 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -1130,6 +1130,10 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM 206
+#define KVM_CAP_VM_GPA_BITS 207
+#define KVM_CAP_XSAVE2 208
+#define KVM_CAP_SYS_ATTRIBUTES 209
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1161,11 +1165,20 @@ struct kvm_irq_routing_hv_sint {
 	__u32 sint;
 };
 
+struct kvm_irq_routing_xen_evtchn {
+	__u32 port;
+	__u32 vcpu;
+	__u32 priority;
+};
+
+#define KVM_IRQ_ROUTING_XEN_EVTCHN_PRIO_2LEVEL ((__u32)(-1))
+
 /* gsi routing entry types */
 #define KVM_IRQ_ROUTING_IRQCHIP 1
 #define KVM_IRQ_ROUTING_MSI 2
 #define KVM_IRQ_ROUTING_S390_ADAPTER 3
 #define KVM_IRQ_ROUTING_HV_SINT 4
+#define KVM_IRQ_ROUTING_XEN_EVTCHN 5
 
 struct kvm_irq_routing_entry {
 	__u32 gsi;
@@ -1177,6 +1190,7 @@ struct kvm_irq_routing_entry {
 		struct kvm_irq_routing_msi msi;
 		struct kvm_irq_routing_s390_adapter adapter;
 		struct kvm_irq_routing_hv_sint hv_sint;
+		struct kvm_irq_routing_xen_evtchn xen_evtchn;
 		__u32 pad[8];
 	} u;
 };
@@ -1207,6 +1221,7 @@ struct kvm_x86_mce {
 #define KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL	(1 << 1)
 #define KVM_XEN_HVM_CONFIG_SHARED_INFO		(1 << 2)
 #define KVM_XEN_HVM_CONFIG_RUNSTATE		(1 << 3)
+#define KVM_XEN_HVM_CONFIG_EVTCHN_2LEVEL	(1 << 4)
 
 struct kvm_xen_hvm_config {
 	__u32 flags;
@@ -1609,6 +1624,9 @@ struct kvm_enc_region {
 #define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
 #define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
 
+/* Available with KVM_CAP_XSAVE2 */
+#define KVM_GET_XSAVE2		  _IOR(KVMIO,  0xcf, struct kvm_xsave)
+
 struct kvm_s390_pv_sec_parm {
 	__u64 origin;
 	__u64 length;
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
index b4309397b6..133df1002e 100644
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
+#define VFIO_DEVICE_ZPCI_FLAG_AIF_FLOAT 1	/* Enable floating interrupts */
+#define VFIO_DEVICE_ZPCI_FLAG_AIF_HOST 2	/* Force host delivery */
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

