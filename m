Return-Path: <kvm+bounces-72923-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mIR7IR3EqWm2EQEAu9opvQ
	(envelope-from <kvm+bounces-72923-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:57:49 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E46BA216A51
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 18:57:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 529813053675
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2026 17:50:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC83647F2ED;
	Thu,  5 Mar 2026 17:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CN7l5v3e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848F447DFA8;
	Thu,  5 Mar 2026 17:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772732707; cv=none; b=BB5njfHgQk5CxpPAw8mOz4TxuMk1Z02wITM4W84gVNkSEWKCiegpsFUtkjTOlZeKFXGIL88NbOtPslB+Hnvohzlt3wHxXATab3/TcOsvtzm5VWtYUv9LnYAlN/JDfgnApiUPAGjLmN45yfkk75YxG2iy+WXwUflxcXWYmYKPM0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772732707; c=relaxed/simple;
	bh=kQ0CuBb7Q7+35jEaO5dVDxI7MgYm7NKrH5dxieMJ5jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfzMMvvzLk9TByytTRzxmlQfkz7PFWrLOYZ1WKb8hCUgtVJwib9flyy87SBJeRinVzpvKYU+uWlIvUs2ws1AmVdu2O5BoupUzV3Ux9FPcpxem69LWDo310jBUQ2FqNfutHyZW6fHXcC+Z/yesOC0PnBRsDlX3I+fpHAqTZ8R5BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CN7l5v3e; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772732705; x=1804268705;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kQ0CuBb7Q7+35jEaO5dVDxI7MgYm7NKrH5dxieMJ5jk=;
  b=CN7l5v3ethOPoYwBb9MCNgbAk4r5aX5BE6MfjXH0zYZWIDxoTmZiQAPN
   MoxnZjHcbER48NgmE0aDlLrMj5OWMSSWvItRimjmVYmJEFx4i48t3TEan
   q3Y+8RfRouBfGaoApBsOBeV4yxEusPPjNTrndKiIBhRdtEAQhc6CNHmt9
   ONna7ZWRMT5XOqb4zubJFyrxYnhqjcR3N5UvXb9J6rzHk7Egz/i/0TGgX
   2Nqbuy5mKLHwVu36p3kexu4nm+ow/Qi1SPoUd3LmZ47X+n6V2PNrhj8dl
   Y3Mh/LLqiX4Yzv3jZx3NDe6FoyS+RRta3bTfq8Uy6VHJwKOqF01NAYFe6
   A==;
X-CSE-ConnectionGUID: aV0DfMm6SayrTMpN9HL6tQ==
X-CSE-MsgGUID: otYmvnnzSo6PLWPFmgXsdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="85301990"
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="85301990"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:56 -0800
X-CSE-ConnectionGUID: xxhPB5U8S6OGiz1F5I2KUA==
X-CSE-MsgGUID: WCLlac57QqiMSE0Q+unE+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,103,1770624000"; 
   d="scan'208";a="222896557"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.220.244])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2026 09:44:55 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org,
	syzbot+ci66a37fb2e2f8de71@syzkaller.appspotmail.com
Subject: [PATCH v2 35/36] KVM: selftests: Test VMX apic timer virt with inkernel apic disable
Date: Thu,  5 Mar 2026 09:44:15 -0800
Message-ID: <d4195a040c68667c9a86b810b8375dfa17539a92.1772732517.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1772732517.git.isaku.yamahata@intel.com>
References: <cover.1772732517.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E46BA216A51
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[intel.com,gmail.com,redhat.com,google.com,vger.kernel.org,syzkaller.appspotmail.com];
	TAGGED_FROM(0.00)[bounces-72923-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_NO_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	RCPT_COUNT_SEVEN(0.00)[7];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm,ci66a37fb2e2f8de71];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[isaku.yamahata@intel.com,kvm@vger.kernel.org]
X-Rspamd-Action: no action

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add a test case to excercize APIC timer virtuliazation support with
inkernel APIC disabled as Syzbot reported GP fault if inkernel APIC is
disabled.

