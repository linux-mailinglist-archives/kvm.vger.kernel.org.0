Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B65E228AB3
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731442AbgGUVQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:31 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37792 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731391AbgGUVQS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:18 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id B2153305D4EF;
        Wed, 22 Jul 2020 00:09:27 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 93428304FA13;
        Wed, 22 Jul 2020 00:09:27 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 55/84] KVM: introspection: add KVMI_VCPU_CONTROL_EVENTS
Date:   Wed, 22 Jul 2020 00:08:53 +0300
Message-Id: <20200721210922.7646-56-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

By default, all introspection vCPU events are disabled. The introspection
tool must explicitly enable the vCPU events it wants to receive. With
this command (KVMI_VCPU_CONTROL_EVENTS) it can enable/disable any vCPU
event if allowed by the device manager.

Some vCPU events doesn't have to be explicitly enabled (and can't be
disabled) with this command because they are implicitly enabled/requested
by the use of certain commands. For example, if the introspection
tool uses the KVMI_VCPU_PAUSE command, it wants to receive an
KVMI_EVENT_PAUSE_VCPU event.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 51 +++++++++++++++++-
 include/linux/kvmi_host.h                     |  2 +
 include/uapi/linux/kvmi.h                     | 12 ++++-
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 54 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 26 +++++++++
 virt/kvm/introspection/kvmi_int.h             |  3 ++
 virt/kvm/introspection/kvmi_msg.c             | 26 ++++++++-
 7 files changed, 169 insertions(+), 5 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 06c1cb34209e..4393ce89b2fa 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -377,6 +377,9 @@ the following events::
 
 	KVMI_EVENT_UNHOOK
 
+The vCPU events (e.g. *KVMI_EVENT_PAUSE_VCPU*) are controlled with
+the *KVMI_VCPU_CONTROL_EVENTS* command.
+
 :Errors:
 
 * -KVM_EINVAL - the padding is not zero
@@ -520,12 +523,58 @@ command) before returning to guest.
                 *KVMI_EVENT_PAUSE_VCPU* events
 * -KVM_EPERM  - the *KVMI_EVENT_PAUSE_VCPU* event is disallowed
 
