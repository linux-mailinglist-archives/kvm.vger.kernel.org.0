Return-Path: <kvm+bounces-45393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 710E7AA8AF1
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FB401893D32
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:57:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 479D2192D9D;
	Mon,  5 May 2025 01:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PPkInHEu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83FD191F98
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746410191; cv=none; b=Xluf+k1KHqeTfjLCVK6JAOObIvXT5jbkAyXJJXxjBTGvqnxV/3e9CfLZHavriW5dV6CZDOYVecDnfVRzlppIVTyaq4eeoJX/ckXKIbRRgTY/mxxw01q06PCHVliBME4YtSbjdwG07cug8bA4gRHc2cWqMQUqQBfjwkT9zfAEMnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746410191; c=relaxed/simple;
	bh=iyPEaOyzmIIRLJU7wts6DcjgQvj9g+kJZ3VUYtrKmzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=trMPLS+NuPsX2SEc0H0kpiE0Jvf3qICH7hNDiku7dyAARWEKN0mPp4OOssQnUVSRM6aCKYkeqQPj/fwuHBSUNi9P57OpxMTuXxuYAuDj4S2LQyQOytr+yNJI2G7QvVojvN16iaseQt2wYx/NnueTOExkWInp+c2sefRQCk3EmdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PPkInHEu; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-af589091049so2753099a12.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746410189; x=1747014989; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KAOgrGi4ghC8+gWPIlyM/nbU9ofyXXxCXlHL7nptXa0=;
        b=PPkInHEuyHP7Rxg/LaGwTKagOOLYPTRfJme2jKoy85mNgLRnKP3nOuh+1W1+SZLSq+
         08X/cR9ZGLQYybH/YLDFYjcXuPCguzuN8eqGzVWWs3+8BDL4UQ1INLzog5ds63mqekWQ
         3ZuDWHhw4gRFyplhDbyQsZNZC0wqSQepF7bPLXf7pFkakSRD5XtJq+730iovQqytCGpd
         uLEV56ERqJSDXNInLTOt6UBo/SOG+BOYqR01EROa4JO2fRNxlW6VxHPfyFa7caFje0Bc
         cfdkFRnB2dZjhsXTUHIQN/R4+KSoGA0FOByJgY48/UT+xGYhWak8fyPbWzguL01Z4s3o
         BN+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746410189; x=1747014989;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KAOgrGi4ghC8+gWPIlyM/nbU9ofyXXxCXlHL7nptXa0=;
        b=CzH0Uu3lZcBTUtsJOgG82plTuMPAGLO3AWdyOk4tioPEOhe/czoO3YWeuVX5EBWRM8
         qvQN7cfwj+NGsQ3z/LhgrWDkfu/MR4b0i4nw3QG5ZPjzJ6uMSZeszWPod4Ndrr2bCAml
         HZ8YlX2yKj+9h9zBJMzLsfLmdOfwXyV2ns7+CKsNSOynT48PeUfavncy+VNZ42wBFdRh
         V2VEBzsr1OcLaMqOLFBEZiucQvAiid0r4GpBMgmAEHsKqgyZ3PvYEZ20nioTs9YhMBL+
         767d6zU/Xo7GjJQbuX/4DLQ1mjojDg+0Sqan3L/Q19nHFzK8VaaMt6/bN6cwvZgsndZ6
         NeQw==
X-Forwarded-Encrypted: i=1; AJvYcCV77sIsD4207WChfnimoljzBsla0SVYFu5np5sL6zJyN++vNArNzIt6x3Gn52V5XMLcDI0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEu2wcqzZD5SNm7hhXQaMiRUHJEBlWbYgujdIbQF+tWUTupQKO
	4i4uMawnSvyxRTzMP+sHpSdeW9PzuWcsOMSgJCoT4pfr14JyhOB1bGE9VixZsuo=
X-Gm-Gg: ASbGncuLbdaciqgwRFA2C7f/NCZflWYC/RvIBgRF5khhNKu8Z1HWvzQwCQFFSQ+QsVP
	q3OZmUbvjCYm2Ne6hHgnwnkpH1jmkUEoSX0ZxeGU4XJ9uUeBgXkD95AIo1UaegM2fre4PLxblPK
	ey4ZFaQUPyjf0vzI/3JRwHV6lUU6WIB5PnCZISmFKGAmy4bW54LC8+dgRBNjBF17WQ4r276ZYhj
	wqZBwAEIi+paeeXWTiDzZb5WCY8oPIfKsmNm9bTar+ZDOWh7oVd4aWTQ/1pWC9VosIbzVG3RqRm
	GwR9RIxOQhn5wjAasgLYyxpGsW7YkBmOgxZWiLsR
