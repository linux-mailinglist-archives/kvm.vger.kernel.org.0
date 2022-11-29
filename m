Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A24263CC12
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 00:59:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbiK2X73 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Nov 2022 18:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiK2X7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Nov 2022 18:59:21 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2051.outbound.protection.outlook.com [40.107.223.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 939676F35B;
        Tue, 29 Nov 2022 15:59:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i+ao8IwiYhRb1lsl3S4S4afZv7id7xgDE9jDjOWF6ezZ3Zrw2Mgiy4iXA3ghA8dWlTdqrYoDBajlFvctOP5a70t4hYReqQamcJGvb/LBV9yflAPmXydMwNb0/Pxc7riWjeimgJ04Ueypl1Pu5Kp9/C5N+PH0JQVFdOMZGuaBT/zo7jqCD3WKy1agScUAN3pHQCw47hR3Fle0TuYsnqT+0p8BL/oRag1axcvD6DRhkprtPvslKgktZ60qWRXGauoXvGpZTxQpP41ZBe59cLkxOPZprbyUZCtYCt9f0HdEfou2Wmj++ur6jM73qbYzItADnUKyrsDEsozpzawkw0rjAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nMesUoH8kGFotcuGaOijJiorBejNzqio1mI5w5aNIKI=;
 b=d1MaQHqF3UKLny+qJtZyBWct2LiPPe+3aWtA6R7gMlmPNHAxfxz22+XJtYHnzEB4n7MhG3L6bgkCN62OhGcpfbJxsKQJvX7MpBZFNbNWB7ucV2xlmKRAZFKbdv1a2nk0TGVgKt3hjxx0SJjkjnTpF8QwHx6Z7DosjrWBnX0BoNnHkp6e8Ly0gI6a5KN14YUoAzO5OZK8iCt+lUxyN/CiamtVuPjr3arJBd2e1JM4H0oZvTD3mhg9ckBFAHLvU+67IxLuT2H53OJfMAANP15286lheGUXQ/Uwf7SZ8CECbcRf7vIUayi0yx891Kvxa/MP92S8pLnCY4/1QO+1KJgejw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMesUoH8kGFotcuGaOijJiorBejNzqio1mI5w5aNIKI=;
 b=QvlnlItDAqX68u8ewam+kPCD7OsQwquPCkaaHXuv6ah6ci3zMIvz4HfMLZCGUFIIRBHuEYUntRysnCE4XqiLrjSweDZScvKsEDQ+JY3XsWPuXPkkqMpvX03KEjkc7znB546NLz3UDJ3ZFX/dNwsWR052Ei9vON3HAIVZd/turag=
Received: from DM6PR11CA0017.namprd11.prod.outlook.com (2603:10b6:5:190::30)
 by CY5PR12MB6382.namprd12.prod.outlook.com (2603:10b6:930:3e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Tue, 29 Nov
 2022 23:59:08 +0000
Received: from DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:190:cafe::27) by DM6PR11CA0017.outlook.office365.com
 (2603:10b6:5:190::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Tue, 29 Nov 2022 23:59:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT033.mail.protection.outlook.com (10.13.172.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5857.20 via Frontend Transport; Tue, 29 Nov 2022 23:59:08 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 29 Nov
 2022 17:59:06 -0600
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
Subject: [PATCH v3 3/7] x86/cpu, kvm: Make X86_FEATURE_LFENCE_RDTSC a scattered feature bit
Date:   Tue, 29 Nov 2022 17:58:12 -0600
Message-ID: <20221129235816.188737-4-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT033:EE_|CY5PR12MB6382:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b284d98-dcdf-4fcc-7eae-08dad265b44f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6SUnmB80h9cyVNEHmNbwK67Ok1GsJCeGWY8S8RNiBgBLfiqRvOwGa/X4VRkeJFPEWjRKy3cKiiI77YvyuXG9mmeFsP7l0Mn4oQu8WZuC724iH8Vn/cUHOfA13lnGAjlGdAUZN/j9/KhVLtWTYlGllgD1gb99YuSsJkeBdtPTRT5AlZmcuvO1TeizKUO3auUSoN9t8Jlitr8I9/z/cMLb+MTcvagdFEjjMoqK0/TAfRNxoQt20n03nRxOR6xRkmNnLf5YrtEUsC4+8MfNi9kn/qR6uEinBROsQVuucmG1HCrB6kSyxN2apgeN7MKs4Ifrg7DF70/GGnMJl36DFaLK2eDURqfjP/4H6kc3U7XsWJbKXxNryym+6M5T9vjsfhXw2fCGvLQS7lbTAbmy3rPW1guXmvtTfmdIVnrA+vrpDe9Zg8BE4Ye7KFBRK2bfL07J/hQEDQda9bQBenJTDhqkx/q96KPOvLBAcB5Sz/kYD9lj07RdcksyY3tajhrrXVqGz7g0uJ2hOfR472QHMbrba+QwTrBesoTdZMWLphVp336cGkIFl5etpfGnV/reK83dhBAM1r+x/KRZMB5CvySEKVruMFSxqWRs3AKt6yubxMH+RCEsb/5PJ5DD4qyvN13/LJNeqnflEDonelyMIW7fuAu5lc/8xB8OgW6wiZJOlSJJq/pltKKnCJKBTdZ+jHdhDV+Q0yIqzulec+SU+46yzMrAJxQxT+MRU8oSMbqK11I=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(376002)(346002)(451199015)(40470700004)(36840700001)(46966006)(44832011)(40460700003)(70586007)(478600001)(86362001)(81166007)(356005)(36756003)(40480700001)(82740400003)(16526019)(36860700001)(2616005)(336012)(186003)(426003)(1076003)(47076005)(4326008)(41300700001)(6916009)(6666004)(316002)(8936002)(7416002)(26005)(8676002)(70206006)(2906002)(7696005)(54906003)(82310400005)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2022 23:59:08.3266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b284d98-dcdf-4fcc-7eae-08dad265b44f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT033.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6382
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

