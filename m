Return-Path: <kvm+bounces-66853-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B6A3CEA874
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 20:13:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EC6A33020C49
	for <lists+kvm@lfdr.de>; Tue, 30 Dec 2025 19:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A2AF2F1FC7;
	Tue, 30 Dec 2025 19:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sB+sMvxe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3EC2AD35
	for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 19:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767122027; cv=none; b=uvQ6YN0evCb+mxmqn9NyqeAy86u3ZP+fgopNVw7pbGU7BaPecHIeE/acN2uNLVT2lpwg3g2IbCghY7BO4DnRrKYJz6UkaN3hNU+DXercMz+IzLXJaUvH+zYhDYH0Au5blEopxdAuvpBG8Ko8vBSF8lXgJ+N8z1BPr/VZq2KSD/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767122027; c=relaxed/simple;
	bh=K7yxmw1WbhvWRVN4tfCf0MvQQM5XQ5yAGgYTaGQ2Guo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=HOFuT4Xuf531PATyyORHstQN8pWp24Gxx3JzMu6bIOScTjW1P18pYMOhcs7xUmE7suAj7aylOE90ByS2nzFcPp4i02sHqt3M4ZhzbqdHcZ3XDfFjR0I6CpONYSZ+c2S8r9cQYAmuL5aQULWABjSstI2yQTYit2BXxPltOEIEdEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sB+sMvxe; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c21341f56so30436078a91.2
        for <kvm@vger.kernel.org>; Tue, 30 Dec 2025 11:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767122025; x=1767726825; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eNt6L3/n5eEkpGm6v60dZjdonqUcKri9z/pXfbeCT9E=;
        b=sB+sMvxe42CtXjSpJBKfcRdxp8cX9iLtchDJM3URj5OwUTBxNgoKEqTq49B45mXYv5
         /W/UJbb9WZzv15K3ZKwOthLyaUUaeNicNe8JLMgifrcsvqfP1a6rT4JWmwyO71fjqoiq
         1LRurxmcf1LZSiJ4q2tCIywjCb3Dwh/77tMUNbeNFDtIicy7fkJauwpuvu3nERhqArtJ
         5Y44QVQRhT4KCyzM2Tp4gNwbKr+w/wwgsPE3saus3YXfwbPvu89stGseZtTU5BrnmeZN
         4nKNtKKrEGkVCKJj6RDw6UNzBbHn4UD2IsGeqHuZTUeVWE1ryVw8AxSOuwtqf7QbmNMM
         /gSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767122025; x=1767726825;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eNt6L3/n5eEkpGm6v60dZjdonqUcKri9z/pXfbeCT9E=;
        b=SjUVQ5qjfWiqoMtSGogz1QbvfYd7UTY28waRstF7YoWdcPlal5LqkLgSxfaFw0uexH
         m7CaEJx6YFwdfX87sWbzTiVxXa7sZ5hckmRPFxLlQcnKkGBFzzNwZo9sGz/W2GDX6DJl
         QAT8Fl+xngv6QecnRptGpJsrjNYLPaAEzvMmk8h1hI2Kbdhk3p+v8m27+qPvmMZXmvLP
         SGfOqs871G89YFrlLzL39Wa2O5WP/hPf0w7BqX4xrFn5VnM6ZMLLKbj9jEHYS3swhkQc
         KJ+wRRs78jeUXDpfAarXLDPwfKfr1Fgu9KYiB377/ny9x4P/e7RV6bCQy39wjo8pvC3m
         E9NQ==
X-Gm-Message-State: AOJu0YzMvPIzW+xf6vynBIl0Wuons4Ev3j7W7AoaREt+ZmkUxnvhUOdl
	IRJfUl0TPV81LMDeLqYFPoLGn98QimWcxDQBUwD+LY9lKyqlIjRnz7xJOr5W9mglFhnYL94bDDQ
	UDwsYsQ==
