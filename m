Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F7B6C7DE9
	for <lists+kvm@lfdr.de>; Fri, 24 Mar 2023 13:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbjCXMSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Mar 2023 08:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjCXMSd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Mar 2023 08:18:33 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 907556A40
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 05:18:21 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32O9xXRo019058
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=mGcywOmAYToLDd2hecYHJu5BXTRG5rXPmk3CB/auLNQ=;
 b=dDngeIXv8CHa+/s/bS607V+YU99hJsZXeyPZpehW0XN9Vo4GLuZAdCqfi3opMnYamArM
 Zm7jFaIBhbXF3JqMwItUXRC9/N3/GgCVE+ojlLwSb6tokhEfSX497pY1/XFF0/zz6Tdg
 HdYDA9F6cWLIAuOEItwI6rGTe3XS03GyeL1CpfdLU6vUAhTT+tQrezw6zcIfbkL/zF65
 2FlktnBhLDCzpDDdet17qSWjM3CyKtv10hG3XqiAFlOLQuG0ihwb21SO9PMt4E1Ulf1Q
 o6J+e+Q3PNM6mj0VIIk/9Bglreaf0VaQtrwa4alhzuc75nZtheeOudzTfAgwldIcy4dz yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph9q6b47d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:20 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32OBj1w2004868
        for <kvm@vger.kernel.org>; Fri, 24 Mar 2023 12:18:20 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3ph9q6b472-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:20 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32NLuljq013860;
        Fri, 24 Mar 2023 12:18:18 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3pgy3s0t27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Mar 2023 12:18:18 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32OCIExu23397068
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Mar 2023 12:18:14 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B75042004D;
        Fri, 24 Mar 2023 12:18:14 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 21FF42004B;
        Fri, 24 Mar 2023 12:18:14 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 24 Mar 2023 12:18:14 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v2 8/9] s390x: uv-host: Properly handle config creation errors
Date:   Fri, 24 Mar 2023 12:17:23 +0000
Message-Id: <20230324121724.1627-9-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230324121724.1627-1-frankja@linux.ibm.com>
References: <20230324121724.1627-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: YyQb1dVu5OJINPQzEjSG64oFu3DQFwID
X-Proofpoint-GUID: nf4ZTXyk1x3leyitY0wXnPirh50PK8aY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_06,2023-03-24_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 mlxlogscore=855 spamscore=0 suspectscore=0 mlxscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303240099
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the first bit is set on a error rc, the hypervisor will need to
destroy the config before trying again. Let's properly handle those
cases so we're not usign stale data.

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
index 8d1d441f..5ad1a116 100644
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
@@ -394,44 +430,51 @@ static void test_config_create(void)
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
@@ -444,21 +487,24 @@ static void test_config_create(void)
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
@@ -477,6 +523,7 @@ static void test_config_create(void)
 	uvcb_cgc.guest_handle = 0;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
 	report(uvcb_cgc.header.rc >= 0x100 && rc == 1, "reuse uvcb");
+	cgc_destroy_if_needed(&uvcb_cgc);
 	uvcb_cgc.guest_handle = tmp;
 
 	/* Copy over most data from uvcb_cgc, so we have the ASCE that was used. */
@@ -494,6 +541,7 @@ static void test_config_create(void)
 	rc = uv_call(0, (uint64_t)&uvcb);
 	report(uvcb.header.rc >= 0x104 && rc == 1 && !uvcb.guest_handle,
 	       "reuse ASCE");
+	cgc_destroy_if_needed(&uvcb);
 	free((void *)uvcb.conf_base_stor_origin);
 	free((void *)uvcb.conf_var_stor_origin);
 
-- 
2.34.1

