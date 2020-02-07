Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4229F155DA4
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgBGSRi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:38 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40756 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727490AbgBGSQw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:52 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E78F9305D352;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id D95F0305206A;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 52/78] KVM: introspection: add KVMI_EVENT_PAUSE_VCPU
Date:   Fri,  7 Feb 2020 20:16:10 +0200
Message-Id: <20200207181636.1065-53-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This event is send by the vCPU thread and has a low priority. It
will be sent after any other vCPU introspection event and when no vCPU
introspection command is queued.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  23 ++-
 arch/x86/kvm/kvmi.c                           |  53 ++++++
 include/linux/kvmi_host.h                     |  11 ++
 include/uapi/linux/kvmi.h                     |  14 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  |  48 +++++-
 virt/kvm/introspection/kvmi.c                 |  49 +++++-
 virt/kvm/introspection/kvmi_int.h             |   3 +
 virt/kvm/introspection/kvmi_msg.c             | 153 +++++++++++++++++-
 8 files changed, 347 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index ba01b9a249a2..8bf9b8f6dd7c 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -548,6 +548,27 @@ On x86 the structure looks like this::
 
 It contains information about the vCPU state at the time of the event.
 
+The reply to events uses the *KVMI_EVENT_REPLY* message id and begins
+with two common structures::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_event_reply {
+		__u8 action;
+		__u8 event;
+		__u16 padding1;
+		__u32 padding2;
+	};
+
+All events accept the KVMI_EVENT_ACTION_CRASH action, which stops the
+guest ungracefully, but as soon as possible.
+
+Most of the events accept the KVMI_EVENT_ACTION_CONTINUE action, which
+lets the instruction that caused the event to continue (unless specified
+otherwise).
+
+Some of the events accept the KVMI_EVENT_ACTION_RETRY action, to continue
+by re-entering the guest.
+
 Specific data can follow these common structures.
 
 1. KVMI_EVENT_UNHOOK
@@ -570,7 +591,7 @@ for this event (see **KVMI_VM_CONTROL_EVENTS**). The introspection tool
 has a chance to unhook and close the KVMI channel (signaling that the
 operation can proceed).
 
-1. KVMI_EVENT_PAUSE_VCPU
+2. KVMI_EVENT_PAUSE_VCPU
 ------------------------
 
 :Architectures: all
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 2afb3abc97fa..842d6abebb41 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -5,8 +5,61 @@
  * Copyright (C) 2019-2020 Bitdefender S.R.L.
  */
 
+#include "linux/kvm_host.h"
+#include "x86.h"
 #include "../../../virt/kvm/introspection/kvmi_int.h"
 
