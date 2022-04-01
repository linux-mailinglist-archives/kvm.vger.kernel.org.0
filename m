Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3AF4EEC35
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345414AbiDALSw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345391AbiDALS2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15CCA1868AB
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:40 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2319j1Lh007322
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=2S4EMHm0Ca/wGsV6iNJC8p07QeUCfY0kKxIeZFhKOOU=;
 b=aSStLGQvm3Xs6M2XbO3wGm4VuKaSIBo3Sx+CUOj3tN8mNKOnsL8wBM65LSuKSJu/HFRB
 RyYLyrprYT7NBkAdyMdPmheIO2k6+ysPSUO1d/b302I62rA3tDz4UwxtYOCy962EpOAa
 ZrYRPQ5Fzz1Lw+Yh32r3QniCXDvbovBd+0K8BBMjgEK7HYED4jSoUCDuHkkNMi864gsP
 s/Ofbjfey9P5hyo36FTh33+qI1navK4erpQS0aTXM6oSQXxHNxFfITQ6ddcFBIuc48Zd
 O08mgl25ogaw2eYrAw1AlRswUsoUZXvJCuKVEHVvTImeyK8sCea3dAIBdBXGNrcDxqAf PA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5y1j9tw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:39 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231ArW8E000304
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:39 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f5y1j9tv0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:39 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B7R3T020794;
        Fri, 1 Apr 2022 11:16:36 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3f1tf92wqn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:36 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231BGXr231260950
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:16:33 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F1A54C05E;
        Fri,  1 Apr 2022 11:16:33 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C25344C040;
        Fri,  1 Apr 2022 11:16:32 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:32 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 17/27] s390x: smp: add tests for SET_PREFIX
Date:   Fri,  1 Apr 2022 13:16:10 +0200
Message-Id: <20220401111620.366435-18-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: MEGUwIUMft0RXaZ9cGXVlLIUzuFPk_Ch
X-Proofpoint-GUID: v7H3ujSZEQ1TkwaWOxmBFZACOXVIwRFW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_04,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 clxscore=1015 adultscore=0 phishscore=0 priorityscore=1501 impostorscore=0
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

We cover the following cases:

- running CPU
- illegal CPU id

The order should be rejected in both cases.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/smp.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index fcced84f..2015f82c 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -37,6 +37,8 @@ static const struct sigp_invalid_cases cases_valid_cpu_addr[] = {
 	{ INVALID_ORDER_CODE,         "invalid order code" },
 };
 
+static uint32_t cpu1_prefix;
+
 static void test_invalid(void)
 {
 	const struct sigp_invalid_cases *c;
@@ -213,6 +215,76 @@ static void test_store_status(void)
 	report_prefix_pop();
 }
 
+static void loop(void)
+{
+	while (1)
+		;
+}
+
+static void stpx_and_set_flag(void)
+{
+	asm volatile (
+		"	stpx %[prefix]\n"
+		: [prefix] "=Q" (cpu1_prefix)
+		:
+		:
+	);
+
+	set_flag(1);
+}
+
+static void test_set_prefix(void)
+{
+	struct lowcore *new_lc = alloc_pages_flags(1, AREA_DMA31);
+	struct cpu *cpu1 = smp_cpu_from_idx(1);
+	uint32_t status = 0;
+	struct psw new_psw;
+	int cc;
+
+	report_prefix_push("set prefix");
+
+	assert(new_lc);
+
+	memcpy(new_lc, cpu1->lowcore, sizeof(struct lowcore));
+	new_lc->restart_new_psw.addr = (unsigned long)loop;
+
+	report_prefix_push("running");
+	set_flag(0);
+	new_psw.addr = (unsigned long)stpx_and_set_flag;
+	new_psw.mask = extract_psw_mask();
+	smp_cpu_start(1, new_psw);
+	wait_for_flag();
+	cpu1_prefix = 0xFFFFFFFF;
+
+	cc = smp_sigp(1, SIGP_SET_PREFIX, (unsigned long)new_lc, &status);
+	report(cc == 1, "CC = 1");
+	report(status == SIGP_STATUS_INCORRECT_STATE, "status = INCORRECT_STATE");
+
+	/*
+	 * If the prefix of the other CPU was changed it will enter an endless
+	 * loop. Otherwise, it should eventually set the flag.
+	 */
+	smp_cpu_stop(1);
+	set_flag(0);
+	smp_cpu_restart(1);
+	wait_for_flag();
+	report(cpu1_prefix == (uint64_t)cpu1->lowcore, "prefix unchanged");
+
+	report_prefix_pop();
+
+	report_prefix_push("invalid CPU address");
+
+	cc = sigp(INVALID_CPU_ADDRESS, SIGP_SET_PREFIX, (unsigned long)new_lc, &status);
+	report(cc == 3, "CC = 3");
+
+	report_prefix_pop();
+
+	free_pages(new_lc);
+
+	report_prefix_pop();
+
+}
+
 static void ecall(void)
 {
 	unsigned long mask;
@@ -401,6 +473,7 @@ int main(void)
 	test_stop();
 	test_stop_store_status();
 	test_store_status();
+	test_set_prefix();
 	test_ecall();
 	test_emcall();
 	test_sense_running();
-- 
2.34.1

