Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4062F4211
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 03:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbhAMCt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 21:49:28 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:44020 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbhAMCt1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jan 2021 21:49:27 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D2iQIe069762;
        Wed, 13 Jan 2021 02:48:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=PsWu26ET1Aroe/GiEox5JHJTetUd/Z+jgu1B15egZvs=;
 b=r7ozzFYd8TAYnnaAzH8KgsgkgSS1V8kfeYlclk+19pd2OgkeDdnvcPZKXW3iua21vzV1
 x197GhBF6ifkWXP1Y15drluUgkjZ9of0EYTX2K2QPuLhooQt4O2z17gOqvLq5UDQEk8r
 MBJiKN2Oq5P9JewGYeCbCmSYtyxF9rsPwUitfNsWh5XABnGibVACjoOFM6TkyKljgUSA
 0UWxLMM9hh0TEIaiibQAtNUXmzo68ln+rd/rJShmqvwDu+HYbo9Mb3QHcgNXnxe0ti9/
 9Azexpn7UN/FgYwubgJj6doTwejP/4iqigj3jE72O55V6C3VMvo46yAGTic/BfUARW/k DA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 360kg1sbb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 02:48:43 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D2k4Rg147683;
        Wed, 13 Jan 2021 02:46:43 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 360keytnm2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 02:46:42 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 10D2kfFC006720;
        Wed, 13 Jan 2021 02:46:41 GMT
Received: from nsvm-sadhukhan.osdevelopmeniad.oraclevcn.com (/100.100.230.216)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 Jan 2021 18:46:41 -0800
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com
Subject: [PATCH 2/3] Test: nSVM: Test MSR and IO bitmap address
Date:   Wed, 13 Jan 2021 02:46:32 +0000
Message-Id: <20210113024633.8488-3-krish.sadhukhan@oracle.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210113024633.8488-1-krish.sadhukhan@oracle.com>
References: <20210113024633.8488-1-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 clxscore=1015 impostorscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130014
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

According to section "Canonicalization and Consistency Checks" in APM vol 2,
the following guest state is illegal:

    "The MSR or IOIO intercept tables extend to a physical address that
     is greater than or equal to the maximum supported physical address."

Also test that these addresses are aligned on page boundary.

Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
---
 x86/svm_tests.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index dc86efd..929a3e1 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2304,6 +2304,43 @@ static void test_dr(void)
 	vmcb->save.dr7 = dr_saved;
 }
 
+extern u8 msr_bitmap_area[];
+extern u8 io_bitmap_area[];
+
+#define TEST_BITMAP_ADDR(prot_type, bitmap_addr, msg)  {                \
+	vmcb->control.intercept = 1ULL << prot_type;                    \
+	addr_unalign = virt_to_phys(bitmap_addr);                       \
+	if (prot_type == INTERCEPT_MSR_PROT)                            \
+		vmcb->control.msrpm_base_pa = addr_unalign;             \
+	else                                                            \
+		vmcb->control.iopm_base_pa = addr_unalign;              \
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test %s address: %lx", msg,\
+	    addr_unalign);                                              \
+	vmcb->control.msrpm_base_pa = addr_spill_beyond_ram;            \
+	report(svm_vmrun() == SVM_EXIT_ERR, "Test %s address: %lx", msg,\
+	    addr_spill_beyond_ram);                                     \
+}                                                                       \
+
+/*
+ * If the MSR or IOIO intercept table extends to a physical address that
+ * is greater than or equal to the maximum supported physical address, the
+ * guest state is illegal.
+ *
+ * [ APM vol 2]
+ */
+static void test_msrpm_iopm_bitmap_addrs(void)
+{
+	u64 addr_unalign;
+	u64 addr_spill_beyond_ram =
+	    (u64)(((u64)1 << cpuid_maxphyaddr()) - 4096);
+
+	/* MSR bitmap address */
+	TEST_BITMAP_ADDR(INTERCEPT_MSR_PROT, msr_bitmap_area, "MSRPM");
+
+	/* MSR bitmap address */
+	TEST_BITMAP_ADDR(INTERCEPT_IOIO_PROT, io_bitmap_area, "IOPM");
+}
+
 static void svm_guest_state_test(void)
 {
 	test_set_guest(basic_guest_main);
@@ -2313,6 +2350,7 @@ static void svm_guest_state_test(void)
 	test_cr3();
 	test_cr4();
 	test_dr();
+	test_msrpm_iopm_bitmap_addrs();
 }
 
 struct svm_test svm_tests[] = {
-- 
2.27.0

