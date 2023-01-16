Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A60EB66D27F
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 00:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbjAPXE1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 18:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235195AbjAPXD6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 18:03:58 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2040.outbound.protection.outlook.com [40.107.100.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D3E2CC67;
        Mon, 16 Jan 2023 15:03:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iFzHZlnAetOfR7JF7wV25wQjCm/HsRE6LVKSSwZAlmGLsqxDbIdONoLYLUBCDguoHzensCRMe9eDckwD0K55ukNIDfylphQhriPVHQdP0jGHqA/VDGRJcSYq+i2dQb9uMEVKYAeNYbq6q72MTAA4k6Rl83jhxcgAddnmG6Yp1PI6WuvGd3kgv8Biu0MaKz6d8pnh0tAnPMQHB4hZ1PZTlRL8IVSkanMZjR5X3iU0TVB1vgjrWAPjmOmwZxQLbhtn6zYsth4KCyn7N3JC0/xn8dYl4nfruMffgXMOO/nSe+blZsJOF3WkF2PcnZpjXe/z1XQN0hOLC0YQ75BRkKVuFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9KWsTNplYTpILEMulgN18T4palnqcILNY9fxQUxuV+8=;
 b=GAFXpt+7KHZs99GGVJ1l1KHJ/eWyO2b6BUY7tRsz1Ml16WdTkVYTuz8YqbCP1pkHMJsH6EziKUH59w8wHtij5Gxqs6N6NDxOkFpc/f2LEFH3N81BFhTpeN/hB3Pb/Yc4o4zttnsbkI3X+x+5z1SGSUdP5KKs1zXyJQJb45dy5T/MLQa67qeLT8HDEspbxpds9Ph322hjGrIaX1Cv1mcrM8KtSCSOq8Yia7+ZBrxp2bxA1fvD2LyqM6UHygAhP6z6bsrCSTjf8GE68+YP9JthLrWDZRembyhmu4wWx/gubJoJzLRd2dqxd1c6srHKPH6ojM9/+BaQp12NB/mdS/aRXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9KWsTNplYTpILEMulgN18T4palnqcILNY9fxQUxuV+8=;
 b=P2Carluerype1anrl8fs+BIyi+wPwX/WkYF3ELtt/TWY2JZ/I8SVPZol6QCgWNiOm+26PeU7NYisP8xwe/DSZr8lZJ0NtYjv1wWbLwMOpei+feT29TuM6WGEQmRpACWaTkKpHZl5UzpP6uHDda4hBblVk9lFMa5dTj8eGKSG17A=
Received: from DS7PR03CA0017.namprd03.prod.outlook.com (2603:10b6:5:3b8::22)
 by PH8PR12MB7279.namprd12.prod.outlook.com (2603:10b6:510:221::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.21; Mon, 16 Jan
 2023 23:03:13 +0000
Received: from DS1PEPF0000B074.namprd05.prod.outlook.com
 (2603:10b6:5:3b8:cafe::cf) by DS7PR03CA0017.outlook.office365.com
 (2603:10b6:5:3b8::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.19 via Frontend
 Transport; Mon, 16 Jan 2023 23:03:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000B074.mail.protection.outlook.com (10.167.17.5) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Mon, 16 Jan 2023 23:03:13 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 16 Jan
 2023 17:03:11 -0600
From:   Kim Phillips <kim.phillips@amd.com>
To:     <x86@kernel.org>
CC:     Kim Phillips <kim.phillips@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "Alexey Kardashevskiy" <aik@amd.com>, <kvm@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v7 5/7] x86/cpu, kvm: Add the SMM_CTL MSR not present feature
Date:   Mon, 16 Jan 2023 17:01:57 -0600
Message-ID: <20230116230159.1511393-6-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230116230159.1511393-1-kim.phillips@amd.com>
References: <20230116230159.1511393-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B074:EE_|PH8PR12MB7279:EE_
X-MS-Office365-Filtering-Correlation-Id: 23e84c55-9cc9-4ca9-5ae2-08daf815d853
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4EQlhAM+JVXNigzOusH78Zyg0+8INA+7CO6e3yGv5hRhncBw9lJYvd1oTWx+XvWiDpyEhBSnje+kP9JPJBrzQuRP/IwShvltF+UMgmfr8pv0qqaAh8G2F30zZsYK3LjLLUtIeHR4aaW1ztvPUvVylAD4X5/Eb1RmtljIEYd3h0NbSFrEbk6QOAIyieSQvd1Yhl6q7DVwiAcWGPYSE+FnnlWUpjGUfVzxB7ot4CyWeI06YRBErsOwZsgknpV3pdlYs/XgQJDoxMVfRAPckrphWREFeBhxfNoT0b5mD4jXfOpGHHQAhiuM0tJZClax7/zs+uVPHpBL8PVGO33jpsSMgO2ksTUgEwB4mQj8BemYKOdV3hsHsuWDqu40P+ssPIzZuf+BEShPiYIOvgcP95wgz8WjHKW+9N+HL0MhlAQCV8Rl+/g1zwAIdj8393s0WoIPM0sbOTw8KRTWpdysOumg3mSpftHSZtPgT+NW4zbXq3b4LE+YYA1WTkN+QC/k6I1QIWGbpoCTYHCwVJAdvZFYmXrz3zqk+9iThV67P4IXWZxeuYPNV0HuyLWHVNRxpgLV4DzAvIjHJDXHnG9n+xaLRZgWDKwjPU9GOUeihhe6Q250AJvuAuj6fWw3QupA/MLoEAhuxFT3UMX2ZrDg5usdN3QoRqnSs3mKI1gGUwrO6ptu0v7Qnji+9K5u/CjRePaGxZrn0eZgnbCSXSDRZIJcPhxAdvnaBH1AvvOzfGeVro4=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(36756003)(81166007)(40480700001)(356005)(40460700003)(316002)(8676002)(8936002)(54906003)(4326008)(44832011)(5660300002)(41300700001)(70206006)(6916009)(7416002)(70586007)(26005)(186003)(16526019)(86362001)(426003)(336012)(47076005)(7696005)(2616005)(83380400001)(478600001)(1076003)(6666004)(82310400005)(2906002)(82740400003)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 23:03:13.2908
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 23e84c55-9cc9-4ca9-5ae2-08daf815d853
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B074.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7279
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SMM_CTL MSR not present feature was being open-coded for KVM in
__do_cpuid_func().  Add it to its newly added CPUID leaf 0x80000021 EAX
proper, and propagate it in kvm_set_cpu_caps() instead.

Also drop the bit description comments now the code is more
self-describing, and retain the SmmPgCfgLock and PrefetchCtlMsr feature
bit comments at the kvm_cpu_cap_mask() callsite.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kvm/cpuid.c               | 13 +++----------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index ccef41ff718c..861d312c7955 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -432,6 +432,7 @@
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" AMD No Nested Data Breakpoints */
 #define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
 #define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* "" AMD Null Selector Clears Base */
+#define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* "" AMD SMM_CTL MSR is not present */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index afa86241f752..9ba75ad9d976 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -742,12 +742,14 @@ void kvm_set_cpu_caps(void)
 		F(SME_COHERENT));
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
-		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | F(NULL_SEL_CLR_BASE)
+		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
+		F(NULL_SEL_CLR_BASE) | 0 /* PrefetchCtlMsr */
 	);
 	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
 		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
 	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
+	kvm_cpu_cap_set(X86_FEATURE_NO_SMM_CTL_MSR);
 
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
@@ -1231,15 +1233,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 	case 0x80000021:
 		entry->ebx = entry->ecx = entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
-		/*
-		 * Other defined bits are for MSRs that KVM does not expose:
-		 *   EAX      3      SPCL, SMM page configuration lock
-		 *   EAX      13     PCMSR, Prefetch control MSR
-		 *
-		 * KVM doesn't support SMM_CTL.
-		 *   EAX       9     SMM_CTL MSR is not supported
-		 */
-		entry->eax |= BIT(9);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
-- 
2.34.1

