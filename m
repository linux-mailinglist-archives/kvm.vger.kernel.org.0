Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C25E2D1B45
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbgLGUtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:49:31 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42594 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727301AbgLGUsf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:35 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 70C99305D475;
        Mon,  7 Dec 2020 22:46:21 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 429CA3072784;
        Mon,  7 Dec 2020 22:46:21 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Mircea=20C=C3=AErjaliu?= <mcirjaliu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 54/81] KVM: introspection: add KVMI_VCPU_SET_REGISTERS
Date:   Mon,  7 Dec 2020 22:45:55 +0200
Message-Id: <20201207204622.15258-55-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
 arch/x86/include/asm/kvmi_host.h              |  2 +
 arch/x86/kvm/kvmi.c                           | 22 +++++
 arch/x86/kvm/kvmi.h                           |  2 +
 arch/x86/kvm/kvmi_msg.c                       | 21 +++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 83 +++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             |  6 +-
 9 files changed, 165 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index dbaedbee9dee..178832304458 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -601,6 +601,35 @@ registers, the special registers and the requested set of MSRs.
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
 
diff --git a/arch/x86/include/asm/kvmi_host.h b/arch/x86/include/asm/kvmi_host.h
index 05ade3a16b24..cc945151cb36 100644
--- a/arch/x86/include/asm/kvmi_host.h
+++ b/arch/x86/include/asm/kvmi_host.h
@@ -5,6 +5,8 @@
 #include <asm/kvmi.h>
 
 struct kvm_vcpu_arch_introspection {
+	struct kvm_regs delayed_regs;
+	bool have_delayed_regs;
 };
 
 struct kvm_arch_introspection {
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index fa9b20277dad..39638af7757e 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -118,3 +118,25 @@ int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
 
 	return err ? -KVM_EINVAL : 0;
 }
+
+void kvmi_arch_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
+				      const struct kvm_regs *regs)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+	struct kvm_regs *dest = &vcpui->arch.delayed_regs;
+
+	memcpy(dest, regs, sizeof(*dest));
+
+	vcpui->arch.have_delayed_regs = true;
+}
+
+void kvmi_arch_post_reply(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_introspection *vcpui = VCPUI(vcpu);
+
+	if (!vcpui->arch.have_delayed_regs)
+		return;
+
+	kvm_arch_vcpu_set_regs(vcpu, &vcpui->arch.delayed_regs, false);
+	vcpui->arch.have_delayed_regs = false;
+}
diff --git a/arch/x86/kvm/kvmi.h b/arch/x86/kvm/kvmi.h
index 7aab4aaabcda..4eeb0c900083 100644
--- a/arch/x86/kvm/kvmi.h
+++ b/arch/x86/kvm/kvmi.h
@@ -5,5 +5,7 @@
 int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
 				const struct kvmi_vcpu_get_registers *req,
 				struct kvmi_vcpu_get_registers_reply *rpl);
+void kvmi_arch_cmd_vcpu_set_registers(struct kvm_vcpu *vcpu,
+				      const struct kvm_regs *regs);
 
 #endif
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index 4288a91937f6..8ff3aa936ccd 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -90,9 +90,30 @@ static int handle_vcpu_get_registers(const struct kvmi_vcpu_msg_job *job,
 	return err;
 }
 
+static int handle_vcpu_set_registers(const struct kvmi_vcpu_msg_job *job,
+				     const struct kvmi_msg_hdr *msg,
+				     const void *req)
+{
+	const struct kvm_regs *regs = req;
+	size_t cmd_size;
+	int ec = 0;
+
+	cmd_size = sizeof(struct kvmi_vcpu_hdr) + sizeof(*regs);
+
+	if (cmd_size > msg->size)
+		ec = -KVM_EINVAL;
+	else if (!VCPUI(job->vcpu)->waiting_for_reply)
+		ec = -KVM_EOPNOTSUPP;
+	else
+		kvmi_arch_cmd_vcpu_set_registers(job->vcpu, regs);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
 	[KVMI_VCPU_GET_INFO]      = handle_vcpu_get_info,
 	[KVMI_VCPU_GET_REGISTERS] = handle_vcpu_get_registers,
+	[KVMI_VCPU_SET_REGISTERS] = handle_vcpu_set_registers,
 };
 
 kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id)
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 8548ead451c1..4b756d388ad3 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -38,6 +38,7 @@ enum {
 	KVMI_VCPU_GET_INFO       = KVMI_VCPU_MESSAGE_ID(1),
 	KVMI_VCPU_CONTROL_EVENTS = KVMI_VCPU_MESSAGE_ID(2),
 	KVMI_VCPU_GET_REGISTERS  = KVMI_VCPU_MESSAGE_ID(3),
+	KVMI_VCPU_SET_REGISTERS  = KVMI_VCPU_MESSAGE_ID(4),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index f91a70ad1013..311a050c26c1 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -638,6 +638,16 @@ static int do_vcpu_command(struct kvm_vm *vm, int cmd_id,
 	return r;
 }
 
+static int __do_vcpu0_command(int cmd_id, struct kvmi_msg_hdr *req,
+			      size_t req_size, void *rpl, size_t rpl_size)
+{
+	struct kvmi_vcpu_hdr *vcpu_hdr = (struct kvmi_vcpu_hdr *)(req + 1);
+
+	vcpu_hdr->vcpu = 0;
+
+	return do_command(cmd_id, req, req_size, rpl, rpl_size);
+}
+
 static int do_vcpu0_command(struct kvm_vm *vm, int cmd_id,
 			    struct kvmi_msg_hdr *req, size_t req_size,
 			    void *rpl, size_t rpl_size)
@@ -866,6 +876,78 @@ static void test_cmd_vcpu_get_registers(struct kvm_vm *vm)
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
+	wait_vcpu_worker(vcpu_thread);
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
+	__u16 event_id = KVMI_VCPU_EVENT_PAUSE;
+	struct kvmi_msg_hdr hdr;
+	pthread_t vcpu_thread;
+	struct vcpu_event ev;
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
+	receive_vcpu_event(&hdr, &ev, sizeof(ev), event_id);
+
+	__set_registers(vm, &ev.common.arch.regs);
+
+	reply_to_event(&hdr, &ev, KVMI_EVENT_ACTION_CONTINUE,
+			&rpl, sizeof(rpl));
+
+	wait_vcpu_worker(vcpu_thread);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -884,6 +966,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_pause(vm);
 	test_cmd_vcpu_control_events(vm);
 	test_cmd_vcpu_get_registers(vm);
+	test_cmd_vcpu_set_registers(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 8059029cadf4..018764ca1b71 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -70,5 +70,6 @@ void kvmi_arch_init_vcpu_events_mask(unsigned long *supported);
 kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id);
 void kvmi_arch_setup_vcpu_event(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_event *ev);
+void kvmi_arch_post_reply(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 98617917f319..ea8d824b698c 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -722,10 +722,12 @@ int kvmi_send_vcpu_event(struct kvm_vcpu *vcpu, u32 ev_id,
 out:
 	vcpui->waiting_for_reply = false;
 
-	if (err)
+	if (err) {
 		kvmi_sock_shutdown(kvmi);
-	else
+	} else {
+		kvmi_arch_post_reply(vcpu);
 		*action = vcpui->reply.action;
+	}
 
 	return err;
 }
