Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62947623475
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 21:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiKIUWi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 15:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiKIUWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 15:22:08 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 592C72FC32;
        Wed,  9 Nov 2022 12:22:05 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A9IO4GV000807;
        Wed, 9 Nov 2022 20:22:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=YJ7VkIoEgUw1bd/FISmcOZL5C1FmjynTFhRuNNkL6cc=;
 b=Zcj7KmMlr7j8PrrwmZXbsXhWHZNGi00SASGp0JZhQcI/T5ikz/S41UpC0KjaCeBtBuAb
 SEzHIVvoQgU8xb4eLVdYnWJOafmH9M2gc0qXvNEVbA3DlzreUrWXUDyXE12FCeQrJNm+
 R491jzoSFy3Dkb5NrQWZ+XncLSpw0k5UznHz4dWFMM7y7bRq05qBB9Dv1zS/S8MwWGrv
 XThXXfw1JhiyY+gwVlsI17j6l7nuoVVMSpKgVeouhRK7n4eRQekOYNTCWVKNlRme4A2i
 2olPOnS0Q5z0mkI0HSW2dYZEh3jVONo89pCq8CU6JhPn66XrO5nObZig5nqwhpwqfu05 /w== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3krfguxdgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 20:22:04 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A9KJebo009520;
        Wed, 9 Nov 2022 20:22:02 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3kngs4mh64-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Nov 2022 20:22:02 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A9KLxUO65536344
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Nov 2022 20:21:59 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE5CB4C044;
        Wed,  9 Nov 2022 20:21:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA3904C040;
        Wed,  9 Nov 2022 20:21:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed,  9 Nov 2022 20:21:58 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 901ADE0200; Wed,  9 Nov 2022 21:21:58 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH 2/2] vfio/ccw: identify CCW data addresses as physical
Date:   Wed,  9 Nov 2022 21:21:57 +0100
Message-Id: <20221109202157.1050545-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221109202157.1050545-1-farman@linux.ibm.com>
References: <20221109202157.1050545-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: md9OHaAS3NaoIf4i9FkHUXNjK4zqLV3d
X-Proofpoint-ORIG-GUID: md9OHaAS3NaoIf4i9FkHUXNjK4zqLV3d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-09_06,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 clxscore=1015 spamscore=0 phishscore=0 bulkscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211090151
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The CCW data address created by vfio-ccw is that of an IDAL
built by this code. Since this address is used by real hardware,
it should be a physical address rather than a virtual one.
Let's clarify it as such in the ORB.

Similarly, once the I/O has completed the memory for that IDAL
needs to be released, so convert the CCW data address back to
a virtual address so that kfree() can process it.

Note: this currently doesn't fix a real bug, since virtual
addresses are identical to physical ones.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 7b02e97f4b29..c0a09fa8991a 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -394,7 +394,7 @@ static void ccwchain_cda_free(struct ccwchain *chain, int idx)
 	if (ccw_is_tic(ccw))
 		return;
 
-	kfree((void *)(u64)ccw->cda);
+	kfree(phys_to_virt(ccw->cda));
 }
 
 /**
@@ -845,7 +845,7 @@ union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm)
 
 	chain = list_first_entry(&cp->ccwchain_list, struct ccwchain, next);
 	cpa = chain->ch_ccw;
-	orb->cmd.cpa = (__u32) __pa(cpa);
+	orb->cmd.cpa = (__u32)virt_to_phys(cpa);
 
 	return orb;
 }
-- 
2.34.1

