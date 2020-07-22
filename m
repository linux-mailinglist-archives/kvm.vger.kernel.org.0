Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6232229CB8
	for <lists+kvm@lfdr.de>; Wed, 22 Jul 2020 18:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728612AbgGVQCV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jul 2020 12:02:21 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:37956 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728980AbgGVQBj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Jul 2020 12:01:39 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id 540B3305D761;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
Received: from localhost.localdomain (unknown [91.199.104.6])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 44E27305FFA0;
        Wed, 22 Jul 2020 19:01:32 +0300 (EEST)
From:   =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
To:     kvm@vger.kernel.org
Cc:     virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?=C8=98tefan=20=C8=98icleru?= <ssicleru@bitdefender.com>,
        =?UTF-8?q?Adalbert=20Laz=C4=83r?= <alazar@bitdefender.com>
Subject: [RFC PATCH v1 13/34] KVM: introspection: add KVMI_VCPU_GET_EPT_VIEW
Date:   Wed, 22 Jul 2020 19:01:00 +0300
Message-Id: <20200722160121.9601-14-alazar@bitdefender.com>
In-Reply-To: <20200722160121.9601-1-alazar@bitdefender.com>
References: <20200722160121.9601-1-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ștefan Șicleru <ssicleru@bitdefender.com>

The introspection tool uses this function to check the hardware support
for EPT switching, which can be used either to singlestep vCPUs
on a unprotected EPT view or to use #VE in order to avoid filter out
VM-exits caused by EPT violations.

Signed-off-by: Ștefan Șicleru <ssicleru@bitdefender.com>
Signed-off-by: Adalbert Lazăr <alazar@bitdefender.com>
---
 Documentation/virt/kvm/kvmi.rst               | 34 +++++++++++++++++++
 arch/x86/include/uapi/asm/kvmi.h              |  6 ++++
 arch/x86/kvm/kvmi.c                           |  5 +++
 include/uapi/linux/kvmi.h                     |  1 +
 .../testing/selftests/kvm/x86_64/kvmi_test.c  | 28 +++++++++++++++
 virt/kvm/introspection/kvmi_int.h             |  1 +
 virt/kvm/introspection/kvmi_msg.c             | 14 ++++++++
 7 files changed, 89 insertions(+)

diff --git a/Documentation/virt/kvm/kvmi.rst b/Documentation/virt/kvm/kvmi.rst
index 234eacec4db1..76a2d0125f78 100644
--- a/Documentation/virt/kvm/kvmi.rst
+++ b/Documentation/virt/kvm/kvmi.rst
@@ -1120,6 +1120,40 @@ the address cannot be translated.
 * -KVM_EINVAL - the padding is not zero
 * -KVM_EAGAIN - the selected vCPU can't be introspected yet
 
+26. KVMI_VCPU_GET_EPT_VIEW
+--------------------------
+
+:Architecture: x86
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
+	struct kvmi_vcpu_get_ept_view_reply {
+		__u16 view;
+		__u16 padding1;
+		__u32 padding2;
+	};
+
+Returns the EPT ``view`` the provided vCPU operates on.
+
+Before getting EPT views, the introspection tool should use
+*KVMI_GET_VERSION* to check if the hardware has support for VMFUNC and
+EPTP switching mechanism (see **KVMI_GET_VERSION**).  If the hardware
+does not provide support for these features, the returned EPT view will
+be zero.
+
+* -KVM_EINVAL - the selected vCPU is invalid
+* -KVM_EINVAL - the padding is not zero
+* -KVM_EAGAIN - the selected vCPU can't be introspected yet
+
 Events
 ======
 
diff --git a/arch/x86/include/uapi/asm/kvmi.h b/arch/x86/include/uapi/asm/kvmi.h
index 51b399d50a2a..3087c685c232 100644
--- a/arch/x86/include/uapi/asm/kvmi.h
+++ b/arch/x86/include/uapi/asm/kvmi.h
@@ -152,4 +152,10 @@ struct kvmi_features {
 	__u8 padding[5];
 };
 
+struct kvmi_vcpu_get_ept_view_reply {
+	__u16 view;
+	__u16 padding1;
+	__u32 padding2;
+};
+
 #endif /* _UAPI_ASM_X86_KVMI_H */
diff --git a/arch/x86/kvm/kvmi.c b/arch/x86/kvm/kvmi.c
index 25c1f8f2e221..bd31809ff812 100644
--- a/arch/x86/kvm/kvmi.c
+++ b/arch/x86/kvm/kvmi.c
@@ -1417,3 +1417,8 @@ bool kvmi_update_ad_flags(struct kvm_vcpu *vcpu)
 
 	return ret;
 }
