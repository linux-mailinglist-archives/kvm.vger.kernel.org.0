Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE263187764
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 02:21:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733127AbgCQBVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Mar 2020 21:21:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57960 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733101AbgCQBVx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Mar 2020 21:21:53 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02H1Hawe179121;
        Tue, 17 Mar 2020 01:21:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pfIwU/PXEpuf5XuEm6c4PZ/De0gyTs4w+BvLHNHU4bQ=;
 b=t7zvSEMYIfsYYfK5eOqCkVMiunCD+HP4HInEx04d4GuGtBZHs/E4QPz7GWGe1lXj+an+
 t2qf+fnPDhwvvA53zGJlrJKf1xZAtlQ86eNS8mzWaixJb4fQDVnH1vknmFkwMShgLmYj
 hwSy/z4TMCFJ2bqGlhhxFmgP8fuyY0llNqAeq0s5TTxbhd/hdDrhJ5uYZsEQHUd7IGua
 SY9Lz+hL3/t5UIf5DGteQ0pmEVrmJlYjz9Smq5mYiYm8sXaATXIh3h5FDh/9TojWVFq2
 /5q/IkbdMO7ENMalySwvfcLX67oCC4nsYZkurIs59E5OElBBwNEK1uZgQbLPbX91dmj7 Yw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2yrqwn1w3v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 01:21:48 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02H1KgXg064756;
        Tue, 17 Mar 2020 01:21:47 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ys8tqs4tg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Mar 2020 01:21:47 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02H1LkmN008354;
        Tue, 17 Mar 2020 01:21:46 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.231.182)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 16 Mar 2020 18:21:46 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 2/2] kvm-unit-test: nVMX: Test GUEST_BNDCFGS VM-Entry control on vmentry of nested guests
Date:   Tue, 17 Mar 2020 01:21:35 +0000
Message-Id: <1584408095-16591-3-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584408095-16591-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1584408095-16591-1-git-send-email-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 malwarescore=0 suspectscore=13 mlxlogscore=999 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003170003
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9562 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 mlxlogscore=999
 mlxscore=0 bulkscore=0 phishscore=0 spamscore=0 suspectscore=13
 malwarescore=0 priorityscore=1501 clxscore=1015 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003170003
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks on Guest Control Registers, Debug Registers,
and MSRs" in Intel SDM vol 3C, the following checks are performed on
vmentry of nested guests:

    If the "load IA32_BNDCFGS" VM-entry control is 1, the following
    checks are performed on the field for the IA32_BNDCFGS MSR:

      —  Bits reserved in the IA32_BNDCFGS MSR must be 0.
      —  The linear address in bits 63:12 must be canonical.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/vmx_tests.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index a7abd63..5ea15d0 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7681,6 +7681,58 @@ static void test_load_guest_pat(void)
 	test_pat(GUEST_PAT, "GUEST_PAT", ENT_CONTROLS, ENT_LOAD_PAT);
 }
 
+#define MSR_IA32_BNDCFGS_RSVD_MASK	0x00000ffc
+
+/*
+ * If the “load IA32_BNDCFGS” VM-entry control is 1, the following
+ * checks are performed on the field for the IA32_BNDCFGS MSR:
+ *
+ *   —  Bits reserved in the IA32_BNDCFGS MSR must be 0.
+ *   —  The linear address in bits 63:12 must be canonical.
+ *
+ *  [Intel SDM]
+ */
+static void test_load_guest_bndcfgs(void)
+{
+	u64 bndcfgs_saved = vmcs_read(GUEST_BNDCFGS);
+	u64 bndcfgs;
+
+	if (!(ctrl_enter_rev.clr & ENT_LOAD_BNDCFGS)) {
+		printf("\"Load-IA32-BNDCFGS\" entry control not supported\n");
+		return;
+	}
+
+	vmcs_clear_bits(ENT_CONTROLS, ENT_LOAD_BNDCFGS);
+
+	vmcs_write(GUEST_BNDCFGS, NONCANONICAL);
+	enter_guest();
+	report_guest_state_test("ENT_LOAD_BNDCFGS disabled",
+				VMX_VMCALL, NONCANONICAL, "GUEST_BNDCFGS");
+
+	bndcfgs = bndcfgs_saved | MSR_IA32_BNDCFGS_RSVD_MASK;
+	vmcs_write(GUEST_BNDCFGS, bndcfgs);
+	enter_guest();
+	report_guest_state_test("ENT_LOAD_BNDCFGS disabled",
+				VMX_VMCALL, bndcfgs, "GUEST_BNDCFGS");
+
+	vmcs_set_bits(ENT_CONTROLS, ENT_LOAD_BNDCFGS);
+
+	vmcs_write(GUEST_BNDCFGS, NONCANONICAL);
+	enter_guest_with_invalid_guest_state();
+	report_guest_state_test("ENT_LOAD_BNDCFGS enabled",
+				VMX_FAIL_STATE | VMX_ENTRY_FAILURE,
+				NONCANONICAL, "GUEST_BNDCFGS");
+
+	bndcfgs = bndcfgs_saved | MSR_IA32_BNDCFGS_RSVD_MASK;
+	vmcs_write(GUEST_BNDCFGS, bndcfgs);
+	enter_guest_with_invalid_guest_state();
+	report_guest_state_test("ENT_LOAD_BNDCFGS enabled",
+				VMX_FAIL_STATE | VMX_ENTRY_FAILURE, bndcfgs,
+				"GUEST_BNDCFGS");
+
+	vmcs_write(GUEST_BNDCFGS, bndcfgs_saved);
+}
+
 /*
  * Check that the virtual CPU checks the VMX Guest State Area as
  * documented in the Intel SDM.
@@ -7701,6 +7753,7 @@ static void vmx_guest_state_area_test(void)
 	test_load_guest_pat();
 	test_guest_efer();
 	test_load_guest_perf_global_ctrl();
+	test_load_guest_bndcfgs();
 
 	/*
 	 * Let the guest finish execution
-- 
1.8.3.1

