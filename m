Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864221C4A13
	for <lists+kvm@lfdr.de>; Tue,  5 May 2020 01:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728283AbgEDXQt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 19:16:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57266 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728092AbgEDXQs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 19:16:48 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044NDjX6092837;
        Mon, 4 May 2020 23:16:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=OidiipWYMP0Ajv4LCjgSYyoY42Nbl9Rzf2IhSsGg0Ig=;
 b=giMo3UJXUZ0vs0fpltSZ+tBNRu0JKcj6Zo2hKmlUHJEoGbnupbJCjUdb9nWdOSwxiUaS
 g8+4fz/eeDMF0PWJraAjcJQfNrLy54Gvic3PcXD15GHa7S79igc0vvdIH8st6V1dqbBn
 JtcQLvMxvjUmUr2BbjZ5NSmzLi8M3zqMP1HtBBtPoxGRBzdw2R4BwVTcDpZebm8g1MyQ
 jGAAupuOGoda/hCX9SCzjI7OFgOtJzDj7n2EuxorTEW6WQuTlGZAuY44pLh5SzONwybB
 dYXIeyY3a1EdWpPxDbRiQFr4S9WXD1YfGbVHLlsM+C1u8kG/0HUNRTh2SLijwhyf1Y4R oQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 30s1gn1mnm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 23:16:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 044NDL5O022865;
        Mon, 4 May 2020 23:16:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 30sjncaw9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 04 May 2020 23:16:44 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 044NGhwH000739;
        Mon, 4 May 2020 23:16:43 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 04 May 2020 16:16:43 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 2/2] kvm-unit-tests: nSVM: Test that MBZ bits in CR3 and CR4 are not set on vmrun of nested guests
Date:   Mon,  4 May 2020 18:35:23 -0400
Message-Id: <20200504223523.7166-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200504223523.7166-1-krish.sadhukhan@oracle.com>
References: <20200504223523.7166-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=920 bulkscore=0 malwarescore=0 spamscore=0 suspectscore=13
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040180
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9611 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=13 mlxscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=964
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005040180
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol. 2,
the following guest state is illegal:

	"Any MBZ bit of CR3 is set."
	"Any MBZ bit of CR4 is set."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>

---
 x86/svm.h       |   6 ++++
 x86/svm_tests.c | 105 +++++++++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 99 insertions(+), 12 deletions(-)

diff --git a/x86/svm.h b/x86/svm.h
index 645deb7..3d5b79c 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -323,6 +323,12 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_EXIT_ERR		-1
 
 #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
+#define	SVM_CR0_RESERVED_MASK			0xffffffff00000000U
+#define	SVM_CR3_LEGACY_RESERVED_MASK		0xfe7U
+#define	SVM_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
+#define	SVM_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
+#define	SVM_CR4_LEGACY_RESERVED_MASK		0xffbaf000U
+#define	SVM_CR4_RESERVED_MASK			0xffffffffffbaf000U
 
 #define MSR_BITMAP_SIZE 8192
 
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 5a571eb..5d57ad0 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1596,6 +1596,31 @@ static void basic_guest_main(struct svm_test *test)
 {
 }
 
+#define SVM_TEST_CR_RESERVED_BITS(start, end, inc, cr, val, resv_mask)	\
+{									\
+        u64 tmp, mask;							\
+        int i;								\
+									\
+        for (i = start; i <= end; i = i + inc) {			\
+                mask = 1ull << i;					\
+                if (!(mask & resv_mask))				\
+                        continue;					\
+                tmp = val | mask;					\
+                switch (cr) {						\
+                        case 0:						\
+                                vmcb->save.cr0 = tmp;			\
+                                break;					\
+                        case 3:						\
+                                vmcb->save.cr3 = tmp;			\
+                                break;					\
+                        case 4:						\
+                                vmcb->save.cr4 = tmp;			\
+                }							\
+                report(svm_vmrun() == SVM_EXIT_ERR, "Test CR%d %d:%d: %lx",\
+		    cr, end, start, tmp);				\
+        }								\
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -1621,32 +1646,88 @@ static void svm_guest_state_test(void)
 	cr0 |= X86_CR0_CD;
 	cr0 &= ~X86_CR0_NW;
 	vmcb->save.cr0 = cr0;
-	report (svm_vmrun() == SVM_EXIT_VMMCALL, "CR0: %lx", cr0);
+	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=0: %lx",
+	    cr0);
 	cr0 |= X86_CR0_NW;
 	vmcb->save.cr0 = cr0;
