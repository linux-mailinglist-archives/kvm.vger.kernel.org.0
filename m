Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51038197917
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729618AbgC3KVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:21:21 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43750 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729472AbgC3KT7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:19:59 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 67484305D495;
        Mon, 30 Mar 2020 13:13:00 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 369C9305B7A0;
        Mon, 30 Mar 2020 13:13:00 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 69/81] KVM: introspection: add KVMI_VCPU_GET_MTRR_TYPE
Date:   Mon, 30 Mar 2020 13:12:56 +0300
Message-Id: <20200330101308.21702-70-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This command returns the memory type for a guest physical address.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Nicușor Cîțu <ncitu@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 32 +++++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              |  9 ++++++
 arch/x86/kvm/kvmi.c                           |  7 ++++
 include/uapi/linux/kvmi.h                     |  3 +-
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 19 +++++++++++
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 17 ++++++++++
 7 files changed, 87 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index e1be8d63bfcd..9d37030213a6 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -808,6 +808,38 @@ the buffer size from the message size (kvmi_msg_hdr.size).
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - there is not enough memory to allocate the reply
 
+18. KVMI_VCPU_GET_MTRR_TYPE
+---------------------------
+
+:Architecture: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_get_mtrr_type {
+		__u64 gpa;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	struct kvmi_vcpu_get_mtrr_type_reply {
+		__u8 type;
+		__u8 padding[7];
+	};
+
+Returns the guest memory type for a specific physical address.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 39812e93c9c1..d622c89a4f2c 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -101,4 +101,13 @@ struct kvmi_vcpu_get_xsave_reply {
 	__u32 region[0];
 };
 
+struct kvmi_vcpu_get_mtrr_type {
+	__u64 gpa;
+};
+
+struct kvmi_vcpu_get_mtrr_type_reply {
+	__u8 type;
+	__u8 padding[7];
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 348583d8237f..3de7e98fa426 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -722,3 +722,10 @@ int kvmi_arch_cmd_vcpu_get_xsave(struct kvm_vcpu *vcpu,
 
 	return 0;
 }
+
+int kvmi_arch_cmd_vcpu_get_mtrr_type(struct kvm_vcpu *vcpu, u64 gpa, u8 *type)
+{
+	*type = kvm_mtrr_get_guest_memory_type(vcpu, gpa_to_gfn(gpa));
+
+	return 0;
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index b3008f96dd06..0827bd90691b 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -36,7 +36,8 @@ enum {
 
 	KVMI_VM_GET_MAX_GFN = 17,
 
-	KVMI_VCPU_GET_XSAVE = 18,
+	KVMI_VCPU_GET_XSAVE     = 18,
+	KVMI_VCPU_GET_MTRR_TYPE = 19,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 4aa033a2b18b..b984c3704baf 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1345,6 +1345,24 @@ static void test_cmd_vcpu_get_xsave(struct kvm_vm *vm)
 			   &rpl, sizeof(rpl));
 }
 
+static void test_cmd_vcpu_get_mtrr_type(struct kvm_vm *vm)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_get_mtrr_type cmd;
+	} req = {};
+	struct kvmi_vcpu_get_mtrr_type_reply rpl;
+
+	req.cmd.gpa = test_gpa;
+
+	test_vcpu0_command(vm, KVMI_VCPU_GET_MTRR_TYPE,
+			   &req.hdr, sizeof(req),
+			   &rpl, sizeof(rpl));
+
+	DEBUG("mtrr_type: gpa 0x%lx type 0x%x\n", test_gpa, rpl.type);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1372,6 +1390,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_get_max_gfn();
 	test_event_xsetbv(vm);
 	test_cmd_vcpu_get_xsave(vm);
+	test_cmd_vcpu_get_mtrr_type(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 907751bbf596..72c9d3a1a4b6 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -106,5 +106,6 @@ void kvmi_arch_inject_exception(struct kvm_vcpu *vcpu);
 int kvmi_arch_cmd_vcpu_get_xsave(struct kvm_vcpu *vcpu,
 				 struct kvmi_vcpu_get_xsave_reply **dest,
 				 size_t *dest_size);
+int kvmi_arch_cmd_vcpu_get_mtrr_type(struct kvm_vcpu *vcpu, u64 gpa, u8 *type);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 9bc648b2eb08..78ae52f05c29 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -33,6 +33,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VCPU_CONTROL_EVENTS]   = "KVMI_VCPU_CONTROL_EVENTS",
 	[KVMI_VCPU_GET_CPUID]        = "KVMI_VCPU_GET_CPUID",
 	[KVMI_VCPU_GET_INFO]         = "KVMI_VCPU_GET_INFO",
+	[KVMI_VCPU_GET_MTRR_TYPE]    = "KVMI_VCPU_GET_MTRR_TYPE",
 	[KVMI_VCPU_GET_REGISTERS]    = "KVMI_VCPU_GET_REGISTERS",
 	[KVMI_VCPU_GET_XSAVE]        = "KVMI_VCPU_GET_XSAVE",
 	[KVMI_VCPU_INJECT_EXCEPTION] = "KVMI_VCPU_INJECT_EXCEPTION",
@@ -576,6 +577,21 @@ static int handle_vcpu_get_xsave(const struct kvmi_vcpu_cmd_job *job,
 	return err;
 }
 
+static int handle_vcpu_get_mtrr_type(const struct kvmi_vcpu_cmd_job *job,
+				     const struct kvmi_msg_hdr *msg,
+				     const void *_req)
+{
+	const struct kvmi_vcpu_get_mtrr_type *req = _req;
+	struct kvmi_vcpu_get_mtrr_type_reply rpl;
+	int ec;
+
+	memset(&rpl, 0, sizeof(rpl));
+
+	ec = kvmi_arch_cmd_vcpu_get_mtrr_type(job->vcpu, req->gpa, &rpl.type);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, &rpl, sizeof(rpl));
+}
+
 /*
  * These commands are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -589,6 +605,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 	[KVMI_VCPU_CONTROL_EVENTS]   = handle_vcpu_control_events,
 	[KVMI_VCPU_GET_CPUID]        = handle_get_cpuid,
 	[KVMI_VCPU_GET_INFO]         = handle_get_vcpu_info,
+	[KVMI_VCPU_GET_MTRR_TYPE]    = handle_vcpu_get_mtrr_type,
 	[KVMI_VCPU_GET_REGISTERS]    = handle_get_registers,
 	[KVMI_VCPU_GET_XSAVE]        = handle_vcpu_get_xsave,
 	[KVMI_VCPU_INJECT_EXCEPTION] = handle_vcpu_inject_exception,
