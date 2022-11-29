Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82E4763CC0F
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 00:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231309AbiK2X7T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 18:59:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbiK2X7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 18:59:07 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF3B6F812;
        Tue, 29 Nov 2022 15:58:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BeopJMIBqi3lZAg21la+5B8G0N+rQtGWelBe3OvhiTgJRyxeG69+VFd943Q3TIFPVS9Wl0nunE1a4BV5KV/zAsjF29ygEiPL1F3U7VRlgbZgRdVvGR4IjQcZ5dz9pvM54iGo8qOc+PNfIGCFBTWtrfL8Lq+SjtqtzDe968i4vso8qE11+Gnno6dLNHRAfK2EztGtN5SrKpS7OGMDyijySrU2qlD14Z6/y2zIiQmPnBwlt/3HjZCWqFgkJDCCTvpht+6ysrx9j+W7rP1pC81wm5uNKmXax0sSjVGYAU0mEk8+b6MzROwnw1U74ngo0EUoeoHjr966Ycuy46yJuILd7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3mBRCH0RHZGhPDha632U6j9+A9xCRgPvHIBf/L4fpSY=;
 b=SHmb/UHhFL2Xx5y1cuTN9R8Jt423r0P2U15Z+RjjYkOp2/xrYsVdJE4H5kv90otiZ3BhrEqCDAnfKLNEoIBoXCO94vSZ9xFklxha/9PEqmoTZqPh2MzEIQz9hdVBITT5ZIRuBAYqCDf6YOwgMqXRN1pdMGVdDVJtS7qaKfS8tsIw334u6BsCAIAsrIJnSNbk5/Q9YCGiYOpOUFwtuLHl1tPwrruNZae7pzjS57GgGaB137vMRcTrWcF4a1XMwncqMgTBRLwyKg0dID7rT2qTeBLSx8faX2QYvG2uxNhG1/WDRhFm1KJrJEaNMj+TwbKt3MUvRFrMhj59nQ3Das+Otw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3mBRCH0RHZGhPDha632U6j9+A9xCRgPvHIBf/L4fpSY=;
 b=uCTaG4HIc1zbTH927WJBf3KqGhO8GpEA8bN9IXmoltfqCSNd7+MZItv/c+mGcBapeRtpNzGiYaoiwxMDSL/ys7tBDIN11QmkTca0TdRlNOtfohQ5mBPle8ROKrgQoRn52zVilEoMemUQY5AwUvPZCxv5+uGspRRVPH9DQxfkojs=
Received: from DM6PR01CA0002.prod.exchangelabs.com (2603:10b6:5:296::7) by
 DM6PR12MB4252.namprd12.prod.outlook.com (2603:10b6:5:211::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 23:58:56 +0000
Received: from DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::69) by DM6PR01CA0002.outlook.office365.com
 (2603:10b6:5:296::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18 via Frontend
 Transport; Tue, 29 Nov 2022 23:58:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT112.mail.protection.outlook.com (10.13.173.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.18 via Frontend Transport; Tue, 29 Nov 2022 23:58:56 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 29 Nov
 2022 17:58:54 -0600
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
Subject: [PATCH v3 2/7] x86/cpu, kvm: Define a scattered Null Selector Clears Base feature bit
Date:   Tue, 29 Nov 2022 17:58:11 -0600
Message-ID: <20221129235816.188737-3-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT112:EE_|DM6PR12MB4252:EE_
X-MS-Office365-Filtering-Correlation-Id: aa1b7b52-0eb8-4c46-cce0-08dad265acfb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zokKW8VjUgFVODjrUUZZuCb9bnPEQa/fm+MVbWitwHb8GYsvpP588z/QEgwevyq2Yzp6z/DVw7JOVkp3Rw3kyDq72ayLU1YlPZ1ocwmK525Okn2ANgNQGoQ6lJcXrphGbkJwnCy2aWMMe67cyybuEKl0gaA5nriGia/V+7RfiVelNxLjeq0mstwqar4eH5JTb24caVv4J1UTFm51isVD9wbTa2ASUE3UuYaxJB8j6v9ClZzyoYD2c6Y5NUSppoNY+f48or2wzQzG07b8V+sRSDwdZiICyD7WgWqOusoLMaCYGY3+X6Indcsy0RPNqOBpeujVHQZLS2ATjaDvQWCn0OJx48KQ8MSAwS6PHvSKe0uTQhUoWZcCS9IKJwLqGstGDZMCCbaTD3ALVGK2rfJ7vKttutKz1ArpBXX+YAFyCXAI0ViTQfJEg0GLnY5K/I2VjQuONDIr+dnUvIj9kqoH4DXsntiogYJBjuKy+FaNCEA8lkY4C+ico3PFZuns+/CD8TGmcNbsvzMtMObTaiFqrHHpSYSOCoB5NECZk9t0Xji6Wwgq6ySWGKzQRpVzdc/FJRnQi5fbW8rJWCw9Oi/OFhylgxraf6rcMtM8U38gzHPKAYBSEmo++Stx49t+vrPVawFWFWkO/8+5gUIryteiDESpvb/QWsKRecm6upN1k7cfa9yLyczU2ogEfGg0QQXnuGh4sy9fjBhQ5wAolUjATBma6EBvcc98Px1rw0uk+QY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(376002)(136003)(451199015)(40470700004)(36840700001)(46966006)(356005)(81166007)(86362001)(40480700001)(16526019)(70586007)(336012)(41300700001)(186003)(8676002)(8936002)(70206006)(4326008)(26005)(2616005)(478600001)(40460700003)(7696005)(316002)(6666004)(6916009)(36860700001)(83380400001)(82740400003)(44832011)(54906003)(7416002)(5660300002)(426003)(1076003)(47076005)(2906002)(36756003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 23:58:56.1278
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: aa1b7b52-0eb8-4c46-cce0-08dad265acfb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4252
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

