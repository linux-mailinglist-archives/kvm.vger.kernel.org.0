Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79255229C92
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbgGVQBr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:47 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38028 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729195AbgGVQBm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:42 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 80B85305D767;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 75D9B305FFA3;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 16/34] KVM: introspection: add KVMI_VCPU_CONTROL_EPT_VIEW
Date:   Wed, 22 Jul 2020 19:01:03 +0300
Message-Id: <20200722160121.9601-17-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

This will be used by the introspection tool to control the EPT views to
which the guest is allowed to switch.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               |  37 ++++++
 arch/x86/include/uapi/asm/kvmi.h              |   7 ++
 arch/x86/kvm/kvmi.c                           |   9 ++
 include/uapi/linux/kvmi.h                     |   1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 118 ++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |   2 +
 virt/kvm/introspection/kvmi_msg.c             |  19 +++
 7 files changed, 193 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 02f03c62adef..f4c60aba9b53 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -1190,6 +1190,43 @@ EPTP switching mechanism (see **KVMI_GET_VERSION**).
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_EOPNOTSUPP - an EPT view was selected but the hardware doesn't support it
 
+28. KVMI_VCPU_CONTROL_EPT_VIEW
+------------------------------
+
+:Architecture: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_control_ept_view {
+		__u16 view;
+		__u8  visible;
+		__u8  padding1;
+		__u32 padding2;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+
+Controls the capability of the guest to successfully change EPT views
+through VMFUNC instruction without triggering a vm-exit. If ``visible``
+is true, the guest will be capable to change EPT views through VMFUNC(0,
+``view``). If ``visible`` is false, VMFUNC(0, ``view``) triggers a
+vm-exit, a #UD exception is injected to guest and the guest application
+is terminated.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EINVAL - padding is not zero
+* -KVM_EINVAL - the selected EPT view is not valid
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index f7a080d5e227..fc35da900778 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -166,4 +166,11 @@ struct kvmi_vcpu_set_ept_view {
 	__u32 padding2;
 };
 
+struct kvmi_vcpu_control_ept_view {
+	__u16 view;
+	__u8  visible;
+	__u8  padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 99ea8ef70be2..06357b8ab54a 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1432,3 +1432,12 @@ int kvmi_arch_cmd_set_ept_view(struct kvm_vcpu *vcpu, u16 view)
 
 	return kvm_x86_ops.set_ept_view(vcpu, view);
 }
+
+int kvmi_arch_cmd_control_ept_view(struct kvm_vcpu *vcpu, u16 view,
+				   bool visible)
+{
+	if (!kvm_x86_ops.control_ept_view)
+		return -KVM_EINVAL;
+
+	return kvm_x86_ops.control_ept_view(vcpu, view, visible);
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 8204661d944d..a72c536a2c80 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -51,6 +51,7 @@ enum {
 	KVMI_VCPU_TRANSLATE_GVA      = 25,
 	KVMI_VCPU_GET_EPT_VIEW       = 26,
 	KVMI_VCPU_SET_EPT_VIEW       = 27,
+	KVMI_VCPU_CONTROL_EPT_VIEW   = 28,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index c6f7d10563db..d808cb61463d 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -56,6 +56,7 @@ struct vcpu_worker_data {
 	bool stop;
 	bool shutdown;
 	bool restart_on_shutdown;
+	bool run_guest_once;
 };
 
 static struct kvmi_features features;
@@ -72,6 +73,7 @@ enum {
 	GUEST_TEST_HYPERCALL,
 	GUEST_TEST_MSR,
 	GUEST_TEST_PF,
+	GUEST_TEST_VMFUNC,
 	GUEST_TEST_XSETBV,
 };
 
@@ -130,6 +132,13 @@ static void guest_pf_test(void)
 	*((uint8_t *)test_gva) = READ_ONCE(test_write_pattern);
 }
 
+static void guest_vmfunc_test(void)
+{
+	asm volatile("mov $0, %rax");
+	asm volatile("mov $1, %rcx");
+	asm volatile(".byte 0x0f,0x01,0xd4");
+}
+
 /* from fpu/internal.h */
 static u64 xgetbv(u32 index)
 {
@@ -193,6 +202,9 @@ static void guest_code(void)
 		case GUEST_TEST_PF:
 			guest_pf_test();
 			break;
+		case GUEST_TEST_VMFUNC:
+			guest_vmfunc_test();
+			break;
 		case GUEST_TEST_XSETBV:
 			guest_xsetbv_test();
 			break;
@@ -777,6 +789,7 @@ static void test_memory_access(struct kvm_vm *vm)
 static void *vcpu_worker(void *data)
 {
 	struct vcpu_worker_data *ctx = data;
+	bool first_run = false;
 	struct kvm_run *run;
 
 	run = vcpu_state(ctx->vm, ctx->vcpu_id);
@@ -805,6 +818,13 @@ static void *vcpu_worker(void *data)
 		if (HOST_SEND_TEST(uc)) {
 			test_id = READ_ONCE(ctx->test_id);
 			sync_global_to_guest(ctx->vm, test_id);
+			if (run->exit_reason == KVM_EXIT_IO &&
+			    ctx->run_guest_once) {
+				if (!first_run)
+					first_run = true;
+				else
+					break;
+			}
 		}
 	}
 
@@ -2140,6 +2160,103 @@ static void test_cmd_vcpu_set_ept_view(struct kvm_vm *vm)
 	set_ept_view(vm, old_view);
 }
 
+static void check_expected_view(struct kvm_vm *vm,
+				__u16 check_view)
+{
+	__u16 found_view = get_ept_view(vm);
+
+	TEST_ASSERT(check_view == found_view,
+			"Unexpected EPT view, found ept view (%u), expected view (%u)\n",
+			found_view, check_view);
+}
+
+static void test_guest_switch_to_invisible_view(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {
+		.vm = vm,
+		.vcpu_id = VCPU_ID,
+		.shutdown = true,
+		.test_id = GUEST_TEST_VMFUNC,
+	};
+	pthread_t vcpu_thread;
+	struct kvm_regs regs;
+	__u16 view = 0;
+
+	check_expected_view(vm, view);
+
+	vcpu_thread = start_vcpu_worker(&data);
+	wait_vcpu_worker(vcpu_thread);
+
+	/*
+	 * Move to the next instruction, so the guest would not
+	 * re-execute VMFUNC again when vcpu_run() is called.
+	 */
+	vcpu_regs_get(vm, VCPU_ID, &regs);
+	regs.rip += 3;
+	vcpu_regs_set(vm, VCPU_ID, &regs);
+
+	check_expected_view(vm, view);
+}
+
+static void test_control_ept_view(struct kvm_vm *vm, __u16 view, bool visible)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_control_ept_view cmd;
+	} req = {};
+
+	req.cmd.view = view;
+	req.cmd.visible = visible;
+
+	test_vcpu0_command(vm, KVMI_VCPU_CONTROL_EPT_VIEW,
+			   &req.hdr, sizeof(req), NULL, 0);
+}
+
+static void enable_ept_view_visibility(struct kvm_vm *vm, __u16 view)
+{
+	test_control_ept_view(vm, view, true);
+}
+
+static void disable_ept_view_visibility(struct kvm_vm *vm, __u16 view)
+{
+	test_control_ept_view(vm, view, false);
+}
+
+static void test_guest_switch_to_visible_view(struct kvm_vm *vm)
+{
+	struct vcpu_worker_data data = {
+		.vm = vm,
+		.vcpu_id = VCPU_ID,
+		.run_guest_once = true,
+		.test_id = GUEST_TEST_VMFUNC,
+	};
+	pthread_t vcpu_thread;
+	__u16 old_view = 0, new_view = 1;
+
+	enable_ept_view_visibility(vm, new_view);
+
+	vcpu_thread = start_vcpu_worker(&data);
+	wait_vcpu_worker(vcpu_thread);
+
+	check_expected_view(vm, new_view);
+
+	disable_ept_view_visibility(vm, new_view);
+
+	set_ept_view(vm, old_view);
+}
+
+static void test_cmd_vcpu_vmfunc(struct kvm_vm *vm)
+{
+	if (!features.vmfunc) {
+		print_skip("EPT views not supported");
+		return;
+	}
+
+	test_guest_switch_to_invisible_view(vm);
+	test_guest_switch_to_visible_view(vm);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -2178,6 +2295,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_translate_gva(vm);
 	test_cmd_vcpu_get_ept_view(vm);
 	test_cmd_vcpu_set_ept_view(vm);
+	test_cmd_vcpu_vmfunc(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index f093aad2f804..d78116442ddd 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -149,5 +149,7 @@ bool kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu);
 gpa_t kvmi_arch_cmd_translate_gva(struct kvm_vcpu *vcpu, gva_t gva);
 u16 kvmi_arch_cmd_get_ept_view(struct kvm_vcpu *vcpu);
 int kvmi_arch_cmd_set_ept_view(struct kvm_vcpu *vcpu, u16 view);
+int kvmi_arch_cmd_control_ept_view(struct kvm_vcpu *vcpu, u16 view,
+				   bool visible);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 73a7179f7031..696857f6d008 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -693,6 +693,24 @@ static int handle_vcpu_set_ept_view(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_control_ept_view(const struct kvmi_vcpu_msg_job *job,
+					const struct kvmi_msg_hdr *msg,
+					const void *_req)
+{
+	const struct kvmi_vcpu_control_ept_view *req = _req;
+	int ec;
+
+	if (req->padding1 || req->padding2)
+		ec = -KVM_EINVAL;
+	else if (!is_valid_view(req->view))
+		ec = -KVM_EINVAL;
+	else
+		ec = kvmi_arch_cmd_control_ept_view(job->vcpu, req->view,
+						    req->visible);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 /*
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -703,6 +721,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
 	[KVMI_EVENT]                   = handle_vcpu_event_reply,
 	[KVMI_VCPU_CONTROL_CR]         = handle_vcpu_control_cr,
+	[KVMI_VCPU_CONTROL_EPT_VIEW]   = handle_vcpu_control_ept_view,
 	[KVMI_VCPU_CONTROL_EVENTS]     = handle_vcpu_control_events,
 	[KVMI_VCPU_CONTROL_MSR]        = handle_vcpu_control_msr,
 	[KVMI_VCPU_CONTROL_SINGLESTEP] = handle_vcpu_control_singlestep,
