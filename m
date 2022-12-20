Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0BA65255B
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:13:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234143AbiLTRM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:12:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233933AbiLTRMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:12:25 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313961DDC4;
        Tue, 20 Dec 2022 09:11:34 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKH8I7U003967;
        Tue, 20 Dec 2022 17:11:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=EiZZwiDd1FO2FQFTg/4M4RlPOV6iX4/UXvMXZrRha48=;
 b=QkRwFDxzI4Cf2IWQzl2pMDJ5udJt9EXYkLqrQOhx3D4DGknN4hrIqCTUS3GcAbI5r5NC
 /hdOtfgKSOlWCnoPD5NrWukuBAn9giBev1sJANp/NBab8NGvrg+2sxJNI6tEUXXiNElh
 yuV+w7v8a7SuMvmUavcEZk/tqWhxkRWPbwbdOYIKgp8uAd7sWgvBD3gLSFhzVprBX12b
 iPtuYf5MCzrTZaB1qrmBpRHPy+aaFlOkkRl0jsxWLhnWyfW91maxTeAhK8Aqq5z5BahC
 bR/76MM7hDT45nWu8WIkRsfl2nv26QMzCDrdkXAAstM0XX75XjRYWkufKJipFyIufpge 3A== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgd220u4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:11:32 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BJLeA8K013401;
        Tue, 20 Dec 2022 17:10:13 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3mh6yxk4uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHAAdw20120062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 426392005A;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2CE232004E;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 96B02E08E5; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
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
Subject: [PATCH v2 10/16] vfio/ccw: refactor the idaw counter
Date:   Tue, 20 Dec 2022 18:10:02 +0100
Message-Id: <20221220171008.1362680-11-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: w0pswZYSZUFKr2xJ8ogU9ckVL76AWoTB
X-Proofpoint-GUID: w0pswZYSZUFKr2xJ8ogU9ckVL76AWoTB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-20_06,2022-12-20_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 adultscore=0 phishscore=0 impostorscore=0 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212200141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The rules of an IDAW are fairly simple: Each one can move no
more than a defined amount of data, must not cross the
boundary defined by that length, and must be aligned to that
length as well. The first IDAW in a list is special, in that
it does not need to adhere to that alignment, but the other
rules still apply. Thus, by reading the first IDAW in a list,
the number of IDAWs that will comprise a data transfer of a
particular size can be calculated.

Let's factor out the reading of that first IDAW with the
logic that calculates the length of the list, to simplify
the rest of the routine that handles the individual IDAWs.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 39 ++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index f448aa93007f..9d74e0b74da7 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -496,23 +496,25 @@ static int ccwchain_fetch_tic(struct ccw1 *ccw,
 	return -EFAULT;
 }
 
-static int ccwchain_fetch_ccw(struct ccw1 *ccw,
-			      struct page_array *pa,
-			      struct channel_program *cp)
+/*
+ * ccw_count_idaws() - Calculate the number of IDAWs needed to transfer
+ * a specified amount of data
+ *
+ * @ccw: The Channel Command Word being translated
+ * @cp: Channel Program being processed
+ */
+static int ccw_count_idaws(struct ccw1 *ccw,
+			   struct channel_program *cp)
 {
 	struct vfio_device *vdev =
 		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
 	u64 iova;
-	unsigned long *idaws;
 	int ret;
 	int bytes = 1;
-	int idaw_nr, idal_len;
-	int i;
 
 	if (ccw->count)
 		bytes = ccw->count;
 
-	/* Calculate size of IDAL */
 	if (ccw_is_idal(ccw)) {
 		/* Read first IDAW to see if it's 4K-aligned or not. */
 		/* All subsequent IDAws will be 4K-aligned. */
@@ -522,7 +524,26 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 	} else {
 		iova = ccw->cda;
 	}
-	idaw_nr = idal_nr_words((void *)iova, bytes);
+
+	return idal_nr_words((void *)iova, bytes);
+}
+
+static int ccwchain_fetch_ccw(struct ccw1 *ccw,
+			      struct page_array *pa,
+			      struct channel_program *cp)
+{
+	struct vfio_device *vdev =
+		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
+	unsigned long *idaws;
+	int ret;
+	int idaw_nr, idal_len;
+	int i;
+
+	/* Calculate size of IDAL */
+	idaw_nr = ccw_count_idaws(ccw, cp);
+	if (idaw_nr < 0)
+		return idaw_nr;
+
 	idal_len = idaw_nr * sizeof(*idaws);
 
 	/* Allocate an IDAL from host storage */
@@ -555,7 +576,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 		for (i = 0; i < idaw_nr; i++)
 			pa->pa_iova[i] = idaws[i];
 	} else {
-		pa->pa_iova[0] = iova;
+		pa->pa_iova[0] = ccw->cda;
 		for (i = 1; i < pa->pa_nr; i++)
 			pa->pa_iova[i] = pa->pa_iova[i - 1] + PAGE_SIZE;
 	}
-- 
2.34.1

