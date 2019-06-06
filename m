Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB9137EC3
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 22:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727063AbfFFU2m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 16:28:42 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36788 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726962AbfFFU2k (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jun 2019 16:28:40 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56KRZ9e083453
        for <kvm@vger.kernel.org>; Thu, 6 Jun 2019 16:28:39 -0400
Received: from e06smtp03.uk.ibm.com (e06smtp03.uk.ibm.com [195.75.94.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sy71hg955-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 16:28:39 -0400
Received: from localhost
        by e06smtp03.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Thu, 6 Jun 2019 21:28:37 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp03.uk.ibm.com (192.168.101.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 21:28:35 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56KSYcg33947660
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 20:28:34 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2D0642041;
        Thu,  6 Jun 2019 20:28:33 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEE044203F;
        Thu,  6 Jun 2019 20:28:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  6 Jun 2019 20:28:33 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 570D9E02AA; Thu,  6 Jun 2019 22:28:33 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 3/9] s390/cio: Generalize the TIC handler
Date:   Thu,  6 Jun 2019 22:28:25 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606202831.44135-1-farman@linux.ibm.com>
References: <20190606202831.44135-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19060620-0012-0000-0000-00000325ECA5
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060620-0013-0000-0000-0000215ED5C5
Message-Id: <20190606202831.44135-4-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=985 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor ccwchain_handle_tic() into a routine that handles a channel
program address (which itself is a CCW pointer), rather than a CCW pointer
that is only a TIC CCW.  This will make it easier to reuse this code for
other CCW commands.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 628daf1a8f9a..52735cdb0270 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -497,13 +497,13 @@ static int tic_target_chain_exists(struct ccw1 *tic, struct channel_program *cp)
 static int ccwchain_loop_tic(struct ccwchain *chain,
 			     struct channel_program *cp);
 
-static int ccwchain_handle_tic(struct ccw1 *tic, struct channel_program *cp)
+static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 {
 	struct ccwchain *chain;
 	int len, ret;
 
 	/* Get chain length. */
-	len = ccwchain_calc_length(tic->cda, cp);
+	len = ccwchain_calc_length(cda, cp);
 	if (len < 0)
 		return len;
 
@@ -511,10 +511,10 @@ static int ccwchain_handle_tic(struct ccw1 *tic, struct channel_program *cp)
 	chain = ccwchain_alloc(cp, len);
 	if (!chain)
 		return -ENOMEM;
-	chain->ch_iova = tic->cda;
+	chain->ch_iova = cda;
 
 	/* Copy the new chain from user. */
-	ret = copy_ccw_from_iova(cp, chain->ch_ccw, tic->cda, len);
+	ret = copy_ccw_from_iova(cp, chain->ch_ccw, cda, len);
 	if (ret) {
 		ccwchain_free(chain);
 		return ret;
@@ -540,7 +540,8 @@ static int ccwchain_loop_tic(struct ccwchain *chain, struct channel_program *cp)
 		if (tic_target_chain_exists(tic, cp))
 			continue;
 
-		ret = ccwchain_handle_tic(tic, cp);
+		/* Build a ccwchain for the next segment */
+		ret = ccwchain_handle_ccw(tic->cda, cp);
 		if (ret)
 			return ret;
 	}
-- 
2.17.1

