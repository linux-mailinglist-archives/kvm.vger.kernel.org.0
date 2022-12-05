Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24866643988
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 00:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232384AbiLEXdj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 18:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbiLEXdT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 18:33:19 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F846D119;
        Mon,  5 Dec 2022 15:33:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6tlJMOv6OTzM1AJMYtYHFDnGt1fZsfawFrH9w4DqpwNygmsqO6OtE8uuGnYSOLUjFa427qjPxo6V+L7fgaovzQFFcbMtRtAc6Kr0esjEVe7sSWGWWWXXgu3uJnyFqhy07VYGPU89BSGM2j1gsS4KbV3BwYsrGscA6uQ0rIguf2zzP4BgoYaeUcel1YM8ML5EkZR2P+CgDINT6SmI6FABp+I3DX/XjBOFBCndXGeO4UEsomxx14EmqD5+R4rdv0LhyRZLlzfqSI5x2DQfmjL+ng8S9RMY7/AeKYbZzNFYg9XNzQQ4ihxseX0rt2T4C5Oz1/OlxcHjoXLVjuUov0PgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lrus1RgnPCTQ3ojDfAiukMVP1G9NWHKMVy8qkw1SQY0=;
 b=n013d63F9fmkdIuBCbFiHuLtpnT6Z23uhvdh77VYhK5kXypSLLLQQhwyKW9TNUDvhm2/tps/0l6SofK5KA6xIRZOhjo2x5iFuvm0bb2I/vmJ6+WkYo4cyTj/z3qPqjefmgxusOlx/V+/yJJIBKk6IoxmMNeYWi9QvnS0m7otIU+nUe6MDunjtwfYMQ29KpOGEHd8EmOF6czDw7U4atj49RecODQyROnotlxiqnIv0DaijKQLzFq15Tg2FFKYLj2kLWErcGMwOqV1t46lmc0TkLffmwMuwz4qJ8mloO1okrWY7clPgD7RXBFXdTtZgvY5LrB+0NvsntMAtKwZa+gCZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lrus1RgnPCTQ3ojDfAiukMVP1G9NWHKMVy8qkw1SQY0=;
 b=gBbn1CLIC35Hr2dWnyVoE9wZUvsQa/moEfeYYZXEcsc8nLFiwb9jwXy7sCbmneNQBCcSCQVyRU9LM5KhZZMTYLcMBfXoEqBPo0YvefiHyQCvDbfLBisNDFu3zSi8JcgT1Z23QaicrAqAEq6+QTxpe9L1apo6o1Fi48O6+pXHwBI=
