Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0DC21DF2A4
	for <lists+kvm@lfdr.de>; Sat, 23 May 2020 01:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbgEVXCi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 19:02:38 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60898 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731172AbgEVXCh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 May 2020 19:02:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMx67G093821;
        Fri, 22 May 2020 23:02:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=KtRnmSWRFRNUvrp6zX3kLi2gOkHeJuHj7ZSUgtgpHQw=;
 b=Ago+S7nFHdq71pbEmU8qFoIhByNgquVx9vyE90tMKLKXgmPTKKJB/lh9OTea/0pbCWJM
 S1AqLnk9lt+6chYwkapqtxZegpavbf/LzNC0xKQC9g5gmXIDQshSBu4zmhsHnaJ5FpBa
 zqTxLF8plArFynWYq0O8fjV9Ms9n/OKuA8Yq0XciHe2LT6iYh+oAh0C/OS5y2CwyOLJa
 spw8x/SbPXzKLp9bpl7EbU7JQ/yE08+gikL/P4+GOjkq9Uo8vczRf5UK+6RJioQ4LlYE
 UkEYcYWs68FghS3BNO7o8V1Rcu5Epd7dSVWTnbUda6ZtnxKGifSHlCkycDoGnOdrvlup Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 316qrvr1ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 22 May 2020 23:02:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04MMvJZI058938;
        Fri, 22 May 2020 23:02:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 312t3fxuph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 May 2020 23:02:33 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04MN2WIX015971;
        Fri, 22 May 2020 23:02:32 GMT
Received: from ban25x6uut29.us.oracle.com (/10.153.73.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 22 May 2020 16:02:32 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH 3/4] kvm-unit-tests: nSVM: Test that DR6[63:32], DR7[63:32] and EFER reserved bits are not set on vmrun of nested guests
Date:   Fri, 22 May 2020 18:19:53 -0400
Message-Id: <20200522221954.32131-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200522221954.32131-1-krish.sadhukhan@oracle.com>
References: <20200522221954.32131-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 phishscore=0 mlxscore=0 malwarescore=0 suspectscore=13 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220179
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9629 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 malwarescore=0 cotscore=-2147483648 suspectscore=13 adultscore=0
 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005220179
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol. 2
the following guest state is illegal:

    "DR6[63:32] are not zero."
    "DR7[63:32] are not zero."
    "Any MBZ bit of EFER is set."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.h       |  3 +++
 x86/svm_tests.c | 59 ++++++++++++++++++++++++++++++++++++++-------------------
 2 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/x86/svm.h b/x86/svm.h
index 3d5b79c..14418ef 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -329,6 +329,9 @@ struct __attribute__ ((__packed__)) vmcb {
 #define	SVM_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
 #define	SVM_CR4_LEGACY_RESERVED_MASK		0xffbaf000U
 #define	SVM_CR4_RESERVED_MASK			0xffffffffffbaf000U
+#define	SVM_DR6_RESERVED_MASK			0xffffffffffff1ff0U
+#define	SVM_DR7_RESERVED_MASK			0xffffffff0000cc00U
+#define	SVM_EFER_RESERVED_MASK			0xffffffffffff0200U
 
 #define MSR_BITMAP_SIZE 8192
 
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 99cfe4a..d96f3ee 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1799,7 +1799,8 @@ static void basic_guest_main(struct svm_test *test)
 {
 }
 
-#define SVM_TEST_CR_RESERVED_BITS(start, end, inc, cr, val, resv_mask)	\
+#define SVM_TEST_REG_RESERVED_BITS(start, end, inc, str_name, reg, val,	\
+				   resv_mask)				\
 {									\
         u64 tmp, mask;							\
         int i;								\
@@ -1809,18 +1810,9 @@ static void basic_guest_main(struct svm_test *test)
                 if (!(mask & resv_mask))				\
                         continue;					\
                 tmp = val | mask;					\
-                switch (cr) {						\
-                        case 0:						\
-                                vmcb->save.cr0 = tmp;			\
-                                break;					\
-                        case 3:						\
-                                vmcb->save.cr3 = tmp;			\
-                                break;					\
-                        case 4:						\
-                                vmcb->save.cr4 = tmp;			\
-                }							\
-                report(svm_vmrun() == SVM_EXIT_ERR, "Test CR%d %d:%d: %lx",\
-		    cr, end, start, tmp);				\
+		reg = tmp;						\
+		report(svm_vmrun() == SVM_EXIT_ERR, "Test %s %d:%d: %lx",\
+		    str_name, end, start, tmp);				\
         }								\
 }
 
