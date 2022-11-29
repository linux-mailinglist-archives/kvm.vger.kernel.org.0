Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA74763C0C3
	for <lists+kvm@lfdr.de>; Tue, 29 Nov 2022 14:14:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbiK2NOY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 08:14:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbiK2NNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 08:13:53 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B07C5C762
        for <kvm@vger.kernel.org>; Tue, 29 Nov 2022 05:12:59 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ATAiYEQ005244;
        Tue, 29 Nov 2022 13:12:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2022-7-12; bh=pc713x/1JkqKcZIP5oPRm+h2chqljhhqBQ3i+4uiCRw=;
 b=XKMYEp/V8JAs0BRxiZiVfaRRwlrN+7kYUKfBsP32Nw7UmI63bLXP3jYOtf/bwOLUTtui
 vB2mGCkcMBiOAgxEoMufr5KyUzUYf77Ai2XpmBl3LjDbXsGRtnrdGz/YOdwgX8XfNEPu
 rAvt8vdNYhwRRGD345agYMv1x+5R/TQLpGseOLaK6tYW5Dp1Qpyan/nU6COzuGtxHGay
 8Jj+gdfXCHFoxDV5e1/1p/zg4gSRrGIOYwsJeBAeRntVGglbqtOySoa2Pv7JBs7E44Fl
 S37Qp262nwWm/ccvJSkvmfhYjrQYstoaSXqFpcvX4T3uTPbmg9Vfh96h1+mRcRi/gGqH WQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m39k2pq1d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 13:12:55 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ATCFTXQ027030;
        Tue, 29 Nov 2022 13:12:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3m3c1v7p6n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 29 Nov 2022 13:12:55 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ATDCswM016131;
        Tue, 29 Nov 2022 13:12:54 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-164-4.vpn.oracle.com [10.175.164.4])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3m3c1v7p5h-1;
        Tue, 29 Nov 2022 13:12:54 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>
Subject: [PATCH v2] vfio/iova_bitmap: refactor iova_bitmap_set() to better handle page boundaries
Date:   Tue, 29 Nov 2022 13:12:35 +0000
Message-Id: <20221129131235.38880-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-29_08,2022-11-29_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 bulkscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211290077
X-Proofpoint-GUID: K_LNDjBktNF1lmoPBilsW1eNTi9IugK1
X-Proofpoint-ORIG-GUID: K_LNDjBktNF1lmoPBilsW1eNTi9IugK1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
had fixed the unaligned bitmaps by capping the remaining iterable set at
the start of the bitmap. Although, that mistakenly worked around
iova_bitmap_set() incorrectly setting bits across page boundary.

Fix this by reworking the loop inside iova_bitmap_set() to iterate over a
range of bits to set (cur_bit .. last_bit) which may span different pinned
pages, thus updating @page_idx and @offset as it sets the bits. The
previous cap to the first page is now adjusted to be always accounted
rather than when there's only a non-zero pgoff.

While at it, make @page_idx , @offset and @nbits to be unsigned int given
that it won't be more than 512 and 4096 respectively (even a bigger
PAGE_SIZE or a smaller struct page size won't make this bigger than the
above 32-bit max). Also, delete the stale kdoc on Return type.

Cc: Avihai Horon <avihaih@nvidia.com>
Fixes: f38044e5ef58 ("vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps")
Co-developed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
Changes since v1:
 * Add Reviewed-by by Jason Gunthorpe
 * Add Fixes tag (Alex Williamson)

It passes my tests but to be extra sure: Avihai could you take this
patch a spin in your rig/tests as well? Thanks!
---
 drivers/vfio/iova_bitmap.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
index de6d6ea5c496..0848f920efb7 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -298,9 +298,7 @@ static unsigned long iova_bitmap_mapped_remaining(struct iova_bitmap *bitmap)
 {
 	unsigned long remaining, bytes;
 
-	/* Cap to one page in the first iteration, if PAGE_SIZE unaligned. */
-	bytes = !bitmap->mapped.pgoff ? bitmap->mapped.npages << PAGE_SHIFT :
-					PAGE_SIZE - bitmap->mapped.pgoff;
+	bytes = (bitmap->mapped.npages << PAGE_SHIFT) - bitmap->mapped.pgoff;
 
 	remaining = bitmap->mapped_total_index - bitmap->mapped_base_index;
 	remaining = min_t(unsigned long, remaining,
@@ -399,29 +397,27 @@ int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
  * Set the bits corresponding to the range [iova .. iova+length-1] in
  * the user bitmap.
  *
- * Return: The number of bits set.
  */
 void iova_bitmap_set(struct iova_bitmap *bitmap,
 		     unsigned long iova, size_t length)
 {
 	struct iova_bitmap_map *mapped = &bitmap->mapped;
-	unsigned long offset = (iova - mapped->iova) >> mapped->pgshift;
-	unsigned long nbits = max_t(unsigned long, 1, length >> mapped->pgshift);
-	unsigned long page_idx = offset / BITS_PER_PAGE;
-	unsigned long page_offset = mapped->pgoff;
-	void *kaddr;
-
-	offset = offset % BITS_PER_PAGE;
+	unsigned long cur_bit = ((iova - mapped->iova) >>
+			mapped->pgshift) + mapped->pgoff * BITS_PER_BYTE;
+	unsigned long last_bit = (((iova + length - 1) - mapped->iova) >>
+			mapped->pgshift) + mapped->pgoff * BITS_PER_BYTE;
 
 	do {
-		unsigned long size = min(BITS_PER_PAGE - offset, nbits);
+		unsigned int page_idx = cur_bit / BITS_PER_PAGE;
+		unsigned int offset = cur_bit % BITS_PER_PAGE;
+		unsigned int nbits = min(BITS_PER_PAGE - offset,
+					 last_bit - cur_bit + 1);
+		void *kaddr;
 
 		kaddr = kmap_local_page(mapped->pages[page_idx]);
-		bitmap_set(kaddr + page_offset, offset, size);
+		bitmap_set(kaddr, offset, nbits);
 		kunmap_local(kaddr);
-		page_offset = offset = 0;
-		nbits -= size;
-		page_idx++;
-	} while (nbits > 0);
+		cur_bit += nbits;
+	} while (cur_bit <= last_bit);
 }
 EXPORT_SYMBOL_GPL(iova_bitmap_set);
-- 
2.17.2

