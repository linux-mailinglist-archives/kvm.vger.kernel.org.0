Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0EE5BDE5C
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 09:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbiITHhL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 03:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiITHhJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 03:37:09 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB91060519;
        Tue, 20 Sep 2022 00:37:07 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28K7VuuO003445;
        Tue, 20 Sep 2022 07:37:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Sch/KijMF+Mv4TSW1LR/yOGkNcQ3exSLSmAIozsuy7g=;
 b=I9llzA82p1py83NTqkgaxYFeYw7nnT5ht4sVfwP0obr1NFzC9pZrdq/70NgLoeSYzzfq
 4U2L9X90nonkhnKe5abIS1aOBzStCxpggfbWUSSBOvzksba4B2m3hRTPhTN9g+RVe9CS
 socObKgyLHeRaJhe0I5ejF65+AqsNhc4vz0q1kHSN36635dqK6BTc/euCKdO7ik2r39e
 Lf4Z39FggEfAxo+aCayibqepSC71O9Nx9L3E5ywZfInDB2d18SuUQSIfj9b2IfF2iXUF
 uD4rrllB0mp0aacc//1DAcjW+ComsXJjRbPGq8/IyT0efkOXH7SqOD29PL+1iPhkxjxX Ew== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq97a05kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:37:06 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28K7Wr5u010432;
        Tue, 20 Sep 2022 07:37:06 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq97a05jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:37:06 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28K7L6qX021752;
        Tue, 20 Sep 2022 07:32:03 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3jn5v93fh9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:03 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28K7S2k845482266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 07:28:02 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C95311C050;
        Tue, 20 Sep 2022 07:32:00 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 706BC11C04A;
        Tue, 20 Sep 2022 07:31:59 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 07:31:59 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 01/11] s390x: smp: move sigp calls with invalid cpu address to array
Date:   Tue, 20 Sep 2022 07:30:25 +0000
Message-Id: <20220920073035.29201-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220920073035.29201-1-frankja@linux.ibm.com>
References: <20220920073035.29201-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MUHfAlNdBbbLFjxYnO-mtJq4dKn1q7kr
X-Proofpoint-ORIG-GUID: DLzGbwGZLMptMeJGr5tKmkYfrPuQo9fw
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_02,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 adultscore=0 impostorscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209200045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

We have the nice array to test SIGP calls with invalid CPU addresses.
Move the SIGP cases there to eliminate some of the duplicated code in
test_emcall and test_cond_emcall.

Since adding coverage for invalid CPU addresses in the ecall case is now
trivial, do that as well.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220810074616.1223561-2-nrb@linux.ibm.com
Message-Id: <20220810074616.1223561-2-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/smp.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 0df4751f..34ae91c3 100644
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
@@ -329,7 +332,6 @@ static void emcall(void)
 static void test_emcall(void)
 {
 	struct psw psw;
-	int cc;
 	psw.mask = extract_psw_mask();
 	psw.addr = (unsigned long)emcall;
 
@@ -343,13 +345,6 @@ static void test_emcall(void)
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
 
@@ -368,13 +363,6 @@ static void test_cond_emcall(void)
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
2.34.1

