Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0928E632F1A
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbiKUVmP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:42:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbiKUVlh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:41:37 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785EDDB858;
        Mon, 21 Nov 2022 13:41:08 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALJhQwf016164;
        Mon, 21 Nov 2022 21:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hj6GtO2fdZu/698eA1qxjGhZ0ZqZKwvRuq9bjnTZlCM=;
 b=VnzXlKKbmR7c1E/t1SkosmczmeGz9IqG5gKvJ8wvhZZ/9IJOfCx5XHUeJhWdzpmc8EET
 4XzRmSUr4Rz0ouHhiAxl7WCyQfPb9fTK2bxWyKtnFjHHBURNQ//+UM0H+qmzNX8Wfkky
 bUeV162/gsua0QWjT6d5bYCcn4FE6x9nReYZoeW+fEFZ/2VKT7ZVxTJgeodorJzrc9Kh
 QbZlUy+kWjZlNwbPKdAvE9ccdGLzxw+CA5neWjIJzXlT3qthxhcRmjqkDXayvag18Nki
 HU0U1EifYArhKg+thGlQhZeW+q4FRMK8u4FUFRJtD38udzvSVhS+4J0kn4OdhpjnjcSx SA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0fr02mp2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:07 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALLbSIw004521;
        Mon, 21 Nov 2022 21:41:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3kxps8u6v2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:05 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALLf25V28181210
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:41:02 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 122BDAE053;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 008ACAE051;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 82A65E0876; Mon, 21 Nov 2022 22:41:01 +0100 (CET)
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
Subject: [PATCH v1 10/16] vfio/ccw: refactor the idaw counter
Date:   Mon, 21 Nov 2022 22:40:50 +0100
Message-Id: <20221121214056.1187700-11-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121214056.1187700-1-farman@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iWqJJMM5NSbTigVr-SqHdKzX1t4UJnf9
X-Proofpoint-GUID: iWqJJMM5NSbTigVr-SqHdKzX1t4UJnf9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_16,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 suspectscore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210158
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
---
 drivers/s390/cio/vfio_ccw_cp.c | 39 ++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index a30f26962750..34a133d962d1 100644
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

