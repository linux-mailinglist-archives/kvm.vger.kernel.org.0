Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE3E481045
	for <lists+kvm@lfdr.de>; Wed, 29 Dec 2021 07:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238911AbhL2GWh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Dec 2021 01:22:37 -0500
Received: from mail-co1nam11on2071.outbound.protection.outlook.com ([40.107.220.71]:57217
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238906AbhL2GWg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Dec 2021 01:22:36 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KqRT2MyMshcF9IE6Ho8YuNDXqfoZpvxv5YUPVMHaXjQDJHfq5hd8vbWPcf8yN1smQ9OO2WqydhSjc6cCkEvenoCx7O6lNMNW4+EVdEdwxDtSgscytR0bRlx2aG4O4h45894SzBoqQKzz5r5uITGs3n+tFep87VJsX7jzrhAewO5P68gDsjxtjIYZMJkIx1586050y6e4QcpJG32DgCMGkw2zZGTUUjJMjl7PX7Y3BzU/Dio4pjSW0gzW8SmCy3Jnpbb6iaUx8scsy8bW7i6ppG0AGLIMxMdJZJLM3tuLyM5hjNjnDyDij/VaK1+BTM5j6TtlUDDeqdrbZUMt0VlRlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JfK4po0pfFKOqsjGQdvXI9ymDQH41ErxopaRIqphZng=;
 b=Bs0pLil/0l+ZhFreWqDlNjQX7oi6mde9G2bBY+ocTC+LA5NerKYC2q4bK5I/qqVQBU9G8Gxx9J8EbNwc9qp9r7da2n7YKhiZkGhkyQC+qHArkN5fl1ewUuRb2rKmXtWrEj9F2ilaJCdtP3mck690memqihaoDuSq1fDaky/k/kN3Fn0B5dS361PBSkfwoRAIIX+r4MEq/6zzdyHx6jdNomzX44uHF+o7dcNoS1VHa3+P2OI/Q8tDl3rM0SJo2mC3x1+YNLJeSlI6N7IHE1qtfAuAOM1dRSfZBWimqFa6prsIVH8STOqSIHdnyJjbJKwTlCt3aeathHcOCVIYrVYd7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JfK4po0pfFKOqsjGQdvXI9ymDQH41ErxopaRIqphZng=;
 b=J6zcOYRWNgFr1KcjpY3v3GPy01cwZNqlhD5whfQFnJmNN2xZEaraJwgNLdJMCJDEcCHmP4PanS0UskFsVsmnVXj0W31vfYd3rK2gHvuMlB+rFqLmF3pz54rJDDuSFf+xyuAFEuikDr3HAZeDCPoq36tCaH1aWN7eiFYR6lYc6ME=
Received: from DM5PR18CA0057.namprd18.prod.outlook.com (2603:10b6:3:22::19) by
 PH0PR12MB5420.namprd12.prod.outlook.com (2603:10b6:510:e8::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4823.16; Wed, 29 Dec 2021 06:22:34 +0000
Received: from DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:22:cafe::7e) by DM5PR18CA0057.outlook.office365.com
 (2603:10b6:3:22::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4844.14 via Frontend
 Transport; Wed, 29 Dec 2021 06:22:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT031.mail.protection.outlook.com (10.13.172.203) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4844.14 via Frontend Transport; Wed, 29 Dec 2021 06:22:34 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Wed, 29 Dec
 2021 00:22:33 -0600
From:   Manali Shukla <manali.shukla@amd.com>
To:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH 1/3] x86: nSVM: Check #NM exception handling in L2
Date:   Wed, 29 Dec 2021 06:21:59 +0000
Message-ID: <20211229062201.26269-2-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211229062201.26269-1-manali.shukla@amd.com>
References: <20211229062201.26269-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8799452-bd89-4c47-f0de-08d9ca939a4f
X-MS-TrafficTypeDiagnostic: PH0PR12MB5420:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB5420384F12E4EE81D8DE8865FD449@PH0PR12MB5420.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wIApM2nunwrC4ufScLueZGp4UHgieke7H+VkWNRfTW68BLs+FLw2IcCQusZfqCrS3btlEszp2bLppe3RtPYxk/xukRjuZ8qzjA4w8JauSEDj/vjX9/KhAn2YxdALqqjn1/H6nj46nDdp9t/yGpF4sDATclvbPYgaY7SDbmEzlUwnZoxbFNMR9rX34CTvHs2TvIGd+DTjh1c980Ilo5CPZqXhFw/zdiSopKvhOoWvDto3+0ac6X5p9buFwadaayWuCRo4YDydAS+2J0nAsUPGTciPN2s1HmY+M5zMeBDn9wDuW8Zhz5ZFUXBCdvazpz6z9TM3IFYF1jLfMdJFNnEF9ePJSEofhVXw8A185axPIaV+xQCU+Gu0/EZOItWsSEx8Hqdy2zAqNz+7qRqNkojkr1nDvgaqwFhSrq+vWr1QyCwM6VFtEYRGG5DEXG9ylWecVCn8cbwpNtVbief92t5AbXpFR45EkWMFttrsXwSsjJxuNwYARIZ1FQTassAyr1lNdRCL2BcAKOXQymXSjdfARJxIhFPMIUJz+E98TxvBZgoHN31xQKeeXiS3svIgDeZs7f31wtSmNWV0nqZNjpKnxFAUJ4j6wz6M8V7xPM/CboW+OTrpxo3jmFNNl/v0wdy8wnTA3kLzQjhXlq9D5n+H6UsGJJfKY7dWpyqrCfEUzwjqP6zG2KDyF39YmKokJQpnAE7WpL93aLiQaQL3e4Kje8qF+nMovi6J12YgAWw9Y5ksgd4U7WSTzvxO4Qa3WqOjMOVXwLtfv8NjlJZeqyJjsWzixTwpcOmTVY3V1t1W/mQ=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(40470700002)(46966006)(426003)(47076005)(1076003)(26005)(508600001)(36860700001)(8676002)(356005)(6916009)(7696005)(70586007)(70206006)(44832011)(81166007)(82310400004)(6666004)(2906002)(186003)(16526019)(36756003)(316002)(5660300002)(86362001)(2616005)(336012)(40460700001)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Dec 2021 06:22:34.6631
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f8799452-bd89-4c47-f0de-08d9ca939a4f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5420
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add coverage for NM exception handling in L2 when only L2 NM
exception handler is registered

Verifies 3 different conditions for which #NM is generated and
handled in L2
1) CR0.TS is set - #NM is generated and handled in L2 exception
   handler
