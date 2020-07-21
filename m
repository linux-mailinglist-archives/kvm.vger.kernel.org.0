Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6626E228AE6
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731474AbgGUVR7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:59 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37848 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731254AbgGUVQE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:04 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 8138B305D500;
        Wed, 22 Jul 2020 00:09:30 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 57198304FA14;
        Wed, 22 Jul 2020 00:09:30 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <ncitu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 72/84] KVM: introspection: add KVMI_VCPU_GET_MTRR_TYPE
Date:   Wed, 22 Jul 2020 00:09:10 +0300
Message-Id: <20200721210922.7646-73-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
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
 include/uapi/linux/kvmi.h                     |  7 ++--
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 19 +++++++++++
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 16 ++++++++++
 7 files changed, 88 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 24605aaede9a..6de260c09f3b 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -902,6 +902,38 @@ Modifies the XSAVE area.
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+21. KVMI_VCPU_GET_MTRR_TYPE
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
index 71206206973c..33edbb5b32f4 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -107,4 +107,13 @@ struct kvmi_vcpu_set_xsave {
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
index 0776be48ada1..80ad67e875c4 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -784,3 +784,10 @@ int kvmi_arch_cmd_vcpu_set_xsave(struct kvm_vcpu *vcpu,
 
 	return err ? -KVM_EINVAL : 0;
 }
+
+int kvmi_arch_cmd_vcpu_get_mtrr_type(struct kvm_vcpu *vcpu, u64 gpa, u8 *type)
+{
+	*type = kvm_mtrr_get_guest_memory_type(vcpu, gpa_to_gfn(gpa));
+
+	return 0;
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 441586cec238..207bcaeec05a 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -39,9 +39,10 @@ enum {
 
 	KVMI_VM_GET_MAX_GFN = 17,
 
-	KVMI_VCPU_GET_XCR = 18,
-	KVMI_VCPU_GET_XSAVE = 19,
-	KVMI_VCPU_SET_XSAVE = 20,
+	KVMI_VCPU_GET_XCR       = 18,
+	KVMI_VCPU_GET_XSAVE     = 19,
+	KVMI_VCPU_SET_XSAVE     = 20,
+	KVMI_VCPU_GET_MTRR_TYPE = 21,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 30741983a3ab..7174e464d759 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1599,6 +1599,24 @@ static void test_cmd_vcpu_xsave(struct kvm_vm *vm)
 	cmd_vcpu_set_xsave(vm, &xsave);
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
+	pr_info("mtrr_type: gpa 0x%lx type 0x%x\n", test_gpa, rpl.type);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1628,6 +1646,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_xsetbv(vm);
 	test_cmd_vcpu_get_xcr(vm);
 	test_cmd_vcpu_xsave(vm);
+	test_cmd_vcpu_get_mtrr_type(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index f358ef1c0c73..a9664d255d6d 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -114,5 +114,6 @@ int kvmi_arch_cmd_vcpu_get_xsave(struct kvm_vcpu *vcpu,
 int kvmi_arch_cmd_vcpu_set_xsave(struct kvm_vcpu *vcpu,
 				 const struct kvmi_vcpu_set_xsave *req,
 				 size_t req_size);
+int kvmi_arch_cmd_vcpu_get_mtrr_type(struct kvm_vcpu *vcpu, u64 gpa, u8 *type);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index c8fe55c3d5c7..36819b54b3a0 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -569,6 +569,21 @@ static int handle_vcpu_set_xsave(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_get_mtrr_type(const struct kvmi_vcpu_msg_job *job,
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
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -582,6 +597,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 	[KVMI_VCPU_CONTROL_EVENTS]   = handle_vcpu_control_events,
 	[KVMI_VCPU_GET_CPUID]        = handle_vcpu_get_cpuid,
 	[KVMI_VCPU_GET_INFO]         = handle_vcpu_get_info,
+	[KVMI_VCPU_GET_MTRR_TYPE]    = handle_vcpu_get_mtrr_type,
 	[KVMI_VCPU_GET_REGISTERS]    = handle_vcpu_get_registers,
 	[KVMI_VCPU_GET_XCR]          = handle_vcpu_get_xcr,
 	[KVMI_VCPU_GET_XSAVE]        = handle_vcpu_get_xsave,
