Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDA76F44C1
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 15:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234263AbjEBNKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 09:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234264AbjEBNKK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 09:10:10 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D00F5B87;
        Tue,  2 May 2023 06:10:06 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342D8peJ018280;
        Tue, 2 May 2023 13:10:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=v22rJkOfS5kLbFgBDQGFK2qjK/E3IfLjYFcJ4spaQ/Y=;
 b=pYr4XNamFvFfjAjovOpR4Xbxe0leWGLro3Z+Td7FURxPjX9BXK1Gvrx5448siXCemP0u
 uBOeyyNlAWkiD8IY2S58Vswe38jkfiJvtUNUbuTDokei1UReVBoW6kmXoilVng3jOuO0
 yGYl25TvOzoawmZSBJtQ6qPyNcISUykav7fqtOwGHcYKq6j+Th3hGopxvTjx8aldndAo
 OTWy4ElW3CCICSDta1gXAysMoTQaKBfSeWEADq8jg+lnGCfgjeb6BuUyFFzlv9A5AowZ
 q8GH9eFE+0mQBMp7qdDpkJ/H6oHUXhhEPYjhfbaZKU48LfE/KN4Veffw1UiC3t19h8BW rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2xv8d0s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:10:05 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342D99FP022060;
        Tue, 2 May 2023 13:09:59 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qb2xv8bj5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:59 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3425MpQO031255;
        Tue, 2 May 2023 13:09:29 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3q8tv6skjh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 13:09:28 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342D9Ppl14090694
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 13:09:25 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 634B920040;
        Tue,  2 May 2023 13:09:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9357220043;
        Tue,  2 May 2023 13:09:24 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 13:09:24 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v3 7/9] s390x: uv-host: Properly handle config creation errors
Date:   Tue,  2 May 2023 13:07:30 +0000
Message-Id: <20230502130732.147210-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502130732.147210-1-frankja@linux.ibm.com>
References: <20230502130732.147210-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 93_TOOzizp_B5sBBhoeh3muHuns1fYN_
X-Proofpoint-ORIG-GUID: eiaLhTPEO5B5yecKB_Ly8FKEqQM82ApO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_08,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 phishscore=0 impostorscore=0 mlxlogscore=927 spamscore=0 clxscore=1015
 suspectscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020111
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the first bit is set on a error rc, the hypervisor will need to
destroy the config before trying again. Let's properly handle those
cases so we're not using stale data.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
---
 lib/s390x/asm/uv.h |  1 +
 s390x/uv-host.c    | 66 +++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
index 38920461..e9fb19af 100644
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
index a9543593..4418e9b9 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -371,6 +371,42 @@ static void test_cpu_create(void)
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
@@ -395,44 +431,51 @@ static void test_config_create(void)
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
 
 	/*
@@ -445,21 +488,24 @@ static void test_config_create(void)
 		rc = uv_call(0, (uint64_t)&uvcb_cgc);
 		report(uvcb_cgc.header.rc == 0x10b && rc == 1 &&
 		       !uvcb_cgc.guest_handle, "variable storage area contains lowcore");
+		cgc_destroy_if_needed(&uvcb_cgc);
 		smp_sigp(1, SIGP_SET_PREFIX, 0x0, NULL);
 	}
 
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
@@ -478,6 +524,7 @@ static void test_config_create(void)
 	uvcb_cgc.guest_handle = 0;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
 	report(uvcb_cgc.header.rc >= 0x100 && rc == 1, "reuse uvcb");
+	cgc_destroy_if_needed(&uvcb_cgc);
 	uvcb_cgc.guest_handle = tmp;
 
 	/* Copy over most data from uvcb_cgc, so we have the ASCE that was used. */
@@ -495,6 +542,7 @@ static void test_config_create(void)
 	rc = uv_call(0, (uint64_t)&uvcb);
 	report(uvcb.header.rc >= 0x104 && rc == 1 && !uvcb.guest_handle,
 	       "reuse ASCE");
+	cgc_destroy_if_needed(&uvcb);
 	free((void *)uvcb.conf_base_stor_origin);
 	free((void *)uvcb.conf_var_stor_origin);
 
-- 
2.34.1

