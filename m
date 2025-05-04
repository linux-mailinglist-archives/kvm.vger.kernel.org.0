Return-Path: <kvm+bounces-45308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 12533AA83FD
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 07:30:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE285189A90F
	for <lists+kvm@lfdr.de>; Sun,  4 May 2025 05:31:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D02119AD8C;
	Sun,  4 May 2025 05:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Bs6Fd9NH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0BB16D9C2
	for <kvm@vger.kernel.org>; Sun,  4 May 2025 05:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746336575; cv=none; b=jgQIrSHDOt/zw5IuAS+j3xyX8fnn2iYGoAcsypMQr+fOlJGCxsH8O+QU6ObZ51qrP0DnHAyHzCEZ1HxbuxCN1tRrtRf8XXDe3VV+53WkxFVT+QWLdVu3VcVzASCmwdPGUFUhfIIZCFrXxhobSdq1hExhwdds5szs4n+1aA28hvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746336575; c=relaxed/simple;
	bh=ucVayIA+hGkub8c+axbrMCI6i+Dz2B2mE03U0WQ40KY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tkx/92afHCntHKM3hmCT1F+KvhfSWHp7HKhhkqoFxNF4wONXfimTbAu0xWF+dQ2XN+pUYuAm2XnRZB+xifFLsOY18BS61DVBsZV8Bio+7auQybjNv5C8/dpSpeherjerSHn9oPUcERekF/pXCwPD3ZZbrE1Juv6hF5X8tveMS34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Bs6Fd9NH; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7394945d37eso2841216b3a.3
        for <kvm@vger.kernel.org>; Sat, 03 May 2025 22:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746336573; x=1746941373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WzMy66shbPXXlyjnEns4rH7PvNwF6buM8qH1Xg0FZ+4=;
        b=Bs6Fd9NHVmBFKD0TBChnywSkq/r5ckca7kj8Vs6qi9rtTGdN+hm3A3KqgmlW3vI5Ya
         QqxvRzRVcI8PoXMIMVoyG6dlI3vVy7Kn56Us6gISJ/+1zkmKyY3u0P90DPOXgmbJIi3n
         vW9Yf/G7jL+R3/vGjaPWwabLaGjCkQnqCOp75ZAnH76UUJA6u5BJnngqqqKp94I2C5Em
         oSOhCFNsK0FDEzb1ttXI+LGDIGyqWOY0m/mo7wwvTGqfMk5IxoarS2SncJ+diZjdPkcY
         rVSl7T09zt9vMAwxZjavRD49SzJeUGW9wf6wNXTjS9gMjAj6PDgMLNrR9shd9wWNPr7v
         /MLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746336573; x=1746941373;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WzMy66shbPXXlyjnEns4rH7PvNwF6buM8qH1Xg0FZ+4=;
        b=AmOdPvpsEnLFAZmvXl2ojGCX6Pg9qYgpQ0FqvkQaNQwEJCt0vOlsd7pUKyZAmmyGVZ
         S9fldtkMejIhZyKU/FVbXEPYF2z4XbF2XG46woAZT/iL4UzAmpP5etUwGYyRHTT5PVI+
         ZqMRi9HQ2H3NcQY1/xeqtTBNdHPerUa4hyeNXkSP9q5JRq6yenLGhOkchXj62hwFVHda
         ThXoEJwhmNXz2GK16fusjbxPWU485Uy6FkJtt1wYGJGrVLBn5k8t79AxVa5wMWDmI9FY
         XmKd618FHCoufo62d93j0EgDrWdtCJTzpFTMxQMqGnNMC31U18C8onbLpV9vcliK6Vl3
         d7Lw==
X-Forwarded-Encrypted: i=1; AJvYcCWJ/d1wOxnPIb67mXzafNhO/xt02B9/9/bAKUFESGMV4Gox+aBuMtwb/iHToIBOEDQpveY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxidxD5yej7cMFZdx1SPBeAvEDDh6zVdteG1weRrTwoyr4PMBVf
	z7yqDFXvHbQaF/QcbZFRURhpcqIlNeS4mx777TVo6COQrqKx1teEj5of9fPk+xI=
