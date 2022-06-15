Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E83B54BF21
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 03:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239528AbiFOBRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 21:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236818AbiFOBRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 21:17:21 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D863916B;
        Tue, 14 Jun 2022 18:17:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TGnbV8BN4ZjqoqlNfCKjMMoLMG9+OVBwQBnZcn6o2WZVTgVWZ7ar8DPNQH0fXdxVXN/CYc0RhHCz3NZURqak9/QV2ebX3HxxkiXbBKteMBCAY5+XVEkrKZrAEdCZ2gd1pz1AjQsJJwDt+udAXKuo8V3YsDTyu3DbTI/PTUkNiB7sV3wClhGm+Jv5xvCiX+erMxzZ21EDc+o4ohX0Jltq8PtjNo2hyrI4zKgJNtLABuL2vVipAaNHfInybVrcQV/f5RXOw2y8fP+2jMfmLIQU/0GaqKzQ/xGQ+TU+nKjgKKzQJqHQMSsyiGoa5dSPGGXGVjKYFlNGmt1L5WsqlRCW8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQFMSfQAbsEUSI3Jph/BToZ98JCiMeJ93p5rV04Dm5U=;
 b=jvJzoz/V1xeYG9Pb4Ky/NRQGZJwC5h5PBx4GoyEKzLfHyz9Qd3tHMYaFww5Trnjt93CBIMf/0QW8EqUQP5HF+zg/d5GboREYWvteqFWycz2lGhFcWAi6jlWm8zZ33V3GXHyOv6gb9Fy+XRzQq3nUf2j2hqfR3g+HTTnsmzDHMFLQpYI9Yc9pbgLksNCtR3E4d3aqyEz948yisi712fqhGaMyFiVp+s6VGnyROeLmtyZCkN/w+eYDNP5Z510NwtACJXPQTjguIA2MqLoZsJmYeaa0ptKE39cV2AUOOrwJUL+bqDxCB4QGQ3Rj0EzcBECGiTWPzcDFxTr1FeSivy4b5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQFMSfQAbsEUSI3Jph/BToZ98JCiMeJ93p5rV04Dm5U=;
 b=NVmEWhHi+KwX/4Xbvp+iSfiRWYdWgpx7hU49Z+DKO9EdbNcolNvTrKJ9K4JjhiquJAtAZpoNS4DHW6hvx39Qwui4WuOg6f5fzC5C4qp7YW/e8FsyZGolybpJju8TRcTSj8i34iZK1+oz8mov/gNmgZb/IXpETfcy8QYOZZtCfGZr80ZGxU37ssEtLcJFeXyYZDdVnIvNus12ECq5QAFkMPRCdacKRzzQ0hO+1iCnYm4nYnA5nTGj7A2/BKTyFvDeeXuRwrWenCp2KJfnevxoSYQWKeAOrQ0RK7M3beKxtQ+SPyjhAhw1jyHRuWB7nwqTQ7V1ld92+TyHWcQRby850g==
