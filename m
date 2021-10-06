Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCB3424510
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239733AbhJFRnT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:19 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53652 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239274AbhJFRml (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:41 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 74DFD30827B1;
        Wed,  6 Oct 2021 20:31:20 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 5CC123064495;
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
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mdontu@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v12 63/77] KVM: introspection: add KVMI_VCPU_GET_XSAVE
Date:   Wed,  6 Oct 2021 20:30:59 +0300
Message-Id: <20211006173113.26445-64-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
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
index 389d69e3fd7e..8f2f105a527f 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -811,6 +811,35 @@ Returns the value of an extended control register XCR.
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+18. KVMI_VCPU_GET_XSAVE
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
index 21624568e329..90e19244044a 100644
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
 static const kvmi_vcpu_msg_job_fct msg_vcpu[] = {
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
index ac23754627ff..b99763e580e4 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -44,6 +44,7 @@ enum {
 	KVMI_VCPU_CONTROL_CR       = KVMI_VCPU_MESSAGE_ID(6),
 	KVMI_VCPU_INJECT_EXCEPTION = KVMI_VCPU_MESSAGE_ID(7),
 	KVMI_VCPU_GET_XCR          = KVMI_VCPU_MESSAGE_ID(8),
+	KVMI_VCPU_GET_XSAVE        = KVMI_VCPU_MESSAGE_ID(9),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index d9497727e859..a9ab0e973340 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1437,6 +1437,31 @@ static void test_cmd_vcpu_get_xcr(struct kvm_vm *vm)
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
@@ -1464,6 +1489,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vcpu_inject_exception(vm);
 	test_event_xsetbv(vm);
 	test_cmd_vcpu_get_xcr(vm);
+	test_cmd_vcpu_get_xsave(vm);
 
 	unhook_introspection(vm);
 }
