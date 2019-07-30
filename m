Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 699BE7B5A0
	for <lists+kvm@lfdr.de>; Wed, 31 Jul 2019 00:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbfG3WUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Jul 2019 18:20:50 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:57288 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727221AbfG3WUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Jul 2019 18:20:50 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6UMJ4Ag117940;
        Tue, 30 Jul 2019 22:20:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2018-07-02;
 bh=rAyzX37QeWvvumAVUm+OxnDuyu77CuiDTI0XwJKw6tc=;
 b=IZhL2thFmchYedMhXDi/XEKgqO5eqAf5ESdSAw9vYDI7AvbSJjVe6hoKpfhQF3898+Eb
 J47hDHUT+SjL0xpPe7uU+2l9Ekmt0+zIbrZzsFm5Io6IQSWLvyjYHhGguGB8MLf95Rbi
 VQEZuMKw07J/8pXEd94mRyi3MNM0lD9evcqLdWSM4M2IZBbS+Ft5tnQ6q+tPatYnYTp5
 EdZSP1V/HAxEm7nWppETfmNBuZGuM9T/AEGB+v8IkAwZEmswiPxClOTjU3rONdzW0WU1
 gTG5oTlcRU9GPEwKa1AHtpqYZPjSb1PeGuPCtFon4PtwTMHwhu1XOQJZ1Hi2NHa9F3iL og== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2u0e1tsfdk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 22:20:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6UMII4x174709;
        Tue, 30 Jul 2019 22:20:42 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2u2jp4ecfp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Jul 2019 22:20:42 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x6UMKgFA001439;
        Tue, 30 Jul 2019 22:20:42 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 30 Jul 2019 15:20:41 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 1/2] kvm-unit-test: x86: Implement a generic wrapper for cpuid/cpuid_indexed functions
Date:   Tue, 30 Jul 2019 17:52:55 -0400
Message-Id: <20190730215256.26695-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190730215256.26695-1-krish.sadhukhan@oracle.com>
References: <20190730215256.26695-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=13 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1907300223
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9334 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=13 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1907300223
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
---
 lib/x86/processor.h | 143 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 111 insertions(+), 32 deletions(-)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 8b8bb7a..9b87dd5 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -65,6 +65,117 @@
 #define X86_IA32_EFER          0xc0000080
 #define X86_EFER_LMA           (1UL << 8)
 
