Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C363155D86
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgBGSQy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:16:54 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40748 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727671AbgBGSQw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:52 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 193CC305D356;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 0CF17305206F;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 56/78] KVM: introspection: add KVMI_VCPU_GET_CPUID
Date:   Fri,  7 Feb 2020 20:16:14 +0200
Message-Id: <20200207181636.1065-57-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marian Rotariu <marian.c.rotariu@gmail.com>

This command returns a CPUID leaf (as seen by the guest OS).

Signed-off-by: Marian Rotariu <marian.c.rotariu@gmail.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 36 +++++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              | 12 +++++++
 arch/x86/kvm/kvmi.c                           | 19 ++++++++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 34 ++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  4 +++
 virt/kvm/introspection/kvmi_msg.c             | 16 +++++++++
 7 files changed, 122 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index ff1fe5ec2e18..f9f961509c61 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -618,6 +618,42 @@ currently being handled is replied to.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_EOPNOTSUPP - the command hasn't been received during an introspection event
 
+13. KVMI_VCPU_GET_CPUID
+-----------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_get_cpuid {
+		__u32 function;
+		__u32 index;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	struct kvmi_vcpu_get_cpuid_reply {
+		__u32 eax;
+		__u32 ebx;
+		__u32 ecx;
+		__u32 edx;
+	};
+
+Returns a CPUID leaf (as seen by the guest OS).
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_ENOENT - the selected leaf is not present or is invalid
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index f14674c3c109..57c48ace417f 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -45,4 +45,16 @@ struct kvmi_vcpu_get_registers_reply {
 	struct kvm_msrs msrs;
 };
 
+struct kvmi_vcpu_get_cpuid {
+	__u32 function;
+	__u32 index;
+};
+
+struct kvmi_vcpu_get_cpuid_reply {
+	__u32 eax;
+	__u32 ebx;
+	__u32 ecx;
+	__u32 edx;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 67cf2d19ba0f..bba85f333639 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -7,6 +7,7 @@
 
 #include "linux/kvm_host.h"
 #include "x86.h"
+#include "cpuid.h"
 #include "../../../virt/kvm/introspection/kvmi_int.h"
 
 static unsigned int kvmi_vcpu_mode(const struct kvm_vcpu *vcpu,
@@ -140,3 +141,21 @@ int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
 	return err;
 
 }
+
+int kvmi_arch_cmd_vcpu_get_cpuid(struct kvm_vcpu *vcpu,
+				 const struct kvmi_vcpu_get_cpuid *req,
+				 struct kvmi_vcpu_get_cpuid_reply *rpl)
+{
+	struct kvm_cpuid_entry2 *e;
+
+	e = kvm_find_cpuid_entry(vcpu, req->function, req->index);
+	if (!e)
+		return -KVM_ENOENT;
+
+	rpl->eax = e->eax;
+	rpl->ebx = e->ebx;
+	rpl->ecx = e->ecx;
+	rpl->edx = e->edx;
+
+	return 0;
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 4d5f6317db03..05535a7d9313 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -31,6 +31,7 @@ enum {
 	KVMI_VCPU_CONTROL_EVENTS = 11,
 	KVMI_VCPU_GET_REGISTERS  = 12,
 	KVMI_VCPU_SET_REGISTERS  = 13,
+	KVMI_VCPU_GET_CPUID      = 14,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 6e4490340b36..fa23ca0ed0d7 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -909,6 +909,39 @@ static void test_cmd_vcpu_set_registers(struct kvm_vm *vm)
 	disable_vcpu_event(vm, event_id);
 }
 
+static int cmd_get_cpuid(struct kvm_vm *vm,
+			 __u32 function, __u32 index,
+			 struct kvmi_vcpu_get_cpuid_reply *rpl)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_get_cpuid cmd;
+	} req = {};
+
+	req.cmd.function = function;
+	req.cmd.index = index;
+
+	return do_vcpu0_command(vm, KVMI_VCPU_GET_CPUID, &req.hdr, sizeof(req),
+				rpl, sizeof(*rpl));
+}
+
+static void test_cmd_vcpu_get_cpuid(struct kvm_vm *vm)
+{
+	struct kvmi_vcpu_get_cpuid_reply rpl = {};
+	__u32 function = 0;
+	__u32 index = 0;
+	int r;
+
+	r = cmd_get_cpuid(vm, function, index, &rpl);
+	TEST_ASSERT(r == 0,
+		"KVMI_VCPU_GET_CPUID failed, error %d(%s)\n",
+		-r, kvm_strerror(-r));
+
+	DEBUG("cpuid(%u, %u) => eax 0x%.8x, ebx 0x%.8x, ecx 0x%.8x, edx 0x%.8x\n",
+	      function, index, rpl.eax, rpl.ebx, rpl.ecx, rpl.edx);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -927,6 +960,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_control_events(vm);
 	test_cmd_vcpu_get_registers(vm);
 	test_cmd_vcpu_set_registers(vm);
+	test_cmd_vcpu_get_cpuid(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index a736f364f5be..1b3d8958e6c8 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -38,6 +38,7 @@
 			| BIT(KVMI_VCPU_GET_INFO) \
 			| BIT(KVMI_VCPU_PAUSE) \
 			| BIT(KVMI_VCPU_CONTROL_EVENTS) \
+			| BIT(KVMI_VCPU_GET_CPUID) \
 			| BIT(KVMI_VCPU_GET_REGISTERS) \
 			| BIT(KVMI_VCPU_SET_REGISTERS) \
 		)
@@ -92,5 +93,8 @@ int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
 				const struct kvmi_vcpu_get_registers *req,
 				struct kvmi_vcpu_get_registers_reply **dest,
 				size_t *dest_size);
+int kvmi_arch_cmd_vcpu_get_cpuid(struct kvm_vcpu *vcpu,
+				 const struct kvmi_vcpu_get_cpuid *req,
+				 struct kvmi_vcpu_get_cpuid_reply *rpl);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 11e0171076c7..11873cb3c23b 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -26,6 +26,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VM_READ_PHYSICAL]    = "KVMI_VM_READ_PHYSICAL",
 	[KVMI_VM_WRITE_PHYSICAL]   = "KVMI_VM_WRITE_PHYSICAL",
 	[KVMI_VCPU_CONTROL_EVENTS] = "KVMI_VCPU_CONTROL_EVENTS",
