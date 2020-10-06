Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32686285214
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 21:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgJFTHQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 15:07:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:57586 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727018AbgJFTHO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Oct 2020 15:07:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096IxPu5088592;
        Tue, 6 Oct 2020 19:07:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=WlsT3nGyPUgfvtjyhik+PX0/iFyko6GrgHTE0WmTI2w=;
 b=SSiNHggVg0v16V+PWiHHCv+yluvxKd0cH3t3kRPKfxjU2Ab+xm+2dhcoR0QRCRTifMpQ
 BcuC6pqxKUubSdGv0ejq+4Z86FLZ1+LegGL4z1JFq97h9oQKW1asCga1ZpjfgD7zQrU5
 0+7yAZ3+XSNgcEzUlxaCael21hujy6lMIrHb8EEWnzFB4/Hsaqzf6G1ZyEl7gsa46qsK
 xdE0OyqN6M3J7b+iwnOVxhONiwhyDfHh6BXHDKT94ycdcS07pxqZRg6RDNBUdidC2Qr1
 BObG4Y/xWP7d7e4EH03HOrTS/frLNfbUoeRczcfa02SHYBY7hJxeg8m++EoQYeFEnfYe 3A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33xhxmwuqf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 19:07:05 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096J1IDu134166;
        Tue, 6 Oct 2020 19:07:05 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33y2vnep1x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 19:07:05 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 096J73Zm016157;
        Tue, 6 Oct 2020 19:07:04 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 12:07:03 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com,
        sean.j.christopherson@intel.com
Subject: [PATCH 3/4 v3] nSVM: Test non-MBZ reserved bits in CR3 in long mode and legacy PAE mode
Date:   Tue,  6 Oct 2020 19:06:53 +0000
Message-Id: <20201006190654.32305-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20201006190654.32305-1-krish.sadhukhan@oracle.com>
References: <20201006190654.32305-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 suspectscore=1 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010060123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 suspectscore=1 phishscore=0
 mlxlogscore=999 adultscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060123
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "CR3" in APM vol. 2, the non-MBZ reserved bits in CR3
need to be set by software as follows:

	"Reserved Bits. Reserved fields should be cleared to 0 by software
	when writing CR3."

But experiments show that consistency checking in SVM ignores these
non-MBZ-reserved bits in CR3, meaning they can be set to 1 also. However,
setting them to 1 may cause guest crashes in some modes and in bare metal
environments. Hence, this test induces an #NPF by clearing the "P" bit in
the highest level page table, when testing the 1-setting of these bits.
Inducing an #NPF causes the guest to exit to userspace before any guest
instruction is executed thus avoiding any crash.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm.h       |  4 ++-
 x86/svm_tests.c | 66 ++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 63 insertions(+), 7 deletions(-)

diff --git a/x86/svm.h b/x86/svm.h
index 15e0f18..d657592 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -325,7 +325,9 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
 
 #define	SVM_CR0_RESERVED_MASK			0xffffffff00000000U
-#define	SVM_CR3_LONG_RESERVED_MASK		0xfff0000000000000U
+#define	SVM_CR3_LONG_MBZ_MASK			0xfff0000000000000U
+#define	SVM_CR3_LONG_RESERVED_MASK		0x0000000000000fe7U
+#define SVM_CR3_PAE_LEGACY_RESERVED_MASK	0x0000000000000007U
 #define	SVM_CR4_LEGACY_RESERVED_MASK		0xff88f000U
 #define	SVM_CR4_RESERVED_MASK			0xffffffffff88f000U
 #define	SVM_DR6_RESERVED_MASK			0xffffffffffff1ff0U
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1908c7c..ed21d21 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
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
@@ -2012,9 +2013,62 @@ static void test_cr3(void)
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
+	 *          [2:0] - PAE legacy mode
+	 */
+	u64 cr4_saved = vmcb->save.cr4;
+	u64 *pdpe = npt_get_pml4e();
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
+
+	/*
+	 * PAE legacy
+	 */
+	pdpe[0] &= ~1ULL;
+	vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;
+	SVM_TEST_CR_RESERVED_BITS(0, 2, 1, 3, cr3_saved,
+	    SVM_CR3_PAE_LEGACY_RESERVED_MASK, SVM_EXIT_NPF);
+
+	pdpe[0] |= 1ULL;
+	vmcb->save.cr3 = cr3_saved & ~SVM_CR3_PAE_LEGACY_RESERVED_MASK;
+	report(svm_vmrun() == SVM_EXIT_VMMCALL, "Test CR3 63:0: %lx",
+	    vmcb->save.cr3);
 
 	vmcb->save.cr3 = cr3_saved;
+	vmcb->save.cr4 = cr4_saved;
 }
 
 static void test_cr4(void)
@@ -2031,14 +2085,14 @@ static void test_cr4(void)
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

