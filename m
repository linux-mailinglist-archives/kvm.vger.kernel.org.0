Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D830C74F190
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:17:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjGKORF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:17:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbjGKOQ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:16:59 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5661C199C
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:16:44 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BEEVwC003872;
        Tue, 11 Jul 2023 14:16:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=rA7j/5R+SWMopdzxMYKZ96rF+UOex91DZQJsNGoG6tI=;
 b=gJRfOXcErpZyay2y81n5kj85xuTnaF0qoNSuTngG1o2okY/YRoROl+V/mtOnd0TVdUYB
 PclAkuft6sLU9qG6kpNdYjopOurh9Wi3NtN7ovFlOyMNd236rsVVKiSGjHeAoUR6xfam
 7QgI2DAKteK6xttw8+S2O++GN9oGUEHc/JyRFS4iRb6Zq365+DOSnFDn9RmyrbWrI5Eg
 Fj0VqFArUpOPccFV2spwJ0rW3DJy0LsQwjRCqgVAamXRAknOvJK7a37lCbkRHVNE6+Dv
 xVXOMCnPZplyoh1blEhOW0hrqH215DNbl9CI4FyxKymbXPtS8JYt7M/Ja83FRRCFTXdr Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8nvr3ss-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:34 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BEFAVP006831;
        Tue, 11 Jul 2023 14:16:26 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs8nvr3ma-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:26 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
        by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36BEFVGY019726;
        Tue, 11 Jul 2023 14:16:22 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3rqmu0r142-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:22 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGJ3H31982004
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:19 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB12820043;
        Tue, 11 Jul 2023 14:16:19 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 31B8120040;
        Tue, 11 Jul 2023 14:16:19 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:19 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 16/22] s390x: uv-host: Properly handle config creation errors
Date:   Tue, 11 Jul 2023 16:15:49 +0200
Message-ID: <20230711141607.40742-17-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 7zJbd5cmu1kWv299KGNX7GwBZdBu7IX4
X-Proofpoint-GUID: D0CRNi9uTCsjW5BW5bMsLsc04QFn8keI
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 mlxlogscore=962 adultscore=0 suspectscore=0 priorityscore=1501
 malwarescore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

If the first bit is set on a error rc, the hypervisor will need to
destroy the config before trying again. Let's properly handle those
cases so we're not using stale data.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230622075054.3190-7-frankja@linux.ibm.com
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/uv.h |  1 +
 s390x/uv-host.c    | 65 +++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 3892046..e9fb19a 100644
--- a/lib/s390x/asm/uv.h
+++ b/lib/s390x/asm/uv.h
@@ -24,6 +24,7 @@
 #define UVC_RC_NO_RESUME	0x0007
 #define UVC_RC_INV_GHANDLE	0x0020
 #define UVC_RC_INV_CHANDLE	0x0021
+#define UVC_RC_DSTR_NEEDED_FLG	0x8000
 
 #define UVC_CMD_QUI			0x0001
 #define UVC_CMD_INIT_UV			0x000f
diff --git a/s390x/uv-host.c b/s390x/uv-host.c
index 4112b4b..65a9c6d 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -370,6 +370,42 @@ static void test_cpu_create(void)
 	report_prefix_pop();
 }
 
