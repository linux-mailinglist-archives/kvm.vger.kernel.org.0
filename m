Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4C0197937
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbgC3KWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:22:17 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43780 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729204AbgC3KTw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:52 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 093E2305D3D3;
        Mon, 30 Mar 2020 13:13:02 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 98B2D305B7A2;
        Mon, 30 Mar 2020 13:13:01 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 77/81] KVM: introspection: add KVMI_VCPU_CONTROL_SINGLESTEP
Date:   Mon, 30 Mar 2020 13:13:04 +0300
Message-Id: <20200330101308.21702-78-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nicușor Cîțu <ncitu@bitdefender.com>

This command is useful for debuggers.

Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 32 +++++++
 arch/x86/kvm/kvmi.c                           | 18 ++++
 arch/x86/kvm/x86.c                            |  7 ++
 include/linux/kvmi_host.h                     |  7 ++
 include/uapi/linux/kvmi.h                     |  7 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 23 +++++
 virt/kvm/introspection/kvmi.c                 | 23 +++++
 virt/kvm/introspection/kvmi_int.h             |  2 +
 virt/kvm/introspection/kvmi_msg.c             | 94 ++++++++++++-------
 9 files changed, 181 insertions(+), 32 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index b211ae0ed86a..5e013ee4a79b 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -954,6 +954,38 @@ In order to 'forget' an address, all three bits ('rwx') must be set.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - there is not enough memory to add the page tracking structures
 
+20. KVMI_VCPU_CONTROL_SINGLESTEP
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
index d7e1c0690c43..729f91a66405 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1210,3 +1210,21 @@ bool kvmi_arch_pf_of_interest(struct kvm_vcpu *vcpu)
 	      !kvm_x86_ops->gpt_translation_fault(vcpu);
 }
 
+bool kvmi_arch_start_singlestep(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_x86_ops->control_singlestep)
+		return false;
+
+	kvm_x86_ops->control_singlestep(vcpu, true);
+	return true;
+}
+
+bool kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_x86_ops->control_singlestep)
+		return false;
+
+	kvm_x86_ops->control_singlestep(vcpu, false);
+	return true;
+}
+
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ce2f9d47d6f6..12e9b4689025 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7738,6 +7738,13 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool req_int_win)
 {
 	int r;
 
+	if (kvmi_vcpu_running_singlestep(vcpu))
+		/*
+		 * We cannot inject events during single-stepping.
+		 * Try again later.
+		 */
+		return -1;
+
 	/* try to reinject previous events if any */
 
 	if (vcpu->arch.exception.injected)
diff --git a/include/linux/kvmi_host.h b/include/linux/kvmi_host.h
index c9dd2d57033b..23784611996e 100644
--- a/include/linux/kvmi_host.h
+++ b/include/linux/kvmi_host.h
@@ -50,6 +50,10 @@ struct kvm_vcpu_introspection {
 		bool pending;
 		bool send_event;
 	} exception;
+
+	struct {
+		bool loop;
+	} singlestep;
 };
 
 struct kvm_introspection {
@@ -90,6 +94,7 @@ void kvmi_handle_requests(struct kvm_vcpu *vcpu);
 bool kvmi_hypercall_event(struct kvm_vcpu *vcpu);
 bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva, u8 insn_len);
 bool kvmi_enter_guest(struct kvm_vcpu *vcpu);
+bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu);
 
 #else
 
@@ -106,6 +111,8 @@ static inline bool kvmi_breakpoint_event(struct kvm_vcpu *vcpu, u64 gva,
 			{ return true; }
 static inline bool kvmi_enter_guest(struct kvm_vcpu *vcpu)
 			{ return true; }
+static inline bool kvmi_vcpu_running_singlestep(struct kvm_vcpu *vcpu)
+			{ return false; }
 
 #endif /* CONFIG_KVM_INTROSPECTION */
 
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index caf166e7ddff..97c4ef67bfe4 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -42,6 +42,8 @@ enum {
 
 	KVMI_VM_SET_PAGE_ACCESS = 21,
 
+	KVMI_VCPU_CONTROL_SINGLESTEP = 22,
+
 	KVMI_NUM_MESSAGES
 };
 
@@ -178,6 +180,11 @@ struct kvmi_vm_set_page_access {
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
index d4cfe595821d..27642000c4e4 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1668,6 +1668,28 @@ static void test_event_pf(struct kvm_vm *vm)
 	test_pf(vm, cbk_test_event_pf);
 }
 
+static void test_cmd_vcpu_control_singlestep(struct kvm_vm *vm)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_control_singlestep cmd;
+	} req = {};
+
+	if (!features.singlestep) {
+		DEBUG("Skip %s()\n", __func__);
+		return;
+	}
+
+	req.cmd.enable = true;
+	test_vcpu0_command(vm, KVMI_VCPU_CONTROL_SINGLESTEP,
+			   &req.hdr, sizeof(req), NULL, 0);
+
+	req.cmd.enable = false;
+	test_vcpu0_command(vm, KVMI_VCPU_CONTROL_SINGLESTEP,
+			   &req.hdr, sizeof(req), NULL, 0);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1700,6 +1722,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_control_msr(vm);
 	test_cmd_vm_set_page_access(vm);
 	test_event_pf(vm);
