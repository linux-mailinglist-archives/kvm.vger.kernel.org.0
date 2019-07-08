Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D88062A30
	for <lists+kvm@lfdr.de>; Mon,  8 Jul 2019 22:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404888AbfGHULG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jul 2019 16:11:06 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1192 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729283AbfGHULF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jul 2019 16:11:05 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x68K7NFf131834;
        Mon, 8 Jul 2019 16:10:44 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tmbg5jbap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 16:10:44 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x68KAeIe017974;
        Mon, 8 Jul 2019 20:10:43 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma01dal.us.ibm.com with ESMTP id 2tjk970eqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Jul 2019 20:10:43 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x68KAfA060948750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 8 Jul 2019 20:10:41 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A51BFBE053;
        Mon,  8 Jul 2019 20:10:41 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 271B6BE059;
        Mon,  8 Jul 2019 20:10:41 +0000 (GMT)
Received: from alifm-ThinkPad-T470p.pok.ibm.com (unknown [9.56.58.103])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon,  8 Jul 2019 20:10:40 +0000 (GMT)
From:   Farhan Ali <alifm@linux.ibm.com>
To:     cohuck@redhat.com, farman@linux.ibm.com, pasic@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        alifm@linux.ibm.com
Subject: [RFC v2 2/5] vfio-ccw: Fix memory leak and don't call cp_free in cp_init
Date:   Mon,  8 Jul 2019 16:10:35 -0400
Message-Id: <fbb44bc85f5dfe4fdaebaf9cb74efcfae4743fba.1562616169.git.alifm@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1562616169.git.alifm@linux.ibm.com>
References: <cover.1562616169.git.alifm@linux.ibm.com>
In-Reply-To: <cover.1562616169.git.alifm@linux.ibm.com>
References: <cover.1562616169.git.alifm@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=935 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080250
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't set cp->initialized to true so calling cp_free
will just return and not do anything.

Also fix a memory leak where we fail to free a ccwchain
on an error.

Fixes: 812271b910 ("s390/cio: Squash cp_free() and cp_unpin_free()")
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 7622b72..31a04a5 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -421,7 +421,7 @@ static int ccwchain_loop_tic(struct ccwchain *chain,
 static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 {
 	struct ccwchain *chain;
-	int len;
+	int len, ret;
 
 	/* Copy 2K (the most we support today) of possible CCWs */
 	len = copy_from_iova(cp->mdev, cp->guest_cp, cda,
@@ -448,7 +448,12 @@ static int ccwchain_handle_ccw(u32 cda, struct channel_program *cp)
 	memcpy(chain->ch_ccw, cp->guest_cp, len * sizeof(struct ccw1));
 
 	/* Loop for tics on this new chain. */
-	return ccwchain_loop_tic(chain, cp);
+	ret = ccwchain_loop_tic(chain, cp);
+
+	if (ret)
+		ccwchain_free(chain);
+
+	return ret;
 }
 
 /* Loop for TICs. */
@@ -642,8 +647,6 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 
 	/* Build a ccwchain for the first CCW segment */
 	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
-	if (ret)
-		cp_free(cp);
 
 	/* It is safe to force: if it was not set but idals used
 	 * ccwchain_calc_length would have returned an error.
-- 
2.7.4

