Return-Path: <kvm+bounces-51441-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34564AF713B
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:59:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0D283BC756
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C972E3B1E;
	Thu,  3 Jul 2025 10:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YM2JhM+p"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E642DE70E
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540348; cv=none; b=gmw6aYOdc8em9WdImTmV3AZZl/ZEJTw0l8X4rmgpeGhTf0d+Kn5Ip0Q4B3IyOhqQ93LCigYFT/oVnqM8uClfDFRF4dTrIimW9GhW+3gL8Um9Ni+vtS0oLpB8btdR0WJmMH1jQJmvZJGyMcU03FbnGy9+uDZeWYE5cb7eTwJiIso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540348; c=relaxed/simple;
	bh=x6Kn9WCjk7y549R0hbClnz9/lmWD6DS4tFjyCnYfDrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z2FeBUfQEOEqUZpdaTekmd+ily4cDVpsXvLWrIhTQkiA9BDV1LamRZBy4D5B0G1pFwaZ9/UM84nJuv7hO2F1gFvbJ/gfYiEvvgPFCMkgdCIkXzdEL8j8/C0dnhQf/+/BJtTXtu7FTqC6z9q6bpVIE2kFupgJnZRldPFq4Y5r7t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YM2JhM+p; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a4f379662cso4654275f8f.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540345; x=1752145145; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rbpcjy4o5ZUQnpuXjuYjR5B0wNodIi5DdAoNAkyy2SM=;
        b=YM2JhM+pE1ZWb89iwB5DU3QXqhdYzBaHQZ71JG9b/CmfLhVSKxL3VoSQ49Ns3TADrH
         VuoTgmBXOEjQyavuplRQSMvJ81qXuBih+FTWeIUpnte/jGWwvN0KuHdvQSz/on3OFTid
         /Bp4FPLyVFvp7F7v5bkHjmUgWJrhBWYP/d3FDmSpOawZDnUQ70NSuG2fAHTGuIeh8sn1
         75Q0zX85FL8BmGSZuVfZVxhgNtd7Ci46S0ojMJ6zvY8mq1oLHSan9GUlpT29Uz30fIlp
         Invg4ZLEnGKBnvNfNtHZo8AGVNRPemneLRc9Vk7OaFjUiAMMPmBTX4CCIxnsDxR7mRDN
         EM3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540345; x=1752145145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rbpcjy4o5ZUQnpuXjuYjR5B0wNodIi5DdAoNAkyy2SM=;
        b=qL83igWg032cveDkZ4wKnqXhI/vehIZTyoublnsO6ZkLjTgkN//xS+Mhfmhhyz4QE9
         pvYYoDzGlha/Nso0d9T24NjM0G9t/edJQA4Tj+77I3JbmEOD+BRovURFOQ4uV8Fc1wvs
         QE5488HqpRrO1WcpFvdOI5Rq2x+kPy7lm4hSETWditNTycX2kQyG6G3/PDHyCeABZovM
         tEQ3dKepNtNZjiI4a4giBLg7aE39jmUAhTZuDoGg3SJW1E12lHogzcY58o9Ffmru1q4s
         L1lBYwIcJOQaABM9jwVLv4uRdZ+a7EXWHZR0gkr9Yr/uWeX6KMDOfai/U1p6rjIVRj/P
         CVrw==
X-Forwarded-Encrypted: i=1; AJvYcCVpcX9YAmaaBckWQrU5+cjOPqTi0yorMhPDo9GKX8JMutBDsyAQJjW6LI9oRFdWSr8GYqY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzj/Jh6MUU+oL9Qdspoc/xrbopT5yV3gZRWl1Tf5YNb3GlmDa7t
	5AxDJqNQhmsv6RvV1o5PLUpWQGzHhjeKPYTlT0YD3NA4tifGkBV3zVRtOic3n1DT6x8=
X-Gm-Gg: ASbGncsSeGDmh62Z/mVEtkbxWZ2rdOJyWBNwDwsETN9dDbG4kypSWYkGQiA7H00MgHW
	6qjEcylkwklSNNLm3JiNwOGwOHiCnGB3xkTFOeUddqP+xMJg8buQAMaYBn/U8WpLhUMfpevzY5m
	2ZOjrmM1ABdRjEwc3nq5ixo/3Ni4JX5DQlaU5zYcK8/cCNUgIkF3YJzTj83FGth6lheLpGw7kCa
	m+gyGy9zopjqXqN73k7adoWSOaK8hnM2VePQPtLG/MjnthoJdNDRcSIlF8+FSAe7ck8anpH0va2
	FfZSxWlfQBOLiDggw82vZf1MDbHyvaCa/9BJch6x0N1fCTT4S5hb4sRH6r3PvS3vWT9eRHAriPb
	AaynC1d8lyWI=
