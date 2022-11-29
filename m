Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D983663CC1C
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 01:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231945AbiK3AAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 19:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231705AbiK3AAI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 19:00:08 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2063.outbound.protection.outlook.com [40.107.100.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F6373413;
        Tue, 29 Nov 2022 15:59:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q7DsS5qSN3d1hx7VWrkP3W79aMpbP1XzJ6DxGhr4FXVLDlsEiLFK0HlmDdTc6YmMYskgVkCzULpAR3eeXtRkDMlQOrHpqwiqOPNA68cpZf9eSdv4d+Gv0HAKJZOkES/5EZhlCwrheytA7E5PhAUnW/FNNa4vGvUTuG/O9J6Vfqyq9GvqJB30KvFHXorPEj09GmSpqL712mBWazghIJtCw/DV6wkeeCOFCqbDvFiB5daz5BoGA+zMzZgagSDVYd6ePB/CBFwjJwBG97pBGwFNQ7rClJ+PrqzWuHjEX/K5taj3bRdyCYBA5lXgLLk8UVibRtrWinv+NtY8ODLCtVoMQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nN5weJ79cyT58jZYmjSBjPJ+VRu7fp+JJWujD6UWFFQ=;
 b=AfvvcyceDwFC8FToHotKS4p4SbP1DvMLz/oLouK7wawW1KUgGyXZT5uxD7BHc44XzJFH5Yv0q/t9hohWvmFQgf1lMLEsZFvig1WCS5kkWIfpKerkupjA1Pzs0doSfj9X7PiDyH9cPrMi6QZ9/lUgPCYRlYzIEwm5oQpUR4BK8eVwjk62AbLWcAf+lweN6+4rlquQfNYjLfVJoPsip0KswJ+cW0G0ajn9uV6AR5Uv+USlocDHZxsJlnoZk6uWirj4IphoQTfC0vpR/64L7f5bkjtR1ZuCZpdoevPOGpdmOk+EZv2h7hYpu1ZBT18SkgFLPlUKeFoRBsSfi+eO+vYIVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nN5weJ79cyT58jZYmjSBjPJ+VRu7fp+JJWujD6UWFFQ=;
 b=vF6ShrX27Y6nWsVyVWqIFLPSUqyUGNFEVJy2ro1bn3ZEJSkHs5dJvLNltsk/XarG8bMqOK49DtivRneBXjoQrWcupmvR89xir+FX5hfuyqZm+wNny1EsQv2U+fCgeuinf7dZ3Wr1SNKzThFh/XONUPg1P7BlhFJ3ppHvTOUelfw=
Received: from DM6PR07CA0106.namprd07.prod.outlook.com (2603:10b6:5:330::15)
 by SN7PR12MB6930.namprd12.prod.outlook.com (2603:10b6:806:262::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 23:59:46 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:330:cafe::49) by DM6PR07CA0106.outlook.office365.com
 (2603:10b6:5:330::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Tue, 29 Nov 2022 23:59:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Tue, 29 Nov 2022 23:59:46 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 29 Nov
 2022 17:59:41 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Alexey Kardashevskiy <aik@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 6/7] x86/cpu, kvm: Support AMD Automatic IBRS
Date:   Tue, 29 Nov 2022 17:58:15 -0600
Message-ID: <20221129235816.188737-7-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129235816.188737-1-kim.phillips@amd.com>
References: <20221129235816.188737-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT051:EE_|SN7PR12MB6930:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d963652-cde2-46b4-0317-08dad265caeb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8yC6g6io7xoQoRBRhSwL4t8f624l16En3d9GG1rSd2z4dqll9It4/0BxIBQePzjADQEbxRJPol2ho1x0sfGH3TBgs0H/BFstW8bM6+gcE8K37cI2KgUorckEY/ObKvPZVQ6hTDiKjhG1dsHZOtSPrcHWSGs09R/BAyPp1XKNUChO+w7WjW+MtlkI6HwUN1czUFt0lYkOTIN04jsR4qniYc2vZ0kkYQnkMc6H8CHvl4Uk3njxe6aweRWf8wnXtSeiwYtvyUyEOHU2UVlOwh8LAe8qROgt3+9WOBL1kijz3tTHxbHYoekBWKqvYJAsULamYPoEzmhEsycmRHKL9fDp9AfI/mI7W+DDKZK2Gpl5MZOXCsdwn4mmbTZBOG4/UZGCbGcShR33J5Ze3H7NKv757Cn4Y1dEXK7xMom1IhKd9JP18jlQsrP5xfRVyKDOu3welc8D9AVfwaJ2slg17jymerf6mK5IV4y+eVoINbHBN38Rcqa8kQDX1Fu+7BwrCQN5bZvA6eKSih/LGyHGGFipaW1yQAhC+Zc4MZujwbKneIuxdqM+De+tYEsseVT0FhWtR2gXUComkneYZaho8gSkj4a/Ip663bhhMh3Vb6o0q0S3oGiUnZos5Vo4mP5BzwYRrljvpXOI5CuxbNm23CbA+sJ7aEhhbN9IypfUbngzQZUv/qP5HG/XHkc3RRyWC/qw8ZD5bth5ZBpee01pXDr7w9Sc6czuZjejqxAfV1LozJc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199015)(36840700001)(40470700004)(46966006)(16526019)(1076003)(2616005)(36860700001)(2906002)(83380400001)(7696005)(6666004)(70206006)(356005)(8676002)(41300700001)(478600001)(70586007)(40460700003)(82310400005)(36756003)(82740400003)(26005)(81166007)(40480700001)(186003)(336012)(426003)(5660300002)(8936002)(47076005)(4326008)(86362001)(6916009)(54906003)(7416002)(44832011)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 23:59:46.3494
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d963652-cde2-46b4-0317-08dad265caeb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6930
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AMD Zen4 core supports a new feature called Automatic IBRS.

