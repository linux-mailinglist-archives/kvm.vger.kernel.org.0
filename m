Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152B4739887
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 09:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbjFVHxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 03:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230154AbjFVHxP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 03:53:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8881F1FF2;
        Thu, 22 Jun 2023 00:53:02 -0700 (PDT)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35M7q3nN018335;
        Thu, 22 Jun 2023 07:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=B66tDDzDNb9OcKEoWSRqbuFmlYHVf8mKznF156PIW0c=;
 b=sHLYZmzasVZRhvXlEE7Q7pto46BiqJQClxuvuGeGgt7FxJnRQu9BT+MvlTJODAw4usXC
 kJ7DFnM2eTC7ah8dZF9oe5dcVSwtCNlZf/D/NmUbQ2FDckFoFfp5ejUmsq95DxoQ8okM
 pSqEjvGa+cAGVnVF2U/XjFcKps0DFxUk6eHxYzb+jopzYmdQrwrGZBzpb0aZKOrcdRuB
 3JlxqMZTzzDFs0snWlAzmYWV17UahFBHs8fIlgWykyx1WhmcamvW8B3xEOEhPYcVvUy1
 ntf3U8HDPpxFU+WbOLaSCfKQKpH12ZME1YBdER+bIvd4FfE1ULWmC+BF7C49xg6rXnP0 ZA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rcj9q00dt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:58 +0000
Received: from m0353728.ppops.net (m0353728.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35M7qvTr024366;
        Thu, 22 Jun 2023 07:52:57 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rcj9q00d5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:57 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35M3OaQo021635;
        Thu, 22 Jun 2023 07:52:09 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3r94f5age4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 22 Jun 2023 07:52:09 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35M7q5v937814756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 22 Jun 2023 07:52:05 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A219E2004E;
        Thu, 22 Jun 2023 07:52:05 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D6A1D20043;
        Thu, 22 Jun 2023 07:52:04 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 22 Jun 2023 07:52:04 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v4 6/8] s390x: uv-host: Properly handle config creation errors
Date:   Thu, 22 Jun 2023 07:50:52 +0000
Message-Id: <20230622075054.3190-7-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230622075054.3190-1-frankja@linux.ibm.com>
References: <20230622075054.3190-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _WYPBpRs35QKnqNw992ANiHHvNSBOhF3
X-Proofpoint-ORIG-GUID: eQHHWuWH_10OAllf8Zhstl8DZc0gMvlG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-22_04,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 mlxlogscore=949 suspectscore=0 phishscore=0
 impostorscore=0 spamscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306220062
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the first bit is set on a error rc, the hypervisor will need to
destroy the config before trying again. Let's properly handle those
cases so we're not using stale data.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/asm/uv.h |  1 +
 s390x/uv-host.c    | 65 +++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 57 insertions(+), 9 deletions(-)

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
index 4112b4b6..65a9c6d3 100644
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
2.34.1

