Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0733B37EC9
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 22:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfFFU2t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 16:28:49 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42864 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727034AbfFFU2l (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 Jun 2019 16:28:41 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x56KQvMr019227
        for <kvm@vger.kernel.org>; Thu, 6 Jun 2019 16:28:41 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sy86xmmqk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 16:28:39 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Thu, 6 Jun 2019 21:28:37 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 6 Jun 2019 21:28:35 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x56KSYV753477538
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 6 Jun 2019 20:28:34 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E48A8A4062;
        Thu,  6 Jun 2019 20:28:33 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF412A4054;
        Thu,  6 Jun 2019 20:28:33 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu,  6 Jun 2019 20:28:33 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id 548B7E0287; Thu,  6 Jun 2019 22:28:33 +0200 (CEST)
From:   Eric Farman <farman@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH v2 2/9] s390/cio: Refactor the routine that handles TIC CCWs
Date:   Thu,  6 Jun 2019 22:28:24 +0200
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190606202831.44135-1-farman@linux.ibm.com>
References: <20190606202831.44135-1-farman@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19060620-0008-0000-0000-000002F0EC0E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060620-0009-0000-0000-0000225DD9D0
Message-Id: <20190606202831.44135-3-farman@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-06_14:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906060138
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extract the "does the target of this TIC already exist?" check from
ccwchain_handle_tic(), so that it's easier to refactor that function
into one that cp_init() is able to use.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 47cd7f94f42f..628daf1a8f9a 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -502,10 +502,6 @@ static int ccwchain_handle_tic(struct ccw1 *tic, struct channel_program *cp)
 	struct ccwchain *chain;
 	int len, ret;
 
-	/* May transfer to an existing chain. */
-	if (tic_target_chain_exists(tic, cp))
-		return 0;
-
 	/* Get chain length. */
 	len = ccwchain_calc_length(tic->cda, cp);
 	if (len < 0)
@@ -540,6 +536,10 @@ static int ccwchain_loop_tic(struct ccwchain *chain, struct channel_program *cp)
 		if (!ccw_is_tic(tic))
 			continue;
 
+		/* May transfer to an existing chain. */
+		if (tic_target_chain_exists(tic, cp))
+			continue;
+
 		ret = ccwchain_handle_tic(tic, cp);
 		if (ret)
 			return ret;
-- 
2.17.1