+	[KVMI_VCPU_GET_CPUID]      = "KVMI_VCPU_GET_CPUID",
 	[KVMI_VCPU_GET_INFO]       = "KVMI_VCPU_GET_INFO",
 	[KVMI_VCPU_GET_REGISTERS]  = "KVMI_VCPU_GET_REGISTERS",
 	[KVMI_VCPU_PAUSE]          = "KVMI_VCPU_PAUSE",
@@ -464,6 +465,20 @@ static int handle_set_registers(const struct kvmi_vcpu_cmd_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_get_cpuid(const struct kvmi_vcpu_cmd_job *job,
+			    const struct kvmi_msg_hdr *msg,
+			    const void *req)
+{
+	struct kvmi_vcpu_get_cpuid_reply rpl;
+	int ec;
+
+	memset(&rpl, 0, sizeof(rpl));
+
+	ec = kvmi_arch_cmd_vcpu_get_cpuid(job->vcpu, req, &rpl);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, &rpl, sizeof(rpl));
+}
+
 /*
  * These commands are executed on the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -474,6 +489,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
 	[KVMI_EVENT_REPLY]         = handle_event_reply,
 	[KVMI_VCPU_CONTROL_EVENTS] = handle_vcpu_control_events,
+	[KVMI_VCPU_GET_CPUID]      = handle_get_cpuid,
 	[KVMI_VCPU_GET_INFO]       = handle_get_vcpu_info,
 	[KVMI_VCPU_GET_REGISTERS]  = handle_get_registers,
 	[KVMI_VCPU_SET_REGISTERS]  = handle_set_registers,