Reported-by: syzbot+ci66a37fb2e2f8de71@syzkaller.appspotmail.com
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
--
Changes v1 -> v2:
- Newly added.
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../kvm/x86/vmx_tertiary_ctls_test.c          | 168 ++++++++++++++++++
 2 files changed, 169 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/vmx_tertiary_ctls_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 424ae9a56481..928b665f8086 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -148,6 +148,7 @@ TEST_GEN_PROGS_x86 += x86/aperfmperf_test
 TEST_GEN_PROGS_x86 += x86/timer_latency
 TEST_GEN_PROGS_x86 += x86/vmx_apic_timer_virt_test
 TEST_GEN_PROGS_x86 += x86/vmx_apic_timer_virt_vmcs_test
+TEST_GEN_PROGS_x86 += x86/vmx_tertiary_ctls_test
 TEST_GEN_PROGS_x86 += access_tracking_perf_test
 TEST_GEN_PROGS_x86 += coalesced_io_test
 TEST_GEN_PROGS_x86 += dirty_log_perf_test
diff --git a/tools/testing/selftests/kvm/x86/vmx_tertiary_ctls_test.c b/tools/testing/selftests/kvm/x86/vmx_tertiary_ctls_test.c
new file mode 100644
index 000000000000..9ef120e00d6d
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/vmx_tertiary_ctls_test.c
@@ -0,0 +1,168 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * VMX tertiary controls test
+ *
+ * Copyright (C) 2026 Intel Corporation
+ */
+#include "kvm_util.h"
+#include "vmx.h"
+
+static bool has_guest_apic_timer_virt = true;
+#define TIMER_VECTOR	0xec
+
+#define L2_GUEST_STACK_SIZE 64
+static unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+
+static void l2_guest_code(void)
+{
+	vmcall();
+
+	/* L1 stops L2 vcpu at above vmcall(). */
+	GUEST_FAIL("L2 should not reach here.");
+}
+
+static void setup_l2(struct vmx_pages *vmx_pages)
+{
+	uint64_t ctls;
+
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx_pages));
+	GUEST_ASSERT(load_vmcs(vmx_pages));
+	prepare_vmcs(vmx_pages, l2_guest_code,
+		     &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	GUEST_ASSERT(!vmread(PIN_BASED_VM_EXEC_CONTROL, &ctls));
+	ctls |= PIN_BASED_EXT_INTR_MASK;
+	GUEST_ASSERT(!vmwrite(PIN_BASED_VM_EXEC_CONTROL, ctls));
+
+	GUEST_ASSERT(!vmread(CPU_BASED_VM_EXEC_CONTROL, &ctls));
+	ctls |= CPU_BASED_USE_MSR_BITMAPS | CPU_BASED_TPR_SHADOW |
+		CPU_BASED_ACTIVATE_SECONDARY_CONTROLS;
+	ctls |= CPU_BASED_ACTIVATE_TERTIARY_CONTROLS;
+	GUEST_ASSERT(!vmwrite(CPU_BASED_VM_EXEC_CONTROL, ctls));
+
+	GUEST_ASSERT(!vmread(SECONDARY_VM_EXEC_CONTROL, &ctls));
+	ctls |= SECONDARY_EXEC_VIRTUALIZE_X2APIC_MODE |
+		SECONDARY_EXEC_APIC_REGISTER_VIRT |
+		SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY;
+	GUEST_ASSERT(!vmwrite(SECONDARY_VM_EXEC_CONTROL, ctls));
+
+	GUEST_ASSERT(!vmread(TERTIARY_VM_EXEC_CONTROL, &ctls));
+	ctls |= TERTIARY_EXEC_GUEST_APIC_TIMER;
+	/*
+	 * vmwrite() succeeds even if unsuported bit is set.
+	 * follwoing vmenter will fail instead.
+	 */
+	GUEST_ASSERT(!vmwrite(TERTIARY_VM_EXEC_CONTROL, ctls));
+
+	if (has_guest_apic_timer_virt) {
+		GUEST_ASSERT(!vmwrite(GUEST_DEADLINE_VIR, 0));
+		GUEST_ASSERT(!vmwrite(GUEST_DEADLINE_PHY, 0));
+		GUEST_ASSERT(!vmwrite(GUEST_APIC_TIMER_VECTOR, TIMER_VECTOR));
+	} else {
+		GUEST_ASSERT(vmwrite(GUEST_DEADLINE_VIR, 0));
+		GUEST_ASSERT(vmwrite(GUEST_DEADLINE_PHY, 0));
+		GUEST_ASSERT(vmwrite(GUEST_APIC_TIMER_VECTOR, TIMER_VECTOR));
+	}
+}
+
+static void l1_guest_code(struct vmx_pages *vmx_pages)
+{
+	/* Prepare the VMCS for L2 execution. */
+	setup_l2(vmx_pages);
+
+	/* Run L2 */
+	if (!has_guest_apic_timer_virt) {
+		uint64_t ctls3;
+
+		GUEST_ASSERT(vmlaunch());
+
+		GUEST_ASSERT(!vmread(TERTIARY_VM_EXEC_CONTROL, &ctls3));
+		ctls3 &= ~TERTIARY_EXEC_GUEST_APIC_TIMER;
+		GUEST_ASSERT(!vmwrite(TERTIARY_VM_EXEC_CONTROL, ctls3));
+	}
+	GUEST_ASSERT(!vmlaunch());
+	GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
+
+	GUEST_DONE();
+}
+
+static void vmx_tertiary_controls_test(void)
+{
+	uint64_t ctls, ctls3, r;
+	struct kvm_vcpu *vcpu;
+	vm_vaddr_t guest_gva;
+	struct kvm_vm *vm;
+	bool done;
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+	vcpu_alloc_vmx(vm, &guest_gva);
+	vcpu_args_set(vcpu, 1, guest_gva);
+
+	ctls = vcpu_get_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS);
+	ctls |= (uint64_t)CPU_BASED_ACTIVATE_TERTIARY_CONTROLS << 32;
+	vcpu_set_msr(vcpu, MSR_IA32_VMX_TRUE_PROCBASED_CTLS, ctls);
+
+	ctls3 = vcpu_get_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3);
+	ctls3 |= TERTIARY_EXEC_GUEST_APIC_TIMER;
+
+	r = _vcpu_set_msr(vcpu, MSR_IA32_VMX_PROCBASED_CTLS3, ctls3);
+	if (has_guest_apic_timer_virt)
+		TEST_ASSERT_MSR(r == 1,
+			       "KVM_SET_MSR on %s failed value = 0x%lx",
+				MSR_IA32_VMX_PROCBASED_CTLS3,
+				"MSR_IA32_VMX_PROCBASED_CTLS3",
+				ctls3);
+	else {
+		TEST_ASSERT_MSR(r != 1,
+				"KVM_SET_MSR on %s should fail value = 0x%lx",
+				MSR_IA32_VMX_PROCBASED_CTLS3,
+				"MSR_IA32_VMX_PROCBASED_CTLS3",
+				ctls3);
+	}
+	sync_global_to_guest(vm, has_guest_apic_timer_virt);
+
+	done = false;
+	while (!done) {
+		struct ucall uc;
+
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			/* NOT REACHED */
+		case UCALL_DONE:
+			done = true;
+			break;
+		default:
+			TEST_ASSERT(false, "Unknown ucall %lu", uc.cmd);
+		}
+	}
+
+	kvm_vm_free(vm);
+}
+
+int main(void)
+{
+	union vmx_ctrl_msr ctls;
+	uint64_t ctls3;
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX));
+
+	ctls.val = kvm_get_feature_msr(MSR_IA32_VMX_TRUE_PROCBASED_CTLS);
+	TEST_REQUIRE(ctls.clr & CPU_BASED_ACTIVATE_TERTIARY_CONTROLS);
+
+	ctls3 = kvm_get_feature_msr(MSR_IA32_VMX_PROCBASED_CTLS3);
+	has_guest_apic_timer_virt = ctls3 & TERTIARY_EXEC_GUEST_APIC_TIMER;
+
+	disable_inkernel_irqchip = false;
+	vmx_tertiary_controls_test();
+
+	/* nested apic timer virtualization requires in-kernel apic */
+	disable_inkernel_irqchip = true;
+	has_guest_apic_timer_virt = false;
+	vmx_tertiary_controls_test();
+
+	return 0;
+}
-- 
2.45.2


