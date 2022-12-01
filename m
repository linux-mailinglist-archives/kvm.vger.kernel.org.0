Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9098963E750
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 02:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiLABvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 20:51:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbiLABvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 20:51:38 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2054.outbound.protection.outlook.com [40.107.223.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F60A9AE2A;
        Wed, 30 Nov 2022 17:51:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=htDxSX6W9bylxNXpVzKhForjnFHV7+LB0XrjdqH6UrFOcRYe16pWHiYRFIB78KbKGExkEGjqOqZJSpXnEsNSb8vENfP97fKUepVNtl0UIGTcooVAPXzPqSdCKRv2iKBjJPXEe5C50RnWjUedHm+AAuhpB91U2q2rbS6kYDZ8mSKDAQVGBW4rwl5ViY9J1YFlTg+oLFGzJwKI1wY1rMJRbboEgKi9FQnQGzZN/rz21XhU9YhEVGg2laEHZYnorS3zYu5JfvW6K2Agq+o8Fmkckg/ggJ1Z1DyBhUf7nKLpDBWt3mg4zVZLorotWX4pnReWqVqGwmX/+1YbZnzfCOGwTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nLPAgpLB0LB1NW30EwhKp8uwdbTzlYuf2+gh4q0kInA=;
 b=YBfWWVfGr38ZRpzPmXQnbUAXOe892Ek1B/h3Rq9YTp5xFI7Q7MAo5L5/pkJUlUbJFONBpXsFnBClUyDIwS0MH0UzPYJ92Rx74r4R/jc9j6P8kKFbwI/7COcHXo4yUObuMu4GXpYLRJsuzCIb9jvtJTGZT2WejrgkpVnZP9dL85K70xd6AfpeyWQFJAgSHlhMKvkRo8S8RRsazK8vL5sj3htOXxATFQBs25gJW747MaXUu3+txgIVlwFsI1u8LtN7fW9+E3C+UabC1rW6I7rrcfSpGDnvSacebL+IgODE8RiC/HLvB6LELbe+x5O4JYFm7QFUGLA//sYd4IymXjrq3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLPAgpLB0LB1NW30EwhKp8uwdbTzlYuf2+gh4q0kInA=;
 b=CmJulSZjEt4I5q6IzrD435WpAyXPF37Svpc8w6TlM/bO7ft5RRlLT1PvG+fb5XEL3WOvZPSwPWtNDMC4PK2GpGQoVSfxAu2KH8o7XDpMHzOaJteNLDiyVIBIRs40nmAzX65pJmEQZvBvH4zyPeZL47F3W43oofNDrP9ADeiOpI0=
Received: from BN8PR16CA0004.namprd16.prod.outlook.com (2603:10b6:408:4c::17)
 by DS7PR12MB5959.namprd12.prod.outlook.com (2603:10b6:8:7e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 01:51:34 +0000
Received: from BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:4c:cafe::8a) by BN8PR16CA0004.outlook.office365.com
 (2603:10b6:408:4c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17 via Frontend
 Transport; Thu, 1 Dec 2022 01:51:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT025.mail.protection.outlook.com (10.13.177.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.17 via Frontend Transport; Thu, 1 Dec 2022 01:51:34 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 30 Nov
 2022 19:51:32 -0600
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
Subject: [PATCH v4 5/7] x86/cpu: Define a scattered AMD Automatic IBRS feature bit
Date:   Wed, 30 Nov 2022 19:50:01 -0600
Message-ID: <20221201015003.295769-6-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT025:EE_|DS7PR12MB5959:EE_
X-MS-Office365-Filtering-Correlation-Id: 32834dd2-295f-4ac9-8014-08dad33e93b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PXmMy+SaTmF3dkWPmiZ4as4uM+G/mCSqy7ETFPBgK9n8+rZuoo4XQrQDhzqSufEGmjmyUCBWY46rN/hx8mgpHLYhkDfCwGNESVBhWRGm6jQG2zFKGjFS/v7u5NMWQirnzEAmahbZizzdo2mxh63CrrP8M8v87Gxk9hyF4JlgOQi9ZCr2QgA/QMYIoXJONfGq3ISPcXXZ7I0W9XkX/1BxSAK4uywf0+LzXYT5BHfFyFBI55pWjoKoD7oknWNO8SQ7jQyriTt3dVDkKRLdVgX7eGDA9MpvYN3zPi3Y8+I7CegCd3ZnSLNLMcPQHqrH2GjP4R07zYuYSBduxfB4P3HW0N3kVEqUrgBkzyVwK5R1wqBRfvFp+11WYuJTv+Sbn5PZe5RB+R4EnDO6Q34NK5DEKzFJt1KZ16qfK5vkjb6KNMeWxZ3VNPPBMBSx/llCHrAPMuCYLxNsXbhuknExofqZuTKpz1Jn10+PnIxwhDYrAjEd6qqivd+Gb7IWCMStpGiTAxaTqFL47XpR9qOvj7q1NjgGkS/2G70oQuYBejrDeHPPtX997B+uk0s1BrsCOgGYlYLwetyKlsEfEsAv0YjGcYVmB8ih9zrcDW88UcvbdWzILuNhn1hVOLvcH7358zxiGTxmjSDSr8uXWhHPjWa6iYve1rHzGQdPt10KESWXXRh8F7NjPxtm9mDT4Qy5PPCnPUh3nMqv7QFLNzi3LHIpjwrFTuNFpSE4+5T6gGnn+0s=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(396003)(376002)(451199015)(40470700004)(36840700001)(46966006)(82740400003)(478600001)(36756003)(82310400005)(40480700001)(26005)(6666004)(7696005)(81166007)(41300700001)(40460700003)(70586007)(356005)(70206006)(8676002)(86362001)(316002)(4326008)(426003)(44832011)(54906003)(7416002)(6916009)(8936002)(5660300002)(336012)(47076005)(2616005)(16526019)(186003)(1076003)(2906002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 01:51:34.5718
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 32834dd2-295f-4ac9-8014-08dad33e93b9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT025.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5959
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's bit 8 of the hardware CPUID 0x80000021 EAX leaf.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 5ddde18c1ae8..961eb49532b7 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -309,6 +309,7 @@
 #define X86_FEATURE_MSR_TSX_CTRL	(11*32+20) /* "" MSR IA32_TSX_CTRL (Intel) implemented */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(11*32+21) /* "" AMD No Nested Data Breakpoints */
 #define X86_FEATURE_NULL_SEL_CLR_BASE	(11*32+22) /* "" AMD Null Selector Clears Base */
+#define X86_FEATURE_AUTOIBRS		(11*32+23) /* AMD Automatic IBRS */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX_VNNI		(12*32+ 4) /* AVX VNNI instructions */
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index caa03466cd9e..7ae7203cd410 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -48,6 +48,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_NO_NESTED_DATA_BP,CPUID_EAX,  0, 0x80000021, 0 },
 	{ X86_FEATURE_LFENCE_RDTSC,	CPUID_EAX,  2, 0x80000021, 0 },
 	{ X86_FEATURE_NULL_SEL_CLR_BASE,CPUID_EAX,  6, 0x80000021, 0 },
+	{ X86_FEATURE_AUTOIBRS,		CPUID_EAX,  8, 0x80000021, 0 },
 	{ X86_FEATURE_PERFMON_V2,	CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,	CPUID_EAX,  1, 0x80000022, 0 },
 	{ 0, 0, 0, 0, 0 }
-- 
2.34.1

