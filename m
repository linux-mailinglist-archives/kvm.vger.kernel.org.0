Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0736A4AF985
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 19:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239075AbiBISOS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 13:14:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239045AbiBISNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 13:13:10 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2087.outbound.protection.outlook.com [40.107.223.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74037C03E937;
        Wed,  9 Feb 2022 10:12:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=doMBFE2jnwVB7QXJA9OUWnc48eyrVxg2D/ke4c1c/lb13y7t8Ue9rc72GX/fs8+zteKG+1nDSwXiZSAi6sa6DOoMHcUlt9bpjfRTJ+vDRnledojzfS6KBydRBWcm+lEMmO+sreiN1ZVIZCw6gPjDxb8w5V5r7V1/MEm4xYiSDCdOh6gHXv3eWuB8T5aNT5LmJ5Ekylymx+aOURyC5fyzFH2YafbGTqp0jB3/tir3vxZWqZcXHqaEmx4TH0jTZMSqGK7E9AAc+olH8kzn3s0R2jypVg8df3yYd/i9gnSZoPFo9Z8VpBPJYoZOY0SJe77AiSWPjVaViVw/vKo5BHKkeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u5YDI9jYo57S6MwXjaweiTblRtur/Xu4GgKjk7NYpcg=;
 b=GSkvOKd/I9AyHlLSCQHhJU3PcGh08snBkzEV38H+FzRt0o4iJAIbyCJT3KPNyfFDyb7ZsHWG3pwYp7GwTJiqCSylP25XoOk2np7ePtAK2DqdGZ5ftPRVhXAq0r/WZPK1ZJ3aigwd5fjJZiQhjf0QuwAS0ewtcpMOAVU+/K/h8aUfwQcVDiTaaxEO1Vly3iSLrG63s0WB0nCDT6q/Y91W6S8vu0PMtmMlzX2jDY7TN5/yQ9rd5emHzddnUaMVGkERaupNy1MadxPAEY9tp11hqkMHqBREWNyBsPIfcepNmq3SIQZrW6A+3RC+bIK6Ub5PI1c9+Il0nSOMY+0gmhwM1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u5YDI9jYo57S6MwXjaweiTblRtur/Xu4GgKjk7NYpcg=;
 b=ua0rl/Q6onabCQrvCMTGMrScshGOmR1jr7rR4iEE1Os7/E6/craY3O8vrA7o4gHnN/M2PrsC+irQA38Ac5daBAQwVCxRWMtExfrVdTGJOucRXGwev3kvbWljRLcmo87LNl4LgQdEnMrq1utUOq1mgaOjcTGNI9SjdlvTFSy7exs=
Received: from BN9PR03CA0142.namprd03.prod.outlook.com (2603:10b6:408:fe::27)
 by BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.17; Wed, 9 Feb
 2022 18:12:07 +0000
Received: from BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::1c) by BN9PR03CA0142.outlook.office365.com
 (2603:10b6:408:fe::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.11 via Frontend
 Transport; Wed, 9 Feb 2022 18:12:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com;
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT032.mail.protection.outlook.com (10.13.177.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4975.11 via Frontend Transport; Wed, 9 Feb 2022 18:12:06 +0000
Received: from sbrijesh-desktop.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 9 Feb
 2022 12:12:04 -0600
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>, <linux-efi@vger.kernel.org>,
        <platform-driver-x86@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Vitaly Kuznetsov" <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        "Andy Lutomirski" <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        <brijesh.ksingh@gmail.com>, <tony.luck@intel.com>,
        <marcorr@google.com>, <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v10 23/45] x86/head/64: Re-enable stack protection
Date:   Wed, 9 Feb 2022 12:10:17 -0600
Message-ID: <20220209181039.1262882-24-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220209181039.1262882-1-brijesh.singh@amd.com>
References: <20220209181039.1262882-1-brijesh.singh@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 669ff59e-08a4-4c6c-2a0c-08d9ebf7aeb8
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB27430DC91CA0D69B2E53984CE52E9@BYAPR12MB2743.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YtpRhq+7L7juzOSrQ7g/mJa9usWcd5+B4FDGxsDmY69wQN1LWvXTYb1SemQAl3pvhEGl6iVE6Mw5pH1EftNChig6oRSji5KiCiwfWoUtAWxe7VEJ/RKzuWldEG58mwJNtnBL29sflxhIElK+JdYKQZYk1Z29noBpHkXkIoJqxuT+z4t6qXVEyiwpUvDc5IB8xKGuEGCkaUHmXSRRZ0Fnqq1G+NBQXmzKrZQFcke/HPzfyI/Ly7TcUXPM5wr8sfxYY6FbVyWi0hz9jqrZHFv6DYB547OAw54FLEMHv3vwrMr8X8Y0qX30JTN1Izy3LPHhavcuRI42YhHuadq4YfKHN1CJlXxbGb64MipdDZN84HoOkcy3n93lhyNbx+y98dsU5HK8nCNvmwQaUqz2mkXbwUna2kI7lNub/6CKagvPPiXM1H/2jhobDjKO/ITlrldKCkcimgmQO+Q5KGD61+4zvyr3VkpvCBsFuVJ91/KFUIJEhbKyBSWfUN3Zz1fha2PUCPAIqNnYOt6d43laI7EACZ8fToMUvhCmM9Ml1YJIr3jBpCQ0wJpsEfXYNsO3sOiNTlXySIOVE2K2MhK2btQEaFhNcZ2u6PurPAE10R1Yx1rTz/HG9Hu59imH7zUCVkAtHYTUCcOZ4r2XOZNqw4GiObLyB+fwa1OxZEgJA9xRIHxRckHdOicrFgv+0nTpwpBOzq7K6caZI0nCBBA6t2pmPvahCRvJDXOG2IgYlNY2A30=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(46966006)(36840700001)(40470700004)(81166007)(8676002)(54906003)(7696005)(6666004)(8936002)(70586007)(70206006)(316002)(356005)(508600001)(110136005)(86362001)(47076005)(36860700001)(36756003)(82310400004)(7406005)(7416002)(2906002)(2616005)(40460700003)(4326008)(16526019)(83380400001)(26005)(336012)(186003)(1076003)(44832011)(426003)(5660300002)(2101003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2022 18:12:06.9609
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 669ff59e-08a4-4c6c-2a0c-08d9ebf7aeb8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT032.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2743
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michael Roth <michael.roth@amd.com>

Due to commit 103a4908ad4d ("x86/head/64: Disable stack protection for
head$(BITS).o"), kernel/head{32,64}.c are compiled with
-fno-stack-protector to allow a call to set_bringup_idt_handler(), which
would otherwise have stack protection enabled with
CONFIG_STACKPROTECTOR_STRONG.

While sufficient for that case, there may still be issues with calls to
any external functions that were compiled with stack protection enabled
that in-turn make stack-protected calls, or if the exception handlers
set up by set_bringup_idt_handler() make calls to stack-protected
functions.

Subsequent patches for SEV-SNP CPUID validation support will introduce
both such cases. Attempting to disable stack protection for everything
in scope to address that is prohibitive since much of the code, like
SEV-ES #VC handler, is shared code that remains in use after boot and
could benefit from having stack protection enabled. Attempting to inline
calls is brittle and can quickly balloon out to library/helper code
where that's not really an option.

Instead, re-enable stack protection for head32.c/head64.c, and make the
appropriate changes to ensure the segment used for the stack canary is
initialized in advance of any stack-protected C calls.

For head64.c:

- The BSP will enter from startup_64() and call into C code
  (startup_64_setup_env()) shortly after setting up the stack, which
  may result in calls to stack-protected code. Set up %gs early to allow
  for this safely.
- APs will enter from secondary_startup_64*(), and %gs will be set up
  soon after. There is one call to C code prior to %gs being setup
  (__startup_secondary_64()), but it is only to fetch 'sme_me_mask'
  global, so just load 'sme_me_mask' directly instead, and remove the
  now-unused __startup_secondary_64() function.

For head32.c:

- BSPs/APs will set %fs to __BOOT_DS prior to any C calls. In recent
  kernels, the compiler is configured to access the stack canary at
  %fs:__stack_chk_guard [1], which overlaps with the initial per-cpu
  '__stack_chk_guard' variable in the initial/"master" .data..percpu
  area. This is sufficient to allow access to the canary for use
  during initial startup, so no changes are needed there.

[1] commit 3fb0fdb3bbe7 ("x86/stackprotector/32: Make the canary into a regular percpu variable")

Suggested-by: Joerg Roedel <jroedel@suse.de> #for 64-bit %gs set up
Signed-off-by: Michael Roth <michael.roth@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/setup.h |  1 -
 arch/x86/kernel/Makefile     |  1 -
 arch/x86/kernel/head64.c     |  9 ---------
 arch/x86/kernel/head_64.S    | 24 +++++++++++++++++++++---
 4 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index a12458a7a8d4..72ede9159951 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -49,7 +49,6 @@ extern unsigned long saved_video_mode;
 extern void reserve_standard_io_resources(void);
 extern void i386_reserve_resources(void);
 extern unsigned long __startup_64(unsigned long physaddr, struct boot_params *bp);
-extern unsigned long __startup_secondary_64(void);
 extern void startup_64_setup_env(unsigned long physbase);
 extern void early_setup_idt(void);
 extern void __init do_early_exception(struct pt_regs *regs, int trapnr);
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 6aef9ee28a39..bd45e5ee6fe3 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -48,7 +48,6 @@ endif
 # non-deterministic coverage.
 KCOV_INSTRUMENT		:= n
 
-CFLAGS_head$(BITS).o	+= -fno-stack-protector
 CFLAGS_cc_platform.o	+= -fno-stack-protector
 
 CFLAGS_irq.o := -I $(srctree)/$(src)/../include/asm/trace
diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 4a24b121a2ba..e94e32ba9636 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -318,15 +318,6 @@ unsigned long __head __startup_64(unsigned long physaddr,
 	return sme_postprocess_startup(bp, pmd);
 }
 
-unsigned long __startup_secondary_64(void)
-{
-	/*
-	 * Return the SME encryption mask (if SME is active) to be used as a
-	 * modifier for the initial pgdir entry programmed into CR3.
-	 */
-	return sme_get_me_mask();
-}
-
 /* Wipe all early page tables except for the kernel symbol map */
 static void __init reset_early_page_tables(void)
 {
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 9c2c3aff5ee4..9e84263bcb94 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -65,6 +65,22 @@ SYM_CODE_START_NOALIGN(startup_64)
 	leaq	(__end_init_task - FRAME_SIZE)(%rip), %rsp
 
 	leaq	_text(%rip), %rdi
+
+	/*
+	 * initial_gs points to initial fixed_percpu_data struct with storage for
+	 * the stack protector canary. Global pointer fixups are needed at this
+	 * stage, so apply them as is done in fixup_pointer(), and initialize %gs
+	 * such that the canary can be accessed at %gs:40 for subsequent C calls.
+	 */
+	movl	$MSR_GS_BASE, %ecx
+	movq	initial_gs(%rip), %rax
+	movq	$_text, %rdx
+	subq	%rdx, %rax
+	addq	%rdi, %rax
+	movq	%rax, %rdx
+	shrq	$32,  %rdx
+	wrmsr
+
 	pushq	%rsi
 	call	startup_64_setup_env
 	popq	%rsi
@@ -145,9 +161,11 @@ SYM_INNER_LABEL(secondary_startup_64_no_verify, SYM_L_GLOBAL)
 	 * Retrieve the modifier (SME encryption mask if SME is active) to be
 	 * added to the initial pgdir entry that will be programmed into CR3.
 	 */
-	pushq	%rsi
-	call	__startup_secondary_64
-	popq	%rsi
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+	movq	sme_me_mask, %rax
+#else
+	xorq	%rax, %rax
+#endif
 
 	/* Form the CR3 value being sure to include the CR3 modifier */
 	addq	$(init_top_pgt - __START_KERNEL_map), %rax
-- 
2.25.1

