Return-Path: <kvm+bounces-51468-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E0FAF717E
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:05:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DB564A1DDF
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:02:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC6FC2E499C;
	Thu,  3 Jul 2025 11:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DjOBLpn8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEAB2E498B
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540490; cv=none; b=V6hdv+PrutydZhGYgU8g+vFOJShmkxRhvpqJtvyh3ZsVvoaSmv3oBgbTjCj3r9m/G3gs9apBb2ivyWC+U4phTsUnVU/67Jz/9y6iLVE94whXtwVaGxJ6CMUUvDiGXkHeShcxVHfX4UH/jr/e00gfXSMtkUVqNl1A48CLiesdk6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540490; c=relaxed/simple;
	bh=o5TPexLQILKzEF2sAOp697m5JmBDmH929TXWrvy0EvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f6R7cvZrtrcCv5ngPg8eRjkVAFkNXE0fDQbTVZijKEY42EPUUWWML8+JTobR8TTop0D4lLAxvacoLr5+s7LIHAsnL7xzlPl8y5Y54oRJTZb/CnMu3e4XIWnJ98nR2iCt4dfHpCQ8TTen474xsEkBycU6r1K0YK9zqvWrPxd8YMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DjOBLpn8; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-451d3f72391so57659555e9.3
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540487; x=1752145287; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iVv77+T3+ACMfJtq+FwRrQOYxT41VnoDNDgY/IfZvIE=;
        b=DjOBLpn8KoN3I61pFgb0fJS+tTaR0rb+etuFv3QVvxYm7NBEsQxLEbNyMlGUW5+CHb
         AEW8yu5oeoLnmkxv+UPFOKf5DiGIfrpNoS2plYr9F8XMhOmJ70P6ukhezk+YRDRe8kee
         S5Ee1uow/UJrCA/ACHkZDblpCEATZXJ6px1h8c40Pg2AlZ0eebc3VwbPU3GFIIDVvt/e
         BAqan5o0HmKZ6VXLZwWa2lgCILHCpN7aiOc/xBSf3Iuz8xnW9YQS73uDqqoyK1cAqY5/
         0ndstNs1yQ98yT9T+L9nwRwGw5l4/OBjhRsi+3xYq+FWx60c4toaYMDe52HEV/Zi3Rit
         MdqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540487; x=1752145287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iVv77+T3+ACMfJtq+FwRrQOYxT41VnoDNDgY/IfZvIE=;
        b=XPAx3ULhUWSpUdBxmHZpu9eXLhIdyIHdMz50OMaKDGoByg3iGdWR+Oni2nTvnpS0uw
         obNrUptck4yLJOAMLufFCYBpypvjOUDJY1vnvza6GE2H9Pr2kWGpfKVliQrLaGaWoMGy
         1LSbtNQqwvbZRvP+ZgpfnnYztzOUVagyWWOK4ramrg6bO8vmP6a3CfN8rIdNNq5+1Y6i
         0kdqz98umz5oDGcnNysX6WwGog1MpTHBUmdd+UtmlyTlomfEhmf9hZgQs4eK3NjjYJ1r
         bRv5CpcQ5MV7jyr3m9g1tRCHXaE9OsMm0Oii8RKGxCL3WIUbirT1IMcRP9721nbNYtuC
         5onw==
X-Forwarded-Encrypted: i=1; AJvYcCUI4E06VZBoYoNUPmzlLQ+Bt5ipW8q3YY2er3FWw4DdGHC1QxHtBW6DJC1WGvSiRIWIZtc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCvPABibX+w/g05sDXyhAigU4OQdCLDSTHNojhMOwca425HgAT
	ME78wfozWVHjt5Xt+8hMC2brHY+K2WcLH9IWA0/e3BFmffZ4abS1el+JYbOBRW23bXE=
X-Gm-Gg: ASbGncun5+pfgONeq6ZxXC+sGukc2a2xbZYDLhq/Wl27qtCmsTYYm8YqkMWaF9512wL
	RqNN1oUhxF0o4b/SSrAznc3bEU1H5jkifA3b+w8dNshAbHODVph7LNG7BID3hS9bfzkP52WQkOF
	q+vtUTP8HT5+kc0PcDV7q4beLpRykdaFOtCgMy1uWEnlZSrluz/ogGyA0kcOH7LTrZWrh0u/tn5
	C0xLkKlUI/ShvklXNheCX5cAFYDDATBOqP+DDmwt3sxcZyjpDQ84J4K3HbN+Mz8avDERXVddSRi
	o9JJ8G7IDdbbm1M/v54te0t12lbzLplH+CpUYWUSKg7SM9P8Bal0z6mygBYtNWVzqwKP7hcEIDn
	AiiuERzh825k=
