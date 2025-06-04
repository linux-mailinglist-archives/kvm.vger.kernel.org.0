Return-Path: <kvm+bounces-48441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 55C05ACE46B
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 20:36:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 942B91896ECE
	for <lists+kvm@lfdr.de>; Wed,  4 Jun 2025 18:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96F7D20C488;
	Wed,  4 Jun 2025 18:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O2hxCAuF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA0D1FE45B
	for <kvm@vger.kernel.org>; Wed,  4 Jun 2025 18:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749062196; cv=none; b=Kxi8yVw1CTdu72FjKp7aZVLDyvy+cCte+IMlYg/E26HVYwYDQmA4/8kuAGysuhSg9MZvo4AeAu8rEN7+QsOAwzgGIPPv9uid3CJ+L7TEtjG/5LWQXqX3Gr/8bKwDjdmT5PYtiqUzyr/fH6haWCAB64CLvKGflwL5pp7iAu0L+nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749062196; c=relaxed/simple;
	bh=KityFWkSI8B98VXYq7NN7plsN5inRVdhtc0AI9lBcIA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=D3Nu+3qvmKy4cvKPb3mwv9oNriknSuDv2/T8qrfuOjKdvLcexA6Hkt/ygKGgDGGq9kZK39XsEZ/bG8Ymt6UE1HXYgoVuuOf78J7Kivcr7/7Vc1RsNz29hJjSp29rGYJ/2z/UDR2PPSf6gZWXB2SBzdZkDEOg9TCAdMZoeHccnmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O2hxCAuF; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-742d077bdfaso244978b3a.2
        for <kvm@vger.kernel.org>; Wed, 04 Jun 2025 11:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749062193; x=1749666993; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=AbtN8LYDlX7ERBpe5CgpLtQEEghskOM9nZd9OA/GIIw=;
        b=O2hxCAuF2xZNKlmF37KWXO6Gq+BLziPE0Rq6SSyQU+hmFRVqRGwpAq1ZYveZfsuwQe
         eosEYhoZ75k7QD1px1lW4eFxtthnLRnHSJaJLwrZiLfDnQlYzDTBo0cl9WlfYJV+3Po9
         M6qiWJsE7iv4KB9of2lr5wJ1ehEv5gmNyHQPHwF4E9jiwq2uR0E0d4jNHmi3r6zgE5U/
         gp6xmq1/iuktDhmVNVfQRfhhpBHxmdOZuRU1K3dBzv2nhZONmzM2Di8E8nLUDfX8VHCV
         5knrQ8P36b7iIMr3DQse3CPHPhDEffkY1aLU/1HKv969yUAF8kv9WhPQ9wugkBxd2hGs
         WzGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749062193; x=1749666993;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AbtN8LYDlX7ERBpe5CgpLtQEEghskOM9nZd9OA/GIIw=;
        b=PcSxHQv8HMySz7XJ5ic0K/rVJkQgIl16uZL5wejPud9JnBQX745zdDkGVZxlGswyse
         Jcpi6l9OTKXiZeAPtcV5/4lzfY/5VSKt5pPspJN+KyzCAEKDo9IhSZmZTs7pd5MEe5tL
         sq1ngMM+D9Hz8+01JAj8KmJ17mbYg6UFG6XoScamxxJvLEVZvL+3SReZzB8WyHX8F9r2
         sSc64PfQ7uYrPFtFUEXEZsThcVDWyv0HgeNNPO3FCqPQbvKyQpnNyxZq6IcVQP9TSonH
         3IVyq2NjvMSHz/t7oIKykFMzmYbQAVtlgW19E6EXDr3HBdR2NurMNlw2ol+pbFuTmbU4
         8+CQ==
X-Gm-Message-State: AOJu0Yw6xJ8r/bpGT8K0AjWTgI5dx2lDvG5fpfYSgo9Adwlw/9627aim
	GFclWOg9FULwUU3gopRlngkR1JhY08atvTTYotKYVvlrDq7zsbm7CnvQm/9I8HIgCzW3mj96kqZ
	mmRlBIw==
