Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAE32C3CBA
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgKYJmw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:52 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57190 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728074AbgKYJmA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:00 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 6B6B5305D3C7;
        Wed, 25 Nov 2020 11:35:52 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 4597B3072785;
        Wed, 25 Nov 2020 11:35:52 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 59/81] KVM: introspection: restore the state of #BP interception on unhook
Date:   Wed, 25 Nov 2020 11:35:38 +0200
Message-Id: <20201125093600.2766-60-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

This commit also ensures that only the userspace or the introspection
tool can control the #BP interception exclusively at one time.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 arch/x86/include/asm/kvmi_host.h              | 18 ++++++
 arch/x86/kvm/kvmi.c                           | 60 +++++++++++++++++++
 arch/x86/kvm/x86.c                            |  5 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 14 +++++
 4 files changed, 97 insertions(+)

diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index b776be4bb49f..e008662f91a5 100644
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
@@ -16,4 +23,15 @@ struct kvm_vcpu_arch_introspection {
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
index b4a7d581f68c..3fd73087276e 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -162,19 +162,72 @@ bool kvmi_arch_is_agent_hypercall(struct kvm_vcpu *vcpu)
 		&& subfunc2 == 0);
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
@@ -213,6 +266,7 @@ void kvmi_arch_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len)
 
 static void kvmi_arch_restore_interception(struct kvm_vcpu *vcpu)
 {
+	kvmi_arch_disable_bp_intercept(vcpu);
 }
 
 bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu)
@@ -238,6 +292,12 @@ bool kvmi_arch_vcpu_alloc_interception(struct kvm_vcpu *vcpu)
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
index aad12df742df..824d9d20a6ea 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9756,6 +9756,11 @@ int kvm_arch_vcpu_set_guest_debug(struct kvm_vcpu *vcpu,
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
index ccb9a3a997d8..143ee1a8f618 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -63,6 +63,9 @@ enum {
 #define HOST_SEND_TEST(uc)       (uc.cmd == UCALL_SYNC && uc.args[1] == 0)
 #define HOST_TEST_DONE(uc)       (uc.cmd == UCALL_SYNC && uc.args[1] == 1)
 
+static pthread_t start_vcpu_worker(struct vcpu_worker_data *data);
+static void wait_vcpu_worker(pthread_t vcpu_thread);
+
 static int guest_test_id(void)
 {
 	GUEST_REQUEST_TEST();
@@ -172,13 +175,24 @@ static void allow_command(struct kvm_vm *vm, __s32 id)
 
 static void hook_introspection(struct kvm_vm *vm)
 {
+	struct vcpu_worker_data data = {.vm = vm, .vcpu_id = VCPU_ID };
 	__u32 allow = 1, disallow = 0, allow_inval = 2;
+	pthread_t vcpu_thread;
 	__s32 all_IDs = -1;
 
 	set_command_perm(vm, all_IDs, allow, EFAULT);
 	set_event_perm(vm, all_IDs, allow, EFAULT);
 
 	do_hook_ioctl(vm, -1, EINVAL);
+
+	/*
+	 * The last call failed "too late".
+	 * We have to let the vCPU run and clean up its structures,
+	 * otherwise the next call will fail with EEXIST.
+	 */
+	vcpu_thread = start_vcpu_worker(&data);
+	wait_vcpu_worker(vcpu_thread);
+
 	do_hook_ioctl(vm, Kvm_socket, 0);
 	do_hook_ioctl(vm, Kvm_socket, EEXIST);
 
