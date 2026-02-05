Return-Path: <kvm+bounces-70372-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mEGUNxYQhWms7wMAu9opvQ
	(envelope-from <kvm+bounces-70372-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:48:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AB84F7DF6
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 22:48:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2BC753092544
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 21:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0089F33A6F1;
	Thu,  5 Feb 2026 21:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2CXF8Ou8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2826B339B3C
	for <kvm@vger.kernel.org>; Thu,  5 Feb 2026 21:43:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770327830; cv=none; b=nYgiE04jt4N1veLSak4kqOmT8WDEQKW+Kzs4KM8fPhImjFKngtVzbVaF5Qbvbona7g3hTmP5WVCkp1j9vcmCfJStwY4akQ2lgZunGV+c08WQoJzzYSK7b5Wv6FmZakWmUcq19GRnIKM6gcF1M3WDn91JbAL+NOiNBBMINIhC1Bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770327830; c=relaxed/simple;
	bh=JZ5ruax6Fqre5VIwRYbUJVDDyy/C2tkKudh0Pd6yX/M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BgdBJz77TiOZIe0GF0u7xv3HtLvan4oFzDGXejovUVzimVSYjb3hkjXxXPNTRfNJIGMAv1Ijm1qwwDCziMV1+UTSgyz/8hrFwQiwCE/sCbW70B7vAYzHLhgFEUbPOI5+5XSn1XSVtwg0pCyKdGo7SLm8k1YkyCNJFEzyXf0/aXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2CXF8Ou8; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a946c0e441so10099755ad.1
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 13:43:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770327829; x=1770932629; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1yRMb4qc+aRpKM0YfgdxkNe0DvJ7aTkEuu9+gYbrEts=;
        b=2CXF8Ou81t60wqGx1B4aiqHvpCDSZJPGD4UK0Vv1Lp1U64bZPb7pONh+KURj9HBich
         jAAdrY0MpXemYjgwUW5vJgVZdXKUaOSObVR/tGefyhuZmt71LK3YiAMRnF/FmsJAivuk
         sb5DW7FTyY+XwKWgNzVmJxhSmTxPyuxO24E7QkOErCwY0DsAZ47Cd8ely5CxQpvw/9Hv
         tocZYNj/zsL7PUiXa4LjFS8NG0CLgLNRw8SuFXyDdQgpMCUGg7h/jvh56Xtg/Fi3cCRw
         zErIPnRZFunXl6QozOmFznrR9FqLseyFaJsnMjVVJbM++YCqdNhP4Mb9QFlcL9wQDyUI
         T4fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770327829; x=1770932629;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1yRMb4qc+aRpKM0YfgdxkNe0DvJ7aTkEuu9+gYbrEts=;
        b=SxZQCT5LH/9DfF649d5gdWDZ044e9m6fJ1ighTvz9B1SkXB60yPsOQeMYCzLFSOn6N
         AAfDZtWauFVN5i2q/hsOK68ht3yTwg+HWecLVbKrE9/ho5fnAHE7VUiBYFU3FzbRyBkV
         8YbX2lsdUFfd87V4bSh3+PXOfDsm7D3hvZ/JojkGp7diVGVo2pMtrtZuesXMGT4fNDfp
         ZBQde65hqyCGwlcVrOYBsBcwbVsUWyylfoFA/uC2CxFGsJ2ljqrRm7vJl/g6BBBADzQH
         MNs7785ivmI+0QE9WsnHbf9QYmhJtwyR5lrg3Xu0JqctW/w7lMUXIQ6aY8RbB+eOWVJ4
         6xNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNSU3k6QLUBJQ3Q1RUyKdOa/SjLxirFkEraVLJZTMY2qyneNoVBkYVv87/FSdExs07FT8=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywv2WOr5i6hkj7RnWTkveB1WJXgLv3r6XGz9XrAcAhxsxu+Pj2q
	/BHpwmfIaXlO0h9ezLnc7WZijywCAlepvGYsgoBaK08DbUA7wg89winF3PRiIn9Jk1Ju+V3L5cA
	jpj+PDkcJPb5znw==
X-Received: from pjbqd12.prod.google.com ([2002:a17:90b:3ccc:b0:352:b687:3b20])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4f45:b0:343:7714:4cab with SMTP id 98e67ed59e1d1-354b3e2f162mr294708a91.22.1770327829498;
 Thu, 05 Feb 2026 13:43:49 -0800 (PST)
Date: Thu,  5 Feb 2026 13:43:08 -0800
In-Reply-To: <20260205214326.1029278-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260205214326.1029278-1-jmattson@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260205214326.1029278-9-jmattson@google.com>
Subject: [PATCH v3 8/8] KVM: selftests: nSVM: Add svm_nested_pat test
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70372-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[14];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8AB84F7DF6
X-Rspamd-Action: no action

Verify that when nested NPT is enabled, L1 and L2 have independent PATs,
and changes to the PAT by either guest are not visible to the other.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/svm_nested_pat_test.c   | 298 ++++++++++++++++++
 2 files changed, 299 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_pat_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 58eee0474db6..dddaaa6ac157 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -110,6 +110,7 @@ TEST_GEN_PROGS_x86 += x86/state_test
 TEST_GEN_PROGS_x86 += x86/vmx_preemption_timer_test
 TEST_GEN_PROGS_x86 += x86/svm_vmcall_test
 TEST_GEN_PROGS_x86 += x86/svm_int_ctl_test
+TEST_GEN_PROGS_x86 += x86/svm_nested_pat_test
 TEST_GEN_PROGS_x86 += x86/svm_nested_shutdown_test
 TEST_GEN_PROGS_x86 += x86/svm_nested_soft_inject_test
 TEST_GEN_PROGS_x86 += x86/tsc_scaling_sync
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_pat_test.c b/tools/testing/selftests/kvm/x86/svm_nested_pat_test.c
new file mode 100644
index 000000000000..08c1428969b0
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/svm_nested_pat_test.c
@@ -0,0 +1,298 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM nested SVM PAT test
+ *
+ * Copyright (C) 2026, Google LLC.
+ *
+ * Test that KVM correctly virtualizes the PAT MSR and VMCB g_pat field
+ * for nested SVM guests:
+ *
+ * o With nested NPT disabled:
+ *     - L1 and L2 share the same PAT
+ *     - The vmcb12.g_pat is ignored
+ * o With nested NPT enabled:
+ *     - Invalid g_pat in vmcb12 should cause VMEXIT_INVALID
+ *     - L2 should see vmcb12.g_pat via RDMSR, not L1's PAT
+ *     - L2's writes to PAT should be saved to vmcb12 on exit
+ *     - L1's PAT should be restored after #VMEXIT from L2
+ *     - State save/restore should preserve both L1's and L2's PAT values
+ */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+
+#define L2_GUEST_STACK_SIZE 256
+
+#define PAT_DEFAULT		0x0007040600070406ULL
+#define L1_PAT_VALUE		0x0007040600070404ULL  /* Change PA0 to WT */
+#define L2_VMCB12_PAT		0x0606060606060606ULL  /* All WB */
+#define L2_PAT_MODIFIED		0x0606060606060604ULL  /* Change PA0 to WT */
+#define INVALID_PAT_VALUE	0x0808080808080808ULL  /* 8 is reserved */
+
+/*
+ * Shared state between L1 and L2 for verification.
+ */
+struct pat_test_data {
+	uint64_t l2_pat_read;
+	uint64_t l2_pat_after_write;
+	uint64_t l1_pat_after_vmexit;
+	uint64_t vmcb12_gpat_after_exit;
+	bool l2_done;
+};
+
+static struct pat_test_data *pat_data;
+
+static void l2_guest_code(void)
+{
+	pat_data->l2_pat_read = rdmsr(MSR_IA32_CR_PAT);
+	wrmsr(MSR_IA32_CR_PAT, L2_PAT_MODIFIED);
+	pat_data->l2_pat_after_write = rdmsr(MSR_IA32_CR_PAT);
+	pat_data->l2_done = true;
+	vmmcall();
+}
+
+static void l2_guest_code_saverestoretest(void)
+{
+	pat_data->l2_pat_read = rdmsr(MSR_IA32_CR_PAT);
+
+	GUEST_SYNC(1);
+	GUEST_ASSERT_EQ(rdmsr(MSR_IA32_CR_PAT), pat_data->l2_pat_read);
+
+	wrmsr(MSR_IA32_CR_PAT, L2_PAT_MODIFIED);
+	pat_data->l2_pat_after_write = rdmsr(MSR_IA32_CR_PAT);
+
+	GUEST_SYNC(2);
+	GUEST_ASSERT_EQ(rdmsr(MSR_IA32_CR_PAT), L2_PAT_MODIFIED);
+
+	pat_data->l2_done = true;
+	vmmcall();
+}
+
+static void l2_guest_code_multi_vmentry(void)
+{
+	pat_data->l2_pat_read = rdmsr(MSR_IA32_CR_PAT);
+	wrmsr(MSR_IA32_CR_PAT, L2_PAT_MODIFIED);
+	pat_data->l2_pat_after_write = rdmsr(MSR_IA32_CR_PAT);
+	vmmcall();
+
+	pat_data->l2_pat_read = rdmsr(MSR_IA32_CR_PAT);
+	pat_data->l2_done = true;
+	vmmcall();
+}
+
+static struct vmcb *l1_common_setup(struct svm_test_data *svm,
+				    struct pat_test_data *data,
+				    void *l2_guest_code,
+				    void *l2_guest_stack)
+{
+	struct vmcb *vmcb = svm->vmcb;
+
+	pat_data = data;
+
+	wrmsr(MSR_IA32_CR_PAT, L1_PAT_VALUE);
+	GUEST_ASSERT_EQ(rdmsr(MSR_IA32_CR_PAT), L1_PAT_VALUE);
+
+	generic_svm_setup(svm, l2_guest_code, l2_guest_stack);
+
+	vmcb->save.g_pat = L2_VMCB12_PAT;
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_MSR_PROT);
+
+	return vmcb;
+}
+
+static void l1_assert_l2_state(struct pat_test_data *data, uint64_t expected_pat_read)
+{
+	GUEST_ASSERT(data->l2_done);
+	GUEST_ASSERT_EQ(data->l2_pat_read, expected_pat_read);
+	GUEST_ASSERT_EQ(data->l2_pat_after_write, L2_PAT_MODIFIED);
+}
+
+static void l1_svm_code_npt_disabled(struct svm_test_data *svm,
+				     struct pat_test_data *data)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb;
+
+	vmcb = l1_common_setup(svm, data, l2_guest_code,
+			       &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	run_guest(vmcb, svm->vmcb_gpa);
+
+	GUEST_ASSERT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+	l1_assert_l2_state(data, L1_PAT_VALUE);
+
+	data->l1_pat_after_vmexit = rdmsr(MSR_IA32_CR_PAT);
+	GUEST_ASSERT_EQ(data->l1_pat_after_vmexit, L2_PAT_MODIFIED);
+
+	GUEST_DONE();
+}
+
+static void l1_svm_code_invalid_gpat(struct svm_test_data *svm,
+				     struct pat_test_data *data)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb;
+
+	vmcb = l1_common_setup(svm, data, l2_guest_code,
+			       &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	vmcb->save.g_pat = INVALID_PAT_VALUE;
+
+	run_guest(vmcb, svm->vmcb_gpa);
+
+	GUEST_ASSERT_EQ(vmcb->control.exit_code, SVM_EXIT_ERR);
+	GUEST_ASSERT(!data->l2_done);
+
+	GUEST_DONE();
+}
+
+static void l1_svm_code_npt_enabled(struct svm_test_data *svm,
+				    struct pat_test_data *data)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb;
+
+	vmcb = l1_common_setup(svm, data, l2_guest_code,
+			       &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	run_guest(vmcb, svm->vmcb_gpa);
+
+	GUEST_ASSERT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+	l1_assert_l2_state(data, L2_VMCB12_PAT);
+
+	data->vmcb12_gpat_after_exit = vmcb->save.g_pat;
+	GUEST_ASSERT_EQ(data->vmcb12_gpat_after_exit, L2_PAT_MODIFIED);
+
+	data->l1_pat_after_vmexit = rdmsr(MSR_IA32_CR_PAT);
+	GUEST_ASSERT_EQ(data->l1_pat_after_vmexit, L1_PAT_VALUE);
+
+	GUEST_DONE();
+}
+
+static void l1_svm_code_saverestore(struct svm_test_data *svm,
+				    struct pat_test_data *data)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb;
+
+	vmcb = l1_common_setup(svm, data, l2_guest_code_saverestoretest,
+			       &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	run_guest(vmcb, svm->vmcb_gpa);
+
+	GUEST_ASSERT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+	GUEST_ASSERT(data->l2_done);
+
+	GUEST_ASSERT_EQ(rdmsr(MSR_IA32_CR_PAT), L1_PAT_VALUE);
+	GUEST_ASSERT_EQ(vmcb->save.g_pat, L2_PAT_MODIFIED);
+
+	GUEST_DONE();
+}
+
+static void l1_svm_code_multi_vmentry(struct svm_test_data *svm,
+				      struct pat_test_data *data)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb;
+
+	vmcb = l1_common_setup(svm, data, l2_guest_code_multi_vmentry,
+			       &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	run_guest(vmcb, svm->vmcb_gpa);
+	GUEST_ASSERT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+
+	GUEST_ASSERT_EQ(data->l2_pat_after_write, L2_PAT_MODIFIED);
+	GUEST_ASSERT_EQ(vmcb->save.g_pat, L2_PAT_MODIFIED);
+	GUEST_ASSERT_EQ(rdmsr(MSR_IA32_CR_PAT), L1_PAT_VALUE);
+
+	vmcb->save.rip += 3;  /* vmmcall */
+	run_guest(vmcb, svm->vmcb_gpa);
+
+	GUEST_ASSERT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+	GUEST_ASSERT(data->l2_done);
+	GUEST_ASSERT_EQ(data->l2_pat_read, L2_PAT_MODIFIED);
+	GUEST_ASSERT_EQ(rdmsr(MSR_IA32_CR_PAT), L1_PAT_VALUE);
+
+	GUEST_DONE();
+}
+
+static void run_test(void *l1_code, const char *test_name, bool npt_enabled,
+		     bool do_save_restore)
+{
+	struct pat_test_data *data_hva;
+	vm_vaddr_t svm_gva, data_gva;
+	struct kvm_x86_state *state;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	pr_info("Testing: %s\n", test_name);
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_code);
+	if (npt_enabled)
+		vm_enable_npt(vm);
+
+	vcpu_alloc_svm(vm, &svm_gva);
+
+	data_gva = vm_vaddr_alloc_page(vm);
+	data_hva = addr_gva2hva(vm, data_gva);
+	memset(data_hva, 0, sizeof(*data_hva));
+
+	if (npt_enabled)
+		tdp_identity_map_default_memslots(vm);
+
+	vcpu_args_set(vcpu, 2, svm_gva, data_gva);
+
+	for (;;) {
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			/* NOT REACHED */
+		case UCALL_SYNC:
+			if (do_save_restore) {
+				pr_info("  Save/restore at sync point %ld\n",
+					uc.args[1]);
+				state = vcpu_save_state(vcpu);
+				kvm_vm_release(vm);
+				vcpu = vm_recreate_with_one_vcpu(vm);
+				vcpu_load_state(vcpu, state);
+				kvm_x86_state_cleanup(state);
+			}
+			break;
+		case UCALL_DONE:
+			pr_info("  PASSED\n");
+			kvm_vm_free(vm);
+			return;
+		default:
+			TEST_FAIL("Unknown ucall %lu", uc.cmd);
+		}
+	}
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_NPT));
+	TEST_REQUIRE(kvm_has_cap(KVM_CAP_NESTED_STATE));
+
+	run_test(l1_svm_code_npt_disabled, "nested NPT disabled", false, false);
+
+	run_test(l1_svm_code_invalid_gpat, "invalid g_pat", true, false);
+
+	run_test(l1_svm_code_npt_enabled, "nested NPT enabled", true, false);
+
+	run_test(l1_svm_code_saverestore, "save/restore", true, true);
+
+	run_test(l1_svm_code_multi_vmentry, "multiple entries", true, false);
+
+	return 0;
+}
-- 
2.53.0.rc2.204.g2597b5adb4-goog


