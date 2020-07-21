Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0681F228AFB
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731199AbgGUVP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:15:57 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37762 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731184AbgGUVPz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:15:55 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E1F64305D4F0;
        Wed, 22 Jul 2020 00:09:27 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id B4F0A304FA14;
        Wed, 22 Jul 2020 00:09:27 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 56/84] KVM: introspection: add KVMI_VCPU_GET_REGISTERS
Date:   Wed, 22 Jul 2020 00:08:54 +0300
Message-Id: <20200721210922.7646-57-alazar@bitdefender.com>
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

This command is used to get kvm_regs and kvm_sregs structures,
plus a list of struct kvm_msrs from a specific vCPU.

While the kvm_regs and kvm_sregs structures are included with every
event, this command allows reading any MSR and can be used as a quick
way to read the state of any vCPU.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 44 +++++++++
 arch/x86/include/uapi/asm/kvmi.h              | 15 +++
 arch/x86/kvm/kvmi.c                           | 93 +++++++++++++++++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 75 +++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  7 ++
 virt/kvm/introspection/kvmi_msg.c             | 20 ++++
 7 files changed, 255 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 4393ce89b2fa..f9095e1a9417 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -568,6 +568,50 @@ the *KVMI_VM_CONTROL_EVENTS* command.
 * -KVM_EPERM - the access is disallowed (use *KVMI_VM_CHECK_EVENT* first)
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+11. KVMI_VCPU_GET_REGISTERS
+---------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_get_registers {
+		__u16 nmsrs;
+		__u16 padding1;
+		__u32 padding2;
+		__u32 msrs_idx[0];
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	struct kvmi_vcpu_get_registers_reply {
+		__u32 mode;
+		__u32 padding;
+		struct kvm_regs regs;
+		struct kvm_sregs sregs;
+		struct kvm_msrs msrs;
+	};
+
+For the given vCPU and the ``nmsrs`` sized array of MSRs registers,
+returns the current vCPU mode (in bytes: 2, 4 or 8), the general purpose
+registers, the special registers and the requested set of MSRs.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - one of the indicated MSRs is invalid
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EINVAL - the reply size is larger than KVMI_MSG_SIZE
+                (too many MSRs)
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_ENOMEM - there is not enough memory to allocate the reply
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 89adf84cefe4..f14674c3c109 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -30,4 +30,19 @@ struct kvmi_vcpu_get_info_reply {
 	__u64 tsc_speed;
 };
 
+struct kvmi_vcpu_get_registers {
+	__u16 nmsrs;
+	__u16 padding1;
+	__u32 padding2;
+	__u32 msrs_idx[0];
+};
+
+struct kvmi_vcpu_get_registers_reply {
+	__u32 mode;
+	__u32 padding;
+	struct kvm_regs regs;
+	struct kvm_sregs sregs;
+	struct kvm_msrs msrs;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index ce7e2d5f2ab4..4fd7a3c17ef5 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -98,3 +98,96 @@ int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
 
 	return 0;
 }
+
+int kvmi_arch_check_get_registers_req(const struct kvmi_msg_hdr *msg,
+				const struct kvmi_vcpu_get_registers *req)
+{
+	size_t req_size;
+
+	if (check_add_overflow(sizeof(struct kvmi_vcpu_hdr),
+				struct_size(req, msrs_idx, req->nmsrs),
+				&req_size))
+		return -1;
+
+	if (msg->size < req_size)
+		return -1;
+
+	return 0;
+}
+
+static int kvmi_get_registers(struct kvm_vcpu *vcpu, u32 *mode,
+			      struct kvm_regs *regs,
+			      struct kvm_sregs *sregs,
+			      struct kvm_msrs *msrs)
+{
+	struct kvm_msr_entry *msr = msrs->entries;
+	struct kvm_msr_entry *end = msrs->entries + msrs->nmsrs;
+	struct msr_data m = {.host_initiated = true};
+	int err = 0;
+
+	kvm_arch_vcpu_get_regs(vcpu, regs);
+	kvm_arch_vcpu_get_sregs(vcpu, sregs);
+	*mode = kvmi_vcpu_mode(vcpu, sregs);
+
+	for (; msr < end && !err; msr++) {
+		m.index = msr->index;
+
+		err = kvm_x86_ops.get_msr(vcpu, &m);
+
+		if (!err)
+			msr->data = m.data;
+	}
+
+	return err ? -KVM_EINVAL : 0;
+}
+
+static bool valid_reply_size(size_t rpl_size)
+{
+	size_t msg_size;
+
+	if (check_add_overflow(sizeof(struct kvmi_error_code),
+				rpl_size, &msg_size))
+		return false;
+
+	if (msg_size > KVMI_MSG_SIZE)
+		return false;
+
+	return true;
+}
+
+int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
+				const struct kvmi_msg_hdr *msg,
+				const struct kvmi_vcpu_get_registers *req,
+				struct kvmi_vcpu_get_registers_reply **dest,
+				size_t *dest_size)
+{
+	struct kvmi_vcpu_get_registers_reply *rpl;
+	size_t rpl_size;
+	int err;
+	u16 k;
+
+	if (req->padding1 || req->padding2)
+		return -KVM_EINVAL;
+
+	rpl_size = struct_size(rpl, msrs.entries, req->nmsrs);
+
+	if (!valid_reply_size(rpl_size))
+		return -KVM_EINVAL;
+
+	rpl = kvmi_msg_alloc();
+	if (!rpl)
+		return -KVM_ENOMEM;
+
+	rpl->msrs.nmsrs = req->nmsrs;
+
+	for (k = 0; k < req->nmsrs; k++)
+		rpl->msrs.entries[k].index = req->msrs_idx[k];
+
+	err = kvmi_get_registers(vcpu, &rpl->mode, &rpl->regs,
+				 &rpl->sregs, &rpl->msrs);
+
+	*dest = rpl;
+	*dest_size = rpl_size;
+
+	return err;
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 9ebf17fa9564..39ff54b4b661 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -28,6 +28,7 @@ enum {
 	KVMI_VCPU_GET_INFO       = 8,
 	KVMI_VCPU_PAUSE          = 9,
 	KVMI_VCPU_CONTROL_EVENTS = 10,
+	KVMI_VCPU_GET_REGISTERS  = 11,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index da6a06fa0baa..73aafc5d959a 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -887,6 +887,80 @@ static void test_cmd_vcpu_control_events(struct kvm_vm *vm)
 
 }
 
+static void cmd_vcpu_get_registers(struct kvm_vm *vm, struct kvm_regs *regs)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_get_registers cmd;
+	} req = {};
+	struct kvmi_vcpu_get_registers_reply rpl;
+
+	test_vcpu0_command(vm, KVMI_VCPU_GET_REGISTERS, &req.hdr, sizeof(req),
+			   &rpl, sizeof(rpl));
+
+	memcpy(regs, &rpl.regs, sizeof(*regs));
+}
+
+static void test_invalid_cmd_vcpu_get_registers(struct kvm_vm *vm,
+						struct kvmi_msg_hdr *req,
+						size_t req_size, void *rpl,
+						size_t rpl_size)
+{
+	int r;
+
+	r = do_vcpu0_command(vm, KVMI_VCPU_GET_REGISTERS, req, req_size,
+			     rpl, rpl_size);
+	TEST_ASSERT(r == -KVM_EINVAL,
+		"KVMI_VCPU_GET_REGISTERS didn't failed with -KVM_EINVAL, error %d (%s)\n",
+		-r, kvm_strerror(-r));
+}
+
+static void test_invalid_vcpu_get_registers(struct kvm_vm *vm)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_get_registers cmd;
+		__u32 msrs_idx[1];
+	} req = {};
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_get_registers cmd;
+	} *req_big;
+	struct kvmi_vcpu_get_registers_reply rpl;
+
+	req.cmd.padding1 = 1;
+	req.cmd.padding2 = 1;
+	test_invalid_cmd_vcpu_get_registers(vm, &req.hdr, sizeof(req),
+					    &rpl, sizeof(rpl));
+
+	req.cmd.padding1 = 0;
+	req.cmd.padding2 = 0;
+	req.cmd.nmsrs = 1;
+	req.cmd.msrs_idx[0] = 0xffffffff;
+	test_invalid_cmd_vcpu_get_registers(vm, &req.hdr, sizeof(req),
+					    &rpl, sizeof(rpl));
+
+	req_big = calloc(1, KVMI_MSG_SIZE);
+	req_big->cmd.nmsrs = (KVMI_MSG_SIZE - sizeof(*req_big)) / sizeof(__u32);
+	test_invalid_cmd_vcpu_get_registers(vm, &req.hdr, sizeof(req),
+					    &rpl, sizeof(rpl));
+	free(req_big);
+}
+
+static void test_cmd_vcpu_get_registers(struct kvm_vm *vm)
+{
+	struct kvm_regs regs = {};
+
+	cmd_vcpu_get_registers(vm, &regs);
+
+	pr_info("get_registers rip 0x%llx\n", regs.rip);
+
+	test_invalid_vcpu_get_registers(vm);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -904,6 +978,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_get_info(vm);
 	test_pause(vm);
 	test_cmd_vcpu_control_events(vm);
+	test_cmd_vcpu_get_registers(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 57a62ebadd94..740eea3a9531 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -57,5 +57,12 @@ int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_get_info_reply *rpl);
 void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
+int kvmi_arch_check_get_registers_req(const struct kvmi_msg_hdr *msg,
+				const struct kvmi_vcpu_get_registers *req);
+int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
+				const struct kvmi_msg_hdr *msg,
+				const struct kvmi_vcpu_get_registers *req,
+				struct kvmi_vcpu_get_registers_reply **dest,
+				size_t *dest_size);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 20ef4a44d3a2..6c7a600dd477 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -418,6 +418,25 @@ static int handle_vcpu_control_events(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_get_registers(const struct kvmi_vcpu_msg_job *job,
+				     const struct kvmi_msg_hdr *msg,
+				     const void *req)
+{
+	struct kvmi_vcpu_get_registers_reply *rpl = NULL;
+	size_t rpl_size = 0;
+	int err, ec;
+
+	if (kvmi_arch_check_get_registers_req(msg, req))
+		return -EINVAL;
+
+	ec = kvmi_arch_cmd_vcpu_get_registers(job->vcpu, msg, req,
+					      &rpl, &rpl_size);
+
+	err = kvmi_msg_vcpu_reply(job, msg, ec, rpl, rpl_size);
+	kvmi_msg_free(rpl);
+	return err;
+}
+
 /*
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -429,6 +448,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 	[KVMI_EVENT]               = handle_vcpu_event_reply,
 	[KVMI_VCPU_CONTROL_EVENTS] = handle_vcpu_control_events,
 	[KVMI_VCPU_GET_INFO]       = handle_vcpu_get_info,
+	[KVMI_VCPU_GET_REGISTERS]  = handle_vcpu_get_registers,
 };
 
 static bool is_vcpu_command(u16 id)
