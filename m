Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D839155D8E
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgBGSQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:57 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40642 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727681AbgBGSQy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:54 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id B89ED305D362;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id AA951305207A;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 68/78] KVM: introspection: restore the state of descriptor interception on unhook
Date:   Fri,  7 Feb 2020 20:16:26 +0200
Message-Id: <20200207181636.1065-69-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This commit also ensures that the introspection tool and the userspace
do not disable each other the descriptor access VM-exit.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h |  4 +++
 arch/x86/kvm/kvmi.c              | 45 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm.c               |  3 +++
 arch/x86/kvm/vmx/vmx.c           |  3 +++
 4 files changed, 55 insertions(+)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 8f9e6bd2953a..10b251856c0e 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -14,6 +14,7 @@ struct kvmi_interception {
 	bool restore_interception;
 	struct kvmi_monitor_interception breakpoint;
 	struct kvmi_monitor_interception cr3w;
+	struct kvmi_monitor_interception descriptor;
 };
 
 struct kvm_vcpu_arch_introspection {
@@ -31,6 +32,7 @@ bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu);
 bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable);
 void kvmi_xsetbv_event(struct kvm_vcpu *vcpu);
+bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu, bool enable);
 bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, u8 write);
 
 #else /* CONFIG_KVM_INTROSPECTION */
@@ -44,6 +46,8 @@ static inline bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu) { return false; }
 static inline bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu,
 						bool enable) { return false; }
 static inline void kvmi_xsetbv_event(struct kvm_vcpu *vcpu) { }
+static inline bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu,
+					       bool enable) { return false; }
 static inline bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
 					 u8 write) { return true; }
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index ed9b45060e2a..048f0e1f9f79 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -311,12 +311,52 @@ static void kvmi_arch_disable_cr3w_intercept(struct kvm_vcpu *vcpu)
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
+			kvm_x86_ops->desc_intercepted(vcpu);
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
 	if (!kvm_x86_ops->umip_emulated())
 		return -KVM_EOPNOTSUPP;
 
+	vcpu->arch.kvmi->descriptor.monitor_fct = monitor_desc_fct_kvmi;
 	kvm_x86_ops->control_desc_intercept(vcpu, enable);
+	vcpu->arch.kvmi->descriptor.monitor_fct = monitor_desc_fct_kvm;
 
 	return 0;
 }
@@ -324,6 +364,9 @@ static int kvmi_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 static void kvmi_arch_disable_desc_intercept(struct kvm_vcpu *vcpu)
 {
 	kvmi_control_desc_intercept(vcpu, false);
+
+	vcpu->arch.kvmi->descriptor.kvmi_intercepted = false;
+	vcpu->arch.kvmi->descriptor.kvm_intercepted = false;
 }
 
 int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
@@ -389,11 +432,13 @@ bool kvmi_arch_vcpu_alloc(struct kvm_vcpu *vcpu)
 
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
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 988eb6937515..7cd48ef25f59 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7388,6 +7388,9 @@ static void svm_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (kvmi_monitor_desc_intercept(vcpu, enable))
+		return;
+
 	if (enable) {
 		set_intercept(svm, INTERCEPT_STORE_IDTR);
 		set_intercept(svm, INTERCEPT_STORE_GDTR);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 68986f600f98..e423dbbf3cf5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3008,6 +3008,9 @@ static void vmx_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (kvmi_monitor_desc_intercept(vcpu, enable))
+		return;
+
 	if (enable)
 		secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
 	else