Received: from DM5PR21CA0049.namprd21.prod.outlook.com (2603:10b6:3:129::11)
 by CY4PR1201MB0023.namprd12.prod.outlook.com (2603:10b6:910:1f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Wed, 15 Jun
 2022 01:17:17 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:129:cafe::3e) by DM5PR21CA0049.outlook.office365.com
 (2603:10b6:3:129::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.6 via Frontend
 Transport; Wed, 15 Jun 2022 01:17:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5332.12 via Frontend Transport; Wed, 15 Jun 2022 01:17:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 15 Jun
 2022 01:17:16 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.230.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 14 Jun 2022 18:17:15 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>
CC:     <vkuznets@redhat.com>, <somduttar@nvidia.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v3 2/7] KVM: x86: Move *_in_guest power management flags to vCPU scope
Date:   Tue, 14 Jun 2022 18:16:17 -0700
Message-ID: <20220615011622.136646-3-kechenl@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220615011622.136646-1-kechenl@nvidia.com>
References: <20220615011622.136646-1-kechenl@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31ba33fc-58e7-4a8a-0f64-08da4e6cc994
X-MS-TrafficTypeDiagnostic: CY4PR1201MB0023:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1201MB0023AD1985ABEA01912195E1CAAD9@CY4PR1201MB0023.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WPgBl48aT8wztnA15t8NBN15dYcXCud6ua3pcYLM7jvXeT+75IdlLEPkoLzVYw3Vk240CR6NPXNAEX3BvuOpM7RD8uDJSSmklio1mjgztvBst9nxG5kmUoEu8UY4Ed1OmK3Wb8DwJ95aY1mx1QlbFNb4fsll9FO88+f+i4oNhN6eg+dnYCgF6MWOQjFqhiqCKgW8GU9QGBf30tEqkXgVtosgys0tPv3x10xl18oFE9BXm1XG5r55+QqTanKD+QYixpSBBscghpkno0g6VrMl7oXQKsxdJXYa0qAUwvPV2dwrW8ij4rpKhO8n49HiLrXos5qmIK2Qv+VevcoWfl/Xnf2hn7NQSZf8zXxBzhawGK5rQElh6pnNWkIPf0rRelMYhvJGLX+iNl8snE26oESrzzixG40nwN28W3ahz3mWmOKdVu3Rf/Y1jaHoX658RDFX7rNN7thDpdO7Jd15KIe/43qKJx+tnxueR+CLAfwSfMI2AED+jGKbLxH8tCQHj/+BqvUP/L0zEGtioEk8qJdhpJW5IPhP20Dfw8amnbSGLJqgScgVXY/zlN2VjpNsH2w2hlnGh4hA0uwRv4X6xQGy77Esr+bhUhU1KFXJyg3P6xG3pMc50Mtw5qNkglrWkuMuFPZKex7Vqdbp3hewPpNw3i+2pKtV34qkIzGwkw4mpQ8OjnLNfJY17vVPxFtWeZkJT5Esr7WNLzUXq1VzaYPQJw==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(40470700004)(46966006)(36840700001)(26005)(86362001)(7696005)(356005)(336012)(81166007)(36860700001)(426003)(47076005)(40460700003)(16526019)(1076003)(2616005)(186003)(316002)(36756003)(30864003)(2906002)(110136005)(8936002)(54906003)(4326008)(5660300002)(8676002)(70206006)(82310400005)(508600001)(83380400001)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 01:17:16.9829
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 31ba33fc-58e7-4a8a-0f64-08da4e6cc994
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1201MB0023
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Make the runtime disabled mwait/hlt/pause/cstate exits flags vCPU scope
to allow finer-grained, per-vCPU control.  The VM-scoped control is only
allowed before vCPUs are created, thus preserving the existing behavior
is a simple matter of snapshotting the flags at vCPU creation.

