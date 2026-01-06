Return-Path: <kvm+bounces-67084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D786CF60D5
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 01:02:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id EFF6F300A98E
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 00:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F2A27DA66;
	Tue,  6 Jan 2026 00:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Rfb8dlqw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275EB256D
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 00:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767657734; cv=none; b=YJOu2R1lszLYY4sbjSzD9scWcFdW+eLoMEk8QElafew60STNnjjMjEsy3sb44+9IvB/pDOo3/RiQ0061iYj1RdU7S+eORGZZ6zKqIeH+0a5tocPBzgmcTjnuFAfVByJcrYU6XCMmOm/G3Zewee+YBdJncL2HxGLVtN2TFqd6Suo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767657734; c=relaxed/simple;
	bh=rroKNlVbZCy7ELszwC9b9j/yeamYk+rHS6PmAGGv8BE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qRYKr3yNjDTnnw5iZbCWAt+z2ezzlO0gUl/aX2Em5PTT2iX2wyswo5PBXlP/tN8OxiVll4BivohiOQnEgJYrO3NFWeDNLvFegT2Ync1oXuaLg49cWuEEfcnbOg2fQviH2U6/orbiAvfw4JfzRWY9BH8nxWKtFWcSrFQSqSzFuEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Rfb8dlqw; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c38781efcso856819a91.2
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 16:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767657732; x=1768262532; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vGRWL2JiL9rij9W12TBCl4/Iu/deWdZO6/owu4HUTBY=;
        b=Rfb8dlqwxuGA5RYfLr1i9KzHzPVMpAkb9EMBlXdRhz5Z5LCZbfkzw9Cyv3cAik1/n1
         VDDYqM/v4LIQ6bXR5FuozMDKFsIh+2/70tvFV1nFjUSUGTEBYlruE48rQDGAO8CdV6tm
         sDJd60VKAlAfSmYKy3fv9HgkZ8xdBl/9Bt5Qc2DsjyeLuqz7pNrfcLjm8q6v4u8s7qOT
         zg5CqIZqGb/tlKZRy8SW9CQAQ9WZY1T26ETHIcnVzaXngv74D5gq7qEoAD/02FK+ABuA
         0KSwMXJxopSuiXbffh17SsK6m2zN2v1DEKGTkTnBqcAmvDXjrsfrf5CPuFv3hTPNg0YZ
         ObAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767657732; x=1768262532;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vGRWL2JiL9rij9W12TBCl4/Iu/deWdZO6/owu4HUTBY=;
        b=FuyQm7EJBPg807MT9H3egSgiGYnJCIX150mebGTBxGoBpgmsFvAQTX+MiZxgGiUHSs
         MwOPDTd/pPHcKhT3LysFd64uu50xxkSCXUPePRXu01tAIsJKlZ+E4cCy7TLOGHqzgNf6
         qL2C8KxNGAU4nw0g3mGZKyaYHyARMfC3STv8CfdtJXj7qR9lyq2gdGyCD4w3m6/WpUNA
         NCy8KB5xhFI7RWlEOO9laOWZKZKRsZc361b0HDIv//3hnDPuwm1JypLHTwbYgzvSC1Lf
         e9/8URyXlUAygMErq5WMbqUhCnG2IZ8sGMohSedRyWwbC4L8HKfzWJYnWnPHFoimFyMF
         Ddiw==
X-Forwarded-Encrypted: i=1; AJvYcCVHptcp3EGkfwzJhPzEolT7Wq1SxGkTU1rUffNa8hujbUOlXC37gRPw/39vcLMkoy7svaA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8rekxowK1krT/chpLgUmttvXLFLbPqe/yItfXlgAoZBYALd7D
	uXa3On9kSWsHt/f2678uRGkxYhZPGNEP8Yr1Pnl0mauKY40IbaP3BKbuZJNzxIWYmKbQ9xyHLV3
	6utDpmw==
