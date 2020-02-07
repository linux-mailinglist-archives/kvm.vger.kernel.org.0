Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D308155D87
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727766AbgBGSQ4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:56 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40732 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727698AbgBGSQy (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:54 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 6CF26305D35B;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 56E5E3052072;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 61/78] KVM: introspection: restore the state of CR3 interception on unhook
Date:   Fri,  7 Feb 2020 20:16:19 +0200
Message-Id: <20200207181636.1065-62-alazar@bitdefender.com>
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
do not disable each other the CR3-write VM-exit.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h |  4 ++
 arch/x86/kvm/kvmi.c              | 64 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/svm.c               |  5 +++
 arch/x86/kvm/vmx/vmx.c           |  5 +++
 4 files changed, 75 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 4ac209cb4ebf..24f3f8fdee62 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -13,6 +13,7 @@ struct kvmi_monitor_interception {
 struct kvmi_interception {
 	bool restore_interception;
 	struct kvmi_monitor_interception breakpoint;
+	struct kvmi_monitor_interception cr3w;
 };
 
 struct kvm_vcpu_arch_introspection {
@@ -28,6 +29,7 @@ bool kvmi_monitor_bp_intercept(struct kvm_vcpu *vcpu, u32 dbg);
 bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 		   unsigned long old_value, unsigned long *new_value);
 bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu);
+bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu, bool enable);
 
 #else /* CONFIG_KVM_INTROSPECTION */
 
@@ -37,6 +39,8 @@ static inline bool kvmi_cr_event(struct kvm_vcpu *vcpu, unsigned int cr,
 				 unsigned long old_value,
 				 unsigned long *new_value) { return true; }
 static inline bool kvmi_cr3_intercepted(struct kvm_vcpu *vcpu) { return false; }
+static inline bool kvmi_monitor_cr3w_intercept(struct kvm_vcpu *vcpu,
+						bool enable) { return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 9917295e9a56..a522d4b1fa09 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -258,6 +258,59 @@ static void kvmi_arch_disable_bp_intercept(struct kvm_vcpu *vcpu)
 	vcpu->arch.kvmi->breakpoint.kvm_intercepted = false;
 }
 
+static bool monitor_cr3w_fct_kvmi(struct kvm_vcpu *vcpu, bool enable)
+{
+	vcpu->arch.kvmi->cr3w.kvmi_intercepted = enable;
+
+	if (enable)
+		vcpu->arch.kvmi->cr3w.kvm_intercepted =
+			kvm_x86_ops->cr3_write_intercepted(vcpu);
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
+	kvm_x86_ops->control_cr3_intercept(vcpu, CR_TYPE_W, enable);
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
@@ -302,6 +355,7 @@ bool kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 		return false;
 
 	kvmi_arch_disable_bp_intercept(vcpu);
+	kvmi_arch_disable_cr3w_intercept(vcpu);
 
 	return true;
 }
@@ -315,8 +369,13 @@ bool kvmi_arch_vcpu_alloc(struct kvm_vcpu *vcpu)
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
 
@@ -354,8 +413,7 @@ int kvmi_arch_cmd_vcpu_control_cr(struct kvm_vcpu *vcpu,
 	case 0:
 		break;
 	case 3:
-		kvm_x86_ops->control_cr3_intercept(vcpu, CR_TYPE_W,
-						   req->enable);
+		kvmi_control_cr3w_intercept(vcpu, req->enable);
 		break;
 	case 4:
 		break;
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 37b018988d7d..909308711bb7 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -7326,6 +7326,11 @@ static void svm_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
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
index d3d7908995b5..157dfc3f756a 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2907,6 +2907,11 @@ static void vmx_control_cr3_intercept(struct kvm_vcpu *vcpu, int type,
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
