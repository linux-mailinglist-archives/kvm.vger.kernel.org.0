Return-Path: <kvm+bounces-37045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 345A2A2466D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 02:58:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9FB56166182
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2025 01:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D7CA1A8408;
	Sat,  1 Feb 2025 01:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NP2hW6Ua"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A2B15C15C
	for <kvm@vger.kernel.org>; Sat,  1 Feb 2025 01:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738374940; cv=none; b=aOgnxeTKiRCvTLrZMDSf53uCFAe1KyNhQkqtGX9RapkSSOfQ0ZhYDXnSoztlrI2b/dFwzLkDfgatQzgMGBtd1UCAEAMbWyYYobqHAB+mb8tdZ3cAYH+FM7/7+6oG1X37zt712VeXwnY8DdieFkt2PpVrK4NAzM3/x4DF6F5T5Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738374940; c=relaxed/simple;
	bh=b6etz9i2RP+7QRExjC2SLRQVHjwYvlu/F+QZh/r2q6U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lYJOSRkP+u1cuD2qWH06tMhQ3NVnYNprrQEWpagKckzkiWfxhhUk7asBD4zl6HqyRPfLW8lr+ngoSw8A/pyLI4PGxl8OdD4YlXa+Vmb45JGXxQ5TTxkqZgtxywbmEkmQ+5Iyh9P2mFc9xt3/FEkSTsWGlEL5SF3akw7PrXMnPhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NP2hW6Ua; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef9e38b0cfso4988340a91.0
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 17:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738374938; x=1738979738; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=P9OmM+sDu38vDrQYwzEU5YwA1UJzt3FjXx/dBaYsJEk=;
        b=NP2hW6Ua0MdGpog1jd5NlkOEcb5m+DbqxUJ1zUGJAL4Gyr1J1vF8c5mLynFcz1g587
         GIFRWkOKjXuqtB6Hofvk2vOFuzdwN88IqArgE1SUGbdvrhV5ijSgJpXLugLbbzGRYiRv
         mS5KttbvM+6CTw9PIaCSTxxT8Id/27hrUijhy3pU+bXzl2RBdbS9io4WoP2iOewfG7Hu
         B++b6ESTibM5TKUs+VDqRNJx4DxVrHgKnSy5MJHBW0+5s+RkJJxO64YDvogvc4rjo4jv
         qCzu4m1DrH3x3U6jNWPXRpPzuq0hHo3zNVq3Oq4YXD6DB7i4Nf5QT93seYy1HWkUT7NN
         AdGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738374938; x=1738979738;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P9OmM+sDu38vDrQYwzEU5YwA1UJzt3FjXx/dBaYsJEk=;
        b=WoNePvLcXxjwZnr7i+gXeW+foeD/pjMSuhz8RhayzhPgIYkU4X0OfT9hFP3MrQMHUt
         QhHode5jpNkrBPY6ttfCTapDkOQ3zp2rimR9YXSUc3lM1S8ZKRTdJzXYVEb9gVCpV0l6
         w4OwFMQgm0sGdNpsZi8zJoYZOXLIwygh67CACrPWMfSKfvkJbHCdSDy1l1hkK5lVI3kC
         9117ePfGU6D8YU0gCkWX4XZhbR0VpKy36p7D1PyG33oC8UDyXchySej4ZrrfJLP/E6t8
         pFzh8p6cK61g93X4fAHGLdLr373KXhS75N3bi/F56dMZRXzFqUY6yinyOFnrSNpW5pQQ
         qHNA==
X-Gm-Message-State: AOJu0YxBXrlwU/am9mQ8uCvF7Mx1x/k1S+uawUUAco90RQcQeBRmNaPk
	51SQV8087K1ZXKI/BhFgVgmYX3zUdkMCubD1+3qJtkBwURx9OjQo1aSZ0cNMwnIKxN8PPFbHUfT
	0og==
X-Google-Smtp-Source: AGHT+IGdd3i7WLWE6L1sJjjSeejxkxKdfst0PcdT8Ti/xqhwNIREB3iVs/B5jAoGWZX/W33UitjN50Udz8U=
X-Received: from pjbeu16.prod.google.com ([2002:a17:90a:f950:b0:2ea:756d:c396])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f50:b0:2f8:34df:5652
 with SMTP id 98e67ed59e1d1-2f83ac1a52fmr18331282a91.21.1738374938398; Fri, 31
 Jan 2025 17:55:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 31 Jan 2025 17:55:18 -0800