It is a "set-and-forget" feature that means that, like
Intel's Enhanced IBRS, h/w manages its IBRS mitigation
resources automatically across CPL transitions.

The feature is advertised by CPUID_Fn80000021_EAX bit 8 and is
enabled by setting MSR C000_0080 (EFER) bit 21.

Enable Automatic IBRS by default if the CPU feature is present.
It typically provides greater performance over the incumbent
generic retpolines mitigation.

Reuse the SPECTRE_V2_EIBRS spectre_v2_mitigation enum.
AMD Automatic IBRS and Intel Enhanced IBRS have similar
bugs.c enablement.

Also allow for spectre_v2=autoibrs on the kernel command line.
'spectre_v2=autoibrs,retpoline' and 'autoibrs,lfence' are
honoured but not required.  AutoIBRS will also be enabled if
the =eibrs[,{lfence,retpoline}] variants are specified.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 .../admin-guide/kernel-parameters.txt         |  9 +++++---
 arch/x86/include/asm/msr-index.h              |  2 ++
 arch/x86/kernel/cpu/bugs.c                    | 23 ++++++++++++-------
 arch/x86/kernel/cpu/common.c                  |  8 +++++++
 arch/x86/kvm/svm/svm.c                        |  3 +++
 arch/x86/kvm/x86.c                            |  3 +++
 6 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a465d5242774..880016d06a8a 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5698,9 +5698,12 @@
 			retpoline,generic - Retpolines
 			retpoline,lfence  - LFENCE; indirect branch
 			retpoline,amd     - alias for retpoline,lfence
-			eibrs		  - enhanced IBRS
-			eibrs,retpoline   - enhanced IBRS + Retpolines
-			eibrs,lfence      - enhanced IBRS + LFENCE
+			eibrs		  - Enhanced/Auto IBRS
+			autoibrs	  - Enhanced/Auto IBRS
+			eibrs,retpoline   - Enhanced/Auto IBRS + Retpolines
+			autoibrs,retpoline- Enhanced/Auto IBRS + Retpolines
+			eibrs,lfence      - Enhanced/Auto IBRS + LFENCE
+			autoibrs,lfence   - Enhanced/Auto IBRS + LFENCE
 			ibrs		  - use IBRS to protect kernel
 
 			Not specifying this option is equivalent to
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 8519191c6409..88fdd75f6a2f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -30,6 +30,7 @@
 #define _EFER_SVME		12 /* Enable virtualization */
 #define _EFER_LMSLE		13 /* Long Mode Segment Limit Enable */
 #define _EFER_FFXSR		14 /* Enable Fast FXSAVE/FXRSTOR */
