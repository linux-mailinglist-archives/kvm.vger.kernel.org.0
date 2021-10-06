Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF024244E9
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239647AbhJFRng (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:36 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53634 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239213AbhJFRmn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:43 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 15FA430827B0;
        Wed,  6 Oct 2021 20:31:20 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id F0BC4300F73A;
        Wed,  6 Oct 2021 20:31:19 +0300 (EEST)
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
Subject: [PATCH v12 62/77] KVM: introspection: add KVMI_VCPU_GET_XCR
Date:   Wed,  6 Oct 2021 20:30:58 +0300
Message-Id: <20211006173113.26445-63-alazar@bitdefender.com>
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
 Documentation/virt/kvm/kvmi.rst               | 33 +++++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              |  9 +++++
 arch/x86/kvm/kvmi_msg.c                       | 21 ++++++++++++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 33 +++++++++++++++++++
 5 files changed, 97 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index d3a0bea64e02..389d69e3fd7e 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -778,6 +778,39 @@ exception.
 * -KVM_EBUSY - another *KVMI_VCPU_INJECT_EXCEPTION*-*KVMI_VCPU_EVENT_TRAP*
                pair is in progress
 
+17. KVMI_VCPU_GET_XCR
+---------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_get_xcr {
+		__u8 xcr;
+		__u8 padding[7];
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	struct kvmi_vcpu_get_xcr_reply {
+		__u64 value;
+	};
+
+Returns the value of an extended control register XCR.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the specified control register is not XCR0
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 604a8b3d4ac2..c0a73051d667 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -102,4 +102,13 @@ struct kvmi_vcpu_event_xsetbv {
 	__u64 new_value;
 };
 
+struct kvmi_vcpu_get_xcr {
+	__u8 xcr;
+	__u8 padding[7];
+};
+
+struct kvmi_vcpu_get_xcr_reply {
+	__u64 value;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index c767b969df53..21624568e329 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -174,11 +174,32 @@ static int handle_vcpu_inject_exception(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_get_xcr(const struct kvmi_vcpu_msg_job *job,
+			       const struct kvmi_msg_hdr *msg,
+			       const void *_req)
+{
+	const struct kvmi_vcpu_get_xcr *req = _req;
+	struct kvmi_vcpu_get_xcr_reply rpl;
+	int ec = 0;
+
+	memset(&rpl, 0, sizeof(rpl));
+
+	if (non_zero_padding(req->padding, ARRAY_SIZE(req->padding)))
+		ec = -KVM_EINVAL;
+	else if (req->xcr != 0)
+		ec = -KVM_EINVAL;
+	else
+		rpl.value = job->vcpu->arch.xcr0;
+
+	return kvmi_msg_vcpu_reply(job, msg, ec, &rpl, sizeof(rpl));
+}
+
 static const kvmi_vcpu_msg_job_fct msg_vcpu[] = {
 	[KVMI_VCPU_CONTROL_CR]       = handle_vcpu_control_cr,
 	[KVMI_VCPU_GET_CPUID]        = handle_vcpu_get_cpuid,
 	[KVMI_VCPU_GET_INFO]         = handle_vcpu_get_info,
 	[KVMI_VCPU_GET_REGISTERS]    = handle_vcpu_get_registers,
+	[KVMI_VCPU_GET_XCR]          = handle_vcpu_get_xcr,
 	[KVMI_VCPU_INJECT_EXCEPTION] = handle_vcpu_inject_exception,
 	[KVMI_VCPU_SET_REGISTERS]    = handle_vcpu_set_registers,
 };
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 4b71c6b0b16c..ac23754627ff 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -43,6 +43,7 @@ enum {
 	KVMI_VCPU_GET_CPUID        = KVMI_VCPU_MESSAGE_ID(5),
 	KVMI_VCPU_CONTROL_CR       = KVMI_VCPU_MESSAGE_ID(6),
 	KVMI_VCPU_INJECT_EXCEPTION = KVMI_VCPU_MESSAGE_ID(7),
+	KVMI_VCPU_GET_XCR          = KVMI_VCPU_MESSAGE_ID(8),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 380aa3d2d8f3..d9497727e859 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1405,6 +1405,38 @@ static void test_event_xsetbv(struct kvm_vm *vm)
 	disable_vcpu_event(vm, event_id);
 }
 
+static void cmd_vcpu_get_xcr(struct kvm_vm *vm, u8 xcr, u64 *value,
+			     int expected_err)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_get_xcr cmd;
+	} req = { 0 };
+	struct kvmi_vcpu_get_xcr_reply rpl = { 0 };
+	int r;
+
+	req.cmd.xcr = xcr;
+
+	r = do_vcpu0_command(vm, KVMI_VCPU_GET_XCR, &req.hdr, sizeof(req),
+			     &rpl, sizeof(rpl));
+	TEST_ASSERT(r == expected_err,
+		"KVMI_VCPU_GET_XCR failed, error %d (%s), expected %d\n",
+		-r, kvm_strerror(-r), expected_err);
+
+	*value = r == 0 ? rpl.value : 0;
+}
+
+static void test_cmd_vcpu_get_xcr(struct kvm_vm *vm)
+{
+	u8 xcr0 = 0, xcr1 = 1;
+	u64 value;
+
+	cmd_vcpu_get_xcr(vm, xcr0, &value, 0);
+	pr_debug("XCR0 0x%lx\n", value);
+	cmd_vcpu_get_xcr(vm, xcr1, &value, -KVM_EINVAL);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1431,6 +1463,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_control_cr(vm);
 	test_cmd_vcpu_inject_exception(vm);
 	test_event_xsetbv(vm);
+	test_cmd_vcpu_get_xcr(vm);
 
 	unhook_introspection(vm);
 }
