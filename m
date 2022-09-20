Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5A975BDE36
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 09:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiITHcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 03:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiITHcK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 03:32:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD52E5C9E0;
        Tue, 20 Sep 2022 00:32:08 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28K7C0KD030929;
        Tue, 20 Sep 2022 07:32:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=tzdweaAPtwJgvpfcfcPDznzC421wM64SrkE4H9SPoDs=;
 b=GtK5PHwR/vy2DLp5qwDGMQKtWlmbBu6AW2+bHbBhMHglCkipAjmGIOCBkc3WAi0dDehP
 J1l25znWYimmB6kfXZY42YKfcwhy6Wuyv26/0RTTqkJRmZMV1X1HQhS9mku8TN3MYK8c
 0xTgfx8CAZ22ikpm1Sy/8GxmxtMU++rc22guHxlALTE2pwKyECWSmaZ020UUYHDe3bMz
 rKGXLggwpxKqUpDuMDi/UAkHycaiN7RwqOOnCqEm8qjmGkw70vr/uEWkFwC2plpGjohd
 YlnIXsVZhMBPap4g22+n3/Q4MGLqQvLMLunypyyTx9Cx+PzAR8/UHnGQpKmkMhtZLYXL rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq8wu0jky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:08 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 28K7CMgq031759;
        Tue, 20 Sep 2022 07:32:07 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3jq8wu0jjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:07 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 28K7LZMn025971;
        Tue, 20 Sep 2022 07:32:05 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3jn5ghjjyy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 20 Sep 2022 07:32:04 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 28K7W1en44564812
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Sep 2022 07:32:01 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8FA3A11C050;
        Tue, 20 Sep 2022 07:32:01 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 92DF511C04A;
        Tue, 20 Sep 2022 07:32:00 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 20 Sep 2022 07:32:00 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        borntraeger@de.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 02/11] s390x: smp: use an array for sigp calls
Date:   Tue, 20 Sep 2022 07:30:26 +0000
Message-Id: <20220920073035.29201-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220920073035.29201-1-frankja@linux.ibm.com>
References: <20220920073035.29201-1-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aPtVnc_ug-zbPyv5St80T7aXfJXPnwQ7
X-Proofpoint-ORIG-GUID: IwtZE9V4D_3rGPmtH8Ejo-IV-Eu2tPkf
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-20_02,2022-09-16_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2209200045
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

Tests for the SIGP calls are quite similar, so we have a lot of code
duplication right now. Since upcoming changes will add more cases,
refactor the code to iterate over an array, similarily as we already do
for test_invalid().

The receiving CPU is disabled for IO interrupts. This makes sure the
conditional emergency signal is accepted and doesn't hurt the other
orders.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Link: https://lore.kernel.org/r/20220810074616.1223561-3-nrb@linux.ibm.com
Message-Id: <20220810074616.1223561-3-nrb@linux.ibm.com>
Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/smp.c | 128 ++++++++++++++++++++--------------------------------
 1 file changed, 50 insertions(+), 78 deletions(-)

