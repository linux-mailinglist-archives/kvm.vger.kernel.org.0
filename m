Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A523758E806
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 09:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiHJHqb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 03:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbiHJHqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 03:46:25 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC96642DB
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 00:46:24 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A6bddq030347
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:46:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LT2+RIvfx80kuLNJteTfvoQ7bTmESYyiZmE/eQJ2sTs=;
 b=tcORb2+04HD7ilLQkw05WNG/CMvv6DRPmzPW3CnEx4PKxkclfl9Q2zSou/6+0fOGvZf4
 ME3za1Xs0uCS6WY+PwPC0sWdW7OkMqOWc00hZmGWa9exjxyRPtGlX0Ep/6jtNqwOfSzx
 9YrnTsJIn8BFSBUDAjAH1LY1i8uuCBRwU8TqSP+UwmzVBX43wE3v/pKsiYmZM2Ipaj7g
 OfxbA+joTh8KIGDwqEJl+VmweD2eFvGfH0MB00ESXgHFzsa2HpilYF81Ktlbe6rZ2LCe
 RJGkRJ5U9Z1b+Uii4fnk/9gXWBeRrkXASMv0tQFmqWDl3Ws32z3DxybpOS8bDJSmLgeN sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv4526tx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:46:23 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27A7jOmV008361
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 07:46:22 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv4526tw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 07:46:22 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27A7NGZf032461;
        Wed, 10 Aug 2022 07:46:20 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06ams.nl.ibm.com with ESMTP id 3huwvf0hk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 07:46:20 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27A7kHVP22086096
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 07:46:17 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A45F34C046;
        Wed, 10 Aug 2022 07:46:17 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 663D34C050;
        Wed, 10 Aug 2022 07:46:17 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 07:46:17 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4 1/3] s390x: smp: move sigp calls with invalid cpu address to array
Date:   Wed, 10 Aug 2022 09:46:14 +0200
Message-Id: <20220810074616.1223561-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220810074616.1223561-1-nrb@linux.ibm.com>
References: <20220810074616.1223561-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Wo4toSuGueF2nwDcXVHa7homc6D3Mucf
X-Proofpoint-GUID: HDLODPd6utCBPppbXCisCWkidDDT5Ygp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_03,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 impostorscore=0 mlxlogscore=999 clxscore=1015 adultscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 spamscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100021
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
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/smp.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 0df4751f9cee..34ae91c3fe12 100644
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
2.36.1

