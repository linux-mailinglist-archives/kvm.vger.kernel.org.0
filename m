Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB077CA9D2
	for <lists+kvm@lfdr.de>; Mon, 16 Oct 2023 15:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233872AbjJPNjR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Oct 2023 09:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbjJPNjB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Oct 2023 09:39:01 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2081.outbound.protection.outlook.com [40.107.237.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDB310D1;
        Mon, 16 Oct 2023 06:38:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gVjpHvDWmjA0HcM2uQdLqwoE8nzyj56JRn+dmb21yRX7ReqxRWBT2Bpp+s/2e3wQdyVCwyPjXtVgMYFO47MSV7IN8TyKdiDLzx3c7K0BbC3jPpfTuofCIBe4QJpI96X0WZBjE18vs/4inyZjqGLBJRdCyvFTlxh7WRISUX925i46bhsrbuUdbb4p7tJK+79nMBTlIfdFiEkcNy3frDnqKOrGWvyt6X8fDk6iPwB2gFfQMbanciS7E10XvwbfEgOCzBfOVsBPn3UFEMlx6bI7acEyxHS/+FNx9haz9rW4vHcaDOsogg7xU8Ot/Bs/0qwsAXk4ZfYPaHrHVqDPB24qrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pjxZBnS5MLOuqlm9DTDulyqxa8tan8YR6IJ+af5tIDk=;
 b=QKYvzHJRvPw9wAg9dxU1D6+Nrf20/kuBYCWWrJ6g/tqI4xYQLMbBUVjlDyjuIqBJ6bADvp4cVeMA57QTigXf0hEvLVr5NlUeXo/LbTYyUzphKw+unLR5XMV/SwPujQ0Gh1Ct3KPOIYUKlcz2iVB7VPHWrLaKweDYhkKTrWuI7HThT/xr9YLTPNzHmskfi1hu+HMsGA2rdoggIg1UfgUdw6sGms0BPkd8oqjVFI1yitw29HiPtT7hAZXh00ZV1IPZ495uHK3LTOOI15XXqo0XtQMTe/mcDEV4m0jrrFOTaeR2I+5lDBiZvFdPJTgKUZEC0LfQ9PAsttSx3DSnT/ilQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pjxZBnS5MLOuqlm9DTDulyqxa8tan8YR6IJ+af5tIDk=;
 b=p+DY4fhlXA++l9ULcECxduJ5lxvKayHFtcuBeoRuhx5VAvsF9KCE7bctpV14+RkL9I26P6nt//c09PxBySW10jezRVNTAO3nnGtcFSwollGz0+Gmk5Kz9nHETosX09vvVPxwH7eNz22fL7BAmYIqRsO+XWK1Dy+QcnlitcDDxVM=
Received: from MN2PR22CA0019.namprd22.prod.outlook.com (2603:10b6:208:238::24)
 by PH8PR12MB7254.namprd12.prod.outlook.com (2603:10b6:510:225::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.45; Mon, 16 Oct
 2023 13:38:49 +0000
Received: from BL02EPF0001A0FD.namprd03.prod.outlook.com
 (2603:10b6:208:238:cafe::97) by MN2PR22CA0019.outlook.office365.com
 (2603:10b6:208:238::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6886.36 via Frontend
 Transport; Mon, 16 Oct 2023 13:38:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF0001A0FD.mail.protection.outlook.com (10.167.242.104) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6838.22 via Frontend Transport; Mon, 16 Oct 2023 13:38:48 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 16 Oct
 2023 08:38:48 -0500
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
        <stable@vger.kernel.org>
Subject: [PATCH v10 02/50] KVM: SVM: Fix TSC_AUX virtualization setup
Date:   Mon, 16 Oct 2023 08:27:31 -0500
Message-ID: <20231016132819.1002933-3-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: BL02EPF0001A0FD:EE_|PH8PR12MB7254:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b2be24d-3e98-4789-0ab6-08dbce4d3a64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XCpATVppVTG8UeklejD8+NnQx3KrdH1Eyw+EpUEkdvZEzwsxLxmBRW0B0gSWDqTCnmrbUCMs1/wXVP1XbhaJaJ34tXJedo75s/oFdXumTNIf5jH4ps3JI0WYSJodsDtXMCChnY9LlHn7tc5OOczogWmkusxXQWazDWaAERsPqgHSV29IzmbGnGaNjrqTXQVrwnTF7VsmzfgHyQ1dOVXvAQA/dXNUSmEELyeIUV170jI73kBQ4Gc6DSHfYC1sOtOqMR3Kvqyk5DIH18lIxJFrcD6H/vtd2CdpI3fhXbjGrOq43Co8T8Nv7I9CLqmxcQrZ3BGALScNeX5XEnYF/llfYXdfmwMCwuFQY2fOsaAgbrctEHJ4vyDR9nTaN5c3ck89tPMGfNlPrcOLP1dTgxAEK7E4pz41N/XgKApgIoOVB8yZF+hGuiHZ5hzb8i1vYxy+7ekHrzRnhcWwG+RenU9PbmCx5VJO7ZE9xbsy78tJyTKdoepo+CJiJIzIHi+1XgjbLhZZ1IeWfqnabO5eAkGZSCRpWpgQjCNbxZqJu6ccUprvZYFS4ZfsaOdVmXG1aArJqaNOE5M6eJj7bfamYSGgvlJxtN8e+lxcwT9axFBrNt1mxTVMKA4seYjQsVplSmgblKG9r0HSRl0PtCpC9eWEvmvZJjjre2Ijuq7K3G3nvoTzqZgSkXEbY6OAeA9PBCW3EmhgAA8Hkh8zI9XpYRZBtEV37VEtayzUkXnmbqCSQYA/KKulyD5T2FTVohHSn5SkkhHytdjt4FyWevHNNQe0yI1n7DrSPYG0v/Cuewl39vI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(396003)(376002)(136003)(346002)(230922051799003)(451199024)(82310400011)(186009)(1800799009)(64100799003)(36840700001)(40470700004)(46966006)(47076005)(44832011)(8936002)(8676002)(4326008)(41300700001)(40460700003)(5660300002)(83380400001)(7416002)(2906002)(36756003)(356005)(81166007)(36860700001)(7406005)(1076003)(26005)(426003)(40480700001)(336012)(2616005)(316002)(16526019)(6916009)(82740400003)(478600001)(86362001)(70586007)(70206006)(54906003)(6666004)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2023 13:38:48.9870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b2be24d-3e98-4789-0ab6-08dbce4d3a64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF0001A0FD.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7254
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

The checks for virtualizing TSC_AUX occur during the vCPU reset processing
path. However, at the time of initial vCPU reset processing, when the vCPU
is first created, not all of the guest CPUID information has been set. In
this case the RDTSCP and RDPID feature support for the guest is not in
place and so TSC_AUX virtualization is not established.

This continues for each vCPU created for the guest. On the first boot of
an AP, vCPU reset processing is executed as a result of an APIC INIT
event, this time with all of the guest CPUID information set, resulting
in TSC_AUX virtualization being enabled, but only for the APs. The BSP
always sees a TSC_AUX value of 0 which probably went unnoticed because,
at least for Linux, the BSP TSC_AUX value is 0.

Move the TSC_AUX virtualization enablement out of the init_vmcb() path and
into the vcpu_after_set_cpuid() path to allow for proper initialization of
the support after the guest CPUID information has been set.

With the TSC_AUX virtualization support now in the vcpu_set_after_cpuid()
path, the intercepts must be either cleared or set based on the guest
CPUID input.

Fixes: 296d5a17e793 ("KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Message-Id: <4137fbcb9008951ab5f0befa74a0399d2cce809a.1694811272.git.thomas.lendacky@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
(cherry picked from commit e0096d01c4fcb8c96c05643cfc2c20ab78eae4da)
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c | 31 ++++++++++++++++++++++++++-----
 arch/x86/kvm/svm/svm.c |  9 ++-------
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 29 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index fa1fb81323b5..4900c078045a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2962,6 +2962,32 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 				    count, in);
 }
 
+static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+
+	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
+		bool v_tsc_aux = guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
+				 guest_cpuid_has(vcpu, X86_FEATURE_RDPID);
+
+		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, v_tsc_aux, v_tsc_aux);
+	}
+}
+
+void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_cpuid_entry2 *best;
+
+	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
+	best = kvm_find_cpuid_entry(vcpu, 0x8000001F);
+	if (best)
+		vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
+
+	if (sev_es_guest(svm->vcpu.kvm))
+		sev_es_vcpu_after_set_cpuid(svm);
+}
+
 static void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
