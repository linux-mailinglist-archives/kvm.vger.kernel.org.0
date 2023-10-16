Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBBDE7CAA0E
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbjJPNnr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232365AbjJPNnn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:43:43 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93A341AA;
        Mon, 16 Oct 2023 06:43:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OziGier9QWcAuC5tkgO0vk+FdV7SKYpdDj4XSL9LL9Lo1mpIpLkQAH+DFA4i9dw7tAb74rxOLzKPIMNTKeh+F0uxrMSNmUXzJOUlekarjFMuI4dllS99YFFNwB6GOYnGT3rF3MwBxgAXyF73Qn/+byr2IB51pIf96hmg03OfpUNg01/AfX/oZ5wa+8lL52w1CXH0/nCdK64CM61z1zQugkdyrueKubI1ukClGtyEcTCU7vCySXpfunnMyCQQ7zVgX/XX4X/otXOY7WGywqe5aw6eCQar636rz3y4+Ba78prgvBCnCYDktCvefDnWfKZDdFCUJA9iz9XJIeBvFAGKQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ioKmdW5u8oz4n/hSrjYaU7DKRMzHLf2Sn+it5+ignoY=;
 b=PIx/h3EOYbPj95eVLC/qKb1jFu2aiQkhAQ74dkV8Ymugrmp7G4L0Y/W3QEXq2s6m8nli0j94W/9btW3GgXPaZuaSP9c3W0WMx5ZF94CMH+T5DXcaIwJOxcTdjAHgMmH6RqySUfeal+Xolq9IinNpCbs5UFdlqThQ7nntvi4N9sOPvhbZjR8JyaABHZGKi40NUZIeJdUxXluTUZTi3ywPqF+P5vBMrHhWeKcyixDqfBMdFxWKM2VV2S4ruP+tHV/P1c4rkrGtFaXNZZ16w24B39BaBIr4yysa+vLfVfr8CqlckZsTjLbDVni0EjqdbS2OiKL0oI6tVVyQdlrzJ9BAgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ioKmdW5u8oz4n/hSrjYaU7DKRMzHLf2Sn+it5+ignoY=;
 b=oms8JKIOCW/xd8qNvYdhlF3UZBOBQMePpXci2kc4pMY59veu03uMC/Mwq4QAegWNtJhFcwrfc9v1jT9ZOdBomTRpiIIBh+ykXUWn5Fp7s1atzkejfWWqLfikSsaQ56Mk4DUQYtcGin+Ubu6NNxdjD99PWnkujKfNusEDWgpmuxY=