X-Google-Smtp-Source: AGHT+IEXmYTixm9R/utCr6gAiHjqsYw478azZr867duSrNV/vHlG45jG6yVt0zjtI4tUhhNJAOwAeNNTZ5s=
X-Received: from pjxx11.prod.google.com ([2002:a17:90b:58cb:b0:349:a1a3:75fb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35c1:b0:33b:dec9:d9aa
 with SMTP id 98e67ed59e1d1-34f5f3362f4mr711865a91.25.1767657732300; Mon, 05
 Jan 2026 16:02:12 -0800 (PST)
Date: Mon, 5 Jan 2026 16:02:10 -0800
In-Reply-To: <20260101090516.316883-3-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260101090516.316883-1-pbonzini@redhat.com> <20260101090516.316883-3-pbonzini@redhat.com>
Message-ID: <aVxRAv888jsmQJ8-@google.com>
Subject: Re: [PATCH 2/4] selftests: kvm: replace numbered sync points with actions
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Jan 01, 2026, Paolo Bonzini wrote:
> Rework the guest=>host syncs in the AMX test to use named actions instead
> of arbitrary, incrementing numbers.  The "stage" of the test has no real
> meaning, what matters is what action the test wants the host to perform.
> The incrementing numbers are somewhat helpful for triaging failures, but
> fully debugging failures almost always requires a much deeper dive into
> the test (and KVM).
> 
> Using named actions not only makes it easier to extend the test without
> having to shift all sync point numbers, it makes the code easier to read.
> 
> [Commit message by Sean Christopherson]
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
> 	I wrote this before seeing your patch... It's obviously
> 	similar but different enough that I kept my version. :)

Heh, no worries.

> @@ -244,6 +254,7 @@ int main(int argc, char *argv[])
>  	memset(addr_gva2hva(vm, xstate), 0, PAGE_SIZE * DIV_ROUND_UP(XSAVE_SIZE, PAGE_SIZE));
>  	vcpu_args_set(vcpu, 3, amx_cfg, tiledata, xstate);
>  
> +	int iter = 0;

If we want to retain "tracing" of guest syncs, I vote to provide the information
from the guest, otherwise I'll end up counting GUEST_SYNC() calls on my fingers
(and run out of fingers) :-D.

E.g. if we wrap all GUEST_SYNC() calls in a macro, we can print the line number
without having to hardcode sync point numbers.

# ./x86/amx_test 
Random seed: 0x6b8b4567
GUEST_SYNC line 164, save/restore VM state
GUEST_SYNC line 168, save/restore VM state
GUEST_SYNC line 172, save/restore VM state
GUEST_SYNC line 175, save tiledata
GUEST_SYNC line 175, check TMM0 contents
GUEST_SYNC line 175, save/restore VM state
GUEST_SYNC line 181, before KVM_SET_XSAVE
GUEST_SYNC line 181, after KVM_SET_XSAVE
GUEST_SYNC line 182, save/restore VM state
GUEST_SYNC line 186, save/restore VM state
GUEST_SYNC line 210, save/restore VM state
GUEST_SYNC line 224, save/restore VM state
GUEST_SYNC line 231, save/restore VM state
GUEST_SYNC line 234, check TMM0 contents
GUEST_SYNC line 234, save/restore VM state
UCALL_DONE

---
 tools/testing/selftests/kvm/x86/amx_test.c | 55 +++++++++++++---------
 1 file changed, 33 insertions(+), 22 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86/amx_test.c b/tools/testing/selftests/kvm/x86/amx_test.c
index 37b166260ee3..9593ecd47d28 100644
--- a/tools/testing/selftests/kvm/x86/amx_test.c
+++ b/tools/testing/selftests/kvm/x86/amx_test.c
@@ -131,19 +131,27 @@ static void set_tilecfg(struct tile_config *cfg)
 }
 
 enum {
+	TEST_SYNC_LINE_NUMBER_MASK = GENMASK(15, 0),
+
 	/* Retrieve TMM0 from guest, stash it for TEST_RESTORE_TILEDATA */
-	TEST_SAVE_TILEDATA = 1,
+	TEST_SAVE_TILEDATA = BIT(16),
 
 	/* Check TMM0 against tiledata */
-	TEST_COMPARE_TILEDATA = 2,
+	TEST_COMPARE_TILEDATA = BIT(17),
 
 	/* Restore TMM0 from earlier save */
-	TEST_RESTORE_TILEDATA = 4,
+	TEST_RESTORE_TILEDATA = BIT(18),
 
 	/* Full VM save/restore */
-	TEST_SAVE_RESTORE = 8,
+	TEST_SAVE_RESTORE = BIT(19),
 };
 
