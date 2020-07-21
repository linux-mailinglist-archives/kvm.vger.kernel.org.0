Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D752228A83
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731282AbgGUVQD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:16:03 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37794 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731229AbgGUVQA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:00 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 53376305D4FF;
        Wed, 22 Jul 2020 00:09:30 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 361AA304FA12;
        Wed, 22 Jul 2020 00:09:30 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 71/84] KVM: introspection: add KVMI_VCPU_SET_XSAVE
Date:   Wed, 22 Jul 2020 00:09:09 +0300
Message-Id: <20200721210922.7646-72-alazar@bitdefender.com>
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
 Documentation/virt/kvm/kvmi.rst               | 29 +++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              |  4 +++
 arch/x86/kvm/kvmi.c                           | 23 ++++++++++++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 31 +++++++++++++++----
 virt/kvm/introspection/kvmi_int.h             |  3 ++
 virt/kvm/introspection/kvmi_msg.c             | 17 ++++++++++
 7 files changed, 102 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 9bf8b08eb585..24605aaede9a 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -873,6 +873,35 @@ the buffer size from the message size (kvmi_msg_hdr.size).
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - there is not enough memory to allocate the reply
 
+20. KVMI_VCPU_SET_XSAVE
+-----------------------
+
+:Architecture: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_set_xsave {
+		__u32 region[0];
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+
+Modifies the XSAVE area.
+
+:Errors:
+
+* -KVM_EINVAL - the buffer is larger than ``struct kvm_xsave``
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index a165c259ba0e..71206206973c 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -103,4 +103,8 @@ struct kvmi_vcpu_get_xsave_reply {
 	__u32 region[0];
 };
 
+struct kvmi_vcpu_set_xsave {
+	__u32 region[0];
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 7b7122784f0f..0776be48ada1 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -761,3 +761,26 @@ int kvmi_arch_cmd_vcpu_get_xsave(struct kvm_vcpu *vcpu,
 
 	return 0;
 }
+
+int kvmi_arch_cmd_vcpu_set_xsave(struct kvm_vcpu *vcpu,
+				 const struct kvmi_vcpu_set_xsave *req,
+				 size_t req_size)
+{
+	struct kvm_xsave *area;
+	size_t dest_size = sizeof(*area);
+	int err;
+
+	if (req_size > dest_size)
+		return -KVM_EINVAL;
+
+	area = kzalloc(dest_size, GFP_KERNEL);
+	if (!area)
+		return -KVM_ENOMEM;
+
+	memcpy(area, req, min(req_size, dest_size));
+
+	err = kvm_vcpu_ioctl_x86_set_xsave(vcpu, area);
+	kfree(area);
+
+	return err ? -KVM_EINVAL : 0;
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 6b5662f54ba1..441586cec238 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -41,6 +41,7 @@ enum {
 
 	KVMI_VCPU_GET_XCR = 18,
 	KVMI_VCPU_GET_XSAVE = 19,
+	KVMI_VCPU_SET_XSAVE = 20,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 657684ec6ff5..30741983a3ab 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1551,25 +1551,43 @@ static void test_cmd_vcpu_get_xcr(struct kvm_vm *vm)
 	cmd_vcpu_get_xcr(vm, xcr1, &value, no_padding, -KVM_EINVAL);
 }
 
-static void cmd_vcpu_get_xsave(struct kvm_vm *vm)
+static void cmd_vcpu_get_xsave(struct kvm_vm *vm, struct kvm_xsave *rpl)
 {
 	struct {
 		struct kvmi_msg_hdr hdr;
 		struct kvmi_vcpu_hdr vcpu_hdr;
 	} req = {};
-	struct kvm_xsave rpl;
 	int r;
 
 	r = do_vcpu0_command(vm, KVMI_VCPU_GET_XSAVE, &req.hdr, sizeof(req),
-			     &rpl, sizeof(rpl));
+			     rpl, sizeof(*rpl));
 	TEST_ASSERT(r == 0,
 		    "KVMI_VCPU_GET_XSAVE failed with error %d (%s)\n",
 		    -r, kvm_strerror(-r));
 }
 
-static void test_cmd_vcpu_get_xsave(struct kvm_vm *vm)
+static void cmd_vcpu_set_xsave(struct kvm_vm *vm, struct kvm_xsave *rpl)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvm_xsave xsave;
+	} req = {};
+	int r;
+
+	memcpy(&req.xsave, rpl, sizeof(*rpl));
+
+	r = do_vcpu0_command(vm, KVMI_VCPU_SET_XSAVE, &req.hdr, sizeof(req),
+			     NULL, 0);
+	TEST_ASSERT(r == 0,
+		    "KVMI_VCPU_SET_XSAVE failed with error %d (%s)\n",
+		    -r, kvm_strerror(-r));
+}
+
+static void test_cmd_vcpu_xsave(struct kvm_vm *vm)
 {
 	struct kvm_cpuid_entry2 *entry;
+	struct kvm_xsave xsave;
 
 	entry = kvm_get_supported_cpuid_entry(1);
 	if (!(entry->ecx & X86_FEATURE_XSAVE)) {
@@ -1577,7 +1595,8 @@ static void test_cmd_vcpu_get_xsave(struct kvm_vm *vm)
 		return;
 	}
 
-	cmd_vcpu_get_xsave(vm);
+	cmd_vcpu_get_xsave(vm, &xsave);
+	cmd_vcpu_set_xsave(vm, &xsave);
 }
 
 static void test_introspection(struct kvm_vm *vm)
@@ -1608,7 +1627,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_get_max_gfn();
 	test_event_xsetbv(vm);
 	test_cmd_vcpu_get_xcr(vm);
-	test_cmd_vcpu_get_xsave(vm);
+	test_cmd_vcpu_xsave(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 26fc27f3fddc..f358ef1c0c73 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -111,5 +111,8 @@ int kvmi_arch_cmd_vcpu_get_xcr(struct kvm_vcpu *vcpu,
 int kvmi_arch_cmd_vcpu_get_xsave(struct kvm_vcpu *vcpu,
 				 struct kvmi_vcpu_get_xsave_reply **dest,
 				 size_t *dest_size);
+int kvmi_arch_cmd_vcpu_set_xsave(struct kvm_vcpu *vcpu,
+				 const struct kvmi_vcpu_set_xsave *req,
+				 size_t req_size);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 06a8fbb5c86d..c8fe55c3d5c7 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -553,6 +553,22 @@ static int handle_vcpu_get_xsave(const struct kvmi_vcpu_msg_job *job,
 	return err;
 }
 
+static int handle_vcpu_set_xsave(const struct kvmi_vcpu_msg_job *job,
+				 const struct kvmi_msg_hdr *msg,
+				 const void *req)
+{
+	size_t msg_size = msg->size, xsave_size;
+	int ec;
+
+	if (check_sub_overflow(msg_size, sizeof(struct kvmi_vcpu_hdr),
+				&xsave_size))
+		return -EINVAL;
+
+	ec = kvmi_arch_cmd_vcpu_set_xsave(job->vcpu, req, xsave_size);
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 /*
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -571,6 +587,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 	[KVMI_VCPU_GET_XSAVE]        = handle_vcpu_get_xsave,
 	[KVMI_VCPU_INJECT_EXCEPTION] = handle_vcpu_inject_exception,
 	[KVMI_VCPU_SET_REGISTERS]    = handle_vcpu_set_registers,
+	[KVMI_VCPU_SET_XSAVE]        = handle_vcpu_set_xsave,
 };
 
 static bool is_vcpu_command(u16 id)
