Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 156AB4AB9E
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2019 22:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730624AbfFRUYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jun 2019 16:24:03 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:56268 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730571AbfFRUYC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Jun 2019 16:24:02 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5IKHWkY124331
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 16:24:01 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t73wugmxx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 18 Jun 2019 16:24:00 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Tue, 18 Jun 2019 21:23:58 +0100
Received: from b06avi18626390.portsmouth.uk.ibm.com (9.149.26.192)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 18 Jun 2019 21:23:56 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5IKNkuU19595558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jun 2019 20:23:46 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50486AE056;
        Tue, 18 Jun 2019 20:23:54 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3CC5EAE053;
        Tue, 18 Jun 2019 20:23:54 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue, 18 Jun 2019 20:23:54 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id CC353E0250; Tue, 18 Jun 2019 22:23:53 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [RFC PATCH v1 2/5] vfio-ccw: Skip second copy of guest cp to host
Date:   Tue, 18 Jun 2019 22:23:49 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190618202352.39702-1-farman@linux.ibm.com>
References: <20190618202352.39702-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19061820-4275-0000-0000-00000343755B
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061820-4276-0000-0000-000038539E94
Message-Id: <20190618202352.39702-3-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-18_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906180161
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already pinned/copied/unpinned 2K (256 CCWs) of guest memory
to the host space anchored off vfio_ccw_private.  There's no need
to do that again once we have the length calculated, when we could
just copy the section we need to the "permanent" space for the I/O.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index f358502376be..37d513e86530 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -444,7 +444,7 @@ static int ccwchain_loop_tic(struct ccwchain *chain,
 static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 {
 	struct ccwchain *chain;
-	int len, ret;
+	int len;
 
 	/* Copy the chain from cda to cp, and count the CCWs in it */
 	len = ccwchain_calc_length(cda, cp);
@@ -457,12 +457,8 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 		return -ENOMEM;
 	chain->ch_iova = cda;
 
-	/* Copy the new chain from user. */
-	ret = copy_ccw_from_iova(cp, chain->ch_ccw, cda, len);
-	if (ret) {
-		ccwchain_free(chain);
-		return ret;
-	}
+	/* Copy the actual CCWs into the new chain */
+	memcpy(chain->ch_ccw, cp->guest_cp, len * sizeof(struct ccw1));
 
 	/* Loop for tics on this new chain. */
 	return ccwchain_loop_tic(chain, cp);
-- 
2.17.1

