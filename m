Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36902C3C8D
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbgKYJmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:42:06 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57140 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727682AbgKYJmC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:42:02 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 62D96305D3EA;
        Wed, 25 Nov 2020 11:35:55 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3EF253072785;
        Wed, 25 Nov 2020 11:35:55 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 77/81] KVM: introspection: add KVMI_VCPU_CONTROL_SINGLESTEP
Date:   Wed, 25 Nov 2020 11:35:56 +0200
Message-Id: <20201125093600.2766-78-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <nicu.citu@icloud.com>

The next commit that adds the KVMI_VCPU_EVENT_SINGLESTEP event will make
this command more useful.

Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 33 +++++++++++
 arch/x86/kvm/kvmi.c                           | 14 ++++-
 arch/x86/kvm/kvmi_msg.c                       | 56 +++++++++++++++----
 arch/x86/kvm/x86.c                            | 12 +++-
 include/linux/kvmi_host.h                     |  7 +++
 include/uapi/linux/kvmi.h                     | 30 ++++++----
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 39 +++++++++++++
 virt/kvm/introspection/kvmi.c                 | 22 ++++++++
 virt/kvm/introspection/kvmi_int.h             |  2 +
 9 files changed, 187 insertions(+), 28 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 991922897f1d..c8822912d8c8 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -791,6 +791,7 @@ exception.
 * -KVM_EINVAL - the selected vCPU is invalid
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EBUSY - the vCPU is switched in singlestep mode (*KVMI_VCPU_CONTROL_SINGLESTEP*)
 * -KVM_EBUSY - another *KVMI_VCPU_INJECT_EXCEPTION*-*KVMI_VCPU_EVENT_TRAP*
                pair is in progress
 
@@ -1036,6 +1037,38 @@ In order to 'forget' an address, all three bits ('rwx') must be set.
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
index e0302883aec5..31a2de24de29 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -776,7 +776,9 @@ void kvmi_enter_guest(struct kvm_vcpu *vcpu)
 	if (kvmi) {
 		vcpui = VCPUI(vcpu);
 
-		if (vcpui->arch.exception.pending)
+		if (vcpui->singlestep.loop)
+			kvmi_arch_start_singlestep(vcpu);
+		else if (vcpui->arch.exception.pending)
 			kvmi_inject_pending_exception(vcpu);
 
 		kvmi_put(vcpu->kvm);
@@ -1086,3 +1088,13 @@ void kvmi_arch_features(struct kvmi_features *feat)
 {
 	feat->singlestep = !!kvm_x86_ops.control_singlestep;
 }
+
+void kvmi_arch_start_singlestep(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops.control_singlestep(vcpu, true);
+}
+
+void kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu)
+{
+	kvm_x86_ops.control_singlestep(vcpu, false);
+}
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index c961c5367a13..8b59f9f73c5d 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -166,7 +166,8 @@ static int handle_vcpu_inject_exception(const struct kvmi_vcpu_msg_job *job,
 	else if (req->padding1 || req->padding2)
 		ec = -KVM_EINVAL;
 	else if (VCPUI(vcpu)->arch.exception.pending ||
-			VCPUI(vcpu)->arch.exception.send_event)
+			VCPUI(vcpu)->arch.exception.send_event ||
+			VCPUI(vcpu)->singlestep.loop)
 		ec = -KVM_EBUSY;
 	else
 		ec = kvmi_arch_cmd_vcpu_inject_exception(vcpu, req);
@@ -276,18 +277,49 @@ static int handle_vcpu_control_msr(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_control_singlestep(const struct kvmi_vcpu_msg_job *job,
+					  const struct kvmi_msg_hdr *msg,
+					  const void *_req)
+{
+	const struct kvmi_vcpu_control_singlestep *req = _req;
+	struct kvm_vcpu *vcpu = job->vcpu;
+	int ec = 0;
+
+	if (non_zero_padding(req->padding, ARRAY_SIZE(req->padding)) ||
+	    req->enable > 1) {
+		ec = -KVM_EINVAL;
+		goto reply;
+	}
+
+	if (!kvm_x86_ops.control_singlestep) {
+		ec = -KVM_EOPNOTSUPP;
+		goto reply;
+	}
+
+	if (req->enable)
+		kvmi_arch_start_singlestep(vcpu);
+	else
+		kvmi_arch_stop_singlestep(vcpu);
+
+	VCPUI(vcpu)->singlestep.loop = !!req->enable;
+
+reply:
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
-	[KVMI_VCPU_CONTROL_CR]       = handle_vcpu_control_cr,
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
+	[KVMI_VCPU_CONTROL_CR]         = handle_vcpu_control_cr,
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
 
 kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id)
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 0ffa2e73284e..cc7292ee3b2d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8957,9 +8957,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
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
index 14ac075a3ea9..e2103ab9d0d5 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -33,6 +33,10 @@ struct kvm_vcpu_introspection {
 	bool waiting_for_reply;
 
 	unsigned long *ev_enable_mask;
+
+	struct {
+		bool loop;
+	} singlestep;
 };
 
 struct kvm_introspection {
@@ -76,6 +80,7 @@ int kvmi_ioctl_preunhook(struct kvm *kvm);
 void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
 bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
+bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu);
 
 #else
 
@@ -90,6 +95,8 @@ static inline void kvmi_handle_requests(struct kvm_vcpu *vcpu) { }
 static inline bool kvmi_hypercall_event(struct kvm_vcpu *vcpu) { return false; }
 static inline bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva,
 					 u8 insn_len) { return true; }
