Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBB2229C91
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:01:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730308AbgGVQBp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:01:45 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38098 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730435AbgGVQBo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:44 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 4366C305D679;
        Wed, 22 Jul 2020 19:01:33 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 3371C305FFA2;
        Wed, 22 Jul 2020 19:01:33 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 32/34] KVM: introspection: add KVMI_VCPU_SET_VE_INFO/KVMI_VCPU_DISABLE_VE
Date:   Wed, 22 Jul 2020 19:01:19 +0300
Message-Id: <20200722160121.9601-33-alazar@bitdefender.com>
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

The introspection tool can use #VE to reduce the number of VM-exits
caused by SPT violations for some guests.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 63 +++++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              |  8 +++
 arch/x86/kvm/kvmi.c                           | 19 ++++++
 include/uapi/linux/kvmi.h                     |  2 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 52 +++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  3 +
 virt/kvm/introspection/kvmi_msg.c             | 30 +++++++++
 7 files changed, 177 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index caa51fccc463..c50c40638d46 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -1230,6 +1230,69 @@ is terminated.
 * -KVM_EINVAL - padding is not zero
 * -KVM_EINVAL - the selected EPT view is not valid
 
+29. KVMI_VCPU_SET_VE_INFO
+-------------------------
+
+:Architecture: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_set_ve_info {
+		__u64 gpa;
+		__u8 trigger_vmexit;
+		__u8 padding1;
+		__u16 padding2;
+		__u32 padding3;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+
+Configures the guest physical address for the #VE info page and enables
+the #VE mechanism. If ``trigger_vmexit`` is true, any virtualization
+exception will trigger a vm-exit. Otherwise, the exception is delivered
+using gate descriptor 20 from the Interrupt Descriptor Table (IDT).
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - one of the specified GPAs is invalid
+* -KVM_EOPNOTSUPP - the hardware does not support #VE
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
+30. KVMI_VCPU_DISABLE_VE
+------------------------
+
+:Architecture: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+
+Disables the #VE mechanism. All EPT violations will trigger a vm-exit,
+regardless of the corresponding spte 63rd bit (SVE) for the GPA that
+triggered the EPT violation within a specific EPT view.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 56992dacfb69..d925e6d49f50 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -174,4 +174,12 @@ struct kvmi_vcpu_control_ept_view {
 	__u32 padding2;
 };
 
+struct kvmi_vcpu_set_ve_info {
+	__u64 gpa;
+	__u8 trigger_vmexit;
+	__u8 padding1;
+	__u16 padding2;
+	__u32 padding3;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 3e8c83623703..e101ac390809 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1464,3 +1464,22 @@ int kvmi_arch_cmd_control_ept_view(struct kvm_vcpu *vcpu, u16 view,
 
 	return kvm_x86_ops.control_ept_view(vcpu, view, visible);
 }
+
+int kvmi_arch_cmd_set_ve_info(struct kvm_vcpu *vcpu, u64 gpa,
+			      bool trigger_vmexit)
+{
+	unsigned long ve_info = (unsigned long) gpa;
+
+	if (!kvm_x86_ops.set_ve_info)
+		return -KVM_EINVAL;
+
+	return kvm_x86_ops.set_ve_info(vcpu, ve_info, trigger_vmexit);
+}
+
+int kvmi_arch_cmd_disable_ve(struct kvm_vcpu *vcpu)
+{
+	if (!kvm_x86_ops.disable_ve)
+		return 0;
+
+	return kvm_x86_ops.disable_ve(vcpu);
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 505a865cd115..a17cd1fa16d0 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -52,6 +52,8 @@ enum {
 	KVMI_VCPU_GET_EPT_VIEW       = 26,
 	KVMI_VCPU_SET_EPT_VIEW       = 27,
 	KVMI_VCPU_CONTROL_EPT_VIEW   = 28,
+	KVMI_VCPU_SET_VE_INFO        = 29,
+	KVMI_VCPU_DISABLE_VE         = 30,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 4e099cbfcf4e..a3ea22f546ec 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -35,6 +35,10 @@ static vm_vaddr_t test_gva;
 static void *test_hva;
 static vm_paddr_t test_gpa;
 
+static vm_vaddr_t test_ve_info_gva;
+static void *test_ve_info_hva;
+static vm_paddr_t test_ve_info_gpa;
+
 static uint8_t test_write_pattern;
 static int page_size;
 
@@ -2258,6 +2262,43 @@ static void test_cmd_vcpu_vmfunc(struct kvm_vm *vm)
 	test_guest_switch_to_visible_view(vm);
 }
 
+static void enable_ve(struct kvm_vm *vm)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_set_ve_info cmd;
+	} req = {};
+
+	req.cmd.gpa = test_ve_info_gpa;
+	req.cmd.trigger_vmexit = 1;
+
+	test_vcpu0_command(vm, KVMI_VCPU_SET_VE_INFO, &req.hdr,
+				sizeof(req), NULL, 0);
+}
+
+static void disable_ve(struct kvm_vm *vm)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+	} req = {};
+
+	test_vcpu0_command(vm, KVMI_VCPU_DISABLE_VE, &req.hdr,
+				sizeof(req), NULL, 0);
+}
+
+static void test_virtualization_exceptions(struct kvm_vm *vm)
+{
+	if (!features.ve) {
+		print_skip("#VE not supported");
+		return;
+	}
+
+	enable_ve(vm);
+	disable_ve(vm);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -2297,6 +2338,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_get_ept_view(vm);
 	test_cmd_vcpu_set_ept_view(vm);
 	test_cmd_vcpu_vmfunc(vm);
+	test_virtualization_exceptions(vm);
 
 	unhook_introspection(vm);
 }
