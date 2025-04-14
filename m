Return-Path: <kvm+bounces-43300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 13F4BA88E60
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 23:53:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D83B189A8AD
	for <lists+kvm@lfdr.de>; Mon, 14 Apr 2025 21:54:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80469224AE9;
	Mon, 14 Apr 2025 21:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kned6Wyf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5071DDC37
	for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 21:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744667347; cv=none; b=NHmn4WYpZJ32q11lFFdZ3NPWmyiOsyUhUBPJY8dSmj/xWB8ot+ZLcGynRsTKJuFy5i7XkJ7E33CaeytRfD5/5jDDxhH6wgxyyq+eIsyo4UMX7KiwknRK7nNl5yDn0xq5iGpb3f8uUd5o6VRPLQelpj0ID1wqyq4rIB117r7iUcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744667347; c=relaxed/simple;
	bh=/n1foAlpk+etzTBM2D1hxEcnm/8ah9s9ZBI7R5m2ATQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u0LINlNcvNdGdP31i3ryvcoDxtihGaSKHT5PIFT36OoWfBU8KbGfDJqKmGGXr/dspTuT5qV5Ee1XIN37ZO7t9DOBEMQ3DCcgNUhMqTCsYnRBBsdtV2h9tV+wLe7Sck5Cr2FZD64EZERXQNAGt6xMJR7rzynOTrHVDLQneDGUKvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kned6Wyf; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7370e73f690so5324383b3a.3
        for <kvm@vger.kernel.org>; Mon, 14 Apr 2025 14:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744667344; x=1745272144; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ojSFGVutva/8voVAMgW6hqOpSnmRctEgikC/JBWm1uk=;
        b=kned6Wyfu4JLibjaOouI9v7/iL79tkEhpanOsFQgW38k5QRWyBs+dWP6Q4eiEykJW0
         Ncz3LFIz+6gU9mxRW31IRWo6015wm2X/3HT4dbLMyjBM15UDJn5grsqoAYifEj5lBjC4
         4XCliHQC3tzK6Gb7yvkELOj+m74vs2rQo+O5dw37C4jhvCYh9piEaNmMYtoMIG+njSHz
         6kzb0tar8Whgf3RM4XLkeosyV1Lxca9vab+LaS4ssu/vEIoh8tnJg3oLBkmi5C/X8sCJ
         8TCp78vpkE5cv+XMRTFTKjtJwTpthrt3vnLDlmGIMvFwg8UvsQgGK61NbfIPqs4B5guN
         Dh8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744667344; x=1745272144;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ojSFGVutva/8voVAMgW6hqOpSnmRctEgikC/JBWm1uk=;
        b=LJaatDJJmaXdMGgWhjAVxOevyUi8Vb3jvxmlMPSUictx02rlBhEBNX1FR4W+gKtH8x
         D5eDqXKur0+w8sUNpfl/nCCauB2lj/fIhGu1RW/jtvAGnatwsoC0OLMqdElRgquTM8It
         Qqgb8OFZR456+tE60FctmLo5/oxiFt7Vmm6Gp1CDNjl0TYvhJHEz6FSxZyqxWYOPAy0U
         jz2LkmiXqlP9zTKNWjp0PeZbEkWrIKT9NNNQtAXs2MtS9EmVgPgebmrZ5P0hc9zL1E+Z
         92IvbqdFHqZ5OD72/gX09/5oElL3ooT4dfp1sPxXyIn8Azok3Bsz4WuS8HLsWHJRzgIj
         Vfog==
X-Forwarded-Encrypted: i=1; AJvYcCW91T4R0FucXpaop2x40IeMPIyvdiOCI+DpTFp25E8gVSnyzZhA/echsZskpGyx7Ag08J4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRRc+WV5zxLHgzOsH3M9EJvfD4UCJOLHVzPvWE1fxy/f/Unqnl
	fN+0eCRPisf13MgiysFAFPzrZRvZ5z2Kl1MIPNMRI/ZpIk9dfkOOGLwiO5YyrvYu//aMZmvnAg=
	=
X-Google-Smtp-Source: AGHT+IGmeeImAshDYCR0XYzQjIanYW8HtrwP2QGwHu3yLtyGhKR1MZsn7HPM9WTulJ6ihGpNExB0SL21VA==
X-Received: from pfhs21.prod.google.com ([2002:a62:e715:0:b0:730:96d1:c213])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2185:b0:736:3e50:bfec
 with SMTP id d2e1a72fcca58-73bd11bde77mr22359994b3a.8.1744667344246; Mon, 14
 Apr 2025 14:49:04 -0700 (PDT)
Date: Mon, 14 Apr 2025 14:47:46 -0700
In-Reply-To: <20250414214801.2693294-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414214801.2693294-1-sagis@google.com>
X-Mailer: git-send-email 2.49.0.777.g153de2bbd5-goog
Message-ID: <20250414214801.2693294-18-sagis@google.com>
Subject: [PATCH v6 17/30] KVM: selftests: TDX: Add TDX HLT exit test
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

From: Erdem Aktas <erdemaktas@google.com>

The test verifies that the guest runs TDVMCALL<INSTRUCTION.HLT> and the
guest vCPU enters to the halted state.

Co-developed-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Erdem Aktas <erdemaktas@google.com>
Signed-off-by: Sagi Shahar <sagis@google.com>
---
 .../selftests/kvm/include/x86/tdx/tdx.h       |  2 +
 tools/testing/selftests/kvm/lib/x86/tdx/tdx.c | 10 +++
 tools/testing/selftests/kvm/x86/tdx_vm_test.c | 81 ++++++++++++++++++-
 3 files changed, 92 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/x86/tdx/tdx.h b/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
