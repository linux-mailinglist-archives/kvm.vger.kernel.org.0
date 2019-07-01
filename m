Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5239D5C10B
	for <lists+kvm@lfdr.de>; Mon,  1 Jul 2019 18:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbfGAQYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jul 2019 12:24:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:20030 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727227AbfGAQYC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jul 2019 12:24:02 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61GNnlK051686;
        Mon, 1 Jul 2019 12:23:50 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2tfmevmgkt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 12:23:50 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x61GJOfa030988;
        Mon, 1 Jul 2019 16:23:50 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 2tdym6g3nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Jul 2019 16:23:49 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x61GNmcl61014482
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Jul 2019 16:23:48 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A1520BE051;
        Mon,  1 Jul 2019 16:23:48 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 090AABE04F;
        Mon,  1 Jul 2019 16:23:47 +0000 (GMT)
Received: from alifm-ThinkPad-T470p.pok.ibm.com (unknown [9.56.58.42])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTPS;
        Mon,  1 Jul 2019 16:23:47 +0000 (GMT)
From:   Farhan Ali <alifm@linux.ibm.com>
To:     cohuck@redhat.com, farman@linux.ibm.com, pasic@linux.ibm.com
Cc:     linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        alifm@linux.ibm.com
Subject: [RFC v1 1/4] vfio-ccw: Set orb.cmd.c64 before calling ccwchain_handle_ccw
Date:   Mon,  1 Jul 2019 12:23:43 -0400
Message-Id: <050943a6f5a427317ea64100bc2b4ec6394a4411.1561997809.git.alifm@linux.ibm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1561997809.git.alifm@linux.ibm.com>
References: <cover.1561997809.git.alifm@linux.ibm.com>
In-Reply-To: <cover.1561997809.git.alifm@linux.ibm.com>
References: <cover.1561997809.git.alifm@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=992 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010198
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Because ccwchain_handle_ccw calls ccwchain_calc_length and
as per the comment we should set orb.cmd.c64 before calling
ccwchanin_calc_length.

Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index d6a8dff..5ac4c1e 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -640,16 +640,16 @@ int cp_init(struct channel_program *cp, struct device *mdev, union orb *orb)
 	memcpy(&cp->orb, orb, sizeof(*orb));
 	cp->mdev = mdev;
 
-	/* Build a ccwchain for the first CCW segment */
-	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
-	if (ret)
-		cp_free(cp);
-
 	/* It is safe to force: if not set but idals used
 	 * ccwchain_calc_length returns an error.
 	 */
 	cp->orb.cmd.c64 = 1;
 
+	/* Build a ccwchain for the first CCW segment */
+	ret = ccwchain_handle_ccw(orb->cmd.cpa, cp);
+	if (ret)
+		cp_free(cp);
+
 	if (!ret)
 		cp->initialized = true;
 
-- 
2.7.4

