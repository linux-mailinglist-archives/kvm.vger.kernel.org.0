Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14B91664EF9
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 23:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbjAJWrp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 17:47:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235025AbjAJWrf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 17:47:35 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7A133D58;
        Tue, 10 Jan 2023 14:47:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mblqt9xSDTx2T6/PK6x79eaOqV4NMxgl5A0d895p4bi6AnbnXXcpFBRPxPlehxoUi3FELZlDxBAp6VDQxS8yVQAhpOsrd/klSWOYjJt7VAsfnKVb/pDHsZqX2KRwDPitP9CfhCxyVsIfPycGj/gf58MyWsxv9k07ua+KKJ1vuN+AgZbTWPHqXK7t43/gQfFv082EecufQJnsjbGhDqnF916LxJK5vDd9PwoLKK6RD15lPQtskXZcda6fkAfS+gQ5U+B+buoLICPuX9G9iy+R4Zuh3e7bVvMu1aZ/BuY0Epmc6BxNYv/D68NvDL4/MeAp6Nm+yNayuEUMIHlxKtFkCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IRHtynNGbwYyZbx6wfEhzaG5TNzdrGsgcF/ZyG15fdQ=;
 b=Xvp29qMosuHsE7X3lCR2tg89oDnoi5o9bA2fmHCyZ4DzdvcDdqbXefhN/kBySSOGt+TTM9gNNz1GuYn14zQg1i3u7gxrFmaoM9WYE3nvyy/w2SynpgTCrd2OmvRO0HUEqWgBqKvFSQGctkwUml55owO/ka1C+VCygfbix3CQSKuU93saXnR2Johjewt44LqR81lbYswnc2Hq0GVWAHrX9zb9U5cX0V6uRgQArfxb2Re+1MTaTkCmWLn68FMvEYMN44ZYHWp/3DFpKA8YAxZupOD8QPYSNPvjmUhi+Sw4f/Pq8bQ58ySqJEmXnZEF4vW6kuB64zMLLzl2bsgEGuzOtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRHtynNGbwYyZbx6wfEhzaG5TNzdrGsgcF/ZyG15fdQ=;
 b=4V5KKEeFZTOpKvusBq19ZbVx/M5ecytsasg9oKrUYduG505Mug2o0EYgqtM2D5U1hlx1Bd60wMZXKVOA85AZBY4kZqASt1Z0+uS8VY2b4qj02d4Dak8oELdmuRBT/2eIazRD/Ea5dPNZPUqQTFGT03eXEATKv48UZs007/2r46U=