+static inline bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu)
+			{ return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 43631ed2b06c..91126607b7eb 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -38,18 +38,19 @@ enum {
 enum {
 	KVMI_VCPU_EVENT = KVMI_VCPU_MESSAGE_ID(0),
 
-	KVMI_VCPU_GET_INFO         = KVMI_VCPU_MESSAGE_ID(1),
-	KVMI_VCPU_CONTROL_EVENTS   = KVMI_VCPU_MESSAGE_ID(2),
-	KVMI_VCPU_GET_REGISTERS    = KVMI_VCPU_MESSAGE_ID(3),
-	KVMI_VCPU_SET_REGISTERS    = KVMI_VCPU_MESSAGE_ID(4),
-	KVMI_VCPU_GET_CPUID        = KVMI_VCPU_MESSAGE_ID(5),
-	KVMI_VCPU_CONTROL_CR       = KVMI_VCPU_MESSAGE_ID(6),
-	KVMI_VCPU_INJECT_EXCEPTION = KVMI_VCPU_MESSAGE_ID(7),
-	KVMI_VCPU_GET_XCR          = KVMI_VCPU_MESSAGE_ID(8),
-	KVMI_VCPU_GET_XSAVE        = KVMI_VCPU_MESSAGE_ID(9),
-	KVMI_VCPU_SET_XSAVE        = KVMI_VCPU_MESSAGE_ID(10),
-	KVMI_VCPU_GET_MTRR_TYPE    = KVMI_VCPU_MESSAGE_ID(11),
-	KVMI_VCPU_CONTROL_MSR      = KVMI_VCPU_MESSAGE_ID(12),
+	KVMI_VCPU_GET_INFO           = KVMI_VCPU_MESSAGE_ID(1),
+	KVMI_VCPU_CONTROL_EVENTS     = KVMI_VCPU_MESSAGE_ID(2),
+	KVMI_VCPU_GET_REGISTERS      = KVMI_VCPU_MESSAGE_ID(3),
+	KVMI_VCPU_SET_REGISTERS      = KVMI_VCPU_MESSAGE_ID(4),
+	KVMI_VCPU_GET_CPUID          = KVMI_VCPU_MESSAGE_ID(5),
+	KVMI_VCPU_CONTROL_CR         = KVMI_VCPU_MESSAGE_ID(6),
+	KVMI_VCPU_INJECT_EXCEPTION   = KVMI_VCPU_MESSAGE_ID(7),
+	KVMI_VCPU_GET_XCR            = KVMI_VCPU_MESSAGE_ID(8),
+	KVMI_VCPU_GET_XSAVE          = KVMI_VCPU_MESSAGE_ID(9),
+	KVMI_VCPU_SET_XSAVE          = KVMI_VCPU_MESSAGE_ID(10),
+	KVMI_VCPU_GET_MTRR_TYPE      = KVMI_VCPU_MESSAGE_ID(11),
+	KVMI_VCPU_CONTROL_MSR        = KVMI_VCPU_MESSAGE_ID(12),
+	KVMI_VCPU_CONTROL_SINGLESTEP = KVMI_VCPU_MESSAGE_ID(13),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
@@ -221,4 +222,9 @@ struct kvmi_vcpu_event_pf {
 	__u32 padding3;
 };
 
+struct kvmi_vcpu_control_singlestep {
+	__u8 enable;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 9984b0247ae9..d959216aac9d 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1819,6 +1819,44 @@ static void test_event_pf(struct kvm_vm *vm)
 	test_pf(vm, cbk_test_event_pf);
 }
 
+static void cmd_vcpu_singlestep(struct kvm_vm *vm, __u8 enable,
+				int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_control_singlestep cmd;
+	} req = {};
+
+	req.cmd.enable = enable;
+
+	test_vcpu0_command(vm, KVMI_VCPU_CONTROL_SINGLESTEP,
+			   &req.hdr, sizeof(req), NULL, 0, expected_err);
+}
+
+static void test_supported_singlestep(struct kvm_vm *vm)
+{
+	__u8 disable = 0, enable = 1, enable_inval = 2;
+
+	cmd_vcpu_singlestep(vm, enable, 0);
+	cmd_vcpu_singlestep(vm, disable, 0);
+
+	cmd_vcpu_singlestep(vm, enable_inval, -KVM_EINVAL);
+}
+
+static void test_unsupported_singlestep(struct kvm_vm *vm)
+{
+	cmd_vcpu_singlestep(vm, 1, -KVM_EOPNOTSUPP);
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
@@ -1853,6 +1891,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_control_msr(vm);
 	test_cmd_vm_set_page_access(vm);
 	test_event_pf(vm);
+	test_cmd_vcpu_control_singlestep(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index a228178ddba2..f620396d1887 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -436,6 +436,11 @@ static void kvmi_job_release_vcpu(struct kvm_vcpu *vcpu, void *ctx)
 
 	atomic_set(&vcpui->pause_requests, 0);
 	vcpui->waiting_for_reply = false;
+
+	if (vcpui->singlestep.loop) {
+		kvmi_arch_stop_singlestep(vcpu);
+		vcpui->singlestep.loop = false;
+	}
 }
 
 static void kvmi_release_vcpus(struct kvm *kvm)
@@ -1170,3 +1175,20 @@ void kvmi_remove_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
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
index a51e7e4ed511..4815fa61b136 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -122,5 +122,7 @@ void kvmi_arch_update_page_tracking(struct kvm *kvm,
 void kvmi_arch_hook(struct kvm *kvm);
 void kvmi_arch_unhook(struct kvm *kvm);
 void kvmi_arch_features(struct kvmi_features *feat);
+void kvmi_arch_start_singlestep(struct kvm_vcpu *vcpu);
+void kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu);
 
 #endif
