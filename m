Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CBA24134E
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 00:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgHJWkU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 18:40:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:33088 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgHJWkU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 18:40:20 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07AMVnvu139859;
        Mon, 10 Aug 2020 22:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id; s=corp-2020-01-29;
 bh=UXEW9jo2ubap1L0jIA9ExRp2jPQwMgBNiy7G8DeReJI=;
 b=AsB9aKMnLmneYcWroWuDeTzSve6gJqZKs5OK6OgyWDhBXNQl9YwmuZlY/o0TyPdZBSWI
 nE+fuz5hOKCLzZ7yELYouwliL/aPFD5a80EJ5YK3aDhkIvDd+7dG+0zqeinVCRaJDZ7f
 s1oWLo+rkal4984clkiwyVVcxDUOAZZwfi2RGv4R9vFLJB/i1i9fGO1lw8s/qAjOgjM/
 wtMhwqItRgnee5uK/oLjgrXVJFifON5LDYyEw1qmu65BrgZhFSesMLELSe/hTohxQqUe
 ahAEahRCeuNoDkuGG7LeuzJ/qeRiYx0U9GExFG9BdEMpD1bGIRA5lsL4fj+l770M237Z XA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 32t2ydfrnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 10 Aug 2020 22:40:16 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07AMcMwG092600;
        Mon, 10 Aug 2020 22:40:16 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 32t5yxkjvk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Aug 2020 22:40:16 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07AMeFto021275;
        Mon, 10 Aug 2020 22:40:15 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 10 Aug 2020 22:40:07 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH] KVM: nSVM: Test combinations of EFER.LME, CR0.PG, CR4.PAE, CR0.PE and CS register on VMRUN of nested guests
Date:   Mon, 10 Aug 2020 22:39:27 +0000
Message-Id: <20200810223927.82895-1-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9709 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 bulkscore=0 adultscore=0 spamscore=0 suspectscore=1 mlxlogscore=918
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008100155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9709 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=894 priorityscore=1501
 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 bulkscore=0
 suspectscore=1 phishscore=0 adultscore=0 spamscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008100154
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
---
 x86/svm_tests.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1908c7c..43208fd 100644
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
+	cr0 = cr0_saved | X86_CR0_PG;
+	vmcb->save.cr0 = cr0;
+	cr4 = cr4_saved & ~X86_CR4_PAE;
+	vmcb->save.cr4 = cr4;
+	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
+	    "CR0.PG=1 (%lx) and CR4.PAE=0 (%lx)", efer, cr0, cr4);
+
+	/*
+	 * EFER.LME and CR0.PG are both set and CR0.PE is zero.
+	 */
+	vmcb->save.cr4 = cr4_saved;
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
+	cr4 = cr4_saved | X86_CR4_PAE;
+	vmcb->save.cr4 = cr4;
+	cs_attrib = cs_attrib_saved | SVM_SELECTOR_L_MASK |
+	    SVM_SELECTOR_DB_MASK;
+	vmcb->save.cs.attrib = cs_attrib;
+	report(svm_vmrun() == SVM_EXIT_ERR, "EFER.LME=1 (%lx), "
+	    "CR0.PG=1 (%lx), CR4.PAE=1 (%lx), CS.L=1 and CS.D=1 (%x)",
+	    efer, cr0, cr4, cs_attrib);
+
+	vmcb->save.cr4 = cr4_saved;
+	vmcb->save.cs.attrib = cs_attrib_saved;
 	vmcb->save.efer = efer_saved;
+	vmcb->save.cr0 = cr0_saved;
 }
 
 static void test_cr0(void)
-- 
2.18.4

