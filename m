Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF07942450E
	for <lists+kvm@lfdr.de>; Wed,  6 Oct 2021 19:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239668AbhJFRnP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Oct 2021 13:43:15 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:53646 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239248AbhJFRmk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 Oct 2021 13:42:40 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 2F4EF30828BF;
        Wed,  6 Oct 2021 20:31:25 +0300 (EEST)
Received: from localhost (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 17E413064495;
        Wed,  6 Oct 2021 20:31:25 +0300 (EEST)
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
Subject: [PATCH v12 75/77] KVM: introspection: add KVMI_VCPU_TRANSLATE_GVA
Date:   Wed,  6 Oct 2021 20:31:11 +0300
Message-Id: <20211006173113.26445-76-alazar@bitdefender.com>
In-Reply-To: <20211006173113.26445-1-alazar@bitdefender.com>
References: <20211006173113.26445-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This helps the introspection tool with the GVA to GPA translations
without the need to read or monitor the guest page tables.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 32 +++++++++++++++++++
 arch/x86/kvm/kvmi_msg.c                       | 15 +++++++++
 include/uapi/linux/kvmi.h                     |  9 ++++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 30 +++++++++++++++++
 4 files changed, 86 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 84922d327255..17735d099be2 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -1055,6 +1055,38 @@ to the introspection tool.
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+24. KVMI_VCPU_TRANSLATE_GVA
+---------------------------
+
+:Architectures: x86
+:Versions: >= 1
+:Parameters:
+
+::
+
+	struct kvmi_vcpu_hdr;
+	struct kvmi_vcpu_translate_gva {
+		__u64 gva;
+	};
+
+:Returns:
+
+::
+
+	struct kvmi_error_code;
+	struct kvmi_vcpu_translate_gva_reply {
+		__u64 gpa;
+	};
+
+Translates a guest virtual address (``gva``) to a guest physical address
+(``gpa``) or ~0 if the address cannot be translated.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/kvm/kvmi_msg.c b/arch/x86/kvm/kvmi_msg.c
index ea38eb7ccb7c..cdd497a342a0 100644
--- a/arch/x86/kvm/kvmi_msg.c
+++ b/arch/x86/kvm/kvmi_msg.c
@@ -312,6 +312,20 @@ static int handle_vcpu_control_singlestep(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_translate_gva(const struct kvmi_vcpu_msg_job *job,
+				     const struct kvmi_msg_hdr *msg,
+				     const void *_req)
+{
+	const struct kvmi_vcpu_translate_gva *req = _req;
+	struct kvmi_vcpu_translate_gva_reply rpl;
+
+	memset(&rpl, 0, sizeof(rpl));
+
+	rpl.gpa = kvm_mmu_gva_to_gpa_system(job->vcpu, req->gva, 0, NULL);
+
+	return kvmi_msg_vcpu_reply(job, msg, 0, &rpl, sizeof(rpl));
+}
+
 static const kvmi_vcpu_msg_job_fct msg_vcpu[] = {
 	[KVMI_VCPU_CONTROL_CR]         = handle_vcpu_control_cr,
 	[KVMI_VCPU_CONTROL_MSR]        = handle_vcpu_control_msr,
@@ -325,6 +339,7 @@ static const kvmi_vcpu_msg_job_fct msg_vcpu[] = {
 	[KVMI_VCPU_INJECT_EXCEPTION]   = handle_vcpu_inject_exception,
 	[KVMI_VCPU_SET_REGISTERS]      = handle_vcpu_set_registers,
 	[KVMI_VCPU_SET_XSAVE]          = handle_vcpu_set_xsave,
+	[KVMI_VCPU_TRANSLATE_GVA]      = handle_vcpu_translate_gva,
 };
 
 kvmi_vcpu_msg_job_fct kvmi_arch_vcpu_msg_handler(u16 id)
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 148d145ddea0..a1bfa845fed8 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -50,6 +50,7 @@ enum {
 	KVMI_VCPU_GET_MTRR_TYPE      = KVMI_VCPU_MESSAGE_ID(11),
 	KVMI_VCPU_CONTROL_MSR        = KVMI_VCPU_MESSAGE_ID(12),
 	KVMI_VCPU_CONTROL_SINGLESTEP = KVMI_VCPU_MESSAGE_ID(13),
+	KVMI_VCPU_TRANSLATE_GVA      = KVMI_VCPU_MESSAGE_ID(14),
 
 	KVMI_NEXT_VCPU_MESSAGE
 };
@@ -228,4 +229,12 @@ struct kvmi_vcpu_event_singlestep {
 	__u8 padding[7];
 };
 
+struct kvmi_vcpu_translate_gva {
+	__u64 gva;
+};
+
+struct kvmi_vcpu_translate_gva_reply {
+	__u64 gpa;
+};
+
 #endif /* _UAPI__LINUX_KVMI_H */
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index faef908eeedd..fc59a8b9f99a 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1894,6 +1894,35 @@ static void test_cmd_vcpu_control_singlestep(struct kvm_vm *vm)
 		test_unsupported_singlestep(vm);
 }
 
+static void cmd_translate_gva(struct kvm_vm *vm, vm_vaddr_t gva,
+			      vm_paddr_t expected_gpa)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+		struct kvmi_vcpu_translate_gva cmd;
+	} req = { 0 };
+	struct kvmi_vcpu_translate_gva_reply rpl;
+
+	req.cmd.gva = gva;
+
+	test_vcpu0_command(vm, KVMI_VCPU_TRANSLATE_GVA, &req.hdr, sizeof(req),
+			  &rpl, sizeof(rpl), 0);
+	TEST_ASSERT(rpl.gpa == expected_gpa,
+		    "Translation failed for gva 0x%lx -> gpa 0x%llx instead of 0x%lx\n",
+		    gva, rpl.gpa, expected_gpa);
+}
+
+static void test_cmd_translate_gva(struct kvm_vm *vm)
+{
+	cmd_translate_gva(vm, test_gva, test_gpa);
+	pr_debug("Tested gva 0x%lx to gpa 0x%lx\n", test_gva, test_gpa);
+
+	cmd_translate_gva(vm, -1, ~0);
+	pr_debug("Tested gva 0x%lx to gpa 0x%lx\n",
+		 (vm_vaddr_t)-1, (vm_paddr_t)-1);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -1928,6 +1957,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_set_page_access(vm);
 	test_event_pf(vm);
 	test_cmd_vcpu_control_singlestep(vm);
+	test_cmd_translate_gva(vm);
 
 	unhook_introspection(vm);
 }
