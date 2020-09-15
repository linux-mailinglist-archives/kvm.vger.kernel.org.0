Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD8126AD28
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 21:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbgIOTKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 15:10:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61928 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727976AbgIOTFg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 15:05:36 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FIXi1v032846;
        Tue, 15 Sep 2020 15:05:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=sjt/S6np6D4/53bKdF+p/e8fPp0Y4PQPdKkW3dJL2fs=;
 b=eaCGTvAIdJpMsxQ+XhIMCwXW1jv2Sd71kMNcypHrjbp2gvUi7L9KolDJikOUsr+Uv4th
 6dF2RqqMNtrEsvCb4i60wQpheGTUujSp2LDYFm0W5K8o0I2iLaU7D44Am0Qx7zHvszgg
 niwfDqZDaEGhgjuwcpT7xrqsHLW/FLG8xPhDkUzxLVKumBBS/mqluUVbIUX0yeyStXJg
 1tyOJvaeeCbORKwJaXWmYluONZNoRy01QhKsK9mlzzkUEc13f2tZCTTQvC3q93qi3LSs
 p5fImLLwrdaFB8RlYF03jFnSqSquRjfguXkjntnf2rlnXzapbuItIKT1LGcXByVvIx4M Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33k2q8s9en-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 15:05:25 -0400
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08FIXwlG033569;
        Tue, 15 Sep 2020 15:05:25 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33k2q8s9e9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 15:05:25 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08FIuZcp022125;
        Tue, 15 Sep 2020 19:05:24 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma03dal.us.ibm.com with ESMTP id 33gny9g1y4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 19:05:24 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08FJ5NfO63898042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 19:05:23 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3074F7805C;
        Tue, 15 Sep 2020 19:05:23 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5A0027805F;
        Tue, 15 Sep 2020 19:05:22 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.85.51])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 15 Sep 2020 19:05:22 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] vfio iommu: Add dma available capability
Date:   Tue, 15 Sep 2020 15:05:18 -0400
Message-Id: <1600196718-23238-2-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600196718-23238-1-git-send-email-mjrosato@linux.ibm.com>
References: <1600196718-23238-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_12:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 malwarescore=0 suspectscore=0 phishscore=0 clxscore=1015 spamscore=0
 bulkscore=0 adultscore=0 mlxlogscore=739 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 492855939bdb ("vfio/type1: Limit DMA mappings per container")
added the ability to limit the number of memory backed DMA mappings.
However on s390x, when lazy mapping is in use, we use a very large
number of concurrent mappings.  Let's provide the current allowable
number of DMA mappings to userspace via the IOMMU info chain so that
userspace can take appropriate mitigation.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++++++++
 include/uapi/linux/vfio.h       | 15 +++++++++++++++
 2 files changed, 32 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5fbf0c1..15e21db 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2609,6 +2609,20 @@ static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
 	return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
 }
 
+static int vfio_iommu_dma_avail_build_caps(struct vfio_iommu *iommu,
+					   struct vfio_info_cap *caps)
+{
+	struct vfio_iommu_type1_info_dma_avail cap_dma_avail;
+
+	cap_dma_avail.header.id = VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL;
+	cap_dma_avail.header.version = 1;
+
+	cap_dma_avail.avail = iommu->dma_avail;
+
+	return vfio_info_add_capability(caps, &cap_dma_avail.header,
+					sizeof(cap_dma_avail));
+}
+
 static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
 				     unsigned long arg)
 {
@@ -2642,6 +2656,9 @@ static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
 	ret = vfio_iommu_migration_build_caps(iommu, &caps);
 
 	if (!ret)
+		ret = vfio_iommu_dma_avail_build_caps(iommu, &caps);
+
+	if (!ret)
 		ret = vfio_iommu_iova_build_caps(iommu, &caps);
 
 	mutex_unlock(&iommu->lock);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9204705..3891e03 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1039,6 +1039,21 @@ struct vfio_iommu_type1_info_cap_migration {
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
-- 
1.8.3.1

