Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 790B0678B31
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 23:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbjAWW6X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 17:58:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbjAWW6T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 17:58:19 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2081.outbound.protection.outlook.com [40.107.93.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB24301AC;
        Mon, 23 Jan 2023 14:58:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZSACIhZpdVGKncJRgs5QJnYBQeq7c5lt1SIeHd+E1pH77ATUv/DnrqtIyET4obpgVRtFgR/cunJypyOGV/t1VYd9NLWAVndRNKwFg288/5Gf87bukdCFgT0Shg1xJCBPwtrJnP6BxVOH6Elmkn4L3B2lcof5l3L49DEIEYU0zp1izq64TgON63dG7I0ZFRHpaZ1u50nNMyYuE8zRvaGKVMtvv1ZcI4bcduICBPtURB1j6Mi/O7RokAmVHr/lM6MU46qoZWJtL0X7wpuNkAmVOL/oOr8EQx3eQTIOd2yUFUjLrjaKb0YJCXEw6BR+rBppinCyFzP97sYiB1ZJYDAVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v9tHClwbTjqQsDepWLuQkEidUR6vBqMsc7y7GLLKoqo=;
 b=c0T6E0FuoLu8JhZkXd4ysBMx/ik/n0KKV4CdTbJDTqf6CiyMWOaGHms4j8SDVtF7Yk43pwqOx8nrVtMyqxWsPSHE3uQwVcrNElBMDxmupyM8SSCw2G7jJxIOWmBoOFwRbES/lyk2oSVAem6vcmngY6m9shDM+ix9HlFbDJyXKlZatL/hifDHXM1Y+EmBmSIJEg6+uB8ivo3K1tMMHqnnHpy8qRssqxDpS6Gy8HEEKu/8OHc5Vbe3PrTTD719PyUDKVjWxNkBnygFY9lvfWdhU/Bw2EvYdCNKbv35GymPkoGdseETBA8xLYWnShoqJLT5AgCJ3IIO/bu601+m/O4cIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v9tHClwbTjqQsDepWLuQkEidUR6vBqMsc7y7GLLKoqo=;
 b=xOjl/RlXDrHGFGAAQfIAbrQ5ZD+e1X7VIz1Pyd5h7mPn+Spdu/QzxZJLDERuZ98pfpv+IUbw6DAyiEbgmMxdQ4XeO8kC7dTpOZHYQojHxosvE16MeuVH9uy9BAimlroxCR8+hIhWIx6HKWgquzzuQG9viGE2KI2mLBLgxTp+WgY=
Received: from BN9PR03CA0986.namprd03.prod.outlook.com (2603:10b6:408:109::31)
 by PH0PR12MB8125.namprd12.prod.outlook.com (2603:10b6:510:293::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 22:58:03 +0000
Received: from BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:109:cafe::87) by BN9PR03CA0986.outlook.office365.com
 (2603:10b6:408:109::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Mon, 23 Jan 2023 22:58:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT030.mail.protection.outlook.com (10.13.177.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Mon, 23 Jan 2023 22:58:03 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Jan
 2023 16:58:02 -0600
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
Subject: [PATCH v8 4/8] x86/cpu, kvm: Move X86_FEATURE_LFENCE_RDTSC to its native leaf
Date:   Mon, 23 Jan 2023 16:56:56 -0600
Message-ID: <20230123225700.2224063-5-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230123225700.2224063-1-kim.phillips@amd.com>
References: <20230123225700.2224063-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT030:EE_|PH0PR12MB8125:EE_
X-MS-Office365-Filtering-Correlation-Id: c28b1620-d126-4fd2-145b-08dafd954897
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yxUbnkuJhfBaPYu2bBdwBX2Yl5iSBjTc8H5E4x8eh74uSykIF36S8zIgvh4OdytouXSgct7W0ToBaURdzhC/2lvVhDZLhXOTD80K19NiV5F16idUeDSlm27ACSiu7oiF9GbBcPUr6xLSD/6YRFxuhfn8Z9k8NZ/l/g4Rm2OdGJIGNp6wczNpp2eAD1dSU3EQ30rzX3FlVreNf5akeliH7fIn+M+gaUGV8zudu9l8gM47CDnelCOzfotxzldzFIVIU6+FMXFP6jejl3t3zR++K2BLQ7porK+oOynNmCWaL42dxHNbm1tLpIXuVk9cKbT13AJmey9acETYiMW5XQRf9TKn5/2Q0sPrxXRCwJhf4o78DY17+uSFjgugsgUEN5UwnFvi2VDORszpWx+0A9aOjJnaRS9pubC5gpj7MoIPgI6/ROTFnX6Kangt9Ak2tS3TwBissVyTl5i8x1be9endtyurZY6/9FCg4uHsi1LUA1wSm4+oKvfV0TconT6MezfcTMjGrQdRumAv+humDwUwyykIBkJMh2iEfWzoOpNukm6x9Zqr4+10hS7B/rQrA8xso2qOi77pUnr6I8wI7lnYrBKoMhcyCgqeaMbxFJr2P3fybVCOvoZG5mP/qalGPOg+sHTuXqW0sdUVX8QNSWqSH5vsKpACXaNWQFBSCh1uprwktqqKQXVH28wL419EWD7iWf2pkezPviZtirrT+nRfhOjj6qE3rFoRaepUwldI+ZE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199015)(46966006)(36840700001)(40470700004)(54906003)(316002)(2616005)(81166007)(356005)(36860700001)(40480700001)(2906002)(83380400001)(36756003)(47076005)(336012)(41300700001)(44832011)(7416002)(5660300002)(40460700003)(8936002)(70586007)(82740400003)(70206006)(426003)(8676002)(6916009)(4326008)(478600001)(16526019)(82310400005)(26005)(1076003)(86362001)(186003)(6666004)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:58:03.5692
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c28b1620-d126-4fd2-145b-08dafd954897
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8125
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

Drop the bit description comments now it's more self-describing.

Also, in amd_init(), don't bother setting DE_CFG[1] any more.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 3 ++-
 arch/x86/kernel/cpu/amd.c          | 2 +-
 arch/x86/kvm/cpuid.c               | 4 ++--
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 7f0fb894e432..4f22d828c753 100644
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
index 13bd2769fa5a..601eeb03ebc9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -742,11 +742,11 @@ void kvm_set_cpu_caps(void)
 		F(SME_COHERENT));
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
-		F(NO_NESTED_DATA_BP) | 0 /* SmmPgCfgLock */ |
+		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
 		BIT(6) /* NULL_SEL_CLR_BASE */ | 0 /* PrefetchCtlMsr */
 	);
 	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
-		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(2) /* LFENCE Always serializing */;
+		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
 	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(6) /* NULL_SEL_CLR_BASE */;
 	kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(9) /* NO_SMM_CTL_MSR */;
-- 
2.34.1

