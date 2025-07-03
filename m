Return-Path: <kvm+bounces-51410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18D3BAF7114
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:57:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94A503B55E7
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:56:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 894732E339D;
	Thu,  3 Jul 2025 10:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wxg1mf7K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01FEB29B789
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540182; cv=none; b=nki8iC/PVllEM+JbGxGL7EQLEBssrcZsM5bcXNkq4IBRfBnXp/381xrIG5F0Ayoi/eIXtjWgOISQ53J6rTbl5/B0EE0tPuy6BGPxkcUNsl7t4DPt96c/zEAAL0GmyrM5HCJX7cHcDYX2mUDrRe8mQHkIu45FtKP0r2aSTnf/cvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540182; c=relaxed/simple;
	bh=aZdC9jIPBh5iqEmR+IhQnMvRxE/gSHQGWaivF2jVgeQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KMrORQA1pCF/ZQRjp9Mpnzt617MmOjn3lBxU9DdXrZcXH991mc5wB3BfoIQPeAPBPxRaNpjBu8InDVNXU1C5ICBe2ACQby3jN8PLExkNm69T9wtYB64E17GK9v6+lNXmo1OIIZ7faRuWNbYf8z4EMagIJON4UmYXNkAWw7i4qF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wxg1mf7K; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-3a582e09144so3866325f8f.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540179; x=1752144979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOy/hh8CdzW8JKLOeQuyvYboWC5TjWykREm1ryjsqd8=;
        b=wxg1mf7KZQS6ltV6qyCj1gwKAUbj998RklCLT7tfJf2Sz/PC7KD3LzScJ9fssy3FjU
         HhL+en5gN0V5aVMibAYmjt/ElMRf5tAyUV8Q1tI28SUMwU1OGblSuoG7p3WCG2rVkhqs
         LrsrLPESYGMbUKSgvS8L9+hAJu+WQ/5oZ/C/qP/QAhdDoYKoahVEpC1zrl1Mmrc8cYl2
         ApMWeOUy6XXoxj1sjszu/c6KhxCIq3LRjhZKwh7pOH3ePF0IUgYEt462o+al7aRMV4yG
         tDk4K/RUUppBw4pi1US1b+6RU7Ms8A++pUKHub78LgzSSCt9+X55rd2xnUrrWMG8KJg1
         4+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540179; x=1752144979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOy/hh8CdzW8JKLOeQuyvYboWC5TjWykREm1ryjsqd8=;
        b=Rm9yp25ZxTTpV+/ulgWIambMdXvlVOC7j7DJ+bEGP4x7OfWjJIrVk22UJu+Pzwbq61
         keiNJP+Qy8s3hNuR3ih+rHFD8gbx74DUuJVJHnenOZOCGzfTtPkoLsRxQT689DpG4YsP
         0v/LUZVNL3+4lbNJYMIfGITz9JOGB7LLDe6l4WtePlixP8AxIUpX0QRIYhxSXGLT1S+Z
         3ymKxx/FL8ZBdj1n/8/s6nLbKNpKatgWlQZxL+lS2XCof7mk1A5rWQxrriMk509w0FK/
         BFNfhfhpSo86Yl1LpSVr8kViioLM+3Vkn3m/zB9uJLHkGlJa1HayVWzdCYl2lwFBe4iH
         Sruw==
X-Forwarded-Encrypted: i=1; AJvYcCUVObROP7YfuQxNWS8cV95uixiDgJAhxqDFcSEy6eNlz187iDOeRBlenn5BuhKAbm0hqHY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+XEsiF39b0lU+J9oZlNN6rSrnE1aROTcvQIHHKFs9sLCNCekb
	jI8Ynz0YWmzLczkx7GT7YZ21AsaN9BHXpLzYp3svIbJ7Ja0fMpwshZVj7/DIUj86L+8=
