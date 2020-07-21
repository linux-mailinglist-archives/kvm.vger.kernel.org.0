Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61734228ACC
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731454AbgGUVRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:17:10 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37924 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731234AbgGUVQL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jul 2020 17:16:11 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 29629305D50A;
        Wed, 22 Jul 2020 00:09:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.27])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 0FD45304FA15;
        Wed, 22 Jul 2020 00:09:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v9 82/84] KVM: introspection: add KVMI_VCPU_TRANSLATE_GVA
Date:   Wed, 22 Jul 2020 00:09:20 +0300
Message-Id: <20200721210922.7646-83-alazar@bitdefender.com>
In-Reply-To: <20200721210922.7646-1-alazar@bitdefender.com>
References: <20200721210922.7646-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This helps the introspection tool with the GVA to GPA translations
without the need to read or monitor the guest page tables.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 32 +++++++++++++++++++
 arch/x86/kvm/kvmi.c                           |  5 +++
 include/uapi/linux/kvmi.h                     |  9 ++++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 30 +++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 15 +++++++++
 6 files changed, 92 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 3c481c1b2186..62138fa4b65c 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -1086,6 +1086,38 @@ to the introspection tool.
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+25. KVMI_VCPU_TRANSLATE_GVA
+---------------------------
+
+:Architecture: x86
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
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 18713004152d..8051d06064ab 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1373,3 +1373,8 @@ bool kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu)
 	kvm_x86_ops.control_singlestep(vcpu, false);
 	return true;
 }
+
+gpa_t kvmi_arch_cmd_translate_gva(struct kvm_vcpu *vcpu, gva_t gva)
+{
+	return kvm_mmu_gva_to_gpa_system(vcpu, gva, 0, NULL);
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 040049abd450..3c15c17d28e3 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -48,6 +48,7 @@ enum {
 	KVMI_VM_SET_PAGE_ACCESS = 23,
 
 	KVMI_VCPU_CONTROL_SINGLESTEP = 24,
+	KVMI_VCPU_TRANSLATE_GVA      = 25,
 
 	KVMI_NUM_MESSAGES
 };
@@ -242,4 +243,12 @@ struct kvmi_event_singlestep {
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
index 967ea568d93c..e968b1a6f969 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -2040,6 +2040,35 @@ static void test_cmd_vcpu_control_singlestep(struct kvm_vm *vm)
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
+			  &rpl, sizeof(rpl));
+	TEST_ASSERT(rpl.gpa == expected_gpa,
+		    "Translation failed for gva 0x%lx -> gpa 0x%llx instead of 0x%lx\n",
+		    gva, rpl.gpa, expected_gpa);
+}
+
+static void test_cmd_translate_gva(struct kvm_vm *vm)
+{
+	cmd_translate_gva(vm, test_gva, test_gpa);
+	pr_info("Tested gva 0x%lx to gpa 0x%lx\n", test_gva, test_gpa);
+
+	cmd_translate_gva(vm, -1, ~0);
+	pr_info("Tested gva 0x%lx to gpa 0x%lx\n",
+		(vm_vaddr_t)-1, (vm_paddr_t)-1);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -2075,6 +2104,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_set_page_access(vm);
 	test_event_pf(vm);
 	test_cmd_vcpu_control_singlestep(vm);
+	test_cmd_translate_gva(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index e5fca3502bab..cb8453f0fb87 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -141,5 +141,6 @@ void kvmi_arch_unhook(struct kvm *kvm);
 void kvmi_arch_features(struct kvmi_features *feat);
 bool kvmi_arch_start_singlestep(struct kvm_vcpu *vcpu);
 bool kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu);
+gpa_t kvmi_arch_cmd_translate_gva(struct kvm_vcpu *vcpu, gva_t gva);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 645debc47f13..d8874bd7a8b7 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -647,6 +647,20 @@ static int handle_vcpu_control_singlestep(const struct kvmi_vcpu_msg_job *job,
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
+	rpl.gpa = kvmi_arch_cmd_translate_gva(job->vcpu, req->gva);
+
+	return kvmi_msg_vcpu_reply(job, msg, 0, &rpl, sizeof(rpl));
+}
+
 /*
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -669,6 +683,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 	[KVMI_VCPU_INJECT_EXCEPTION]   = handle_vcpu_inject_exception,
 	[KVMI_VCPU_SET_REGISTERS]      = handle_vcpu_set_registers,
 	[KVMI_VCPU_SET_XSAVE]          = handle_vcpu_set_xsave,
+	[KVMI_VCPU_TRANSLATE_GVA]      = handle_vcpu_translate_gva,
 };
 
 static bool is_vcpu_command(u16 id)
