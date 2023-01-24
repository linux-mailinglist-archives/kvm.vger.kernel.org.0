Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069A1679EC1
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:35:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbjAXQfC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232991AbjAXQfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:35:00 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2048.outbound.protection.outlook.com [40.107.237.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59554B8B3;
        Tue, 24 Jan 2023 08:34:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kLOHp3yhTp7M1ZPuGk4HLV4m7ECj3WQM7hVhwxIJR6X+uiNjdEyUlOJHc8uhAlB5oVcHw9lFMG4DW19As3f8xwCa9LcfNUlQP42wkD39AyTV3PAoUMpAvCqM8rNIxwLKTWHHb0iCfqufcmyQMcAMSBEs6KRqv1akvY4XM1Oh2Yf6EMa5SPz+18YJG0uhdLtUEgXZJIHDpVvudQbOxXWavijvD4x7jt4Ro+Hl20uhbqdnKZVwVhzWFLfhnYrz5RrvuzrPNjmCXqk7pk3imhf+QvyLteZhmE01/4k/2Uj6JVZ9TcyznkvX8uj10jrjYUN7wE8zx9zkL5JvwajaRAaDHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9yDG4uvs1w0obZGxxDm+raAwQbQJ/zFfwkygQNbaUkQ=;
 b=nuolWiO5nCYMhF2ZGdJX64pzBuh6/eU8GxW5bqXYDRRKp9SGPlIBowAIBAsnQHg0C5suezXa1D5SY4g4nYPyYpcy8CbRLtoOoxZdxA1ehyctH4dTfJv+RdlLYIiFsadR37BfKz1wK5IRNW0H/V6tbKZV+HiVRXIlMR5ajwN/ZMP/1ldAM8nPL5sByDkTBxpQWgeHGZn3KGIS9y0rWSb+p2+ZjdjsNDrUfK/FEJSuUIsf8SInml3nPPe5yW38KGl0YIkSRZmwn+TU46RfLAayQdxHVqIxaisXwsbxoiFbLrAkDIqN93hE2XByC1QMLVE5K4DNRZEYmOuLoBDsYmVKWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9yDG4uvs1w0obZGxxDm+raAwQbQJ/zFfwkygQNbaUkQ=;
 b=4L1iWQMWjsfCGcDiFOHJkfUg19DGSjMVP8amXd5liLIUeTCN+ebg+56r4jdcZhMZr+bCUPyo5fUyvyAME+DjKvJSL4C0RvPq+pV7zwA4Bxr0TADhbi5oO8XQJ76Xu+vIUFOoNpo3+llgueAvdcqSWJyP5hiR8b0F5T9V1L30ohA=
Received: from BN9PR03CA0273.namprd03.prod.outlook.com (2603:10b6:408:f5::8)
 by SN7PR12MB7022.namprd12.prod.outlook.com (2603:10b6:806:261::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 16:34:31 +0000
Received: from BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f5:cafe::b8) by BN9PR03CA0273.outlook.office365.com
 (2603:10b6:408:f5::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17 via Frontend
 Transport; Tue, 24 Jan 2023 16:34:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT013.mail.protection.outlook.com (10.13.176.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.17 via Frontend Transport; Tue, 24 Jan 2023 16:34:31 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 10:34:29 -0600
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
Subject: [PATCH v9 4/8] x86/cpu, kvm: Move X86_FEATURE_LFENCE_RDTSC to its native leaf
Date:   Tue, 24 Jan 2023 10:33:15 -0600
Message-ID: <20230124163319.2277355-5-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124163319.2277355-1-kim.phillips@amd.com>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT013:EE_|SN7PR12MB7022:EE_
X-MS-Office365-Filtering-Correlation-Id: 6202ddb3-4f19-4dde-135a-08dafe28de95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bbu1aKUXRx7V+fK0gOPBOFDCKk15ThGBYdSLMPw55HL1v/+Y2gQhNTOf8FLjy4q6wVLhAbCOJpyXgMUiOcl87/8UDab7VrOCvtFQaq7bWMhoWWyBDdc2+D5j6mGOe4GRmyKX1XXYsUK9kaXhx55zMD2Bxw5oxgeOfyxPsnSaClXDyboiS956tbGMnRarbTBr3oJFI4Bnd/ggKnCNCR/WGv0GXUPB2wlfUnV0gKEgZs/LXPCJykXgPZ7zqRXYAck3VC9n1tjbiawr6up1rb40EPRzJq67qaKzWCNHvLIO20sLr1vaPt+DBZyV7RTiLOwhA6BezNJLFS4ovtsEDczFS34dwLsO+oszDn2F56d4m6DsAarMQqaZXxDaTpaLWHn1sS8XC2JOOrH7SKcinx6vy9qoCOTuH3wU0Id5hH4ePZnH4lGw+P1N/mjArtTgI1NxBNQmJ4F8xZ11lTv9NXt3cSURqOEk22b4znwQCjUVN+8PJmpsF2L8+3W2sl1SUZYkcbbVYqk1mkGZqYDHPLQF4DnU0HPREqgb9Uf0XDlnIgbv8HGmxrI2h1vopEhd/teVh17WJoiyPDcXyCZ3lO9qNiXz5t/JYclHdMqT58SbRMN707fRhqQdGgPRZV50x6AiyShYiQ5W6FI2ygNB18vZWEEMW6rBGmZHZ/c52I9cajW0Lk/D9yG/QXImsgsJ8qtqDcxPiqYr1FvsmnNC2T2v6yLGIW54KeWKKG5p59TWITs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(39860400002)(346002)(451199015)(36840700001)(40470700004)(46966006)(36860700001)(83380400001)(82740400003)(81166007)(2906002)(86362001)(44832011)(8936002)(5660300002)(356005)(41300700001)(4326008)(7416002)(82310400005)(186003)(40460700003)(40480700001)(16526019)(70206006)(6916009)(8676002)(26005)(316002)(47076005)(336012)(6666004)(426003)(70586007)(2616005)(54906003)(1076003)(478600001)(7696005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 16:34:31.2336
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6202ddb3-4f19-4dde-135a-08dafe28de95
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7022
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LFENCE always serializing feature bit was defined as scattered
LFENCE_RDTSC and its native leaf bit position open-coded for KVM.
Add it to its newly added CPUID leaf 0x80000021 EAX proper.
With LFENCE_RDTSC is in its proper place, the kernel's set_cpu_cap()
will effectively sythesize the feature for KVM going forward.

Drop the bit description comments now it's more self-describing.

Also, in amd_init(), don't bother setting DE_CFG[1] any more.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 3 ++-
 arch/x86/kernel/cpu/amd.c          | 2 +-
 arch/x86/kvm/cpuid.c               | 5 +----
 3 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 4637fd7a84d6..e975822951b2 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -97,7 +97,7 @@
 #define X86_FEATURE_SYSENTER32		( 3*32+15) /* "" sysenter in IA32 userspace */
 #define X86_FEATURE_REP_GOOD		( 3*32+16) /* REP microcode works well */
 #define X86_FEATURE_AMD_LBR_V2		( 3*32+17) /* AMD Last Branch Record Extension Version 2 */
-#define X86_FEATURE_LFENCE_RDTSC	( 3*32+18) /* "" LFENCE synchronizes RDTSC */
+/* FREE, was #define X86_FEATURE_LFENCE_RDTSC		( 3*32+18) "" LFENCE synchronizes RDTSC */
 #define X86_FEATURE_ACC_POWER		( 3*32+19) /* AMD Accumulated Power Mechanism */
 #define X86_FEATURE_NOPL		( 3*32+20) /* The NOPL (0F 1F) instructions */
 #define X86_FEATURE_ALWAYS		( 3*32+21) /* "" Always-present feature */
@@ -432,6 +432,7 @@
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
+#define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index f769d6d08b43..208c2ce8598a 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -956,7 +956,7 @@ static void init_amd(struct cpuinfo_x86 *c)
 
 	init_amd_cacheinfo(c);
 
-	if (cpu_has(c, X86_FEATURE_XMM2)) {
+	if (!cpu_has(c, X86_FEATURE_LFENCE_RDTSC) && cpu_has(c, X86_FEATURE_XMM2)) {
 		/*
 		 * Use LFENCE for execution serialization.  On families which
 		 * don't have that MSR, LFENCE is already serializing.
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9764499acce2..448b5de98b8f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -742,12 +742,9 @@ void kvm_set_cpu_caps(void)
 		F(SME_COHERENT));
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
-		F(NO_NESTED_DATA_BP) |
-		BIT(2) /* LFENCE Always serializing */ | 0 /* SmmPgCfgLock */ |
+		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
 		BIT(6) /* NULL_SEL_CLR_BASE */ | 0 /* PrefetchCtlMsr */
 	);
-	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
-		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(2) /* LFENCE Always serializing */;
 	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(6) /* NULL_SEL_CLR_BASE */;
 	kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(9) /* NO_SMM_CTL_MSR */;
-- 
2.34.1