+#define AMX_GUEST_SYNC(action)						\
+do {									\
+	kvm_static_assert(!((action) & TEST_SYNC_LINE_NUMBER_MASK));	\
+	GUEST_SYNC((action) | __LINE__);				\
+} while (0)
+
 static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 						    struct tile_data *tiledata,
 						    struct xstate *xstate)
@@ -153,29 +161,29 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	GUEST_ASSERT(this_cpu_has(X86_FEATURE_XSAVE) &&
 		     this_cpu_has(X86_FEATURE_OSXSAVE));
 	check_xtile_info();
-	GUEST_SYNC(TEST_SAVE_RESTORE);
+	AMX_GUEST_SYNC(TEST_SAVE_RESTORE);
 
 	/* xfd=0, enable amx */
 	wrmsr(MSR_IA32_XFD, 0);
-	GUEST_SYNC(TEST_SAVE_RESTORE);
+	AMX_GUEST_SYNC(TEST_SAVE_RESTORE);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == 0);
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
-	GUEST_SYNC(TEST_SAVE_RESTORE);
+	AMX_GUEST_SYNC(TEST_SAVE_RESTORE);
 	/* Check save/restore when trap to userspace */
 	__tileloadd(tiledata);
-	GUEST_SYNC(TEST_SAVE_TILEDATA | TEST_COMPARE_TILEDATA | TEST_SAVE_RESTORE);
+	AMX_GUEST_SYNC(TEST_SAVE_TILEDATA | TEST_COMPARE_TILEDATA | TEST_SAVE_RESTORE);
 
 	/* xfd=0x40000, disable amx tiledata */
 	wrmsr(MSR_IA32_XFD, XFEATURE_MASK_XTILE_DATA);
 
 	/* host tries setting tiledata while guest XFD is set */
-	GUEST_SYNC(TEST_RESTORE_TILEDATA);
-	GUEST_SYNC(TEST_SAVE_RESTORE);
+	AMX_GUEST_SYNC(TEST_RESTORE_TILEDATA);
+	AMX_GUEST_SYNC(TEST_SAVE_RESTORE);
 
 	wrmsr(MSR_IA32_XFD, 0);
 	__tilerelease();
-	GUEST_SYNC(TEST_SAVE_RESTORE);
+	AMX_GUEST_SYNC(TEST_SAVE_RESTORE);
 	/*
 	 * After XSAVEC, XTILEDATA is cleared in the xstate_bv but is set in
 	 * the xcomp_bv.
@@ -199,7 +207,7 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	GUEST_ASSERT(!(xstate->header.xstate_bv & XFEATURE_MASK_XTILE_DATA));
 	GUEST_ASSERT((xstate->header.xcomp_bv & XFEATURE_MASK_XTILE_DATA));
 
-	GUEST_SYNC(TEST_SAVE_RESTORE);
+	AMX_GUEST_SYNC(TEST_SAVE_RESTORE);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	set_tilecfg(amx_cfg);
 	__ldtilecfg(amx_cfg);
@@ -213,17 +221,17 @@ static void __attribute__((__flatten__)) guest_code(struct tile_config *amx_cfg,
 	GUEST_ASSERT(!(get_cr0() & X86_CR0_TS));
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
-	GUEST_SYNC(TEST_SAVE_RESTORE);
+	AMX_GUEST_SYNC(TEST_SAVE_RESTORE);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD_ERR) == XFEATURE_MASK_XTILE_DATA);
 	GUEST_ASSERT(rdmsr(MSR_IA32_XFD) == XFEATURE_MASK_XTILE_DATA);
 	/* Clear xfd_err */
 	wrmsr(MSR_IA32_XFD_ERR, 0);
 	/* xfd=0, enable amx */
 	wrmsr(MSR_IA32_XFD, 0);
