Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E9A74F194
	for <lists+kvm@lfdr.de>; Tue, 11 Jul 2023 16:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233551AbjGKORJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jul 2023 10:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjGKORB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jul 2023 10:17:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2791738
        for <kvm@vger.kernel.org>; Tue, 11 Jul 2023 07:16:46 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36BDlnr8027343;
        Tue, 11 Jul 2023 14:16:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : content-transfer-encoding
 : mime-version; s=pp1; bh=Jvmqtgnsg94K1mBm3bXsB2cNFDN8HY6UyGkWbODMrZ8=;
 b=qEFvSwCIIpYs2PAI5B7wRGRzlTJD9vxdTI+2SX2iWQlhEgQFoWIcCz71P3qeAhDcfL+F
 i1mjC5NqSHilTqeESWwzFcDcssZJTJB27X/10TEtFPj+T7lvZJvUX7zlRcOQlyTu3t8B
 isT/EgJZ+83+vLJezw26g+5864oGxjol/NoCERb9S+seeb8wl4A1xrTdzStfsw9omf4n
 FKFnq1o73eUDZCB2GE9WTISPYDXrKIAdsSaRnCjdIAcu+IJrFiGbRyXnPufeEksw14ud
 srITyLG+7HG9C00Hwy2kt7Mwujw+mXFc73sYaiPMD+XaNq9JOtgROb726usTLFNNNHBY eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs89a13qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:43 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36BE59qJ024685;
        Tue, 11 Jul 2023 14:16:33 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rs89a13dx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:33 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36B5uOlu030259;
        Tue, 11 Jul 2023 14:16:17 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3rpye59tu0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jul 2023 14:16:17 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36BEGEUX35193276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 14:16:14 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32F332004D;
        Tue, 11 Jul 2023 14:16:14 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B68692004B;
        Tue, 11 Jul 2023 14:16:13 +0000 (GMT)
Received: from t14-nrb.ibmuc.com (unknown [9.171.51.229])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jul 2023 14:16:13 +0000 (GMT)
From:   Nico Boehr <nrb@linux.ibm.com>
To:     thuth@redhat.com, pbonzini@redhat.com, andrew.jones@linux.dev
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com
Subject: [PATCH 07/22] lib: s390x: uv: Add pv host requirement check function
Date:   Tue, 11 Jul 2023 16:15:40 +0200
Message-ID: <20230711141607.40742-8-nrb@linux.ibm.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230711141607.40742-1-nrb@linux.ibm.com>
References: <20230711141607.40742-1-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: C5ecVjaNeOJbGoIgln-ZfCXX4gTEGQye
X-Proofpoint-ORIG-GUID: dg1_xFovjnTtfJ5iewPiRyg-S5J1s122
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-11_08,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 suspectscore=0 bulkscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 mlxscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110127
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Janosch Frank <frankja@linux.ibm.com>

When running PV guests some of the UV memory needs to be allocated
with > 31 bit addresses which means tests with PV guests will always
need a lot more memory than other tests.
Additionally facilities nr 158 and sclp.sief2 need to be available.

Let's add a function that checks for these requirements and prints a
helpful skip message.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Link: https://lore.kernel.org/r/20230619083329.22680-6-frankja@linux.ibm.com
[ nrb: replace 1024*1024 with SZ_1M as requested by author ]
Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/snippet.h |  7 +++++++
 lib/s390x/uv.h      |  1 +
 lib/s390x/uv.c      | 20 ++++++++++++++++++++
 s390x/pv-diags.c    |  8 +-------
 4 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
index 5704599..11ec54c 100644
--- a/lib/s390x/snippet.h
+++ b/lib/s390x/snippet.h
@@ -30,6 +30,13 @@
 #define SNIPPET_HDR_LEN(type, file) \
 	((uintptr_t)SNIPPET_HDR_END(type, file) - (uintptr_t)SNIPPET_HDR_START(type, file))
 
+/*
+ * Some of the UV memory needs to be allocated with >31 bit
+ * addresses which means we need a lot more memory than other
+ * tests.
+ */
+#define SNIPPET_PV_MIN_MEM_SIZE	(SZ_1M * 2200UL)
+
 #define SNIPPET_PV_TWEAK0	0x42UL
 #define SNIPPET_PV_TWEAK1	0UL
 #define SNIPPET_UNPACK_OFF	0
diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 78b979b..286933c 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -7,6 +7,7 @@
 
 bool uv_os_is_guest(void);
 bool uv_os_is_host(void);
+bool uv_host_requirement_checks(void);
 bool uv_query_test_call(unsigned int nr);
 const struct uv_cb_qui *uv_get_query_data(void);
 void uv_init(void);
diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index 383271a..23a8617 100644
--- a/lib/s390x/uv.c
+++ b/lib/s390x/uv.c
@@ -18,6 +18,7 @@
 #include <asm/uv.h>
 #include <uv.h>
 #include <sie.h>
+#include <snippet.h>
 
 static struct uv_cb_qui uvcb_qui = {
 	.header.cmd = UVC_CMD_QUI,
@@ -38,6 +39,25 @@ bool uv_os_is_host(void)
 	return test_facility(158) && uv_query_test_call(BIT_UVC_CMD_INIT_UV);
 }
 
+bool uv_host_requirement_checks(void)
+{
+	if (!test_facility(158)) {
+		report_skip("UV Call facility unavailable");
+		return false;
+	}
+	if (!sclp_facilities.has_sief2) {
+		report_skip("SIEF2 facility unavailable");
+		return false;
+	}
+	if (get_ram_size() < SNIPPET_PV_MIN_MEM_SIZE) {
+		report_skip("Not enough memory. This test needs about %ld MB of memory",
+			    SNIPPET_PV_MIN_MEM_SIZE / SZ_1M);
+		return false;
+	}
+
+	return true;
+}
+
 bool uv_query_test_call(unsigned int nr)
 {
 	/* Query needs to be called first */
diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index fa4e553..3193ad9 100644
--- a/s390x/pv-diags.c
+++ b/s390x/pv-diags.c
@@ -149,14 +149,8 @@ static void test_diag_yield(void)
 int main(void)
 {
 	report_prefix_push("pv-diags");
-	if (!test_facility(158)) {
-		report_skip("UV Call facility unavailable");
+	if (!uv_host_requirement_checks())
 		goto done;
-	}
-	if (!sclp_facilities.has_sief2) {
-		report_skip("SIEF2 facility unavailable");
-		goto done;
-	}
 
 	uv_setup_asces();
 	snippet_setup_guest(&vm, true);
-- 
2.41.0

