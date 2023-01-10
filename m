Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90563664F00
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 23:48:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235102AbjAJWsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Jan 2023 17:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234960AbjAJWrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Jan 2023 17:47:49 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 033064E419;
        Tue, 10 Jan 2023 14:47:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=czGCbn5na3czFgQhslyC1cq7GaPCf3lAdN/LV3Ydj2yZHco6/SlfyC8vDSlrrgHVeu8jLrqh3nXxkwCi7PJ/vfKcdMR8VtOxqY1lgDDbLUPmjkDZSAYf0UMoy5ra3Qa+ubo+A/Iv7zajPu4kPTtElRkfBKoK5Cq0+dFld1QsFOcvhO1lKuyUAhv3Uzkt0JyPbSUm0aLnXEYgvlFWb45MIdPDUCbMRUHqxEmT9Bf5nc06AghlnWODftgtTsQhUPgTj60Q8qT6WhbE+q2YBmDK+bvR8yuaLxHGmpMnVkgwQVi5ljIHUhgAy9QM+vYUpg7Fm8h0Dah6DQ1ZsIauWncCoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wAy/sduVFGYDYjjKrS2T0+igS+FuKW8eQPTNyS0EHzQ=;
 b=oFaic80YBmLW65JZxKk/1c1FjD2vQneoYTeF3AQPL9Rt1Py7qqOvcEXeb7ekATyc5dB19qA1WvSDuHGncexo41AE5A6Cm1xp5NUhmeXJwyMKKF5GOiKTXs9Z7NsyMor5+kqzOP8fovht896I4iY8qDybdYOoMdj47x1B0rBhRbl8XbvfAmIH1rKiMvCHDsj9FNJRfHuRAYE7Zg/ts7jpcpI21Fr6DsmpD0ZQ3SgKTHDEvEHaoN5Q5OIJDP+HA+jiy3yivmD3LN4byO75nQVYwJ4ZDIv7YC0JXO+zgaOkbhVakUCgpF+9Pu6WM2JOCGOWN39K0xA6qEdKi0UMMnLULQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com;
 dmarc=temperror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wAy/sduVFGYDYjjKrS2T0+igS+FuKW8eQPTNyS0EHzQ=;
 b=0FOsulJ40cQWvIP7V+GO1+GWHgSTsjR4fsTzbhCldKJMsUfHS+TfiDsDhm9I+LLcZcVl00/040O09Ux5zTpSoR3msbU73p9TJ5ZJIlhmp85M/o6r4L26QABQYQq5w+ENVBLMmEvC8rQeqKQ0xtrWeX9wPnSIvFBLm4Jhbs3p/Ho=
Received: from MW4PR03CA0103.namprd03.prod.outlook.com (2603:10b6:303:b7::18)
 by MN0PR12MB6056.namprd12.prod.outlook.com (2603:10b6:208:3cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 22:47:43 +0000
Received: from CO1PEPF00001A61.namprd05.prod.outlook.com
 (2603:10b6:303:b7:cafe::b8) by MW4PR03CA0103.outlook.office365.com
 (2603:10b6:303:b7::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18 via Frontend
 Transport; Tue, 10 Jan 2023 22:47:43 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 165.204.84.17) smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=amd.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of amd.com: DNS Timeout)
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1PEPF00001A61.mail.protection.outlook.com (10.167.241.8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Tue, 10 Jan 2023 22:47:41 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 10 Jan
 2023 16:47:39 -0600
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
Subject: [PATCH v6 3/7] x86/cpu, kvm: Move the LFENCE_RDTSC / LFENCE always serializing feature
Date:   Tue, 10 Jan 2023 16:46:39 -0600
Message-ID: <20230110224643.452273-5-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1PEPF00001A61:EE_|MN0PR12MB6056:EE_
X-MS-Office365-Filtering-Correlation-Id: 4d344ebc-8874-40a8-a839-08daf35cae60
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eIdNa3GBBN0sWmBeW1jmq+XRL2n4jVJWNl0ufBYFdaW/LiwSaZIsrWn6bycXoGFXelmTbvNiq/UVLvdLiSadLtTQJy+0+v28sv89Dxa8hfTVTGmTVF4sIXyVGOssH9Fhyzhgvdigtsg98PTHzqmrkdpLSTmexDvsLFImTm/xWwOIIc+F2ZYhxE15ZsueS1dkVIuzDyU5rbqfiWjWZNiIoVYXXVvHQQsn7qfJfJLqHWBgtSA5RYhdcagCs1QSb/+s2NYW3s+MfYyrqiVogfdzGCkeaa1GTlXHSIBeJHXIJ7iSnYtOO0sYKehkRnvujMZP+g1216ktdoG2gxVFgYBwuLzw1jJsFND50hxf8n/Q5Cx8dj0HuI1pAeWm+QXLk9l1qv/MDN3V07Q4wYbcoNLnYjp8tpG60YnzpNMumVSgbQu/Dzn54akJNe0bjGfBP9jcmAtKRjY8K1HvOvXNlwC0GZOLrZELRxwu0rkscS69s0GE3DjTmLnyOyMuLjweiRYsd/EZ+Jc87y5lm1+pEFZo8hE0YUZb1zdjiTomFHPlkcHHcbkomBlaACzVJNmkgsiiH1tTC1ZVMKChJE0EiPJxzgryUIUX7XuWi0RgWpByMnz37TuwmH2JC0wLs1YcbgvpTRGtlLNDCnTaF50zilYmfl8QYmC1zMXCqnGfXnItqOlz3Ymvmq6IDTC84S/j5inKuTtcyiNjQrYj9r5kST/TFGspSZDmST3tmdhzMfSiiNs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199015)(40470700004)(46966006)(36840700001)(7416002)(44832011)(2906002)(36860700001)(426003)(41300700001)(5660300002)(7696005)(356005)(36756003)(8936002)(8676002)(70586007)(70206006)(4326008)(63370400001)(83380400001)(63350400001)(40460700003)(6916009)(86362001)(54906003)(47076005)(336012)(82310400005)(1076003)(2616005)(26005)(478600001)(81166007)(186003)(16526019)(316002)(40480700001)(82740400003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 22:47:41.2894
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d344ebc-8874-40a8-a839-08daf35cae60
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1PEPF00001A61.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6056
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
instead.

Also drop the bit description comments now it's more self-describing.

Whilst there, switch to using the more efficient cpu_feature_enabled()
instead of static_cpu_has().

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 3 ++-
 arch/x86/kvm/cpuid.c               | 9 ++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 0cd7b4afd528..79da8e492c0f 100644
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
@@ -428,6 +428,7 @@
 
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" AMD No Nested Data Breakpoints */
+#define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 69e433e4e9ff..88c970046c10 100644
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

