Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 508BF61A371
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 22:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiKDVhs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Nov 2022 17:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiKDVhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Nov 2022 17:37:40 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 421DF50F05;
        Fri,  4 Nov 2022 14:37:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FK8vWeFHOI8DiWBN7k2fnI+3/+JIzRGKOL1mGY8Dd0P/6Oi6NBy/iij3BTk84GguDkVup/KNTpefyvzBQ1DtppQv8r49xpI4qr+1RGnnEDdkch1htL254/dkoPxhDmhMHiUeRi8HOUPuniQXzbwqSJ1N3w7IsJNC214L62G1SpwE7POD3+NhaxqliVvN4Y+AnhbxbceIwU7HG2DnlKsJYo+3ZmQizc2PEtlgvAMKIuOqgzSehtdIx1PFsUEaaAD15bx8n2mP3mamkJYW63o9XyHMfVA00gX6KvQIn5eMZqTMI7V36Z74D3borwXzOrx3lhV6EnwBzUOZ31s5lntg4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mbVDM7xURsCJ38pD8le61MToi9JHl8/f+1S9G9aw8d4=;
 b=b1UzB8nZ1PXjUUCVBCIdfrDWnYmd5PjEob6mnRSlIflFpP55vvMx5Zinx/zFMf9hMcuHVluEBIibGlJfkdrRYqTQqwO8u3DraRONNV4yzXJ1icc893iL9KE/AJeYcWl2QxoB6TXkDWAOOUxFVAQOFyX1AgAWx4JJY2TKWmW0HiZkd/CiwBcaRUeJcgcj9VOFwmT/Cwzo5bOYGQoxFOdC5EXygy/jWGPt06ugJwYuPfNS9tWJI5+/O2A0rRP4fp80VDBrmASbk0OH6RtypX+8M5rZqrHSzqsJnYuZT8kxfqPuI0VGswXXTeXDbelxB7IZjWDGwFAnunIto1fXi1twxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbVDM7xURsCJ38pD8le61MToi9JHl8/f+1S9G9aw8d4=;
 b=fj8ZPqtdKfN/WiHCzQc3IdVhJEzBKPboAKmKjQUSANRvpZqVepPaVnp8DiK4NAYyJVB6epksB+jcpF0kDBdh9LBZCrdpGfnkWNdZSoSiYrVNkRB4PWe7IpAiEKDZkClLgbsHbHdLB1YQXNvUeDReA8/AeOwfHqLZHPoWMAisxG0=
