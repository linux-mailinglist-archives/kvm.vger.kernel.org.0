Return-Path: <kvm+bounces-46248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99EEEAB42C9
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:26:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21AF11B61E4D
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:26:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D55112C2ACD;
	Mon, 12 May 2025 18:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="T5H9y0t4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F9B72C2AB2
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073340; cv=none; b=EZKn3iu9cgW130ANYAZGTBFIuvQTPgKaOXdd4KIWslbSXNYede3EAOC2LpLKQfpZV9+ssVZj5Z+BIZWNoHNafFh9/tBj3qx4xptIUj8yqFnem9qmBNE6E/D3/m/GvPbLn6XAhV66TTqQbBw9Wcq8tn5ADWOtWMGCuPzOuOat5SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073340; c=relaxed/simple;
	bh=faRCTrf6TBAyy1Gxn1R7zpsi5M9ebC+tFXR3moVS+yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+FAjhN9xw4Mjgwco/Rx0lX/54eehLxGannMCp5JhK+JaQlqsK2j4tBGol1dy6K4sHyQ6HaskkezuerMbU/MT1diJAQ04lJqNh9yfBubnFQY2x4sBHMtfDpy2ZG+n2QtrHH3N9mYAGF966LdrfyIm0jIyM8eWpwt4t7lLcBSN7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=T5H9y0t4; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7390d21bb1cso4802456b3a.2
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073337; x=1747678137; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZWI42H1mGpC+qtJnGTlft49SFGxWloHLdh6QbAbdhzc=;
        b=T5H9y0t45sQE2/SrzxwdngatXVlMnC3N3aG/1ItqisuVW93x2oDqn3A1MJyvsLdnBf
         4Gn+EgxwBTIFXbZukoK12wTkn23sjR4j6cyhn5UOD3292Ph+XjWOTPceQsOsgPfJ7GEk
         W6PiNvrvr+H68e85LlEXEI6S7U/H3Ux2O+QC607/YQRxPH3bNLfEghQsz0YUOOxUYWNC
         PLNLRY6i3M0MCNd/Rd2z/Z3UobzuSkBb0Cv4yroZEBMOJsI288VidduBRqZ6VSvd2gq1
         sl113y5/40aGUg3iBK1MmFtnlGheaNJmC2v/OAWEKcpTcOudQU5vUIFgHLufjxpg4gC6
         IxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073337; x=1747678137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZWI42H1mGpC+qtJnGTlft49SFGxWloHLdh6QbAbdhzc=;
        b=KXJDHVcIc9324mp/RsGdOxQrD9Yg8PT7wYeb4fHPpR5IZLQMUt2Y4HuBas4mY6gBCI
         wOzrErhAGkz4SiTFFIkPeWn8155tIho9nDE6g79+NelMDQKGZtB4t77GOJNsz1g2Rya0
         90gFBVcJq0Lkv0k23/jegcB2gj0FQtSJ4RZUfJZ1Sfc+dhZayh3/0dITSCZ6GRoEWobx
         Y/0iJppN2cCNftS7IYzdCOwSNpwSNKuBGcXoufJiDQoBPQf/5L2dXEEpq5CXg+ufCS6H
         QlWnBTDU6ImJqdhbR/IaNMx5iMUxmgfCfUbeDS0UEvLHK31dnTdjNmsf6BTON7vMpJu3
         7Y5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXbvdbeKEjEwxcgEsjK3zBjcshb4XdFzItvRLl3ozNl0/mznr1nGzwFhMtbnhyav9fGWjo=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTova6EqQF7rRRdb1jKP3IGqxwQzsTDkQqqjltZ1ZDo7UvUKIQ
	WW2RJqxiO1jDDG7BBeZW+ctG3LyyYMuFA8ksVx5wNeoT3xbo0/JHKDdCWbBV9l0=
X-Gm-Gg: ASbGncsZl3odBqdVkhnYs9nS8sYe1i2az28PkY65Sh/IPiR30uSJkPFixiU5F+JFdtr
	ASV+QLO4OhRQ6pbjXwRX3Ri7GnTDcVKtNcs8XFRUKT52bPvGNLuzy1mM4UQIJqGNehu0pbwqWoS
	LqKTmSBZuRCor6vluoOMQ3gyjYvOIGezzy4PHhqAqwDVB7Ik4FtyiAOhDMrZWq2ZioF4vA9J76W
	9sCHgFZQyNq5dY5nDvQtSeO4ySZUEgnsaMY3Zv0wSSLScRxp/BbebpN2jeP8BIN3sLfSBaO3cSa
	Ir3gm+5RSEvv97Z1BhZX4cDe5+zjmSiHyKvTzT1ckUrV0HxdtIg=
X-Google-Smtp-Source: AGHT+IHtnl15XBTtEr1mY8dLt6bXrBUqTmVSSEupohhsnj2Dz63VmmRIZJFm31uUpKt4D1dkYmWtPw==
X-Received: by 2002:a05:6a00:23c8:b0:737:9b:582a with SMTP id d2e1a72fcca58-7423c087158mr22392781b3a.24.1747073337534;
        Mon, 12 May 2025 11:08:57 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237705499sm6438580b3a.33.2025.05.12.11.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:08:57 -0700 (PDT)
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
Subject: [PATCH v8 46/48] target/arm/tcg/tlb-insns: compile file once (system)
Date: Mon, 12 May 2025 11:05:00 -0700
Message-ID: <20250512180502.2395029-47-pierrick.bouvier@linaro.org>
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


