Return-Path: <kvm+bounces-46222-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 773D3AB4246
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:21:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5CF623AE73A
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:19:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B90322BF3E1;
	Mon, 12 May 2025 18:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OQKT2UYj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665382BEC4B
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073133; cv=none; b=gKQNFVyHIs7RYgfKAVV8pNWNY9F6c3h4IUmUx2LIGhPW788/JUinPO0KYWYP39uS4kZjdvT6oeZHPl8ms6z2bJNWXABOB5w5oSZ2pvMlXTwmJU/fiCPE7SJxPzHaGrV+KB19SVuTiLrsmGl2XYceDQuf0yRShpY1zD7nLn1ELM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073133; c=relaxed/simple;
	bh=cDS4jJgO3G5zcB4Ty54Y3yKQCwoDp/kMMjJJoYKCWZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ud+DJ1lZikGQNrA1Sx8G0yFzY3pJxktAg7pA+7Feg0rNe9RYkkyd87ZCatREHKXLkPDVFqK1WBf/tKKRj77pHqJUzMbQwadDUcgPswVZytNLZMJhdh03kynF2MvOLZmBczSRTmKz78IF7xgyufg2Vqo/ItGxG47h14xRicjMO1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OQKT2UYj; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7403f3ece96so6704883b3a.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:05:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073131; x=1747677931; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ynPpe+7xoYBYdred6SBN6w9Y0IgzDdC2ZAA3L0jAu5s=;
        b=OQKT2UYjHrhnq3kYG/1lwucaVPQ+inWr/ft+IxfyZnw52loDcXyDiIe4RxtilrN2Kf
         bXRLF4+i5XiHcwnliywW2pm8nek27yBX79UP1mjkXysqKyipzu9L9VCEDC7xdxozApm0
         VAWTSzU3N0ebqTFvnOGBRLzzSLpQH41Q0mPpb7n7xlHC1ZcfsiBhx0IIJRZztyu8zCFA
         IjW9LrnRlW7GK90AtXP3NsI1lUC61Kg1TUj8nrT0Qugm2nXRAEmDKfkG3visUZgTOW+q
         tCouI2feYXlxCEgbZe0M6VSS206Y9GIUBerjBx6d444XJiILZlEhPNyRjw1RoOuV7hfU
         7aPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073131; x=1747677931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ynPpe+7xoYBYdred6SBN6w9Y0IgzDdC2ZAA3L0jAu5s=;
        b=MpCQBjylw4BGbpQ5OTfDkCfCB5KdUGpng2MPNgQ6m+5HdzqJ9VB8Vb9oL8lPxoXwRZ
         WEJvTWCFChuMiR67NoyEeHWH2aCG3nWYQ4Bfx5doI7BT49847X6g6vGieQ2QFyYH5bf3
         KS4Ei49+h1kp783pS/qEoPVFgGxoTp1R/UbGBzkeRpWLmWaMPM7fcd2GNzjr+gymJDqE
         EcvxzNz36jLTlODBAAOLFTqQ2UI7CW/XoYVS6U8NgXLvIPExfuHSHVwBY9zt1Js7q6M1
         9t6IQBldVsQEXYYRueG4N11V1Butm0owe0GmBEorMGHPma0WE23sNlA7w5iDgSei2P/j
         DbOA==
X-Forwarded-Encrypted: i=1; AJvYcCV5/jkXfAlDQvuHfv09rEpQeJ/XnPjHiT+Dyaj4miEJp62gwzekopoox7tZhF2r8Ig24js=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZkIl4dlXaGMU8qNpgELMD78Zpz0u0U4xwNnTHSJ1dvB2fA7Zo
	Djsl/K0RIXzoi3TQiKAHyXT9Lg9zKIo4DHhP8Hx3Cskh4f9kkw7WlfhUtjfiQaiOY59bpJ31ZcA
	3
X-Gm-Gg: ASbGncst/FZAMi6H+pcwf1Zsm5jWHcF/Gy0q0lG5GSCW8ieG2SoRpiGSoKKNN+9b927
	e//ZJGO64KWtHQ4sZzGQtXuPsLnDDH8oQer5UeLS7ZsTDWX5XaDa8k3GBqKrBu/drUSKSDL2Mrq
	ifjq5N8QKMcIQ2RRLllmoTBK4W1FkUzUtG+Crawd57gKEEgUVNWKSPoBuC8O8x7NFgS+OFgTf8/
	JZP2etFxPkTYmHSXQdhP5AO3nGcwFYXX97L+G806pMVbcc3XfNqqkp/2ExaldX+9m+/IOpQTFS0
	IGyud3SIMAHecvTcJbX2G+IcLJUtESiXuLCqQjJFM2uGZPI5/U6ySQf1yzqtAQ==
X-Google-Smtp-Source: AGHT+IHOIsMsSo9l7r0BSna7qr5cjMQFR4caBJLTeNrnfl8hHoLW5O8u+UyBnmKRl9wmyrnYPFvZiw==
X-Received: by 2002:a17:903:41c7:b0:220:be86:a421 with SMTP id d9443c01a7336-22fc9185f46mr214714525ad.38.1747073130756;
        Mon, 12 May 2025 11:05:30 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22fc82a2e4fsm65792005ad.232.2025.05.12.11.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:05:30 -0700 (PDT)
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
Subject: [PATCH v8 21/48] target/arm/helper: expose aarch64 cpu registration
Date: Mon, 12 May 2025 11:04:35 -0700
Message-ID: <20250512180502.2395029-22-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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
index d2607107eb9..92a975bbf78 100644
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


