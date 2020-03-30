Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A96197904
	for <lists+kvm@lfdr.de>; Mon, 30 Mar 2020 12:20:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729853AbgC3KUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Mar 2020 06:20:54 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:43782 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729040AbgC3KUD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 30 Mar 2020 06:20:03 -0400
Received: from smtp.bitdefender.com (smtp02.buh.bitdefender.net [10.17.80.76])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 75157305D3D5;
        Mon, 30 Mar 2020 13:13:02 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.28])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 15698305B7A9;
        Mon, 30 Mar 2020 13:13:02 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [PATCH v8 79/81] KVM: introspection: add KVMI_VCPU_TRANSLATE_GVA
Date:   Mon, 30 Mar 2020 13:13:06 +0300
Message-Id: <20200330101308.21702-80-alazar@bitdefender.com>
In-Reply-To: <20200330101308.21702-1-alazar@bitdefender.com>
References: <20200330101308.21702-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This helps the introspection tool with the GVA to GPA translations
without the need to monitor the guest page tables.

Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 31 +++++++++++++++++++
 arch/x86/kvm/kvmi.c                           |  4 +++
 include/uapi/linux/kvmi.h                     |  9 ++++++
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 31 +++++++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 16 ++++++++++
 6 files changed, 92 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index c761438801dd..c45643ebec3b 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -991,6 +991,37 @@ to the introspection tool.
 * -KVM_EINVAL - the padding is not zero
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
index 729f91a66405..d339a879ba0b 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1228,3 +1228,7 @@ bool kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu)
 	return true;
 }
 
+gpa_t kvmi_arch_cmd_translate_gva(struct kvm_vcpu *vcpu, gva_t gva)
+{
+	return kvm_mmu_gva_to_gpa_system(vcpu, gva, 0, NULL);
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index d69735918fd6..52e305a76c3b 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -43,6 +43,7 @@ enum {
 	KVMI_VM_SET_PAGE_ACCESS = 21,
 
 	KVMI_VCPU_CONTROL_SINGLESTEP = 22,
+	KVMI_VCPU_TRANSLATE_GVA      = 23,
 
 	KVMI_NUM_MESSAGES
 };
@@ -215,4 +216,12 @@ struct kvmi_event_singlestep {
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
index 24dfcba113cd..cb4973141051 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -1752,6 +1752,36 @@ static void test_cmd_vcpu_control_singlestep(struct kvm_vm *vm)
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
 	srandom(time(0));
@@ -1785,6 +1815,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_cmd_vm_set_page_access(vm);
 	test_event_pf(vm);
 	test_cmd_vcpu_control_singlestep(vm);
+	test_cmd_translate_gva(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index 820081f8e3f1..88fe3d67d580 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -130,5 +130,6 @@ bool kvmi_arch_pf_of_interest(struct kvm_vcpu *vcpu);
 void kvmi_arch_features(struct kvmi_features *feat);
 bool kvmi_arch_start_singlestep(struct kvm_vcpu *vcpu);
 bool kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu);
+gpa_t kvmi_arch_cmd_translate_gva(struct kvm_vcpu *vcpu, gva_t gva);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index 43762e4b7c5c..c7af2b5701eb 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -42,6 +42,7 @@ static const char *const msg_IDs[] = {
 	[KVMI_VCPU_INJECT_EXCEPTION]   = "KVMI_VCPU_INJECT_EXCEPTION",
 	[KVMI_VCPU_PAUSE]              = "KVMI_VCPU_PAUSE",
 	[KVMI_VCPU_SET_REGISTERS]      = "KVMI_VCPU_SET_REGISTERS",
+	[KVMI_VCPU_TRANSLATE_GVA]      = "KVMI_VCPU_TRANSLATE_GVA",
 };
 
 static const char *id2str(u16 id)
@@ -653,6 +654,20 @@ static int handle_vcpu_control_singlestep(const struct kvmi_vcpu_cmd_job *job,
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
  * These commands are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_cmd_job'
@@ -673,6 +688,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_cmd_job *,
 	[KVMI_VCPU_GET_XSAVE]          = handle_vcpu_get_xsave,
 	[KVMI_VCPU_INJECT_EXCEPTION]   = handle_vcpu_inject_exception,
 	[KVMI_VCPU_SET_REGISTERS]      = handle_set_registers,
+	[KVMI_VCPU_TRANSLATE_GVA]      = handle_vcpu_translate_gva,
 };
 
 static bool is_vcpu_command(u16 id)
