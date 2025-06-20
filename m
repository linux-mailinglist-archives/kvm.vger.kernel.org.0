Return-Path: <kvm+bounces-50075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BCE7AE1B7B
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:08:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 705D616E79F
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34DA528C2CA;
	Fri, 20 Jun 2025 13:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jyty51kI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7E3D284B3C
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424880; cv=none; b=mwuG278QEIT9nAAnXqPzltNBy9PwBa+pJY15AKL274zeTdBgCHzNJHpomxeHPROmmgOjXOaBs5FlKjaaFfoOgGXMPPtlHgMX9nqS3JnoHYTV7KNTMwW2Aoh2r8oHN5nMuWn9xwkVYdYeDNDF1kO7GiG2mSzI9qCHy7XaJpaQwkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424880; c=relaxed/simple;
	bh=f8NvzMqKx8UHnEdJOyorF06BZHlOzCa768Ga0ywIB7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mOVwW9/91CH95QrPyV1k7q3FULbYOor0Mpyvw8Kr8lXcVrA7wLebbUWZrLSAFcmAkAwlmDig8ESKhcFJFNoEG4+kGaBRfUm8x4bMFGHMEQlk65wH1S8UU3sPuhAZ5T95rTZGlICzGQghN21fvapQwBfd6WFpGMN9wbXnm5218lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jyty51kI; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-453066fad06so11855015e9.2
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424877; x=1751029677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qyHQEfn6inWyZRMUVI/8b1HegzN318xDx/IKxFDD3c0=;
        b=jyty51kIjJ/30CR+fxf5ckHQNbUgNdz4pPpWtlJZz5icgeq2HWgXA5tLrBeQeHM3DK
         HraoFq8XdkvDpmHWC34hK+Zv/8PkUu3K5sF97wGCY0ELadaI2fB4Jq5TQ8uY8Ul/gMq3
         gKb/5qTegh/eboKR9innyTKCQR3VaMMAsCl7/jjOoqx+/Mpx632LRTI6VycoYUupvE2g
         Neg7Atud45eow0DAifkmSixBPXv0dQQ9+kSp/ITZkTQiXUtWfbiotjsIcMe14W1uJlgl
         VzPUeYrlOo8HOaMz8Cea0ceLmbGBbsXNUftxueOps+n/qaTwwlWdn94TwpxMgUtMRDCP
         oX2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424877; x=1751029677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qyHQEfn6inWyZRMUVI/8b1HegzN318xDx/IKxFDD3c0=;
        b=qLdFi7YD87yFMzV/RdtFXOAsVvQOurpWjh2mWvo7Z9S5qU9Q+Tpk5BjtZDxmAzMGiV
         AzG5h5ltKow9fhjejBCfoJ8mcXB4JVs3DhNhJnPzCsx5PHKPwAhKN+wvk+2aLA8wxmXm
         e9Xov1C0ek3VV4+0pm8NFDEHfEF2XF+CgZSH9ga7o5CeOo4ir8jcth+NctL6tRTnEtxu
         sRrZ10Vf4YkhoOPV6EsNGXj00eNMnCxaMwUWPPmeO0JYKsTGGydL08eo8uGMVBq+yMZf
         q1Xh00mLGp/Y7aqT/0+s9VZGOEHzfMWhKRcwnftqew44MDxqx4cVUE+d/zfQzT9eRb0Z
         LOFw==
X-Forwarded-Encrypted: i=1; AJvYcCXuFtxPb2/BUIKLzmE7BTSQfsRR6IjgBTYEXiQC6ndtW9tqbPq7wB7JtN7QQx/yjXkxn9c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1Bef5hpEHNsZNUkp2N/Jz6rA2vY3j4WcX28AJXtmG9eERaVWr
	TGkdhzrCsO3XM0B8xet3nPPNuPiHayMazzcy7LUqq1kbN8MxtAPo5uz5hVDP4cu2LIA=
X-Gm-Gg: ASbGnctA4kpnjLm6HPUuPZyzHmVfvfwpP8frcJNxoTqvStyOF/GxQzGWGeHhZpUaaU8
	VCIlpEV6+lHcQhH6BUITgMchfC9qSCgLXcSdOwadMKtbtLlUdWfc+GG2gMf/3dntPJFZxHF/oLK
	LALo1a/xlsXNzP+OwCoXP6IaQFI170l4hwuNkkL9Q70MYU8ObcXMsDKNJzXgeE5TunGRrJqpQ7B
	8f66bgfqog460WTFYs99nlI10phT83jA/Q49hH86MnGVpNjTrNBhSdFYhz0lFX85uQSkYyuTcob
	bkdwGNni7jJVe1VBzE4SzE70J2Lk0Y27PBrutGlL7ynHOT7rPm3TvpvnTT4E1Htj4GQlYvsqQZX
	gVTct3BufEvYrbvffJt3twpMYZylkmNkyK4D4
