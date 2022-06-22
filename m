Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795F3553FC8
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 02:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354770AbiFVAzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jun 2022 20:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355542AbiFVAzL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jun 2022 20:55:11 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2048.outbound.protection.outlook.com [40.107.243.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A69C3120B;
        Tue, 21 Jun 2022 17:55:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XbRuXpuOi5pVo8dfTCX9BPYauPETUHIDgJTO4ffWLsGsLnUcmntiyk12ZM5/4nBbETtzHJKU+Ki4MawRfLIq4xy4AGeKtKBIrx0nlfrBkKeyIQaxo+kO+TV7xmCQtntb9cXMVWXfazPoErN7iE83GqEjxhl0tWzam5UCs37O7gQjBxpHManr8cO8/rDLijWZ+ZWk72x4OH0f39Kgie2KN28FJLPxYREpuvLNKnwvadqZKhRM50J3J+B3Rqs1r+mVGsOfJwNvsnbMGF7wqDkr2Ik2Vj0h29m3uHQcR2lO59aXQW2nz4zTsp6CZlomlcI3J9giQKh28i1/1GylRazAcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AfD+SPzU3vtV5ahCycR/JCfR6nOVjscLOMf4x/bZHtI=;
 b=AW7YuQmjN/Ow7MamkBBMEcnDGCN7qe6GkBxKZlSrcWOjjkVw4Snt/f6plugWtjjQoXnfrFHK4h5jUNGRPFxIOkzLPKKoJQLz4zwRzyLaTObDI88fZ0zTrMfxLL9tc1GkoAL1f6xPNBqSUTqIcLCqfHFKz0NKtpnlJLDIg0TL/juDkO74d4K8moOFtnV5UILwycKWBOXcfWyKdxl21sG51tALJHz6lQFPq7IyKOFkgevCs0XHWeeXSZblkzA3Lo9kvcmF3XMTfzR1YUCSm1NvGWap9gJVftflXCBuu7Rl+xYsl+PKFH9rlmQpoR3lrE9Q9DSzgosG/6ifeMiwVdkPpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AfD+SPzU3vtV5ahCycR/JCfR6nOVjscLOMf4x/bZHtI=;
 b=lMq/hDzcAln7JHtvRkuEbTGPMbcFePUIRKxa/CSQhg6WDzi5phgwYfFRbG5G+NaZreTAWO/qJxSpPM6IhX75d7Zc0Cz3qIawo/Ikx9TnHMaGFND4R9HtrY2Z/uPTg31vIOxaZRfNcCwqMlZU3A01zxEfunSZxWO5xX9Acpnf+VtXoQTL2NbXq0yz0GMAeicF56fGxqKZGv/fUCQ/p3f/+UtRfV/YRhqii1SI9VcJTVyqifkk6X8oSGHj+o7K3+ieU8dkRGW1BhVyHCmZX7owNm4jXJ2SiYiXB+Qc2JuCIPrYcLr75o8EBclz6m9PkxZrGDobcuFpGLNW1N9qK+tjlA==
Received: from MWHPR22CA0060.namprd22.prod.outlook.com (2603:10b6:300:12a::22)
 by MWHPR12MB1757.namprd12.prod.outlook.com (2603:10b6:300:111::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Wed, 22 Jun
 2022 00:55:03 +0000
Received: from CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:12a:cafe::64) by MWHPR22CA0060.outlook.office365.com
 (2603:10b6:300:12a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15 via Frontend
 Transport; Wed, 22 Jun 2022 00:55:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT053.mail.protection.outlook.com (10.13.175.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5373.15 via Frontend Transport; Wed, 22 Jun 2022 00:55:03 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Wed, 22 Jun
 2022 00:54:59 +0000
Received: from foundations-user-AS-2114GT-DNR-C1-NC24B.nvidia.com
 (10.126.231.35) by rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 21 Jun 2022 17:54:58 -0700
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC:     <seanjc@google.com>, <chao.gao@intel.com>, <vkuznets@redhat.com>,
        <somduttar@nvidia.com>, <kechenl@nvidia.com>,
        <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v4 5/7] KVM: x86: add vCPU scoped toggling for disabled exits
Date:   Tue, 21 Jun 2022 17:49:22 -0700
Message-ID: <20220622004924.155191-6-kechenl@nvidia.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220622004924.155191-1-kechenl@nvidia.com>
References: <20220622004924.155191-1-kechenl@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5fe14544-d8d2-4e66-2a34-08da53e9d788
X-MS-TrafficTypeDiagnostic: MWHPR12MB1757:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB17578102D8B3ECC0BF59C017CAB29@MWHPR12MB1757.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: divr3U3P56P8R42Jj/xjF6Zbv2a4u6tyaxuVWzLT141ldJtBqBjVJZrva+3zPZGhZZ0g/6pUyMUs8glGqaPkG5Mw/O5A/P8vayATZ+SIVkHmN8j49XH4AbqwnYScoYkUmx/FRp3Xn/Z6bg59kUCIOIHUuQIlYpaptX9qK0fTky74X/LXkZEdSCvF+J/UsHx/lVHc5+2nbiVDhvYnBjzdvTJ/JVpQ0OfNy9nYW3ALMKMnGEYnV22Hnw2fpSw42ZbUh8RCF+d9/3gPUejW5GjFCva+VVVuXKFkwvhkJnnYSPHGuhom+8dXlhc2ldoJC72c4jQHR5S21FmVgWHRZaC5Kr21e05JQV4oNT/coXvxdnMWkdioBSdd4jTJEslWOCecAQqQHRa6aVszVYGjQhlt7hkknTmQsUh9l0MMe7+hnV0CwlplTIPkwJLodvbGyrp+Nz/XHJUjGjE7IWq5d06ZyP7E4VWAjn4SfGV1KUDop6PsaY/Zr0adamlNKwbu4PT6NXBrWbsHq8CWpxYBeO49D9rk6ZAEKfSDil20ATsVOJ7isoS4XOtAVvlgKA4UGH8mGElbAvU8CrZDy87QBHwF67e4NfCSDefl5f+ESHFZaameHLWuzWYnadDzJbaIN1zQL9HM9AXNKli+dQNxq+8CSsB5vQ0pDOKsxpbKfyZ8ucV2j7pXP1WsJzr+QKTMAUCimPrklBBjYzHdmtN8ABr3IaRMQADVlM15i0kE3QLlPES7hulifkzMFrkgSbyluaRC
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(396003)(346002)(40470700004)(36840700001)(46966006)(6666004)(40460700003)(41300700001)(8936002)(82310400005)(36756003)(7696005)(8676002)(26005)(316002)(54906003)(110136005)(478600001)(70206006)(426003)(336012)(4326008)(83380400001)(86362001)(82740400003)(16526019)(356005)(186003)(47076005)(2616005)(40480700001)(5660300002)(81166007)(2906002)(36860700001)(1076003)(70586007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2022 00:55:03.3607
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fe14544-d8d2-4e66-2a34-08da53e9d788
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT053.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1757
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce support of vCPU-scoped ioctl with KVM_CAP_X86_DISABLE_EXITS
cap for disabling exits to enable finer-grained VM exits disabling
on per vCPU scales instead of whole guest. This patch enabled
the vCPU-scoped exits control toggling, also align the VM-scoped
exits control behaviors. Add a new kvm request KVM_REQ_DISABLE_EXITS
to guarantee updating the vmcs before vCPU entry especially for
toggling the VM-scoped exits.

In use cases like Windows guest running heavy CPU-bound
workloads, disabling HLT VM-exits could mitigate host sched ctx switch
overhead. Simply HLT disabling on all vCPUs could bring
performance benefits, but if no pCPUs reserved for host threads, could
happened to the forced preemption as host does not know the time to do
the schedule for other host threads want to run. With this patch, we
could only disable part of vCPUs HLT exits for one guest, this still
keeps performance benefits, and also shows resiliency to host stressing
workload running at the same time.

In the host stressing workload experiment with Windows guest heavy
CPU-bound workloads, it shows good resiliency and having the ~3%
performance improvement. E.g. Passmark running in a Windows guest
with this patch disabling HLT exits on only half of vCPUs still
showing 2.4% higher main score v/s baseline.

Suggested-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Kechen Lu <kechenl@nvidia.com>
---
 Documentation/virt/kvm/api.rst     |  2 +-
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  3 +++
 arch/x86/kvm/svm/svm.c             | 30 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c             | 37 ++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                 | 23 +++++++++++++++----
 6 files changed, 91 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 89e13b6783b5..7f614b7d5ad8 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6948,7 +6948,7 @@ longer intercept some instructions for improved latency in some
 workloads, and is suggested when vCPUs are associated to dedicated
 physical CPUs.  More bits can be added in the future; userspace can
 just pass the KVM_CHECK_EXTENSION result to KVM_ENABLE_CAP to disable
-all such vmexits.
+all such vmexits. VM scoped and vCPU scoped capability are both supported.
 
 By default, this capability only disables exits.  To re-enable an exit, or to
 override previous settings, userspace can set KVM_X86_DISABLE_EXITS_OVERRIDE,
diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index da47f60a4650..c17d417cb3cf 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -128,6 +128,7 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP(update_disabled_exits)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 573a39bf7a84..86baae62af86 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -105,6 +105,7 @@
 	KVM_ARCH_REQ_FLAGS(30, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_MMU_FREE_OBSOLETE_ROOTS \
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_DISABLE_EXITS		KVM_ARCH_REQ(32)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -1584,6 +1585,8 @@ struct kvm_x86_ops {
 	 * Returns vCPU specific APICv inhibit reasons
 	 */
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
+
+	void (*update_disabled_exits)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b32987f54ace..7b3d64b3b901 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4589,6 +4589,33 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
 	sev_vcpu_deliver_sipi_vector(vcpu, vector);
 }
 
+static void svm_update_disabled_exits(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb_control_area *control = &svm->vmcb->control;
+
+	if (kvm_hlt_in_guest(vcpu))
+		svm_clr_intercept(svm, INTERCEPT_HLT);
+	else
+		svm_set_intercept(svm, INTERCEPT_HLT);
+
+	if (kvm_mwait_in_guest(vcpu)) {
+		svm_clr_intercept(svm, INTERCEPT_MONITOR);
+		svm_clr_intercept(svm, INTERCEPT_MWAIT);
+	} else {
+		svm_set_intercept(svm, INTERCEPT_MONITOR);
+		svm_set_intercept(svm, INTERCEPT_MWAIT);
+	}
+
+	if (kvm_pause_in_guest(vcpu)) {
+		svm_clr_intercept(svm, INTERCEPT_PAUSE);
+	} else {
+		control->pause_filter_count = pause_filter_count;
+		if (pause_filter_thresh)
+			control->pause_filter_thresh = pause_filter_thresh;
+	}
+}
+
 static void svm_vm_destroy(struct kvm *kvm)
 {
 	avic_vm_destroy(kvm);
@@ -4732,7 +4759,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
+
+	.update_disabled_exits = svm_update_disabled_exits,
 };
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f24c9a357f70..2d000638cc9b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7716,6 +7716,41 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 	return supported & BIT(reason);
 }
 
+static void vmx_update_disabled_exits(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_vmx *vmx = to_vmx(vcpu);
+
+	if (kvm_hlt_in_guest(vcpu))
+		exec_controls_clearbit(vmx, CPU_BASED_HLT_EXITING);
+	else
+		exec_controls_setbit(vmx, CPU_BASED_HLT_EXITING);
+
+	if (kvm_mwait_in_guest(vcpu))
+		exec_controls_clearbit(vmx, CPU_BASED_MWAIT_EXITING |
+			CPU_BASED_MONITOR_EXITING);
+	else
+		exec_controls_setbit(vmx, CPU_BASED_MWAIT_EXITING |
+			CPU_BASED_MONITOR_EXITING);
+
+	if (!kvm_pause_in_guest(vcpu)) {
+		vmcs_write32(PLE_GAP, ple_gap);
+		vmx->ple_window = ple_window;
+		vmx->ple_window_dirty = true;
+	}
+
+	if (kvm_cstate_in_guest(vcpu)) {
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
+		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
+	} else {
+		vmx_enable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
+		vmx_enable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
+		vmx_enable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
+		vmx_enable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
+	}
+}
+
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = "kvm_intel",
 
@@ -7849,6 +7884,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.update_disabled_exits = vmx_update_disabled_exits,
 };
 
 static unsigned int vmx_handle_intel_pt_intr(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe114e319a89..6165f0b046ed 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5331,6 +5331,13 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 		if (vcpu->arch.pv_cpuid.enforce)
 			kvm_update_pv_runtime(vcpu);
 
+		return 0;
+	case KVM_CAP_X86_DISABLE_EXITS:
+		if (cap->args[0] & ~kvm_get_allowed_disable_exits())
+			return -EINVAL;
+
+		kvm_ioctl_disable_exits(vcpu->arch, cap->args[0]);
+		kvm_make_request(KVM_REQ_DISABLE_EXITS, vcpu);
 		return 0;
 	default:
 		return -EINVAL;
@@ -5980,6 +5987,8 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_event,
 int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			    struct kvm_enable_cap *cap)
 {
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
 	int r;
 
 	if (cap->flags)
@@ -6036,14 +6045,17 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 			break;
 
 		mutex_lock(&kvm->lock);
-		if (kvm->created_vcpus)
-			goto disable_exits_unlock;
+		if (kvm->created_vcpus) {
+			kvm_for_each_vcpu(i, vcpu, kvm) {
+				kvm_ioctl_disable_exits(vcpu->arch, cap->args[0]);
+				kvm_make_request(KVM_REQ_DISABLE_EXITS, vcpu);
+			}
+		}
+		mutex_unlock(&kvm->lock);
 
 		kvm_ioctl_disable_exits(kvm->arch, cap->args[0]);
 
 		r = 0;
-disable_exits_unlock:
-		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
 		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];
@@ -10175,6 +10187,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+
+		if (kvm_check_request(KVM_REQ_DISABLE_EXITS, vcpu))
+			static_call(kvm_x86_update_disabled_exits)(vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
-- 
2.32.0

