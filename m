Return-Path: <kvm+bounces-46214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90844AB4227
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:18:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9CEC61B610F0
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:18:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C84FD2BE114;
	Mon, 12 May 2025 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hSCxO/Sw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC2E2BDC2B
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073126; cv=none; b=lXbjUX1Qb+o59ty1D5lbZvQChP96I6CGAJMQPYqiLvntVVM+VclF4I7RX12VRP15A8k+SNwCuhW2aXBwi73VRt3vAxGhufjfS9lDckyMbOI5dXABE6FQU945L3cJsc8ka+TVLl2pYu+cdirAj0jqBVAXLmUyNUKQM5dOwKyJw6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073126; c=relaxed/simple;
	bh=EzRITekUV3GOdklMQfspnNaPhZSQ5YzzOUPxMNZS8xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uy+cZOadkOpDP/1nJq/7ntfkOb/3LHPuG2IxqZGDgN6QnW03+tmWXdRuyGaNX/EMdtVA93ukw0gil9Oj5MhCzFgmSPY6tzLNsO3J7AF4G9yGp0vysV8YH87l+ynVjwrmXtYlBVNRai2uqZkKpK7xjM1BrICqyPSriiBo+qjtBeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hSCxO/Sw; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-22e661313a3so42934385ad.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073124; x=1747677924; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hulB2UBYIXOqzJFKVn1ypmpXSnKnDaK1c4I5WrAN9H8=;
        b=hSCxO/SwQzpTAUVUuY/R0Ys8t0cXdETnTwA+az9Jqw2NwPwHiaxSDIO2DGMpOAiq/G
         yFqS3kEC1sL3pqIOpHExOvM7qLi2Qff44EofqmXjwUET+Bft87EQaNeDBNwcF7zt1lz9
         PPhnJC1bLrxBnRm+3zyaxDwBhJhQkG22t6Cp+b+ktDsGd55M6MPk/xLIqWCOfN+Jz3wO
         8uG5BCe78BDIcRMzdh8+mtbOJMm7amdLB+qDQI//zk7S3MfOT3KZYBBdZlpB1jbqh+fJ
         /jGROPFpMyTncoMjUIr6paT1BkRulqINGHyQhDUHq7sl7H3koMZ3mOtBlaYknmse8j+W
         9DyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073124; x=1747677924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hulB2UBYIXOqzJFKVn1ypmpXSnKnDaK1c4I5WrAN9H8=;
        b=JBaJC0yb4Wf6iDh+HRd87TVG4x+i/uloibUNePymZN9xnykJUy1ai3+U1S1veB88Ua
         yEqavDtEa3IN5sJTze/YGkDOF0TRKmsUHLh/5UZvCkqpJ9Q4i+WiwACOoGfjGlqr33sF
         AS0vuwdwBn7diqXHbi7KFJzVZk3xsMfeK63yWlnRYMjHdF/eCssVPvk4sely4ioh0BPi
         PAYN9SFOb66dqZAd4X20M2mOEJa+FgXORAetwC1z0Y4ijhBHmW7E4iEo7DCyb/227Sh2
         vh2dLrnR2FbJ3rcyudW8hv4wYwDSRFp4BpsHCstYF8e3fpbf5RHv+oFssaqrAIBiqwwp
         5kow==
X-Forwarded-Encrypted: i=1; AJvYcCUAnMjOCoPHvOPKI/dDb/w5P/qV+NLLQIQyfjfy3v9swSuFkG8Q33rm9Wpe3w+wixeUlaY=@vger.kernel.org
X-Gm-Message-State: AOJu0YypzLOuwG5LpUo3hQOMsmy9NeWKTclJkVT18rDBZsZGySTMAL0Z
	2CCalQLuXwA69uzbJ4HeMwxPJXoD8TkrAyHccqQpXPVQ3BxwlOWySHV4PBHm7nc=
X-Gm-Gg: ASbGncts1euIYeyg0qdav9X9Dbp5v0mLjnSfP0Asr2BOCa3DAlufZuVcTrPfGjXmWaF
	43V64Q5QCPr+cDFrPk88YrbgSY8DyPaZdVsZn4WyX98O3z3kFKWGF8QQipcZuNt2HvXCL/Z65bK
	fcgojNRZKELxejoJHNCIbRWYSjz7Iy7h92SegW3ukgi6aKpc9fmpz28gjCwDrQ7BfhPUhF0l9CV
	Dli0swMoweD+FPJEkZ142hS5H0ROkfa7BfsSstdd/offjA5T8g8eIzkdVqTLn3D9kEUV9lgO/9C
	I2UHdRdAAQGsnDsV7DtbzJsqfPrBFpiA9YtVLT6FtWXk1ipPPh0=