X-Gm-Gg: ASbGncshTqlOpFWCvx+Qmd8G9gnIVZU66qPzKO9DxyakRjSAw/IyAEoO7MilZq6Yw3f
	pA3MlIwvImmANWLfUd6CjcFEgzA/XAGGwMmxAPb/cL/48GglNSFfuTtLF07mDn851N8LX4SoyT4
	GUdBTh5cGo2ClGWBKtx+P3OnHsZRshlmbm617YyRzCxZJf0IDaeV8/ZFiY3ye64qIZpXw6lO52P
	PBxc0mzAYeejXOYJY5bskSOmVaXD6jo95dpeL5lzheZ/sgLMPoRAfrV6qyTITiFEG9Szdn/U2Lb
	/2tSIwyIRU0/Ghobb/hEfXpt9zSZ+PxpxQrSFkOj
X-Google-Smtp-Source: AGHT+IF3MsqDxnvukykvE/6O00kSUuX24CTMca9uQ13CHCSwtTjTadd/FH15AOifa1kLNKXwqjQ+ZQ==
X-Received: by 2002:aa7:9314:0:b0:73e:30dd:d14b with SMTP id d2e1a72fcca58-7406f1769e2mr4015705b3a.15.1746336573425;
        Sat, 03 May 2025 22:29:33 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-740590207e3sm4400511b3a.94.2025.05.03.22.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 May 2025 22:29:33 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	anjo@rev.ng,
	kvm@vger.kernel.org,
	richard.henderson@linaro.org,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	alex.bennee@linaro.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 15/40] target/arm/helper: use vaddr instead of target_ulong for exception_pc_alignment
Date: Sat,  3 May 2025 22:28:49 -0700
Message-ID: <20250504052914.3525365-16-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
References: <20250504052914.3525365-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 8841f039bc6..4e3e96a2af0 100644
--- a/target/arm/tcg/tlb_helper.c
+++ b/target/arm/tcg/tlb_helper.c
@@ -277,7 +277,7 @@ void arm_cpu_do_unaligned_access(CPUState *cs, vaddr vaddr,
     arm_deliver_fault(cpu, vaddr, access_type, mmu_idx, &fi);
 }
 
-void helper_exception_pc_alignment(CPUARMState *env, target_ulong pc)
+void helper_exception_pc_alignment(CPUARMState *env, vaddr pc)
 {
     ARMMMUFaultInfo fi = { .type = ARMFault_Alignment };
     int target_el = exception_target_el(env);
diff --git a/target/arm/tcg/translate-a64.c b/target/arm/tcg/translate-a64.c
index d9305f9d269..4f94fe179b0 100644
--- a/target/arm/tcg/translate-a64.c
+++ b/target/arm/tcg/translate-a64.c
@@ -10243,7 +10243,7 @@ static void aarch64_tr_translate_insn(DisasContextBase *dcbase, CPUState *cpu)
          * start of the TB.
          */
         assert(s->base.num_insns == 1);
-        gen_helper_exception_pc_alignment(tcg_env, tcg_constant_tl(pc));
+        gen_helper_exception_pc_alignment(tcg_env, tcg_constant_vaddr(pc));
         s->base.is_jmp = DISAS_NORETURN;
         s->base.pc_next = QEMU_ALIGN_UP(pc, 4);
         return;
diff --git a/target/arm/tcg/translate.c b/target/arm/tcg/translate.c
index 88df9c482ab..99f07047fe5 100644
--- a/target/arm/tcg/translate.c
+++ b/target/arm/tcg/translate.c
@@ -7790,7 +7790,7 @@ static void arm_tr_translate_insn(DisasContextBase *dcbase, CPUState *cpu)
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


