Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC3E727328
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 02:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbfEWAMy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 20:12:54 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:55080 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728784AbfEWAMy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 20:12:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4N06iGs135821;
        Thu, 23 May 2019 00:12:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=FDdTqWbzJAzVjGHj6MmVyB2DSEm1EL3o97AHrxjBT9U=;
 b=AEfK84nCiYRcVrA2wvLAYDxO/wUTzGB8rKDSb6t6p9vdRyYyikKgE5gbJfn5qSkqu2UR
 iTgwHjQZgKpSgMjQRBst5unCxkJdcZFfNRvNVC+MAuUwY7L4RLKfz47dRYz174fVrtVJ
 avH34XQrKSjtk7Vuto4Z/z3MHxsJM55Ljnv5Eii5861wasDvajGXQUrXvJR514UH/l0Q
 zcmbJRv2CEgUrOxWC0IQHhWjk4rEkaAW6wpHuZVDLr1m+myv712zLQUfTcMKFI4RtOdH
 B1Yz8RQlZNnM0Qli0np69E5mQ6UA4uQ6vg8t6bJni2kI2FXtIuFYaCDiQKzlpYrKq/Nm cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2smsk574rt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 00:12:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4N0BgJJ045525;
        Thu, 23 May 2019 00:12:02 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2smsgv5vwc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 May 2019 00:12:02 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4N0C1Ir020256;
        Thu, 23 May 2019 00:12:01 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 May 2019 00:12:01 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 2/2] kvm-unit-test: nVMX: Test "Load IA32_EFER" VM-exit control on vmentry of nested guests
Date:   Wed, 22 May 2019 19:45:45 -0400
Message-Id: <20190522234545.5930-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522234545.5930-1-krish.sadhukhan@oracle.com>
References: <20190522234545.5930-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9265 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220168
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9265 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220168
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

 ..to verify KVM performs the appropriate consistency checks for loading
   IA32_EFER VM-exit control as part of running a nested guest.

According to section "Checks on Host Control Registers and MSRs" in Intel
SDM vol 3C, the following checks are performed on vmentry of nested guests:

   If the “load IA32_EFER” VM-exit control is 1, bits reserved in the
   IA32_EFER MSR must be 0 in the field for that register. In addition,
   the values of the LMA and LME bits in the field must each be that of
   the “host address-space size” VM-exit control.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 x86/vmx_tests.c | 121 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 121 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 8cb1708..32fa16d 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -5136,6 +5136,126 @@ static void test_guest_perf_global_ctl(void)
 			     ENT_CONTROLS, ENT_LOAD_PERF);
 }
 