-	report (svm_vmrun() == SVM_EXIT_VMMCALL, "CR0: %lx", cr0);
+	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=1,NW=1: %lx",
+	    cr0);
 	cr0 &= ~X86_CR0_NW;
 	cr0 &= ~X86_CR0_CD;
 	vmcb->save.cr0 = cr0;
-	report (svm_vmrun() == SVM_EXIT_VMMCALL, "CR0: %lx", cr0);
+	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=0,NW=0: %lx",
+	    cr0);
 	cr0 |= X86_CR0_NW;
 	vmcb->save.cr0 = cr0;
-	report (svm_vmrun() == SVM_EXIT_ERR, "CR0: %lx", cr0);
+	report (svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR0 CD=0,NW=1: %lx",
+	    cr0);
 	vmcb->save.cr0 = cr0_saved;
 
 	/*
 	 * CR0[63:32] are not zero
 	 */
-	int i;
-
 	cr0 = cr0_saved;
-	for (i = 32; i < 63; i = i + 4) {
-		cr0 = cr0_saved | (1ull << i);
-		vmcb->save.cr0 = cr0;
-		report (svm_vmrun() == SVM_EXIT_ERR, "CR0[63:32]: %lx",
-		    cr0 >> 32);
-	}
+
+	SVM_TEST_CR_RESERVED_BITS(32, 63, 4, 0, cr0_saved,
+	    SVM_CR0_RESERVED_MASK);
 	vmcb->save.cr0 = cr0_saved;
+
+	/*
+	 * CR3 MBZ bits based on different modes:
+	 *   [2:0]		    - legacy PAE
+	 *   [2:0], [11:5]	    - legacy non-PAE
+	 *   [2:0], [11:5], [63:52] - long mode
+	 */
+	u64 cr3_saved = vmcb->save.cr3;
+	u64 cr4_saved = vmcb->save.cr4;
+	u64 cr4 = cr4_saved;
+	efer_saved = vmcb->save.efer;
+	efer = efer_saved;
+
+	efer &= ~EFER_LMA;
+	vmcb->save.efer = efer;
+	cr4 |= X86_CR4_PAE;
+	vmcb->save.cr4 = cr4;
+	SVM_TEST_CR_RESERVED_BITS(0, 2, 1, 3, cr3_saved,
+	    SVM_CR3_LEGACY_PAE_RESERVED_MASK);
+
+	cr4 = cr4_saved & ~X86_CR4_PAE;
+	vmcb->save.cr4 = cr4;
+	SVM_TEST_CR_RESERVED_BITS(0, 11, 2, 3, cr3_saved,
+	    SVM_CR3_LEGACY_RESERVED_MASK);
+
+	cr4 |= X86_CR4_PAE;
+	vmcb->save.cr4 = cr4;
+	efer |= EFER_LMA;
+	vmcb->save.efer = efer;
+	SVM_TEST_CR_RESERVED_BITS(0, 63, 2, 3, cr3_saved,
+	    SVM_CR3_LONG_RESERVED_MASK);
+
+	vmcb->save.cr4 = cr4_saved;
+	vmcb->save.cr3 = cr3_saved;
+	vmcb->save.efer = efer_saved;
+
+	/*
+	 * CR4 MBZ bits based on different modes:
+	 *   [15:12], 17, 19, [31:22] - legacy mode
+	 *   [15:12], 17, 19, [63:22] - long mode
+	 */
+	cr4_saved = vmcb->save.cr4;
+	efer_saved = vmcb->save.efer;
+	efer &= ~EFER_LMA;
+	vmcb->save.efer = efer;
+	SVM_TEST_CR_RESERVED_BITS(12, 31, 2, 4, cr4_saved,
+	    SVM_CR4_LEGACY_RESERVED_MASK);
+
+	efer |= EFER_LMA;
+	vmcb->save.efer = efer;
+	SVM_TEST_CR_RESERVED_BITS(12, 31, 2, 4, cr4_saved,
+	    SVM_CR4_RESERVED_MASK);
+	SVM_TEST_CR_RESERVED_BITS(32, 63, 4, 4, cr4_saved,
+	    SVM_CR4_RESERVED_MASK);
+
+	vmcb->save.cr4 = cr4_saved;
+	vmcb->save.efer = efer_saved;
 }
 
 struct svm_test svm_tests[] = {
-- 
1.8.3.1

