Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AAB765254A
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234087AbiLTRLP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:11:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234015AbiLTRKo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:10:44 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96A0AC48;
        Tue, 20 Dec 2022 09:10:43 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKGrkvB011643;
        Tue, 20 Dec 2022 17:10:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=l+h0KmgNOrLbYCEJt2cAcdsfmoyl7J7OXXtpA+JbNQA=;
 b=aDG2sgViM7jIlgegG5/YYHxGNTJ6v6gNjfVC0PdOqokdQ+O7+IwtgKHJ8KipxW4iWGr5
 NkGSUua+dm/d6N6pLOO+f9+MgrSCMURecMmmkyo0toDgHhUly7okdqyRvPSylfQp6+EB
 QcKCy5lmDaCQaHF8vS9OEZcsMiizN/W0L7QoRSbg/7zYZx4z3pvQBlxkiRiCF+8mew0t
 l+iuaWujoNgcXghQo4Nv5iHV/aKpEz/fCquaWOTGIrDAMmqcUEp8oAyCM6O7oggfCp48
 J8SF8HqV2+koOOcb7drt8xrpGSvdZYX8OTW3KUQCaGVUOe7FcXW9jSChX549kjhXg0d+ /A== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgyp170s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:40 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK6T2v5014025;
        Tue, 20 Dec 2022 17:10:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3mh6yw4axj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHA9ou39584150
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:09 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4CDD20040;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B38032004B;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:09 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 7D04FE06D6; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
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
Subject: [PATCH v2 01/16] vfio/ccw: cleanup some of the mdev commentary
Date:   Tue, 20 Dec 2022 18:09:53 +0100
Message-Id: <20221220171008.1362680-2-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -l4IkiGZ6EIMvqRQ3tsRzxy8h6LBqdx9
X-Proofpoint-ORIG-GUID: -l4IkiGZ6EIMvqRQ3tsRzxy8h6LBqdx9
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

There is no longer an mdev struct accessible via a channel
program struct, but there are some artifacts remaining that
mention it. Clean them up.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
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

