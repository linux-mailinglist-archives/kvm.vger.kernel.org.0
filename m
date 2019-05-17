Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86C5221B5D
	for <lists+kvm@lfdr.de>; Fri, 17 May 2019 18:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbfEQQRA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 May 2019 12:17:00 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32772 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729249AbfEQQRA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 May 2019 12:17:00 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4HG7FbY028304
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 12:16:59 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2shxe7d4pa-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 17 May 2019 12:16:59 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Fri, 17 May 2019 17:16:57 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 May 2019 17:16:54 +0100
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4HGGqDG47644828
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 May 2019 16:16:52 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA34F52073;
        Fri, 17 May 2019 16:16:52 +0000 (GMT)
Received: from morel-ThinkPad-W530.boeblingen.de.ibm.com (unknown [9.145.153.112])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 2531B52071;
        Fri, 17 May 2019 16:16:52 +0000 (GMT)
From:   Pierre Morel <pmorel@linux.ibm.com>
To:     sebott@linux.vnet.ibm.com
Cc:     gerald.schaefer@de.ibm.com, pasic@linux.vnet.ibm.com,
        borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        robin.murphy@arm.com
Subject: [PATCH v2 2/4] vfio: vfio_iommu_type1: Define VFIO_IOMMU_INFO_CAPABILITIES
Date:   Fri, 17 May 2019 18:16:48 +0200
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558109810-18683-1-git-send-email-pmorel@linux.ibm.com>
References: <1558109810-18683-1-git-send-email-pmorel@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19051716-0008-0000-0000-000002E7C7C9
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051716-0009-0000-0000-0000225472E3
Message-Id: <1558109810-18683-3-git-send-email-pmorel@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-17_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905170098
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We add a capabilities functionality to VFIO_IOMMU_GET_INFO.

This will allow the VFIO_IOMMU_GET_INFO ioctl to retrieve IOMMU
specific information.

we define a new flag VFIO_IOMMU_INFO_CAPABILITIES in the
vfio_iommu_type1_info structure and two Z-PCI specific
capabilities:
VFIO_IOMMU_INFO_CAP_QFN: to query Z-PCI function information
VFIO_IOMMU_INFO_CAP_QGRP: to query for Z-PCI group information
and we define the associated information structures.

Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
---
 include/uapi/linux/vfio.h | 67 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 8f10748..aed0e72 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -715,6 +715,73 @@ struct vfio_iommu_type1_info {
 	__u32	flags;
 #define VFIO_IOMMU_INFO_PGSIZES (1 << 0)	/* supported page sizes info */
 	__u64	iova_pgsizes;		/* Bitmap of supported page sizes */
+#define VFIO_IOMMU_INFO_CAPABILITIES (1 << 1)  /* support capabilities info */
+	__u64   cap_offset;     /* Offset within info struct of first cap */
+};
+
+/*
+ * The VFIO IOMMU INFO  PCI function capability allows to retrieve
+ * Z-PCI function specific data needed by the VFIO user to provide
+ * them to the guest function's driver.
+ *
+ * The structures below define version 1 of this capability.
+ */
+#define VFIO_IOMMU_INFO_CAP_QFN		1
+
+struct vfio_iommu_pci_function {
+	__u32 ignored;
+	__u32 format;		/* Structure format */
+	__u64 reserved1;
+	__u16 vfn;		/* Virtual function number */
+	__u8 u;			/* utility string presence */
+	__u8 gid;		/* Function group */
+	__u32 fid;		/* Function identifier */
+	__u8 bar_size[6];	/* Bar size */
+	__u16 pchid;		/* Physical channel ID */
+	__u32 bar[6];		/* PCI Bar address */
+	__u64 reserved2;
+	__u64 sdma;		/* Start available DMA */
+	__u64 edma;		/* End available DMA */
+	__u32 reserved3[11];
+	__u32 uid;		/* User's identifier */
+	__u8 util_str[64];	/* Adapter specific utility string */
+};
+
+struct vfio_iommu_type1_info_pcifn {
+	struct vfio_info_cap_header header;
+	struct vfio_iommu_pci_function response;
+};
+
+/*
+ * The VFIO IOMMU INFO PCI function group capability allows to retrieve
+ * information, specific to a group of Z-PCI functions, needed by
+ * the VFIO user to provide them to the guest function's driver.
+ *
+ * The structures below define version 1 of this capability.
+ */
+#define VFIO_IOMMU_INFO_CAP_QGRP	2
+
+struct vfio_iommu_pci_function_group {
+	__u32 ignored;
+	__u32 format;		/* Structure format */
+	__u64 reserved1;
+	__u16 noi;		/* Maximum number of interruptions */
+	__u8 version;		/* Version */
+	__u8 flags;		/* Flags */
+#define VFIO_IOMMU_ZPCI_REFRESH	0x01
+#define VFIO_IOMMU_ZPCI_FRAME	0x02
+	__u16 maxstbl;		/* Maximum store-block length */
+	__u16 mui;		/* Measurement block update interval */
+	__u64 reserved3;
+	__u64 dasm;		/* DMA Address space mask */
+	__u64 msia;		/* MSI Address */
+	__u64 reserved4;
+	__u64 reserved5;
+};
+
+struct vfio_iommu_type1_info_pcifg {
+	struct vfio_info_cap_header header;
+	struct vfio_iommu_pci_function_group response;
 };
 
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
-- 
2.7.4

