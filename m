Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04F832ACAA6
	for <lists+kvm@lfdr.de>; Tue, 10 Nov 2020 02:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729847AbgKJBqO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 20:46:14 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:37492 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725889AbgKJBqO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 20:46:14 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AA1hj4o056466;
        Tue, 10 Nov 2020 01:46:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=i2jWfVMlK5gGnkaaFfcTgSOAhQ2y3N6KfAlSePc/E+A=;
 b=BLgteSQ0rIZVI7zQRVxTfa/uMhoyl0E8GtNCfuvbCign7uswWhJsDVtv8VL0EtTqwqd7
 wjTL7mewAXZQXy1D7coIr5YptkFxcf5qJvFwv/tjNpQyxFzwUyXuLF9ozXlgM5MrzeI2
 0w+y/0IZ/n8yMZRpG2B/sFXW/oPAUAR2lqFDtmzgrJiWOmbA/cJ+xK0ucvlwPT5riEjQ
 8ucUrZMCtzEFY2Ud5HofdI9e8WbFX2oH7pnXaD0ABBHSqqmXc1eLrT0PpRT7z0ZgNxmI
 jkbv6fWvor16HLOaH1+R7Q3Ys+3hGNzuIBtt8N0Oa9le4y+tLdGxM43uOj+PnOTYfGFm Xw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 34nkhks4q8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 10 Nov 2020 01:46:07 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AA1e7Xt073227;
        Tue, 10 Nov 2020 01:46:07 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 34p5gw504x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Nov 2020 01:46:07 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AA1k56T031572;
        Tue, 10 Nov 2020 01:46:05 GMT
Received: from sadhukhan-nvmx.osdevelopmeniad.oraclevcn.com (/100.100.230.226)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 09 Nov 2020 17:46:05 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     jmattson@google.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com
Subject: [PATCH] nVMX: Test 'Type' and 'S' portions of Access Rights field in guest segment registers
Date:   Tue, 10 Nov 2020 01:45:56 +0000
Message-Id: <20201110014556.14913-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 spamscore=0 phishscore=0 adultscore=0 malwarescore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100011
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9800 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 priorityscore=1501
 mlxscore=0 suspectscore=1 mlxlogscore=999 lowpriorityscore=0 spamscore=0
 malwarescore=0 adultscore=0 clxscore=1015 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011100011
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Checks on Guest Segment Registers" in Intel SDM vol 3C,
the following checks are performed on the Guest Segment Registers on vmentry
of nested guests:

    Access-rights field:
	— Bits 3:0 (Type):
	    - CS: The values allowed depend on the setting of the “unrestricted
	          guest” VM-execution control:
		    - If the control is 0, the Type must be 9, 11, 13, or 15
		      (accessed code segment).
		    - If the control is 1, the Type must be either 3 (read/write
		      accessed expand-up data segment) or one of 9, 11, 13, and
		      15 (accessed code segment).
	    - SS: If SS is usable, the Type must be 3 or 7 (read/write,
		  accessed data segment).
	    - DS, ES, FS, GS: The following checks apply if the register is
	      		      usable:
			- Bit 0 of the Type must be 1 (accessed).
			- If bit 3 of the Type is 1 (code segment), then bit 1
		  	  of the Type must be 1 (readable).
	— Bit 4 (S): If the register is CS or if the register is usable, S must
	  be 1.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/vmx_tests.c | 165 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 165 insertions(+)

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index d2084ae..e7481bf 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -8177,6 +8177,170 @@ static void test_guest_segment_base_addr_fields(void)
 	vmcs_write(GUEST_AR_ES, ar_saved);
 }
 