+static void test_efer_bit(u32 fld, const char * fld_name, u32 ctrl_fld,
+			   u64 ctrl_bit, u64 efer_bit,
+			   const char *efer_bit_name)
+{
+	u64 efer_saved = vmcs_read(fld);
+	u32 ctrl_saved = vmcs_read(ctrl_fld);
+	u64 host_addr_size = ctrl_saved & EXI_HOST_64;
+	u64 efer;
+
+	vmcs_write(ctrl_fld, ctrl_saved & ~ctrl_bit);
+	efer = efer_saved & ~efer_bit;
+	vmcs_write(fld, efer);
+	report_prefix_pushf("%s bit turned off, %s %lx", efer_bit_name,
+			    fld_name, efer);
+	test_vmx_vmlaunch(0, false);
+	report_prefix_pop();
+
+	efer = efer_saved | efer_bit;
+	vmcs_write(fld, efer);
+	report_prefix_pushf("%s bit turned on, %s %lx", efer_bit_name,
+			    fld_name, efer);
+	test_vmx_vmlaunch(0, false);
+	report_prefix_pop();
+
+	vmcs_write(ctrl_fld, ctrl_saved | ctrl_bit);
+	efer = efer_saved & ~efer_bit;
+	vmcs_write(fld, efer);
+	report_prefix_pushf("%s bit turned off, %s %lx", efer_bit_name,
+			    fld_name, efer);
+	if (host_addr_size)
+		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
+				  false);
+	else
+		test_vmx_vmlaunch(0, false);
+	report_prefix_pop();
+
+	efer = efer_saved | efer_bit;
+	vmcs_write(fld, efer);
+	report_prefix_pushf("%s bit turned on, %s %lx", efer_bit_name,
+			    fld_name, efer);
+	if (host_addr_size)
+		test_vmx_vmlaunch(0, false);
+	else
+		test_vmx_vmlaunch(VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
+				  false);
+	report_prefix_pop();
+
+	vmcs_write(ctrl_fld, ctrl_saved);
+	vmcs_write(fld, efer_saved);
+}
+
+static void test_efer(u32 fld, const char * fld_name, u32 ctrl_fld,
+		      u64 ctrl_bit)
+{
+	u64 efer_saved = vmcs_read(fld);
+	u32 ctrl_saved = vmcs_read(ctrl_fld);
+	u64 efer_reserved_bits =  ~((u64)(EFER_SCE | EFER_LME | EFER_LMA));
+	u64 i;
+	u64 efer;
+
+	if (efer_nx_enabled())
+		efer_reserved_bits &= ~EFER_NX;
+
+	/*
+	 * Check reserved bits
+	 */
+	vmcs_write(ctrl_fld, ctrl_saved & ~ctrl_bit);
+	for (i = 0; i < 64; i++) {
+		if ((1ull << i) & efer_reserved_bits) {
+			efer = efer_saved | (1ull << i);
+			vmcs_write(fld, efer);
+			report_prefix_pushf("%s %lx", fld_name, efer);
+			test_vmx_vmlaunch(0, false);
+			report_prefix_pop();
+		}
+	}
+
+	vmcs_write(ctrl_fld, ctrl_saved | ctrl_bit);
+	for (i = 0; i < 64; i++) {
+		if ((1ull << i) & efer_reserved_bits) {
+			efer = efer_saved | (1ull << i);
+			vmcs_write(fld, efer);
+			report_prefix_pushf("%s %lx", fld_name, efer);
+			test_vmx_vmlaunch(
+				VMXERR_ENTRY_INVALID_HOST_STATE_FIELD,
+				false);
+			report_prefix_pop();
+		}
+	}
+
+	vmcs_write(ctrl_fld, ctrl_saved);
+	vmcs_write(fld, efer_saved);
+
+	/*
+	 * Check LMA and LME bits
+	 */
+	test_efer_bit(fld, fld_name, ctrl_fld, ctrl_bit, EFER_LMA,
+		      "EFER_LMA");
+	test_efer_bit(fld, fld_name, ctrl_fld, ctrl_bit, EFER_LME,
+		      "EFER_LME");
+}
+
+/*
+ * If the “load IA32_EFER” VM-exit control is 1, bits reserved in the
+ * IA32_EFER MSR must be 0 in the field for that register. In addition,
+ * the values of the LMA and LME bits in the field must each be that of
+ * the “host address-space size” VM-exit control.
+ *
+ *  [Intel SDM]
+ */
+static void test_host_efer(void)
+{
+	if (!(ctrl_exit_rev.clr & EXI_LOAD_EFER)) {
+		printf("\"Load-IA32-EFER\" exit control not supported\n");
+		return;
+	}
+
+	test_efer(HOST_EFER, "HOST_EFER", EXI_CONTROLS, EXI_LOAD_EFER);
+}
+
 /*
  * PAT values higher than 8 are uninteresting since they're likely lumped
  * in with "8". We only test values above 8 one bit at a time,
@@ -5268,6 +5388,7 @@ static void vmx_host_state_area_test(void)
 	test_sysenter_field(HOST_SYSENTER_ESP, "HOST_SYSENTER_ESP");
 	test_sysenter_field(HOST_SYSENTER_EIP, "HOST_SYSENTER_EIP");
 
+	test_host_efer();
 	test_host_perf_global_ctl();
 	test_load_host_pat();
 }
-- 
2.20.1

