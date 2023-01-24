Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0130679EC4
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234376AbjAXQfP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234371AbjAXQfL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:35:11 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2048.outbound.protection.outlook.com [40.107.93.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E584743F;
        Tue, 24 Jan 2023 08:34:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BjjuPMh37AGEW1L/BTMZmRPuxuvsIM5aU6Cwcr7vEelmRNYj6XDHrb3JY4v9cbgI/cAa0JQlam2F/DUl7WIGyEuy0vG2R4TgE1SB6Z15v4i0NQUTEAaDXXYYerPn9VxI1Sr6xL2JN5IkJn6dWlOgY369A7JLSrVKL4B8wQnlsr1cOJe8MsLiXUEnuncB67iPM5O5KhemvjP+h8i+bm+nakXV+J7D1UUqwm0hZPtNPny9eD9LKq72W9eunQRKC4ALJUroNZHcc1T5g9W42oOkZZjmkaX/7AL0QYJIUPNUbdXzIwvgsYYtNZl+AWY93RG54mCw3y31yCh4G4r+MFM1BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JHz2VoCROOyIzwsAcGGthYNYjnPqPZZuD4o7FeOwosY=;
 b=dyGiM0LzW2i4F1ndqG2wFS9b2Keqpi0+i9VU0A5dP6+e/7JwZnXWoJn6wDZ96MC8ZCeGiYqqfK3zcjt4TiYlt306fVkUxUZeP3auYQPrlytWLjhRgGUGhCdkhe9gIjPePG5G0TEj/Z2T/Ls5NgOdjmUT8jtUKsP0YMX1hUaj78jBhyHza/y/HRTRq5zf2/9Lmf0WWcyuVyrMeaCs4t8BKMdwhi88LWOgsVLCwUbv9h638UNyji1xqy/sT51wR1tQRpqouG/T3q9vMQij7lH9ukQMRsOp8S95EmxJXq3R7Us+mLqoiii6slQhhMwPi6maX4DKDRBxkk9zXocsXaN1XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JHz2VoCROOyIzwsAcGGthYNYjnPqPZZuD4o7FeOwosY=;
 b=Fgn6d3pCg4U3FYxTenAusUwFNVjnAGlY6G5XdrExap4JhPE00pSBz5+akopVwRPsjKBX2YvgLoCPZYBr/yb2Z2ledL1xj8wzOjKYHJzBpR0PHDKYnfxm7wjHGWAb8Ujoquq9qnX/pb0DVYnws4G7tI6a/9bKNS0LnTSWSuJvhqQ=
Received: from BN8PR15CA0001.namprd15.prod.outlook.com (2603:10b6:408:c0::14)
 by CY8PR12MB7684.namprd12.prod.outlook.com (2603:10b6:930:87::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 16:34:43 +0000
Received: from BN8NAM11FT100.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::29) by BN8PR15CA0001.outlook.office365.com
 (2603:10b6:408:c0::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17 via Frontend
 Transport; Tue, 24 Jan 2023 16:34:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT100.mail.protection.outlook.com (10.13.177.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6002.13 via Frontend Transport; Tue, 24 Jan 2023 16:34:42 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 10:34:41 -0600
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
Subject: [PATCH v9 5/8] x86/cpu, kvm: Add the Null Selector Clears Base feature
Date:   Tue, 24 Jan 2023 10:33:16 -0600
Message-ID: <20230124163319.2277355-6-kim.phillips@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124163319.2277355-1-kim.phillips@amd.com>
References: <20230124163319.2277355-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT100:EE_|CY8PR12MB7684:EE_
X-MS-Office365-Filtering-Correlation-Id: b1673429-a5ae-4a6c-9db6-08dafe28e56f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7lYurIoC71GEojUnU83MOz02KUDQd7bWc8JtC6pODbExhmr5HJGlb0UmqDsy8NNJDUnIcdmCXHuwXVX9x1QaGYPKTPI21NVrVyazyPRMKOiYoGV5KF1/9g0SQGG5TMKwtg3yv8xVW8Gl6ByDzfT3S7l6nc3WS9DjpBNGPSAdpWFBJKKbMpD4Nngh6yl//+kA+BL/+wv+oTTzVjGWUExKNbKZbC91fqaVyYNfxURovEVyPUIxHD+1+TnOgbsRlkLx7iEHM8PCNInqKxwz5ohA0ryv/YQcmcaVAsGO0ZlGeOB3XQIopobCgm8rAR8fac3OcICOAu4Vsokrdsl+CUmXixhhAb6FHuW7rv14U9O26uDUdu1loK3y15WHFpaxN9JNWjaOdHPA6kAexuwjModTqGA/wQguCbXNoZ8J1Ny7FfEUkP+K3BphND34OBRlrO5HTN66HFaC6UVw6MNpS89I22dJo9vUG5tpY3Bz5rWUivID3NteVb10op2A8vxK6TpR8Jger/1AvvzdM6HkSr5KS1A2sRjxbO0ycqfTyZRBuSS0umXYGAhvIvdCTOM4KIkaYN4dmVuNsKitM51slpNXcPfQH+dhPeayVnv4N32RyYRGTg2crXqy2pNelYJBwMxw+bl9PDBJV7/bKpji2XouRjKduBOgXrRzaWXUXLlOZ2UIuCeTrOIpgPvcd/2eRpTG81T8U24mmzZdqxxHfNeI87Ioc0ZBsS5LgH2YZVhBiLI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199015)(46966006)(36840700001)(40470700004)(54906003)(7696005)(1076003)(70586007)(6916009)(70206006)(4326008)(8676002)(2616005)(47076005)(426003)(41300700001)(36860700001)(26005)(8936002)(186003)(44832011)(7416002)(16526019)(5660300002)(83380400001)(6666004)(2906002)(82740400003)(81166007)(316002)(478600001)(336012)(82310400005)(86362001)(40460700003)(36756003)(356005)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 16:34:42.7322
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1673429-a5ae-4a6c-9db6-08dafe28e56f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT100.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7684
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The Null Selector Clears Base feature was being open-coded for KVM.
Add it to its newly added native CPUID leaf 0x80000021 EAX proper.

Also drop the bit description comments now it's more self-describing.

  [ bp: Convert test in check_null_seg_clears_base() too. ]

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/common.c       | 4 +---
 arch/x86/kvm/cpuid.c               | 4 ++--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index e975822951b2..bb0b483dcfd1 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -433,6 +433,7 @@
 /* AMD-defined Extended Feature 2 EAX, CPUID level 0x80000021 (EAX), word 20 */
 #define X86_FEATURE_NO_NESTED_DATA_BP	(20*32+ 0) /* "" No Nested Data Breakpoints */
 #define X86_FEATURE_LFENCE_RDTSC	(20*32+ 2) /* "" LFENCE always serializing / synchronizes RDTSC */
+#define X86_FEATURE_NULL_SEL_CLR_BASE	(20*32+ 6) /* "" Null Selector Clears Base */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 094dbcd63f2a..162352d42ce0 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1685,9 +1685,7 @@ void check_null_seg_clears_base(struct cpuinfo_x86 *c)
 	if (!IS_ENABLED(CONFIG_X86_64))
 		return;
 
-	/* Zen3 CPUs advertise Null Selector Clears Base in CPUID. */
-	if (c->extended_cpuid_level >= 0x80000021 &&
-	    cpuid_eax(0x80000021) & BIT(6))
+	if (cpu_has(c, X86_FEATURE_NULL_SEL_CLR_BASE))
 		return;
 
 	/*
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 448b5de98b8f..e2c403cd33f1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -743,10 +743,10 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
-		BIT(6) /* NULL_SEL_CLR_BASE */ | 0 /* PrefetchCtlMsr */
+		F(NULL_SEL_CLR_BASE) | 0 /* PrefetchCtlMsr */
 	);
 	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
-		kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(6) /* NULL_SEL_CLR_BASE */;
+		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
 	kvm_cpu_caps[CPUID_8000_0021_EAX] |= BIT(9) /* NO_SMM_CTL_MSR */;
 
 	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
-- 
2.34.1

