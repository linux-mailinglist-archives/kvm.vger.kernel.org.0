Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09538229CB4
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728236AbgGVQCP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:02:15 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:38030 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729114AbgGVQBk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:40 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 7876E305D766;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 6079E305FFA2;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 15/34] KVM: introspection: add KVMI_VCPU_SET_EPT_VIEW
Date:   Wed, 22 Jul 2020 19:01:02 +0300
Message-Id: <20200722160121.9601-16-alazar@bitdefender.com>
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

The introspection tool uses this function to check the hardware support
for EPT switching, which can be used to singlestep vCPUs
on a unprotected EPT view.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 36 ++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              |  6 +++
 arch/x86/kvm/kvmi.c                           |  9 ++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 43 +++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  6 +++
 virt/kvm/introspection/kvmi_msg.c             | 20 +++++++++
 7 files changed, 121 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 76a2d0125f78..02f03c62adef 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -1154,6 +1154,42 @@ be zero.
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+27. KVMI_VCPU_SET_EPT_VIEW
+--------------------------
+
+:Architecture: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_set_ept_view {
+		__u16 view;
+		__u16 padding1;
+		__u32 padding2;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+
+Configures the vCPU to use the provided ``view``.
+
+Before switching EPT views, the introspection tool should use
+*KVMI_GET_VERSION* to check if the hardware has support for VMFUNC and
+EPTP switching mechanism (see **KVMI_GET_VERSION**).
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EINVAL - the selected EPT view is invalid
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_EOPNOTSUPP - an EPT view was selected but the hardware doesn't support it
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index a13a98fa863f..f7a080d5e227 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -160,4 +160,10 @@ struct kvmi_vcpu_get_ept_view_reply {
 	__u32 padding2;
 };
 
+struct kvmi_vcpu_set_ept_view {
+	__u16 view;
+	__u16 padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 292606902338..99ea8ef70be2 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1423,3 +1423,12 @@ u16 kvmi_arch_cmd_get_ept_view(struct kvm_vcpu *vcpu)
 {
 	return kvm_get_ept_view(vcpu);
 }
+
+int kvmi_arch_cmd_set_ept_view(struct kvm_vcpu *vcpu, u16 view)
+{
+
+	if (!kvm_x86_ops.set_ept_view)
+		return -KVM_EINVAL;
+
+	return kvm_x86_ops.set_ept_view(vcpu, view);
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index cf3422ec60a8..8204661d944d 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -50,6 +50,7 @@ enum {
 	KVMI_VCPU_CONTROL_SINGLESTEP = 24,
 	KVMI_VCPU_TRANSLATE_GVA      = 25,
 	KVMI_VCPU_GET_EPT_VIEW       = 26,
+	KVMI_VCPU_SET_EPT_VIEW       = 27,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 74eafbcae14a..c6f7d10563db 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -20,6 +20,8 @@
 #include "linux/kvm_para.h"
 #include "linux/kvmi.h"
 
+#define KVM_MAX_EPT_VIEWS 3
+
 #define VCPU_ID         5
 
 #define X86_FEATURE_XSAVE	(1<<26)
@@ -2098,6 +2100,46 @@ static void test_cmd_vcpu_get_ept_view(struct kvm_vm *vm)
 	pr_info("EPT view %u\n", view);
 }
 
+static void set_ept_view(struct kvm_vm *vm, __u16 view)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_set_ept_view cmd;
+	} req = {};
+
+	req.cmd.view = view;
+
+	test_vcpu0_command(vm, KVMI_VCPU_SET_EPT_VIEW,
+			   &req.hdr, sizeof(req), NULL, 0);
+}
+
+static void test_cmd_vcpu_set_ept_view(struct kvm_vm *vm)
+{
+	__u16 old_view;
+	__u16 new_view;
+	__u16 check_view;
+
+	if (!features.eptp) {
+		print_skip("EPT views not supported");
+		return;
+	}
+
+	old_view = get_ept_view(vm);
+
+	new_view = (old_view + 1) % KVM_MAX_EPT_VIEWS;
+	pr_info("Change EPT view from %u to %u\n", old_view, new_view);
+	set_ept_view(vm, new_view);
+
+	check_view = get_ept_view(vm);
+	TEST_ASSERT(check_view == new_view,
+			"Switching EPT view failed, found ept view (%u), expected view (%u)\n",
+			check_view, new_view);
+
+	pr_info("Change EPT view from %u to %u\n", check_view, old_view);
+	set_ept_view(vm, old_view);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -2135,6 +2177,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_control_singlestep(vm);
 	test_cmd_translate_gva(vm);
 	test_cmd_vcpu_get_ept_view(vm);
+	test_cmd_vcpu_set_ept_view(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index f88999bf59e8..f093aad2f804 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -32,6 +32,11 @@ static inline bool is_event_enabled(struct kvm_vcpu *vcpu, int event)
 	return test_bit(event, VCPUI(vcpu)->ev_enable_mask);
 }
 
+static inline bool is_valid_view(unsigned short view)
+{
+	return (view < KVM_MAX_EPT_VIEWS);
+}
+
 /* kvmi_msg.c */
 bool kvmi_sock_get(struct kvm_introspection *kvmi, int fd);
 void kvmi_sock_shutdown(struct kvm_introspection *kvmi);
@@ -143,5 +148,6 @@ bool kvmi_arch_start_singlestep(struct kvm_vcpu *vcpu);
 bool kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu);
 gpa_t kvmi_arch_cmd_translate_gva(struct kvm_vcpu *vcpu, gva_t gva);
 u16 kvmi_arch_cmd_get_ept_view(struct kvm_vcpu *vcpu);
+int kvmi_arch_cmd_set_ept_view(struct kvm_vcpu *vcpu, u16 view);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 6cb3473190db..73a7179f7031 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -674,6 +674,25 @@ static int handle_vcpu_get_ept_view(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, 0, &rpl, sizeof(rpl));
 }
 
+static int handle_vcpu_set_ept_view(const struct kvmi_vcpu_msg_job *job,
+				    const struct kvmi_msg_hdr *msg,
+				    const void *_req)
+{
+	const struct kvmi_vcpu_set_ept_view *req = _req;
+	int ec;
+
+	if (req->padding1 || req->padding2)
+		ec = -KVM_EINVAL;
+	else if (!is_valid_view(req->view))
+		ec = -KVM_EINVAL;
+	else if (!kvm_eptp_switching_supported)
+		ec = -KVM_EOPNOTSUPP;
+	else
+		ec = kvmi_arch_cmd_set_ept_view(job->vcpu, req->view);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 /*
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -695,6 +714,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 	[KVMI_VCPU_GET_XCR]            = handle_vcpu_get_xcr,
 	[KVMI_VCPU_GET_XSAVE]          = handle_vcpu_get_xsave,
 	[KVMI_VCPU_INJECT_EXCEPTION]   = handle_vcpu_inject_exception,
+	[KVMI_VCPU_SET_EPT_VIEW]       = handle_vcpu_set_ept_view,
 	[KVMI_VCPU_SET_REGISTERS]      = handle_vcpu_set_registers,
 	[KVMI_VCPU_SET_XSAVE]          = handle_vcpu_set_xsave,
 	[KVMI_VCPU_TRANSLATE_GVA]      = handle_vcpu_translate_gva,
