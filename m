Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9AA573591
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 13:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbiGMLgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 07:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236113AbiGMLgb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 07:36:31 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88E510272D;
        Wed, 13 Jul 2022 04:36:29 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26DBKKcc000916;
        Wed, 13 Jul 2022 11:36:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=GsYU7xPhxK2zeHUYHUsm0zZfWg0qVEUm7gu94dYpr14=;
 b=F768rz7obKO3df2w2Py8x9sl36O+CnhA5lIIp0AKNhzW4xKj9aYNrzc/smkaCnzxgl4j
 u6VYYROpcWtC5XptXm3MjIyiDK+rEcyxm9kxxS/C9GSBax/jOz1phnmkr0nOnKJDpC6y
 Gqq0m72K8DzQ15VXNfaE3qQrHY6EALKs57tSZgWRcYS3LC+j8W+xrB4Dkxkr4iDEnEjx
 R6yBkughmzhuesXGv2aM0+7sgDBSyOcPB5iV/hlGEM+/+w9BzXZOb2paZQBKCcOoWDWs
 ffPsOtanVuhAtDKFMoze2XJ8k8IpgCZoS7jfMoKtc9LE/tE2YLVB7HL1R8kOESaPIMg+ 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9w3c0b55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:28 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26DBMAgj005192;
        Wed, 13 Jul 2022 11:36:28 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h9w3c0b3m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:28 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26DBaA7E013316;
        Wed, 13 Jul 2022 11:36:26 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3h70xhwkpg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 13 Jul 2022 11:36:26 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26DBaYki32964910
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jul 2022 11:36:34 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67DC611C04C;
        Wed, 13 Jul 2022 11:36:23 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3053411C058;
        Wed, 13 Jul 2022 11:36:23 +0000 (GMT)
Received: from t35lp63.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 13 Jul 2022 11:36:23 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v1 4/4] s390x: smp: add tests for calls in wait state
Date:   Wed, 13 Jul 2022 13:36:21 +0200
Message-Id: <20220713113621.14778-5-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220713113621.14778-1-nrb@linux.ibm.com>
References: <20220713113621.14778-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: g1988xRmYy-dbZs57NjusmSqdxawIJBa
X-Proofpoint-ORIG-GUID: FVTkjBolpBMZypB6sTE_tJVZjXlHHvz_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-12_14,2022-07-13_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 adultscore=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2206140000 definitions=main-2207130047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Under PV, SIGP ecall requires some special handling by the hypervisor
when the receiving CPU is in enabled wait. Hence, we should have
coverage for the various SIGP call orders when the receiving CPU is in
enabled wait.

The ecall test currently fails under PV due to a KVM bug under
investigation.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/smp.c | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 74 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 857eae206daa..2b48f83d2b6d 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -350,6 +350,79 @@ static void test_calls(void)
 	}
 }
 
+static void call_in_wait_setup(void)
+{
+	expect_ext_int();
+	ctl_set_bit(0, current_sigp_call_case->cr0_bit);
+	set_flag(1);
+}
+
+static void call_in_wait_received(void)
+{
+	report(lowcore.ext_int_code == current_sigp_call_case->ext_int_expected_type, "received");
+	set_flag(1);
+}
+
+static void call_in_wait_ext_int_fixup(struct stack_frame_int *stack)
+{
+	/* leave wait after returning */
+	lowcore.ext_old_psw.mask &= ~PSW_MASK_WAIT;
+
+	stack->crs[0] &= ~current_sigp_call_case->cr0_bit;
+}
+
+static void test_calls_in_wait(void)
+{
+	int i;
+	struct psw psw;
+
+	report_prefix_push("psw wait");
+	for (i = 0; i < ARRAY_SIZE(cases_sigp_call); i++) {
+		current_sigp_call_case = &cases_sigp_call[i];
+
+		report_prefix_push(current_sigp_call_case->name);
+		if (!current_sigp_call_case->supports_pv && uv_os_is_guest()) {
+			report_skip("Not supported under PV");
+			report_prefix_pop();
+			continue;
+		}
+
+		set_flag(0);
+		psw.mask = extract_psw_mask();
+		psw.addr = (unsigned long)call_in_wait_setup;
+		smp_cpu_start(1, psw);
+		wait_for_flag();
+		set_flag(0);
+
+		register_ext_cleanup_func(call_in_wait_ext_int_fixup);
+
+		/*
+		 * To avoid races, we need to know that the secondary CPU has entered wait,
+		 * but the architecture provides no way to check whether the secondary CPU
+		 * is in wait.
+		 *
+		 * But since a waiting CPU is considered operating, simply stop the CPU, set
+		 * up the restart new PSW mask in wait, send the restart interrupt and then
+		 * wait until the CPU becomes operating (done by smp_cpu_start).
+		 */
+		smp_cpu_stop(1);
+		expect_ext_int();
+		psw.mask = extract_psw_mask() | PSW_MASK_EXT | PSW_MASK_WAIT;
+		psw.addr = (unsigned long)call_in_wait_received;
+		smp_cpu_start(1, psw);
+
+		smp_sigp(1, current_sigp_call_case->call, 0, NULL);
+
+		wait_for_flag();
+		smp_cpu_stop(1);
+
+		register_ext_cleanup_func(NULL);
+
+		report_prefix_pop();
+	}
+	report_prefix_pop();
+}
+
 static void test_sense_running(void)
 {
 	report_prefix_push("sense_running");
@@ -472,6 +545,7 @@ int main(void)
 	test_store_status();
 	test_set_prefix();
 	test_calls();
+	test_calls_in_wait();
 	test_sense_running();
 	test_reset();
 	test_reset_initial();
-- 
2.35.3

