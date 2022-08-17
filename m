Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD67B5979CE
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 00:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241672AbiHQWwz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 18:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241519AbiHQWwx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 18:52:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BE77A0250;
        Wed, 17 Aug 2022 15:52:52 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27HMe6T9028120;
        Wed, 17 Aug 2022 22:52:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=MWPFJefi5bG1Pt4zbhFj9WB9yC1qfp/SCvEHAa+Cz64=;
 b=eSzYsl9vWZZ8QADqFYMPVP+AWeArXay9FGRo56o6PfjQG/gC5kWgu+wM0worWPVe0Kt1
 PkVmVkuHGLoBX+d5Ddlh8DjBhO1bQ1ludcau7dOoFUTN42vcditfqoslIeUMfBtdxt6E
 k9gJ7eybRDxjS/KTVVP5iqq0mcfFeECJtNIC+CzJDnkwaXMNl8DtSylpitF0bjoRSZvk
 h5FkfDr7kxHRA1Pk5lkDcjyvJ3hqgOF77HDJQQaFzQp/O53PrMkokpZxHB1xTUzgxQp7
 EvjZEOS7bttUWs9SqqsqPWw/lieeQqLpHjAeCRDfn9ZD9102VB8qpcyGzxS2Vze44s3a qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j18wqruhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 22:52:50 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27HMgRRk033782;
        Wed, 17 Aug 2022 22:52:49 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3j18wqruhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 22:52:49 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27HMoh86012016;
        Wed, 17 Aug 2022 22:52:48 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04dal.us.ibm.com with ESMTP id 3hx3kaa13c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 Aug 2022 22:52:48 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27HMqleH10420876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Aug 2022 22:52:47 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24F516A04D;
        Wed, 17 Aug 2022 22:52:47 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 265D26A047;
        Wed, 17 Aug 2022 22:52:46 +0000 (GMT)
Received: from li-2c1e724c-2c76-11b2-a85c-ae42eaf3cb3d.ibm.com.com (unknown [9.160.118.205])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 17 Aug 2022 22:52:46 +0000 (GMT)
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     jjherne@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
Subject: [PATCH 2/2] s390/vfio-ap: fix unlinking of queues from the mdev
Date:   Wed, 17 Aug 2022 18:52:42 -0400
Message-Id: <20220817225242.188805-3-akrowiak@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220817225242.188805-1-akrowiak@linux.ibm.com>
References: <20220817225242.188805-1-akrowiak@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3pB49UJxUc01XdSvvPFmY4F9SCmbTi1a
X-Proofpoint-GUID: KKxiFd60JDOMVQyyNITbC3SMZ3h0VD1c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-17_15,2022-08-16_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=818 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2207270000 definitions=main-2208170084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The vfio_ap_mdev_unlink_adapter and vfio_ap_mdev_unlink_domain functions
add the associated vfio_ap_queue objects to the hashtable that links them
to the matrix mdev to which their APQN is assigned. In order to unlink
them, they must be deleted from the hashtable. This patch fixes that
issue.

Reported-by: Tony Krowiak <akrowiak@linux.ibm.com>
Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
---
 drivers/s390/crypto/vfio_ap_ops.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
index ee82207b4e60..2493926b5dfb 100644
--- a/drivers/s390/crypto/vfio_ap_ops.c
+++ b/drivers/s390/crypto/vfio_ap_ops.c
@@ -1049,8 +1049,7 @@ static void vfio_ap_mdev_unlink_adapter(struct ap_matrix_mdev *matrix_mdev,
 		if (q && qtable) {
 			if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
 			    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
-				hash_add(qtable->queues, &q->mdev_qnode,
-					 q->apqn);
+				vfio_ap_unlink_queue_fr_mdev(q);
 		}
 	}
 }
@@ -1236,8 +1235,7 @@ static void vfio_ap_mdev_unlink_domain(struct ap_matrix_mdev *matrix_mdev,
 		if (q && qtable) {
 			if (test_bit_inv(apid, matrix_mdev->shadow_apcb.apm) &&
 			    test_bit_inv(apqi, matrix_mdev->shadow_apcb.aqm))
-				hash_add(qtable->queues, &q->mdev_qnode,
-					 q->apqn);
+				vfio_ap_unlink_queue_fr_mdev(q);
 		}
 	}
 }
-- 
2.31.1

