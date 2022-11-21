Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45F3A632F1C
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231841AbiKUVmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:42:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231726AbiKUVli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:41:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E2A1DB85E;
        Mon, 21 Nov 2022 13:41:08 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALLRY0N023134;
        Mon, 21 Nov 2022 21:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=yLjvMIxS6ztk/SZxNph4GGZktVfD7uEXPWM9MM2KKh8=;
 b=lGhleW57+uKMz7qfV6xfyY9reiy77GbACxNL82PXQKLLYR/e6Rdq5lcL6z/KpK3VClwh
 kxXxS4mP+HYYNrR8Yxy97+jcn7xw9w6i+Jb7eZ68ivdgge6B2Szd4sDgIvyt1IP4YJ+F
 zUyT2Vvo4upAl22fWMj7KfEZHILQHuRs8H51Nbuf+2B+kWjzhsoSS4LUoDDlofIn8nEq
 T3Fk5VsfA4jHGSN5eUstDieDwNPBoPmzawUci6K2PNqccLH6j95m0N0b2iwUlZPgfaNc
 ViVsl4Eh1OEHs1wQOtYxVwadL1mNV44SaUOsLRdDUJ2rj56IdKea2cpfmz0fgGCZoOae wA== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0h910c85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:07 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALLZuEx020785;
        Mon, 21 Nov 2022 21:41:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3kxpdj2d8r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:05 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALLf2eW55771614
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:41:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4B022AE04D;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39288AE045;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 956F3E08E3; Mon, 21 Nov 2022 22:41:01 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v1 16/16] vfio/ccw: remove old IDA format restrictions
Date:   Mon, 21 Nov 2022 22:40:56 +0100
Message-Id: <20221121214056.1187700-17-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121214056.1187700-1-farman@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CmYICqLT7l4aIQp3HrNK_ZEsAs9DncxO
X-Proofpoint-ORIG-GUID: CmYICqLT7l4aIQp3HrNK_ZEsAs9DncxO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_17,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0
 clxscore=1015 spamscore=0 suspectscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210158
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

By this point, all the pieces are in place to properly support
a 2K Format-2 IDAL, and to convert a guest Format-1 IDAL to
the 2K Format-2 variety. Let's remove the fence that prohibits
them, and allow a guest to submit them if desired.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 Documentation/s390/vfio-ccw.rst | 4 ++--
 drivers/s390/cio/vfio_ccw_cp.c  | 8 --------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/Documentation/s390/vfio-ccw.rst b/Documentation/s390/vfio-ccw.rst
index ea928a3806f4..53375dc86213 100644
--- a/Documentation/s390/vfio-ccw.rst
+++ b/Documentation/s390/vfio-ccw.rst
@@ -219,8 +219,8 @@ values may occur:
   The operation was successful.
 
 ``-EOPNOTSUPP``
-  The orb specified transport mode or an unidentified IDAW format, or the
-  scsw specified a function other than the start function.
+  The ORB specified transport mode, or the
+  SCSW specified a function other than the start function.
 
 ``-EIO``
   A request was issued while the device was not in a state ready to accept
diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 3829c346583c..60e972042979 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -372,14 +372,6 @@ static int ccwchain_calc_length(u64 iova, struct channel_program *cp)
 	do {
 		cnt++;
 
-		/*
-		 * As we don't want to fail direct addressing even if the
-		 * orb specified one of the unsupported formats, we defer
-		 * checking for IDAWs in unsupported formats to here.
-		 */
-		if ((!cp->orb.cmd.c64 || cp->orb.cmd.i2k) && ccw_is_idal(ccw))
-			return -EOPNOTSUPP;
-
 		/*
 		 * We want to keep counting if the current CCW has the
 		 * command-chaining flag enabled, or if it is a TIC CCW
-- 
2.34.1

