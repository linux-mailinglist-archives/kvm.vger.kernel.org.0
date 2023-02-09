Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBE86904B6
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 11:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjBIKZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 05:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjBIKZR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 05:25:17 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748AE5EF80;
        Thu,  9 Feb 2023 02:25:15 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3199AICo023579;
        Thu, 9 Feb 2023 10:25:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=TlTzKKP6pDzT9DQGLCvV8tAQqCFP51HSn9E5f8cJ2a0=;
 b=nqJ/2lGifpvOuLuN6kXPvqXFYs0ZqmLEqZPm0RsisQx9Fa6Hf4YqtWhlaGeHyJMf3Gfm
 iI9zgXS/R7Drr3nS1YJHQTnOwTgGaz5isM2qCAZ4UbNaxHFdjHKt9JlRqz3naMiur8S2
 hvDsj4MQ1pDi+r3gm3MLV2POowCM/sAGxRwNC4YdR27C3x3WbN3CR9qt49hZ/MLjzAKV
 Nrk14dyA+zbokmrlFdXLAQEuVau8fySSu+7f+ywBCI0KdOPt1ZVpcjGSOdjaD7kRYNL5
 pa+zoHmvqXVvWrgWupVCHzeMWKOrg4Bw78NuDrrkR/m5Fl1+TPIgcKkhfU3j3B+KT8Zq pA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmw7w2w01-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:14 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3199CrmV001869;
        Thu, 9 Feb 2023 10:25:14 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nmw7w2vy6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:14 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 318JQabI022560;
        Thu, 9 Feb 2023 10:25:11 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3nhemfp23p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 10:25:11 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319AP8XE47186352
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 10:25:08 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A4D520071;
        Thu,  9 Feb 2023 10:25:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E28952006A;
        Thu,  9 Feb 2023 10:25:07 +0000 (GMT)
Received: from li-9fd7f64c-3205-11b2-a85c-df942b00d78d.ibm.com (unknown [9.152.224.253])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 10:25:07 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        hca@linux.ibm.com
Subject: [GIT PULL 18/18] s390/virtio: sort out physical vs virtual pointers usage
Date:   Thu,  9 Feb 2023 11:23:00 +0100
Message-Id: <20230209102300.12254-19-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230209102300.12254-1-frankja@linux.ibm.com>
References: <20230209102300.12254-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: PmZ0qYwnmbOOOfIoNjgGWjE1WBi1QvHx
X-Proofpoint-GUID: HtHxzpF5mBRSPZ2k2YTK0wuEYLxwhCzZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_05,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 bulkscore=0 lowpriorityscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 clxscore=1015 impostorscore=0 spamscore=0
 adultscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

This does not fix a real bug, since virtual addresses
are currently indentical to physical ones.

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 drivers/s390/virtio/virtio_ccw.c | 46 +++++++++++++++++---------------
 1 file changed, 24 insertions(+), 22 deletions(-)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index a10dbe632ef9..954fc31b4bc7 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -363,7 +363,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 		thinint_area->isc = VIRTIO_AIRQ_ISC;
 		ccw->cmd_code = CCW_CMD_SET_IND_ADAPTER;
 		ccw->count = sizeof(*thinint_area);
