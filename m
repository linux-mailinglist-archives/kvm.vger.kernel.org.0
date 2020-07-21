Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D695228AD4
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731358AbgGUVRX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:23 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37850 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731319AbgGUVQK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:10 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 256C9305D4F7;
        Wed, 22 Jul 2020 00:09:29 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 04B47304FA14;
        Wed, 22 Jul 2020 00:09:29 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 63/84] KVM: introspection: add KVMI_VM_CONTROL_CLEANUP
Date:   Wed, 22 Jul 2020 00:09:01 +0300
Message-Id: <20200721210922.7646-64-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This command will allow more control over the guest state on
unhook.  However, the memory restrictions (e.g. those set with
KVMI_VM_SET_PAGE_ACCESS) will be removed on unhook.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>

--
It will be more interesting if the userspace could control the cleanup
behavior through the use of the KVM_INTROSPECTION_COMMAND ioctl. Now, by
disallowing this command, the userspace can only keep the default behavior
(to not automatically clean up).

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 30 ++++++++++++++++
 arch/x86/include/asm/kvmi_host.h              |  1 +
 arch/x86/kvm/kvmi.c                           | 17 +++++-----
 include/linux/kvmi_host.h                     |  2 ++
 include/uapi/linux/kvmi.h                     |  9 +++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 34 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 14 +++++---
 virt/kvm/introspection/kvmi_int.h             |  4 ++-
 virt/kvm/introspection/kvmi_msg.c             | 34 ++++++++++++++-----
 9 files changed, 124 insertions(+), 21 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 110a6e7a7d2a..f760957b27f4 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -684,6 +684,36 @@ Returns a CPUID leaf (as seen by the guest OS).
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOENT - the selected leaf is not present or is invalid
 
+14. KVMI_VM_CONTROL_CLEANUP
+---------------------------
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vm_control_cleanup {
+		__u8 enable;
+		__u8 padding1;
+		__u16 padding2;
+		__u32 padding3;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code
+
+Enables/disables the automatic cleanup of the changes made by
+the introspection tool at the hypervisor level (e.g. CR/MSR/BP
+interceptions). By default it is disabled.
+
+:Errors:
+
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EINVAL - 'enabled' is not 1 or 0
+
 Events
 ======
 
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 5f2a968831d3..3e85ae4fe5f0 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -11,6 +11,7 @@ struct kvmi_monitor_interception {
 };
 
 struct kvmi_interception {
+	bool cleanup;
 	bool restore_interception;
 	struct kvmi_monitor_interception breakpoint;
 };
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 56c02dad3b57..89fa158a6535 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -353,13 +353,11 @@ bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu)
 {
 	struct kvmi_interception *arch_vcpui = vcpu->arch.kvmi;
 
-	if (!arch_vcpui)
+	if (!arch_vcpui || !arch_vcpui->cleanup)
 		return false;
 
-	if (!arch_vcpui->restore_interception)
-		return false;
-
-	kvmi_arch_restore_interception(vcpu);
+	if (arch_vcpui->restore_interception)
+		kvmi_arch_restore_interception(vcpu);
 
 	return true;
 }
@@ -392,10 +390,13 @@ bool kvmi_arch_vcpu_introspected(struct kvm_vcpu *vcpu)
 	return !!READ_ONCE(vcpu->arch.kvmi);
 }
 
-void kvmi_arch_request_interception_cleanup(struct kvm_vcpu *vcpu)
+void kvmi_arch_request_interception_cleanup(struct kvm_vcpu *vcpu,
+					    bool restore_interception)
 {
 	struct kvmi_interception *arch_vcpui = READ_ONCE(vcpu->arch.kvmi);
 
-	if (arch_vcpui)
-		arch_vcpui->restore_interception = true;
+	if (arch_vcpui) {
+		arch_vcpui->restore_interception = restore_interception;
+		arch_vcpui->cleanup = true;
+	}
 }
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index c4fac41bd5c7..01219c56d042 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -53,6 +53,8 @@ struct kvm_introspection {
 	unsigned long *vm_event_enable_mask;
 
 	atomic_t ev_seq;
+
+	bool cleanup_on_unhook;
 };
 
 int kvmi_version(void);
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 026ae5911b1c..20bf5bf194a4 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -32,6 +32,8 @@ enum {
 	KVMI_VCPU_SET_REGISTERS  = 12,
 	KVMI_VCPU_GET_CPUID      = 13,
 
+	KVMI_VM_CONTROL_CLEANUP = 14,
+
 	KVMI_NUM_MESSAGES
 };
 
