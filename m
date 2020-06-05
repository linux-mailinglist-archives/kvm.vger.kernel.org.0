Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157531F0060
	for <lists+kvm@lfdr.de>; Fri,  5 Jun 2020 21:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgFETWl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jun 2020 15:22:41 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40758 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbgFETWl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jun 2020 15:22:41 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055JGe26071758;
        Fri, 5 Jun 2020 19:22:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=4kqUjMIG6MoQcVFyQ7OhUnBY75OV7DVs0TsTVFNlx3g=;
 b=chjEqEPn8+iRlLK+4DiIG0Oy4aAPvt/eCzuEzHVUC4Rb9BVgBBeAaoHPDiRl7hHwqBfl
 LwPh7B3KwyWytANjyDrE0e7hi8sbeZboRGZxiewm3POGgN3bovfRKejnai7wvhz3Ri+N
 tGdOMl3ecKAGzcU+gRj9X68A7JEdLf4V6UFNA+fQXngDspT0uwMfCu9XpOpsZ7hsko3h
 3K5fyoywa3uBsjLG4bP3K9Ol71SiICr6iWacm7ygd445RfLfsd6Cd72Rd4gTaaqjZMNd
 RrdPrcgtyZK7oMxFVTw8JXlDqjFrr/VhOdZXOjxO0hS8WOEh1U3GOqLfU76OcYAZGpXJ bQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 31f91dvdxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 05 Jun 2020 19:22:36 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 055JJRps108855;
        Fri, 5 Jun 2020 19:20:35 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31f92t6658-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Jun 2020 19:20:35 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 055JKYEo031279;
        Fri, 5 Jun 2020 19:20:34 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.231.182)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 05 Jun 2020 19:20:34 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 2/3 v2] kvm-unit-tests: nVMX: Optimize test_guest_dr7() by factoring out the loops into a macro
Date:   Fri,  5 Jun 2020 19:20:21 +0000
Message-Id: <1591384822-71784-3-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1591384822-71784-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1591384822-71784-1-git-send-email-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9643 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 spamscore=0 suspectscore=13 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006050142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9643 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 clxscore=1015 cotscore=-2147483648 malwarescore=0 adultscore=0
 priorityscore=1501 suspectscore=13 phishscore=0 spamscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006050141
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/vmx_tests.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 4308ef3..7dd8bfb 100644
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