-		ccw->cda = (__u32)(unsigned long) thinint_area;
+		ccw->cda = (__u32)virt_to_phys(thinint_area);
 	} else {
 		/* payload is the address of the indicators */
 		indicatorp = ccw_device_dma_zalloc(vcdev->cdev,
@@ -373,7 +373,7 @@ static void virtio_ccw_drop_indicator(struct virtio_ccw_device *vcdev,
 		*indicatorp = 0;
 		ccw->cmd_code = CCW_CMD_SET_IND;
 		ccw->count = sizeof(indicators(vcdev));
-		ccw->cda = (__u32)(unsigned long) indicatorp;
+		ccw->cda = (__u32)virt_to_phys(indicatorp);
 	}
 	/* Deregister indicators from host. */
 	*indicators(vcdev) = 0;
@@ -417,7 +417,7 @@ static int virtio_ccw_read_vq_conf(struct virtio_ccw_device *vcdev,
 	ccw->cmd_code = CCW_CMD_READ_VQ_CONF;
 	ccw->flags = 0;
 	ccw->count = sizeof(struct vq_config_block);
-	ccw->cda = (__u32)(unsigned long)(&vcdev->dma_area->config_block);
+	ccw->cda = (__u32)virt_to_phys(&vcdev->dma_area->config_block);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_VQ_CONF);
 	if (ret)
 		return ret;
@@ -454,7 +454,7 @@ static void virtio_ccw_del_vq(struct virtqueue *vq, struct ccw1 *ccw)
 	}
 	ccw->cmd_code = CCW_CMD_SET_VQ;
 	ccw->flags = 0;
-	ccw->cda = (__u32)(unsigned long)(info->info_block);
+	ccw->cda = (__u32)virt_to_phys(info->info_block);
 	ret = ccw_io_helper(vcdev, ccw,
 			    VIRTIO_CCW_DOING_SET_VQ | index);
 	/*
@@ -556,7 +556,7 @@ static struct virtqueue *virtio_ccw_setup_vq(struct virtio_device *vdev,
 	}
 	ccw->cmd_code = CCW_CMD_SET_VQ;
 	ccw->flags = 0;
-	ccw->cda = (__u32)(unsigned long)(info->info_block);
+	ccw->cda = (__u32)virt_to_phys(info->info_block);
 	err = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_VQ | i);
 	if (err) {
 		dev_warn(&vcdev->cdev->dev, "SET_VQ failed\n");
@@ -590,6 +590,7 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
 {
 	int ret;
 	struct virtio_thinint_area *thinint_area = NULL;
+	unsigned long indicator_addr;
 	struct airq_info *info;
 
 	thinint_area = ccw_device_dma_zalloc(vcdev->cdev,
@@ -599,21 +600,22 @@ static int virtio_ccw_register_adapter_ind(struct virtio_ccw_device *vcdev,
 		goto out;
 	}
 	/* Try to get an indicator. */
-	thinint_area->indicator = get_airq_indicator(vqs, nvqs,
-						     &thinint_area->bit_nr,
-						     &vcdev->airq_info);
-	if (!thinint_area->indicator) {
+	indicator_addr = get_airq_indicator(vqs, nvqs,
+					    &thinint_area->bit_nr,
+					    &vcdev->airq_info);
+	if (!indicator_addr) {
 		ret = -ENOSPC;
 		goto out;
 	}
+	thinint_area->indicator = virt_to_phys((void *)indicator_addr);
 	info = vcdev->airq_info;
 	thinint_area->summary_indicator =
-		(unsigned long) get_summary_indicator(info);
+		virt_to_phys(get_summary_indicator(info));
 	thinint_area->isc = VIRTIO_AIRQ_ISC;
 	ccw->cmd_code = CCW_CMD_SET_IND_ADAPTER;
 	ccw->flags = CCW_FLAG_SLI;
 	ccw->count = sizeof(*thinint_area);
-	ccw->cda = (__u32)(unsigned long)thinint_area;
+	ccw->cda = (__u32)virt_to_phys(thinint_area);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_IND_ADAPTER);
 	if (ret) {
 		if (ret == -EOPNOTSUPP) {
@@ -686,7 +688,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 		ccw->cmd_code = CCW_CMD_SET_IND;
 		ccw->flags = 0;
 		ccw->count = sizeof(indicators(vcdev));
-		ccw->cda = (__u32)(unsigned long) indicatorp;
+		ccw->cda = (__u32)virt_to_phys(indicatorp);
 		ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_IND);
 		if (ret)
 			goto out;
@@ -697,7 +699,7 @@ static int virtio_ccw_find_vqs(struct virtio_device *vdev, unsigned nvqs,
 	ccw->cmd_code = CCW_CMD_SET_CONF_IND;
 	ccw->flags = 0;
 	ccw->count = sizeof(indicators2(vcdev));
-	ccw->cda = (__u32)(unsigned long) indicatorp;
+	ccw->cda = (__u32)virt_to_phys(indicatorp);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_SET_CONF_IND);
 	if (ret)
 		goto out;
@@ -759,7 +761,7 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_READ_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)(unsigned long)features;
+	ccw->cda = (__u32)virt_to_phys(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_FEAT);
 	if (ret) {
 		rc = 0;
@@ -776,7 +778,7 @@ static u64 virtio_ccw_get_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_READ_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)(unsigned long)features;
+	ccw->cda = (__u32)virt_to_phys(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_FEAT);
 	if (ret == 0)
 		rc |= (u64)le32_to_cpu(features->features) << 32;
@@ -829,7 +831,7 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)(unsigned long)features;
+	ccw->cda = (__u32)virt_to_phys(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
 	if (ret)
 		goto out_free;
@@ -843,7 +845,7 @@ static int virtio_ccw_finalize_features(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_WRITE_FEAT;
 	ccw->flags = 0;
 	ccw->count = sizeof(*features);
-	ccw->cda = (__u32)(unsigned long)features;
+	ccw->cda = (__u32)virt_to_phys(features);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_FEAT);
 
 out_free:
@@ -875,7 +877,7 @@ static void virtio_ccw_get_config(struct virtio_device *vdev,
 	ccw->cmd_code = CCW_CMD_READ_CONF;
 	ccw->flags = 0;
 	ccw->count = offset + len;
-	ccw->cda = (__u32)(unsigned long)config_area;
+	ccw->cda = (__u32)virt_to_phys(config_area);
 	ret = ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_CONFIG);
 	if (ret)
 		goto out_free;
@@ -922,7 +924,7 @@ static void virtio_ccw_set_config(struct virtio_device *vdev,
 	ccw->cmd_code = CCW_CMD_WRITE_CONF;
 	ccw->flags = 0;
 	ccw->count = offset + len;
-	ccw->cda = (__u32)(unsigned long)config_area;
+	ccw->cda = (__u32)virt_to_phys(config_area);
 	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_WRITE_CONFIG);
 
 out_free:
@@ -946,7 +948,7 @@ static u8 virtio_ccw_get_status(struct virtio_device *vdev)
 	ccw->cmd_code = CCW_CMD_READ_STATUS;
 	ccw->flags = 0;
 	ccw->count = sizeof(vcdev->dma_area->status);
-	ccw->cda = (__u32)(unsigned long)&vcdev->dma_area->status;
+	ccw->cda = (__u32)virt_to_phys(&vcdev->dma_area->status);
 	ccw_io_helper(vcdev, ccw, VIRTIO_CCW_DOING_READ_STATUS);
 /*
  * If the channel program failed (should only happen if the device
@@ -975,7 +977,7 @@ static void virtio_ccw_set_status(struct virtio_device *vdev, u8 status)
 	ccw->cmd_code = CCW_CMD_WRITE_STATUS;
 	ccw->flags = 0;
 	ccw->count = sizeof(status);
-	ccw->cda = (__u32)(unsigned long)&vcdev->dma_area->status;
+	ccw->cda = (__u32)virt_to_phys(&vcdev->dma_area->status);
 	/* We use ssch for setting the status which is a serializing
 	 * instruction that guarantees the memory writes have
 	 * completed before ssch.
@@ -1274,7 +1276,7 @@ static int virtio_ccw_set_transport_rev(struct virtio_ccw_device *vcdev)
 	ccw->cmd_code = CCW_CMD_SET_VIRTIO_REV;
 	ccw->flags = 0;
 	ccw->count = sizeof(*rev);
-	ccw->cda = (__u32)(unsigned long)rev;
+	ccw->cda = (__u32)virt_to_phys(rev);
 
 	vcdev->revision = VIRTIO_CCW_REV_MAX;
 	do {
-- 
2.39.1