X-Google-Smtp-Source: AGHT+IFJQfvZtwxe2m1fSsxo10JaYZ0gSHdCuiW1yqoqyfmrLz40r02GK6v0qQL7gJgdo9z1zOy59ab7gA4=
X-Received: from pfhx19.prod.google.com ([2002:a05:6a00:1893:b0:736:38af:afeb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3d12:b0:737:678d:fb66
 with SMTP id d2e1a72fcca58-7480b1f3b1amr5299278b3a.5.1749062193439; Wed, 04
 Jun 2025 11:36:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed,  4 Jun 2025 11:36:22 -0700
In-Reply-To: <20250604183623.283300-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250604183623.283300-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1266.g31b7d2e469-goog
Message-ID: <20250604183623.283300-6-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 5/6] x86: Cache availability of forced
 emulation during setup_idt()
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Cache whether or not forced emulation is availability during setup_idt()
so that tests can force emulation (or not) in contexts where taking an
exception of any kind will fail.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 lib/x86/desc.c   | 22 ++++++++++++++++++++++
 lib/x86/desc.h   | 14 +-------------
 x86/access.c     |  2 +-
 x86/emulator.c   | 11 +++++------
 x86/emulator64.c |  2 +-
 x86/la57.c       |  2 +-
 x86/lam.c        |  2 +-
 x86/msr.c        |  2 +-
 x86/pmu.c        |  2 +-
 9 files changed, 34 insertions(+), 25 deletions(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 5748f900..fca37b9a 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -298,6 +298,22 @@ static void *idt_handlers[32] = {
 	[21] = &cp_fault,
 };
 
+bool is_fep_available;
+
+static bool __is_fep_available(void)
+{
+	/*
+	 * Use the non-FEP ASM_TRY() as KVM will inject a #UD on the prefix
+	 * itself if forced emulation is not available.
+	 */
+	asm goto(ASM_TRY("%l[fep_unavailable]")
+		 KVM_FEP "nop\n\t"
+		 ::: "memory" : fep_unavailable);
+	return true;
+fep_unavailable:
+	return false;
+}
+
 void setup_idt(void)
 {
 	int i;
@@ -311,6 +327,12 @@ void setup_idt(void)
 	}
 
 	load_idt();
+
+	/*
+	 * Detect support for forced emulation *after* loading the IDT, as this
+	 * will #UD if FEP is unavailable.
+	 */
+	is_fep_available = __is_fep_available();
 }
 
 void load_idt(void)
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index a1e60e78..68f38f3d 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -164,19 +164,7 @@ typedef struct  __attribute__((packed)) {
 #define KVM_FEP "ud2; .byte 'k', 'v', 'm';"
 #define ASM_TRY_FEP(catch) __ASM_TRY(KVM_FEP, catch)
 
-static inline bool is_fep_available(void)
-{
-	/*
-	 * Use the non-FEP ASM_TRY() as KVM will inject a #UD on the prefix
-	 * itself if forced emulation is not available.
-	 */
-	asm goto(ASM_TRY("%l[fep_unavailable]")
-		 KVM_FEP "nop\n\t"
-		 ::: "memory" : fep_unavailable);
-	return true;
-fep_unavailable:
-	return false;
-}
+extern bool is_fep_available;
 
 typedef struct {
 	unsigned short offset0;
diff --git a/x86/access.c b/x86/access.c
index f90a72d6..d94910bf 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -1232,7 +1232,7 @@ void ac_test_run(int pt_levels, bool force_emulation)
 	ac_pt_env_t pt_env;
 	int i, tests, successes;
 
-	if (force_emulation && !is_fep_available()) {
+	if (force_emulation && !is_fep_available) {
 		report_skip("Forced emulation prefix (FEP) not available\n");
 		return;
 	}
diff --git a/x86/emulator.c b/x86/emulator.c
index f8bdc26b..4e1ba12a 100644
--- a/x86/emulator.c
+++ b/x86/emulator.c
@@ -728,7 +728,6 @@ static void handle_db(struct ex_regs *regs)
 static void test_mov_pop_ss_code_db(void)
 {
 	handler old_db_handler = handle_exception(DB_VECTOR, handle_db);
-	bool fep_available = is_fep_available();
 	/* On Intel, code #DBs are inhibited when MOV/POP SS blocking is active. */
 	int nr_expected = is_intel() ? 0 : 1;
 
@@ -761,7 +760,7 @@ static void test_mov_pop_ss_code_db(void)
 		      "mov %%ss, %0\n\t", "mov %0, %%ss\n\t")
 
 	MOV_SS_DB("no fep", "", "");
-	if (fep_available) {
+	if (is_fep_available) {
 		MOV_SS_DB("fep MOV-SS", KVM_FEP, "");
 		MOV_SS_DB("fep XOR", "", KVM_FEP);
 		MOV_SS_DB("fep MOV-SS/fep XOR", KVM_FEP, KVM_FEP);
@@ -774,7 +773,7 @@ static void test_mov_pop_ss_code_db(void)
 		      "push %%ss\n\t", "pop %%ss\n\t")
 
 	POP_SS_DB("no fep", "", "");
-	if (fep_available) {
+	if (is_fep_available) {
 		POP_SS_DB("fep POP-SS", KVM_FEP, "");
 		POP_SS_DB("fep XOR", "", KVM_FEP);
 		POP_SS_DB("fep POP-SS/fep XOR", KVM_FEP, KVM_FEP);
@@ -791,8 +790,8 @@ int main(void)
 	void *mem;
 	void *cross_mem;
 
-	if (!is_fep_available())
-		report_skip("Skipping tests the require forced emulation, "
+	if (!is_fep_available)
+		report_skip("Skipping tests that require forced emulation, "
 			    "use kvm.force_emulation_prefix=1 to enable");
 
 	setup_vm();
@@ -821,7 +820,7 @@ int main(void)
 	//test_lldt(mem);
 	test_ltr(mem);
 
-	if (is_fep_available()) {
+	if (is_fep_available) {
 		test_smsw_reg(mem);
 		test_nop(mem);
 		test_mov_dr(mem);
diff --git a/x86/emulator64.c b/x86/emulator64.c
index 5d1bb0f0..138903af 100644
--- a/x86/emulator64.c
+++ b/x86/emulator64.c
@@ -478,7 +478,7 @@ static void test_emulator_64(void *mem)
 	test_sreg(mem);
 	test_cmov(mem);
 
-	if (is_fep_available()) {
+	if (is_fep_available) {
 		test_mmx_movq_mf(mem);
 		test_movabs(mem);
 		test_user_load_dpl0_seg();
diff --git a/x86/la57.c b/x86/la57.c
index 41764110..d93e286c 100644
--- a/x86/la57.c
+++ b/x86/la57.c
@@ -313,7 +313,7 @@ static void test_canonical_checks(void)
 {
 	__test_canonical_checks(false);
 
-	if (is_fep_available())
+	if (is_fep_available)
 		__test_canonical_checks(true);
 	else
 		report_skip("Force emulation prefix not enabled");
diff --git a/x86/lam.c b/x86/lam.c
index a1c98949..8ad68178 100644
--- a/x86/lam.c
+++ b/x86/lam.c
@@ -184,7 +184,7 @@ static void __test_lam_sup(void *vaddr, void *vaddr_mmio)
 	test_ptr(vaddr_mmio, true);
 	test_invpcid(vaddr);
 	test_invlpg(vaddr, false);
-	if (is_fep_available())
+	if (is_fep_available)
 		test_invlpg(vaddr, true);
 }
 
diff --git a/x86/msr.c b/x86/msr.c
index e21ff0ac..f582a584 100644
--- a/x86/msr.c
+++ b/x86/msr.c
@@ -313,7 +313,7 @@ static void test_cmd_msrs(void)
 		test_wrmsr_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", L1D_FLUSH);
 	}
 
-	if (is_fep_available()) {
+	if (is_fep_available) {
 		for (i = 1; i < 64; i++)
 			test_wrmsr_fep_fault(MSR_IA32_FLUSH_CMD, "FLUSH_CMD", BIT_ULL(i));
 	}
diff --git a/x86/pmu.c b/x86/pmu.c
index 8cf26b12..b794b7d8 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -823,7 +823,7 @@ static void warm_up(void)
 
 static void check_counters(void)
 {
-	if (is_fep_available())
+	if (is_fep_available)
 		check_emulated_instr();
 
 	warm_up();
-- 
2.49.0.1266.g31b7d2e469-goog


