Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BDF979E893
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 15:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238163AbjIMNGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 09:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjIMNGn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 09:06:43 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D9019B1;
        Wed, 13 Sep 2023 06:06:39 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38DCuuJ1031677;
        Wed, 13 Sep 2023 13:06:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+yS4A9C6bDkm88UVUGu+D7xxJ8zAuI4Ip9K+7iZOJkk=;
 b=Q65SckCto85+tqnP9QTRrqimdxzZM3ZS7NNwdfMVmZMGhsvy3xW2cFz8tIOVK8Com3VJ
 grPIxoZ0ImwYtHxHROd7k7e2Q7BwyXaj5b47jW1XSpuJ3Wf04CGFHHAB/OxyJZ+xsTY4
 Zmc9m9ayL1kBDk6DV+D/SQhu1Vl/Xs0OLqb5u2Sb/Akdp6JuL1EwPIJAMEY0NXVGyh8Q
 L+/l1C3ff6U9r2tIG9OsaBXcRteTY+Vt6ALoGcF9qgxaLzi6k3NFEAUFMluLQ72noQvJ
 uifNVSob3+OKsXQdVD2K1DZmrrQOb4FizzyMM2b4MmqSrxAAFyRlJ+8S7EZ1WKXT86Ug 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3dhggddd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 13:06:36 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 38DD6W7E028030;
        Wed, 13 Sep 2023 13:06:34 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3t3dhggd9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 13:06:34 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
        by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 38DAxqSm002755;
        Wed, 13 Sep 2023 13:06:30 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
        by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3t14hm32tv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Sep 2023 13:06:30 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
        by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 38DD6TS113369908
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Sep 2023 13:06:29 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D40558059;
        Wed, 13 Sep 2023 13:06:29 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4042A58058;
        Wed, 13 Sep 2023 13:06:28 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.61.101.13])
        by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 13 Sep 2023 13:06:28 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, borntraeger@linux.ibm.com,
        kwankhede@nvidia.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        Anthony Krowiak <akrowiak@linux.ibm.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] s390/vfio-ap: unpin pages on gisc registration failure
Date:   Wed, 13 Sep 2023 09:06:21 -0400
Message-ID: <20230913130626.217665-2-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230913130626.217665-1-akrowiak@linux.ibm.com>
References: <20230913130626.217665-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wsF5irEh6MPDqm-9JoGtN0h0tWuxxoYU
X-Proofpoint-ORIG-GUID: ka6gNPFCTGmE6hlryg6mAw6brf4XiIzB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-13_06,2023-09-13_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 bulkscore=0 phishscore=0 clxscore=1011 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 priorityscore=1501 impostorscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309130101
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Anthony Krowiak <akrowiak@linux.ibm.com>

In the vfio_ap_irq_enable function, after the page containing the
notification indicator byte (NIB) is pinned, the function attempts
to register the guest ISC. If registration fails, the function sets the
status response code and returns without unpinning the page containing
the NIB. In order to avoid a memory leak, the NIB should be unpinned before
returning from the vfio_ap_irq_enable function.

Fixes: 783f0a3ccd79 ("s390/vfio-ap: add s390dbf logging to the vfio_ap_irq_enable function")

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Signed-off-by: Anthony Krowiak <akrowiak@linux.ibm.com>
Cc: <stable@vger.kernel.org>
---
 drivers/s390/crypto/vfio_ap_ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index 4db538a55192..9cb28978c186 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -457,6 +457,7 @@ static struct ap_queue_status vfio_ap_irq_enable(struct vfio_ap_queue *q,
 		VFIO_AP_DBF_WARN("%s: gisc registration failed: nisc=%d, isc=%d, apqn=%#04x\n",
 				 __func__, nisc, isc, q->apqn);
 
+		vfio_unpin_pages(&q->matrix_mdev->vdev, nib, 1);
 		status.response_code = AP_RESPONSE_INVALID_GISA;
 		return status;
 	}
-- 
2.41.0

