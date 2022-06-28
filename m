Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5585555D035
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344744AbiF1Llh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 07:41:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344184AbiF1Llf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 07:41:35 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2074.outbound.protection.outlook.com [40.107.95.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED5C2ED4B
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 04:41:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jfglkAQ9kYnVToCjjMd1TEmzbgRBJDkpst2inuhKnPVAkAul7IKy5eywsinbNDA+cLw6/coD3LPgYwDxEmBJ/fJmvHnpyrsMihFFP/KnExZIScxlRZgNwe2my7Z/QydtRnC4NVKxRQzu9+ksD/HQ4brz3HFiZ0xE0SYNcuG7vjr9csn2noOpBoIZLDX+Q8FN/4ecX4r/Lc5BT6Pkk7R8etx5EUgl4OF/5L04ZhkKH81HBtP7068VX+zMfCyZsYaZnq95RRaM10WKRZMZ8OHQB9oX44BXayEjE/YIp3Y45Uco5Yqcp/jtucrtEDfJA2rzVaaEfhuTDyrsjpTE5sqTkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AAERBgaLN2Nj85nZZbMvqaU40jQ/5ZGW3llvqXlWzSE=;
 b=GduD231YSNm+qiEUEOm8DotLpg7ZutkQtWdK+CtPK71jWh2/DOdPNHXy6vxU8wDCbv2/eqaBTGb9cUNZVn0qdPuJdpe6RaeCb9psvGY3GcmFGbk13U2averf7OelIaezKka8V1A24AJS+WS0FLnt3nY+Kx4g5NP45S9qBKAlVAlp1gymH2fxoXDs06F+h7dS3L2RriVcgl6l7vYO0XL1OFjLSbUjo0wygnSQYrH4xosKo0B+4+vfLtES0ZS8FoOieVC2aRjLngfcsgm11F/+pLaewKBELOR6MuHpNLRODAEh2xw6+RetSqwxAdcxgfSYeb5TKLxvmvUDD9gBbJuLHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAERBgaLN2Nj85nZZbMvqaU40jQ/5ZGW3llvqXlWzSE=;
 b=nA25R43HZUja275JwB3FTL3AaJ3OR5JL/nWtDTy4HEIHb6TpDPU+12GFSO+1eTGgLyMiGARGnI93CzD3hWWeLm0PFHvkAuramuclCqMQope1MeNYiAfDGbdfWTLCq3r3BdfOWrbSVKyV34trObmDY+rLn8vu6XSNAbfClH2TLkQ=
Received: from BN0PR04CA0111.namprd04.prod.outlook.com (2603:10b6:408:ec::26)
 by PH7PR12MB5710.namprd12.prod.outlook.com (2603:10b6:510:1e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Tue, 28 Jun
 2022 11:41:32 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ec:cafe::45) by BN0PR04CA0111.outlook.office365.com
 (2603:10b6:408:ec::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Tue, 28 Jun 2022 11:41:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5373.15 via Frontend Transport; Tue, 28 Jun 2022 11:41:32 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Tue, 28 Jun
 2022 06:41:30 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v5 6/8] x86: nSVM: Correct indentation for svm.c
Date:   Tue, 28 Jun 2022 11:38:51 +0000
Message-ID: <20220628113853.392569-7-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220628113853.392569-1-manali.shukla@amd.com>
References: <20220628113853.392569-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84cded20-dcc5-4893-94b8-08da58fb25e5
X-MS-TrafficTypeDiagnostic: PH7PR12MB5710:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MqG4tvaq+uriLZ2r3CGlxtLczCXuX0yCEyp6QAfGnzoAGKmesiK8FTsHXeTiY2z597BzUXdN4yqkg7mZV4wMqOpCWQnne2bb4oKhJuLItryTHW0v3/wFI/asedmyxHg7L7M8bcAxyHyja9wooA9U2Yb4s16oINkgEPfjv79qvvjyTC9gCRblAP2qIdrj30FXvHULBuWuQ7EBkP4Cs1ivorIdiY1x75KAKBQw9/4MNCsoYJD1ilPwv9kJGN3iukUhQzh0MUUUbR48oMtRLMKzYxGiqVsi+UGs4MRSZeQ45rxRD4EpuIfEE2uIg7jwTjTF+y8nxjsk9G9+e2yHX2nkF1TsZgNEnMf0N5bqaKDf1AosLMiOguad3RICJoz5OTpt9A1DvO3Mm7v233+z78bJvUw79yPCLgLbL/yz7id35dkT6tQHioZJoC3aLdLkvVvxVBwjm+zrfN5ZDpg+OGgiwxKRk3jxMEHzKtHvTMUpGBR1qojlkmNDiSZcZVpvbrLFqakYDmTsX0XHgHdkimxxUmzb6u2/esMVDUgLTkAKihqYUB9Sh1UaRgZUWj/yhMmMvXohRyPnJQ69jvCPp/+4KVICrYG4p4yBVjxgXC2zv1tBfasgjd8nqzr+pKPdMBDQWkih/HlsRwdCLqZgnV5/Gz3wnX1TkEdO4MgQX4xJsYVNeZMQZZPVEWNkHMQp80RWWWUNtR+NBGGa9F9X11S8acchoh+jUU45j1lLECYN2T2hewvejVRWwxe4UEmzeP7ul0EbHMFPIFU0KU4ZnlWuCCeBdMjJGAz166rsXJSiIAiHypqsW4PzOUi7VfPtJdHZ8aiqv4mFi3v9rHNIp38fWw==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(136003)(39860400002)(346002)(396003)(46966006)(40470700004)(36840700001)(336012)(186003)(47076005)(1076003)(478600001)(16526019)(40460700003)(70586007)(2616005)(82310400005)(426003)(86362001)(36756003)(6666004)(41300700001)(36860700001)(2906002)(110136005)(26005)(8676002)(316002)(8936002)(7696005)(83380400001)(82740400003)(44832011)(40480700001)(70206006)(4326008)(356005)(81166007)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 11:41:32.1559
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 84cded20-dcc5-4893-94b8-08da58fb25e5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5710
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixed indentation errors in svm.c

No functional changes intended.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm.c | 144 +++++++++++++++++++++++++++---------------------------
 1 file changed, 72 insertions(+), 72 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index 08b0b15..e0ef4ec 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -52,7 +52,7 @@ bool smp_supported(void)
 
 bool default_supported(void)
 {
-    return true;
+	return true;
 }
 
 bool vgif_supported(void)
@@ -62,22 +62,22 @@ bool vgif_supported(void)
 
 bool lbrv_supported(void)
 {
-    return this_cpu_has(X86_FEATURE_LBRV);
+	return this_cpu_has(X86_FEATURE_LBRV);
 }
 
 bool tsc_scale_supported(void)
 {
-    return this_cpu_has(X86_FEATURE_TSCRATEMSR);
+	return this_cpu_has(X86_FEATURE_TSCRATEMSR);
 }
 
 bool pause_filter_supported(void)
 {
-    return this_cpu_has(X86_FEATURE_PAUSEFILTER);
+	return this_cpu_has(X86_FEATURE_PAUSEFILTER);
 }
 
 bool pause_threshold_supported(void)
 {
-    return this_cpu_has(X86_FEATURE_PFTHRESHOLD);
+	return this_cpu_has(X86_FEATURE_PFTHRESHOLD);
 }
 
 
@@ -121,7 +121,7 @@ void inc_test_stage(struct svm_test *test)
 }
 
 static void vmcb_set_seg(struct vmcb_seg *seg, u16 selector,
-                         u64 base, u32 limit, u32 attr)
+			 u64 base, u32 limit, u32 attr)
 {
 	seg->selector = selector;
 	seg->attrib = attr;
@@ -159,9 +159,9 @@ void vmcb_ident(struct vmcb *vmcb)
 	struct vmcb_save_area *save = &vmcb->save;
 	struct vmcb_control_area *ctrl = &vmcb->control;
 	u32 data_seg_attr = 3 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
-	    | SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
+		| SVM_SELECTOR_DB_MASK | SVM_SELECTOR_G_MASK;
 	u32 code_seg_attr = 9 | SVM_SELECTOR_S_MASK | SVM_SELECTOR_P_MASK
-	    | SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;
+		| SVM_SELECTOR_L_MASK | SVM_SELECTOR_G_MASK;
 	struct descriptor_table_ptr desc_table_ptr;
 
 	memset(vmcb, 0, sizeof(*vmcb));
@@ -186,8 +186,8 @@ void vmcb_ident(struct vmcb *vmcb)
 	save->g_pat = rdmsr(MSR_IA32_CR_PAT);
 	save->dbgctl = rdmsr(MSR_IA32_DEBUGCTLMSR);
 	ctrl->intercept = (1ULL << INTERCEPT_VMRUN) |
-			  (1ULL << INTERCEPT_VMMCALL) |
-			  (1ULL << INTERCEPT_SHUTDOWN);
+		(1ULL << INTERCEPT_VMMCALL) |
+		(1ULL << INTERCEPT_SHUTDOWN);
 	ctrl->iopm_base_pa = virt_to_phys(io_bitmap);
 	ctrl->msrpm_base_pa = virt_to_phys(msr_bitmap);
 
@@ -220,12 +220,12 @@ int __svm_vmrun(u64 rip)
 	regs.rdi = (ulong)v2_test;
 
 	asm volatile (
-		ASM_PRE_VMRUN_CMD
-                "vmrun %%rax\n\t"               \
-		ASM_POST_VMRUN_CMD
-		:
-		: "a" (virt_to_phys(vmcb))
-		: "memory", "r15");
+		      ASM_PRE_VMRUN_CMD
+		      "vmrun %%rax\n\t"               \
+		      ASM_POST_VMRUN_CMD
+		      :
+		      : "a" (virt_to_phys(vmcb))
+		      : "memory", "r15");
 
 	return (vmcb->control.exit_code);
 }
