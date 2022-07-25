Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9303580249
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 17:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235658AbiGYPya (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 11:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235752AbiGYPy2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 11:54:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A995411C12
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 08:54:27 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26PFkmnD013344
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:54:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=LT2+RIvfx80kuLNJteTfvoQ7bTmESYyiZmE/eQJ2sTs=;
 b=R8qsFYQ42tjmwgMBSlXsxJB1GkQlkQnJ9htIcyXtOeASXWVAUCHaK3RPLs9dTxtLcRJD
 m9jLjFYRTLuejYAY5GFeVwgvN4qnNw2dFY//U4464A765Y8dErXeAA6uyXKSkT87nvI0
 4AasnBJ1R30MQ6kQsUpkDW5bjTPLiVepkEsY1Bp+Y1HjR7zs9lSrgGtSmo96dIMQkf7V
 rQVyw+tjfK+E49kamoxMiYOiWca8b5ZyjoXuSXr3WdFG7uIpsAfRaN+6T2zV3XqAb0b+
 KTFFy5ojXefLKeQy828qX/+xr0ljVKHSHl2mqNS1zW/c1NvHdDIFnKgZIlR5atREJLZJ UQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hhx49g7vp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:54:26 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26PFkx7m013888
        for <kvm@vger.kernel.org>; Mon, 25 Jul 2022 15:54:26 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hhx49g7uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 15:54:26 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26PFqU0P011216;
        Mon, 25 Jul 2022 15:54:24 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04ams.nl.ibm.com with ESMTP id 3hg96wjp1b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 15:54:24 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26PFsL4e17170766
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jul 2022 15:54:21 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E21E25204F;
        Mon, 25 Jul 2022 15:54:20 +0000 (GMT)
Received: from a46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id B067B52051;
        Mon, 25 Jul 2022 15:54:20 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/3] s390x: smp: move sigp calls with invalid cpu address to array
Date:   Mon, 25 Jul 2022 17:54:18 +0200
Message-Id: <20220725155420.2009109-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220725155420.2009109-1-nrb@linux.ibm.com>
References: <20220725155420.2009109-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SbjBzUOa0d-TOzpTWFGAZ_oidrOG7eq5
X-Proofpoint-GUID: fOPrRjKIL65QtLdKlqmQdZ5353eovFWc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-25_10,2022-07-25_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207250063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

