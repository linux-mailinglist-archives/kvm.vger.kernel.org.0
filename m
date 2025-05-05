Return-Path: <kvm+bounces-45499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E5C3AAAD5A
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 04:33:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D96BA1A84098
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 02:30:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812F83EA8F1;
	Mon,  5 May 2025 23:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jHtCHP+m"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE9843B11F8
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487237; cv=none; b=lhbiVkwOrq+QVQBI9CMn0G57TB8NpdraL2WTB9rqpdFCKtgQRUL4dJhd83oEl0A8jxMaXobCwRBHfQ9zuZNxgeM5mjqGq9PUTMCDScA5Z4RHq9jGElzXzRo0gCaWzmqAZRoj+17qeZBBtQ3sG+281TzwZfd80gYqHb+BhhjH/24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487237; c=relaxed/simple;
	bh=Mzqsn120QGpE+vKtcAjFkp67eDLsrk1bAO1ZIsU/LzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBkiK8BSOucfLmWMBOIcAu3ezKScbm9XMBjUYFSOyLSZxYmZPfwZYrd8WTBNK2/hD87JOqe3pb8yxzlIRR3HGFPHV4gIJZ/P+JBuZC5a+xhznH2nbnpOg9rS0kYafdHiG9c+2T/UcZeLozQTfAHOwZCDWiwMV8uHtGplPZP0arI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jHtCHP+m; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22e09f57ed4so46777855ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487234; x=1747092034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4MSVLYsQ1aHRPUMsqKWeWNfiw/1OBObe6XUOYFWrKME=;
        b=jHtCHP+myy3/oekAqWqqyTQhHZvRgqCt4auzyZrBanawn+cgmWvAJ5zTXlzP/DTK59
         U6LUCjLDy2W6slGi7mi3RoEXj9kd1tCDoTsuZBIxlO8/6sYNLwbHpAsy4m/iXJK+KJtK
         UCU3RuRZfM9aE9W3v2UD4MMXg4Wmu0oF/H6ddcT4gmsyzg3SMGa2FTNkxmxZmKUxFqs2
         0Mh119ZdOIuX7tqIOnI6CNNSTjg34rl5I8kY8aVBpwY8/m0WOwB808YLovWcekX3QuCW
         sBtUno4OMhE9fj2mRBolkExSmJDVVs1tty2sn+5D3qoCIkmQ26dfgnrEysYaYpQ4laaF
         7U+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487234; x=1747092034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4MSVLYsQ1aHRPUMsqKWeWNfiw/1OBObe6XUOYFWrKME=;
        b=ZfVFYQar0zC+wUx1Ip62ZhQfWRq5jmbDyzpUtIZCRmqXSDT4ZOOF0klfchRgCpMEgt
         BBuB5V9au/BMcIwG0g0kqn5fvXnqA7vfIMBzPt+ViiVS5nQgZsnECFkxJ6cbFcw5ethI
         L5No1yx1Xhc/6mTjC2XaaWogwc+9+cVMaAtZGUbpCHiUjXIqU5QNi34F4madLH+uQBif
         A+6gZO/dfAqlukNczP68Fa+OB1QwEXLbrxGs8atRvPyWlhBLJazl6reg+rf8yxnvxfDk
         XXgqcusH80T1ti1YSAGtLdXCMpx1B6eZWihC74nNn8iY+yAtTy1Queug8sx6W4S/ctBO
         MdUQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtq7Yyjd9RaE7mD5RNcwTpDsCxOZZj6E9jHacRPmFS7/CX1eUBUSGOPTTyJWm6z+OyKv8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzO+lVlerdciQ/te0iVtllJsqtHAObuqqE6sYeL1l2c/UMLIiWP
	WlqSCgOp1kT9brbykxPbThCDjCYxhZtA/Cg8yCxD/SCR+9HV2SIhSyQr1AOenkE=
X-Gm-Gg: ASbGncvD7dViDZoK/Qd+zmrd23SNcg9Be6HXKqsSXCWQkiAjb/jEpDP0zeKDJTafrQp
	yxjOIT3UPrZuTvfP4DTwy2TETI6H83xHXnoooaEAJcid7ZmCISNvny8gCaNGdb9DpjegCFEGvJg
	mwZOOs+2NFLUmTQ9sxOzquu9T/ic869xP4aBE1bLCdbcuGx6VjORexJ8mjeV2sIk+/H/Jg70qPz
	VELHwyH7+LWvRAn3PH4l+0Njkn27wVETj4B9YUEwt7h3jPSl8R+9y0ehIo9y27NmSLJwDJ9t3+9
	Uyc303afGckKNcUrB3yttxW0qHBVcC8FmKSCf+oS
X-Google-Smtp-Source: AGHT+IHTINwaey7ySLvXtg1QPxU98WusV/OE2FldyD8VBKMIteaxM9KIYsWwhG915qemWBZmFL73qA==
X-Received: by 2002:a17:903:906:b0:215:a303:24e9 with SMTP id d9443c01a7336-22e31f7e424mr17270675ad.3.1746487233916;
        Mon, 05 May 2025 16:20:33 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:33 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: richard.henderson@linaro.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v6 15/50] target/arm/helper: use vaddr instead of target_ulong for exception_pc_alignment
Date: Mon,  5 May 2025 16:19:40 -0700
Message-ID: <20250505232015.130990-16-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
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


