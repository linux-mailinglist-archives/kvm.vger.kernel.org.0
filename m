Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EE1264398D
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 00:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbiLEXeH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 18:34:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233199AbiLEXd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 18:33:59 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2083.outbound.protection.outlook.com [40.107.92.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F2713DF9;
        Mon,  5 Dec 2022 15:33:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxSPorhK5aSp2qHoGU0T5Hf+fJE+fmmhiir9Qsw+oVzEtB2IS2CE7si71ekLBKpbZtHgi2ZCts1u86yy9vgGt+TP5W5oVe57l7hWHAOO55/vfYFRJKosANfuWC9gjzrQu3ntyT27P5pPUjFcUg/z2TbsULggjeuhAraW42Yc2ZYR7a0Fj+J9GZF6tocCskOleFfAZI3uEzByMhQkuorOUScH3YGbMvS0xXS12GdsuAN7Xo+t6NMZu1GCJiVWFAROA9UZZDjqvXgnEG/zx5ojG3uZlBCLmOZc0SUrj8Of0Y3yMA+CEqrEzWFqa8kpS4PT2WUTblr8qEkLIsATdXpP2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nLPAgpLB0LB1NW30EwhKp8uwdbTzlYuf2+gh4q0kInA=;
 b=lcaGv6iEBUYaKxX15iLO8CyLw7BJfYHjKlL+rx0y4A6+Mhpd4inCZGokHgmvX1v7NCpszthTOhWU9Rwakt7FM7QwGBE0PZwxKTjBBfeSFFV6QcVtX29yf/dXwy+aLNivjPbmSstMLrBHsSuYnMM/jkAnHIdWRpKemrkv24HK7QRP35SvNW2PVFhV8D2wWWZ09nwsfzHcHHHVZWzU0oSbN4dv56/VkB2+cDWr8Pu9YBmazbB6A/IAH57ZtjcCwv85PMPW8n2biNiM/ul06A16zYnGW4+KvtGzKvO/xOVIy8dOGH3rUm/GaCcP+kt/8wjWn1UlCzVVWEw8H4Gr76cKwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nLPAgpLB0LB1NW30EwhKp8uwdbTzlYuf2+gh4q0kInA=;
 b=oDoFV9B33Kw864JBbms6xiSD/QphLGNVyqOPFVMIBfgqpa4kFH75KtGa1mvUJtncnE5ZDREBq3AuLhm2leWzzdflv+h8D7DoaAKclIPP2agVeSwRXxmE/uz/Fo26y5PUC57yRo5PvL3Y6RFHKay56eWi1/hdATFJEzKti+150fM=
Received: from DS7PR03CA0286.namprd03.prod.outlook.com (2603:10b6:5:3ad::21)
 by DS7PR12MB6047.namprd12.prod.outlook.com (2603:10b6:8:84::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 23:33:54 +0000
Received: from DS1PEPF0000E642.namprd02.prod.outlook.com
 (2603:10b6:5:3ad:cafe::e1) by DS7PR03CA0286.outlook.office365.com
 (2603:10b6:5:3ad::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Mon, 5 Dec 2022 23:33:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E642.mail.protection.outlook.com (10.167.17.198) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Mon, 5 Dec 2022 23:33:54 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Dec
 2022 17:33:52 -0600
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
Subject: [PATCH v5 5/7] x86/cpu: Define a scattered AMD Automatic IBRS feature bit
Date:   Mon, 5 Dec 2022 17:32:33 -0600
Message-ID: <20221205233235.622491-6-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E642:EE_|DS7PR12MB6047:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f942405-8a98-4279-5097-08dad7192c85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AygsS7zrbhx63L3ni1zkabrZjyrScZAVKbj+drg52qs/FHjDnMgJHL/qlhNiBO+RvIgMgBftUnwWSQ+LFq8wcOJq8Bb+efPb9nxjMAy2eMTJGUacMDtrKTed5N615aw7vTaEJtFQ85Q/eTINJeXRFHpHIwi1+flfHMCXcI22Y9TTfIgLJd7Nxyq2k/kHyRWWe3gtnmuAObPP22dLd+FlIunJFwRLZgG9uyOweStEdG8eOSqEVrByE/HZiUWqnXJpktMHGkRM/r/w7bowqkq0EQWiM6ggwAX5CiSXW2FuFhetX6VOZZ8hPefQ7q73WumUMiuiIK4ux1KnvyAcdR3mh+w9p5g/6xXEtXY0xiDrcWuQGYIySvu2TCbRLV6pVDdK4cTPA30zrDCnEDNJMnjcQufR5APHsrPO4ZXv+i2DijT3LH4s7LJF9vwPo5dW8wiAgHi4x6WHDGRlTyDTzjEy/5dmObrK7BFOwb/oSmau/34ZJbnu3VH2nrYsfn+7NTUbFWXCHLXILg24TVX0Thc+e1EHvMrIJEMUtYK+RKJkP5akcZXz0AC90EklEzUmjE0o0NZHkedN8UXPDx+HTdXtMjGaxKNV5AZfYGwdmMw84nBsoD7PD748PBIr4ZxSSIeLKZvdD3FecXp26INIyG2gjFZyMK2SSWWpWL1ang/qaKbGPZPFdgW33Gd/FLgGEG4tjSQBXG9KF+8MbcA/NzoS3kvVzmia5lhnhJzrZZ/MFQk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(39860400002)(396003)(376002)(451199015)(40470700004)(36840700001)(46966006)(2906002)(7416002)(8936002)(44832011)(8676002)(4326008)(36756003)(336012)(86362001)(81166007)(356005)(186003)(16526019)(47076005)(2616005)(82310400005)(426003)(70206006)(1076003)(41300700001)(82740400003)(5660300002)(316002)(6916009)(26005)(7696005)(54906003)(6666004)(36860700001)(70586007)(40460700003)(478600001)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 23:33:54.6653
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f942405-8a98-4279-5097-08dad7192c85
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E642.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6047
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

