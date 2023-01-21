Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263216762E6
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 03:08:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbjAUCIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 21:08:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbjAUCIo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 21:08:44 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2041.outbound.protection.outlook.com [40.107.92.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A92A707C6;
        Fri, 20 Jan 2023 18:08:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iIG6km1wkmAXOCUKNiqgy1RVIglG5MrMWOqjela9kn5DUs62G/9l5QEPiwjQbBAqfEsvHeOeXV3cH9pwKDCA2DPCiyx+qbU9wvZX2VHc+LIa6Z8bftYCDYipTBHVIjpUJisLhTwResjrsFCTMKXd0EBUdFpTtf3us61f7Nkf1SvoyC8ZBQQSFZsFpjOSzQzZfWYiE/cEMuJWorhryh/QKQ4ixMhaDj5eyvMnRmeXGiBUzefBAljl3VJPtRN9Ni0tq7q16s4H/vMvj9FNPghVOo9BUJU7hf09xTpa5k+QfB54/1XWUlpyvs08soBu++yGdSrzp7c6h9DMIh599QIYiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pCVwnfon+D+exnG4W9ehny4BDM7lJpQ2S3wz9rg4rFw=;
 b=D7MWpfXBagCvNghDOfuSxPU+B65puZDHfVxkChNtBaIRVR/KsRcLHgejD/kXU2cS042hzWzxg4xk70o89jxsPrAiHizY+fuv8kM7z9tCvWd88kU9Ki9zRp2t8pBwW4BUzOwJyvUK2UHdZfoLNXstBPFQ6WyWigvd8l+5XLUHVKPM8x9xb5bnCtlDKkRo9TeJk0P3E0AWg65EyaXxXmRWricJwfjFr60wITf51izyFUbrbfXusEdIDd1M6/CjYOzkKnocO9v0ow55mNwz9FjtmIJ4+1Lq22nVixFyBCKvosSQddn0U2Xwf/yCxNzj8PvxqG6IULy1pC8b9gkuZi3Y/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCVwnfon+D+exnG4W9ehny4BDM7lJpQ2S3wz9rg4rFw=;
 b=jE/Nd76SvfBF8D0m2QCABukHBU9RDnduBmkdAb1I2FKJSboY0MjET6Em5dmxUOwmG7yawoWJZIpeDn0lmWFHcsU28qlTy/Vbl9nbcWbYdIzq3rOtUVXydnXilKh2uF59V/kydhqXncZ7GZCMZZNEqaOvsIE8CEofXVMUKC5c/n/DxAS0uZm80snczdNLv9pcP3Xu6KcIGpip319DgPm+y7S0Az937do6ntt3pp3ZAKtMk7Gq+x2pdKYsnF5szTwpZmZzUAyh2ZdcCpzrytCnWkJAjn9GCg2xkfEayUvW8DrDt/+eaRMFEtV0C+HHV4QbJ9lEk5sJhEX1SRsHfuFuAQ==
Received: from BN9P222CA0027.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::32)
 by CH0PR12MB5121.namprd12.prod.outlook.com (2603:10b6:610:bc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Sat, 21 Jan
 2023 02:08:29 +0000
Received: from BN8NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::50) by BN9P222CA0027.outlook.office365.com
 (2603:10b6:408:10c::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27 via Frontend
 Transport; Sat, 21 Jan 2023 02:08:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT069.mail.protection.outlook.com (10.13.176.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6023.16 via Frontend Transport; Sat, 21 Jan 2023 02:08:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 20 Jan
 2023 18:08:19 -0800
Received: from dvt1-1.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 20 Jan
 2023 18:08:18 -0800
From:   Kechen Lu <kechenl@nvidia.com>
To:     <kvm@vger.kernel.org>, <seanjc@google.com>, <pbonzini@redhat.com>
CC:     <zhi.wang.linux@gmail.com>, <chao.gao@intel.com>,
        <shaoqin.huang@intel.com>, <vkuznets@redhat.com>,
        <kechenl@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [RFC PATCH v6 5/6] KVM: x86: add vCPU scoped toggling for disabled exits
Date:   Sat, 21 Jan 2023 02:07:37 +0000
Message-ID: <20230121020738.2973-6-kechenl@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230121020738.2973-1-kechenl@nvidia.com>
References: <20230121020738.2973-1-kechenl@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT069:EE_|CH0PR12MB5121:EE_
X-MS-Office365-Filtering-Correlation-Id: 63b30690-28d3-4d06-ed8f-08dafb5463a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xIgkTo1cI7OE4eoLmDiVKPZzKhY04TwXYZXamip44HTbJyRIWK5SpSifeU3dRftMXETa2bDwOOVDM0Habv3yFt+Lp3nf54zSHtuFGj055Mq52nR5yQ8UNuD+H8FbxPgWa30GgcW8DA6hp8aOdoCFkDCZ8fYShOcnsFk4PMfwr/Uc369bnvO+R8uIJbTOLXMtPCcyNTDcV42afV3K0Io29UzV2WWEH6TpnCAj2bBSNUWB5KRpL1CumtjiqG1z47sgVq25Fd9nkQuRwSx5I7n1KPVaN1xSzYhG7d+QT+4NklcGdr6fr1hcIr9XXIG02tiPyAZxV3zy7rxP4Z5jMkkd/YXia7Wz4mkuITjN6bbPW9PtmSDVn2e7ZZsKObshK/wNK2/1T53HKl2jvaRmzVbZPawVnk3tfjqElfaFGPDw+wrACrxxtdaNVFgpjoVuL0ms6PFAFSQ6bp1Nw+evIEQPgTu0ilHb7KKNJ6Plh6xpqaQ55XyrU5uBnQt3nltPBWLNbKWGhgERNGFAVGrTFkVr3EEtV2+iYS9fyMHjkkP3zdMl6nh3Qtk1cwXiHOgm9JsmfxjA/ExoSkcGVxOIlXHBeTZEjiVLS88LeUxlSX6jEhfZeQuVOYosC2N2e66BYvTM4IxBHk7cg6Ps6pKcngI+IIyQvBOYDnaSR+IdggqJp713rd0TRRnawV8+8+ueQMqd3cIHrlI1cNvVLeJSin3omw==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199015)(46966006)(40470700004)(36840700001)(5660300002)(8936002)(4326008)(82310400005)(8676002)(70586007)(70206006)(36860700001)(36756003)(6666004)(186003)(16526019)(2906002)(54906003)(110136005)(26005)(7696005)(316002)(478600001)(2616005)(83380400001)(41300700001)(356005)(40460700003)(82740400003)(40480700001)(1076003)(86362001)(7636003)(47076005)(336012)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2023 02:08:29.2155
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63b30690-28d3-4d06-ed8f-08dafb5463a8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5121
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce support of vCPU-scoped ioctl with KVM_CAP_X86_DISABLE_EXITS
cap for disabling exits to enable finer-grained VM exits disabling
on per vCPU scales instead of whole guest. This patch enables
the vCPU-scoped exits control toggling, but keeps the VM-scoped
exits control behaviors restriction as before.

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
 arch/x86/include/asm/kvm_host.h    |  2 ++
 arch/x86/kvm/svm/svm.c             | 30 ++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.c             | 37 ++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                 |  7 ++++++
 6 files changed, 78 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 3850202942d0..698f476d36dd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7102,7 +7102,7 @@ longer intercept some instructions for improved latency in some
 workloads, and is suggested when vCPUs are associated to dedicated
 physical CPUs.  More bits can be added in the future; userspace can
 just pass the KVM_CHECK_EXTENSION result to KVM_ENABLE_CAP to disable
-all such vmexits.
+all such vmexits. VM scoped and vCPU scoped capability are both supported.
 
 By default, this capability only disables exits.  To re-enable an exit, or to
 override previous settings, userspace can set KVM_X86_DISABLE_EXITS_OVERRIDE,
diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index abccd51dcfca..534322c21168 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -131,6 +131,7 @@ KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP(update_disabled_exits)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 41b998234a04..e21e5d452b5d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1711,6 +1711,8 @@ struct kvm_x86_ops {
 	 * Returns vCPU specific APICv inhibit reasons
 	 */
 	unsigned long (*vcpu_get_apicv_inhibit_reasons)(struct kvm_vcpu *vcpu);
+
+	void (*update_disabled_exits)(struct kvm_vcpu *vcpu);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dc7176605e01..81c387dfa46c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4680,6 +4680,33 @@ static void svm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
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
@@ -4825,7 +4852,10 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.complete_emulated_msr = svm_complete_emulated_msr,
 
 	.vcpu_deliver_sipi_vector = svm_vcpu_deliver_sipi_vector,
+
 	.vcpu_get_apicv_inhibit_reasons = avic_vcpu_get_apicv_inhibit_reasons,
+
+	.update_disabled_exits = svm_update_disabled_exits,
 };
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 019a20029878..f5137afdd424 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8070,6 +8070,41 @@ static void vmx_vm_destroy(struct kvm *kvm)
 	free_pages((unsigned long)kvm_vmx->pid_table, vmx_get_pid_table_order(kvm));
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
 
@@ -8207,6 +8242,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
+
+	.update_disabled_exits = vmx_update_disabled_exits,
 };
 
 static unsigned int vmx_handle_intel_pt_intr(void)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3ea5f12536a0..8c15292c6886 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5552,6 +5552,13 @@ static int kvm_vcpu_ioctl_enable_cap(struct kvm_vcpu *vcpu,
 		if (vcpu->arch.pv_cpuid.enforce)
 			kvm_update_pv_runtime(vcpu);
 
+		return 0;
+	case KVM_CAP_X86_DISABLE_EXITS:
+		if (cap->args[0] & ~kvm_get_allowed_disable_exits())
+			return -EINVAL;
+
+		kvm_ioctl_disable_exits(vcpu->arch, cap->args[0]);
+		static_call(kvm_x86_update_disabled_exits)(vcpu);
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.34.1

