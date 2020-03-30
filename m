Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64BF91978F6
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729809AbgC3KUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:38 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43788 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729666AbgC3KUG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:06 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 1C831305FFB2;
        Mon, 30 Mar 2020 13:12:58 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id EFC39305B7A0;
        Mon, 30 Mar 2020 13:12:57 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 58/81] KVM: introspection: add KVMI_VCPU_SET_REGISTERS
Date:   Mon, 30 Mar 2020 13:12:45 +0300
Message-Id: <20200330101308.21702-59-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
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
 Documentation/virt/kvm/kvmi.rst               | 29 +++++++
 include/linux/kvmi_host.h                     |  3 +
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 78 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 24 ++++++
 virt/kvm/introspection/kvmi_int.h             |  3 +
 virt/kvm/introspection/kvmi_msg.c             | 15 ++++
 7 files changed, 153 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 0000099e8038..7d6d85aa191a 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -608,6 +608,35 @@ registers, the special registers and the requested set of MSRs.
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
index 8e8ab9d836fe..fe071a92510c 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -38,6 +38,9 @@ struct kvm_vcpu_introspection {
 	bool waiting_for_reply;
 
 	DECLARE_BITMAP(ev_enable_mask, KVMI_NUM_EVENTS);
+
+	struct kvm_regs delayed_regs;
+	bool have_delayed_regs;
 };
 
 struct kvm_introspection {
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index c354c5e15be1..746f433b8269 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -29,6 +29,7 @@ enum {
 	KVMI_VCPU_PAUSE          = 10,
 	KVMI_VCPU_CONTROL_EVENTS = 11,
 	KVMI_VCPU_GET_REGISTERS  = 12,
+	KVMI_VCPU_SET_REGISTERS  = 13,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 2fb191740cae..18ccc794c6cc 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -832,6 +832,83 @@ static void test_cmd_vcpu_get_registers(struct kvm_vm *vm)
 	DEBUG("get_registers rip 0x%llx\n", regs.rip);
 }
 
+static int __cmd_set_registers(struct kvm_vm *vm,
+			       struct kvm_regs *regs)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvm_regs regs;
+	} req = {};
+	__u16 vcpu_index = 0;
+
+	req.vcpu_hdr.vcpu = vcpu_index;
+
+	memcpy(&req.regs, regs, sizeof(req.regs));
+
+	return do_command(KVMI_VCPU_SET_REGISTERS,
+			  &req.hdr, sizeof(req), NULL, 0);
+}
+
+static int cmd_set_registers(struct kvm_vm *vm,
+			     struct kvm_regs *regs)
+{
+	struct vcpu_worker_data data = {.vm = vm, .vcpu_id = VCPU_ID};
+	pthread_t vcpu_thread;
+	int r;
+
+	vcpu_thread = start_vcpu_worker(&data);
+
+	r = __cmd_set_registers(vm, regs);
+
+	stop_vcpu_worker(vcpu_thread, &data);
+
+	return r;
+}
+
+static void __set_registers(struct kvm_vm *vm,
+			    struct kvm_regs *regs)
+{
+	int r;
+
+	r = __cmd_set_registers(vm, regs);
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
+	int r;
+
+	get_vcpu_registers(vm, &regs);
+
+	r = cmd_set_registers(vm, &regs);
+	TEST_ASSERT(r == -KVM_EOPNOTSUPP,
+		"KVMI_VCPU_SET_REGISTERS didn't failed with KVM_EOPNOTSUPP, error %d(%s)\n",
+		-r, kvm_strerror(-r));
+
+	pause_vcpu(vm);
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
@@ -850,6 +927,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_pause(vm);
 	test_cmd_vcpu_control_events(vm);
 	test_cmd_vcpu_get_registers(vm);
+	test_cmd_vcpu_set_registers(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 8d292a4be270..d1898bf8da1a 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -815,3 +815,27 @@ int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait)
 
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
index 3e471e3a755d..0f44893bcbdc 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -39,6 +39,7 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
 		 void *ctx, void (*free_fct)(void *ctx));
 void kvmi_run_jobs(struct kvm_vcpu *vcpu);
+void kvmi_post_reply(struct kvm_vcpu *vcpu);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
 int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
@@ -51,6 +52,8 @@ int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, size_t size,
 int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, size_t size,
 			    const void *buf);
 int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
+int kvmi_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
+				const struct kvm_regs *regs);
 
 /* arch */
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index e30e1ad5e443..38e1acdf744f 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -32,6 +32,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VCPU_GET_INFO]       = "KVMI_VCPU_GET_INFO",
 	[KVMI_VCPU_GET_REGISTERS]  = "KVMI_VCPU_GET_REGISTERS",
 	[KVMI_VCPU_PAUSE]          = "KVMI_VCPU_PAUSE",
+	[KVMI_VCPU_SET_REGISTERS]  = "KVMI_VCPU_SET_REGISTERS",
 };
 
 static const char *id2str(u16 id)
@@ -486,6 +487,18 @@ static int handle_get_registers(const struct kvmi_vcpu_cmd_job *job,
 	return err;
 }
 
+static int handle_set_registers(const struct kvmi_vcpu_cmd_job *job,
+				const struct kvmi_msg_hdr *msg,
+				const void *_req)
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
  * These commands are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -498,6 +511,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 	[KVMI_VCPU_CONTROL_EVENTS] = handle_vcpu_control_events,
 	[KVMI_VCPU_GET_INFO]       = handle_get_vcpu_info,
 	[KVMI_VCPU_GET_REGISTERS]  = handle_get_registers,
+	[KVMI_VCPU_SET_REGISTERS]  = handle_set_registers,
 };
 
 static bool is_vcpu_command(u16 id)
@@ -787,6 +801,7 @@ static int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
 	if (err)
 		goto out;
 
+	kvmi_post_reply(vcpu);
 	*action = vcpui->reply.action;
 
 out:
