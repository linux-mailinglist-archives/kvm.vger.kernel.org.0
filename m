Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F178228A95
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731387AbgGUVQN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:13 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37848 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731316AbgGUVQK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:10 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 27E0C305D4F1;
        Wed, 22 Jul 2020 00:09:28 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E52C2304FA12;
        Wed, 22 Jul 2020 00:09:27 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 57/84] KVM: introspection: add KVMI_VCPU_SET_REGISTERS
Date:   Wed, 22 Jul 2020 00:08:55 +0300
Message-Id: <20200721210922.7646-58-alazar@bitdefender.com>
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

During an introspection event, the introspection tool might need to
change the vCPU state, for example, to skip the current instruction.

This command is allowed only during vCPU events and the registers will
be set when the reply has been received.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 29 ++++++++
 include/linux/kvmi_host.h                     |  3 +
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 73 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 24 ++++++
 virt/kvm/introspection/kvmi_int.h             |  3 +
 virt/kvm/introspection/kvmi_msg.c             | 17 ++++-
 7 files changed, 149 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index f9095e1a9417..bd35002c3254 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -612,6 +612,35 @@ registers, the special registers and the requested set of MSRs.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - there is not enough memory to allocate the reply
 
+12. KVMI_VCPU_SET_REGISTERS
+---------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvm_regs;
+
+:Returns:
+
+::
+
+	struct kvmi_error_code
+
+Sets the general purpose registers for the given vCPU. The changes become
+visible to other threads accessing the KVM vCPU structure after the event
+currently being handled is replied to.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EOPNOTSUPP - the command hasn't been received during an introspection event
+
 Events
 ======
 
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 9625c8f19379..857b75a2664a 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -33,6 +33,9 @@ struct kvm_vcpu_introspection {
 	bool waiting_for_reply;
 
 	unsigned long *ev_enable_mask;
+
+	struct kvm_regs delayed_regs;
+	bool have_delayed_regs;
 };
 
 struct kvm_introspection {
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 39ff54b4b661..5f637a21a907 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -29,6 +29,7 @@ enum {
 	KVMI_VCPU_PAUSE          = 9,
 	KVMI_VCPU_CONTROL_EVENTS = 10,
 	KVMI_VCPU_GET_REGISTERS  = 11,
+	KVMI_VCPU_SET_REGISTERS  = 12,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 73aafc5d959a..ffd0337d0567 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -961,6 +961,78 @@ static void test_cmd_vcpu_get_registers(struct kvm_vm *vm)
 	test_invalid_vcpu_get_registers(vm);
 }
 
+static int __cmd_vcpu_set_registers(struct kvm_vm *vm,
+				    struct kvm_regs *regs)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvm_regs regs;
+	} req = {};
+
+	memcpy(&req.regs, regs, sizeof(req.regs));
+
+	return __do_vcpu0_command(KVMI_VCPU_SET_REGISTERS,
+				  &req.hdr, sizeof(req), NULL, 0);
+}
+
+static void test_invalid_cmd_vcpu_set_registers(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {.vm = vm, .vcpu_id = VCPU_ID};
+	pthread_t vcpu_thread;
+	struct kvm_regs regs;
+	int r;
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	r = __cmd_vcpu_set_registers(vm, &regs);
+
+	stop_vcpu_worker(vcpu_thread, &data);
+
+	TEST_ASSERT(r == -KVM_EOPNOTSUPP,
+		"KVMI_VCPU_SET_REGISTERS didn't failed with KVM_EOPNOTSUPP, error %d(%s)\n",
+		-r, kvm_strerror(-r));
+}
+
+static void __set_registers(struct kvm_vm *vm,
+			    struct kvm_regs *regs)
+{
+	int r;
+
+	r = __cmd_vcpu_set_registers(vm, regs);
+	TEST_ASSERT(r == 0,
+		"KVMI_VCPU_SET_REGISTERS failed, error %d(%s)\n",
+		-r, kvm_strerror(-r));
+}
+
+static void test_cmd_vcpu_set_registers(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {.vm = vm, .vcpu_id = VCPU_ID};
+	__u16 event_id = KVMI_EVENT_PAUSE_VCPU;
+	struct kvmi_msg_hdr hdr;
+	pthread_t vcpu_thread;
+	struct kvmi_event ev;
+	struct vcpu_reply rpl = {};
+	struct kvm_regs regs = {};
+
+	cmd_vcpu_get_registers(vm, &regs);
+
+	test_invalid_cmd_vcpu_set_registers(vm);
+
+	pause_vcpu();
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	receive_event(&hdr, &ev, sizeof(ev), event_id);
+
+	__set_registers(vm, &ev.arch.regs);
+
+	reply_to_event(&hdr, &ev, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+
+	stop_vcpu_worker(vcpu_thread, &data);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -979,6 +1051,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_pause(vm);
 	test_cmd_vcpu_control_events(vm);
 	test_cmd_vcpu_get_registers(vm);
+	test_cmd_vcpu_set_registers(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 286a81e55d9d..2bffe9ee5b69 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -861,3 +861,27 @@ int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait)
 
 	return 0;
 }
+
+int kvmi_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
+				const struct kvm_regs *regs)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	if (!vcpui->waiting_for_reply)
+		return -KVM_EOPNOTSUPP;
+
+	memcpy(&vcpui->delayed_regs, regs, sizeof(vcpui->delayed_regs));
+	vcpui->have_delayed_regs = true;
+
+	return 0;
+}
+
+void kvmi_post_reply(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	if (vcpui->have_delayed_regs) {
+		kvm_arch_vcpu_set_regs(vcpu, &vcpui->delayed_regs, false);
+		vcpui->have_delayed_regs = false;
+	}
+}
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 740eea3a9531..1d5a07277072 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -40,6 +40,7 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
 		 void *ctx, void (*free_fct)(void *ctx));
 void kvmi_run_jobs(struct kvm_vcpu *vcpu);
+void kvmi_post_reply(struct kvm_vcpu *vcpu);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
 int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
@@ -52,6 +53,8 @@ int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
 int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, size_t size,
 			    const void *buf);
 int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
+int kvmi_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
+				const struct kvm_regs *regs);
 
 /* arch */
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 6c7a600dd477..ed43e4d5f5b2 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -437,6 +437,18 @@ static int handle_vcpu_get_registers(const struct kvmi_vcpu_msg_job *job,
 	return err;
 }
 
+static int handle_vcpu_set_registers(const struct kvmi_vcpu_msg_job *job,
+				     const struct kvmi_msg_hdr *msg,
+				     const void *_req)
+{
+	const struct kvm_regs *regs = _req;
+	int ec;
+
+	ec = kvmi_cmd_vcpu_set_registers(job->vcpu, regs);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 /*
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -449,6 +461,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 	[KVMI_VCPU_CONTROL_EVENTS] = handle_vcpu_control_events,
 	[KVMI_VCPU_GET_INFO]       = handle_vcpu_get_info,
 	[KVMI_VCPU_GET_REGISTERS]  = handle_vcpu_get_registers,
+	[KVMI_VCPU_SET_REGISTERS]  = handle_vcpu_set_registers,
 };
 
 static bool is_vcpu_command(u16 id)
@@ -743,8 +756,10 @@ static int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
 
 	err = vcpui->reply.error;
 
-	if (!err)
+	if (!err) {
+		kvmi_post_reply(vcpu);
 		*action = vcpui->reply.action;
+	}
 
 out:
 	if (err)
