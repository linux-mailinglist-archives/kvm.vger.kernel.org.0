Return-Path: <kvm+bounces-72230-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SLbeIgIPomniygQAu9opvQ
	(envelope-from <kvm+bounces-72230-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 22:39:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E76B41BE3A8
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 22:39:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E0ACA30AD8BD
	for <lists+kvm@lfdr.de>; Fri, 27 Feb 2026 21:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC85C47A0B8;
	Fri, 27 Feb 2026 21:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JCCjqxC7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32DC37BE9B
	for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 21:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772228345; cv=none; b=GY2cyUPSbvrjx5Vpb082JI0M/GT1QLEcFAFRFBq+Oo8vGGvC1U6Dvy79pFwl0Q4d8JL6eCBV25iYJdsPufyfk9uFU0Cw4M5kXC96zxh5TBpZ4APyQ9HxG3eU5u7hwZz75gMD73k4uc3sRHX8goQ8pHI4Fv/V3wvSzyMtmIrBq5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772228345; c=relaxed/simple;
	bh=cviVU3xD6JxK/FECVBz2YduYX59/TYXzSINjJm6njME=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=M2vK/Pt5vUvpUT7ftCZbFNmTfeTFsgUQ0Tsh5g557RpqJxsMpLwArEtS1jBsADfxg6jXz5UGN+JCepSF8z3jovLvOISupqTKl+kLSfKPKQJo1/1uk/8YRSwyjkssUfZ+U2edYgqGmEzNdReGEgRZhcLPhj+pAQiXjBkuCljk0iA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JCCjqxC7; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jmattson.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aad6045810so24700825ad.3
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 13:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772228343; x=1772833143; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nwdvBKl3gxteFLUbmJgO0ss76jgFGjRI1irykTmvd8E=;
        b=JCCjqxC7Klk/6EiU2UKLoGoUTp9MF8NnZyidExJsHlwWl0/pTl0ibfdtwcj3g5+Ani
         8pTspfjvbwI0AogntsukOeiLdHm1h16G7EBzo5796ASeAxjudcojFaOr9DHaSdvFfw5k
         kRvgIobhIabVkp8+D1eYIKHUB1KdyqI23THJHGx71c7/YtfdRuok3/ADBfKBe8F1udrh
         m1+tvBjk1Iqdc15d8fRTLl+jdgklws4vV34qq9MkKopCuOtcutjG/I5DjvpjGti4uEzH
         hHj5GZM5Fc29brmEbGqMjAdIbP6o4T49icAicgdo+ZiBH/0gYd/d2tni8pj9IAgrFJ48
         T0Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772228343; x=1772833143;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nwdvBKl3gxteFLUbmJgO0ss76jgFGjRI1irykTmvd8E=;
        b=KPMfsMYyGBSX5Cpu0puZMT35Lb0oDd6pROqoyHclBux5YOZTYjAxigQotmSJ3TfVjU
         XxnOa74xIjOircotksINyOerGHFbsPd4TqHcyrK05y8jaSE9PMji4a0uRMeEk0lnd5Ef
         e1y/nYFd+d3a/FfpJG/I4XCPO/LDp2xQE9Uy+UGMmmV+rdxxCV5c5h0ILvCTlzCH6M+i
         FWNKrPvGNs9cMdYrgI43dDMqNZOk9sGsK+cqgQcHVrBT3ZMJpW3XqIEuBwyw8FvS7Gc8
         GRY4jMegH2/0Jks2YkvHkq6WVeaIAuXOYsBuTvCV835JTrlH2j7FrEBM+FKi2OXjyuin
         4XKg==
X-Gm-Message-State: AOJu0YwrDCtRG2hF3t36PjhzaEab5N8ZpdXNSu4DCva+ClwClO6bfsL9
	06F3+jAQsZpDVOR8Agbru41j+kTxi186bsRHRbg853rrbMVoESlB7v9YUEaw3XnH3GGah6Uv7T/
	SlI6fPRxqNXgM3RTUYs7P8RxLfzHUwo4JlxRP6PSOZpBH8XbZnrbqz7/YDupxTv60CeTucX53tm
	8c/JDJk5/5MiFS51WYsQH0Ro4D31smJ7Vi9fhEl5Jb+14=
X-Received: from pltf9.prod.google.com ([2002:a17:902:74c9:b0:2ae:3a4e:20cf])
 (user=jmattson job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:4b27:b0:2a3:628d:dbea with SMTP id d9443c01a7336-2ae2e417736mr42682645ad.24.1772228342796;
 Fri, 27 Feb 2026 13:39:02 -0800 (PST)
Date: Fri, 27 Feb 2026 13:38:34 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260227213849.3653331-1-jmattson@google.com>
Subject: [kvm-unit-tests PATCH] x86: nVMX: Add retry loop to advanced RTM
 debugging subtest
From: Jim Mattson <jmattson@google.com>
To: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Yosry Ahmed <yosry@kernel.org>
Cc: Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72230-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E76B41BE3A8
X-Rspamd-Action: no action

Linux commit 400816f60c54 ("perf/x86/intel: Implement support for TSX Force
Abort") introduced a feature that temporarily disables RTM on Skylake and
similar CPUs (06_55H stepping <= 5, 06_4EH, 06_5EH, 06_8EH stepping <= 0BH,
and 06_9EH stepping <= 0CH) via the TSX_FORCE_ABORT MSR, so that all four
general purpose PMCs can be used by perf. This feature is on by default,
but can be disabled by writing 0 to /sys/devices/cpu/allow_tsx_force_abort.

When TSX_FORCE_ABORT.RTM_FORCE_ABORT[bit 0] is set, all RTM transactions
will immediately abort, before the xbegin instruction retires.

The test of a single-step #DB delivered in a transactional region,
introduced in commit 414bd9d5ebd7 ("x86: nVMX: Basic test of #DB intercept
in L1"), does not handle this scenario.

Modify the test to identify an immediate RTM transaction abort and to try
up to 30 times before giving up. If the xbegin instruction never retires,
report the test as skipped.

Note that when an RTM transaction aborts, the CPU state is rolled back to
before the xbegin instruction, but the RIP is modified to point to the
fallback code address. Hence, if the transaction aborts before the
single-step #DB trap is delivered, the first instruction of the fallback
code will retire before the single-step #DB trap is delivered.

Fixes: 414bd9d5ebd7 ("x86: nVMX: Basic test of #DB intercept in L1")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 lib/x86/msr.h   |  1 +
 x86/vmx_tests.c | 56 ++++++++++++++++++++++++++++++++-----------------
 2 files changed, 38 insertions(+), 19 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 7397809c07cd..97f52bb5bb4e 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -109,6 +109,7 @@
 #define DEBUGCTLMSR_BTS_OFF_OS		(1UL <<  9)
 #define DEBUGCTLMSR_BTS_OFF_USR		(1UL << 10)
 #define DEBUGCTLMSR_FREEZE_LBRS_ON_PMI	(1UL << 11)
+#define DEBUGCTLMSR_RTM_DEBUG		(1UL << 15)
 
 #define MSR_LBR_NHM_FROM	0x00000680
 #define MSR_LBR_NHM_TO		0x000006c0
diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 5ffb80a3d866..2094a0d3ec57 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -9217,9 +9217,10 @@ static void vmx_db_test_guest(void)
 	 * For a hardware generated single-step #DB in a transactional region.
 	 */
 	asm volatile("vmcall;"
-		     ".Lxbegin: xbegin .Lskip_rtm;"
+		     ".Lrtm_begin: xbegin .Lrtm_fallback;"
 		     "xend;"
-		     ".Lskip_rtm:");
+		     ".Lrtm_fallback: nop;"
+		     ".Lpost_rtm:");
 }
 
 /*
@@ -9295,6 +9296,10 @@ static void single_step_guest(const char *test_name, u64 starting_dr6,
  * exception bits are properly accumulated into the exit qualification
  * field.
  */
+
+#define RTM_RETRIES 30
+#define ONE_BILLION 1000000000ul
+
 static void vmx_db_test(void)
 {
 	/*
@@ -9308,8 +9313,8 @@ static void vmx_db_test(void)
 	extern char post_movss_nop asm(".Lpost_movss_nop");
 	extern char post_wbinvd asm(".Lpost_wbinvd");
 	extern char post_movss_wbinvd asm(".Lpost_movss_wbinvd");
-	extern char xbegin asm(".Lxbegin");
-	extern char skip_rtm asm(".Lskip_rtm");
+	extern char rtm_begin asm(".Lrtm_begin");
+	extern char post_rtm asm(".Lpost_rtm");
 
 	/*
 	 * L1 wants to intercept #DB exceptions encountered in L2.
@@ -9362,30 +9367,43 @@ static void vmx_db_test(void)
 		      starting_dr6);
 
 	/*
-	 * Optional RTM test for hardware that supports RTM, to
-	 * demonstrate that the current volume 3 of the SDM
-	 * (325384-067US), table 27-1 is incorrect. Bit 16 of the exit
-	 * qualification for debug exceptions is not reserved. It is
-	 * set to 1 if a debug exception (#DB) or a breakpoint
-	 * exception (#BP) occurs inside an RTM region while advanced
-	 * debugging of RTM transactional regions is enabled.
+	 * Optional RTM test for hardware that supports RTM, to verify that
+	 * bit 16 of the exit qualification for debug exceptions is set to
+	 * 1 if a #DB occurs inside an RTM region while advanced debugging
+	 * of RTM transactional regions is enabled.
 	 */
 	if (this_cpu_has(X86_FEATURE_RTM)) {
+		int i = RTM_RETRIES;
+
 		vmcs_write(ENT_CONTROLS,
 			   vmcs_read(ENT_CONTROLS) | ENT_LOAD_DBGCTLS);
 		/*
-		 * Set DR7.RTM[bit 11] and IA32_DEBUGCTL.RTM[bit 15]
-		 * in the guest to enable advanced debugging of RTM
-		 * transactional regions.
+		 * Set DR7.RTM and IA32_DEBUGCTL.RTM to enable advanced
+		 * debugging of RTM transactional regions. See "RTM-Enabled
+		 * Debugger Support" in the SDM, volume 1.
 		 */
-		vmcs_write(GUEST_DR7, BIT(11));
-		vmcs_write(GUEST_DEBUGCTL, BIT(15));
+		vmcs_write(GUEST_DR7, DR7_RTM);
+		vmcs_write(GUEST_DEBUGCTL, DEBUGCTLMSR_RTM_DEBUG);
+
 		single_step_guest("Hardware delivered single-step in "
 				  "transactional region", starting_dr6, 0);
-		check_db_exit(false, false, false, &xbegin, BIT(16),
-			      starting_dr6);
+
+		while (--i && vmcs_read(GUEST_RIP) == (u64)&post_rtm) {
+			delay(ONE_BILLION);
+			vmcs_write(GUEST_RIP, (u64)&rtm_begin);
+			enter_guest();
+		}
+
+		if (vmcs_read(GUEST_RIP) == (u64)&post_rtm) {
+			report_skip("Transaction always aborted before xbegin "
+				    "retired (%d attempts)", RTM_RETRIES);
+			dismiss_db();
+		} else {
+			check_db_exit(false, false, false, &rtm_begin, DR6_RTM,
+				      starting_dr6);
+		}
 	} else {
-		vmcs_write(GUEST_RIP, (u64)&skip_rtm);
+		vmcs_write(GUEST_RIP, (u64)&post_rtm);
 		enter_guest();
 	}
 }

base-commit: 86e53277ac80dabb04f4fa5fa6a6cc7649392bdc
prerequisite-patch-id: 177e49d1b63609e5b421ea64fe7490a4906617a9
prerequisite-patch-id: 7e71aa35841be5d72bf543e4f332554d12e83cc0
-- 
2.53.0.473.g4a7958ca14-goog


