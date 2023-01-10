Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5483664F0C
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 23:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235192AbjAJWtL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 17:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235530AbjAJWsB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 17:48:01 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2072.outbound.protection.outlook.com [40.107.244.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F531B9E7;
        Tue, 10 Jan 2023 14:47:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h68heLPU7s4woAOQ0hQZmI1yhuZWjmHpuvnzCOmJ716yB9LjiIakqKHVt01HGFArO/NL7uCHfuapW5uYkVGkx7XmT3SD429T4rA/hNmvuo9/HUPww70tAB4PHbU2X3uvlOK32POdj3cJXqVZnNOSkaSwmBQshKQA+usD6y6VXvJyb5emYi+7A7QOpKgTBNmgqKcuikjSyOezrVQQ9VmCqB+pWXkvF6ewvNibAwD3Jjcs/8LDp5DeOHLHgjt0UHNkOfnlPWc1K7B5Nxq3T6ySCsEdfOgXOgs94pc8qHPRoRGvaoTm92KkhsxDOg2BehAWP3MM8ATy0Sx+1cog1jw3bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SMGEnlJGCl5gNjJ4GDpQZuz0qKBg70a00L0xTooNZxo=;
 b=CI18ve2k+beicjg65vrMfqRHKIysssXi5RjHHBoRcoBXCIDIcneE0zvtGqeB+n9NBp+IV619wl6Q8564Xpv1NL/UWIMbFORL69G9mR7UXl7dlY3z0AQ5eEk0I6CbuDoB10CBBLmVtYDbilEtyZRfcr+wMPXmAPmGJ9jQSxZTwAhYzo9Xb+4SW7jJJ3+aX9PhFjNIfJWrdQOPoY8dX3chHsMCzXwEvE3qjqK4lStkbGkDBxEvae+kBvkDqm8kvk2bsOV7e305oBChOMtSETmN0uM03toWsksiFvx3hFYuFSancD3Xlft6tytcfXT+EY/NjZvK5fhDncpPhJATA1lWmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMGEnlJGCl5gNjJ4GDpQZuz0qKBg70a00L0xTooNZxo=;
 b=IaSl+tdDn+rsVYSYY2CLXH5KpweKCLP5vkxazLw4H6ZUydh5XXRxOkEPt/jLXp4DnfX/AJFaHRgG/1yVfDTIRpOwkONxUX2ORTXNmONs6rga0d4wj/zvLQXSoz9OQEEKk0bhNI5oQskcbOKLP478a7mM7b/dZKGapldqfvkHsPM=
Received: from BYAPR05CA0065.namprd05.prod.outlook.com (2603:10b6:a03:74::42)
 by SA0PR12MB4400.namprd12.prod.outlook.com (2603:10b6:806:95::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 22:47:53 +0000
Received: from CO1PEPF00001A5E.namprd05.prod.outlook.com
 (2603:10b6:a03:74:cafe::b7) by BYAPR05CA0065.outlook.office365.com
 (2603:10b6:a03:74::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12 via Frontend
 Transport; Tue, 10 Jan 2023 22:47:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A5E.mail.protection.outlook.com (10.167.241.5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Tue, 10 Jan 2023 22:47:53 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 10 Jan
 2023 16:47:51 -0600
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
Subject: [PATCH v6 4/7] x86/cpu, kvm: Add the Null Selector Clears Base feature
Date:   Tue, 10 Jan 2023 16:46:40 -0600
Message-ID: <20230110224643.452273-6-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A5E:EE_|SA0PR12MB4400:EE_
X-MS-Office365-Filtering-Correlation-Id: 6e92a7ab-fbd0-4ed7-76a8-08daf35cb56d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TRhVLIzb/gqmuCfmTiOJOpqHJmfPvLmTh+Mu+VK6aONfpIFfCrZnbP32PmYoJqFJu8FWRhs2H7TyBps7atodz44SQJhMDwIkyWKhntfFed3EQfyyI6F6qHanGL7B3GB9d7BSyjZKLTMtp1nSpHyaDjDN+OZb9j4TPvI6wo8WZDuz/JBBWafOkYhRXVHlMdOTsvYXJHvbbsrlwFqD7/NrhqH9U2ZnhfC3Uhj4JAj3fN92R2gxmQlYM5HUgbnU5zlUaaNe5+w5innMWPtLrYtc4ilchgPwywkJeYnhUMzB/aIm51d+KIkdqwwZBGtFB+QFHxabfwX08iGh+md+SBPk2+8TAqHN2eRiyCFf7PV+NPRHT3qq7Zj3hMQsgUYyEokCjUNXTiHmm86GO6W9FZRyc0ydFiO14t+C7tB4xGcZ6d/SS8TLFfCZLW5fmMN8iqg7PJSBESNRc/U3aubwG8ExFdxY9q+qu2D7a1jOxdfA92bXGikcWwUYiSUpTugRNNgdwadCXxN3YI5M9Pb7JDUg811ubckmDrNhLju8iVotO9XXBtKmsMBBtoR4D4TqAGJ83LNVIJZwgMCI7GFm70LCxwVp0MwLdw/fC5CXyoiV4xPuqKrrUljkpmKcIw0yqqHVGiw1g58NzEc7Bv/D5C+J83HFlpyCix9hmipXeEolX/4kOICui3paRBnAXZ3prCHlB2o5WAxoihHoBnfzCfQsRR0+Qq5WDDv3assI+0Pkwek=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199015)(36840700001)(46966006)(40470700004)(8676002)(4326008)(81166007)(82310400005)(7416002)(41300700001)(82740400003)(70206006)(356005)(70586007)(5660300002)(8936002)(83380400001)(47076005)(7696005)(336012)(426003)(316002)(44832011)(86362001)(40480700001)(6666004)(36860700001)(478600001)(40460700003)(1076003)(6916009)(2906002)(2616005)(54906003)(36756003)(16526019)(26005)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 22:47:53.0546
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e92a7ab-fbd0-4ed7-76a8-08daf35cb56d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A5E.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4400
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Null Selector Clears Base feature was being open-coded for KVM in
__do_cpuid_func().  Add it to its newly added CPUID leaf 0x80000021 EAX
proper, and propagate it in kvm_set_cpu_caps() instead.

Also drop the bit description comments now it's more self-describing.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kvm/cpuid.c               | 10 +++-------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 79da8e492c0f..8237c4cc4010 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -429,6 +429,7 @@
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" AMD No Nested Data Breakpoints */
 #define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
+#define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* "" AMD Null Selector Clears Base */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 88c970046c10..04f2f4879d69 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -742,10 +742,12 @@ void kvm_set_cpu_caps(void)
 		F(SME_COHERENT));
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
-		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC)
+		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | F(NULL_SEL_CLR_BASE)
 	);
 	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
 		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
+	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
+		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
 
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
@@ -1230,9 +1232,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->ebx = entry->ecx = entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
 		/*
-		 * Pass down these bits:
-		 *    EAX      6      NSCB, Null selector clear base
-		 *
 		 * Other defined bits are for MSRs that KVM does not expose:
 		 *   EAX      3      SPCL, SMM page configuration lock
 		 *   EAX      13     PCMSR, Prefetch control MSR
@@ -1240,10 +1239,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 * KVM doesn't support SMM_CTL.
 		 *   EAX       9     SMM_CTL MSR is not supported
 		 */
-		entry->eax &= BIT(6);
 		entry->eax |= BIT(9);
-		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
-			entry->eax |= BIT(6);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
-- 
2.34.1

