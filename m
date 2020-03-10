Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD52180C62
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 00:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgCJX3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 19:29:33 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:49828 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbgCJX3d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 19:29:33 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02ANSqn7005247;
        Tue, 10 Mar 2020 23:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=JSYk78dNi+JU+apuaD1KMzLzsConJ6LXXwdKYBQWSus=;
 b=KxNdVE5VEtTVWr0c5w1ECLcGmPEb4I/ywPbI0j/7gxQ7qhcJzlrAi5rDCsDANqIWk8cz
 g8qr/gDSwxsdeV43HQX+8r9hAWnBolZTWZu9pYreQrDbhW9QU+W8a72u/HYLAg2Laasq
 Rs/MC3ylvUK39IFBDv2MyLvvXlww1zO+ay8kHZ1GgkUGigAOYnrKCQ8+Ep34DmNzkp3p
 Ie08WR2nIMakc7DxaBibTbAVvI6gAV/Zc4v8P7id5Df10yWwTmtaDEX0ALRvXAc5D/Dm
 sf2ylRqpu/lOUrpakbWtftJ39fs9wPlBPQWvJEC0qE0twOLQqUmdibSCNy2iv5YG82k2 Fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ym31ughd1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 23:29:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02ANSC8i112117;
        Tue, 10 Mar 2020 23:29:27 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2yp8puta90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Mar 2020 23:29:27 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02ANTQnD017284;
        Tue, 10 Mar 2020 23:29:26 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 10 Mar 2020 16:29:25 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH] kvm-unit-test: nVMX: Test Selector and Base Address fields of Guest Segment Registers on vmentry of nested guests
Date:   Tue, 10 Mar 2020 18:51:49 -0400
Message-Id: <20200310225149.31254-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
References: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=815 bulkscore=0 suspectscore=13 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003100140
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9556 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 lowpriorityscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 suspectscore=13
 phishscore=0 mlxlogscore=877 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003100140
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks on Guest Segment Registers" in Intel SDM vol 3C,
the following checks are performed on the Guest Segment Registers on vmentry
of nested guests:

    Selector fields:
	— TR. The TI flag (bit 2) must be 0.
	— LDTR. If LDTR is usable, the TI flag (bit 2) must be 0.
	— SS. If the guest will not be virtual-8086 and the "unrestricted
	  guest" VM-execution control is 0, the RPL (bits 1:0) must equal
	  the RPL of the selector field for CS.1

    Base-address fields:
	— CS, SS, DS, ES, FS, GS. If the guest will be virtual-8086, the
	  address must be the selector field shifted left 4 bits (multiplied
	  by 16).
	— The following checks are performed on processors that support Intel
	  64 architecture:
		TR, FS, GS. The address must be canonical.
		LDTR. If LDTR is usable, the address must be canonical.
		CS. Bits 63:32 of the address must be zero.
		SS, DS, ES. If the register is usable, bits 63:32 of the
		address must be zero.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 lib/x86/processor.h |   1 +
 x86/vmx_tests.c     | 109 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 03fdf64..3642212 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -57,6 +57,7 @@
 #define X86_EFLAGS_OF    0x00000800
 #define X86_EFLAGS_IOPL  0x00003000
 #define X86_EFLAGS_NT    0x00004000
+#define X86_EFLAGS_VM    0x00020000
 #define X86_EFLAGS_AC    0x00040000
 
 #define X86_EFLAGS_ALU (X86_EFLAGS_CF | X86_EFLAGS_PF | X86_EFLAGS_AF | \
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index a7abd63..5e96dfa 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7681,6 +7681,113 @@ static void test_load_guest_pat(void)
 	test_pat(GUEST_PAT, "GUEST_PAT", ENT_CONTROLS, ENT_LOAD_PAT);
 }
 
