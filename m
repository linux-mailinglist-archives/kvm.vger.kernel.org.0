Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A418C217C4F
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 02:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgGHAkJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 20:40:09 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58708 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbgGHAkJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 20:40:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0680Wpvx155186;
        Wed, 8 Jul 2020 00:40:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=yUTrceer40v17/ZTL9p4b5SMaZTxJjvT2U+jnBmQovc=;
 b=oo47KFDXmdoOOm745v/AbVZgjfWj3p/66DP+18KKFXHLUsakPhdOSlQBZa0Aaop4fBd8
 pYFjHjeS2Iv5noy5JT94aYxbmSBnTRcXDt0oea/Iah7XCsuzGvOULEd4Bbfn+bKZQONf
 Eumx3fzfn/qsNSjbDAOuzcUM/yk4ipBfYhIG52+9WtjTWR2XVW0AykffVstwoyk15CNR
 KIRBorxVGt/6YnLYw8dU+/CiRdAguObz5IHpQ6qvcpfHOROOwE2+h2u6FBUcmgsgFQzG
 8hcQF1KQYnI6dWZjnMnenc/P/u7y/4qiScietkn8YVWAkv85/l2BYoa3c/1o4JtgIsJD 1w== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 322kv6fd7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 08 Jul 2020 00:40:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0680XDuG100793;
        Wed, 8 Jul 2020 00:40:06 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3233bq0nvb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Jul 2020 00:40:06 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0680e68o007329;
        Wed, 8 Jul 2020 00:40:06 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.231.196)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 07 Jul 2020 17:40:06 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 3/3 v4] kvm-unit-tests: nSVM: Test that MBZ bits in CR3 and CR4 are not set on vmrun of nested guests
Date:   Wed,  8 Jul 2020 00:39:57 +0000
Message-Id: <1594168797-29444-4-git-send-email-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
References: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 bulkscore=0 suspectscore=13
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9675 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 suspectscore=13 mlxlogscore=999 phishscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 impostorscore=0 mlxscore=0 adultscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2007080000
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
 x86/svm.h       |  5 +++
 x86/svm_tests.c | 94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 95 insertions(+), 4 deletions(-)

diff --git a/x86/svm.h b/x86/svm.h
index 457ce3c..f6b9a31 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -325,6 +325,11 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
 
 #define	SVM_CR0_RESERVED_MASK			0xffffffff00000000U
+#define	SVM_CR3_LEGACY_RESERVED_MASK		0xfe7U
+#define	SVM_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
+#define	SVM_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
+#define	SVM_CR4_LEGACY_RESERVED_MASK		0xffbaf000U
+#define	SVM_CR4_RESERVED_MASK			0xffffffffffbaf000U
 #define	SVM_DR6_RESERVED_MASK			0xffffffffffff1ff0U
 #define	SVM_DR7_RESERVED_MASK			0xffffffff0000cc00U
 #define	SVM_EFER_RESERVED_MASK			0xffffffffffff0200U
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index d4d130f..c59e7eb 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1913,6 +1913,31 @@ static void basic_guest_main(struct svm_test *test)
         }								\
 }
 
+#define SVM_TEST_CR_RESERVED_BITS(start, end, inc, cr, val, resv_mask)	\
+{									\
+	u64 tmp, mask;							\
+	int i;								\
+									\
+	for (i = start; i <= end; i = i + inc) {			\
+		mask = 1ull << i;					\
+		if (!(mask & resv_mask))				\
+			continue;					\
+		tmp = val | mask;					\
+		switch (cr) {						\
+		case 0:							\
+			vmcb->save.cr0 = tmp;				\
+			break;						\
+		case 3:							\
+			vmcb->save.cr3 = tmp;				\
+			break;						\
+		case 4:							\
+			vmcb->save.cr4 = tmp;				\
+		}							\
+		report(svm_vmrun() == SVM_EXIT_ERR, "Test CR%d %d:%d: %lx",\
+		    cr, end, start, tmp);				\
+	}								\
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -1938,17 +1963,21 @@ static void svm_guest_state_test(void)
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
+	report (svm_vmrun() == SVM_EXIT_ERR, "Test CR0 CD=0,NW=1: %lx",
+	    cr0);
 	vmcb->save.cr0 = cr0_saved;
 
 	/*
@@ -1961,6 +1990,63 @@ static void svm_guest_state_test(void)
 	vmcb->save.cr0 = cr0_saved;
 
 	/*
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
+
+	/*
 	 * DR6[63:32] and DR7[63:32] are MBZ
 	 */
 	u64 dr_saved = vmcb->save.dr6;
-- 
1.8.3.1

