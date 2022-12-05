Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F99E643989
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 00:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232589AbiLEXdn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 18:33:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231149AbiLEXd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 18:33:29 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73E06548;
        Mon,  5 Dec 2022 15:33:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FDxxQULwNYLPGXiJzKhQ4fcTLOmicpwgdT51Zf04tm8RoxnC2oj7ZhpirOn0u2E5hrTrNsxaaDTAREP80BrDFSdrU478KQe71nTc+WdhB0EzkKxXplHHyAddwpHvBel1VPIW6sSaej4BDxHbtc+2LgL4aW4f6Kj61XS7D0kbDPqdUUiHw+8r3jFDIkegvtJ20a3eT5539aBGexwjKBJCJOCvp26xJaJrWZNnjdjwyOPsmLHg8GqWKP4xmsSytIcLvLT+MbELYB6+y8gHfDmXilFWO62knhdjMx+28dCTQyLy0dm6rF9YzU1I+7GDnHvlO/Uz4sqEroOicXt/z5+oGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D/PsyeRWEKYEJPwiKh3YYzfXYqYgLnYeN7PeRh5njPs=;
 b=MiHSPb+BZyzY2BYy0c+q1NM5aRvCYtfFZmvkWCP1kWbG4+glP/Dx7tEywfshynnNlGqNeivADHmMoZd6vz/CceAeMF9WQbfN41ZP0khdDltoGqvPmVwDe7f6IQ1gka0W/aWAiRhotuA8ORF+V4lZ3sTYFSd0tZVd03LswIIXl+AvhpgKPshHAVXiS0Uv9zOau2zGs3iVr0Txs9Q5/r1Ot/PVN07oakylpJu1QQPTFFeo6KGyllAdA6UYwxhW8P00Mhz5aAQSnl59XCUa6FGY7J8FzrEXL3OnU9nUfXcTjv/EcTR0rntwil5JCQPXLyySfkp3fHa0WzSrWqc0Y5o9eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/PsyeRWEKYEJPwiKh3YYzfXYqYgLnYeN7PeRh5njPs=;
 b=NYbBPINUmTysOSsQ1SPMeeotiWVt95snEwNKNQvei/gt/Zz61NxthjXzqJGzbQATTmkBDXRVMlN+OVV6jqhqMUTmvDGALt5vHtblJQ2SpL9b4ZJKzOMTV8mkKgkhtJdTvsy8ycPSJBA2DyVVUAY5vpyYUNWtA4RzWP3J9V5WgTY=
Received: from DS7PR03CA0307.namprd03.prod.outlook.com (2603:10b6:8:2b::13) by
 SJ0PR12MB8113.namprd12.prod.outlook.com (2603:10b6:a03:4e0::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Mon, 5 Dec
 2022 23:33:26 +0000
Received: from DS1PEPF0000E643.namprd02.prod.outlook.com
 (2603:10b6:8:2b:cafe::12) by DS7PR03CA0307.outlook.office365.com
 (2603:10b6:8:2b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Mon, 5 Dec 2022 23:33:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E643.mail.protection.outlook.com (10.167.17.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Mon, 5 Dec 2022 23:33:25 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Dec
 2022 17:33:24 -0600
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
Subject: [PATCH v5 3/7] x86/cpu: Make X86_FEATURE_LFENCE_RDTSC a scattered feature bit
Date:   Mon, 5 Dec 2022 17:32:31 -0600
Message-ID: <20221205233235.622491-4-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E643:EE_|SJ0PR12MB8113:EE_
X-MS-Office365-Filtering-Correlation-Id: 3efab710-16c3-4f79-6cb8-08dad7191b46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DgDTpTa7WdpDLcuEzS7mUiV0G8FGCodnUoK57m3wZ4xW/4aEaLJE20kGDUdaToZokVtbZKvLzWP2SAHNcXqpp36WltxZwOgDX65oapU7eBC/s3TCSbU8V3mdrkhhnGSl9dPdmH1+3riL29KRDPIERlDnXVSKaZglPdn8qz7M6Hn8UUPBoltvEuYnLPRCGqN0RPC9yfYn8JrKPpNGOORoVPxxfVX5dy2rdglgIWGDPOZ8aeltYwD7fahMrZ7Gvhb/ZX291Gpo77ofRFrUc+skRhbIfq23rRWZsTT7g5ogLC3IWIwU67ltob7q450H5nD+L5GwR/AYURULXDC7WC6jErTx2QBNaYF3nASE4puu27O+VL/ykyVDYaOtME1Pi14q8dnEkwitiSzALGaRJvWBasFKN94JKnd1tUxctfF5feV42kq4FEOQKqGJY7O67s0kZVJXtkpR0IDBDh73oII9MPOnqGsmFBGFc9lK8I+fYSBMWTt0KrNCQS305Bcy1OWWp/VcZWOgg/kXAf8n4A6XK+HD4+bMIy6113PHgEbU8uCrRsK75vV9zrZc7aaEOZM3dohT8dL40lMkKLSLBsWr7E3GwF8YtUWH1plg+RBxor/wE5HYDXhMZcM9z/fQaFc3p44co5zlIxQTc+pplA3v0sAgQC3OYsVOIS/LhaYRYz8TxcjqOoC3R8eDf8NbitZH+pZ+CiDP4SQj5csEQsM2RWW3+DQkJVGfDv5E7U/7WVk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199015)(40470700004)(46966006)(36840700001)(36756003)(86362001)(4326008)(82740400003)(70586007)(2906002)(8936002)(70206006)(81166007)(478600001)(44832011)(8676002)(7416002)(356005)(36860700001)(40460700003)(336012)(2616005)(316002)(6916009)(41300700001)(186003)(426003)(1076003)(54906003)(16526019)(47076005)(40480700001)(82310400005)(5660300002)(6666004)(26005)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 23:33:25.7319
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3efab710-16c3-4f79-6cb8-08dad7191b46
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E643.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8113
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

Unlike the other CPUID 0x80000021 EAX feature bits,
X86_FEATURE_LFENCE_RDTSC already had an entry in cpufeatures.h.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kernel/cpu/scattered.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index d0734cc19d37..caa03466cd9e 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -46,6 +46,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PROC_FEEDBACK,    CPUID_EDX, 11, 0x80000007, 0 },
 	{ X86_FEATURE_MBA,		CPUID_EBX,  6, 0x80000008, 0 },
 	{ X86_FEATURE_NO_NESTED_DATA_BP,CPUID_EAX,  0, 0x80000021, 0 },
+	{ X86_FEATURE_LFENCE_RDTSC,	CPUID_EAX,  2, 0x80000021, 0 },
 	{ X86_FEATURE_NULL_SEL_CLR_BASE,CPUID_EAX,  6, 0x80000021, 0 },
 	{ X86_FEATURE_PERFMON_V2,	CPUID_EAX,  0, 0x80000022, 0 },
 	{ X86_FEATURE_AMD_LBR_V2,	CPUID_EAX,  1, 0x80000022, 0 },
-- 
2.34.1

