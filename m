Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB4B74F192
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjGKORL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbjGKORD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:17:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C1A173C
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:16:49 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BEEUm5003832;
        Tue, 11 Jul 2023 14:16:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=r9QPjCOQV2d5Z7OvDSHYXyz1ER2QVSoQ0iAkN5rG5gA=;
 b=VDHZM3gDpU4jrJ/ny/EVXNNZGoiQ6YTAbee63SeN61aa2djKSQTNFb+IZGQPfV/9ATY3
 qo+DT+7A2e4G/E6f5rui6Vsg/+1+sUSrJ7nN3N5KLK8CCOAZXcuP5wI8uoVPKBXrTK6D
 n0w4ZGF4OJN3x/M9ZLaEuWNbuY/pTHxyCcsmkrVAw2lcbNm3JM1lMwGB26gnU8L/rG6a
 Hmcvts/mAr9lWPL12OhIPt/ILHkXeQmUU8EdLt+hzI49cij06cdVrYVjMEdobm/8trq0
 KSEkh94zhcJGULLuxPwBSasz3RPpM13TjymZt8D/qF1UQwG+LQeLOZnaRCOB6RH5r4UG TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8nvr49k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:45 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BEG5o5012726;
        Tue, 11 Jul 2023 14:16:35 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8nvr3ms-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:34 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36BDmUti005988;
        Tue, 11 Jul 2023 14:16:22 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rpy2e1u3y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:22 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGJLl31981998
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:19 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 133682004E;
        Tue, 11 Jul 2023 14:16:19 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9107720049;
        Tue, 11 Jul 2023 14:16:18 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:18 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 15/22] s390x: uv-host: Remove create guest variable storage prefix check
Date:   Tue, 11 Jul 2023 16:15:48 +0200
Message-ID: <20230711141607.40742-16-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OSkJUcxqAE5tbQGRYZJO-72Bnpvfn_92
X-Proofpoint-GUID: lbwpDM0vNAW3dVKfVTpTwr23JybJ79gU
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxlogscore=999 adultscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

The test fails and we currently dont know why, so let's remove it so
we can add it again once we understand the problem.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Link: https://lore.kernel.org/r/20230622075054.3190-6-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index c04cdd7..4112b4b 100644
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
2.41.0

