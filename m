Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10218632F0B
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 22:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbiKUVl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 16:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbiKUVlW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 16:41:22 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170E9D53B7;
        Mon, 21 Nov 2022 13:41:08 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALLQKnG011420;
        Mon, 21 Nov 2022 21:41:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WKsGdEAk1m9l4J0Hd3fdAUHO3upFSJZAHb/Rm69tOoU=;
 b=eN1Yk9N9d7Nn0O3L4CcfkTEM0h/HMVEiKvJWgxor2eMEwKMRV5mDvuXgpYzMFEIg0Rus
 Y03RhTOPIfLESm0P+vTvXvIuzKs5lXzGu2ZDzNTQkIAixeyCwuugbsoovg9GF9Y6+G+w
 b4RVHmbvio4xQnSyPxiyS1ya2VUNoULhiQhjh9YOiHy1OTDPE/oqoLf+FXz18C6UkPUH
 2iJcCMPdoWWquW3vSn6jFcYF5Qrh6L+zk/4LwP0Soh8xLAkPCayZRqVEG/prxWJxH7RP
 SeIaxhqTMbeFxqzP6FC2Smtc4RxotPPG1MLR3WkmzAlCFLafV0RWoQjbON/rFKAgezQg ag== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0d3g6mtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:07 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ALLaj7a025119;
        Mon, 21 Nov 2022 21:41:05 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3kxps8tcxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Nov 2022 21:41:05 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ALLf1kH46596552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 21:41:01 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BC90CAE051;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA9F6AE04D;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Mon, 21 Nov 2022 21:41:01 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 67405E012D; Mon, 21 Nov 2022 22:41:01 +0100 (CET)
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
Subject: [PATCH v1 01/16] vfio/ccw: cleanup some of the mdev commentary
Date:   Mon, 21 Nov 2022 22:40:41 +0100
Message-Id: <20221121214056.1187700-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121214056.1187700-1-farman@linux.ibm.com>
References: <20221121214056.1187700-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 39CBoZnCYXgK4OwzupVsRyD7VGafL0cR
X-Proofpoint-GUID: 39CBoZnCYXgK4OwzupVsRyD7VGafL0cR
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_18,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 phishscore=0 mlxlogscore=999 clxscore=1015
 malwarescore=0 suspectscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211210162
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no longer an mdev struct accessible via a channel
program struct, but there are some artifacts remaining that
mention it. Clean them up.

Fixes: 0a58795647cd ("vfio/ccw: Remove mdev from struct channel_program")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 5 ++---
 drivers/s390/cio/vfio_ccw_cp.h | 1 -
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index c0a09fa8991a..9e6df1f2fbee 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -121,7 +121,7 @@ static void page_array_unpin(struct page_array *pa,
 /*
  * page_array_pin() - Pin user pages in memory
  * @pa: page_array on which to perform the operation
- * @mdev: the mediated device to perform pin operations
+ * @vdev: the vfio device to perform pin operations
  *
  * Returns number of pages pinned upon success.
  * If the pin request partially succeeds, or fails completely,
@@ -229,7 +229,7 @@ static void convert_ccw0_to_ccw1(struct ccw1 *source, unsigned long len)
 }
 
 /*
- * Within the domain (@mdev), copy @n bytes from a guest physical
+ * Within the domain (@vdev), copy @n bytes from a guest physical
  * address (@iova) to a host physical address (@to).
  */
 static long copy_from_iova(struct vfio_device *vdev, void *to, u64 iova,
@@ -665,7 +665,6 @@ static int ccwchain_fetch_one(struct ccwchain *chain,
 /**
  * cp_init() - allocate ccwchains for a channel program.
  * @cp: channel_program on which to perform the operation
- * @mdev: the mediated device to perform pin/unpin operations
  * @orb: control block for the channel program from the guest
  *
  * This creates one or more ccwchain(s), and copies the raw data of
diff --git a/drivers/s390/cio/vfio_ccw_cp.h b/drivers/s390/cio/vfio_ccw_cp.h
index 54d26e242533..16138a654fdd 100644
--- a/drivers/s390/cio/vfio_ccw_cp.h
+++ b/drivers/s390/cio/vfio_ccw_cp.h
@@ -27,7 +27,6 @@
  * struct channel_program - manage information for channel program
  * @ccwchain_list: list head of ccwchains
  * @orb: orb for the currently processed ssch request
- * @mdev: the mediated device to perform page pinning/unpinning
  * @initialized: whether this instance is actually initialized
  *
  * @ccwchain_list is the head of a ccwchain list, that contents the
-- 
2.34.1

