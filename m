Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9ABE155D98
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 19:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgBGSRL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 13:17:11 -0500
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:40708 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727761AbgBGSQ4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 13:16:56 -0500
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 089D1305D36A;
        Fri,  7 Feb 2020 20:16:42 +0200 (EET)
Received: from host.bbu.bitdefender.biz (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id F0BC93052078;
        Fri,  7 Feb 2020 20:16:41 +0200 (EET)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v7 76/78] KVM: introspection: add KVMI_VCPU_TRANSLATE_GVA
Date:   Fri,  7 Feb 2020 20:16:34 +0200
Message-Id: <20200207181636.1065-77-alazar@bitdefender.com>
In-Reply-To: <20200207181636.1065-1-alazar@bitdefender.com>
References: <20200207181636.1065-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This helps the introspection tool with the VGA to GPA translations
without the need to monitor the guest page tables.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 31 +++++++++++++++++++
 arch/x86/kvm/kvmi.c                           |  4 +++
 include/uapi/linux/kvmi.h                     |  9 ++++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 31 +++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  2 ++
 virt/kvm/introspection/kvmi_msg.c             | 16 ++++++++++
 6 files changed, 93 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 3515fea1eb75..bbe33cf7bd6e 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -962,6 +962,37 @@ if the hardware supports singlestep (see **KVMI_GET_VERSION**).
 * -KVM_EINVAL - padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+21. KVMI_VCPU_TRANSLATE_GVA
+---------------------------
+
+:Architecture: all
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
+Translates a guest virtual address to a guest physical address or ~0 if
+the address cannot be translated.
+
+:Errors:
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index feebb0327e27..7b02bc82dbd7 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1129,3 +1129,7 @@ bool kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+gpa_t kvmi_arch_cmd_translate_gva(struct kvm_vcpu *vcpu, gva_t gva)
+{
+	return kvm_mmu_gva_to_gpa_system(vcpu, gva, 0, NULL);
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 37c51e64d22c..2d93cafd0062 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -44,6 +44,7 @@ enum {
 	KVMI_VM_SET_PAGE_ACCESS = 21,
 
 	KVMI_VCPU_CONTROL_SINGLESTEP = 22,
+	KVMI_VCPU_TRANSLATE_GVA      = 23,
 
 	KVMI_NUM_MESSAGES
 };
@@ -205,4 +206,12 @@ struct kvmi_event_singlestep {
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
index cf5edf91197d..9056a826864b 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1763,6 +1763,36 @@ static void test_cmd_vcpu_control_singlestep(struct kvm_vm *vm)
 	disable_vcpu_event(vm, KVMI_EVENT_SINGLESTEP);
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
+			  &rpl, sizeof(rpl));
+
+	TEST_ASSERT(rpl.gpa == expected_gpa,
+		    "Translation failed for gva 0x%llx -> gpa 0x%llx instead of 0x%llx\n",
+		    gva, rpl.gpa, expected_gpa);
+}
+
+static void test_cmd_translate_gva(struct kvm_vm *vm)
+{
+	cmd_translate_gva(vm, test_gva, test_gpa);
+	DEBUG("Tested gva 0x%lx to gpa 0x%lx\n", test_gva, test_gpa);
+
+	cmd_translate_gva(vm, -1, ~0);
+	DEBUG("Tested gva 0x%lx to gpa 0x%lx\n",
+		(vm_vaddr_t)-1, (vm_paddr_t)-1);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	setup_socket();
@@ -1795,6 +1825,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_set_page_access(vm);
 	test_event_pf(vm);
 	test_cmd_vcpu_control_singlestep(vm);
+	test_cmd_translate_gva(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index ccd99dfddf31..f440d04824c7 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -58,6 +58,7 @@
 			| BIT(KVMI_VCPU_GET_XSAVE) \
 			| BIT(KVMI_VCPU_INJECT_EXCEPTION) \
 			| BIT(KVMI_VCPU_SET_REGISTERS) \
+			| BIT(KVMI_VCPU_TRANSLATE_GVA) \
 		)
 
 #define KVMI(kvm) ((struct kvm_introspection *)((kvm)->kvmi))
@@ -172,5 +173,6 @@ bool kvmi_arch_pf_of_interest(struct kvm_vcpu *vcpu);
 void kvmi_arch_features(struct kvmi_features *feat);
 bool kvmi_arch_start_singlestep(struct kvm_vcpu *vcpu);
 bool kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu);
+gpa_t kvmi_arch_cmd_translate_gva(struct kvm_vcpu *vcpu, gva_t gva);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 4c49033a6407..b026cd142f5e 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -39,6 +39,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VCPU_INJECT_EXCEPTION]   = "KVMI_VCPU_INJECT_EXCEPTION",
 	[KVMI_VCPU_PAUSE]              = "KVMI_VCPU_PAUSE",
 	[KVMI_VCPU_SET_REGISTERS]      = "KVMI_VCPU_SET_REGISTERS",
+	[KVMI_VCPU_TRANSLATE_GVA]      = "KVMI_VCPU_TRANSLATE_GVA",
 };
 
 static bool is_known_message(u16 id)
@@ -614,6 +615,20 @@ static int handle_vcpu_control_singlestep(const struct kvmi_vcpu_cmd_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, ec, NULL, 0);
 }
 
+static int handle_vcpu_translate_gva(const struct kvmi_vcpu_cmd_job *job,
+				     const struct kvmi_msg_hdr *msg,
+				     const void *_req)
+{
+	const struct kvmi_vcpu_translate_gva *req = _req;
+	struct kvmi_vcpu_translate_gva_reply rpl;
+
+	memset(&rpl, 0, sizeof(rpl));
+
+	rpl.gpa = kvmi_arch_cmd_translate_gva(job->vcpu, req->gva);
+
+	return kvmi_msg_vcpu_reply(job, msg, 0, &rpl, sizeof(rpl));
+}
+
 /*
  * These commands are executed on the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -634,6 +649,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 	[KVMI_VCPU_GET_XSAVE]          = handle_vcpu_get_xsave,
 	[KVMI_VCPU_INJECT_EXCEPTION]   = handle_vcpu_inject_exception,
 	[KVMI_VCPU_SET_REGISTERS]      = handle_set_registers,
+	[KVMI_VCPU_TRANSLATE_GVA]      = handle_vcpu_translate_gva,
 };
 
 static void kvmi_job_vcpu_cmd(struct kvm_vcpu *vcpu, void *ctx)