Signed-off-by: Kechen Lu <kechenl@nvidia.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++++
 arch/x86/kvm/cpuid.c            |  4 ++--
 arch/x86/kvm/lapic.c            |  7 +++----
 arch/x86/kvm/svm/nested.c       |  4 ++--
 arch/x86/kvm/svm/svm.c          | 12 ++++++------
 arch/x86/kvm/vmx/vmx.c          | 16 ++++++++--------
 arch/x86/kvm/x86.c              |  6 +++++-
 arch/x86/kvm/x86.h              | 16 ++++++++--------
 8 files changed, 39 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9217bd6cf0d1..573a39bf7a84 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -924,6 +924,11 @@ struct kvm_vcpu_arch {
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
index de6d44e07e34..f013ff4f49c5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -245,8 +245,8 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
 	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
-	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
-		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
+	if (kvm_hlt_in_guest(vcpu) &&
+	    best && (best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0e68b4c937fc..9e29d658a8c2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -147,14 +147,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 {
 	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
-		(kvm_mwait_in_guest(vcpu->kvm) || kvm_hlt_in_guest(vcpu->kvm));
+		(kvm_mwait_in_guest(vcpu) || kvm_hlt_in_guest(vcpu));
 }
 
 bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
 {
-	return kvm_x86_ops.set_hv_timer
-	       && !(kvm_mwait_in_guest(vcpu->kvm) ||
-		    kvm_can_post_timer_interrupt(vcpu));
+	return kvm_x86_ops.set_hv_timer &&
+		!(kvm_mwait_in_guest(vcpu) || kvm_can_post_timer_interrupt(vcpu));
 }
 EXPORT_SYMBOL_GPL(kvm_can_use_hv_timer);
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ba7cd26f438f..f143ec757467 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -675,7 +675,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 
 	pause_count12 = svm->pause_filter_enabled ? svm->nested.ctl.pause_filter_count : 0;
 	pause_thresh12 = svm->pause_threshold_enabled ? svm->nested.ctl.pause_filter_thresh : 0;
-	if (kvm_pause_in_guest(svm->vcpu.kvm)) {
+	if (kvm_pause_in_guest(&svm->vcpu)) {
 		/* use guest values since host doesn't intercept PAUSE */
 		vmcb02->control.pause_filter_count = pause_count12;
 		vmcb02->control.pause_filter_thresh = pause_thresh12;
@@ -951,7 +951,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
 	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
-	if (!kvm_pause_in_guest(vcpu->kvm)) {
+	if (!kvm_pause_in_guest(vcpu)) {
 		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
 		vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 87da90360bc7..b32987f54ace 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -921,7 +921,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	int old = control->pause_filter_count;
 
-	if (kvm_pause_in_guest(vcpu->kvm))
+	if (kvm_pause_in_guest(vcpu))
 		return;
 
 	control->pause_filter_count = __grow_ple_window(old,
@@ -942,7 +942,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	int old = control->pause_filter_count;
 
-	if (kvm_pause_in_guest(vcpu->kvm))
+	if (kvm_pause_in_guest(vcpu))
 		return;
 
 	control->pause_filter_count =
@@ -1136,12 +1136,12 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
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
@@ -1185,7 +1185,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	svm->nested.vmcb12_gpa = INVALID_GPA;
 	svm->nested.last_vmcb12_gpa = INVALID_GPA;
 
-	if (!kvm_pause_in_guest(vcpu->kvm)) {
+	if (!kvm_pause_in_guest(vcpu)) {
 		control->pause_filter_count = pause_filter_count;
 		if (pause_filter_thresh)
 			control->pause_filter_thresh = pause_filter_thresh;
@@ -4269,7 +4269,7 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
-	if (!kvm_pause_in_guest(vcpu->kvm))
+	if (!kvm_pause_in_guest(vcpu))
 		shrink_ple_window(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 553dd2317b9c..f24c9a357f70 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1597,7 +1597,7 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 	 * then the instruction is already executing and RIP has already been
 	 * advanced.
 	 */
-	if (kvm_hlt_in_guest(vcpu->kvm) &&
+	if (kvm_hlt_in_guest(vcpu) &&
 			vmcs_read32(GUEST_ACTIVITY_STATE) == GUEST_ACTIVITY_HLT)
 		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 }
@@ -4212,10 +4212,10 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
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
@@ -4294,7 +4294,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	}
 	if (!enable_unrestricted_guest)
 		exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
-	if (kvm_pause_in_guest(vmx->vcpu.kvm))
+	if (kvm_pause_in_guest(&vmx->vcpu))
 		exec_control &= ~SECONDARY_EXEC_PAUSE_LOOP_EXITING;
 	if (!kvm_vcpu_apicv_active(vcpu))
 		exec_control &= ~(SECONDARY_EXEC_APIC_REGISTER_VIRT |
@@ -4397,7 +4397,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(POSTED_INTR_DESC_ADDR, __pa((&vmx->pi_desc)));
 	}
 
-	if (!kvm_pause_in_guest(vmx->vcpu.kvm)) {
+	if (!kvm_pause_in_guest(&vmx->vcpu)) {
 		vmcs_write32(PLE_GAP, ple_gap);
 		vmx->ple_window = ple_window;
 		vmx->ple_window_dirty = true;
@@ -5562,7 +5562,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
  */
 static int handle_pause(struct kvm_vcpu *vcpu)
 {
-	if (!kvm_pause_in_guest(vcpu->kvm))
+	if (!kvm_pause_in_guest(vcpu))
 		grow_ple_window(vcpu);
 
 	/*
@@ -7059,7 +7059,7 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
-	if (kvm_cstate_in_guest(vcpu->kvm)) {
+	if (kvm_cstate_in_guest(vcpu)) {
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
@@ -7597,7 +7597,7 @@ static void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu)
 
 static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
-	if (!kvm_pause_in_guest(vcpu->kvm))
+	if (!kvm_pause_in_guest(vcpu))
 		shrink_ple_window(vcpu);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ac6329e6d43..b419b258ed90 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11355,6 +11355,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 #if IS_ENABLED(CONFIG_HYPERV)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
 #endif
+	vcpu->arch.mwait_in_guest = vcpu->kvm->arch.mwait_in_guest;
+	vcpu->arch.hlt_in_guest = vcpu->kvm->arch.hlt_in_guest;
+	vcpu->arch.pause_in_guest = vcpu->kvm->arch.pause_in_guest;
+	vcpu->arch.cstate_in_guest = vcpu->kvm->arch.cstate_in_guest;
 
 	r = static_call(kvm_x86_vcpu_create)(vcpu);
 	if (r)
@@ -12539,7 +12543,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 		     vcpu->arch.exception.pending))
 		return false;
 
-	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
+	if (kvm_hlt_in_guest(vcpu) && !kvm_can_deliver_async_pf(vcpu))
 		return false;
 
 	/*
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 588792f00334..a59b73e11726 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -324,24 +324,24 @@ static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
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
 
 enum kvm_intr_type {
-- 
2.32.0

