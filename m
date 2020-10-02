Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697F8281C78
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgJBUBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:01:13 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:2004 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725833AbgJBUBM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:01:12 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092JZppa102688;
        Fri, 2 Oct 2020 16:01:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=rNmp4FZRzv7ZKUd/u8wzTGU/PEGj/lSBise2jp766C8=;
 b=CqvqCSzonCbo7I1Q3HRnPjgkqlxUFFH7LNh7T0UAFrJTHSVB95464cgQyU5STgjnVt+t
 l8YKimytFo+2B1u/KrRYW5WUkswOB9xI9ukTdMlA/PY2g1Mm3W4Tg1AjD5R07CDmU+a1
 yDcPXzS75qNeHGmTlQywIYDfxLahDI6LXn8oxE4fLT5OYL/gHXwqHBGewTxA3wLSt+BD
 Wf/E5EVTGEMwwl9ETDeJIhDLHqyeRujfdApcXonf74JHpDP/CZoxprtkbcP85HEYizav
 zv0Rp0lHR2HgHlqTPJpgDALhkrDUIy27QPLm0kH1l9WjeISZ16FjcSCkr0nL6cLYNwN5 ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x9qghg65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:00:57 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092JaT08104606;
        Fri, 2 Oct 2020 16:00:56 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x9qghg5h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:00:56 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092JmDFE007928;
        Fri, 2 Oct 2020 20:00:55 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma01wdc.us.ibm.com with ESMTP id 33sw9a082q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 20:00:55 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092K0mtx21824062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 20:00:48 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 53E3C6E04C;
        Fri,  2 Oct 2020 20:00:52 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3A2446E050;
        Fri,  2 Oct 2020 20:00:51 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.4.25])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 20:00:51 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] vfio-pci/zdev: define the vfio_zdev header
Date:   Fri,  2 Oct 2020 16:00:42 -0400
Message-Id: <1601668844-5798-4-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1601668844-5798-1-git-send-email-mjrosato@linux.ibm.com>
References: <1601668844-5798-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 mlxlogscore=707 bulkscore=0 spamscore=0 phishscore=0 priorityscore=1501
 clxscore=1015 mlxscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020137
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
 include/uapi/linux/vfio_zdev.h | 118 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 123 insertions(+)
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
index 0000000..1c8fb62
--- /dev/null
+++ b/include/uapi/linux/vfio_zdev.h
@@ -0,0 +1,118 @@
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
+};
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
+};
+
+/**
+ * struct vfio_region_zpci_info_pci - Base PCI Function information
+ *
+ * This region provides a set of descriptive information about the associated
+ * PCI function.
+ */
+#define VFIO_REGION_ZPCI_INFO_BASE	1
+
+struct vfio_region_zpci_info_base {
+	struct vfio_region_zpci_info_hdr hdr;
+	__u64 start_dma;	/* Start of available DMA addresses */
+	__u64 end_dma;		/* End of available DMA addresses */
+	__u16 pchid;		/* Physical Channel ID */
+	__u16 vfn;		/* Virtual function number */
+	__u16 fmb_length;	/* Measurement Block Length (in bytes) */
+	__u8 pft;		/* PCI Function Type */
+	__u8 gid;		/* PCI function group ID */
+};
+
+
+/**
+ * struct vfio_region_zpci_info_group - Base PCI Function Group information
+ *
+ * This region provides a set of descriptive information about the group of PCI
+ * functions that the associated device belongs to.
+ */
+#define VFIO_REGION_ZPCI_INFO_GROUP	2
+
+struct vfio_region_zpci_info_group {
+	struct vfio_region_zpci_info_hdr hdr;
+	__u64 dasm;		/* DMA Address space mask */
+	__u64 msi_addr;		/* MSI address */
+	__u64 flags;
+#define VFIO_PCI_ZDEV_FLAGS_REFRESH 1 /* Use program-specified TLB refresh */
+	__u16 mui;		/* Measurement Block Update Interval */
+	__u16 noi;		/* Maximum number of MSIs */
+	__u16 maxstbl;		/* Maximum Store Block Length */
+	__u8 version;		/* Supported PCI Version */
+};
+
+/**
+ * struct vfio_region_zpci_info_util - Utility String
+ *
+ * This region provides the utility string for the associated device, which is
+ * a device identifier string made up of EBCDID characters.  'size' specifies
+ * the length of 'util_str'.
+ */
+#define VFIO_REGION_ZPCI_INFO_UTIL	3
+
+struct vfio_region_zpci_info_util {
+	struct vfio_region_zpci_info_hdr hdr;
+	__u32 size;
+	__u8 util_str[];
+};
+
+/**
+ * struct vfio_region_zpci_info_pfip - PCI Function Path
+ *
+ * This region provides the PCI function path string, which is an identifier
+ * that describes the internal hardware path of the device. 'size' specifies
+ * the length of 'pfip'.
+ */
+#define VFIO_REGION_ZPCI_INFO_PFIP	4
+
+struct vfio_region_zpci_info_pfip {
+struct vfio_region_zpci_info_hdr hdr;
+	__u32 size;
+	__u8 pfip[];
+};
+
+#endif
-- 
1.8.3.1

