Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6E4567EC6
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 08:41:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiGFGlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 02:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiGFGlU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 02:41:20 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE1518381;
        Tue,  5 Jul 2022 23:41:19 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2665kdgT027428;
        Wed, 6 Jul 2022 06:41:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=+QnP1kSCnK+lsyVPXXwBdFM3GOUzfR0Dh4bQiQFZ3cg=;
 b=NfWcx1f+tF5PdBXOMAOSlxgLGOsaXYaCu7FNKJH4WBhcPun/4XOOaLrH0tptn06WF6Jz
 Ay/wOxogmRyVFaSkHAIRk8Z7wmjW70RuVd5OqFi5BHbmDbYUi109TafnRweqK58NgngB
 pK+8SbSaJf0GFTjeaKYQpAUwlHU0XWoTn9mOapDbR5robNO8GMwesrarI7IgLFT9e7mG
 6kgDfV9P/fNSqxAbB4h7ySa97O+tu8f0g54FlXI+ZKIYExL3tcdvBsRVN0ghc9lFrzPk
 +CbaJ1+aWfFUzYBbGmc0ikR1qht+Ht28LaE4MVrao+oY8EK/hOJPj2GjmsDBgqaEIfJz 2g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h54hwh2a8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:19 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2666QKr1025841;
        Wed, 6 Jul 2022 06:41:19 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h54hwh29q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:19 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2666KZYl027612;
        Wed, 6 Jul 2022 06:41:16 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3h4v8qgd5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2666fDmG16646604
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Jul 2022 06:41:13 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D8564C044;
        Wed,  6 Jul 2022 06:41:13 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 69D984C040;
        Wed,  6 Jul 2022 06:41:12 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Jul 2022 06:41:12 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 2/8] s390x: uv-host: Add uninitialized UV tests
Date:   Wed,  6 Jul 2022 06:40:18 +0000
Message-Id: <20220706064024.16573-3-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706064024.16573-1-frankja@linux.ibm.com>
References: <20220706064024.16573-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 45EHuPDTOHARmwhA29X_dLYb5CLPSO77
X-Proofpoint-ORIG-GUID: I_7dwy98-QsmPzuduGM5pGJ3gNQmyeyH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_03,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207060024
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
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 77 insertions(+), 2 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 983cb4a1..5aeacb42 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -101,6 +101,25 @@ static void test_priv(void)
 	report_prefix_pop();
 }
 
+static void test_uv_uninitialized(void)
+{
+	struct uv_cb_header uvcb = {};
+	int i;
+
+	report_prefix_push("uninitialized");
+
+	for (i = 0; cmds[i].name; i++) {
+		if (cmds[i].cmd == UVC_CMD_INIT_UV)
+			continue;
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
@@ -468,13 +487,68 @@ static void test_invalid(void)
 	report_prefix_pop();
 }
 
+static void setup_test_clear(void)
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
+	setup_test_clear();
 
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
@@ -505,6 +579,7 @@ int main(void)
 
 	test_priv();
 	test_invalid();
+	test_uv_uninitialized();
 	test_query();
 	test_init();
 
-- 
2.34.1

