Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442FD2D1B25
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727383AbgLGUsg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:36 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42576 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727364AbgLGUsf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:35 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9C6E7305D476;
        Mon,  7 Dec 2020 22:46:21 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 755F93072785;
        Mon,  7 Dec 2020 22:46:21 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marian Rotariu <marian.c.rotariu@gmail.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 55/81] KVM: introspection: add KVMI_VCPU_GET_CPUID
Date:   Mon,  7 Dec 2020 22:45:56 +0200
Message-Id: <20201207204622.15258-56-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
 arch/x86/kvm/kvmi_msg.c                       | 26 ++++++++++++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 30 ++++++++++++++++
 5 files changed, 105 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 178832304458..10966430621c 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -630,6 +630,42 @@ currently being handled is replied to.
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
index 11835bf9bdc6..3631da9eef8c 100644
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
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index 8ff3aa936ccd..c2fcfba9f315 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -6,6 +6,7 @@
  *
  */
 
+#include "cpuid.h"
 #include "../../../virt/kvm/introspection/kvmi_int.h"
 #include "kvmi.h"
 
@@ -110,7 +111,32 @@ static int handle_vcpu_set_registers(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_get_cpuid(const struct kvmi_vcpu_msg_job *job,
+				 const struct kvmi_msg_hdr *msg,
+				 const void *_req)
+{
+	const struct kvmi_vcpu_get_cpuid *req = _req;
+	struct kvmi_vcpu_get_cpuid_reply rpl;
+	struct kvm_cpuid_entry2 *entry;
+	int ec = 0;
+
+	entry = kvm_find_cpuid_entry(job->vcpu, req->function, req->index);
+	if (!entry) {
+		ec = -KVM_ENOENT;
+	} else {
+		memset(&rpl, 0, sizeof(rpl));
+
+		rpl.eax = entry->eax;
+		rpl.ebx = entry->ebx;
+		rpl.ecx = entry->ecx;
+		rpl.edx = entry->edx;
+	}
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, &rpl, sizeof(rpl));
+}
+
 static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
+	[KVMI_VCPU_GET_CPUID]     = handle_vcpu_get_cpuid,
 	[KVMI_VCPU_GET_INFO]      = handle_vcpu_get_info,
 	[KVMI_VCPU_GET_REGISTERS] = handle_vcpu_get_registers,
 	[KVMI_VCPU_SET_REGISTERS] = handle_vcpu_set_registers,
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 4b756d388ad3..2c93a36bfa43 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -39,6 +39,7 @@ enum {
 	KVMI_VCPU_CONTROL_EVENTS = KVMI_VCPU_MESSAGE_ID(2),
 	KVMI_VCPU_GET_REGISTERS  = KVMI_VCPU_MESSAGE_ID(3),
 	KVMI_VCPU_SET_REGISTERS  = KVMI_VCPU_MESSAGE_ID(4),
+	KVMI_VCPU_GET_CPUID      = KVMI_VCPU_MESSAGE_ID(5),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 311a050c26c1..542b59466d12 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -948,6 +948,35 @@ static void test_cmd_vcpu_set_registers(struct kvm_vm *vm)
 	wait_vcpu_worker(vcpu_thread);
 }
 
+static void cmd_vcpu_get_cpuid(struct kvm_vm *vm,
+			       __u32 function, __u32 index,
+			       struct kvmi_vcpu_get_cpuid_reply *rpl)
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
+	test_vcpu0_command(vm, KVMI_VCPU_GET_CPUID, &req.hdr, sizeof(req),
+			   rpl, sizeof(*rpl), 0);
+}
+
+static void test_cmd_vcpu_get_cpuid(struct kvm_vm *vm)
+{
+	struct kvmi_vcpu_get_cpuid_reply rpl = {};
+	__u32 function = 0;
+	__u32 index = 0;
+
+	cmd_vcpu_get_cpuid(vm, function, index, &rpl);
+
+	pr_debug("cpuid(%u, %u) => eax 0x%.8x, ebx 0x%.8x, ecx 0x%.8x, edx 0x%.8x\n",
+	      function, index, rpl.eax, rpl.ebx, rpl.ecx, rpl.edx);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -967,6 +996,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_control_events(vm);
 	test_cmd_vcpu_get_registers(vm);
 	test_cmd_vcpu_set_registers(vm);
+	test_cmd_vcpu_get_cpuid(vm);
 
 	unhook_introspection(vm);
 }
