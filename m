Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE243735168
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 12:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231476AbjFSKCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 06:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbjFSKCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 06:02:34 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E98D2E51;
        Mon, 19 Jun 2023 03:02:11 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35J8LugB028534;
        Mon, 19 Jun 2023 08:34:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=bvcXv2O6Z2cZq6PtacksfB3Jc3wsAIGIARcU/ojdVj0=;
 b=b5KUeX7hrBCRP+CoEPWzeCdTHEHj/TC0HdLw4r3IH7jp2RgHL/bnlkSbnew+pL+wstKa
 Hx0k7TgUbZRv/BHeunDW6rfExSOpZ4gXFHFk5ZBov9IsiQDBfa2dXghbN127pNIjPOPY
 TQcTGTL8M4l9zHw5P+3G8ckVDR6XP3xMEjOlpAdM20m6MAX2td8c7YrFzjcVSVAq38TF
 WodOqmPF6tMF9XfTt28M9JPXO4V63Par4nFtimg9e/epY5vbW9SV7mt4SLgxNKblJVPs
 Sfe7qWbxb97GS7iLnN2DxwIhru2b5jfke504amwbkl0TVPqEoThAZ5uYQR9WtTi1y8JH Nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3raken06uv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:34:03 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35J8Mr2E000967;
        Mon, 19 Jun 2023 08:34:03 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3raken06u1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:34:03 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35J4kk42018552;
        Mon, 19 Jun 2023 08:34:00 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3r94f50xdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 19 Jun 2023 08:34:00 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35J8XvUA36242044
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 19 Jun 2023 08:33:57 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 617152004E;
        Mon, 19 Jun 2023 08:33:57 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DE2520043;
        Mon, 19 Jun 2023 08:33:56 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon, 19 Jun 2023 08:33:56 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, david@redhat.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com
Subject: [kvm-unit-tests PATCH v5 5/8] lib: s390x: uv: Add pv host requirement check function
Date:   Mon, 19 Jun 2023 08:33:26 +0000
Message-Id: <20230619083329.22680-6-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230619083329.22680-1-frankja@linux.ibm.com>
References: <20230619083329.22680-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nibyZHTEUo8PO72DhQHC-bdbjZn720no
X-Proofpoint-GUID: Te8a1BCqarkbp_XhBJbvLGNtLB6x6a9U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-19_06,2023-06-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 bulkscore=0 clxscore=1015 mlxscore=0 impostorscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306190077
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When running PV guests some of the UV memory needs to be allocated
with > 31 bit addresses which means tests with PV guests will always
need a lot more memory than other tests.
Additionally facilities nr 158 and sclp.sief2 need to be available.

Let's add a function that checks for these requirements and prints a
helpful skip message.

Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
---
 lib/s390x/snippet.h |  7 +++++++
 lib/s390x/uv.c      | 20 ++++++++++++++++++++
 lib/s390x/uv.h      |  1 +
 s390x/pv-diags.c    |  8 +-------
 4 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet.h
index 57045994..11ec54c3 100644
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
diff --git a/lib/s390x/uv.c b/lib/s390x/uv.c
index 383271a5..4ccb7bde 100644
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
+			    SNIPPET_PV_MIN_MEM_SIZE / 1024 / 1024);
+		return false;
+	}
+
+	return true;
+}
+
 bool uv_query_test_call(unsigned int nr)
 {
 	/* Query needs to be called first */
diff --git a/lib/s390x/uv.h b/lib/s390x/uv.h
index 78b979b7..286933ca 100644
--- a/lib/s390x/uv.h
+++ b/lib/s390x/uv.h
@@ -7,6 +7,7 @@
 
 bool uv_os_is_guest(void);
 bool uv_os_is_host(void);
+bool uv_host_requirement_checks(void);
 bool uv_query_test_call(unsigned int nr);
 const struct uv_cb_qui *uv_get_query_data(void);
 void uv_init(void);
diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
index fa4e5532..3193ad99 100644
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
2.34.1

