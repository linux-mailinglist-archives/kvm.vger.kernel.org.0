Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37C9F1978B7
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729171AbgC3KTt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:19:49 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43736 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729026AbgC3KTt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:49 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id EB6D7305FFB1;
        Mon, 30 Mar 2020 13:12:57 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id CF974305B7A1;
        Mon, 30 Mar 2020 13:12:57 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 57/81] KVM: introspection: add KVMI_VCPU_GET_REGISTERS
Date:   Mon, 30 Mar 2020 13:12:44 +0300
Message-Id: <20200330101308.21702-58-alazar@bitdefender.com>
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

This command is used to get kvm_regs and kvm_sregs structures,
plus the list of struct kvm_msrs.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 42 +++++++++
 arch/x86/include/uapi/asm/kvmi.h              | 15 +++
 arch/x86/kvm/kvmi.c                           | 91 +++++++++++++++++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 26 ++++++
 virt/kvm/introspection/kvmi.c                 |  7 ++
 virt/kvm/introspection/kvmi_int.h             |  8 ++
 virt/kvm/introspection/kvmi_msg.c             | 21 +++++
 8 files changed, 211 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index b0eb2649b10c..0000099e8038 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -566,6 +566,48 @@ the *KVMI_VM_CONTROL_EVENTS* command.
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
index 21ff48cfdb89..1ba264c10cff 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -98,3 +98,94 @@ int kvmi_arch_cmd_vcpu_get_info(struct kvm_vcpu *vcpu,
 
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
+	if (msg->size != req_size)
+		return -1;
+
+	return 0;
+}
+
+static void *alloc_get_registers_reply(const struct kvmi_msg_hdr *msg,
+				const struct kvmi_vcpu_get_registers *req,
+				size_t *rpl_size)
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
+	for (; msr < end; msr++) {
+		struct msr_data m = {
+			.index = msr->index,
+			.host_initiated = true
+		};
+		int err = kvm_x86_ops->get_msr(vcpu, &m);
+
+		if (err)
+			break;
+
+		msr->data = m.data;
+	}
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
+	size_t rpl_size;
+	int err;
+
+	if (req->padding1 || req->padding2)
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
index e361d6e6563d..c354c5e15be1 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -28,6 +28,7 @@ enum {
 	KVMI_VCPU_GET_INFO       = 9,
 	KVMI_VCPU_PAUSE          = 10,
 	KVMI_VCPU_CONTROL_EVENTS = 11,
+	KVMI_VCPU_GET_REGISTERS  = 12,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 94378066d69a..2fb191740cae 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -807,6 +807,31 @@ static void test_cmd_vcpu_control_events(struct kvm_vm *vm)
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
 	srandom(time(0));
@@ -824,6 +849,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_get_vcpu_info(vm);
 	test_pause(vm);
 	test_cmd_vcpu_control_events(vm);
+	test_cmd_vcpu_get_registers(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index b6b3efd085c4..8d292a4be270 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -26,6 +26,13 @@ void *kvmi_msg_alloc(void)
 	return kmem_cache_zalloc(msg_cache, GFP_KERNEL);
 }
 
+void *kvmi_msg_alloc_check(size_t size)
+{
+	if (size > KVMI_MSG_SIZE_ALLOC)
+		return NULL;
+	return kvmi_msg_alloc();
+}
+
 void kvmi_msg_free(void *addr)
 {
 	if (addr)
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index e94356516a05..3e471e3a755d 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -33,6 +33,7 @@ u32 kvmi_msg_send_vcpu_pause(struct kvm_vcpu *vcpu);
 
 /* kvmi.c */
 void *kvmi_msg_alloc(void);
+void *kvmi_msg_alloc_check(size_t size);
 void kvmi_msg_free(void *addr);
 int kvmi_add_job(struct kvm_vcpu *vcpu,
 		 void (*fct)(struct kvm_vcpu *vcpu, void *ctx),
@@ -55,5 +56,12 @@ int kvmi_cmd_vcpu_pause(struct kvm_vcpu *vcpu, bool wait);
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
index f819d0a942dc..e30e1ad5e443 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -30,6 +30,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VM_WRITE_PHYSICAL]   = "KVMI_VM_WRITE_PHYSICAL",
 	[KVMI_VCPU_CONTROL_EVENTS] = "KVMI_VCPU_CONTROL_EVENTS",
 	[KVMI_VCPU_GET_INFO]       = "KVMI_VCPU_GET_INFO",
+	[KVMI_VCPU_GET_REGISTERS]  = "KVMI_VCPU_GET_REGISTERS",
 	[KVMI_VCPU_PAUSE]          = "KVMI_VCPU_PAUSE",
 };
 
@@ -466,6 +467,25 @@ static int handle_vcpu_control_events(const struct kvmi_vcpu_cmd_job *job,
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
  * These commands are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -477,6 +497,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 	[KVMI_EVENT]               = handle_event_reply,
 	[KVMI_VCPU_CONTROL_EVENTS] = handle_vcpu_control_events,
 	[KVMI_VCPU_GET_INFO]       = handle_get_vcpu_info,
+	[KVMI_VCPU_GET_REGISTERS]  = handle_get_registers,
 };
 
 static bool is_vcpu_command(u16 id)
