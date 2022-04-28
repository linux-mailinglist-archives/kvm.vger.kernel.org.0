Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB1C512C72
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 09:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244933AbiD1HPV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 03:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244976AbiD1HPR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 03:15:17 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47BBA8D6B6
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 00:12:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YG/sVSRdkPtRVwwCeb8hFcT9pcUh4oOpUK+/0m4nP/PoxqXoZf7vguxe63piAFilX04CzQ7Bysa4Oy+QQ9iGFvFzO+2tbHVqjTschtu0ANgIt+gWT5dsVdUNE19XlT7zPR220n22TGih2CIfkmG1JZ6tUox8okiaD8+zjSza0rooOBc1Y06HUTnMxwLgPS+XSXDKoX6VsXYVYt0bA/nxD3gfoPIhhWpHsneSodlRWl30oc7efOmdZ7mrwQAQQSZwN3Eb1kBWBMMSKCvKXQShgdmW3OXruht4NEZCBHr54kMxr7cVngGDCi0zSnO0R6h72fsuVrytuDR00GwDHa4HvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ed43BIu8koPsb8Ntkolhm04rleZfGkBOUsUZ5pXwrvo=;
 b=dOMqhAnnSwQSiCOuW7xcZ59F/G5yLCzUwZR72wRlZRI2picsLmAj42YR69TQYZQvawyqMDYY2olhl7KB1xLy6npULocQEWftkRRq3+cyIX2zjcOEIbCWOYS9TabZBUvaA4NItKuqTyeOmd5A77ypPEZVjXzNuWDBds4Tr1IULzPXlPLhKvlnS9jTMcOt+CjDfdsYzNnQdw6sv4eoUff+oKIT47WqhrzxNeb1D8jrZluqTfAqMrmn3xynbSdAyP81aCYxdMVNu8GQAntc5Vx9KiZIn0z1JBteTrWjAZ2qvKhzMpXxFW+eV0zRSkK91AEtByCv2aWJrTJvr8t+c+NTHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ed43BIu8koPsb8Ntkolhm04rleZfGkBOUsUZ5pXwrvo=;
 b=nJwFUI6mOsdJSX+sB4CatiXwhUD618KuHBjQ6u3DZAeXMiq+qXeVVDy2WkPkZmXOSwTc2bY/4BFHM4GG6HWwDzRpyXOQHeli3vT3T+Dbu73FwyDoBPz6ByVnNYTDrqQSLr0CX2Mrmp5yvq9zndNlOIsr/nrUWVQV/Owk2yA9oUA=
