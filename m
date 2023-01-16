Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBFE66D279
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 00:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235115AbjAPXDV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 18:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbjAPXCt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 18:02:49 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2066.outbound.protection.outlook.com [40.107.244.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE3B298FF;
        Mon, 16 Jan 2023 15:02:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Re+7i8Kb5XiQSS0j5E7ng80SVZx/0bWDeNwKfl/Vw1BIoXb6pAIkC+FVHahQrfhcnE40IWffhSmynBnObZRGk4Qs5rvejQe3USWSiNllIvCmcuA9hvl5dC48L9Nt6vUetG0ibVf3u2AyDMdDEK4fiPCDMmKffoswLTs7COi6LvGnBAktWUOTUX3VoneZ4U3z2Dach3guIrbjT+oHL0W74Eyd3FcB6VNZnywU6wAtmIJa3KlDi3a53k6lItAr0TwhUtD0RUbHvLVUGC0QZD2N2QVaWkz7WOLaNK7TGNboI8ON6veilNOP5464rMEqT4STb6FAJtMNH/2qUnpWJtSYHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T5bbewbRn16pCLxl29623O6eBamSPRtWsJX2gaRHxLA=;
 b=aklBzXAN29nK6l0eJIyh5P3LfCiH4IyohRK83RgyrPdKm61VpBlCQB0nkUrDrvX6LrX+bFArxm6PorEUf+KCk/kxgDQaw5V+ee/AJgbo18kH/BNSBCZQ4LBE0VYmp1cQTKyRwudDh9z3NHOLv2etaeh8VUw1Dxqy9CwibAlLuXOx+o0G9eAMMWNlGAdwowwOzXETw9euZOP4bLHZ9idBmtcFAfxNG/+wy+5cx0DXwMm9HEYJ6svCUwA8G6ymV7Qkwn0nXekoTO0r2M+pGHoQhpe/SqrpT6UI9CPapB86Ybp1XuOMHrwF1UHNwLYO0/Q90od49XFfV4xLHqfk7Wt98A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T5bbewbRn16pCLxl29623O6eBamSPRtWsJX2gaRHxLA=;
 b=t3Au4uG3wNL744LIF/osWUV+KMDqLfrHnDKBuXBMBUrMrDcTWwdyzjQIREQ2uZ904MlpIu5hfs++RWJuv2xLTkHOdNZvAv59mHK0S2Zep8oMLjy4+4JeyvNMDNtgdhSLh9Ym1hGBLdY5haCJq4gX5NVxBCXcPU9AGz68SBP+Flc=
Received: from DS7PR03CA0184.namprd03.prod.outlook.com (2603:10b6:5:3b6::9) by
 CH3PR12MB8329.namprd12.prod.outlook.com (2603:10b6:610:12e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Mon, 16 Jan
 2023 23:02:45 +0000
Received: from DS1PEPF0000B076.namprd05.prod.outlook.com
 (2603:10b6:5:3b6:cafe::df) by DS7PR03CA0184.outlook.office365.com
 (2603:10b6:5:3b6::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Mon, 16 Jan 2023 23:02:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000B076.mail.protection.outlook.com (10.167.17.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Mon, 16 Jan 2023 23:02:44 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 16 Jan
 2023 17:02:43 -0600
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
Subject: [PATCH v7 3/7] x86/cpu, kvm: Move the LFENCE_RDTSC / LFENCE always serializing feature
Date:   Mon, 16 Jan 2023 17:01:55 -0600
Message-ID: <20230116230159.1511393-4-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B076:EE_|CH3PR12MB8329:EE_
X-MS-Office365-Filtering-Correlation-Id: 787a174d-c0eb-499c-5681-08daf815c764
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQKdx3PUtqjXB1rUtEKvICcGc2sp1SJea05LmSxuGbOfFtqEVZGrimXXiB+oSDdsYN2c+n+XxTLVN0FjPk2lyNkxvuZqKNLtYDUPGiqD7zB7zjO6JXoCHuJycPtF9GddiB8hOP7K78/746bYn0xudiesWathSBFRpRxhgw48Yb04OUlrnwpEweeFXDbFhTGFkwrf8O0S+0HSOKNj1GtZCBbmqxL0bjSq9lYwupC4L1e+qUzPFlygolusDs2xOQMY0d5aTSfoz3fZveeG9nex8B6xvZbztgJaeXH6aW/Tyn98u7/Lp6Ws/WB7f6XrSq4iePGO9DJpP/fqM+7A8HeTRSraLxy28W/mC+LXt9XItQTzgMsTIjT4IkSAEZZ5Qolsl6MJbyku8VdQ3+4LMhUPj+kM4lrvuP1nVuy1llsflgHdCIEPREon3yfWxEL2+yvUSsX+bumT/I8R0r9NKNfsF/JP1lkGg0HBhTBrXK6nphCEEEbVw9QM0Xhuo1ssOb91JCzEO8WKnjHL4pe5jcfCD3F74Ez2yPFvmd0J0PWxdy8oAD5c5PwgEqSRXkNulsKigCyk1PNtU3EEbzuaim14JQCdz9NiklPcuXZ4p629YUNmH/khMdDil6Dv/SaXe1Ednzapw+rzijEbetLd/7EmAmDHqDKc/NWrI1PgFP3rnnxwmWgjIYMlKKpnsmCRWcmlYN2275JowN+hPUobEDHoXnxXEnzK57S/1JRIbr4edkA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(376002)(346002)(451199015)(36840700001)(40470700004)(46966006)(6666004)(26005)(8936002)(6916009)(36756003)(7696005)(2616005)(1076003)(316002)(478600001)(16526019)(5660300002)(40480700001)(186003)(7416002)(4326008)(40460700003)(356005)(82740400003)(41300700001)(70586007)(81166007)(86362001)(8676002)(54906003)(70206006)(83380400001)(82310400005)(47076005)(44832011)(2906002)(426003)(336012)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 23:02:44.8809
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 787a174d-c0eb-499c-5681-08daf815c764
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B076.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8329
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The LFENCE_RDTSC / LFENCE always serializing feature was a scattered bit
and open-coded for KVM in __do_cpuid_func().  Add it to its newly added
CPUID leaf 0x80000021 EAX proper, and propagate it in kvm_set_cpu_caps()
instead.  Drop the bit description comments now it's more self-describing.

Also, in amd_init(), don't bother setting DE_CFG[1] any more if we already
have the X86_FEATURE_LFENCE_RDTSC feature (set by hardware).

Whilst there, switch to using the more efficient cpu_feature_enabled()
instead of static_cpu_has().

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 3 ++-
 arch/x86/kernel/cpu/amd.c          | 2 +-
 arch/x86/kvm/cpuid.c               | 9 ++++-----
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 8255b95a7987..b22b2e8fef00 100644
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
@@ -430,6 +430,7 @@
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" AMD No Nested Data Breakpoints */
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
index c9081e3a1b66..d7a13716b7c8 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -742,8 +742,10 @@ void kvm_set_cpu_caps(void)
 		F(SME_COHERENT));
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
-		F(NO_NESTED_DATA_BP)
+		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC)
 	);
+	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
+		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
 
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
@@ -1229,7 +1231,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
 		/*
 		 * Pass down these bits:
-		 *    EAX      2      LAS, LFENCE always serializing
 		 *    EAX      6      NSCB, Null selector clear base
 		 *
 		 * Other defined bits are for MSRs that KVM does not expose:
@@ -1239,10 +1240,8 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 * KVM doesn't support SMM_CTL.
 		 *   EAX       9     SMM_CTL MSR is not supported
 		 */
-		entry->eax &= BIT(2) | BIT(6);
+		entry->eax &= BIT(6);
 		entry->eax |= BIT(9);
-		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
-			entry->eax |= BIT(2);
 		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 			entry->eax |= BIT(6);
 		break;
-- 
2.34.1

