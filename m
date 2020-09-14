Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BCD2698C0
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 00:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgINWZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 18:25:45 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725978AbgINWZl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Sep 2020 18:25:41 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EMBQUj134928;
        Mon, 14 Sep 2020 18:25:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references; s=pp1;
 bh=FCgI4rIz8x5AS5bq9tJM0eW3jbCMFd0+4ituB3B5/lA=;
 b=XhbRqLeYUfZZKvw0gG3TfJh3bp6EppPxX/U8cAQ8YvFlcj+nzXyD+2sXEQcRfUcoUey7
 0GLaHWGeQCt+5jBnE2m4N8OgQhPwqbmvYIiITxUSAX1HCXCJqD/Hq+dcggLhtFA3MoOl
 iPJ5HmXAnZguAkIssnQKOuXzSzUeOqwqfx4OA3NfK5fpSiYS15X1psjuJfi0DjoLe4p8
 JwmZ28tbf33KFF/QlpZ9DNzVxKp1HUc0ldSLSnwBKrQpLNJFGEuvEtJzz8mhIOpbCHgz
 KvEalJhjhdRoLxlyV5QldA+yzGMYS5ITWrDwWhIVdmGw1G+QsYh9bC8oi6Taq8mZGmp5 Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33jh3fg856-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 18:25:39 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08EMCLP6137347;
        Mon, 14 Sep 2020 18:25:39 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33jh3fg851-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 18:25:39 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08EM2dPN019664;
        Mon, 14 Sep 2020 22:25:39 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02dal.us.ibm.com with ESMTP id 33gny8ysmd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 22:25:38 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08EMPc4323265738
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 22:25:38 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1FFD8124052;
        Mon, 14 Sep 2020 22:25:38 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF241124054;
        Mon, 14 Sep 2020 22:25:36 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.85.51])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 14 Sep 2020 22:25:36 +0000 (GMT)
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] vfio iommu: Add dma available capability
Date:   Mon, 14 Sep 2020 18:25:31 -0400
Message-Id: <1600122331-12181-2-git-send-email-mjrosato@linux.ibm.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1600122331-12181-1-git-send-email-mjrosato@linux.ibm.com>
References: <1600122331-12181-1-git-send-email-mjrosato@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_09:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=803
 clxscore=1015 impostorscore=0 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 suspectscore=0 spamscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140166
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
 include/uapi/linux/vfio.h       | 16 ++++++++++++++++
 2 files changed, 33 insertions(+)

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
index 9204705..a8cc4a5 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -1039,6 +1039,22 @@ struct vfio_iommu_type1_info_cap_migration {
 	__u64	max_dirty_bitmap_size;		/* in bytes */
 };
 
+/*
+ * The DMA available capability allows to report the current number of
+ * simultaneously outstanding DMA mappings that are allowed.
+ *
+ * The structures below define version 1 of this capability.
+ *
+ * max: specifies the maximum number of outstanding DMA mappings allowed.
+ */
+#define VFIO_IOMMU_TYPE1_INFO_DMA_AVAIL 3
+
+struct vfio_iommu_type1_info_dma_avail {
+	struct	vfio_info_cap_header header;
+	__u32	avail;
+};
+
+
 #define VFIO_IOMMU_GET_INFO _IO(VFIO_TYPE, VFIO_BASE + 12)
 
 /**
-- 
1.8.3.1