Received: from DM5PR07CA0119.namprd07.prod.outlook.com (2603:10b6:4:ae::48) by
 MN0PR12MB5930.namprd12.prod.outlook.com (2603:10b6:208:37d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 23:33:14 +0000
Received: from DS1PEPF0000E640.namprd02.prod.outlook.com
 (2603:10b6:4:ae:cafe::d6) by DM5PR07CA0119.outlook.office365.com
 (2603:10b6:4:ae::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Mon, 5 Dec 2022 23:33:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E640.mail.protection.outlook.com (10.167.17.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Mon, 5 Dec 2022 23:33:13 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Dec
 2022 17:33:12 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@amd.com>,
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
Subject: [PATCH v5 2/7] x86/cpu: Define a scattered Null Selector Clears Base feature bit
Date:   Mon, 5 Dec 2022 17:32:30 -0600
Message-ID: <20221205233235.622491-3-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221205233235.622491-1-kim.phillips@amd.com>
References: <20221205233235.622491-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E640:EE_|MN0PR12MB5930:EE_
X-MS-Office365-Filtering-Correlation-Id: fe547ce0-4faf-44e0-55ed-08dad719143b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZcAwyjji2IPh3DTUefz7h7sfAtNFgrcMY0rVara2zICBXV08sDJYzNAo0OpbyoKFZz1uo/Ruk+ubr/yX4qXxq0U6DRGhWiAMOZqR+uhP7p6TG60yVHORU2zknYi2Kgj8XHtGA8KVkxuLlzIlxVQeMm7m8/7I9AV8o3LjBjzeawBI5OyC7cnvcpuApG4S7XEV0r+FGuY3otp0hn+m4V1seJzcnGhFUM+SiTxhcGXqOia0N0JXZtNxu0SudpCAGU4kRqk0jIkPy7cXjaVcqwxRjnHB+pHeJvqgTcsAZPxhp5Q6BNVlxBD9pMWOdcon+sXAzBMEcNGI06/4ufFgjWdAS/TwcXhDiVRdHPqPx/6ZaBP5yJ2FwWYPdvWsMI2GN2nSCbyckUcu8iQ0APcDs3xKdPSSCsAOZ5PHJMJ+UpskdhvggVegvDWbIKQYAJI7feLOwV299RG71/jo9hmX6KCQ0NDNjYRlFIIIOPT9Wqq3aIyqETqIHc+r6ZCyS6KM2HAbFR4KqSaox8L/7FnzrejqPz670zp9n2hRd0GNyEiGML49urRAR7V7K7xttdCFUAA6gqlUl9IdoY5EQt6vpZcXgtKfSS6zDeMSVCBXx0PysDTF7lH8Se+fMyQHJ/RUwu3UObdTWfsQ02V2a7qI3HVHhZ3o5QLkfXl9kIS54AzBaysprX54D/Khpp6zfZxCVkEMgxTp6AOVnupLfaO341G9sQS+vRv/DSL39ba5V5AiJMY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(396003)(39860400002)(136003)(451199015)(40470700004)(46966006)(36840700001)(5660300002)(44832011)(7416002)(356005)(2906002)(36756003)(40460700003)(82310400005)(40480700001)(86362001)(2616005)(16526019)(1076003)(82740400003)(26005)(186003)(7696005)(336012)(36860700001)(47076005)(83380400001)(426003)(316002)(54906003)(70206006)(478600001)(6916009)(8676002)(70586007)(4326008)(41300700001)(6666004)(8936002)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 23:33:13.8996
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fe547ce0-4faf-44e0-55ed-08dad719143b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E640.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5930
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's a part of the CPUID 0x80000021 leaf, and will be grouped
with other feature bits to being propagated via kvm_set_cpu_caps()
instead of open-coding them in __do_cpuid_func().

Also use the feature bit definition in check_null_seg_clears_base()
instead of open-coding it.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/common.c       | 3 +--
 arch/x86/kernel/cpu/scattered.c    | 1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index b16fdcedc2b5..5ddde18c1ae8 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -308,6 +308,7 @@
 #define X86_FEATURE_CALL_DEPTH		(11*32+19) /* "" Call depth tracking for RSB stuffing */
 #define X86_FEATURE_MSR_TSX_CTRL	(11*32+20) /* "" MSR IA32_TSX_CTRL (Intel) implemented */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(11*32+21) /* "" AMD No Nested Data Breakpoints */
+#define X86_FEATURE_NULL_SEL_CLR_BASE	(11*32+22) /* "" AMD Null Selector Clears Base */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 73cc546e024d..8d28cd7c9072 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1683,8 +1683,7 @@ void check_null_seg_clears_base(struct cpuinfo_x86 *c)
 		return;
 
 	/* Zen3 CPUs advertise Null Selector Clears Base in CPUID. */
-	if (c->extended_cpuid_level >= 0x80000021 &&
-	    cpuid_eax(0x80000021) & BIT(6))
+	if (cpu_has(c, X86_FEATURE_NULL_SEL_CLR_BASE))
 		return;
 
 	/*
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 079e253e1049..d0734cc19d37 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -46,6 +46,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
 	{ X86_FEATURE_NO_NESTED_DATA_BP,CPUID_EAX,  0, 0x80000021, 0 },
+	{ X86_FEATURE_NULL_SEL_CLR_BASE,CPUID_EAX,  6, 0x80000021, 0 },
 	{ X86_FEATURE_PERFMON_V2,	CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,	CPUID_EAX,  1, 0x80000022, 0 },
 	{ 0, 0, 0, 0, 0 }
-- 
2.34.1

