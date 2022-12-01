Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3037063E74A
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 02:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiLABvF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 20:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbiLABu6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 20:50:58 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2051.outbound.protection.outlook.com [40.107.237.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C1489802E;
        Wed, 30 Nov 2022 17:50:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mq4cA8MlnTOCjdLj8PocxzX0t0Xj/3Al0JCGN5+TKQNlYppdO8KU2jue3RXicfYfERwYzq5/XnVdBYjSdYxpxClyRHM+oz10vPwbF8G0aPgWOHP5bSbRS7Tb2OEyJV6QJb6H3DaQ7M6pM5uj6JaTRj32rvY6WyXlJ7vyVLSTl6/3plOcet5jfdM7mZo8VdwMtJddub/RfbKplv7U+2bv5hTokiQb20CkLjlRwc4nJIc6D1+6LH4UkC5wnFTMMN1M3vvVjOfkXNUo5Hs85/VHP7jVgk5w0BIJhMRN6y9CKMIyOcYZMPfPfXGSDaOnT9OieTtLwkkmEVEMREju7diUAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=30CI6/Z+JHcW+AqhKQWtRpUMNnWwm4nj/Hsi3VKx3X4=;
 b=CC3SAJSI7B+w6k0U5KCx8w3EgNDZ6GZKktrkXed3ZQt11lIulqP9SRC5JWxzqJf1IovQMtkmNE/AY2trV3yXbM71fVvDLhzaOFKVx/3rAmCZmvYqCyh4dm+oXvVVHyhPQSqybvPc6MdQoM4ubA4+0BhNoreOI94Z7dYtdlkyUvv5dqOKl2XMnl8xuHQB5LnotzvePmVvi58ZEp78nPcsxAQI9ePi7MmMasllx+uFIkD5anReQsoPugi3QUSepVvHMGNuIE6W3SIMU0564t8QcSVfflzd7/cY6uJXNLqvM9GXxag6IK2ClyMBAEDNwnJ77aboPy4Cpa3w8NW7tliL0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=30CI6/Z+JHcW+AqhKQWtRpUMNnWwm4nj/Hsi3VKx3X4=;
 b=cVpmgREhKEKzafUBXvki78Y6CNOw29NhpnyhVhzjqHeIz9irbGbmPlf8wfIawnoaVM2nPL7Xl5w9GK6bmPU2zqWWW8F9fGMUGVUQ/C0dP9gD/2plLFSV5rU7HrkH5b9Zo5WkT0WzDGyWNHrBjGsyrk59DMjuM8V9uH9tDWXvxyc=
Received: from MN2PR07CA0001.namprd07.prod.outlook.com (2603:10b6:208:1a0::11)
 by DM4PR12MB7576.namprd12.prod.outlook.com (2603:10b6:8:10c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Thu, 1 Dec
 2022 01:50:54 +0000
Received: from BL02EPF0000EE3C.namprd05.prod.outlook.com
 (2603:10b6:208:1a0:cafe::69) by MN2PR07CA0001.outlook.office365.com
 (2603:10b6:208:1a0::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Thu, 1 Dec 2022 01:50:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0000EE3C.mail.protection.outlook.com (10.167.241.132) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Thu, 1 Dec 2022 01:50:54 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 30 Nov
 2022 19:50:52 -0600
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
Subject: [PATCH v4 3/7] x86/cpu: Make X86_FEATURE_LFENCE_RDTSC a scattered feature bit
Date:   Wed, 30 Nov 2022 19:49:59 -0600
Message-ID: <20221201015003.295769-4-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0000EE3C:EE_|DM4PR12MB7576:EE_
X-MS-Office365-Filtering-Correlation-Id: f9945591-f67b-4183-0428-08dad33e7b98
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xyTsVFCF/iCTtmYsxAw2anKuNSh9qaMzoZkyV2X9hsEP8XA3rVUVW9XiBEiBv84ZQAqPzw1rGp1+nP8wxHZSVzRgSmInt1W5byOu/whs5rR/sq8Zr8aqXUvwBH5fy1pzLebReJW2Q002NVPE7Trz6eYcjThG7FrziEYfKkViBiAmrQL8erwsRTSsgR3Kc38rE+z5E/uw+dCdEMKPmy8b8kSND2odSbuWWSC++or52wtLhG95SlRhtKocPfgd3Izpsmle9RIRYmteUABSNrlOkXO6mB42w9lwUgKDa2Er9hpX3mEsb7jaKPLLT59JQ9wfeeOAEwYmRay0HKpVBaGQUrlGRs1oneHT2OdzmYR2duGrx2Lpknq3xu+KSgu+DBUQKFEXSYJ9I32eHeC/d9vbmJ4T1gDHADO+4fDBzmWPxlRzAqcYA/ql1hBbUlbggtG/UJfaECK3NsSBZ7xjadAiBMFXWJubKSpWZ/PFHXuIGNadBzo1PjCPYdU6bVoDHbgSv/u/QnGnx1rgtIDlvo221OIG3JIDjpyBP/HbOUsER2tzRALeNcrnLIPXfe+LoJ4er+rEM6l4jhIVn5+su49rFkj3eRd7F5nESyvVwj/O1a1y2cziwEag5zJUO2KVLOcGBC8MCzdD5q7cyU3eArat5jFyQagbrbPRvPgucZMpfPdx8veJDl6QOvViqjPJssTfUo52GmVAZ/bg4YtFaOn8V+OC6BA7FmdC1UVDXwi8AQ0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(451199015)(40470700004)(36840700001)(46966006)(70586007)(186003)(5660300002)(8936002)(86362001)(36756003)(4326008)(26005)(54906003)(8676002)(36860700001)(316002)(40460700003)(356005)(40480700001)(82740400003)(426003)(81166007)(47076005)(82310400005)(2616005)(7416002)(70206006)(1076003)(336012)(41300700001)(16526019)(478600001)(7696005)(6916009)(2906002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 01:50:54.0714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9945591-f67b-4183-0428-08dad33e7b98
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0000EE3C.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7576
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