Received: from DM6PR02CA0062.namprd02.prod.outlook.com (2603:10b6:5:177::39)
 by MW3PR12MB4409.namprd12.prod.outlook.com (2603:10b6:303:2d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Fri, 4 Nov
 2022 21:37:27 +0000
Received: from DM6NAM11FT107.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:177:cafe::4f) by DM6PR02CA0062.outlook.office365.com
 (2603:10b6:5:177::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.23 via Frontend
 Transport; Fri, 4 Nov 2022 21:37:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT107.mail.protection.outlook.com (10.13.172.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5791.20 via Frontend Transport; Fri, 4 Nov 2022 21:37:27 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 4 Nov
 2022 16:37:25 -0500
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
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] x86/speculation: Support Automatic IBRS
Date:   Fri, 4 Nov 2022 16:36:50 -0500
Message-ID: <20221104213651.141057-3-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221104213651.141057-1-kim.phillips@amd.com>
References: <20221104213651.141057-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT107:EE_|MW3PR12MB4409:EE_
X-MS-Office365-Filtering-Correlation-Id: 36830118-6dda-4163-36ec-08dabeacc4f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qZs9mEbd1QYoPidYqP432+G0b7JuEG6wj5EMH7rLgM5oUwqnc0J0uNr5m8wJhiZaW/itf2KChduzA5+4Q+NUkeR07ofmPGtLVaztV/foTHsx6a9qfj3jcg0kBb3IbxtvcCDe9sg2Wu6TGiHHrTeXeKCRA7hD+vPg+HJYoZKPCoAxJmbUh+SM8YhsjOBaUOzL98j+b/MZaCmtFiulcMcDKxQaFQXyeVHtVRNnvjbKBqb3l8xK16sI3EDEnWPLds7+SYpsTJFlq0Z87mi6YwTyZdd3BL3HDUBel1F7Q05J8U32A6vwu9TSWUTwjbL9zS+5MF8CzX+5ZzeC9Vtid9upCOpj9Oo9UqkqnSVScpIbQfZ29O60kVhjVdMe0hSDwdF/tTF/mfEmMqXqVwDHpL1HZ+c+7CZeFSWiTEoj5GFcL2QdFk2fviVaCIF4Ls1MxG2isneN+yEISsM7RcuQLhaXHQjhBUphXLw4vBCep3tYNNxOQNjJXqPkZQLFNhB9I0iudZ7CxF/Knt/Uujum1zsMdI5eWGDRP+KtDs8lrnuP8m+YpQEHNmhHUuSATsXeRvVMpIF20T0D97ZIJgnX61zgpyXuFOhIeJyuDpA6dndOF/+05uco8yKDnVtGnQe3e+lHdG6XgsLeXk597uAfm8ONGC6ZeSH25ah9m0lN0ribujIZttvcF4ImOyHnc6Y7u88neYQswSxoQPE1F/AjWXxpPaa1Z+QR+xQmSRyfxc8KKuZmmFRxT571TxR7BPWZlxAyE9yRrNluPhn7MFYsvlSRJmxhi9SvWrkeIhqEAGVxuJvZlrc3sXPfExhcHr5OzzVv
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(346002)(136003)(451199015)(40470700004)(36840700001)(46966006)(81166007)(36860700001)(82310400005)(36756003)(40480700001)(40460700003)(86362001)(41300700001)(70586007)(4326008)(26005)(356005)(8676002)(70206006)(1076003)(2616005)(44832011)(16526019)(7416002)(186003)(7696005)(336012)(478600001)(5660300002)(6916009)(8936002)(316002)(82740400003)(6666004)(54906003)(2906002)(83380400001)(47076005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Nov 2022 21:37:27.3753
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 36830118-6dda-4163-36ec-08dabeacc4f7
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT107.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4409
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

It is a "set-and-forget" feature that means that, unlike e.g.,
s/w-toggled SPEC_CTRL.IBRS, h/w manages its IBRS mitigation
resources automatically across CPL transitions.

The feature is advertised by CPUID_Fn80000021_EAX bit 8 and is
enabled by setting MSR C000_0080 (EFER) bit 21.

Enable Automatic IBRS by default if the CPU feature is present.
It typically provides greater performance over the incumbent
generic retpolines mitigation.  In addition:

 - Don't clear the RSB on VMEXIT when AutoIBRS is enabled:
   The internal return address stack used for return address
   predictions is automatically cleared on VMEXIT.

 - Automatic IBRS removes the need for toggling IBRS during
   firmware switches, so don't enable IBRS_FW when Automatic
   IBRS is enabled.

 - Allow for spectre_v2=autoibrs in the kernel command line,
   reverting to auto-selection if the feature isn't available.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 .../admin-guide/kernel-parameters.txt         |  1 +
 arch/x86/include/asm/msr-index.h              |  2 ++
 arch/x86/include/asm/nospec-branch.h          |  1 +
 arch/x86/kernel/cpu/bugs.c                    | 34 +++++++++++++++++--
 4 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index a465d5242774..5ac4422e16a6 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5702,6 +5702,7 @@
 			eibrs,retpoline   - enhanced IBRS + Retpolines
 			eibrs,lfence      - enhanced IBRS + LFENCE
 			ibrs		  - use IBRS to protect kernel
+			autoibrs          - AMD Automatic IBRS
 
 			Not specifying this option is equivalent to
 			spectre_v2=auto.
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 10ac52705892..bd73e509cfa6 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -30,6 +30,7 @@
 #define _EFER_SVME		12 /* Enable virtualization */
 #define _EFER_LMSLE		13 /* Long Mode Segment Limit Enable */
 #define _EFER_FFXSR		14 /* Enable Fast FXSAVE/FXRSTOR */
+#define _EFER_AUTOIBRS		21 /* Automatic IBRS Enable */
 
 #define EFER_SCE		(1<<_EFER_SCE)
 #define EFER_LME		(1<<_EFER_LME)
@@ -38,6 +39,7 @@
 #define EFER_SVME		(1<<_EFER_SVME)
 #define EFER_LMSLE		(1<<_EFER_LMSLE)
 #define EFER_FFXSR		(1<<_EFER_FFXSR)
+#define EFER_AUTOIBRS		(1<<_EFER_AUTOIBRS)
 
 /* Intel MSRs. Some also available on other CPUs */
 
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 82580adbca4b..12b2b070caab 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -442,6 +442,7 @@ enum spectre_v2_mitigation {
 	SPECTRE_V2_EIBRS_RETPOLINE,
 	SPECTRE_V2_EIBRS_LFENCE,
 	SPECTRE_V2_IBRS,
+	SPECTRE_V2_AUTO_IBRS,
 };
 
 /* The indirect branch speculation control variants */
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 66d7addf1784..31e5af78baa0 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1050,6 +1050,7 @@ enum spectre_v2_mitigation_cmd {
 	SPECTRE_V2_CMD_EIBRS_RETPOLINE,
 	SPECTRE_V2_CMD_EIBRS_LFENCE,
 	SPECTRE_V2_CMD_IBRS,
+	SPECTRE_V2_CMD_AUTOIBRS,
 };
 
 enum spectre_v2_user_cmd {
@@ -1124,6 +1125,7 @@ spectre_v2_parse_user_cmdline(void)
 	return SPECTRE_V2_USER_CMD_AUTO;
 }
 
+/* Checks for Intel IBRS versions */
 static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
 {
 	return mode == SPECTRE_V2_IBRS ||
@@ -1233,6 +1235,7 @@ static const char * const spectre_v2_strings[] = {
 	[SPECTRE_V2_EIBRS_LFENCE]		= "Mitigation: Enhanced IBRS + LFENCE",
 	[SPECTRE_V2_EIBRS_RETPOLINE]		= "Mitigation: Enhanced IBRS + Retpolines",
 	[SPECTRE_V2_IBRS]			= "Mitigation: IBRS",
+	[SPECTRE_V2_AUTO_IBRS]			= "Mitigation: Automatic IBRS",
 };
 
 static const struct {
@@ -1249,6 +1252,7 @@ static const struct {
 	{ "eibrs",		SPECTRE_V2_CMD_EIBRS,		  false },
 	{ "eibrs,lfence",	SPECTRE_V2_CMD_EIBRS_LFENCE,	  false },
 	{ "eibrs,retpoline",	SPECTRE_V2_CMD_EIBRS_RETPOLINE,	  false },
+	{ "autoibrs",		SPECTRE_V2_CMD_AUTOIBRS,	  false },
 	{ "auto",		SPECTRE_V2_CMD_AUTO,		  false },
 	{ "ibrs",		SPECTRE_V2_CMD_IBRS,              false },
 };
@@ -1305,6 +1309,13 @@ static enum spectre_v2_mitigation_cmd __init spectre_v2_parse_cmdline(void)
 		return SPECTRE_V2_CMD_AUTO;
 	}
 
+	if (cmd == SPECTRE_V2_CMD_AUTOIBRS &&
+	    !boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
+		pr_err("%s selected but CPU doesn't have AMD Automatic IBRS. Switching to AUTO select\n",
+		       mitigation_options[i].option);
+		return SPECTRE_V2_CMD_AUTO;
+	}
+
 	if ((cmd == SPECTRE_V2_CMD_RETPOLINE_LFENCE ||
 	     cmd == SPECTRE_V2_CMD_EIBRS_LFENCE) &&
 	    !boot_cpu_has(X86_FEATURE_LFENCE_RDTSC)) {
@@ -1392,6 +1403,7 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
 	 */
 	switch (mode) {
 	case SPECTRE_V2_NONE:
+	case SPECTRE_V2_AUTO_IBRS:
 		return;
 
 	case SPECTRE_V2_EIBRS_LFENCE:
@@ -1419,6 +1431,7 @@ static void __init spectre_v2_select_mitigation(void)
 {
 	enum spectre_v2_mitigation_cmd cmd = spectre_v2_parse_cmdline();
 	enum spectre_v2_mitigation mode = SPECTRE_V2_NONE;
+	uint64_t efer;
 
 	/*
 	 * If the CPU is not affected and the command line mode is NONE or AUTO
@@ -1434,6 +1447,11 @@ static void __init spectre_v2_select_mitigation(void)
 
 	case SPECTRE_V2_CMD_FORCE:
 	case SPECTRE_V2_CMD_AUTO:
+		if (boot_cpu_has(X86_FEATURE_AUTOIBRS)) {
+			mode = SPECTRE_V2_AUTO_IBRS;
+			break;
+		}
+
 		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED)) {
 			mode = SPECTRE_V2_EIBRS;
 			break;
@@ -1480,6 +1498,10 @@ static void __init spectre_v2_select_mitigation(void)
 	case SPECTRE_V2_CMD_EIBRS_RETPOLINE:
 		mode = SPECTRE_V2_EIBRS_RETPOLINE;
 		break;
+
+	case SPECTRE_V2_CMD_AUTOIBRS:
+		mode = SPECTRE_V2_AUTO_IBRS;
+		break;
 	}
 
 	if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
@@ -1495,6 +1517,11 @@ static void __init spectre_v2_select_mitigation(void)
 	case SPECTRE_V2_EIBRS:
 		break;
 
+	case SPECTRE_V2_AUTO_IBRS:
+		rdmsrl(MSR_EFER, efer);
+		wrmsrl(MSR_EFER, efer | EFER_AUTOIBRS);
+		break;
+
 	case SPECTRE_V2_IBRS:
 		setup_force_cpu_cap(X86_FEATURE_KERNEL_IBRS);
 		if (boot_cpu_has(X86_FEATURE_IBRS_ENHANCED))
@@ -1571,8 +1598,8 @@ static void __init spectre_v2_select_mitigation(void)
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
@@ -1589,7 +1616,8 @@ static void __init spectre_v2_select_mitigation(void)
 			pr_info("Enabling Speculation Barrier for firmware calls\n");
 		}
 
-	} else if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_ibrs_mode(mode)) {
+	} else if (boot_cpu_has(X86_FEATURE_IBRS) && !spectre_v2_in_ibrs_mode(mode) &&
+		   mode != SPECTRE_V2_AUTO_IBRS) {
 		setup_force_cpu_cap(X86_FEATURE_USE_IBRS_FW);
 		pr_info("Enabling Restricted Speculation for firmware calls\n");
 	}
-- 
2.34.1

