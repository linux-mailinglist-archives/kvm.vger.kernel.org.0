Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA4D14BA31B
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 15:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238733AbiBQOfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 09:35:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241935AbiBQOfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 09:35:38 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BB92B1671
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 06:35:23 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21HEBAgT025383
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=AQpdSmeOKjloa5NphmrQWcqW+/4CJ+GNJ7vmctFzMec=;
 b=X+mq8lv8mgY1mbNvGvt40KcREJKgPbSUAqflxGaXjR/BjZyxyV7WvCyryrd5tN4DRAwR
 Bgu/7ucSjTzJYQ+uoPWOayY0BF09Zvfx/FDW7x6WApQQ7YohnDgBvHQED2oooor+euwr
 63lJOQNF9kiTkQjODGOgTiZz4LDN3cplYlCCsqOM/z/Jw/Kc/X0Ji4AOypin3dwMlF4u
 FWAeGI+5px+Q5RpFS4YE1260RKY4hTuMsGOosL1nODdqrvSxH1ZPnBhHPMU+MvMXz/do
 E/nRWS+BsS4n/1VFvjDgS9sO/ilkBZVwNwUH1r4+UnAVn3nVY02EoS4dteCN43ymMTmi 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9q461e9c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:22 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21HECD94031532
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 14:35:21 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3e9q461e8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:21 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21HEXpgb028138;
        Thu, 17 Feb 2022 14:35:20 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3e64hah483-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 17 Feb 2022 14:35:19 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21HEZGPE37880126
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Feb 2022 14:35:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 658404204F;
        Thu, 17 Feb 2022 14:35:16 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 00C2D4203F;
        Thu, 17 Feb 2022 14:35:16 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.2.54])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 17 Feb 2022 14:35:15 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 7/9] s390x: firq: use CPU indexes instead of addresses
Date:   Thu, 17 Feb 2022 15:35:02 +0100
Message-Id: <20220217143504.232688-8-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220217143504.232688-1-imbrenda@linux.ibm.com>
References: <20220217143504.232688-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T6CtX7BYsSjNtriZc8Y7mukU80v1FZiS
X-Proofpoint-ORIG-GUID: W29on4i72v7sdrmaTng6nl8y8iQd_Xio
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-17_05,2022-02-17_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 bulkscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0
 mlxlogscore=896 spamscore=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202170066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adapt the test to the new semantics of the smp_* functions, and use CPU
indexes instead of addresses.

replace the checks with asserts, the 3 CPUs are guaranteed to be there.

Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
---
 s390x/firq.c | 26 ++++++--------------------
 1 file changed, 6 insertions(+), 20 deletions(-)

diff --git a/s390x/firq.c b/s390x/firq.c
index fb9a2906..b4b3542e 100644
--- a/s390x/firq.c
+++ b/s390x/firq.c
@@ -44,24 +44,13 @@ static void test_wait_state_delivery(void)
 		goto out;
 	}
 
-	if (stap()) {
-		report_skip("need to start on CPU #0");
-		goto out;
-	}
-
-	/*
-	 * We want CPU #2 to be stopped. This should be the case at this
-	 * point, however, we want to sense if it even exists as well.
-	 */
+	/* Stop CPU #2. It must succeed because we have at least 3 CPUs */
 	ret = smp_cpu_stop(2);
-	if (ret) {
-		report_skip("CPU #2 not found");
-		goto out;
-	}
+	assert(!ret);
 
 	/*
-	 * We're going to perform an SCLP service call but expect
-	 * the interrupt on CPU #1 while it is in the wait state.
+	 * We're going to perform an SCLP service call but expect the
+	 * interrupt on CPU #1 while it is in the wait state.
 	 */
 	sclp_mark_busy();
 
@@ -69,11 +58,8 @@ static void test_wait_state_delivery(void)
 	psw.mask = extract_psw_mask();
 	psw.addr = (unsigned long)wait_for_sclp_int;
 	ret = smp_cpu_setup(1, psw);
-	if (ret) {
-		sclp_clear_busy();
-		report_skip("cpu #1 not found");
-		goto out;
-	}
+	/* This must not fail because we have at least 3 CPUs */
+	assert(!ret);
 
 	/*
 	 * We'd have to jump trough some hoops to sense e.g., via SIGP
-- 
2.34.1

