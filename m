Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 104682D1B2A
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727393AbgLGUsi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:38 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42600 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727366AbgLGUsg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:36 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id A1842305D47B;
        Mon,  7 Dec 2020 22:46:22 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 7D0EB3072784;
        Mon,  7 Dec 2020 22:46:22 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 60/81] KVM: introspection: add KVMI_VM_CONTROL_CLEANUP
Date:   Mon,  7 Dec 2020 22:46:01 +0200
Message-Id: <20201207204622.15258-61-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This command will allow more control over the guest state on
unhook.  However, the memory restrictions (e.g. those set with
KVMI_VM_SET_PAGE_ACCESS) will be removed on unhook.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 28 +++++++++++++++
 arch/x86/include/asm/kvmi_host.h              |  1 +
 arch/x86/kvm/kvmi.c                           | 17 +++++-----
 include/linux/kvmi_host.h                     |  2 ++
 include/uapi/linux/kvmi.h                     | 22 +++++++-----
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 24 +++++++++++++
 virt/kvm/introspection/kvmi.c                 | 18 +++++++---
 virt/kvm/introspection/kvmi_int.h             | 12 ++++++-
 virt/kvm/introspection/kvmi_msg.c             | 34 ++++++++++++++-----
 9 files changed, 129 insertions(+), 29 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index c89f383e48f9..f9c10d27ce14 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -673,6 +673,34 @@ Returns a CPUID leaf (as seen by the guest OS).
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
+		__u8 padding[7];
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
+interceptions). By default it is enabled.
+
+:Errors:
+
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EINVAL - ``enable`` is not 1 or 0
+
 Events
 ======
 
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index e008662f91a5..161d1ae5a7cf 100644
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
index 3fd73087276e..e7a4ef48ed61 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -273,13 +273,11 @@ bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu)
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
@@ -312,10 +310,13 @@ bool kvmi_arch_vcpu_introspected(struct kvm_vcpu *vcpu)
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
index 30b7269468dd..7a7360306812 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -50,6 +50,8 @@ struct kvm_introspection {
 	unsigned long *vm_event_enable_mask;
 
 	atomic_t ev_seq;
+
+	bool restore_on_unhook;
 };
 
 int kvmi_version(void);
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index ea66f3f803e7..9e28961a8387 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -20,14 +20,15 @@ enum {
 enum {
 	KVMI_VM_EVENT = KVMI_VM_MESSAGE_ID(0),
 
-	KVMI_GET_VERSION       = KVMI_VM_MESSAGE_ID(1),
-	KVMI_VM_CHECK_COMMAND  = KVMI_VM_MESSAGE_ID(2),
-	KVMI_VM_CHECK_EVENT    = KVMI_VM_MESSAGE_ID(3),
-	KVMI_VM_GET_INFO       = KVMI_VM_MESSAGE_ID(4),
-	KVMI_VM_CONTROL_EVENTS = KVMI_VM_MESSAGE_ID(5),
-	KVMI_VM_READ_PHYSICAL  = KVMI_VM_MESSAGE_ID(6),
-	KVMI_VM_WRITE_PHYSICAL = KVMI_VM_MESSAGE_ID(7),
-	KVMI_VM_PAUSE_VCPU     = KVMI_VM_MESSAGE_ID(8),
+	KVMI_GET_VERSION        = KVMI_VM_MESSAGE_ID(1),
+	KVMI_VM_CHECK_COMMAND   = KVMI_VM_MESSAGE_ID(2),
+	KVMI_VM_CHECK_EVENT     = KVMI_VM_MESSAGE_ID(3),
+	KVMI_VM_GET_INFO        = KVMI_VM_MESSAGE_ID(4),
+	KVMI_VM_CONTROL_EVENTS  = KVMI_VM_MESSAGE_ID(5),
+	KVMI_VM_READ_PHYSICAL   = KVMI_VM_MESSAGE_ID(6),
+	KVMI_VM_WRITE_PHYSICAL  = KVMI_VM_MESSAGE_ID(7),
+	KVMI_VM_PAUSE_VCPU      = KVMI_VM_MESSAGE_ID(8),
+	KVMI_VM_CONTROL_CLEANUP = KVMI_VM_MESSAGE_ID(9),
 
 	KVMI_NEXT_VM_MESSAGE
 };
@@ -167,4 +168,9 @@ struct kvmi_vcpu_event_breakpoint {
 	__u8 padding[7];
 };
 
+struct kvmi_vm_control_cleanup {
+	__u8 enable;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 143ee1a8f618..f95f2771a123 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1077,6 +1077,29 @@ static void test_event_breakpoint(struct kvm_vm *vm)
 	disable_vcpu_event(vm, event_id);
 }
 
+static void cmd_vm_control_cleanup(__u8 enable, int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vm_control_cleanup cmd;
+	} req = {};
+
+	req.cmd.enable = enable;
+
+	test_vm_command(KVMI_VM_CONTROL_CLEANUP, &req.hdr, sizeof(req),
+			NULL, 0, expected_err);
+}
+
+static void test_cmd_vm_control_cleanup(struct kvm_vm *vm)
+{
+	__u8 disable = 0, enable = 1, enable_inval = 2;
+
+	cmd_vm_control_cleanup(enable_inval, -KVM_EINVAL);
+
+	cmd_vm_control_cleanup(enable, 0);
+	cmd_vm_control_cleanup(disable, 0);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1099,6 +1122,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_get_cpuid(vm);
 	test_event_hypercall(vm);
 	test_event_breakpoint(vm);
+	test_cmd_vm_control_cleanup(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 25af27aaf9ec..6d486ba9eff7 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -227,7 +227,7 @@ static void kvmi_free_vcpu_jobs(struct kvm_vcpu_introspection *vcpui)
 	}
 }
 
