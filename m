Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E12063CC0B
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 00:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231153AbiK2X7A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 18:59:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiK2X6y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 18:58:54 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367636C738;
        Tue, 29 Nov 2022 15:58:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKAydu4oS57Qu5I9Lgdw+WTK6ewxl3OKV0sorxOzJ9zfErpqojtcoke9hnKBKejNFrKlaglhG8bjL261wkBPIymiRw3Rbwya/egwiUKRWciSB4VqqoEsyUNIPiLUAIjiFVcESQPRjeih85+9aeMtvFvnJgXv21DtWmOftPwynyx4kb1pBtkJXLkqTPI3C+bzSorVPZ7TzOS6us4QXQ508ywnpS+rUgsYReI2svxDSTzp4lNqiFnvlSUbg+mB99xyGFC+O0HS+oTZVKErcBW62cGWFmNjTUwgLNA5h/QPRrGaO1yrCy5C29r98V+aaYnNWKrk6oXESzZEbBshgTFsWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ghj5ckqgDV1lXiflmVljLCykoA4qqKKX7qqvp75pDmY=;
 b=hjUZB1nMD3oJM27HIX0/lUIEzobAW65Dhc+8iR/3zMMlqI03pQ+d2ajOCl4Q4cKO+CkhqG7su9LeHd8LVo1xbdSRw1acZ4SvSQ85gZFXW/Sy7jfpe21y8QcgULzu4eZJvSp8BiyGYazAo8P6gXaCG6W7aKM6cSucgydWcbX3aIW7Stu5wUr+wWX2nRU/uKkzgRTn/FDwY9LrlTGiolCNAcOewjmuUpqw46+oeVpE3diHMcj64xmmpk3AKvV9QiltvXjHVYwm46ub+ltJk+s/HW0YaBUfq6FCSUo9XMrApjZPF+CJd2sf6jJuAzTl6p2VbQ1reENqOOy/0u2tzOlF5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ghj5ckqgDV1lXiflmVljLCykoA4qqKKX7qqvp75pDmY=;
 b=gBzK9FKoi8FIBwu4fEQLoOAqy0WMNV3X80D90SilAOEHmy61NvRBitRffPq3K/5WIYqyXoI4Y7vEeq78UDcp83d8yLEajh9IF5rJa1qKisLyF9qgJW5ZADx4k8PoL/6I+SLWkYZo5NheDS5O12e04dTJSBmLCz9Nl8z3ldazfos=
Received: from DM6PR02CA0146.namprd02.prod.outlook.com (2603:10b6:5:332::13)
 by SA0PR12MB4496.namprd12.prod.outlook.com (2603:10b6:806:9b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Tue, 29 Nov
 2022 23:58:45 +0000
Received: from DM6NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::b6) by DM6PR02CA0146.outlook.office365.com
 (2603:10b6:5:332::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Tue, 29 Nov 2022 23:58:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT089.mail.protection.outlook.com (10.13.173.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.18 via Frontend Transport; Tue, 29 Nov 2022 23:58:45 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 29 Nov
 2022 17:58:42 -0600
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
Subject: [PATCH v3 1/7] x86/cpu, kvm: Define a scattered No Nested Data Breakpoints feature bit
Date:   Tue, 29 Nov 2022 17:58:10 -0600
Message-ID: <20221129235816.188737-2-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221129235816.188737-1-kim.phillips@amd.com>
References: <20221129235816.188737-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT089:EE_|SA0PR12MB4496:EE_
X-MS-Office365-Filtering-Correlation-Id: 868e6511-5d51-4477-c9c2-08dad265a6a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x/CzIxxiBcUXtOORtPtXQYMHsKMDVQkvQcjditKtJRTonA+uJ2yqx1eQdfpE01pQ57o6xuOOG2Mn8K37aZhDtq2K52AUiaCJc7Ksn3d5RKW9IusvLeXFBo7mbucXQrgTiy6Y6jmOmzqEL9YsMfqhdO9ZbKtQzuhV9/7ICfIa9DxevJhuuwXWybL5qVQd1V3EsUivhVywZdeK0AY0SXsH25Hlcs0cS4u6AO/c8zzV6iSBdp4Qg61puVSkpQyqOJ7qw+zyiIZY7JzTpLiBH6LF3ZqAwYj4gievgOgqQYRyPYWZq/MpIITdbKxlu7t9FyRq8H3k5PcumNEazQLlFKjxL06dOsmo4t/zsuryVfil7nK0lXb8yAsQDI7HJFlxYsGOU+qIP5xcUW4RzS8KNKldEcekKxRIpeNjQNTDOhytKIsuSr+nI8kHsZzefFwLuCpplh6u0K6R/QwAIg/5M43eeJd8RT5uFySmpmWcj8Br71wXJ/3spVc37DLgKNZ1ov7nZpQHDi1B9keaH9aP6bIUW3PYTtD1rc3cpeZPyaAZFUZn60XcuAJfSqbtQLPgG3X9pJrpSOKD73DIUItXX6wiZd1v4i2KcBd3L/SUj8uB9rud94KzozMZZjH1pCeQrZWggHTSi1EPD3fqVrxkUFBECGWLpgiLj3mHVWIsrtudZGNm++2BySFT7T3ps0hYiCOwDEEAaU5/dfNmzdbPXnpWYgXMkkmpZNVLhdtr1LSifOI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(396003)(136003)(451199015)(40470700004)(36840700001)(46966006)(478600001)(70586007)(316002)(2906002)(70206006)(6916009)(36756003)(54906003)(356005)(81166007)(40460700003)(82740400003)(426003)(83380400001)(6666004)(47076005)(36860700001)(82310400005)(40480700001)(26005)(86362001)(336012)(16526019)(2616005)(186003)(7696005)(1076003)(44832011)(7416002)(5660300002)(41300700001)(8936002)(4326008)(8676002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 23:58:45.4912
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 868e6511-5d51-4477-c9c2-08dad265a6a4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4496
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's a part of the CPUID 0x80000021 leaf, and this allows us to
group this and other CPUID 0x80000021 EAX feature bits to being
propagated via kvm_set_cpu_caps instead of open-coding them in
__do_cpuid_func().

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 2 +-
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index b6525491a41b..b16fdcedc2b5 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -306,8 +306,8 @@
 #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
 #define X86_FEATURE_SGX_EDECCSSA	(11*32+18) /* "" SGX EDECCSSA user leaf function */
 #define X86_FEATURE_CALL_DEPTH		(11*32+19) /* "" Call depth tracking for RSB stuffing */
-
 #define X86_FEATURE_MSR_TSX_CTRL	(11*32+20) /* "" MSR IA32_TSX_CTRL (Intel) implemented */
+#define X86_FEATURE_NO_NESTED_DATA_BP	(11*32+21) /* "" AMD No Nested Data Breakpoints */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index f53944fb8f7f..079e253e1049 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -45,6 +45,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_CPB,		CPUID_EDX,  9, 0x80000007, 0 },
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
+	{ X86_FEATURE_NO_NESTED_DATA_BP,CPUID_EAX,  0, 0x80000021, 0 },
 	{ X86_FEATURE_PERFMON_V2,	CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,	CPUID_EAX,  1, 0x80000022, 0 },
 	{ 0, 0, 0, 0, 0 }
-- 
2.34.1

