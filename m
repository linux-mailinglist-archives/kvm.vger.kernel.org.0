Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCEB666D27C
	for <lists+kvm@lfdr.de>; Tue, 17 Jan 2023 00:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbjAPXD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Jan 2023 18:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235158AbjAPXDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Jan 2023 18:03:31 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C002BEF4;
        Mon, 16 Jan 2023 15:03:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/W3b9p/DItkAEp7JjpoCTy9FNQadHL+EI/7+7PWmaXaj7VV/Vsb99Ppy1vCEeP5CD8AOw4P54o2h17s+q3HsaCfpiTqRV0SR9Q29PsWLqhPIGjNcQK/9kHSTWki+8Srsda54n+OZzoeDHt6LINAnGJc+uKPyWygI0d0bPPYE2JdPy6CBOlP0X6TsTfqVFJe0MjBBwTx4d4+Yoew7JsVh7g4f/uvRijWpExMpLaChQ73I6F8fMBn9kv4AZuy92pCkhvMcCqIB1dvvjMAuMZ/p7UlQvexmb5nLYZUKa4VwWF7bFsfdtny2b6vlr0jeUDFhWQ1TavcRoInPQHnQ0Zh3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tLU7HuCJoBX+sMS1t4wfIiOZHd/yAMuM3geIm8ZqEEQ=;
 b=gd/8j/tuNg5OApb58jdbVkWkzkH6kkDYU93yyLuO41POQ0s1fyZO36zqb5/nhPHqZiZi2nQVRLHhaJ5uOyUjt4kSxh+7cvBOaprQ/jfjAblJmv7mklRDFvKacXtuTc6Zii6+zZWHGYzy5uyk+oPpcdpkItAAetJeQp5DaR4lblK8VuqiZ8Kogj1uYVYF9em6UAHmyqen442OD2yHgDH1Zz+4WfcWLhneXE/qI6ywcD8eqQsWIAjioHvP9gVXY1q4PKeQ/Dr7uSnxdzj07vDrqgEdgXVv/qZShPJZd0d/TTXaNxslxA6tbDK6tixXoZyHTETXZPejvMqZlzIdAglkkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tLU7HuCJoBX+sMS1t4wfIiOZHd/yAMuM3geIm8ZqEEQ=;
 b=DYY6B7Y7x+hQy9ALmM4cgsBEO1Oa4vJ5j1msgRnFFdGRyt21A81HJ3Ue6UMoLOoSZwMPuyvUB7eXzCnmvlmUl3yo0sy1CHuFl+9Z3JqBts0/NAuiD6PTm0f/uXVCWSel7apx4fQZjmB+2h6d1NfDnqw+TPU0Ju5euu0AkJVHEcA=
