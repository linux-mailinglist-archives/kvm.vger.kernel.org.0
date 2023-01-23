Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C20B678B2B
	for <lists+kvm@lfdr.de>; Mon, 23 Jan 2023 23:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbjAWW6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Jan 2023 17:58:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjAWW6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Jan 2023 17:58:12 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2066.outbound.protection.outlook.com [40.107.243.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB8AD4EF3;
        Mon, 23 Jan 2023 14:57:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j/JnhKjCm2FZA/0L95gHCDAOE2UwyMlrXkpOI490E/IScDYZGgJevLukjLX/ks8Kt1BFKVfATn28+wFNorxomk7KRbc56hggzr9SJrjURavxBj3kKly6mZHmv7STyVX2mkffFV/4ugBM1YPw9IGpZCLyHWr6VCvb0CMxbjVwYghaTCODWU57ZCzIgn9W+m+3ppSff4LSlmXtv9yygVO0i910g1ifeNDC/3fvPBuTov/9zSCUnKDqxgDLRbPAmgvmIOqIbOlsin+GJdp8Cegfm8k4kcJCNRXJr3QnS+S3F+SY59xOKcftVYlFy+wEsRRIYC9YH23/9cHNMTHT0ZTyKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qpxlm4uEqWI7sozxahV0r65VMlPLMLdEUCMreeL+CGc=;
 b=OO+erQDieRTWPHUsKcV1m6lgi4GbJgPmo4bESHEXLdVJi99AID08kwCWQgNEdP4wW3Xh4H1MxDfY6KFfhFzgj5+wDgYMoxXlFDLU7kwfpLf/7dDmuL1kB19fHFpf3bvZ15J+5XECLOUyEMKR25kASI1d+Fx/HQ7osoJrAPXH0onqKFgvTHUYZi7/IpgimMeAfwFrLz1uRG44qt4vtJT3yl6adimATud7XIGpzh8sbls94DFFzhlDJqjyuG45vyM5vqESX7LDzHAjwcXdFku1+ZhZZ7ablahfCtIGMynAIIJXZiQOUEfNUGiw0AXQAJWbbJs9PMji5Rv/OFaD5krE8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qpxlm4uEqWI7sozxahV0r65VMlPLMLdEUCMreeL+CGc=;
 b=LKTW4MZApyYzq9Bup11UngsKJgsMdr8vZk+eO+sNtNR9VJUJWUi/h0feDnebOycA190FQSrlbnKhFqyoSWpb7PW4z2fqgzYAu0PrAZ+RB5cOa6qHOrK2cV2wIbr6KJ9rjVAPlw5c0N9Pz+GT+kQL2bhnEhRdGP5tsng64+bJ1ok=
Received: from BN9PR03CA0934.namprd03.prod.outlook.com (2603:10b6:408:108::9)
 by PH8PR12MB6697.namprd12.prod.outlook.com (2603:10b6:510:1cc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Mon, 23 Jan
 2023 22:57:40 +0000
Received: from BN8NAM11FT090.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:108:cafe::d4) by BN9PR03CA0934.outlook.office365.com
 (2603:10b6:408:108::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Mon, 23 Jan 2023 22:57:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT090.mail.protection.outlook.com (10.13.177.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6023.16 via Frontend Transport; Mon, 23 Jan 2023 22:57:39 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 23 Jan
 2023 16:57:38 -0600
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
Subject: [PATCH v8 2/8] x86/cpu, kvm: Move open-coded cpuid leaf 0x80000021 EAX bit propagation code
Date:   Mon, 23 Jan 2023 16:56:54 -0600
Message-ID: <20230123225700.2224063-3-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230123225700.2224063-1-kim.phillips@amd.com>
References: <20230123225700.2224063-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT090:EE_|PH8PR12MB6697:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f43fde1-0bed-406e-8911-08dafd953a71
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RGjviGrUq7OLr8zLPpb5Hc/PlkX0x+HimId8XPMnNrgi4DVGyGo1jb+x9eW5jOVWhEQlq6IxC6b8EvWLWRFcLIlh2K3lsvCzf+jehLR4iJEbGYrMJR1xc4Y/fPeLntqBdGDXLMOGW2torNnVniXpbIX808y2S67fUfaU4s+oZCoiPA5knPQu6imcT+HRja3tRPDC8135fkhCpqJ+ZlFwt/V7GSw5Nr9b4Ty0d5GIQ8RZJbvhmvO0iNi+TjoyMd3t38bS7SwxflgjUpIXjCMVePtF9v+i6c7CdNMfV2160XovbBoBFSoJkOr4xYDl+Sg4owGo291Qqc9DTX48SggVel6Eq07ZIjtvcAJMf3CTlMufN6JmC5KJHV45yJXkedidcqI3mQa3Xs3QWkZy/BzmJIcrWuNjGUALcLSgyaeqFkuoQyL9Q+S4tKjwf73NriEwPjqPj6/wkGZ3N6L7o7laDc71EotmxxKGy4MPoOB5c76CfrJh4ds1DQZaNkvF6vpO4etdXHcKB7SJh25ADroKHvava2gStQYBMZ5lNBYai9H3nS/UGXP5BtQWbvYA/7toK6fU5qurjk6+PgemTGaC09tNwFLZQfaNbpynPI50EiojUZ+zBFyx05lv3o+2m+/gwUBsOVWLTGoFzQHFa5NVifEDs0kG6OE6forFFSVMCmRfMUE4fK+uvKPGy9L6BdWUXVM0tKoSDoKJxhYWt5s8OqhBviITIpoGcrve6ggVpYE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(396003)(451199015)(36840700001)(46966006)(40470700004)(44832011)(5660300002)(8936002)(7416002)(8676002)(82310400005)(6916009)(70586007)(70206006)(2616005)(6666004)(2906002)(16526019)(26005)(186003)(54906003)(4326008)(36756003)(7696005)(478600001)(316002)(41300700001)(83380400001)(86362001)(40480700001)(81166007)(82740400003)(36860700001)(356005)(47076005)(40460700003)(1076003)(426003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 22:57:39.8351
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f43fde1-0bed-406e-8911-08dafd953a71
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT090.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6697
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move code from __do_cpuid_func() to kvm_set_cpu_caps() in preparation
for adding the features in their native leaf.

Also drop the bit description comments as it will be more self-
describing once the individual features are added.

Whilst there, switch to using the more efficient cpu_feature_enabled()
instead of static_cpu_has().

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kvm/cpuid.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 596061c1610e..3930452bf06e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -741,6 +741,16 @@ void kvm_set_cpu_caps(void)
 		0 /* SME */ | F(SEV) | 0 /* VM_PAGE_FLUSH */ | F(SEV_ES) |
 		F(SME_COHERENT));
 
+	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
+		BIT(0) /* NO_NESTED_DATA_BP */ | 0 /* SmmPgCfgLock */ |
+		BIT(6) /* NULL_SEL_CLR_BASE */ | 0 /* PrefetchCtlMsr */
+	);
+	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
+		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(2) /* LFENCE Always serializing */;
+	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
+		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(6) /* NULL_SEL_CLR_BASE */;
+	kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(9) /* NO_SMM_CTL_MSR */;
+
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
 		F(XSTORE) | F(XSTORE_EN) | F(XCRYPT) | F(XCRYPT_EN) |
 		F(ACE2) | F(ACE2_EN) | F(PHE) | F(PHE_EN) |
@@ -1222,25 +1232,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 		break;
 	case 0x80000021:
 		entry->ebx = entry->ecx = entry->edx = 0;
-		/*
-		 * Pass down these bits:
-		 *    EAX      0      NNDBP, Processor ignores nested data breakpoints
-		 *    EAX      2      LAS, LFENCE always serializing
-		 *    EAX      6      NSCB, Null selector clear base
-		 *
-		 * Other defined bits are for MSRs that KVM does not expose:
-		 *   EAX      3      SPCL, SMM page configuration lock
-		 *   EAX      13     PCMSR, Prefetch control MSR
-		 *
-		 * KVM doesn't support SMM_CTL.
-		 *   EAX       9     SMM_CTL MSR is not supported
-		 */
-		entry->eax &= BIT(0) | BIT(2) | BIT(6);
-		entry->eax |= BIT(9);
-		if (static_cpu_has(X86_FEATURE_LFENCE_RDTSC))
-			entry->eax |= BIT(2);
-		if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
-			entry->eax |= BIT(6);
+		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
 		break;
 	/*Add support for Centaur's CPUID instruction*/
 	case 0xC0000000:
-- 
2.34.1