@@ -3024,11 +3050,6 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
-
-	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
-	    (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP) ||
-	     guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDPID)))
-		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f283eb47f6ac..aef1ddf0b705 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4284,7 +4284,6 @@ static bool svm_has_emulated_msr(struct kvm *kvm, u32 index)
 static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	struct kvm_cpuid_entry2 *best;
 
 	/*
 	 * SVM doesn't provide a way to disable just XSAVES in the guest, KVM
@@ -4328,12 +4327,8 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_FLUSH_CMD, 0,
 				     !!guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
-	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
-	if (sev_guest(vcpu->kvm)) {
-		best = kvm_find_cpuid_entry(vcpu, 0x8000001F);
-		if (best)
-			vcpu->arch.reserved_gpa_bits &= ~(1UL << (best->ebx & 0x3f));
-	}
+	if (sev_guest(vcpu->kvm))
+		sev_vcpu_after_set_cpuid(svm);
 
 	init_vmcb_after_set_cpuid(vcpu);
 }
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f41253958357..be67ab7fdd10 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -684,6 +684,7 @@ void __init sev_hardware_setup(void);
 void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
 void sev_init_vmcb(struct vcpu_svm *svm);
+void sev_vcpu_after_set_cpuid(struct vcpu_svm *svm);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-- 
2.25.1