@@ -253,33 +253,33 @@ static noinline void test_run(struct svm_test *test)
 		struct svm_test *the_test = test;
 		u64 the_vmcb = vmcb_phys;
 		asm volatile (
-			"clgi;\n\t" // semi-colon needed for LLVM compatibility
-			"sti \n\t"
-			"call *%c[PREPARE_GIF_CLEAR](%[test]) \n \t"
-			"mov %[vmcb_phys], %%rax \n\t"
-			ASM_PRE_VMRUN_CMD
-			".global vmrun_rip\n\t"		\
-			"vmrun_rip: vmrun %%rax\n\t"    \
-			ASM_POST_VMRUN_CMD
-			"cli \n\t"
-			"stgi"
-			: // inputs clobbered by the guest:
-			"=D" (the_test),            // first argument register
-			"=b" (the_vmcb)             // callee save register!
-			: [test] "0" (the_test),
-			[vmcb_phys] "1"(the_vmcb),
-			[PREPARE_GIF_CLEAR] "i" (offsetof(struct svm_test, prepare_gif_clear))
-			: "rax", "rcx", "rdx", "rsi",
-			"r8", "r9", "r10", "r11" , "r12", "r13", "r14", "r15",
-			"memory");
+			      "clgi;\n\t" // semi-colon needed for LLVM compatibility
+			      "sti \n\t"
+			      "call *%c[PREPARE_GIF_CLEAR](%[test]) \n \t"
+			      "mov %[vmcb_phys], %%rax \n\t"
+			      ASM_PRE_VMRUN_CMD
+			      ".global vmrun_rip\n\t"		\
+			      "vmrun_rip: vmrun %%rax\n\t"    \
+			      ASM_POST_VMRUN_CMD
+			      "cli \n\t"
+			      "stgi"
+			      : // inputs clobbered by the guest:
+				"=D" (the_test),            // first argument register
+				"=b" (the_vmcb)             // callee save register!
+			      : [test] "0" (the_test),
+				[vmcb_phys] "1"(the_vmcb),
+				[PREPARE_GIF_CLEAR] "i" (offsetof(struct svm_test, prepare_gif_clear))
+			      : "rax", "rcx", "rdx", "rsi",
+				"r8", "r9", "r10", "r11" , "r12", "r13", "r14", "r15",
+				"memory");
 		++test->exits;
 	} while (!test->finished(test));
 	irq_enable();
 
 	report(test->succeeded(test), "%s", test->name);
 
