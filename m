Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 090FF679EB7
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:34:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234307AbjAXQeR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbjAXQeQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:34:16 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0754B187;
        Tue, 24 Jan 2023 08:34:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ocaGccz83cqTkwc8+ajkb7l9IObYX2Pek7T2kcFuxdRKqDZL9fPTvwvaqPsPh3T0Em0XzxLM3NKQC9mRe6lrIyQQJpo2Jn5A6CPphUpDdLEJm96zGSVtQZGYqzdlY9p9dpJW6YVT+l4SEa2PK44p7CG8Q6bkiynXy+tNZL9+6gLRH/cqB87dp4sIWtgkFlLrbAd/P4A6/0qW43W4clmGK21QPlRR2UdQG0jxrs1gNBvaC7dxtoK6o48K82xXdJF/Ub6ZN+bq9FE/RR51z8oTvMax2znRDKRNzfHEdbkdBy8H8JPaL8anr24rngAM5e9jIzqtbfl52t+A76MVg64mHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OgshsaAr/h/n5ex2a9CdYy/pLOZIxuOjhlH5l/nWcr8=;
 b=b3c+SSfCvJxsoQaDODSo7nA9hNe4Eql2U4l2pzFQAt+HbDJLWjkJjdNiZLa1a/LiMUHwuFXfDv+gYXWk+W/fH+pVGDllxb+lL1y/h1USHvRjbefgD5c/FNsxBNSkRBxoqm7mo1ooFJyRMhXF6TeGk7JLIeKXrePdmKVN8nm7TtvEi0Fvk1grV+XkzmlaJRVe3yeb1tt6S+g6n5DQ/6PR4zsCKsowVwUSHGLygCCDCwFmQcOJthRhI0th1iiMDNcaxhFl2Z3ykioMkbRHZ4j2CCwb40jA/77mAekuuDS2EZqVOANac3C2nfhY4IYQw0+QTepoZG41I0mWj95mfmegzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OgshsaAr/h/n5ex2a9CdYy/pLOZIxuOjhlH5l/nWcr8=;
 b=0zXEc6eJDGC7hyrF/l2je53zWrESby1ZlbsnW+kwYIzy3k49Ag78DWKlgeqXoemcw8rKT08uhdSJ2exaxZFWgbP05wb7hlFpUMC6KQiDVRrz05PunGnE0uJFgqAwymdFEkEWpdUbWN+rD7cquYcQqufVDhHDGAt8wjTe6dEoTRE=
