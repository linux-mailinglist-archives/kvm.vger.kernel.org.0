Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBEF643985
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 00:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbiLEXdg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 18:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbiLEXdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 18:33:12 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB0ECDF41;
        Mon,  5 Dec 2022 15:33:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikJxMhNYwWL3QqwTqRaucvOLafgDoIAvxGqjSWUqrzLeZby2YHII4358BXsK4hjwj8DFDopWLuD/Osukm2kaVuaU2q2BCBDe0il6sKu+gg7n+/5vkBElx5DbHA0ucRviiFMjdQuGLL5AWcvAqgtvZTs1tdZiBsPtGVnoOf1QTS0IhgRybe2FwZbId8yi9IeCShdxQG4szSdevuZr0LrkRzPgIkZkPX32YcVa28u37hDpEiUcjH4otUyP5xd/8JcVvv16M+vAf2DNsuPs1qBu2lv+gXTxOlmBw5M272xieoQW0Eo3dWUBwZveCzBnfS8nnsVL50Bga4v66zVzAr2+Tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H87hsUKB9LkjnvkNIHk3GjV+tiR4ViJcfg5LYKiVPkw=;
 b=HXahEg8LPGWbG6k41qAX8cwRdHzqqvYfUfqQjIFCp2bFuV+6iCj2yDW3kFcQrqt8vYqLr2MOb2rEQNyqRdX5ZdzqVpjCSe6F7w8FF/c2GGoUrepZh4qUEYV9t3DETO6ZoxSz8Np4n2Ipxf8CnIOAyIeNPFSpIzjkXRaHEWzPzjtXdj3bCa+ZMbeNjJn2+01E4G/Gv6VEOfF/8twKxey9aJOOHQVtK6fsZhhyRqG8XzVnOHhIR7sKwYDW26T6fJCGYW0NmjVsskjTtWrRy6uS0DraT0WjtkVSSBf3UoaktJJkg/T6uPE7VwGfcyZ3qDgfGAHlVZFdjt4pfE+5AX337w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H87hsUKB9LkjnvkNIHk3GjV+tiR4ViJcfg5LYKiVPkw=;
 b=Kpd+8oKWXvewSxLEPScip+5dubW0CfevPI13FOYJtLzwiSZoRQIt/YwwpEmPqP1zGl7hMWiF1yB4tkkUyyA/0sSyGyQdXYakqoFi+1t9hzboIInP3/8qv3HJ6slAQlpZMaTF6y4akpk1dPGSM4jFTxwwVuPrF0NRNTYZ8VyeDkg=
Received: from DM5PR07CA0102.namprd07.prod.outlook.com (2603:10b6:4:ae::31) by
 MN0PR12MB5907.namprd12.prod.outlook.com (2603:10b6:208:37b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Mon, 5 Dec
 2022 23:33:02 +0000
Received: from DS1PEPF0000E640.namprd02.prod.outlook.com
 (2603:10b6:4:ae:cafe::da) by DM5PR07CA0102.outlook.office365.com
 (2603:10b6:4:ae::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Mon, 5 Dec 2022 23:33:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E640.mail.protection.outlook.com (10.167.17.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Mon, 5 Dec 2022 23:33:02 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Dec
 2022 17:33:00 -0600
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
Subject: [PATCH v5 1/7] x86/cpu: Define a scattered No Nested Data Breakpoints feature bit
Date:   Mon, 5 Dec 2022 17:32:29 -0600
Message-ID: <20221205233235.622491-2-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E640:EE_|MN0PR12MB5907:EE_
X-MS-Office365-Filtering-Correlation-Id: 863fdcb6-c80f-48a2-f5ed-08dad7190d24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lsnrWJoViUtZzKSTmF4RnLRq6BYJVBdNNrUHpQMQNQmm9ZJJRu+EQ6DYx5MwmajMFMg0E3jFyeThOGnWWAaEruaWdYodKC5/USoU8EEQUCM/piGszXNBt5y/cNWzKWbtdaJh5splW+iiBIZHhP9RQT7OUaeovtwGguug6TkO6E2ofu0Hxv+6v0opQPWR2r6ifis4WHCgzdYcv4s8Q6NGqZgAHv9rkNsSFto2rzHbP/72jBUm59w/zM2IBac1lnzxWXAdl0PAGz0pwtjl9tvS64dqmvkoxzy2TxjDpbg7JinxgkGV/4bY9JrdHTQlIvyS0SOVDCdwNFYuLCtKdIZ3A1JhVDqMV4/FcJMOfENNlkuTMuCTXetBxn0LgovP82rHPSTIe0oh9TpnaHxoUn0upYZNS/TEm6l6M0Q4Uw9DY/TKkR6tB+r+hbZ/l3IXakLn+Edvfbjyx2njeGS8A+AnKAMu1EBpn9yPDjgIAknBT+6WrXlnUIeKGokY51ICuLQGkJztE0k/9CIYm+sa2ZBKCUX/jMoZHOA5njgjAm0bE5Kucnl2pRj6Ny8Wce54bDyDFwgo2Z/GeYZmodDye6Rh3rgcSdLZu4I33mEUDMObliOda7PoHuj6ESgxbY6suogoipJEFGUfydi2wcQlXLpk18rzrzfwaJOpzyud3rY4KuH0OvPXQnBkc3yd68eBMLxogqJzWz5zDMc9ShvKMmOwUJM5Vag76xJAapMIJOALRl0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(346002)(136003)(376002)(451199015)(46966006)(36840700001)(40470700004)(40460700003)(40480700001)(4326008)(8676002)(2906002)(478600001)(16526019)(36756003)(2616005)(81166007)(26005)(36860700001)(70586007)(1076003)(70206006)(6666004)(356005)(7696005)(5660300002)(54906003)(8936002)(6916009)(426003)(336012)(86362001)(41300700001)(44832011)(316002)(186003)(82310400005)(82740400003)(7416002)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 23:33:02.0245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 863fdcb6-c80f-48a2-f5ed-08dad7190d24
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E640.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5907
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