index 56359a8c4c19..b5831919a215 100644
--- a/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
+++ b/tools/testing/selftests/kvm/include/x86/tdx/tdx.h
@@ -9,6 +9,7 @@
 #define TDG_VP_VMCALL_GET_TD_VM_CALL_INFO 0x10000
 #define TDG_VP_VMCALL_REPORT_FATAL_ERROR 0x10003
 
+#define TDG_VP_VMCALL_INSTRUCTION_HLT 12
 #define TDG_VP_VMCALL_INSTRUCTION_IO 30
 #define TDG_VP_VMCALL_INSTRUCTION_RDMSR 31
 #define TDG_VP_VMCALL_INSTRUCTION_WRMSR 32
@@ -20,4 +21,5 @@ uint64_t tdg_vp_vmcall_get_td_vmcall_info(uint64_t *r11, uint64_t *r12,
 					  uint64_t *r13, uint64_t *r14);
 uint64_t tdg_vp_vmcall_instruction_rdmsr(uint64_t index, uint64_t *ret_value);
 uint64_t tdg_vp_vmcall_instruction_wrmsr(uint64_t index, uint64_t value);
+uint64_t tdg_vp_vmcall_instruction_hlt(uint64_t interrupt_blocked_flag);
 #endif // SELFTEST_TDX_TDX_H
diff --git a/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c b/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
index 99ec45a5a657..e89ca727286e 100644
--- a/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
+++ b/tools/testing/selftests/kvm/lib/x86/tdx/tdx.c
@@ -93,3 +93,13 @@ uint64_t tdg_vp_vmcall_instruction_wrmsr(uint64_t index, uint64_t value)
 
 	return __tdx_hypercall(&args, 0);
 }
+
+uint64_t tdg_vp_vmcall_instruction_hlt(uint64_t interrupt_blocked_flag)
+{
+	struct tdx_hypercall_args args = {
+		.r11 = TDG_VP_VMCALL_INSTRUCTION_HLT,
+		.r12 = interrupt_blocked_flag,
+	};
+
+	return __tdx_hypercall(&args, 0);
+}
diff --git a/tools/testing/selftests/kvm/x86/tdx_vm_test.c b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
index 079ac266a44e..720ef5e87071 100644
--- a/tools/testing/selftests/kvm/x86/tdx_vm_test.c
+++ b/tools/testing/selftests/kvm/x86/tdx_vm_test.c
@@ -642,6 +642,83 @@ void verify_guest_msr_writes(void)
 	printf("\t ... PASSED\n");
 }
 
+/*
+ * Verifies HLT functionality.
+ */
+void guest_hlt(void)
+{
+	uint64_t interrupt_blocked_flag;
+	uint64_t ret;
+
+	interrupt_blocked_flag = 0;
+	ret = tdg_vp_vmcall_instruction_hlt(interrupt_blocked_flag);
+	tdx_assert_error(ret);
+
+	tdx_test_success();
+}
+
+void _verify_guest_hlt(int signum);
+
+void wake_me(int interval)
+{
+	struct sigaction action;
+
+	action.sa_handler = _verify_guest_hlt;
+	sigemptyset(&action.sa_mask);
+	action.sa_flags = 0;
+
+	TEST_ASSERT(sigaction(SIGALRM, &action, NULL) == 0,
+		    "Could not set the alarm handler!");
+
+	alarm(interval);
+}
+
+void _verify_guest_hlt(int signum)
+{
+	static struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+
+	/*
+	 * This function will also be called by SIGALRM handler to check the
+	 * vCPU MP State. If vm has been initialized, then we are in the signal
+	 * handler. Check the MP state and let the guest run again.
+	 */
+	if (vcpu) {
+		struct kvm_mp_state mp_state;
+
+		vcpu_mp_state_get(vcpu, &mp_state);
+		TEST_ASSERT_EQ(mp_state.mp_state, KVM_MP_STATE_HALTED);
+
+		/* Let the guest to run and finish the test.*/
+		mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
+		vcpu_mp_state_set(vcpu, &mp_state);
+		return;
+	}
+
+	vm = td_create();
+	td_initialize(vm, VM_MEM_SRC_ANONYMOUS, 0);
+	vcpu = td_vcpu_add(vm, 0, guest_hlt);
+	td_finalize(vm);
+
+	printf("Verifying HLT:\n");
+
+	printf("\t ... Running guest\n");
+
+	/* Wait 1 second for guest to execute HLT */
+	wake_me(1);
+	tdx_run(vcpu);
+
+	tdx_test_assert_success(vcpu);
+
+	kvm_vm_free(vm);
+	printf("\t ... PASSED\n");
+}
+
+void verify_guest_hlt(void)
+{
+	_verify_guest_hlt(0);
+}
+
 int main(int argc, char **argv)
 {
 	ksft_print_header();
@@ -649,7 +726,7 @@ int main(int argc, char **argv)
 	if (!is_tdx_enabled())
 		ksft_exit_skip("TDX is not supported by the KVM. Exiting.\n");
 
-	ksft_set_plan(9);
+	ksft_set_plan(10);
 	ksft_test_result(!run_in_new_process(&verify_td_lifecycle),
 			 "verify_td_lifecycle\n");
 	ksft_test_result(!run_in_new_process(&verify_report_fatal_error),
@@ -668,6 +745,8 @@ int main(int argc, char **argv)
 			 "verify_guest_msr_writes\n");
 	ksft_test_result(!run_in_new_process(&verify_guest_msr_reads),
 			 "verify_guest_msr_reads\n");
+	ksft_test_result(!run_in_new_process(&verify_guest_hlt),
+			 "verify_guest_hlt\n");
 
 	ksft_finished();
 	return 0;
-- 
2.49.0.504.g3bcea36a83-goog


