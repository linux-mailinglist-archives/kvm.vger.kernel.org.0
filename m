Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A96664F06
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 23:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbjAJWs4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 17:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235603AbjAJWsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 17:48:09 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2055.outbound.protection.outlook.com [40.107.243.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 581BD479F2;
        Tue, 10 Jan 2023 14:48:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mD6CXCpA5wBtHs75W4fsV+eRJL3/HOx3h69ux4DwfHHP3qfo4CN3VpNoWQKhqxeQyM8MdG0zTQ+3itPef9eiupeFEQBHidSQkg/6gZR/AWaPJ3MONXVN3IYOfK8ZEK12oY8pBspeOWL7loKgoijwgf+vTYMxk/lv9hbfYOAQkDgPxMYMHILhNSmdhhwgshrfSxBYj90byeY58k+FNiDUwj979VINNvS6dHA5boUslQbICFaMeOg8Kc6LX9A9QJb2C7/02S08M1+OjOVvR87bnoXXVEzu/dp7aQsPfIlaXs4cOm9OckXyZHmrRyWsFrQRLmkx7ER9VT8gsGL6KQrCEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/hpghYYNgwNrzF5WL8117gEVhsWvmwFA8OlSOpe9Nxs=;
 b=eZqkCvvP6pDShX3Y+RQIZIfhAUXpuRwYsyxI6MmZwjbtVDGcYx0ACvmg8EfwEsVab5p2SoXwS+AgQQH55ihsh7C1d3mkPfdQk+TtjttVVq69NWrGz7o15X0pJhrPBJP02iACQC7mtLczP6PFtA3OsHgcL0C6rksxPg+6Jg/iBkpuMLULDEEZRDXUBK57t1TogNJ7gVA0OVTz7wkpgaMfHVpllddWmrpcClOpLYtXNi/TQnYvzwdTTQcZyGV58Cw6NLf3NFpXRGxMlGz0hj4c2Am43RHTpm8eFdSVBJQa9AJQ0m3mHC9C81OWKA9VuVMQDu8cjjQpcWumtsFsWhmiKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/hpghYYNgwNrzF5WL8117gEVhsWvmwFA8OlSOpe9Nxs=;
 b=OhK4K0AoB74YQRMy+3nExYZMON4Q/w2jtB98rEVAULxHiwQQaiy21Cg+Jo2LzR8aJltTjlH83WVoiQQtiym8pvauWhFNOt+ypFWCdfBS52G0HGyN5ZA4jLn29r7gTFHeVuiI21VwkVABflAn78dla7K0Nah0IJZlhH+qLuMKXDw=
Received: from BYAPR08CA0069.namprd08.prod.outlook.com (2603:10b6:a03:117::46)
 by MW4PR12MB6754.namprd12.prod.outlook.com (2603:10b6:303:1eb::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 22:48:05 +0000
Received: from CO1PEPF00001A60.namprd05.prod.outlook.com
 (2603:10b6:a03:117:cafe::5f) by BYAPR08CA0069.outlook.office365.com
 (2603:10b6:a03:117::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 22:48:05 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A60.mail.protection.outlook.com (10.167.241.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Tue, 10 Jan 2023 22:48:04 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 10 Jan
 2023 16:48:03 -0600
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
Subject: [PATCH v6 5/7] x86/cpu, kvm: Add the SMM_CTL MSR not present feature
Date:   Tue, 10 Jan 2023 16:46:41 -0600
Message-ID: <20230110224643.452273-7-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A60:EE_|MW4PR12MB6754:EE_
X-MS-Office365-Filtering-Correlation-Id: 4fcfb345-cac2-437c-83a2-08daf35cbc68
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VsK/fqohq1qXvk5zZD5NGWoTezJODdw5Bdz3CVrB97SFB8+JAFkzzdlpeRtuHw07VBz/wYmPwESpvCm8k/MxtC6BUSijU2e78D3SKYUZCxS+PAdPYrhSVySdTWtKYpjXuFuqLxdwkewpMpDc85v69kd3pVtuJJW3XF9yURcFVOLUb9e9sDUGR+MkEkGmYVUq4YsrpyLHJQ+P/MjDQgVJpOKh9iIaaYElLpqUVB0aRPEakNZmd1AMGROGVeWEF7w/NNijW6tEzJyte6y4+MlYoqre8X39u1h8PcCXShOrnnLOOphLX0VApszeAHsgXGYZeJy+SOOIz77v7iqxGTHAO/8sPOXT7syt1D3218EQnsRmotZOXYBsYKL53apuTUXHd9nTV0qSjVd53mss5r05CVPQak4UWiz9dDRFkjHhDkAHXeOOVRcgLRfAFhXWi3I4aU7iVxbXhG/Ds/lG5pT0AqJrhRxL+Cx2Eu3bn27hs9VKLn/QQIlIZM7/l2VmM6KcyzQToAeU8w/dKwGRP/47wZxp9quHsWpmK+T48eLbLfMkH2hraAIXreD7fF5Hes+RIkJVSZxDw1g/tpz+mtuMjgcIhXz05Yoroep5mX7J5Nu8CFPnKrpuuJvEjcafQzkqHZmb/JlU2sEGeEQh0ZuMRWjqWFXPCVtG8U1zp1Y7rpG/gVo7egbekKjdFjgC8eWrN85LnBkNXtc9FWd/mdOTBudK4f8qiopz3FUusgJ6DsU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(39860400002)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(36756003)(44832011)(86362001)(8936002)(7416002)(5660300002)(40460700003)(426003)(47076005)(336012)(83380400001)(82310400005)(7696005)(63370400001)(63350400001)(478600001)(1076003)(186003)(2616005)(26005)(16526019)(6666004)(82740400003)(356005)(6916009)(4326008)(41300700001)(70586007)(40480700001)(8676002)(70206006)(36860700001)(81166007)(316002)(54906003)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 22:48:04.8446
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fcfb345-cac2-437c-83a2-08daf35cbc68
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A60.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6754
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SMM_CTL MSR not present feature was being open-coded for KVM in
__do_cpuid_func().  Add it to its newly added CPUID leaf 0x80000021 EAX
proper, and propagate it in kvm_set_cpu_caps() instead.

Also drop the bit description comments now the code is more
self-describing, and retain the SmmPgCfgLock and PrefetchCtlMsr feature
bit comments at the kvm_cpu_cap_mask() callsite.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kvm/cpuid.c               | 13 +++----------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 8237c4cc4010..da42d799d405 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -430,6 +430,7 @@
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" AMD No Nested Data Breakpoints */
 #define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
 #define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* "" AMD Null Selector Clears Base */
+#define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* "" AMD SMM_CTL MSR is not present */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 04f2f4879d69..56f00d9cc5c5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -742,12 +742,14 @@ void kvm_set_cpu_caps(void)
 		F(SME_COHERENT));
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
-		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | F(NULL_SEL_CLR_BASE)
+		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
+		F(NULL_SEL_CLR_BASE) | 0 /* PrefetchCtlMsr */
 	);
 	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
 		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
 	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
+	kvm_cpu_cap_set(X86_FEATURE_NO_SMM_CTL_MSR);
 
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
@@ -1231,15 +1233,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	case 0x80000021:
 		entry->ebx = entry->ecx = entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
-		/*
-		 * Other defined bits are for MSRs that KVM does not expose:
-		 *   EAX      3      SPCL, SMM page configuration lock
-		 *   EAX      13     PCMSR, Prefetch control MSR
-		 *
-		 * KVM doesn't support SMM_CTL.
-		 *   EAX       9     SMM_CTL MSR is not supported
-		 */
-		entry->eax |= BIT(9);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
-- 
2.34.1