X-Google-Smtp-Source: AGHT+IGkXs40WMIJKGNMuEiJnfxX7/z7m/pHzk9ne+NytzMGvZpK0RzUyqBP8SLCEpCnawa9dPBjrg==
X-Received: by 2002:a05:600c:3b14:b0:43d:2313:7b49 with SMTP id 5b1f17b1804b1-4536539c469mr27259205e9.12.1750424876897;
        Fri, 20 Jun 2025 06:07:56 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535eac8c16sm58396345e9.19.2025.06.20.06.07.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:07:56 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 08/26] target/arm/hvf: Log $pc in hvf_unknown_hvc() trace event
Date: Fri, 20 Jun 2025 15:06:51 +0200
Message-ID: <20250620130709.31073-9-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Tracing $PC for unknown HVC instructions to not have to
look at the disassembled flow of instructions.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/arm/hvf/hvf.c        | 4 ++--
 target/arm/hvf/trace-events | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index cc5bbc155d2..d4c58516e8b 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -2071,12 +2071,12 @@ int hvf_vcpu_exec(CPUState *cpu)
         cpu_synchronize_state(cpu);
         if (arm_cpu->psci_conduit == QEMU_PSCI_CONDUIT_HVC) {
             if (!hvf_handle_psci_call(cpu)) {
-                trace_hvf_unknown_hvc(env->xregs[0]);
+                trace_hvf_unknown_hvc(env->pc, env->xregs[0]);
                 /* SMCCC 1.3 section 5.2 says every unknown SMCCC call returns -1 */
                 env->xregs[0] = -1;
             }
         } else {
-            trace_hvf_unknown_hvc(env->xregs[0]);
+            trace_hvf_unknown_hvc(env->pc, env->xregs[0]);
             hvf_raise_exception(cpu, EXCP_UDEF, syn_uncategorized());
         }
         break;
diff --git a/target/arm/hvf/trace-events b/target/arm/hvf/trace-events
index a4870e0a5c4..b49746f28d1 100644
--- a/target/arm/hvf/trace-events
+++ b/target/arm/hvf/trace-events
@@ -5,10 +5,10 @@ hvf_inject_irq(void) "injecting IRQ"
 hvf_data_abort(uint64_t pc, uint64_t va, uint64_t pa, bool isv, bool iswrite, bool s1ptw, uint32_t len, uint32_t srt) "data abort: [pc=0x%"PRIx64" va=0x%016"PRIx64" pa=0x%016"PRIx64" isv=%d iswrite=%d s1ptw=%d len=%d srt=%d]"
 hvf_sysreg_read(uint32_t reg, uint32_t op0, uint32_t op1, uint32_t crn, uint32_t crm, uint32_t op2, uint64_t val) "sysreg read 0x%08x (op0=%d op1=%d crn=%d crm=%d op2=%d) = 0x%016"PRIx64
 hvf_sysreg_write(uint32_t reg, uint32_t op0, uint32_t op1, uint32_t crn, uint32_t crm, uint32_t op2, uint64_t val) "sysreg write 0x%08x (op0=%d op1=%d crn=%d crm=%d op2=%d, val=0x%016"PRIx64")"
-hvf_unknown_hvc(uint64_t x0) "unknown HVC! 0x%016"PRIx64
+hvf_unknown_hvc(uint64_t pc, uint64_t x0) "pc=0x%"PRIx64" unknown HVC! 0x%016"PRIx64
 hvf_unknown_smc(uint64_t x0) "unknown SMC! 0x%016"PRIx64
 hvf_exit(uint64_t syndrome, uint32_t ec, uint64_t pc) "exit: 0x%"PRIx64" [ec=0x%x pc=0x%"PRIx64"]"
-hvf_psci_call(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3, uint32_t cpuid) "PSCI Call x0=0x%016"PRIx64" x1=0x%016"PRIx64" x2=0x%016"PRIx64" x3=0x%016"PRIx64" cpu=0x%x"
+hvf_psci_call(uint64_t x0, uint64_t x1, uint64_t x2, uint64_t x3, uint32_t cpuid) "PSCI Call x0=0x%016"PRIx64" x1=0x%016"PRIx64" x2=0x%016"PRIx64" x3=0x%016"PRIx64" cpuid=0x%x"
 hvf_vgic_write(const char *name, uint64_t val) "vgic write to %s [val=0x%016"PRIx64"]"
 hvf_vgic_read(const char *name, uint64_t val) "vgic read from %s [val=0x%016"PRIx64"]"
 hvf_illegal_guest_state(void) "HV_ILLEGAL_GUEST_STATE"
-- 
2.49.0


