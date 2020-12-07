Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5E12D1B20
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727362AbgLGUsd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:33 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42578 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727330AbgLGUsc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:32 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 3BACE305D474;
        Mon,  7 Dec 2020 22:46:21 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 0D6E63072785;
        Mon,  7 Dec 2020 22:46:21 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 53/81] KVM: introspection: add KVMI_VCPU_GET_REGISTERS
Date:   Mon,  7 Dec 2020 22:45:54 +0200
Message-Id: <20201207204622.15258-54-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This command is used to get kvm_regs and kvm_sregs structures,
plus a list of struct kvm_msrs from a specific vCPU.

While the kvm_regs and kvm_sregs structures are included with every
event, this command allows reading any MSR.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 44 ++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              | 15 ++++
 arch/x86/kvm/kvmi.c                           | 25 +++++++
 arch/x86/kvm/kvmi.h                           |  9 +++
 arch/x86/kvm/kvmi_msg.c                       | 72 ++++++++++++++++++-
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 59 +++++++++++++++
 7 files changed, 224 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kvm/kvmi.h

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index a502cf9baead..dbaedbee9dee 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -557,6 +557,50 @@ the *KVMI_VM_CONTROL_EVENTS* command.
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
+* -KVM_EINVAL - the reply size is larger than
+                kvmi_get_version_reply.max_msg_size (too many MSRs)
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_ENOMEM - there is not enough memory to allocate the reply
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 9d9df09d381a..11835bf9bdc6 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -30,4 +30,19 @@ struct kvmi_vcpu_event_arch {
 	} msrs;
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
index 383b19dcf054..fa9b20277dad 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -93,3 +93,28 @@ void kvmi_arch_setup_vcpu_event(struct kvm_vcpu *vcpu,
 	ev->arch.mode = kvmi_vcpu_mode(vcpu, &event->sregs);
 	kvmi_get_msrs(vcpu, event);
 }
+
+int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
+				const struct kvmi_vcpu_get_registers *req,
+				struct kvmi_vcpu_get_registers_reply *rpl)
+{
+	struct msr_data m = {.host_initiated = true};
+	int k, err = 0;
+
+	kvm_arch_vcpu_get_regs(vcpu, &rpl->regs);
+	kvm_arch_vcpu_get_sregs(vcpu, &rpl->sregs);
+	rpl->mode = kvmi_vcpu_mode(vcpu, &rpl->sregs);
+	rpl->msrs.nmsrs = req->nmsrs;
+
+	for (k = 0; k < req->nmsrs && !err; k++) {
+		m.index = req->msrs_idx[k];
+
+		err = kvm_x86_ops.get_msr(vcpu, &m);
+		if (!err) {
+			rpl->msrs.entries[k].index = m.index;
+			rpl->msrs.entries[k].data = m.data;
+		}
+	}
+
+	return err ? -KVM_EINVAL : 0;
+}
diff --git a/arch/x86/kvm/kvmi.h b/arch/x86/kvm/kvmi.h
new file mode 100644
index 000000000000..7aab4aaabcda
--- /dev/null
+++ b/arch/x86/kvm/kvmi.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef ARCH_X86_KVM_KVMI_H
+#define ARCH_X86_KVM_KVMI_H
+
+int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
+				const struct kvmi_vcpu_get_registers *req,
+				struct kvmi_vcpu_get_registers_reply *rpl);
+
+#endif
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index 77552bf50984..4288a91937f6 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -7,6 +7,7 @@
  */
 
 #include "../../../virt/kvm/introspection/kvmi_int.h"
+#include "kvmi.h"
 
 static int handle_vcpu_get_info(const struct kvmi_vcpu_msg_job *job,
 				const struct kvmi_msg_hdr *msg,
@@ -21,8 +22,77 @@ static int handle_vcpu_get_info(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, 0, &rpl, sizeof(rpl));
 }
 
