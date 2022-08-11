Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4BB858FD40
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 15:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234955AbiHKNSo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 09:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbiHKNSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 09:18:42 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D48D7D7B1
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 06:18:41 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BCPfsY003946
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 13:18:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=UsH2trbXqUjzVwhYOja1tdE0vFkXGfhYwz9Tneiq40A=;
 b=Dz854EUQ5ribUbAedr694CqZSIKqmExiMXNkv/nXOP946Fhzl+8J+YxyPWdKLxQu7xq7
 iN9N+N6lP7Br4E1coEZldS3KeDpN3M297AJRE/WNKTjGu9ghjozYyhvWKIirmgkUxNIs
 UX0xV6tzOu/e/zCCdQOyWXciVQHcuZbNzZWHkrY3emAGxmxuK+/Qj2x/KGF2gTyEia4j
 rHHwJMCQOHPrJhrKOCncHcfUYEELydfJ27c+sRYElwwdtzMJyFQLJsJfKavgI+WMw52t
 xdk9IH3+Wu0MMVtcNDc2ro0lKgj9YU/MeteBFK+nh3W3Czd1dXlgVOCT55p4kDKgjxwS jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hw1rt1x8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 13:18:41 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27BCRgeG012258
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 13:18:40 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hw1rt1x7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 13:18:40 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27BD5sXp009886;
        Thu, 11 Aug 2022 13:18:38 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3huwvf225c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 13:18:38 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27BDIqgs30081438
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 13:18:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1394CA405B;
        Thu, 11 Aug 2022 13:18:35 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 63F6DA4054;
        Thu, 11 Aug 2022 13:18:34 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Aug 2022 13:18:34 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     imbrenda@linux.ibm.com
Cc:     kvm@vger.kernel.org, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v4] s390x: uv-host: Add access checks for donated memory
Date:   Thu, 11 Aug 2022 13:18:24 +0000
Message-Id: <20220811131824.25847-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220803114602.5359a8a4@p-imbrenda>
References: <20220803114602.5359a8a4@p-imbrenda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: iPAjPfi2s8CqS7NTp4c5Vd1jSThJDn8l
X-Proofpoint-GUID: 6x1RXqwyogF1IwZljwc3fCkNfG9Zfcjn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_10,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0 spamscore=0
 adultscore=0 mlxlogscore=888 bulkscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208110041
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check if the UV really protected all the memory we donated.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 s390x/uv-host.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index dfcebe10..8d2da5d3 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -45,6 +45,32 @@ static void cpu_loop(void)
 	for (;;) {}
 }
 
+/*
+ * Checks if a memory area is protected as secure memory.
+ * Will return true if all pages are protected, false otherwise.
+ */
+static bool access_check_3d(uint8_t *access_ptr, uint64_t len)
+{
+	assert(!(len & ~PAGE_MASK));
+	assert(!((uint64_t)access_ptr & ~PAGE_MASK));
+
+	while (len) {
+		expect_pgm_int();
+		READ_ONCE(*access_ptr);
+		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
+			return false;
+		expect_pgm_int();
+		WRITE_ONCE(*access_ptr, 42);
+		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
+			return false;
+
+		access_ptr += PAGE_SIZE;
+		len -= PAGE_SIZE;
+	}
+
+	return true;
+}
+
 static struct cmd_list cmds[] = {
 	{ "init", UVC_CMD_INIT_UV, sizeof(struct uv_cb_init), BIT_UVC_CMD_INIT_UV },
 	{ "create conf", UVC_CMD_CREATE_SEC_CONF, sizeof(struct uv_cb_cgc), BIT_UVC_CMD_CREATE_SEC_CONF },
@@ -332,6 +358,10 @@ static void test_cpu_create(void)
 	report(rc == 0 && uvcb_csc.header.rc == UVC_RC_EXECUTED &&
 	       uvcb_csc.cpu_handle, "success");
 
+	rc = access_check_3d((uint8_t *)uvcb_csc.stor_origin,
+			     uvcb_qui.cpu_stor_len);
+	report(rc, "Storage protection");
+
 	tmp = uvcb_csc.stor_origin;
 	uvcb_csc.stor_origin = (unsigned long)memalign(PAGE_SIZE, uvcb_qui.cpu_stor_len);
 	rc = uv_call(0, (uint64_t)&uvcb_csc);
@@ -430,6 +460,13 @@ static void test_config_create(void)
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
 	report(rc == 0 && uvcb_cgc.header.rc == UVC_RC_EXECUTED, "successful");
 
+	rc = access_check_3d((uint8_t *)uvcb_cgc.conf_var_stor_origin, vsize);
+	report(rc, "Base storage protection");
+
+	rc = access_check_3d((uint8_t *)uvcb_cgc.conf_base_stor_origin,
+			     uvcb_qui.conf_base_phys_stor_len);
+	report(rc, "Variable storage protection");
+
 	uvcb_cgc.header.rc = 0;
 	uvcb_cgc.header.rrc = 0;
 	tmp = uvcb_cgc.guest_handle;
-- 
2.34.1

