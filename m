Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC81E299120
	for <lists+kvm@lfdr.de>; Mon, 26 Oct 2020 16:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1783986AbgJZPfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Oct 2020 11:35:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16360 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1783970AbgJZPfq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 26 Oct 2020 11:35:46 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09QFXO6A143922;
        Mon, 26 Oct 2020 11:35:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=UfrJHEuFyHloc82/IXTq3yMUFvr3XLwcesdtXqx6HLM=;
 b=eeOFCMQ7K35C2+ROBi9x1J7+Rs2sqUQcB0dE0PESGIbbEYenQOnjfk39hHfo1lME4Nth
 sKgYOSoMzL9k9I4qKvN7gWIsyQxGWNNX7zSprprWA2SE07MLMAFuvCJq1hkOiHctJNVJ
 VvKa8nu6qXDOXyuGN6Uouf2FST/+70IHZrhtTCcRMciSgIsbyMA60kMm4mr5yUCJoIBj
 AEE1hhXq6HGI5k0QBBmMjxznwqCSYTVPoZlqCj3DyM76QpLEq+MTdhcJ2O2usl1p2xo7
 zIbuZYSOO3JarvkC/IqDcSWAkBCyca1qtwEWx/bEypwVYu/l7pzyAHbeMvlQWTqJEGaM 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34d97fnr82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 11:35:25 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09QFXp6c144939;
        Mon, 26 Oct 2020 11:35:19 -0400
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34d97fnr25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 11:35:18 -0400
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09QFHT53030736;
        Mon, 26 Oct 2020 15:34:59 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma05wdc.us.ibm.com with ESMTP id 34cbw8rn01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 26 Oct 2020 15:34:59 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09QFYxxE52035852
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 15:34:59 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFA9E112061;
        Mon, 26 Oct 2020 15:34:58 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5CF68112062;
        Mon, 26 Oct 2020 15:34:54 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.49.29])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 26 Oct 2020 15:34:54 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     cohuck@redhat.com, thuth@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, rth@twiddle.net,
        david@redhat.com, pasic@linux.ibm.com, borntraeger@de.ibm.com,
        mst@redhat.com, pbonzini@redhat.com, alex.williamson@redhat.com,
        philmd@redhat.com, qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Subject: [PATCH 02/13] linux-headers: update against 5.10-rc1
Date:   Mon, 26 Oct 2020 11:34:30 -0400
Message-Id: <1603726481-31824-3-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
References: <1603726481-31824-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.737
 definitions=2020-10-26_08:2020-10-26,2020-10-26 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2010260107
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit 3650b228f83adda7e5ee532e2b90429c03f7b9ec

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 .../drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h | 14 ++--
 .../infiniband/hw/vmw_pvrdma/pvrdma_verbs.h        |  2 +-
 include/standard-headers/linux/ethtool.h           |  2 +
 include/standard-headers/linux/fuse.h              | 50 +++++++++++++-
 include/standard-headers/linux/input-event-codes.h |  4 ++
 include/standard-headers/linux/pci_regs.h          |  6 +-
 include/standard-headers/linux/virtio_fs.h         |  3 +
 include/standard-headers/linux/virtio_gpu.h        | 19 ++++++
 include/standard-headers/linux/virtio_mmio.h       | 11 +++
 include/standard-headers/linux/virtio_pci.h        | 11 ++-
 linux-headers/asm-arm64/kvm.h                      | 25 +++++++
 linux-headers/asm-arm64/mman.h                     |  1 +
 linux-headers/asm-generic/hugetlb_encode.h         |  1 +
 linux-headers/asm-generic/unistd.h                 | 18 ++---
 linux-headers/asm-mips/unistd_n32.h                |  1 +
 linux-headers/asm-mips/unistd_n64.h                |  1 +
 linux-headers/asm-mips/unistd_o32.h                |  1 +
 linux-headers/asm-powerpc/unistd_32.h              |  1 +
 linux-headers/asm-powerpc/unistd_64.h              |  1 +
 linux-headers/asm-s390/unistd_32.h                 |  1 +
 linux-headers/asm-s390/unistd_64.h                 |  1 +
 linux-headers/asm-x86/kvm.h                        | 20 ++++++
 linux-headers/asm-x86/unistd_32.h                  |  1 +
 linux-headers/asm-x86/unistd_64.h                  |  1 +
 linux-headers/asm-x86/unistd_x32.h                 |  1 +
 linux-headers/linux/kvm.h                          | 19 ++++++
 linux-headers/linux/mman.h                         |  1 +
 linux-headers/linux/vfio.h                         | 29 +++++++-
 linux-headers/linux/vfio_zdev.h                    | 78 ++++++++++++++++++++++
 29 files changed, 301 insertions(+), 23 deletions(-)
 create mode 100644 linux-headers/linux/vfio_zdev.h

