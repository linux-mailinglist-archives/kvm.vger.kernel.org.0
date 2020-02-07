Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5519A155DA3
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgBGSRh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:37 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40684 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727683AbgBGSQw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:52 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 53C00305D359;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3B2023052070;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 59/78] KVM: introspection: restore the state of #BP interception on unhook
Date:   Fri,  7 Feb 2020 20:16:17 +0200
Message-Id: <20200207181636.1065-60-alazar@bitdefender.com>
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

This commit also ensures that only the userspace or the introspection
tool can control the #BP interception exclusively at one time.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvm_host.h   |  3 +
 arch/x86/include/asm/kvmi_host.h  | 22 +++++++
 arch/x86/kvm/kvmi.c               | 99 ++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c                |  5 ++
 virt/kvm/introspection/kvmi.c     | 27 ++++++++-
 virt/kvm/introspection/kvmi_int.h |  6 +-
 6 files changed, 157 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9cf45ca73af5..fbd9ecc41177 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -815,6 +815,9 @@ struct kvm_vcpu_arch {
 
 	/* #PF translated error code from EPT/NPT exit reason */
 	u64 error_code;
+
+	/* Control the interception for KVM Introspection */
+	struct kvmi_interception *kvmi;
 };
 
 struct kvm_lpage_info {
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 360a57dd9019..c8b793915b84 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -2,10 +2,32 @@
 #ifndef _ASM_X86_KVMI_HOST_H
 #define _ASM_X86_KVMI_HOST_H
 
+struct kvmi_monitor_interception {
+	bool kvmi_intercepted;
+	bool kvm_intercepted;
+	bool (*monitor_fct)(struct kvm_vcpu *vcpu, bool enable);
+};
+
+struct kvmi_interception {
+	bool restore_interception;
+	struct kvmi_monitor_interception breakpoint;
+};
+
 struct kvm_vcpu_arch_introspection {
 };
 
 struct kvm_arch_introspection {
 };
 
+#ifdef CONFIG_KVM_INTROSPECTION
+
+bool kvmi_monitor_bp_intercept(struct kvm_vcpu *vcpu, u32 dbg);
+
+#else /* CONFIG_KVM_INTROSPECTION */
+
+static inline bool kvmi_monitor_bp_intercept(struct kvm_vcpu *vcpu, u32 dbg)
+	{ return false; }
+
+#endif /* CONFIG_KVM_INTROSPECTION */
+
 #endif /* _ASM_X86_KVMI_HOST_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 2c8c062a4b11..54abaf416ff3 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -193,18 +193,71 @@ void kvmi_arch_hypercall_event(struct kvm_vcpu *vcpu)
 	}
 }
 
+/*
+ * Returns true if one side (kvm or kvmi) tries to enable/disable the breakpoint
+ * interception while the other side is still tracking it.
+ */
+bool kvmi_monitor_bp_intercept(struct kvm_vcpu *vcpu, u32 dbg)
+{
+	u32 bp_mask = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
+	struct kvmi_interception *arch_vcpui = READ_ONCE(vcpu->arch.kvmi);
+	bool enable = false;
+
+	if ((dbg & bp_mask) == bp_mask)
+		enable = true;
+
+	return (arch_vcpui && arch_vcpui->breakpoint.monitor_fct(vcpu, enable));
+}
+EXPORT_SYMBOL(kvmi_monitor_bp_intercept);
+
+static bool monitor_bp_fct_kvmi(struct kvm_vcpu *vcpu, bool enable)
+{
+	if (enable) {
+		if (kvm_x86_ops->bp_intercepted(vcpu))
+			return true;
+	} else if (!vcpu->arch.kvmi->breakpoint.kvmi_intercepted)
+		return true;
+
+	vcpu->arch.kvmi->breakpoint.kvmi_intercepted = enable;
+
+	return false;
+}
+
+static bool monitor_bp_fct_kvm(struct kvm_vcpu *vcpu, bool enable)
+{
+	if (enable) {
+		if (kvm_x86_ops->bp_intercepted(vcpu))
+			return true;
+	} else if (!vcpu->arch.kvmi->breakpoint.kvm_intercepted)
+		return true;
+
+	vcpu->arch.kvmi->breakpoint.kvm_intercepted = enable;
+
+	return false;
+}
+
 static int kvmi_control_bp_intercept(struct kvm_vcpu *vcpu, bool enable)
 {
 	struct kvm_guest_debug dbg = {};
 	int err = 0;
 
+	vcpu->arch.kvmi->breakpoint.monitor_fct = monitor_bp_fct_kvmi;
 	if (enable)
 		dbg.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
 	err = kvm_arch_vcpu_set_guest_debug(vcpu, &dbg);
+	vcpu->arch.kvmi->breakpoint.monitor_fct = monitor_bp_fct_kvm;
 
 	return err;
 }
 
