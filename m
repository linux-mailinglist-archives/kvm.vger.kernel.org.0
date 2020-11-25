Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8100A2C3C77
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgKYJl4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:41:56 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57094 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726620AbgKYJlz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:41:55 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E785C305D49A;
        Wed, 25 Nov 2020 11:35:50 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id C5CE63072784;
        Wed, 25 Nov 2020 11:35:50 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 50/81] KVM: introspection: add KVMI_VCPU_EVENT_PAUSE
Date:   Wed, 25 Nov 2020 11:35:29 +0200
Message-Id: <20201125093600.2766-51-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This event is sent by the vCPU thread as a response to the
KVMI_VM_PAUSE_VCPU command, but it has a lower priority, being sent
after any other introspection event and when no other introspection
command is queued.

The number of KVMI_VCPU_EVENT_PAUSE will match the number of successful
KVMI_VM_PAUSE_VCPU commands.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 26 ++++++++
 include/uapi/linux/kvmi.h                     |  2 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 65 ++++++++++++++++++-
 virt/kvm/introspection/kvmi.c                 | 26 +++++++-
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 18 +++++
 6 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 5e99baf7e2f3..c86c83566c3d 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -596,3 +596,29 @@ the guest (see **Unhooking**) and the introspection has been enabled for
 this event (see **KVMI_VM_CONTROL_EVENTS**). The introspection tool has
 a chance to unhook and close the introspection socket (signaling that
 the operation can proceed).
+
+2. KVMI_VCPU_EVENT_PAUSE
+------------------------
+
+:Architectures: all
+:Versions: >= 1
+:Actions: CONTINUE, CRASH
+:Parameters:
+
+::
+
+	struct kvmi_event_hdr;
+	struct kvmi_vcpu_event;
+
+:Returns:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_event_reply;
+
+This event is sent in response to a *KVMI_VCPU_PAUSE* command and
+cannot be controlled with *KVMI_VCPU_CONTROL_EVENTS*.
+Because it has a low priority, it will be sent after any other vCPU
+introspection event and when no other vCPU introspection command is
+queued.
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 6a57efb5664d..757d4b84f473 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -50,6 +50,8 @@ enum {
 };
 
 enum {
+	KVMI_VCPU_EVENT_PAUSE = KVMI_VCPU_EVENT_ID(0),
+
 	KVMI_NEXT_VCPU_EVENT
 };
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 52765ca3f9c8..4c9dc6560ad9 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -34,6 +34,17 @@ static vm_paddr_t test_gpa;
 
 static int page_size;
 
+struct vcpu_event {
+	struct kvmi_event_hdr hdr;
+	struct kvmi_vcpu_event common;
+};
+
+struct vcpu_reply {
+	struct kvmi_msg_hdr hdr;
+	struct kvmi_vcpu_hdr vcpu_hdr;
+	struct kvmi_vcpu_event_reply reply;
+};
+
 struct vcpu_worker_data {
 	struct kvm_vm *vm;
 	int vcpu_id;
@@ -690,14 +701,66 @@ static void pause_vcpu(void)
 	cmd_vcpu_pause(1, 0);
 }
 
