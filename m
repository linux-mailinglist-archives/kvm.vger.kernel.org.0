Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE7F0271D95
	for <lists+kvm@lfdr.de>; Mon, 21 Sep 2020 10:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgIUIKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Sep 2020 04:10:46 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45056 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgIUIKp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Sep 2020 04:10:45 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08L896XT163587;
        Mon, 21 Sep 2020 08:10:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=Hv/dqC0QFifa4/r82vmdrwp0CRePakr43scoy0mLXNU=;
 b=AlU18KRiNJozaN7Oq8LsresczdgW0ui8CvVB7qQCvUENUUgZWgUV0HjswXlVb66QurEB
 LB4IHkjs9HvOYg3Vjgx2EMdN+UkIOTfhMcH3wiEWQ+vaRpD+FbI/GEk1FzyIhz13QcBT
 KZ7n1OihiBoCmdkBVODAqCnvTKfc15Uk966SBFiLytMXb17EDfbS4aSgUhKPxGQgzTBS
 yN+ja3JaTbZu9CsIbP4vzQLf2gme2yXfS23pukVBHRJqmPSDF6xzxmWcQRXjKQybKziK
 9XbVd/Nx+jp8MoK/2YeaZD/5HgLt24pjxLR+M/8AdNx+rkmFgB0A8+qIPoH/hJ56CwUI 2A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33n9xkm31x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 21 Sep 2020 08:10:39 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08L85mij188337;
        Mon, 21 Sep 2020 08:10:39 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 33nuw04r8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Sep 2020 08:10:38 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08L8AbT7022464;
        Mon, 21 Sep 2020 08:10:37 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.230.226)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 21 Sep 2020 01:10:37 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 2/3 v3] nVMX: Test Selector and Base Address fields of Guest Segment Registers on vmentry of nested guests
Date:   Mon, 21 Sep 2020 08:10:26 +0000
Message-Id: <20200921081027.23047-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200921081027.23047-1-krish.sadhukhan@oracle.com>
References: <20200921081027.23047-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9750 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 suspectscore=1 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009210059
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9750 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 suspectscore=1 priorityscore=1501 adultscore=0 spamscore=0 clxscore=1015
 mlxlogscore=999 bulkscore=0 mlxscore=0 phishscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009210059
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
 x86/vmx_tests.c     | 200 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 201 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 74a2498..c2c487c 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -63,6 +63,7 @@
 #define X86_EFLAGS_OF    0x00000800
 #define X86_EFLAGS_IOPL  0x00003000
 #define X86_EFLAGS_NT    0x00004000
+#define X86_EFLAGS_VM    0x00020000
 #define X86_EFLAGS_AC    0x00040000
 
 #define X86_EFLAGS_ALU (X86_EFLAGS_CF | X86_EFLAGS_PF | X86_EFLAGS_AF | \
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 22f0c7b..2b6e47b 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7980,6 +7980,203 @@ static void test_load_guest_bndcfgs(void)
 	vmcs_write(GUEST_BNDCFGS, bndcfgs_saved);
 }
 
+#define	GUEST_SEG_UNUSABLE_MASK	(1u << 16)
+#define	GUEST_SEG_SEL_TI_MASK	(1u << 2)
+#define	TEST_SEGMENT_SEL(xfail, sel, sel_name, val)			\
+	vmcs_write(sel, val);						\
+	test_guest_state("Test Guest Segment Selector",	xfail, val,	\
+			 sel_name);
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
+	u32 ar_saved;
+	u32 cpu_ctrl0_saved;
+	u32 cpu_ctrl1_saved;
+	u16 cs_rpl_bits;
+
+	/*
+	 * Test for GUEST_SEL_TR
+	 */
+	sel_saved = vmcs_read(GUEST_SEL_TR);
+	TEST_SEGMENT_SEL(true, GUEST_SEL_TR, "GUEST_SEL_TR",
+			 sel_saved | GUEST_SEG_SEL_TI_MASK);
+	vmcs_write(GUEST_SEL_TR, sel_saved);
+
+	/*
+	 * Test for GUEST_SEL_LDTR
+	 */
+	sel_saved = vmcs_read(GUEST_SEL_LDTR);
+	ar_saved = vmcs_read(GUEST_AR_LDTR);
+	/* LDTR is set unusable */
+	vmcs_write(GUEST_AR_LDTR, ar_saved | GUEST_SEG_UNUSABLE_MASK);
+	TEST_SEGMENT_SEL(false, GUEST_SEL_LDTR, "GUEST_SEL_LDTR",
+			 sel_saved | GUEST_SEG_SEL_TI_MASK);
+	TEST_SEGMENT_SEL(false, GUEST_SEL_LDTR, "GUEST_SEL_LDTR",
+			 sel_saved & ~GUEST_SEG_SEL_TI_MASK);
+	/* LDTR is set usable */
+	vmcs_write(GUEST_AR_LDTR, ar_saved & ~GUEST_SEG_UNUSABLE_MASK);
+	TEST_SEGMENT_SEL(true, GUEST_SEL_LDTR, "GUEST_SEL_LDTR",
+			 sel_saved | GUEST_SEG_SEL_TI_MASK);
+
+	TEST_SEGMENT_SEL(false, GUEST_SEL_LDTR, "GUEST_SEL_LDTR",
+			 sel_saved & ~GUEST_SEG_SEL_TI_MASK);
+
+	vmcs_write(GUEST_AR_LDTR, ar_saved);
+	vmcs_write(GUEST_SEL_LDTR, sel_saved);
+
+	/*
+	 * Test for GUEST_SEL_SS
+	 */
+	cpu_ctrl0_saved = vmcs_read(CPU_EXEC_CTRL0);
+	cpu_ctrl1_saved = vmcs_read(CPU_EXEC_CTRL1);
+	ar_saved = vmcs_read(GUEST_AR_SS);
+	/* Turn off "unrestricted guest" vm-execution control */
+	vmcs_write(CPU_EXEC_CTRL1, cpu_ctrl1_saved & ~CPU_URG);
+	cs_rpl_bits = vmcs_read(GUEST_SEL_CS) & 0x3;
+	sel_saved = vmcs_read(GUEST_SEL_SS);
+	TEST_SEGMENT_SEL(true, GUEST_SEL_SS, "GUEST_SEL_SS",
+				 ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
+	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
+				 ((sel_saved & ~0x3) | (cs_rpl_bits & 0x3)));
+	/* Make SS usable if it's unusable or vice-versa */
+	if (ar_saved & GUEST_SEG_UNUSABLE_MASK)
+		vmcs_write(GUEST_AR_SS, ar_saved & ~GUEST_SEG_UNUSABLE_MASK);
+	else
+		vmcs_write(GUEST_AR_SS, ar_saved | GUEST_SEG_UNUSABLE_MASK);
+	TEST_SEGMENT_SEL(true, GUEST_SEL_SS, "GUEST_SEL_SS",
+				 ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
+	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
+				 ((sel_saved & ~0x3) | (cs_rpl_bits & 0x3)));
+
+	/* Turn on "unrestricted guest" vm-execution control */
+	vmcs_write(CPU_EXEC_CTRL0, cpu_ctrl0_saved | CPU_SECONDARY);
+	vmcs_write(CPU_EXEC_CTRL1, cpu_ctrl1_saved | CPU_URG);
+	/* EPT and EPTP must be setup when "unrestricted guest" is on */
+	setup_ept(false);
+	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
+				 ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
+	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
+				 ((sel_saved & ~0x3) | (cs_rpl_bits & 0x3)));
+	/* Make SS usable if it's unusable or vice-versa */
+	if (vmcs_read(GUEST_AR_SS) & GUEST_SEG_UNUSABLE_MASK)
+		vmcs_write(GUEST_AR_SS, ar_saved & ~GUEST_SEG_UNUSABLE_MASK);
+	else
+		vmcs_write(GUEST_AR_SS, ar_saved | GUEST_SEG_UNUSABLE_MASK);
+	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
+				 ((sel_saved & ~0x3) | (~cs_rpl_bits & 0x3)));
+	TEST_SEGMENT_SEL(false, GUEST_SEL_SS, "GUEST_SEL_SS",
+				 ((sel_saved & ~0x3) | (cs_rpl_bits & 0x3)));
+
+	vmcs_write(GUEST_AR_SS, ar_saved);
+	vmcs_write(GUEST_SEL_SS, sel_saved);
+	vmcs_write(CPU_EXEC_CTRL0, cpu_ctrl0_saved);
+	vmcs_write(CPU_EXEC_CTRL1, cpu_ctrl1_saved);
+}
+
+#define	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(xfail, seg_base, seg_base_name)\
+	addr_saved = vmcs_read(seg_base);				\
+	for (i = 32; i < 63; i = i + 4) {				\
+		addr = addr_saved | 1ull << i;				\
+		vmcs_write(seg_base, addr);				\
+		test_guest_state(seg_base_name,	xfail, addr,		\
+				seg_base_name);				\
+	}								\
+	vmcs_write(seg_base, addr_saved);
+
+#define	TEST_SEGMENT_BASE_ADDR_CANONICAL(xfail, seg_base, seg_base_name)\
+	addr_saved = vmcs_read(seg_base);				\
+	vmcs_write(seg_base, NONCANONICAL);				\
+	test_guest_state(seg_base_name,	xfail, NONCANONICAL,		\
+			seg_base_name);					\
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
+	u64 addr_saved;
+	u64 addr;
+	u32 ar_saved;
+	int i;
+
+	/*
+	 * The address of TR, FS, GS and LDTR must be canonical.
+	 */
+	TEST_SEGMENT_BASE_ADDR_CANONICAL(true, GUEST_BASE_TR, "GUEST_BASE_TR");
+	TEST_SEGMENT_BASE_ADDR_CANONICAL(true, GUEST_BASE_FS, "GUEST_BASE_FS");
+	TEST_SEGMENT_BASE_ADDR_CANONICAL(true, GUEST_BASE_GS, "GUEST_BASE_GS");
+	ar_saved = vmcs_read(GUEST_AR_LDTR);
+	/* Make LDTR unusable */
+	vmcs_write(GUEST_AR_LDTR, ar_saved | GUEST_SEG_UNUSABLE_MASK);
+	TEST_SEGMENT_BASE_ADDR_CANONICAL(false, GUEST_BASE_LDTR,
+					"GUEST_BASE_LDTR");
+	/* Make LDTR usable */
+	vmcs_write(GUEST_AR_LDTR, ar_saved & ~GUEST_SEG_UNUSABLE_MASK);
+	TEST_SEGMENT_BASE_ADDR_CANONICAL(true, GUEST_BASE_LDTR,
+					"GUEST_BASE_LDTR");
+
+	vmcs_write(GUEST_AR_LDTR, ar_saved);
+
+	/*
+	 * Bits 63:32 in CS, SS, DS and ES base address must be zero
+	 */
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(true, GUEST_BASE_CS,
+					 "GUEST_BASE_CS");
+	ar_saved = vmcs_read(GUEST_AR_SS);
+	/* Make SS unusable */
+	vmcs_write(GUEST_AR_SS, ar_saved | GUEST_SEG_UNUSABLE_MASK);
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(false, GUEST_BASE_SS,
+					 "GUEST_BASE_SS");
+	/* Make SS usable */
+	vmcs_write(GUEST_AR_SS, ar_saved & ~GUEST_SEG_UNUSABLE_MASK);
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(true, GUEST_BASE_SS,
+					 "GUEST_BASE_SS");
+	vmcs_write(GUEST_AR_SS, ar_saved);
+
+	ar_saved = vmcs_read(GUEST_AR_DS);
+	/* Make DS unusable */
+	vmcs_write(GUEST_AR_DS, ar_saved | GUEST_SEG_UNUSABLE_MASK);
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(false, GUEST_BASE_DS,
+					 "GUEST_BASE_DS");
+	/* Make DS usable */
+	vmcs_write(GUEST_AR_DS, ar_saved & ~GUEST_SEG_UNUSABLE_MASK);
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(true, GUEST_BASE_DS,
+					 "GUEST_BASE_DS");
+	vmcs_write(GUEST_AR_DS, ar_saved);
+
+	ar_saved = vmcs_read(GUEST_AR_ES);
+	/* Make ES unusable */
+	vmcs_write(GUEST_AR_ES, ar_saved | GUEST_SEG_UNUSABLE_MASK);
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(false, GUEST_BASE_ES,
+					 "GUEST_BASE_ES");
+	/* Make ES usable */
+	vmcs_write(GUEST_AR_ES, ar_saved & ~GUEST_SEG_UNUSABLE_MASK);
+	TEST_SEGMENT_BASE_ADDR_UPPER_BITS(true, GUEST_BASE_ES,
+					 "GUEST_BASE_ES");
+	vmcs_write(GUEST_AR_ES, ar_saved);
+}
+
 /*
  * Check that the virtual CPU checks the VMX Guest State Area as
  * documented in the Intel SDM.
@@ -8002,6 +8199,9 @@ static void vmx_guest_state_area_test(void)
 	test_load_guest_perf_global_ctrl();
 	test_load_guest_bndcfgs();
 
+	test_guest_segment_sel_fields();
+	test_guest_segment_base_addr_fields();
+
 	test_canonical(GUEST_BASE_GDTR, "GUEST_BASE_GDTR", false);
 	test_canonical(GUEST_BASE_IDTR, "GUEST_BASE_IDTR", false);
 
-- 
2.18.4

