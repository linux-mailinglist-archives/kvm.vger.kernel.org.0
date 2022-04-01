Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FC44EEC32
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345407AbiDALSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345495AbiDALSW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:22 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01D5181166
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:33 -0700 (PDT)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 231BG7o8005658
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=hmu+uZPEFlyEZgS+R2kC74MBT07MScaH69CYmFbypYc=;
 b=erA1m+a2oIP8W9lvQmsPqlPJONzU5HqXbIngr4nAiaXZVfqgKbvJ9tCH0JPv3Xmvv/Nn
 IGixJt8pI42uLwMNguhTDSAw5OFP3QfwGGG15OQfqneS03ptJrWOkm4ALkOY7sdiFI3s
 4x2aeNPSCos9HMn0p5XPptk+D4BKxTbW4MiH0RdnS+N5M97/UM2toAbk2ZSumKj1L8LN
 5Uz6S0oqz9q7OjVYBpmZmsTaQBrJKPYjG1amWQraGTjeH/+B+uPA5c7l7TgXasay2o30
 wjceDibcwgiitoSmCggoVMXJBcdeASgxY4nrSXUIRz7iHpF2I2oSTD7qhl4yJKv7J2Sa +A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5wpv3k53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:32 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231BEubL013527
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:32 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5wpv3k4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:32 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B7ene012923;
        Fri, 1 Apr 2022 11:16:30 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3f1tf9mv0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGQGp14811578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 571F84C05C;
        Fri,  1 Apr 2022 11:16:26 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 083874C06E;
        Fri,  1 Apr 2022 11:16:26 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:25 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Eric Farman <farman@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 02/27] s390x: smp: Test SIGP RESTART against stopped CPU
Date:   Fri,  1 Apr 2022 13:15:55 +0200
Message-Id: <20220401111620.366435-3-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dDNRKvefsDgM_aa4iMrMH3eq4CEROiXO
X-Proofpoint-GUID: pMOM7Kwgiugm6W2BbsvkcbcEJJq6_GSs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_03,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

test_restart() makes two smp_cpu_restart() calls against CPU 1.
It claims to perform both of them against running (operating) CPUs,
but the first invocation tries to achieve this by calling
smp_cpu_stop() to CPU 0. This will be rejected by the library.

Let's fix this by making the first restart operate on a stopped CPU,
to ensure it gets test coverage instead of relying on other callers.

Fixes: 166da884d ("s390x: smp: Add restart when running test")
Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/smp.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 068ac74d..2f4af820 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -50,10 +50,6 @@ static void test_start(void)
 	report_pass("start");
 }
 
-/*
- * Does only test restart when the target is running.
- * The other tests do restarts when stopped multiple times already.
- */
 static void test_restart(void)
 {
 	struct cpu *cpu = smp_cpu_from_idx(1);
@@ -62,8 +58,8 @@ static void test_restart(void)
 	lc->restart_new_psw.mask = extract_psw_mask();
 	lc->restart_new_psw.addr = (unsigned long)test_func;
 
-	/* Make sure cpu is running */
-	smp_cpu_stop(0);
+	/* Make sure cpu is stopped */
+	smp_cpu_stop(1);
 	set_flag(0);
 	smp_cpu_restart(1);
 	wait_for_flag();
-- 
2.34.1

