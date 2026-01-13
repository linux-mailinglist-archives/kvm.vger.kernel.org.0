Return-Path: <kvm+bounces-67890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E1552D16069
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 01:34:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B5835300969D
	for <lists+kvm@lfdr.de>; Tue, 13 Jan 2026 00:33:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644932727E2;
	Tue, 13 Jan 2026 00:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FoJBdyeB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F1C2459FD
	for <kvm@vger.kernel.org>; Tue, 13 Jan 2026 00:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768264337; cv=none; b=mzPjxf7wrCbk/G1BUVAIY2KJg5/gdKVNEMR4014ujl3spGajL2Q0YfBLRxG6LeecJIYeiXgwxGBI+Ezan6JXCOVc0YABnZPrdwa0XLn+TKbv81H/GgrtfAOgEfOlutAX1TvODJoTsaU52GSMuFmjmAms+dN3qoTgONKwjDMryHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768264337; c=relaxed/simple;
	bh=z1s3+qYAF9k6h+El08KteY8WIjxrSqY+KS00uYyL/QA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=PoRnLzpywl1KsPYONgdipAmh5rhMnOZC6ji+sIBQUgerAyWZgmYOA/Bdmf280uRWH20Bqho6iJVxtLFgqUkf6LVyBcFNNkNZmJNPQ1brmiTyS9rWW6Ztqj15ii16R9c32jwKxUqwveGvHMdBx5L8s6kFU4Ad70ONlJ4dgtb3UUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FoJBdyeB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--chengkev.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34c66cb671fso6784894a91.3
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 16:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768264335; x=1768869135; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jTfNXhj1aHDlK0haRxyeosTMqB3bdwUb40X0uNUok6s=;
        b=FoJBdyeBgaHb7JS5RofaOB5y+2w5/n2zyoYEWDtEaA3vR72MDpa3p6ymQyzmq/I/6c
         db9WamrrvGswhzVkCP9xLQ6sm33choGh3u/HYB4tK+RrxeTvN3INvHlKW32HaYN9zV8V
         wUYgrjPFCow/rlzekCM2S8bkTR4nDc2gWdG3gQMrh9oLQk8Zzjef5mxmy73X4jqbO6Yb
         HmkP+Q98OKlPk1VIA6AdvQ8L3PosRxD9sdTRsKogpM0g5dAIGPSPAAKIiMracHuLgoh4
         oojZbPOnuuzKsgvgVXeh3/UmVR+pWK2D84XxyJWvxbFTAW5fxn5QBZXec2kBieRWVspG
         kmbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768264335; x=1768869135;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jTfNXhj1aHDlK0haRxyeosTMqB3bdwUb40X0uNUok6s=;
        b=RJBMZNZ9p5aywByuLJS36oMsSwlle6Pq7H4tqf4C0MO+b3A4OQ+vSvf5AETharREm8
         65uywkr6AvDXW1WDPOPpOlepStPXXvTUZapBV1fQjaoW8fgEzuDcn8LznKfTMjiV8IXq
         GyVM6nAzn5BqHeomC+jsPFR3SKjpNxmla4Z/RplX2TdDB3wmSEZOWyQbkE1NEdyw/B8H
         U7inAKE3uVcMvZllTFmwyiIU+D5jc0itG/Vu1B0Z3TZQs82nKl6ra246pzbiOjzGcF90
         M0E5SwQrvFuXZXxZxVZ8wbiwe8jB/ilzoSTjFLsKk5NBXwZ3TDveaB6Np+U8axnLz81y
         RaMw==
X-Gm-Message-State: AOJu0YwZahQF9BgtF4P51cNuvuw6zWMWIQh+xvDi6ohanb6oG7xVcIV4
	6ZpOMW0dLOqKNnCb2gLQAPIrHC2nHdiGJmLLmCGoHivLIEBfuALBw54S2UAlV2WO3k09UkI0ODl
	3/ynls32dzxhNh5qqWOrDKg2juUUzU4fN/CtioDpW5GgRM5ljptzukhg0wpS0GdYDeGE3xom+Cl
	GVw2fovJxh7puJEDGB1cfLCTmMNiTGqwkcUBX64Xi37Eg=
