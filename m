Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89FA8423A6
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 13:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438208AbfFLLNQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 07:13:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:33706 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2438218AbfFLLNP (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 12 Jun 2019 07:13:15 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5CBCKv7119010
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 07:13:14 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t2x2kpdg1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 12 Jun 2019 07:13:14 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Wed, 12 Jun 2019 12:13:12 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 12 Jun 2019 12:13:08 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5CBD6Qc8650786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jun 2019 11:13:06 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7D6864204C;
        Wed, 12 Jun 2019 11:13:06 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D50494204F;
        Wed, 12 Jun 2019 11:13:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jun 2019 11:13:05 +0000 (GMT)
From:   Halil Pasic <pasic@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>,
        Sebastian Ott <sebott@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        virtualization@lists.linux-foundation.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Michael Mueller <mimu@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        "Jason J. Herne" <jjherne@linux.ibm.com>
Subject: [PATCH v5 8/8] virtio/s390: make airq summary indicators DMA
Date:   Wed, 12 Jun 2019 13:12:36 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190612111236.99538-1-pasic@linux.ibm.com>
References: <20190612111236.99538-1-pasic@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061211-0020-0000-0000-000003496FD6
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061211-0021-0000-0000-0000219C9FEE
Message-Id: <20190612111236.99538-9-pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-12_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906120078
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hypervisor needs to interact with the summary indicators, so these
need to be DMA memory as well (at least for protected virtualization
guests).

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/virtio/virtio_ccw.c | 32 ++++++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 800252955a2f..1a55e5942d36 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -140,11 +140,17 @@ static int virtio_ccw_use_airq = 1;
 
 struct airq_info {
 	rwlock_t lock;
-	u8 summary_indicator;
+	u8 summary_indicator_idx;
 	struct airq_struct airq;
 	struct airq_iv *aiv;
 };
 static struct airq_info *airq_areas[MAX_AIRQ_AREAS];
+static u8 *summary_indicators;
+
+static inline u8 *get_summary_indicator(struct airq_info *info)
+{
+	return summary_indicators + info->summary_indicator_idx;
+}
 
 #define CCW_CMD_SET_VQ 0x13
 #define CCW_CMD_VDEV_RESET 0x33
@@ -209,7 +215,7 @@ static void virtio_airq_handler(struct airq_struct *airq, bool floating)
 			break;
 		vring_interrupt(0, (void *)airq_iv_get_ptr(info->aiv, ai));
 	}
-	info->summary_indicator = 0;
+	*(get_summary_indicator(info)) = 0;
 	smp_wmb();
 	/* Walk through indicators field, summary indicator not active. */
 	for (ai = 0;;) {
@@ -221,7 +227,7 @@ static void virtio_airq_handler(struct airq_struct *airq, bool floating)
 	read_unlock(&info->lock);
 }
 
-static struct airq_info *new_airq_info(void)
+static struct airq_info *new_airq_info(int index)
 {
 	struct airq_info *info;
 	int rc;
@@ -237,7 +243,8 @@ static struct airq_info *new_airq_info(void)
 		return NULL;
 	}
 	info->airq.handler = virtio_airq_handler;
-	info->airq.lsi_ptr = &info->summary_indicator;
+	info->summary_indicator_idx = index;
+	info->airq.lsi_ptr = get_summary_indicator(info);
 	info->airq.lsi_mask = 0xff;
 	info->airq.isc = VIRTIO_AIRQ_ISC;
 	rc = register_adapter_interrupt(&info->airq);
@@ -259,7 +266,7 @@ static unsigned long get_airq_indicator(struct virtqueue *vqs[], int nvqs,
 
 	for (i = 0; i < MAX_AIRQ_AREAS && !indicator_addr; i++) {
 		if (!airq_areas[i])
-			airq_areas[i] = new_airq_info();
+			airq_areas[i] = new_airq_info(i);
 		info = airq_areas[i];
 		if (!info)
 			return 0;
@@ -345,7 +352,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 		if (!thinint_area)
 			return;
 		thinint_area->summary_indicator =
-			(unsigned long) &airq_info->summary_indicator;
+			(unsigned long) get_summary_indicator(airq_info);
 		thinint_area->isc = VIRTIO_AIRQ_ISC;
 		ccw->cmd_code = CCW_CMD_SET_IND_ADAPTER;
 		ccw->count = sizeof(*thinint_area);
@@ -613,7 +620,7 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
 	}
 	info = vcdev->airq_info;
 	thinint_area->summary_indicator =
-		(unsigned long) &info->summary_indicator;
+		(unsigned long) get_summary_indicator(info);
 	thinint_area->isc = VIRTIO_AIRQ_ISC;
 	ccw->cmd_code = CCW_CMD_SET_IND_ADAPTER;
 	ccw->flags = CCW_FLAG_SLI;
@@ -1493,8 +1500,17 @@ static void __init no_auto_parse(void)
 
 static int __init virtio_ccw_init(void)
 {
+	int rc;
+
 	/* parse no_auto string before we do anything further */
 	no_auto_parse();
-	return ccw_driver_register(&virtio_ccw_driver);
+
+	summary_indicators = cio_dma_zalloc(MAX_AIRQ_AREAS);
+	if (!summary_indicators)
+		return -ENOMEM;
+	rc = ccw_driver_register(&virtio_ccw_driver);
+	if (rc)
+		cio_dma_free(summary_indicators, MAX_AIRQ_AREAS);
+	return rc;
 }
 device_initcall(virtio_ccw_init);
-- 
2.17.1

