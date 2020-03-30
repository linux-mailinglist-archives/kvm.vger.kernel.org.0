Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E694F1978D2
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729778AbgC3KUJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:09 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43782 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729738AbgC3KUI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:08 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id B7A81305D3CD;
        Mon, 30 Mar 2020 13:13:00 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 99F83305B7A2;
        Mon, 30 Mar 2020 13:13:00 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 71/81] KVM: introspection: restore the state of descriptor-table register interception on unhook
Date:   Mon, 30 Mar 2020 13:12:58 +0300
Message-Id: <20200330101308.21702-72-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
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
index 7633501031d2..3c4bba88b50d 100644
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
 bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor, bool write);
 
 #else /* CONFIG_KVM_INTROSPECTION */
@@ -44,6 +46,8 @@ static inline bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu) { return false; }
 static inline bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu,
 						bool enable) { return false; }
 static inline void kvmi_xsetbv_event(struct kvm_vcpu *vcpu) { }
+static inline bool kvmi_monitor_desc_intercept(struct kvm_vcpu *vcpu,
+					       bool enable) { return false; }
 static inline bool kvmi_descriptor_event(struct kvm_vcpu *vcpu, u8 descriptor,
 					 bool write) { return true; }
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 093ff0da88ff..11178bd75cb4 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -360,12 +360,52 @@ static void kvmi_arch_disable_cr3w_intercept(struct kvm_vcpu *vcpu)
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
 	if (!kvm_x86_ops->desc_ctrl_supported())
 		return -KVM_EOPNOTSUPP;
 
+	vcpu->arch.kvmi->descriptor.monitor_fct = monitor_desc_fct_kvmi;
 	kvm_x86_ops->control_desc_intercept(vcpu, enable);
+	vcpu->arch.kvmi->descriptor.monitor_fct = monitor_desc_fct_kvm;
 
 	return 0;
 }
@@ -373,6 +413,9 @@ static int kvmi_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 static void kvmi_arch_disable_desc_intercept(struct kvm_vcpu *vcpu)
 {
 	kvmi_control_desc_intercept(vcpu, false);
+
+	vcpu->arch.kvmi->descriptor.kvmi_intercepted = false;
+	vcpu->arch.kvmi->descriptor.kvm_intercepted = false;
 }
 
 int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
@@ -438,11 +481,13 @@ bool kvmi_arch_vcpu_alloc(struct kvm_vcpu *vcpu)
 
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
index b377acc3410c..0fdc4556057e 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7547,6 +7547,9 @@ static void svm_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+	if (kvmi_monitor_desc_intercept(vcpu, enable))
+		return;
+
 	if (enable) {
 		set_intercept(svm, INTERCEPT_STORE_IDTR);
 		set_intercept(svm, INTERCEPT_STORE_GDTR);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c54c01e088b6..8745d696f592 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3044,6 +3044,9 @@ static void vmx_control_desc_intercept(struct kvm_vcpu *vcpu, bool enable)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+	if (kvmi_monitor_desc_intercept(vcpu, enable))
+		return;
+
 	if (enable)
 		secondary_exec_controls_setbit(vmx, SECONDARY_EXEC_DESC);
 	else