X-Google-Smtp-Source: AGHT+IENrO0snw229s1lX+yVpvUdZZ4APnOiLZPjkXDLB2Xnav09BX6SahZblTq1xBTmD58E2FYW8ZzSKEhNCA==
X-Received: from pjqc7.prod.google.com ([2002:a17:90a:a607:b0:33b:b0fe:e54d])
 (user=chengkev job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4d0d:b0:341:88c9:ca62 with SMTP id 98e67ed59e1d1-34f68c287bemr16123788a91.31.1768264334910;
 Mon, 12 Jan 2026 16:32:14 -0800 (PST)
Date: Tue, 13 Jan 2026 00:31:52 +0000
In-Reply-To: <20260113003153.3344500-1-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003153.3344500-1-chengkev@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260113003153.3344500-11-chengkev@google.com>
Subject: [kvm-unit-tests PATCH V2 10/10] x86/svm: Add test for #UD when EFER.SVME=0
From: Kevin Cheng <chengkev@google.com>
To: kvm@vger.kernel.org
Cc: yosryahmed@google.com, andrew.jones@linux.dev, thuth@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="UTF-8"

When EFER.SVME is set to 0 VMRUN, VMSAVE, VMLOAD, CLGI, VMMCALL, and
INVLPGA generate a #UD. STGI generates a #UD if SVME is not enabled and
neither SVM Lock nor the device exclusion vector (DEV) are supported.

Add a test to verify that disabling EFER.SVME
makes the listed instructions generate a #UD when executed.

Signed-off-by: Kevin Cheng <chengkev@google.com>
---
 x86/svm_tests.c   | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 x86/unittests.cfg | 10 ++++++++-
 2 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 5d27286129337..4c72443702578 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -2804,6 +2804,60 @@ static void svm_insn_intercept_test(void)
 	}
 }
 
+asm (
+	"insn_invlpga: xor %rax, %rax; xor %ecx, %ecx; invlpga %rax, %ecx;ret\n\t"
+	"insn_vmrun: xor %rax, %rax; vmrun %rax;ret\n\t"
+	"insn_vmsave: xor %rax, %rax; vmsave %rax;ret\n\t"
+	"insn_vmload: xor %rax, %rax; vmload %rax;ret\n\t"
+);
+
+extern void insn_invlpga(void);
+extern void insn_vmrun(void);
+extern void insn_vmsave(void);
+extern void insn_vmload(void);
+
+static volatile bool ud_fired;
+
+static void svm_ud_test_handler(struct ex_regs *regs)
+{
+	ud_fired = true;
+	regs->rip += 3;
+}
+
+static void svm_ud_test(void)
+{
+	u64 efer = rdmsr(MSR_EFER);
+
+	handle_exception(UD_VECTOR, svm_ud_test_handler);
+	wrmsr(MSR_EFER, efer & ~EFER_SVME);
+
+	insn_invlpga();
+	report(ud_fired, "Instruction INVLPGA generated #UD when EFER.SVME=0");
+	ud_fired = false;
+
+	clgi();
+	report(ud_fired, "Instruction CLGI generated #UD when EFER.SVME=0");
+	ud_fired = false;
+
+	stgi();
+	report(ud_fired, "Instruction STGI generated #UD when EFER.SVME=0");
+	ud_fired = false;
+
+	insn_vmrun();
+	report(ud_fired, "Instruction VMRUN generated #UD when EFER.SVME=0");
+	ud_fired = false;
+
+	insn_vmsave();
+	report(ud_fired, "Instruction VMSAVE generated #UD when EFER.SVME=0");
+	ud_fired = false;
+
+	insn_vmload();
+	report(ud_fired, "Instruction VMLOAD generated #UD when EFER.SVME=0");
+	ud_fired = false;
+
+	wrmsr(MSR_EFER, efer);
+}
+
 /* TODO: verify if high 32-bits are sign- or zero-extended on bare metal */
 #define	TEST_BITMAP_ADDR(save_intercept, type, addr, exit_code,		\
 			 msg) {						\
@@ -4217,6 +4271,7 @@ struct svm_test svm_tests[] = {
 	TEST(svm_shutdown_intercept_test),
 	TEST(svm_insn_intercept_test),
 	TEST(svm_event_injection),
+	TEST(svm_ud_test),
 	{ NULL, NULL, NULL, NULL, NULL, NULL, NULL }
 };
 
diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 118e7cdd0286d..ad447e5f82f9f 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -253,11 +253,19 @@ arch = x86_64
 [svm]
 file = svm.flat
 smp = 2
-test_args = "-pause_filter_test -svm_intr_intercept_mix_smi -svm_insn_intercept_test -svm_pf_exception_test -svm_pf_exception_forced_emulation_test -svm_pf_inv_asid_test -svm_pf_inv_tlb_ctl_test -svm_event_injection"
+test_args = "-pause_filter_test -svm_intr_intercept_mix_smi -svm_insn_intercept_test -svm_pf_exception_test -svm_pf_exception_forced_emulation_test -svm_pf_inv_asid_test -svm_pf_inv_tlb_ctl_test -svm_event_injection -svm_ud_test"
 qemu_params = -cpu max,+svm -m 4g
 arch = x86_64
 groups = svm
 
+# Disable SKINIT and SVML to test STGI #UD when EFER.SVME=0
+[svm_ud_test]
+file = svm.flat
+test_args = svm_ud_test
+qemu_params = -cpu max,-skinit,-svm-lock,+svm -m 4g
+arch = x86_64
+groups = svm
+
 [svm_event_injection]
 file = svm.flat
 test_args = svm_event_injection
-- 
2.52.0.457.g6b5491de43-goog


