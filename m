Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 173D563CC19
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 01:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiK3AAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 19:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiK2X7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 18:59:40 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C0A71F03;
        Tue, 29 Nov 2022 15:59:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFLwGwcevBwg0UDvFijQjrCKaryn0Wu4sI13A4rb/liwVY7QEiDOq2RppN/UeR6swfQR+ofpyFnTZvP5mMejoav740yUVbBzKjerMkFpeYOB5voZnniWZPgiABSUTfJIgQ+413X+UPbm7WGHfZnJYGZqcSYr/3eAXqp7x/975pGkMk7BolqSTzGT6OTS/pmzyFnZxpGgyTLCs0XUW+/5JazGLt1mU9LR6uWg/ouy2JQW11Cbq6rpZkSgYwItedw24w+TRhuTmvm66wahEWxYuphJhMzvnyACIhTAmbGHN+ngCxxTzH1NvQ+TnQ0Nf/ekbD1YY4u/kZnrX/Wbmd9uzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dAjHQUC+VMJtJYDXkaqs+IqGm6fkN6nhaAnYJNmf1as=;
 b=Au1IF2g2Hxy5uMzAe1rUdQLSSc2VTNsEwJs/elXaVGOIIDxPtXR2XzJPEOmTv6BIsTVs8U0kMfB/oPj8rj7Dd8VmCc6L6eMA6jE4RV8PKalXXP2aorEHatNLt+ZJHk3alYv4a/spJseCRmKDBoIfidouxcl68qXE1mwZ4+6ddrIHGQtYcoYViV98sBpeL4O+QNJ1Y1jylk3BZC3lqq2SgjvYehpCNyjo0yLG+Fc9fg3W9JfPrF5cJPBndgGYTkwmzy1tWVRYAdsmy7jPrwztua90s3xQIOP5Q+Xs5oX3WBQPoUYBtahqFVLHErkxEUcvEXBlbmXcSh/foy0AVP3u/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAjHQUC+VMJtJYDXkaqs+IqGm6fkN6nhaAnYJNmf1as=;
 b=wJSILQY9nWoyBCGfPeLk8HRwVfSUJMZKob2gjcP56CX0TxJqklku4zdgqvXr25tsEHmRd5aJeG6jeXmgHJqE3kUpNwOuo5K9NEOhG453ANyoGaOztp5IyHm+3y1rp5O2X5xUpk2MGly9jku7ATJQN39UE9rzHk2mROW6yTD1C/0=
Received: from DM6PR01CA0013.prod.exchangelabs.com (2603:10b6:5:296::18) by
 BL3PR12MB6378.namprd12.prod.outlook.com (2603:10b6:208:3b1::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.23; Tue, 29 Nov 2022 23:59:32 +0000
Received: from DM6NAM11FT099.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::19) by DM6PR01CA0013.outlook.office365.com
 (2603:10b6:5:296::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19 via Frontend
 Transport; Tue, 29 Nov 2022 23:59:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT099.mail.protection.outlook.com (10.13.172.241) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.17 via Frontend Transport; Tue, 29 Nov 2022 23:59:31 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 29 Nov
 2022 17:59:30 -0600
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
Subject: [PATCH v3 5/7] x86/cpu, kvm: Define a scattered AMD Automatic IBRS feature bit
Date:   Tue, 29 Nov 2022 17:58:14 -0600
Message-ID: <20221129235816.188737-6-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT099:EE_|BL3PR12MB6378:EE_
X-MS-Office365-Filtering-Correlation-Id: d82324d0-d1a7-4d73-dedb-08dad265c224
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hEcpmisT44hghpM4hsEuuu+TQAGMTvuqXhCTnfES7ZFfc0UD4jftyeb0fU9kcMD94ok7exH72V9DaVnZbNA5i8ggDWamtp6dAbnfC1Ah85uEnLXw/5SH7Dg3FMDsE5VAZmgfYYmGFtE4Mxq0DbEnZ5b/S64BouqG1dWDT/hRHcPQNhx2v91ws8oAzUsaT6Cg7piL4l1DUGak5nFOWS2KM+3tHdgqM0+p8+wvw3m4zd8yG3ACzL1IeKd6OR8NAPU4OKch5bd5jRBClUW3E95FVjpJ5SDdvs9ejJN6C8AkA8sw+LXbeXRJmn1E0cowoVbivnrHVPtPCqW85HZXRoTbrg+Y/siXvQOFO45ytgSA0ZvEF2hOkDqC185S06q/JSxY4S7NELWoz8kruMp+C70PDQScbgDWC/BPNrG84gmuy+Vnjj9s/cQjN7t2Jqi+PAOMKKGqG8zUaawX8uBbZbGFXzzGUbJua5e1tsoGb+pJj9/ccXVvNeL7l+yD7DXCXq0UYOUTedFefBTbpNYdIvJj7/YRYQKSJV9J+6R2HU3+u3QE7KRPOPaGs9HJ8VuBBQi5WnmwhkdakiyxGwoZsn4GlOgUpFIreFtNvXl0DYLvYuIitf7lsQhhHnkuvBxbzIsXvaRfS+cj7+3kpajEJmbVuL6z3/oxS+PqVYDUNxqtKdnc8aBOZXeJHLs1+8IVQjHTArZ/ZgY8FIaU6MXyGOSBueq1FwKgHugD0SqQ9OWHpV8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(396003)(39860400002)(376002)(451199015)(36840700001)(40470700004)(46966006)(41300700001)(478600001)(36756003)(7696005)(36860700001)(336012)(316002)(54906003)(6666004)(356005)(4326008)(8676002)(82740400003)(70206006)(26005)(70586007)(82310400005)(8936002)(2906002)(186003)(44832011)(1076003)(2616005)(5660300002)(7416002)(16526019)(86362001)(40460700003)(40480700001)(81166007)(6916009)(47076005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 23:59:31.6291
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d82324d0-d1a7-4d73-dedb-08dad265c224
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT099.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6378
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

