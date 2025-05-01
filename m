Return-Path: <kvm+bounces-45042-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23CC4AA5AD5
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 08:25:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 346114C0563
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 06:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B87927815B;
	Thu,  1 May 2025 06:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UTedJGGB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79902777FD
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 06:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746080645; cv=none; b=lEYQuHherYrnRqOt1ajIa+hycspKQaHCWMLfNvg8JNPjCasyRUDkGgnhIv7cdF/A+apr/rdK9pILX0xvRH3kvR1T0U1jCle8hsndsXIZWlnK5mdS+TbLM5d74nWPmjpgfpoEDbpHgSrBWfXb70CCpG4ru479DSQxhIt9m2utKvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746080645; c=relaxed/simple;
	bh=HutdN8E8OjQAzePYYJlAlj99Z5bnsYebPl59G+9KvaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TWcj6nefpJJn+l9HbPKD+sITW/YOWPQu5anD0YWXaPBeEnzfdLqwyy5OCjzMv04A0Ycyty9amjtv6kHkqGtoeK/P0EQgWpaMwrVpiKG6hkSRs2wD4tqaiohhyEJdXN4zdzBjD790c5AuB0fpLJSFqjt/dI9V7Ut5SfbWr+asB0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UTedJGGB; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-73bf1cef6ceso698353b3a.0
        for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 23:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746080643; x=1746685443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eC/HRV8/2d4cTcu2Y+L56bEld1xnVZxGu+at/3yGTOk=;
        b=UTedJGGB+JU5xi++N/GDaIz/dI5Xf/Cu7c/IsS7gmsSLhN3bgVxWl8aM7nho4hdU/v
         JJ+OTo3yjIRdSDcjJjkAGHbxk/MvauLLcykECTwPdWhjC4wSgpHsqhuYoC+MMbdHXGey
         m2sPaolr1r94q01YhPLa/thBI/I5g8GGr0ksKjOvlVfwxHUMRCP+IzHNE6v/8Q5URKBO
         vxkJ1OsNds0kEmWleSrhFF6dusSi0AYOPaDc2LFJT0OaoVhDiJ8LXAAsg+Ey/aPryPzc
         n31xi/0tBkLOA2VDuEPuCTeygiDrZc/lo90Ua5IDc5D+9iJ5tw2bBra43Q0pZsQyFMVO
         +Xvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746080643; x=1746685443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eC/HRV8/2d4cTcu2Y+L56bEld1xnVZxGu+at/3yGTOk=;
        b=gD+HC1igCDDSYqEiAFqDEA9ruZ3E3Xy7wosbZgojmeaNNCPux+4ysV5whwd7AqXENE
         e8/I44V8q+JhS/GrISE4ZWuPBY8H2IBSxLju6Mq3aY2+u/OimWB00yeYR5WVf6VNc+ox
         UBfMlW5QYJyxkcXMVuTKM+m1bgOULZiyU0+rE9TOD8lbgW43JIVqA/OtS0sQcTDnI9sD
         qh+fGzrbC2wbf3M9EbHuysb56j4vho13DvG2bHnvmsnZ4cIV1M+17pBqSzOp2qkNwjx6
         HYz79vTCBabVF6ik37xLFHdkCsYPSjjT3+5BW8NFytlUkOhp0776zmpyIYK8HBt8lne4
         Tz7Q==
X-Forwarded-Encrypted: i=1; AJvYcCV6GBglkl2P+ex//PZdbv8dWAUwzeXCpTsaN/z0Eja7m7sTBBtYk0AAuiWfvR6OeTBjBYo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPVb4zPz8KgcgrxDn3N5fIM1wUaiyh3gGG92HJTLxrQieDTiVA
	K2za0HzZCHmjxunze2XIkOXQYQqZJMA3pRHSBTeM1pv+PHIsaTX0nIdIY7YJedA=
X-Gm-Gg: ASbGncstf1Mpj/Y/KkddyXjQ/369VEH9wcrU/+UtSCe0/2PuQpYJboxtOhxkCcffkwk
	lW3BgFQHmybo++N4V2Kp9GQ1lkAWa8wHaIQO9zxbdDrovK/gKc/WtNV7XhrCOvOiRJFYPEZdgpa
	GxTJXaqUjgc9YxZnsQGcnt33JyIbtv5PG9MIdzrutR1JzUYf4b1oWaeQ2zcxQGL2IMqVVxFYz3E
	DAjwe7lHtikp/wT+fxgrwv+zqFO52nt1Kav6B+q3VShsf4IhnjYeMbx3Le4RL7EeMqZiHpfecgJ
	Fho9tsfAzVUINQ7X++SJk44OH+Ge3jjCBYM36bux
