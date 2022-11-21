Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CCA632F1D
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbiKUVmV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiKUVli (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:41:38 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98058DB876;
        Mon, 21 Nov 2022 13:41:08 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALLLYmr003915;
        Mon, 21 Nov 2022 21:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kN3Dkxy6fN9jTRkiIbybticlbZ22gn/WkCFZcZpeXe8=;
 b=OccvBHcNcxoSVZPfBLLLX+tnV46JuHte7Bm/TH6nReyp1CvNKn2y4otD4EIwwd4oIeZd
 9xMq5/9TPf2+sSlnyBKb8dO+wu4yGg7fnV52JmEbhT4ZfkrImVs36/xD0B4bLLJO/F3s
 JkoAFecUhftQKbqZc2TKM3e7RQBuSy64f5hf3lJl7R8wnslJsQq6SpscNwnkfdqbTDAL
 SCJb/zeI1ImoCSfiww64N36+Nvcr8iOhJtpkH8vYDPfyoz0yko/9h4mELhdz1RyxoKsa
 Xq1a7jcVq+veJnXFXSPDhBn+1a6KfeiCwXoi5hPq6NvJ9Tn2QoklF4UMfMB7GSDcKaC5 Qw== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0cnxyav5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:07 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALLaYBW014937;
        Mon, 21 Nov 2022 21:41:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma01fra.de.ibm.com with ESMTP id 3kxps92cr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALLf2W366453840
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:41:02 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0A29F4C050;
        Mon, 21 Nov 2022 21:41:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC5D14C046;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 7C9C5E081E; Mon, 21 Nov 2022 22:41:01 +0100 (CET)
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
Subject: [PATCH v1 08/16] vfio/ccw: pass page count to page_array struct
Date:   Mon, 21 Nov 2022 22:40:48 +0100
Message-Id: <20221121214056.1187700-9-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121214056.1187700-1-farman@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MINkycb_cqL0eINQIW3C-aJcTvubJZeC
X-Proofpoint-GUID: MINkycb_cqL0eINQIW3C-aJcTvubJZeC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_17,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 phishscore=0
 lowpriorityscore=0 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 adultscore=0 clxscore=1015 mlxscore=0 priorityscore=1501 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211210158
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The allocation of our page_array struct calculates the number
of 4K pages that would be needed to hold a certain number of
bytes. But, since the number of pages that will be pinned is
also calculated by the length of the IDAL, this logic is
unnecessary. Let's pass that information in directly, and
avoid the math within the allocator.

Also, let's make this two allocations instead of one,
to make it apparent what's happening within here.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 4b6b5f9dc92d..66e890441163 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -43,7 +43,7 @@ struct ccwchain {
  * page_array_alloc() - alloc memory for page array
  * @pa: page_array on which to perform the operation
  * @iova: target guest physical address
- * @len: number of bytes that should be pinned from @iova
+ * @len: number of pages that should be pinned from @iova
  *
  * Attempt to allocate memory for page array.
  *
@@ -63,18 +63,20 @@ static int page_array_alloc(struct page_array *pa, u64 iova, unsigned int len)
 	if (pa->pa_nr || pa->pa_iova)
 		return -EINVAL;
 
-	pa->pa_nr = ((iova & ~PAGE_MASK) + len + (PAGE_SIZE - 1)) >> PAGE_SHIFT;
-	if (!pa->pa_nr)
+	if (!len)
 		return -EINVAL;
 
-	pa->pa_iova = kcalloc(pa->pa_nr,
-			      sizeof(*pa->pa_iova) + sizeof(*pa->pa_page),
-			      GFP_KERNEL);
-	if (unlikely(!pa->pa_iova)) {
-		pa->pa_nr = 0;
+	pa->pa_nr = len;
+
+	pa->pa_iova = kcalloc(len, sizeof(*pa->pa_iova), GFP_KERNEL);
+	if (!pa->pa_iova)
+		return -ENOMEM;
+
+	pa->pa_page = kcalloc(len, sizeof(*pa->pa_page), GFP_KERNEL);
+	if (!pa->pa_page) {
+		kfree(pa->pa_iova);
 		return -ENOMEM;
 	}
-	pa->pa_page = (struct page **)&pa->pa_iova[pa->pa_nr];
 
 	pa->pa_iova[0] = iova;
 	pa->pa_page[0] = NULL;
@@ -167,6 +169,7 @@ static int page_array_pin(struct page_array *pa, struct vfio_device *vdev)
 static void page_array_unpin_free(struct page_array *pa, struct vfio_device *vdev)
 {
 	page_array_unpin(pa, vdev, pa->pa_nr);
+	kfree(pa->pa_page);
 	kfree(pa->pa_iova);
 }
 
@@ -545,7 +548,7 @@ static int ccwchain_fetch_ccw(struct ccw1 *ccw,
 	 * required for the data transfer, since we only only support
 	 * 4K IDAWs today.
 	 */
-	ret = page_array_alloc(pa, iova, bytes);
+	ret = page_array_alloc(pa, iova, idaw_nr);
 	if (ret < 0)
 		goto out_free_idaws;
 
-- 
2.34.1