Received: from DM6PR18CA0006.namprd18.prod.outlook.com (2603:10b6:5:15b::19)
 by DM5PR12MB1450.namprd12.prod.outlook.com (2603:10b6:4:3::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Thu, 28 Apr 2022 07:11:59 +0000
Received: from DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::f0) by DM6PR18CA0006.outlook.office365.com
 (2603:10b6:5:15b::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.21 via Frontend
 Transport; Thu, 28 Apr 2022 07:11:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT017.mail.protection.outlook.com (10.13.172.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5206.12 via Frontend Transport; Thu, 28 Apr 2022 07:11:58 +0000
Received: from bhadra.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 28 Apr
 2022 02:11:56 -0500
From:   Manali Shukla <manali.shukla@amd.com>
To:     <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <kvm@vger.kernel.org>
Subject: [kvm-unit-tests PATCH v4 6/8] x86: nSVM: Correct indentation for svm.c
Date:   Thu, 28 Apr 2022 07:08:49 +0000
Message-ID: <20220428070851.21985-7-manali.shukla@amd.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220428070851.21985-1-manali.shukla@amd.com>
References: <20220428070851.21985-1-manali.shukla@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 463d5727-7d45-4866-a3f9-08da28e662a3
X-MS-TrafficTypeDiagnostic: DM5PR12MB1450:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB14501184B7A51996912B2840FDFD9@DM5PR12MB1450.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b+g6kE8XRua570RCTL9WBBD7Ha2qdRNrSgNIN8C/Z3OV9Sadt/AiGr8O2eHai4Cr79hUjjFAgtsq8RPE6ethUvxKDhLFW2CcqLQY6s1xTlNNgK5QLefhCiPDfvhB4g0osd2xT/XbZO8t7rM0kmYFzj7q7BDIUCMTH3U1Wd/vM9tnBCStptjxAK+P2T7vU5gZiu4F+E0wZ3BhBDBI6b2ITX6PxRusTPQ1S0aWfXtMAIPkagSLWDKskm8eie4UXLfr/3ApaGuVeD4IAYugkuzoI+vQJiEOm6TfoJm5e5KRN4XopGGjZefabRutbV/s3Ce/BYYWiZSXfHq+7EdNkDYlHIx66AZi2KKosLdO3hbjRYBLNSGFyqIwkVlyMimNCseGvOFKj+dDzE1iXeOohdCevW5kEKwMjoQ5fZIFh5aL181U9sCRXd64+dWtsGBy6D/XVQWN7t/6SP2p5rsUB5/4tUda7c0KwGUTLVtFUGiANAlDUZMHye7wwfejLkuE9039XqwEHffY+ArRZPB9VuqGigRqUz44155JOc5nLGmaiqPlvQZRdHp6YQ1R+JLsNRP0yBH5bZW5dhiRkomTRP9L6Vw14Pxw+glIkHH5b8TYOZxjVjTgaZ6VuX23DDnrXZRIOb2mSXdC0qCBXIKsvLTsUL8/Pv4KhSWxT6qDGGpoRnBY6mff2W2VRLfiXZhOeL6DiDU+u2d2nzywAR/5RuVk8Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(186003)(44832011)(26005)(82310400005)(316002)(426003)(47076005)(336012)(70586007)(4326008)(8676002)(1076003)(81166007)(36756003)(110136005)(8936002)(36860700001)(40460700003)(5660300002)(70206006)(508600001)(6666004)(83380400001)(2616005)(7696005)(356005)(86362001)(2906002)(16526019)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2022 07:11:58.7733
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 463d5727-7d45-4866-a3f9-08da28e662a3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1450
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fixed indentation errors in svm.c

No functional changes intended.

Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 x86/svm.c | 174 +++++++++++++++++++++++++++---------------------------
 1 file changed, 87 insertions(+), 87 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index e66c801..c58a745 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -23,26 +23,26 @@ struct vmcb *vmcb;
 
 u64 *npt_get_pte(u64 address)
 {
-        return get_pte(npt_get_pml4e(), (void*)address);
+	return get_pte(npt_get_pml4e(), (void*)address);
 }
 
 u64 *npt_get_pde(u64 address)
 {
-    struct pte_search search;
-    search = find_pte_level(npt_get_pml4e(), (void*)address, 2);
-    return search.pte;
+	struct pte_search search;
+	search = find_pte_level(npt_get_pml4e(), (void*)address, 2);
+	return search.pte;
 }
 
 u64 *npt_get_pdpe(u64 address)
 {
-    struct pte_search search;
-    search = find_pte_level(npt_get_pml4e(), (void*)address, 3);
-    return search.pte;
+	struct pte_search search;
+	search = find_pte_level(npt_get_pml4e(), (void*)address, 3);
+	return search.pte;
 }
 
 u64 *npt_get_pml4e(void)
 {
-    return pml4e;
+	return pml4e;
 }
 
 bool smp_supported(void)
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
@@ -291,14 +291,14 @@ static void set_additional_vcpu_msr(void *msr_efer)
 }
 
 void setup_npt(void) {
-    u64 end_of_memory;
-    pml4e = alloc_page();
+	u64 end_of_memory;
+	pml4e = alloc_page();
 
-    end_of_memory = fwcfg_get_u64(FW_CFG_RAM_SIZE);
-    if (end_of_memory < (1ul << 32))
-        end_of_memory = (1ul << 32);
+	end_of_memory = fwcfg_get_u64(FW_CFG_RAM_SIZE);
+	if (end_of_memory < (1ul << 32))
+		end_of_memory = (1ul << 32);
 
-    setup_mmu_range(pml4e, 0, end_of_memory, true);
+	setup_mmu_range(pml4e, 0, end_of_memory, true);
 }
 
 static void setup_svm(void)
@@ -322,12 +322,12 @@ static void setup_svm(void)
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
 
-  setup_npt();
+	setup_npt();
 }
 
 int matched;
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

