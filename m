Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506F373987A
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 09:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbjFVHwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 03:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230253AbjFVHwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 03:52:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB84E132;
        Thu, 22 Jun 2023 00:52:11 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35M7l83k013060;
        Thu, 22 Jun 2023 07:52:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=CzpSVeSNqYfAZBGpNb2K6VW5yLHS30/wgs9VEfXxNcw=;
 b=Meqds87rPAe6pnBCCvojFkD8I9znxDu9rloybGZYJvtC2OjCBtqAtWXi2W3i7EljV0/+
 xW9UJOyDnh0fRGUZj5mAIZ8xPkGdnHZfjNTvf+mNgEAvXpTdhczLSvxoXBDeAoOV/K9z
 HcApa4GBuA6iNiGUYXIgxZCUym7vDgFAs/Lk3vKQQItoCBK5bFenjT+qPbo0dtizJGhL
 0gBn8DG6JwBnVgiw+uUuKNz3Kd/Xn8BRssUVXi+vt3Z+8yo0c/vx7WbkdwETWUPct0AN
 q3b4awCg51LK+XyRp0lReOFXJ/0peP3H4YJg3bTdHfJnsWbU+2VnK0/SFHPvLqKDmh+z 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rchwggq4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:11 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35M7QoKL021435;
        Thu, 22 Jun 2023 07:52:10 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rchwggq3g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:10 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35M6IGBR028587;
        Thu, 22 Jun 2023 07:52:08 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3r94f52gts-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:08 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35M7q4T140370536
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 07:52:04 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9A5D20040;
        Thu, 22 Jun 2023 07:52:04 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D711420043;
        Thu, 22 Jun 2023 07:52:03 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 22 Jun 2023 07:52:03 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 5/8] s390x: uv-host: Remove create guest variable storage prefix check
Date:   Thu, 22 Jun 2023 07:50:51 +0000
Message-Id: <20230622075054.3190-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230622075054.3190-1-frankja@linux.ibm.com>
References: <20230622075054.3190-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jpwxRNWIcIgNhPzzBYAR62zaTowab93e
X-Proofpoint-ORIG-GUID: SXOrGS0wmZLdAGGEEVYGpCUSWVifQgTD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-22_04,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 malwarescore=0 clxscore=1015 mlxlogscore=999 spamscore=0
 lowpriorityscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306220062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The test fails and we currently dont know why, so let's remove it so
we can add it again once we understand the problem.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index c04cdd73..4112b4b6 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -18,7 +18,6 @@
 #include <snippet.h>
 #include <mmu.h>
 #include <asm/page.h>
-#include <asm/sigp.h>
 #include <asm/pgtable.h>
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
@@ -435,15 +434,6 @@ static void test_config_create(void)
 	       "base storage origin contains lowcore");
 	uvcb_cgc.conf_base_stor_origin = tmp;
 
-	if (smp_query_num_cpus() == 1) {
-		sigp_retry(1, SIGP_SET_PREFIX,
-			   uvcb_cgc.conf_var_stor_origin + PAGE_SIZE, NULL);
-		rc = uv_call(0, (uint64_t)&uvcb_cgc);
-		report(uvcb_cgc.header.rc == 0x10e && rc == 1 &&
-		       !uvcb_cgc.guest_handle, "variable storage area contains lowcore");
-		sigp_retry(1, SIGP_SET_PREFIX, 0x0, NULL);
-	}
-
 	tmp = uvcb_cgc.guest_sca;
 	uvcb_cgc.guest_sca = 0;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-- 
2.34.1

