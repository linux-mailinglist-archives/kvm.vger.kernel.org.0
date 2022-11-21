Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69709632A21
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 17:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbiKUQ6p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 11:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiKUQ6o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 11:58:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AA25985E;
        Mon, 21 Nov 2022 08:58:43 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALGI0Rh018491;
        Mon, 21 Nov 2022 16:58:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3MV6231kq5XSOS7aolmbae2tXU3aE7KUptXs84n/mmU=;
 b=KVs+J8rZKDWH9MqSArX5MhMjlW3p8iY+LXnQAaKHrSqb1/Wv+VEVIJnEPMt/nbtF1q01
 Z65U1Zdwf3tAA0vsuvKFw3mdf/wUPMLLc53AisWaabYOTiquZM35wVDNCM5EVqeg4Yl4
 nE3TV+/hudgtwcmIxP0/F0BieeE4rV4ZeMGgeXhUwGbXo5NbwECHa+KdKIn6gJUK9HUC
 diagk88vFVVZGr8i1hR2FCCoBqVe4UZ3asgt7XQC9EXu7LpTbmxuVn69GFVxcFJdS+PG
 vh8FyDAAI2r4oAryiEZ52pVgXhn9Fb6sOs1fV1oviX5fZntwynX57RwD4t723CJYfARD dA== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0cqw0xrt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 16:58:43 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALGoeFh029534;
        Mon, 21 Nov 2022 16:58:40 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3kxps8j6sn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 16:58:40 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALGqQIu23724466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 16:52:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C19542041;
        Mon, 21 Nov 2022 16:58:37 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 596584203F;
        Mon, 21 Nov 2022 16:58:37 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 16:58:37 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 1B70FE033F; Mon, 21 Nov 2022 17:58:37 +0100 (CET)
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
        Eric Farman <farman@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [PATCH v2 2/2] vfio/ccw: identify CCW data addresses as physical
Date:   Mon, 21 Nov 2022 17:58:36 +0100
Message-Id: <20221121165836.283781-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121165836.283781-1-farman@linux.ibm.com>
References: <20221121165836.283781-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: oWB37gXFPXXK_S8Yx_vWTGzos3v1ksBl
X-Proofpoint-GUID: oWB37gXFPXXK_S8Yx_vWTGzos3v1ksBl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_14,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 malwarescore=0 clxscore=1015
 spamscore=0 bulkscore=0 priorityscore=1501 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211210128
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
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
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

