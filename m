Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795A87A0E87
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 21:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjINTv1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 15:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjINTv0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 15:51:26 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDF526BE;
        Thu, 14 Sep 2023 12:51:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ar1OaB7GGjf0KDp88OIBzjBsp8Dj3Zvc6mLfZeYnEuxv3FbdbafgGaF0jcCFSkemjNIH8hgiAo/Xa3/DM9k4234K56J7j9UgyauJxsrDbvfdvXYS9ZLsAAbQJ5qyBclHnRFbj5qLVWQ+bQuU8q/3ayCS438DgcNKiV6I+A389d5eWaKV9p5Qs0bv4U/kKWiWnt7e8q1ljQqLUjSVrJlS1DTY1TIkwaTAV8QSBxUN8JuxcAjn1evvjW0fuDlTA1MMMOtu+szdb7YrihAywmNSRpBJ75nvEL3A//jol/jA864vQmMi/SEK+3gOaVDA3+0foMR5RmuKLkGgJemYnj+D6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tm7BRgNjA2/a8nv58XJCd38dhES5SBSuBVKXmgnM2xo=;
 b=lpYj07/bGqfDybbey30amcoKyP9prj7SwaJZ7RqY5mdlYqvI5i5xG7q7AxrSaDWsFsc5kX4lTNcBMoEqH2wk6gC1l/abe2IfQdvE5qCg6fp4n+KTnBCvvnO+uaLbbV+mhxYF7I9qhBYfd8ZA43HB6ijUlnoD4KLqor9j4+F5s+E8mk18skg57RgrPNZos10kNKERaLVAjRZYD4yvqBvVhUDX9BKQ8d5Q6O92Y47ml94K7Bgxe8xPjFi+6G8ayuenXIv7K/zB3WQlNA5O3HpbmArk0KUJoVy744HuO86+Kqjfb6AT3SRIC2LVfOX4/vXmcmpEweE9DEpZwl+7zijY4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tm7BRgNjA2/a8nv58XJCd38dhES5SBSuBVKXmgnM2xo=;
 b=rW9Ju303WvTjufB06jpAmEpRD634dm8Ro2n/yN8gL96hiqApw06ZLkv5nLDNH8sH3KQsnLGQ5WI89wBHyH4Q4LDywW8HfGHO5GUiRChVpI/bwRZovaCceM3Apz2IPhVy4rYOtCVXUth3bmmNtbpgYPXEtmwDLDr6HxbifgwjeWM=