2) CR0.TS is cleared and CR0.EM is set - #NM is generated and
   handled in L2 exception handler
3) CR0.TS and CR0.EM are cleared - #NM is not generated

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm_tests.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 8ad6122..681272c 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2962,6 +2962,50 @@ static bool vgif_check(struct svm_test *test)
     return get_test_stage(test) == 3;
 }
 
+static int nm_test_counter;
+
+static void guest_test_nm_handler(struct ex_regs *r)
+{
+    nm_test_counter++; 
+    write_cr0(read_cr0() & ~X86_CR0_TS);
+    write_cr0(read_cr0() & ~X86_CR0_EM);
+}
+
+static void svm_nm_test_guest(struct svm_test *test)
+{
+    asm volatile("fnop");
+}
+
+/* This test checks that:
+ *
+ * (a) If CR0.TS is set in L2, #NM is handled by L2 when
+ *     just an L2 handler is registered.
+ *
+ * (b) If CR0.TS is cleared and CR0.EM is set, #NM is handled
+ *     by L2 when just an l2 handler is registered.
+ *
+ * (c) If CR0.TS and CR0.EM are cleared in L2, no exception
+ *     is generated.
+ */
+
+static void svm_nm_test(void)
+{
+    handle_exception(NM_VECTOR, guest_test_nm_handler);
+    write_cr0(read_cr0() & ~X86_CR0_TS);
+    test_set_guest(svm_nm_test_guest);
+
+    vmcb->save.cr0 = vmcb->save.cr0 | X86_CR0_TS;
+    report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 1,
+        "fnop with CR0.TS set in L2, #NM is triggered");
+
+    vmcb->save.cr0 = (vmcb->save.cr0 & ~X86_CR0_TS) | X86_CR0_EM;
+    report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
+        "fnop with CR0.EM set in L2, #NM is triggered");
+
+    vmcb->save.cr0 = vmcb->save.cr0 & ~(X86_CR0_TS | X86_CR0_EM);
+    report(svm_vmrun() == SVM_EXIT_VMMCALL && nm_test_counter == 2,
+        "fnop with CR0.TS and CR0.EM unset no #NM excpetion");
+}
 
 struct svm_test svm_tests[] = {
     { "null", default_supported, default_prepare,
@@ -3082,5 +3126,6 @@ struct svm_test svm_tests[] = {
     TEST(svm_vmrun_errata_test),
     TEST(svm_vmload_vmsave),
     TEST(svm_test_singlestep),
+    TEST(svm_nm_test),
     { NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
-- 
2.30.2