X-Google-Smtp-Source: AGHT+IGA9I3qbJr9+lDfQNbKuMpUBqcBmxbud/aj7IOWUecC0jRGcLwEZ5BDaM+WV1v8cJyY9B2alA==
X-Received: by 2002:a05:6000:2184:b0:3b3:e29:bda7 with SMTP id ffacd0b85a97d-3b32b14591dmr1811101f8f.9.1751540487431;
        Thu, 03 Jul 2025 04:01:27 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454adc71a96sm11323625e9.24.2025.07.03.04.01.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:01:26 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 65/69] accel/tcg: Factor tcg_vcpu_init() out for re-use
Date: Thu,  3 Jul 2025 12:55:31 +0200
Message-ID: <20250703105540.67664-66-philmd@linaro.org>
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

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/tcg/tcg-accel-ops.h       | 2 ++
 accel/tcg/tcg-accel-ops-mttcg.c | 4 +++-
 accel/tcg/tcg-accel-ops-rr.c    | 4 +++-
 accel/tcg/tcg-accel-ops.c       | 7 +++++++
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/accel/tcg/tcg-accel-ops.h b/accel/tcg/tcg-accel-ops.h
index 3f8eccb7a7f..a95d97fca29 100644
--- a/accel/tcg/tcg-accel-ops.h
+++ b/accel/tcg/tcg-accel-ops.h
@@ -20,4 +20,6 @@ int tcg_cpu_exec(CPUState *cpu);
 void tcg_handle_interrupt(CPUState *cpu, int old_mask, int new_mask);
 void tcg_cpu_init_cflags(CPUState *cpu, bool parallel);
 
+int tcg_vcpu_init(CPUState *cpu);
+
 #endif /* TCG_ACCEL_OPS_H */
diff --git a/accel/tcg/tcg-accel-ops-mttcg.c b/accel/tcg/tcg-accel-ops-mttcg.c
index 96ce065eb59..4de506a80ca 100644
--- a/accel/tcg/tcg-accel-ops-mttcg.c
+++ b/accel/tcg/tcg-accel-ops-mttcg.c
@@ -79,8 +79,10 @@ void *mttcg_cpu_thread_routine(void *arg)
     qemu_thread_get_self(cpu->thread);
 
     cpu->thread_id = qemu_get_thread_id();
-    cpu->neg.can_do_io = true;
     current_cpu = cpu;
+
+    tcg_vcpu_init(cpu);
+
     cpu_thread_signal_created(cpu);
     qemu_guest_random_seed_thread_part2(cpu->random_seed);
 
diff --git a/accel/tcg/tcg-accel-ops-rr.c b/accel/tcg/tcg-accel-ops-rr.c
index fc33a13e4e8..9578bc639cb 100644
--- a/accel/tcg/tcg-accel-ops-rr.c
+++ b/accel/tcg/tcg-accel-ops-rr.c
@@ -192,7 +192,9 @@ static void *rr_cpu_thread_fn(void *arg)
     qemu_thread_get_self(cpu->thread);
 
     cpu->thread_id = qemu_get_thread_id();
-    cpu->neg.can_do_io = true;
+
+    tcg_vcpu_init(cpu);
+
     cpu_thread_signal_created(cpu);
     qemu_guest_random_seed_thread_part2(cpu->random_seed);
 
diff --git a/accel/tcg/tcg-accel-ops.c b/accel/tcg/tcg-accel-ops.c
index 780e9debbc4..6823f31d8ad 100644
--- a/accel/tcg/tcg-accel-ops.c
+++ b/accel/tcg/tcg-accel-ops.c
@@ -77,6 +77,13 @@ void tcg_vcpu_thread_precreate(CPUState *cpu)
     tcg_cpu_init_cflags(cpu, current_machine->smp.max_cpus > 1);
 }
 
+int tcg_vcpu_init(CPUState *cpu)
+{
+    cpu->neg.can_do_io = true;
+
+    return 0;
+}
+
 void tcg_cpu_destroy(CPUState *cpu)
 {
     cpu_thread_signal_destroyed(cpu);
-- 
2.49.0