-static void kvmi_free_vcpui(struct kvm_vcpu *vcpu)
+static void kvmi_free_vcpui(struct kvm_vcpu *vcpu, bool restore_interception)
 {
 	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
 
@@ -241,17 +241,18 @@ static void kvmi_free_vcpui(struct kvm_vcpu *vcpu)
 	kfree(vcpui);
 	vcpu->kvmi = NULL;
 
-	kvmi_arch_request_interception_cleanup(vcpu);
+	kvmi_arch_request_interception_cleanup(vcpu, restore_interception);
 	kvmi_make_request(vcpu, false);
 }
 
 static void kvmi_free(struct kvm *kvm)
 {
+	bool restore_interception = KVMI(kvm)->restore_on_unhook;
 	struct kvm_vcpu *vcpu;
 	int i;
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		kvmi_free_vcpui(vcpu);
+		kvmi_free_vcpui(vcpu, restore_interception);
 
 	bitmap_free(kvm->kvmi->cmd_allow_mask);
 	bitmap_free(kvm->kvmi->event_allow_mask);
@@ -263,8 +264,10 @@ static void kvmi_free(struct kvm *kvm)
 
 void kvmi_vcpu_uninit(struct kvm_vcpu *vcpu)
 {
+	bool restore_interception = false;
+
 	mutex_lock(&vcpu->kvm->kvmi_lock);
-	kvmi_free_vcpui(vcpu);
+	kvmi_free_vcpui(vcpu, restore_interception);
 	kvmi_arch_vcpu_free_interception(vcpu);
 	mutex_unlock(&vcpu->kvm->kvmi_lock);
 }
@@ -295,6 +298,8 @@ kvmi_alloc(struct kvm *kvm, const struct kvm_introspection_hook *hook)
 	BUILD_BUG_ON(sizeof(hook->uuid) != sizeof(kvmi->uuid));
 	memcpy(&kvmi->uuid, &hook->uuid, sizeof(kvmi->uuid));
 
+	kvmi->restore_on_unhook = true;
+
 	bitmap_copy(kvmi->cmd_allow_mask, Kvmi_always_allowed_commands,
 		    KVMI_NUM_COMMANDS);
 
@@ -672,6 +677,11 @@ int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+void kvmi_cmd_vm_control_cleanup(struct kvm_introspection *kvmi, bool enable)
+{
+	kvmi->restore_on_unhook = enable;
+}
+
 static long
 get_user_pages_remote_unlocked(struct mm_struct *mm, unsigned long start,
 				unsigned long nr_pages, unsigned int gup_flags,
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 94de54d7ebb9..8a266b058155 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -31,6 +31,14 @@ static inline bool is_vcpu_event_enabled(struct kvm_vcpu *vcpu, u16 event_id)
 	return test_bit(event_id, VCPUI(vcpu)->ev_enable_mask);
 }
 
+static inline bool non_zero_padding(const u8 *addr, size_t len)
+{
+	while (len--)
+		if (*addr++)
+			return true;
+	return false;
+}
+
 /* kvmi_msg.c */
 bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd);
 void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
