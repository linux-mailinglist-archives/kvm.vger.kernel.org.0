Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 284DA47BC73
	for <lists+kvm@lfdr.de>; Tue, 21 Dec 2021 10:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236068AbhLUJGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Dec 2021 04:06:05 -0500
Received: from mail-dm6nam12on2082.outbound.protection.outlook.com ([40.107.243.82]:35732
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236047AbhLUJGD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Dec 2021 04:06:03 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtdcJuFkKsVfCyb1DpIcswpmpbUM/UfNXnC0RjNJpw2MzVRa4m8orosOePWtizd+o0JrmZV11xSS4T2iHFVtvd0ms8DCfWzPxZphzHx8t6qFk6M1lYyakTCshg2uFkULnajxf63JCSokEhyjK3xCdh/Ul2Ey6bqnTqbdheSp7B3gj9ZCShoj5bIS+SNV4+ZwHbL0BHwS1GvjDcCWWNeDe3jgtvNg5uEpp4dJdDItqUS7CMCHrYiHxGfvouBtt5tsYueqKGMKGC512YOydNG7oaVasoaktjjpOf8JNkUcOtU6owJTgRElVKNZgVL8r2Ow6CarKn6NQjVNUikzm+yzyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NFlWtN0m9u3nySYIuFXarvk4b/75D6BLp51ZKBntxUc=;
 b=j/dGIeow+WZxN/YJMBQUVDszMVMRWsW8bigHcPzIDTnfhYxZklT8gU5tVu3AkC8sDocsQvVUUQyq3R9/JqNqJbVzK4qJusQINve5tSjTOqeX0oD+72TnJnMzG+KsBsMhABBTOfnXGjshjSpIJxrRkGP62N0veEXq2WJwlPdtk+kwBZ3aY0VjrdT1QX6MFISjF6kqDOi7EJmxG0/DZ+RNDeI9xYgYGWZ8Y7/t5lUKjfDcfEvRaemvgIxFF8Dae28eThKVIY0NN2rL0nPnYgmsmruizHCLubQw46znewOzALCuNMkknnWq5sJoL0TpYk66BFdFidQGhZvNGAvd4TjgRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NFlWtN0m9u3nySYIuFXarvk4b/75D6BLp51ZKBntxUc=;
 b=W0MtiGrRKfxYcxxjeRM5C2BGQhVJJYbJWLPlmC1w72UCpqEprcSWnMyXTY1srYMua7ggupbtOmdRKKk2G9m6FlFjjKRAccfeOBqxdMA48M3QRvnS21lhODPD7dQ0/35Mj+2vMkdlN7Y72BO83yRnxGsXPwHSJ3oel4PtnNX4qHPt448OBYgTvOVuIPJ6rW3k+rV9sgCjZrP9FfKAqLb851ZjL7xXwA6nDcxy1jGjj78gSLeTBFbHhF+wF8DZoA1j50AOkzsK15h5zBXOroRGfRQMSf57nQI+ttrTcZtSP+EjLKewU/7X3nfesqV8DWccgKaP2+p7w+MZzSXuExZ59w==
Received: from BN6PR11CA0068.namprd11.prod.outlook.com (2603:10b6:404:f7::30)
 by MN2PR12MB3790.namprd12.prod.outlook.com (2603:10b6:208:164::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Tue, 21 Dec
 2021 09:06:01 +0000
Received: from BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:f7:cafe::38) by BN6PR11CA0068.outlook.office365.com
 (2603:10b6:404:f7::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.14 via Frontend
 Transport; Tue, 21 Dec 2021 09:06:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT006.mail.protection.outlook.com (10.13.177.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4801.14 via Frontend Transport; Tue, 21 Dec 2021 09:06:01 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 21 Dec
 2021 09:06:00 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (172.20.187.5) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.986.9; Tue, 21 Dec 2021 01:05:59 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <wanpengli@tencent.com>, <vkuznets@redhat.com>, <mst@redhat.com>,
        <somduttar@nvidia.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v2 2/3] KVM: x86: move ()_in_guest checking to vCPU scope
Date:   Tue, 21 Dec 2021 01:04:48 -0800
Message-ID: <20211221090449.15337-3-kechenl@nvidia.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211221090449.15337-1-kechenl@nvidia.com>
References: <20211221090449.15337-1-kechenl@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cb56a21-efef-45a5-b519-08d9c4611c29
X-MS-TrafficTypeDiagnostic: MN2PR12MB3790:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB37905647DD255144D5EC5805CA7C9@MN2PR12MB3790.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:233;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BJ8lMehSXXanSyiSqhnJQfBmh2vsz0nj+Y22A3dhPUbQVFbWyitZj34NjWMxpDhM2Iia1ZdfElVgZ2pLeqxwW2HEI9gTFIwlAkZbp4ZYm1kCfTOJyOwBEHlAwuP5eDVnDZXUgmUvJ1/U80OTWayT+3p/mZEmrfASNlnz40raVC+N/+Zgg8WM1oK6HJeLg85dM7dX3SifsI12uKIAM1v6XqToSynclU94vlHwDEFXxqLEiTWuK2+/NI1f4rDP7qkUpqQfw55FYrhiW3VWkK2gsEvdfDy2GyNGIdJnB+liY9u0pjcA0jFMXXQ9yv9s4LPdj5AkkPdVN6L//Q0mZ2fUv/Kr4oO7JjscP5ZL9hlHONLXqEdDzvBOf3L9Po4QjhJ/XYNs4qqqkLQUE3gMkQiKm4gnR3Yd2AaQiTHYLvmsiaHTQYMa/ayVcFc3827ZUeXI0IDjMpQuvQ9RPO8+zRjpjfoQ7QoE+rzmizwGhNnMAumwdh+Q7C1uWTtEkLc8eKWW5lw+fuxaTZ9008DRHPEXKNcXKsi18GVic5AwiHmeynteM9AnU+bj8bE3Lcht8TD/WcyjSYRtRTH6PtXMfcBaXdFgLePme2Ik299O8dKmk8psUnCh/fMFb17JOzein2kYWUrOwn75QxWqFYjxctDJ8uufryBgnmgr/sZZ1xZphGQ7AzefWqf27vb0VqWGx8Bt0lnNW1zTkZE0ea7r15Jd2wqM5eYUnznjF/BbYBGJKByMX5mL1Zf68PXUGo9k8Sd2M8duza+ZuILp/ZR8YB6Xq/lS5L3049N6fwBf21cRAICFJ/053GqCImSFij/nwf2crHviSUwURRkb2pZfIix87A==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(2906002)(336012)(7696005)(26005)(2616005)(70206006)(16526019)(6666004)(5660300002)(4326008)(70586007)(508600001)(8676002)(426003)(81166007)(54906003)(8936002)(110136005)(36860700001)(47076005)(34020700004)(1076003)(316002)(356005)(86362001)(83380400001)(36756003)(82310400004)(186003)(40460700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Dec 2021 09:06:01.0659
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cb56a21-efef-45a5-b519-08d9c4611c29
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT006.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3790
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For futher extensions on finer-grained control on per-vCPU exits
disable control, and because VM-scoped restricted to set before
vCPUs creation, runtime disabled exits flag check could be purely
vCPU scope.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kechen Lu <kechenl@nvidia.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/cpuid.c            |  2 +-
 arch/x86/kvm/lapic.c            |  2 +-
 arch/x86/kvm/svm/svm.c          | 10 +++++-----
 arch/x86/kvm/vmx/vmx.c          | 16 ++++++++--------
 arch/x86/kvm/x86.c              |  6 +++++-
 arch/x86/kvm/x86.h              | 16 ++++++++--------
 7 files changed, 33 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2164b9f4c7b0..edc5fca4d8c8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -908,6 +908,11 @@ struct kvm_vcpu_arch {
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
 #endif
+
+	bool mwait_in_guest;
+	bool hlt_in_guest;
+	bool pause_in_guest;
+	bool cstate_in_guest;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 07e9215e911d..6291e15710ba 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -177,7 +177,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
 	best = kvm_find_kvm_cpuid_features(vcpu);
-	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
+	if (kvm_hlt_in_guest(vcpu) && best &&
 		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index f206fc35deff..effb994e6642 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -119,7 +119,7 @@ static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
 {
 	return kvm_x86_ops.set_hv_timer
-	       && !(kvm_mwait_in_guest(vcpu->kvm) ||
+	       && !(kvm_mwait_in_guest(vcpu) ||
 		    kvm_can_post_timer_interrupt(vcpu));
 }
 EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d0f68d11ec70..70e393c6dfb5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1271,12 +1271,12 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	svm_set_intercept(svm, INTERCEPT_RDPRU);
 	svm_set_intercept(svm, INTERCEPT_RSM);
 
-	if (!kvm_mwait_in_guest(vcpu->kvm)) {
+	if (!kvm_mwait_in_guest(vcpu)) {
 		svm_set_intercept(svm, INTERCEPT_MONITOR);
 		svm_set_intercept(svm, INTERCEPT_MWAIT);
 	}
 
-	if (!kvm_hlt_in_guest(vcpu->kvm))
+	if (!kvm_hlt_in_guest(vcpu))
 		svm_set_intercept(svm, INTERCEPT_HLT);
 
 	control->iopm_base_pa = __sme_set(iopm_base);
@@ -1320,7 +1320,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	svm->nested.vmcb12_gpa = INVALID_GPA;
 	svm->nested.last_vmcb12_gpa = INVALID_GPA;
 
-	if (!kvm_pause_in_guest(vcpu->kvm)) {
+	if (!kvm_pause_in_guest(vcpu)) {
 		control->pause_filter_count = pause_filter_count;
 		if (pause_filter_thresh)
 			control->pause_filter_thresh = pause_filter_thresh;
@@ -3095,7 +3095,7 @@ static int pause_interception(struct kvm_vcpu *vcpu)
 	 */
 	in_kernel = !sev_es_guest(vcpu->kvm) && svm_get_cpl(vcpu) == 0;
 
-	if (!kvm_pause_in_guest(vcpu->kvm))
+	if (!kvm_pause_in_guest(vcpu))
 		grow_ple_window(vcpu);
 
 	kvm_vcpu_on_spin(vcpu, in_kernel);
@@ -4308,7 +4308,7 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
-	if (!kvm_pause_in_guest(vcpu->kvm))
+	if (!kvm_pause_in_guest(vcpu))
 		shrink_ple_window(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5aadad3e7367..b5133619dea1 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1585,7 +1585,7 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 	 * then the instruction is already executing and RIP has already been
 	 * advanced.
 	 */
-	if (kvm_hlt_in_guest(vcpu->kvm) &&
+	if (kvm_hlt_in_guest(vcpu) &&
 			vmcs_read32(GUEST_ACTIVITY_STATE) == GUEST_ACTIVITY_HLT)
 		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 }
@@ -4120,10 +4120,10 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 		exec_control |= CPU_BASED_CR3_STORE_EXITING |
 				CPU_BASED_CR3_LOAD_EXITING  |
 				CPU_BASED_INVLPG_EXITING;
-	if (kvm_mwait_in_guest(vmx->vcpu.kvm))
+	if (kvm_mwait_in_guest(&vmx->vcpu))
 		exec_control &= ~(CPU_BASED_MWAIT_EXITING |
 				CPU_BASED_MONITOR_EXITING);
-	if (kvm_hlt_in_guest(vmx->vcpu.kvm))
+	if (kvm_hlt_in_guest(&vmx->vcpu))
 		exec_control &= ~CPU_BASED_HLT_EXITING;
 	return exec_control;
 }
@@ -4202,7 +4202,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	}
 	if (!enable_unrestricted_guest)
 		exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
-	if (kvm_pause_in_guest(vmx->vcpu.kvm))
+	if (kvm_pause_in_guest(vcpu))
 		exec_control &= ~SECONDARY_EXEC_PAUSE_LOOP_EXITING;
 	if (!kvm_vcpu_apicv_active(vcpu))
 		exec_control &= ~(SECONDARY_EXEC_APIC_REGISTER_VIRT |
@@ -4305,7 +4305,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
 	}
 
-	if (!kvm_pause_in_guest(vmx->vcpu.kvm)) {
+	if (!kvm_pause_in_guest(&vmx->vcpu)) {
 		vmcs_write32(PLE_GAP, ple_gap);
 		vmx->ple_window = ple_window;
 		vmx->ple_window_dirty = true;
@@ -5412,7 +5412,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
  */
 static int handle_pause(struct kvm_vcpu *vcpu)
 {
-	if (!kvm_pause_in_guest(vcpu->kvm))
+	if (!kvm_pause_in_guest(vcpu))
 		grow_ple_window(vcpu);
 
 	/*
@@ -6859,7 +6859,7 @@ static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
-	if (kvm_cstate_in_guest(vcpu->kvm)) {
+	if (kvm_cstate_in_guest(vcpu)) {
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
@@ -7401,7 +7401,7 @@ static void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu)
 
 static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
-	if (!kvm_pause_in_guest(vcpu->kvm))
+	if (!kvm_pause_in_guest(vcpu))
 		shrink_ple_window(vcpu);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 37529c0c279d..d5d0d99b584e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10941,6 +10941,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 #if IS_ENABLED(CONFIG_HYPERV)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
 #endif
+	vcpu->arch.mwait_in_guest = vcpu->kvm->arch.mwait_in_guest;
+	vcpu->arch.hlt_in_guest = vcpu->kvm->arch.hlt_in_guest;
+	vcpu->arch.pause_in_guest = vcpu->kvm->arch.pause_in_guest;
+	vcpu->arch.cstate_in_guest = vcpu->kvm->arch.cstate_in_guest;
 
 	r = static_call(kvm_x86_vcpu_create)(vcpu);
 	if (r)
@@ -12086,7 +12090,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 		     vcpu->arch.exception.pending))
 		return false;
 
-	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
+	if (kvm_hlt_in_guest(vcpu) && !kvm_can_deliver_async_pf(vcpu))
 		return false;
 
 	/*
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 4abcd8d9836d..0da4b09535a5 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -372,24 +372,24 @@ static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
 	    __rem;						\
 	 })
 
-static inline bool kvm_mwait_in_guest(struct kvm *kvm)
+static inline bool kvm_mwait_in_guest(struct kvm_vcpu *vcpu)
 {
-	return kvm->arch.mwait_in_guest;
+	return vcpu->arch.mwait_in_guest;
 }
 
-static inline bool kvm_hlt_in_guest(struct kvm *kvm)
+static inline bool kvm_hlt_in_guest(struct kvm_vcpu *vcpu)
 {
-	return kvm->arch.hlt_in_guest;
+	return vcpu->arch.hlt_in_guest;
 }
 
-static inline bool kvm_pause_in_guest(struct kvm *kvm)
+static inline bool kvm_pause_in_guest(struct kvm_vcpu *vcpu)
 {
-	return kvm->arch.pause_in_guest;
+	return vcpu->arch.pause_in_guest;
 }
 
-static inline bool kvm_cstate_in_guest(struct kvm *kvm)
+static inline bool kvm_cstate_in_guest(struct kvm_vcpu *vcpu)
 {
-	return kvm->arch.cstate_in_guest;
+	return vcpu->arch.cstate_in_guest;
 }
 
 DECLARE_PER_CPU(struct kvm_vcpu *, current_vcpu);
-- 
2.30.2

