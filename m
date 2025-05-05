Return-Path: <kvm+bounces-45362-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A8BAA8AC1
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:53:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0415F172711
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:53:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CE79199E84;
	Mon,  5 May 2025 01:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UrYWqaEy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496FE1B423D
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746409963; cv=none; b=rBA4ipDDkxwVON/G+5FgqYHJa9Oe+zc0Fyh0ToGnwrwXN6NyCQycEI+a8wc7DhicVuDWdzQtfr7UH937hd/XQVRHShpiEY6hzbV0LHWA3WSqHXGk1+tOeyc67eMVw2AHVYrI6ewGvnhaEL868QF2cw9p/0x8HTiQbl8P75gaLZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746409963; c=relaxed/simple;
	bh=Mzqsn120QGpE+vKtcAjFkp67eDLsrk1bAO1ZIsU/LzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAVPKhVeO4cVsH4B7/Q79G9mYGOmHAAIPjtgWOYh3JU9PcWeaZ0/cZmb70mnhxmqcpnw64y1dARjFlNDm0EckQsQntl2YCtGvagk+6NNuu9Lvd1GhAZ6mftlOsZ0Y1qinvyN/E9ayNjBs948fQYCx8xw3E/pKS5nX7YpesfK6WA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UrYWqaEy; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2240b4de12bso62873885ad.2
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746409961; x=1747014761; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4MSVLYsQ1aHRPUMsqKWeWNfiw/1OBObe6XUOYFWrKME=;
        b=UrYWqaEyA+J9oggVS8znPQAmGWMtRGQVfwAnXAC6ucGsGLvH1FQRvQDrYTuI/HXXzx
         7XjrQPrZn2z9RrD3kpeRN02j6+VwXEmSTTKOUCHj3ttQH/HHBAGxxvJWDyGS30Xh4Zp2
         pQREfRXQLiDydQBHXk71g5NG+C3YnQ1cQ3+uKDq6n+VZKW2N1R2zFwdWQuOqEZE6ZC50
         Ahf5ctjyLvCe1pcN/0AKI15FGWLvg3FqWrp2Dq+oYAUGCH3sMa4EabjdNJyHriHtjekY
         69dKJOSCoKxHxglynykyzqGZc2FCcN/hcfDvJssGTlnBlWPkA6CzrLdlD/0E6fGky7DE
         xUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746409961; x=1747014761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4MSVLYsQ1aHRPUMsqKWeWNfiw/1OBObe6XUOYFWrKME=;
        b=pRpHuciPCZ9f3d2i++UUTFe6iVHqFTGSFwDLa4l42h8nvAfGrypYWjQ0OuGc3F4ZNU
         prPPg226P6+FXbsWbqrkmDXWyI/jrZYzjIGkHl9/t7xdG8/Otk7d6MVfmyFVdZrIxo+Q
         0Z+TCzGUALdsRvhk5mAN721zCCFmT2h5CmSAKw93domfImd4sUfHdQQIQLpNJEx83XBs
         OVF2cLan71JXJ89b9kQdpCr0OQVfDQW5C87FBOjFS9dXv+HullNU/P0MSCi1bMkxW9Xs
         dhkxkIOGP8b2sT38GEcqPFKqG5dGTSupS4vuIlclVD18fqJUpXqDg2be8P6GzalBK3Sy
         QMnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWLTxfLNvaZZ0rFag+t0DaYCrRl5TlocXxU5PY52eWMx+mG+mjKJpvY8At1G3znE7tWP3c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxYDcLH6JCEYJen16jjeuON3F58h0qnpOl7L1Rh0+svLLp18t4R
	Ff+MwQd8lkIz7jwED7svgqvtNkWmiphXjtnyWsNUmCF8ogKrEyRx9th5pkDQdjs=
X-Gm-Gg: ASbGncsdsw+3apPB2UpEH5lSCerpevPhafYSxX1U3NqNAfAy0fXb65SB7C6mVq9jtf3
	nTT/GIVcorVyh2mSWoj2HvyLhIyFcJlPK2epSM6lFrtcO5w9lqFDap4iZTjcGvblGIkZbsU4fet
	wmiIC2xl1mEnigTijYdTJFZr9KgXQIQTTaxqtLWasUc2TO56UN/SoEpo5TYou+9rEILHtzljf3q
	E4rSnmuTXhfrY5cw7XdmYaVsOQ/Kn2YV98LfVtYzIB/SbXZ+/AGLqBWpEOq/4Mi/v7Z2Pocztq7
	MOHq5mJkb5kzRFhSqcpjB1F4jsaqm53TzH14sMwz
X-Google-Smtp-Source: AGHT+IFStReL3d3Chdl6PrC5O/ZzbLYNJcWT7xOxwxpCTNKHN0EosJJL26gYeCAolZHGa5+8q0WjYw==
X-Received: by 2002:a17:903:1aa8:b0:224:1781:a947 with SMTP id d9443c01a7336-22e1e905660mr87815615ad.21.1746409961673;
        Sun, 04 May 2025 18:52:41 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3920074sm4462101a12.11.2025.05.04.18.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:52:41 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 15/48] target/arm/helper: use vaddr instead of target_ulong for exception_pc_alignment
Date: Sun,  4 May 2025 18:51:50 -0700
Message-ID: <20250505015223.3895275-16-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
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