-        if (test->on_vcpu)
-	    test->on_vcpu_done = true;
+	if (test->on_vcpu)
+		test->on_vcpu_done = true;
 }
 
 static void set_additional_vcpu_msr(void *msr_efer)
@@ -322,10 +322,10 @@ static void setup_svm(void)
 	printf("NPT detected - running all tests with NPT enabled\n");
 
 	/*
-	* Nested paging supported - Build a nested page table
-	* Build the page-table bottom-up and map everything with 4k
-	* pages to get enough granularity for the NPT unit-tests.
-	*/
+	 * Nested paging supported - Build a nested page table
+	 * Build the page-table bottom-up and map everything with 4k
+	 * pages to get enough granularity for the NPT unit-tests.
+	 */
 
 	setup_npt();
 }
@@ -335,37 +335,37 @@ int matched;
 static bool
 test_wanted(const char *name, char *filters[], int filter_count)
 {
-        int i;
-        bool positive = false;
-        bool match = false;
-        char clean_name[strlen(name) + 1];
-        char *c;
-        const char *n;
-
-        /* Replace spaces with underscores. */
-        n = name;
-        c = &clean_name[0];
-        do *c++ = (*n == ' ') ? '_' : *n;
-        while (*n++);
-
-        for (i = 0; i < filter_count; i++) {
-                const char *filter = filters[i];
-
-                if (filter[0] == '-') {
-                        if (simple_glob(clean_name, filter + 1))
-                                return false;
-                } else {
-                        positive = true;
-                        match |= simple_glob(clean_name, filter);
-                }
-        }
-
-        if (!positive || match) {
-                matched++;
-                return true;
-        } else {
-                return false;
-        }
+	int i;
+	bool positive = false;
+	bool match = false;
+	char clean_name[strlen(name) + 1];
+	char *c;
+	const char *n;
+
+	/* Replace spaces with underscores. */
+	n = name;
+	c = &clean_name[0];
+	do *c++ = (*n == ' ') ? '_' : *n;
+	while (*n++);
+
+	for (i = 0; i < filter_count; i++) {
+		const char *filter = filters[i];
+
+		if (filter[0] == '-') {
+			if (simple_glob(clean_name, filter + 1))
+				return false;
+		} else {
+			positive = true;
+			match |= simple_glob(clean_name, filter);
+		}
+	}
+
+	if (!positive || match) {
+		matched++;
+		return true;
+	} else {
+		return false;
+	}
 }
 
 int run_svm_tests(int ac, char **av)
-- 
2.30.2

