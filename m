Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D08600B0F
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 11:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiJQJkG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 05:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiJQJkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 05:40:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4A71DA51
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 02:39:59 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29H8Sq7I013762
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:39:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=K7O2HMm0Rb1Wpg3W0t0XJmbvn4p5BIENfVyxJu+RxZU=;
 b=kIc7ZPueQYxh3vMSUvaCkvKqK/FBHwQA5jmaq3LK/EASdUTv8MFvOz3bG4vPjvSdjPqs
 NsesdACPR/raD9POCsEXi/90MkTr80Nk9tdvbl2/YWEwuWrhEJCiRtGMpYiyKcFUHZ07
 FBCoFu+0hLHX4LPbAVaniuWw46q80gaD4Mn85OndD8nK4pCripOGa74yq8bpWhc0VVJe
 Uze9ZCFOI4QggXTwFqO5Er0VW05lRn7k+3GefWdGFWH1MiwcyE4H1jfBaON3Cc7my00k
 ofR2e7oVEp3A0FH6hvP1zTy+WYqYLksjrqybyFK7apOC5NePEhgt1LdBEyDMww87EeFi 8Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86sjkq6c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:39:59 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29H7KEJO002149
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 09:39:58 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3k86sjkq5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:39:58 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29H9ZAlr009852;
        Mon, 17 Oct 2022 09:39:56 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg92qmm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 17 Oct 2022 09:39:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29H9drbf918168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 17 Oct 2022 09:39:53 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 538A4A405B;
        Mon, 17 Oct 2022 09:39:53 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A49BAA4054;
        Mon, 17 Oct 2022 09:39:52 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 17 Oct 2022 09:39:52 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: [kvm-unit-tests PATCH v3 1/8] s390x: uv-host: Add access checks for donated memory
Date:   Mon, 17 Oct 2022 09:39:18 +0000
Message-Id: <20221017093925.2038-2-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221017093925.2038-1-frankja@linux.ibm.com>
References: <20221017093925.2038-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Pjwhm_cgWoMH4UplL27_ZkU-KYcOxHjm
X-Proofpoint-GUID: bmhX_P1NQa1EyfqTidSLZtHe9cyclS43
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-17_07,2022-10-17_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 spamscore=0 clxscore=1015 suspectscore=0
 mlxlogscore=971 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210170055
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
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 s390x/uv-host.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index a1a6d120..622c7f7e 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -43,6 +43,32 @@ static void cpu_loop(void)
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
@@ -194,6 +220,10 @@ static void test_cpu_create(void)
 	report(rc == 0 && uvcb_csc.header.rc == UVC_RC_EXECUTED &&
 	       uvcb_csc.cpu_handle, "success");
 
+	rc = access_check_3d((uint8_t *)uvcb_csc.stor_origin,
+			     uvcb_qui.cpu_stor_len);
+	report(rc, "Storage protection");
+
 	tmp = uvcb_csc.stor_origin;
 	uvcb_csc.stor_origin = (unsigned long)memalign(PAGE_SIZE, uvcb_qui.cpu_stor_len);
 	rc = uv_call(0, (uint64_t)&uvcb_csc);
@@ -292,6 +322,13 @@ static void test_config_create(void)
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
 	report(rc == 0 && uvcb_cgc.header.rc == UVC_RC_EXECUTED, "successful");
 
+	rc = access_check_3d((uint8_t *)uvcb_cgc.conf_base_stor_origin,
+			     uvcb_qui.conf_base_phys_stor_len);
+	report(rc, "Base storage protection");
+
+	rc = access_check_3d((uint8_t *)uvcb_cgc.conf_var_stor_origin, vsize);
+	report(rc, "Variable storage protection");
+
 	uvcb_cgc.header.rc = 0;
 	uvcb_cgc.header.rrc = 0;
 	tmp = uvcb_cgc.guest_handle;
-- 
2.34.1