X-Google-Smtp-Source: AGHT+IGOJLu14tw79sMinni6Pg5XCfEWqRsYhCBUSuWaCuNb8d2pxz471kq10G4aKRQvDgx1/8eOS4yVZls=
X-Received: from pjbsw11.prod.google.com ([2002:a17:90b:2c8b:b0:34a:bf4e:cb5c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f08:b0:341:8601:d77a
 with SMTP id 98e67ed59e1d1-34e921ccb3bmr30834508a91.29.1767122024981; Tue, 30
 Dec 2025 11:13:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 30 Dec 2025 11:13:42 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20251230191342.4052363-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86/svm: Track and handle exit code as an
 unsigned 64-bit value
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Track and handle SVM's exit_code as an unsigned 64-bit value.  Per the
APM, offset 0x70 is a single 64-bit value:

  070h 63:0 EXITCODE

And a sane reading of the error values defined in "Table C-1. SVM Intercept
Codes" is that negative values use the full 64 bits:

  =E2=80=931 VMEXIT_INVALID Invalid guest state in VMCB.
  =E2=80=932 VMEXIT_BUSYBUSY bit was set in the VMSA
  =E2=80=933 VMEXIT_IDLE_REQUIREDThe sibling thread is not in an idle state
  -4 VMEXIT_INVALID_PMC Invalid PMC state

And that interpretation is confirmed by testing on Milan and Turin (by
setting bits in CR0[63:32] to generate VMEXIT_INVALID on VMRUN).

Furthermore, Xen has treated exitcode as a 64-bit value since HVM support
was adding in 2006 (see Xen commit d1bd157fbc ("Big merge the HVM
full-virtualisation abstractions.")).

Note, the SVM tests will fail when on KVM builds without commit
f402ecd7a8b6 ("KVM: nSVM: Set exit_code_hi to -1 when synthesizing
SVM_EXIT_ERR (failed VMRUN)").

Link: https://lore.kernel.org/all/20251113225621.1688428-1-seanjc@google.co=
m
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm.c       |  4 +--
 x86/svm.h       |  9 +++----
 x86/svm_npt.c   |  4 +--
 x86/svm_tests.c | 66 ++++++++++++++++++++++++-------------------------
 4 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/x86/svm.c b/x86/svm.c
index de9eb194..3f6d70dc 100644
--- a/x86/svm.c
+++ b/x86/svm.c
@@ -227,7 +227,7 @@ void svm_setup_vmrun(u64 rip)
 	vmcb->save.rsp =3D (ulong)(guest_stack + ARRAY_SIZE(guest_stack));
 }
=20
-int __svm_vmrun(u64 rip)
+u64 __svm_vmrun(u64 rip)
 {
 	svm_setup_vmrun(rip);
 	regs.rdi =3D (ulong)v2_test;
@@ -243,7 +243,7 @@ int __svm_vmrun(u64 rip)
 	return (vmcb->control.exit_code);
 }
=20
-int svm_vmrun(void)
+u64 svm_vmrun(void)
 {
 	return __svm_vmrun((u64)test_thunk);
 }
diff --git a/x86/svm.h b/x86/svm.h
index 264583a6..02d9bac3 100644
--- a/x86/svm.h
+++ b/x86/svm.h
@@ -88,8 +88,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 int_vector;
 	u32 int_state;
 	u8 reserved_3[4];
-	u32 exit_code;
-	u32 exit_code_hi;
+	u64 exit_code;
 	u64 exit_info_1;
 	u64 exit_info_2;
 	u32 exit_int_info;
@@ -354,7 +353,7 @@ struct __attribute__ ((__packed__)) vmcb {
 #define SVM_EXIT_MWAIT_COND	0x08c
 #define SVM_EXIT_NPF  		0x400
=20
-#define SVM_EXIT_ERR		-1
+#define SVM_EXIT_ERR		-1ull
=20
 #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
=20
@@ -435,8 +434,8 @@ void vmcb_ident(struct vmcb *vmcb);
 struct regs get_regs(void);
 void vmmcall(void);
 void svm_setup_vmrun(u64 rip);
-int __svm_vmrun(u64 rip);
-int svm_vmrun(void);
+u64 __svm_vmrun(u64 rip);
+u64 svm_vmrun(void);
 void test_set_guest(test_guest_func func);
=20
 extern struct vmcb *vmcb;
diff --git a/x86/svm_npt.c b/x86/svm_npt.c
index bd5e8f35..24d7707b 100644
--- a/x86/svm_npt.c
+++ b/x86/svm_npt.c
@@ -219,7 +219,7 @@ static void __svm_npt_rsvd_bits_test(u64 * pxe, u64 rsv=
d_bits, u64 efer,
 				     ulong cr4, u64 guest_efer, ulong guest_cr4)
 {
 	u64 pxe_orig =3D *pxe;
-	int exit_reason;
+	u64 exit_reason;
 	u64 pfec;
=20
 	wrmsr(MSR_EFER, efer);
@@ -233,7 +233,7 @@ static void __svm_npt_rsvd_bits_test(u64 * pxe, u64 rsv=
d_bits, u64 efer,
 	exit_reason =3D svm_vmrun();
=20
 	report(exit_reason =3D=3D SVM_EXIT_NPF,
-	       "Wanted #NPF on rsvd bits =3D 0x%lx, got exit =3D 0x%x", rsvd_bits=
,
+	       "Wanted #NPF on rsvd bits =3D 0x%lx, got exit =3D 0x%lx", rsvd_bit=
s,
 	       exit_reason);
=20
 	if (pxe =3D=3D npt_get_pdpe((u64) basic_guest_main) || pxe =3D=3D npt_get=
_pml4e()) {
diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 37616476..8ce3cc2e 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -103,7 +103,7 @@ static bool finished_rsm_intercept(struct svm_test *tes=
t)
 	switch (get_test_stage(test)) {
 	case 0:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_RSM) {
-			report_fail("VMEXIT not due to rsm. Exit reason 0x%x",
+			report_fail("VMEXIT not due to rsm. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -113,7 +113,7 @@ static bool finished_rsm_intercept(struct svm_test *tes=
t)
=20
 	case 1:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_EXCP_BASE + UD_VECTOR) {
-			report_fail("VMEXIT not due to #UD. Exit reason 0x%x",
+			report_fail("VMEXIT not due to #UD. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -971,7 +971,7 @@ static void svm_tsc_scale_run_testcase(u64 duration,
 	start_tsc =3D rdtsc();
=20
 	if (svm_vmrun() !=3D SVM_EXIT_VMMCALL)
-		report_fail("unexpected vm exit code 0x%x", vmcb->control.exit_code);
+		report_fail("unexpected vm exit code 0x%lx", vmcb->control.exit_code);
=20
 	actual_duration =3D (rdtsc() - start_tsc) >> TSC_SHIFT;
=20
@@ -1190,7 +1190,7 @@ static bool pending_event_finished(struct svm_test *t=
est)
 	switch (get_test_stage(test)) {
 	case 0:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_INTR) {
-			report_fail("VMEXIT not due to pending interrupt. Exit reason 0x%x",
+			report_fail("VMEXIT not due to pending interrupt. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1271,7 +1271,7 @@ static void pending_event_cli_test(struct svm_test *t=
est)
 static bool pending_event_cli_finished(struct svm_test *test)
 {
 	report_svm_guest(vmcb->control.exit_code =3D=3D SVM_EXIT_VMMCALL, test,
-			 "Wanted VMMCALL VM-Exit, got exit reason 0x%x",
+			 "Wanted VMMCALL VM-Exit, got exit reason 0x%lx",
 			 vmcb->control.exit_code);
=20
 	switch (get_test_stage(test)) {
@@ -1394,7 +1394,7 @@ static bool interrupt_finished(struct svm_test *test)
 	case 0:
 	case 2:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
-			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1407,7 +1407,7 @@ static bool interrupt_finished(struct svm_test *test)
 	case 1:
 	case 3:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_INTR) {
-			report_fail("VMEXIT not due to intr intercept. Exit reason 0x%x",
+			report_fail("VMEXIT not due to intr intercept. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1470,7 +1470,7 @@ static bool nmi_finished(struct svm_test *test)
 	switch (get_test_stage(test)) {
 	case 0:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
-			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1481,7 +1481,7 @@ static bool nmi_finished(struct svm_test *test)
=20
 	case 1:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_NMI) {
-			report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
+			report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1563,7 +1563,7 @@ static bool nmi_hlt_finished(struct svm_test *test)
 	switch (get_test_stage(test)) {
 	case 1:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
-			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1574,7 +1574,7 @@ static bool nmi_hlt_finished(struct svm_test *test)
=20
 	case 2:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_NMI) {
-			report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%x",
+			report_fail("VMEXIT not due to NMI intercept. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1624,7 +1624,7 @@ static bool vnmi_finished(struct svm_test *test)
 	switch (get_test_stage(test)) {
 	case 0:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_ERR) {
-			report_fail("Wanted ERR VM-Exit, got 0x%x",
+			report_fail("Wanted ERR VM-Exit, got 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1635,7 +1635,7 @@ static bool vnmi_finished(struct svm_test *test)
=20
 	case 1:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
-			report_fail("Wanted VMMCALL VM-Exit, got 0x%x",
+			report_fail("Wanted VMMCALL VM-Exit, got 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1646,7 +1646,7 @@ static bool vnmi_finished(struct svm_test *test)
=20
 	case 2:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
-			report_fail("Wanted VMMCALL VM-Exit, got 0x%x",
+			report_fail("Wanted VMMCALL VM-Exit, got 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1697,7 +1697,7 @@ static bool exc_inject_finished(struct svm_test *test=
)
 	switch (get_test_stage(test)) {
 	case 0:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
-			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1707,7 +1707,7 @@ static bool exc_inject_finished(struct svm_test *test=
)
=20
 	case 1:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_ERR) {
-			report_fail("VMEXIT not due to error. Exit reason 0x%x",
+			report_fail("VMEXIT not due to error. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1717,7 +1717,7 @@ static bool exc_inject_finished(struct svm_test *test=
)
=20
 	case 2:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
-			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1795,7 +1795,7 @@ static bool virq_inject_finished(struct svm_test *tes=
t)
 	switch (get_test_stage(test)) {
 	case 0:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
-			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1811,7 +1811,7 @@ static bool virq_inject_finished(struct svm_test *tes=
t)
=20
 	case 1:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VINTR) {
-			report_fail("VMEXIT not due to vintr. Exit reason 0x%x",
+			report_fail("VMEXIT not due to vintr. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1824,7 +1824,7 @@ static bool virq_inject_finished(struct svm_test *tes=
t)
=20
 	case 2:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
-			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1838,7 +1838,7 @@ static bool virq_inject_finished(struct svm_test *tes=
t)
=20
 	case 3:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
-			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1848,7 +1848,7 @@ static bool virq_inject_finished(struct svm_test *tes=
t)
 	case 4:
 		// INTERCEPT_VINTR should be ignored because V_INTR_PRIO < V_TPR
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
-			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+			report_fail("VMEXIT not due to vmmcall. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -1886,7 +1886,7 @@ static void virq_inject_within_shadow_prepare_gif_cle=
ar(struct svm_test *test)
 static bool virq_inject_within_shadow_finished(struct svm_test *test)
 {
 	if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL)
-		report_fail("VMEXIT not due to vmmcall. Exit reason 0x%x",
+		report_fail("VMEXIT not due to vmmcall. Exit reason 0x%lx",
 			    vmcb->control.exit_code);
 	if (!virq_fired)
 		report_fail("V_IRQ did not fire");
@@ -2063,7 +2063,7 @@ static bool init_intercept_finished(struct svm_test *=
test)
 	vmcb->save.rip +=3D 3;
=20
 	if (vmcb->control.exit_code !=3D SVM_EXIT_INIT) {
-		report_fail("VMEXIT not due to init intercept. Exit reason 0x%x",
+		report_fail("VMEXIT not due to init intercept. Exit reason 0x%lx",
 			    vmcb->control.exit_code);
=20
 		return true;
@@ -2165,7 +2165,7 @@ static bool host_rflags_finished(struct svm_test *tes=
t)
 	switch (get_test_stage(test)) {
 	case 0:
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL) {
-			report_fail("Unexpected VMEXIT. Exit reason 0x%x",
+			report_fail("Unexpected VMEXIT. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -2180,7 +2180,7 @@ static bool host_rflags_finished(struct svm_test *tes=
t)
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL ||
 		    host_rflags_guest_main_flag !=3D 1) {
 			report_fail("Unexpected VMEXIT or #DB handler"
-				    " invoked before guest main. Exit reason 0x%x",
+				    " invoked before guest main. Exit reason 0x%lx",
 				    vmcb->control.exit_code);
 			return true;
 		}
@@ -2196,7 +2196,7 @@ static bool host_rflags_finished(struct svm_test *tes=
t)
 		if (vmcb->control.exit_code !=3D SVM_EXIT_VMMCALL ||
 		    rip_detected !=3D (u64)&vmrun_rip + 3) {
 			report_fail("Unexpected VMEXIT or RIP mismatch."
-				    " Exit reason 0x%x, RIP actual: %lx, RIP expected: "
+				    " Exit reason 0x%lx, RIP actual: %lx, RIP expected: "
 				    "%lx", vmcb->control.exit_code,
 				    (u64)&vmrun_rip + 3, rip_detected);
 			return true;
@@ -2214,7 +2214,7 @@ static bool host_rflags_finished(struct svm_test *tes=
t)
 		    read_rflags() & X86_EFLAGS_RF) {
 			report_fail("Unexpected VMEXIT or RIP mismatch or "
 				    "EFLAGS.RF not cleared."
-				    " Exit reason 0x%x, RIP actual: %lx, RIP expected: "
+				    " Exit reason 0x%lx, RIP actual: %lx, RIP expected: "
 				    "%lx", vmcb->control.exit_code,
 				    (u64)&vmrun_rip, rip_detected);
 			return true;
@@ -2301,7 +2301,7 @@ static void basic_guest_main(struct svm_test *test)
 				  exit_code, test_name)			\
 {									\
 	u64 tmp, mask;							\
-	u32 r;								\
+	u64 r;								\
 	int i;								\
 									\
 	for (i =3D start; i <=3D end; i =3D i + inc) {			\
@@ -2320,8 +2320,8 @@ static void basic_guest_main(struct svm_test *test)
 			vmcb->save.cr4 =3D tmp;				\
 		}							\
 		r =3D svm_vmrun();					\
-		report(r =3D=3D exit_code, "Test CR%d %s%d:%d: %lx, wanted exit 0x%x, go=
t 0x%x", \
-		       cr, test_name, end, start, tmp, exit_code, r);	\
+		report(r =3D=3D exit_code, "Test CR%d %s%d:%d: %lx, wanted exit 0x%lx, g=
ot 0x%lx", \
+		       cr, test_name, end, start, tmp, (u64)exit_code, r);	\
 	}								\
 }
=20
@@ -3316,7 +3316,7 @@ static void dummy_nmi_handler(struct ex_regs *regs)
 }
=20
=20
-static void svm_intr_intercept_mix_run_guest(volatile int *counter, int ex=
pected_vmexit)
+static void svm_intr_intercept_mix_run_guest(volatile int *counter, u64 ex=
pected_vmexit)
 {
 	if (counter)
 		*counter =3D 0;
@@ -3335,7 +3335,7 @@ static void svm_intr_intercept_mix_run_guest(volatile=
 int *counter, int expected
 		report(*counter =3D=3D 1, "Interrupt is expected");
=20
 	report(vmcb->control.exit_code =3D=3D expected_vmexit,
-	       "Wanted VM-Exit reason 0x%x, got 0x%x",
+	       "Wanted VM-Exit reason 0x%lx, got 0x%lx",
 	       expected_vmexit, vmcb->control.exit_code);
 	report(vmcb->save.rflags & X86_EFLAGS_IF, "Guest should have EFLAGS.IF se=
t now");
 	cli();

base-commit: 31d91f5c9b7546471b729491664b05c933d64a7a
--=20
2.52.0.351.gbe84eed79e-goog


