Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD72A155DA6
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbgBGSRm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:42 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40708 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727564AbgBGSQw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:52 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 08A7E305D354;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id EAE47305206C;
        Fri,  7 Feb 2020 20:16:40 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 54/78] KVM: introspection: add KVMI_VCPU_GET_REGISTERS
Date:   Fri,  7 Feb 2020 20:16:12 +0200
Message-Id: <20200207181636.1065-55-alazar@bitdefender.com>
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

This command is used to get kvm_regs and kvm_sregs structures,
plus the list of struct kvm_msrs.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 42 +++++++++++
 arch/x86/include/uapi/asm/kvmi.h              | 15 ++++
 arch/x86/kvm/kvmi.c                           | 70 +++++++++++++++++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 26 +++++++
 virt/kvm/introspection/kvmi_int.h             |  6 ++
 virt/kvm/introspection/kvmi_msg.c             | 18 +++++
 7 files changed, 178 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index c48abc8f5c97..5c366bcd3112 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -547,6 +547,48 @@ by the *KVMI_VM_CONTROL_EVENTS* command.
 * -KVM_EPERM - the access is restricted by the host
 * -KVM_EOPNOTSUPP - one the events can't be intercepted in the current setup
 
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
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_ENOMEM - not enough memory to allocate the reply
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
index 842d6abebb41..67cf2d19ba0f 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -70,3 +70,73 @@ int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
 
 	return 0;
 }
+
+static void *
+alloc_get_registers_reply(const struct kvmi_msg_hdr *msg,
+			  const struct kvmi_vcpu_get_registers *req,
+			  size_t *rpl_size)
+{
+	struct kvmi_vcpu_get_registers_reply *rpl;
+	u16 k, n = req->nmsrs;
+
+	*rpl_size = struct_size(rpl, msrs.entries, n);
+	rpl = kvmi_msg_alloc_check(*rpl_size);
+	if (rpl) {
+		rpl->msrs.nmsrs = n;
+
+		for (k = 0; k < n; k++)
+			rpl->msrs.entries[k].index = req->msrs_idx[k];
+	}
+
+	return rpl;
+}
+
+static int kvmi_get_registers(struct kvm_vcpu *vcpu, u32 *mode,
+			      struct kvm_regs *regs,
+			      struct kvm_sregs *sregs,
+			      struct kvm_msrs *msrs)
+{
+	struct kvm_msr_entry *msr = msrs->entries;
+	struct kvm_msr_entry *end = msrs->entries + msrs->nmsrs;
+	int err = 0;
+
+	kvm_arch_vcpu_get_regs(vcpu, regs);
+	kvm_arch_vcpu_get_sregs(vcpu, sregs);
+	*mode = kvmi_vcpu_mode(vcpu, sregs);
+
+	for (; msr < end && !err; msr++)
+		err = __kvm_get_msr(vcpu, msr->index, &msr->data, true);
+
+	return err ? -KVM_EINVAL : 0;
+}
+
+int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
+				const struct kvmi_msg_hdr *msg,
+				const struct kvmi_vcpu_get_registers *req,
+				struct kvmi_vcpu_get_registers_reply **dest,
+				size_t *dest_size)
+{
+	struct kvmi_vcpu_get_registers_reply *rpl;
+	size_t rpl_size = 0;
+	int err;
+
+	if (req->padding1 || req->padding2)
+		return -KVM_EINVAL;
+
+	if (msg->size < sizeof(struct kvmi_vcpu_hdr)
+			+ struct_size(req, msrs_idx, req->nmsrs))
+		return -KVM_EINVAL;
+
+	rpl = alloc_get_registers_reply(msg, req, &rpl_size);
+	if (!rpl)
+		return -KVM_ENOMEM;
+
+	err = kvmi_get_registers(vcpu, &rpl->mode, &rpl->regs,
+				 &rpl->sregs, &rpl->msrs);
+
+	*dest = rpl;
+	*dest_size = rpl_size;
+
+	return err;
+
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 745503fb7378..bdb5f977c240 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -29,6 +29,7 @@ enum {
 	KVMI_VCPU_GET_INFO       = 9,
 	KVMI_VCPU_PAUSE          = 10,
 	KVMI_VCPU_CONTROL_EVENTS = 11,
+	KVMI_VCPU_GET_REGISTERS  = 12,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 830b64cae20b..5d76d49bc277 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -803,6 +803,31 @@ static void test_cmd_vcpu_control_events(struct kvm_vm *vm)
 	test_invalid_vcpu_event(vm, invalid_id);
 }
 
+static void get_vcpu_registers(struct kvm_vm *vm,
+			       struct kvm_regs *regs)
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
+static void test_cmd_vcpu_get_registers(struct kvm_vm *vm)
+{
+	struct kvm_regs regs = {};
+
+	get_vcpu_registers(vm, &regs);
+
+	DEBUG("get_registers rip 0x%llx\n", regs.rip);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -819,6 +844,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_get_vcpu_info(vm);
 	test_pause(vm);
 	test_cmd_vcpu_control_events(vm);
+	test_cmd_vcpu_get_registers(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index fe59696b0826..5c9ba4b1107e 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -38,6 +38,7 @@
 			| BIT(KVMI_VCPU_GET_INFO) \
 			| BIT(KVMI_VCPU_PAUSE) \
 			| BIT(KVMI_VCPU_CONTROL_EVENTS) \
+			| BIT(KVMI_VCPU_GET_REGISTERS) \
 		)
 
 #define KVMI(kvm) ((struct kvm_introspection *)((kvm)->kvmi))
@@ -82,5 +83,10 @@ int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
 int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
 				struct kvmi_vcpu_get_info_reply *rpl);
 void kvmi_arch_setup_event(struct kvm_vcpu *vcpu, struct kvmi_event *ev);
+int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
+				const struct kvmi_msg_hdr *msg,
+				const struct kvmi_vcpu_get_registers *req,
+				struct kvmi_vcpu_get_registers_reply **dest,
+				size_t *dest_size);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 1995a63f4e99..4a7c831183bb 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -27,6 +27,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VM_WRITE_PHYSICAL]   = "KVMI_VM_WRITE_PHYSICAL",
 	[KVMI_VCPU_CONTROL_EVENTS] = "KVMI_VCPU_CONTROL_EVENTS",
 	[KVMI_VCPU_GET_INFO]       = "KVMI_VCPU_GET_INFO",
+	[KVMI_VCPU_GET_REGISTERS]  = "KVMI_VCPU_GET_REGISTERS",
 	[KVMI_VCPU_PAUSE]          = "KVMI_VCPU_PAUSE",
 };
 
@@ -434,6 +435,22 @@ static int handle_vcpu_control_events(const struct kvmi_vcpu_cmd_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_get_registers(const struct kvmi_vcpu_cmd_job *job,
+				const struct kvmi_msg_hdr *msg,
+				const void *req)
+{
+	struct kvmi_vcpu_get_registers_reply *rpl = NULL;
+	size_t rpl_size = 0;
+	int err, ec;
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
  * These commands are executed on the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -445,6 +462,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 	[KVMI_EVENT_REPLY]         = handle_event_reply,
 	[KVMI_VCPU_CONTROL_EVENTS] = handle_vcpu_control_events,
 	[KVMI_VCPU_GET_INFO]       = handle_get_vcpu_info,
+	[KVMI_VCPU_GET_REGISTERS]  = handle_get_registers,
 };
 
 static void kvmi_job_vcpu_cmd(struct kvm_vcpu *vcpu, void *ctx)
