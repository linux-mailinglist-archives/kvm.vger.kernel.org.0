Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9418966A592
	for <lists+kvm@lfdr.de>; Fri, 13 Jan 2023 23:02:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231169AbjAMWCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Jan 2023 17:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbjAMWCJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Jan 2023 17:02:09 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2044.outbound.protection.outlook.com [40.107.220.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F27C6CFF8;
        Fri, 13 Jan 2023 14:02:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bY3c1f/Q7GK+Qyt07ynL486uRnHUT2BrYxzcRPf3mvZslAfhcxpoozPnYhZ+sUhPBSgORITtPA3IMkqgEAQgeUsK6bjCuLAyKmlPRuo4cYEF0p637tLmkgG+fQ/fKsLGz8/BPgXo75SiIbSkk7YiOgELEFio+8mK49J5IlW102OsCYGL89czasFEehkYeHeKcXyYGkRTY9VC3DEcLEmydGArX8JJ26MHAzu+VeRdl626i25ekfBp1yZ9FvcaBLLkXozhaC8cg7H284LdFo7P0hc2Z15s82UFrcQV0o00XfQzuQrnX1OCESdl08BigUrxOVth/ZTVxhNiYDSkVWq4eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ifqlyX1+U3lHcUzvf1Q9I0DTmIcUk92W/dHamwnNkIU=;
 b=cgb7R5j8p2aHaincMScJNx/oLoMha1+HUiu7UwZAaB3nxHy2VSCdXRAcuPYaDdU7zHH8nI0uVX7Quj4DH2imIvZOjMfWQPJi73teM9pZciAVRKlBB1kpX13Ex51xSR3zSVLsaJ+UD9yiQbWzXyHblW9T8sodwf1KOtc/ux4AO7chWlWrCj6n35vxsB0QA/PGXhpmyLbrZGDwMZVKKrg5BIsCdIu+t8pxaWkWro1Nhze1UZBpQcN5yu0uZPpr4r/MNKNKrRBWR0Nu7pFj9fbrxnBPkzq89Z2HpcxVwIg8Jiveb7fm4Nk68s4bJGVyswewYCphqsJwJ0lE91MwvvJpkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ifqlyX1+U3lHcUzvf1Q9I0DTmIcUk92W/dHamwnNkIU=;
 b=TcwM9VkBKGAEzzhOBNCYBg/IFAzHgu/zLMJexyL2eAxnIT+kPs7wok5mux2bvQM71VTpqb03WHLS+JnyyH/83vWtLkklEdm/5rp02kCFu9IQKZstvUf7xM4Np30FGPYDaz4D0bnw+8HMbXtvbYNqe9WAGfle82HVwqVAu8gGASzxizF/F5ZpgaK+BwI03hVJtgEGkw4AKpLJHAaGiBqa2/kO7PZdNKqiqGeSzwuscnWYSM2ClY5nlyutFaw6sDHjry8O2IHdaLhbXxD2ynEki2DOeQShKvDvGKQ//mz/V82sTqOvNzHBwbnfDAdjvXwo/o8VMI27kwxYPNSXuQjRyQ==
Received: from DM6PR06CA0051.namprd06.prod.outlook.com (2603:10b6:5:54::28) by
 MW4PR12MB7032.namprd12.prod.outlook.com (2603:10b6:303:20a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Fri, 13 Jan
 2023 22:02:04 +0000
Received: from DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::3f) by DM6PR06CA0051.outlook.office365.com
 (2603:10b6:5:54::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.14 via Frontend
 Transport; Fri, 13 Jan 2023 22:02:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT027.mail.protection.outlook.com (10.13.172.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13 via Frontend Transport; Fri, 13 Jan 2023 22:02:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 14:01:52 -0800
Received: from dvt1-1.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 13 Jan
 2023 14:01:52 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC:     <chao.gao@intel.com>, <shaoqin.huang@intel.com>,
        <vkuznets@redhat.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v5 2/6] KVM: x86: Move *_in_guest power management flags to vCPU scope
Date:   Fri, 13 Jan 2023 22:01:10 +0000
Message-ID: <20230113220114.2437-3-kechenl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230113220114.2437-1-kechenl@nvidia.com>
References: <20230113220114.2437-1-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT027:EE_|MW4PR12MB7032:EE_
X-MS-Office365-Filtering-Correlation-Id: 41d83069-4c1c-4191-d926-08daf5b1ce61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z6VH4hzmpEoSCYWzbNsItXyU4lgDkKd641wjDKAo9pnrydPOnwJ8dJs0vCx797C5vFFxzAAd0qfDwRQPUymIv4juYL+mFaU8WlIigrzu6dJyYwvOUaIJJ6WJWT5Z+7NoM8BvM5oYHfoKz8JNQprWxW9eU4nT+VbYy8mZuLqqNWkImzJYcKdThVBMLwLsrHear+NzBlfrvZmiw2KrMXjkulckHCd6zLPSR8OyJ85AUiAaZE+cBn7WeBiLFbsz7hSDE+j+KY+Ljwh0MvGo1XUaTMCwNvZE+AioPb86bTrfMyBgr3gXcmLJq6330fZXwn7njA6g49c/taOi9hZ3qt90lycV7Hugyhq/yn4CU1OCmaCawA33zYzS0nkb6HG4oppnGS2V4zlD6gHRUKiIp2FF6KJWcXr2qMsskPi/p+ViOisaAy4FxsQpk10uJgJlODVv9Nl0VEZKCf1K2McoTGgg9W4OPt4lK9+Y7RD3jtTunlZqVAJ0oePlOI0rjLToSxWKMjcuHyGXeb0ofQSut9G6rxcgtze1sFCz0Ooql1NsuwV++Q6Sxi6/nPoBdZUJtBnKzCEqgsxVJPGpQiZege4NROWlBqgEzdolWFfAj0p+w42kyBLAm3HL0RWbwzgbBucn6YZelQr7f/mVBmRfbJBAdsISaht0n/+8vr/NO31IsrkRDXSb1nx9S5Q6pm6prMs5AH08IUForuvBsOL1D51Z/Q==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(136003)(396003)(451199015)(40470700004)(36840700001)(46966006)(356005)(82740400003)(8936002)(30864003)(5660300002)(40460700003)(82310400005)(41300700001)(426003)(47076005)(478600001)(40480700001)(4326008)(316002)(8676002)(70586007)(70206006)(336012)(36756003)(86362001)(36860700001)(83380400001)(54906003)(2906002)(2616005)(7636003)(1076003)(6666004)(26005)(186003)(16526019)(7696005)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2023 22:02:04.5319
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 41d83069-4c1c-4191-d926-08daf5b1ce61
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT027.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7032
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
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
index 6aaae18f1854..41b998234a04 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1009,6 +1009,11 @@ struct kvm_vcpu_arch {
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
index 596061c1610e..20e427dc608c 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -283,8 +283,8 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
 	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
-	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
-		(best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
+	if (kvm_hlt_in_guest(vcpu) &&
+	    best && (best->eax & (1 << KVM_FEATURE_PV_UNHALT)))
 		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
 
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4efdb4a4d72c..8f74f9a80aa5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -151,14 +151,13 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
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
+	        !(kvm_mwait_in_guest(vcpu) || kvm_can_post_timer_interrupt(vcpu));
 }
 
 static bool kvm_use_posted_timer_interrupt(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index add65dd59756..ed26b6de3007 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -721,7 +721,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 
 	pause_count12 = svm->pause_filter_enabled ? svm->nested.ctl.pause_filter_count : 0;
 	pause_thresh12 = svm->pause_threshold_enabled ? svm->nested.ctl.pause_filter_thresh : 0;
-	if (kvm_pause_in_guest(svm->vcpu.kvm)) {
+	if (kvm_pause_in_guest(&svm->vcpu)) {
 		/* use guest values since host doesn't intercept PAUSE */
 		vmcb02->control.pause_filter_count = pause_count12;
 		vmcb02->control.pause_filter_thresh = pause_thresh12;
@@ -1012,7 +1012,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->control.event_inj         = svm->nested.ctl.event_inj;
 	vmcb12->control.event_inj_err     = svm->nested.ctl.event_inj_err;
 
-	if (!kvm_pause_in_guest(vcpu->kvm)) {
+	if (!kvm_pause_in_guest(vcpu)) {
 		vmcb01->control.pause_filter_count = vmcb02->control.pause_filter_count;
 		vmcb_mark_dirty(vmcb01, VMCB_INTERCEPTS);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9a194aa1a75a..dc7176605e01 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1014,7 +1014,7 @@ static void grow_ple_window(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	int old = control->pause_filter_count;
 
-	if (kvm_pause_in_guest(vcpu->kvm))
+	if (kvm_pause_in_guest(vcpu))
 		return;
 
 	control->pause_filter_count = __grow_ple_window(old,
@@ -1035,7 +1035,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	int old = control->pause_filter_count;
 
-	if (kvm_pause_in_guest(vcpu->kvm))
+	if (kvm_pause_in_guest(vcpu))
 		return;
 
 	control->pause_filter_count =
@@ -1229,12 +1229,12 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
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
@@ -1278,7 +1278,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	svm->nested.vmcb12_gpa = INVALID_GPA;
 	svm->nested.last_vmcb12_gpa = INVALID_GPA;
 
-	if (!kvm_pause_in_guest(vcpu->kvm)) {
+	if (!kvm_pause_in_guest(vcpu)) {
 		control->pause_filter_count = pause_filter_count;
 		if (pause_filter_thresh)
 			control->pause_filter_thresh = pause_filter_thresh;
@@ -4362,7 +4362,7 @@ static void svm_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 
 static void svm_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
-	if (!kvm_pause_in_guest(vcpu->kvm))
+	if (!kvm_pause_in_guest(vcpu))
 		shrink_ple_window(vcpu);
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index fc9008dbed33..019a20029878 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1689,7 +1689,7 @@ static void vmx_clear_hlt(struct kvm_vcpu *vcpu)
 	 * then the instruction is already executing and RIP has already been
 	 * advanced.
 	 */
-	if (kvm_hlt_in_guest(vcpu->kvm) &&
+	if (kvm_hlt_in_guest(vcpu) &&
 			vmcs_read32(GUEST_ACTIVITY_STATE) == GUEST_ACTIVITY_HLT)
 		vmcs_write32(GUEST_ACTIVITY_STATE, GUEST_ACTIVITY_ACTIVE);
 }
@@ -4412,10 +4412,10 @@ static u32 vmx_exec_control(struct vcpu_vmx *vmx)
 		exec_control &= ~(CPU_BASED_CR3_LOAD_EXITING |
 				  CPU_BASED_CR3_STORE_EXITING |
 				  CPU_BASED_INVLPG_EXITING);
-	if (kvm_mwait_in_guest(vmx->vcpu.kvm))
+	if (kvm_mwait_in_guest(&vmx->vcpu))
 		exec_control &= ~(CPU_BASED_MWAIT_EXITING |
 				CPU_BASED_MONITOR_EXITING);
-	if (kvm_hlt_in_guest(vmx->vcpu.kvm))
+	if (kvm_hlt_in_guest(&vmx->vcpu))
 		exec_control &= ~CPU_BASED_HLT_EXITING;
 	return exec_control;
 }
@@ -4515,7 +4515,7 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	}
 	if (!enable_unrestricted_guest)
 		exec_control &= ~SECONDARY_EXEC_UNRESTRICTED_GUEST;
-	if (kvm_pause_in_guest(vmx->vcpu.kvm))
+	if (kvm_pause_in_guest(&vmx->vcpu))
 		exec_control &= ~SECONDARY_EXEC_PAUSE_LOOP_EXITING;
 	if (!kvm_vcpu_apicv_active(vcpu))
 		exec_control &= ~(SECONDARY_EXEC_APIC_REGISTER_VIRT |
@@ -4661,7 +4661,7 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write16(LAST_PID_POINTER_INDEX, kvm->arch.max_vcpu_ids - 1);
 	}
 
-	if (!kvm_pause_in_guest(kvm)) {
+	if (!kvm_pause_in_guest(&vmx->vcpu)) {
 		vmcs_write32(PLE_GAP, ple_gap);
 		vmx->ple_window = ple_window;
 		vmx->ple_window_dirty = true;
@@ -5833,7 +5833,7 @@ static void shrink_ple_window(struct kvm_vcpu *vcpu)
  */
 static int handle_pause(struct kvm_vcpu *vcpu)
 {
-	if (!kvm_pause_in_guest(vcpu->kvm))
+	if (!kvm_pause_in_guest(vcpu))
 		grow_ple_window(vcpu);
 
 	/*
@@ -7379,7 +7379,7 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
 	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
-	if (kvm_cstate_in_guest(vcpu->kvm)) {
+	if (kvm_cstate_in_guest(vcpu)) {
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
 		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
@@ -7935,7 +7935,7 @@ static void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu)
 
 static void vmx_sched_in(struct kvm_vcpu *vcpu, int cpu)
 {
-	if (!kvm_pause_in_guest(vcpu->kvm))
+	if (!kvm_pause_in_guest(vcpu))
 		shrink_ple_window(vcpu);
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c8ae9c4f9f08..9a77b55142c6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11634,6 +11634,10 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 #if IS_ENABLED(CONFIG_HYPERV)
 	vcpu->arch.hv_root_tdp = INVALID_PAGE;
 #endif
+	vcpu->arch.mwait_in_guest = vcpu->kvm->arch.mwait_in_guest;
+	vcpu->arch.hlt_in_guest = vcpu->kvm->arch.hlt_in_guest;
+	vcpu->arch.pause_in_guest = vcpu->kvm->arch.pause_in_guest;
+	vcpu->arch.cstate_in_guest = vcpu->kvm->arch.cstate_in_guest;
 
 	r = static_call(kvm_x86_vcpu_create)(vcpu);
 	if (r)
@@ -12885,7 +12889,7 @@ bool kvm_can_do_async_pf(struct kvm_vcpu *vcpu)
 		     kvm_is_exception_pending(vcpu)))
 		return false;
 
-	if (kvm_hlt_in_guest(vcpu->kvm) && !kvm_can_deliver_async_pf(vcpu))
+	if (kvm_hlt_in_guest(vcpu) && !kvm_can_deliver_async_pf(vcpu))
 		return false;
 
 	/*
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 9de72586f406..b8e49a9d353d 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -351,24 +351,24 @@ static inline u64 nsec_to_cycles(struct kvm_vcpu *vcpu, u64 nsec)
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
 
 static inline bool kvm_notify_vmexit_enabled(struct kvm *kvm)
-- 
2.34.1

