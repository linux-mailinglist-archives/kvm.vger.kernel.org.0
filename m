Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0E9460CB1E
	for <lists+kvm@lfdr.de>; Tue, 25 Oct 2022 13:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232209AbiJYLoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Oct 2022 07:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbiJYLn4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Oct 2022 07:43:56 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9A617535B
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 04:43:54 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29PB8A3M028254
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=L9gcrzacnQsomFvbWWhbCoCMwle349TI0zKauC6QD08=;
 b=bzmFoZ+30d3pMtnUMrNr4kAV1bbp8TtDMhuRsY9D0GW9tVcOL1F36UaQTDKFEC0Y9cAG
 gRt7CN1Q14asK4CfKJJJwrRjJnS0NneWFTZ1dBlvOqAHPoakeb44HNfjoXdf9wHeX/q5
 xU/XZ2MaQGzYQ04kvCTSw7hQx8GXJ0bL4IByImIfatLLVlFSzPkHVLhv4sNVY6vHDmPD
 0a9HT4qKF61ND33gvQNpRxojC0YwP4VoC0/NAxJResg0G2Bd25k2Hh7eKkxbegrbiK5q
 SSGs3lHhFrXMM443olYeGXfsht8ARJcfPfWdtogX+7pzEbGrI5kW1Jih2v5k8zzV1zws MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee35t8e0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:53 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29PBB4FM000749
        for <kvm@vger.kernel.org>; Tue, 25 Oct 2022 11:43:53 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kee35t8d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:53 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29PBcJpA026830;
        Tue, 25 Oct 2022 11:43:50 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3kc859dhpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Oct 2022 11:43:50 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29PBiMcS50987420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Oct 2022 11:44:22 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4D63AE045;
        Tue, 25 Oct 2022 11:43:47 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E0E9AE04D;
        Tue, 25 Oct 2022 11:43:47 +0000 (GMT)
Received: from p-imbrenda.boeblingen.de.ibm.com (unknown [9.152.224.252])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 25 Oct 2022 11:43:47 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>,
        Steffen Eiden <seiden@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 08/22] s390x: uv-host: Add uninitialized UV tests
Date:   Tue, 25 Oct 2022 13:43:31 +0200
Message-Id: <20221025114345.28003-9-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025114345.28003-1-imbrenda@linux.ibm.com>
References: <20221025114345.28003-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: xCPcF9m3h4aB8ydOFkiaLdKwniYpu78A
X-Proofpoint-GUID: SqewdUo9h5w9GVaUt8ei1MaswQvebquj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-25_05,2022-10-25_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 suspectscore=0 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2209130000 definitions=main-2210250067
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

Let's also test for rc 0x3

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
Message-Id: <20221017093925.2038-3-frankja@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/uv-host.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 77 insertions(+), 2 deletions(-)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 622c7f7e..24dcd6dc 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -109,6 +109,25 @@ static void test_priv(void)
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
@@ -476,13 +495,68 @@ static void test_invalid(void)
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
@@ -513,6 +587,7 @@ int main(void)
 
 	test_priv();
 	test_invalid();
+	test_uv_uninitialized();
 	test_query();
 	test_init();
 
-- 
2.37.3

