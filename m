Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFA2155DA9
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgBGSRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:46 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40642 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727668AbgBGSQw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:52 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 11998305D355;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 02A3D305206D;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 55/78] KVM: introspection: add KVMI_VCPU_SET_REGISTERS
Date:   Fri,  7 Feb 2020 20:16:13 +0200
Message-Id: <20200207181636.1065-56-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This command is allowed only during a vCPU event (an event has been sent
and the vCPU is waiting for the reply). The registers will be set only
when the reply has been received.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Mircea Cîrjaliu <mcirjaliu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 29 +++++++
 include/linux/kvmi_host.h                     |  3 +
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 82 +++++++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 24 ++++++
 virt/kvm/introspection/kvmi_int.h             |  4 +
 virt/kvm/introspection/kvmi_msg.c             | 15 ++++
 7 files changed, 158 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 5c366bcd3112..ff1fe5ec2e18 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -589,6 +589,35 @@ registers, the special registers and the requested set of MSRs.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - not enough memory to allocate the reply
 
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
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EOPNOTSUPP - the command hasn't been received during an introspection event
+
 Events
 ======
 
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index da621d83cd94..68c76db83973 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -38,6 +38,9 @@ struct kvm_vcpu_introspection {
 	bool waiting_for_reply;
 
 	DECLARE_BITMAP(ev_mask, KVMI_NUM_EVENTS);
+
+	struct kvm_regs delayed_regs;
+	bool have_delayed_regs;
 };
 
 struct kvm_introspection {
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index bdb5f977c240..4d5f6317db03 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -30,6 +30,7 @@ enum {
 	KVMI_VCPU_PAUSE          = 10,
 	KVMI_VCPU_CONTROL_EVENTS = 11,
 	KVMI_VCPU_GET_REGISTERS  = 12,
+	KVMI_VCPU_SET_REGISTERS  = 13,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 5d76d49bc277..6e4490340b36 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -828,6 +828,87 @@ static void test_cmd_vcpu_get_registers(struct kvm_vm *vm)
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
+	enable_vcpu_event(vm, event_id);
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
+
+	disable_vcpu_event(vm, event_id);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -845,6 +926,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_pause(vm);
 	test_cmd_vcpu_control_events(vm);
 	test_cmd_vcpu_get_registers(vm);
+	test_cmd_vcpu_set_registers(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index f4ff9968bd58..8ffbf46bc17d 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -804,3 +804,27 @@ int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait)
 
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
index 5c9ba4b1107e..a736f364f5be 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -39,6 +39,7 @@
 			| BIT(KVMI_VCPU_PAUSE) \
 			| BIT(KVMI_VCPU_CONTROL_EVENTS) \
 			| BIT(KVMI_VCPU_GET_REGISTERS) \
+			| BIT(KVMI_VCPU_SET_REGISTERS) \
 		)
 
 #define KVMI(kvm) ((struct kvm_introspection *)((kvm)->kvmi))
@@ -66,6 +67,7 @@ int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
 		 void *ctx, void (*free_fct)(void *ctx));
 void kvmi_run_jobs(struct kvm_vcpu *vcpu);
+void kvmi_post_reply(struct kvm_vcpu *vcpu);
 int kvmi_cmd_vm_control_events(struct kvm_introspection *kvmi,
 				unsigned int event_id, bool enable);
 int kvmi_cmd_vcpu_control_events(struct kvm_vcpu *vcpu,
@@ -78,6 +80,8 @@ int kvmi_cmd_read_physical(struct kvm *kvm, u64 gpa, u64 size,
 int kvmi_cmd_write_physical(struct kvm *kvm, u64 gpa, u64 size,
 			    const void *buf);
 int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
+int kvmi_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
+				const struct kvm_regs *regs);
 
 /* arch */
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 4a7c831183bb..11e0171076c7 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -29,6 +29,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VCPU_GET_INFO]       = "KVMI_VCPU_GET_INFO",
 	[KVMI_VCPU_GET_REGISTERS]  = "KVMI_VCPU_GET_REGISTERS",
 	[KVMI_VCPU_PAUSE]          = "KVMI_VCPU_PAUSE",
+	[KVMI_VCPU_SET_REGISTERS]  = "KVMI_VCPU_SET_REGISTERS",
 };
 
 static bool is_known_message(u16 id)
@@ -451,6 +452,18 @@ static int handle_get_registers(const struct kvmi_vcpu_cmd_job *job,
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
  * These commands are executed on the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -463,6 +476,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 	[KVMI_VCPU_CONTROL_EVENTS] = handle_vcpu_control_events,
 	[KVMI_VCPU_GET_INFO]       = handle_get_vcpu_info,
 	[KVMI_VCPU_GET_REGISTERS]  = handle_get_registers,
+	[KVMI_VCPU_SET_REGISTERS]  = handle_set_registers,
 };
 
 static void kvmi_job_vcpu_cmd(struct kvm_vcpu *vcpu, void *ctx)
@@ -818,6 +832,7 @@ static int kvmi_send_event(struct kvm_vcpu *vcpu, u32 ev_id,
 	if (err)
 		goto out;
 
+	kvmi_post_reply(vcpu);
 	*action = vcpui->reply.action;
 
 out:
