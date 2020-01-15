Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1610B13B767
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 03:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgAOCDu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 21:03:50 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41518 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728885AbgAOCDu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 21:03:50 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00F23UVR111594;
        Wed, 15 Jan 2020 02:03:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2019-08-05;
 bh=Sd9+nNWGjenWHpvPXIl4HnAkoueVByOhAHQjv8aEkKc=;
 b=lIq7GQG1uxmHyX63vW8h6Sfs0mPL/PgB1KMvv6YlgmG4ZljNrJNJX5mOAoAw/me7G6XX
 9zmdyDfb2m81Tc0LTqu3SfXqIaSpp8jGRFFILc3QV6zTrmYtnMSNcNP5s3sPkrX2PA66
 6/H2SbIu/JFg3bUGD2s7SJHdlDYZSW+8ryHDUTW71Tcp9X5AUBMUe5IR81EEQGBac5/e
 ixHMh8pZeQ7I+5bOzhSqzcKzskVoCa4Okx1Vw9+5XFgrldI76xzzvaN5u3UR8xr9ih0r
 CVMw8cMniwnIJuJUjF1pEY0bpuzlvUnnHMrhw+597l7uWidYWLy4W4U6mMCD3xcB9TAp 6g== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2xf73tshyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 02:03:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00F23eRB190833;
        Wed, 15 Jan 2020 02:03:45 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2xh2tpqrc1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Jan 2020 02:03:44 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00F22ugJ011607;
        Wed, 15 Jan 2020 02:02:56 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 14 Jan 2020 18:02:55 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 2/2 v2] kvm-unit-test: nVMX: Test GUEST_DR7 on vmentry of nested guests
Date:   Tue, 14 Jan 2020 20:25:41 -0500
Message-Id: <20200115012541.8904-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200115012541.8904-1-krish.sadhukhan@oracle.com>
References: <20200115012541.8904-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9500 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=947
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001150017
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9500 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001150017
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks on Guest Control Registers, Debug Registers, and
and MSRs" in Intel SDM vol 3C, the following checks are performed on vmentry
of nested guests:

   If the "load debug controls" VM-entry control is 1,

      - bits 63:32 in the DR7 field must be 0.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
Co-developed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 x86/vmx_tests.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index fce773c..b773872 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7442,6 +7442,49 @@ static void vmx_host_state_area_test(void)
 	test_load_host_perf_global_ctrl();
 }
 
+/*
+ * If the "load debug controls" VM-entry control is 1, bits 63:32 in
+ * the DR7 field must be 0.
+ *
+ * [Intel SDM]
+ */
+static void test_guest_dr7(void)
+{
+	u32 ent_saved = vmcs_read(ENT_CONTROLS);
+	u64 dr7_saved = vmcs_read(GUEST_DR7);
+	u64 val;
+	int i;
+
+	if (ctrl_enter_rev.set & ENT_LOAD_DBGCTLS) {
+		vmcs_clear_bits(ENT_CONTROLS, ENT_LOAD_DBGCTLS);
+		for (i = 0; i < 64; i++) {
+			val = 1ull << i;
+			vmcs_write(GUEST_DR7, val);
+			enter_guest();
+			report_guest_state_test("ENT_LOAD_DBGCTLS disabled",
+						VMX_VMCALL, val, "GUEST_DR7");
+		}
+	}
+	if (ctrl_enter_rev.clr & ENT_LOAD_DBGCTLS) {
+		vmcs_set_bits(ENT_CONTROLS, ENT_LOAD_DBGCTLS);
+		for (i = 0; i < 64; i++) {
+			val = 1ull << i;
+			vmcs_write(GUEST_DR7, val);
+			if (i < 32)
+				enter_guest();
+			else
+				enter_guest_with_invalid_guest_state();
+			report_guest_state_test("ENT_LOAD_DBGCTLS enabled",
+						i < 32 ? VMX_VMCALL :
+						VMX_ENTRY_FAILURE |
+						VMX_FAIL_STATE,
+						val, "GUEST_DR7");
+		}
+	}
+	vmcs_write(GUEST_DR7, dr7_saved);
+	vmcs_write(ENT_CONTROLS, ent_saved);
+}
+
 /*
  *  If the "load IA32_PAT" VM-entry control is 1, the value of the field
  *  for the IA32_PAT MSR must be one that could be written by WRMSR
@@ -7480,6 +7523,7 @@ static void vmx_guest_state_area_test(void)
 	test_canonical(GUEST_SYSENTER_ESP, "GUEST_SYSENTER_ESP", false);
 	test_canonical(GUEST_SYSENTER_EIP, "GUEST_SYSENTER_EIP", false);
 
+	test_guest_dr7();
 	test_load_guest_pat();
 	test_guest_efer();
 	test_load_guest_perf_global_ctrl();
-- 
2.20.1