+#define	GUEST_SEG_USABLE_MASK	1u << 16
+#define	TEST_SEGMENT_SEL(seg_sel, seg_sel_name, val, val_saved)		\
+	vmcs_write(seg_sel, val);					\
+	enter_guest_with_invalid_guest_state();				\
+	report_guest_state_test(seg_sel_name,			\
+				VMX_ENTRY_FAILURE |			\
+				VMX_FAIL_STATE,				\
+				val, seg_sel_name);			\
+	vmcs_write(seg_sel, val_saved);
+
+/*
+ * The following checks are done on the Selector field of the Guest Segment
+ * Registers:
+ *    — TR. The TI flag (bit 2) must be 0.
+ *    — LDTR. If LDTR is usable, the TI flag (bit 2) must be 0.
+ *    — SS. If the guest will not be virtual-8086 and the "unrestricted
+ *	guest" VM-execution control is 0, the RPL (bits 1:0) must equal
+ *	the RPL of the selector field for CS.
+ *
+ *  [Intel SDM]
+ */
+static void test_guest_segment_sel_fields(void)
+{
+	u16 sel_saved;
+	u16 sel;
+
+	sel_saved = vmcs_read(GUEST_SEL_TR);
+	sel = sel_saved | 0x4;
+	TEST_SEGMENT_SEL(GUEST_SEL_TR, "GUEST_SEL_TR", sel, sel_saved);
+
+	sel_saved = vmcs_read(GUEST_SEL_LDTR);
+	sel = sel_saved | 0x4;
+	TEST_SEGMENT_SEL(GUEST_SEL_LDTR, "GUEST_SEL_LDTR", sel, sel_saved);
+
+	if (!(vmcs_read(GUEST_RFLAGS) & X86_EFLAGS_VM) &&
+	    !(vmcs_read(CPU_SECONDARY) & CPU_URG)) {
+		u16 cs_rpl_bits = vmcs_read(GUEST_SEL_CS) & 0x3;
+		sel_saved = vmcs_read(GUEST_SEL_SS);
+		sel = sel_saved | (~cs_rpl_bits & 0x3);
+		TEST_SEGMENT_SEL(GUEST_SEL_SS, "GUEST_SEL_SS", sel, sel_saved);
+	}
+}
+
+#define	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(seg_base, seg_base_name)	\
+	addr_saved = vmcs_read(seg_base);				\
+	for (i = 32; i < 63; i = i + 4) {				\
+		addr = addr_saved | 1ull << i;				\
+		vmcs_write(seg_base, addr);				\
+		enter_guest_with_invalid_guest_state();			\
+		report_guest_state_test(seg_base_name,			\
+					VMX_ENTRY_FAILURE |		\
+					VMX_FAIL_STATE,			\
+					addr, seg_base_name);		\
+	}								\
+									\
+	vmcs_write(seg_base, addr_saved);
+
+#define	TEST_SEGMENT_BASE_ADDR_CANONICAL(seg_base, seg_base_name)	\
+	addr_saved = vmcs_read(seg_base);				\
+	vmcs_write(seg_base, NONCANONICAL);				\
+	enter_guest_with_invalid_guest_state();				\
+	report_guest_state_test(seg_base_name,				\
+				VMX_ENTRY_FAILURE | VMX_FAIL_STATE,	\
+				NONCANONICAL, seg_base_name);		\
+	vmcs_write(seg_base, addr_saved);
+
+/*
+ * The following checks are done on the Base Address field of the Guest
+ * Segment Registers on processors that support Intel 64 architecture:
+ *    - TR, FS, GS : The address must be canonical.
+ *    - LDTR : If LDTR is usable, the address must be canonical.
+ *    - CS : Bits 63:32 of the address must be zero.
+ *    - SS, DS, ES : If the register is usable, bits 63:32 of the address
+ *	must be zero.
+ *
+ *  [Intel SDM]
+ */
+static void test_guest_segment_base_addr_fields(void)
+{
+	u64 addr_saved, addr;
+	int i;
+
+	/*
+	 * The address of TR, FS, GS and LDTR must be canonical.
+	 */
+	TEST_SEGMENT_BASE_ADDR_CANONICAL(GUEST_BASE_TR, "GUEST_BASE_TR");
+	TEST_SEGMENT_BASE_ADDR_CANONICAL(GUEST_BASE_FS, "GUEST_BASE_FS");
+	TEST_SEGMENT_BASE_ADDR_CANONICAL(GUEST_BASE_GS, "GUEST_BASE_GS");
+	if (!(vmcs_read(GUEST_AR_LDTR) & GUEST_SEG_USABLE_MASK))
+		TEST_SEGMENT_BASE_ADDR_CANONICAL(GUEST_BASE_LDTR,
+						"GUEST_BASE_LDTR");
+
+	/*
+	 * Bits 63:32 in CS, SS, DS and ES base address must be zero
+	 */
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(GUEST_BASE_CS, "GUEST_BASE_CS");
+	if (!(vmcs_read(GUEST_AR_SS) & GUEST_SEG_USABLE_MASK))
+		TEST_SEGMENT_BASE_ADDR_UPPER_BITS(GUEST_BASE_SS,
+						 "GUEST_BASE_SS");
+	if (!(vmcs_read(GUEST_AR_DS) & GUEST_SEG_USABLE_MASK))
+		TEST_SEGMENT_BASE_ADDR_UPPER_BITS(GUEST_BASE_DS,
+						 "GUEST_BASE_DS");
+	if (!(vmcs_read(GUEST_AR_ES) & GUEST_SEG_USABLE_MASK))
+		TEST_SEGMENT_BASE_ADDR_UPPER_BITS(GUEST_BASE_ES,
+						 "GUEST_BASE_ES");
+}
+
 /*
  * Check that the virtual CPU checks the VMX Guest State Area as
  * documented in the Intel SDM.
@@ -7701,6 +7808,8 @@ static void vmx_guest_state_area_test(void)
 	test_load_guest_pat();
 	test_guest_efer();
 	test_load_guest_perf_global_ctrl();
+	test_guest_segment_sel_fields();
+	test_guest_segment_base_addr_fields();
 
 	/*
 	 * Let the guest finish execution
-- 
1.8.3.1

