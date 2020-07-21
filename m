Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF3F228ABF
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731393AbgGUVQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:38 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37986 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731325AbgGUVQQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:16 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id DC7EE305D508;
        Wed, 22 Jul 2020 00:09:31 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id BBF67304FA12;
        Wed, 22 Jul 2020 00:09:31 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 80/84] KVM: introspection: add KVMI_VCPU_CONTROL_SINGLESTEP
Date:   Wed, 22 Jul 2020 00:09:18 +0300
Message-Id: <20200721210922.7646-81-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

The next commit that adds the KVMI_EVENT_SINGLESTEP event will make this
command more useful.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 32 ++++++++++
 arch/x86/kvm/kvmi.c                           | 18 ++++++
 arch/x86/kvm/x86.c                            | 12 +++-
 include/linux/kvmi_host.h                     |  7 +++
 include/uapi/linux/kvmi.h                     |  7 +++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 46 ++++++++++++++
 virt/kvm/introspection/kvmi.c                 | 26 +++++++-
 virt/kvm/introspection/kvmi_int.h             |  2 +
 virt/kvm/introspection/kvmi_msg.c             | 60 +++++++++++++++----
 9 files changed, 193 insertions(+), 17 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 47387f297029..0a07ef101302 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -1049,6 +1049,38 @@ In order to 'forget' an address, all three bits ('rwx') must be set.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - there is not enough memory to add the page tracking structures
 
+24. KVMI_VCPU_CONTROL_SINGLESTEP
+--------------------------------
+
+:Architectures: x86 (vmx)
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_control_singlestep {
+		__u8 enable;
+		__u8 padding[7];
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+
+Enables/disables singlestep for the selected vCPU.
+
+The introspection tool should use *KVMI_GET_VERSION*, to check
+if the hardware supports singlestep (see **KVMI_GET_VERSION**).
+
+:Errors:
+
+* -KVM_EOPNOTSUPP - the hardware doesn't support singlestep
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 672a113b3bf4..18713004152d 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1355,3 +1355,21 @@ void kvmi_arch_features(struct kvmi_features *feat)
 {
 	feat->singlestep = !!kvm_x86_ops.control_singlestep;
 }
+
+bool kvmi_arch_start_singlestep(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_x86_ops.control_singlestep)
+		return false;
+
+	kvm_x86_ops.control_singlestep(vcpu, true);
+	return true;
+}
+
+bool kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_x86_ops.control_singlestep)
+		return false;
+
+	kvm_x86_ops.control_singlestep(vcpu, false);
+	return true;
+}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0add0b0b8f2d..02b74a57ca01 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8515,9 +8515,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		inject_pending_event(vcpu, &req_immediate_exit);
-		if (req_int_win)
-			kvm_x86_ops.enable_irq_window(vcpu);
+		if (!kvmi_vcpu_running_singlestep(vcpu)) {
+			/*
+			 * We cannot inject events during single-stepping.
+			 * Try again later.
+			 */
+			inject_pending_event(vcpu, &req_immediate_exit);
+			if (req_int_win)
+				kvm_x86_ops.enable_irq_window(vcpu);
+		}
 
 		if (kvm_lapic_enabled(vcpu)) {
 			update_cr8_intercept(vcpu);
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index 11eb9b1c3c5e..a641768027cc 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -45,6 +45,10 @@ struct kvm_vcpu_introspection {
 		bool pending;
 		bool send_event;
 	} exception;
+
+	struct {
+		bool loop;
+	} singlestep;
 };
 
 struct kvm_introspection {
@@ -89,6 +93,7 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
 bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 bool kvmi_enter_guest(struct kvm_vcpu *vcpu);
+bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu);
 
 #else
 
@@ -105,6 +110,8 @@ static inline bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva,
 			{ return true; }
 static inline bool kvmi_enter_guest(struct kvm_vcpu *vcpu)
 			{ return true; }
