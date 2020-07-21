Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF90228ADB
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731305AbgGUVRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:41 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38020 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731281AbgGUVQH (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:07 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 6D833305D4F9;
        Wed, 22 Jul 2020 00:09:29 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 4E657304FA15;
        Wed, 22 Jul 2020 00:09:29 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 65/84] KVM: introspection: restore the state of CR3 interception on unhook
Date:   Wed, 22 Jul 2020 00:09:03 +0300
Message-Id: <20200721210922.7646-66-alazar@bitdefender.com>
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
do not disable each other the CR3-write VM-exit.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h |  4 ++
 arch/x86/kvm/kvmi.c              | 64 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm/svm.c           |  5 +++
 arch/x86/kvm/vmx/vmx.c           |  5 +++
 4 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 1aff91ef8475..44580f77e34e 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -16,6 +16,7 @@ struct kvmi_interception {
 	bool cleanup;
 	bool restore_interception;
 	struct kvmi_monitor_interception breakpoint;
+	struct kvmi_monitor_interception cr3w;
 };
 
 struct kvm_vcpu_arch_introspection {
@@ -31,6 +32,7 @@ bool kvmi_monitor_bp_intercept(struct kvm_vcpu *vcpu, u32 dbg);
 bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 		   unsigned long old_value, unsigned long *new_value);
 bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu);
+bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -41,6 +43,8 @@ static inline bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 				 unsigned long *new_value)
 			{ return true; }
 static inline bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu) { return false; }
+static inline bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu,
+						bool enable) { return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index e72b2ef5b28a..e340a2c3500f 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -308,6 +308,59 @@ static void kvmi_arch_disable_bp_intercept(struct kvm_vcpu *vcpu)
 	vcpu->arch.kvmi->breakpoint.kvm_intercepted = false;
 }
 
+static bool monitor_cr3w_fct_kvmi(struct kvm_vcpu *vcpu, bool enable)
+{
+	vcpu->arch.kvmi->cr3w.kvmi_intercepted = enable;
+
+	if (enable)
+		vcpu->arch.kvmi->cr3w.kvm_intercepted =
+			kvm_x86_ops.cr3_write_intercepted(vcpu);
+	else if (vcpu->arch.kvmi->cr3w.kvm_intercepted)
+		return true;
+
+	return false;
+}
+
+static bool monitor_cr3w_fct_kvm(struct kvm_vcpu *vcpu, bool enable)
+{
+	if (!vcpu->arch.kvmi->cr3w.kvmi_intercepted)
+		return false;
+
+	vcpu->arch.kvmi->cr3w.kvm_intercepted = enable;
+
+	if (!enable)
+		return true;
+
+	return false;
+}
+
+/*
+ * Returns true if one side (kvm or kvmi) tries to disable the CR3 write
+ * interception while the other side is still tracking it.
+ */
+bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	struct kvmi_interception *arch_vcpui = READ_ONCE(vcpu->arch.kvmi);
+
+	return (arch_vcpui && arch_vcpui->cr3w.monitor_fct(vcpu, enable));
+}
+EXPORT_SYMBOL(kvmi_monitor_cr3w_intercept);
+
+static void kvmi_control_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable)
+{
+	vcpu->arch.kvmi->cr3w.monitor_fct = monitor_cr3w_fct_kvmi;
+	kvm_x86_ops.control_cr3_intercept(vcpu, CR_TYPE_W, enable);
+	vcpu->arch.kvmi->cr3w.monitor_fct = monitor_cr3w_fct_kvm;
+}
+
+static void kvmi_arch_disable_cr3w_intercept(struct kvm_vcpu *vcpu)
+{
+	kvmi_control_cr3w_intercept(vcpu, false);
+
+	vcpu->arch.kvmi->cr3w.kvmi_intercepted = false;
+	vcpu->arch.kvmi->cr3w.kvm_intercepted = false;
+}
+
 int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 				    unsigned int event_id, bool enable)
 {
@@ -347,6 +400,7 @@ void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 static void kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 {
 	kvmi_arch_disable_bp_intercept(vcpu);
+	kvmi_arch_disable_cr3w_intercept(vcpu);
 }
 
 bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu)
@@ -371,8 +425,13 @@ bool kvmi_arch_vcpu_alloc_interception(struct kvm_vcpu *vcpu)
 		return false;
 
 	arch_vcpui->breakpoint.monitor_fct = monitor_bp_fct_kvm;
+	arch_vcpui->cr3w.monitor_fct = monitor_cr3w_fct_kvm;
 
-	/* pair with kvmi_monitor_bp_intercept() */
+	/*
+	 * paired with:
+	 *  - kvmi_monitor_bp_intercept()
+	 *  - kvmi_monitor_cr3w_intercept()
+	 */
 	smp_wmb();
 	WRITE_ONCE(vcpu->arch.kvmi, arch_vcpui);
 
@@ -413,8 +472,7 @@ int kvmi_arch_cmd_vcpu_control_cr(struct kvm_vcpu *vcpu,
 	case 0:
 		break;
 	case 3:
-		kvm_x86_ops.control_cr3_intercept(vcpu, CR_TYPE_W,
-						  req->enable == 1);
+		kvmi_control_cr3w_intercept(vcpu, req->enable == 1);
 		break;
 	case 4:
 		break;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 47c50e2f0f86..bc886cedf45c 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1668,6 +1668,11 @@ static void svm_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+#ifdef CONFIG_KVM_INTROSPECTION
+	if ((type & CR_TYPE_W) && kvmi_monitor_cr3w_intercept(vcpu, enable))
+		type &= ~CR_TYPE_W;
+#endif /* CONFIG_KVM_INTROSPECTION */
+
 	if (type & CR_TYPE_R)
 		enable ? set_cr_intercept(svm, INTERCEPT_CR3_READ) :
 			 clr_cr_intercept(svm, INTERCEPT_CR3_READ);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5d0876420dd9..69aa1157a0f0 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3011,6 +3011,11 @@ static void vmx_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	u32 cr3_exec_control = 0;
 
+#ifdef CONFIG_KVM_INTROSPECTION
+	if ((type & CR_TYPE_W) && kvmi_monitor_cr3w_intercept(vcpu, enable))
+		type &= ~CR_TYPE_W;
+#endif /* CONFIG_KVM_INTROSPECTION */
+
 	if (type & CR_TYPE_R)
 		cr3_exec_control |= CPU_BASED_CR3_STORE_EXITING;
 	if (type & CR_TYPE_W)
