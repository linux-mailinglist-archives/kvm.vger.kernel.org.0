Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9A844E2424
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 11:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346255AbiCUKUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 06:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241246AbiCUKUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 06:20:36 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7396D29CB0;
        Mon, 21 Mar 2022 03:19:11 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22L9p2gb006261;
        Mon, 21 Mar 2022 10:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=rWbuFv4lGzl+y/2dTFlezS5g21Ok5kP3Q0CN9QF5nQ0=;
 b=MOeruy9XX4HW0anhznE2+d1kxLuxKyzSjxAvUSsDPnvEvc2+iGYjAlme4TRFOTSBlRTy
 JuI02S112K7ibI/b0M2onaNq6jnGVP7L6293m4lS5l1kLGwUAEbkSOVU9anxHk2MM72K
 pw6+w1RopfoQyDzqR3G9M+CNxGr3UMTB72HZelvvIInzlvJMAoMHj79dPi8MIjmOoi2u
 rTjxO4E/79itMG/KeO0E2uxaD5x8sKlh22fXc2nquR5k2GMhOTXhLeLINJ4b3pHrTwPX
 ChiFXu3s4hqIaEZrA+ckUsoo2IspHSNsgpomuEpXTICVufKJtfHyrXTjKTlFtkBKoOvh pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exkvn4p8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:10 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22L9rOdW014978;
        Mon, 21 Mar 2022 10:19:10 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3exkvn4p85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:10 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22LAE3bh016733;
        Mon, 21 Mar 2022 10:19:08 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3ew6t8ujt3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 21 Mar 2022 10:19:08 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22LA7QOo5964172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Mar 2022 10:07:26 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 696F711C04C;
        Mon, 21 Mar 2022 10:19:05 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 231F311C050;
        Mon, 21 Mar 2022 10:19:05 +0000 (GMT)
Received: from t46lp57.lnxne.boe (unknown [9.152.108.100])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 21 Mar 2022 10:19:05 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com,
        david@redhat.com, farman@linux.ibm.com
Subject: [kvm-unit-tests PATCH v1 1/9] s390x: smp: add tests for several invalid SIGP orders
Date:   Mon, 21 Mar 2022 11:18:56 +0100
Message-Id: <20220321101904.387640-2-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220321101904.387640-1-nrb@linux.ibm.com>
References: <20220321101904.387640-1-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5z0mSuGdx-FdSZ8wH7nwk-RGKnA1DB0E
X-Proofpoint-ORIG-GUID: Jl62OW2pYOhzP4_6yIdyW_xXgC0vUmb8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-21_04,2022-03-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1011
 bulkscore=0 mlxlogscore=999 phishscore=0 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 adultscore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2203210066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add tests with for intercepted SIGP orders with invalid values:

- SIGP_STOP with invalid CPU address
- SIGP_START with invalid CPU address
- SIGP_CPU_RESET with invalid CPU address
- SIGP_STOP_AND_STORE_STATUS with invalid CPU address
- SIGP_STORE_STATUS_AT_ADDRESS with invalid CPU address
- invalid order
- invalid order with invalid CPU address

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/smp.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 068ac74dd28a..911a26c51b10 100644
--- a/s390x/smp.c
+++ b/s390x/smp.c
@@ -19,6 +19,47 @@
 #include <alloc_page.h>
 
 static int testflag = 0;
+#define INVALID_CPU_ADDRESS -4711
+#define INVALID_ORDER_CODE 0xFF
+struct sigp_invalid_cases {
+	int order;
+	char message[100];
+};
+static const struct sigp_invalid_cases cases_invalid_cpu_addr[] = {
+	{ SIGP_STOP,                  "stop with invalid CPU address" },
+	{ SIGP_START,                 "start with invalid CPU address" },
+	{ SIGP_CPU_RESET,             "reset with invalid CPU address" },
+	{ INVALID_ORDER_CODE,         "invalid order code and CPU address" },
+	{ SIGP_SENSE,                 "sense with invalid CPU address" },
+	{ SIGP_STOP_AND_STORE_STATUS, "stop and store status with invalid CPU address" },
+};
+static const struct sigp_invalid_cases cases_valid_cpu_addr[] = {
+	{ INVALID_ORDER_CODE,         "invalid order code" },
+};
+
+static void test_invalid(void)
+{
+	const struct sigp_invalid_cases *c;
+	uint32_t status;
+	int cc;
+	int i;
+
+	report_prefix_push("invalid parameters");
+
+	for (i = 0; i < ARRAY_SIZE(cases_invalid_cpu_addr); i++) {
+		c = &cases_invalid_cpu_addr[i];
+		cc = sigp(INVALID_CPU_ADDRESS, c->order, 0, &status);
+		report(cc == 3, c->message);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(cases_valid_cpu_addr); i++) {
+		c = &cases_valid_cpu_addr[i];
+		cc = smp_sigp(1, c->order, 0, &status);
+		report(cc == 1, c->message);
+	}
+
+	report_prefix_pop();
+}
 
 static void wait_for_flag(void)
 {
@@ -123,10 +164,16 @@ static void test_store_status(void)
 {
 	struct cpu_status *status = alloc_pages_flags(1, AREA_DMA31);
 	uint32_t r;
+	int cc;
 
 	report_prefix_push("store status at address");
 	memset(status, 0, PAGE_SIZE * 2);
 
+	report_prefix_push("invalid CPU address");
+	cc = sigp(INVALID_CPU_ADDRESS, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, &r);
+	report(cc == 3, "returned with CC = 3");
+	report_prefix_pop();
+
 	report_prefix_push("running");
 	smp_cpu_restart(1);
 	smp_sigp(1, SIGP_STORE_STATUS_AT_ADDRESS, (uintptr_t)status, &r);
@@ -331,6 +378,7 @@ int main(void)
 	smp_cpu_stop(1);
 
 	test_start();
+	test_invalid();
 	test_restart();
 	test_stop();
 	test_stop_store_status();
-- 
2.31.1

