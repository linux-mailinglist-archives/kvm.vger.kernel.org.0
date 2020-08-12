Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4D8242366
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 02:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbgHLA3s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 20:29:48 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42216 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726485AbgHLA3r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 20:29:47 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07C0Ih45003408;
        Wed, 12 Aug 2020 00:29:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=n4dbQ/XCFjZvEExTUPt6UpTRlkMau3E9UKnX9elN3PA=;
 b=P17Iv2WvuGXtKKGLwSPxIOtXNtloM0TIRkFFOvEsCGOn2QP5x1sMtxXaHJo+Ohyb3TX7
 xZePM+7e3bzbSb+HbGt/oYJOZ1ihsBnuVJGQCMDRMS5cdYq0tIV+WTgXW8PTudtMTmVD
 qpvETtSGtZGbSqENI1Gpu/SpqEfRm9XNmZi1rP8qkA4luuWZximdZpgRzuMl5DzOiIqN
 P6o4VcDdsevmE1CJF0c7nYaZ3pJbXlyH0J5FfPBCdccZtYje0x4nkaH9HDVtgSECPr2d
 puDHBWmUWnkd19qBFJiyJBpIjjmVlqzU0kugjAHyBHcWV0zeao3rcgWZmfKMlPKFj3wP TQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 32t2ydp66g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 12 Aug 2020 00:29:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07C0DJ05131199;
        Wed, 12 Aug 2020 00:29:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 32t5y5cnbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Aug 2020 00:29:44 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07C0Tgnp026388;
        Wed, 12 Aug 2020 00:29:43 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 12 Aug 2020 00:29:42 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH v3] nSVM: Test illegal combinations of EFER.LME, CR0.PG, CR0.PE and CR4.PAE in VMCB
Date:   Wed, 12 Aug 2020 00:29:35 +0000
Message-Id: <20200812002935.48365-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200812002935.48365-1-krish.sadhukhan@oracle.com>
References: <20200812002935.48365-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=1 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=852 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008120000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=834 priorityscore=1501
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 phishscore=0 adultscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008120000
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol. 2
the following guest state combinations are illegal:

	* EFER.LME and CR0.PG are both set and CR4.PAE is zero.
	* EFER.LME and CR0.PG are both non-zero and CR0.PE is zero.
	* EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
---
 x86/svm_tests.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1908c7c..459dd72 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1962,7 +1962,51 @@ static void test_efer(void)
 	SVM_TEST_REG_RESERVED_BITS(16, 63, 4, "EFER", vmcb->save.efer,
 	    efer_saved, SVM_EFER_RESERVED_MASK);
 
+	/*
+	 * EFER.LME and CR0.PG are both set and CR4.PAE is zero.
+	 */
+	u64 cr0_saved = vmcb->save.cr0;
+	u64 cr0;
+	u64 cr4_saved = vmcb->save.cr4;
+	u64 cr4;
+
+	efer = efer_saved | EFER_LME;
+	vmcb->save.efer = efer;
+	cr0 = cr0_saved | X86_CR0_PG | X86_CR0_PE;
+	vmcb->save.cr0 = cr0;
+	cr4 = cr4_saved & ~X86_CR4_PAE;
+	vmcb->save.cr4 = cr4;
+	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
+	    "CR0.PG=1 (%lx) and CR4.PAE=0 (%lx)", efer, cr0, cr4);
+
+	/*
+	 * EFER.LME and CR0.PG are both set and CR0.PE is zero.
+	 */
+	vmcb->save.cr4 = cr4_saved | X86_CR4_PAE;
+	cr0 &= ~X86_CR0_PE;
+	vmcb->save.cr0 = cr0;
+	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
+	    "CR0.PG=1 and CR0.PE=0 (%lx)", efer, cr0);
+
+	/*
+	 * EFER.LME, CR0.PG, CR4.PAE, CS.L, and CS.D are all non-zero.
+	 */
+	u32 cs_attrib_saved = vmcb->save.cs.attrib;
+	u32 cs_attrib;
+
+	cr0 |= X86_CR0_PE;
+	vmcb->save.cr0 = cr0;
+	cs_attrib = cs_attrib_saved | SVM_SELECTOR_L_MASK |
+	    SVM_SELECTOR_DB_MASK;
+	vmcb->save.cs.attrib = cs_attrib;
+	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
+	    "CR0.PG=1 (%lx), CR4.PAE=1 (%lx), CS.L=1 and CS.D=1 (%x)",
+	    efer, cr0, cr4, cs_attrib);
+
+	vmcb->save.cr0 = cr0_saved;
+	vmcb->save.cr4 = cr4_saved;
 	vmcb->save.efer = efer_saved;
+	vmcb->save.cs.attrib = cs_attrib_saved;
 }
 
 static void test_cr0(void)
-- 
2.18.4