X-Google-Smtp-Source: AGHT+IHB80u1428PHxy6JDVfoTMR3OZQ1FT85u62QQ1lo3XoiXyKZwox+P7tK2iUDXZ/GGwXnMlKuw==
X-Received: by 2002:a05:6a21:600c:b0:1f5:8f65:a6f5 with SMTP id adf61e73a8af0-20ba8789a2dmr2995051637.30.1746080643013;
        Wed, 30 Apr 2025 23:24:03 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fed21sm108134b3a.93.2025.04.30.23.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 23:24:02 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 13/33] target/arm/helper: use i64 for exception_pc_alignment
Date: Wed, 30 Apr 2025 23:23:24 -0700
Message-ID: <20250501062344.2526061-14-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
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
index 09075058391..450c9d841bf 100644
--- a/target/arm/helper.h
+++ b/target/arm/helper.h
@@ -49,7 +49,7 @@ DEF_HELPER_3(exception_with_syndrome, noreturn, env, i32, i32)
 DEF_HELPER_4(exception_with_syndrome_el, noreturn, env, i32, i32, i32)
 DEF_HELPER_2(exception_bkpt_insn, noreturn, env, i32)
 DEF_HELPER_2(exception_swstep, noreturn, env, i32)
-DEF_HELPER_2(exception_pc_alignment, noreturn, env, tl)
+DEF_HELPER_2(exception_pc_alignment, noreturn, env, i64)
 DEF_HELPER_1(setend, void, env)
 DEF_HELPER_2(wfi, void, env, i32)
 DEF_HELPER_1(wfe, void, env)
diff --git a/target/arm/tcg/tlb_helper.c b/target/arm/tcg/tlb_helper.c
index 8841f039bc6..943b8438fc7 100644
--- a/target/arm/tcg/tlb_helper.c
+++ b/target/arm/tcg/tlb_helper.c
@@ -277,7 +277,7 @@ void arm_cpu_do_unaligned_access(CPUState *cs, vaddr vaddr,
     arm_deliver_fault(cpu, vaddr, access_type, mmu_idx, &fi);
 }
 
-void helper_exception_pc_alignment(CPUARMState *env, target_ulong pc)
+void helper_exception_pc_alignment(CPUARMState *env, uint64_t pc)
 {
     ARMMMUFaultInfo fi = { .type = ARMFault_Alignment };
     int target_el = exception_target_el(env);
diff --git a/target/arm/tcg/translate-a64.c b/target/arm/tcg/translate-a64.c
index 43408c71bbd..2fe8ada803a 100644
--- a/target/arm/tcg/translate-a64.c
+++ b/target/arm/tcg/translate-a64.c
@@ -10247,7 +10247,7 @@ static void aarch64_tr_translate_insn(DisasContextBase *dcbase, CPUState *cpu)
          * start of the TB.
          */
         assert(s->base.num_insns == 1);
-        gen_helper_exception_pc_alignment(tcg_env, tcg_constant_tl(pc));
+        gen_helper_exception_pc_alignment(tcg_env, tcg_constant_i64(pc));
         s->base.is_jmp = DISAS_NORETURN;
         s->base.pc_next = QEMU_ALIGN_UP(pc, 4);
         return;
diff --git a/target/arm/tcg/translate.c b/target/arm/tcg/translate.c
index 273b860d572..1577ef697b2 100644
--- a/target/arm/tcg/translate.c
+++ b/target/arm/tcg/translate.c
@@ -7801,7 +7801,7 @@ static void arm_tr_translate_insn(DisasContextBase *dcbase, CPUState *cpu)
          * be possible after an indirect branch, at the start of the TB.
          */
         assert(dc->base.num_insns == 1);
-        gen_helper_exception_pc_alignment(tcg_env, tcg_constant_tl(pc));
+        gen_helper_exception_pc_alignment(tcg_env, tcg_constant_i64(pc));
         dc->base.is_jmp = DISAS_NORETURN;
         dc->base.pc_next = QEMU_ALIGN_UP(pc, 4);
         return;
-- 
2.47.2


