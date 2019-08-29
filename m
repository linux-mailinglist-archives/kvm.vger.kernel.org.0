Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0CBEA28F2
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 23:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfH2Van (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 17:30:43 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:34508 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbfH2Van (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 17:30:43 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLO3tr165245;
        Thu, 29 Aug 2019 21:30:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=X4ABRb8q9I95EvfJNm9IASRVplJlfj79UvEr9Wjpvv4=;
 b=nvZnMdcOsLiCFG2RadfYXQ8eT5h7Tsyg/Mrr7MBAjeZ3N5LsXAxDztLU6MRUBGi1wAPr
 Te4ABZeeZt8eW4DYiyaRkfrIaCjVh1gSBoGwgtPtyKrrpzFgVJ0asU8NBiSYWKGBb6cU
 M1dvx88e70tKhKite4CM8tt02QvBZm3/sCddPwgnds+x488G/1aRCQMM4sa0piN/7oYP
 IRy4BRgYNPN8U2kTtPnnDyOPLxuTS3Ibpku3TMDp21hRBZ80F90ut3yQc7858PZ8KUz5
 FDtMB+OPhCeDriLGdKsqt6+ZHlwG5K3X2EoTMlogKHVOD0kdzZN/YYPuJkAMEN9nqSHs KQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uppjc01bb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:30:21 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7TLE77k018405;
        Thu, 29 Aug 2019 21:25:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2unvu0mb9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Aug 2019 21:25:20 +0000
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7TLPJKm027470;
        Thu, 29 Aug 2019 21:25:19 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Aug 2019 14:25:19 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 4/4] kvm-unit-test: nVMX: Check GUEST_DEBUGCTL and GUEST_DR7 on vmentry of nested guests
Date:   Thu, 29 Aug 2019 16:56:35 -0400
Message-Id: <20190829205635.20189-5-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=695
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908290214
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9364 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=757 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908290215
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks on Guest Control Registers, Debug Registers, and
and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
of nested guests:

    If the "load debug controls" VM-entry control is 1,

       - bits reserved in the IA32_DEBUGCTL MSR must be 0 in the field for
         that register. The first processors to support the virtual-machine
         extensions supported only the 1-setting of this control and thus
         performed this check unconditionally.

       - bits 63:32 in the DR7 field must be 0.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx_tests.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 8ad2674..0207caf 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7154,6 +7154,64 @@ static void test_load_guest_pat(void)
 	test_pat(GUEST_PAT, "GUEST_PAT", ENT_CONTROLS, ENT_LOAD_PAT);
 }
 
+/*
+ * If the “load debug controls” VM-entry control is 1,
+ *
+ *   - bits reserved in the IA32_DEBUGCTL MSR must be 0 in the field for
+ *     that register.
+ *   - bits 63:32 in the DR7 field must be 0.
+ */
+static void test_debugctl(void)
+{
+	u64 debugctl_saved = vmcs_read(GUEST_DEBUGCTL);
+	u32 entry_ctl_saved = vmcs_read(ENT_CONTROLS);
+	u64 tmp;
+	int i;
+	u64 dr7_saved = vmcs_read(GUEST_DR7);
+
+	if (!(ctrl_exit_rev.clr & ENT_LOAD_DBGCTLS)) {
+		printf("\"IA32_DEBUGCTL\" VM-entry control not supported\n");
+		return;
+	}
+
+	vmx_set_test_stage(1);
+	test_set_guest(guest_state_test_main);
+
+#define	DEBUGCTL_RESERVED_BITS	0xFFFFFFFFFFFF203C
+
+	if (!(entry_ctl_saved & ENT_LOAD_DBGCTLS))
+		vmcs_write(ENT_CONTROLS, entry_ctl_saved | ENT_LOAD_DBGCTLS);
+
+	for (i = 2; i < 32; (i >= 16 ? i = i + 4 : i++)) {
+		if (!((1 << i) & DEBUGCTL_RESERVED_BITS))
+			continue;
+		tmp = debugctl_saved | (1 << i);
+		vmcs_write(GUEST_DEBUGCTL, tmp);
+		enter_guest_with_invalid_guest_state();
+		report_guest_state_test("ENT_LOAD_DBGCTLS enabled",
+				        VMX_FAIL_STATE | VMX_ENTRY_FAILURE,
+				        tmp, "GUEST_DEBUGCTL");
+	}
+
+	for (i = 32; i < 64; i = i + 4) {
+		tmp = dr7_saved | (1ull << i);
+		vmcs_write(GUEST_DR7, tmp);
+		enter_guest_with_invalid_guest_state();
+		report_guest_state_test("ENT_LOAD_DBGCTLS enabled",
+				        VMX_FAIL_STATE | VMX_ENTRY_FAILURE,
+				        tmp, "GUEST_DR7");
+	}
+
+	/*
+	 * Let the guest finish execution
+	 */
+	vmx_set_test_stage(2);
+	vmcs_write(GUEST_DEBUGCTL, debugctl_saved);
+	vmcs_write(ENT_CONTROLS, entry_ctl_saved);
+	vmcs_write(GUEST_DR7, dr7_saved);
+	enter_guest();
+}
+
 /*
  * Check that the virtual CPU checks the VMX Guest State Area as
  * documented in the Intel SDM.
@@ -7161,6 +7219,7 @@ static void test_load_guest_pat(void)
 static void vmx_guest_state_area_test(void)
 {
 	test_load_guest_pat();
+	test_debugctl();
 }
 
 static bool valid_vmcs_for_vmentry(void)
-- 
2.20.1

