Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB14E4E2431
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 11:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346281AbiCUKUs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 06:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346259AbiCUKUi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 06:20:38 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE142A240;
        Mon, 21 Mar 2022 03:19:13 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L9LhVL016181;
        Mon, 21 Mar 2022 10:19:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1y+iVhxfboa/6GiahI0C6GZ/jZeoElApDbL4Z8vlqaI=;
 b=lyp6T2jnrqZnGlwCHJ7pNAhVtJvScD6oNq1+J/Y2WmdVyNUBC8j/gPlXJiicQ1Ah9w4P
 huPUEeO1KUDGQENoX+PcBppWDGmR6+DK5asbeUF5EQ4bGZF5Dr75sJ/krOlCsZz8+gUX
 FXNKIZVLpEqvLK38WGGGvu0OVJFUrciXNi8gQVL9OH+wtmCiOTGnEwciyibTLY5y4DrA
 TTT8i1SIabuPgv8Bg8dJMfEYJsBF4pxx4oHww9Mbm8K4znecy3c6Gw3W99+fbKLtUE6/
 rBSfhCSMZdJQZKT32K+AM3we1+EEhesqdYaWLwj6tIVMMJMrOw6fu4tdNHtnt3DQSjtm iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exkk3w1wc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:12 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22LAIWue027914;
        Mon, 21 Mar 2022 10:19:12 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exkk3w1vr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:12 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LAEb0O029756;
        Mon, 21 Mar 2022 10:19:10 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3ew6t8uju4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:10 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LAJ66d15466948
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 10:19:06 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8DBA11C04A;
        Mon, 21 Mar 2022 10:19:06 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83B6F11C04C;
        Mon, 21 Mar 2022 10:19:06 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 10:19:06 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 5/9] s390x: smp: add tests for SET_PREFIX
Date:   Mon, 21 Mar 2022 11:19:00 +0100
Message-Id: <20220321101904.387640-6-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220321101904.387640-1-nrb@linux.ibm.com>
References: <20220321101904.387640-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: luZzkLrqSev72xYLRGvX5kbqNicmYky0
X-Proofpoint-ORIG-GUID: HNhAEBmNnwHCxvbjyZRwpIQZIexp6tmt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_04,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 malwarescore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 clxscore=1015 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We cover the following cases:

- running CPU
- illegal CPU id

The order should be rejected in both cases.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/smp.c | 73 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 5d3265f6be64..f22520b4f4fc 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -51,6 +51,8 @@ static uint8_t expected_vec_contents[NUM_VEC_REGISTERS][VEC_REGISTER_SIZE];
 static struct gs_cb gs_cb;
 static struct gs_epl gs_epl;
 
+static uint32_t cpu1_prefix;
+
 static void test_invalid(void)
 {
 	const struct sigp_invalid_cases *c;
@@ -455,6 +457,76 @@ out:
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
@@ -647,6 +719,7 @@ int main(void)
 	test_store_adtl_status_vector();
 	test_store_adtl_status_gs();
 	test_store_adtl_status();
+	test_set_prefix();
 	test_ecall();
 	test_emcall();
 	test_sense_running();
-- 
2.31.1

