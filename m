Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D88E4EEC27
	for <lists+kvm@lfdr.de>; Fri,  1 Apr 2022 13:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345488AbiDALSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Apr 2022 07:18:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345420AbiDALS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Apr 2022 07:18:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A40E18595D
        for <kvm@vger.kernel.org>; Fri,  1 Apr 2022 04:16:38 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2319CrWp016949
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vEmLwCfDLQMgmvKMBGOXVM2Y4mOCOtB/BNGHhOz6PCc=;
 b=XH0RdxUl+DR7YcZfO7eI4Pgl0fn8Pat8vgaggQqpX2urCsv23u+1cBItp0JqlHWqJODd
 EOMYaZ85vwzxiDMlwyBB6RLTkDA6cZSKAywJL8gIqLG61d9DWqh2H9JFXG2Ud2fkoiHA
 8xAwRxK708wVZwEGAx7LF6ITm2lFKqqXNLF4GijhGL4gi7A75oNB5DIKcFKIf+G2UMyq
 nl3n0cM+F1sjYcmyWtLHwEwIgNsIrpsvC0a1tiw6CLaQH44WDdpBYNDlFDX7Q8NOx/sH
 fzr66ck/RAmJsA/ylv9DroLhpppKPqrhigxHjogco/sDCrtu9XWJskHaMf674UrUBbVy NQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f5xjete9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Apr 2022 11:16:37 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 231AvW0a000409
        for <kvm@vger.kernel.org>; Fri, 1 Apr 2022 11:16:37 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f5xjete9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:37 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 231B83lB012942;
        Fri, 1 Apr 2022 11:16:35 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3f1tf9mv0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 01 Apr 2022 11:16:35 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 231B4SY449217924
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Apr 2022 11:04:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3801C4C06D;
        Fri,  1 Apr 2022 11:16:32 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E2D1F4C05A;
        Fri,  1 Apr 2022 11:16:31 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.3.73])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Apr 2022 11:16:31 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        thuth@redhat.com, Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 15/27] s390x: smp: add tests for several invalid SIGP orders
Date:   Fri,  1 Apr 2022 13:16:08 +0200
Message-Id: <20220401111620.366435-16-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401111620.366435-1-imbrenda@linux.ibm.com>
References: <20220401111620.366435-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gGPW-LLHnjmEPPqE3IqWmWGzJhWpllZA
X-Proofpoint-ORIG-GUID: HWl3tvm6A9cmckERtgEj5fK2Dxj_30Fs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-01_04,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0
 phishscore=0 spamscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204010050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

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
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/smp.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/s390x/smp.c b/s390x/smp.c
index 81e02195..cfced18a 100644
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
@@ -136,10 +177,16 @@ static void test_store_status(void)
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
@@ -344,6 +391,7 @@ int main(void)
 	smp_cpu_stop(1);
 
 	test_start();
+	test_invalid();
 	test_restart();
 	test_stop();
 	test_stop_store_status();
-- 
2.34.1