@@ -60,6 +68,7 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void *ctx, void (*free_fct)(void *ctx));
 void kvmi_run_jobs(struct kvm_vcpu *vcpu);
 void kvmi_handle_common_event_actions(struct kvm_vcpu *vcpu, u32 action);
+void kvmi_cmd_vm_control_cleanup(struct kvm_introspection *kvmi, bool enable);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 			       u16 event_id, bool enable);
 int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
@@ -81,7 +90,8 @@ void kvmi_arch_setup_vcpu_event(struct kvm_vcpu *vcpu,
 bool kvmi_arch_vcpu_alloc_interception(struct kvm_vcpu *vcpu);
 void kvmi_arch_vcpu_free_interception(struct kvm_vcpu *vcpu);
 bool kvmi_arch_vcpu_introspected(struct kvm_vcpu *vcpu);
-void kvmi_arch_request_interception_cleanup(struct kvm_vcpu *vcpu);
+void kvmi_arch_request_interception_cleanup(struct kvm_vcpu *vcpu,
+				bool restore_interception);
 bool kvmi_arch_clean_up_interception(struct kvm_vcpu *vcpu);
 void kvmi_arch_post_reply(struct kvm_vcpu *vcpu);
 bool kvmi_arch_is_agent_hypercall(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index ee41f2397822..224049b92138 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -273,18 +273,36 @@ static int handle_vm_pause_vcpu(struct kvm_introspection *kvmi,
 	return kvmi_msg_vm_reply(kvmi, msg, ec, NULL, 0);
 }
 
+static int handle_vm_control_cleanup(struct kvm_introspection *kvmi,
+				     const struct kvmi_msg_hdr *msg,
+				     const void *_req)
+{
+	const struct kvmi_vm_control_cleanup *req = _req;
+	int ec = 0;
+
+	if (non_zero_padding(req->padding, ARRAY_SIZE(req->padding)))
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
 static kvmi_vm_msg_fct const msg_vm[] = {
-	[KVMI_GET_VERSION]       = handle_get_version,
-	[KVMI_VM_CHECK_COMMAND]  = handle_vm_check_command,
-	[KVMI_VM_CHECK_EVENT]    = handle_vm_check_event,
-	[KVMI_VM_CONTROL_EVENTS] = handle_vm_control_events,
-	[KVMI_VM_GET_INFO]       = handle_vm_get_info,
-	[KVMI_VM_PAUSE_VCPU]     = handle_vm_pause_vcpu,
-	[KVMI_VM_READ_PHYSICAL]  = handle_vm_read_physical,
-	[KVMI_VM_WRITE_PHYSICAL] = handle_vm_write_physical,
+	[KVMI_GET_VERSION]        = handle_get_version,
+	[KVMI_VM_CHECK_COMMAND]   = handle_vm_check_command,
+	[KVMI_VM_CHECK_EVENT]     = handle_vm_check_event,
+	[KVMI_VM_CONTROL_CLEANUP] = handle_vm_control_cleanup,
+	[KVMI_VM_CONTROL_EVENTS]  = handle_vm_control_events,
+	[KVMI_VM_GET_INFO]        = handle_vm_get_info,
+	[KVMI_VM_PAUSE_VCPU]      = handle_vm_pause_vcpu,
+	[KVMI_VM_READ_PHYSICAL]   = handle_vm_read_physical,
+	[KVMI_VM_WRITE_PHYSICAL]  = handle_vm_write_physical,
 };
 
 static kvmi_vm_msg_fct get_vm_msg_handler(u16 id)
