Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6050357FF99
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 15:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235481AbiGYNJg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 09:09:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235431AbiGYNJc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 09:09:32 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C97B13E1D;
        Mon, 25 Jul 2022 06:09:31 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26PCg33B013093;
        Mon, 25 Jul 2022 13:09:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=WuaCVlqewRzCanbvYiT+4X7IEfvrY3Qnh4bQnqPHj2c=;
 b=KEGKWbGfRlf2gR6bbLRbmYpIofXWPneNYi/gjLJhY87tOIeSTn9MDeju2FQ6ZBzgisNl
 hLnbBdK9kDqbY0BfRj6DOes59aNId72OH0tTdHjHXOrUutFV9P6awzljwXjZ/wYjcukX
 D6/L6sFjx855CbD5GckoWsraYi9G2cUYO00JbgOf2NIyqBl8zwLMyhnYlSfseFldfsJ5
 37Zgcq5ucmkthDL8wfVdx5wrw7qLZ+fMj6luvrcpblfq71Pxwe4wFG7G9tA6GgOrHLN8
 f/G+XmtLLw3RfwFtndrEtVj5szfoag07vGV4/BeX3Y97AFgZA5IIdMbhCQ59gRatQXqP Sg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hhudfh1yw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 13:09:30 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 26PChTnA018782;
        Mon, 25 Jul 2022 13:09:30 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hhudfh1xn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 13:09:30 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26PD5JxC020722;
        Mon, 25 Jul 2022 13:09:28 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 3hg946aejj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jul 2022 13:09:27 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26PD9cPD17564142
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jul 2022 13:09:38 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A99044203F;
        Mon, 25 Jul 2022 13:09:24 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E586B42041;
        Mon, 25 Jul 2022 13:09:23 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 25 Jul 2022 13:09:23 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, linux-s390@vger.kernel.org,
        thuth@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
Subject: [kvm-unit-tests PATCH v3] s390x: uv-host: Add access checks for donated memory
Date:   Mon, 25 Jul 2022 13:08:59 +0000
Message-Id: <20220725130859.48740-1-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220707111912.51ecc0f2@p-imbrenda>
References: <20220707111912.51ecc0f2@p-imbrenda>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: nDx-CIMDV7uiba0CKDBjJdLXFx9axBUt
X-Proofpoint-ORIG-GUID: pv5S2GdVEWKRJZO2-KdJGnnwRckK62Dt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-25_09,2022-07-25_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 phishscore=0 mlxlogscore=961 clxscore=1015 priorityscore=1501 adultscore=0
 malwarescore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207250055
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's check if the UV really protected all the memory we donated.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 s390x/uv-host.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index dfcebe10..ba6c9008 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -45,6 +45,32 @@ static void cpu_loop(void)
 	for (;;) {}
 }
 
+/*
+ * Checks if a memory area is protected as secure memory.
+ * Will return true if all pages are protected, false otherwise.
+ */
+static bool access_check_3d(uint64_t *access_ptr, uint64_t len)
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
@@ -332,6 +358,10 @@ static void test_cpu_create(void)
 	report(rc == 0 && uvcb_csc.header.rc == UVC_RC_EXECUTED &&
 	       uvcb_csc.cpu_handle, "success");
 
+	rc = access_check_3d((uint64_t *)uvcb_csc.stor_origin,
+			     uvcb_qui.cpu_stor_len);
+	report(rc, "Storage protection");
+
 	tmp = uvcb_csc.stor_origin;
 	uvcb_csc.stor_origin = (unsigned long)memalign(PAGE_SIZE, uvcb_qui.cpu_stor_len);
 	rc = uv_call(0, (uint64_t)&uvcb_csc);
@@ -430,6 +460,13 @@ static void test_config_create(void)
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