X-Google-Smtp-Source: AGHT+IHyZNLrInoF0UGi8/gWlcgqZ15bxABMny7v/Brhs4Ifj0FpxPAHa/DSU+TaHYiyNKfZ9pvvmQ==
X-Received: by 2002:a17:90b:4c12:b0:305:2d68:8d91 with SMTP id 98e67ed59e1d1-30a4e622226mr16542763a91.28.1746410189330;
        Sun, 04 May 2025 18:56:29 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a47640279sm7516495a91.44.2025.05.04.18.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:56:28 -0700 (PDT)
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
Subject: [PATCH v5 46/48] target/arm/tcg/tlb-insns: compile file twice (system, user)
Date: Sun,  4 May 2025 18:52:21 -0700
Message-ID: <20250505015223.3895275-47-pierrick.bouvier@linaro.org>
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

aarch64 specific code is guarded by cpu_isar_feature(aa64*), so it's
safe to expose it.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/tlb-insns.c | 7 -------
 target/arm/tcg/meson.build | 3 ++-
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/target/arm/tcg/tlb-insns.c b/target/arm/tcg/tlb-insns.c
index 0407ad5542d..95c26c6d463 100644
--- a/target/arm/tcg/tlb-insns.c
+++ b/target/arm/tcg/tlb-insns.c
@@ -35,7 +35,6 @@ static CPAccessResult access_ttlbis(CPUARMState *env, const ARMCPRegInfo *ri,
     return CP_ACCESS_OK;
 }
 
-#ifdef TARGET_AARCH64
 /* Check for traps from EL1 due to HCR_EL2.TTLB or TTLBOS. */
 static CPAccessResult access_ttlbos(CPUARMState *env, const ARMCPRegInfo *ri,
                                     bool isread)
@@ -46,7 +45,6 @@ static CPAccessResult access_ttlbos(CPUARMState *env, const ARMCPRegInfo *ri,
     }
     return CP_ACCESS_OK;
 }
-#endif
 
 /* IS variants of TLB operations must affect all cores */
 static void tlbiall_is_write(CPUARMState *env, const ARMCPRegInfo *ri,
@@ -802,7 +800,6 @@ static const ARMCPRegInfo tlbi_el3_cp_reginfo[] = {
       .writefn = tlbi_aa64_vae3_write },
 };
 
-#ifdef TARGET_AARCH64
 typedef struct {
     uint64_t base;
     uint64_t length;
@@ -1270,8 +1267,6 @@ static const ARMCPRegInfo tlbi_rme_reginfo[] = {
       .writefn = tlbi_aa64_paallos_write },
 };
 
-#endif
-
 void define_tlb_insn_regs(ARMCPU *cpu)
 {
     CPUARMState *env = &cpu->env;
@@ -1299,7 +1294,6 @@ void define_tlb_insn_regs(ARMCPU *cpu)
     if (arm_feature(env, ARM_FEATURE_EL3)) {
         define_arm_cp_regs(cpu, tlbi_el3_cp_reginfo);
     }
-#ifdef TARGET_AARCH64
     if (cpu_isar_feature(aa64_tlbirange, cpu)) {
         define_arm_cp_regs(cpu, tlbirange_reginfo);
     }
@@ -1309,5 +1303,4 @@ void define_tlb_insn_regs(ARMCPU *cpu)
     if (cpu_isar_feature(aa64_rme, cpu)) {
         define_arm_cp_regs(cpu, tlbi_rme_reginfo);
     }
-#endif
 }
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 9669eab89e3..a5fcf0e7b88 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -34,7 +34,6 @@ arm_ss.add(files(
   'mve_helper.c',
   'op_helper.c',
   'vec_helper.c',
-  'tlb-insns.c',
   'arith_helper.c',
   'vfp_helper.c',
 ))
@@ -65,6 +64,7 @@ arm_common_system_ss.add(files(
   'iwmmxt_helper.c',
   'neon_helper.c',
   'tlb_helper.c',
+  'tlb-insns.c',
 ))
 arm_user_ss.add(files(
   'crypto_helper.c',
@@ -72,4 +72,5 @@ arm_user_ss.add(files(
   'iwmmxt_helper.c',
   'neon_helper.c',
   'tlb_helper.c',
+  'tlb-insns.c',
 ))
-- 
2.47.2