+10. KVMI_VCPU_CONTROL_EVENTS
+----------------------------
+
+:Architectures: all
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_control_events {
+		__u16 event_id;
+		__u8 enable;
+		__u8 padding1;
+		__u32 padding2;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code
+
+Enables/disables vCPU introspection events.
+
+When an event is enabled, the introspection tool is notified and
+must reply with: continue, retry, crash, etc. (see **Events** below).
+
+The following vCPU events doesn't have to be enabled and can't be disabled,
+because these are sent as a result of certain commands (but they can be
+disallowed by the device manager) ::
+
+	KVMI_EVENT_PAUSE_VCPU
+
+The VM events (e.g. *KVMI_EVENT_UNHOOK*) are controlled with
+the *KVMI_VM_CONTROL_EVENTS* command.
+
+:Errors:
+
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the event ID is unknown (use *KVMI_VM_CHECK_EVENT* first)
+* -KVM_EPERM - the access is disallowed (use *KVMI_VM_CHECK_EVENT* first)
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
 All introspection events (VM or vCPU related) are sent
 using the *KVMI_EVENT* message id. No event will be sent unless
-it is explicitly enabled or requested (eg. *KVMI_EVENT_PAUSE_VCPU*).
+it is explicitly enabled (see *KVMI_VM_CONTROL_EVENTS*
+and *KVMI_VCPU_CONTROL_EVENTS*) or requested (eg. *KVMI_EVENT_PAUSE_VCPU*).
 
 The *KVMI_EVENT_UNHOOK* event doesn't have a reply and share the kvmi_event
 structure, for consistency with the vCPU events.
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index a87f0322c584..9625c8f19379 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -31,6 +31,8 @@ struct kvm_vcpu_introspection {
 
 	struct kvmi_vcpu_reply reply;
 	bool waiting_for_reply;
+
+	unsigned long *ev_enable_mask;
 };
 
 struct kvm_introspection {
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 5a5b01df7e3e..9ebf17fa9564 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -25,8 +25,9 @@ enum {
 	KVMI_VM_READ_PHYSICAL  = 6,
 	KVMI_VM_WRITE_PHYSICAL = 7,
 
-	KVMI_VCPU_GET_INFO     = 8,
-	KVMI_VCPU_PAUSE        = 9,
+	KVMI_VCPU_GET_INFO       = 8,
+	KVMI_VCPU_PAUSE          = 9,
+	KVMI_VCPU_CONTROL_EVENTS = 10,
 
 	KVMI_NUM_MESSAGES
 };
@@ -122,6 +123,13 @@ struct kvmi_vcpu_pause {
 	__u32 padding3;
 };
 
+struct kvmi_vcpu_control_events {
+	__u16 event_id;
+	__u8 enable;
+	__u8 padding1;
+	__u32 padding2;
+};
+
 struct kvmi_event {
 	__u16 size;
 	__u16 vcpu;
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 5c5c5018832d..da6a06fa0baa 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -834,6 +834,59 @@ static void test_pause(struct kvm_vm *vm)
 	allow_event(vm, KVMI_EVENT_PAUSE_VCPU);
 }
 
+static void cmd_vcpu_control_event(struct kvm_vm *vm, __u16 event_id,
+				   __u8 enable, __u16 padding,
+				   int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_control_events cmd;
+	} req = {};
+	int r;
+
+	req.cmd.event_id = event_id;
+	req.cmd.enable = enable;
+	req.cmd.padding1 = padding;
+	req.cmd.padding2 = padding;
+
+	r = do_vcpu0_command(vm, KVMI_VCPU_CONTROL_EVENTS,
+			     &req.hdr, sizeof(req), NULL, 0);
+	TEST_ASSERT(r == expected_err,
+		"KVMI_VCPU_CONTROL_EVENTS failed to enable vCPU event %d, error %d (%s), expected error %d\n",
+		event_id, -r, kvm_strerror(-r), expected_err);
+}
+
+
+static void enable_vcpu_event(struct kvm_vm *vm, __u16 event_id)
+{
+	cmd_vcpu_control_event(vm, event_id, 1, 0, 0);
+}
+
+static void disable_vcpu_event(struct kvm_vm *vm, __u16 event_id)
+{
+	cmd_vcpu_control_event(vm, event_id, 0, 0, 0);
+}
+
+static void test_cmd_vcpu_control_events(struct kvm_vm *vm)
+{
+	__u16 id = KVMI_EVENT_PAUSE_VCPU, invalid_id = 0xffff;
+	__u16 padding = 1, no_padding = 0;
+	__u8 enable = 1, enable_inval = 2;
+
+	enable_vcpu_event(vm, id);
+	disable_vcpu_event(vm, id);
+
+	cmd_vcpu_control_event(vm, id, enable, padding, -KVM_EINVAL);
+	cmd_vcpu_control_event(vm, id, enable_inval, no_padding, -KVM_EINVAL);
+	cmd_vcpu_control_event(vm, invalid_id, enable, no_padding, -KVM_EINVAL);
+
+	disallow_event(vm, id);
+	cmd_vcpu_control_event(vm, id, enable, no_padding, -KVM_EPERM);
+	allow_event(vm, id);
+
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -850,6 +903,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_memory_access(vm);
 	test_cmd_vcpu_get_info(vm);
 	test_pause(vm);
+	test_cmd_vcpu_control_events(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 9e0014bbf9a6..286a81e55d9d 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -73,6 +73,11 @@ bool kvmi_is_known_vm_event(u8 id)
 	return id < KVMI_NUM_EVENTS && test_bit(id, Kvmi_known_vm_events);
 }
 
+bool kvmi_is_known_vcpu_event(u8 id)
+{
+	return id < KVMI_NUM_EVENTS && test_bit(id, Kvmi_known_vcpu_events);
+}
+
 static bool is_vm_event_enabled(struct kvm_introspection *kvmi, int event)
 {
 	return test_bit(event, kvmi->vm_event_enable_mask);
@@ -179,6 +184,12 @@ static bool alloc_vcpui(struct kvm_vcpu *vcpu)
 	if (!vcpui)
 		return false;
 
+	vcpui->ev_enable_mask = bitmap_zalloc(KVMI_NUM_EVENTS, GFP_KERNEL);
+	if (!vcpui->ev_enable_mask) {
+		kfree(vcpu);
+		return false;
+	}
+
 	INIT_LIST_HEAD(&vcpui->job_list);
 	spin_lock_init(&vcpui->job_lock);
 
@@ -214,6 +225,8 @@ static void free_vcpui(struct kvm_vcpu *vcpu)
 
 	free_vcpu_jobs(vcpui);
 
+	bitmap_free(vcpui->ev_enable_mask);
+
 	kfree(vcpui);
 	vcpu->kvmi = NULL;
 }
@@ -613,6 +626,19 @@ int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 	return 0;
 }
 
+int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
+				 unsigned int event_id, bool enable)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	if (enable)
+		set_bit(event_id, vcpui->ev_enable_mask);
+	else
+		clear_bit(event_id, vcpui->ev_enable_mask);
+
+	return 0;
+}
+
 static unsigned long gfn_to_hva_safe(struct kvm *kvm, gfn_t gfn)
 {
 	unsigned long hva;
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index f73596032883..57a62ebadd94 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -35,12 +35,15 @@ void kvmi_msg_free(void *addr);
 bool kvmi_is_command_allowed(struct kvm_introspection *kvmi, u16 id);
 bool kvmi_is_known_event(u8 id);
 bool kvmi_is_known_vm_event(u8 id);
+bool kvmi_is_known_vcpu_event(u8 id);
 int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
 		 void *ctx, void (*free_fct)(void *ctx));
 void kvmi_run_jobs(struct kvm_vcpu *vcpu);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
