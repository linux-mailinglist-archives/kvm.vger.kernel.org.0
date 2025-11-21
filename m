Return-Path: <kvm+bounces-64245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B3B8FC7B874
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 20:33:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A847C4E6C36
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 19:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DFF7301709;
	Fri, 21 Nov 2025 19:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="PuWJ0Tt+"
X-Original-To: kvm@vger.kernel.org
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB0D30217E
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 19:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763753552; cv=none; b=EFRMi0tvgjGAzyYY3+xVBFxqgDhyGKKbkfFJEIhn60EGrpEtx6/2hC1Juv4uNGELb8L79RH4wKvbbNLAUQInq31vAxOvLyANn32C49GOuQ16STovkh6uXjgPKycbF6aNgtaTdxg4G1diQMRY+oj8UIlbgg9Qzympj987wp3N204=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763753552; c=relaxed/simple;
	bh=yWgRTXXeJZU1v0pITpCzPJB/oUhQrczlGMOlkF7tLF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9SGRW3pw3Tkdi5IiIvsD+ngDR7pFYjsKGPaQ+MH/uvBDOnWo+tut3Sc+uG16CzXC1inFDVFDuvZ+W+mRCfueufa4deyJ9z5NgNH5F8WIZKQ4p4JDvJu8Qt6GfT+WhgX2UXZB4hQeg5lTofKfQkP8ke7NIFZc2RqAt7/azCRQGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=PuWJ0Tt+; arc=none smtp.client-ip=91.218.175.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763753547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9C9XfX+UY14sw/5vUVA6fyLzyZRFAVFX0tjWpm79IXc=;
	b=PuWJ0Tt+28oCCxCxw/ndtUo1oAvd/scT4LiQajCzrPArGxriJxRl0CWhmcKxIkfuYHra9D
	5KOSUF3S0ySGrrcf/FJATAo7gNtaEtvj4RaTxLOMGKSLRGH7PgOcQC1tI2mOPZbKyXXSDf
	NBOc/jjrUpnN8jhbSzpFUpl64awBaaE=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Ken Hofsass <hofsass@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 2/3] KVM: selftests: Use TEST_ASSERT_EQ() in debug_regs
Date: Fri, 21 Nov 2025 19:32:03 +0000
Message-ID: <20251121193204.952988-3-yosry.ahmed@linux.dev>
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

The test currently uses calls of TEST_ASSERT() that combine all checked
conditions for every test case. This makes it unclear which value is
incorrect without visually parsing the output.

The only useful content in the error message is the test case,
especially for test cases running in loops where even the line number of
the failed assertion does not provide full information.

Switch to using TEST_ASSERT_EQ(), and print the test case currently
being asserted to keep the information intact. The test output is a lot
more verbose now, but debuggability trumps conciseness (right?).

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 tools/testing/selftests/kvm/x86/debug_regs.c | 66 +++++++-------------
 1 file changed, 24 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/debug_regs.c b/tools/testing/selftests/kvm/x86/debug_regs.c
index 2d814c1d1dc4..563e52217cdd 100644
--- a/tools/testing/selftests/kvm/x86/debug_regs.c
+++ b/tools/testing/selftests/kvm/x86/debug_regs.c
@@ -104,20 +104,19 @@ int main(void)
 	run = vcpu->run;
 
 	/* Test software BPs - int3 */
