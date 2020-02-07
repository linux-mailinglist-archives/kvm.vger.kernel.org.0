Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7901155D9C
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbgBGSRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:21 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40646 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727582AbgBGSQz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:55 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 9D0EC305D35F;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 91A553052066;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 65/78] KVM: introspection: add KVMI_VCPU_GET_XSAVE
Date:   Fri,  7 Feb 2020 20:16:23 +0200
Message-Id: <20200207181636.1065-66-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This vCPU command is used to get the XSAVE area.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 31 +++++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              |  4 +++
 arch/x86/kvm/kvmi.c                           | 21 +++++++++++++
 include/uapi/linux/kvmi.h                     |  2 ++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 21 +++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  4 +++
 virt/kvm/introspection/kvmi_msg.c             | 17 ++++++++++
 7 files changed, 100 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 8b43e0f80f77..5d2b828f2159 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -756,6 +756,37 @@ memory slots allocated by KVM, considering all address spaces indicated
 by KVM_ADDRESS_SPACE_NUM. Stricly speaking, the returned value refers
 to the first inaccessible GFN, next to the maximum accessible GFN.
 
+17. KVMI_VCPU_GET_XSAVE
+-----------------------
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
+	struct kvmi_vcpu_get_xsave_reply {
+		__u32 region[0];
+	};
+
+Returns a buffer containing the XSAVE area. Currently, the size of
+``kvm_xsave`` is used, but it could change. The userspace should get
+the buffer size from the message size.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_ENOMEM - not enough memory to allocate the reply
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 06f69cfa3d79..68ad3d737d7e 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -97,4 +97,8 @@ struct kvmi_vcpu_inject_exception {
 	__u64 address;
 };
 
+struct kvmi_vcpu_get_xsave_reply {
+	__u32 region[0];
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index ac493fcebb5b..f8fd8ce140c5 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -616,3 +616,24 @@ void kvmi_arch_inject_pending_exception(struct kvm_vcpu *vcpu)
 
 	kvmi_save_injected_event(vcpu);
 }
+
+int kvmi_arch_cmd_vcpu_get_xsave(struct kvm_vcpu *vcpu,
+				 struct kvmi_vcpu_get_xsave_reply **dest,
+				 size_t *dest_size)
+{
+	struct kvmi_vcpu_get_xsave_reply *rpl = NULL;
+	size_t rpl_size = sizeof(*rpl) + sizeof(struct kvm_xsave);
+	struct kvm_xsave *area;
+
+	rpl = kvmi_msg_alloc_check(rpl_size);
+	if (!rpl)
+		return -KVM_ENOMEM;
+
+	area = (struct kvm_xsave *) &rpl->region[0];
+	kvm_vcpu_ioctl_x86_get_xsave(vcpu, area);
+
+	*dest = rpl;
+	*dest_size = rpl_size;
+
+	return 0;
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 3ea4882ac469..bc63c04a543d 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -37,6 +37,8 @@ enum {
 
 	KVMI_VM_GET_MAX_GFN = 17,
 
+	KVMI_VCPU_GET_XSAVE = 18,
+
 	KVMI_NUM_MESSAGES
 };
 
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 299f4d29d0d6..638491f33138 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1322,6 +1322,26 @@ static void test_event_xsetbv(struct kvm_vm *vm)
 	disable_vcpu_event(vm, event_id);
 }
 
+static void test_cmd_vcpu_get_xsave(struct kvm_vm *vm)
+{
+	struct kvm_cpuid_entry2 *entry;
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+	} req = {};
+	struct kvm_xsave rpl;
+
+	entry = kvm_get_supported_cpuid_entry(1);
+	if (!(entry->ecx & X86_FEATURE_XSAVE)) {
+		DEBUG("XSAVE is not supported, ecx 0x%x, skipping xsave test\n",
+			entry->ecx);
+		return;
+	}
+
+	test_vcpu0_command(vm, KVMI_VCPU_GET_XSAVE, &req.hdr, sizeof(req),
+			   &rpl, sizeof(rpl));
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -1347,6 +1367,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_inject_exception(vm);
 	test_cmd_vm_get_max_gfn();
 	test_event_xsetbv(vm);
+	test_cmd_vcpu_get_xsave(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 5a00e38c88cc..5e1231f09440 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -47,6 +47,7 @@
 			| BIT(KVMI_VCPU_CONTROL_EVENTS) \
 			| BIT(KVMI_VCPU_GET_CPUID) \
 			| BIT(KVMI_VCPU_GET_REGISTERS) \
+			| BIT(KVMI_VCPU_GET_XSAVE) \
 			| BIT(KVMI_VCPU_INJECT_EXCEPTION) \
 			| BIT(KVMI_VCPU_SET_REGISTERS) \
 		)
@@ -135,5 +136,8 @@ int kvmi_arch_cmd_vcpu_inject_exception(struct kvm_vcpu *vcpu, u8 vector,
 					u32 error_code, u64 address);
 void kvmi_arch_trap_event(struct kvm_vcpu *vcpu);
 void kvmi_arch_inject_pending_exception(struct kvm_vcpu *vcpu);
+int kvmi_arch_cmd_vcpu_get_xsave(struct kvm_vcpu *vcpu,
+				 struct kvmi_vcpu_get_xsave_reply **dest,
+				 size_t *dest_size);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index ba2d7c6acb22..1639f5eab68b 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -31,6 +31,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VCPU_GET_CPUID]        = "KVMI_VCPU_GET_CPUID",
 	[KVMI_VCPU_GET_INFO]         = "KVMI_VCPU_GET_INFO",
 	[KVMI_VCPU_GET_REGISTERS]    = "KVMI_VCPU_GET_REGISTERS",
+	[KVMI_VCPU_GET_XSAVE]        = "KVMI_VCPU_GET_XSAVE",
 	[KVMI_VCPU_INJECT_EXCEPTION] = "KVMI_VCPU_INJECT_EXCEPTION",
 	[KVMI_VCPU_PAUSE]            = "KVMI_VCPU_PAUSE",
 	[KVMI_VCPU_SET_REGISTERS]    = "KVMI_VCPU_SET_REGISTERS",
@@ -526,6 +527,21 @@ static int handle_vcpu_inject_exception(const struct kvmi_vcpu_cmd_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_get_xsave(const struct kvmi_vcpu_cmd_job *job,
+				 const struct kvmi_msg_hdr *msg,
+				 const void *req)
+{
+	struct kvmi_vcpu_get_xsave_reply *rpl = NULL;
+	size_t rpl_size = 0;
+	int err, ec;
+
+	ec = kvmi_arch_cmd_vcpu_get_xsave(job->vcpu, &rpl, &rpl_size);
+
+	err = kvmi_msg_vcpu_reply(job, msg, ec, rpl, rpl_size);
+	kvmi_msg_free(rpl);
+	return err;
+}
+
 /*
  * These commands are executed on the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -540,6 +556,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 	[KVMI_VCPU_GET_CPUID]        = handle_get_cpuid,
 	[KVMI_VCPU_GET_INFO]         = handle_get_vcpu_info,
 	[KVMI_VCPU_GET_REGISTERS]    = handle_get_registers,
+	[KVMI_VCPU_GET_XSAVE]        = handle_vcpu_get_xsave,
 	[KVMI_VCPU_INJECT_EXCEPTION] = handle_vcpu_inject_exception,
 	[KVMI_VCPU_SET_REGISTERS]    = handle_set_registers,
 };
