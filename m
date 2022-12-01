Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E336D63E74E
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 02:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiLABvV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 20:51:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229923AbiLABvL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 20:51:11 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2075.outbound.protection.outlook.com [40.107.96.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D5AC93A62;
        Wed, 30 Nov 2022 17:51:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2biLp6udQsbYfSlD/lh1Wh6yvBrQ8wnZIMqfoN3ke2E4YU7TJOMmPC9TLrJui5Wnak+Eh7CDz/0n8w3vTRp55hi35VlISzEb+IKdnOrAJ2ItnurWjxvXXlJ+1m0mokTUXQOyAnm5fOh49CKTh4WgMqwhTrlajQODryn1Ie5/Ek8ryY27qKTB485pN/VFgNPPdkQZz1dna/V1/1fpEjiP4R/umcM6BfLuuVKROVhvUK1EFOhTwKr4hIKaZ7M5CeLUUGoIdLqCKfzFQvjRUY4wjMIMg9010Pkbx8r0//2Gil1PNB5h/c4BumJpGOqY1K3nmtoF2iibY3iTE+Mz3ypFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aJNYRfHM869rcVG5ek02QXWp90OIOOF7VmnPInzVI0g=;
 b=fueTe1czpB9Lw1aHGTpI6NCW/WXLrWZ0EsPN7UwQveNeCJrCfH9BXC8D5/2TcJd2XW5JEVydpfqwBwHuYVP8fe2MqdUv+F7SoutXVT2vQmc/DBT2xh0eBjAQjHfmaxCpcmEoZJ7/tInWhqCWOR14YtcNa8MSdoUFtVhbWLmag+pxZyUqXJHMl+NX6HJJ1EqcqNRwp8QztZqW3morD9YXyfN9lwPUgrKkKL7HtLvKNA4la3x7hY400VYw2VqFqJ/ynGX6FsxW7A7OmB2iSdbqHbOwth0H7s6ATLG12MIvZ0u6KvCtgR/dAe8FmDdEO3W2XEuAK5EcKNM4MAOXvGt6Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aJNYRfHM869rcVG5ek02QXWp90OIOOF7VmnPInzVI0g=;
 b=eldlJrZp/OkVgIVLbenXi3PU1bft1vbBqEid42qMcTHwXZlFwMj1nVgntF8FHU/bud8IGrci6yZWGxlcDbSdHfuKkGn0/VX0/Yo5MN5INiqt0B2igeDerhqedYxvtdvcuOhiSz7llmkc2HSy7dqTlysNdbLmbJUVpST3pT1zFCw=
Received: from BN9PR03CA0852.namprd03.prod.outlook.com (2603:10b6:408:13d::17)
 by SA1PR12MB6919.namprd12.prod.outlook.com (2603:10b6:806:24e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 01:51:07 +0000
Received: from BN8NAM11FT116.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13d:cafe::7b) by BN9PR03CA0852.outlook.office365.com
 (2603:10b6:408:13d::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Thu, 1 Dec 2022 01:51:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT116.mail.protection.outlook.com (10.13.176.67) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 01:51:06 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 30 Nov
 2022 19:51:04 -0600
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
Subject: [PATCH v4 4/7] x86/cpu, kvm: Move CPUID 0x80000021 EAX feature bits propagation to kvm_set_cpu_caps()
Date:   Wed, 30 Nov 2022 19:50:00 -0600
Message-ID: <20221201015003.295769-5-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221201015003.295769-1-kim.phillips@amd.com>
References: <20221201015003.295769-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT116:EE_|SA1PR12MB6919:EE_
X-MS-Office365-Filtering-Correlation-Id: 34d1213c-f6d1-4e2d-4889-08dad33e832c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EKNunCbiyLIZGJ0UKQxHfP+jG/MdA5LMQ9qTIDavxIfsAzjL+6n9/zWVWbIAwU0LNJihJ0AEi9XOUp6ERSxlX3qQuPaDZavDG7Whyjs1AJY6IHvxfnyEjJk01GvPFYoN4OBwXiEkqh7IQG3DrgqpnqgP/SUI6lNEMeWV2iukqUT19rP4neBju+7d/9+O2G30zJqVZiFxJHzUNB7GyPIW+HRpF/5YEXTBUycLyxIdaCt3tz8DsdP6hsORXC211h8ZTNfaFZrE3SJUOJuFjegm5aASwkYT5PZrZ8WgWTwRZmpMNRjC/4OEB5NzXzTUPvo5khCEpla9xyB7daJp+NyptBbAQeRNeIx3NjBb3XcIAjkQQXPIWrJC/8em1axDf2H8Lesr38LQXf8otteV7EZXtBydXVvKFif9ZUM3jjH2yRDPbBP1C9u1EmG4Vu1X6dxXETWOd+y4t7IuFG07QiUm/cP4qBRz0lILyXlgDoWHIXbJMnILtK4l0F67Wlcb73QdvT+WH4HcY8B3pIyHtD+zgoIlcjJ7a7NTTHidg1IVEbSwieyMAnJxwBOEsuCyUchvKhr+a+1/u2G8SWpAn1J9ChRVKitmVCHYQUWsnFTHqGQGvISgrOQDnXYGEAWtgtUw3p4aKk96iWxhaqDfV/Hn9MhFtq9QX8PKL0wmKi3i9vm/glqX9DGmpVfpsI2EKrmY4FKNLN9BdzBiBKKDK93X5lrFonUt3A6hVhrbBVdh4Fc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(376002)(346002)(136003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(41300700001)(86362001)(36756003)(40460700003)(6916009)(40480700001)(5660300002)(1076003)(2616005)(83380400001)(8676002)(316002)(70206006)(16526019)(26005)(7696005)(4326008)(70586007)(47076005)(6666004)(426003)(186003)(478600001)(82740400003)(336012)(356005)(54906003)(82310400005)(36860700001)(8936002)(7416002)(44832011)(2906002)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 01:51:06.8028
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 34d1213c-f6d1-4e2d-4889-08dad33e832c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT116.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6919
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move CPUID 0x80000021 EAX feature bits guest propagation to
kvm_set_cpu_caps() instead of open-coding them in __do_cpuid_func().
Drop the bit description comments now the code is more self-describing.

Whilst there, switch to using the more efficient cpu_feature_enabled()
instead of static_cpu_has().

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kvm/cpuid.c         | 25 ++++++++++---------------
 arch/x86/kvm/reverse_cpuid.h | 22 ++++++++++++++++------
 2 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c92c49a0b35b..dd0fe79521eb 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -730,6 +730,15 @@ void kvm_set_cpu_caps(void)
 		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
 		F(SME_COHERENT));
 
+	kvm_cpu_cap_init_scattered(CPUID_8000_0021_EAX,
+		SF(NO_NESTED_DATA_BP) | SF(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
+		SF(NULL_SEL_CLR_BASE) | 0 /* PrefetchCtlMsr */
+	);
+	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
+		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
+	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
+		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
+
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
@@ -1211,21 +1220,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
-		 */
-		entry->eax &= BIT(0) | BIT(2) | BIT(6);
-		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
-			entry->eax |= BIT(2);
-		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
-			entry->eax |= BIT(6);
+		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 4e5b8444f161..184614e27d5b 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -13,6 +13,7 @@
  */
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
+	CPUID_8000_0021_EAX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -25,6 +26,11 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
 #define KVM_X86_FEATURE_SGX_EDECCSSA	KVM_X86_FEATURE(CPUID_12_EAX, 11)
 
+/* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX) */
+#define KVM_X86_FEATURE_NO_NESTED_DATA_BP	KVM_X86_FEATURE(CPUID_8000_0021_EAX, 0)
+#define KVM_X86_FEATURE_LFENCE_RDTSC		KVM_X86_FEATURE(CPUID_8000_0021_EAX, 2)
+#define KVM_X86_FEATURE_NULL_SEL_CLR_BASE	KVM_X86_FEATURE(CPUID_8000_0021_EAX, 6)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -49,6 +55,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
+	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
 };
 
 /*
@@ -75,12 +82,15 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
  */
 static __always_inline u32 __feature_translate(int x86_feature)
 {
-	if (x86_feature == X86_FEATURE_SGX1)
-		return KVM_X86_FEATURE_SGX1;
-	else if (x86_feature == X86_FEATURE_SGX2)
-		return KVM_X86_FEATURE_SGX2;
-	else if (x86_feature == X86_FEATURE_SGX_EDECCSSA)
-		return KVM_X86_FEATURE_SGX_EDECCSSA;
+	switch (x86_feature) {
+	case X86_FEATURE_SGX1:			return KVM_X86_FEATURE_SGX1;
+	case X86_FEATURE_SGX2:			return KVM_X86_FEATURE_SGX2;
+	case X86_FEATURE_SGX_EDECCSSA:		return KVM_X86_FEATURE_SGX_EDECCSSA;
+	case X86_FEATURE_NO_NESTED_DATA_BP:	return KVM_X86_FEATURE_NO_NESTED_DATA_BP;
+	case X86_FEATURE_LFENCE_RDTSC:		return KVM_X86_FEATURE_LFENCE_RDTSC;
+	case X86_FEATURE_NULL_SEL_CLR_BASE:	return KVM_X86_FEATURE_NULL_SEL_CLR_BASE;
+	default: break;
+	}
 
 	return x86_feature;
 }
-- 
2.34.1