In-Reply-To: <20250201015518.689704-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250201015518.689704-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250201015518.689704-12-seanjc@google.com>
Subject: [PATCH v2 11/11] KVM: selftests: Add a nested (forced) emulation
 intercept test for x86
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add a rudimentary test for validating KVM's handling of L1 hypervisor
intercepts during instruction emulation on behalf of L2.  To minimize
complexity and avoid overlap with other tests, only validate KVM's
handling of instructions that L1 wants to intercept, i.e. that generate a
nested VM-Exit.  Full testing of emulation on behalf of L2 is better
achieved by running existing (forced) emulation tests in a VM, (although
on VMX, getting L0 to emulate on #UD requires modifying either L1 KVM to
not intercept #UD, or modifying L0 KVM to prioritize L0's exception
intercepts over L1's intercepts, as is done by KVM for SVM).

Since emulation should never be successful, i.e. L2 always exits to L1,
dynamically generate the L2 code stream instead of adding a helper for
each instruction.  Doing so requires hand coding instruction opcodes, but
makes it significantly easier for the test to compute the expected "next
RIP" and instruction length.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/nested_emulation_test.c | 146 ++++++++++++++++++
 2 files changed, 147 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/nested_emulation_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 4277b983cace..f773f8f99249 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -69,6 +69,7 @@ TEST_GEN_PROGS_x86 += x86/hyperv_tlb_flush
 TEST_GEN_PROGS_x86 += x86/kvm_clock_test
 TEST_GEN_PROGS_x86 += x86/kvm_pv_test
 TEST_GEN_PROGS_x86 += x86/monitor_mwait_test
+TEST_GEN_PROGS_x86 += x86/nested_emulation_test
 TEST_GEN_PROGS_x86 += x86/nested_exceptions_test
 TEST_GEN_PROGS_x86 += x86/platform_info_test
 TEST_GEN_PROGS_x86 += x86/pmu_counters_test
diff --git a/tools/testing/selftests/kvm/x86/nested_emulation_test.c b/tools/testing/selftests/kvm/x86/nested_emulation_test.c
new file mode 100644
index 000000000000..abc824dba04f
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/nested_emulation_test.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0-only
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "vmx.h"
+#include "svm_util.h"
+
+enum {
+	SVM_F,
+	VMX_F,
+	NR_VIRTUALIZATION_FLAVORS,
+};
+
+struct emulated_instruction {
+	const char name[32];
+	uint8_t opcode[15];
+	uint32_t exit_reason[NR_VIRTUALIZATION_FLAVORS];
+};
+
+static struct emulated_instruction instructions[] = {
+	{
+		.name = "pause",
+		.opcode = { 0xf3, 0x90 },
+		.exit_reason = { SVM_EXIT_PAUSE,
+				 EXIT_REASON_PAUSE_INSTRUCTION, }
+	},
+	{
+		.name = "hlt",
+		.opcode = { 0xf4 },
+		.exit_reason = { SVM_EXIT_HLT,
+				 EXIT_REASON_HLT, }
+	},
+};
+
+static uint8_t kvm_fep[] = { 0x0f, 0x0b, 0x6b, 0x76, 0x6d };	/* ud2 ; .ascii "kvm" */
+static uint8_t l2_guest_code[sizeof(kvm_fep) + 15];
+static uint8_t *l2_instruction = &l2_guest_code[sizeof(kvm_fep)];
+
+static uint32_t get_instruction_length(struct emulated_instruction *insn)
+{
+	uint32_t i;
+
+	for (i = 0; i < ARRAY_SIZE(insn->opcode) && insn->opcode[i]; i++)
+		;
+
+	return i;
+}
+
+static void guest_code(void *test_data)
+{
+	int f = this_cpu_has(X86_FEATURE_SVM) ? SVM_F : VMX_F;
+	int i;
+
+	memcpy(l2_guest_code, kvm_fep, sizeof(kvm_fep));
+
+	if (f == SVM_F) {
+		struct svm_test_data *svm = test_data;
+		struct vmcb *vmcb = svm->vmcb;
+
+		generic_svm_setup(svm, NULL, NULL);
+		vmcb->save.idtr.limit = 0;
+		vmcb->save.rip = (u64)l2_guest_code;
+
+		vmcb->control.intercept |= BIT_ULL(INTERCEPT_SHUTDOWN) |
+					   BIT_ULL(INTERCEPT_PAUSE) |
+					   BIT_ULL(INTERCEPT_HLT);
+		vmcb->control.intercept_exceptions = 0;
+	} else {
+		GUEST_ASSERT(prepare_for_vmx_operation(test_data));
+		GUEST_ASSERT(load_vmcs(test_data));
+
+		prepare_vmcs(test_data, NULL, NULL);
+		GUEST_ASSERT(!vmwrite(GUEST_IDTR_LIMIT, 0));
+		GUEST_ASSERT(!vmwrite(GUEST_RIP, (u64)l2_guest_code));
+		GUEST_ASSERT(!vmwrite(EXCEPTION_BITMAP, 0));
+
+		vmwrite(CPU_BASED_VM_EXEC_CONTROL, vmreadz(CPU_BASED_VM_EXEC_CONTROL) |
+						   CPU_BASED_PAUSE_EXITING |
+						   CPU_BASED_HLT_EXITING);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(instructions); i++) {
+		struct emulated_instruction *insn = &instructions[i];
+		uint32_t insn_len = get_instruction_length(insn);
+		uint32_t exit_insn_len;
+		u32 exit_reason;
+
+		/*
+		 * Copy the target instruction to the L2 code stream, and fill
+		 * the remaining bytes with INT3s so that a missed intercept
+		 * results in a consistent failure mode (SHUTDOWN).
+		 */
+		memcpy(l2_instruction, insn->opcode, insn_len);
+		memset(l2_instruction + insn_len, 0xcc, sizeof(insn->opcode) - insn_len);
+
+		if (f == SVM_F) {
+			struct svm_test_data *svm = test_data;
+			struct vmcb *vmcb = svm->vmcb;
+
+			run_guest(vmcb, svm->vmcb_gpa);
+			exit_reason = vmcb->control.exit_code;
+			exit_insn_len = vmcb->control.next_rip - vmcb->save.rip;
+			GUEST_ASSERT_EQ(vmcb->save.rip, (u64)l2_instruction);
+		} else {
+			GUEST_ASSERT_EQ(i ? vmresume() : vmlaunch(), 0);
+			exit_reason = vmreadz(VM_EXIT_REASON);
+			exit_insn_len = vmreadz(VM_EXIT_INSTRUCTION_LEN);
+			GUEST_ASSERT_EQ(vmreadz(GUEST_RIP), (u64)l2_instruction);
+		}
+
+		__GUEST_ASSERT(exit_reason == insn->exit_reason[f],
+			       "Wanted exit_reason '0x%x' for '%s', got '0x%x'",
+			       insn->exit_reason[f], insn->name, exit_reason);
+
+		__GUEST_ASSERT(exit_insn_len == insn_len,
+			       "Wanted insn_len '%u' for '%s', got '%u'",
+			       insn_len, insn->name, exit_insn_len);
+	}
+
+	GUEST_DONE();
+}
+
+int main(int argc, char *argv[])
+{
+	vm_vaddr_t nested_test_data_gva;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	TEST_REQUIRE(is_forced_emulation_enabled);
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM) || kvm_cpu_has(X86_FEATURE_VMX));
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vm_enable_cap(vm, KVM_CAP_EXCEPTION_PAYLOAD, -2ul);
+
+	if (kvm_cpu_has(X86_FEATURE_SVM))
+		vcpu_alloc_svm(vm, &nested_test_data_gva);
+	else
+		vcpu_alloc_vmx(vm, &nested_test_data_gva);
+
+	vcpu_args_set(vcpu, 1, nested_test_data_gva);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_EQ(get_ucall(vcpu, NULL), UCALL_DONE);
+
+	kvm_vm_free(vm);
+}
-- 
2.48.1.362.g079036d154-goog