@@ -135,6 +137,13 @@ struct kvmi_vcpu_control_events {
 	__u32 padding2;
 };
 
+struct kvmi_vm_control_cleanup {
+	__u8 enable;
+	__u8 padding1;
+	__u16 padding2;
+	__u32 padding3;
+};
+
 struct kvmi_event {
 	__u16 size;
 	__u16 vcpu;
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 1418e31918be..d3b7778a64d4 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1168,6 +1168,39 @@ static void test_event_breakpoint(struct kvm_vm *vm)
 	disable_vcpu_event(vm, event_id);
 }
 
+static void cmd_vm_control_cleanup(__u8 enable, __u8 padding,
+				   int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vm_control_cleanup cmd;
+	} req = {};
+	int r;
+
+	req.cmd.enable = enable;
+	req.cmd.padding1 = padding;
+	req.cmd.padding2 = padding;
+	req.cmd.padding3 = padding;
+
+	r = do_command(KVMI_VM_CONTROL_CLEANUP, &req.hdr, sizeof(req),
+			     NULL, 0);
+	TEST_ASSERT(r == expected_err,
+		"KVMI_VM_CONTROL_CLEANUP failed, error %d (%s), expected error %d\n",
+		-r, kvm_strerror(-r), expected_err);
+}
+
+static void test_cmd_vm_control_cleanup(struct kvm_vm *vm)
+{
+	__u8 disable = 0, enable = 1, enable_inval = 2;
+	__u16 padding = 1, no_padding = 0;
+
+	cmd_vm_control_cleanup(enable, padding, -KVM_EINVAL);
+	cmd_vm_control_cleanup(enable_inval, no_padding, -KVM_EINVAL);
+
+	cmd_vm_control_cleanup(enable, no_padding, 0);
+	cmd_vm_control_cleanup(disable, no_padding, 0);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1190,6 +1223,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_get_cpuid(vm);
 	test_event_hypercall(vm);
 	test_event_breakpoint(vm);
+	test_cmd_vm_control_cleanup(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 083dd8be9252..db1f4523cec5 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -218,7 +218,7 @@ static void free_vcpu_jobs(struct kvm_vcpu_introspection *vcpui)
 	}
 }
 
-static void free_vcpui(struct kvm_vcpu *vcpu)
+static void free_vcpui(struct kvm_vcpu *vcpu, bool restore_interception)
 {
 	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
 
@@ -232,17 +232,18 @@ static void free_vcpui(struct kvm_vcpu *vcpu)
 	kfree(vcpui);
 	vcpu->kvmi = NULL;
 
-	kvmi_arch_request_interception_cleanup(vcpu);
+	kvmi_arch_request_interception_cleanup(vcpu, restore_interception);
 	kvmi_make_request(vcpu, false);
 }
 
 static void free_kvmi(struct kvm *kvm)
 {
+	bool restore_interception = KVMI(kvm)->cleanup_on_unhook;
 	struct kvm_vcpu *vcpu;
 	int i;
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		free_vcpui(vcpu);
+		free_vcpui(vcpu, restore_interception);
 
 	bitmap_free(kvm->kvmi->cmd_allow_mask);
 	bitmap_free(kvm->kvmi->event_allow_mask);
@@ -255,7 +256,7 @@ static void free_kvmi(struct kvm *kvm)
 void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
 	mutex_lock(&vcpu->kvm->kvmi_lock);
-	free_vcpui(vcpu);
+	free_vcpui(vcpu, false);
 	kvmi_arch_vcpu_free_interception(vcpu);
 	mutex_unlock(&vcpu->kvm->kvmi_lock);
 }