+static inline bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu)
+			{ return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index a84affbafa67..bc515237612a 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -47,6 +47,8 @@ enum {
 
 	KVMI_VM_SET_PAGE_ACCESS = 23,
 
+	KVMI_VCPU_CONTROL_SINGLESTEP = 24,
+
 	KVMI_NUM_MESSAGES
 };
 
@@ -189,6 +191,11 @@ struct kvmi_vm_set_page_access {
 	struct kvmi_page_access_entry entries[0];
 };
 
+struct kvmi_vcpu_control_singlestep {
+	__u8 enable;
+	__u8 padding[7];
+};
+
 struct kvmi_event {
 	__u16 size;
 	__u16 vcpu;
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index eabe7dae149e..0803d7e5af1e 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1940,6 +1940,51 @@ static void test_event_pf(struct kvm_vm *vm)
 	test_pf(vm, cbk_test_event_pf);
 }
 
+static void cmd_vcpu_singlestep(struct kvm_vm *vm, __u8 enable, __u8 padding,
+				int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_control_singlestep cmd;
+	} req = {};
+	int r;
+
+	req.cmd.enable = enable;
+	req.cmd.padding[6] = padding;
+
+	r = do_vcpu0_command(vm, KVMI_VCPU_CONTROL_SINGLESTEP,
+			     &req.hdr, sizeof(req), NULL, 0);
+	TEST_ASSERT(r == expected_err,
+		"KVMI_VCPU_CONTROL_SINGLESTEP failed, error %d(%s), expected error %d\n",
+		-r, kvm_strerror(-r), expected_err);
+}
+
+static void test_supported_singlestep(struct kvm_vm *vm)
+{
+	__u8 disable = 0, enable = 1, enable_inval = 2;
+	__u8 padding = 1, no_padding = 0;
+
+	cmd_vcpu_singlestep(vm, enable, no_padding, 0);
+	cmd_vcpu_singlestep(vm, disable, no_padding, 0);
+
+	cmd_vcpu_singlestep(vm, enable, padding, -KVM_EINVAL);
+	cmd_vcpu_singlestep(vm, enable_inval, no_padding, -KVM_EINVAL);
+}
+
+static void test_unsupported_singlestep(struct kvm_vm *vm)
+{
+	cmd_vcpu_singlestep(vm, 1, 0, -KVM_EOPNOTSUPP);
+}
+
+static void test_cmd_vcpu_control_singlestep(struct kvm_vm *vm)
+{
+	if (features.singlestep)
+		test_supported_singlestep(vm);
+	else
+		test_unsupported_singlestep(vm);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1974,6 +2019,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_control_msr(vm);
 	test_cmd_vm_set_page_access(vm);
 	test_event_pf(vm);
+	test_cmd_vcpu_control_singlestep(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 99c88e182587..2c7533a966f9 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -429,6 +429,11 @@ static void kvmi_job_release_vcpu(struct kvm_vcpu *vcpu, void *ctx)
 
 	atomic_set(&vcpui->pause_requests, 0);
 	vcpui->waiting_for_reply = false;
+
+	if (vcpui->singlestep.loop) {
+		kvmi_arch_stop_singlestep(vcpu);
+		vcpui->singlestep.loop = false;
+	}
 }
 
 static void kvmi_release_vcpus(struct kvm *kvm)
@@ -1047,7 +1052,9 @@ bool kvmi_enter_guest(struct kvm_vcpu *vcpu)
 
 	vcpui = VCPUI(vcpu);
 
-	if (vcpui->exception.pending) {
+	if (vcpui->singlestep.loop) {
+		kvmi_arch_start_singlestep(vcpu);
+	} else if (vcpui->exception.pending) {
 		kvmi_inject_pending_exception(vcpu);
 		r = false;
 	}
@@ -1297,3 +1304,20 @@ void kvmi_remove_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	spin_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
+
+bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu)
+{
+	struct kvm_introspection *kvmi;
+	bool ret;
+
+	kvmi = kvmi_get(vcpu->kvm);
+	if (!kvmi)
+		return false;
+
+	ret = VCPUI(vcpu)->singlestep.loop;
+
+	kvmi_put(vcpu->kvm);
+
+	return ret;
+}
+EXPORT_SYMBOL(kvmi_vcpu_running_singlestep);
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 68b8d60a7fac..e5fca3502bab 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -139,5 +139,7 @@ void kvmi_arch_update_page_tracking(struct kvm *kvm,
 void kvmi_arch_hook(struct kvm *kvm);
 void kvmi_arch_unhook(struct kvm *kvm);
 void kvmi_arch_features(struct kvmi_features *feat);
+bool kvmi_arch_start_singlestep(struct kvm_vcpu *vcpu);
+bool kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index e754cee48912..04e7511a9777 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -609,6 +609,39 @@ static int handle_vcpu_control_msr(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_control_singlestep(const struct kvmi_vcpu_msg_job *job,
+					  const struct kvmi_msg_hdr *msg,
+					  const void *_req)
+{
+	const struct kvmi_vcpu_control_singlestep *req = _req;
+	struct kvm_vcpu *vcpu = job->vcpu;
+	int ec = -KVM_EINVAL;
+	bool done;
+	int i;
+
+	if (req->enable > 1)
+		goto reply;
+
+	for (i = 0; i < sizeof(req->padding); i++)
+		if (req->padding[i])
+			goto reply;
+
+	if (req->enable)
+		done = kvmi_arch_start_singlestep(vcpu);
+	else
+		done = kvmi_arch_stop_singlestep(vcpu);
+
+	if (done) {
+		ec = 0;
+		VCPUI(vcpu)->singlestep.loop = !!req->enable;
+	} else {
+		ec = -KVM_EOPNOTSUPP;
+	}
+
+reply:
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 /*
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -617,19 +650,20 @@ static int handle_vcpu_control_msr(const struct kvmi_vcpu_msg_job *job,
  */
 static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
-	[KVMI_EVENT]                 = handle_vcpu_event_reply,
-	[KVMI_VCPU_CONTROL_CR]       = handle_vcpu_control_cr,
-	[KVMI_VCPU_CONTROL_EVENTS]   = handle_vcpu_control_events,
-	[KVMI_VCPU_CONTROL_MSR]      = handle_vcpu_control_msr,
-	[KVMI_VCPU_GET_CPUID]        = handle_vcpu_get_cpuid,
-	[KVMI_VCPU_GET_INFO]         = handle_vcpu_get_info,
-	[KVMI_VCPU_GET_MTRR_TYPE]    = handle_vcpu_get_mtrr_type,
-	[KVMI_VCPU_GET_REGISTERS]    = handle_vcpu_get_registers,
-	[KVMI_VCPU_GET_XCR]          = handle_vcpu_get_xcr,
-	[KVMI_VCPU_GET_XSAVE]        = handle_vcpu_get_xsave,
-	[KVMI_VCPU_INJECT_EXCEPTION] = handle_vcpu_inject_exception,
-	[KVMI_VCPU_SET_REGISTERS]    = handle_vcpu_set_registers,
-	[KVMI_VCPU_SET_XSAVE]        = handle_vcpu_set_xsave,
+	[KVMI_EVENT]                   = handle_vcpu_event_reply,
+	[KVMI_VCPU_CONTROL_CR]         = handle_vcpu_control_cr,
+	[KVMI_VCPU_CONTROL_EVENTS]     = handle_vcpu_control_events,
+	[KVMI_VCPU_CONTROL_MSR]        = handle_vcpu_control_msr,
+	[KVMI_VCPU_CONTROL_SINGLESTEP] = handle_vcpu_control_singlestep,
+	[KVMI_VCPU_GET_CPUID]          = handle_vcpu_get_cpuid,
+	[KVMI_VCPU_GET_INFO]           = handle_vcpu_get_info,
+	[KVMI_VCPU_GET_MTRR_TYPE]      = handle_vcpu_get_mtrr_type,
+	[KVMI_VCPU_GET_REGISTERS]      = handle_vcpu_get_registers,
+	[KVMI_VCPU_GET_XCR]            = handle_vcpu_get_xcr,
+	[KVMI_VCPU_GET_XSAVE]          = handle_vcpu_get_xsave,
+	[KVMI_VCPU_INJECT_EXCEPTION]   = handle_vcpu_inject_exception,
+	[KVMI_VCPU_SET_REGISTERS]      = handle_vcpu_set_registers,
+	[KVMI_VCPU_SET_XSAVE]          = handle_vcpu_set_xsave,
 };
 
 static bool is_vcpu_command(u16 id)
