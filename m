Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49D0D242273
	for <lists+kvm@lfdr.de>; Wed, 12 Aug 2020 00:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726179AbgHKW0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Aug 2020 18:26:06 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43270 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbgHKW0G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Aug 2020 18:26:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07BMMoDa029220;
        Tue, 11 Aug 2020 22:26:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=corp-2020-01-29;
 bh=j+QIbryDM816c8or5qAtzjNLcN/qyAOC1CKju0VyeVk=;
 b=x2sATOwrEINLyXiQy20+MPJmyGS7Amnk2tbzr5kLPBiL+HTiSpnLILaysBbfiFUpILFq
 ELI0vBByZ1pyH6fUg+J/ZEHOvh4yRJqXw5cuoS59N9ofOtTidIdSoOd+uQlR0JcFpJDw
 a5NwMlJh2O1EUGc/rXIazMAhFYieJavuX9YOLjsdGMqhyxeWG/IduJZ3a74Pp96wkyKJ
 pVlAH6wLcDLGeK7S7mpmMZRlWFfwO0jmJdcSbwC2XYKoTXbonfwo96duWObGIm5ivF2h
 ALWk3USLI6aJ2wLz2VvOwdrsKs2LxwGyHou9lzqt7TXNCFQLBMElTu9hp5h08ZvnI0PZ zQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 32sm0mqf9w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 11 Aug 2020 22:26:04 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07BMNMZu094639;
        Tue, 11 Aug 2020 22:24:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 32t5y54rpx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Aug 2020 22:24:03 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07BMO3GU027586;
        Tue, 11 Aug 2020 22:24:03 GMT
Received: from nsvm-sadhukhan-1.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 11 Aug 2020 22:24:03 +0000
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH v2] kvm-unit-tests: nSVM: Test combination of EFER.LME, CR0.PG and CR4.PAE on VMRUN of nested guests
Date:   Tue, 11 Aug 2020 22:23:53 +0000
Message-Id: <20200811222353.41414-2-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200811222353.41414-1-krish.sadhukhan@oracle.com>
References: <20200811222353.41414-1-krish.sadhukhan@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=15 mlxscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxlogscore=948 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008110161
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9710 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 clxscore=1015
 suspectscore=15 mlxlogscore=930 priorityscore=1501 adultscore=0
 impostorscore=0 spamscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008110161
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
 x86/svm_tests.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1908c7c..1c37ba2 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1962,7 +1962,52 @@ static void test_efer(void)
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
+	cr0 = cr0 | X86_CR0_PE;
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

