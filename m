Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1FF3567EC3
	for <lists+kvm@lfdr.de>; Wed,  6 Jul 2022 08:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbiGFGlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Jul 2022 02:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbiGFGlT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Jul 2022 02:41:19 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192F2167CA;
        Tue,  5 Jul 2022 23:41:19 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2666CSpA031035;
        Wed, 6 Jul 2022 06:41:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=vwnsrP4U/jryjwEbcceGSR9SMW8gSXe0LLEHVNwy4O0=;
 b=CdduUUk49LBxMVSw/ZSRL/RE3LIQVMrarZ8mdyn6+tYuPLRbNRlQBMt9SJ/7tX813K8O
 0fmwfMHtIV7BZB5zTOSj9tLjP0XT1tdB1t7QMjLfgTJQ0r6iO0cpy5eGIz35a28KMHaE
 7/pyEqNMQSth9vLn/KmMqyCoTrA0KUBsz7kCofE5/A7t5h/7u2wOJovvPckrPlZq1p1j
 RxrLHePVWZePQnkPWsAtRs1p08u1wtjmRHA8Zea/7ZuBgr/j9YAge63Pmea1aE3zwEUL
 50zfDIc9Fq29sKZitmBnygQL5h6xNTVwKqhj/TZtIe9sJlivpCHKUEOgPZLlLcARS5Lk fw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4vc72t26-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:18 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2666KTB3010277;
        Wed, 6 Jul 2022 06:41:18 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h4vc72t1n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:18 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2666K35R029714;
        Wed, 6 Jul 2022 06:41:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3h4ukw0drt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 06:41:15 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2666fCT116449978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 6 Jul 2022 06:41:12 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 410354C040;
        Wed,  6 Jul 2022 06:41:12 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5D42B4C04A;
        Wed,  6 Jul 2022 06:41:11 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  6 Jul 2022 06:41:11 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm390 mailing list <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, seiden@linux.ibm.com,
        nrb@linux.ibm.com, scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 1/8] s390x: uv-host: Add access checks for donated memory
Date:   Wed,  6 Jul 2022 06:40:17 +0000
Message-Id: <20220706064024.16573-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220706064024.16573-1-frankja@linux.ibm.com>
References: <20220706064024.16573-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: HbteIVuQYp08TbHz1JpOP9vkbqvLZa_W
X-Proofpoint-GUID: lMqOFGPzMo-QS3QlEH3x8K5NZ8imB_D8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-06_03,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxscore=0
 malwarescore=0 impostorscore=0 lowpriorityscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 mlxlogscore=999 suspectscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207060024
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
---
 s390x/uv-host.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index a1a6d120..983cb4a1 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -43,6 +43,24 @@ static void cpu_loop(void)
 	for (;;) {}
 }
 
+/*
+ * Checks if a memory area is protected as secure memory.
+ * Will return true if all pages are protected, false otherwise.
+ */
+static bool access_check_3d(uint64_t *access_ptr, uint64_t len)
+{
+	while (len) {
+		expect_pgm_int();
+		*access_ptr += 42;
+		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
+			return false;
+		access_ptr += PAGE_SIZE / sizeof(access_ptr);
+		len -= PAGE_SIZE;
+	}
+
+	return true;
+}
+
 static struct cmd_list cmds[] = {
 	{ "init", UVC_CMD_INIT_UV, sizeof(struct uv_cb_init), BIT_UVC_CMD_INIT_UV },
 	{ "create conf", UVC_CMD_CREATE_SEC_CONF, sizeof(struct uv_cb_cgc), BIT_UVC_CMD_CREATE_SEC_CONF },
@@ -194,6 +212,10 @@ static void test_cpu_create(void)
 	report(rc == 0 && uvcb_csc.header.rc == UVC_RC_EXECUTED &&
 	       uvcb_csc.cpu_handle, "success");
 
+	rc = access_check_3d((uint64_t *)uvcb_csc.stor_origin,
+			     uvcb_qui.cpu_stor_len);
+	report(rc, "Storage protection");
+
 	tmp = uvcb_csc.stor_origin;
 	uvcb_csc.stor_origin = (unsigned long)memalign(PAGE_SIZE, uvcb_qui.cpu_stor_len);
 	rc = uv_call(0, (uint64_t)&uvcb_csc);
@@ -292,6 +314,13 @@ static void test_config_create(void)
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
 	report(rc == 0 && uvcb_cgc.header.rc == UVC_RC_EXECUTED, "successful");
 
+	rc = access_check_3d((uint64_t *)uvcb_cgc.conf_var_stor_origin, vsize);
+	report(rc, "Base storage protection");
+
+	rc = access_check_3d((uint64_t *)uvcb_cgc.conf_base_stor_origin,
+			     uvcb_qui.conf_base_phys_stor_len);
+	report(rc, "Variable storage protection");
+
 	uvcb_cgc.header.rc = 0;
 	uvcb_cgc.header.rrc = 0;
 	tmp = uvcb_cgc.guest_handle;
-- 
2.34.1

