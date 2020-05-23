Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E15B01DF3C1
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 03:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387465AbgEWBJM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 21:09:12 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:41946 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387427AbgEWBJM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 21:09:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N18EAL104070;
        Sat, 23 May 2020 01:09:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=N/SrwxTYPSrc6MLiJ/PyaDtJ37vMII8cDYkNARaK814=;
 b=VhBku3K+ne7oPscxjdtfSsXQ36P7bI/FL9wi1VkCsNOGcYkQLYDd/HjUDuy7cWe6akVv
 w1K/0qjjcsozgxYk1Pr+c6wK/PbW3omj5OSvZ6Zi/AGOv1tIsPI7UWtb6+SIt9U5BbCR
 NrFvVDltbH6thJbyNDMoZFk9en9pxB3iZuOQ50JckD9xKUL3RpzYuEfruQ6KbsUteQTY
 Xot733Fxn88xyEN0LVeaYSo0u4GAe4Z9i1W5eSRv+QfPCYGgeQJhGXW9AaSve4kuS8kc
 tI1FF4urx3/SrcCwn2MOJUl6j45Cq1lk0amtq0cJUz15ISjf7eElXmSZuui0xq9Pw96C bQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 316qrvr7du-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 23 May 2020 01:09:06 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04N13I1R167160;
        Sat, 23 May 2020 01:07:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 312t3g8aby-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 May 2020 01:07:05 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04N174P8029335;
        Sat, 23 May 2020 01:07:04 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 18:07:04 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 2/3] kvm-unit-tests: nVMX: Optimize test_guest_dr7() by factoring out the loops into a macro
Date:   Fri, 22 May 2020 20:26:02 -0400
Message-Id: <20200523002603.32450-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200523002603.32450-1-krish.sadhukhan@oracle.com>
References: <20200523002603.32450-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=13 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230005
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 cotscore=-2147483648 suspectscore=13 adultscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005230006
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/vmx_tests.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index fa27d99..f400408 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7704,6 +7704,19 @@ static void vmx_host_state_area_test(void)
 	test_load_host_perf_global_ctrl();
 }
 
+#define TEST_GUEST_VMCS_FIELD_RESERVED_BITS(start, end, inc, fld, str_name,\
+					    val, msg, xfail)		\
+{									\
+	u64 tmp;							\
+	int i;								\
+									\
+	for (i = start; i <= end; i = i + inc) {			\
+		tmp = val | (1ull << i);				\
+		vmcs_write(fld, tmp);					\
+		test_guest_state(msg, xfail, val, str_name);		\
+	}								\
+}
+
 /*
  * If the "load debug controls" VM-entry control is 1, bits 63:32 in
  * the DR7 field must be 0.
@@ -7714,26 +7727,17 @@ static void test_guest_dr7(void)
 {
 	u32 ent_saved = vmcs_read(ENT_CONTROLS);
 	u64 dr7_saved = vmcs_read(GUEST_DR7);
-	u64 val;
-	int i;
 
 	if (ctrl_enter_rev.set & ENT_LOAD_DBGCTLS) {
-		vmcs_clear_bits(ENT_CONTROLS, ENT_LOAD_DBGCTLS);
-		for (i = 0; i < 64; i++) {
-			val = 1ull << i;
-			vmcs_write(GUEST_DR7, val);
-			test_guest_state("ENT_LOAD_DBGCTLS disabled", false,
-					 val, "GUEST_DR7");
-		}
+		vmcs_write(ENT_CONTROLS, ent_saved & ~ENT_LOAD_DBGCTLS);
+		TEST_GUEST_VMCS_FIELD_RESERVED_BITS(0, 63, 4, GUEST_DR7,
+		    "GUEST_DR7", dr7_saved, "ENT_LOAD_DBGCTLS disabled", false);
 	}
 	if (ctrl_enter_rev.clr & ENT_LOAD_DBGCTLS) {
-		vmcs_set_bits(ENT_CONTROLS, ENT_LOAD_DBGCTLS);
-		for (i = 0; i < 64; i++) {
-			val = 1ull << i;
-			vmcs_write(GUEST_DR7, val);
-			test_guest_state("ENT_LOAD_DBGCTLS enabled", i >= 32,
-					 val, "GUEST_DR7");
-		}
+		vmcs_write(ENT_CONTROLS, ent_saved | ENT_LOAD_DBGCTLS);
+		TEST_GUEST_VMCS_FIELD_RESERVED_BITS(0, 63, 4, GUEST_DR7,
+		    "GUEST_DR7", dr7_saved, "ENT_LOAD_DBGCTLS enabled",
+		    i >= 32);
 	}
 	vmcs_write(GUEST_DR7, dr7_saved);
 	vmcs_write(ENT_CONTROLS, ent_saved);
-- 
1.8.3.1

