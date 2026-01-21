Return-Path: <kvm+bounces-68823-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCmcMu9ZcWkNEwAAu9opvQ
	(envelope-from <kvm+bounces-68823-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:57:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 63DAB5F293
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 23:57:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0F3A95ABCDB
	for <lists+kvm@lfdr.de>; Wed, 21 Jan 2026 22:57:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FAA745BD66;
	Wed, 21 Jan 2026 22:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YM4kIzrz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9449C3D3008
	for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 22:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769036120; cv=none; b=AZJydNcg+7fcaU5Wle1KhVdASwv+zACpG2xJ6bQDOaA97wAq0tNkngNo98ZsZGFQY9q9+m1ELFTob4i3i3rqubKawsbATrOfpXEA/Yd1RdPJwKYM6ONQnLZMCuMS1hulCkrRp/ksKO95swaH5tDu6JVXTdvG719XZrhGkRbUf9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769036120; c=relaxed/simple;
	bh=rYmfFxJAIso34omZtNLieNENfALkCc2zmC93xUg6tbg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Bw12oWg76I9URqgg6N/pjlnAxNpveUla4XUxloX3/1ZlD1Hvbi4tEDX+EeNCZKVsklnMuil9zZsIAs82NQZq79O+XFpehFbTYsW1hLXoQQm+cCfnGov/irsO9OniFcfZp8k5Iika3+nXlnMMJyDIyt47+yGFDQpo/ZPN/ZsIq3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YM4kIzrz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34ab459c051so775018a91.0
        for <kvm@vger.kernel.org>; Wed, 21 Jan 2026 14:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769036113; x=1769640913; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JICyYLoyMG4i3hAuwsrXfwlezARecCmtVIZbGsycDJA=;
        b=YM4kIzrz/CQDC0z+5+Gsyce9xKPiCX6241qpVUMWk2dvwefYz9g3YfdqCNF6tGqwE4
         vYVGE9GX5jAtBRz+Twp8ZNEi5q4Yfb5vzwbFAeNtQmJubIO59M224W2dGxmxBR5JWgeS
         /eKjOU9WOz/Fasb7b0iNl5h6nfIBoWDRkjXIaIlPi/KjiA7z17mUNeYmFuZf9fz5c8wK
         s+4kzokwk7k5kaQBIw4aGy8uWomdd0oy/9uwgweu3qtJKRkJ610uAbRz8E1aQFOnnedh
         +b4hs2VfKqlRhKpgF7HWybiXx00NGyB2an/AjoAg7ywRU5U/dU0iBuh5KNjozj7ghwIf
         8deQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769036113; x=1769640913;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JICyYLoyMG4i3hAuwsrXfwlezARecCmtVIZbGsycDJA=;
        b=i/5BsbC2V0qhrJjPUq97mXjwVM3/BYIwt++Z9MNqstPTJxmCZpsiMnKZopiPVIt7su
         hLWqgKmpHKwbIntGmkCd315TWkdZ8mIvNCyN0G8WmHIU/9kBfpX88jABPwa9QgncXCyQ
         l7ahCspfd59CB2jPtAm4iQ3l42bjJPO5TjTGtu0NFgIcMA4M117jxCRQJa7zQQ4vxd92
         RxLDEzDFDiSnUOShzn67QlrkwMHPe+DQrm4xohjyQNk5wjlt1nBxXlwebc17UH534P4A
         pYBjEZD9phQ6WCAF1GuwXoTpEFWC7vE5xzeJeMCtBfVUtimU3XV+m3z+5kSDcagM22fR
         OHEw==
X-Forwarded-Encrypted: i=1; AJvYcCX+2QLkOx/ZteQtbLqvy8RQ02ws3oLQeUi0eVXtfzuQrReuxdnkifnW0Zedm/DBsDpweKw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7448MKuLk8FD/CJBR1DTDGP9R7QX55mumkIRlvboHVCcln1lS
	rmPMoowPFBuZOBtq2Kyf/ESVV2fJ52OIl/bFtecUMGxfxRqF0qdx2sjgF1P/6apteeclfQTKt8i
	I6tckiimxayDr0A==
X-Received: from plat13.prod.google.com ([2002:a17:902:e1cd:b0:29f:13b1:d028])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:196d:b0:2a7:6cdc:7f14 with SMTP id d9443c01a7336-2a76cdc8521mr50987495ad.60.1769036112692;
 Wed, 21 Jan 2026 14:55:12 -0800 (PST)
Date: Wed, 21 Jan 2026 14:54:04 -0800
In-Reply-To: <20260121225438.3908422-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260121225438.3908422-1-jmattson@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260121225438.3908422-7-jmattson@google.com>
Subject: [PATCH 6/6] KVM: selftests: x86: Add svm_pmu_hg_test for HG_ONLY bits
From: Jim Mattson <jmattson@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	James Clark <james.clark@linaro.org>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.46 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[23];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68823-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DMARC_POLICY_ALLOW(0.00)[google.com,reject];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	ASN(0.00)[asn:7979, ipnet:142.0.200.0/24, country:US];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:helo,dfw.mirrors.kernel.org:rdns]
X-Rspamd-Queue-Id: 63DAB5F293
X-Rspamd-Action: no action

