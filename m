Return-Path: <kvm+bounces-71589-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kP4lAPFQnWkBOgQAu9opvQ
	(envelope-from <kvm+bounces-71589-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:19:13 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E527182E94
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 08:19:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7F909302BB82
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 07:18:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D055364047;
	Tue, 24 Feb 2026 07:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eyNeL6Km"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E96364041
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 07:18:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771917520; cv=none; b=LqhRPcL5mWpQ2TbVVfdY9c8ULneE8swI1xzGCbeHCGMQiX0p53/JgPpXnbahNq5pE2KIyil0W0BOpOeNxPMOXOkdLI65tn4vLG5WvPMzGX/mzq+vcssgmVEHNRCEY3QcN9hQXsirUeGBtYIC0txCtiyIWPeV17Xvahg+wQ5mVGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771917520; c=relaxed/simple;
	bh=o2lXAF8DlbMbY3dKElYJx00rNsVLLWMFknS+lu6kFMg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V3aguOSJfwYsvBea+hKiti4+aP+zdcJNuYKWaR4wy/lANPZ3wIv/4OvAfBk1onQJ4RsczxS/t0tth+/OeMyhntVGLACwi7JtrRju34ZD6TCruWXDv60WJjCSBqz59JykNiWpVLS/82mm2JpMmY7iZjVxscJfqeurLwtUNmfHeSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eyNeL6Km; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354490889b6so24121178a91.3
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 23:18:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771917512; x=1772522312; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iHhMMK4VWyZxrOQeZtJ11bNmNzWKZ3L+l8EC7z1Hl3w=;
        b=eyNeL6KmycK2ZxMoDP7s7Up+ke4yWKa34aS2ExgaqT5YNJnsC8MHpL0ZUU7RlRHLib
         QRhdFjuAY2mMGrh28pHgnWFNM3oq/bzPqxv2wwK08UFX0o2c29BryOKdpJjQlog+nhyB
         /fDe/icqgq9Lp3fqwOzVTWaFg657lxPlwxRxYF6O5DJi9/CxKNy9FfWu1Xa/3P1vi8lD
         jAhzK626IXWllY/2MTEPIc7F86KVjY7JRPQaYD0LefcIHW75FAAmEZ3zisVm4W8Z1qRy
         T2dtc2XsVCoLLCv1WgYPDyu56aNo3Imcr5ZO89l7pOhkUASFBCiaP6wTC9mP+/IE4gim
         iJTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771917512; x=1772522312;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iHhMMK4VWyZxrOQeZtJ11bNmNzWKZ3L+l8EC7z1Hl3w=;
        b=asjxYi9mSjFRyHwcdd6To5khTQMuq3j5tAG7Byktg6oc4mPNzP/zOZUnHQM3lFm3E3
         Q7BlOeh4JRq6A8HUoLwbjmKogBWf7RzhiFjoY6b7GVwV5voZbRMixr9EKemvCoRajmZ9
         zWRCA96ZFkgXGu+fFWs/QNdw2KSD4uWXrloCCFpJjs9ktTadymJJlUfepZqtlqPq0HOy
         4Pp8BTmyzMtQLCEpak/Pk0Gx/VvqlUeis2mXgiJzXeZvjHhjvb9Kug9fC2wFT2TiiBS0
         Ff2b0S71Iq1zARiegsFvsULzZ5PlR2Gdud8A5IhUr/nseHOggDPTVW/cz6XrI8J4sRVy
         QJVg==
X-Gm-Message-State: AOJu0YzwxuXgBfIF8w5C+B5L2D4MvS6sX/3CIGSwisNwPjkMpI2hijCQ
	vGe82T5MpMRjWQAguDJlIhoDt3F0h/Xlyz41AxdmJ7DDgWpXwOF41tQtUYI4zg8fHMTz5qr5HOd
	9RFQlZUxAQLMVWw==
X-Received: from pje3.prod.google.com ([2002:a17:90b:5503:b0:356:2f4b:a4dc])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d645:b0:354:c441:a758 with SMTP id 98e67ed59e1d1-358ae8c2723mr9322133a91.19.1771917512061;
 Mon, 23 Feb 2026 23:18:32 -0800 (PST)
Date: Tue, 24 Feb 2026 07:18:22 +0000
In-Reply-To: <20260224071822.369326-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224071822.369326-1-chengkev@google.com>
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260224071822.369326-5-chengkev@google.com>
Subject: [PATCH V2 4/4] KVM: selftests: Add nested page fault injection test
From: Kevin Cheng <chengkev@google.com>
To: seanjc@google.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, yosry.ahmed@linux.dev, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71589-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[chengkev@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5E527182E94
X-Rspamd-Action: no action

Add a test that exercises nested page fault injection during L2
execution. L2 executes I/O string instructions (OUTSB/INSB) that access
memory restricted in L1's nested page tables (NPT/EPT), triggering a
nested page fault that L0 must inject to L1.

The test supports both AMD SVM (NPF) and Intel VMX (EPT violation) and
verifies that:
  - The exit reason is an NPF/EPT violation
  - The access type and permission bits are correct
  - The faulting GPA is correct

Three test cases are implemented:
  - Unmap the final data page (final translation fault, OUTSB read)
  - Unmap a PT page (page walk fault, OUTSB read)
  - Write-protect the final data page (protection violation, INSB write)
  - Write-protect a PT page (protection violation on A/D update, OUTSB
    read)

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/nested_npf_test.c       | 374 ++++++++++++++++++
 2 files changed, 375 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/nested_npf_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index fdec90e854671..55703d6be5e7a 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -93,6 +93,7 @@ TEST_GEN_PROGS_x86 += x86/nested_dirty_log_test
 TEST_GEN_PROGS_x86 += x86/nested_emulation_test
 TEST_GEN_PROGS_x86 += x86/nested_exceptions_test
 TEST_GEN_PROGS_x86 += x86/nested_invalid_cr3_test
+TEST_GEN_PROGS_x86 += x86/nested_npf_test
 TEST_GEN_PROGS_x86 += x86/nested_set_state_test
 TEST_GEN_PROGS_x86 += x86/nested_tsc_adjust_test
 TEST_GEN_PROGS_x86 += x86/nested_tsc_scaling_test
diff --git a/tools/testing/selftests/kvm/x86/nested_npf_test.c b/tools/testing/selftests/kvm/x86/nested_npf_test.c
new file mode 100644
index 0000000000000..7725e5dc3a386
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/nested_npf_test.c
@@ -0,0 +1,374 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025, Google, Inc.
+ */
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "svm_util.h"
+#include "vmx.h"
+
+#define L2_GUEST_STACK_SIZE 64
+
+#define EPT_VIOLATION_ACC_READ		BIT(0)
+#define EPT_VIOLATION_ACC_WRITE		BIT(1)
+#define EPT_VIOLATION_ACC_INSTR		BIT(2)
+#define EPT_VIOLATION_PROT_READ		BIT(3)
+#define EPT_VIOLATION_PROT_WRITE	BIT(4)
+#define EPT_VIOLATION_PROT_EXEC		BIT(5)
+#define EPT_VIOLATION_GVA_IS_VALID	BIT(7)
+#define EPT_VIOLATION_GVA_TRANSLATED	BIT(8)
+
+enum test_type {
+	TEST_FINAL_PAGE_UNMAPPED,	    /* Final data page not present */
+	TEST_PT_PAGE_UNMAPPED,		    /* Page table page not present */
+	TEST_FINAL_PAGE_WRITE_PROTECTED,    /* Final data page read-only */
+	TEST_PT_PAGE_WRITE_PROTECTED,	    /* Page table page read-only */
+};
+
+static vm_vaddr_t l2_test_page;
+static void (*l2_entry)(void);
+
+#define TEST_IO_PORT 0x80
+#define TEST1_VADDR 0x8000000ULL
+#define TEST2_VADDR 0x10000000ULL
+#define TEST3_VADDR 0x18000000ULL
+#define TEST4_VADDR 0x20000000ULL
+
+/*
+ * L2 executes OUTS reading from l2_test_page, triggering a nested page
+ * fault on the read access.
+ */
+static void l2_guest_code_outs(void)
+{
+	asm volatile("outsb" ::"S"(l2_test_page), "d"(TEST_IO_PORT) : "memory");
+	GUEST_FAIL("L2 should not reach here");
+}
+
+/*
+ * L2 executes INS writing to l2_test_page, triggering a nested page
+ * fault on the write access.
+ */
+static void l2_guest_code_ins(void)
+{
+	asm volatile("insb" ::"D"(l2_test_page), "d"(TEST_IO_PORT) : "memory");
+	GUEST_FAIL("L2 should not reach here");
+}
+
+static void l1_vmx_code(struct vmx_pages *vmx, uint64_t expected_fault_gpa,
+			 uint64_t test_type)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	uint64_t exit_qual;
+
+	GUEST_ASSERT(vmx->vmcs_gpa);
+	GUEST_ASSERT(prepare_for_vmx_operation(vmx));
+	GUEST_ASSERT(load_vmcs(vmx));
+
+	prepare_vmcs(vmx, l2_entry, &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	GUEST_ASSERT(!vmlaunch());
+
+	/* Verify we got an EPT violation exit */
+	__GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_EPT_VIOLATION,
+		       "Expected EPT violation (0x%x), got 0x%lx",
+		       EXIT_REASON_EPT_VIOLATION,
+		       vmreadz(VM_EXIT_REASON));
+
+	exit_qual = vmreadz(EXIT_QUALIFICATION);
+
+	switch (test_type) {
+	case TEST_FINAL_PAGE_UNMAPPED:
+		/* Read access, final translation, page not present */
+		__GUEST_ASSERT(exit_qual & EPT_VIOLATION_ACC_READ,
+			       "Expected ACC_READ set, exit_qual 0x%lx",
+			       exit_qual);
+		__GUEST_ASSERT(exit_qual & EPT_VIOLATION_GVA_IS_VALID,
+			       "Expected GVA_IS_VALID set, exit_qual 0x%lx",
+			       exit_qual);
+		__GUEST_ASSERT(exit_qual & EPT_VIOLATION_GVA_TRANSLATED,
+			       "Expected GVA_TRANSLATED set, exit_qual 0x%lx",
+			       exit_qual);
+		break;
+	case TEST_PT_PAGE_UNMAPPED:
+		/* Read access, page walk fault, page not present */
+		__GUEST_ASSERT(exit_qual & EPT_VIOLATION_ACC_READ,
+			       "Expected ACC_READ set, exit_qual 0x%lx",
+			       exit_qual);
+		__GUEST_ASSERT(exit_qual & EPT_VIOLATION_GVA_IS_VALID,
+			       "Expected GVA_IS_VALID set, exit_qual 0x%lx",
+			       exit_qual);
+		__GUEST_ASSERT(!(exit_qual & EPT_VIOLATION_GVA_TRANSLATED),
+			       "Expected GVA_TRANSLATED clear, exit_qual 0x%lx",
+			       exit_qual);
+		break;
+	case TEST_FINAL_PAGE_WRITE_PROTECTED:
+		/* Write access, final translation, page present but read-only */
+		__GUEST_ASSERT(exit_qual & EPT_VIOLATION_ACC_WRITE,
+			       "Expected ACC_WRITE set, exit_qual 0x%lx",
+			       exit_qual);
+		__GUEST_ASSERT(exit_qual & EPT_VIOLATION_PROT_READ,
+			       "Expected PROT_READ set, exit_qual 0x%lx",
+			       exit_qual);
+		__GUEST_ASSERT(!(exit_qual & EPT_VIOLATION_PROT_WRITE),
+			       "Expected PROT_WRITE clear, exit_qual 0x%lx",
+			       exit_qual);
+		__GUEST_ASSERT(exit_qual & EPT_VIOLATION_GVA_IS_VALID,
+			       "Expected GVA_IS_VALID set, exit_qual 0x%lx",
+			       exit_qual);
+		__GUEST_ASSERT(exit_qual & EPT_VIOLATION_GVA_TRANSLATED,
+			       "Expected GVA_TRANSLATED set, exit_qual 0x%lx",
+			       exit_qual);
+		break;
+	case TEST_PT_PAGE_WRITE_PROTECTED:
+		/* Write access (A/D update), page walk, page present but read-only */
+		__GUEST_ASSERT(exit_qual & EPT_VIOLATION_ACC_WRITE,
+			       "Expected ACC_WRITE set, exit_qual 0x%lx",
+			       exit_qual);
+		__GUEST_ASSERT(exit_qual & EPT_VIOLATION_PROT_READ,
+			       "Expected PROT_READ set, exit_qual 0x%lx",
+			       exit_qual);
+		__GUEST_ASSERT(!(exit_qual & EPT_VIOLATION_PROT_WRITE),
+			       "Expected PROT_WRITE clear, exit_qual 0x%lx",
+			       exit_qual);
+		__GUEST_ASSERT(exit_qual & EPT_VIOLATION_GVA_IS_VALID,
+			       "Expected GVA_IS_VALID set, exit_qual 0x%lx",
+			       exit_qual);
+		__GUEST_ASSERT(!(exit_qual & EPT_VIOLATION_GVA_TRANSLATED),
+			       "Expected GVA_TRANSLATED clear, exit_qual 0x%lx",
+			       exit_qual);
+		break;
+	}
+
+	__GUEST_ASSERT(vmreadz(GUEST_PHYSICAL_ADDRESS) == expected_fault_gpa,
+		       "Expected guest_physical_address = 0x%lx, got 0x%lx",
+		       expected_fault_gpa,
+		       vmreadz(GUEST_PHYSICAL_ADDRESS));
+
+	GUEST_DONE();
+}
+
+static void l1_svm_code(struct svm_test_data *svm, uint64_t expected_fault_gpa,
+			 uint64_t test_type)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb = svm->vmcb;
+	uint64_t exit_info_1;
+
+	generic_svm_setup(svm, l2_entry,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+
+	run_guest(vmcb, svm->vmcb_gpa);
+
+	/* Verify we got an NPF exit */
+	__GUEST_ASSERT(vmcb->control.exit_code == SVM_EXIT_NPF,
+		       "Expected NPF exit (0x%x), got 0x%lx", SVM_EXIT_NPF,
+		       vmcb->control.exit_code);
+
+	exit_info_1 = vmcb->control.exit_info_1;
+
+	switch (test_type) {
+	case TEST_FINAL_PAGE_UNMAPPED:
+		/* Read access, final translation, page not present */
+		__GUEST_ASSERT(exit_info_1 & PFERR_GUEST_FINAL_MASK,
+			       "Expected GUEST_FINAL set, exit_info_1 0x%lx",
+			       (unsigned long)exit_info_1);
+		__GUEST_ASSERT(!(exit_info_1 & PFERR_GUEST_PAGE_MASK),
+			       "Expected GUEST_PAGE clear, exit_info_1 0x%lx",
+			       (unsigned long)exit_info_1);
+		__GUEST_ASSERT(!(exit_info_1 & PFERR_PRESENT_MASK),
+			       "Expected PRESENT clear, exit_info_1 0x%lx",
+			       (unsigned long)exit_info_1);
+		break;
+	case TEST_PT_PAGE_UNMAPPED:
+		/* Read access, page walk fault, page not present */
+		__GUEST_ASSERT(exit_info_1 & PFERR_GUEST_PAGE_MASK,
+			       "Expected GUEST_PAGE set, exit_info_1 0x%lx",
+			       (unsigned long)exit_info_1);
+		__GUEST_ASSERT(!(exit_info_1 & PFERR_GUEST_FINAL_MASK),
+			       "Expected GUEST_FINAL clear, exit_info_1 0x%lx",
+			       (unsigned long)exit_info_1);
+		__GUEST_ASSERT(!(exit_info_1 & PFERR_PRESENT_MASK),
+			       "Expected PRESENT clear, exit_info_1 0x%lx",
+			       (unsigned long)exit_info_1);
+		break;
+	case TEST_FINAL_PAGE_WRITE_PROTECTED:
+		/* Write access, final translation, page present but read-only */
+		__GUEST_ASSERT(exit_info_1 & PFERR_GUEST_FINAL_MASK,
+			       "Expected GUEST_FINAL set, exit_info_1 0x%lx",
+			       (unsigned long)exit_info_1);
+		__GUEST_ASSERT(!(exit_info_1 & PFERR_GUEST_PAGE_MASK),
+			       "Expected GUEST_PAGE clear, exit_info_1 0x%lx",
+			       (unsigned long)exit_info_1);
+		__GUEST_ASSERT(exit_info_1 & PFERR_PRESENT_MASK,
+			       "Expected PRESENT set, exit_info_1 0x%lx",
+			       (unsigned long)exit_info_1);
+		__GUEST_ASSERT(exit_info_1 & PFERR_WRITE_MASK,
+			       "Expected WRITE set, exit_info_1 0x%lx",
+			       (unsigned long)exit_info_1);
+		break;
+	case TEST_PT_PAGE_WRITE_PROTECTED:
+		/* Write access (A/D update), page walk, page present but read-only */
+		__GUEST_ASSERT(exit_info_1 & PFERR_GUEST_PAGE_MASK,
+			       "Expected GUEST_PAGE set, exit_info_1 0x%lx",
+			       (unsigned long)exit_info_1);
+		__GUEST_ASSERT(!(exit_info_1 & PFERR_GUEST_FINAL_MASK),
+			       "Expected GUEST_FINAL clear, exit_info_1 0x%lx",
+			       (unsigned long)exit_info_1);
+		__GUEST_ASSERT(exit_info_1 & PFERR_PRESENT_MASK,
+			       "Expected PRESENT set, exit_info_1 0x%lx",
+			       (unsigned long)exit_info_1);
+		__GUEST_ASSERT(exit_info_1 & PFERR_WRITE_MASK,
+			       "Expected WRITE set, exit_info_1 0x%lx",
+			       (unsigned long)exit_info_1);
+		break;
+	}
+
+	__GUEST_ASSERT(vmcb->control.exit_info_2 == expected_fault_gpa,
+		       "Expected exit_info_2 = 0x%lx, got 0x%lx",
+		       expected_fault_gpa,
+		       vmcb->control.exit_info_2);
+
+	GUEST_DONE();
+}
+
+static void l1_guest_code(void *data, uint64_t expected_fault_gpa,
+			  uint64_t test_type)
+{
+	if (this_cpu_has(X86_FEATURE_VMX))
+		l1_vmx_code(data, expected_fault_gpa, test_type);
+	else
+		l1_svm_code(data, expected_fault_gpa, test_type);
+}
+
+/* Returns the GPA of the PT page that maps @vaddr. */
+static uint64_t get_pt_gpa_for_vaddr(struct kvm_vm *vm, uint64_t vaddr)
+{
+	uint64_t *pte;
+
+	pte = vm_get_pte(vm, vaddr);
+	TEST_ASSERT(pte && (*pte & 0x1), "PTE not present for vaddr 0x%lx",
+		    (unsigned long)vaddr);
+
+	return addr_hva2gpa(vm, (void *)((uint64_t)pte & ~0xFFFULL));
+}
+
+static void run_test(enum test_type type)
+{
+	vm_paddr_t expected_fault_gpa;
+	vm_vaddr_t nested_gva;
+
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+	vm_enable_tdp(vm);
+
+	if (kvm_cpu_has(X86_FEATURE_VMX))
+		vcpu_alloc_vmx(vm, &nested_gva);
+	else
+		vcpu_alloc_svm(vm, &nested_gva);
+
+	switch (type) {
+	case TEST_FINAL_PAGE_UNMAPPED:
+		/*
+		 * Unmap the final data page from NPT/EPT. The guest page
+		 * table walk succeeds, but the final GPA->HPA translation
+		 * fails. L2 reads from the page via OUTS.
+		 */
+		l2_entry = l2_guest_code_outs;
+		l2_test_page = vm_vaddr_alloc(vm, vm->page_size, TEST1_VADDR);
+		expected_fault_gpa = addr_gva2gpa(vm, l2_test_page);
+		break;
+	case TEST_PT_PAGE_UNMAPPED:
+		/*
+		 * Unmap a page table page from NPT/EPT. The hardware page
+		 * table walk fails when translating the PT page's GPA
+		 * through NPT/EPT. L2 reads from the page via OUTS.
+		 */
+		l2_entry = l2_guest_code_outs;
+		l2_test_page = vm_vaddr_alloc(vm, vm->page_size, TEST2_VADDR);
+		expected_fault_gpa = get_pt_gpa_for_vaddr(vm, l2_test_page);
+		break;
+	case TEST_FINAL_PAGE_WRITE_PROTECTED:
+		/*
+		 * Write-protect the final data page in NPT/EPT.  The page
+		 * is present and readable, but not writable.  L2 writes to
+		 * the page via INS, triggering a protection violation.
+		 */
+		l2_entry = l2_guest_code_ins;
+		l2_test_page = vm_vaddr_alloc(vm, vm->page_size, TEST3_VADDR);
+		expected_fault_gpa = addr_gva2gpa(vm, l2_test_page);
+		break;
+	case TEST_PT_PAGE_WRITE_PROTECTED:
+		/*
+		 * Write-protect a page table page in NPT/EPT.  The page is
+		 * present and readable, but not writable.  The guest page
+		 * table walk needs write access to set A/D bits, so it
+		 * triggers a protection violation on the PT page.
+		 * L2 reads from the page via OUTS.
+		 */
+		l2_entry = l2_guest_code_outs;
+		l2_test_page = vm_vaddr_alloc(vm, vm->page_size, TEST4_VADDR);
+		expected_fault_gpa = get_pt_gpa_for_vaddr(vm, l2_test_page);
+		break;
+	}
+
+	tdp_identity_map_default_memslots(vm);
+
+	if (type == TEST_FINAL_PAGE_WRITE_PROTECTED ||
+	    type == TEST_PT_PAGE_WRITE_PROTECTED)
+		*tdp_get_pte(vm, expected_fault_gpa) &= ~PTE_WRITABLE_MASK(&vm->stage2_mmu);
+	else
+		*tdp_get_pte(vm, expected_fault_gpa) &= ~(PTE_PRESENT_MASK(&vm->stage2_mmu) |
+							   PTE_READABLE_MASK(&vm->stage2_mmu) |
+							   PTE_WRITABLE_MASK(&vm->stage2_mmu) |
+							   PTE_EXECUTABLE_MASK(&vm->stage2_mmu));
+
+	sync_global_to_guest(vm, l2_entry);
+	sync_global_to_guest(vm, l2_test_page);
+	vcpu_args_set(vcpu, 3, nested_gva, expected_fault_gpa, (uint64_t)type);
+
+	/*
+	 * For the INS-based write test, KVM emulates the instruction and
+	 * first reads from the I/O port, which exits to userspace.
+	 * Re-enter the guest so emulation can proceed to the memory
+	 * write, where the nested page fault is triggered.
+	 */
+	for (;;) {
+		vcpu_run(vcpu);
+
+		if (vcpu->run->exit_reason == KVM_EXIT_IO &&
+		    vcpu->run->io.port == TEST_IO_PORT &&
+		    vcpu->run->io.direction == KVM_EXIT_IO_IN) {
+			continue;
+		}
+		break;
+	}
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+	default:
+		TEST_FAIL("Unexpected exit reason: %d", vcpu->run->exit_reason);
+	}
+
+	kvm_vm_free(vm);
+}
+
+int main(int argc, char *argv[])
+{
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_VMX) || kvm_cpu_has(X86_FEATURE_SVM));
+	TEST_REQUIRE(kvm_cpu_has_tdp());
+
+	run_test(TEST_FINAL_PAGE_UNMAPPED);
+	run_test(TEST_PT_PAGE_UNMAPPED);
+	run_test(TEST_FINAL_PAGE_WRITE_PROTECTED);
+	run_test(TEST_PT_PAGE_WRITE_PROTECTED);
+
+	return 0;
+}
-- 
2.53.0.414.gf7e9f6c205-goog


