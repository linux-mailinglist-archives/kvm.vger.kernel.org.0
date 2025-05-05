Return-Path: <kvm+bounces-45542-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7863FAAB602
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 07:40:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3084F50330A
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:36:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3509C4B1E63;
	Tue,  6 May 2025 00:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GbT0zcQr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35812FC108
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487457; cv=none; b=tgulZmhYWEtjF0Qp6sVGPF00nxBypXIhHNiBhF+LG6/d6SgVTbm9ZzYaGbIycenQczVSJbv50NBnxo9+jVPbwZ+Hv+X2yPfUW+WhNKyaF7U5RFvfmVMCGRgcQLFNF1xbEFtH3eg34CnswGPqmFFgtP8tOQjlccy97J45xrCQqCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487457; c=relaxed/simple;
	bh=faRCTrf6TBAyy1Gxn1R7zpsi5M9ebC+tFXR3moVS+yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDFbOB4MGHqxjfG2mw4cFM5vFIiPnQopjltrjc8/oAOFPw88dvq39pjjhJaHB8Na+Htc/F/olTiLOqpuO2d3QR3wSbPAx7oF/bJIfhlJeFgP9WBpNndX/6ukvUeDthhXteD1UBslR+/s+On7I4qdwloiVrZFA/G/LZ7aewwkJGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GbT0zcQr; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22c33677183so59931315ad.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487455; x=1747092255; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZWI42H1mGpC+qtJnGTlft49SFGxWloHLdh6QbAbdhzc=;
        b=GbT0zcQrNQaqNmXJdgEifGL19flNIPXae4cgRiv8eg9INE5vmZPsI8M6NPDb4zN04A
         SKfpRS47P0FnodB95RrFzjduuafkCU1zO8ePoae7ZtUxIY/O9Asc6ncDgSRCfHHWQQgs
         PtYjWZhZho3jmdgaP3rRenf4NUGFilkOv4+p5jafhALKfe1EcUVOAVHEUyrF/jYOZEJU
         rRKjMvUVR1P2SOAKm2JkMTFHB5grAilJtOE1Tcgjk9NaZy2h4H4RSVGzb333R5KcZaNn
         cZv9P7unK4oF+NOGYROp85a0UU29t6PaXzbQBn90A6WJgtTPA2mOKk67s+nc0PSSCzCk
         rdSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487455; x=1747092255;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZWI42H1mGpC+qtJnGTlft49SFGxWloHLdh6QbAbdhzc=;
        b=LNAavKUsNg5niyMnde88XSF1tKnTzUJm+Q436OirAEa9Pw4LD89vRogkw3Y2qDiYBy
         Bx7r7tsY7OHMIXwOExBnfV4aoSrB0fnQfKFhYlimp4IydFLll2o/MgE8Jd450F+jSW3+
         HkekxkuIMMe6ECDFPqXXKah/OY0uDbe91OxWZBSNe0jpdlc8Ofnj9uYhmw+6+v+E/g5s
         xvUSq4URdVkHDaOGY2jO/Tugto3aEfgXzga2/+VtDopQvKSX9B4dUD5LSnyzluNnLaW6
         T7aP/FtrhtlBkeLu/NZtUP1E33ZP01h6/wbX1vleqm96ADSnVxNJKf2u806TyWCPZ1fs
         eBdA==
X-Forwarded-Encrypted: i=1; AJvYcCV7hEGERjunYGtrpKjjAkFhGnVVkdalG4ASj7ZzHVwx5ukRqtB0VmLnv05VvWjNp5kAWVo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2UHG+RnTg3mfHieLfKtse7ioJXvChroX+Q4yEgWkkwgt7bEXo
	qTG7M70aIOFVPj7orjNIVznbShS4lQlClbWjCtb/6du+Dcw18De/RzM9UawhDVs=
X-Gm-Gg: ASbGnctz94Ex29kXJG44TL/MYIlxK1ZeKGU0wY9tUgsMLD66ZRPjgOmnxczHWEXBvuJ
	XxJ9Lm9O7D9Bvo6Nb0cSDLnSBQ5JWJX85+7QtMWFyOlujIbE+0dhXUqmSdSapqidgPX+/RFWfAh
	N0fEkTPKznRirc7mMzf1BMbVm3BxemC9+jhdeqcBaK7+0aUhX4ykAKWUYtbzlhSPLW2LZlE7O41
	pvSN4h08qbpMLFEAkDIP2SVCiiZrtiLR566Z5FHBtpV9T26Oiz/S/KYBY9q9y+bvVD2iadqwswh
	waeRYsBkiFy1vfEgSrJI6GtQtH414KqfSKePWcisUoLqQCS1p3o=
X-Google-Smtp-Source: AGHT+IEUQQFAnhHZvpgEW269JjynFC74SxQHriC0mVPlLRJAjytrepF+TKFERHIHr5qYzSkqIHY0bA==
X-Received: by 2002:a17:902:f14d:b0:22e:37b8:7972 with SMTP id d9443c01a7336-22e37b881c3mr6291595ad.10.1746487455166;
        Mon, 05 May 2025 16:24:15 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e16348edasm58705265ad.28.2025.05.05.16.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:24:14 -0700 (PDT)
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
Subject: [PATCH v6 48/50] target/arm/tcg/tlb-insns: compile file once (system)
Date: Mon,  5 May 2025 16:20:13 -0700
Message-ID: <20250505232015.130990-49-pierrick.bouvier@linaro.org>
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

aarch64 specific code is guarded by cpu_isar_feature(aa64*), so it's
safe to expose it.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/tlb-insns.c | 7 -------
 target/arm/tcg/meson.build | 2 +-
 2 files changed, 1 insertion(+), 8 deletions(-)

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
index 49c8f4390a1..5d326585401 100644
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
@@ -68,6 +67,7 @@ arm_common_system_ss.add(files(
   'iwmmxt_helper.c',
   'neon_helper.c',
   'tlb_helper.c',
+  'tlb-insns.c',
 ))
 arm_user_ss.add(files(
   'hflags.c',
-- 
2.47.2


