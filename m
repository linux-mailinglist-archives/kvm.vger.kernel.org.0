Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEBF6C6579
	for <lists+kvm@lfdr.de>; Thu, 23 Mar 2023 11:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231605AbjCWKoA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Mar 2023 06:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjCWKn1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Mar 2023 06:43:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169803B3C3
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 03:40:28 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32N9fqFl012681
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=kEhPInzXBW0DTQjpzewSkyE6jdXSAatAYTYhUtMOGJ4=;
 b=lE3b4BWxbhyjjFeScApkx+L6ohTqHe/KbHqziUkbct9DfTGmj2miCK6DA6KP3OVipgb9
 hflaoVSfMNIC86evP9dBqOif/KytL+C7fdBucVlFlZGQcVBarzmGUGa0J82BgzeLxeAB
 GdY2oK7ufzEXJtswazyel7JRhX70BZI30lUzMNlLcWaZtRkg5x0XRSFvvowy00RVwLDA
 4AAIss++gyt34t+JAj3yROYUXClMypi7527dn6ylPrv4YnyKUAm7CcO01ESXnMqVPO8D
 dZZjWZCKhDX7jC9LZyvQtGB1HhcD4dJYM1+9EKLLCkWu+cfKz9CsNg0Sidk6fK1MxLoi 4w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgmc2hahj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:26 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32NAXGRU019057
        for <kvm@vger.kernel.org>; Thu, 23 Mar 2023 10:40:26 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pgmc2hagt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:25 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32MKG9nJ014689;
        Thu, 23 Mar 2023 10:40:23 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3pd4x6e1xq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Mar 2023 10:40:23 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32NAeJcg28902012
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Mar 2023 10:40:19 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C50CA2004E;
        Thu, 23 Mar 2023 10:40:19 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3679620043;
        Thu, 23 Mar 2023 10:40:19 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Mar 2023 10:40:19 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org, nrb@linux.ibm.com