+/*
+ * If the first bit of the rc is set we need to destroy the
+ * configuration before testing other create config errors.
+ */
+static void cgc_destroy_if_needed(struct uv_cb_cgc *uvcb)
+{
+	uint16_t rc, rrc;
+
+	if (uvcb->header.rc != UVC_RC_EXECUTED &&
+	    !(uvcb->header.rc & UVC_RC_DSTR_NEEDED_FLG))
+		return;
+
+	assert(uvcb->guest_handle);
+	assert(!uv_cmd_nodata(uvcb->guest_handle, UVC_CMD_DESTROY_SEC_CONF,
+			      &rc, &rrc));
+
+	/* We need to zero it for the next test */
+	uvcb->guest_handle = 0;
+}
+
+static bool cgc_check_data(struct uv_cb_cgc *uvcb, uint16_t rc_expected)
+{
+	/* This function purely checks for error rcs */
+	if (uvcb->header.rc == UVC_RC_EXECUTED)
+		return false;
+
+	/*
+	 * We should only receive a handle when the rc is 1 or the
+	 * first bit is set.
+	 */
+	if (!(uvcb->header.rc & UVC_RC_DSTR_NEEDED_FLG) && uvcb->guest_handle)
+		report_abort("Received a handle when we didn't expect one");
+
+	return (uvcb->header.rc & ~UVC_RC_DSTR_NEEDED_FLG) == rc_expected;
+}
+
 static void test_config_create(void)
 {
 	int rc;
@@ -394,58 +430,67 @@ static void test_config_create(void)
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
 	report(uvcb_cgc.header.rc == UVC_RC_INV_LEN && rc == 1 &&
 	       !uvcb_cgc.guest_handle, "hdr invalid length");
+	cgc_destroy_if_needed(&uvcb_cgc);
 	uvcb_cgc.header.len += 8;
 
 	uvcb_cgc.guest_stor_origin = uvcb_qui.max_guest_stor_addr + (1UL << 20) * 2 + 1;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x101 && rc == 1,
+	report(cgc_check_data(&uvcb_cgc, 0x101) && rc == 1,
 	       "MSO > max guest addr");
+	cgc_destroy_if_needed(&uvcb_cgc);
 	uvcb_cgc.guest_stor_origin = 0;
 
 	uvcb_cgc.guest_stor_origin = uvcb_qui.max_guest_stor_addr - (1UL << 20);
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x102 && rc == 1,
+	report(cgc_check_data(&uvcb_cgc, 0x102) && rc == 1,
 	       "MSO + MSL > max guest addr");
+	cgc_destroy_if_needed(&uvcb_cgc);
 	uvcb_cgc.guest_stor_origin = 0;
 
 	uvcb_cgc.guest_asce &= ~ASCE_P;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x105 && rc == 1,
+	report(cgc_check_data(&uvcb_cgc, 0x105) && rc == 1,
 	       "ASCE private bit missing");
+	cgc_destroy_if_needed(&uvcb_cgc);
 	uvcb_cgc.guest_asce |= ASCE_P;
 
 	uvcb_cgc.guest_asce |= 0x20;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x105 && rc == 1,
+	report(cgc_check_data(&uvcb_cgc, 0x105) && rc == 1,
 	       "ASCE bit 58 set");
+	cgc_destroy_if_needed(&uvcb_cgc);
 	uvcb_cgc.guest_asce &= ~0x20;
 
 	tmp = uvcb_cgc.conf_base_stor_origin;
 	uvcb_cgc.conf_base_stor_origin = get_max_ram_size() + 8;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x108 && rc == 1,
+	report(cgc_check_data(&uvcb_cgc, 0x108) && rc == 1,
 	       "base storage origin > available memory");
+	cgc_destroy_if_needed(&uvcb_cgc);
 	uvcb_cgc.conf_base_stor_origin = tmp;
 
 	tmp = uvcb_cgc.conf_base_stor_origin;
 	uvcb_cgc.conf_base_stor_origin = 0x1000;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x109 && rc == 1,
-	       "base storage origin contains lowcore");
+	report(cgc_check_data(&uvcb_cgc, 0x109) && rc == 1,
+	       "base storage origin contains lowcore %x",  uvcb_cgc.header.rc);
+	cgc_destroy_if_needed(&uvcb_cgc);
 	uvcb_cgc.conf_base_stor_origin = tmp;
 
 	tmp = uvcb_cgc.guest_sca;
 	uvcb_cgc.guest_sca = 0;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x10c && rc == 1,
+	report(cgc_check_data(&uvcb_cgc, 0x10c) && rc == 1,
 	       "sca == 0");
+	cgc_destroy_if_needed(&uvcb_cgc);
 	uvcb_cgc.guest_sca = tmp;
 
 	tmp = uvcb_cgc.guest_sca;
 	uvcb_cgc.guest_sca = get_max_ram_size() + PAGE_SIZE * 4;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x10d && rc == 1,
+	report(cgc_check_data(&uvcb_cgc, 0x10d) && rc == 1,
 	       "sca inaccessible");
+	cgc_destroy_if_needed(&uvcb_cgc);
 	uvcb_cgc.guest_sca = tmp;
 
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
@@ -464,6 +509,7 @@ static void test_config_create(void)
 	uvcb_cgc.guest_handle = 0;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
 	report(uvcb_cgc.header.rc >= 0x100 && rc == 1, "reuse uvcb");
+	cgc_destroy_if_needed(&uvcb_cgc);
 	uvcb_cgc.guest_handle = tmp;
 
 	/* Copy over most data from uvcb_cgc, so we have the ASCE that was used. */
@@ -481,6 +527,7 @@ static void test_config_create(void)
 	rc = uv_call(0, (uint64_t)&uvcb);
 	report(uvcb.header.rc >= 0x104 && rc == 1 && !uvcb.guest_handle,
 	       "reuse ASCE");
+	cgc_destroy_if_needed(&uvcb);
 	free((void *)uvcb.conf_base_stor_origin);
 	free((void *)uvcb.conf_var_stor_origin);
 
-- 
2.41.0