X-Google-Smtp-Source: AGHT+IGYxtS1oEgE+wPV64Af3YSVbtZnoBNIR61h6tPaEQk84SaFj2CgxdVoLgHbVl+oBToAAhLlkA==
X-Received: by 2002:a5d:5f4e:0:b0:3a4:d6ed:8e2e with SMTP id ffacd0b85a97d-3b200b4673amr4801917f8f.41.1751540344516;
        Thu, 03 Jul 2025 03:59:04 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3aba76e40c0sm14278820f8f.59.2025.07.03.03.59.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:59:04 -0700 (PDT)
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
Subject: [PATCH v5 38/69] accel/hvf: Replace @dirty field by generic CPUState::vcpu_dirty field
Date: Thu,  3 Jul 2025 12:55:04 +0200
Message-ID: <20250703105540.67664-39-philmd@linaro.org>
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

No need for accel-specific @dirty field when we have
a generic one in CPUState.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 include/system/hvf_int.h  |  1 -
 accel/hvf/hvf-accel-ops.c | 10 +++++-----
 target/arm/hvf/hvf.c      |  4 ++--
 target/i386/hvf/hvf.c     |  4 ++--
 target/i386/hvf/x86hvf.c  |  2 +-
 5 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/include/system/hvf_int.h b/include/system/hvf_int.h
index ea6730f255d..a8ee7c7dae6 100644
--- a/include/system/hvf_int.h
+++ b/include/system/hvf_int.h
@@ -62,7 +62,6 @@ struct AccelCPUState {
     bool vtimer_masked;
     sigset_t unblock_ipi_mask;
     bool guest_debug_enabled;
-    bool dirty;
 };
 
 void assert_hvf_ok_impl(hv_return_t ret, const char *file, unsigned int line,
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index 319c30f703c..c91e18bc3dd 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -79,15 +79,15 @@ hvf_slot *hvf_find_overlap_slot(uint64_t start, uint64_t size)
 
 static void do_hvf_cpu_synchronize_state(CPUState *cpu, run_on_cpu_data arg)
 {
-    if (!cpu->accel->dirty) {
+    if (!cpu->vcpu_dirty) {
         hvf_get_registers(cpu);
-        cpu->accel->dirty = true;
+        cpu->vcpu_dirty = true;
     }
 }
 
 static void hvf_cpu_synchronize_state(CPUState *cpu)
 {
-    if (!cpu->accel->dirty) {
+    if (!cpu->vcpu_dirty) {
         run_on_cpu(cpu, do_hvf_cpu_synchronize_state, RUN_ON_CPU_NULL);
     }
 }
@@ -96,7 +96,7 @@ static void do_hvf_cpu_synchronize_set_dirty(CPUState *cpu,
                                              run_on_cpu_data arg)
 {
     /* QEMU state is the reference, push it to HVF now and on next entry */
-    cpu->accel->dirty = true;
+    cpu->vcpu_dirty = true;
 }
 
 static void hvf_cpu_synchronize_post_reset(CPUState *cpu)
@@ -156,8 +156,8 @@ static int hvf_init_vcpu(CPUState *cpu)
 #else
     r = hv_vcpu_create(&cpu->accel->fd, HV_VCPU_DEFAULT);
 #endif
-    cpu->accel->dirty = true;
     assert_hvf_ok(r);
+    cpu->vcpu_dirty = true;
 
     cpu->accel->guest_debug_enabled = false;
 
diff --git a/target/arm/hvf/hvf.c b/target/arm/hvf/hvf.c
index bd19a9f475d..44a831d004f 100644
--- a/target/arm/hvf/hvf.c
+++ b/target/arm/hvf/hvf.c
@@ -813,9 +813,9 @@ int hvf_put_registers(CPUState *cpu)
 
 static void flush_cpu_state(CPUState *cpu)
 {
-    if (cpu->accel->dirty) {
+    if (cpu->vcpu_dirty) {
         hvf_put_registers(cpu);
-        cpu->accel->dirty = false;
+        cpu->vcpu_dirty = false;
     }
 }
 
diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index bcf30662bec..c893aaac1b0 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -738,9 +738,9 @@ int hvf_vcpu_exec(CPUState *cpu)
     }
 
     do {
-        if (cpu->accel->dirty) {
+        if (cpu->vcpu_dirty) {
             hvf_put_registers(cpu);
-            cpu->accel->dirty = false;
+            cpu->vcpu_dirty = false;
         }
 
         if (hvf_inject_interrupts(cpu)) {
diff --git a/target/i386/hvf/x86hvf.c b/target/i386/hvf/x86hvf.c
index 2057314892a..17fce1d3cdd 100644
--- a/target/i386/hvf/x86hvf.c
+++ b/target/i386/hvf/x86hvf.c
@@ -427,7 +427,7 @@ int hvf_process_events(CPUState *cs)
     X86CPU *cpu = X86_CPU(cs);
     CPUX86State *env = &cpu->env;
 
-    if (!cs->accel->dirty) {
+    if (!cs->vcpu_dirty) {
         /* light weight sync for CPU_INTERRUPT_HARD and IF_MASK */
         env->eflags = rreg(cs->accel->fd, HV_X86_RFLAGS);
     }
-- 
2.49.0