@@ -1871,7 +1863,7 @@ static void svm_guest_state_test(void)
 	 */
 	cr0 = cr0_saved;
 
-	SVM_TEST_CR_RESERVED_BITS(32, 63, 4, 0, cr0_saved,
+	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "CR0", vmcb->save.cr0, cr0_saved,
 	    SVM_CR0_RESERVED_MASK);
 	vmcb->save.cr0 = cr0_saved;
 
@@ -1891,19 +1883,19 @@ static void svm_guest_state_test(void)
 	vmcb->save.efer = efer;
 	cr4 |= X86_CR4_PAE;
 	vmcb->save.cr4 = cr4;
-	SVM_TEST_CR_RESERVED_BITS(0, 2, 1, 3, cr3_saved,
+	SVM_TEST_REG_RESERVED_BITS(0, 2, 1, "CR3", vmcb->save.cr3, cr3_saved,
 	    SVM_CR3_LEGACY_PAE_RESERVED_MASK);
 
 	cr4 = cr4_saved & ~X86_CR4_PAE;
 	vmcb->save.cr4 = cr4;
-	SVM_TEST_CR_RESERVED_BITS(0, 11, 2, 3, cr3_saved,
+	SVM_TEST_REG_RESERVED_BITS(0, 11, 2, "CR3", vmcb->save.cr3, cr3_saved,
 	    SVM_CR3_LEGACY_RESERVED_MASK);
 
 	cr4 |= X86_CR4_PAE;
 	vmcb->save.cr4 = cr4;
 	efer |= EFER_LMA;
 	vmcb->save.efer = efer;
-	SVM_TEST_CR_RESERVED_BITS(0, 63, 2, 3, cr3_saved,
+	SVM_TEST_REG_RESERVED_BITS(0, 63, 2, "CR3", vmcb->save.cr3, cr3_saved,
 	    SVM_CR3_LONG_RESERVED_MASK);
 
 	vmcb->save.cr4 = cr4_saved;
@@ -1919,18 +1911,45 @@ static void svm_guest_state_test(void)
 	efer_saved = vmcb->save.efer;
 	efer &= ~EFER_LMA;
 	vmcb->save.efer = efer;
-	SVM_TEST_CR_RESERVED_BITS(12, 31, 2, 4, cr4_saved,
+	SVM_TEST_REG_RESERVED_BITS(12, 31, 2, "CR4", vmcb->save.cr4, cr4_saved,
 	    SVM_CR4_LEGACY_RESERVED_MASK);
 
 	efer |= EFER_LMA;
 	vmcb->save.efer = efer;
-	SVM_TEST_CR_RESERVED_BITS(12, 31, 2, 4, cr4_saved,
+	SVM_TEST_REG_RESERVED_BITS(12, 31, 2, "CR4", vmcb->save.cr4, cr4_saved,
 	    SVM_CR4_RESERVED_MASK);
-	SVM_TEST_CR_RESERVED_BITS(32, 63, 4, 4, cr4_saved,
+	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "CR4", vmcb->save.cr4, cr4_saved,
 	    SVM_CR4_RESERVED_MASK);
 
 	vmcb->save.cr4 = cr4_saved;
 	vmcb->save.efer = efer_saved;
+
+	/*
+	 * DR6[63:32] and DR7[63:32] are MBZ
+	 */
+	u64 dr_saved = vmcb->save.dr6;
+
+	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "DR6", vmcb->save.dr6, dr_saved,
+	    SVM_DR6_RESERVED_MASK);
+	vmcb->save.dr6 = dr_saved;
+
+	dr_saved = vmcb->save.dr7;
+	SVM_TEST_REG_RESERVED_BITS(32, 63, 4, "DR7", vmcb->save.dr7, dr_saved,
+	    SVM_DR7_RESERVED_MASK);
+
+	vmcb->save.dr7 = dr_saved;
+
+	/*
+	 * EFER MBZ bits: 63:16, 9
+	 */
+	efer_saved = vmcb->save.efer;
+
+	SVM_TEST_REG_RESERVED_BITS(8, 9, 1, "EFER", vmcb->save.efer,
+	    efer_saved, SVM_EFER_RESERVED_MASK);
+	SVM_TEST_REG_RESERVED_BITS(16, 63, 4, "EFER", vmcb->save.efer,
+	    efer_saved, SVM_EFER_RESERVED_MASK);
+
+	vmcb->save.efer = efer_saved;
 }
 
 struct svm_test svm_tests[] = {
-- 
1.8.3.1