+static void kvmi_arch_disable_bp_intercept(struct kvm_vcpu *vcpu)
+{
+	kvmi_control_bp_intercept(vcpu, false);
+
+	vcpu->arch.kvmi->breakpoint.kvmi_intercepted = false;
+	vcpu->arch.kvmi->breakpoint.kvm_intercepted = false;
+}
+
 int kvmi_arch_cmd_control_intercept(struct kvm_vcpu *vcpu,
 				    unsigned int event_id, bool enable)
 {
@@ -241,6 +294,50 @@ void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 	}
 }
 
-void kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
+bool kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 {
+	struct kvmi_interception *arch_vcpui = vcpu->arch.kvmi;
+
+	if (!arch_vcpui || !arch_vcpui->restore_interception)
+		return false;
+
+	kvmi_arch_disable_bp_intercept(vcpu);
+
+	return true;
+}
+
+bool kvmi_arch_vcpu_alloc(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_interception *arch_vcpui;
+
+	arch_vcpui = kzalloc(sizeof(*arch_vcpui), GFP_KERNEL);
+	if (!arch_vcpui)
+		return false;
+
+	arch_vcpui->breakpoint.monitor_fct = monitor_bp_fct_kvm;
+
+	/* pair with kvmi_monitor_bp_intercept() */
+	smp_wmb();
+	WRITE_ONCE(vcpu->arch.kvmi, arch_vcpui);
+
+	return true;
+}
+
+void kvmi_arch_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	kfree(vcpu->arch.kvmi);
+	WRITE_ONCE(vcpu->arch.kvmi, NULL);
+}
+
+bool kvmi_arch_vcpu_introspected(struct kvm_vcpu *vcpu)
+{
+	return !!READ_ONCE(vcpu->arch.kvmi);
+}
+
+void kvmi_arch_request_restore_interception(struct kvm_vcpu *vcpu)
+{
+	struct kvmi_interception *arch_vcpui = READ_ONCE(vcpu->arch.kvmi);
+
+	if (arch_vcpui)
+		arch_vcpui->restore_interception = true;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4a7805ce9e4..a3afbbb7199f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8993,6 +8993,11 @@ int kvm_arch_vcpu_set_guest_debug(struct kvm_vcpu *vcpu,
 			kvm_queue_exception(vcpu, BP_VECTOR);
 	}
 
+	if (kvmi_monitor_bp_intercept(vcpu, dbg->control)) {
+		r = -EBUSY;
+		goto out;
+	}
+
 	/*
 	 * Read rflags as long as potentially injected trace flags are still
 	 * filtered out.
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 19ea94dc0e1d..f369856f91b1 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -137,7 +137,7 @@ static bool alloc_vcpui(struct kvm_vcpu *vcpu)
 
 	vcpu->kvmi = vcpui;
 
-	return true;
+	return kvmi_arch_vcpu_alloc(vcpu);
 }
 
 static int create_vcpui(struct kvm_vcpu *vcpu)
@@ -166,6 +166,7 @@ static void free_vcpui(struct kvm_vcpu *vcpu)
 	kfree(vcpui);
 	vcpu->kvmi = NULL;
 
+	kvmi_arch_request_restore_interception(vcpu);
 	kvmi_make_request(vcpu, false);
 }
 
@@ -184,6 +185,7 @@ static void free_kvmi(struct kvm *kvm)
 void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 	free_vcpui(vcpu);
+	kvmi_arch_vcpu_free(vcpu);
 }
 
 static struct kvm_introspection *
@@ -324,6 +326,21 @@ static int kvmi_recv_thread(void *arg)
 	return 0;
 }
 
+static bool ready_to_hook(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	if (kvm->kvmi)
+		return false;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		if (kvmi_arch_vcpu_introspected(vcpu))
+			return false;
+
+	return true;
+}
+
 int kvmi_hook(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 {
 	struct kvm_introspection *kvmi;
@@ -331,7 +348,7 @@ int kvmi_hook(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 
 	mutex_lock(&kvm->kvmi_lock);
 
-	if (kvm->kvmi) {
+	if (!ready_to_hook(kvm)) {
 		err = -EEXIST;
 		goto out;
 	}
@@ -793,7 +810,11 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu)
 	kvmi_put(vcpu->kvm);
 
 out:
-	kvmi_arch_restore_interception(vcpu);
+	if (kvmi_arch_restore_interception(vcpu)) {
+		mutex_lock(&vcpu->kvm->kvmi_lock);
+		kvmi_arch_vcpu_free(vcpu);
+		mutex_unlock(&vcpu->kvm->kvmi_lock);
+	}
 }
 
 int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait)
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 06f2c5b6857a..06792c0ba6e6 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -96,7 +96,11 @@ int kvmi_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
 				const struct kvm_regs *regs);
 
 /* arch */
-void kvmi_arch_restore_interception(struct kvm_vcpu *vcpu);
+bool kvmi_arch_vcpu_alloc(struct kvm_vcpu *vcpu);
+void kvmi_arch_vcpu_free(struct kvm_vcpu *vcpu);
+bool kvmi_arch_vcpu_introspected(struct kvm_vcpu *vcpu);
+bool kvmi_arch_restore_interception(struct kvm_vcpu *vcpu);
+void kvmi_arch_request_restore_interception(struct kvm_vcpu *vcpu);
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_get_info_reply *rpl);
 void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