+	test_cmd_vcpu_control_singlestep(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi.c b/virt/kvm/introspection/kvmi.c
index e13b55856e9c..90e6c2d3dd4f 100644
--- a/virt/kvm/introspection/kvmi.c
+++ b/virt/kvm/introspection/kvmi.c
@@ -401,6 +401,9 @@ static void kvmi_job_release_vcpu(struct kvm_vcpu *vcpu, void *ctx)
 
 	atomic_set(&vcpui->pause_requests, 0);
 	vcpui->waiting_for_reply = false;
+
+	if (vcpui->singlestep.loop)
+		kvmi_arch_stop_singlestep(vcpu);
 }
 
 static void kvmi_release_vcpus(struct kvm *kvm)
@@ -1019,6 +1022,9 @@ bool kvmi_enter_guest(struct kvm_vcpu *vcpu)
 	if (!kvmi)
 		return true;
 
+	if (VCPUI(vcpu)->singlestep.loop)
+		kvmi_arch_start_singlestep(vcpu);
+
 	if (kvmi_inject_pending_exception(vcpu))
 		r = false;
 
@@ -1297,3 +1303,20 @@ static void kvmi_track_flush_slot(struct kvm *kvm, struct kvm_memory_slot *slot,
 
 	kvmi_put(kvm);
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
index e0cb58c60697..820081f8e3f1 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -128,5 +128,7 @@ bool kvmi_arch_pf_event(struct kvm_vcpu *vcpu, gpa_t gpa, gva_t gva,
 			u8 access);
 bool kvmi_arch_pf_of_interest(struct kvm_vcpu *vcpu);
 void kvmi_arch_features(struct kvmi_features *feat);
+bool kvmi_arch_start_singlestep(struct kvm_vcpu *vcpu);
+bool kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 71a67154542f..14c063869c29 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -20,27 +20,28 @@ struct kvmi_vcpu_cmd_job {
 };
 
 static const char *const msg_IDs[] = {
-	[KVMI_EVENT]                 = "KVMI_EVENT",
-	[KVMI_GET_VERSION]           = "KVMI_GET_VERSION",
-	[KVMI_VM_CHECK_COMMAND]      = "KVMI_VM_CHECK_COMMAND",
-	[KVMI_VM_CHECK_EVENT]        = "KVMI_VM_CHECK_EVENT",
-	[KVMI_VM_CONTROL_EVENTS]     = "KVMI_VM_CONTROL_EVENTS",
-	[KVMI_VM_GET_INFO]           = "KVMI_VM_GET_INFO",
-	[KVMI_VM_GET_MAX_GFN]        = "KVMI_VM_GET_MAX_GFN",
-	[KVMI_VM_READ_PHYSICAL]      = "KVMI_VM_READ_PHYSICAL",
-	[KVMI_VM_SET_PAGE_ACCESS]    = "KVMI_VM_SET_PAGE_ACCESS",
-	[KVMI_VM_WRITE_PHYSICAL]     = "KVMI_VM_WRITE_PHYSICAL",
-	[KVMI_VCPU_CONTROL_CR]       = "KVMI_VCPU_CONTROL_CR",
-	[KVMI_VCPU_CONTROL_EVENTS]   = "KVMI_VCPU_CONTROL_EVENTS",
-	[KVMI_VCPU_CONTROL_MSR]      = "KVMI_VCPU_CONTROL_MSR",
-	[KVMI_VCPU_GET_CPUID]        = "KVMI_VCPU_GET_CPUID",
-	[KVMI_VCPU_GET_INFO]         = "KVMI_VCPU_GET_INFO",
-	[KVMI_VCPU_GET_MTRR_TYPE]    = "KVMI_VCPU_GET_MTRR_TYPE",
-	[KVMI_VCPU_GET_REGISTERS]    = "KVMI_VCPU_GET_REGISTERS",
-	[KVMI_VCPU_GET_XSAVE]        = "KVMI_VCPU_GET_XSAVE",
-	[KVMI_VCPU_INJECT_EXCEPTION] = "KVMI_VCPU_INJECT_EXCEPTION",
-	[KVMI_VCPU_PAUSE]            = "KVMI_VCPU_PAUSE",
-	[KVMI_VCPU_SET_REGISTERS]    = "KVMI_VCPU_SET_REGISTERS",
+	[KVMI_EVENT]                   = "KVMI_EVENT",
+	[KVMI_GET_VERSION]             = "KVMI_GET_VERSION",
+	[KVMI_VM_CHECK_COMMAND]        = "KVMI_VM_CHECK_COMMAND",
+	[KVMI_VM_CHECK_EVENT]          = "KVMI_VM_CHECK_EVENT",
+	[KVMI_VM_CONTROL_EVENTS]       = "KVMI_VM_CONTROL_EVENTS",
+	[KVMI_VM_GET_INFO]             = "KVMI_VM_GET_INFO",
+	[KVMI_VM_GET_MAX_GFN]          = "KVMI_VM_GET_MAX_GFN",
+	[KVMI_VM_READ_PHYSICAL]        = "KVMI_VM_READ_PHYSICAL",
+	[KVMI_VM_SET_PAGE_ACCESS]      = "KVMI_VM_SET_PAGE_ACCESS",
+	[KVMI_VM_WRITE_PHYSICAL]       = "KVMI_VM_WRITE_PHYSICAL",
+	[KVMI_VCPU_CONTROL_CR]         = "KVMI_VCPU_CONTROL_CR",
+	[KVMI_VCPU_CONTROL_EVENTS]     = "KVMI_VCPU_CONTROL_EVENTS",
+	[KVMI_VCPU_CONTROL_MSR]        = "KVMI_VCPU_CONTROL_MSR",
+	[KVMI_VCPU_CONTROL_SINGLESTEP] = "KVMI_VCPU_CONTROL_SINGLESTEP",
+	[KVMI_VCPU_GET_CPUID]          = "KVMI_VCPU_GET_CPUID",
+	[KVMI_VCPU_GET_INFO]           = "KVMI_VCPU_GET_INFO",
+	[KVMI_VCPU_GET_MTRR_TYPE]      = "KVMI_VCPU_GET_MTRR_TYPE",
+	[KVMI_VCPU_GET_REGISTERS]      = "KVMI_VCPU_GET_REGISTERS",
+	[KVMI_VCPU_GET_XSAVE]          = "KVMI_VCPU_GET_XSAVE",
+	[KVMI_VCPU_INJECT_EXCEPTION]   = "KVMI_VCPU_INJECT_EXCEPTION",
+	[KVMI_VCPU_PAUSE]              = "KVMI_VCPU_PAUSE",
+	[KVMI_VCPU_SET_REGISTERS]      = "KVMI_VCPU_SET_REGISTERS",
 };
 
 static const char *id2str(u16 id)
@@ -619,6 +620,34 @@ static int handle_vcpu_control_msr(const struct kvmi_vcpu_cmd_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_control_singlestep(const struct kvmi_vcpu_cmd_job *job,
+					  const struct kvmi_msg_hdr *msg,
+					  const void *_req)
+{
+	const struct kvmi_vcpu_control_singlestep *req = _req;
+	struct kvm_vcpu *vcpu = job->vcpu;
+	int ec = -KVM_EINVAL;
+	bool done;
+	int i;
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
+	}
+
+reply:
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 /*
  * These commands are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -627,17 +656,18 @@ static int handle_vcpu_control_msr(const struct kvmi_vcpu_cmd_job *job,
  */
 static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
-	[KVMI_EVENT]                 = handle_event_reply,
-	[KVMI_VCPU_CONTROL_CR]       = handle_vcpu_control_cr,
-	[KVMI_VCPU_CONTROL_EVENTS]   = handle_vcpu_control_events,
-	[KVMI_VCPU_CONTROL_MSR]      = handle_vcpu_control_msr,
-	[KVMI_VCPU_GET_CPUID]        = handle_get_cpuid,
-	[KVMI_VCPU_GET_INFO]         = handle_get_vcpu_info,
-	[KVMI_VCPU_GET_MTRR_TYPE]    = handle_vcpu_get_mtrr_type,
-	[KVMI_VCPU_GET_REGISTERS]    = handle_get_registers,
-	[KVMI_VCPU_GET_XSAVE]        = handle_vcpu_get_xsave,
-	[KVMI_VCPU_INJECT_EXCEPTION] = handle_vcpu_inject_exception,
-	[KVMI_VCPU_SET_REGISTERS]    = handle_set_registers,
+	[KVMI_EVENT]                   = handle_event_reply,
+	[KVMI_VCPU_CONTROL_CR]         = handle_vcpu_control_cr,
+	[KVMI_VCPU_CONTROL_EVENTS]     = handle_vcpu_control_events,
+	[KVMI_VCPU_CONTROL_MSR]        = handle_vcpu_control_msr,
+	[KVMI_VCPU_CONTROL_SINGLESTEP] = handle_vcpu_control_singlestep,
+	[KVMI_VCPU_GET_CPUID]          = handle_get_cpuid,
+	[KVMI_VCPU_GET_INFO]           = handle_get_vcpu_info,
+	[KVMI_VCPU_GET_MTRR_TYPE]      = handle_vcpu_get_mtrr_type,
+	[KVMI_VCPU_GET_REGISTERS]      = handle_get_registers,
+	[KVMI_VCPU_GET_XSAVE]          = handle_vcpu_get_xsave,
+	[KVMI_VCPU_INJECT_EXCEPTION]   = handle_vcpu_inject_exception,
+	[KVMI_VCPU_SET_REGISTERS]      = handle_set_registers,
 };
 
 static bool is_vcpu_command(u16 id)
