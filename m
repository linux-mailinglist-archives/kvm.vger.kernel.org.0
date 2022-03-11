Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491104D67BC
	for <lists+kvm@lfdr.de>; Fri, 11 Mar 2022 18:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350789AbiCKRjn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Mar 2022 12:39:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349860AbiCKRjj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Mar 2022 12:39:39 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7B01AEECF;
        Fri, 11 Mar 2022 09:38:32 -0800 (PST)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22BFwK2a008309;
        Fri, 11 Mar 2022 17:38:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=gMEYcLt/7ibKvH+e2bmgpFuu4tLg8omNahZKh8RUYgI=;
 b=h6Nl8oahdE4h8829nhceDm6R4Ba3pldnQzz304fuyyWGjCRCaFpraR2NE4N5Q6tTDbIe
 P8GNJ1Y3GJeWDPqY7ZwJtHuoOEhlLnSbnphTgjAjYM5Gt8/wJUsRCfD/rdUEipJpi2nE
 rYeT7PVUCHSOZCpXsdh/9EuRm62KWINI4ZY/o2z0GFkLjNq42JTKXfJTTtpCn26DrFbE
 jyP8TEFxb/VepnOqDnBIIf8ZOEACGraoq8e3jfIF0PVwdx4uFDC6B2uiWiWyRxdowUMB
 dJHnR9WVv8+dBWfeNXx7c5iB80Rjh/lwYZB12z7LLQ1BY4EHraMtVjHPO6jiswHD0sy0 Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eqg9ehew4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:31 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22BHL4E0022135;
        Fri, 11 Mar 2022 17:38:31 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3eqg9eheva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:31 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22BHXqA1017869;
        Fri, 11 Mar 2022 17:38:29 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3enqgnt682-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Mar 2022 17:38:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22BHcQtS44499408
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Mar 2022 17:38:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 290C042047;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 170AB42042;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 11 Mar 2022 17:38:26 +0000 (GMT)
Received: by tuxmaker.boeblingen.de.ibm.com (Postfix, from userid 4958)
        id C5E22E128E; Fri, 11 Mar 2022 18:38:25 +0100 (CET)
From:   Eric Farman <farman@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Eric Farman <farman@linux.ibm.com>
Subject: [PATCH kvm-unit-tests v2 2/6] s390x: smp: Test SIGP RESTART against stopped CPU
Date:   Fri, 11 Mar 2022 18:38:18 +0100
Message-Id: <20220311173822.1234617-3-farman@linux.ibm.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220311173822.1234617-1-farman@linux.ibm.com>
References: <20220311173822.1234617-1-farman@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0EcIqtFPPfmgPy7IrwyShs2fOsCWzqnc
X-Proofpoint-ORIG-GUID: Iw69xi-F0iAhJO-BuBH7vPrwBTH1UdsU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-11_07,2022-03-11_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 clxscore=1015 adultscore=0 spamscore=0
 impostorscore=0 bulkscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203110086
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
2.32.0