Add a selftest to verify KVM correctly virtualizes the AMD PMU Host-Only
(bit 41) and Guest-Only (bit 40) event selector bits across all relevant
SVM state transitions.

For both Guest-Only and Host-Only counters, verify that:
  1. SVME=0: counter counts (HG_ONLY bits ignored)
  2. Set SVME=1: counter behavior changes based on HG_ONLY bit
  3. VMRUN to L2: counter behavior switches (guest vs host mode)
  4. VMEXIT to L1: counter behavior switches back
  5. Clear SVME=0: counter counts (HG_ONLY bits ignored again)

Also confirm that setting both bits is the same as setting neither bit.

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/x86/svm_pmu_hg_test.c       | 297 ++++++++++++++++++
 2 files changed, 298 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_pmu_hg_test.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index e88699e227dd..06ba85d97618 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -112,6 +112,7 @@ TEST_GEN_PROGS_x86 += x86/svm_vmcall_test
 TEST_GEN_PROGS_x86 += x86/svm_int_ctl_test
 TEST_GEN_PROGS_x86 += x86/svm_nested_shutdown_test
 TEST_GEN_PROGS_x86 += x86/svm_nested_soft_inject_test
+TEST_GEN_PROGS_x86 += x86/svm_pmu_hg_test
 TEST_GEN_PROGS_x86 += x86/tsc_scaling_sync
 TEST_GEN_PROGS_x86 += x86/sync_regs_test
 TEST_GEN_PROGS_x86 += x86/ucna_injection_test
