Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FC46F43A5
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 14:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233890AbjEBMVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 08:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbjEBMVh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 08:21:37 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 530835B87;
        Tue,  2 May 2023 05:21:34 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 342CDwdQ030003;
        Tue, 2 May 2023 12:21:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=ZoLPSF54egz3pXp6gB64dawT8dpYYuV/s+0uGXqgr0A=;
 b=hR2t0ZZ33VLSKYcfwMS2texCNSBIqhppDrhON/hA8A7zSzhWyPThW4MrWRCK68+TX3+x
 ttL8zAVViPWRa3XHQtUNbqyepNUgyckNW5c567oRh1XRVs81GrADcTaKuGPanuPd94Lh
 nCbspPRQo8sWoyJnyJxjSD0sJ3vnBFlEz1IsBbWYsA5I+7CF4xrmf3gg0mTP1MCXYPYZ
 07bvagGe7G8ut1MJ1O14swX01VfmQx50EH9zmrEK5qcgG0Vj8iwl1ZjQ4aabgGVTWeV8
 L6ub+UUs6ASkO5TOsh1pvJzn09SIh1pXDjTeqD+s26S0Z0xXQDvDujGDX2XfIz9k19HK hA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qaxx6p3v1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:21:33 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 342C91B2024493;
        Tue, 2 May 2023 12:21:33 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qaxx6p3p7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:21:33 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3427i7Mn009764;
        Tue, 2 May 2023 12:00:50 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3q8tv6s9n2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 May 2023 12:00:49 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 342C0kj245154760
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 May 2023 12:00:46 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4C9EE20043;
        Tue,  2 May 2023 12:00:46 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C8AE20040;
        Tue,  2 May 2023 12:00:45 +0000 (GMT)
Received: from linux6.. (unknown [9.114.12.104])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  2 May 2023 12:00:45 +0000 (GMT)
From:   Janosch Frank <frankja@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        thuth@redhat.com, nrb@linux.ibm.com, david@redhat.com
Subject: [kvm-unit-tests PATCH v4 4/7] lib: s390x: uv: Add pv host requirement check function
Date:   Tue,  2 May 2023 11:59:28 +0000
Message-Id: <20230502115931.86280-5-frankja@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230502115931.86280-1-frankja@linux.ibm.com>
References: <20230502115931.86280-1-frankja@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 8oF7hoOhxoymEYOFGLPMLdiq6Hsk4Mzg
X-Proofpoint-ORIG-GUID: _s17CP9Vh4Skk3-3fgxeHevUosWnUMB1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-02_05,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 impostorscore=0
 phishscore=0 mlxscore=0 clxscore=1015 adultscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305020103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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