+int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
+				 unsigned int event_id, bool enable);
 int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
 			   int (*send)(struct kvm_introspection *,
 					const struct kvmi_msg_hdr*,
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 1dcd3db75ff1..20ef4a44d3a2 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -397,6 +397,27 @@ static int handle_vcpu_event_reply(const struct kvmi_vcpu_msg_job *job,
 	return expected->error;
 }
 
+static int handle_vcpu_control_events(const struct kvmi_vcpu_msg_job *job,
+				      const struct kvmi_msg_hdr *msg,
+				      const void *_req)
+{
+	struct kvm_introspection *kvmi = KVMI(job->vcpu->kvm);
+	const struct kvmi_vcpu_control_events *req = _req;
+	int ec;
+
+	if (req->padding1 || req->padding2 || req->enable > 1)
+		ec = -KVM_EINVAL;
+	else if (!kvmi_is_known_vcpu_event(req->event_id))
+		ec = -KVM_EINVAL;
+	else if (!is_event_allowed(kvmi, req->event_id))
+		ec = -KVM_EPERM;
+	else
+		ec = kvmi_cmd_vcpu_control_events(job->vcpu, req->event_id,
+						  req->enable == 1);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 /*
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -405,8 +426,9 @@ static int handle_vcpu_event_reply(const struct kvmi_vcpu_msg_job *job,
  */
 static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
-	[KVMI_EVENT]         = handle_vcpu_event_reply,
-	[KVMI_VCPU_GET_INFO] = handle_vcpu_get_info,
+	[KVMI_EVENT]               = handle_vcpu_event_reply,
+	[KVMI_VCPU_CONTROL_EVENTS] = handle_vcpu_control_events,
+	[KVMI_VCPU_GET_INFO]       = handle_vcpu_get_info,
 };
 
 static bool is_vcpu_command(u16 id)
