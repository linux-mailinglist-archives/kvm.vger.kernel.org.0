Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C03228AAE
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731427AbgGUVQ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:26 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37790 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731314AbgGUVQT (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:19 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id F271A305D4F6;
        Wed, 22 Jul 2020 00:09:28 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id D0A92304FA13;
        Wed, 22 Jul 2020 00:09:28 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 62/84] KVM: introspection: restore the state of #BP interception on unhook
Date:   Wed, 22 Jul 2020 00:09:00 +0300
Message-Id: <20200721210922.7646-63-alazar@bitdefender.com>
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

This commit also ensures that only the userspace or the introspection
tool can control the #BP interception exclusively at one time.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h              | 18 ++++++
 arch/x86/kvm/kvmi.c                           | 60 +++++++++++++++++++
 arch/x86/kvm/x86.c                            |  5 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 16 +++++
 4 files changed, 99 insertions(+)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 6d274f173fb5..5f2a968831d3 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -4,8 +4,15 @@
 
 #include <asm/kvmi.h>
 
+struct kvmi_monitor_interception {
+	bool kvmi_intercepted;
+	bool kvm_intercepted;
+	bool (*monitor_fct)(struct kvm_vcpu *vcpu, bool enable);
+};
+
 struct kvmi_interception {
 	bool restore_interception;
+	struct kvmi_monitor_interception breakpoint;
 };
 
 struct kvm_vcpu_arch_introspection {
@@ -14,4 +21,15 @@ struct kvm_vcpu_arch_introspection {
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
index ca2ce7498cfe..56c02dad3b57 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -243,18 +243,71 @@ void kvmi_arch_hypercall_event(struct kvm_vcpu *vcpu)
 	}
 }
 
+/*
+ * Returns true if one side (kvm or kvmi) tries to enable/disable the breakpoint
+ * interception while the other side is still tracking it.
+ */
+bool kvmi_monitor_bp_intercept(struct kvm_vcpu *vcpu, u32 dbg)
+{
+	struct kvmi_interception *arch_vcpui = READ_ONCE(vcpu->arch.kvmi);
+	u32 bp_mask = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
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
+		if (kvm_x86_ops.bp_intercepted(vcpu))
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
+		if (kvm_x86_ops.bp_intercepted(vcpu))
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
@@ -293,6 +346,7 @@ void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 
 static void kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 {
+	kvmi_arch_disable_bp_intercept(vcpu);
 }
 
 bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu)
@@ -318,6 +372,12 @@ bool kvmi_arch_vcpu_alloc_interception(struct kvm_vcpu *vcpu)
 	if (!arch_vcpui)
 		return false;
 
+	arch_vcpui->breakpoint.monitor_fct = monitor_bp_fct_kvm;
+
+	/* pair with kvmi_monitor_bp_intercept() */
+	smp_wmb();
+	WRITE_ONCE(vcpu->arch.kvmi, arch_vcpui);
+
 	return true;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0d5ce07c4164..9c8b7a3c5758 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9325,6 +9325,11 @@ int kvm_arch_vcpu_set_guest_debug(struct kvm_vcpu *vcpu,
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
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 3b921e3cf958..1418e31918be 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -58,6 +58,10 @@ enum {
 
 #define HOST_SEND_TEST(uc)       (uc.cmd == UCALL_SYNC && uc.args[1] == 0)
 
+static pthread_t start_vcpu_worker(struct vcpu_worker_data *data);
+static void stop_vcpu_worker(pthread_t vcpu_thread,
+			     struct vcpu_worker_data *data);
+
 static int guest_test_id(void)
 {
 	GUEST_REQUEST_TEST();
@@ -171,8 +175,10 @@ static void allow_command(struct kvm_vm *vm, __s32 id)
 
 static void hook_introspection(struct kvm_vm *vm)
 {
+	struct vcpu_worker_data data = {.vm = vm, .vcpu_id = VCPU_ID };
 	__u32 allow = 1, disallow = 0, allow_inval = 2;
 	__u32 padding = 1, no_padding = 0;
+	pthread_t vcpu_thread;
 	__s32 all_IDs = -1;
 
 	set_command_perm(vm, all_IDs, allow, EFAULT);
@@ -180,6 +186,16 @@ static void hook_introspection(struct kvm_vm *vm)
 
 	do_hook_ioctl(vm, Kvm_socket, padding, EINVAL);
 	do_hook_ioctl(vm, -1, no_padding, EINVAL);
+
+	/*
+	 * The last call failed "too late".
+	 * We have to let the vCPU run and clean up its structures,
+	 * otherwise the next call will fail with EEXIST.
+	 */
+	vcpu_thread = start_vcpu_worker(&data);
+	sleep(1);
+	stop_vcpu_worker(vcpu_thread, &data);
+
 	do_hook_ioctl(vm, Kvm_socket, no_padding, 0);
 	do_hook_ioctl(vm, Kvm_socket, no_padding, EEXIST);
 