Received: from DM6PR17CA0034.namprd17.prod.outlook.com (2603:10b6:5:1b3::47)
 by BL0PR12MB4914.namprd12.prod.outlook.com (2603:10b6:208:1c4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.19; Thu, 14 Sep
 2023 19:51:15 +0000
Received: from CY4PEPF0000EE38.namprd03.prod.outlook.com
 (2603:10b6:5:1b3:cafe::e3) by DM6PR17CA0034.outlook.office365.com
 (2603:10b6:5:1b3::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20 via Frontend
 Transport; Thu, 14 Sep 2023 19:51:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE38.mail.protection.outlook.com (10.167.242.12) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6792.20 via Frontend Transport; Thu, 14 Sep 2023 19:51:15 +0000
Received: from tlendack-t1.amdoffice.net (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Thu, 14 Sep 2023 14:51:13 -0500
From:   Tom Lendacky <thomas.lendacky@amd.com>
To:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Babu Moger <babu.moger@amd.com>
Subject: [PATCH 1/2] KVM: SVM: Fix TSC_AUX virtualization setup
Date:   Thu, 14 Sep 2023 14:50:44 -0500
Message-ID: <8a5c1d2637475c7fb9657cdd6cb0e86f2bb3bab6.1694721045.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694721045.git.thomas.lendacky@amd.com>
References: <cover.1694721045.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE38:EE_|BL0PR12MB4914:EE_
X-MS-Office365-Filtering-Correlation-Id: d02e8ee4-ba73-4afa-0171-08dbb55bf4a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gDIfLHPduSMYOGHEmmD/OeGo8t0bg18ohulZw9qpraXYakn2DuIsK3qG12s+9epsQEr9p7T1jxr7DEw5lkgDiPFnr5PhEljvzpVvrpYqfA1pRMSSApDevUfwEsY19Vvlh4XZICprVBrQldlYRsYSod3ou9miXWROKbX0rZ/e9Qmh9rtNTobkg/b/osvYVeRF7VQS3OedUNLAma/sO2gvbjGN3MPE5GJ0yb+BiTa4XPOix0Pk5N9L0OLKEGoWfhsjfcM4i8oYcLzJDl7vQLZJph1yhO1oip+ZNpvWueV+YMqwU9l6hH+4yHqc1tfC3jiZPIqh3H5IBX/lrzglPyXtFT3VmcqBi2ywcnOf2Tlk+dDiY1KPFXnNN/UEbFlxHxZwxtHWNxXMhQuOKforGLF0eULzabIdz0vT6n3KGg6TDlm/pJ6EuTVEKFiE+Qkcp9rlkYxCyL/3El8ULnFsmh0BO9lk7BqNaxnfHeYtby7y8B84VBnwpuYj+AvObRINdBhxuVd1uOtrytilpr7rRM23eE+/GXh/pqaGC1ed9g6neQA0QuBdtCpwv/QbEFsYxcAvDjyYay31jEvKRnz+ekwo7FULJoyr3RYVxy3mjyOwPzoRLWjvKgv/MqoQKAELEeuwrrHPBuP+dMByijv4OP4ovl/2kZkKDsG1oE2GwRgJkCh1InHvH97rEE9DJ4C21CG4qu/5jMzcgg3EsRzKH0j5/JD5limoH95+P5kJPbv4GgKK8XsR9j8vX6KBjYSac68vdt4cOHJoBUxN65RLk19G+Q==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(39860400002)(376002)(136003)(396003)(346002)(82310400011)(1800799009)(186009)(451199024)(36840700001)(40470700004)(46966006)(40460700003)(478600001)(16526019)(83380400001)(2616005)(26005)(426003)(47076005)(336012)(36860700001)(54906003)(316002)(70206006)(70586007)(8676002)(41300700001)(110136005)(5660300002)(8936002)(4326008)(2906002)(6666004)(40480700001)(86362001)(36756003)(82740400003)(81166007)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Sep 2023 19:51:15.3069
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d02e8ee4-ba73-4afa-0171-08dbb55bf4a5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EE38.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4914
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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

Move the TSC_AUX virtualization enablement into the vcpu_after_set_cpuid()
path to allow for proper initialization of the support after the guest
CPUID information has been set.

Fixes: 296d5a17e793 ("KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 27 +++++++++++++++++++--------
 arch/x86/kvm/svm/svm.c |  3 +++
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b9a0a939d59f..565c9de87c6d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2962,6 +2962,25 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 				    count, in);
 }
 
+static void sev_es_init_vmcb_after_set_cpuid(struct vcpu_svm *svm)
+{
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+
+	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
+	    (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
+	     guest_cpuid_has(vcpu, X86_FEATURE_RDPID))) {
+		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);
+		if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
+	}
+}
+
+void sev_init_vmcb_after_set_cpuid(struct vcpu_svm *svm)
+{
+	if (sev_es_guest(svm->vcpu.kvm))
+		sev_es_init_vmcb_after_set_cpuid(svm);
+}
+
 static void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
 	struct vmcb *vmcb = svm->vmcb01.ptr;
@@ -3024,14 +3043,6 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
-
-	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX) &&
-	    (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP) ||
-	     guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDPID))) {
-		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, 1, 1);
-		if (guest_cpuid_has(&svm->vcpu, X86_FEATURE_RDTSCP))
-			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
-	}
 }
 
 void sev_init_vmcb(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f283eb47f6ac..c58d5632e74a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1225,6 +1225,9 @@ static inline void init_vmcb_after_set_cpuid(struct kvm_vcpu *vcpu)
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_EIP, 1, 1);
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SYSENTER_ESP, 1, 1);
 	}
+
+	if (sev_guest(vcpu->kvm))
+		sev_init_vmcb_after_set_cpuid(svm);
 }
 
 static void init_vmcb(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index f41253958357..c0d17da46fae 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -684,6 +684,7 @@ void __init sev_hardware_setup(void);
 void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
 void sev_init_vmcb(struct vcpu_svm *svm);
+void sev_init_vmcb_after_set_cpuid(struct vcpu_svm *svm);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-- 
2.41.0