Received: from MW4PR03CA0140.namprd03.prod.outlook.com (2603:10b6:303:8c::25)
 by BN9PR12MB5164.namprd12.prod.outlook.com (2603:10b6:408:11d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 22:47:18 +0000
Received: from CO1PEPF00001A5D.namprd05.prod.outlook.com
 (2603:10b6:303:8c:cafe::5c) by MW4PR03CA0140.outlook.office365.com
 (2603:10b6:303:8c::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 22:47:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A5D.mail.protection.outlook.com (10.167.241.4) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Tue, 10 Jan 2023 22:47:17 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 10 Jan
 2023 16:47:15 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <borislav.petkov@amd.com>,
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
Subject: [PATCH v6 1/7] x86/cpu, kvm: Add support for cpuid leaf 80000021/EAX (FeatureExt2Eax)
Date:   Tue, 10 Jan 2023 16:46:37 -0600
Message-ID: <20230110224643.452273-3-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230110224643.452273-1-kim.phillips@amd.com>
References: <20230110224643.452273-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A5D:EE_|BN9PR12MB5164:EE_
X-MS-Office365-Filtering-Correlation-Id: b80da600-25c3-49ee-11d9-08daf35ca039
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BTHQSvcdVk9xEgvomoJENSHWE8RL9+upgpToFomfpUWt8GgDFeI6+91ygR2MkGlqoWCAY7T8qTFcaobnfJI9qM6SFWxmxBA7ZscCvO8Yw604MpmAFkVhsyRoXXHUfRKJNYpzVrL9xeElucrvzzDN5PVLPg8/YlfR//ovPLzzCoN08QDF2tigmub4OjtidlZelPzijln4jQcgjkk46FYgmgENB+R1pZTZosPAbnPJUDArKzM2mRHWifAUImetFdexyafm11xVTebmaPJWxnPfmYNr6ywJgDFj6ehIUECnBGWlbV1MC7F6Qn6h9KZT9/3AFDTlj2qKTCCdQg3VQ9VBt6Woj/EhFC4Y2MD6idq4Bs96IcS47S28YpqVjtcVudT9w43iysN7pV7RmX5W2sxf6cDNinzMCFWP+TKkP89o5m2JB1BQ9NV40XYKxf0qJ/EkUtUBMZ8k+88JBW2qWo53lAtg2+ScE7HF28SKwdZrn7ROOesVrlfy6GCJZSgNHK1wAY1CjR2fYF+UREXjeBq9I//McscZOjvaWqgrbQUDvy2cviX45UJyMs7l5GINfP3zI6RrtDvLX1G0V1hOC3TkmAYpXZeoIb0326DboC412AL+snnXFyRjzs07no7lkAAV0+0suRzk3sWmkNRi8jOC/gcH9I/5hy4apJLhTrBaJCpnX6rRXlskqwrdeo/3zsAPwZn598C6bGFdQWn70KGabJMol6+ED47m73GpZqAnN/c=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199015)(46966006)(36840700001)(40470700004)(82310400005)(40460700003)(47076005)(8936002)(2906002)(5660300002)(426003)(41300700001)(7416002)(81166007)(7696005)(70206006)(4326008)(316002)(6916009)(70586007)(8676002)(356005)(44832011)(54906003)(26005)(82740400003)(16526019)(2616005)(1076003)(40480700001)(336012)(86362001)(186003)(36860700001)(83380400001)(36756003)(478600001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 22:47:17.5419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b80da600-25c3-49ee-11d9-08daf35ca039
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A5D.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5164
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the 80000021/EAX leaf that advertises features in later Zen
processors.  The majority of the features will be used in the kernel
and thus a separate leaf is appropriate.

Include KVM's reverse_cpuid entry because features are used by VM
guests, too.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeature.h        | 7 +++++--
 arch/x86/include/asm/cpufeatures.h       | 2 +-
 arch/x86/include/asm/disabled-features.h | 3 ++-
 arch/x86/include/asm/required-features.h | 3 ++-
 arch/x86/kernel/cpu/common.c             | 3 +++
 arch/x86/kvm/reverse_cpuid.h             | 1 +
 6 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 1a85e1fb0922..ce0c8f7d3218 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -32,6 +32,7 @@ enum cpuid_leafs
 	CPUID_8000_0007_EBX,
 	CPUID_7_EDX,
 	CPUID_8000_001F_EAX,
+	CPUID_8000_0021_EAX,
 };
 
 #define X86_CAP_FMT_NUM "%d:%d"
@@ -94,8 +95,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 17, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 18, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 19, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 20, feature_bit) ||	\
 	   REQUIRED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 21))
 
 #define DISABLED_MASK_BIT_SET(feature_bit)				\
 	 ( CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  0, feature_bit) ||	\
@@ -118,8 +120,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 17, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 18, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 19, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 20, feature_bit) ||	\
 	   DISABLED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 20))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 21))
 
 #define cpu_has(c, bit)							\
 	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 61012476d66e..d53e13048d2e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -13,7 +13,7 @@
 /*
  * Defines x86 CPU feature bits
  */
-#define NCAPINTS			20	   /* N 32-bit words worth of info */
+#define NCAPINTS			21	   /* N 32-bit words worth of info */
 #define NBUGINTS			1	   /* N 32-bit bug flags */
 
 /*
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index c44b56f7ffba..5dfa4fb76f4b 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -124,6 +124,7 @@
 #define DISABLED_MASK17	0
 #define DISABLED_MASK18	0
 #define DISABLED_MASK19	0
-#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
+#define DISABLED_MASK20	0
+#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 21)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index aff774775c67..7ba1726b71c7 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -98,6 +98,7 @@
 #define REQUIRED_MASK17	0
 #define REQUIRED_MASK18	0
 #define REQUIRED_MASK19	0
-#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 20)
+#define REQUIRED_MASK20	0
+#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 21)
 
 #endif /* _ASM_X86_REQUIRED_FEATURES_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 9cfca3d7d0e2..09e068b24313 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1093,6 +1093,9 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
 	if (c->extended_cpuid_level >= 0x8000001f)
 		c->x86_capability[CPUID_8000_001F_EAX] = cpuid_eax(0x8000001f);
 
+	if (c->extended_cpuid_level >= 0x80000021)
+		c->x86_capability[CPUID_8000_0021_EAX] = cpuid_eax(0x80000021);
+
 	init_scattered_cpuid_features(c);
 	init_speculation_control(c);
 
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 042d0aca3c92..81f4e9ce0c77 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -68,6 +68,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
 	[CPUID_7_1_EDX]       = {         7, 1, CPUID_EDX},
+	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
 };
 
 /*
-- 
2.34.1

