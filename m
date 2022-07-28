Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD87584750
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 22:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbiG1U5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jul 2022 16:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232781AbiG1U5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jul 2022 16:57:14 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B4574DF4;
        Thu, 28 Jul 2022 13:57:13 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SKmBi8011757;
        Thu, 28 Jul 2022 20:57:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=E4d6KifwHsmZzT9Q5UINm+bad82hFlSeFkgN+m7PCdE=;
 b=syiWpXE8R1UOy+E3k09/FvKToE5ml83eNNrOitBzETcWMOh/lLfrO5DsR2m83/etjZAj
 BqAYBYODMFMxhG0DHs01KYnwk/EFL8jKpwScQ/VMB64sXtBM7Z4T435/QPfoc4W7HAOg
 uTXp7tnQ9gEKUPTvV5oQYWtk1A14BjWu70decqhHqspasZjzsBzsD/2Xl+67w5xfIOlU
 j7oLbYHsRRFSQyPHe0tC50UihjCp/1W54z5YurjSFky4ZpEaP/xkxgXfzcjSxWnctFfH
 So/s2AeCtIBVKU92Emxo+yZ51oTz5MhagU7+ZOLd9lCre62MdFdm91Nhm5lFzEuNxFIP TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hm1t9g5nk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 20:57:10 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26SKprni026042;
        Thu, 28 Jul 2022 20:57:10 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hm1t9g5mr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 20:57:10 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26SKqNEJ010144;
        Thu, 28 Jul 2022 20:57:08 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3hg98neucn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 20:57:08 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26SKv4dn26804510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jul 2022 20:57:04 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9020C52052;
        Thu, 28 Jul 2022 20:57:04 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 7EEB552050;
        Thu, 28 Jul 2022 20:57:04 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 091E5E092A; Thu, 28 Jul 2022 22:49:16 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Nicolin Chen <nicolinc@nvidia.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v3 1/3] vfio/ccw: Add length to DMA_UNMAP checks
Date:   Thu, 28 Jul 2022 22:49:12 +0200
Message-Id: <20220728204914.2420989-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220728204914.2420989-1-farman@linux.ibm.com>
References: <20220728204914.2420989-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 4wSoQ_vzxeL0WWOWb3ddQXG-OMksLhAw
X-Proofpoint-GUID: tX7OQ7FvtlPkC1rkYLFo0mY05-xXF4zm
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 priorityscore=1501 suspectscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207280093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As pointed out with the simplification of the
VFIO_IOMMU_NOTIFY_DMA_UNMAP notifier [1], the length
parameter was never used to check against the pinned
pages.

Let's correct that, and see if a page is within the
affected range instead of simply the first page of
the range.

[1] https://lore.kernel.org/kvm/20220720170457.39cda0d0.alex.williamson@redhat.com/

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c  | 16 +++++++++++-----
 drivers/s390/cio/vfio_ccw_cp.h  |  2 +-
 drivers/s390/cio/vfio_ccw_ops.c |  2 +-
 3 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 8963f452f963..7b02e97f4b29 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -170,13 +170,18 @@ static void page_array_unpin_free(struct page_array *pa, struct vfio_device *vde
 	kfree(pa->pa_iova);
 }
 
-static bool page_array_iova_pinned(struct page_array *pa, unsigned long iova)
+static bool page_array_iova_pinned(struct page_array *pa, u64 iova, u64 length)
 {
+	u64 iova_pfn_start = iova >> PAGE_SHIFT;
+	u64 iova_pfn_end = (iova + length - 1) >> PAGE_SHIFT;
+	u64 pfn;
 	int i;
 
-	for (i = 0; i < pa->pa_nr; i++)
-		if (pa->pa_iova[i] == iova)
+	for (i = 0; i < pa->pa_nr; i++) {
+		pfn = pa->pa_iova[i] >> PAGE_SHIFT;
+		if (pfn >= iova_pfn_start && pfn <= iova_pfn_end)
 			return true;
+	}
 
 	return false;
 }
@@ -899,11 +904,12 @@ void cp_update_scsw(struct channel_program *cp, union scsw *scsw)
  * cp_iova_pinned() - check if an iova is pinned for a ccw chain.
  * @cp: channel_program on which to perform the operation
  * @iova: the iova to check
+ * @length: the length to check from @iova
  *
  * If the @iova is currently pinned for the ccw chain, return true;
  * else return false.
  */
-bool cp_iova_pinned(struct channel_program *cp, u64 iova)
+bool cp_iova_pinned(struct channel_program *cp, u64 iova, u64 length)
 {
 	struct ccwchain *chain;
 	int i;
@@ -913,7 +919,7 @@ bool cp_iova_pinned(struct channel_program *cp, u64 iova)
 
 	list_for_each_entry(chain, &cp->ccwchain_list, next) {
 		for (i = 0; i < chain->ch_len; i++)
-			if (page_array_iova_pinned(chain->ch_pa + i, iova))
+			if (page_array_iova_pinned(chain->ch_pa + i, iova, length))
 				return true;
 	}
 
diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
index 3194d887e08e..54d26e242533 100644
--- a/drivers/s390/cio/vfio_ccw_cp.h
+++ b/drivers/s390/cio/vfio_ccw_cp.h
@@ -46,6 +46,6 @@ void cp_free(struct channel_program *cp);
 int cp_prefetch(struct channel_program *cp);
 union orb *cp_get_orb(struct channel_program *cp, u32 intparm, u8 lpm);
 void cp_update_scsw(struct channel_program *cp, union scsw *scsw);
-bool cp_iova_pinned(struct channel_program *cp, u64 iova);
+bool cp_iova_pinned(struct channel_program *cp, u64 iova, u64 length);
 
 #endif
diff --git a/drivers/s390/cio/vfio_ccw_ops.c b/drivers/s390/cio/vfio_ccw_ops.c
index 0047fd88f938..3f67fa103c7f 100644
--- a/drivers/s390/cio/vfio_ccw_ops.c
+++ b/drivers/s390/cio/vfio_ccw_ops.c
@@ -39,7 +39,7 @@ static void vfio_ccw_dma_unmap(struct vfio_device *vdev, u64 iova, u64 length)
 		container_of(vdev, struct vfio_ccw_private, vdev);
 
 	/* Drivers MUST unpin pages in response to an invalidation. */
-	if (!cp_iova_pinned(&private->cp, iova))
+	if (!cp_iova_pinned(&private->cp, iova, length))
 		return;
 
 	vfio_ccw_mdev_reset(private);
-- 
2.34.1