diff --git a/s390x/smp.c b/s390x/smp.c
index 34ae91c3..5a269087 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -43,6 +43,20 @@ static const struct sigp_invalid_cases cases_valid_cpu_addr[] = {
 
 static uint32_t cpu1_prefix;
 
+struct sigp_call_cases {
+	char name[20];
+	int call;
+	uint16_t ext_int_expected_type;
+	unsigned int cr0_bit;
+	bool supports_pv;
+};
+static const struct sigp_call_cases cases_sigp_call[] = {
+	{ "emcall",      SIGP_EMERGENCY_SIGNAL,      0x1201, CTL0_EMERGENCY_SIGNAL, true },
+	{ "cond emcall", SIGP_COND_EMERGENCY_SIGNAL, 0x1201, CTL0_EMERGENCY_SIGNAL, false },
+	{ "ecall",       SIGP_EXTERNAL_CALL,         0x1202, CTL0_EXTERNAL_CALL,    true },
+};
+static const struct sigp_call_cases *current_sigp_call_case;
+
 static void test_invalid(void)
 {
 	const struct sigp_invalid_cases *c;
@@ -289,97 +303,57 @@ static void test_set_prefix(void)
 
 }
 
-static void ecall(void)
+static void call_received(void)
 {
 	expect_ext_int();
-	ctl_set_bit(0, CTL0_EXTERNAL_CALL);
-	psw_mask_set_bits(PSW_MASK_EXT);
+	ctl_set_bit(0, current_sigp_call_case->cr0_bit);
+	/* make sure conditional emergency is accepted by disabling IO interrupts */
+	psw_mask_clear_and_set_bits(PSW_MASK_IO, PSW_MASK_EXT);
+
+	/* Indicate that we're ready to receive the call */
 	set_flag(1);
-	while (lowcore.ext_int_code != 0x1202) { mb(); }
+
+	while (lowcore.ext_int_code != current_sigp_call_case->ext_int_expected_type)
+		mb();
 	report_pass("received");
+
+	ctl_clear_bit(0, current_sigp_call_case->cr0_bit);
+
+	/* Indicate that we're done */
 	set_flag(1);
 }
 
-static void test_ecall(void)
+static void test_calls(void)
 {
+	int i;
 	struct psw psw;
-	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)ecall;
 
-	report_prefix_push("ecall");
-	set_flag(0);
+	for (i = 0; i < ARRAY_SIZE(cases_sigp_call); i++) {
+		current_sigp_call_case = &cases_sigp_call[i];
 
-	smp_cpu_start(1, psw);
-	wait_for_flag();
-	set_flag(0);
-	smp_sigp(1, SIGP_EXTERNAL_CALL, 0, NULL);
-	wait_for_flag();
-	smp_cpu_stop(1);
-	report_prefix_pop();
-}
+		report_prefix_push(current_sigp_call_case->name);
+		if (!current_sigp_call_case->supports_pv && uv_os_is_guest()) {
+			report_skip("Not supported under PV");
+			report_prefix_pop();
+			continue;
+		}
 
-static void emcall(void)
-{
-	expect_ext_int();
-	ctl_set_bit(0, CTL0_EMERGENCY_SIGNAL);
-	psw_mask_set_bits(PSW_MASK_EXT);
-	set_flag(1);
-	while (lowcore.ext_int_code != 0x1201) { mb(); }
-	report_pass("received");
-	set_flag(1);
-}
+		set_flag(0);
+		psw.mask = extract_psw_mask();
+		psw.addr = (unsigned long)call_received;
+		smp_cpu_start(1, psw);
 
-static void test_emcall(void)
-{
-	struct psw psw;
-	psw.mask = extract_psw_mask();
-	psw.addr = (unsigned long)emcall;
+		/* Wait until the receiver has finished setup */
+		wait_for_flag();
+		set_flag(0);
 
-	report_prefix_push("emcall");
-	set_flag(0);
+		smp_sigp(1, current_sigp_call_case->call, 0, NULL);
 
-	smp_cpu_start(1, psw);
-	wait_for_flag();
-	set_flag(0);
-	smp_sigp(1, SIGP_EMERGENCY_SIGNAL, 0, NULL);
-	wait_for_flag();
-	smp_cpu_stop(1);
-
-	report_prefix_pop();
-}
-
-static void test_cond_emcall(void)
-{
-	uint32_t status = 0;
-	struct psw psw;
-	int cc;
-	psw.mask = extract_psw_mask() & ~PSW_MASK_IO;
-	psw.addr = (unsigned long)emcall;
-
-	report_prefix_push("conditional emergency call");
-
-	if (uv_os_is_guest()) {
-		report_skip("unsupported under PV");
-		goto out;
+		/* Wait until the receiver has handled the call */
+		wait_for_flag();
+		smp_cpu_stop(1);
+		report_prefix_pop();
 	}
-
-	report_prefix_push("success");
-	set_flag(0);
-
-	smp_cpu_start(1, psw);
-	wait_for_flag();
-	set_flag(0);
-	cc = smp_sigp(1, SIGP_COND_EMERGENCY_SIGNAL, 0, &status);
-	report(!cc, "CC = 0");
-
-	wait_for_flag();
-	smp_cpu_stop(1);
-
-	report_prefix_pop();
-
-out:
-	report_prefix_pop();
-
 }
 
 static void test_sense_running(void)
@@ -499,9 +473,7 @@ int main(void)
 	test_stop_store_status();
 	test_store_status();
 	test_set_prefix();
-	test_ecall();
-	test_emcall();
-	test_cond_emcall();
+	test_calls();
 	test_sense_running();
 	test_reset();
 	test_reset_initial();
-- 
2.34.1

