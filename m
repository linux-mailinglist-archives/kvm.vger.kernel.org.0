Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2C7D652546
	for <lists+kvm@lfdr.de>; Tue, 20 Dec 2022 18:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234139AbiLTRLI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Dec 2022 12:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234045AbiLTRKl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Dec 2022 12:10:41 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9F1219;
        Tue, 20 Dec 2022 09:10:40 -0800 (PST)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BKGrmUp011868;
        Tue, 20 Dec 2022 17:10:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WOJkdvI3Ef5NA+YR195KiYapTcEpduqxXV+OMvaNr6M=;
 b=ZrGSolfABPH9pmkxf7JtlVcqw3boE9bGn2PdfSTa9yJVVGaFl4l4US9xRA97+x4XIwPi
 y2hcbi+7JIcIDQ0k56LS3RKMrPWGwK+s+eEdMgHxhMzN6RI/IYLxsX5kTyJCL0db8GNf
 G8qZUzwWrgEF330uK6batoNqf7Jg8NzDZh1jhFbfDQL92Nv/OoEwdEB2KutR2SOS8mxT
 zMONgcmGcwd1gCGg+Q6ooATOOWnTWf9uyRb1f7dMVhWQw6b7Iy1s/C+IxZPYRcpM964q
 VKShmcqTkqa8LVXnRQDM8qIdtujJaBLRoEwRuxK6aFNJLGi6Huc+rmybZvrPCRN2mVeH nA== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mkgyp170x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:39 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BK7b15K014065;
        Tue, 20 Dec 2022 17:10:14 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3mh6yw4axk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Dec 2022 17:10:13 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BKHAA2u37552410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Dec 2022 17:10:10 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C69120065;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1DA532005A;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Tue, 20 Dec 2022 17:10:10 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 996F6E08E6; Tue, 20 Dec 2022 18:10:09 +0100 (CET)
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
Subject: [PATCH v2 11/16] vfio/ccw: read only one Format-1 IDAW
Date:   Tue, 20 Dec 2022 18:10:03 +0100
Message-Id: <20221220171008.1362680-12-farman@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221220171008.1362680-1-farman@linux.ibm.com>
References: <20221220171008.1362680-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _rNj5vtX9bKmYggO_4n4qKM1tEmX43qG
X-Proofpoint-ORIG-GUID: _rNj5vtX9bKmYggO_4n4qKM1tEmX43qG
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

The intention is to read the first IDAW to determine the starting
location of an I/O operation, knowing that the second and any/all
subsequent IDAWs will be aligned per architecture. But, this read
receives 64-bits of data, which is the size of a Format-2 IDAW.

In the event that Format-1 IDAWs are presented, adjust the size
of the read to 32-bits. The data will end up occupying the upper
word of the target iova variable, so shift it down to the lower
word for use as an adddress. (By definition, this IDAW format
uses a 31-bit address, so the "sign" bit will always be off and
there is no concern about sign extension.)

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 9d74e0b74da7..29d1e418b2e2 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -509,6 +509,7 @@ static int ccw_count_idaws(struct ccw1 *ccw,
 	struct vfio_device *vdev =
 		&container_of(cp, struct vfio_ccw_private, cp)->vdev;
 	u64 iova;
+	int size = cp->orb.cmd.c64 ? sizeof(u64) : sizeof(u32);
 	int ret;
 	int bytes = 1;
 
@@ -516,11 +517,15 @@ static int ccw_count_idaws(struct ccw1 *ccw,
 		bytes = ccw->count;
 
 	if (ccw_is_idal(ccw)) {
-		/* Read first IDAW to see if it's 4K-aligned or not. */
-		/* All subsequent IDAws will be 4K-aligned. */
-		ret = vfio_dma_rw(vdev, ccw->cda, &iova, sizeof(iova), false);
+		/* Read first IDAW to check its starting address. */
+		/* All subsequent IDAWs will be 2K- or 4K-aligned. */
+		ret = vfio_dma_rw(vdev, ccw->cda, &iova, size, false);
 		if (ret)
 			return ret;
+
+		/* Format-1 IDAWs only occupy the first int */
+		if (!cp->orb.cmd.c64)
+			iova = iova >> 32;
 	} else {
 		iova = ccw->cda;
 	}
-- 
2.34.1

