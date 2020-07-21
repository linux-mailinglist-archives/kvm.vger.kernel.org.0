Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33239228AF2
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731212AbgGUVS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:18:27 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37924 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731224AbgGUVQB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:01 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 521F6305D4F2;
        Wed, 22 Jul 2020 00:09:28 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 2D361304FA13;
        Wed, 22 Jul 2020 00:09:28 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 58/84] KVM: introspection: add KVMI_VCPU_GET_CPUID
Date:   Wed, 22 Jul 2020 00:08:56 +0300
Message-Id: <20200721210922.7646-59-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
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
 virt/kvm/introspection/kvmi_int.h             |  3 ++
 virt/kvm/introspection/kvmi_msg.c             | 15 ++++++++
 7 files changed, 120 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index bd35002c3254..fc2e8c756191 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -641,6 +641,42 @@ currently being handled is replied to.
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
+* -KVM_EINVAL - the padding is not zero
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
index 4fd7a3c17ef5..53c4a37e10c6 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -7,6 +7,7 @@
 
 #include "linux/kvm_host.h"
 #include "x86.h"
+#include "cpuid.h"
 #include "../../../virt/kvm/introspection/kvmi_int.h"
 
 static unsigned int kvmi_vcpu_mode(const struct kvm_vcpu *vcpu,
@@ -191,3 +192,21 @@ int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
 
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
index 5f637a21a907..d7f4360e609e 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -30,6 +30,7 @@ enum {
 	KVMI_VCPU_CONTROL_EVENTS = 10,
 	KVMI_VCPU_GET_REGISTERS  = 11,
 	KVMI_VCPU_SET_REGISTERS  = 12,
+	KVMI_VCPU_GET_CPUID      = 13,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index ffd0337d0567..7269afd4c36d 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1033,6 +1033,39 @@ static void test_cmd_vcpu_set_registers(struct kvm_vm *vm)
 	stop_vcpu_worker(vcpu_thread, &data);
 }
 
+static int cmd_vcpu_get_cpuid(struct kvm_vm *vm,
+			      __u32 function, __u32 index,
+			      struct kvmi_vcpu_get_cpuid_reply *rpl)
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
+	r = cmd_vcpu_get_cpuid(vm, function, index, &rpl);
+	TEST_ASSERT(r == 0,
+		"KVMI_VCPU_GET_CPUID failed, error %d(%s)\n",
+		-r, kvm_strerror(-r));
+
+	pr_info("cpuid(%u, %u) => eax 0x%.8x, ebx 0x%.8x, ecx 0x%.8x, edx 0x%.8x\n",
+	      function, index, rpl.eax, rpl.ebx, rpl.ecx, rpl.edx);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1052,6 +1085,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_control_events(vm);
 	test_cmd_vcpu_get_registers(vm);
 	test_cmd_vcpu_set_registers(vm);
+	test_cmd_vcpu_get_cpuid(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 1d5a07277072..bc8b5c03b057 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -67,5 +67,8 @@ int kvmi_arch_cmd_vcpu_get_registers(struct kvm_vcpu *vcpu,
 				const struct kvmi_vcpu_get_registers *req,
 				struct kvmi_vcpu_get_registers_reply **dest,
 				size_t *dest_size);
+int kvmi_arch_cmd_vcpu_get_cpuid(struct kvm_vcpu *vcpu,
+				 const struct kvmi_vcpu_get_cpuid *req,
+				 struct kvmi_vcpu_get_cpuid_reply *rpl);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index ed43e4d5f5b2..61c96a24a730 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -449,6 +449,20 @@ static int handle_vcpu_set_registers(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_get_cpuid(const struct kvmi_vcpu_msg_job *job,
+				 const struct kvmi_msg_hdr *msg,
+				 const void *req)
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
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -459,6 +473,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 			      const struct kvmi_msg_hdr *, const void *) = {
 	[KVMI_EVENT]               = handle_vcpu_event_reply,
 	[KVMI_VCPU_CONTROL_EVENTS] = handle_vcpu_control_events,
+	[KVMI_VCPU_GET_CPUID]      = handle_vcpu_get_cpuid,
 	[KVMI_VCPU_GET_INFO]       = handle_vcpu_get_info,
 	[KVMI_VCPU_GET_REGISTERS]  = handle_vcpu_get_registers,
 	[KVMI_VCPU_SET_REGISTERS]  = handle_vcpu_set_registers,