+#define TEST_SEGMENT_AR(seg, name, saved_val, mask, test_val, xfail, msg)\
+{									\
+	u32 val = (saved_val & mask) | test_val;			\
+	vmcs_write(seg, val);						\
+	test_guest_state(msg, xfail, val, name);			\
+}
+
+#define TEST_SEGMENT_AR_TYPE_HELPER(seg, name)				\
+{									\
+	u32 ar_saved = vmcs_read(seg);					\
+									\
+	TEST_SEGMENT_AR(seg, name, (ar_saved | GUEST_SEG_UNUSABLE_MASK),\
+	    AR_TYPE_MASK1, 0x1, false, msg);				\
+	TEST_SEGMENT_AR(seg, name, (ar_saved | GUEST_SEG_UNUSABLE_MASK),\
+	    AR_TYPE_MASK1, 0x0, false, msg);				\
+	TEST_SEGMENT_AR(seg, name, (ar_saved & ~GUEST_SEG_UNUSABLE_MASK),\
+	    AR_TYPE_MASK1, 0x1, false, msg);				\
+	TEST_SEGMENT_AR(seg, name, (ar_saved & ~GUEST_SEG_UNUSABLE_MASK),\
+	    AR_TYPE_MASK1, 0x0, true, msg);				\
+	TEST_SEGMENT_AR(seg, name, (ar_saved | GUEST_SEG_UNUSABLE_MASK),\
+	    AR_TYPE_MASK2, 0x8, false, msg);				\
+	TEST_SEGMENT_AR(seg, name, (ar_saved | GUEST_SEG_UNUSABLE_MASK),\
+	    AR_TYPE_MASK2, 0x2, false, msg);				\
+	TEST_SEGMENT_AR(seg, name, (ar_saved & ~GUEST_SEG_UNUSABLE_MASK),\
+	    AR_TYPE_MASK2, 0x9, true, msg);				\
+	TEST_SEGMENT_AR(seg, name, (ar_saved & ~GUEST_SEG_UNUSABLE_MASK),\
+	    AR_TYPE_MASK2, 0x3, false, msg);				\
+									\
+	vmcs_write(seg, ar_saved);					\
+}
+
+#define TEST_SEGMENT_AR_S_HELPER(seg, name)				\
+{									\
+	u32 ar_saved = vmcs_read(seg);					\
+	char msg[] = "Access_Rights[4]";				\
+									\
+	if (seg == GUEST_AR_CS) {					\
+		TEST_SEGMENT_AR(seg, name, ar_saved, AR_S_MASK, 0x10,	\
+		    false, msg);					\
+		TEST_SEGMENT_AR(seg, name, ar_saved, AR_S_MASK, ~0x10,	\
+		    true, msg);						\
+	} else {							\
+		TEST_SEGMENT_AR(seg, name, (ar_saved |			\
+		    GUEST_SEG_UNUSABLE_MASK), AR_S_MASK, 0x10, false, msg);\
+		TEST_SEGMENT_AR(seg, name, (ar_saved |			\
+		    GUEST_SEG_UNUSABLE_MASK), AR_S_MASK, 0x0, false, msg);\
+		TEST_SEGMENT_AR(seg, name, (ar_saved &			\
+		    ~GUEST_SEG_UNUSABLE_MASK), AR_S_MASK, 0x10, false, msg);\
+		TEST_SEGMENT_AR(seg, name, (ar_saved &			\
+		    ~GUEST_SEG_UNUSABLE_MASK), AR_S_MASK, 0x0, true, msg);\
+	}								\
+	vmcs_write(seg, ar_saved);					\
+}
+
+/*
+ * The following checks are done on the Access Rights field of the Guest
+ * Segment Registers:
+ *
+ * Bits 3:0 (Type):
+ *   CS:
+ *     - If the “unrestricted guest" VM-execution control is 0, value must be
+ *       9, 11, 13, or 15.
+ *     - If the “unrestricted guest" VM-execution control is 1, value must be
+ *       either 3 or one of 9, 11, 13, and 15.
+ *   SS:
+ *     - If SS is usable, the Type must be 3 or 7.
+ *   DS, ES, FS, GS:
+ *     - If the register is usable, bit 0 of the Type must be 1 and if bit 3
+ *	 of the Type is 1, then bit 1 of the Type must be 1.
+ *
+ * Bit 4 (S): If the register is CS or if the register is usable, S must be 1.
+ *
+ *  [Intel SDM]
+ */
+static void test_guest_segment_ar_fields(void)
+{
+	/*
+	 * Type [3:0] of CS
+	 */
+	u32 ar_saved = vmcs_read(GUEST_AR_CS);
+	char msg[] = "Access_Rights[3:0]";
+
+#define	AR_TYPE_MASK	~0xf
+#define	AR_TYPE_MASK1	~0x1
+#define	AR_TYPE_MASK2	~0xa
+
+	TEST_SEGMENT_AR(GUEST_AR_CS, "GUEST_AR_CS", ar_saved,
+	    AR_TYPE_MASK, 0x9, false, msg);
+	TEST_SEGMENT_AR(GUEST_AR_CS, "GUEST_AR_CS", ar_saved,
+	    AR_TYPE_MASK, 0xb, false, msg);
+	TEST_SEGMENT_AR(GUEST_AR_CS, "GUEST_AR_CS", ar_saved,
+	    AR_TYPE_MASK, 0xd, false, msg);
+	TEST_SEGMENT_AR(GUEST_AR_CS, "GUEST_AR_CS", ar_saved,
+	    AR_TYPE_MASK, 0xf, false, msg);
+
+	/* Turn off "unrestricted guest" vm-execution control */
+	u32 cpu_ctrl0_saved = vmcs_read(CPU_EXEC_CTRL0);
+	u32 cpu_ctrl1_saved = vmcs_read(CPU_EXEC_CTRL1);
+	if (cpu_ctrl1_saved | CPU_URG)
+		vmcs_write(CPU_EXEC_CTRL1, cpu_ctrl1_saved & ~CPU_URG);
+
+	TEST_SEGMENT_AR(GUEST_AR_CS, "GUEST_AR_CS", ar_saved,
+	    AR_TYPE_MASK, 0x3, false, msg);
+
+	/* Turn on "unrestricted guest" vm-execution control */
+	vmcs_write(CPU_EXEC_CTRL0, cpu_ctrl0_saved | CPU_SECONDARY);
+	vmcs_write(CPU_EXEC_CTRL1, cpu_ctrl1_saved | CPU_URG);
+	/* EPT and EPTP must be setup when "unrestricted guest" is on */
+	setup_ept(false);
+
+	TEST_SEGMENT_AR(GUEST_AR_CS, "GUEST_AR_CS", ar_saved,
+	    AR_TYPE_MASK, 0x3, false, msg);
+
+	vmcs_write(GUEST_AR_CS, ar_saved);
+	vmcs_write(CPU_EXEC_CTRL0, cpu_ctrl0_saved);
+	vmcs_write(CPU_EXEC_CTRL1, cpu_ctrl1_saved);
+
+	/*
+	 * Type [3:0] of SS
+	 */
+	ar_saved = vmcs_read(GUEST_AR_SS);
+
+	TEST_SEGMENT_AR(GUEST_AR_SS, "GUEST_AR_SS", (ar_saved |
+	    GUEST_SEG_UNUSABLE_MASK), AR_TYPE_MASK, 0x3, false, msg);
+
+	TEST_SEGMENT_AR(GUEST_AR_SS, "GUEST_AR_SS", (ar_saved |
+	    GUEST_SEG_UNUSABLE_MASK), AR_TYPE_MASK, 0x7, false, msg);
+
+	TEST_SEGMENT_AR(GUEST_AR_SS, "GUEST_AR_SS", (ar_saved |
+	    GUEST_SEG_UNUSABLE_MASK), AR_TYPE_MASK, 0x0, false, msg);
+
+	TEST_SEGMENT_AR(GUEST_AR_SS, "GUEST_AR_SS", (ar_saved &
+	    ~GUEST_SEG_UNUSABLE_MASK), AR_TYPE_MASK, 0x3, false, msg);
+
+	TEST_SEGMENT_AR(GUEST_AR_SS, "GUEST_AR_SS", (ar_saved &
+	    ~GUEST_SEG_UNUSABLE_MASK), AR_TYPE_MASK, 0x7, false, msg);
+
+	TEST_SEGMENT_AR(GUEST_AR_SS, "GUEST_AR_SS", (ar_saved &
+	    ~GUEST_SEG_UNUSABLE_MASK), AR_TYPE_MASK, 0x0, true, msg);
+
+	vmcs_write(GUEST_AR_SS, ar_saved);
+
+	/*
+	 * Type [3:0] of DS, ES, FS and GS
+	 */
+	TEST_SEGMENT_AR_TYPE_HELPER(GUEST_AR_DS, "GUEST_AR_DS");
+	TEST_SEGMENT_AR_TYPE_HELPER(GUEST_AR_ES, "GUEST_AR_ES");
+	TEST_SEGMENT_AR_TYPE_HELPER(GUEST_AR_FS, "GUEST_AR_FS");
+	TEST_SEGMENT_AR_TYPE_HELPER(GUEST_AR_GS, "GUEST_AR_GS");
+
+	/*
+	 * S [4] of CS, SS, DS, ES, FS and GS
+	 */
+#define	AR_S_MASK	~0x10
+
+	TEST_SEGMENT_AR_S_HELPER(GUEST_AR_CS, "GUEST_AR_CS");
+	TEST_SEGMENT_AR_S_HELPER(GUEST_AR_CS, "GUEST_AR_CS");
+	TEST_SEGMENT_AR_S_HELPER(GUEST_AR_SS, "GUEST_AR_SS");
+	TEST_SEGMENT_AR_S_HELPER(GUEST_AR_DS, "GUEST_AR_DS");
+	TEST_SEGMENT_AR_S_HELPER(GUEST_AR_ES, "GUEST_AR_ES");
+	TEST_SEGMENT_AR_S_HELPER(GUEST_AR_FS, "GUEST_AR_FS");
+	TEST_SEGMENT_AR_S_HELPER(GUEST_AR_GS, "GUEST_AR_GS");
+}
+
 /*
  * Check that the virtual CPU checks the VMX Guest State Area as
  * documented in the Intel SDM.
@@ -8201,6 +8365,7 @@ static void vmx_guest_state_area_test(void)
 
 	test_guest_segment_sel_fields();
 	test_guest_segment_base_addr_fields();
+	test_guest_segment_ar_fields();
 
 	test_canonical(GUEST_BASE_GDTR, "GUEST_BASE_GDTR", false);
 	test_canonical(GUEST_BASE_IDTR, "GUEST_BASE_IDTR", false);
-- 
2.18.4

