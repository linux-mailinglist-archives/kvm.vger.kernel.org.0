Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59CED64B8CD
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 16:45:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbiLMPot (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 10:44:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236167AbiLMPoo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 10:44:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B306368;
        Tue, 13 Dec 2022 07:44:43 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDE9ePL011228;
        Tue, 13 Dec 2022 15:44:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=nfH4fN+czCBQMn+335TdKClC5X9kduQW3sBrlTHqqMw=;
 b=NBHAzGzXV5mrBLqwDNNK4WB2cAdsn4yCM5kz9qTuA4k8yKhlviawjNHcSnSvvWgfkp/I
 GjUgQf1fmA8GUPZqJYOTWt5JFOgsyBfRjLlgwIsFru6Q1OWC35clM+y9VgLigjLL7wft
 yH+K0P+wcXfcGx0mhR8+j5buuxQ11YnPzS6WPHnYVhdARcaIe9GNgR7miaAGYIXd6TZt
 MRx8EWh7r+nGkF7IGPCigPqwUnK4f0qzMMMBYRcb9dI8bC2bh60uByhTq84Fh/1flbwC
 9bS7KvkcpVpDkBYOmZ0/Ib+73XvzviNtLRpzRhTt4N/ms134/ccGnlbgrC6HNTcver/n Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mejre7hfy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:41 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDFL2xp017138;
        Tue, 13 Dec 2022 15:44:41 GMT
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mejre7hfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:41 +0000
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDDeVub032045;
        Tue, 13 Dec 2022 15:44:40 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([9.208.130.102])
        by ppma01wdc.us.ibm.com (PPS) with ESMTPS id 3mchr6c9aj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:40 +0000
Received: from smtpav01.dal12v.mail.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDFid2w6357532
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:44:39 GMT
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6128558057;
        Tue, 13 Dec 2022 15:44:39 +0000 (GMT)
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8F5B858061;
        Tue, 13 Dec 2022 15:44:38 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav01.dal12v.mail.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 15:44:38 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH 1/7] s390/vfio-ap: verify reset complete in separate function
Date:   Tue, 13 Dec 2022 10:44:31 -0500
Message-Id: <20221213154437.15480-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213154437.15480-1-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nps-d39EmrNYei5FXUaeSuRmzC8LD-Ui
X-Proofpoint-ORIG-GUID: C2hsMtofm9EqD7zVFaKc-zIzQ5T-O5ew
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1015 mlxscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0 impostorscore=0
 bulkscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_ap_mdev_reset_queue() function contains a loop to verify that the
reset successfully completes within 40ms. This patch moves that loop into
a separate function.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 0b4cc8c597ae..83ff94a38102 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1587,12 +1587,30 @@ static struct vfio_ap_queue *vfio_ap_find_queue(int apqn)
 	return q;
 }
 
+static int apq_reset_check(struct vfio_ap_queue *q)
+{
+	int iters = 2;
+	struct ap_queue_status status;
+
+	while (iters--) {
+		msleep(20);
+		status = ap_tapq(q->apqn, NULL);
+		if (status.queue_empty && !status.irq_enabled)
+			return 0;
+	}
+	WARN_ONCE(iters <= 0,
+		  "timeout verifying reset of queue %02x.%04x (%u, %u, %u)",
+		  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn),
+		  status.queue_empty, status.irq_enabled, status.response_code);
+
+	return -EBUSY;
+}
+
 static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
 				    unsigned int retry)
 {
 	struct ap_queue_status status;
 	int ret;
-	int retry2 = 2;
 
 	if (!q)
 		return 0;
@@ -1629,14 +1647,8 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q,
 	}
 
 	/* wait for the reset to take effect */
-	while (retry2--) {
-		if (status.queue_empty && !status.irq_enabled)
-			break;
-		msleep(20);
-		status = ap_tapq(q->apqn, NULL);
-	}
-	WARN_ONCE(retry2 <= 0, "unable to verify reset of queue %02x.%04x",
-		  AP_QID_CARD(q->apqn), AP_QID_QUEUE(q->apqn));
+	if (!status.queue_empty && status.irq_enabled)
+		ret = apq_reset_check(q);
 
 free_resources:
 	vfio_ap_free_aqic_resources(q);
-- 
2.31.1