Cc:     thuth@redhat.com, imbrenda@linux.ibm.com
Subject: [kvm-unit-tests PATCH 7/8] s390x: uv-host: Properly handle config creation errors
Date:   Thu, 23 Mar 2023 10:39:12 +0000
Message-Id: <20230323103913.40720-8-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230323103913.40720-1-frankja@linux.ibm.com>
References: <20230323103913.40720-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: LHUb_V1LqkX2I8uFuIgXCNsnVbZPJyZW
X-Proofpoint-ORIG-GUID: T2vskfYMpEmBrJHh3pgajcvuR2YUWmlw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-22_21,2023-03-22_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 bulkscore=0 impostorscore=0 mlxscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 phishscore=0 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303150002 definitions=main-2303230080
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
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
 s390x/uv-host.c    | 52 ++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 44 insertions(+), 9 deletions(-)

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
index d92571b5..b23d51c9 100644
--- a/s390x/uv-host.c
+++ b/s390x/uv-host.c
@@ -370,6 +370,38 @@ static void test_cpu_create(void)
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
+	if (!(uvcb->header.rc & UVC_RC_DSTR_NEEDED_FLG))
+		return;
+
+	assert(uvcb->guest_handle);
+
+	assert(!uv_cmd_nodata(uvcb->guest_handle, UVC_CMD_DESTROY_SEC_CONF,
+			      &rc, &rrc));
+}
+
+/* This function expects errors, not successes */
+static bool cgc_check_data(struct uv_cb_cgc *uvcb, uint16_t rc_expected)
+{
+	cgc_destroy_if_needed(uvcb);
+	/*
+	 * We should only receive a handle when the rc is 1 or the
+	 * first bit is set.
+	 */
+	if (!(uvcb->header.rc & UVC_RC_DSTR_NEEDED_FLG) && uvcb->guest_handle)
+		return false;
+	/* Now that we checked the handle, we need to zero it for the next test */
+	uvcb->guest_handle = 0;
+	return (uvcb->header.rc & ~UVC_RC_DSTR_NEEDED_FLG) == rc_expected;
+}
+
 static void test_config_create(void)
 {
 	int rc;
@@ -398,40 +430,40 @@ static void test_config_create(void)
 
 	uvcb_cgc.guest_stor_origin = uvcb_qui.max_guest_stor_addr + (1UL << 20) * 2 + 1;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x101 && rc == 1,
+	report(cgc_check_data(&uvcb_cgc, 0x101) && rc == 1,
 	       "MSO > max guest addr");
 	uvcb_cgc.guest_stor_origin = 0;
 
 	uvcb_cgc.guest_stor_origin = uvcb_qui.max_guest_stor_addr - (1UL << 20);
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x102 && rc == 1,
+	report(cgc_check_data(&uvcb_cgc, 0x102) && rc == 1,
 	       "MSO + MSL > max guest addr");
 	uvcb_cgc.guest_stor_origin = 0;
 
 	uvcb_cgc.guest_asce &= ~ASCE_P;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x105 && rc == 1,
+	report(cgc_check_data(&uvcb_cgc, 0x105) && rc == 1,
 	       "ASCE private bit missing");
 	uvcb_cgc.guest_asce |= ASCE_P;
 
 	uvcb_cgc.guest_asce |= 0x20;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x105 && rc == 1,
+	report(cgc_check_data(&uvcb_cgc, 0x105) && rc == 1,
 	       "ASCE bit 58 set");
 	uvcb_cgc.guest_asce &= ~0x20;
 
 	tmp = uvcb_cgc.conf_base_stor_origin;
 	uvcb_cgc.conf_base_stor_origin = get_max_ram_size() + 8;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x108 && rc == 1,
+	report(cgc_check_data(&uvcb_cgc, 0x108) && rc == 1,
 	       "base storage origin > available memory");
 	uvcb_cgc.conf_base_stor_origin = tmp;
 
 	tmp = uvcb_cgc.conf_base_stor_origin;
 	uvcb_cgc.conf_base_stor_origin = 0x1000;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x109 && rc == 1,
-	       "base storage origin contains lowcore");
+	report(cgc_check_data(&uvcb_cgc, 0x109) && rc == 1,
+	       "base storage origin contains lowcore %x",  uvcb_cgc.header.rc);
 	uvcb_cgc.conf_base_stor_origin = tmp;
 
 	/*
@@ -450,14 +482,14 @@ static void test_config_create(void)
 	tmp = uvcb_cgc.guest_sca;
 	uvcb_cgc.guest_sca = 0;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x10c && rc == 1,
+	report(cgc_check_data(&uvcb_cgc, 0x10c) && rc == 1,
 	       "sca == 0");
 	uvcb_cgc.guest_sca = tmp;
 
 	tmp = uvcb_cgc.guest_sca;
 	uvcb_cgc.guest_sca = get_max_ram_size() + PAGE_SIZE * 4;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
-	report(uvcb_cgc.header.rc == 0x10d && rc == 1,
+	report(cgc_check_data(&uvcb_cgc, 0x10d) && rc == 1,
 	       "sca inaccessible");
 	uvcb_cgc.guest_sca = tmp;
 
@@ -477,6 +509,7 @@ static void test_config_create(void)
 	uvcb_cgc.guest_handle = 0;
 	rc = uv_call(0, (uint64_t)&uvcb_cgc);
 	report(uvcb_cgc.header.rc >= 0x100 && rc == 1, "reuse uvcb");
+	cgc_destroy_if_needed(&uvcb_cgc);
 	uvcb_cgc.guest_handle = tmp;
 
 	/* Copy over most data from uvcb_cgc, so we have the ASCE that was used. */
@@ -494,6 +527,7 @@ static void test_config_create(void)
 	rc = uv_call(0, (uint64_t)&uvcb);
 	report(uvcb.header.rc >= 0x104 && rc == 1 && !uvcb.guest_handle,
 	       "reuse ASCE");
+	cgc_destroy_if_needed(&uvcb);
 	free((void *)uvcb.conf_base_stor_origin);
 	free((void *)uvcb.conf_var_stor_origin);
 
-- 
2.34.1