@@ -660,6 +661,11 @@ int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
 	return kvmi_arch_cmd_control_intercept(vcpu, event_id, enable);
 }
 
+void kvmi_cmd_vm_control_cleanup(struct kvm_introspection *kvmi, bool enable)
+{
+	kvmi->cleanup_on_unhook = enable;
+}
+
 static unsigned long gfn_to_hva_safe(struct kvm *kvm, gfn_t gfn)
 {
 	unsigned long hva;
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 05bfde7d7f1a..831e7e14524f 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -49,6 +49,7 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 void kvmi_run_jobs(struct kvm_vcpu *vcpu);
 void kvmi_post_reply(struct kvm_vcpu *vcpu);
 void kvmi_handle_common_event_actions(struct kvm *kvm, u32 action);
+void kvmi_cmd_vm_control_cleanup(struct kvm_introspection *kvmi, bool enable);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
 int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
@@ -68,7 +69,8 @@ int kvmi_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
 bool kvmi_arch_vcpu_alloc_interception(struct kvm_vcpu *vcpu);
 void kvmi_arch_vcpu_free_interception(struct kvm_vcpu *vcpu);
 bool kvmi_arch_vcpu_introspected(struct kvm_vcpu *vcpu);
-void kvmi_arch_request_interception_cleanup(struct kvm_vcpu *vcpu);
+void kvmi_arch_request_interception_cleanup(struct kvm_vcpu *vcpu,
+				bool restore_interception);
 bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu);
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_get_info_reply *rpl);
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 4a03980e0bbb..86cee47d214f 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -305,19 +305,37 @@ static int handle_vcpu_pause(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, err, NULL, 0);
 }
 
+static int handle_vm_control_cleanup(struct kvm_introspection *kvmi,
+				     const struct kvmi_msg_hdr *msg,
+				     const void *_req)
+{
+	const struct kvmi_vm_control_cleanup *req = _req;
+	int ec = 0;
+
+	if (req->padding1 || req->padding2 || req->padding3)
+		ec = -KVM_EINVAL;
+	else if (req->enable > 1)
+		ec = -KVM_EINVAL;
+	else
+		kvmi_cmd_vm_control_cleanup(kvmi, req->enable == 1);
+
+	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
+}
+
 /*
  * These commands are executed by the receiving thread.
  */
 static int(*const msg_vm[])(struct kvm_introspection *,
 			    const struct kvmi_msg_hdr *, const void *) = {
-	[KVMI_GET_VERSION]       = handle_get_version,
-	[KVMI_VCPU_PAUSE]        = handle_vcpu_pause,
-	[KVMI_VM_CHECK_COMMAND]  = handle_vm_check_command,
-	[KVMI_VM_CHECK_EVENT]    = handle_vm_check_event,
-	[KVMI_VM_CONTROL_EVENTS] = handle_vm_control_events,
-	[KVMI_VM_GET_INFO]       = handle_vm_get_info,
-	[KVMI_VM_READ_PHYSICAL]  = handle_vm_read_physical,
-	[KVMI_VM_WRITE_PHYSICAL] = handle_vm_write_physical,
+	[KVMI_GET_VERSION]        = handle_get_version,
+	[KVMI_VCPU_PAUSE]         = handle_vcpu_pause,
+	[KVMI_VM_CHECK_COMMAND]   = handle_vm_check_command,
+	[KVMI_VM_CHECK_EVENT]     = handle_vm_check_event,
+	[KVMI_VM_CONTROL_CLEANUP] = handle_vm_control_cleanup,
+	[KVMI_VM_CONTROL_EVENTS]  = handle_vm_control_events,
+	[KVMI_VM_GET_INFO]        = handle_vm_get_info,
+	[KVMI_VM_READ_PHYSICAL]   = handle_vm_read_physical,
+	[KVMI_VM_WRITE_PHYSICAL]  = handle_vm_write_physical,
 };
 
 static bool is_vm_command(u16 id)
