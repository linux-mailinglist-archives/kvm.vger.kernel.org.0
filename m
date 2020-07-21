Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC95228AE5
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731308AbgGUVQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:05 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37984 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731241AbgGUVQB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:01 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id CDB25305D502;
        Wed, 22 Jul 2020 00:09:30 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id AD00C304FA12;
        Wed, 22 Jul 2020 00:09:30 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 74/84] KVM: introspection: restore the state of descriptor-table register interception on unhook
Date:   Wed, 22 Jul 2020 00:09:12 +0300
Message-Id: <20200721210922.7646-75-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This commit also ensures that the introspection tool and the userspace
do not disable each other the descriptor-table access VM-exit.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h |  4 +++
 arch/x86/kvm/kvmi.c              | 45 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c           |  3 +++
 arch/x86/kvm/vmx/vmx.c           |  3 +++
 4 files changed, 55 insertions(+)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 09ebed80a8cc..0ed1879fd250 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -17,6 +17,7 @@ struct kvmi_interception {
 	bool restore_interception;
 	struct kvmi_monitor_interception breakpoint;
 	struct kvmi_monitor_interception cr3w;
+	struct kvmi_monitor_interception descriptor;
 };
 
 struct kvm_vcpu_arch_introspection {
@@ -35,6 +36,7 @@ bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu);
 bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable);
 void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
 		       u64 old_value, u64 new_value);
+bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu, bool enable);
 bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write);
 
 #else /* CONFIG_KVM_INTROSPECTION */
@@ -50,6 +52,8 @@ static inline bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu,
 						bool enable) { return false; }
 static inline void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
 					u64 old_value, u64 new_value) { }
+static inline bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu,
+					       bool enable) { return false; }
 static inline bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
 					 bool write) { return true; }
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 3ae43a4c8764..dfe1b887b4f3 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -361,12 +361,52 @@ static void kvmi_arch_disable_cr3w_intercept(struct kvm_vcpu *vcpu)
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
@@ -374,6 +414,9 @@ static int kvmi_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 static void kvmi_arch_disable_desc_intercept(struct kvm_vcpu *vcpu)
 {
 	kvmi_control_desc_intercept(vcpu, false);
+
+	vcpu->arch.kvmi->descriptor.kvmi_intercepted = false;
+	vcpu->arch.kvmi->descriptor.kvm_intercepted = false;
 }
 
 int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
@@ -445,11 +488,13 @@ bool kvmi_arch_vcpu_alloc_interception(struct kvm_vcpu *vcpu)
 
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
index a0b91007e484..20f6905b45aa 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1555,6 +1555,9 @@ static void svm_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (kvmi_monitor_desc_intercept(vcpu, enable))
+		return;
+
 	if (enable) {
 		set_intercept(svm, INTERCEPT_STORE_IDTR);
 		set_intercept(svm, INTERCEPT_STORE_GDTR);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 74bdcd4966ca..8d396a2d2309 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3162,6 +3162,9 @@ static void vmx_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (kvmi_monitor_desc_intercept(vcpu, enable))
+		return;
+
 	if (enable)
 		secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
 	else