+#define _EFER_AUTOIBRS		21 /* Enable Automatic IBRS */
 
 #define EFER_SCE		(1<<_EFER_SCE)
 #define EFER_LME		(1<<_EFER_LME)
@@ -38,6 +39,7 @@
 #define EFER_SVME		(1<<_EFER_SVME)
 #define EFER_LMSLE		(1<<_EFER_LMSLE)
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
+#define EFER_AUTOIBRS		(1<<_EFER_AUTOIBRS)
 
 /* Intel MSRs. Some also available on other CPUs */
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index aa0819252c88..5f48dd4dbc48 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1222,9 +1222,9 @@ static const char * const spectre_v2_strings[] = {
 	[SPECTRE_V2_NONE]			= "Vulnerable",
 	[SPECTRE_V2_RETPOLINE]			= "Mitigation: Retpolines",
 	[SPECTRE_V2_LFENCE]			= "Mitigation: LFENCE",
-	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced IBRS",
-	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced IBRS + LFENCE",
-	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced IBRS + Retpolines",
+	[SPECTRE_V2_EIBRS]			= "Mitigation: Enhanced / Automatic IBRS",
+	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced / Automatic IBRS + LFENCE",
+	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced / Automatic IBRS + Retpolines",
 	[SPECTRE_V2_IBRS]			= "Mitigation: IBRS",
 };
 
@@ -1240,8 +1240,11 @@ static const struct {
 	{ "retpoline,lfence",	SPECTRE_V2_CMD_RETPOLINE_LFENCE,  false },
 	{ "retpoline,generic",	SPECTRE_V2_CMD_RETPOLINE_GENERIC, false },
 	{ "eibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
+	{ "autoibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
 	{ "eibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
+	{ "autoibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
 	{ "eibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
+	{ "autoibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
 	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
 	{ "ibrs",		SPECTRE_V2_CMD_IBRS,              false },
 };
@@ -1293,7 +1296,7 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
 	     cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
 	    !boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
-		pr_err("%s selected but CPU doesn't have eIBRS. Switching to AUTO select\n",
+		pr_err("%s selected but CPU doesn't have Enhanced or Automatic IBRS. Switching to AUTO select\n",
 		       mitigation_options[i].option);
 		return SPECTRE_V2_CMD_AUTO;
 	}
@@ -1479,8 +1482,12 @@ static void __init spectre_v2_select_mitigation(void)
 		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
 
 	if (spectre_v2_in_ibrs_mode(mode)) {
-		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
+			msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
+		} else {
+			x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
+			write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		}
 	}
 
 	switch (mode) {
@@ -1564,8 +1571,8 @@ static void __init spectre_v2_select_mitigation(void)
 	/*
 	 * Retpoline protects the kernel, but doesn't protect firmware.  IBRS
 	 * and Enhanced IBRS protect firmware too, so enable IBRS around
-	 * firmware calls only when IBRS / Enhanced IBRS aren't otherwise
-	 * enabled.
+	 * firmware calls only when IBRS / Enhanced / Automatic IBRS aren't
+	 * otherwise enabled.
 	 *
 	 * Use "mode" to check Enhanced IBRS instead of boot_cpu_has(), because
 	 * the user might select retpoline on the kernel command line and if
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 8d28cd7c9072..0af7b963f2e4 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1406,6 +1406,14 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
 		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
 
+	/*
+	 * AMD's AutoIBRS is equivalent to Intel's eIBRS - use the Intel flag only
+	 * after IBRS_ENHANCED bugs such as BUG_EIBRS_PBRSB above have been
+	 * determined.
+	 */
+	if (cpu_has(c, X86_FEATURE_AUTOIBRS))
+		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
+
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4b6d2b050e57..3ac3d4cfce24 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4960,6 +4960,9 @@ static __init int svm_hardware_setup(void)
 
 	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
 
+	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
+		kvm_enable_efer_bits(EFER_AUTOIBRS);
+
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
 		pause_filter_count = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 490ec23c8450..db0f522fd597 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1682,6 +1682,9 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 
 static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
+	if (efer & EFER_AUTOIBRS && !guest_cpuid_has(vcpu, X86_FEATURE_AUTOIBRS))
+		return false;
+
 	if (efer & EFER_FFXSR && !guest_cpuid_has(vcpu, X86_FEATURE_FXSR_OPT))
 		return false;
 
-- 
2.34.1