@@ -2311,6 +2353,16 @@ static void setup_test_pages(struct kvm_vm *vm)
 	memset(test_hva, 0, page_size);
 
 	test_gpa = addr_gva2gpa(vm, test_gva);
+
+	/* Allocate #VE info page */
+	test_ve_info_gva = vm_vaddr_alloc(vm, page_size, KVM_UTIL_MIN_VADDR,
+					  0, 0);
+	sync_global_to_guest(vm, test_ve_info_gva);
+
+	test_ve_info_hva = addr_gva2hva(vm, test_ve_info_gva);
+	memset(test_ve_info_hva, 0, page_size);
+
+	test_ve_info_gpa = addr_gva2gpa(vm, test_ve_info_gva);
 }
 
 int main(int argc, char *argv[])
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index fc6dbd3a6472..a0062fbde49e 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -151,5 +151,8 @@ u16 kvmi_arch_cmd_get_ept_view(struct kvm_vcpu *vcpu);
 int kvmi_arch_cmd_set_ept_view(struct kvm_vcpu *vcpu, u16 view);
 int kvmi_arch_cmd_control_ept_view(struct kvm_vcpu *vcpu, u16 view,
 				   bool visible);
+int kvmi_arch_cmd_set_ve_info(struct kvm_vcpu *vcpu, u64 gpa,
+			      bool trigger_vmexit);
+int kvmi_arch_cmd_disable_ve(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 696857f6d008..664b78d545c3 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -711,6 +711,34 @@ static int handle_vcpu_control_ept_view(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_set_ve_info(const struct kvmi_vcpu_msg_job *job,
+				   const struct kvmi_msg_hdr *msg,
+				   const void *_req)
+{
+	const struct kvmi_vcpu_set_ve_info *req = _req;
+	bool trigger_vmexit = !!req->trigger_vmexit;
+	int ec;
+
+	if (req->padding1 || req->padding2 || req->padding3)
+		ec = -KVM_EINVAL;
+	else
+		ec = kvmi_arch_cmd_set_ve_info(job->vcpu, req->gpa,
+						trigger_vmexit);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
+static int handle_vcpu_disable_ve(const struct kvmi_vcpu_msg_job *job,
+				  const struct kvmi_msg_hdr *msg,
+				  const void *req)
+{
+	int ec;
+
+	ec = kvmi_arch_cmd_disable_ve(job->vcpu);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 /*
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -725,6 +753,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 	[KVMI_VCPU_CONTROL_EVENTS]     = handle_vcpu_control_events,
 	[KVMI_VCPU_CONTROL_MSR]        = handle_vcpu_control_msr,
 	[KVMI_VCPU_CONTROL_SINGLESTEP] = handle_vcpu_control_singlestep,
+	[KVMI_VCPU_DISABLE_VE]         = handle_vcpu_disable_ve,
 	[KVMI_VCPU_GET_CPUID]          = handle_vcpu_get_cpuid,
 	[KVMI_VCPU_GET_EPT_VIEW]       = handle_vcpu_get_ept_view,
 	[KVMI_VCPU_GET_INFO]           = handle_vcpu_get_info,
@@ -736,6 +765,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 	[KVMI_VCPU_SET_EPT_VIEW]       = handle_vcpu_set_ept_view,
 	[KVMI_VCPU_SET_REGISTERS]      = handle_vcpu_set_registers,
 	[KVMI_VCPU_SET_XSAVE]          = handle_vcpu_set_xsave,
+	[KVMI_VCPU_SET_VE_INFO]        = handle_vcpu_set_ve_info,
 	[KVMI_VCPU_TRANSLATE_GVA]      = handle_vcpu_translate_gva,
 };
 