diff --git a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
index 7b4062a..acd4c83 100644
--- a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
+++ b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
@@ -68,7 +68,7 @@ static inline int pvrdma_idx_valid(uint32_t idx, uint32_t max_elems)
 
 static inline int32_t pvrdma_idx(int *var, uint32_t max_elems)
 {
-	const unsigned int idx = qatomic_read(var);
+	const unsigned int idx = atomic_read(var);
 
 	if (pvrdma_idx_valid(idx, max_elems))
 		return idx & (max_elems - 1);
@@ -77,17 +77,17 @@ static inline int32_t pvrdma_idx(int *var, uint32_t max_elems)
 
 static inline void pvrdma_idx_ring_inc(int *var, uint32_t max_elems)
 {
-	uint32_t idx = qatomic_read(var) + 1;	/* Increment. */
+	uint32_t idx = atomic_read(var) + 1;	/* Increment. */
 
 	idx &= (max_elems << 1) - 1;		/* Modulo size, flip gen. */
-	qatomic_set(var, idx);
+	atomic_set(var, idx);
 }
 
 static inline int32_t pvrdma_idx_ring_has_space(const struct pvrdma_ring *r,
 					      uint32_t max_elems, uint32_t *out_tail)
 {
-	const uint32_t tail = qatomic_read(&r->prod_tail);
-	const uint32_t head = qatomic_read(&r->cons_head);
+	const uint32_t tail = atomic_read(&r->prod_tail);
+	const uint32_t head = atomic_read(&r->cons_head);
 
 	if (pvrdma_idx_valid(tail, max_elems) &&
 	    pvrdma_idx_valid(head, max_elems)) {
@@ -100,8 +100,8 @@ static inline int32_t pvrdma_idx_ring_has_space(const struct pvrdma_ring *r,
 static inline int32_t pvrdma_idx_ring_has_data(const struct pvrdma_ring *r,
 					     uint32_t max_elems, uint32_t *out_head)
 {
-	const uint32_t tail = qatomic_read(&r->prod_tail);
-	const uint32_t head = qatomic_read(&r->cons_head);
+	const uint32_t tail = atomic_read(&r->prod_tail);
+	const uint32_t head = atomic_read(&r->cons_head);
 
 	if (pvrdma_idx_valid(tail, max_elems) &&
 	    pvrdma_idx_valid(head, max_elems)) {
diff --git a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
index 1677208..0a8c7c9 100644
--- a/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
+++ b/include/standard-headers/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.h
@@ -176,7 +176,7 @@ struct pvrdma_port_attr {
 	uint8_t			subnet_timeout;
 	uint8_t			init_type_reply;
 	uint8_t			active_width;
-	uint8_t			active_speed;
+	uint16_t			active_speed;
 	uint8_t			phys_state;
 	uint8_t			reserved[2];
 };
diff --git a/include/standard-headers/linux/ethtool.h b/include/standard-headers/linux/ethtool.h
index e13eff4..0df22f7 100644
--- a/include/standard-headers/linux/ethtool.h
+++ b/include/standard-headers/linux/ethtool.h
@@ -1617,6 +1617,8 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT = 87,
 	ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT	 = 88,
 	ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT	 = 89,
+	ETHTOOL_LINK_MODE_100baseFX_Half_BIT		 = 90,
+	ETHTOOL_LINK_MODE_100baseFX_Full_BIT		 = 91,
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
diff --git a/include/standard-headers/linux/fuse.h b/include/standard-headers/linux/fuse.h
index f4df0a4..82c0a38 100644
--- a/include/standard-headers/linux/fuse.h
+++ b/include/standard-headers/linux/fuse.h
@@ -172,6 +172,9 @@
  *  - add FUSE_WRITE_KILL_PRIV flag
  *  - add FUSE_SETUPMAPPING and FUSE_REMOVEMAPPING
  *  - add map_alignment to fuse_init_out, add FUSE_MAP_ALIGNMENT flag
+ *
+ *  7.32
+ *  - add flags to fuse_attr, add FUSE_ATTR_SUBMOUNT, add FUSE_SUBMOUNTS
  */
 
 #ifndef _LINUX_FUSE_H
@@ -203,7 +206,7 @@
 #define FUSE_KERNEL_VERSION 7
 
 /** Minor version number of this interface */
-#define FUSE_KERNEL_MINOR_VERSION 31
+#define FUSE_KERNEL_MINOR_VERSION 32
 
 /** The node ID of the root inode */
 #define FUSE_ROOT_ID 1
@@ -227,7 +230,7 @@ struct fuse_attr {
 	uint32_t	gid;
 	uint32_t	rdev;
 	uint32_t	blksize;
-	uint32_t	padding;
+	uint32_t	flags;
 };
 
 struct fuse_kstatfs {
@@ -309,7 +312,10 @@ struct fuse_file_lock {
  * FUSE_CACHE_SYMLINKS: cache READLINK responses
  * FUSE_NO_OPENDIR_SUPPORT: kernel supports zero-message opendir
  * FUSE_EXPLICIT_INVAL_DATA: only invalidate cached pages on explicit request
- * FUSE_MAP_ALIGNMENT: map_alignment field is valid
+ * FUSE_MAP_ALIGNMENT: init_out.map_alignment contains log2(byte alignment) for
+ *		       foffset and moffset fields in struct
+ *		       fuse_setupmapping_out and fuse_removemapping_one.
+ * FUSE_SUBMOUNTS: kernel supports auto-mounting directory submounts
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -338,6 +344,7 @@ struct fuse_file_lock {
 #define FUSE_NO_OPENDIR_SUPPORT (1 << 24)
 #define FUSE_EXPLICIT_INVAL_DATA (1 << 25)
 #define FUSE_MAP_ALIGNMENT	(1 << 26)
+#define FUSE_SUBMOUNTS		(1 << 27)
 
 /**
  * CUSE INIT request/reply flags
@@ -413,6 +420,13 @@ struct fuse_file_lock {
  */
 #define FUSE_FSYNC_FDATASYNC	(1 << 0)
 
+/**
+ * fuse_attr flags
+ *
+ * FUSE_ATTR_SUBMOUNT: Object is a submount root
+ */
+#define FUSE_ATTR_SUBMOUNT      (1 << 0)
+
 enum fuse_opcode {
 	FUSE_LOOKUP		= 1,
 	FUSE_FORGET		= 2,  /* no reply */
@@ -888,4 +902,34 @@ struct fuse_copy_file_range_in {
 	uint64_t	flags;
 };
 
+#define FUSE_SETUPMAPPING_FLAG_WRITE (1ull << 0)
+#define FUSE_SETUPMAPPING_FLAG_READ (1ull << 1)
+struct fuse_setupmapping_in {
+	/* An already open handle */
+	uint64_t	fh;
+	/* Offset into the file to start the mapping */
+	uint64_t	foffset;
+	/* Length of mapping required */
+	uint64_t	len;
+	/* Flags, FUSE_SETUPMAPPING_FLAG_* */
+	uint64_t	flags;
+	/* Offset in Memory Window */
+	uint64_t	moffset;
+};
+
+struct fuse_removemapping_in {
+	/* number of fuse_removemapping_one follows */
+	uint32_t        count;
+};
+
+struct fuse_removemapping_one {
+	/* Offset into the dax window start the unmapping */
+	uint64_t        moffset;
+	/* Length of mapping required */
+	uint64_t	len;
+};
+
+#define FUSE_REMOVEMAPPING_MAX_ENTRY   \
+		(PAGE_SIZE / sizeof(struct fuse_removemapping_one))
+
 #endif /* _LINUX_FUSE_H */
diff --git a/include/standard-headers/linux/input-event-codes.h b/include/standard-headers/linux/input-event-codes.h
index e740ad9..c403b9c 100644
--- a/include/standard-headers/linux/input-event-codes.h
+++ b/include/standard-headers/linux/input-event-codes.h
@@ -515,6 +515,9 @@
 #define KEY_10CHANNELSUP	0x1b8	/* 10 channels up (10+) */
 #define KEY_10CHANNELSDOWN	0x1b9	/* 10 channels down (10-) */
 #define KEY_IMAGES		0x1ba	/* AL Image Browser */
+#define KEY_NOTIFICATION_CENTER	0x1bc	/* Show/hide the notification center */
+#define KEY_PICKUP_PHONE	0x1bd	/* Answer incoming call */
+#define KEY_HANGUP_PHONE	0x1be	/* Decline incoming call */
 
 #define KEY_DEL_EOL		0x1c0
 #define KEY_DEL_EOS		0x1c1
@@ -542,6 +545,7 @@
 #define KEY_FN_F		0x1e2
 #define KEY_FN_S		0x1e3
 #define KEY_FN_B		0x1e4
+#define KEY_FN_RIGHT_SHIFT	0x1e5
 
 #define KEY_BRL_DOT1		0x1f1
 #define KEY_BRL_DOT2		0x1f2
diff --git a/include/standard-headers/linux/pci_regs.h b/include/standard-headers/linux/pci_regs.h
index f970141..a95d55f 100644
--- a/include/standard-headers/linux/pci_regs.h
+++ b/include/standard-headers/linux/pci_regs.h
@@ -76,6 +76,7 @@
 #define PCI_CACHE_LINE_SIZE	0x0c	/* 8 bits */
 #define PCI_LATENCY_TIMER	0x0d	/* 8 bits */
 #define PCI_HEADER_TYPE		0x0e	/* 8 bits */
+#define  PCI_HEADER_TYPE_MASK		0x7f
 #define  PCI_HEADER_TYPE_NORMAL		0
 #define  PCI_HEADER_TYPE_BRIDGE		1
 #define  PCI_HEADER_TYPE_CARDBUS	2
@@ -246,7 +247,7 @@
 #define  PCI_PM_CAP_PME_D0	0x0800	/* PME# from D0 */
 #define  PCI_PM_CAP_PME_D1	0x1000	/* PME# from D1 */
 #define  PCI_PM_CAP_PME_D2	0x2000	/* PME# from D2 */
-#define  PCI_PM_CAP_PME_D3	0x4000	/* PME# from D3 (hot) */
+#define  PCI_PM_CAP_PME_D3hot	0x4000	/* PME# from D3 (hot) */
 #define  PCI_PM_CAP_PME_D3cold	0x8000	/* PME# from D3 (cold) */
 #define  PCI_PM_CAP_PME_SHIFT	11	/* Start of the PME Mask in PMC */
 #define PCI_PM_CTRL		4	/* PM control and status register */
@@ -532,6 +533,8 @@
 #define  PCI_EXP_LNKCAP_SLS_32_0GB 0x00000005 /* LNKCAP2 SLS Vector bit 4 */
 #define  PCI_EXP_LNKCAP_MLW	0x000003f0 /* Maximum Link Width */
 #define  PCI_EXP_LNKCAP_ASPMS	0x00000c00 /* ASPM Support */
+#define  PCI_EXP_LNKCAP_ASPM_L0S 0x00000400 /* ASPM L0s Support */
+#define  PCI_EXP_LNKCAP_ASPM_L1  0x00000800 /* ASPM L1 Support */
 #define  PCI_EXP_LNKCAP_L0SEL	0x00007000 /* L0s Exit Latency */
 #define  PCI_EXP_LNKCAP_L1EL	0x00038000 /* L1 Exit Latency */
 #define  PCI_EXP_LNKCAP_CLKPM	0x00040000 /* Clock Power Management */
@@ -1056,6 +1059,7 @@
 #define  PCI_L1SS_CTL1_PCIPM_L1_1	0x00000002  /* PCI-PM L1.1 Enable */
 #define  PCI_L1SS_CTL1_ASPM_L1_2	0x00000004  /* ASPM L1.2 Enable */
 #define  PCI_L1SS_CTL1_ASPM_L1_1	0x00000008  /* ASPM L1.1 Enable */
+#define  PCI_L1SS_CTL1_L1_2_MASK	0x00000005
 #define  PCI_L1SS_CTL1_L1SS_MASK	0x0000000f
 #define  PCI_L1SS_CTL1_CM_RESTORE_TIME	0x0000ff00  /* Common_Mode_Restore_Time */
 #define  PCI_L1SS_CTL1_LTR_L12_TH_VALUE	0x03ff0000  /* LTR_L1.2_THRESHOLD_Value */
diff --git a/include/standard-headers/linux/virtio_fs.h b/include/standard-headers/linux/virtio_fs.h
index 9d88817..a32fe8a 100644
--- a/include/standard-headers/linux/virtio_fs.h
+++ b/include/standard-headers/linux/virtio_fs.h
@@ -16,4 +16,7 @@ struct virtio_fs_config {
 	uint32_t num_request_queues;
 } QEMU_PACKED;
 
+/* For the id field in virtio_pci_shm_cap */
+#define VIRTIO_FS_SHMCAP_ID_CACHE 0
+
 #endif /* _LINUX_VIRTIO_FS_H */
diff --git a/include/standard-headers/linux/virtio_gpu.h b/include/standard-headers/linux/virtio_gpu.h
index b8fa15f..4183cdc 100644
--- a/include/standard-headers/linux/virtio_gpu.h
+++ b/include/standard-headers/linux/virtio_gpu.h
@@ -50,6 +50,10 @@
  * VIRTIO_GPU_CMD_GET_EDID
  */
 #define VIRTIO_GPU_F_EDID                1
+/*
+ * VIRTIO_GPU_CMD_RESOURCE_ASSIGN_UUID
+ */
+#define VIRTIO_GPU_F_RESOURCE_UUID       2
 
 enum virtio_gpu_ctrl_type {
 	VIRTIO_GPU_UNDEFINED = 0,
@@ -66,6 +70,7 @@ enum virtio_gpu_ctrl_type {
 	VIRTIO_GPU_CMD_GET_CAPSET_INFO,
 	VIRTIO_GPU_CMD_GET_CAPSET,
 	VIRTIO_GPU_CMD_GET_EDID,
+	VIRTIO_GPU_CMD_RESOURCE_ASSIGN_UUID,
 
 	/* 3d commands */
 	VIRTIO_GPU_CMD_CTX_CREATE = 0x0200,
@@ -87,6 +92,7 @@ enum virtio_gpu_ctrl_type {
 	VIRTIO_GPU_RESP_OK_CAPSET_INFO,
 	VIRTIO_GPU_RESP_OK_CAPSET,
 	VIRTIO_GPU_RESP_OK_EDID,
+	VIRTIO_GPU_RESP_OK_RESOURCE_UUID,
 
 	/* error responses */
 	VIRTIO_GPU_RESP_ERR_UNSPEC = 0x1200,
@@ -340,4 +346,17 @@ enum virtio_gpu_formats {
 	VIRTIO_GPU_FORMAT_R8G8B8X8_UNORM  = 134,
 };
 
+/* VIRTIO_GPU_CMD_RESOURCE_ASSIGN_UUID */
+struct virtio_gpu_resource_assign_uuid {
+	struct virtio_gpu_ctrl_hdr hdr;
+	uint32_t resource_id;
+	uint32_t padding;
+};
+
+/* VIRTIO_GPU_RESP_OK_RESOURCE_UUID */
+struct virtio_gpu_resp_resource_uuid {
+	struct virtio_gpu_ctrl_hdr hdr;
+	uint8_t uuid[16];
+};
+
 #endif
diff --git a/include/standard-headers/linux/virtio_mmio.h b/include/standard-headers/linux/virtio_mmio.h
index c4b0968..0650f91 100644
--- a/include/standard-headers/linux/virtio_mmio.h
+++ b/include/standard-headers/linux/virtio_mmio.h
@@ -122,6 +122,17 @@
 #define VIRTIO_MMIO_QUEUE_USED_LOW	0x0a0
 #define VIRTIO_MMIO_QUEUE_USED_HIGH	0x0a4
 
+/* Shared memory region id */
+#define VIRTIO_MMIO_SHM_SEL             0x0ac
+
+/* Shared memory region length, 64 bits in two halves */
+#define VIRTIO_MMIO_SHM_LEN_LOW         0x0b0
+#define VIRTIO_MMIO_SHM_LEN_HIGH        0x0b4
+
+/* Shared memory region base address, 64 bits in two halves */
+#define VIRTIO_MMIO_SHM_BASE_LOW        0x0b8
+#define VIRTIO_MMIO_SHM_BASE_HIGH       0x0bc
+
 /* Configuration atomicity value */
 #define VIRTIO_MMIO_CONFIG_GENERATION	0x0fc
 
diff --git a/include/standard-headers/linux/virtio_pci.h b/include/standard-headers/linux/virtio_pci.h
index 9262acd..db7a8e2 100644
--- a/include/standard-headers/linux/virtio_pci.h
+++ b/include/standard-headers/linux/virtio_pci.h
@@ -113,6 +113,8 @@
 #define VIRTIO_PCI_CAP_DEVICE_CFG	4
 /* PCI configuration access */
 #define VIRTIO_PCI_CAP_PCI_CFG		5
+/* Additional shared memory capability */
+#define VIRTIO_PCI_CAP_SHARED_MEMORY_CFG 8
 
 /* This is the PCI capability header: */
 struct virtio_pci_cap {
@@ -121,11 +123,18 @@ struct virtio_pci_cap {
 	uint8_t cap_len;		/* Generic PCI field: capability length */
 	uint8_t cfg_type;		/* Identifies the structure. */
 	uint8_t bar;		/* Where to find it. */
-	uint8_t padding[3];	/* Pad to full dword. */
+	uint8_t id;		/* Multiple capabilities of the same type */
+	uint8_t padding[2];	/* Pad to full dword. */
 	uint32_t offset;		/* Offset within bar. */
 	uint32_t length;		/* Length of the structure, in bytes. */
 };
 
+struct virtio_pci_cap64 {
+	struct virtio_pci_cap cap;
+	uint32_t offset_hi;             /* Most sig 32 bits of offset */
+	uint32_t length_hi;             /* Most sig 32 bits of length */
+};
+
 struct virtio_pci_notify_cap {
 	struct virtio_pci_cap cap;
 	uint32_t notify_off_multiplier;	/* Multiplier for queue_notify_off. */
diff --git a/linux-headers/asm-arm64/kvm.h b/linux-headers/asm-arm64/kvm.h
index 9e34f0f..a72de1a 100644
--- a/linux-headers/asm-arm64/kvm.h
+++ b/linux-headers/asm-arm64/kvm.h
@@ -159,6 +159,21 @@ struct kvm_sync_regs {
 struct kvm_arch_memory_slot {
 };
 
+/*
+ * PMU filter structure. Describe a range of events with a particular
+ * action. To be used with KVM_ARM_VCPU_PMU_V3_FILTER.
+ */
+struct kvm_pmu_event_filter {
+	__u16	base_event;
+	__u16	nevents;
+
+#define KVM_PMU_EVENT_ALLOW	0
+#define KVM_PMU_EVENT_DENY	1
+
+	__u8	action;
+	__u8	pad[3];
+};
+
 /* for KVM_GET/SET_VCPU_EVENTS */
 struct kvm_vcpu_events {
 	struct {
@@ -242,6 +257,15 @@ struct kvm_vcpu_events {
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL		0
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL		1
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_REQUIRED	2
+
+/*
+ * Only two states can be presented by the host kernel:
+ * - NOT_REQUIRED: the guest doesn't need to do anything
+ * - NOT_AVAIL: the guest isn't mitigated (it can still use SSBS if available)
+ *
+ * All the other values are deprecated. The host still accepts all
+ * values (they are ABI), but will narrow them to the above two.
+ */
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2	KVM_REG_ARM_FW_REG(2)
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL		0
 #define KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN		1
@@ -329,6 +353,7 @@ struct kvm_vcpu_events {
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
 #define   KVM_ARM_VCPU_PMU_V3_IRQ	0
 #define   KVM_ARM_VCPU_PMU_V3_INIT	1
+#define   KVM_ARM_VCPU_PMU_V3_FILTER	2
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/linux-headers/asm-arm64/mman.h b/linux-headers/asm-arm64/mman.h
index e94b9af..d0dbfe9 100644
--- a/linux-headers/asm-arm64/mman.h
+++ b/linux-headers/asm-arm64/mman.h
@@ -5,5 +5,6 @@
 #include <asm-generic/mman.h>
 
 #define PROT_BTI	0x10		/* BTI guarded page */
+#define PROT_MTE	0x20		/* Normal Tagged mapping */
 
 #endif /* ! _UAPI__ASM_MMAN_H */
diff --git a/linux-headers/asm-generic/hugetlb_encode.h b/linux-headers/asm-generic/hugetlb_encode.h
index b0f8e87..4f3d5aa 100644
--- a/linux-headers/asm-generic/hugetlb_encode.h
+++ b/linux-headers/asm-generic/hugetlb_encode.h
@@ -20,6 +20,7 @@
 #define HUGETLB_FLAG_ENCODE_SHIFT	26
 #define HUGETLB_FLAG_ENCODE_MASK	0x3f
 
+#define HUGETLB_FLAG_ENCODE_16KB	(14 << HUGETLB_FLAG_ENCODE_SHIFT)
 #define HUGETLB_FLAG_ENCODE_64KB	(16 << HUGETLB_FLAG_ENCODE_SHIFT)
 #define HUGETLB_FLAG_ENCODE_512KB	(19 << HUGETLB_FLAG_ENCODE_SHIFT)
 #define HUGETLB_FLAG_ENCODE_1MB		(20 << HUGETLB_FLAG_ENCODE_SHIFT)
diff --git a/linux-headers/asm-generic/unistd.h b/linux-headers/asm-generic/unistd.h
index 995b36c..2056318 100644
--- a/linux-headers/asm-generic/unistd.h
+++ b/linux-headers/asm-generic/unistd.h
@@ -140,7 +140,7 @@ __SYSCALL(__NR_renameat, sys_renameat)
 #define __NR_umount2 39
 __SYSCALL(__NR_umount2, sys_umount)
 #define __NR_mount 40
-__SC_COMP(__NR_mount, sys_mount, compat_sys_mount)
+__SYSCALL(__NR_mount, sys_mount)
 #define __NR_pivot_root 41
 __SYSCALL(__NR_pivot_root, sys_pivot_root)
 
@@ -207,9 +207,9 @@ __SYSCALL(__NR_read, sys_read)
 #define __NR_write 64
 __SYSCALL(__NR_write, sys_write)
 #define __NR_readv 65
-__SC_COMP(__NR_readv, sys_readv, compat_sys_readv)
+__SC_COMP(__NR_readv, sys_readv, sys_readv)
 #define __NR_writev 66
-__SC_COMP(__NR_writev, sys_writev, compat_sys_writev)
+__SC_COMP(__NR_writev, sys_writev, sys_writev)
 #define __NR_pread64 67
 __SC_COMP(__NR_pread64, sys_pread64, compat_sys_pread64)
 #define __NR_pwrite64 68
@@ -237,7 +237,7 @@ __SC_COMP(__NR_signalfd4, sys_signalfd4, compat_sys_signalfd4)
 
 /* fs/splice.c */
 #define __NR_vmsplice 75
-__SC_COMP(__NR_vmsplice, sys_vmsplice, compat_sys_vmsplice)
+__SYSCALL(__NR_vmsplice, sys_vmsplice)
 #define __NR_splice 76
 __SYSCALL(__NR_splice, sys_splice)
 #define __NR_tee 77
@@ -727,11 +727,9 @@ __SYSCALL(__NR_setns, sys_setns)
 #define __NR_sendmmsg 269
 __SC_COMP(__NR_sendmmsg, sys_sendmmsg, compat_sys_sendmmsg)
 #define __NR_process_vm_readv 270
-__SC_COMP(__NR_process_vm_readv, sys_process_vm_readv, \
-          compat_sys_process_vm_readv)
+__SYSCALL(__NR_process_vm_readv, sys_process_vm_readv)
 #define __NR_process_vm_writev 271
-__SC_COMP(__NR_process_vm_writev, sys_process_vm_writev, \
-          compat_sys_process_vm_writev)
+__SYSCALL(__NR_process_vm_writev, sys_process_vm_writev)
 #define __NR_kcmp 272
 __SYSCALL(__NR_kcmp, sys_kcmp)
 #define __NR_finit_module 273
@@ -859,9 +857,11 @@ __SYSCALL(__NR_openat2, sys_openat2)
 __SYSCALL(__NR_pidfd_getfd, sys_pidfd_getfd)
 #define __NR_faccessat2 439
 __SYSCALL(__NR_faccessat2, sys_faccessat2)
+#define __NR_process_madvise 440
+__SYSCALL(__NR_process_madvise, sys_process_madvise)
 
 #undef __NR_syscalls
-#define __NR_syscalls 440
+#define __NR_syscalls 441
 
 /*
  * 32 bit systems traditionally used different
diff --git a/linux-headers/asm-mips/unistd_n32.h b/linux-headers/asm-mips/unistd_n32.h
index 246fbb6..aba284d 100644
--- a/linux-headers/asm-mips/unistd_n32.h
+++ b/linux-headers/asm-mips/unistd_n32.h
@@ -369,6 +369,7 @@
 #define __NR_openat2	(__NR_Linux + 437)
 #define __NR_pidfd_getfd	(__NR_Linux + 438)
 #define __NR_faccessat2	(__NR_Linux + 439)
+#define __NR_process_madvise	(__NR_Linux + 440)
 
 
 #endif /* _ASM_MIPS_UNISTD_N32_H */
diff --git a/linux-headers/asm-mips/unistd_n64.h b/linux-headers/asm-mips/unistd_n64.h
index 194d777..0465ab9 100644
--- a/linux-headers/asm-mips/unistd_n64.h
+++ b/linux-headers/asm-mips/unistd_n64.h
@@ -345,6 +345,7 @@
 #define __NR_openat2	(__NR_Linux + 437)
 #define __NR_pidfd_getfd	(__NR_Linux + 438)
 #define __NR_faccessat2	(__NR_Linux + 439)
+#define __NR_process_madvise	(__NR_Linux + 440)
 
 
 #endif /* _ASM_MIPS_UNISTD_N64_H */
diff --git a/linux-headers/asm-mips/unistd_o32.h b/linux-headers/asm-mips/unistd_o32.h
index 3e093dd..5222a0d 100644
--- a/linux-headers/asm-mips/unistd_o32.h
+++ b/linux-headers/asm-mips/unistd_o32.h
@@ -415,6 +415,7 @@
 #define __NR_openat2	(__NR_Linux + 437)
 #define __NR_pidfd_getfd	(__NR_Linux + 438)
 #define __NR_faccessat2	(__NR_Linux + 439)
+#define __NR_process_madvise	(__NR_Linux + 440)
 
 
 #endif /* _ASM_MIPS_UNISTD_O32_H */
diff --git a/linux-headers/asm-powerpc/unistd_32.h b/linux-headers/asm-powerpc/unistd_32.h
index 0db9481d..21066a3 100644
--- a/linux-headers/asm-powerpc/unistd_32.h
+++ b/linux-headers/asm-powerpc/unistd_32.h
@@ -422,6 +422,7 @@
 #define __NR_openat2	437
 #define __NR_pidfd_getfd	438
 #define __NR_faccessat2	439
+#define __NR_process_madvise	440
 
 
 #endif /* _ASM_POWERPC_UNISTD_32_H */
diff --git a/linux-headers/asm-powerpc/unistd_64.h b/linux-headers/asm-powerpc/unistd_64.h
index 9f74310..c153da2 100644
--- a/linux-headers/asm-powerpc/unistd_64.h
+++ b/linux-headers/asm-powerpc/unistd_64.h
@@ -394,6 +394,7 @@
 #define __NR_openat2	437
 #define __NR_pidfd_getfd	438
 #define __NR_faccessat2	439
+#define __NR_process_madvise	440
 
 
 #endif /* _ASM_POWERPC_UNISTD_64_H */
diff --git a/linux-headers/asm-s390/unistd_32.h b/linux-headers/asm-s390/unistd_32.h
index 1803cd0..3b4f2dd 100644
--- a/linux-headers/asm-s390/unistd_32.h
+++ b/linux-headers/asm-s390/unistd_32.h
@@ -412,5 +412,6 @@
 #define __NR_openat2 437
 #define __NR_pidfd_getfd 438
 #define __NR_faccessat2 439
+#define __NR_process_madvise 440
 
 #endif /* _ASM_S390_UNISTD_32_H */
diff --git a/linux-headers/asm-s390/unistd_64.h b/linux-headers/asm-s390/unistd_64.h
index 228d500..030a51f 100644
--- a/linux-headers/asm-s390/unistd_64.h
+++ b/linux-headers/asm-s390/unistd_64.h
@@ -360,5 +360,6 @@
 #define __NR_openat2 437
 #define __NR_pidfd_getfd 438
 #define __NR_faccessat2 439
+#define __NR_process_madvise 440
 
 #endif /* _ASM_S390_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/kvm.h b/linux-headers/asm-x86/kvm.h
index 0780f97..89e5f3d 100644
--- a/linux-headers/asm-x86/kvm.h
+++ b/linux-headers/asm-x86/kvm.h
@@ -192,6 +192,26 @@ struct kvm_msr_list {
 	__u32 indices[0];
 };
 
+/* Maximum size of any access bitmap in bytes */
+#define KVM_MSR_FILTER_MAX_BITMAP_SIZE 0x600
+
+/* for KVM_X86_SET_MSR_FILTER */
+struct kvm_msr_filter_range {
+#define KVM_MSR_FILTER_READ  (1 << 0)
+#define KVM_MSR_FILTER_WRITE (1 << 1)
+	__u32 flags;
+	__u32 nmsrs; /* number of msrs in bitmap */
+	__u32 base;  /* MSR index the bitmap starts at */
+	__u8 *bitmap; /* a 1 bit allows the operations in flags, 0 denies */
+};
+
+#define KVM_MSR_FILTER_MAX_RANGES 16
+struct kvm_msr_filter {
+#define KVM_MSR_FILTER_DEFAULT_ALLOW (0 << 0)
+#define KVM_MSR_FILTER_DEFAULT_DENY  (1 << 0)
+	__u32 flags;
+	struct kvm_msr_filter_range ranges[KVM_MSR_FILTER_MAX_RANGES];
+};
 
 struct kvm_cpuid_entry {
 	__u32 function;
diff --git a/linux-headers/asm-x86/unistd_32.h b/linux-headers/asm-x86/unistd_32.h
index 356c12c..cfba368 100644
--- a/linux-headers/asm-x86/unistd_32.h
+++ b/linux-headers/asm-x86/unistd_32.h
@@ -430,6 +430,7 @@
 #define __NR_openat2 437
 #define __NR_pidfd_getfd 438
 #define __NR_faccessat2 439
+#define __NR_process_madvise 440
 
 
 #endif /* _ASM_X86_UNISTD_32_H */
diff --git a/linux-headers/asm-x86/unistd_64.h b/linux-headers/asm-x86/unistd_64.h
index ef70e1c..61af725 100644
--- a/linux-headers/asm-x86/unistd_64.h
+++ b/linux-headers/asm-x86/unistd_64.h
@@ -352,6 +352,7 @@
 #define __NR_openat2 437
 #define __NR_pidfd_getfd 438
 #define __NR_faccessat2 439
+#define __NR_process_madvise 440
 
 
 #endif /* _ASM_X86_UNISTD_64_H */
diff --git a/linux-headers/asm-x86/unistd_x32.h b/linux-headers/asm-x86/unistd_x32.h
index 84ae8e9..a6890cb 100644
--- a/linux-headers/asm-x86/unistd_x32.h
+++ b/linux-headers/asm-x86/unistd_x32.h
@@ -305,6 +305,7 @@
 #define __NR_openat2 (__X32_SYSCALL_BIT + 437)
 #define __NR_pidfd_getfd (__X32_SYSCALL_BIT + 438)
 #define __NR_faccessat2 (__X32_SYSCALL_BIT + 439)
+#define __NR_process_madvise (__X32_SYSCALL_BIT + 440)
 #define __NR_rt_sigaction (__X32_SYSCALL_BIT + 512)
 #define __NR_rt_sigreturn (__X32_SYSCALL_BIT + 513)
 #define __NR_ioctl (__X32_SYSCALL_BIT + 514)
diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
index 43580c7..56ce14a 100644
--- a/linux-headers/linux/kvm.h
+++ b/linux-headers/linux/kvm.h
@@ -248,6 +248,8 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
 #define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_X86_RDMSR        29
+#define KVM_EXIT_X86_WRMSR        30
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -413,6 +415,17 @@ struct kvm_run {
 			__u64 esr_iss;
 			__u64 fault_ipa;
 		} arm_nisv;
+		/* KVM_EXIT_X86_RDMSR / KVM_EXIT_X86_WRMSR */
+		struct {
+			__u8 error; /* user -> kernel */
+			__u8 pad[7];
+#define KVM_MSR_EXIT_REASON_INVAL	(1 << 0)
+#define KVM_MSR_EXIT_REASON_UNKNOWN	(1 << 1)
+#define KVM_MSR_EXIT_REASON_FILTER	(1 << 2)
+			__u32 reason; /* kernel -> user */
+			__u32 index; /* kernel -> user */
+			__u64 data; /* kernel <-> user */
+		} msr;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -1037,6 +1050,9 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_SMALLER_MAXPHYADDR 185
 #define KVM_CAP_S390_DIAG318 186
 #define KVM_CAP_STEAL_TIME 187
+#define KVM_CAP_X86_USER_SPACE_MSR 188
+#define KVM_CAP_X86_MSR_FILTER 189
+#define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1538,6 +1554,9 @@ struct kvm_pv_cmd {
 /* Available with KVM_CAP_S390_PROTECTED */
 #define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
 
+/* Available with KVM_CAP_X86_MSR_FILTER */
+#define KVM_X86_SET_MSR_FILTER	_IOW(KVMIO,  0xc6, struct kvm_msr_filter)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
diff --git a/linux-headers/linux/mman.h b/linux-headers/linux/mman.h
index 51ea363..434986f 100644
--- a/linux-headers/linux/mman.h
+++ b/linux-headers/linux/mman.h
@@ -27,6 +27,7 @@
 #define MAP_HUGE_SHIFT	HUGETLB_FLAG_ENCODE_SHIFT
 #define MAP_HUGE_MASK	HUGETLB_FLAG_ENCODE_MASK
 
+#define MAP_HUGE_16KB	HUGETLB_FLAG_ENCODE_16KB
 #define MAP_HUGE_64KB	HUGETLB_FLAG_ENCODE_64KB
 #define MAP_HUGE_512KB	HUGETLB_FLAG_ENCODE_512KB
 #define MAP_HUGE_1MB	HUGETLB_FLAG_ENCODE_1MB
diff --git a/linux-headers/linux/vfio.h b/linux-headers/linux/vfio.h
index a906724..b92dcc4 100644
--- a/linux-headers/linux/vfio.h
+++ b/linux-headers/linux/vfio.h
@@ -201,8 +201,11 @@ struct vfio_device_info {
 #define VFIO_DEVICE_FLAGS_AMBA  (1 << 3)	/* vfio-amba device */
 #define VFIO_DEVICE_FLAGS_CCW	(1 << 4)	/* vfio-ccw device */
 #define VFIO_DEVICE_FLAGS_AP	(1 << 5)	/* vfio-ap device */
+#define VFIO_DEVICE_FLAGS_FSL_MC (1 << 6)	/* vfio-fsl-mc device */
+#define VFIO_DEVICE_FLAGS_CAPS	(1 << 7)	/* Info supports caps */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
+	__u32   cap_offset;	/* Offset within info struct of first cap */
 };
 #define VFIO_DEVICE_GET_INFO		_IO(VFIO_TYPE, VFIO_BASE + 7)
 
@@ -218,6 +221,15 @@ struct vfio_device_info {
 #define VFIO_DEVICE_API_CCW_STRING		"vfio-ccw"
 #define VFIO_DEVICE_API_AP_STRING		"vfio-ap"
 
+/*
+ * The following capabilities are unique to s390 zPCI devices.  Their contents
+ * are further-defined in vfio_zdev.h
+ */
+#define VFIO_DEVICE_INFO_CAP_ZPCI_BASE		1
+#define VFIO_DEVICE_INFO_CAP_ZPCI_GROUP		2
+#define VFIO_DEVICE_INFO_CAP_ZPCI_UTIL		3
+#define VFIO_DEVICE_INFO_CAP_ZPCI_PFIP		4
+
 /**
  * VFIO_DEVICE_GET_REGION_INFO - _IOWR(VFIO_TYPE, VFIO_BASE + 8,
  *				       struct vfio_region_info)
@@ -462,7 +474,7 @@ struct vfio_region_gfx_edid {
  * 5. Resumed
  *                  |--------->|
  *
- * 0. Default state of VFIO device is _RUNNNG when the user application starts.
+ * 0. Default state of VFIO device is _RUNNING when the user application starts.
  * 1. During normal shutdown of the user application, the user application may
  *    optionally change the VFIO device state from _RUNNING to _STOP. This
  *    transition is optional. The vendor driver must support this transition but
@@ -1039,6 +1051,21 @@ struct vfio_iommu_type1_info_cap_migration {
 	__u64	max_dirty_bitmap_size;		/* in bytes */
 };
 
+/*
+ * The DMA available capability allows to report the current number of
+ * simultaneously outstanding DMA mappings that are allowed.
+ *
+ * The structure below defines version 1 of this capability.
+ *
+ * avail: specifies the current number of outstanding DMA mappings allowed.
+ */
+#define VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL 3
+
+struct vfio_iommu_type1_info_dma_avail {
+	struct	vfio_info_cap_header header;
+	__u32	avail;
+};
+
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
 
 /**
diff --git a/linux-headers/linux/vfio_zdev.h b/linux-headers/linux/vfio_zdev.h
new file mode 100644
index 0000000..b430939
--- /dev/null
+++ b/linux-headers/linux/vfio_zdev.h
@@ -0,0 +1,78 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * VFIO Region definitions for ZPCI devices
+ *
+ * Copyright IBM Corp. 2020
+ *
+ * Author(s): Pierre Morel <pmorel@linux.ibm.com>
+ *            Matthew Rosato <mjrosato@linux.ibm.com>
+ */
+
+#ifndef _VFIO_ZDEV_H_
+#define _VFIO_ZDEV_H_
+
+#include <linux/types.h>
+#include <linux/vfio.h>
+
+/**
+ * VFIO_DEVICE_INFO_CAP_ZPCI_BASE - Base PCI Function information
+ *
+ * This capability provides a set of descriptive information about the
+ * associated PCI function.
+ */
+struct vfio_device_info_cap_zpci_base {
+	struct vfio_info_cap_header header;
+	__u64 start_dma;	/* Start of available DMA addresses */
+	__u64 end_dma;		/* End of available DMA addresses */
+	__u16 pchid;		/* Physical Channel ID */
+	__u16 vfn;		/* Virtual function number */
+	__u16 fmb_length;	/* Measurement Block Length (in bytes) */
+	__u8 pft;		/* PCI Function Type */
+	__u8 gid;		/* PCI function group ID */
+};
+
+/**
+ * VFIO_DEVICE_INFO_CAP_ZPCI_GROUP - Base PCI Function Group information
+ *
+ * This capability provides a set of descriptive information about the group of
+ * PCI functions that the associated device belongs to.
+ */
+struct vfio_device_info_cap_zpci_group {
+	struct vfio_info_cap_header header;
+	__u64 dasm;		/* DMA Address space mask */
+	__u64 msi_addr;		/* MSI address */
+	__u64 flags;
+#define VFIO_DEVICE_INFO_ZPCI_FLAG_REFRESH 1 /* Program-specified TLB refresh */
+	__u16 mui;		/* Measurement Block Update Interval */
+	__u16 noi;		/* Maximum number of MSIs */
+	__u16 maxstbl;		/* Maximum Store Block Length */
+	__u8 version;		/* Supported PCI Version */
+};
+
+/**
+ * VFIO_DEVICE_INFO_CAP_ZPCI_UTIL - Utility String
+ *
+ * This capability provides the utility string for the associated device, which
+ * is a device identifier string made up of EBCDID characters.  'size' specifies
+ * the length of 'util_str'.
+ */
+struct vfio_device_info_cap_zpci_util {
+	struct vfio_info_cap_header header;
+	__u32 size;
+	__u8 util_str[];
+};
+
+/**
+ * VFIO_DEVICE_INFO_CAP_ZPCI_PFIP - PCI Function Path
+ *
+ * This capability provides the PCI function path string, which is an identifier
+ * that describes the internal hardware path of the device. 'size' specifies
+ * the length of 'pfip'.
+ */
+struct vfio_device_info_cap_zpci_pfip {
+	struct vfio_info_cap_header header;
+	__u32 size;
+	__u8 pfip[];
+};
+
+#endif
-- 
1.8.3.1

