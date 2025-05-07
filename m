Return-Path: <kvm+bounces-45780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F1C4AAEF78
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:45:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C94537BEAB1
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EB602920A2;
	Wed,  7 May 2025 23:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j0P69Wqk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 552F4292083
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661377; cv=none; b=tVrdwzK5ggrOI+K3r66+Fhh8pNCASO+ozmRf7vZneQteGwZwwiejj4p1p0eZYr7Js8ySXyCXUB8dpuO/lPU/aF4GTZQRaxQgL72+dVEv+HGDdvqufAZ4ARBH276nxlm6pbCiDBNR+rEi8tA6tM6Li8G4LGGhWvM28foz+vkeYTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661377; c=relaxed/simple;
	bh=EzRITekUV3GOdklMQfspnNaPhZSQ5YzzOUPxMNZS8xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYtIG/LhmOOiuSZvuc+y2Z+P1orAtksUr8PXMT4NKS6f+MKE9GNTQeMM+VPqvc+QAPyzrdY7MvnAbEnc75P1iDGPJGmk+pLBJnYaXI+X5b1bakkWvZEB5SQwpSq7EyXsF+OTo3hoZZWz+dk2UGPeA8rCVxMw5KC8oU85wkJZiuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=j0P69Wqk; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22fa414c497so1202045ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661375; x=1747266175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hulB2UBYIXOqzJFKVn1ypmpXSnKnDaK1c4I5WrAN9H8=;
        b=j0P69WqktKfNhJP/n1amBpc1aG0bPs2RMBUv75gaBgFM/Gmzm6l7qDbtvK7RZRthc6
         w+peNpm1lMT5wrbRr/afgM2Pz9T82LB+LtbjNUOGuysHu9oITrZjUMJF1G4PZ2tR5ndn
         mS2U0mpZgQIat3T9KX+0qAwNeEVjkhhNMhIgswuSviBz8Ifn+lw0GR/WAHi9vN4WaxRH
         ZZ63aOBAawvYSkflNNEhgAWH+6xKFjLvQQ6CS8XocIrs1hBySrMgE+bUWyvXwvqNhXnr
         0vsLGRm0sj+PTqbTyx9NhkbJr3DuExE+dh2CftTaHyO3bdZBrT7Ihx+BQp2/JU3XmwQ+
         7YQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661375; x=1747266175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hulB2UBYIXOqzJFKVn1ypmpXSnKnDaK1c4I5WrAN9H8=;
        b=qHPhBFqp8+EL8cO2EJRiCyyPvN1I621zVkNjn5LGr5aSoz0mPkYAsPgUTUiIYjBfca
         nc5tXXf/R5lw1n5bYCOpUwv0Hqu39h6c45C0804e8DyJL8cNkWYdNxQwnoFRzkHFKO+I
         zRFxEanrjgzYhsmWx46omF1HDWQCxCqq3PhVdLO5borZFflkq3bI5HNVHzqM5WxuvLfW
         FEpNCGc5PwCyFWERDLjTGzygNOpwkBSpDlAhtUo+u5wyjoNZcFfvLudJ19t8aK874Jhr
         OxIy7VcRP99anwutTyrMEwLKpmKPuQcOJ0G6OvLqQNNsJNoRgmcv5hHMvn0LPD0nwBg4
         f6lA==
X-Forwarded-Encrypted: i=1; AJvYcCVgN1N7jC99RQeP9Ruq1we9hFIqM3D5YyqxV3K0/0SJPgeYFmuSeZgK3Pjt9xNNd3ovTTE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCRZt0lQZxjafb+zhMFcKKOJ8+XiDDMASn6wMH+HrXePVUl7+q
	HnlGRwexafh8qA0TB7eb7cToMjX3920ZTGSsi1UEieqstnqzvdNLL6lyGDv62iM=
X-Gm-Gg: ASbGncub9waYMTU85uKZO5KGISBckQ6TWUAf+osedv3gJ9rTN+3g8o+HLyP+3MRtbGv
	rJuzplaLrNc8dt+mLEOFoeyUgIGN6bxKyuL8LQhdjmYoqYPZSbKyVqJI2Zw1lAhLeRxbE6ucDQ6
	qoB8WKX9uk+ShATF/T7yVIx1N+4VRTnu5Fa1KKn3Z4sqAmFFzzYGTlfHvsS9r3H/vjMRUHKbgi3
	r1/pmzOlQucQxdcNm3KvX/icDtBDGi2BAaiNS1TnK7TP49/7EOauljMqT6pby/WrJuViy9fuF3E
	E+jKIk3EJA/C4o4OmeA9y3S7/1FIY5ZBUQlgtlUs
X-Google-Smtp-Source: AGHT+IG0668HnujjOop4MRhdufku9w1ExNwRIuz4QjwGB7uvWhg2Mg9/z3MDPW/4Cc15wrPc+nQsvg==
X-Received: by 2002:a17:902:daca:b0:223:5379:5e4e with SMTP id d9443c01a7336-22e5ea70aedmr96307875ad.10.1746661375655;
        Wed, 07 May 2025 16:42:55 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e815806fdsm6491325ad.17.2025.05.07.16.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:42:55 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 14/49] target/arm/helper: use vaddr instead of target_ulong for exception_pc_alignment
Date: Wed,  7 May 2025 16:42:05 -0700
Message-ID: <20250507234241.957746-15-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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


