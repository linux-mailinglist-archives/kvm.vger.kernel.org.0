Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE47632F1F
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbiKUVm0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiKUVli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:41:38 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83D6ADB860;
        Mon, 21 Nov 2022 13:41:08 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALJS1qZ038606;
        Mon, 21 Nov 2022 21:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=5h+D69zAceSnitj4V+d/VeyKxKMHm1GRwSPMxqxL0lo=;
 b=kZp6zFl5qwpp1xc3g8H2ZRz9Zmc36OE4xtHbxJB/U8oblQBdmacR3pw2+xNuJz4xzMyh
 6SHLZANEgX8K4qlr+/nRVYGXYHwB/J55RGVnhrbAd5A9RXjVXpZYgFrLdypI07vCCocc
 UEwmzIGOtF/QNiiK/ImLZ/ffJn5ZvI1NO59c62XmBBHHd3muoLhc4mEOpXCoTJ4Kqmzx
 Y55JZdpx+ODcK/kcTL9n+PwahaknFDjx1nJ8WrYMLVHddDtL/QZmBNCznuvfCiQlou3E
 xoQo7E5BCPC+2sOID2LZM5IFjb0wq17txBv2tCDDmWpx89WDePWlP4v/SHWmqhj0XAG6 Ew== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0fguav3a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:07 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALLaCMi020848;
        Mon, 21 Nov 2022 21:41:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3kxpdj2d8q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALLf2jW27394634
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:41:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1725B4C044;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 045064C04E;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 8B879E08BF; Mon, 21 Nov 2022 22:41:01 +0100 (CET)
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
Subject: [PATCH v1 13/16] vfio/ccw: allocate/populate the guest idal
Date:   Mon, 21 Nov 2022 22:40:53 +0100
Message-Id: <20221121214056.1187700-14-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121214056.1187700-1-farman@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: tu1rVEV_7AjQuvguG1o-ugX5HGJLRS5x
X-Proofpoint-ORIG-GUID: tu1rVEV_7AjQuvguG1o-ugX5HGJLRS5x
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_17,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 mlxscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211210158
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
 drivers/s390/cio/vfio_ccw_cp.c | 72 +++++++++++++++++++++++-----------
 1 file changed, 50 insertions(+), 22 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 6839e7195182..90685cee85db 100644
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
+		return NULL;
+
+	if (ccw_is_idal(ccw)) {
+		/* Copy IDAL from guest */
+		ret = vfio_dma_rw(vdev, ccw->cda, idaws, idal_len, false);
+		if (ret) {
+			kfree(idaws);
+			return NULL;
+		}
+	} else {
+		/* Fabricate an IDAL based off CCW data address */
+		if (cp->orb.cmd.c64) {
+			idaws[0] = ccw->cda;
+			for (i = 1; i < idaw_nr; i++)
+				idaws[i] = (idaws[i - 1] + idaw_size) & idaw_mask;
+		} else {
+			kfree(idaws);
+			return NULL;
+		}
+	}
+
+	return idaws;
+}
+
 /*
  * ccw_count_idaws() - Calculate the number of IDAWs needed to transfer
  * a specified amount of data
@@ -555,7 +594,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
 	unsigned long *idaws;
 	int ret;
-	int idaw_nr, idal_len;
+	int idaw_nr;
 	int i;
 
 	/* Calculate size of IDAL */
@@ -563,10 +602,8 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 	if (idaw_nr < 0)
 		return idaw_nr;
 
-	idal_len = idaw_nr * sizeof(*idaws);
-
 	/* Allocate an IDAL from host storage */
-	idaws = kcalloc(idaw_nr, sizeof(*idaws), GFP_DMA | GFP_KERNEL);
+	idaws = get_guest_idal(ccw, cp, idaw_nr);
 	if (!idaws) {
 		ret = -ENOMEM;
 		goto out_init;
@@ -582,22 +619,13 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
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