+static void reply_to_event(struct kvmi_msg_hdr *ev_hdr, struct vcpu_event *ev,
+			   __u8 action, struct vcpu_reply *rpl, size_t rpl_size)
+{
+	ssize_t r;
+
+	rpl->hdr.id = ev_hdr->id;
+	rpl->hdr.seq = ev_hdr->seq;
+	rpl->hdr.size = rpl_size - sizeof(rpl->hdr);
+
+	rpl->vcpu_hdr.vcpu = ev->common.vcpu;
+
+	rpl->reply.action = action;
+	rpl->reply.event = ev->hdr.event;
+
+	r = send(Userspace_socket, rpl, rpl_size, 0);
+	TEST_ASSERT(r == rpl_size,
+		"send() failed, sending %zd, result %zd, errno %d (%s)\n",
+		rpl_size, r, errno, strerror(errno));
+}
+
+static void receive_vcpu_event(struct kvmi_msg_hdr *msg_hdr,
+			       struct vcpu_event *ev,
+			       size_t ev_size, u16 ev_id)
+{
+	receive_event(msg_hdr, KVMI_VCPU_EVENT,
+		      &ev->hdr, ev_id, ev_size);
+}
+
+static void discard_pause_event(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {.vm = vm, .vcpu_id = VCPU_ID};
+	struct vcpu_reply rpl = {};
+	struct kvmi_msg_hdr hdr;
+	pthread_t vcpu_thread;
+	struct vcpu_event ev;
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_vcpu_event(&hdr, &ev, sizeof(ev), KVMI_VCPU_EVENT_PAUSE);
+
+	reply_to_event(&hdr, &ev, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+
+	wait_vcpu_worker(vcpu_thread);
+}
+
 static void test_pause(struct kvm_vm *vm)
 {
-	__u8 wait = 1, wait_inval = 2;
+	__u8 no_wait = 0, wait = 1, wait_inval = 2;
 
 	pause_vcpu();
+	discard_pause_event(vm);
 
 	cmd_vcpu_pause(wait, 0);
+	discard_pause_event(vm);
 	cmd_vcpu_pause(wait_inval, -KVM_EINVAL);
+
+	disallow_event(vm, KVMI_VCPU_EVENT_PAUSE);
+	cmd_vcpu_pause(no_wait, -KVM_EPERM);
+	allow_event(vm, KVMI_VCPU_EVENT_PAUSE);
 }
 
 static void test_introspection(struct kvm_vm *vm)
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 771e6b545698..3d26a7319fb7 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -103,6 +103,7 @@ static void kvmi_init_known_events(void)
 
 	bitmap_zero(Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
 	kvmi_arch_init_vcpu_events_mask(Kvmi_known_vcpu_events);
+	set_bit(KVMI_VCPU_EVENT_PAUSE, Kvmi_known_vcpu_events);
 
 	bitmap_or(Kvmi_known_events, Kvmi_known_vm_events,
 		  Kvmi_known_vcpu_events, KVMI_NUM_EVENTS);
@@ -740,12 +741,35 @@ void kvmi_run_jobs(struct kvm_vcpu *vcpu)
 	}
 }
 
+static void kvmi_handle_unsupported_event_action(struct kvm *kvm)
+{
+	kvmi_sock_shutdown(KVMI(kvm));
+}
+
+void kvmi_handle_common_event_actions(struct kvm_vcpu *vcpu, u32 action)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	switch (action) {
+	default:
+		kvmi_handle_unsupported_event_action(kvm);
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
+		kvmi_handle_common_event_actions(vcpu, action);
+	}
 }
 
 void kvmi_handle_requests(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 65d8c1c37796..0876740dfa24 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -38,6 +38,7 @@ int kvmi_send_vcpu_event(struct kvm_vcpu *vcpu, u32 ev_id,
 int kvmi_msg_vcpu_reply(const struct kvmi_vcpu_msg_job *job,
 			const struct kvmi_msg_hdr *msg, int err,
 			const void *rpl, size_t rpl_size);
+u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 467c88185be1..71a28e26d382 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -258,6 +258,11 @@ static int handle_vm_pause_vcpu(struct kvm_introspection *kvmi,
 		goto reply;
 	}
 
+	if (!kvmi_is_event_allowed(kvmi, KVMI_VCPU_EVENT_PAUSE)) {
+		err = -KVM_EPERM;
+		goto reply;
+	}
+
 	vcpu = kvmi_get_vcpu(kvmi, req->vcpu);
 	if (!vcpu)
 		err = -KVM_EINVAL;
@@ -697,3 +702,16 @@ int kvmi_send_vcpu_event(struct kvm_vcpu *vcpu, u32 ev_id,
 
 	return err;
 }
+
+u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu)
+{
+	u32 action;
+	int err;
+
+	err = kvmi_send_vcpu_event(vcpu, KVMI_VCPU_EVENT_PAUSE, NULL, 0,
+				   NULL, 0, &action);
+	if (err)
+		return KVMI_EVENT_ACTION_CONTINUE;
+
+	return action;
+}
