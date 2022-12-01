Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ABFB63E746
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 02:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiLABuw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 20:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiLABus (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 20:50:48 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2086.outbound.protection.outlook.com [40.107.212.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9369B9AE1E;
        Wed, 30 Nov 2022 17:50:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iTp60CmpEMNlysKtlQ2WJ26mo4x42oqLpr9aO3qkcXG97u3UvXgs4bXW54g8tZqCmfDpcEo15FOKkULIMWZ3WH39tABaE4xWurgSc0Um1xgBskap3RkpG7pOcD55aJyZ55Tm0ZY3Yt1G8g+Lk0vY8ULjcQK0dxtvSLWLKMcmkZlOmoa4Y4HfwFSBTOrrzX3nGNwFfZYN5RKvta0ySl/76KuCf6oY7iuICkdVbY5hwW9shnrmz5Iaxk72ljkRVLqYBfslLLQv/9mRzlvw47Vi1PIZzcjXZNYkH4WEh6Ba1RuxLfTRFbOHv6ntQZ3q+rCLhjPH/XbWSPoAvhXKL+VA7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZh06G+UMQkT5MIp5hrgE1kDExWORTtidp6tHLKxO0w=;
 b=dKmDrfDZjY352qbSpGy7a91jEYGXLI5meyBHvw4mnwGSbKp8cCSEe3C6NhFiaTJpSoMj3AbQ9GxhS8ZvbGODzaY76bHWQ2vAMAfadYml2k7xtS+81VTLYTcBzi+E3P8FReKHuwRwCa77IhKSOoRolZZ33NNp+O7GXybWMLoWC4jzXKtAPVCJCRlRKiSFCbyuU+TPtzha34rudJb5WWUcgByWeaw6gByPlrqJG8+AA+L/D1pXa01s6oeqtrI0z/Ov6yvl/rAza9F0VTMVfgVuUMPuFiuxi6tGKSU1RQBMQKhVcQs/XMmEh9g+XXDxb7GiN7Bd8MaUY/UaVmWEi/D2UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZh06G+UMQkT5MIp5hrgE1kDExWORTtidp6tHLKxO0w=;
 b=zHvOeK0Wjrpa3K/JNdlxOKlFtk3GWif4yR2jZpy3AMsjSL1Td0qZbRu/qQlAO6a9qIXONZMVvPlnO5Zyd6XEjKJLPe9hkKTa1qgPHX5NzX3SL73OJ6eMmPfpuhDzkEYUXnLEmc3NCQ9idE3WE887cZZR9ngp4gIB9/cRf8zFgP8=
Received: from BN9PR03CA0196.namprd03.prod.outlook.com (2603:10b6:408:f9::21)
 by PH7PR12MB7426.namprd12.prod.outlook.com (2603:10b6:510:201::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 01:50:42 +0000
Received: from BL02EPF0000EE3F.namprd05.prod.outlook.com
 (2603:10b6:408:f9:cafe::55) by BN9PR03CA0196.outlook.office365.com
 (2603:10b6:408:f9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Thu, 1 Dec 2022 01:50:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000EE3F.mail.protection.outlook.com (10.167.241.133) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.17 via Frontend Transport; Thu, 1 Dec 2022 01:50:42 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 30 Nov
 2022 19:50:40 -0600
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
Subject: [PATCH v4 2/7] x86/cpu: Define a scattered Null Selector Clears Base feature bit
Date:   Wed, 30 Nov 2022 19:49:58 -0600
Message-ID: <20221201015003.295769-3-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3F:EE_|PH7PR12MB7426:EE_
X-MS-Office365-Filtering-Correlation-Id: 495e7954-cfcd-4868-10ab-08dad33e748e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QvEhnC96ob7c4cb1TSlcnhg+kRm6UBDPfe15ch7dqYzGyJM58/GM78DhstwfIUqv8WVxtaWmaPS3TYLC+edZ3mW2OwjAkTvHXal4h6edSy12Q9rvVoPuQnF5DcLw3XI+ncVa68ZlU1DqSgLxOwr2SKkaMdymnIoXifKXODktLozGDQsQpBfTyKlA8oxOr6lMhPDcUZ0nJNvQYiw6ldz3dovB2eznT4ZgYwtYuS3NRjRoWACLya1rC5m9YLWxScj8tOPE1wmageESsEHuYXQW1/BEsWus4KedThiClNP9tFoVaXguRqcnYiBOiCbAYl32mCEQ/k1W50KUsntN3eEOnEw+E8S0afvhAPY9gFsj4y0OLkoBSoA2OV8Ww7KuZBsEqD3RVl0vn2cmm/qDByK1CjSAHasxHwn3iiRZyN0Dd02CB0WCqfO6PD6zInqBl31X7RmJj8QTI30+FmpXTNI//5MLCF4V5yvhallIaS/tZu/t+UNwyeZvQjMGW9f5uW/N8zeHT7qXvA4usZ12lUBuPFUqeei2yDQbf70iZGBqjdKcPyQmSumsIk5mKK9JEYrHKUbK+XFSKNzg6EYiHcpvWZgY4bJfhmCm2fNPn/K1sQXScDvF53Gl3o+P2Epg4EjR0PN5ga1b2SyMcHQSbG8IOQnlNSLQw3pE489TD/KPuNFux1xj0LXCwWQXBnSConQI1K11W+fVhVhSZKdcJPZtobNaJT6mqNtjKZF100PGEkY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199015)(46966006)(40470700004)(36840700001)(7416002)(7696005)(5660300002)(1076003)(6666004)(4326008)(478600001)(83380400001)(70206006)(8936002)(2616005)(70586007)(186003)(47076005)(336012)(16526019)(8676002)(36860700001)(426003)(44832011)(2906002)(41300700001)(82740400003)(86362001)(82310400005)(26005)(316002)(54906003)(6916009)(36756003)(40460700003)(40480700001)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 01:50:42.2621
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 495e7954-cfcd-4868-10ab-08dad33e748e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7426
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
propagated via kvm_set_cpu_caps() instead of open-coding them in
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

