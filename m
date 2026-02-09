Return-Path: <kvm+bounces-70643-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oCTtDEs7imlvIgAAu9opvQ
	(envelope-from <kvm+bounces-70643-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 20:53:47 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 89D81114440
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 20:53:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AD11B3036052
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 19:53:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5494538A712;
	Mon,  9 Feb 2026 19:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="evffC1a1"
X-Original-To: kvm@vger.kernel.org
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 626D1428461
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 19:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770666785; cv=none; b=f8D0iVluCRJ7ZAhnk9h4gyMprRHfwDA74EVEaO7y4YBi5t0QhYtq8meratW1G5FnJospwe4rhT1FFYRRWRAkLLO8rDP1f9AyPL8C5BwHgEPg8aI5agjj/UeUhkD/70iADYwFdM9QeNrtL6zYJ/9JdCA4IbcQi0kCIMiNdPHjTuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770666785; c=relaxed/simple;
	bh=kwLeHpwXB93kA2kA5PIFCI7gv/QvpkmOePSGl8gjVtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/YZBT7fIJ0P6EPlo+YhbL6enNmm0GzebFlRtgqU/f87CCw3U0YBMEAuWf1gKyTWxjatjd747iWk7hAwqKoUzOLPhZf5SKU00fjqieQjciqKnZPh59ssjuTivdL54pq5hrWiLtKCr/WsOJwr74bPjPRrpSIUMMMbfWhO7Y3inic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=evffC1a1; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770666784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LOFUFZtvZUm4eoRVpzHMdMVSi4TwGR8WtU1V2w4bGMU=;
	b=evffC1a1MhTnu23JcYQGN1RyeqGeLKAaR2bqfScWcq84xt//i3+LKtSYtia/tPaRwYwh+v
	BktKFA+p8vP7o1URcW0SYo2l72l6vvu+s1VhMeFiJ7QVBTo+nXl7ca9wMTBhdAW1Dqbjce
	XJWMa6j+HP3NmOIVY9BciTyujUPqnAc=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH v2 2/2] KVM: selftests: Add a test for L2 clearing EFER.SVME without intercept
Date: Mon,  9 Feb 2026 19:51:42 +0000
Message-ID: <20260209195142.2554532-3-yosry.ahmed@linux.dev>
In-Reply-To: <20260209195142.2554532-1-yosry.ahmed@linux.dev>
References: <20260209195142.2554532-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70643-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	PRECEDENCE_BULK(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:mid,linux.dev:dkim,linux.dev:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 89D81114440
X-Rspamd-Action: no action

Add a test that verifies KVM's newly introduced behavior of synthesizing
a triple fault in L1 if L2 clears EFER.SVME without an L1 interception
(which is architecturally undefined).

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/Makefile.kvm      |  1 +
 .../kvm/x86/svm_nested_clear_efer_svme.c      | 55 +++++++++++++++++++
 2 files changed, 56 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/x86/svm_nested_clear_efer_svme.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 58eee0474db6..89ba5d6ee741 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -110,6 +110,7 @@ TEST_GEN_PROGS_x86 += x86/state_test
 TEST_GEN_PROGS_x86 += x86/vmx_preemption_timer_test
 TEST_GEN_PROGS_x86 += x86/svm_vmcall_test
 TEST_GEN_PROGS_x86 += x86/svm_int_ctl_test
+TEST_GEN_PROGS_x86 += x86/svm_nested_clear_efer_svme
 TEST_GEN_PROGS_x86 += x86/svm_nested_shutdown_test
 TEST_GEN_PROGS_x86 += x86/svm_nested_soft_inject_test
 TEST_GEN_PROGS_x86 += x86/tsc_scaling_sync
diff --git a/tools/testing/selftests/kvm/x86/svm_nested_clear_efer_svme.c b/tools/testing/selftests/kvm/x86/svm_nested_clear_efer_svme.c
new file mode 100644
index 000000000000..a521a9eed061
--- /dev/null
+++ b/tools/testing/selftests/kvm/x86/svm_nested_clear_efer_svme.c
@@ -0,0 +1,55 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2026, Google LLC.
+ */
+#include "kvm_util.h"
+#include "vmx.h"
+#include "svm_util.h"
+#include "kselftest.h"
+
+
+#define L2_GUEST_STACK_SIZE 64
+
+static void l2_guest_code(void)
+{
+	unsigned long efer = rdmsr(MSR_EFER);
+
+	/* generic_svm_setup() initializes EFER_SVME set for L2 */
+	GUEST_ASSERT(efer & EFER_SVME);
+	wrmsr(MSR_EFER, efer & ~EFER_SVME);
+
+	/* Unreachable, L1 should be shutdown */
+	GUEST_ASSERT(0);
+}
+
+static void l1_guest_code(struct svm_test_data *svm)
+{
+	unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
+
+	generic_svm_setup(svm, l2_guest_code,
+			  &l2_guest_stack[L2_GUEST_STACK_SIZE]);
+	run_guest(svm->vmcb, svm->vmcb_gpa);
+
+	/* Unreachable, L1 should be shutdown */
+	GUEST_ASSERT(0);
+}
+
+int main(int argc, char *argv[])
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	vm_vaddr_t nested_gva = 0;
+
+	TEST_REQUIRE(kvm_cpu_has(X86_FEATURE_SVM));
+
+	vm = vm_create_with_one_vcpu(&vcpu, l1_guest_code);
+
+	vcpu_alloc_svm(vm, &nested_gva);
+	vcpu_args_set(vcpu, 1, nested_gva);
+
+	vcpu_run(vcpu);
+	TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_SHUTDOWN);
+
+	kvm_vm_free(vm);
+	return 0;
+}
-- 
2.53.0.rc2.204.g2597b5adb4-goog


