Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1AC57A28CF
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 22:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237730AbjIOU6I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Sep 2023 16:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237842AbjIOU54 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Sep 2023 16:57:56 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED6BC3A84;
        Fri, 15 Sep 2023 13:55:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ihct4oJ2/m4JmNFxN8w6XTFnF63fF0PLv3WKRr4VQODcpChAwn3cWqJ/FE5GanKz24xIkz0+Z/w86J0iwiS9NyQp09nVeZa6gPLugpnB9MaqFxIhL+U905uCb29ajOxkrfidgCvcv2+wdemJeO0/xi3gl3t5qGb7VoH6Y88y7BWYm1mngw27eHLEDZTOesy9Xfi/LwpO6OcfalV7MCJFgIBc6n76sqFCBiIYFAjOrREVOLvtv3F1/8iMAdMJefbnSmME4X4Cee8U5vvpTtqND/BziKcwfdOMyulgmfI2DUwojyrt5Vn63CAEN+t3d+vf1Ab4nTh/wbnWJQCNC7TpUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ypRz3TDdthS8Oo/+VOtP2YEf2xCorkTVSGttuN/Vusk=;
 b=g/qcNHMPKPbgxJV2D1mBx2W1kK19Ld+DgA0aPVueXogqnRHmAuozbGyDZ9+P52DRQYWZYasui3Nha8nksa56RXDyILeGsXxeKNkEsbYrmcr2Tj33mlwUOwkfj8fyyd7gaMkf2pqqb0bMA4T8JRKLX8BOvncdmzp78EgagrulvIAvD1fCYrUcwqQ16RG3D15/UIqP5wEw/e4fmk8OY2piAdEz79pEfyVGkQ+guK3jMVb1CuYxrXLvwTD8qGlNIgFCT/WiBO54tCL+AzeNTq3Nf/HTRHhmHLvs5eSOg3iBILxgxmRGNEY+YWNM8qJ6CM6ftWwFJiaIturdPMccacqljA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypRz3TDdthS8Oo/+VOtP2YEf2xCorkTVSGttuN/Vusk=;
 b=ZqKqJKTPVN4Rt9sfLzXwRsY01GrczISQ3IA+Xtod2McE9m17kyJloG17wtq8qO70jj+mkZXsr3E5uedliNjVoj4xECCqdi8mlAMYza35GOczGgMr7HPpxLCGCOZG3wQEY8cdR4aRnK7Qs/woNaLmy8S75G9V7a2QGGSrJkbCN0s=
Received: from DM6PR06CA0001.namprd06.prod.outlook.com (2603:10b6:5:120::14)
 by LV2PR12MB5989.namprd12.prod.outlook.com (2603:10b6:408:171::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21; Fri, 15 Sep
 2023 20:54:54 +0000
Received: from CY4PEPF0000EE32.namprd05.prod.outlook.com
 (2603:10b6:5:120:cafe::9e) by DM6PR06CA0001.outlook.office365.com
 (2603:10b6:5:120::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.21 via Frontend
 Transport; Fri, 15 Sep 2023 20:54:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE32.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6792.20 via Frontend Transport; Fri, 15 Sep 2023 20:54:53 +0000
Received: from tlendack-t1.amdoffice.net (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Fri, 15 Sep 2023 15:54:52 -0500
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
Subject: [PATCH v2 1/3] KVM: SVM: Fix TSC_AUX virtualization setup
Date:   Fri, 15 Sep 2023 15:54:30 -0500
Message-ID: <4137fbcb9008951ab5f0befa74a0399d2cce809a.1694811272.git.thomas.lendacky@amd.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694811272.git.thomas.lendacky@amd.com>
References: <cover.1694811272.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE32:EE_|LV2PR12MB5989:EE_
X-MS-Office365-Filtering-Correlation-Id: 92ab51ed-50f0-4ade-aa85-08dbb62e02fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8AXzi1wbhdFmwNeG/1Gib/cnQyJ659PnTCtHEtGRxhUt9XSbo8v/HlLR3fqUCWCNVe7hTz62Vy8nSRPLuWbXHbPdi2aEMzwMJKPnr2ux0ud9Idvc6258WCfYtgUtR/OmblQkyY2EWXBIBq95fvUqCoH24xqcVahGCcV7gGwhnoeRzBI7i4dT2mxTi9U/fdPz994qQv5UqsyhdG08cfRAOcZIwPLIr2YdCG1ycC2N75LZ0if6byTsCe16HEGzW6ICEKSDwBZYrYNBgMIe48bSxt5voTwufjOQL6Ss9QjJ+xzNoQo3bJUGBKlSPW+6o6n+/mZIlnUpImhyXshIQyNSC+qduT9h9nYXrEpWKzhPujGWaI9Cy5jmBtPSrzERSOmblL23ETB9xAd0QisFuJzCjPKzfjf9oM7MNLbkRw4KiwfBmkckM+wAyMjoP+kZc4ngQVmcrEi2WMg8nwGmH68PL7gxOipR/qB13v2DNwKYLxq7vnl/fjdmEtwYEDgBO5ZbwUSfcaHwslyv6+VH4ohG6HYb1aSyW2Ld751JbbwlgczD+Iy3lxKfelJFxnd5157pcsMZOD0hIENn3DHLpKPd3dEZAic9+z5UvNuSEWa6pmmHIoIBkaFrd3/6UhHUdkkIZXxQjqnUJ62joNfzYZ8N3jB7hJKuL/8Y8lLszyKrf2YB/EaK2OVpxCOZf4eG3PQzxnDCukjoH8abPr6+9A36L2sDv2ZaBoCEcKRs55aQ44dmnHvrfoo0eYyjK03SYPXN96wbzSvU65oBHNLvvwl/ARm6GxeuOTziu7DFQc0917s=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(136003)(346002)(39860400002)(396003)(82310400011)(451199024)(186009)(1800799009)(40470700004)(36840700001)(46966006)(6666004)(478600001)(5660300002)(4326008)(83380400001)(26005)(2616005)(426003)(336012)(2906002)(316002)(70586007)(70206006)(16526019)(54906003)(41300700001)(110136005)(8936002)(8676002)(47076005)(40460700003)(356005)(82740400003)(36860700001)(36756003)(40480700001)(86362001)(81166007)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 20:54:53.7049
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92ab51ed-50f0-4ade-aa85-08dbb62e02fd
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CY4PEPF0000EE32.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5989
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

Move the TSC_AUX virtualization enablement out of the init_vmcb() path and
into the vcpu_after_set_cpuid() path to allow for proper initialization of
the support after the guest CPUID information has been set.

Fixes: 296d5a17e793 ("KVM: SEV-ES: Use V_TSC_AUX if available instead of RDTSC/MSR_TSC_AUX intercepts")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kvm/svm/sev.c | 35 +++++++++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.c |  9 ++-------
 arch/x86/kvm/svm/svm.h |  1 +
 3 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index b9a0a939d59f..4ac01f338903 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2962,6 +2962,33 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 				    count, in);
 }
 
+static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
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
@@ -3024,14 +3051,6 @@ static void sev_es_init_vmcb(struct vcpu_svm *svm)
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
2.41.0

