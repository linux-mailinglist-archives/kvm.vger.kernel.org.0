Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4AF4244CA
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239536AbhJFRnB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:01 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53574 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239174AbhJFRmi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:38 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 6C2BB30828BD;
        Wed,  6 Oct 2021 20:31:24 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 4DC913064495;
        Wed,  6 Oct 2021 20:31:24 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 73/77] KVM: introspection: add KVMI_VCPU_CONTROL_SINGLESTEP
Date:   Wed,  6 Oct 2021 20:31:09 +0300
Message-Id: <20211006173113.26445-74-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
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
 arch/x86/kvm/x86.c                            | 18 ++++--
 include/linux/kvmi_host.h                     |  7 +++
 include/uapi/linux/kvmi.h                     | 30 ++++++----
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 39 +++++++++++++
 virt/kvm/introspection/kvmi.c                 | 22 ++++++++
 virt/kvm/introspection/kvmi_int.h             |  2 +
 9 files changed, 190 insertions(+), 31 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 54cb3fbe184e..7f70345ebaac 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -791,6 +791,7 @@ exception.
 * -KVM_EINVAL - the selected vCPU is invalid
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EBUSY - the vCPU is switched in singlestep mode (*KVMI_VCPU_CONTROL_SINGLESTEP*)
 * -KVM_EBUSY - another *KVMI_VCPU_INJECT_EXCEPTION*-*KVMI_VCPU_EVENT_TRAP*
                pair is in progress
 
@@ -1017,6 +1018,38 @@ In order to 'forget' an address, all three bits ('rwx') must be set.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - there is not enough memory to add the page tracking structures
 
+23. KVMI_VCPU_CONTROL_SINGLESTEP
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
index eee874890e29..e26a0eee1592 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -779,7 +779,9 @@ void kvmi_enter_guest(struct kvm_vcpu *vcpu)
 	if (kvmi) {
 		vcpui = VCPUI(vcpu);
 
-		if (vcpui->arch.exception.pending)
+		if (vcpui->singlestep.loop)
+			kvmi_arch_start_singlestep(vcpu);
+		else if (vcpui->arch.exception.pending)
 			kvmi_inject_pending_exception(vcpu);
 
 		kvmi_put(vcpu->kvm);
@@ -1089,3 +1091,13 @@ void kvmi_arch_features(struct kvmi_features *feat)
 {
 	feat->singlestep = !!kvm_x86_ops.control_singlestep;
 }
+
+void kvmi_arch_start_singlestep(struct kvm_vcpu *vcpu)
+{
+	static_call(kvm_x86_control_singlestep)(vcpu, true);
+}
+
+void kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu)
+{
+	static_call(kvm_x86_control_singlestep)(vcpu, false);
+}
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index 98e29e1d3961..6d3980e18281 100644
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
@@ -275,18 +276,49 @@ static int handle_vcpu_control_msr(const struct kvmi_vcpu_msg_job *job,
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
 static const kvmi_vcpu_msg_job_fct msg_vcpu[] = {
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
index 238f3de10894..9a3fac9b30ba 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9613,13 +9613,19 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 			goto out;
 		}
 
-		r = inject_pending_event(vcpu, &req_immediate_exit);
-		if (r < 0) {
-			r = 0;
-			goto out;
+		if (!kvmi_vcpu_running_singlestep(vcpu)) {
+			/*
+			 * We cannot inject events during single-stepping.
+			 * Try again later.
+			 */
+			r = inject_pending_event(vcpu, &req_immediate_exit);
+			if (r < 0) {
+				r = 0;
+				goto out;
+			}
+			if (req_int_win)
+				static_call(kvm_x86_enable_irq_window)(vcpu);
 		}
-		if (req_int_win)
-			static_call(kvm_x86_enable_irq_window)(vcpu);
 
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
index b594463795c6..31bf2b6f3779 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -37,18 +37,19 @@ enum {
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
@@ -216,4 +217,9 @@ struct kvmi_vcpu_event_pf {
 	__u32 padding3;
 };
 
+struct kvmi_vcpu_control_singlestep {
+	__u8 enable;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index f7735e3ea9e8..1bd01115be31 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1808,6 +1808,44 @@ static void test_event_pf(struct kvm_vm *vm)
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
@@ -1841,6 +1879,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_control_msr(vm);
 	test_cmd_vm_set_page_access(vm);
 	test_event_pf(vm);
+	test_cmd_vcpu_control_singlestep(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index 4bc29382ba5a..c20c70547065 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -437,6 +437,11 @@ static void kvmi_job_release_vcpu(struct kvm_vcpu *vcpu, void *ctx)
 
 	atomic_set(&vcpui->pause_requests, 0);
 	vcpui->waiting_for_reply = false;
+
+	if (vcpui->singlestep.loop) {
+		kvmi_arch_stop_singlestep(vcpu);
+		vcpui->singlestep.loop = false;
+	}
 }
 
 static void kvmi_release_vcpus(struct kvm *kvm)
@@ -1172,3 +1177,20 @@ void kvmi_remove_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	KVM_MMU_UNLOCK(kvm);
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
