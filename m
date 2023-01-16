Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D8866D282
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 00:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbjAPXEu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 18:04:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbjAPXES (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 18:04:18 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2075.outbound.protection.outlook.com [40.107.93.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3DE2D15F;
        Mon, 16 Jan 2023 15:03:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cOBaLS1GsNawU3+DjdcCBF2013cs+lKxdv2x6SuM2PgaI84ruHFv7IRCmbG2b1xSg5pscTnt6wWDDNXSS/RuUN7CClro8Oba9a95cFIW+s7jbTABUF4ZMRYgCIdFxjOkQQwirfX0OWyhJjYP02n1xxiErj/NTRaSv3Fk1TMIG7S8uaSV1Gb9X3TDyEapQgp/2f3k04W5qdQa86M4IebmDABoD5LbmBsUYNBiWm32cReQltoNkcpnkX8mq7XDw6wS2H3xwZwUpnOJyNOVUKmHDI+snhwUf3d4z5GaOr3RFMUvFXAUDNDkL/ZgmRQ1Kd7Lh0QK4TDWqZIc48Ry9eWZmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YCRchL8LTF8C7JPN9I6JKlxnz2N0tDwO6qc8KVqblO0=;
 b=fpRcGGPAQAFG0cl1uo59uWJs054ZKWEewMQViKeRJCYLqmZYoAafMC265EC8rLz7l+dQYER9KJpk0R6R2crszlLkrqxvKqKB+410JGFB1KOUsq/wn+PLHbVyhcKK8a0esOCjNKN0cusF8Zs4kPGEYltqEbDg+dPjCPuKVReX4CFjd15t6h5hoD/uUtqJfT29OgT6Hsh1P7MDOGBuDO1RCT1PX4hPRxCg7MnyeqhKO0VnJEKBFl9sHxrcfNyx2GqgRu2zTaWVUvsbxMKQbWaQ8IPTTZocnavjwpffImN9aSM6quEKqWkvp/otZexCRrZvKd/hF+Q1aF6HCWpowj5YZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YCRchL8LTF8C7JPN9I6JKlxnz2N0tDwO6qc8KVqblO0=;
 b=pixUML6vYWeFJW7yBapNTMrN/G5ix0wX19skcVRTeqQQq7QvUg4UJCa0vXtaQHNx0edbV+386dAIAu+vktDQ97OJOBHtUrrJNik3qCxLHn0N3lUGTZzANy36KYiSBY+VySwlvg6ssjzNFQPSB2Iz4aG58KKuU2eM8Y3zCdYm0OQ=
Received: from DM6PR21CA0017.namprd21.prod.outlook.com (2603:10b6:5:174::27)
 by PH7PR12MB5758.namprd12.prod.outlook.com (2603:10b6:510:1d1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 16 Jan
 2023 23:03:25 +0000
Received: from DS1PEPF0000B07A.namprd05.prod.outlook.com
 (2603:10b6:5:174:cafe::c6) by DM6PR21CA0017.outlook.office365.com
 (2603:10b6:5:174::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.1 via Frontend
 Transport; Mon, 16 Jan 2023 23:03:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000B07A.mail.protection.outlook.com (10.167.17.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Mon, 16 Jan 2023 23:03:25 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 16 Jan
 2023 17:03:23 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Alexey Kardashevskiy" <aik@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 6/7] x86/cpu: Support AMD Automatic IBRS
Date:   Mon, 16 Jan 2023 17:01:58 -0600
Message-ID: <20230116230159.1511393-7-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230116230159.1511393-1-kim.phillips@amd.com>
References: <20230116230159.1511393-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B07A:EE_|PH7PR12MB5758:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d692f9b-461a-423f-0bf9-08daf815df64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 57ud84a9GvF1+oQmtu/P14ZvPeFzN6ZY/QXDmbC2oIYIjqYKvjRVSrXhZD54KddvIaqYNidhgfkWJEbJKRHz+42CQ+wY5OPoRv7kQwHnWIp3Uqf1DsOtQY4bpzu180HKU4Gl37lCPfVs1RWD3a+z87Wqvz0DqA15DqIxV3PX8v4516Ay2q9fP8+plyd5WZ+OkYbNUBlBA2zNzIoZdCpgESCbWBaCsisA3Oz/0xlxjmcOmBUdi8GkF5N1kK8Jg6dzerqQYa8nLA/K18ejyUQZTW6DIGaQ/q2X/VNssQe/Et2O9+1OR4yF5CghqQOEQIlaO/Bti1oTHhVpbZTYeSp27ji/U2FUT0r5adzb1pQtloBhz0zwPw5XSnT3qcO5peDrpZQ47Kz9EpeDI/q7LA5UcchHXXR/nyOd/x2C+BR83EeQukG8eGG7k5GyPOt5xbLjAJGuZyfBTTocg8MFIUQC9mNkHu1C1GdxuCMKLiQxv5+WdkqHhOnGr9qoU52JPE1/SlXd3X7oZLyARz+o0rNr9P+5UPGEnCkPoK4u9S3bqDskhv/Cjj9XaNst3tfhz0A8kBb6Wuie2zXsapfrUk0epI9UHdUKTktUa/xD246Dh9Ik0tNR4fQGXUq5uL4/13WOPCJQt6gK7KC97e2mAXW+SKpYrUCsNi3I1T4vFLkylJbRNwM7MQt1DOjOkV3otjc5BbkZvTraMYj0CR8gmVsdmBA3b+ISy9lrUhYVdy4ih4Y=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(39860400002)(136003)(346002)(451199015)(46966006)(40470700004)(36840700001)(47076005)(83380400001)(426003)(40480700001)(40460700003)(82310400005)(36860700001)(44832011)(356005)(81166007)(36756003)(86362001)(82740400003)(316002)(336012)(2906002)(8676002)(54906003)(70586007)(1076003)(6916009)(4326008)(8936002)(5660300002)(7416002)(70206006)(41300700001)(2616005)(26005)(6666004)(186003)(16526019)(478600001)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 23:03:25.1442
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d692f9b-461a-423f-0bf9-08daf815df64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B07A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5758
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
bugs.c enablement.  Add NO_EIBRS_PBRSB to cpu_vuln_whitelist,
since AMD Automatic IBRS isn't affected by PBRSB-eIBRS.

The kernel command line option spectre_v2=eibrs is
used to select AMD Automatic IBRS, if available.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
---
 Documentation/admin-guide/hw-vuln/spectre.rst |  6 +++---
 .../admin-guide/kernel-parameters.txt         |  6 +++---
 arch/x86/include/asm/cpufeatures.h            |  1 +
 arch/x86/include/asm/msr-index.h              |  2 ++
 arch/x86/kernel/cpu/bugs.c                    | 20 +++++++++++--------
 arch/x86/kernel/cpu/common.c                  | 19 ++++++++++--------
 6 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/Documentation/admin-guide/hw-vuln/spectre.rst b/Documentation/admin-guide/hw-vuln/spectre.rst
index c4dcdb3d0d45..3fe6511c5405 100644
--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -610,9 +610,9 @@ kernel command line.
                 retpoline,generic       Retpolines
                 retpoline,lfence        LFENCE; indirect branch
                 retpoline,amd           alias for retpoline,lfence
-                eibrs                   enhanced IBRS
-                eibrs,retpoline         enhanced IBRS + Retpolines
-                eibrs,lfence            enhanced IBRS + LFENCE
+                eibrs                   Enhanced/Auto IBRS
+                eibrs,retpoline         Enhanced/Auto IBRS + Retpolines
+                eibrs,lfence            Enhanced/Auto IBRS + LFENCE
                 ibrs                    use IBRS to protect kernel
 
 		Not specifying this option is equivalent to
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 6cfa6e3996cf..839fa0fefb58 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5729,9 +5729,9 @@
 			retpoline,generic - Retpolines
 			retpoline,lfence  - LFENCE; indirect branch
 			retpoline,amd     - alias for retpoline,lfence
-			eibrs		  - enhanced IBRS
-			eibrs,retpoline   - enhanced IBRS + Retpolines
-			eibrs,lfence      - enhanced IBRS + LFENCE
+			eibrs		  - Enhanced/Auto IBRS
+			eibrs,retpoline   - Enhanced/Auto IBRS + Retpolines
+			eibrs,lfence      - Enhanced/Auto IBRS + LFENCE
 			ibrs		  - use IBRS to protect kernel
 
 			Not specifying this option is equivalent to
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 861d312c7955..d5acc4dc5906 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -432,6 +432,7 @@
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" AMD No Nested Data Breakpoints */
 #define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
 #define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* "" AMD Null Selector Clears Base */
+#define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* "" AMD Automatic IBRS */
 #define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* "" AMD SMM_CTL MSR is not present */
 
 /*
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index a85019756003..cb3d0f6e6ac2 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -25,6 +25,7 @@
 #define _EFER_SVME		12 /* Enable virtualization */
 #define _EFER_LMSLE		13 /* Long Mode Segment Limit Enable */
 #define _EFER_FFXSR		14 /* Enable Fast FXSAVE/FXRSTOR */
+#define _EFER_AUTOIBRS		21 /* Enable Automatic IBRS */
 
 #define EFER_SCE		(1<<_EFER_SCE)
 #define EFER_LME		(1<<_EFER_LME)
@@ -33,6 +34,7 @@
 #define EFER_SVME		(1<<_EFER_SVME)
 #define EFER_LMSLE		(1<<_EFER_LMSLE)
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
+#define EFER_AUTOIBRS		(1<<_EFER_AUTOIBRS)
 
 /* Intel MSRs. Some also available on other CPUs */
 
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 4a0add86c182..cf81848b72f4 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1238,9 +1238,9 @@ static const char * const spectre_v2_strings[] = {
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
 
@@ -1309,7 +1309,7 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE ||
 	     cmd == SPECTRE_V2_CMD_EIBRS_RETPOLINE) &&
 	    !boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
-		pr_err("%s selected but CPU doesn't have eIBRS. Switching to AUTO select\n",
+		pr_err("%s selected but CPU doesn't have Enhanced or Automatic IBRS. Switching to AUTO select\n",
 		       mitigation_options[i].option);
 		return SPECTRE_V2_CMD_AUTO;
 	}
@@ -1495,8 +1495,12 @@ static void __init spectre_v2_select_mitigation(void)
 		pr_err(SPECTRE_V2_EIBRS_EBPF_MSG);
 
 	if (spectre_v2_in_ibrs_mode(mode)) {
-		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		update_spec_ctrl(x86_spec_ctrl_base);
+		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
+			msr_set_bit(MSR_EFER, _EFER_AUTOIBRS);
+		} else {
+			x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
+			update_spec_ctrl(x86_spec_ctrl_base);
+		}
 	}
 
 	switch (mode) {
@@ -1580,8 +1584,8 @@ static void __init spectre_v2_select_mitigation(void)
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
index d762654d16a0..b441758d2680 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1229,8 +1229,8 @@ static const __initconst struct x86_cpu_id cpu_vuln_whitelist[] = {
 	VULNWL_AMD(0x12,	NO_MELTDOWN | NO_SSB | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
 
 	/* FAMILY_ANY must be last, otherwise 0x0f - 0x12 matches won't work */
-	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
-	VULNWL_HYGON(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO),
+	VULNWL_AMD(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
+	VULNWL_HYGON(X86_FAMILY_ANY,	NO_MELTDOWN | NO_L1TF | NO_MDS | NO_SWAPGS | NO_ITLB_MULTIHIT | NO_MMIO | NO_EIBRS_PBRSB),
 
 	/* Zhaoxin Family 7 */
 	VULNWL(CENTAUR,	7, X86_MODEL_ANY,	NO_SPECTRE_V2 | NO_SWAPGS | NO_MMIO),
@@ -1341,8 +1341,16 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 	   !cpu_has(c, X86_FEATURE_AMD_SSB_NO))
 		setup_force_cpu_bug(X86_BUG_SPEC_STORE_BYPASS);
 
-	if (ia32_cap & ARCH_CAP_IBRS_ALL)
+	/*
+	 * AMD's AutoIBRS is equivalent to Intel's eIBRS - use the Intel feature
+	 * flag and protect from vendor-specific bugs via the whitelist.
+	 */
+	if ((ia32_cap & ARCH_CAP_IBRS_ALL) || cpu_has(c, X86_FEATURE_AUTOIBRS)) {
 		setup_force_cpu_cap(X86_FEATURE_IBRS_ENHANCED);
+		if (!cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
+		    !(ia32_cap & ARCH_CAP_PBRSB_NO))
+			setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
+	}
 
 	if (!cpu_matches(cpu_vuln_whitelist, NO_MDS) &&
 	    !(ia32_cap & ARCH_CAP_MDS_NO)) {
@@ -1404,11 +1412,6 @@ static void __init cpu_set_bug_bits(struct cpuinfo_x86 *c)
 			setup_force_cpu_bug(X86_BUG_RETBLEED);
 	}
 
-	if (cpu_has(c, X86_FEATURE_IBRS_ENHANCED) &&
-	    !cpu_matches(cpu_vuln_whitelist, NO_EIBRS_PBRSB) &&
-	    !(ia32_cap & ARCH_CAP_PBRSB_NO))
-		setup_force_cpu_bug(X86_BUG_EIBRS_PBRSB);
-
 	if (cpu_matches(cpu_vuln_whitelist, NO_MELTDOWN))
 		return;
 
-- 
2.34.1

