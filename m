Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7E82664B5
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 18:44:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgIKQof (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 12:44:35 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13128 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726392AbgIKQoT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 12:44:19 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08BGYkvk024226;
        Fri, 11 Sep 2020 12:44:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=jaxEgQC6wdaz4q4DPBtqSbQcompo/vEQ4h4vw9qyZ58=;
 b=cDk7oIWtwX2DxKkZwQcb581iwmL4GVmZSOpFkK5XUYF/hKTA/pnYztMgC6k/BrmXOfFA
 PZt6w5k7rTjO9SWHS/VVqc8DQv+628stSHRrAPpSCsPTHGN4DkWBsrLlbIh7EnIf0PbM
 5AQhPjyoBRMobOZ/63lp+rBJUO2RsdktlMuMkZAbOZbNSocv12UznaJPfN6CKVEnpiuj
 6EoSYAr4KmSi+U/ZGNgpffuuUec2pulTVaCd2ouRIiAyMMHN/DtUK0vJk9gn2suhpGvh
 P3xUfqLCVCFR5WDp66shLW75Fx5GQ4Ms7Obdzs+wgKRnV/Ej1ii6LpbDVt6M9vcxhpDP fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33gcdy8y2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 12:44:13 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08BGZ82e025595;
        Fri, 11 Sep 2020 12:44:13 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33gcdy8y2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 12:44:13 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08BGgVux018955;
        Fri, 11 Sep 2020 16:44:12 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma02dal.us.ibm.com with ESMTP id 33c2aa5f8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 16:44:12 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08BGiBQr38928760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 16:44:11 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FC48B205F;
        Fri, 11 Sep 2020 16:44:11 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EBDE8B2064;
        Fri, 11 Sep 2020 16:44:09 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.91.207])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 11 Sep 2020 16:44:09 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vfio iommu: Add dma limit capability
Date:   Fri, 11 Sep 2020 12:44:03 -0400
Message-Id: <1599842643-2553-2-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1599842643-2553-1-git-send-email-mjrosato@linux.ibm.com>
References: <1599842643-2553-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-11_08:2020-09-10,2020-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=887 impostorscore=0
 mlxscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 492855939bdb ("vfio/type1: Limit DMA mappings per container")
added the ability to limit the number of memory backed DMA mappings.
However on s390x, when lazy mapping is in use, we use a very large
number of concurrent mappings.  Let's provide the limitation to
userspace via the IOMMU info chain so that userspace can take
appropriate mitigation.

Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++++++++
 include/uapi/linux/vfio.h       | 16 ++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 5fbf0c1..573c2c9 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -2609,6 +2609,20 @@ static int vfio_iommu_migration_build_caps(struct vfio_iommu *iommu,
 	return vfio_info_add_capability(caps, &cap_mig.header, sizeof(cap_mig));
 }
 
+static int vfio_iommu_dma_limit_build_caps(struct vfio_iommu *iommu,
+					   struct vfio_info_cap *caps)
+{
+	struct vfio_iommu_type1_info_dma_limit cap_dma_limit;
+
+	cap_dma_limit.header.id = VFIO_IOMMU_TYPE1_INFO_DMA_LIMIT;
+	cap_dma_limit.header.version = 1;
+
+	cap_dma_limit.max = dma_entry_limit;
+
+	return vfio_info_add_capability(caps, &cap_dma_limit.header,
+					sizeof(cap_dma_limit));
+}
+
 static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
 				     unsigned long arg)
 {
@@ -2642,6 +2656,9 @@ static int vfio_iommu_type1_get_info(struct vfio_iommu *iommu,
 	ret = vfio_iommu_migration_build_caps(iommu, &caps);
 
 	if (!ret)
+		ret = vfio_iommu_dma_limit_build_caps(iommu, &caps);
+
+	if (!ret)
 		ret = vfio_iommu_iova_build_caps(iommu, &caps);
 
 	mutex_unlock(&iommu->lock);
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 9204705..c91e471 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1039,6 +1039,22 @@ struct vfio_iommu_type1_info_cap_migration {
 	__u64	max_dirty_bitmap_size;		/* in bytes */
 };
 
+/*
+ * The DMA limit capability allows to report the number of simultaneously
+ * outstanding DMA mappings are supported.
+ *
+ * The structures below define version 1 of this capability.
+ *
+ * max: specifies the maximum number of outstanding DMA mappings allowed.
+ */
+#define VFIO_IOMMU_TYPE1_INFO_DMA_LIMIT 3
+
+struct vfio_iommu_type1_info_dma_limit {
+	struct	vfio_info_cap_header header;
+	__u32	max;
+};
+
+
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
 
 /**
-- 
1.8.3.1

