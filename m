Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A422652547
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbiLTRLF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:11:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbiLTRKl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:10:41 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21E111F;
        Tue, 20 Dec 2022 09:10:39 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKGrmUl011868;
        Tue, 20 Dec 2022 17:10:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mpf53VhJojwsAlqeo8XNMHNzbcuWjtMV6o0rddgguTo=;
 b=T6ydr+iYxn/thq008aNjwNoEIcgc1xC0om5jf2CTYEGYDYrBDj/QgKirdNui8D1MuUvP
 nzuySzUnGHuGORm/+6/1RI04Wz1MGEf5SnG8GVmqeMkNkli+LJjzidiTjX6if+by/pl1
 Jx9kGIOkxZZsv8uYp4HMBQ3qKajhXv89hzLbhk3HWRYZGX8lo8pxE8CptilfJ5memf+X
 giAQbVjanvnZVy8IY8ABC2Jw7ADUvDiRGYLzEIx7w4vl6tKfLP4gNBInpTNS0+WXFagp
 egGOzPCT0lysWPXA1v4tVmNHCLBQmMK/jynUf2cfTXw56IKir9K9ycjqzzbz0rGMkjzW ZA== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgyp170g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:38 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK6qeYs025143;
        Tue, 20 Dec 2022 17:10:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3mh6ywmacq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHAARJ45351202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2044A20063;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1014420043;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 9F005E08F2; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
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
Subject: [PATCH v2 13/16] vfio/ccw: allocate/populate the guest idal
Date:   Tue, 20 Dec 2022 18:10:05 +0100
Message-Id: <20221220171008.1362680-14-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: lYEvEu8L5_uUuhHp8EKy3FVZevqVM_v1
X-Proofpoint-ORIG-GUID: lYEvEu8L5_uUuhHp8EKy3FVZevqVM_v1
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

Today, we allocate memory for a list of IDAWs, and if the CCW
being processed contains an IDAL we read that data from the guest
into that space. We then copy each IDAW into the pa_iova array,
or fabricate that pa_iova array with a list of addresses based
on a direct-addressed CCW.

Combine the reading of the guest IDAL with the creation of a
pseudo-IDAL for direct-addressed CCWs, so that both CCW types
have a "guest" IDAL that can be populated straight into the
pa_iova array.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 76 +++++++++++++++++++++++-----------
 1 file changed, 52 insertions(+), 24 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 62a013a631d8..477835b5e5b8 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -192,11 +192,12 @@ static inline void page_array_idal_create_words(struct page_array *pa,
 	 * idaw.
 	 */
 
-	for (i = 0; i < pa->pa_nr; i++)
+	for (i = 0; i < pa->pa_nr; i++) {
 		idaws[i] = page_to_phys(pa->pa_page[i]);
 
-	/* Adjust the first IDAW, since it may not start on a page boundary */
-	idaws[0] += pa->pa_iova[0] & (PAGE_SIZE - 1);
+		/* Incorporate any offset from each starting address */
+		idaws[i] += pa->pa_iova[i] & (PAGE_SIZE - 1);
+	}
 }
 
 static void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)
@@ -496,6 +497,44 @@ static int ccwchain_fetch_tic(struct ccw1 *ccw,
 	return -EFAULT;
 }
 
+static unsigned long *get_guest_idal(struct ccw1 *ccw,
+				     struct channel_program *cp,
+				     int idaw_nr)
+{
+	struct vfio_device *vdev =
+		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
+	unsigned long *idaws;
+	int idal_len = idaw_nr * sizeof(*idaws);
+	int idaw_size = PAGE_SIZE;
+	int idaw_mask = ~(idaw_size - 1);
+	int i, ret;
+
+	idaws = kcalloc(idaw_nr, sizeof(*idaws), GFP_DMA | GFP_KERNEL);
+	if (!idaws)
+		return ERR_PTR(-ENOMEM);
+
+	if (ccw_is_idal(ccw)) {
+		/* Copy IDAL from guest */
+		ret = vfio_dma_rw(vdev, ccw->cda, idaws, idal_len, false);
+		if (ret) {
+			kfree(idaws);
+			return ERR_PTR(ret);
+		}
+	} else {
+		/* Fabricate an IDAL based off CCW data address */
+		if (cp->orb.cmd.c64) {
+			idaws[0] = ccw->cda;
+			for (i = 1; i < idaw_nr; i++)
+				idaws[i] = (idaws[i - 1] + idaw_size) & idaw_mask;
+		} else {
+			kfree(idaws);
+			return ERR_PTR(-EOPNOTSUPP);
+		}
+	}
+
+	return idaws;
+}
+
 /*
  * ccw_count_idaws() - Calculate the number of IDAWs needed to transfer
  * a specified amount of data
@@ -557,7 +596,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
 	unsigned long *idaws;
 	int ret;
-	int idaw_nr, idal_len;
+	int idaw_nr;
 	int i;
 
 	/* Calculate size of IDAL */
@@ -565,12 +604,10 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 	if (idaw_nr < 0)
 		return idaw_nr;
 
-	idal_len = idaw_nr * sizeof(*idaws);
-
 	/* Allocate an IDAL from host storage */
-	idaws = kcalloc(idaw_nr, sizeof(*idaws), GFP_DMA | GFP_KERNEL);
-	if (!idaws) {
-		ret = -ENOMEM;
+	idaws = get_guest_idal(ccw, cp, idaw_nr);
+	if (IS_ERR(idaws)) {
+		ret = PTR_ERR(idaws);
 		goto out_init;
 	}
 
@@ -584,22 +621,13 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 	if (ret < 0)
 		goto out_free_idaws;
 
-	if (ccw_is_idal(ccw)) {
-		/* Copy guest IDAL into host IDAL */
-		ret = vfio_dma_rw(vdev, ccw->cda, idaws, idal_len, false);
-		if (ret)
-			goto out_unpin;
-
-		/*
-		 * Copy guest IDAWs into page_array, in case the memory they
-		 * occupy is not contiguous.
-		 */
-		for (i = 0; i < idaw_nr; i++)
+	/*
+	 * Copy guest IDAWs into page_array, in case the memory they
+	 * occupy is not contiguous.
+	 */
+	for (i = 0; i < idaw_nr; i++) {
+		if (cp->orb.cmd.c64)
 			pa->pa_iova[i] = idaws[i];
-	} else {
-		pa->pa_iova[0] = ccw->cda;
-		for (i = 1; i < pa->pa_nr; i++)
-			pa->pa_iova[i] = pa->pa_iova[i - 1] + PAGE_SIZE;
 	}
 
 	if (ccw_does_data_transfer(ccw)) {
-- 
2.34.1