Received: from BY3PR03CA0003.namprd03.prod.outlook.com (2603:10b6:a03:39a::8)
 by DS7PR12MB5861.namprd12.prod.outlook.com (2603:10b6:8:78::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.46; Mon, 16 Oct
 2023 13:43:36 +0000
Received: from SN1PEPF000252A2.namprd05.prod.outlook.com
 (2603:10b6:a03:39a:cafe::5c) by BY3PR03CA0003.outlook.office365.com
 (2603:10b6:a03:39a::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36 via Frontend
 Transport; Mon, 16 Oct 2023 13:43:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A2.mail.protection.outlook.com (10.167.242.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:43:35 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:43:35 -0500
From:   Michael Roth <michael.roth@amd.com>
To:     <kvm@vger.kernel.org>
CC:     <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
        <linux-crypto@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <jroedel@suse.de>, <thomas.lendacky@amd.com>,
        <hpa@zytor.com>, <ardb@kernel.org>, <pbonzini@redhat.com>,
        <seanjc@google.com>, <vkuznets@redhat.com>, <jmattson@google.com>,
        <luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
        <nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>,
        <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
        Alexey Kardashevskiy <aik@amd.com>
Subject: [PATCH v10 03/50] KVM: SEV: Do not intercept accesses to MSR_IA32_XSS for SEV-ES guests
Date:   Mon, 16 Oct 2023 08:27:32 -0500
Message-ID: <20231016132819.1002933-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231016132819.1002933-1-michael.roth@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A2:EE_|DS7PR12MB5861:EE_
X-MS-Office365-Filtering-Correlation-Id: 122ef2e9-87d3-4050-0962-08dbce4de54c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rGaBheoYLRenzJNrFLuyPdNgoNtGtm1+bWO2c/zpabtGOeQhvvlhyskQDrpyb67W3np3JxzwKojtsomG4BIIbkI21ffz02i1Z0cRPKOcs2P2RmhD1w/Kp01Y6QRsL6TBMpV2VtdODodaOrp9T0XTaCAk+zWboNWXrcehwr8nitLW602RcYdaVP9i+ypaTo5myPOonQ5nmVasjRH3itkfC3Etayt+OAIgao6jUNAZHSAdBMww8W3ub2i0HXylw0iwfTKyW2UjFAIHIez0e5y/9v6MTEWiLFn3OTO5uiTQHVa6JavRPbvba6HjMQ92aIUjcYTFXGL5WP7msR6U8d8lh+zbMlErdongym/BOFKi8CTZGnqz4dh0OQ/CIhYeGHV1veFy1Cx8CWJyPZczDzF2ffF/xScRE5Mm/az0Vjdt3EDA5rakPRKYYeOtDTZ04a9JMwmWhkK/JmDEyfcU4+gkxiOVAa/UVqGhb3PS8yR5PFgFUTcUIUtsRmiWvoxy4dr7q7SwF4V9u1wppVX8UiKekNptIPWOL2nYuGvB44ShXgYPKWqXGMGUeAQ1b8ZiRv2uEAbsOqdgp4Ex8HUo0JgY+FM5J+fNEYjorV+gyLA5MHS2QKcih7SgdJvlWF0b2c3IsTNOBXBNfLrl4WDiT+edEp3shb9se7CIAuz34Og1u1VHuZ1oDtsFwB4euFdM+SSTyVKpXndC8lH3KASLTFNInWrctg1tAzj0S9Q/bTKSMspd2S6d0NZelGpS0kXqEC0IuxhkqKCHjWLvgUpBgl8ptg==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(39860400002)(136003)(396003)(230922051799003)(1800799009)(451199024)(186009)(64100799003)(82310400011)(40470700004)(46966006)(36840700001)(47076005)(40460700003)(40480700001)(82740400003)(26005)(1076003)(16526019)(81166007)(36756003)(2616005)(356005)(336012)(7406005)(8936002)(70586007)(7416002)(54906003)(316002)(41300700001)(6916009)(70206006)(4326008)(8676002)(6666004)(86362001)(2906002)(478600001)(5660300002)(426003)(44832011)(83380400001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:43:35.7201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 122ef2e9-87d3-4050-0962-08dbce4de54c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: SN1PEPF000252A2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5861
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When intercepts are enabled for MSR_IA32_XSS, the host will swap in/out
the guest-defined values while context-switching to/from guest mode.
However, in the case of SEV-ES, vcpu->arch.guest_state_protected is set,
so the guest-defined value is effectively ignored when switching to
guest mode with the understanding that the VMSA will handle swapping
in/out this register state.

However, SVM is still configured to intercept these accesses for SEV-ES
guests, so the values in the initial MSR_IA32_XSS are effectively
read-only, and a guest will experience undefined behavior if it actually
tries to write to this MSR. Fortunately, only CET/shadowstack makes use
of this register on SEV-ES-capable systems currently, which isn't yet
widely used, but this may become more of an issue in the future.

Additionally, enabling intercepts of MSR_IA32_XSS results in #VC
exceptions in the guest in certain paths that can lead to unexpected #VC
nesting levels. One example is SEV-SNP guests when handling #VC
exceptions for CPUID instructions involving leaf 0xD, subleaf 0x1, since
they will access MSR_IA32_XSS as part of servicing the CPUID #VC, then
generate another #VC when accessing MSR_IA32_XSS, which can lead to
guest crashes if an NMI occurs at that point in time. Running perf on a
guest while it is issuing such a sequence is one example where these can
be problematic.

Address this by disabling intercepts of MSR_IA32_XSS for SEV-ES guests
if the host/guest configuration allows it. If the host/guest
configuration doesn't allow for MSR_IA32_XSS, leave it intercepted so
that it can be caught by the existing checks in
kvm_{set,get}_msr_common() if the guest still attempts to access it.

Fixes: 376c6d285017 ("KVM: SVM: Provide support for SEV-ES vCPU creation/loading")
Cc: Alexey Kardashevskiy <aik@amd.com>
Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 19 +++++++++++++++++++
 arch/x86/kvm/svm/svm.c |  1 +
 arch/x86/kvm/svm/svm.h |  2 +-
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4900c078045a..6ee925d66648 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2972,6 +2972,25 @@ static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
 
 		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, v_tsc_aux, v_tsc_aux);
 	}
+
+	/*
+	 * For SEV-ES, accesses to MSR_IA32_XSS should not be intercepted if
+	 * the host/guest supports its use.
+	 *
+	 * guest_can_use() checks a number of requirements on the host/guest to
+	 * ensure that MSR_IA32_XSS is available, but it might report true even
+	 * if X86_FEATURE_XSAVES isn't configured in the guest to ensure host
+	 * MSR_IA32_XSS is always properly restored. For SEV-ES, it is better
+	 * to further check that the guest CPUID actually supports
+	 * X86_FEATURE_XSAVES so that accesses to MSR_IA32_XSS by misbehaved
+	 * guests will still get intercepted and caught in the normal
+	 * kvm_emulate_rdmsr()/kvm_emulated_wrmsr() paths.
+	 */
+	if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
+	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 1, 1);
+	else
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_XSS, 0, 0);
 }
 
 void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index aef1ddf0b705..1e7fb1ea45f7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -103,6 +103,7 @@ static const struct svm_direct_access_msrs {
 	{ .index = MSR_IA32_LASTBRANCHTOIP,		.always = false },
 	{ .index = MSR_IA32_LASTINTFROMIP,		.always = false },
 	{ .index = MSR_IA32_LASTINTTOIP,		.always = false },
+	{ .index = MSR_IA32_XSS,			.always = false },
 	{ .index = MSR_EFER,				.always = false },
 	{ .index = MSR_IA32_CR_PAT,			.always = false },
 	{ .index = MSR_AMD64_SEV_ES_GHCB,		.always = true  },
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index be67ab7fdd10..c409f934c377 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -30,7 +30,7 @@
 #define	IOPM_SIZE PAGE_SIZE * 3
 #define	MSRPM_SIZE PAGE_SIZE * 2
 
-#define MAX_DIRECT_ACCESS_MSRS	46
+#define MAX_DIRECT_ACCESS_MSRS	47
 #define MSRPM_OFFSETS	32
 extern u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
 extern bool npt_enabled;
-- 
2.25.1

