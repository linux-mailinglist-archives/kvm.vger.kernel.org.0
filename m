Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42FC60D4B2
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 21:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbiJYTbd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 15:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiJYTbb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 15:31:31 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B60D038A
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 12:31:30 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PI4jO2004124;
        Tue, 25 Oct 2022 19:31:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2022-7-12;
 bh=hIWH2Ou//jnKTr9ST84eauTacDt2erWlMIRsuZiOAkE=;
 b=VV6OPs8JZDNwoqrVlJkfEqZ/CkxMOWadlTUHMKFP9gpXLcm25oz6qLx+kdDRDjQ1Nv7I
 7po6A9Va93ARReS6QgytQQIo8zVorBAQWx9a5/WNFlwGtNHZ5sameLn/nTgS6O6tu4sT
 PjzZNRkxD5b9p/hDpSOd5wf0zMCLdYfF7GmL3UQTTniKSBsG59h43L1pRZzufN+6Sl/a
 4C5L12XqnMcfVzwKA3b5BQiJO3fcapyC3GB2yuIKZljViit/hS7Wfi8OJ6ZAJnjsENd/
 9PXtJmnLIA9XMdYgj+nTEaYPWXVYju85Wdj1IMDyRSemQ1jk+ISQjK65m5A1oFFlCZ0Y Tg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc939d5yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 19:31:27 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29PJ5VkT012753;
        Tue, 25 Oct 2022 19:31:26 GMT
Received: from joaomart-mac.uk.oracle.com (dhcp-10-175-215-98.vpn.oracle.com [10.175.215.98])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3kc6y4y1dp-3;
        Tue, 25 Oct 2022 19:31:26 +0000
From:   Joao Martins <joao.m.martins@oracle.com>
To:     kvm@vger.kernel.org
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: [PATCH v1 2/2] vfio/iova_bitmap: Fix PAGE_SIZE unaligned bitmaps
Date:   Tue, 25 Oct 2022 20:31:14 +0100
Message-Id: <20221025193114.58695-3-joao.m.martins@oracle.com>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
In-Reply-To: <20221025193114.58695-1-joao.m.martins@oracle.com>
References: <20221025193114.58695-1-joao.m.martins@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_12,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=856 bulkscore=0
 suspectscore=0 malwarescore=0 phishscore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210250110
X-Proofpoint-GUID: dxmYgZuO6zIJG_DawbH-90ioERIP44EP
X-Proofpoint-ORIG-GUID: dxmYgZuO6zIJG_DawbH-90ioERIP44EP
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

iova_bitmap_set() doesn't consider the end of the page boundary when the
first bitmap page offset isn't zero, and wrongly changes the consecutive
page right after. Consequently this leads to missing dirty pages from
reported by the device as seen from the VMM.

The current logic iterates over a given number of base pages and clamps it
to the remaining indexes to iterate in the last page.  Instead of having to
consider extra pages to pin (e.g. first and extra pages), just handle the
first page as its own range and let the rest of the bitmap be handled as if
it was base page aligned.

This is done by changing iova_bitmap_mapped_remaining() to return PAGE_SIZE
- pgoff (on the first bitmap page), and leads to pgoff being set to 0 on
following iterations.

Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
Reported-by: Avihai Horon <avihaih@nvidia.com>
Tested-by: Avihai Horon <avihaih@nvidia.com>
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
---
I have a small test suite that I have been using for functional and some
performance tests; I try to cover all the edge cases. Though I happened to
miss having a test case (which is also fixed) ... leading to this bug.
I wonder if this test suite is something of interest to have in tree?
---
 drivers/vfio/iova_bitmap.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
index 389f36cae355..40463c51da31 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -296,11 +296,15 @@ void iova_bitmap_free(struct iova_bitmap *bitmap)
  */
 static unsigned long iova_bitmap_mapped_remaining(struct iova_bitmap *bitmap)
 {
-	unsigned long remaining;
+	unsigned long remaining, bytes;
+
+	/* Cap to one page in the first iteration, if PAGE_SIZE unaligned. */
+	bytes = !bitmap->mapped.pgoff ? bitmap->mapped.npages << PAGE_SHIFT :
+					PAGE_SIZE - bitmap->mapped.pgoff;
 
 	remaining = bitmap->mapped_total_index - bitmap->mapped_base_index;
 	remaining = min_t(unsigned long, remaining,
-	      (bitmap->mapped.npages << PAGE_SHIFT) / sizeof(*bitmap->bitmap));
+			  bytes / sizeof(*bitmap->bitmap));
 
 	return remaining;
 }
-- 
2.17.2

