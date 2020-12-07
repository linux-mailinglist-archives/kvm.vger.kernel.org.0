Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54DF2D1B30
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 21:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727480AbgLGUsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 15:48:46 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:42560 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727441AbgLGUsq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 15:48:46 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 5AB2930462E8;
        Mon,  7 Dec 2020 22:46:24 +0200 (EET)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 306F33072785;
        Mon,  7 Dec 2020 22:46:24 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Nicu=C8=99or=20C=C3=AE=C8=9Bu?= <nicu.citu@icloud.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v11 69/81] KVM: introspection: add KVMI_VCPU_GET_MTRR_TYPE
Date:   Mon,  7 Dec 2020 22:46:10 +0200
Message-Id: <20201207204622.15258-70-alazar@bitdefender.com>
In-Reply-To: <20201207204622.15258-1-alazar@bitdefender.com>
References: <20201207204622.15258-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Mihai Donțu <mdontu@bitdefender.com>

This command returns the memory type for a guest physical address.

Signed-off-by: Mihai Donțu <mdontu@bitdefender.com>
Co-developed-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Nicușor Cîțu <nicu.citu@icloud.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 32 +++++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              |  9 ++++++
 arch/x86/kvm/kvmi_msg.c                       | 17 ++++++++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 18 +++++++++++
 5 files changed, 77 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 70d1f96bc4f0..b3527d10a44e 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -887,6 +887,38 @@ Modifies the XSAVE area.
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+21. KVMI_VCPU_GET_MTRR_TYPE
+---------------------------
+
+:Architectures: x86
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
+Returns the guest memory type for a specific guest physical address (``gpa``).
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
index 89f3dc9269c1..7b93450d0d62 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -119,4 +119,13 @@ struct kvmi_vcpu_set_xsave {
 	struct kvm_xsave xsave;
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
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index 7df71b5cd50a..2617ada3a692 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -232,10 +232,27 @@ static int handle_vcpu_set_xsave(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_get_mtrr_type(const struct kvmi_vcpu_msg_job *job,
+				     const struct kvmi_msg_hdr *msg,
+				     const void *_req)
+{
+	const struct kvmi_vcpu_get_mtrr_type *req = _req;
+	struct kvmi_vcpu_get_mtrr_type_reply rpl;
+	gfn_t gfn;
+
+	gfn = gpa_to_gfn(req->gpa);
+
+	memset(&rpl, 0, sizeof(rpl));
+	rpl.type = kvm_mtrr_get_guest_memory_type(job->vcpu, gfn);
+
+	return kvmi_msg_vcpu_reply(job, msg, 0, &rpl, sizeof(rpl));
+}
+
 static kvmi_vcpu_msg_job_fct const msg_vcpu[] = {
 	[KVMI_VCPU_CONTROL_CR]       = handle_vcpu_control_cr,
 	[KVMI_VCPU_GET_CPUID]        = handle_vcpu_get_cpuid,
 	[KVMI_VCPU_GET_INFO]         = handle_vcpu_get_info,
+	[KVMI_VCPU_GET_MTRR_TYPE]    = handle_vcpu_get_mtrr_type,
 	[KVMI_VCPU_GET_REGISTERS]    = handle_vcpu_get_registers,
 	[KVMI_VCPU_GET_XCR]          = handle_vcpu_get_xcr,
 	[KVMI_VCPU_GET_XSAVE]        = handle_vcpu_get_xsave,
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 3baf5c7842bb..8d7c6027f12c 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -47,6 +47,7 @@ enum {
 	KVMI_VCPU_GET_XCR          = KVMI_VCPU_MESSAGE_ID(8),
 	KVMI_VCPU_GET_XSAVE        = KVMI_VCPU_MESSAGE_ID(9),
 	KVMI_VCPU_SET_XSAVE        = KVMI_VCPU_MESSAGE_ID(10),
+	KVMI_VCPU_GET_MTRR_TYPE    = KVMI_VCPU_MESSAGE_ID(11),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 45c1f3132a3c..b0906c7fb954 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1488,6 +1488,23 @@ static void test_cmd_vcpu_xsave(struct kvm_vm *vm)
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
+			   &req.hdr, sizeof(req), &rpl, sizeof(rpl), 0);
+
+	pr_debug("mtrr_type: gpa 0x%lx type 0x%x\n", test_gpa, rpl.type);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1517,6 +1534,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_xsetbv(vm);
 	test_cmd_vcpu_get_xcr(vm);
 	test_cmd_vcpu_xsave(vm);
+	test_cmd_vcpu_get_mtrr_type(vm);
 
 	unhook_introspection(vm);
 }
