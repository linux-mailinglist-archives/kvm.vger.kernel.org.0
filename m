Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D233636EB1
	for <lists+kvm@lfdr.de>; Thu, 24 Nov 2022 01:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiKXAFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 19:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiKXAFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 19:05:33 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED4110CE98;
        Wed, 23 Nov 2022 16:05:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfQ8E1wixQQ1LJIWxfNtteDm5dWgEyBB1rDsamtjFET4pJcjdzAx8cOr5ygwGUM+LYESYKsDyAoQAVz+rVjvwcSX+4triTc6a4bYtv1/DQ1fkf67mMTe4YmFy71R/qhRgACXBvaSfbXS/0Gk3fY+lmRSakfkOn76ImwnWUVG6Yt1wOrWRm2bhoz1QD9oLAVNF3PQTO+/5HpdhyJl/WOqEdvrla+gGhosY4TAv6TPkuJ9mxj/zg2OKzvkMwAP10n28sb6S9hYsvoqNXyaXVVYTPO9dIEgjG+KP2K8IJby89A6KlubCGHi+Zw42EgI/rjIs2WKNedT2oZh8TsSe+e9MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W20SzAEoQHbKu0wGpENiReJaqubY09OI+iAoYVje1AE=;
 b=lKPZdqwGpOj/uHnHuxxaXFXJYph68iaUobf4ClhG/H4rfgJMtbeAnl1SE+WqTlSxExJtQiOMFO+Io1sowt1CL95poUbIPsYHDxo7+uxDS9jYWIf3Lx4QLSSRzQkZT8imVC71Ga3roCs9Bh4DvBQbiA1XVzkl6Bgve2sm/tWufT3rIghXZAuUkbLyhrnBTsBsV0Krx5L1XobgwjMCJ+UhbJjjfQAoCRAFhhNYqasrodwNxREdvyZLSjQIC9oMEJqRdjWuVxsQtMi4EDrzhcqq9MRDVO1GP+gQW33gbbAJBHF/A/hECDHOD0Q8PXaqdwzXOeHCkKzFYj5BkjmKJTANLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W20SzAEoQHbKu0wGpENiReJaqubY09OI+iAoYVje1AE=;
 b=IuJlLjqLx25RT+vMBOnkAa4d7Kkqhqk7Euu1heQoOhyveCvU7FBBJ+FpMMeDiSYpSvgA/ZKZ6PT34knRFH9v5XhT/DrlQePzFd8XNJglQichRIJMNk60Jw9TxupsoYqNp0Fs/g3xqd81fQHGUpoTh2qL7Atz8a9YA265eJW3hFQ=
Received: from MW4PR03CA0221.namprd03.prod.outlook.com (2603:10b6:303:b9::16)
 by MW3PR12MB4412.namprd12.prod.outlook.com (2603:10b6:303:58::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Thu, 24 Nov
 2022 00:05:25 +0000
Received: from CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b9:cafe::bf) by MW4PR03CA0221.outlook.office365.com
 (2603:10b6:303:b9::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15 via Frontend
 Transport; Thu, 24 Nov 2022 00:05:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT073.mail.protection.outlook.com (10.13.174.196) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5834.8 via Frontend Transport; Thu, 24 Nov 2022 00:05:20 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 23 Nov
 2022 18:05:18 -0600
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
        Tom Lendacky <thomas.lendacky@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/2] x86/cpu, kvm: Use CPU capabilities for CPUID[0x80000021].EAX
