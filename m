Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8EB24244EF
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239736AbhJFRnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:40 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53648 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234560AbhJFRmo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:44 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id D4A5E30827B2;
        Wed,  6 Oct 2021 20:31:20 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id B827C300F73A;
        Wed,  6 Oct 2021 20:31:20 +0300 (EEST)
X-Is-Junk-Enabled: fGZTSsP0qEJE2AIKtlSuFiRRwg9xyHmJ
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 64/77] KVM: introspection: add KVMI_VCPU_SET_XSAVE
Date:   Wed,  6 Oct 2021 20:31:00 +0300
Message-Id: <20211006173113.26445-65-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
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
 arch/x86/kvm/kvmi_msg.c                       | 20 +++++++++++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 27 ++++++++++++++----
 5 files changed, 74 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 8f2f105a527f..eedcae3900c5 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -840,6 +840,34 @@ Returns a buffer containing the XSAVE area.
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 * -KVM_ENOMEM - there is not enough memory to allocate the reply
 
+19. KVMI_VCPU_SET_XSAVE
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
index c6a46252a684..89f3dc9269c1 100644
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
index 90e19244044a..ecad1882cdd8 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -213,6 +213,25 @@ static int handle_vcpu_get_xsave(const struct kvmi_vcpu_msg_job *job,
 	return err;
 }
 
+static int handle_vcpu_set_xsave(const struct kvmi_vcpu_msg_job *job,
+				 const struct kvmi_msg_hdr *msg,
+				 const void *req)
+{
+	const struct kvm_xsave *area = req;
+	size_t cmd_size;
+	int ec = 0;
+
+	cmd_size = sizeof(struct kvmi_vcpu_hdr) + sizeof(*area);
+
+	if (cmd_size > msg->size)
+		ec = -KVM_EINVAL;
+	else if (kvm_vcpu_ioctl_x86_set_xsave(job->vcpu,
+					      (struct kvm_xsave *) area))
+		ec = -KVM_EINVAL;
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
+}
+
 static const kvmi_vcpu_msg_job_fct msg_vcpu[] = {
 	[KVMI_VCPU_CONTROL_CR]       = handle_vcpu_control_cr,
 	[KVMI_VCPU_GET_CPUID]        = handle_vcpu_get_cpuid,
@@ -222,6 +241,7 @@ static const kvmi_vcpu_msg_job_fct msg_vcpu[] = {
 	[KVMI_VCPU_GET_XSAVE]        = handle_vcpu_get_xsave,
 	[KVMI_VCPU_INJECT_EXCEPTION] = handle_vcpu_inject_exception,
 	[KVMI_VCPU_SET_REGISTERS]    = handle_vcpu_set_registers,
+	[KVMI_VCPU_SET_XSAVE]        = handle_vcpu_set_xsave,
 };
 
 kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id)
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index b99763e580e4..4671e0e3cb45 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -45,6 +45,7 @@ enum {
 	KVMI_VCPU_INJECT_EXCEPTION = KVMI_VCPU_MESSAGE_ID(7),
 	KVMI_VCPU_GET_XCR          = KVMI_VCPU_MESSAGE_ID(8),
 	KVMI_VCPU_GET_XSAVE        = KVMI_VCPU_MESSAGE_ID(9),
+	KVMI_VCPU_SET_XSAVE        = KVMI_VCPU_MESSAGE_ID(10),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index a9ab0e973340..adac0edddc50 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1437,21 +1437,35 @@ static void test_cmd_vcpu_get_xcr(struct kvm_vm *vm)
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
+}
+
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
 }
 
-static void test_cmd_vcpu_get_xsave(struct kvm_vm *vm)
+static void test_cmd_vcpu_xsave(struct kvm_vm *vm)
 {
 	struct kvm_cpuid_entry2 *entry;
+	struct kvm_xsave xsave;
 
 	entry = kvm_get_supported_cpuid_entry(1);
 	if (!(entry->ecx & X86_FEATURE_XSAVE)) {
@@ -1459,7 +1473,8 @@ static void test_cmd_vcpu_get_xsave(struct kvm_vm *vm)
 		return;
 	}
 
-	cmd_vcpu_get_xsave(vm);
+	cmd_vcpu_get_xsave(vm, &xsave);
+	cmd_vcpu_set_xsave(vm, &xsave);
 }
 
 static void test_introspection(struct kvm_vm *vm)
@@ -1489,7 +1504,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_inject_exception(vm);
 	test_event_xsetbv(vm);
 	test_cmd_vcpu_get_xcr(vm);
-	test_cmd_vcpu_get_xsave(vm);
+	test_cmd_vcpu_xsave(vm);
 
 	unhook_introspection(vm);
 }