+	pr_info("Testing INT3\n");
 	memset(&debug, 0, sizeof(debug));
 	debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
 	vcpu_guest_debug_set(vcpu, &debug);
 	vcpu_run(vcpu);
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
-		    run->debug.arch.exception == BP_VECTOR &&
-		    run->debug.arch.pc == CAST_TO_RIP(sw_bp),
-		    "INT3: exit %d exception %d rip 0x%llx (should be 0x%llx)",
-		    run->exit_reason, run->debug.arch.exception,
-		    run->debug.arch.pc, CAST_TO_RIP(sw_bp));
+	TEST_ASSERT_EQ(run->exit_reason, KVM_EXIT_DEBUG);
+	TEST_ASSERT_EQ(run->debug.arch.exception, BP_VECTOR);
+	TEST_ASSERT_EQ(run->debug.arch.pc, CAST_TO_RIP(sw_bp));
 	vcpu_skip_insn(vcpu, 1);
 
 	/* Test instruction HW BP over DR[0-3] */
 	for (i = 0; i < 4; i++) {
+		pr_info("Testing INS_HW_BP DR[%d]\n", i);
 		memset(&debug, 0, sizeof(debug));
 		debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW_BP;
 		debug.arch.debugreg[i] = CAST_TO_RIP(hw_bp);
@@ -125,21 +124,17 @@ int main(void)
 		vcpu_guest_debug_set(vcpu, &debug);
 		vcpu_run(vcpu);
 		target_dr6 = 0xffff0ff0 | (1UL << i);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
-			    run->debug.arch.exception == DB_VECTOR &&
-			    run->debug.arch.pc == CAST_TO_RIP(hw_bp) &&
-			    run->debug.arch.dr6 == target_dr6,
-			    "INS_HW_BP (DR%d): exit %d exception %d rip 0x%llx "
-			    "(should be 0x%llx) dr6 0x%llx (should be 0x%llx)",
-			    i, run->exit_reason, run->debug.arch.exception,
-			    run->debug.arch.pc, CAST_TO_RIP(hw_bp),
-			    run->debug.arch.dr6, target_dr6);
+		TEST_ASSERT_EQ(run->exit_reason, KVM_EXIT_DEBUG);
+		TEST_ASSERT_EQ(run->debug.arch.exception, DB_VECTOR);
+		TEST_ASSERT_EQ(run->debug.arch.pc, CAST_TO_RIP(hw_bp));
+		TEST_ASSERT_EQ(run->debug.arch.dr6, target_dr6);
 	}
 	/* Skip "nop" */
 	vcpu_skip_insn(vcpu, 1);
 
 	/* Test data access HW BP over DR[0-3] */
 	for (i = 0; i < 4; i++) {
+		pr_info("Testing DATA_HW_BP DR[%d]\n", i);
 		memset(&debug, 0, sizeof(debug));
 		debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW_BP;
 		debug.arch.debugreg[i] = CAST_TO_RIP(guest_value);
@@ -148,15 +143,10 @@ int main(void)
 		vcpu_guest_debug_set(vcpu, &debug);
 		vcpu_run(vcpu);
 		target_dr6 = 0xffff0ff0 | (1UL << i);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
-			    run->debug.arch.exception == DB_VECTOR &&
-			    run->debug.arch.pc == CAST_TO_RIP(write_data) &&
-			    run->debug.arch.dr6 == target_dr6,
-			    "DATA_HW_BP (DR%d): exit %d exception %d rip 0x%llx "
-			    "(should be 0x%llx) dr6 0x%llx (should be 0x%llx)",
-			    i, run->exit_reason, run->debug.arch.exception,
-			    run->debug.arch.pc, CAST_TO_RIP(write_data),
-			    run->debug.arch.dr6, target_dr6);
+		TEST_ASSERT_EQ(run->exit_reason, KVM_EXIT_DEBUG);
+		TEST_ASSERT_EQ(run->debug.arch.exception, DB_VECTOR);
+		TEST_ASSERT_EQ(run->debug.arch.pc, CAST_TO_RIP(write_data));
+		TEST_ASSERT_EQ(run->debug.arch.dr6, target_dr6);
 		/* Rollback the 4-bytes "mov" */
 		vcpu_skip_insn(vcpu, -7);
 	}
@@ -167,6 +157,7 @@ int main(void)
 	target_rip = CAST_TO_RIP(ss_start);
 	target_dr6 = 0xffff4ff0ULL;
 	for (i = 0; i < ARRAY_SIZE(ss_size); i++) {
+		pr_info("Testing SINGLE_STEP (%d)\n", i);
 		target_rip += ss_size[i];
 		memset(&debug, 0, sizeof(debug));
 		debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_SINGLESTEP |
@@ -174,33 +165,24 @@ int main(void)
 		debug.arch.debugreg[7] = 0x00000400;
 		vcpu_guest_debug_set(vcpu, &debug);
 		vcpu_run(vcpu);
-		TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
-			    run->debug.arch.exception == DB_VECTOR &&
-			    run->debug.arch.pc == target_rip &&
-			    run->debug.arch.dr6 == target_dr6,
-			    "SINGLE_STEP[%d]: exit %d exception %d rip 0x%llx "
-			    "(should be 0x%llx) dr6 0x%llx (should be 0x%llx)",
-			    i, run->exit_reason, run->debug.arch.exception,
-			    run->debug.arch.pc, target_rip, run->debug.arch.dr6,
-			    target_dr6);
+		TEST_ASSERT_EQ(run->exit_reason, KVM_EXIT_DEBUG);
+		TEST_ASSERT_EQ(run->debug.arch.exception, DB_VECTOR);
+		TEST_ASSERT_EQ(run->debug.arch.pc, target_rip);
+		TEST_ASSERT_EQ(run->debug.arch.dr6, target_dr6);
 	}
 
 	/* Finally test global disable */
+	pr_info("Testing DR7.GD\n");
 	memset(&debug, 0, sizeof(debug));
 	debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_HW_BP;
 	debug.arch.debugreg[7] = 0x400 | DR7_GD;
 	vcpu_guest_debug_set(vcpu, &debug);
 	vcpu_run(vcpu);
 	target_dr6 = 0xffff0ff0 | DR6_BD;
-	TEST_ASSERT(run->exit_reason == KVM_EXIT_DEBUG &&
-		    run->debug.arch.exception == DB_VECTOR &&
-		    run->debug.arch.pc == CAST_TO_RIP(bd_start) &&
-		    run->debug.arch.dr6 == target_dr6,
-			    "DR7.GD: exit %d exception %d rip 0x%llx "
-			    "(should be 0x%llx) dr6 0x%llx (should be 0x%llx)",
-			    run->exit_reason, run->debug.arch.exception,
-			    run->debug.arch.pc, target_rip, run->debug.arch.dr6,
-			    target_dr6);
+	TEST_ASSERT_EQ(run->exit_reason, KVM_EXIT_DEBUG);
+	TEST_ASSERT_EQ(run->debug.arch.exception, DB_VECTOR);
+	TEST_ASSERT_EQ(run->debug.arch.pc, CAST_TO_RIP(bd_start));
+	TEST_ASSERT_EQ(run->debug.arch.dr6, target_dr6);
 
 	/* Disable all debug controls, run to the end */
 	memset(&debug, 0, sizeof(debug));
-- 
2.52.0.rc2.455.g230fcf2819-goog