Date:   Wed, 23 Nov 2022 18:04:48 -0600
Message-ID: <20221124000449.79014-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124000449.79014-1-kim.phillips@amd.com>
References: <20221124000449.79014-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT073:EE_|MW3PR12MB4412:EE_
X-MS-Office365-Filtering-Correlation-Id: 11bb414a-f36d-49e4-2151-08dacdaf936a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mt9cdrBN8g0uB5Fawm+JpAMUfM6I/aUz3w/qB3pUvuRnn4d/vAyRGBPXXn2iiOMKhDwlFeLLAWO5yLAWNwld/XX+dl2Tt4gdxh9lfujrzeB0oKMpl2rhI1VHvDPZvHHOsh1ZqaKrnWyd1pZ2hBBNcPynWFy1ZZ4cYwEetgGENY0Wa2rKhddsjoQmRu+h/5Fjnjm9NyqSO2Afn3ltV4rHOtUryNsSGnYxq3iQOpHc4F8WOm1PW5W3RtvHE0Uh97aVxO0vsYssGy0dPp4RhX7xFaENmwqflyb/QR61++LD+n1cWTDJk6EeY0EQ+6RFrvdYQeCjEsAe/q8e6tQpO/yLKvE8HzvpxzAKW46IMYNGVu8Q0jbXFyoh+6M65AWtzgIycQ1Eir9nbq/rxJsFuHUL8WBlw+hy+VQqEpvmJObstl4PE/tUdYbaJNVaR8zreBCYimzDZekvnmHeq/oMBj7LNCaz+V9W6WZ2UjDK7+jy0KoJZUEfywGL/ZVuLb20jazkhyIuhU9l+m/wrtwFk4OO8GktCg2ul261BnWVtJyXSNdHXMhwOb36QsfTgY2MwVeycObWNsoDB/80KxkZ+e+/Xlgnm0TRHMwfr8P7UzaKERW2uiapXmiCkkvOnsLxhtCyVPJ10Q1e2zeTdZ3nlG3bbCtTO46bfkFfgDUZOTXcrxABNvXS8YFM35kGbEmuozfZuPv1prx4OAOnqdFIMEAjsr3rW2WDnRMDZLDosm3ncZw6e1VehE6fiTluU7G9tMx4LVSfqIl6Mg//BWrFrhbm4enBgfrYgJ24f9bWZoSRqnc5+CZzTGGH8He3652zDrWe
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(46966006)(36840700001)(40470700004)(36756003)(86362001)(5660300002)(36860700001)(40480700001)(44832011)(2906002)(356005)(2616005)(81166007)(47076005)(426003)(186003)(40460700003)(26005)(83380400001)(82740400003)(336012)(16526019)(7416002)(1076003)(7696005)(82310400005)(70206006)(70586007)(54906003)(6666004)(966005)(41300700001)(478600001)(8676002)(316002)(6916009)(8936002)(4326008)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2022 00:05:20.0648
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11bb414a-f36d-49e4-2151-08dacdaf936a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4412
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The AMD Zen4 Automatic IBRS feature bit resides in the 0x80000021 leaf,
for which there is already support for exposing Zen3 bits to the guest.

Add AMD AutoIBRS feature bit support, including for the other bits,
using scattered/synthetic bits.

Add the corresponding word to KVM's feature machinery so that AutoIBRS
gets advertized into the guest too.

Co-developed-by: Babu Moger <Babu.Moger@amd.com>
Co-developed-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
v1: https://lore.kernel.org/lkml/20221104213651.141057-2-kim.phillips@amd.com/, and
    https://lore.kernel.org/lkml/20221104213651.141057-4-kim.phillips@amd.com/
v2: Addressed v1 comments:
    - Use synthetic/scattered bits instead of introducing new leaf [Boris]
    - Combine the rest of the leaf's bits being used [Paolo]
      Note: Bits not used by the host can be moved to kvm/cpuid.c if
      maintainers do not want them in cpufeatures.h.
    - Hoist bitsetting code to kvm_set_cpu_caps(), and use
      cpuid_entry_override() in __do_cpuid_func() [Paolo]

 arch/x86/include/asm/cpufeatures.h |  5 +++--
 arch/x86/kernel/cpu/scattered.c    |  4 ++++
 arch/x86/kvm/cpuid.c               | 35 +++++++++++++++++-------------
 arch/x86/kvm/reverse_cpuid.h       | 24 +++++++++++++++-----
 4 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 759b71cb4f9a..961eb49532b7 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -306,9 +306,10 @@
 #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
 #define X86_FEATURE_SGX_EDECCSSA	(11*32+18) /* "" SGX EDECCSSA user leaf function */
 #define X86_FEATURE_CALL_DEPTH		(11*32+19) /* "" Call depth tracking for RSB stuffing */
