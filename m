Return-Path: <kvm+bounces-45504-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71F2DAAAFFE
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 05:30:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9050A1893268
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 03:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F66528A1E4;
	Mon,  5 May 2025 23:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XW4WjlVm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1FB2F8BC3
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487246; cv=none; b=IcmjZ3qbwgXf2Tt14pv4R16DY/KLKZBxI6YPh+LbVQUuQXnGeTeFwO+l1L4nHIfdFoCsi21koZIAL/nmZX4wRKsWlxXxfj2eRO52whAY0b6BotXoY4OD+8CnwfMgNEqpGAMk0yOqAS5KTQ8x1B4dz9P0fiIIkK+T6qYWA7PZD1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487246; c=relaxed/simple;
	bh=kMI89uwz3CZQxLYmt+ENIXbqtUjYiWkNNse372VP55E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nb57Zij5WDkKz+SKhnaAqyPRL2heko9q2skLvr1vTtdSy3H9h+3hkCpFN6LBKXpSoTQOFPaFkBe3Ry7YB/VUJML/eM/cQ7tAHuSPXbRMIzZmq9uiQXggC6OqeUChp35GlKJwH105V1iYAkA7WeaFRPxsPX2mLGM2n3ZSawBD33Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XW4WjlVm; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b12b984e791so4472053a12.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487241; x=1747092041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p8C01O7GU6PtK/NYVapVL2wa5t0zjMaLo72cjg41Wlg=;
        b=XW4WjlVm5CzcmyNnPt7pb4bsCXqsWNUXsj2Zz0jTYYbl1lEphs3R/ZTZpBLAq5QGJI
         TCdB6NN+awMn++dcHVtJZhX63Ya/OWS6VciGkqbZpwBxHhoV1rUqT2WGi1vXOm+pHRl3
         KRU4/XODqb0nOAWXRTtYlyySm3nRQuCYcD20yHSzw+9LhI8km7EQKXale4kVFUT80Dwo
         s1BhJri4jd3OSjKqT2zA+OyoIhpgb+HzC+jBcWyI/XNWAXRw4mQRX9JFTJ4QUGmJvnea
         EAjpFjZegnMWPcsehJiCA3TrsMYWaqDRg3wE5HlFzFui+TZbqsXFUMJDYxtvSvGgp+qD
         Iw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487241; x=1747092041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p8C01O7GU6PtK/NYVapVL2wa5t0zjMaLo72cjg41Wlg=;
        b=sjGDOvnVbbUsD4057OE2+nrbbpiOCEfEwi3PgsAeA3yS0WDVDKWkCwWpzg33c/9aAO
         LwhBBEHoc523QpNHeeNZSwhDVASK3IXom3sC0ymWv+RIyGzSCxD/syfe6INCIscNNzzB
         9xePJXfMEZ1pkJT3KRr9UKiS9Uyafw9ou1NaGmzWBxhifgnRz45JvcRZtMyVRKeOXTyi
         yVeE35XpDkVXIusxVB8uQjam46iNWEw+F+rJ3Om32T8MjIhfQHAxzX8eP+CtujiAuCPJ
         p2UmqfTnP7ImRiKCH/OMnMOrQpzyFba8chI7ldWrebq2PAEwTJle+BVRGkGG2wCMw/h/
         wJVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMC95VL92Wx4MF5ISId3Y0U14EgId0NGNiGpvr+rFrpasWAMGhv2gGA/cjVO9jAhyh4Vw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyJm7hrMA82TZpKh++Wt+hTar7QepihefUfU5Va/Q1+piOZky+E
	WWbDw62SEH7MWzIqMLLpN54AYF0f+qQ/eQieCmwJJXphg3K/BqXatc6tVVUhRzk=