Received: from DM6PR21CA0011.namprd21.prod.outlook.com (2603:10b6:5:174::21)
 by MN0PR12MB6150.namprd12.prod.outlook.com (2603:10b6:208:3c6::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Mon, 16 Jan
 2023 23:03:01 +0000
Received: from DS1PEPF0000B07A.namprd05.prod.outlook.com
 (2603:10b6:5:174:cafe::7a) by DM6PR21CA0011.outlook.office365.com
 (2603:10b6:5:174::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.1 via Frontend
 Transport; Mon, 16 Jan 2023 23:03:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000B07A.mail.protection.outlook.com (10.167.17.11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.11 via Frontend Transport; Mon, 16 Jan 2023 23:03:01 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 16 Jan
 2023 17:03:00 -0600
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
Subject: [PATCH v7 4/7] x86/cpu, kvm: Add the Null Selector Clears Base feature
Date:   Mon, 16 Jan 2023 17:01:56 -0600
Message-ID: <20230116230159.1511393-5-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000B07A:EE_|MN0PR12MB6150:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c167d6d-804d-476b-17c4-08daf815d15b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x6tfkbFo9j1M1kTkgM9OJFThoid7IwTJLyfsuZ5mKzTB4dOphDxXVPZTxCNggYQLZr6ptxrDVn4mN90Iq9qnVoeIzSfMYZavk2IvkzH7PiLdRx1Y89zi8DD6ushIMGEYd/HIKMCJllK6avWFx86t1iDqna46LlfyQAadbbXbFM8QTzPH/bx9sYUFdFIo76Gc9QWZqXCiolsnfP5FLWzEwGdgLcH6B08icqNLAFRPpnqzOnozVkMVXmKtAT0NMijQoGcU1anSTa28Ntl8UaSwACvCNQHvKS+rHvYEc8pRG25wbeHjZLvyG+I7lO7Q+9I78cEAD9zAN/cgmB9LXLnE7pa/QHYM34vgEGpoF/gCRF0QIqHMg04QYJhllS2if1K3BGhf8oPBDbAObvQcTKpXdsXIcMlpkZ3z26YraG1OUrpFNiMwcsw+eHJ69H83xNrLf7gft0aeLKoVEFhv5d9RMk+QJ1M3CdvaaiVqylpzxKIYvD6LrM739nohgAiAkqBUh1yBC2x0hlSIdRhydboYcDlQ3zw7Ouu94/5EuS9zncFmTZZdA4OS9bOxTkMOR1wxV5cIyk0nO/vjqsIbGAuR1W2NPCTopfP9iRiml6zimIPKRYLTNPQzFjMZVwgfxyoAxJ7tG1PGisrOU+6uQUPw9ubxPxgY08jz1Dy4jH5Gv5saCTuzb0q48NVzGLBOoDtWkZ8UZZkC7x+jbjUcGi+GuxqKoFisFV30UACp3LM6s3U=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199015)(36840700001)(46966006)(40470700004)(316002)(54906003)(6916009)(8936002)(5660300002)(7416002)(83380400001)(70206006)(4326008)(70586007)(36756003)(8676002)(41300700001)(356005)(426003)(47076005)(81166007)(336012)(2616005)(1076003)(82740400003)(40460700003)(36860700001)(7696005)(86362001)(40480700001)(26005)(186003)(82310400005)(6666004)(16526019)(478600001)(2906002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2023 23:03:01.5974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c167d6d-804d-476b-17c4-08daf815d15b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000B07A.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6150
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Null Selector Clears Base feature was being open-coded for KVM in
__do_cpuid_func().  Add it to its newly added CPUID leaf 0x80000021 EAX
proper, and propagate it in kvm_set_cpu_caps() instead.

Also drop the bit description comments now it's more self-describing.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h |  1 +
 arch/x86/kvm/cpuid.c               | 10 +++-------
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index b22b2e8fef00..ccef41ff718c 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -431,6 +431,7 @@
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" AMD No Nested Data Breakpoints */
 #define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
+#define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* "" AMD Null Selector Clears Base */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d7a13716b7c8..afa86241f752 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -742,10 +742,12 @@ void kvm_set_cpu_caps(void)
 		F(SME_COHERENT));
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
-		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC)
+		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | F(NULL_SEL_CLR_BASE)
 	);
 	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
 		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
+	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
+		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
 
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
@@ -1230,9 +1232,6 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		entry->ebx = entry->ecx = entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
 		/*
-		 * Pass down these bits:
-		 *    EAX      6      NSCB, Null selector clear base
-		 *
 		 * Other defined bits are for MSRs that KVM does not expose:
 		 *   EAX      3      SPCL, SMM page configuration lock
 		 *   EAX      13     PCMSR, Prefetch control MSR
@@ -1240,10 +1239,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		 * KVM doesn't support SMM_CTL.
 		 *   EAX       9     SMM_CTL MSR is not supported
 		 */
-		entry->eax &= BIT(6);
 		entry->eax |= BIT(9);
-		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
-			entry->eax |= BIT(6);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
-- 
2.34.1