diff --git a/tools/testing/selftests/kvm/x86/svm_pmu_hg_test.c b/tools/testing/selftests/kvm/x86/svm_pmu_hg_test.c
new file mode 100644
index 000000000000..e811b4c1a818
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/svm_pmu_hg_test.c
@@ -0,0 +1,297 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KVM nested SVM PMU Host-Only/Guest-Only test
+ *
+ * Copyright (C) 2026, Google LLC.
+ *
+ * Test that KVM correctly virtualizes the AMD PMU Host-Only (bit 41) and
+ * Guest-Only (bit 40) event selector bits across all SVM state transitions.
+ *
+ * For Guest-Only counters:
+ *   1. SVME=0: counter counts (HG_ONLY bits ignored)
+ *   2. Set SVME=1: counter stops (in host mode)
+ *   3. VMRUN to L2: counter counts (in guest mode)
+ *   4. VMEXIT to L1: counter stops (back to host mode)
+ *   5. Clear SVME=0: counter counts (HG_ONLY bits ignored)
+ *
+ * For Host-Only counters:
+ *   1. SVME=0: counter counts (HG_ONLY bits ignored)
+ *   2. Set SVME=1: counter counts (in host mode)
+ *   3. VMRUN to L2: counter stops (in guest mode)
+ *   4. VMEXIT to L1: counter counts (back to host mode)
+ *   5. Clear SVME=0: counter counts (HG_ONLY bits ignored)
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
+#include "pmu.h"
+
+#define L2_GUEST_STACK_SIZE	256
+
+#define MSR_F15H_PERF_CTL0	0xc0010200
+#define MSR_F15H_PERF_CTR0	0xc0010201
+
+#define AMD64_EVENTSEL_GUESTONLY	BIT_ULL(40)
+#define AMD64_EVENTSEL_HOSTONLY		BIT_ULL(41)
+
+#define EVENTSEL_RETIRED_INSNS	(ARCH_PERFMON_EVENTSEL_OS |	\
+				 ARCH_PERFMON_EVENTSEL_USR |	\
+				 ARCH_PERFMON_EVENTSEL_ENABLE | \
+				 AMD_ZEN_INSTRUCTIONS_RETIRED)
+
+#define LOOP_INSNS	1000
+
+static __always_inline void run_instruction_loop(void)
+{
+	unsigned int i;
+
+	for (i = 0; i < LOOP_INSNS; i++)
+		__asm__ __volatile__("nop");
+}
+
+static __always_inline uint64_t run_and_measure(void)
+{
+	uint64_t count_before, count_after;
+
+	count_before = rdmsr(MSR_F15H_PERF_CTR0);
+	run_instruction_loop();
+	count_after = rdmsr(MSR_F15H_PERF_CTR0);
+
+	return count_after - count_before;
+}
+
+struct hg_test_data {
+	uint64_t l2_delta;
+	bool l2_done;
+};
+
+static struct hg_test_data *hg_data;
+
+static void l2_guest_code(void)
+{
+	hg_data->l2_delta = run_and_measure();
+	hg_data->l2_done = true;
+	vmmcall();
+}
+
+/*
+ * Test Guest-Only counter across all relevant state transitions.
+ */
+static void l1_guest_code_guestonly(struct svm_test_data *svm,
+				    struct hg_test_data *data)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb = svm->vmcb;
+	uint64_t eventsel, delta;
+
+	hg_data = data;
+
+	eventsel = EVENTSEL_RETIRED_INSNS | AMD64_EVENTSEL_GUESTONLY;
+	wrmsr(MSR_F15H_PERF_CTL0, eventsel);
+	wrmsr(MSR_F15H_PERF_CTR0, 0);
+
+	/* Step 1: SVME=0; HG_ONLY ignored */
+	wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
+	delta = run_and_measure();
+	GUEST_ASSERT_NE(delta, 0);
+
+	/* Step 2: Set SVME=1; Guest-Only counter stops */
+	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
+	delta = run_and_measure();
+	GUEST_ASSERT_EQ(delta, 0);
+
+	/* Step 3: VMRUN to L2; Guest-Only counter counts */
+	generic_svm_setup(svm, l2_guest_code,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_MSR_PROT);
+
+	run_guest(vmcb, svm->vmcb_gpa);
+
+	GUEST_ASSERT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+	GUEST_ASSERT(data->l2_done);
+	GUEST_ASSERT_NE(data->l2_delta, 0);
+
+	/* Step 4: After VMEXIT to L1; Guest-Only counter stops */
+	delta = run_and_measure();
+	GUEST_ASSERT_EQ(delta, 0);
+
+	/* Step 5: Clear SVME; HG_ONLY ignored */
+	wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
+	delta = run_and_measure();
+	GUEST_ASSERT_NE(delta, 0);
+
+	GUEST_DONE();
+}
+
+/*
+ * Test Host-Only counter across all relevant state transitions.
+ */
+static void l1_guest_code_hostonly(struct svm_test_data *svm,
+				   struct hg_test_data *data)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb = svm->vmcb;
+	uint64_t eventsel, delta;
+
+	hg_data = data;
+
+	eventsel = EVENTSEL_RETIRED_INSNS | AMD64_EVENTSEL_HOSTONLY;
+	wrmsr(MSR_F15H_PERF_CTL0, eventsel);
+	wrmsr(MSR_F15H_PERF_CTR0, 0);
+
+
+	/* Step 1: SVME=0; HG_ONLY ignored */
+	wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
+	delta = run_and_measure();
+	GUEST_ASSERT_NE(delta, 0);
+
+	/* Step 2: Set SVME=1; Host-Only counter still counts */
+	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
+	delta = run_and_measure();
+	GUEST_ASSERT_NE(delta, 0);
+
+	/* Step 3: VMRUN to L2; Host-Only counter stops */
+	generic_svm_setup(svm, l2_guest_code,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_MSR_PROT);
+
+	run_guest(vmcb, svm->vmcb_gpa);
+
+	GUEST_ASSERT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+	GUEST_ASSERT(data->l2_done);
+	GUEST_ASSERT_EQ(data->l2_delta, 0);
+
+	/* Step 4: After VMEXIT to L1; Host-Only counter counts */
+	delta = run_and_measure();
+	GUEST_ASSERT_NE(delta, 0);
+
+	/* Step 5: Clear SVME; HG_ONLY ignored */
+	wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
+	delta = run_and_measure();
+	GUEST_ASSERT_NE(delta, 0);
+
+	GUEST_DONE();
+}
+
+/*
+ * Test that both bits set is the same as neither bit set (always counts).
+ */
+static void l1_guest_code_both_bits(struct svm_test_data *svm,
+				    struct hg_test_data *data)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+	struct vmcb *vmcb = svm->vmcb;
+	uint64_t eventsel, delta;
+
+	hg_data = data;
+
+	eventsel = EVENTSEL_RETIRED_INSNS |
+		AMD64_EVENTSEL_HOSTONLY | AMD64_EVENTSEL_GUESTONLY;
+	wrmsr(MSR_F15H_PERF_CTL0, eventsel);
+	wrmsr(MSR_F15H_PERF_CTR0, 0);
+
+	/* Step 1: SVME=0 */
+	wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
+	delta = run_and_measure();
+	GUEST_ASSERT_NE(delta, 0);
+
+	/* Step 2: Set SVME=1 */
+	wrmsr(MSR_EFER, rdmsr(MSR_EFER) | EFER_SVME);
+	delta = run_and_measure();
+	GUEST_ASSERT_NE(delta, 0);
+
+	/* Step 3: VMRUN to L2 */
+	generic_svm_setup(svm, l2_guest_code,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+	vmcb->control.intercept &= ~(1ULL << INTERCEPT_MSR_PROT);
+
+	run_guest(vmcb, svm->vmcb_gpa);
+
+	GUEST_ASSERT_EQ(vmcb->control.exit_code, SVM_EXIT_VMMCALL);
+	GUEST_ASSERT(data->l2_done);
+	GUEST_ASSERT_NE(data->l2_delta, 0);
+
+	/* Step 4: After VMEXIT to L1 */
+	delta = run_and_measure();
+	GUEST_ASSERT_NE(delta, 0);
+
+	/* Step 5: Clear SVME */
+	wrmsr(MSR_EFER, rdmsr(MSR_EFER) & ~EFER_SVME);
+	delta = run_and_measure();
+	GUEST_ASSERT_NE(delta, 0);
+
+	GUEST_DONE();
+}
+
+static void l1_guest_code(struct svm_test_data *svm, struct hg_test_data *data,
+			  int test_num)
+{
+	switch (test_num) {
+	case 0:
+		l1_guest_code_guestonly(svm, data);
+		break;
+	case 1:
+		l1_guest_code_hostonly(svm, data);
+		break;
+	case 2:
+		l1_guest_code_both_bits(svm, data);
+		break;
+	}
+}
+
+static void run_test(int test_number, const char *test_name)
+{
+	struct hg_test_data *data_hva;
+	vm_vaddr_t svm_gva, data_gva;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	struct ucall uc;
+
+	pr_info("Testing: %s\n", test_name);
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+
+	vcpu_alloc_svm(vm, &svm_gva);
+
+	data_gva = vm_vaddr_alloc_page(vm);
+	data_hva = addr_gva2hva(vm, data_gva);
+	memset(data_hva, 0, sizeof(*data_hva));
+
+	vcpu_args_set(vcpu, 3, svm_gva, data_gva, test_number);
+
+	for (;;) {
+		vcpu_run(vcpu);
+		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			/* NOT REACHED */
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
+	TEST_REQUIRE(kvm_is_pmu_enabled());
+	TEST_REQUIRE(get_kvm_amd_param_bool("enable_mediated_pmu"));
+
+	run_test(0, "Guest-Only counter across all transitions");
+	run_test(1, "Host-Only counter across all transitions");
+	run_test(2, "Both HG_ONLY bits set (always count)");
+
+	return 0;
+}
-- 
2.52.0.457.g6b5491de43-goog


