Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD14643996
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 00:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbiLEXfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Dec 2022 18:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiLEXei (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Dec 2022 18:34:38 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8762037A;
        Mon,  5 Dec 2022 15:34:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKv4vgrNnEUSWzQuBKCzs3GMJsXkhjGIQUQ1IG4g3WZ59j/Z03VsddgIkqjdaoAlrRIDIQyZ/1quDj6pYFZLazYLSCa4GyC5lw5HC3+WGS+X4XCQKkFUUdE9/QmgDQYhuTWh6TQd0OHKDG3FDQer1LQG7Z6yMcba6ZxTrJLKG6XNgqpiYPU5Nf/PSCjjLt04qRt305mu1vOX+QDGotbH6Ewm1epg2r5i/f/UOm0RXvdKs6ogbffeC1W30L8R0kXRgutksImhBJL/YS8WXW7eVKlxsl53+LgNwYpC9Twu+L8qG8AAeiH/2sbY5+qrditwiBqFik/cMEQoMAHpRR7axg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gGvG9Rf9xVNCz0RYULQ5crweJXubHrQh73RG4+BymoQ=;
 b=a7i4EAzna/s6Pwi9K2qbhLYtCvUbV3j069DKLZMnrDqzFwVemCKGlz8sdOd6ECTL6DvVgB1Nh7491fCH2P5PcxXbrqiSEYTCvF8w5FCVrHd8VvufTJ6OtNKYUDaIcVFXlNHa0GUnRyoAosiZRKWE0ySPoy3H8ZL6UDONHxBDVETzkwesmesYSr4pBBFwUKK7WroyW3cKwkSol79Ey5eH33HkbJgxEmNQ01YAQqQdm12lkKJ9xGOoi6Agsa6vb4HypCK0CWqoZ6RBhYeo9f667d4yob9NvJp9jKDs9xX8Qqfqfz3S4kRoNsLq/0qU5MdW3CUMpJGQ5tEESFhTCO7ZOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gGvG9Rf9xVNCz0RYULQ5crweJXubHrQh73RG4+BymoQ=;
 b=pb4QPrCPSczPHLmG3dIsyoVFN4+ctfLhIS7awrTVXUmGml5L8kUzBDWN4NJOYiauqTY2dza1wEWMoLaSSBcqk3enQYhcKDc4VDUROmIbjliiQPEg2+ccg3Szq/Pr8Zo0vdw870TBOiNoXQnT3dVT0VjF2fmsTfwTHoTDfBsOGw0=
Received: from DM5PR07CA0110.namprd07.prod.outlook.com (2603:10b6:4:ae::39) by
 DM4PR12MB5890.namprd12.prod.outlook.com (2603:10b6:8:66::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Mon, 5 Dec 2022 23:34:23 +0000
Received: from DS1PEPF0000E640.namprd02.prod.outlook.com
 (2603:10b6:4:ae:cafe::db) by DM5PR07CA0110.outlook.office365.com
 (2603:10b6:4:ae::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Mon, 5 Dec 2022 23:34:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E640.mail.protection.outlook.com (10.167.17.202) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5880.8 via Frontend Transport; Mon, 5 Dec 2022 23:34:23 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 5 Dec
 2022 17:34:21 -0600
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
Subject: [PATCH v5 7/7] x86/cpu, kvm: Propagate the AMD Automatic IBRS feature to the guest
Date:   Mon, 5 Dec 2022 17:32:35 -0600
Message-ID: <20221205233235.622491-8-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E640:EE_|DM4PR12MB5890:EE_
X-MS-Office365-Filtering-Correlation-Id: 54a912ea-65b0-4504-6084-08dad7193d6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h5WNjcicmMVeYE3+iM432qfkHr6pKivq3Ca1OLkIGkvW3zN2MmtrcqkPySKV/ORSnYpcvT2HRgGSFQwIZPFHm46m8uAmPle76ZTKfk1cMstA6L58nhac5+fLIGdELk9eDrj7SbgNVrN3jvXKOEDJPrS9jN1OMBX8POVeUcIp/uOKAzok3ZNSLWdTuPaIpcxktra349dNMsccVun3vCHRwrP6/I4BoW2fsYwiWOeQlNMRpi2xJe+rHzM2bjmcPAjit083hC2NVC5wDhyqy/moRN26IEbY3YN4GfYok/snID9gosYb47p/4U0iIPccSAcWepnEeQPMKjrZP17G43PgCKR64rpOUU+HFVXFRedX+gLrcuFIx8pjMuly1/BqUZxYIemOeo9KBzhY50LVus6zDqfGIErihpWu7XMgIFxGZrvktv69vfeoeb0dTKc1L34r8a8zc7khEPpCbi7cMSRySQZi9sHwpqNV4nEbHwzYqqJpDtTzYVKh24Bjcn+fBmSHo7AH6HBJikqgr3URlJ/OGH26nLu4LYQA0t/S3fHMCrXvw2ONsm6Qc1JtohXJ4sAt/CI7dew7ehlhcVqzgDoqnTsCLXy19hAj8an8g8u6phfBusDV8I4kKfvocuw09hKHNFNWaO9pfXCHjdiRZCmkl6rxJ7xsXsgRDf1eXwdhVOX50J4hznZH8zAjuQOqR9qjiVCdbfScmpdik6lEfz1EYIV8cPGVn/G16UgfFLezhMg=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199015)(46966006)(40470700004)(36840700001)(36756003)(7416002)(81166007)(86362001)(41300700001)(40460700003)(8936002)(4326008)(2906002)(44832011)(5660300002)(82740400003)(36860700001)(83380400001)(356005)(70206006)(70586007)(478600001)(2616005)(6916009)(54906003)(316002)(40480700001)(8676002)(82310400005)(336012)(16526019)(1076003)(47076005)(426003)(6666004)(186003)(7696005)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 23:34:23.0101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 54a912ea-65b0-4504-6084-08dad7193d6a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E640.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5890
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the AMD Automatic IBRS feature bit to those being
propagated to the guest, and enable the guest EFER bit.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kvm/cpuid.c         | 2 +-
 arch/x86/kvm/reverse_cpuid.h | 2 ++
 arch/x86/kvm/svm/svm.c       | 3 +++
 arch/x86/kvm/x86.c           | 3 +++
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index dd0fe79521eb..0ed3ad3e9341 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -732,7 +732,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_init_scattered(CPUID_8000_0021_EAX,
 		SF(NO_NESTED_DATA_BP) | SF(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
-		SF(NULL_SEL_CLR_BASE) | 0 /* PrefetchCtlMsr */
+		SF(NULL_SEL_CLR_BASE) | SF(AUTOIBRS) | 0 /* PrefetchCtlMsr */
 	);
 	if (cpu_feature_enabled(X86_FEATURE_LFENCE_RDTSC))
 		kvm_cpu_cap_set(X86_FEATURE_LFENCE_RDTSC);
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index 184614e27d5b..0bf02c02bb0a 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -30,6 +30,7 @@ enum kvm_only_cpuid_leafs {
 #define KVM_X86_FEATURE_NO_NESTED_DATA_BP	KVM_X86_FEATURE(CPUID_8000_0021_EAX, 0)
 #define KVM_X86_FEATURE_LFENCE_RDTSC		KVM_X86_FEATURE(CPUID_8000_0021_EAX, 2)
 #define KVM_X86_FEATURE_NULL_SEL_CLR_BASE	KVM_X86_FEATURE(CPUID_8000_0021_EAX, 6)
+#define KVM_X86_FEATURE_AUTOIBRS		KVM_X86_FEATURE(CPUID_8000_0021_EAX, 8)
 
 struct cpuid_reg {
 	u32 function;
@@ -89,6 +90,7 @@ static __always_inline u32 __feature_translate(int x86_feature)
 	case X86_FEATURE_NO_NESTED_DATA_BP:	return KVM_X86_FEATURE_NO_NESTED_DATA_BP;
 	case X86_FEATURE_LFENCE_RDTSC:		return KVM_X86_FEATURE_LFENCE_RDTSC;
 	case X86_FEATURE_NULL_SEL_CLR_BASE:	return KVM_X86_FEATURE_NULL_SEL_CLR_BASE;
+	case X86_FEATURE_AUTOIBRS:		return KVM_X86_FEATURE_AUTOIBRS;
 	default: break;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ce362e88a567..1551a791cff0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4946,6 +4946,9 @@ static __init int svm_hardware_setup(void)
 
 	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
 
+	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
+		kvm_enable_efer_bits(EFER_AUTOIBRS);
+
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
 		pause_filter_count = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2835bd796639..0697d444c715 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1688,6 +1688,9 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 
 static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
+	if (efer & EFER_AUTOIBRS && !guest_cpuid_has(vcpu, X86_FEATURE_AUTOIBRS))
+		return false;
+
 	if (efer & EFER_FFXSR && !guest_cpuid_has(vcpu, X86_FEATURE_FXSR_OPT))
 		return false;
 
-- 
2.34.1

