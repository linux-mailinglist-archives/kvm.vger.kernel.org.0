Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE99679ED5
	for <lists+kvm@lfdr.de>; Tue, 24 Jan 2023 17:36:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbjAXQgR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Jan 2023 11:36:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234031AbjAXQgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Jan 2023 11:36:13 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2052.outbound.protection.outlook.com [40.107.92.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 244844C6E5;
        Tue, 24 Jan 2023 08:35:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F5NJ40CdR7IWZrDUMwpCYQ8TRV6n7gWTUShohAMz/hr6s+f6Itmp7klU/UNcXnP59Or5zwQS0BsmwULW9tiOMPty7R09CL4tY2i1B6ILEvWR8Hemyn4zvN2RLwCVfd3uLuwy40P5u9NuuODH9yTePYsYg5fvZWrSe3Y/J5hYAwz+DoU8/y+U7q5nwo8CCUfW+0CktAKBYDALwM43yrC56W3hCnOa1OqIdkD+3BiW7kT/Gs1ZPrp3Ten1xC7kt2qNt/AHlBlWfUqCW3Im0Pb4hW/tBt7dAx9s5NSsTJNzgzPpwezDOxyXc7sf6juAj2x9UfO4SWkI4m+saB/Q5KJ/Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XOrXxt4az/1m3xxxc8phYeF2k3nu+oPU/LTvGHktjZg=;
 b=UnFKMpG9LvgRLdGIu7TWo2C7TXLAqz3MoDpuAdnH++RalFPhTUwg/B9laHHd2jcx/fT3V3wtXoWEuA8Oj/f2wOqG2VA6OI1bNVzYbP3x9Vc0/psk5R8IWIdDCRbECY490IGAmqlnpzBnSmxly/LPaoZJ2V/MooRiBnWUmrjvvCk1wi9LgpCG1+o8sb702gQXHDr4yq00ARw9dosneZwLL9XLsMZ3AKbCbq7MnF+IL6QJQUVCwVocM/mYSJQLNk7ya5kjUttDvEVjE3EszjA/ItkLqXGF+fwN1P2NOWiX7kYS58riT2pG+ABC4E4z+1fg00Gjolt5G7riN+UeSbMu2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=kernel.org smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XOrXxt4az/1m3xxxc8phYeF2k3nu+oPU/LTvGHktjZg=;
 b=Szpok9lgTHhGtvEDvQr1cG3UjbGy9/dPk7qvhw5sGsE+HREE1nkuBlFX+P94ykZv5eSKU/KLQ60C5XGZzWP3GChMaZOXLqLINgBRgpUnXOCUfQ81wQmHp6RB3cTR2H6+cfZ9EU7iv7d61vksg7AKSF1Y3pa/0KExgX8fMCn2xsc=
Received: from MW4PR03CA0278.namprd03.prod.outlook.com (2603:10b6:303:b5::13)
 by DM6PR12MB4137.namprd12.prod.outlook.com (2603:10b6:5:218::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Tue, 24 Jan
 2023 16:35:19 +0000
Received: from CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::88) by MW4PR03CA0278.outlook.office365.com
 (2603:10b6:303:b5::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33 via Frontend
 Transport; Tue, 24 Jan 2023 16:35:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT087.mail.protection.outlook.com (10.13.174.68) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.17 via Frontend Transport; Tue, 24 Jan 2023 16:35:18 +0000
Received: from fritz.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 24 Jan
 2023 10:35:16 -0600
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
Subject: [PATCH v9 8/8] KVM: x86: Propagate the AMD Automatic IBRS feature to the guest
Date:   Tue, 24 Jan 2023 10:33:19 -0600
Message-ID: <20230124163319.2277355-9-kim.phillips@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT087:EE_|DM6PR12MB4137:EE_
X-MS-Office365-Filtering-Correlation-Id: 040258c8-3371-4b34-e1e1-08dafe28fb11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Jape+yDbUSAp/H9uqbi1h2echBks22AehrPZBRN4Uij3SZsS9ZIeUVNdWFKRdUqGQoBIRSqK4ao7hBPgOmoeegU1PAkP/OvMNcI6gmTzBCPQ9j1IRU2rSc2NA71ex6v3msYAp0oq0PdnX66yu3wvEFOSVuvSWZJNAovTPXvNCjSkFRThfrd+AmCKY73EsGCIqO8q1+lW6mbUu49aTCVmKzY8sR2GXfMBnSkCdM8fUno257j8TwYzLMeg4YOT0fghyUNBnp2pXyWfa03iQ8n0LnDLo7eVetOdp16ha33nh/bIkIrLFUBNLxRVIbRXT/GGBQ+BW8OIQRj2rM4s0b1ewgiqKWnFEYnZnlpQvbO8iwyrr0ht176DRbnb/1mgpRgZry7LjeM5QXhn8xBCvQLWmEfC+cDTunC3Uy4KJcJUep6+4mWdrgUwwyOh1X3L4K9M7SbTfIQ639SAc+hFQemlXV5rdehiQ35W+VnOsK7cKsz2BM5dIfgcwISIJm5/ZC6DNyV50AWnAPeeY14VfJrYmsGx9ouVR1eI0Hdpc+DKoun8TXcElhvdOMWa+f7HAVcN27XbdZU3n5kWEUQOoEnub2zQTz15odf9Oo5IMLDRF53lzeFal5vk7pb7YoxlGua5PPBMqxeJn8SWwBGQXBCW/wx3b4xdJGasZYXAmdIYwVglJfxj6/sxBKvHezaMyAHoG3hqnT5WZfrKwTxlxEtbPtmVJW0w3Gbh+yEgXBQ/26I=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199015)(36840700001)(40470700004)(46966006)(36756003)(41300700001)(86362001)(356005)(82740400003)(81166007)(7416002)(8936002)(5660300002)(4326008)(44832011)(2906002)(82310400005)(83380400001)(36860700001)(478600001)(7696005)(6916009)(26005)(8676002)(186003)(40460700003)(16526019)(40480700001)(316002)(70206006)(70586007)(54906003)(2616005)(1076003)(336012)(426003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 16:35:18.9184
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 040258c8-3371-4b34-e1e1-08dafe28fb11
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT087.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4137
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add the AMD Automatic IBRS feature bit to those being propagated to the guest,
and enable the guest EFER bit.

Signed-off-by: Kim Phillips <kim.phillips@amd.com>
---
 arch/x86/kvm/cpuid.c   | 2 +-
 arch/x86/kvm/svm/svm.c | 3 +++
 arch/x86/kvm/x86.c     | 3 +++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8519f4a993f7..f29d35c20c7e 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -743,7 +743,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP) | F(LFENCE_RDTSC) | 0 /* SmmPgCfgLock */ |
-		F(NULL_SEL_CLR_BASE) | 0 /* PrefetchCtlMsr */
+		F(NULL_SEL_CLR_BASE) | F(AUTOIBRS) | 0 /* PrefetchCtlMsr */
 	);
 	if (!static_cpu_has_bug(X86_BUG_NULL_SEG))
 		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9a194aa1a75a..60c7c880266b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4969,6 +4969,9 @@ static __init int svm_hardware_setup(void)
 
 	tsc_aux_uret_slot = kvm_add_user_return_msr(MSR_TSC_AUX);
 
+	if (boot_cpu_has(X86_FEATURE_AUTOIBRS))
+		kvm_enable_efer_bits(EFER_AUTOIBRS);
+
 	/* Check for pause filtering support */
 	if (!boot_cpu_has(X86_FEATURE_PAUSEFILTER)) {
 		pause_filter_count = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index da4bbd043a7b..8dd0cb230ef5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1685,6 +1685,9 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 
 static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
+	if (efer & EFER_AUTOIBRS && !guest_cpuid_has(vcpu, X86_FEATURE_AUTOIBRS))
+		return false;
+
 	if (efer & EFER_FFXSR && !guest_cpuid_has(vcpu, X86_FEATURE_FXSR_OPT))
 		return false;
 
-- 
2.34.1