+
+u16 kvmi_arch_cmd_get_ept_view(struct kvm_vcpu *vcpu)
+{
+	return kvm_get_ept_view(vcpu);
+}
diff --git a/include/uapi/linux/kvmi.h b/include/uapi/linux/kvmi.h
index 3c15c17d28e3..cf3422ec60a8 100644
--- a/include/uapi/linux/kvmi.h
+++ b/include/uapi/linux/kvmi.h
@@ -49,6 +49,7 @@ enum {
 
 	KVMI_VCPU_CONTROL_SINGLESTEP = 24,
 	KVMI_VCPU_TRANSLATE_GVA      = 25,
+	KVMI_VCPU_GET_EPT_VIEW       = 26,
 
 	KVMI_NUM_MESSAGES
 };
diff --git a/tools/testing/selftests/kvm/x86_64/kvmi_test.c b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
index 33fffcb3a171..74eafbcae14a 100644
--- a/tools/testing/selftests/kvm/x86_64/kvmi_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvmi_test.c
@@ -2071,6 +2071,33 @@ static void test_cmd_translate_gva(struct kvm_vm *vm)
 		(vm_vaddr_t)-1, (vm_paddr_t)-1);
 }
 
+static __u16 get_ept_view(struct kvm_vm *vm)
+{
+	struct {
+		struct kvmi_msg_hdr hdr;
+		struct kvmi_vcpu_hdr vcpu_hdr;
+	} req = {};
+	struct kvmi_vcpu_get_ept_view_reply rpl;
+
+	test_vcpu0_command(vm, KVMI_VCPU_GET_EPT_VIEW,
+			   &req.hdr, sizeof(req), &rpl, sizeof(rpl));
+
+	return rpl.view;
+}
+
+static void test_cmd_vcpu_get_ept_view(struct kvm_vm *vm)
+{
+	__u16 view;
+
+	if (!features.eptp) {
+		print_skip("EPT views not supported");
+		return;
+	}
+
+	view = get_ept_view(vm);
+	pr_info("EPT view %u\n", view);
+}
+
 static void test_introspection(struct kvm_vm *vm)
 {
 	srandom(time(0));
@@ -2107,6 +2134,7 @@ static void test_introspection(struct kvm_vm *vm)
 	test_event_pf(vm);
 	test_cmd_vcpu_control_singlestep(vm);
 	test_cmd_translate_gva(vm);
+	test_cmd_vcpu_get_ept_view(vm);
 
 	unhook_introspection(vm);
 }
diff --git a/virt/kvm/introspection/kvmi_int.h b/virt/kvm/introspection/kvmi_int.h
index cb8453f0fb87..f88999bf59e8 100644
--- a/virt/kvm/introspection/kvmi_int.h
+++ b/virt/kvm/introspection/kvmi_int.h
@@ -142,5 +142,6 @@ void kvmi_arch_features(struct kvmi_features *feat);
 bool kvmi_arch_start_singlestep(struct kvm_vcpu *vcpu);
 bool kvmi_arch_stop_singlestep(struct kvm_vcpu *vcpu);
 gpa_t kvmi_arch_cmd_translate_gva(struct kvm_vcpu *vcpu, gva_t gva);
+u16 kvmi_arch_cmd_get_ept_view(struct kvm_vcpu *vcpu);
 
 #endif
diff --git a/virt/kvm/introspection/kvmi_msg.c b/virt/kvm/introspection/kvmi_msg.c
index d8874bd7a8b7..6cb3473190db 100644
--- a/virt/kvm/introspection/kvmi_msg.c
+++ b/virt/kvm/introspection/kvmi_msg.c
@@ -661,6 +661,19 @@ static int handle_vcpu_translate_gva(const struct kvmi_vcpu_msg_job *job,
 	return kvmi_msg_vcpu_reply(job, msg, 0, &rpl, sizeof(rpl));
 }
 
+static int handle_vcpu_get_ept_view(const struct kvmi_vcpu_msg_job *job,
+				    const struct kvmi_msg_hdr *msg,
+				    const void *req)
+{
+	struct kvmi_vcpu_get_ept_view_reply rpl;
+
+	memset(&rpl, 0, sizeof(rpl));
+
+	rpl.view = kvmi_arch_cmd_get_ept_view(job->vcpu);
+
+	return kvmi_msg_vcpu_reply(job, msg, 0, &rpl, sizeof(rpl));
+}
+
 /*
  * These functions are executed from the vCPU thread. The receiving thread
  * passes the messages using a newly allocated 'struct kvmi_vcpu_msg_job'
@@ -675,6 +688,7 @@ static int(*const msg_vcpu[])(const struct kvmi_vcpu_msg_job *,
 	[KVMI_VCPU_CONTROL_MSR]        = handle_vcpu_control_msr,
 	[KVMI_VCPU_CONTROL_SINGLESTEP] = handle_vcpu_control_singlestep,
 	[KVMI_VCPU_GET_CPUID]          = handle_vcpu_get_cpuid,
+	[KVMI_VCPU_GET_EPT_VIEW]       = handle_vcpu_get_ept_view,
 	[KVMI_VCPU_GET_INFO]           = handle_vcpu_get_info,
 	[KVMI_VCPU_GET_MTRR_TYPE]      = handle_vcpu_get_mtrr_type,
 	[KVMI_VCPU_GET_REGISTERS]      = handle_vcpu_get_registers,
