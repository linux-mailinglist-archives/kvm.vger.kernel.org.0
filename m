Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826F865253F
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbiLTRK4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234036AbiLTRKj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:10:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A55763D1;
        Tue, 20 Dec 2022 09:10:38 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKGrlgF011848;
        Tue, 20 Dec 2022 17:10:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=X2baz4aYirGZzn8Tjagt+jxYT6ZsFiOiEn/E1+WlobQ=;
 b=YSeL82qqjqIbbuC/nWC/gIb8lZPh4sQt57BZTH0AoZi8WYT8Z4t4GeEAW2//gDjGI31X
 RsD7653CxVFGIhsWiVrEBebEe4IErUYRz0zVZ6KSW3z6QmqYHJ45Fa996GSkYv93pO/c
 HvOnSeUjn/TsF8F97wnLzjpPwd15fL7St/rRc+PytaLMBW0C/R1CC+SMMciF+Co0o06T
 FW9vqJyU0usdaWokiT9Q8aeuxPSt0GAogVYo7z6ldf7RtHof/iKZZxJvtPT0/FWe2iht
 tGTnMxE+ZQpNI2qzZd0WAds93SnQZgDaKtk1+z4jeV+S4yIc1n1jzYTInXM7CxgYUgVP dg== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgyp170k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:37 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKGXX7b016895;
        Tue, 20 Dec 2022 17:10:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3mh6yw34h3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHAAi742074400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 19CE62004B;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 113122004E;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id A1D3BE08FD; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
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
Subject: [PATCH v2 14/16] vfio/ccw: handle a guest Format-1 IDAL
Date:   Tue, 20 Dec 2022 18:10:06 +0100
Message-Id: <20221220171008.1362680-15-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BXvIcwkpBwH1apNTg1azUbHulP2DV4Fm
X-Proofpoint-ORIG-GUID: BXvIcwkpBwH1apNTg1azUbHulP2DV4Fm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 mlxscore=0
 impostorscore=0 spamscore=0 clxscore=1015 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There are two scenarios that need to be addressed here.

First, an ORB that does NOT have the Format-2 IDAL bit set could
have both a direct-addressed CCW and an indirect-data-address CCW
chained together. This means that the IDA CCW will contain a
Format-1 IDAL, and can be easily converted to a 2K Format-2 IDAL.
But it also means that the direct-addressed CCW needs to be
converted to the same 2K Format-2 IDAL for consistency with the
ORB settings.

Secondly, a Format-1 IDAL is comprised of 31-bit addresses.
Thus, we need to cast this IDAL to a pointer of ints while
populating the list of addresses that are sent to vfio.

Since the result of both of these is the use of the 2K IDAL
variants, and the output of vfio-ccw is always a Format-2 IDAL
(in order to use 64-bit addresses), make sure that the correct
control bit gets set in the ORB when these scenarios occur.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 477835b5e5b8..52e5abce5827 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -222,6 +222,8 @@ static void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)
 	}
 }
 
+#define idal_is_2k(_cp) (!(_cp)->orb.cmd.c64 || (_cp)->orb.cmd.i2k)
+
 /*
  * Helpers to operate ccwchain.
  */
@@ -504,8 +506,9 @@ static unsigned long *get_guest_idal(struct ccw1 *ccw,
 	struct vfio_device *vdev =
 		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
 	unsigned long *idaws;
+	unsigned int *idaws_f1;
 	int idal_len = idaw_nr * sizeof(*idaws);
-	int idaw_size = PAGE_SIZE;
+	int idaw_size = idal_is_2k(cp) ? PAGE_SIZE / 2 : PAGE_SIZE;
 	int idaw_mask = ~(idaw_size - 1);
 	int i, ret;
 
@@ -527,8 +530,10 @@ static unsigned long *get_guest_idal(struct ccw1 *ccw,
 			for (i = 1; i < idaw_nr; i++)
 				idaws[i] = (idaws[i - 1] + idaw_size) & idaw_mask;
 		} else {
-			kfree(idaws);
-			return ERR_PTR(-EOPNOTSUPP);
+			idaws_f1 = (unsigned int *)idaws;
+			idaws_f1[0] = ccw->cda;
+			for (i = 1; i < idaw_nr; i++)
+				idaws_f1[i] = (idaws_f1[i - 1] + idaw_size) & idaw_mask;
 		}
 	}
 
@@ -595,6 +600,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 	struct vfio_device *vdev =
 		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
 	unsigned long *idaws;
+	unsigned int *idaws_f1;
 	int ret;
 	int idaw_nr;
 	int i;
@@ -625,9 +631,12 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 	 * Copy guest IDAWs into page_array, in case the memory they
 	 * occupy is not contiguous.
 	 */
+	idaws_f1 = (unsigned int *)idaws;
 	for (i = 0; i < idaw_nr; i++) {
 		if (cp->orb.cmd.c64)
 			pa->pa_iova[i] = idaws[i];
+		else
+			pa->pa_iova[i] = idaws_f1[i];
 	}
 
 	if (ccw_does_data_transfer(ccw)) {
@@ -848,7 +857,11 @@ union orb *cp_get_orb(struct channel_program *cp, struct subchannel *sch)
 
 	/*
 	 * Everything built by vfio-ccw is a Format-2 IDAL.
+	 * If the input was a Format-1 IDAL, indicate that
+	 * 2K Format-2 IDAWs were created here.
 	 */
+	if (!orb->cmd.c64)
+		orb->cmd.i2k = 1;
 	orb->cmd.c64 = 1;
 
 	if (orb->cmd.lpm == 0)
-- 
2.34.1