+/*
+ * CPU features
+ */
+
+enum cpuid_output_regs {
+	EAX,
+	EBX,
+	ECX,
+	EDX
+};
+
+struct cpuid { u32 a, b, c, d; };
+
+static inline struct cpuid raw_cpuid(u32 function, u32 index)
+{
+    struct cpuid r;
+    asm volatile ("cpuid"
+                  : "=a"(r.a), "=b"(r.b), "=c"(r.c), "=d"(r.d)
+                  : "0"(function), "2"(index));
+    return r;
+}
+
+static inline struct cpuid cpuid_indexed(u32 function, u32 index)
+{
+    u32 level = raw_cpuid(function & 0xf0000000, 0).a;
+    if (level < function)
+        return (struct cpuid) { 0, 0, 0, 0 };
+    return raw_cpuid(function, index);
+}
+
+static inline struct cpuid cpuid(u32 function)
+{
+    return cpuid_indexed(function, 0);
+}
+
+static inline u8 cpuid_maxphyaddr(void)
+{
+    if (raw_cpuid(0x80000000, 0).a < 0x80000008)
+        return 36;
+    return raw_cpuid(0x80000008, 0).a & 0xff;
+}
+
+#define	CPUID(a, b, c, d) ((((unsigned long long) a) << 32) | (b << 16) | \
+			  (c << 8) | d)
+
+/*
+ * Each X86_FEATURE_XXX definition is 64-bit and contains the following
+ * CPUID meta-data:
+ *
+ * 	[63:32] :  input value for EAX
+ * 	[31:16] :  input value for ECX
+ * 	[15:8]  :  output register
+ * 	[7:0]   :  bit position in output register
+ */
+
+/*
+ * Intel CPUID features
+ */
+#define	X86_FEATURE_MWAIT		(CPUID(0x1, 0, ECX, 3))
+#define	X86_FEATURE_VMX			(CPUID(0x1, 0, ECX, 5))
+#define	X86_FEATURE_PCID		(CPUID(0x1, 0, ECX, 17))
+#define	X86_FEATURE_MOVBE		(CPUID(0x1, 0, ECX, 22))
+#define	X86_FEATURE_TSC_DEADLINE_TIMER	(CPUID(0x1, 0, ECX, 24))
+#define	X86_FEATURE_XSAVE		(CPUID(0x1, 0, ECX, 26))
+#define	X86_FEATURE_OSXSAVE		(CPUID(0x1, 0, ECX, 27))
+#define	X86_FEATURE_RDRAND		(CPUID(0x1, 0, ECX, 30))
+#define	X86_FEATURE_MCE			(CPUID(0x1, 0, EDX, 7))
+#define	X86_FEATURE_APIC		(CPUID(0x1, 0, EDX, 9))
+#define	X86_FEATURE_CLFLUSH		(CPUID(0x1, 0, EDX, 19))
+#define	X86_FEATURE_XMM			(CPUID(0x1, 0, EDX, 25))
+#define	X86_FEATURE_XMM2		(CPUID(0x1, 0, EDX, 26))
+#define	X86_FEATURE_TSC_ADJUST		(CPUID(0x7, 0, EBX, 1))
+#define	X86_FEATURE_INVPCID_SINGLE	(CPUID(0x7, 0, EBX, 7))
+#define	X86_FEATURE_INVPCID		(CPUID(0x7, 0, EBX, 10))
+#define	X86_FEATURE_RTM			(CPUID(0x7, 0, EBX, 11))
+#define	X86_FEATURE_SMAP		(CPUID(0x7, 0, EBX, 20))
+#define	X86_FEATURE_PCOMMIT		(CPUID(0x7, 0, EBX, 22))
+#define	X86_FEATURE_CLFLUSHOPT		(CPUID(0x7, 0, EBX, 23))
+#define	X86_FEATURE_CLWB		(CPUID(0x7, 0, EBX, 24))
+#define	X86_FEATURE_UMIP		(CPUID(0x7, 0, ECX, 2))
+#define	X86_FEATURE_PKU			(CPUID(0x7, 0, ECX, 3))
+#define	X86_FEATURE_LA57		(CPUID(0x7, 0, ECX, 16))
+#define	X86_FEATURE_RDPID		(CPUID(0x7, 0, ECX, 22))
+#define	X86_FEATURE_SPEC_CTRL		(CPUID(0x7, 0, EDX, 26))
+#define	X86_FEATURE_NX			(CPUID(0x80000001, 0, EDX, 20))
+
+/*
+ * AMD CPUID features
+ */
+#define	X86_FEATURE_SVM			(CPUID(0x80000001, 0, ECX, 2))
+#define	X86_FEATURE_RDTSCP		(CPUID(0x80000001, 0, EDX, 27))
+#define	X86_FEATURE_AMD_IBPB		(CPUID(0x80000008, 0, EBX, 12))
+#define	X86_FEATURE_NPT			(CPUID(0x8000000A, 0, EDX, 0))
+#define	X86_FEATURE_NRIPS		(CPUID(0x8000000A, 0, EDX, 3))
+
+
+static inline bool this_cpu_has(u64 feature)
+{
+	u32 input_eax = feature >> 32;
+	u32 input_ecx = (feature >> 16) & 0xffff;
+	u32 output_reg = (feature >> 8) & 0xff;
+	u8 bit = feature & 0xff;
+	struct cpuid c;
+	u32 *tmp;
+
+	c = cpuid_indexed(input_eax, input_ecx);
+	tmp = (u32 *)&c;
+
+	return ((*(tmp + (output_reg % 32))) & (1 << bit));
+}
+
 struct far_pointer32 {
 	u32 offset;
 	u16 selector;
@@ -330,38 +441,6 @@ static inline ulong read_dr7(void)
     return val;
 }
 
-struct cpuid { u32 a, b, c, d; };
-
-static inline struct cpuid raw_cpuid(u32 function, u32 index)
-{
-    struct cpuid r;
-    asm volatile ("cpuid"
-                  : "=a"(r.a), "=b"(r.b), "=c"(r.c), "=d"(r.d)
-                  : "0"(function), "2"(index));
-    return r;
-}
-
-static inline struct cpuid cpuid_indexed(u32 function, u32 index)
-{
-    u32 level = raw_cpuid(function & 0xf0000000, 0).a;
-    if (level < function)
-        return (struct cpuid) { 0, 0, 0, 0 };
-    return raw_cpuid(function, index);
-}
-
-static inline struct cpuid cpuid(u32 function)
-{
-    return cpuid_indexed(function, 0);
-}
-
-static inline u8 cpuid_maxphyaddr(void)
-{
-    if (raw_cpuid(0x80000000, 0).a < 0x80000008)
-        return 36;
-    return raw_cpuid(0x80000008, 0).a & 0xff;
-}
-
-
 static inline void pause(void)
 {
     asm volatile ("pause");
-- 
2.20.1