X-Gm-Gg: ASbGnct51LYPWqM5aflN1E5vGkt+auHb380vhvwfRWvXudeJhDnP84zES5iujJaZc0O
	zWvWvoPCwPNYLSN/H+GZydykY9d5XyMTLRTCAJ05ZclfoLoYxjqOGJ2kPbsjxQHe6ji8FgUixmD
	EKILrn1+Z9NMAtlcVNkMEhBjx5gNkYHF3w6Cg6BNDzY1U/S3OF59cc9o+WzEjB2h3RXuznlQ4Fw
	J8tcycmDqh3tQVIjOJ/n574gJCoIe5v2LdyHyqg2xCc/zgLNTGUrea5BgLgyqmdrlP8siwxfA6D
	XZm4Wl6E5dOfn/q5fWXXNYC/KF7X8RKXD7qUQYpRj3gOY6+pqhQ=
X-Google-Smtp-Source: AGHT+IEpYzPq9ezMy4I+jEKbu52ggydOFGVSukSx9xmYEV4nOTZH+rYgC1fwP4d94dqdVjUQVDDRYQ==
X-Received: by 2002:a17:90b:2dc1:b0:2f6:be57:49d2 with SMTP id 98e67ed59e1d1-30a619b0dabmr16714791a91.17.1746487241023;
        Mon, 05 May 2025 16:20:41 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522917asm60981715ad.201.2025.05.05.16.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:20:40 -0700 (PDT)
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
Subject: [PATCH v6 23/50] target/arm/helper: expose aarch64 cpu registration
Date: Mon,  5 May 2025 16:19:48 -0700
Message-ID: <20250505232015.130990-24-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

associated define_arm_cp_regs are guarded by
"cpu_isar_feature(aa64_*)", so it's safe to expose that code for arm
target (32 bit).

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/target/arm/helper.c b/target/arm/helper.c
index 7daf44e199d..7e07ed04a5b 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -6590,7 +6590,6 @@ static const ARMCPRegInfo zcr_reginfo[] = {
       .writefn = zcr_write, .raw_writefn = raw_write },
 };
 
-#ifdef TARGET_AARCH64
 static CPAccessResult access_tpidr2(CPUARMState *env, const ARMCPRegInfo *ri,
                                     bool isread)
 {
@@ -6824,7 +6823,6 @@ static const ARMCPRegInfo nmi_reginfo[] = {
       .writefn = aa64_allint_write, .readfn = aa64_allint_read,
       .resetfn = arm_cp_reset_ignore },
 };
-#endif /* TARGET_AARCH64 */
 
 static void define_pmu_regs(ARMCPU *cpu)
 {
@@ -7016,7 +7014,6 @@ static const ARMCPRegInfo lor_reginfo[] = {
       .type = ARM_CP_CONST, .resetvalue = 0 },
 };
 
-#ifdef TARGET_AARCH64
 static CPAccessResult access_pauth(CPUARMState *env, const ARMCPRegInfo *ri,
                                    bool isread)
 {
@@ -7509,8 +7506,6 @@ static const ARMCPRegInfo nv2_reginfo[] = {
       .fieldoffset = offsetof(CPUARMState, cp15.vncr_el2) },
 };
 
-#endif /* TARGET_AARCH64 */
-
 static CPAccessResult access_predinv(CPUARMState *env, const ARMCPRegInfo *ri,
                                      bool isread)
 {
@@ -8951,7 +8946,6 @@ void register_cp_regs_for_features(ARMCPU *cpu)
         define_one_arm_cp_reg(cpu, &hcrx_el2_reginfo);
     }
 
-#ifdef TARGET_AARCH64
     if (cpu_isar_feature(aa64_sme, cpu)) {
         define_arm_cp_regs(cpu, sme_reginfo);
     }
@@ -9012,7 +9006,6 @@ void register_cp_regs_for_features(ARMCPU *cpu)
     if (cpu_isar_feature(aa64_nmi, cpu)) {
         define_arm_cp_regs(cpu, nmi_reginfo);
     }
-#endif
 
     if (cpu_isar_feature(any_predinv, cpu)) {
         define_arm_cp_regs(cpu, predinv_reginfo);
-- 
2.47.2