+static unsigned int kvmi_vcpu_mode(const struct kvm_vcpu *vcpu,
+				   const struct kvm_sregs *sregs)
+{
+	unsigned int mode = 0;
+
+	if (is_long_mode((struct kvm_vcpu *) vcpu)) {
+		if (sregs->cs.l)
+			mode = 8;
+		else if (!sregs->cs.db)
+			mode = 2;
+		else
+			mode = 4;
+	} else if (sregs->cr0 & X86_CR0_PE) {
+		if (!sregs->cs.db)
+			mode = 2;
+		else
+			mode = 4;
+	} else if (!sregs->cs.db) {
+		mode = 2;
+	} else {
+		mode = 4;
+	}
+
+	return mode;
+}
+
+static void kvmi_get_msrs(struct kvm_vcpu *vcpu, struct kvmi_event_arch *ev)
+{
+	__kvm_get_msr(vcpu, MSR_IA32_SYSENTER_CS, &ev->msrs.sysenter_cs, true);
+	__kvm_get_msr(vcpu, MSR_IA32_SYSENTER_ESP, &ev->msrs.sysenter_esp,
+			true);
+	__kvm_get_msr(vcpu, MSR_IA32_SYSENTER_EIP, &ev->msrs.sysenter_eip,
+			true);
+	__kvm_get_msr(vcpu, MSR_EFER, &ev->msrs.efer, true);
+	__kvm_get_msr(vcpu, MSR_STAR, &ev->msrs.star, true);
+	__kvm_get_msr(vcpu, MSR_LSTAR, &ev->msrs.lstar, true);
+	__kvm_get_msr(vcpu, MSR_CSTAR, &ev->msrs.cstar, true);
+	__kvm_get_msr(vcpu, MSR_IA32_CR_PAT, &ev->msrs.pat, true);
+	__kvm_get_msr(vcpu, MSR_KERNEL_GS_BASE, &ev->msrs.shadow_gs, true);
+}
+
+void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev)
+{
+	struct kvmi_event_arch *event = &ev->arch;
+
+	kvm_arch_vcpu_get_regs(vcpu, &event->regs);
+	kvm_arch_vcpu_get_sregs(vcpu, &event->sregs);
+	ev->arch.mode = kvmi_vcpu_mode(vcpu, &event->sregs);
+	kvmi_get_msrs(vcpu, event);
+}
+
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_get_info_reply *rpl)
 {
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 988927c29bf5..49e68777a390 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -11,6 +11,14 @@ struct kvm_vcpu;
 
 #define KVMI_NUM_COMMANDS KVMI_NUM_MESSAGES
 
+struct kvmi_vcpu_reply {
+	int error;
+	int action;
+	u32 seq;
+	void *data;
+	size_t size;
+};
+
 struct kvmi_job {
 	struct list_head link;
 	void *ctx;
@@ -25,6 +33,9 @@ struct kvm_vcpu_introspection {
 	spinlock_t job_lock;
 
 	atomic_t pause_requests;
+
+	struct kvmi_vcpu_reply reply;
+	bool waiting_for_reply;
 };
 
 struct kvm_introspection {
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 54a788c1c204..2eb1e5b20d53 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -15,6 +15,7 @@ enum {
 };
 
 enum {
+	KVMI_EVENT_REPLY       = 0,
 	KVMI_EVENT             = 1,
 
 	KVMI_GET_VERSION       = 2,
@@ -38,6 +39,12 @@ enum {
 	KVMI_NUM_EVENTS
 };
 
+enum {
+	KVMI_EVENT_ACTION_CONTINUE = 0,
+	KVMI_EVENT_ACTION_RETRY    = 1,
+	KVMI_EVENT_ACTION_CRASH    = 2,
+};
+
 struct kvmi_msg_hdr {
 	__u16 id;
 	__u16 size;
@@ -114,4 +121,11 @@ struct kvmi_event {
 	struct kvmi_event_arch arch;
 };
 
+struct kvmi_event_reply {
+	__u8 action;
+	__u8 event;
+	__u16 padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 942601f6177b..27de5fb24580 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -33,6 +33,12 @@ static vm_paddr_t test_gpa;
 static uint8_t test_write_pattern;
 static int page_size;
 
+struct vcpu_reply {
+	struct kvmi_msg_hdr hdr;
+	struct kvmi_vcpu_hdr vcpu_hdr;
+	struct kvmi_event_reply reply;
+};
+
 struct vcpu_worker_data {
 	struct kvm_vm *vm;
 	int vcpu_id;
@@ -550,7 +556,7 @@ static void *vcpu_worker(void *data)
 
 	run = vcpu_state(ctx->vm, ctx->vcpu_id);
 
-	while (!ctx->stop) {
+	while (!READ_ONCE(ctx->stop)) {
 		struct ucall uc;
 
 		vcpu_run(ctx->vm, ctx->vcpu_id);
@@ -589,7 +595,7 @@ static void wait_vcpu_worker(pthread_t vcpu_thread)
 static void stop_vcpu_worker(pthread_t vcpu_thread,
 			     struct vcpu_worker_data *data)
 {
-	data->stop = true;
+	WRITE_ONCE(data->stop, true);
 
 	wait_vcpu_worker(vcpu_thread);
 }
@@ -673,9 +679,47 @@ static void pause_vcpu(struct kvm_vm *vm)
 		-r, kvm_strerror(-r));
 }
 
+static void reply_to_event(struct kvmi_msg_hdr *ev_hdr, struct kvmi_event *ev,
+			   __u8 action, struct vcpu_reply *rpl, size_t rpl_size)
+{
+	ssize_t r;
+
+	rpl->hdr.id = KVMI_EVENT_REPLY;
+	rpl->hdr.seq = ev_hdr->seq;
+	rpl->hdr.size = rpl_size - sizeof(rpl->hdr);
+
+	rpl->vcpu_hdr.vcpu = ev->vcpu;
+
+	rpl->reply.action = action;
+	rpl->reply.event = ev->event;
+
+	r = send(Userspace_socket, rpl, rpl_size, 0);
+	TEST_ASSERT(r == rpl_size,
+		"send() failed, sending %d, result %d, errno %d (%s)\n",
+		rpl_size, r, errno, strerror(errno));
+}
+
 static void test_pause(struct kvm_vm *vm)
 {
+	struct vcpu_worker_data data = {.vm = vm, .vcpu_id = VCPU_ID};
+	__u16 event_id = KVMI_EVENT_PAUSE_VCPU;
+	struct vcpu_reply rpl = {};
+	struct kvmi_msg_hdr hdr;
+	pthread_t vcpu_thread;
+	struct kvmi_event ev;
+
+	allow_event(vm, event_id);
+
 	pause_vcpu(vm);
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_event(&hdr, &ev, sizeof(ev), event_id);
+
+	reply_to_event(&hdr, &ev, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+
+	stop_vcpu_worker(vcpu_thread, &data);
 }
 
 static void test_introspection(struct kvm_vm *vm)
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 51c090a56242..670c14c9683f 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -291,6 +291,7 @@ static void kvmi_job_release_vcpu(struct kvm_vcpu *vcpu, void *ctx)
 	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
 
 	atomic_set(&vcpui->pause_requests, 0);
+	vcpui->waiting_for_reply = false;
 }
 
 static void kvmi_release_vcpus(struct kvm *kvm)
@@ -702,12 +703,58 @@ void kvmi_run_jobs(struct kvm_vcpu *vcpu)
 	}
 }
 
+static int kvmi_vcpu_kill(int sig, struct kvm_vcpu *vcpu)
+{
+	struct kernel_siginfo siginfo[1] = {};
+	int err = -ESRCH;
+	struct pid *pid;
+
+	rcu_read_lock();
+	pid = rcu_dereference(vcpu->pid);
+	if (pid)
+		err = kill_pid_info(sig, siginfo, pid);
+	rcu_read_unlock();
+
+	return err;
+}
+
+static void kvmi_vm_shutdown(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	int i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		kvmi_vcpu_kill(SIGTERM, vcpu);
+}
+
+void kvmi_handle_common_event_actions(struct kvm *kvm,
+				      u32 action, const char *str)
+{
+	switch (action) {
+	case KVMI_EVENT_ACTION_CRASH:
+		kvmi_vm_shutdown(kvm);
+		break;
+
+	default:
+		kvmi_err(KVMI(kvm), "Unsupported action %d for event %s\n",
+			 action, str);
+	}
+}
+
 static void kvmi_vcpu_pause_event(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	u32 action;
 
 	atomic_dec(&vcpui->pause_requests);
-	/* to be implemented */
+
+	action = kvmi_msg_send_vcpu_pause(vcpu);
+	switch (action) {
+	case KVMI_EVENT_ACTION_CONTINUE:
+		break;
+	default:
+		kvmi_handle_common_event_actions(vcpu->kvm, action, "PAUSE");
+	}
 }
 
 void kvmi_handle_requests(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index d1d93488af1c..50b2b98dd99b 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -54,6 +54,7 @@ void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
 void kvmi_sock_put(struct kvm_introspection *kvmi);
 bool kvmi_msg_process(struct kvm_introspection *kvmi);
 int kvmi_msg_send_unhook(struct kvm_introspection *kvmi);
+u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
@@ -62,6 +63,7 @@ void kvmi_msg_free(void *addr);
 int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
 		 void *ctx, void (*free_fct)(void *ctx));
+void kvmi_run_jobs(struct kvm_vcpu *vcpu);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
 int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, u64 size,
@@ -76,5 +78,6 @@ int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
 /* arch */
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_get_info_reply *rpl);
+void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 1eae0a9a8e0a..69abca999cd2 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -17,6 +17,7 @@ struct kvmi_vcpu_cmd_job {
 };
 
 static const char *const msg_IDs[] = {
+	[KVMI_EVENT_REPLY]       = "KVMI_EVENT_REPLY",
 	[KVMI_GET_VERSION]       = "KVMI_GET_VERSION",
 	[KVMI_VM_CHECK_COMMAND]  = "KVMI_VM_CHECK_COMMAND",
 	[KVMI_VM_CHECK_EVENT]    = "KVMI_VM_CHECK_EVENT",
@@ -356,6 +357,56 @@ static int handle_get_vcpu_info(const struct kvmi_vcpu_cmd_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, 0, &rpl, sizeof(rpl));
 }
 
+static int handle_event_reply(const struct kvmi_vcpu_cmd_job *job,
+			      const struct kvmi_msg_hdr *msg, const void *rpl)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(job->vcpu);
+	struct kvm_introspection *kvmi = KVMI(job->vcpu->kvm);
+	struct kvmi_vcpu_reply *expected = &vcpui->reply;
+	const struct kvmi_event_reply *reply = rpl;
+	size_t useful, received, common;
+
+	if (unlikely(msg->seq != expected->seq))
+		goto out_wakeup;
+
+	common = sizeof(struct kvmi_vcpu_hdr) + sizeof(*reply);
+	if (unlikely(msg->size < common))
+		goto out_wakeup;
+
+	if (unlikely(reply->padding1 || reply->padding2))
+		goto out_wakeup;
+
+	received = msg->size - common;
+	/* Don't accept newer/bigger structures */
+	if (unlikely(received > expected->size))
+		goto out_wakeup;
+
+	useful = min(received, expected->size);
+	if (useful)
+		memcpy(expected->data, reply + 1, useful);
+
+	if (useful < expected->size)
+		memset((char *)expected->data + useful, 0,
+			expected->size - useful);
+
+	expected->action = reply->action;
+	expected->error = 0;
+
+out_wakeup:
+
+	if (unlikely(expected->error))
+		kvmi_err(kvmi, "Invalid event %d/%d reply seq %x/%x size %u min %zu expected %zu padding %u,%u\n",
+			 reply->event, reply->action,
+			 msg->seq, expected->seq,
+			 msg->size, common,
+			 common + expected->size,
+			 reply->padding1,
+			 reply->padding2);
+
+	vcpui->waiting_for_reply = false;
+	return expected->error;
+}
+
 /*
  * These commands are executed on the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -364,6 +415,7 @@ static int handle_get_vcpu_info(const struct kvmi_vcpu_cmd_job *job,
  */
 static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
+	[KVMI_EVENT_REPLY]   = handle_event_reply,
 	[KVMI_VCPU_GET_INFO] = handle_get_vcpu_info,
 };
 
@@ -489,7 +541,8 @@ static int kvmi_msg_dispatch_vm_cmd(struct kvm_introspection *kvmi,
 
 static bool vcpu_can_handle_commands(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.mp_state != KVM_MP_STATE_UNINITIALIZED;
+	return VCPUI(vcpu)->waiting_for_reply
+		|| vcpu->arch.mp_state != KVM_MP_STATE_UNINITIALIZED;
 }
 
 static int kvmi_get_vcpu_if_ready(struct kvm_introspection *kvmi,
@@ -569,6 +622,9 @@ static int kvmi_msg_dispatch(struct kvm_introspection *kvmi,
 
 static bool is_message_allowed(struct kvm_introspection *kvmi, __u16 id)
 {
+	if (id == KVMI_EVENT_REPLY)
+		return true;
+
 	if (id >= KVMI_NUM_COMMANDS)
 		return false;
 
@@ -616,14 +672,23 @@ static inline u32 new_seq(struct kvm_introspection *kvmi)
 	return atomic_inc_return(&kvmi->ev_seq);
 }
 
-static void kvmi_setup_event_common(struct kvmi_event *ev, u32 ev_id)
+static void kvmi_setup_event_common(struct kvmi_event *ev, u32 ev_id,
+				    unsigned short vcpu_idx)
 {
 	memset(ev, 0, sizeof(*ev));
 
+	ev->vcpu = vcpu_idx;
 	ev->event = ev_id;
 	ev->size = sizeof(*ev);
 }
 
+static void kvmi_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev,
+			     u32 ev_id)
+{
+	kvmi_setup_event_common(ev, ev_id, kvm_vcpu_get_idx(vcpu));
+	kvmi_arch_setup_event(vcpu, ev);
+}
+
 int kvmi_msg_send_unhook(struct kvm_introspection *kvmi)
 {
 	struct kvmi_msg_hdr hdr;
@@ -640,7 +705,89 @@ int kvmi_msg_send_unhook(struct kvm_introspection *kvmi)
 	hdr.seq = new_seq(kvmi);
 	hdr.size = msg_size - sizeof(hdr);
 
-	kvmi_setup_event_common(&common, KVMI_EVENT_UNHOOK);
+	kvmi_setup_event_common(&common, KVMI_EVENT_UNHOOK, 0);
 
 	return kvmi_sock_write(kvmi, vec, n, msg_size);
 }
+
+static int kvmi_wait_for_reply(struct kvm_vcpu *vcpu)
+{
+	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	int err = 0;
+
+	vcpui->waiting_for_reply = true;
+
+	while (vcpui->waiting_for_reply && !err) {
+		kvmi_run_jobs(vcpu);
+
+		err = swait_event_killable_exclusive(*wq,
+			!vcpui->waiting_for_reply ||
+			!list_empty(&vcpui->job_list));
+	}
+
+	return err;
+}
+
+static int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
+			   void *ev, size_t ev_size,
+			   void *rpl, size_t rpl_size, int *action)
+{
+	struct kvmi_msg_hdr hdr;
+	struct kvmi_event common;
+	struct kvec vec[] = {
+		{.iov_base = &hdr,	.iov_len = sizeof(hdr)	 },
+		{.iov_base = &common,	.iov_len = sizeof(common)},
+		{.iov_base = ev,	.iov_len = ev_size	 },
+	};
+	size_t msg_size = sizeof(hdr) + sizeof(common) + ev_size;
+	size_t n = ev_size ? ARRAY_SIZE(vec) : ARRAY_SIZE(vec)-1;
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	struct kvm_introspection *kvmi = KVMI(vcpu->kvm);
+	int err;
+
+	memset(&hdr, 0, sizeof(hdr));
+	hdr.id = KVMI_EVENT;
+	hdr.seq = new_seq(kvmi);
+	hdr.size = msg_size - sizeof(hdr);
+
+	kvmi_setup_event(vcpu, &common, ev_id);
+
+	memset(&vcpui->reply, 0, sizeof(vcpui->reply));
+
+	vcpui->reply.seq = hdr.seq;
+	vcpui->reply.data = rpl;
+	vcpui->reply.size = rpl_size;
+	vcpui->reply.error = -EINTR;
+
+	err = kvmi_sock_write(kvmi, vec, n, msg_size);
+	if (err)
+		goto out;
+
+	err = kvmi_wait_for_reply(vcpu);
+	if (err)
+		goto out;
+
+	err = vcpui->reply.error;
+	if (err)
+		goto out;
+
+	*action = vcpui->reply.action;
+
+out:
+	if (err)
+		kvmi_sock_shutdown(kvmi);
+	return err;
+}
+
+u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu)
+{
+	int err, action;
+
+	err = kvmi_send_event(vcpu, KVMI_EVENT_PAUSE_VCPU, NULL, 0,
+			      NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