X-Google-Smtp-Source: AGHT+IGwq1tKRijfOMpNf6jcDnCb5CsbqOkXM1HmtY5XbufEcxIBy7HmQc4p5cmL1ZbzIfEVQPoTSg==
X-Received: by 2002:a17:903:3ba3:b0:220:ca08:8986 with SMTP id d9443c01a7336-22fc8b3e338mr213945315ad.22.1747073123534;
        Mon, 12 May 2025 11:05:23 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:23 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 13/48] target/arm/helper: use vaddr instead of target_ulong for exception_pc_alignment
Date: Mon, 12 May 2025 11:04:27 -0700
Message-ID: <20250512180502.2395029-14-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.h            | 2 +-
 target/arm/tcg/tlb_helper.c    | 2 +-
 target/arm/tcg/translate-a64.c | 2 +-
 target/arm/tcg/translate.c     | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/arm/helper.h b/target/arm/helper.h
index 09075058391..95b9211c6f4 100644
--- a/target/arm/helper.h
+++ b/target/arm/helper.h
@@ -49,7 +49,7 @@ DEF_HELPER_3(exception_with_syndrome, noreturn, env, i32, i32)
 DEF_HELPER_4(exception_with_syndrome_el, noreturn, env, i32, i32, i32)
 DEF_HELPER_2(exception_bkpt_insn, noreturn, env, i32)
 DEF_HELPER_2(exception_swstep, noreturn, env, i32)
-DEF_HELPER_2(exception_pc_alignment, noreturn, env, tl)
+DEF_HELPER_2(exception_pc_alignment, noreturn, env, vaddr)
 DEF_HELPER_1(setend, void, env)
 DEF_HELPER_2(wfi, void, env, i32)
 DEF_HELPER_1(wfe, void, env)
diff --git a/target/arm/tcg/tlb_helper.c b/target/arm/tcg/tlb_helper.c
index 5ea4d6590f2..d9e6c827d43 100644
--- a/target/arm/tcg/tlb_helper.c
+++ b/target/arm/tcg/tlb_helper.c
@@ -276,7 +276,7 @@ void arm_cpu_do_unaligned_access(CPUState *cs, vaddr vaddr,
     arm_deliver_fault(cpu, vaddr, access_type, mmu_idx, &fi);
 }
 
-void helper_exception_pc_alignment(CPUARMState *env, target_ulong pc)
+void helper_exception_pc_alignment(CPUARMState *env, vaddr pc)
 {
     ARMMMUFaultInfo fi = { .type = ARMFault_Alignment };
     int target_el = exception_target_el(env);
diff --git a/target/arm/tcg/translate-a64.c b/target/arm/tcg/translate-a64.c
index 52cf47e775f..ac80f572a2d 100644
--- a/target/arm/tcg/translate-a64.c
+++ b/target/arm/tcg/translate-a64.c
@@ -10242,7 +10242,7 @@ static void aarch64_tr_translate_insn(DisasContextBase *dcbase, CPUState *cpu)
          * start of the TB.
          */
         assert(s->base.num_insns == 1);
-        gen_helper_exception_pc_alignment(tcg_env, tcg_constant_tl(pc));
+        gen_helper_exception_pc_alignment(tcg_env, tcg_constant_vaddr(pc));
         s->base.is_jmp = DISAS_NORETURN;
         s->base.pc_next = QEMU_ALIGN_UP(pc, 4);
         return;
diff --git a/target/arm/tcg/translate.c b/target/arm/tcg/translate.c
index e773ab72685..9962f43b1d0 100644
--- a/target/arm/tcg/translate.c
+++ b/target/arm/tcg/translate.c
@@ -7791,7 +7791,7 @@ static void arm_tr_translate_insn(DisasContextBase *dcbase, CPUState *cpu)
          * be possible after an indirect branch, at the start of the TB.
          */
         assert(dc->base.num_insns == 1);
-        gen_helper_exception_pc_alignment(tcg_env, tcg_constant_tl(pc));
+        gen_helper_exception_pc_alignment(tcg_env, tcg_constant_vaddr(pc));
         dc->base.is_jmp = DISAS_NORETURN;
         dc->base.pc_next = QEMU_ALIGN_UP(pc, 4);
         return;
-- 
2.47.2