+static bool is_valid_get_regs_request(const struct kvmi_msg_hdr *msg,
+				const struct kvmi_vcpu_get_registers *req)
+{
+	size_t req_size, msg_size;
+
+	if (req->padding1 || req->padding2)
+		return false;
+
+	req_size = struct_size(req, msrs_idx, req->nmsrs);
+
+	if (check_add_overflow(sizeof(struct kvmi_vcpu_hdr),
+			       req_size, &msg_size))
+		return false;
+
+	if (msg_size > msg->size)
+		return false;
+
+	return true;
+}
+
+static bool is_valid_get_regs_reply(const struct kvmi_vcpu_get_registers *req,
+				    size_t *ptr_rpl_size)
+{
+	struct kvmi_vcpu_get_registers_reply *rpl;
+	size_t rpl_size, msg_size;
+
+	rpl_size = struct_size(rpl, msrs.entries, req->nmsrs);
+
+	if (check_add_overflow(sizeof(struct kvmi_error_code),
+			       rpl_size, &msg_size))
+		return false;
+
+	if (msg_size > KVMI_MAX_MSG_SIZE)
+		return false;
+
+	*ptr_rpl_size = rpl_size;
+	return true;
+}
+
+static int handle_vcpu_get_registers(const struct kvmi_vcpu_msg_job *job,
+				     const struct kvmi_msg_hdr *msg,
+				     const void *req)
+{
+	struct kvmi_vcpu_get_registers_reply *rpl = NULL;
+	size_t rpl_size = 0;
+	int err, ec;
+
+	if (!is_valid_get_regs_request(msg, req) ||
+	    !is_valid_get_regs_reply(req, &rpl_size)) {
+		ec = -KVM_EINVAL;
+		goto reply;
+	}
+
+	rpl = kvmi_msg_alloc();
+	if (!rpl) {
+		ec = -KVM_ENOMEM;
+		goto reply;
+	}
+
+	ec = kvmi_arch_cmd_vcpu_get_registers(job->vcpu, req, rpl);
+
+reply:
+	err = kvmi_msg_vcpu_reply(job, msg, ec, rpl, rpl_size);
+
+	kvmi_msg_free(rpl);
+	return err;
+}
+
 static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
-	[KVMI_VCPU_GET_INFO] = handle_vcpu_get_info,
+	[KVMI_VCPU_GET_INFO]      = handle_vcpu_get_info,
+	[KVMI_VCPU_GET_REGISTERS] = handle_vcpu_get_registers,
 };
 
 kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id)
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index acd00e883dc9..8548ead451c1 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -37,6 +37,7 @@ enum {
 
 	KVMI_VCPU_GET_INFO       = KVMI_VCPU_MESSAGE_ID(1),
 	KVMI_VCPU_CONTROL_EVENTS = KVMI_VCPU_MESSAGE_ID(2),
+	KVMI_VCPU_GET_REGISTERS  = KVMI_VCPU_MESSAGE_ID(3),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 5948f9b79ed0..f91a70ad1013 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -808,6 +808,64 @@ static void test_cmd_vcpu_control_events(struct kvm_vm *vm)
 
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
+			   &rpl, sizeof(rpl), 0);
+
+	memcpy(regs, &rpl.regs, sizeof(*regs));
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
+	struct kvmi_get_version_reply version;
+
+	req.cmd.nmsrs = 1;
+	req.cmd.msrs_idx[0] = 0xffffffff;
+	test_vcpu0_command(vm, KVMI_VCPU_GET_REGISTERS,
+			   &req.hdr, sizeof(req),
+			   &rpl, sizeof(rpl), -KVM_EINVAL);
+
+	cmd_vm_get_version(&version);
+
+	req_big = calloc(1, version.max_msg_size);
+	req_big->cmd.nmsrs = (version.max_msg_size - sizeof(*req_big)) / sizeof(__u32);
+	test_vcpu0_command(vm, KVMI_VCPU_GET_REGISTERS,
+			   &req.hdr, sizeof(req),
+			   &rpl, sizeof(rpl), -KVM_EINVAL);
+	free(req_big);
+}
+
+static void test_cmd_vcpu_get_registers(struct kvm_vm *vm)
+{
+	struct kvm_regs regs = {};
+
+	cmd_vcpu_get_registers(vm, &regs);
+
+	pr_debug("get_registers rip 0x%llx\n", regs.rip);
+
+	test_invalid_vcpu_get_registers(vm);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -825,6 +883,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_get_info(vm);
 	test_pause(vm);
 	test_cmd_vcpu_control_events(vm);
+	test_cmd_vcpu_get_registers(vm);
 
 	unhook_introspection(vm);
 }