-	GUEST_SYNC(TEST_SAVE_RESTORE);
+	AMX_GUEST_SYNC(TEST_SAVE_RESTORE);
 
 	__tileloadd(tiledata);
-	GUEST_SYNC(TEST_COMPARE_TILEDATA | TEST_SAVE_RESTORE);
+	AMX_GUEST_SYNC(TEST_COMPARE_TILEDATA | TEST_SAVE_RESTORE);
 
 	GUEST_DONE();
 }
@@ -275,7 +283,6 @@ int main(int argc, char *argv[])
 	memset(addr_gva2hva(vm, xstate), 0, PAGE_SIZE * DIV_ROUND_UP(XSAVE_SIZE, PAGE_SIZE));
 	vcpu_args_set(vcpu, 3, amx_cfg, tiledata, xstate);
 
-	int iter = 0;
 	for (;;) {
 		vcpu_run(vcpu);
 		TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
@@ -285,13 +292,14 @@ int main(int argc, char *argv[])
 			REPORT_GUEST_ASSERT(uc);
 			/* NOT REACHED */
 		case UCALL_SYNC:
-			++iter;
 			if (uc.args[1] & TEST_SAVE_TILEDATA) {
-				fprintf(stderr, "GUEST_SYNC #%d, save tiledata\n", iter);
+				fprintf(stderr, "GUEST_SYNC line %d, save tiledata\n",
+					(u16)(uc.args[1] & TEST_SYNC_LINE_NUMBER_MASK));
 				tile_state = vcpu_save_state(vcpu);
 			}
 			if (uc.args[1] & TEST_COMPARE_TILEDATA) {
-				fprintf(stderr, "GUEST_SYNC #%d, check TMM0 contents\n", iter);
+				fprintf(stderr, "GUEST_SYNC line %d, check TMM0 contents\n",
+					(u16)(uc.args[1] & TEST_SYNC_LINE_NUMBER_MASK));
 
 				/* Compacted mode, get amx offset by xsave area
 				 * size subtract 8K amx size.
@@ -304,12 +312,15 @@ int main(int argc, char *argv[])
 				TEST_ASSERT(ret == 0, "memcmp failed, ret=%d", ret);
 			}
 			if (uc.args[1] & TEST_RESTORE_TILEDATA) {
-				fprintf(stderr, "GUEST_SYNC #%d, before KVM_SET_XSAVE\n", iter);
+				fprintf(stderr, "GUEST_SYNC line %d, before KVM_SET_XSAVE\n",
+					(u16)(uc.args[1] & TEST_SYNC_LINE_NUMBER_MASK));
 				vcpu_xsave_set(vcpu, tile_state->xsave);
-				fprintf(stderr, "GUEST_SYNC #%d, after KVM_SET_XSAVE\n", iter);
+				fprintf(stderr, "GUEST_SYNC line %d, after KVM_SET_XSAVE\n",
+					(u16)(uc.args[1] & TEST_SYNC_LINE_NUMBER_MASK));
 			}
 			if (uc.args[1] & TEST_SAVE_RESTORE) {
-				fprintf(stderr, "GUEST_SYNC #%d, save/restore VM state\n", iter);
+				fprintf(stderr, "GUEST_SYNC line %d, save/restore VM state\n",
+					(u16)(uc.args[1] & TEST_SYNC_LINE_NUMBER_MASK));
 				state = vcpu_save_state(vcpu);
 				memset(&regs1, 0, sizeof(regs1));
 				vcpu_regs_get(vcpu, &regs1);

base-commit: bc6eb58bab2fda28ef473ff06f4229c814c29380
--

