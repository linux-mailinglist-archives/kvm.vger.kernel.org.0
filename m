Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38376194E3
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 23:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727018AbfEIVrV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 17:47:21 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48982 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbfEIVrV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 17:47:21 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49LiW4C185806;
        Thu, 9 May 2019 21:46:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=+F+FCY9mN8hViyTt7kvXJOtNkLlGIXGm8si6xkeP1zA=;
 b=ReTgKLgFpmX+OvSXavDz8rtvGoJzU0PvKiFyFYgz0qwtyNXuo3/WZRug9GSSXOKui9kS
 +eDeWx0IXd945mVTOggfMKnqIgxUBcjuaf+HhFQJmIA6wLVTj0sClVEELg7GKXYxJTeO
 +Z4YHTxLu+8uvvyciiTCTyAUrd91SZDjgwCiLwP2S7QFmmlrO938aPDAOtHU4wSRnZmB
 nKBd0x08q1mV1Kc0oNrUEdCp42hutMpd6vvLS5YY2Q3CA8HWw6pSGvFxehapuXhpfKHo
 Qpeay/TmP16UimMoIOHUrTN5cgNYLuyEZ3xy5PuMEjMNeuVOVkLRiTW0766wW6KJcULP aA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2s94b15nkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 May 2019 21:46:59 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x49LjPYw124632;
        Thu, 9 May 2019 21:46:59 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2s94ah1nm9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 May 2019 21:46:59 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x49Lkw3x012754;
        Thu, 9 May 2019 21:46:58 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 09 May 2019 14:46:58 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 4/4][kvm-unit-test nVMX]: Test "load IA32_PERF_GLOBAL_CONTROL" VM-entry control on vmentry of nested guests
Date:   Thu,  9 May 2019 17:20:55 -0400
Message-Id: <20190509212055.29933-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190509212055.29933-1-krish.sadhukhan@oracle.com>
References: <20190509212055.29933-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905090123
X-Proofpoint-Virus-Version: vendor=nai engine=5900 definitions=9252 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905090123
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 ..to verify KVM performs the appropriate consistency checks for loading
   IA32_PERF_GLOBAL_CONTROL as part of running a nested guest.

According to section "Checking and Loading Guest State" in Intel SDM
vol 3C, the following check is performed on vmentry:

   If the "load IA32_PERF_GLOBAL_CTRL" VM-exit control is 1, bits reserved
   in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the field for that register.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx_tests.c | 82 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 71 insertions(+), 11 deletions(-)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index a339bb3..65772ce 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5031,29 +5031,69 @@ static void test_perf_global_ctl(u32 field, const char * field_name,
 	u64 perf_global_saved = vmcs_read(field);
 	u64 i, val;
 
+	if (field == GUEST_PERF_GLOBAL_CTRL) {
+		vmx_set_test_stage(1);
+		test_set_guest(guest_state_test_main);
+	}
+
 	vmcs_write(ctrl_field, ctrl_saved & ~ctrl_bit);
 	for (i = 0; i < 64; i++) {
 		val = 1ull << i;
 		vmcs_write(field, val);
-		report_prefix_pushf("\"load IA32_PERF_GLOBAL_CTRL\" "
-		    "VM-exit control is off, HOST_PERF_GLOBAL_CTRL %lx", val);
-		test_vmx_vmlaunch(0, false);
-		report_prefix_pop();
+		if (field == HOST_PERF_GLOBAL_CTRL) {
+			report_prefix_pushf("\"load IA32_PERF_GLOBAL_CTRL\" "
+					    "VM-exit control is off, "
+					    "HOST_PERF_GLOBAL_CTRL %lx", val);
+			test_vmx_vmlaunch(0, false);
+			report_prefix_pop();
+		} else {        // GUEST_PERF_GLOBAL_CTRL
+			enter_guest();
+			report_guest_state_test("ENT_LOAD_PERF disabled",
+						 VMX_VMCALL, val,
+						"GUEST_PERF_GLOBAL_CTRL");
+		}
 	}
 
 	vmcs_write(ctrl_field, ctrl_saved | ctrl_bit);
 	for (i = 0; i < 64; i++) {
 		val = 1ull << i;
 		vmcs_write(field, val);
-		report_prefix_pushf("\"load IA32_PERF_GLOBAL_CTRL\" "
-		    "VM-exit control is on, HOST_PERF_GLOBAL_CTRL %lx", val);
-		if (PERF_GLOBAL_CTRL_VALID_BITS & (1ull << i)) {
-			test_vmx_vmlaunch(0, false);
-		} else {
-			test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
-					  false);
+		if (field == HOST_PERF_GLOBAL_CTRL) {
+			report_prefix_pushf("\"load IA32_PERF_GLOBAL_CTRL\" "
+			"VM-exit control is on, HOST_PERF_GLOBAL_CTRL %lx",
+			val);
+			if (PERF_GLOBAL_CTRL_VALID_BITS & (1ull << i)) {
+				test_vmx_vmlaunch(0, false);
+			} else {
+				test_vmx_vmlaunch(
+					VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
+					false);
 		}
 		report_prefix_pop();
+		} else {        // GUEST_PERF_GLOBAL_CTRL
+			enter_guest();
+			if (PERF_GLOBAL_CTRL_VALID_BITS & (1ull << i)) {
+				report_guest_state_test("ENT_LOAD_PERF enabled",
+						VMX_FAIL_STATE |
+						VMX_ENTRY_FAILURE,
+						val,
+						"GUEST_PERF_GLOBAL_CTRL");
+			} else {
+				report_guest_state_test("ENT_LOAD_PERF enabled",
+						VMX_VMCALL,
+						val,
+						"GUEST_PERF_GLOBAL_CTRL");
+			}
+		}
+	}
+
+	if (field == GUEST_PERF_GLOBAL_CTRL) {
+		/*
+		 * Let the guest finish execution
+		 */
+		vmx_set_test_stage(2);
+		vmcs_write(field, perf_global_saved);
+		enter_guest();
 	}
 
 	vmcs_write(ctrl_field, ctrl_saved);
@@ -5079,6 +5119,25 @@ static void test_host_perf_global_ctl(void)
 			     EXI_CONTROLS, EXI_LOAD_PERF);
 }
 
+/*
+ * If the "load IA32_PERF_GLOBAL_CTRL" VM-entry control is 1, bits reserved
+ * in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the field for that
+ * register.
+ *
+ *  [Intel SDM]
+ */
+static void test_guest_perf_global_ctl(void)
+{
+	if (!(ctrl_exit_rev.clr & ENT_LOAD_PERF)) {
+		printf("\"load IA32_PERF_GLOBAL_CTRL\" VM-entry control not "
+			"supported\n");
+		return;
+	}
+
+	test_perf_global_ctl(GUEST_PERF_GLOBAL_CTRL, "GUEST_PERF_GLOBAL_CTRL",
+			     ENT_CONTROLS, ENT_LOAD_PERF);
+}
+
 /*
  * PAT values higher than 8 are uninteresting since they're likely lumped
  * in with "8". We only test values above 8 one bit at a time,
@@ -5243,6 +5302,7 @@ static void test_load_guest_pat(void)
  */
 static void vmx_guest_state_area_test(void)
 {
+	test_guest_perf_global_ctl();
 	test_load_guest_pat();
 }
 
-- 
2.20.1

