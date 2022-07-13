Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D1E573592
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 13:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236193AbiGMLge (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 07:36:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236120AbiGMLgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 07:36:31 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E64B1020BC;
        Wed, 13 Jul 2022 04:36:29 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DBL2jK023099;
        Wed, 13 Jul 2022 11:36:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+RfADs1rGHcuraQl9V4+h6l3S1fxveOM4tk7lNVwkcs=;
 b=ZZIxR1s63h9hG6LGevkCrhmqhjjq6A63f55RSzC2GPyqmBqGxGRpKYqTxi4/xyo/bUHI
 A+Efo/rkHEA+jovez/YujloN35Zd854+oOEk9KInbhYLBJre+rnbhz1e9/uHcqO75f43
 +uNfZLio0dEHSQzfcaUljLL00wMcPGX7NUG6tx28P1Yg9KagpJKZdF0uFa0HRS83nVSN
 mFJjCqporFn/VPxe17zlh7empMCFcjJqVl+L/WlP7ud7mNK92pp1RKjvnOYoMa9A3YVn
 ML2nm4zQw1pOM2D/Q0DpYHJckFWfUQ7C2DYOnnEnzbcaxu1+ZEZpU8sZPG364yUYmQ/g pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9w3q8aba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:28 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26DBMvlo027285;
        Wed, 13 Jul 2022 11:36:27 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9w3q8aa5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:27 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26DBaA7D013316;
        Wed, 13 Jul 2022 11:36:26 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3h70xhwkpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:25 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26DBaMht19726748
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 11:36:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6BCB11C04A;
        Wed, 13 Jul 2022 11:36:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FE2711C04C;
        Wed, 13 Jul 2022 11:36:22 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 11:36:22 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 2/4] s390x: smp: move sigp calls with invalid cpu address to array
Date:   Wed, 13 Jul 2022 13:36:19 +0200
Message-Id: <20220713113621.14778-3-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220713113621.14778-1-nrb@linux.ibm.com>
References: <20220713113621.14778-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ngh41nVuVWKbelR6izGBdlyXj1VBugsZ
X-Proofpoint-GUID: nF2OIH7C_4BsclLD0EUbZutb5yl4p_79
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 suspectscore=0 clxscore=1015 phishscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207130047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have the nice array to test SIGP calls with invalid CPU addresses.
Move the SIGP cases there to eliminate some of the duplicated code in
test_emcall and test_cond_emcall.

Since adding coverage for invalid CPU addresses in the ecall case is now
trivial, do that as well.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/smp.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 6d474d0d4f99..ea811087587e 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -30,6 +30,9 @@ static const struct sigp_invalid_cases cases_invalid_cpu_addr[] = {
 	{ SIGP_STOP,                  "stop with invalid CPU address" },
 	{ SIGP_START,                 "start with invalid CPU address" },
 	{ SIGP_CPU_RESET,             "reset with invalid CPU address" },
+	{ SIGP_COND_EMERGENCY_SIGNAL, "conditional emcall with invalid CPU address" },
+	{ SIGP_EMERGENCY_SIGNAL,      "emcall with invalid CPU address" },
+	{ SIGP_EXTERNAL_CALL,         "ecall with invalid CPU address" },
 	{ INVALID_ORDER_CODE,         "invalid order code and CPU address" },
 	{ SIGP_SENSE,                 "sense with invalid CPU address" },
 	{ SIGP_STOP_AND_STORE_STATUS, "stop and store status with invalid CPU address" },
@@ -337,7 +340,6 @@ static void emcall(void)
 static void test_emcall(void)
 {
 	struct psw psw;
-	int cc;
 	psw.mask = extract_psw_mask();
 	psw.addr = (unsigned long)emcall;
 
@@ -351,13 +353,6 @@ static void test_emcall(void)
 	wait_for_flag();
 	smp_cpu_stop(1);
 
-	report_prefix_push("invalid CPU address");
-
-	cc = sigp(INVALID_CPU_ADDRESS, SIGP_EMERGENCY_SIGNAL, 0, NULL);
-	report(cc == 3, "CC = 3");
-
-	report_prefix_pop();
-
 	report_prefix_pop();
 }
 
@@ -376,13 +371,6 @@ static void test_cond_emcall(void)
 		goto out;
 	}
 
-	report_prefix_push("invalid CPU address");
-
-	cc = sigp(INVALID_CPU_ADDRESS, SIGP_COND_EMERGENCY_SIGNAL, 0, NULL);
-	report(cc == 3, "CC = 3");
-
-	report_prefix_pop();
-
 	report_prefix_push("success");
 	set_flag(0);
 
-- 
2.35.3

