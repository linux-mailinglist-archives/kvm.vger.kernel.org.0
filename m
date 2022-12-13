Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67F764B8D9
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 16:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbiLMPpS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 10:45:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236291AbiLMPou (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 10:44:50 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C24820350;
        Tue, 13 Dec 2022 07:44:48 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDFPlIW025599;
        Tue, 13 Dec 2022 15:44:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GFSkCfdxivE8yosDtk1dQw3AIraT+zbh6YgluqsCQR0=;
 b=TLSqUFH2jZzonsXhNT6wXHgRPHLo9x16/N734DbW41JIF1mBCX7eLqZcRWm6gIP5PwFK
 IYMKhPkd0bEVjdqIMRnfvDuqZBzauqO29y46pF6eylW5ZakscU4PqV8fU00xqbeumF+e
 EWSLMPEpj0T4bUbruzXL/gvPcyejQ/UgvTGymxg25Mvj10BA1AuhhQ/12yDKrFPeTTWn
 5aw9LwHQhM0Wx1OJlNTmaVC5z0TU771Mi3CPKYmAtghuaLQMiQ1k0KgEHNFVYVteL5L4
 9cc45j53rqsS+ek7DgDfJPJCygM9dozde+CH2u1BxJhswXmqcgMJOTF4GGh857AwiVH3 8w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mev1drkdb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:45 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BDFQ5E9027499;
        Tue, 13 Dec 2022 15:44:44 GMT
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mev1drkd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:44 +0000
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDF01Fp014276;
        Tue, 13 Dec 2022 15:44:43 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma03dal.us.ibm.com (PPS) with ESMTPS id 3mchr71aqx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Dec 2022 15:44:43 +0000
Received: from smtpav01.dal12v.mail.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BDFigl622741296
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Dec 2022 15:44:42 GMT
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 260AC58061;
        Tue, 13 Dec 2022 15:44:42 +0000 (GMT)
Received: from smtpav01.dal12v.mail.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 560185805D;
        Tue, 13 Dec 2022 15:44:41 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.endicott.ibm.com (unknown [9.60.85.43])
        by smtpav01.dal12v.mail.com (Postfix) with ESMTP;
        Tue, 13 Dec 2022 15:44:41 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pasic@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, fiuczy@linux.ibm.com
Subject: [PATCH 4/7] s390/vfio_ap: verify ZAPQ completion after return of response code zero
Date:   Tue, 13 Dec 2022 10:44:34 -0500
Message-Id: <20221213154437.15480-5-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20221213154437.15480-1-akrowiak@linux.ibm.com>
References: <20221213154437.15480-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8IeQMLPF4NNvS1nQi5WXg3wvjEMHQvNJ
X-Proofpoint-GUID: D9nzezPKchQ8PKuPvS2EkdLItehyzK8z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-13_03,2022-12-13_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 impostorscore=0 clxscore=1015 adultscore=0 lowpriorityscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 phishscore=0 priorityscore=1501
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212130137
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Verification that the asynchronous ZAPQ function has completed only needs
to be done when the response code indicates the function was successfully
initiated; so, let's call the apq_reset_check function immediately after
the response code zero is returned from the ZAPQ.

Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 5bf2d93ae8af..c0cf5050be59 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1645,6 +1645,9 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 	switch (status.response_code) {
 	case AP_RESPONSE_NORMAL:
 		ret = 0;
+		/* if the reset has not completed, wait for it to take effect */
+		if (!status.queue_empty || status.irq_enabled)
+			ret = apq_reset_check(q);
 		break;
 	case AP_RESPONSE_RESET_IN_PROGRESS:
 		/*
@@ -1674,10 +1677,6 @@ static int vfio_ap_mdev_reset_queue(struct vfio_ap_queue *q)
 		return -EIO;
 	}
 
-	/* wait for the reset to take effect */
-	if (!status.queue_empty && status.irq_enabled)
-		ret = apq_reset_check(q);
-
 free_resources:
 	vfio_ap_free_aqic_resources(q);
 
-- 
2.31.1

