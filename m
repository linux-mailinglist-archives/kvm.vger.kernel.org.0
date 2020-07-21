Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C227A228AF3
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731247AbgGUVS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:18:27 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37846 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731206AbgGUVQA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 0E32E305D4FD;
        Wed, 22 Jul 2020 00:09:30 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id E52B7304FA15;
        Wed, 22 Jul 2020 00:09:29 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 69/84] KVM: introspection: add KVMI_VCPU_GET_XCR
Date:   Wed, 22 Jul 2020 00:09:07 +0300
Message-Id: <20200721210922.7646-70-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This can be used by the introspection tool to emulate SSE instructions.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 33 ++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              |  9 +++++
 arch/x86/kvm/kvmi.c                           | 17 +++++++++
 include/uapi/linux/kvmi.h                     |  2 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 38 +++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  3 ++
 virt/kvm/introspection/kvmi_msg.c             | 15 ++++++++
 7 files changed, 117 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 283e9a2dfda1..1fdb73c6a6ff 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -809,6 +809,39 @@ Provides the maximum GFN allocated to the VM by walking through all
 memory slots allocated by KVM. Stricly speaking, the returned value refers
 to the first inaccessible GFN, next to the maximum accessible GFN.
 
+18. KVMI_VCPU_GET_XCR
+---------------------
+
+:Architecture: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_get_xcr {
+		__u8 xcr;
+		__u8 padding[7];
+	};
+
+:Returns:
+
+::
+
+        struct kvmi_error_code;
+	struct kvmi_vcpu_get_xcr_reply {
+		u64 value;
+	};
+
+Returns the value of an extended control register XCR.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the specified control register is not XCR0
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 2f69a4f5d2e0..cc4cb85366c8 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -90,4 +90,13 @@ struct kvmi_event_xsetbv {
 	__u64 new_value;
 };
 
+struct kvmi_vcpu_get_xcr {
+	__u8 xcr;
+	__u8 padding[7];
+};
+
+struct kvmi_vcpu_get_xcr_reply {
+	u64 value;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 55c5e290730c..ff70c9a33ccf 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -720,3 +720,20 @@ void kvmi_xsetbv_event(struct kvm_vcpu *vcpu, u8 xcr,
 
 	kvmi_put(vcpu->kvm);
 }
+
+int kvmi_arch_cmd_vcpu_get_xcr(struct kvm_vcpu *vcpu,
+			       const struct kvmi_vcpu_get_xcr *req,
+			       struct kvmi_vcpu_get_xcr_reply *rpl)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(req->padding); i++)
+		if (req->padding[i])
+			return -KVM_EINVAL;
+
+	if (req->xcr != 0)
+		return -KVM_EINVAL;
+
+	rpl->value = vcpu->arch.xcr0;
+	return 0;
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 348a9a551091..d1c564ff3d6c 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -39,6 +39,8 @@ enum {
 
 	KVMI_VM_GET_MAX_GFN = 17,
 
+	KVMI_VCPU_GET_XCR = 18,
+
 	KVMI_NUM_MESSAGES
 };
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 0569185a7064..8b92ff7cee6b 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1514,6 +1514,43 @@ static void test_event_xsetbv(struct kvm_vm *vm)
 	disable_vcpu_event(vm, event_id);
 }
 
+static void cmd_vcpu_get_xcr(struct kvm_vm *vm, u8 xcr, u64 *value,
+			     u8 padding, int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_get_xcr cmd;
+	} req = { 0 };
+	struct kvmi_vcpu_get_xcr_reply rpl = { 0 };
+	int r;
+
+	req.cmd.xcr = xcr;
+	req.cmd.padding[6] = padding;
+
+	r = do_vcpu0_command(vm, KVMI_VCPU_GET_XCR, &req.hdr, sizeof(req),
+			     &rpl, sizeof(rpl));
+
+	TEST_ASSERT(r == expected_err,
+		    "KVMI_VCPU_GET_XCR failed with error %d (%s), expected err %d\n",
+		    -r, kvm_strerror(-r), expected_err);
+
+	*value = r == 0 ? rpl.value : 0;
+}
+
+static void test_cmd_vcpu_get_xcr(struct kvm_vm *vm)
+{
+	u8 no_padding = 0, padding = 1;
+	u8 xcr0 = 0, xcr1 = 1;
+	u64 value;
+
+	cmd_vcpu_get_xcr(vm, xcr0, &value, no_padding, 0);
+	pr_info("XCR0 0x%lx\n", value);
+
+	cmd_vcpu_get_xcr(vm, xcr0, &value, padding, -KVM_EINVAL);
+	cmd_vcpu_get_xcr(vm, xcr1, &value, no_padding, -KVM_EINVAL);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1541,6 +1578,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_inject_exception(vm);
 	test_cmd_vm_get_max_gfn();
 	test_event_xsetbv(vm);
+	test_cmd_vcpu_get_xcr(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 51c03097a7d5..0b84ac365ae7 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -105,5 +105,8 @@ int kvmi_arch_cmd_vcpu_inject_exception(struct kvm_vcpu *vcpu, u8 vector,
 					u32 error_code, u64 address);
 void kvmi_arch_send_trap_event(struct kvm_vcpu *vcpu);
 void kvmi_arch_inject_exception(struct kvm_vcpu *vcpu);
+int kvmi_arch_cmd_vcpu_get_xcr(struct kvm_vcpu *vcpu,
+			       const struct kvmi_vcpu_get_xcr *req,
+			       struct kvmi_vcpu_get_xcr_reply *rpl);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 18bc1a711845..aa4fb202115e 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -524,6 +524,20 @@ static int handle_vcpu_inject_exception(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_get_xcr(const struct kvmi_vcpu_msg_job *job,
+			       const struct kvmi_msg_hdr *msg,
+			       const void *req)
+{
+	struct kvmi_vcpu_get_xcr_reply rpl;
+	int ec;
+
+	memset(&rpl, 0, sizeof(rpl));
+
+	ec = kvmi_arch_cmd_vcpu_get_xcr(job->vcpu, req, &rpl);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, &rpl, sizeof(rpl));
+}
+
 /*
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -538,6 +552,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 	[KVMI_VCPU_GET_CPUID]        = handle_vcpu_get_cpuid,
 	[KVMI_VCPU_GET_INFO]         = handle_vcpu_get_info,
 	[KVMI_VCPU_GET_REGISTERS]    = handle_vcpu_get_registers,
+	[KVMI_VCPU_GET_XCR]          = handle_vcpu_get_xcr,
 	[KVMI_VCPU_INJECT_EXCEPTION] = handle_vcpu_inject_exception,
 	[KVMI_VCPU_SET_REGISTERS]    = handle_vcpu_set_registers,
 };
