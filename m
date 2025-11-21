Return-Path: <kvm+bounces-64246-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 74F85C7B87A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 20:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2982C3A406B
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:33:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA974305057;
	Fri, 21 Nov 2025 19:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n5AxN8lJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33503002A6;
	Fri, 21 Nov 2025 19:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763753553; cv=none; b=gpVjGJQUs8mYKH9RENqWYRurF4Y2u03fvoQIJcXodssvK8lJvPoueYz9J/4swsClCsOHD6c3fFeqw1GpxKlEYu01084eS9ypWTCLJzTpQlZzStzLhsxD4kd9wGRc6D25DppedIWNNp60e2PBW2w0BVhCubzanVh6YCrX1MYN4FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763753553; c=relaxed/simple;
	bh=XTcT2aRIC+bx02fSkf5olHtJ8KjSKocOAdwnrpK8srA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORpY81RpHaTukZGYAUWQhzhpxX/fteOprm9aSU5lPGwozYeLJEKWAGQMYaDjihfTVV9OdcXNKFDBVehd+4G3TZOVOQa8a2PSdACSAlhdpSmm/eMJNug11l/swRsHAnwHdznl5eM0Lhdtag3kxJYdsauxfhrOIQLOKB0N1V3PDcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n5AxN8lJ; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763753548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3DqFdYkdQ+nHqF3kgNLYzHfTDGHGl4q58gU1CFuLCXk=;
	b=n5AxN8lJ67yEwn2BfR3jw7OIm296RqyTe+falzjel5zEwqvjMHAsNos77Zgop2qB8pnfjp
	bNPgysusRbLlQRxXCMctkF38Ko3XcgyLaaOHjJmgdgTJG/Dh8I53v9ErJliDVVZscoyvHI
	4QWaCPyX34fZW19Uo5FPTNHQWeVhy6I=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Ken Hofsass <hofsass@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 3/3] KVM: selftests: Verify CR3 in debug_regs
Date: Fri, 21 Nov 2025 19:32:04 +0000
Message-ID: <20251121193204.952988-4-yosry.ahmed@linux.dev>
In-Reply-To: <20251121193204.952988-1-yosry.ahmed@linux.dev>
References: <20251121193204.952988-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If KVM_CAP_X86_GUEST_DEBUG_CR3 is set, check that the value of CR3 in
struct kvm_run on KVM_EXIT_DEBUG matches that returned by KVM_GET_SREGS.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/x86/debug_regs.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/x86/debug_regs.c b/tools/testing/selftests/kvm/x86/debug_regs.c
index 563e52217cdd..ecad92789182 100644
--- a/tools/testing/selftests/kvm/x86/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86/debug_regs.c
@@ -80,8 +80,9 @@ static void vcpu_skip_insn(struct kvm_vcpu *vcpu, int insn_len)
 
 int main(void)
 {
+	unsigned long long target_dr6, target_rip, target_cr3;
 	struct kvm_guest_debug debug;
-	unsigned long long target_dr6, target_rip;
+	struct kvm_sregs sregs;
 	struct kvm_vcpu *vcpu;
 	struct kvm_run *run;
 	struct kvm_vm *vm;
@@ -103,6 +104,14 @@ int main(void)
 	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
 	run = vcpu->run;
 
+	if (kvm_has_cap(KVM_CAP_X86_GUEST_DEBUG_CR3)) {
+		pr_info("Debug info includes guest CR3\n");
+		vcpu_sregs_get(vcpu, &sregs);
+		target_cr3 = sregs.cr3;
+	} else {
+		target_cr3 = 0;
+	}
+
 	/* Test software BPs - int3 */
 	pr_info("Testing INT3\n");
 	memset(&debug, 0, sizeof(debug));
@@ -112,6 +121,7 @@ int main(void)
 	TEST_ASSERT_EQ(run->exit_reason, KVM_EXIT_DEBUG);
 	TEST_ASSERT_EQ(run->debug.arch.exception, BP_VECTOR);
 	TEST_ASSERT_EQ(run->debug.arch.pc, CAST_TO_RIP(sw_bp));
+	TEST_ASSERT_EQ(run->debug.arch.cr3, target_cr3);
 	vcpu_skip_insn(vcpu, 1);
 
 	/* Test instruction HW BP over DR[0-3] */
@@ -128,6 +138,7 @@ int main(void)
 		TEST_ASSERT_EQ(run->debug.arch.exception, DB_VECTOR);
 		TEST_ASSERT_EQ(run->debug.arch.pc, CAST_TO_RIP(hw_bp));
 		TEST_ASSERT_EQ(run->debug.arch.dr6, target_dr6);
+		TEST_ASSERT_EQ(run->debug.arch.cr3, target_cr3);
 	}
 	/* Skip "nop" */
 	vcpu_skip_insn(vcpu, 1);
@@ -147,6 +158,7 @@ int main(void)
 		TEST_ASSERT_EQ(run->debug.arch.exception, DB_VECTOR);
 		TEST_ASSERT_EQ(run->debug.arch.pc, CAST_TO_RIP(write_data));
 		TEST_ASSERT_EQ(run->debug.arch.dr6, target_dr6);
+		TEST_ASSERT_EQ(run->debug.arch.cr3, target_cr3);
 		/* Rollback the 4-bytes "mov" */
 		vcpu_skip_insn(vcpu, -7);
 	}
@@ -169,6 +181,7 @@ int main(void)
 		TEST_ASSERT_EQ(run->debug.arch.exception, DB_VECTOR);
 		TEST_ASSERT_EQ(run->debug.arch.pc, target_rip);
 		TEST_ASSERT_EQ(run->debug.arch.dr6, target_dr6);
+		TEST_ASSERT_EQ(run->debug.arch.cr3, target_cr3);
 	}
 
 	/* Finally test global disable */
@@ -183,6 +196,7 @@ int main(void)
 	TEST_ASSERT_EQ(run->debug.arch.exception, DB_VECTOR);
 	TEST_ASSERT_EQ(run->debug.arch.pc, CAST_TO_RIP(bd_start));
 	TEST_ASSERT_EQ(run->debug.arch.dr6, target_dr6);
+	TEST_ASSERT_EQ(run->debug.arch.cr3, target_cr3);
 
 	/* Disable all debug controls, run to the end */
 	memset(&debug, 0, sizeof(debug));
-- 
2.52.0.rc2.455.g230fcf2819-goog


