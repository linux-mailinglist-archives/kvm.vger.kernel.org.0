Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A902563C2
	for <lists+kvm@lfdr.de>; Sat, 29 Aug 2020 02:48:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgH2Asp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 20:48:45 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:34886 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgH2Asj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 20:48:39 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07T0Vpqh089451;
        Sat, 29 Aug 2020 00:48:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=CnEHzMOFKrVtrGYMzDdiDP0w+Wju5iodrzjRIhiHPX8=;
 b=fAsaUNZYR+fVkVRasuHiNMsqm9e0dj5TNhnqldDLlePrPP2/6/Ay1dqUBdCFSvi7eM+A
 6VdFIMCNqwUHfYSZW+vyocVh+vhQSnnX3Ky3HjeFz2FjAXR/TJCUVOSG2I7ZKB9rj9zU
 wVUVp8xTS0rjM258aTdWLIgzeIH3etRRRdy/QByWjIZl+01o/TlD+peFPNEy9ikZtbiT
 EPJTqVsIa7fPExabodPPi6pPfxRJPQWs9rwFjb4oISMri+nHkeQjmC8g5ajHYToULet+
 90755ZTTsAY8o8QZ7fUZaWhGjsh/iobXq5J6MapOJ97+tCZHCUIxOIRYrRUtUDsv/UJW Sg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 336ht3pq4k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 29 Aug 2020 00:48:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07T0VSDG078496;
        Sat, 29 Aug 2020 00:48:34 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 337c4s0rdu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 29 Aug 2020 00:48:34 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07T0mXsO000428;
        Sat, 29 Aug 2020 00:48:33 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 28 Aug 2020 17:48:33 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 3/3] nSVM: Test non-MBZ reserved bits in CR3 in long mode
Date:   Sat, 29 Aug 2020 00:48:24 +0000
Message-Id: <20200829004824.4577-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200829004824.4577-1-krish.sadhukhan@oracle.com>
References: <20200829004824.4577-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=1 adultscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008290000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9727 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=1 spamscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008290000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "CR3" in APM vol. 2, the non-MBZ reserved bits in CR3
need to be set by software as follows:

	"Reserved Bits. Reserved fields should be cleared to 0 by software
	when writing CR3."

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.h       |  3 ++-
 x86/svm_tests.c | 54 ++++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/x86/svm.h b/x86/svm.h
index 15e0f18..465d794 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -325,7 +325,8 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
 
 #define	SVM_CR0_RESERVED_MASK			0xffffffff00000000U
-#define	SVM_CR3_LONG_RESERVED_MASK		0xfff0000000000000U
+#define	SVM_CR3_LONG_MBZ_MASK			0xfff0000000000000U
+#define	SVM_CR3_LONG_RESERVED_MASK		0x0000000000000fe7U
 #define	SVM_CR4_LEGACY_RESERVED_MASK		0xff88f000U
 #define	SVM_CR4_RESERVED_MASK			0xffffffffff88f000U
 #define	SVM_DR6_RESERVED_MASK			0xffffffffffff1ff0U
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1908c7c..af8684b 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1891,11 +1891,11 @@ static bool reg_corruption_check(struct svm_test *test)
  * v2 tests
  */
 
+int KRISH_step = 0;
 static void basic_guest_main(struct svm_test *test)
 {
 }
 
-
 #define SVM_TEST_REG_RESERVED_BITS(start, end, inc, str_name, reg, val,	\
 				   resv_mask)				\
 {									\
@@ -1913,7 +1913,8 @@ static void basic_guest_main(struct svm_test *test)
         }								\
 }
 
-#define SVM_TEST_CR_RESERVED_BITS(start, end, inc, cr, val, resv_mask)	\
+#define SVM_TEST_CR_RESERVED_BITS(start, end, inc, cr, val, resv_mask,	\
+				  exit_code)				\
 {									\
 	u64 tmp, mask;							\
 	int i;								\
@@ -1933,7 +1934,7 @@ static void basic_guest_main(struct svm_test *test)
 		case 4:							\
 			vmcb->save.cr4 = tmp;				\
 		}							\
-		report(svm_vmrun() == SVM_EXIT_ERR, "Test CR%d %d:%d: %lx",\
+		report(svm_vmrun() == exit_code, "Test CR%d %d:%d: %lx",\
 		    cr, end, start, tmp);				\
 	}								\
 }
@@ -2012,9 +2013,48 @@ static void test_cr3(void)
 	u64 cr3_saved = vmcb->save.cr3;
 
 	SVM_TEST_CR_RESERVED_BITS(0, 63, 1, 3, cr3_saved,
-	    SVM_CR3_LONG_RESERVED_MASK);
+	    SVM_CR3_LONG_MBZ_MASK, SVM_EXIT_ERR);
+
+	vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_MBZ_MASK;
+	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
+	    vmcb->save.cr3);
+
+	/*
+	 * CR3 non-MBZ reserved bits based on different modes:
+	 *   [11:5] [2:0] - long mode
+	 */
+	u64 cr4_saved = vmcb->save.cr4;
+
+	/*
+	 * Long mode
+	 */
+	if (this_cpu_has(X86_FEATURE_PCID)) {
+		vmcb->save.cr4 = cr4_saved | X86_CR4_PCIDE;
+		SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
+		    SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_VMMCALL);
+
+		vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_RESERVED_MASK;
+		report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
+		    vmcb->save.cr3);
+	} else {
+		u64 *pdpe = npt_get_pml4e();
+
+		vmcb->save.cr4 = cr4_saved & ~X86_CR4_PCIDE;
+
+		/* Clear P (Present) bit in NPT in order to trigger #NPF */
+		pdpe[0] &= ~1ULL;
+
+		SVM_TEST_CR_RESERVED_BITS(0, 11, 1, 3, cr3_saved,
+		    SVM_CR3_LONG_RESERVED_MASK, SVM_EXIT_NPF);
+
+		pdpe[0] |= 1ULL;
+		vmcb->save.cr3 = cr3_saved & ~SVM_CR3_LONG_RESERVED_MASK;
+		report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
+		    vmcb->save.cr3);
+	}
 
 	vmcb->save.cr3 = cr3_saved;
+	vmcb->save.cr4 = cr4_saved;
 }
 
 static void test_cr4(void)
@@ -2031,14 +2071,14 @@ static void test_cr4(void)
 	efer &= ~EFER_LME;
 	vmcb->save.efer = efer;
 	SVM_TEST_CR_RESERVED_BITS(12, 31, 1, 4, cr4_saved,
-	    SVM_CR4_LEGACY_RESERVED_MASK);
+	    SVM_CR4_LEGACY_RESERVED_MASK, SVM_EXIT_ERR);
 
 	efer |= EFER_LME;
 	vmcb->save.efer = efer;
 	SVM_TEST_CR_RESERVED_BITS(12, 31, 1, 4, cr4_saved,
-	    SVM_CR4_RESERVED_MASK);
+	    SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR);
 	SVM_TEST_CR_RESERVED_BITS(32, 63, 4, 4, cr4_saved,
-	    SVM_CR4_RESERVED_MASK);
+	    SVM_CR4_RESERVED_MASK, SVM_EXIT_ERR);
 
 	vmcb->save.cr4 = cr4_saved;
 	vmcb->save.efer = efer_saved;
-- 
2.18.4

