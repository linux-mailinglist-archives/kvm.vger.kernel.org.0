Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F720270EF7
	for <lists+kvm@lfdr.de>; Sat, 19 Sep 2020 17:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgISP2w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Sep 2020 11:28:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48220 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726591AbgISP2v (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 19 Sep 2020 11:28:51 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08JF1F8P153397;
        Sat, 19 Sep 2020 11:28:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=jQR2PMWD32tMEcTViSKBVR2fWlp9m7EWbKGal9jnzWw=;
 b=Lm2KygssmGOuM+c+5DONOusFE8I7OaUiEtE8fv/X5MVw22/GIZQwwKkNZwMU7zzrXvIm
 xIRXumf4OaAShbS5gy8KcE8rKi/+ZHd9A4BVUWkTpTQEX+x2+gjKWr6vLiNz1FHoLWcc
 Xq/mewP+txVN+s4dieiwqHEtt0KVWSEEaGdfeqOpFGi+WRDImkyEn3j47WeN8SbrlCZV
 8pXU/SRw87k9KQ4GTZCCF8T97S8qCNPQwyPycbjotdecPDTgWJ3teCNT2NmsSBTBVR/S
 pyhhPTnUgCi0l9czCwsvZ08UA/0KmvRmqpGxJPJ7r6rJTSsGxgcERAKncx7c09h5etcH pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33nm3ggmgy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 11:28:49 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08JFNFr9005029;
        Sat, 19 Sep 2020 11:28:49 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33nm3ggmgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 11:28:49 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08JFS6t5029691;
        Sat, 19 Sep 2020 15:28:48 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04wdc.us.ibm.com with ESMTP id 33n9m8b6kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 15:28:48 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08JFSjcX50331924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Sep 2020 15:28:45 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 852C7BE054;
        Sat, 19 Sep 2020 15:28:45 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 68E95BE053;
        Sat, 19 Sep 2020 15:28:44 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.74.107])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Sat, 19 Sep 2020 15:28:44 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] vfio-pci/zdev: define the vfio_zdev header
Date:   Sat, 19 Sep 2020 11:28:37 -0400
Message-Id: <1600529318-8996-4-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
References: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-19_05:2020-09-16,2020-09-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009190126
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We define a new device region in vfio.h to be able to get the ZPCI CLP
information by reading this region from userspace.

We create a new file, vfio_zdev.h to define the structure of the new
region defined in vfio.h

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 include/uapi/linux/vfio.h      |   5 ++
 include/uapi/linux/vfio_zdev.h | 116 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 121 insertions(+)
 create mode 100644 include/uapi/linux/vfio_zdev.h

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9204705..65eb367 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -326,6 +326,11 @@ struct vfio_region_info_cap_type {
  * to do TLB invalidation on a GPU.
  */
 #define VFIO_REGION_SUBTYPE_IBM_NVLINK2_ATSD	(1)
+/*
+ * IBM zPCI specific hardware feature information for a devcie.  The contents
+ * of this region are mapped by struct vfio_region_zpci_info.
+ */
+#define VFIO_REGION_SUBTYPE_IBM_ZPCI_CLP	(2)
 
 /* sub-types for VFIO_REGION_TYPE_GFX */
 #define VFIO_REGION_SUBTYPE_GFX_EDID            (1)
diff --git a/include/uapi/linux/vfio_zdev.h b/include/uapi/linux/vfio_zdev.h
new file mode 100644
index 0000000..c9e4891
--- /dev/null
+++ b/include/uapi/linux/vfio_zdev.h
@@ -0,0 +1,116 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Region definition for ZPCI devices
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
+
+/**
+ * struct vfio_region_zpci_info - ZPCI information
+ *
+ * This region provides zPCI specific hardware feature information for a
+ * device.
+ *
+ * The ZPCI information structure is presented as a chain of CLP features
+ * defined below. argsz provides the size of the entire region, and offset
+ * provides the location of the first CLP feature in the chain.
+ *
+ */
+struct vfio_region_zpci_info {
+	__u32 argsz;		/* Size of entire payload */
+	__u32 offset;		/* Location of first entry */
+} __packed;
+
+/**
+ * struct vfio_region_zpci_info_hdr - ZPCI header information
+ *
+ * This structure is included at the top of each CLP feature to define what
+ * type of CLP feature is presented / the structure version. The next value
+ * defines the offset of the next CLP feature, and is an offset from the very
+ * beginning of the region (vfio_region_zpci_info).
+ *
+ * Each CLP feature must have it's own unique 'id'.
+ */
+struct vfio_region_zpci_info_hdr {
+	__u16 id;		/* Identifies the CLP type */
+	__u16	version;	/* version of the CLP data */
+	__u32 next;		/* Offset of next entry */
+} __packed;
+
+/**
+ * struct vfio_region_zpci_info_qpci - Initial Query PCI information
+ *
+ * This region provides an initial set of data from the Query PCI Function
+ * CLP.
+ */
+#define VFIO_REGION_ZPCI_INFO_QPCI	1
+
+struct vfio_region_zpci_info_qpci {
+	struct vfio_region_zpci_info_hdr hdr;
+	__u64 start_dma;	/* Start of available DMA addresses */
+	__u64 end_dma;		/* End of available DMA addresses */
+	__u16 pchid;		/* Physical Channel ID */
+	__u16 vfn;		/* Virtual function number */
+	__u16 fmb_length;	/* Measurement Block Length (in bytes) */
+	__u8 pft;		/* PCI Function Type */
+	__u8 gid;		/* PCI function group ID */
+} __packed;
+
+
+/**
+ * struct vfio_region_zpci_info_qpcifg - Initial Query PCI Function Group info
+ *
+ * This region provides an initial set of data from the Query PCI Function
+ * Group CLP.
+ */
+#define VFIO_REGION_ZPCI_INFO_QPCIFG	2
+
+struct vfio_region_zpci_info_qpcifg {
+	struct vfio_region_zpci_info_hdr hdr;
+	__u64 dasm;		/* DMA Address space mask */
+	__u64 msi_addr;		/* MSI address */
+	__u64 flags;
+#define VFIO_PCI_ZDEV_FLAGS_REFRESH 1 /* Use program-specified TLB refresh */
+	__u16 mui;		/* Measurement Block Update Interval */
+	__u16 noi;		/* Maximum number of MSIs */
+	__u16 maxstbl;		/* Maximum Store Block Length */
+	__u8 version;		/* Supported PCI Version */
+} __packed;
+
+/**
+ * struct vfio_region_zpci_info_util - Utility String
+ *
+ * This region provides the utility string for the associated device, which is
+ * a device identifier string.
+ */
+#define VFIO_REGION_ZPCI_INFO_UTIL	3
+
+struct vfio_region_zpci_info_util {
+	struct vfio_region_zpci_info_hdr hdr;
+	__u32 size;
+	__u8 util_str[];
+} __packed;
+
+/**
+ * struct vfio_region_zpci_info_pfip - PCI Function Path
+ *
+ * This region provides the PCI function path string, which is an identifier
+ * that describes the internal hardware path of the device.
+ */
+#define VFIO_REGION_ZPCI_INFO_PFIP	4
+
+struct vfio_region_zpci_info_pfip {
+struct vfio_region_zpci_info_hdr hdr;
+	__u32 size;
+	__u8 pfip[];
+} __packed;
+
+#endif
-- 
1.8.3.1

