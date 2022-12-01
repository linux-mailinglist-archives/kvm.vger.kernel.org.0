Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B132063E743
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 02:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbiLABul (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 20:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiLABug (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 20:50:36 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2079.outbound.protection.outlook.com [40.107.102.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301D79AE1B;
        Wed, 30 Nov 2022 17:50:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fQoFvtS8bik7LQdSx3isG9pVbGkRCmdFZ1xYAtN5uNsWntqolMsem41csOOBOspXm346JZ6BT5g/Eh42RP9NvC8lbXEx2T3j9Pohd8s9c9+nGOWepsMhKrOsY5+CZMXA7k3FWSO3usxbDHKTMhbcNloHtCqm/K7qh6sigZ+lEZ7ZnOxkBhROh2Uxq3OK4Ihgwdm0Bl3sbw4r8nOv5NovKMzpWzUxji58ZwexB56Ze3sZdLvMIqUVB9j9bMBBk2WATgXJoI2mA7sE/ZdTnyGoElnLcP8ZB4Ifx1D/Qk6s7hD/GdaicjmCVp27JdheCQ6s/fycbBF9E0niv/iClCu2Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HQpTsS8xT1UW1HpQcwngMfc8dUWozRXsDFyQfd9txEE=;
 b=RSz+CqFFlHvlVEtZsNTJkJzhvtnD705CzJbNQuozatwtQaXUggIuKI914vOB2pA7Go2ZZJCI+u7H40/xK78ifxBYcWZnjnimGXhfWXBcxxNu0W/HF/0NZsy7OZ4ss+fIF6rvoIXQdpGBNC41OhDYZiOBM92FA/CCXwolUWemjecjoOVzGUMA0lOeRdz9HyMXMnGFGLadqdz63b4LkiLT5y/oLncID75tPf7/r8LugR8aamZ5u7OINAZ9PdH/fkU40nb4AOMO+v8FG8z5Cq4b85hIe3DOuh7UbhgUpTCiYvi4/HpZHmv1k7QWMC5YrO/98P6aFhOMRPR3UnmoaVQfsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HQpTsS8xT1UW1HpQcwngMfc8dUWozRXsDFyQfd9txEE=;
 b=octtsGmDombSHS2V9X/xAVoKsRGyELMgtsGO7kXMm4+QeAleABaNc/DwiNe5qvWFvyxSm+paTkGc3iioIgIJAn4ih82RvlVK8+pNIK7n/QuR0Q1TK+8RDCGY4k4qBiS/P/qeqn3eYZ+LLglm7EFiKOKOmDYpwO1MNtN7Y6VE8qo=
Received: from MN2PR19CA0052.namprd19.prod.outlook.com (2603:10b6:208:19b::29)
 by CH3PR12MB8186.namprd12.prod.outlook.com (2603:10b6:610:129::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Thu, 1 Dec
 2022 01:50:30 +0000
Received: from BL02EPF0000EE3C.namprd05.prod.outlook.com
 (2603:10b6:208:19b:cafe::d9) by MN2PR19CA0052.outlook.office365.com
 (2603:10b6:208:19b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18 via Frontend
 Transport; Thu, 1 Dec 2022 01:50:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000EE3C.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 01:50:30 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 30 Nov
 2022 19:50:28 -0600
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
Subject: [PATCH v4 1/7] x86/cpu: Define a scattered No Nested Data Breakpoints feature bit
Date:   Wed, 30 Nov 2022 19:49:57 -0600
Message-ID: <20221201015003.295769-2-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3C:EE_|CH3PR12MB8186:EE_
X-MS-Office365-Filtering-Correlation-Id: f5fae657-f354-467e-1597-08dad33e6d83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YBlIM8e0Eo/NYBfbFDCCPmUDszAhHvtukK2kYjRX5uArBj27OSG9yEY692BxyvpdhmLzHjaqeF6z8fEmgxUSkxgLhByYW56AspkmYEj/YgeedXTnZLJ3gIvU0xkE2FAigm82o6F35YVGIwumrULkOExssSI+xZ8ZteOkBHrQQYefSeUo8rL3r+ZktF8sE0F4POqpyO7AK0KQ3GPEd7y/2ooDpFFXGyn8fCmppEInyOY/OmZBm4Vne3JeDFiSq0qvKgJXt0tukHjlyoq1WlC1jPsgyajNrKgNtzfsMn2mYT1f80Imf2A5MJVqQVIMXdhubxREnticnl6cM8C/SrZipJ8N1p+sZnBxu2p1FM06lB86zhoc/U30pUXsUKBUw/lyZlywZDftfIo0x7rLW9KT4XBMAcn92P6EbF3DYtTJVYVUeMEBvy65/XKKaNgbNXMpfC2qAy47D3qtnfRYnxArcJODnpGGc0EHWM7fN4RatD6XFW9nJNALLHyn9Rpqa6U44+YmuImy/Chm17ozTxvK1avPUPLT+tMa+yMUxdigcEzOBpW4TYkVm1hfv3E+pXiL1MoSacNFhA/8WuQ82lcq6WU7ZDtBQvghlil6rN7MllLHbD0Kr5CEP63KLRZsn0U4AWMqJqIwBbyYpP4fQwD03YqE0t54PFCVK/Lu23Mv5h6i83Up84d+A+ZMVmY5kybeTcnUny4V4/hEyflolbbPixYps/Aog1Bld3k+1bU1bEc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199015)(46966006)(36840700001)(40470700004)(356005)(82740400003)(86362001)(82310400005)(36860700001)(81166007)(2906002)(40460700003)(8936002)(44832011)(40480700001)(8676002)(4326008)(41300700001)(5660300002)(7416002)(70586007)(316002)(70206006)(6916009)(54906003)(47076005)(36756003)(7696005)(16526019)(2616005)(26005)(1076003)(186003)(478600001)(426003)(336012)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 01:50:30.4305
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f5fae657-f354-467e-1597-08dad33e6d83
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8186
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
index 11a0e06362e4..b16fdcedc2b5 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -307,6 +307,7 @@
 #define X86_FEATURE_SGX_EDECCSSA	(11*32+18) /* "" SGX EDECCSSA user leaf function */
 #define X86_FEATURE_CALL_DEPTH		(11*32+19) /* "" Call depth tracking for RSB stuffing */
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

