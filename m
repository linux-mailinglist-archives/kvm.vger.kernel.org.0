Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100942D6316
	for <lists+kvm@lfdr.de>; Thu, 10 Dec 2020 18:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392496AbgLJRJZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Dec 2020 12:09:25 -0500
Received: from mail-dm6nam12on2055.outbound.protection.outlook.com ([40.107.243.55]:46528
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730503AbgLJRJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Dec 2020 12:09:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lLAJzhBDKxzJdFcSf89HT1YTauyoEQ/4TziLaGANXL8Y/KWjh+/VR+qiKKvWWJTj7yOGKyaJrREb4KmXscXrc+QG2m4mfsYTPXzPZDllSr1pAu54ghjPFY79XlL4QEcn0ETyFqmEJxY+MwjlAjr3+enW8odIVTq4ceBIL3JRn/fpMdI9qrSUMJ58ilYJEpP4qbZeB1n0ZiDJpxETofVjKRpY+IpRHiGsZdMyL+k02tlzMl8mvL98erg+t/+gNm4ZXWmiuljgvRWdHMKzf+o2A1KuOMPq4V72O98KTguO8CJjSa/iiba+kSULCCtKd4d3eQiCRHRPniMFQOlQyhYzSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIDSQVwBhceTkXrKGCJrfTL5U9e5STc9iqm9UuU3694=;
 b=jWouVlkxPGesp+cgKzaZXoFSsmGuvve45KZw+wtsGiWj8AJbv5KKg+pPqFq0YYYZDaRb4uXhy/LqBWtjOuwA/lUFtTNTDNEoXhPpVcEZ7GxotVY2uqddsJdfkLKuZ8lzSL7fOcOM4xqJHlSJReVs5KlPVjzSy3nOfQfUMBEKJ6enKIXi72bxNsJzcf+4i0EmlJgZtp/AWRjeFenkvl+VHnjQJULL/9mMuImy6/q3GCIaDNu7WXhT9XxWyY9qQYoZTXDfyh9eUCHW1MT5JAqbgb6pxmGhfCkKbGyX/QfcoNMNlzG7abz8B4Nh1BvnTfp8bPE/xP9fQTQNxnE2Lc7VQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jIDSQVwBhceTkXrKGCJrfTL5U9e5STc9iqm9UuU3694=;
 b=NdS51naCgAUj3Gvu6z0BMHLHBDsNM366Fb5sA6CCt9jgssQSk6y8VVV2acrpf9Avcmr5eUlEhPP+eZGeOceZ8sEODN06awJubZ1Rm0hjpnKelKjCWNJcTSQfSwhoHDYQHPvvtJChKBjvNf8CRFULL+0FzZkscIFjC0BQTx+C3/E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from CY4PR12MB1352.namprd12.prod.outlook.com (2603:10b6:903:3a::13)
 by CY4PR12MB1493.namprd12.prod.outlook.com (2603:10b6:910:11::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 10 Dec
 2020 17:07:43 +0000
Received: from CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d]) by CY4PR12MB1352.namprd12.prod.outlook.com
 ([fe80::a10a:295e:908d:550d%8]) with mapi id 15.20.3632.021; Thu, 10 Dec 2020
 17:07:43 +0000
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH v5 01/34] x86/cpu: Add VM page flush MSR availablility as a CPUID feature
Date:   Thu, 10 Dec 2020 11:06:45 -0600
Message-Id: <f1966379e31f9b208db5257509c4a089a87d33d0.1607620037.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607620037.git.thomas.lendacky@amd.com>
References: <cover.1607620037.git.thomas.lendacky@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:610:59::23) To CY4PR12MB1352.namprd12.prod.outlook.com
 (2603:10b6:903:3a::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from tlendack-t1.amd.com (165.204.77.1) by CH2PR03CA0013.namprd03.prod.outlook.com (2603:10b6:610:59::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 10 Dec 2020 17:07:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f213ff22-85c6-4d90-4d6d-08d89d2e1bc9
X-MS-TrafficTypeDiagnostic: CY4PR12MB1493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CY4PR12MB1493EFB922691DE290F4AE1CECCB0@CY4PR12MB1493.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gMfvoe2AdnTKdr6tfMlnus88PrYJm1e0iKvqCte7+5TJStINuX6B61I75KMoSEg2tHZYbdoh5aDDQ2ruuJOzA9Uii2RkMCYRn9luKo8RMMshri0IqLd2zpHrcGDFUMwcPNbOu0rvAuiXbk4qm/rWo4vt21lGfUSatF+xMIA0ptIo8caPW3+OqALiUNxrKx1En0ShP0bV7IV0uYFcW9kFJ7sdtffHJ8uIKv1WYPD3P2dIHg2qc7FJXz8QN50EbhB5AFHaXO9+P3tC6XzhDzLA4HlIcI4QPvz9j2bnDl8yqjvKV++0jvd20wApQoo4KBocq4CbSfh8l0rfz9UPTRA/hKx6pIK9TeC3kt8/pzzkiQyO5zldaq7ttWrXGy3xN/PU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR12MB1352.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(376002)(346002)(5660300002)(66476007)(186003)(52116002)(8676002)(36756003)(8936002)(4326008)(86362001)(2906002)(66946007)(66556008)(26005)(508600001)(34490700003)(7416002)(2616005)(16526019)(54906003)(7696005)(956004)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?F6l0gRMtm6TicIMHKEA/LCdtLmfsboFj4kcUOaG9EkogsdIAanrmJOo9CXK+?=
 =?us-ascii?Q?HYW8vmVTLz9JbxBQLxvjgqfzqeC3jkOsUht1q1YQUMAqWhkGIkT48WDpWiPY?=
 =?us-ascii?Q?g5XnqkicJzzZh/7czCv5CSuhY/BnlvgtEpjSlEnTCMKzcYPdKC4nEjJhfX/u?=
 =?us-ascii?Q?Z8/DTPNQXdPcePlTXGy6x0oZ7oA6dQxGmwj2GzXZVb268y1LeCEY8i35RYOH?=
 =?us-ascii?Q?NhVHE0rRXkOWDjv8E0DJvSjmagKs6A1++vrOSc+GH7bv2YgY9ESr4UFFNblS?=
 =?us-ascii?Q?NtQO9qgsp1ZSwOc4Oc0FNDbahuOAjqoUfl71qzYD0Hmz/ch98JtpmL7hAQIm?=
 =?us-ascii?Q?vsNFIs7vPeVkqHrBeVBbDuf3rlOQ4pkKuMp9LDG6mepsm6Pv6FXV5aHj2Iq4?=
 =?us-ascii?Q?OGWCNvWqjmrYBCffk3MlcqWbRWYrH3UIM2zvleY3AYz/VgYffv6OEIDBHCJr?=
 =?us-ascii?Q?IiaZjETKYnLIuW5nRT1HKnvAllitXtDizD5HCrIQ0pqYMHGcGzgQkYUUWjb3?=
 =?us-ascii?Q?wdk3QNZHIgpCID3eutELv4bjC/dXMsuVq/3rjVyREv1A6Ee0HXALye1u8FfC?=
 =?us-ascii?Q?l4LGkAJkg4LIupsVbMc9q1/LGNlIkj/KvikXWLZUD1AF8zBE0isEd6DTuRBE?=
 =?us-ascii?Q?OOsy9D4sun+PBI4tOWJJZ9vRl7HSTMONxL0XaArOgHFahrrV+3Ggalx81Wap?=
 =?us-ascii?Q?ZybBErwb7dJjutnwgx/XSHw8Sks6VQWNhAdcVYu2hhQyC0v77Hvuka+Enl/U?=
 =?us-ascii?Q?PV71v8Knr34qVGKu+zfxskPrT3WR4qLaOy4gdtRk8SdR/Tbertsf0bRuQP9g?=
 =?us-ascii?Q?3SXqnjmkZIgD92jo94Z41Ok24yVZYltMklvkHb6Zl0p9Vk4lzFH9ymuB8yLQ?=
 =?us-ascii?Q?v7N5ZaDithe9pTuIuCfSr+MyT6MWwSOqhbsZ9fqkutHfmPxbQ1PO09ay0oEg?=
 =?us-ascii?Q?TSJIWILxljReN1Mttsa/Ez+8vSE4lJaGQrknOznQgj/wYvD3LAOVyrO0KfyD?=
 =?us-ascii?Q?tHCE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: CY4PR12MB1352.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2020 17:07:43.2509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: f213ff22-85c6-4d90-4d6d-08d89d2e1bc9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d8I5PNeM1OeCRnSKJ1wO2yXAnqPBNTc17PK+JtouS+g8+3rwNXppOM7Yba3JIyj2t3ENEj2TM0i6KRkzNEUFvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1493
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

On systems that do not have hardware enforced cache coherency between
encrypted and unencrypted mappings of the same physical page, the
hypervisor can use the VM page flush MSR (0xc001011e) to flush the cache
contents of an SEV guest page. When a small number of pages are being
flushed, this can be used in place of issuing a WBINVD across all CPUs.

CPUID 0x8000001f_eax[2] is used to determine if the VM page flush MSR is
available. Add a CPUID feature to indicate it is supported and define the
MSR.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/include/asm/msr-index.h   | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index dad350d42ecf..54df367b3180 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -237,6 +237,7 @@
 #define X86_FEATURE_VMCALL		( 8*32+18) /* "" Hypervisor supports the VMCALL instruction */
 #define X86_FEATURE_VMW_VMMCALL		( 8*32+19) /* "" VMware prefers VMMCALL hypercall instruction */
 #define X86_FEATURE_SEV_ES		( 8*32+20) /* AMD Secure Encrypted Virtualization - Encrypted State */
+#define X86_FEATURE_VM_PAGE_FLUSH	( 8*32+21) /* "" VM Page Flush MSR is supported */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 972a34d93505..abfc9b0fbd8d 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -470,6 +470,7 @@
 #define MSR_AMD64_ICIBSEXTDCTL		0xc001103c
 #define MSR_AMD64_IBSOPDATA4		0xc001103d
 #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
+#define MSR_AMD64_VM_PAGE_FLUSH		0xc001011e
 #define MSR_AMD64_SEV_ES_GHCB		0xc0010130
 #define MSR_AMD64_SEV			0xc0010131
 #define MSR_AMD64_SEV_ENABLED_BIT	0
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 866c9a9bcdee..236924930bf0 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -44,6 +44,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_SEV,		CPUID_EAX,  1, 0x8000001f, 0 },
 	{ X86_FEATURE_SEV_ES,		CPUID_EAX,  3, 0x8000001f, 0 },
 	{ X86_FEATURE_SME_COHERENT,	CPUID_EAX, 10, 0x8000001f, 0 },
+	{ X86_FEATURE_VM_PAGE_FLUSH,	CPUID_EAX,  2, 0x8000001f, 0 },
 	{ 0, 0, 0, 0, 0 }
 };
 
-- 
2.28.0

