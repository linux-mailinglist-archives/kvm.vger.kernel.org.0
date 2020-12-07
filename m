Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD852D1B32
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727530AbgLGUss (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:48 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42562 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727415AbgLGUsp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:45 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id F3CF630462E3;
        Mon,  7 Dec 2020 22:46:23 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id CB3223072785;
        Mon,  7 Dec 2020 22:46:23 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 67/81] KVM: introspection: add KVMI_VCPU_GET_XSAVE
Date:   Mon,  7 Dec 2020 22:46:08 +0200
Message-Id: <20201207204622.15258-68-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This vCPU command is used to get the XSAVE area.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Adalbert Lazăr <alazar@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 29 +++++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              |  4 +++
 arch/x86/kvm/kvmi_msg.c                       | 20 +++++++++++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 26 +++++++++++++++++
 5 files changed, 80 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 3846fec72f14..3b7a68cc8faf 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -830,6 +830,35 @@ Returns the value of an extended control register XCR.
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+19. KVMI_VCPU_GET_XSAVE
+-----------------------
+
+:Architectures: x86
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
+		struct kvm_xsave xsave;
+	};
+
+Returns a buffer containing the XSAVE area.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+* -KVM_ENOMEM - there is not enough memory to allocate the reply
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index c0a73051d667..c6a46252a684 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -111,4 +111,8 @@ struct kvmi_vcpu_get_xcr_reply {
 	__u64 value;
 };
 
+struct kvmi_vcpu_get_xsave_reply {
+	struct kvm_xsave xsave;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index 8badef7003fd..befb1c288045 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -194,12 +194,32 @@ static int handle_vcpu_get_xcr(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, &rpl, sizeof(rpl));
 }
 
+static int handle_vcpu_get_xsave(const struct kvmi_vcpu_msg_job *job,
+				 const struct kvmi_msg_hdr *msg,
+				 const void *req)
+{
+	struct kvmi_vcpu_get_xsave_reply *rpl;
+	int err, ec = 0;
+
+	rpl = kvmi_msg_alloc();
+	if (!rpl)
+		ec = -KVM_ENOMEM;
+	else
+		kvm_vcpu_ioctl_x86_get_xsave(job->vcpu, &rpl->xsave);
+
+	err = kvmi_msg_vcpu_reply(job, msg, ec, rpl, sizeof(*rpl));
+
+	kvmi_msg_free(rpl);
+	return err;
+}
+
 static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
 	[KVMI_VCPU_CONTROL_CR]       = handle_vcpu_control_cr,
 	[KVMI_VCPU_GET_CPUID]        = handle_vcpu_get_cpuid,
 	[KVMI_VCPU_GET_INFO]         = handle_vcpu_get_info,
 	[KVMI_VCPU_GET_REGISTERS]    = handle_vcpu_get_registers,
 	[KVMI_VCPU_GET_XCR]          = handle_vcpu_get_xcr,
+	[KVMI_VCPU_GET_XSAVE]        = handle_vcpu_get_xsave,
 	[KVMI_VCPU_INJECT_EXCEPTION] = handle_vcpu_inject_exception,
 	[KVMI_VCPU_SET_REGISTERS]    = handle_vcpu_set_registers,
 };
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 07b6d383641a..e47c4ce0f8ed 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -45,6 +45,7 @@ enum {
 	KVMI_VCPU_CONTROL_CR       = KVMI_VCPU_MESSAGE_ID(6),
 	KVMI_VCPU_INJECT_EXCEPTION = KVMI_VCPU_MESSAGE_ID(7),
 	KVMI_VCPU_GET_XCR          = KVMI_VCPU_MESSAGE_ID(8),
+	KVMI_VCPU_GET_XSAVE        = KVMI_VCPU_MESSAGE_ID(9),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index da90c6a8d535..277b1061410b 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1448,6 +1448,31 @@ static void test_cmd_vcpu_get_xcr(struct kvm_vm *vm)
 	cmd_vcpu_get_xcr(vm, xcr1, &value, -KVM_EINVAL);
 }
 
+static void cmd_vcpu_get_xsave(struct kvm_vm *vm)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+	} req = {};
+	struct kvm_xsave rpl;
+
+	test_vcpu0_command(vm, KVMI_VCPU_GET_XSAVE, &req.hdr, sizeof(req),
+			   &rpl, sizeof(rpl), 0);
+}
+
+static void test_cmd_vcpu_get_xsave(struct kvm_vm *vm)
+{
+	struct kvm_cpuid_entry2 *entry;
+
+	entry = kvm_get_supported_cpuid_entry(1);
+	if (!(entry->ecx & X86_FEATURE_XSAVE)) {
+		print_skip("XSAVE not supported, ecx 0x%x", entry->ecx);
+		return;
+	}
+
+	cmd_vcpu_get_xsave(vm);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1476,6 +1501,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_get_max_gfn();
 	test_event_xsetbv(vm);
 	test_cmd_vcpu_get_xcr(vm);
+	test_cmd_vcpu_get_xsave(vm);
 
 	unhook_introspection(vm);
 }
