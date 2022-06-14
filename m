Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3644354B418
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 17:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355812AbiFNPBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 11:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245462AbiFNPBA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 11:01:00 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889C2427C4
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:00:57 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25EEqRqQ012596
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:00:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=pp1;
 bh=3KPfgaw2WEAv5uk+yYe4g5XQRXQ6kxDZ6VOTD9Ieasw=;
 b=pKNyoWHjmxIFp+fjdEISgLLJrpwyA2aXN1TJV9wwNTlc7NxenKiQu/6yxDKNVAunSWFm
 BAatU93wjagX5ffiD8Pxc2r4xU+qzDK9MJt7FSWQffE56cfGAOgKenVUPNFARzUGfUbt
 e5Mx1hAo/qgiAe9TvkS/37SFKpWlvRYDWRMs8ParRvZt4vBTlHgBhJUKXr97VVt3zVt+
 Dh81bRX4n5tsH2RDsxyFpiBMyVwGsnaCzfelcZMjiudYDVWdbGnxklSMSG7znx2IS7nD
 iSxKVx7dzbKzubQ2sO9+ZaDp95alflJhXjZSI4at2MP2Hywdzc1LY8MGa70E1UrTBi26 fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gppp4m3ex-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:00:56 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25EErHxM020355
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 15:00:56 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3gppp4m3dj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 15:00:56 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25EEpGIO001684;
        Tue, 14 Jun 2022 15:00:54 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3gmjp8ugtt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 14 Jun 2022 15:00:54 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25EF0pw423331172
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Jun 2022 15:00:51 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 505E042045;
        Tue, 14 Jun 2022 15:00:51 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC81E4204C;
        Tue, 14 Jun 2022 15:00:50 +0000 (GMT)
Received: from p-imbrenda.ibmuc.com (unknown [9.145.3.94])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 14 Jun 2022 15:00:50 +0000 (GMT)
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, thuth@redhat.com, frankja@linux.ibm.com,
        Nico Boehr <nrb@linux.ibm.com>
Subject: [kvm-unit-tests GIT PULL 1/5] lib: s390x: add header for CMM related defines
Date:   Tue, 14 Jun 2022 17:00:45 +0200
Message-Id: <20220614150049.55787-2-imbrenda@linux.ibm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614150049.55787-1-imbrenda@linux.ibm.com>
References: <20220614150049.55787-1-imbrenda@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: W_X8X46U47kVlW1IDDdFlaFVPgjg4KFA
X-Proofpoint-GUID: z3Sr_mMS-DS3yfRZR7enIJKqq94Agrax
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-14_05,2022-06-13_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=729 priorityscore=1501 impostorscore=0
 suspectscore=0 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206140057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nico Boehr <nrb@linux.ibm.com>

Since we're going to need the definitions in an upcoming migration test for CMM,
add a header for CMM related defines. It is based on
arch/s390/include/asm/page-states.h from linux.

While at it, use the constants in existing calls to CMM related functions.

Also move essa() and test_availability() there to be able to use it outside
cmm.c.

Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
---
 lib/s390x/asm/cmm.h | 50 +++++++++++++++++++++++++++++++++++++++++++++
 s390x/cmm.c         | 25 +++--------------------
 2 files changed, 53 insertions(+), 22 deletions(-)
 create mode 100644 lib/s390x/asm/cmm.h

diff --git a/lib/s390x/asm/cmm.h b/lib/s390x/asm/cmm.h
new file mode 100644
index 00000000..554a6003
--- /dev/null
+++ b/lib/s390x/asm/cmm.h
@@ -0,0 +1,50 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ *    Copyright IBM Corp. 2017, 2022
+ *    Author(s): Claudio Imbrenda <imbrenda@linux.vnet.ibm.com>
+ *               Nico Boehr <nrb@linux.ibm.com>
+ */
+#include <asm/interrupt.h>
+
+#ifndef PAGE_STATES_H
+#define PAGE_STATES_H
+
+#define ESSA_GET_STATE			0
+#define ESSA_SET_STABLE			1
+#define ESSA_SET_UNUSED			2
+#define ESSA_SET_VOLATILE		3
+#define ESSA_SET_POT_VOLATILE		4
+#define ESSA_SET_STABLE_RESIDENT	5
+#define ESSA_SET_STABLE_IF_RESIDENT	6
+#define ESSA_SET_STABLE_NODAT		7
+
+#define ESSA_MAX	ESSA_SET_STABLE_NODAT
+
+#define ESSA_USAGE_STABLE		0
+#define ESSA_USAGE_UNUSED		1
+#define ESSA_USAGE_POT_VOLATILE		2
+#define ESSA_USAGE_VOLATILE		3
+
+static unsigned long essa(uint8_t state, unsigned long paddr)
+{
+	uint64_t extr_state;
+
+	asm volatile(".insn rrf,0xb9ab0000,%[extr_state],%[addr],%[new_state],0" \
+			: [extr_state] "=d" (extr_state) \
+			: [addr] "a" (paddr), [new_state] "i" (state));
+
+	return (unsigned long)extr_state;
+}
+
+/*
+ * Unfortunately the availability is not indicated by stfl bits, but
+ * we have to try to execute it and test for an operation exception.
+ */
+static inline bool check_essa_available(void)
+{
+	expect_pgm_int();
+	essa(ESSA_GET_STATE, 0);
+	return clear_pgm_int() == 0;
+}
+
+#endif
diff --git a/s390x/cmm.c b/s390x/cmm.c
index c3f0c931..af852838 100644
--- a/s390x/cmm.c
+++ b/s390x/cmm.c
@@ -12,19 +12,10 @@
 #include <asm/asm-offsets.h>
 #include <asm/interrupt.h>
 #include <asm/page.h>
+#include <asm/cmm.h>
 
 static uint8_t pagebuf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
 
-static unsigned long essa(uint8_t state, unsigned long paddr)
-{
-	uint64_t extr_state;
-
-	asm volatile(".insn rrf,0xb9ab0000,%[extr_state],%[addr],%[new_state],0"
-			: [extr_state] "=d" (extr_state)
-			: [addr] "a" (paddr), [new_state] "i" (state));
-	return (unsigned long)extr_state;
-}
-
 static void test_params(void)
 {
 	report_prefix_push("invalid ORC 8");
@@ -39,24 +30,14 @@ static void test_priv(void)
 	report_prefix_push("privileged");
 	expect_pgm_int();
 	enter_pstate();
-	essa(0, (unsigned long)pagebuf);
+	essa(ESSA_GET_STATE, (unsigned long)pagebuf);
 	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
 	report_prefix_pop();
 }
 
-/* Unfortunately the availability is not indicated by stfl bits, but
- * we have to try to execute it and test for an operation exception.
- */
-static bool test_availability(void)
-{
-	expect_pgm_int();
-	essa(0, (unsigned long)pagebuf);
-	return clear_pgm_int() == 0;
-}
-
 int main(void)
 {
-	bool has_essa = test_availability();
+	bool has_essa = check_essa_available();
 
 	report_prefix_push("cmm");
 	if (!has_essa) {
-- 
2.36.1

