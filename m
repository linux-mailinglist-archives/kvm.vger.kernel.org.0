Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE05E27A875
	for <lists+kvm@lfdr.de>; Mon, 28 Sep 2020 09:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgI1HVN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Sep 2020 03:21:13 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34056 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726461AbgI1HVM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Sep 2020 03:21:12 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S7J2LF015987;
        Mon, 28 Sep 2020 07:21:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=R5xjuRVckYl+TLAy3xQN9Qywbeg6hCgX23rFiO8N6sk=;
 b=PidagqRn6bC7C/5i+x+ivdrFkKk1JG/Imb60lUtWWdGeTHYJzUzmQc6h0BW41ppZTryo
 Ev354auEssbjtfN1IdAOGZWhHEugUivUgDOSupUcqHPhoLXERTvXntQdr6p0ICb7wkrT
 71NyTqTpANTF8JzVFEgI3u9bHYcU3KxLuRxblK3z0wRurXvWdnHzkUjWcnDM3ivXAEkD
 JuASTWe7H/crL31cUFIP1+I2QO/z3Ig/FuVxiEOR68M1ttTfYIYYntoYdTQtjjO7z6JV
 Nsj1xCNCLonH9IXnpAzGr7wOYR13hKmFrANySlHDSSPljW6cKSYrfeRMvwkJ6YDgk+I4 aQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 33sx9muc4x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 07:21:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08S7KMe3186942;
        Mon, 28 Sep 2020 07:21:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33tfhvwkys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 07:21:07 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08S7L7fG030752;
        Mon, 28 Sep 2020 07:21:07 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 00:21:07 -0700
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com
Subject: [PATCH 3/4 v2] KVM: nSVM: Test non-MBZ reserved bits in CR3 in long mode
Date:   Mon, 28 Sep 2020 07:20:42 +0000
Message-Id: <20200928072043.9359-4-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200928072043.9359-1-krish.sadhukhan@oracle.com>
References: <20200928072043.9359-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 malwarescore=0 adultscore=0 suspectscore=1 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280061
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9757 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280061
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
 x86/svm_tests.c | 52 +++++++++++++++++++++++++++++++++++++++++++------
 2 files changed, 48 insertions(+), 7 deletions(-)

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
index 1908c7c..6c97ee3 100644
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

