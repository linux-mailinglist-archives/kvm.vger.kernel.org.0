Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03A4053C41B
	for <lists+kvm@lfdr.de>; Fri,  3 Jun 2022 07:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240378AbiFCFSF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jun 2022 01:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239190AbiFCFSB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jun 2022 01:18:01 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2045.outbound.protection.outlook.com [40.107.102.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC29CDB
        for <kvm@vger.kernel.org>; Thu,  2 Jun 2022 22:17:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pu8G1gk1Dc8pJ392eZ8GSMgS641SAGw2hR2G3aCJyP5IxaSrsXZZQWVT1KheOrDbFc9Uv3Llwa/lflY1wEaLSo/VYnRECLvDaOpMgsquCsCo/KZ0+cxOAsSGB3v/qsBgqwxoBEg5xb4OilVk+649G76F80UU8GxGCVqFEsbwudpGc5n9KS86KKUO94Yb2WwQCYByTzmlCvmH6WFWc6NkYFLeBB1FlGtm1sHFj6Giy21+xIkimAsJbOvA/HoH7n+cn3vplJtrVPRJgO09DIanLj1RCZIBlyfUeTTfmrw4EHlfhCqnpNeCBSNp5qJqB7YuBgoVNveWhh/snym/TY6BSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eAM8Bnv2hFdtLMRBwveNtxVS5OtMdd7kRdX/j9jPnnw=;
 b=EHCONUDmgTle8Jl0zPnCGTp7i/Q/cBhRKsH1lGSupB9Meoo82O33i88/SL5/cF5nfSG7ZAVPo+xW9xsJpTVIhcsYZiK43Pnt4h8o7xOieHbtmyw9ZsF76XLHCUdg33fT8b6l/zQfhyQCLKM73TnnJNSfUHajWiTT2FUK21PI7TDPQpxchKAJ0cWaZXXordPz2fVsZrfp/LG+gX6DHu6E1tfyB2fDH2AGyOMNHM2XNeCBUk9QiqJUGXdbdyIwGxT1rDfG3+erA6Y275TeVgVnRmltHTMO8sQEl6U866jOXGfeAsJT2/nU+cFKHmkJ00K+c4NIRPOGtrrMlkxrUpPHYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eAM8Bnv2hFdtLMRBwveNtxVS5OtMdd7kRdX/j9jPnnw=;
 b=GKK26rWoVmLXVAZ1SR3KCHORifXoLCqQNrAxgd1649RTbHDtllCTwrPgbuHzbi+oc6V54hVZxAGtynJVQLT/AHDc9P/gLzfJRj6YzkMmpWW/UhnTMfkFe7n3/yKLROVvnTKImr1IQVD8DCNycLLHRBjBWHyyL2fPuZRFULKNV7Y=
Received: from DM5PR13CA0045.namprd13.prod.outlook.com (2603:10b6:3:7b::31) by
 DS7PR12MB6213.namprd12.prod.outlook.com (2603:10b6:8:97::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12; Fri, 3 Jun 2022 05:17:55 +0000
Received: from DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:7b:cafe::a4) by DM5PR13CA0045.outlook.office365.com
 (2603:10b6:3:7b::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.5 via Frontend
 Transport; Fri, 3 Jun 2022 05:17:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT037.mail.protection.outlook.com (10.13.172.122) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5314.12 via Frontend Transport; Fri, 3 Jun 2022 05:17:55 +0000
Received: from BLR-5CG113396M.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 3 Jun
 2022 00:17:53 -0500
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <Santosh.Shukla@amd.com>
Subject: [kvm-unit-tests PATCH] x86: nSVM: Add support for VNMI test
Date:   Fri, 3 Jun 2022 10:47:43 +0530
Message-ID: <20220603051743.4253-1-santosh.shukla@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 67fa9fd8-f10a-4e9b-073f-08da45206ac3
X-MS-TrafficTypeDiagnostic: DS7PR12MB6213:EE_
X-Microsoft-Antispam-PRVS: <DS7PR12MB6213BEB8875C3E0ACE6C9D5C87A19@DS7PR12MB6213.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R6uhioM1IX5ODa0aUbqMCQyDV54xwN7K1RMaTiC2irdB/+VaIpO8zNTL23D7PBWqQJQ0zHiBLQj2EvnGNeiD22ah17wfHBbL6/JkEYdNlWh3RKWg4SKsrA2WSblANTlZTy9+t8vLg97P/aXzAtDdXU4sGgwFom7mFup1qUitAyy/MbXE3cq4BavpLqKJyowL0klTaJyUQeaDsx5C1YpS5UDFVGJ7yBGzLZCJwnxyBsBFluypR0ZTaRnQD5eU7iKHKTQ86tUkC8nyjphgiYPL/s0vxP5rVbpeKUZ9qd+dVb4epkO384GMLmyridfrK3pEt0yRdZ+XYjj1+tIFnGYXCCbu2UbPp5NdmW81b3VuxgQCGveza8Lc2YBLIk40SUR/Lt46H7fe4x91LeSSJroAdkrgyUzOmYfwhLe6Kz92Vhiy8L1zgglUVpL0jOQZOuq/bVxRsA94tl/uP+jz2nsrelWM4qAnZda4gmaRnZdOlVOBiGUfIoprMgzgH7VEgCzDBEZT+diwd/nKmNEJAPMxUpJUx3mXt+jO1G2mCtFYGkMKPsCp+yW/laRKD0/CUJCEolEc+7WVKJYus4aKGFBoqPKacE4Cz0hy4eRCmETuaGazKLER3IyX0dy5OX3vDNO5WpPzxlPfWewAJdQZjXG1N6Zx7mr2MqU0aVDpNRMWnXhkDoouJCIczglIu81oINmT2fMw4VwgvXDvJKc24A5a/g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(7696005)(6666004)(508600001)(81166007)(8676002)(4326008)(70586007)(5660300002)(36756003)(36860700001)(70206006)(316002)(2906002)(8936002)(2616005)(44832011)(6916009)(86362001)(186003)(1076003)(16526019)(40460700003)(26005)(82310400005)(426003)(336012)(356005)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 05:17:55.7845
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67fa9fd8-f10a-4e9b-073f-08da45206ac3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6213
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a VNMI test case to test Virtual NMI in a nested environment,
The test covers the Virtual NMI (VNMI) event delivery.

Signed-off-by: Santosh Shukla <santosh.shukla@amd.com>
---
 lib/x86/processor.h |  1 +
 x86/svm.c           |  5 +++
 x86/svm.h           |  8 +++++
 x86/svm_tests.c     | 79 +++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 93 insertions(+)

diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 9a0dad677870..cd86b5d60545 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -193,6 +193,7 @@ static inline bool is_intel(void)
 #define X86_FEATURE_PAUSEFILTER     (CPUID(0x8000000A, 0, EDX, 10))
 #define X86_FEATURE_PFTHRESHOLD     (CPUID(0x8000000A, 0, EDX, 12))
 #define	X86_FEATURE_VGIF		(CPUID(0x8000000A, 0, EDX, 16))
+#define	X86_FEATURE_V_NMI		(CPUID(0x8000000A, 0, EDX, 25))
 
 
 static inline bool this_cpu_has(u64 feature)
diff --git a/x86/svm.c b/x86/svm.c
index 93794fdfd7a2..2073c52fdb49 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -110,6 +110,11 @@ bool npt_supported(void)
 	return this_cpu_has(X86_FEATURE_NPT);
 }
 
+bool vnmi_supported(void)
+{
+	return this_cpu_has(X86_FEATURE_V_NMI);
+}
+
 int get_test_stage(struct svm_test *test)
 {
 	barrier();
diff --git a/x86/svm.h b/x86/svm.h
index e93822b66bab..98c237ba4aa3 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -131,6 +131,13 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define V_INTR_MASKING_SHIFT 24
 #define V_INTR_MASKING_MASK (1 << V_INTR_MASKING_SHIFT)
 
+#define V_NMI_PENDING_SHIFT 11
+#define V_NMI_PENDING (1 << V_NMI_PENDING_SHIFT)
+#define V_NMI_MASK_SHIFT 12
+#define V_NMI_MASK (1 << V_NMI_MASK_SHIFT)
+#define V_NMI_ENABLE_SHIFT 26
+#define V_NMI_ENABLE (1 << V_NMI_ENABLE_SHIFT)
+
 #define SVM_INTERRUPT_SHADOW_MASK 1
 
 #define SVM_IOIO_STR_SHIFT 2
@@ -418,6 +425,7 @@ void default_prepare(struct svm_test *test);
 void default_prepare_gif_clear(struct svm_test *test);
 bool default_finished(struct svm_test *test);
 bool npt_supported(void);
+bool vnmi_supported(void);
 int get_test_stage(struct svm_test *test);
 void set_test_stage(struct svm_test *test, int s);
 void inc_test_stage(struct svm_test *test);
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 1bd4d3b20505..e331d5cc97ed 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -1624,6 +1624,82 @@ static bool nmi_hlt_check(struct svm_test *test)
     return get_test_stage(test) == 3;
 }
 
+static volatile bool vnmi_fired;
+static void vnmi_handler(isr_regs_t *regs)
+{
+    vnmi_fired = true;
+}
+
+static void vnmi_prepare(struct svm_test *test)
+{
+    default_prepare(test);
+    vnmi_fired = false;
+    vmcb->control.int_ctl = V_NMI_ENABLE;
+    vmcb->control.int_vector = NMI_VECTOR;
+    handle_irq(NMI_VECTOR, vnmi_handler);
+    set_test_stage(test, 0);
+}
+
+static void vnmi_test(struct svm_test *test)
+{
+    if (vnmi_fired) {
+        report(!vnmi_fired, "vNMI dispatched even before injection");
+        set_test_stage(test, -1);
+    }
+
+    vmmcall();
+
+    if (!vnmi_fired) {
+        report(vnmi_fired, "pending vNMI not dispatched");
+        set_test_stage(test, -1);
+    }
+    report(vnmi_fired, "vNMI delivered to guest");
+
+    vmmcall();
+}
+
+static bool vnmi_finished(struct svm_test *test)
+{
+    switch (get_test_stage(test)) {
+    case 0:
+        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+            report_fail("VMEXIT not due to error. Exit reason 0x%x",
+                        vmcb->control.exit_code);
+            return true;
+        }
+        report(!vnmi_fired, "vNMI with vector 2 not injected");
+        vmcb->control.int_ctl |= V_NMI_PENDING;
+        vmcb->save.rip += 3;
+        break;
+
+    case 1:
+        if (vmcb->control.exit_code != SVM_EXIT_VMMCALL) {
+            report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+                        vmcb->control.exit_code);
+            return true;
+        }
+        if (vmcb->control.int_ctl & V_NMI_MASK) {
+            report_fail("V_NMI_MASK not cleared on VMEXIT");
+            return true;
+        }
+        report_pass("VNMI serviced");
+        vmcb->save.rip += 3;
+        break;
+
+    default:
+        return true;
+    }
+
+    inc_test_stage(test);
+
+    return get_test_stage(test) == 2;
+}
+
+static bool vnmi_check(struct svm_test *test)
+{
+    return get_test_stage(test) == 2;
+}
+
 static volatile int count_exc = 0;
 
 static void my_isr(struct ex_regs *r)
@@ -3729,6 +3805,9 @@ struct svm_test svm_tests[] = {
     { "nmi_hlt", smp_supported, nmi_prepare,
       default_prepare_gif_clear, nmi_hlt_test,
       nmi_hlt_finished, nmi_hlt_check },
+    { "vnmi", vnmi_supported, vnmi_prepare,
+      default_prepare_gif_clear, vnmi_test,
+      vnmi_finished, vnmi_check },
     { "virq_inject", default_supported, virq_inject_prepare,
       default_prepare_gif_clear, virq_inject_test,
       virq_inject_finished, virq_inject_check },
-- 
2.25.1

