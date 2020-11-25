Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82A3B2C3CC4
	for <lists+kvm@lfdr.de>; Wed, 25 Nov 2020 10:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728826AbgKYJnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Nov 2020 04:43:06 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:57136 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727338AbgKYJl4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Nov 2020 04:41:56 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id E0AAF30462CE;
        Wed, 25 Nov 2020 11:35:53 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id C2C243072784;
        Wed, 25 Nov 2020 11:35:53 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v10 68/81] KVM: introspection: add KVMI_VCPU_SET_XSAVE
Date:   Wed, 25 Nov 2020 11:35:47 +0200
Message-Id: <20201125093600.2766-69-alazar@bitdefender.com>
In-Reply-To: <20201125093600.2766-1-alazar@bitdefender.com>
References: <20201125093600.2766-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This can be used by the introspection tool to emulate SSE instructions.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 28 +++++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              |  4 +++
 arch/x86/kvm/kvmi_msg.c                       | 21 ++++++++++++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 27 ++++++++++++++----
 5 files changed, 75 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index c1ac47def4e9..56efeeb38980 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -859,6 +859,34 @@ Returns a buffer containing the XSAVE area.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - there is not enough memory to allocate the reply
 
+20. KVMI_VCPU_SET_XSAVE
+-----------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_set_xsave {
+		struct kvm_xsave xsave;
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
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 0d3696c52d88..6ec290b69b46 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -115,4 +115,8 @@ struct kvmi_vcpu_get_xsave_reply {
 	struct kvm_xsave xsave;
 };
 
+struct kvmi_vcpu_set_xsave {
+	struct kvm_xsave xsave;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index 77c753cd9705..c1b3bd56a42c 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -213,6 +213,26 @@ static int handle_vcpu_get_xsave(const struct kvmi_vcpu_msg_job *job,
 	return err;
 }
 
+static int handle_vcpu_set_xsave(const struct kvmi_vcpu_msg_job *job,
+				 const struct kvmi_msg_hdr *msg,
+				 const void *req)
+{
+	size_t req_size, msg_size = msg->size;
+	int ec = 0;
+
+	if (check_sub_overflow(msg_size, sizeof(struct kvmi_vcpu_hdr),
+			       &req_size))
+		return -EINVAL;
+
+	if (req_size < sizeof(struct kvm_xsave))
+		ec = -KVM_EINVAL;
+	else if (kvm_vcpu_ioctl_x86_set_xsave(job->vcpu,
+					      (struct kvm_xsave *) req))
+		ec = -KVM_EINVAL;
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
 	[KVMI_VCPU_CONTROL_CR]       = handle_vcpu_control_cr,
 	[KVMI_VCPU_GET_CPUID]        = handle_vcpu_get_cpuid,
@@ -222,6 +242,7 @@ static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
 	[KVMI_VCPU_GET_XSAVE]        = handle_vcpu_get_xsave,
 	[KVMI_VCPU_INJECT_EXCEPTION] = handle_vcpu_inject_exception,
 	[KVMI_VCPU_SET_REGISTERS]    = handle_vcpu_set_registers,
+	[KVMI_VCPU_SET_XSAVE]        = handle_vcpu_set_xsave,
 };
 
 kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id)
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index e47c4ce0f8ed..3baf5c7842bb 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -46,6 +46,7 @@ enum {
 	KVMI_VCPU_INJECT_EXCEPTION = KVMI_VCPU_MESSAGE_ID(7),
 	KVMI_VCPU_GET_XCR          = KVMI_VCPU_MESSAGE_ID(8),
 	KVMI_VCPU_GET_XSAVE        = KVMI_VCPU_MESSAGE_ID(9),
+	KVMI_VCPU_SET_XSAVE        = KVMI_VCPU_MESSAGE_ID(10),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 277b1061410b..45c1f3132a3c 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1448,21 +1448,35 @@ static void test_cmd_vcpu_get_xcr(struct kvm_vm *vm)
 	cmd_vcpu_get_xcr(vm, xcr1, &value, -KVM_EINVAL);
 }
 
-static void cmd_vcpu_get_xsave(struct kvm_vm *vm)
+static void cmd_vcpu_get_xsave(struct kvm_vm *vm, struct kvm_xsave *rpl)
 {
 	struct {
 		struct kvmi_msg_hdr hdr;
 		struct kvmi_vcpu_hdr vcpu_hdr;
 	} req = {};
-	struct kvm_xsave rpl;
 
 	test_vcpu0_command(vm, KVMI_VCPU_GET_XSAVE, &req.hdr, sizeof(req),
-			   &rpl, sizeof(rpl), 0);
+			   rpl, sizeof(*rpl), 0);
 }
 
-static void test_cmd_vcpu_get_xsave(struct kvm_vm *vm)
+static void cmd_vcpu_set_xsave(struct kvm_vm *vm, struct kvm_xsave *rpl)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvm_xsave xsave;
+	} req = {};
+
+	memcpy(&req.xsave, rpl, sizeof(*rpl));
+
+	test_vcpu0_command(vm, KVMI_VCPU_SET_XSAVE, &req.hdr, sizeof(req),
+			   NULL, 0, 0);
+}
+
+static void test_cmd_vcpu_xsave(struct kvm_vm *vm)
 {
 	struct kvm_cpuid_entry2 *entry;
+	struct kvm_xsave xsave;
 
 	entry = kvm_get_supported_cpuid_entry(1);
 	if (!(entry->ecx & X86_FEATURE_XSAVE)) {
@@ -1470,7 +1484,8 @@ static void test_cmd_vcpu_get_xsave(struct kvm_vm *vm)
 		return;
 	}
 
-	cmd_vcpu_get_xsave(vm);
+	cmd_vcpu_get_xsave(vm, &xsave);
+	cmd_vcpu_set_xsave(vm, &xsave);
 }
 
 static void test_introspection(struct kvm_vm *vm)
@@ -1501,7 +1516,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_get_max_gfn();
 	test_event_xsetbv(vm);
 	test_cmd_vcpu_get_xcr(vm);
-	test_cmd_vcpu_get_xsave(vm);
+	test_cmd_vcpu_xsave(vm);
 
 	unhook_introspection(vm);
 }