X-Gm-Gg: ASbGncswVX3rEtTYESkGTnZNVA3OR98QnxM7u6XsuuybXUI0k0vGpSkvv+VsZ/sPdwf
	yvU0eESxSrKeMkTK1SpJqtwQsEGk1RcsEEGheNV4ylLwQbRlmbL/lKDzz8eHHurBy6pTjwTCy3z
	NWA8q2NwafKbdoZhh34tLjbw9lL9c1yu2nGqWh9F27+MiDF5gN1s5tPZU00cUz1F3Uos19bqVZ3
	STuyr3gT5NOz9WK2UWUQxJzQ2qGesbzD9m/ievr5CuIs9iBPVaPVseW89BL4Mklux4VvBvu23AV
	WHDs5lekyFZcveX8HBjRhpWZBenCch9y4RA71dPMHlO3qYYJErU6DcZE8/XDNvhAECs7EmESWw7
	KaIvxTmJvVQg=
X-Google-Smtp-Source: AGHT+IG7ipjun04dtTdCOm6oy7eUWWjsKtRV5HObOuItyYoks+uXkUq2AKmszEHPvw4ntsxZJLkEbg==
X-Received: by 2002:a05:6000:2c0b:b0:3a3:7387:3078 with SMTP id ffacd0b85a97d-3b1fe5bf382mr5188202f8f.4.1751540179252;
        Thu, 03 Jul 2025 03:56:19 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e595d1sm18529515f8f.71.2025.07.03.03.56.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:56:18 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Mads Ynddal <mads@ynddal.dk>,
	Alexander Graf <agraf@csgraf.de>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org
Subject: [PATCH v5 07/69] accel/hvf: Add hvf_arch_cpu_realize() stubs
Date: Thu,  3 Jul 2025 12:54:33 +0200
Message-ID: <20250703105540.67664-8-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Implement HVF AccelOpsClass::cpu_target_realize() hook as
empty stubs. Target implementations will come separately.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/hvf.h      | 3 +++
 accel/hvf/hvf-accel-ops.c | 2 ++
 target/arm/hvf/hvf.c      | 5 +++++
 target/i386/hvf/hvf.c     | 5 +++++
 4 files changed, 15 insertions(+)

diff --git a/include/system/hvf.h b/include/system/hvf.h
index a9a502f0c8f..8c4409a13f1 100644
--- a/include/system/hvf.h
+++ b/include/system/hvf.h
@@ -72,6 +72,9 @@ void hvf_arch_update_guest_debug(CPUState *cpu);
  * Return whether the guest supports debugging.
  */
 bool hvf_arch_supports_guest_debug(void);
+
+bool hvf_arch_cpu_realize(CPUState *cpu, Error **errp);
+
 #endif /* COMPILING_PER_TARGET */
 
 #endif
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index b38977207d2..b9511103a75 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -588,6 +588,8 @@ static void hvf_accel_ops_class_init(ObjectClass *oc, const void *data)
 {
     AccelOpsClass *ops = ACCEL_OPS_CLASS(oc);
 
+    ops->cpu_target_realize = hvf_arch_cpu_realize;
+
     ops->create_vcpu_thread = hvf_start_vcpu_thread;
     ops->kick_vcpu_thread = hvf_kick_vcpu_thread;
 
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index 7b6d291e79c..4c4d21e38cd 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -1081,6 +1081,11 @@ int hvf_arch_init_vcpu(CPUState *cpu)
     return 0;
 }
 
+bool hvf_arch_cpu_realize(CPUState *cs, Error **errp)
+{
+    return true;
+}
+
 void hvf_kick_vcpu_thread(CPUState *cpu)
 {
     cpus_kick_thread(cpu);
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index 99e37a33e50..28484496710 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -367,6 +367,11 @@ int hvf_arch_init_vcpu(CPUState *cpu)
     return 0;
 }
 
+bool hvf_arch_cpu_realize(CPUState *cs, Error **errp)
+{
+    return true;
+}
+
 static void hvf_store_events(CPUState *cpu, uint32_t ins_len, uint64_t idtvec_info)
 {
     X86CPU *x86_cpu = X86_CPU(cpu);
-- 
2.49.0


