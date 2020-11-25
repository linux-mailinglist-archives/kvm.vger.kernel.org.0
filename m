Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8C12C3CC5
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgKYJnL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:43:11 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57100 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727126AbgKYJlz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:41:55 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E6BA8305D3CA;
        Wed, 25 Nov 2020 11:35:52 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id C4A833072784;
        Wed, 25 Nov 2020 11:35:52 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 62/81] KVM: introspection: restore the state of CR3 interception on unhook
Date:   Wed, 25 Nov 2020 11:35:41 +0200
Message-Id: <20201125093600.2766-63-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This commit also ensures that the introspection tool and the userspace
do not disable each other the CR3-write VM-exit.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h |  4 ++
 arch/x86/kvm/kvmi.c              | 67 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/kvmi.h              |  4 +-
 arch/x86/kvm/kvmi_msg.c          |  4 +-
 arch/x86/kvm/svm/svm.c           |  5 +++
 arch/x86/kvm/vmx/vmx.c           |  5 +++
 6 files changed, 81 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 7613088d0ae2..edbedf031467 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -16,6 +16,7 @@ struct kvmi_interception {
 	bool cleanup;
 	bool restore_interception;
 	struct kvmi_monitor_interception breakpoint;
+	struct kvmi_monitor_interception cr3w;
 };
 
 struct kvm_vcpu_arch_introspection {
@@ -34,6 +35,7 @@ bool kvmi_monitor_bp_intercept(struct kvm_vcpu *vcpu, u32 dbg);
 bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 		   unsigned long old_value, unsigned long *new_value);
 bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu);
+bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -44,6 +46,8 @@ static inline bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 				 unsigned long *new_value)
 			{ return true; }
 static inline bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu) { return false; }
+static inline bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu,
+						bool enable) { return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 2bb6b4bb932b..8ad3698e5988 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -230,6 +230,59 @@ static void kvmi_arch_disable_bp_intercept(struct kvm_vcpu *vcpu)
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
@@ -269,6 +322,7 @@ void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 static void kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 {
 	kvmi_arch_disable_bp_intercept(vcpu);
+	kvmi_arch_disable_cr3w_intercept(vcpu);
 }
 
 bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu)
@@ -293,8 +347,13 @@ bool kvmi_arch_vcpu_alloc_interception(struct kvm_vcpu *vcpu)
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
 
@@ -326,7 +385,7 @@ void kvmi_arch_request_interception_cleanup(struct kvm_vcpu *vcpu,
 int kvmi_arch_cmd_vcpu_control_cr(struct kvm_vcpu *vcpu, int cr, bool enable)
 {
 	if (cr == 3)
-		kvm_x86_ops.control_cr3_intercept(vcpu, CR_TYPE_W, enable);
+		kvmi_control_cr3w_intercept(vcpu, enable);
 
 	if (enable)
 		set_bit(cr, VCPUI(vcpu)->arch.cr_mask);
@@ -346,8 +405,8 @@ static bool __kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 	if (!test_bit(cr, VCPUI(vcpu)->arch.cr_mask))
 		return true;
 
-	action = kvmi_msg_send_cr(vcpu, cr, old_value, *new_value,
-				  &reply_value);
+	action = kvmi_msg_send_vcpu_cr(vcpu, cr, old_value, *new_value,
+				       &reply_value);
 	switch (action) {
 	case KVMI_EVENT_ACTION_CONTINUE:
 		*new_value = reply_value;
diff --git a/arch/x86/kvm/kvmi.h b/arch/x86/kvm/kvmi.h
index 6f4aaebb67f9..6a444428b831 100644
--- a/arch/x86/kvm/kvmi.h
+++ b/arch/x86/kvm/kvmi.h
@@ -9,7 +9,7 @@ void kvmi_arch_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
 				      const struct kvm_regs *regs);
 int kvmi_arch_cmd_vcpu_control_cr(struct kvm_vcpu *vcpu, int cr, bool enable);
 
-u32 kvmi_msg_send_cr(struct kvm_vcpu *vcpu, u32 cr, u64 old_value,
-		     u64 new_value, u64 *ret_value);
+u32 kvmi_msg_send_vcpu_cr(struct kvm_vcpu *vcpu, u32 cr, u64 old_value,
+			  u64 new_value, u64 *ret_value);
 
 #endif
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index 1682bb27105f..34aedb4785e4 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -163,8 +163,8 @@ kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id)
 	return id < ARRAY_SIZE(msg_vcpu) ? msg_vcpu[id] : NULL;
 }
 
-u32 kvmi_msg_send_cr(struct kvm_vcpu *vcpu, u32 cr, u64 old_value,
-		     u64 new_value, u64 *ret_value)
+u32 kvmi_msg_send_vcpu_cr(struct kvm_vcpu *vcpu, u32 cr, u64 old_value,
+			  u64 new_value, u64 *ret_value)
 {
 	struct kvmi_vcpu_event_cr e;
 	struct kvmi_vcpu_event_cr_reply r;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index baca455212f9..f3ec79e6c39a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1787,6 +1787,11 @@ static void svm_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+#ifdef CONFIG_KVM_INTROSPECTION
+	if ((type & CR_TYPE_W) && kvmi_monitor_cr3w_intercept(vcpu, enable))
+		type &= ~CR_TYPE_W;
+#endif /* CONFIG_KVM_INTROSPECTION */
+
 	if (type & CR_TYPE_R)
 		enable ? svm_set_intercept(svm, INTERCEPT_CR3_READ) :
 			 svm_clr_intercept(svm, INTERCEPT_CR3_READ);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 723e78529146..837447541710 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2985,6 +2985,11 @@ static void vmx_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
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