Received: from BN9PR03CA0934.namprd03.prod.outlook.com (2603:10b6:408:108::9)
 by SA1PR12MB6750.namprd12.prod.outlook.com (2603:10b6:806:257::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 16:34:02 +0000
Received: from BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::8) by BN9PR03CA0934.outlook.office365.com
 (2603:10b6:408:108::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 16:34:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT028.mail.protection.outlook.com (10.13.176.225) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.17 via Frontend Transport; Tue, 24 Jan 2023 16:34:02 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 10:34:01 -0600
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
Subject: [PATCH v9 2/8] KVM: x86: Move open-coded cpuid leaf 0x80000021 EAX bit propagation code
Date:   Tue, 24 Jan 2023 10:33:13 -0600
Message-ID: <20230124163319.2277355-3-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT028:EE_|SA1PR12MB6750:EE_
X-MS-Office365-Filtering-Correlation-Id: de9b16a4-cb10-4d63-8dd1-08dafe28cd5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /eexl8ne/eR4DzLH4oDdA3NgnLI+qycP80tltdLObGqQ+u6xjfgkaCvIa9bXL4Y8iy/LTJ4vTL4y3OxuGOSd1r6Daxl6Z6tsa4ppfniymU23Xmlkk5CUTBBkcorBD/wMuD4OCbQiShlRBzcVHU+3vfoBDbF5InTyrLyRnsV4Xm5YIZpK3y5xdA8S6a/iAdcWgkLDaz+pb7XuVvr8zyL2EnlEhKkVJ5WspnFWH97QZbycR5oYeFc2AvPgSJdDi04ueoXFb7/D4TOaAFOLTJWi9ndoHKEsMvX4CSwx+jAoIzrJGMlJYDMQ4IvV9AS45oaPu2pWGUcrjLIKkEy7VUHtb/Ne43cAnz4Y0HoCRV1M3rjA8qMGrFfdznekQ5BUiByezlOSmYNfWQ2yFt0S1yFR3sDshkMd4M9XS99mFqljcTouJ6pY290She4CDKn73MwIAt4+1BlX181Y+s5kQDkLHS/IsuXIRN4G/GKvn/A3dFcdQs62KIOFqbK7forMHPOxEO2DxDh9KWekC6yu11uYfLvf1x02NXAOo6zy3/TcePvXIMSq31GqNab57Egf7Y0Ysbk36tHRUqsuD+8+zeWQsUYVjSEAuI03Mn68hRTDQQQluxQ0F11bx0bd7VKCq8oNp/PniVm2NnMYdShyYYI+dOKrzu/4qTjfTToVISASbYjmyi6Pt6Ow9i0SlfF2I+EhlnumkQJU3qy/Xr9hM7WI9maqPTjAF32vu34Umk9jPY4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199015)(36840700001)(40470700004)(46966006)(336012)(82310400005)(426003)(316002)(47076005)(54906003)(40460700003)(2906002)(36756003)(86362001)(36860700001)(6916009)(4326008)(81166007)(40480700001)(356005)(44832011)(82740400003)(70206006)(41300700001)(7696005)(6666004)(1076003)(83380400001)(70586007)(478600001)(5660300002)(8936002)(2616005)(7416002)(26005)(16526019)(8676002)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 16:34:02.3485
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de9b16a4-cb10-4d63-8dd1-08dafe28cd5d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6750
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move code from __do_cpuid_func() to kvm_set_cpu_caps() in preparation
for adding the features in their native leaf.

Also drop the bit description comments as it will be more self-
describing once the individual features are added.

Whilst there, switch to using the more efficient cpu_feature_enabled()
instead of static_cpu_has().

Note, LFENCE_RDTSC and "NULL selector clears base" are currently
synthetic, Linux-defined feature flags as Linux tracking of the features
predates AMD's definition.  Keep the manual propagation of the flags from
their synthetic counterparts until the kernel fully converts to AMD's
definition, otherwise KVM would stop synthesizing the flags as intended.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kvm/cpuid.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 596061c1610e..a1047763fdd3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -741,6 +741,17 @@ void kvm_set_cpu_caps(void)
 		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
 		F(SME_COHERENT));
 
+	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
+		BIT(0) /* NO_NESTED_DATA_BP */ |
+		BIT(2) /* LFENCE Always serializing */ | 0 /* SmmPgCfgLock */ |
+		BIT(6) /* NULL_SEL_CLR_BASE */ | 0 /* PrefetchCtlMsr */
+	);
+	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
+		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(2) /* LFENCE Always serializing */;
+	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
+		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(6) /* NULL_SEL_CLR_BASE */;
+	kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(9) /* NO_SMM_CTL_MSR */;
+
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
@@ -1222,25 +1233,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	case 0x80000021:
 		entry->ebx = entry->ecx = entry->edx = 0;
-		/*
-		 * Pass down these bits:
-		 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
-		 *    EAX      2      LAS, LFENCE always serializing
-		 *    EAX      6      NSCB, Null selector clear base
-		 *
-		 * Other defined bits are for MSRs that KVM does not expose:
-		 *   EAX      3      SPCL, SMM page configuration lock
-		 *   EAX      13     PCMSR, Prefetch control MSR
-		 *
-		 * KVM doesn't support SMM_CTL.
-		 *   EAX       9     SMM_CTL MSR is not supported
-		 */
-		entry->eax &= BIT(0) | BIT(2) | BIT(6);
-		entry->eax |= BIT(9);
-		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
-			entry->eax |= BIT(2);
-		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
-			entry->eax |= BIT(6);
+		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
-- 
2.34.1

