Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9DB525EF6
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 12:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379180AbiEMJvu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 05:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379171AbiEMJvs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 05:51:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604565716C;
        Fri, 13 May 2022 02:51:48 -0700 (PDT)
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24D9gUE8012908;
        Fri, 13 May 2022 09:51:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=1o01ehLqlX/YYeb5qV6xwxVs/1Huj6/O1R4x+qwv2l0=;
 b=mD8B1FuAsNqTwfzBDZBS6VcB1LT522nBmcZebr6dc9dRF+C/0HSoatYVh2XcGLtzVx3E
 xExr8R47MJQjtshQg0DFzSGeRggSUIFIJagaVkeZsNan3AgZRfiIPYNB+6KNNJqN7Ju5
 sPUlMQ9ButNPO1a0rlINJvESSzzMqbsqGE44L/1kj/ihJMOP2ud5qRyhKqfKlwd/bnCj
 qF81XSSqVBiaXDMaLO+asy6oBA0V0yHx5azHhGoEazC27cFFtVPNXK6NRei9eSiru7w4
 PHFsQO6nSh27wVuD19u8/VQnbfzcqu7trIGd8KXfAu96mNhBvZzO4D343GCU3ZW678O8 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1jjn36du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:47 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24D8lwN5010850;
        Fri, 13 May 2022 09:51:47 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g1jjn36dc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:47 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24D9SnGG026829;
        Fri, 13 May 2022 09:51:45 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3fwgd90cmq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 May 2022 09:51:45 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24D9pg5h36176218
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 May 2022 09:51:42 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0359B4C04E;
        Fri, 13 May 2022 09:51:42 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E94D4C044;
        Fri, 13 May 2022 09:51:41 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 13 May 2022 09:51:41 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH 2/6] s390x: uv-host: Add uninitialized UV tests
Date:   Fri, 13 May 2022 09:50:13 +0000
Message-Id: <20220513095017.16301-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220513095017.16301-1-frankja@linux.ibm.com>
References: <20220513095017.16301-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: sbLResKu52Cm8Vr72IoafvS4qLbVFIrU
X-Proofpoint-GUID: hZwwggLV-jHWTMCtPgQsZh1xm-qnrSSS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-13_04,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205130041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's also test for rc 0x3

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 76 insertions(+), 2 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 0f0b18a1..f846fc42 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -83,6 +83,24 @@ static void test_priv(void)
 	report_prefix_pop();
 }
 
+static void test_uv_uninitialized(void)
+{
+	struct uv_cb_header uvcb = {};
+	int i;
+
+	report_prefix_push("uninitialized");
+
+	/* i = 1 to skip over initialize */
+	for (i = 1; cmds[i].name; i++) {
+		expect_pgm_int();
+		uvcb.cmd = cmds[i].cmd;
+		uvcb.len = cmds[i].len;
+		uv_call_once(0, (uint64_t)&uvcb);
+		report(uvcb.rc == UVC_RC_INV_STATE, "%s", cmds[i].name);
+	}
+	report_prefix_pop();
+}
+
 static void test_config_destroy(void)
 {
 	int rc;
@@ -477,13 +495,68 @@ static void test_invalid(void)
 	report_prefix_pop();
 }
 
+static void test_clear_setup(void)
+{
+	unsigned long vsize;
+	int rc;
+
+	uvcb_cgc.header.cmd = UVC_CMD_CREATE_SEC_CONF;
+	uvcb_cgc.header.len = sizeof(uvcb_cgc);
+
+	uvcb_cgc.guest_stor_origin = 0;
+	uvcb_cgc.guest_stor_len = 42 * (1UL << 20);
+	vsize = uvcb_qui.conf_base_virt_stor_len +
+		((uvcb_cgc.guest_stor_len / (1UL << 20)) * uvcb_qui.conf_virt_var_stor_len);
+
+	uvcb_cgc.conf_base_stor_origin = (uint64_t)memalign(PAGE_SIZE * 4, uvcb_qui.conf_base_phys_stor_len);
+	uvcb_cgc.conf_var_stor_origin = (uint64_t)memalign(PAGE_SIZE, vsize);
+	uvcb_cgc.guest_asce = (uint64_t)memalign(PAGE_SIZE, 4 * PAGE_SIZE) | ASCE_DT_SEGMENT | REGION_TABLE_LENGTH | ASCE_P;
+	uvcb_cgc.guest_sca = (uint64_t)memalign(PAGE_SIZE * 4, PAGE_SIZE * 4);
+
+	rc = uv_call(0, (uint64_t)&uvcb_cgc);
+	assert(rc == 0);
+
+	uvcb_csc.header.len = sizeof(uvcb_csc);
+	uvcb_csc.header.cmd = UVC_CMD_CREATE_SEC_CPU;
+	uvcb_csc.guest_handle = uvcb_cgc.guest_handle;
+	uvcb_csc.stor_origin = (unsigned long)memalign(PAGE_SIZE, uvcb_qui.cpu_stor_len);
+	uvcb_csc.state_origin = (unsigned long)memalign(PAGE_SIZE, PAGE_SIZE);
+
+	rc = uv_call(0, (uint64_t)&uvcb_csc);
+	assert(rc == 0);
+}
+
 static void test_clear(void)
 {
-	uint64_t *tmp = (void *)uvcb_init.stor_origin;
+	uint64_t *tmp;
+
+	report_prefix_push("load normal reset");
+
+	/*
+	 * Setup a config and a cpu so we can check if a diag308 reset
+	 * clears the donated memory and makes the pages unsecure.
+	 */
+	test_clear_setup();
 
 	diag308_load_reset(1);
 	sclp_console_setup();
-	report(!*tmp, "memory cleared after reset 1");
+
+	tmp = (void *)uvcb_init.stor_origin;
+	report(!*tmp, "uv init donated memory cleared");
+
+	tmp = (void *)uvcb_cgc.conf_base_stor_origin;
+	report(!*tmp, "config base donated memory cleared");
+
+	tmp = (void *)uvcb_cgc.conf_base_stor_origin;
+	report(!*tmp, "config variable donated memory cleared");
+
+	tmp = (void *)uvcb_csc.stor_origin;
+	report(!*tmp, "cpu donated memory cleared after reset 1");
+
+	/* Check if uninitialized after reset */
+	test_uv_uninitialized();
+
+	report_prefix_pop();
 }
 
 static void setup_vmem(void)
@@ -514,6 +587,7 @@ int main(void)
 
 	test_priv();
 	test_invalid();
+	test_uv_uninitialized();
 	test_query();
 	test_init();
 
-- 
2.34.1

