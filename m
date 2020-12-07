Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE98D2D1B41
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbgLGUt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:49:26 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42574 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727460AbgLGUsr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:47 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id B4EFF305D480;
        Mon,  7 Dec 2020 22:46:24 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 93DF23072785;
        Mon,  7 Dec 2020 22:46:24 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 71/81] KVM: introspection: restore the state of descriptor-table register interception on unhook
Date:   Mon,  7 Dec 2020 22:46:12 +0200
Message-Id: <20201207204622.15258-72-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This commit also ensures that the introspection tool and the userspace
do not disable each other the descriptor-table access VM-exit.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h |  4 +++
 arch/x86/kvm/kvmi.c              | 45 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c           |  3 +++
 arch/x86/kvm/vmx/vmx.c           |  3 +++
 4 files changed, 55 insertions(+)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index a24ba87036f7..a872277eba67 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -17,6 +17,7 @@ struct kvmi_interception {
 	bool restore_interception;
 	struct kvmi_monitor_interception breakpoint;
 	struct kvmi_monitor_interception cr3w;
+	struct kvmi_monitor_interception descriptor;
 };
 
 struct kvm_vcpu_arch_introspection {
@@ -48,6 +49,7 @@ bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable);
 void kvmi_enter_guest(struct kvm_vcpu *vcpu);
 void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
 		       u64 old_value, u64 new_value);
+bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu, bool enable);
 bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write);
 
 #else /* CONFIG_KVM_INTROSPECTION */
@@ -64,6 +66,8 @@ static inline bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu,
 static inline void kvmi_enter_guest(struct kvm_vcpu *vcpu) { }
 static inline void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
 					u64 old_value, u64 new_value) { }
+static inline bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu,
+					       bool enable) { return false; }
 static inline bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
 					 bool write) { return true; }
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 3d5b041de634..4106ae63a115 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -286,12 +286,52 @@ static void kvmi_arch_disable_cr3w_intercept(struct kvm_vcpu *vcpu)
 	vcpu->arch.kvmi->cr3w.kvm_intercepted = false;
 }
 
+/*
+ * Returns true if one side (kvm or kvmi) tries to disable the descriptor
+ * interception while the other side is still tracking it.
+ */
+bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	struct kvmi_interception *arch_vcpui = READ_ONCE(vcpu->arch.kvmi);
+
+	return (arch_vcpui && arch_vcpui->descriptor.monitor_fct(vcpu, enable));
+}
+EXPORT_SYMBOL(kvmi_monitor_desc_intercept);
+
+static bool monitor_desc_fct_kvmi(struct kvm_vcpu *vcpu, bool enable)
+{
+	vcpu->arch.kvmi->descriptor.kvmi_intercepted = enable;
+
+	if (enable)
+		vcpu->arch.kvmi->descriptor.kvm_intercepted =
+			kvm_x86_ops.desc_intercepted(vcpu);
+	else if (vcpu->arch.kvmi->descriptor.kvm_intercepted)
+		return true;
+
+	return false;
+}
+
+static bool monitor_desc_fct_kvm(struct kvm_vcpu *vcpu, bool enable)
+{
+	if (!vcpu->arch.kvmi->descriptor.kvmi_intercepted)
+		return false;
+
+	vcpu->arch.kvmi->descriptor.kvm_intercepted = enable;
+
+	if (!enable)
+		return true;
+
+	return false;
+}
+
 static int kvmi_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 {
 	if (!kvm_x86_ops.desc_ctrl_supported())
 		return -KVM_EOPNOTSUPP;
 
+	vcpu->arch.kvmi->descriptor.monitor_fct = monitor_desc_fct_kvmi;
 	kvm_x86_ops.control_desc_intercept(vcpu, enable);
+	vcpu->arch.kvmi->descriptor.monitor_fct = monitor_desc_fct_kvm;
 
 	return 0;
 }
@@ -299,6 +339,9 @@ static int kvmi_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 static void kvmi_arch_disable_desc_intercept(struct kvm_vcpu *vcpu)
 {
 	kvmi_control_desc_intercept(vcpu, false);
+
+	vcpu->arch.kvmi->descriptor.kvmi_intercepted = false;
+	vcpu->arch.kvmi->descriptor.kvm_intercepted = false;
 }
 
 int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
@@ -370,11 +413,13 @@ bool kvmi_arch_vcpu_alloc_interception(struct kvm_vcpu *vcpu)
 
 	arch_vcpui->breakpoint.monitor_fct = monitor_bp_fct_kvm;
 	arch_vcpui->cr3w.monitor_fct = monitor_cr3w_fct_kvm;
+	arch_vcpui->descriptor.monitor_fct = monitor_desc_fct_kvm;
 
 	/*
 	 * paired with:
 	 *  - kvmi_monitor_bp_intercept()
 	 *  - kvmi_monitor_cr3w_intercept()
+	 *  - kvmi_monitor_desc_intercept()
 	 */
 	smp_wmb();
 	WRITE_ONCE(vcpu->arch.kvmi, arch_vcpui);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5b689d3fe3e4..834e4b6c4112 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1670,6 +1670,9 @@ static void svm_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (kvmi_monitor_desc_intercept(vcpu, enable))
+		return;
+
 	if (enable) {
 		svm_set_intercept(svm, INTERCEPT_STORE_IDTR);
 		svm_set_intercept(svm, INTERCEPT_STORE_GDTR);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 3afdf532b030..245332ce91a5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3130,6 +3130,9 @@ static void vmx_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (kvmi_monitor_desc_intercept(vcpu, enable))
+		return;
+
 	if (enable)
 		secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
 	else
