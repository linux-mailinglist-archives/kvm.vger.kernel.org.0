Return-Path: <kvm+bounces-54288-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 28CCCB1DE04
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 22:21:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D290E189552D
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 20:21:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5EE523F417;
	Thu,  7 Aug 2025 20:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e3AVs2QC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F286027A46E
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 20:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754597825; cv=none; b=TOkuqXwV1mkZQAU7jSLJ8Ai73Q3KmSfPNwbdNNBiA88pjBYYXzfENiaO4HmXZfk57IleWHyfDo58lpyYZrgBd7h0r5P48bJ5bRX5AWmV1imBTQ8S3VPyq2tNR/6ENMZ3PPirno7BWN2SUWzUEnTka4xk2jLPK+B3gJo5UcNSCa0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754597825; c=relaxed/simple;
	bh=1lLJEQt553XarCyVGURP6/QnoZ2UebtBy96ceC/3gK8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VK2sw09V607NJCVGRoHz9uToXwjtqN2Xru1MauQR1J9qPOEiUZLOxVPczf+JCxQtJxzI4pOmY7DkRJd+DjpNG3GK61Ywm3nKl/bvtPxt+x+OkUwRFe4VJOIwROsBdXLDQ7X7jtBGsZhHAInLd74/GEfRJLnQpMd/w5ebZcNooUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e3AVs2QC; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24011ceafc8so11823785ad.3
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 13:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754597823; x=1755202623; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fHXS+IMdX42x6FMeqA3gkQMVcireV7tMgGO8OV5Mnhw=;
        b=e3AVs2QCc9NnGFsBQYPSG2Akl7trxCTBwBcYRxpPLgXqSDAJDth5/pm8s+O9xwxJM3
         fE1JfYtShwXfOyc8SLHQKn9WC6kEotQfyhZx3pWEeUXvrHX6z0LxJjWqASybeLMRjvVh
         74AKk+1ss7gmrfRFrQ3sQMIuOMVzl6X/rj2r9oMvIwHMts4fWxueHjAjtY6EpayyYqYb
         2yHtud1UxK5yhxzwRAd1N0BxUb5hZL0d6XRZaY5lEcfE5to4Ar9SKYaIFcpQlerjzJDz
         H7VfdMgPr/t37KiNjCwUX+EUrraWtt1N2aEj9Pmcw2C4zJJj4hy+cmx3KrfcSTPtBDOM
         HcjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754597823; x=1755202623;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fHXS+IMdX42x6FMeqA3gkQMVcireV7tMgGO8OV5Mnhw=;
        b=BUhuOq7eSuxGRfydgCYxIpLS5hcJvIkUjMpqrXtU7XDn/8a6LPdq0NHYH4ayU5CmPT
         pMP1YZeEoLpKESEvFOuRuexT+zowt56dGGOYd9fdCdLQgAjRJ74fao+/BUP3Vqu7Yijl
         ReCN3o1/iAyNJE77YQ7q95yu/Nk7CNcq1qw8Rv9wlRcvdulunmchzO0966jB/B65icIB
         UEKOSMrg+LKk5xy/DHLYUpPP7PPQgF74f2P+Tp389vZGI1o3odq9Duzz7kg2qtVisnRc
         /0dWilj0nxF9gZWzOleXMUPTNDmtPm8MYfI+p+0AhOR05eNrzAGj2Gqb5qWB63ZPTpag
         hylg==
X-Forwarded-Encrypted: i=1; AJvYcCVjfkOz9uJFmFGqT2v24uloJe7IotiO/Ljyf0qI4yde0WG6s1F1jUBAD5a7FhMOvAkO+E4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4B3x535Xx6u1624RjPCkebLMy6PKgxOdV7oanxDda3DfjwTjC
	l9qjm8xSjRSX54gtrYh4PIStwpWT2oHTKDVB7Ok1M+USkg9t0CxrGeKlbFgmFVTr+7w3bftLqmT
	vGQ==
X-Google-Smtp-Source: AGHT+IFqenLs+t/iiOJ8dl6m0BMR2FI1dhWrueWing11YrkV8I+u/puGCyRBZbK2SKvLUeG3O0QjlAxWLw==
X-Received: from plbkh8.prod.google.com ([2002:a17:903:648:b0:240:1bbf:686b])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:19ce:b0:240:cd3e:d860
 with SMTP id d9443c01a7336-242c220df9cmr4079385ad.41.1754597823307; Thu, 07
 Aug 2025 13:17:03 -0700 (PDT)
Date: Thu,  7 Aug 2025 13:16:13 -0700
In-Reply-To: <20250807201628.1185915-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250807201628.1185915-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc0.155.g4a0f42376b-goog
Message-ID: <20250807201628.1185915-18-sagis@google.com>
Subject: [PATCH v8 17/30] KVM: selftests: TDX: Add TDX HLT exit test
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>
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
2.51.0.rc0.155.g4a0f42376b-goog