-
-
 #define X86_FEATURE_MSR_TSX_CTRL	(11*32+20) /* "" MSR IA32_TSX_CTRL (Intel) implemented */
+#define X86_FEATURE_NO_NESTED_DATA_BP	(11*32+21) /* "" AMD No Nested Data Breakpoints */
+#define X86_FEATURE_NULL_SEL_CLR_BASE	(11*32+22) /* "" AMD Null Selector Clears Base */
+#define X86_FEATURE_AUTOIBRS		(11*32+23) /* AMD Automatic IBRS */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index f53944fb8f7f..7ae7203cd410 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -45,6 +45,10 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
+	{ X86_FEATURE_NO_NESTED_DATA_BP,CPUID_EAX,  0, 0x80000021, 0 },
+	{ X86_FEATURE_LFENCE_RDTSC,	CPUID_EAX,  2, 0x80000021, 0 },
+	{ X86_FEATURE_NULL_SEL_CLR_BASE,CPUID_EAX,  6, 0x80000021, 0 },
+	{ X86_FEATURE_AUTOIBRS,		CPUID_EAX,  8, 0x80000021, 0 },
 	{ X86_FEATURE_PERFMON_V2,	CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,	CPUID_EAX,  1, 0x80000022, 0 },
 	{ 0, 0, 0, 0, 0 }
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c92c49a0b35b..61cd33a848cc 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -730,6 +730,25 @@ void kvm_set_cpu_caps(void)
 		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
 		F(SME_COHERENT));
 
+	/*
+	 * Pass down these bits:
+	 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
+	 *    EAX      2      LAS, LFENCE always serializing
+	 *    EAX      6      NSCB, Null selector clear base
+	 *    EAX      8      Automatic IBRS
+	 *
+	 * Other defined bits are for MSRs that KVM does not expose:
+	 *   EAX      3      SPCL, SMM page configuration lock
+	 *   EAX      13     PCMSR, Prefetch control MSR
+	 */
+	kvm_cpu_cap_init_scattered(CPUID_8000_0021_EAX,
+				   SF(NO_NESTED_DATA_BP) | SF(LFENCE_RDTSC) |
+				   SF(NULL_SEL_CLR_BASE) | SF(AUTOIBRS));
+	if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
+		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
+	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
+		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
+
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
@@ -1211,21 +1230,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
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
index 4e5b8444f161..0bf02c02bb0a 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -13,6 +13,7 @@
  */
 enum kvm_only_cpuid_leafs {
 	CPUID_12_EAX	 = NCAPINTS,
+	CPUID_8000_0021_EAX,
 	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
@@ -25,6 +26,12 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_SGX2		KVM_X86_FEATURE(CPUID_12_EAX, 1)
 #define KVM_X86_FEATURE_SGX_EDECCSSA	KVM_X86_FEATURE(CPUID_12_EAX, 11)
 
+/* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX) */
+#define KVM_X86_FEATURE_NO_NESTED_DATA_BP	KVM_X86_FEATURE(CPUID_8000_0021_EAX, 0)
+#define KVM_X86_FEATURE_LFENCE_RDTSC		KVM_X86_FEATURE(CPUID_8000_0021_EAX, 2)
+#define KVM_X86_FEATURE_NULL_SEL_CLR_BASE	KVM_X86_FEATURE(CPUID_8000_0021_EAX, 6)
+#define KVM_X86_FEATURE_AUTOIBRS		KVM_X86_FEATURE(CPUID_8000_0021_EAX, 8)
+
 struct cpuid_reg {
 	u32 function;
 	u32 index;
@@ -49,6 +56,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
 	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 	[CPUID_8000_001F_EAX] = {0x8000001f, 0, CPUID_EAX},
+	[CPUID_8000_0021_EAX] = {0x80000021, 0, CPUID_EAX},
 };
 
 /*
@@ -75,12 +83,16 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
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
+	case X86_FEATURE_AUTOIBRS:		return KVM_X86_FEATURE_AUTOIBRS;
+	default: break;
+	}
 
 	return x86_feature;
 }
-- 
2.34.1

