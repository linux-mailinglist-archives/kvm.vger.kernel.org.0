Return-Path: <kvm+bounces-51470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 357F2AF7183
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:05:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67CE34A366E
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D360E2E49B4;
	Thu,  3 Jul 2025 11:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="UfviE0K+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE2B2E498B
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540501; cv=none; b=Bnlen+GPW3k1IjUiInnQiJqcD2f8x2X4KT9mTm1lVTrfPidZVYSaUt8VkROblXEiHFDCGwVPjaBIy/I1WiSDMngyd0w/8h9ubm8dAz5hnuYZLrAJsjJhpenZt+/JL2SPBuek/o6VKej4M7aQzlFmOFoj6atTgKCpMKaCAC+xjQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540501; c=relaxed/simple;
	bh=8qSaES+FNI1x03r8nQpI+xmPS5tajfVLbMsr4b5i3O0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XIkEobtCWSAdB8/tAnmONj0rPgFA6h7gjWJJthunAw3ysCfpejZrV0urtelbmcyghzeleknFjrgPorN4Sa7+vwnqhR1YWgNSFu84Pw7ji/STuMtCG/KeYAXLA1aRAY/QMpPvoidJXA9GzDyrpyjJCc48UF/vY5yCu1LKE+d5zZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=UfviE0K+; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3a4fd1ba177so623886f8f.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:01:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540498; x=1752145298; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OlVw0qlAe+vja7bYyOtLn/rW8RkSmVUiIwefJ7c8zZk=;
        b=UfviE0K+Iq2KIcV0H9aGCc9NeaUcoWTSgFNnO+oeaQ8VR9qQ7MAWaVkil8aOvxyAMM
         XY8tDkUzMk5Gm1Nt/1T3rDi+xCvJx5TeZWoj8cw72aFL0ssFPEBssCOxbi0LrJDPnZJ3
         5TaTolOknr1dbfUeLZE4cXjO4oJB1B7Nm9whPC5N5i2lgVxLYLecbvIAd+T5olGJmYh/
         fPa2u5rCTuEmZzoJ1p11J7LdW8rkKeijUYrN1pxULpoyK86kwjyZrhbid+NiAAf7dWkH
         QedQ6U2BC2V4EwwTeXpsfBeoO2qrDv8XrwsqcKvvIg3WD7WW2SsFhkZDIQOMYvsybktb
         bfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540498; x=1752145298;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OlVw0qlAe+vja7bYyOtLn/rW8RkSmVUiIwefJ7c8zZk=;
        b=ulVqIU6plfjrWP5guT963PwK6Ma9DdsQu8aRa9g3qVmP68TisNmU7ZMX5V4VXx5A2y
         nfIiTfGiTdTEHHARVLpPwIdgRkbbMZHcfmi5pnd7Rq4l/UZeE0cYjMGaEh2VzGkjDwsb
         QKV2DaNT1cU5BYXZ2pZqElsqQeZwQZy1imHj8V/MS+OrbjX4rg3WEbdjBe4Ods5kgKIx
         H0UGOVGmJMqxofP2eD+gfsAivdCQ/gNdbABc4Bsl/XsJGbILhcRkrI5Mr8Ogj0EVwlVe
         qMHG7O4zj2BS+BX2MmOHed5HVUr0QrhZVQYmNBfxVqxbjBuRNbUdFNhfVv4O4LgVCsGv
         r5aw==
X-Forwarded-Encrypted: i=1; AJvYcCVbU/F2ng6oadnSWgkDKjdClCXfaBvdJBiCXxbpIJkJQPp7vPkyI5nL/5fOe7EQE8mVgoE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPmbgEwISFzbFhac/TRAod7279CgeDOHlybPi5T7GjUv2Ybx3S
	tnwlEPcsAKHC2TBNSWireOZ4sqr4nZGyykPw32CgztFcScUj1xDNiRYHSWpYIiA8ZM4=
X-Gm-Gg: ASbGncs3PSXzBYbmuZ0kKoK9AUKYLc32BVKcwRtyLLgyrm44i+RYUtmnXhfC2xYmcdj
	sZMnEAJA8SWCRsr+V/AzK4AWnqk5AdWERZigVimO3fIW3b7e2hFjo4pUswodzSQGc6wG76hhKaC
	uxTCuG4cWJCGOx2OIk0DX5UWiCPR5ZMMNU6+ctYPS4WnGgFdwbL+GA8ml/OxlH3rZSzzBYo1KsI
	opWuENPHAeKTXecXG48dP3ZDOwtEIgyvYiunPzhst3ZuCg9cHCvDEPi6fYumuILmxSM0izYS0W6
	bh2d2FJVvrlR2FeJ8NK61dr+5s0sUc/HZBeDG/jzasCdZV1FZa4RzLbcTlTXyXTrR782UJoCpde
	QpNMCeN95I1E=
X-Google-Smtp-Source: AGHT+IEwu22mbFkl1rhzB3HygZbLt0VI4Bzye/g/jnm9qC1XNkE7RNZ7ayhpruh8WHbzvMo2Ak18vQ==
X-Received: by 2002:a05:6000:200c:b0:3a4:dfbe:2b14 with SMTP id ffacd0b85a97d-3b343886534mr2079025f8f.16.1751540497685;
        Thu, 03 Jul 2025 04:01:37 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e59aaasm18000178f8f.83.2025.07.03.04.01.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:01:37 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>
Subject: [PATCH v5 67/69] accel/tcg: Factor rr_cpu_exec() out
Date: Thu,  3 Jul 2025 12:55:33 +0200
Message-ID: <20250703105540.67664-68-philmd@linaro.org>
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

Altough we aren't going to re-use rr_cpu_exec(), factor
it out to have RR implementation matches with MTTCG one.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
 accel/tcg/tcg-accel-ops-rr.c | 31 ++++++++++++++++++++-----------
 1 file changed, 20 insertions(+), 11 deletions(-)

diff --git a/accel/tcg/tcg-accel-ops-rr.c b/accel/tcg/tcg-accel-ops-rr.c
index 9578bc639cb..d976daa7319 100644
--- a/accel/tcg/tcg-accel-ops-rr.c
+++ b/accel/tcg/tcg-accel-ops-rr.c
@@ -169,6 +169,25 @@ static int rr_cpu_count(void)
     return cpu_count;
 }
 
+static int rr_cpu_exec(CPUState *cpu, int64_t cpu_budget)
+{
+    int ret;
+
+    bql_unlock();
+    if (icount_enabled()) {
+        icount_prepare_for_run(cpu, cpu_budget);
+    }
+
+    ret = tcg_cpu_exec(cpu);
+
+    if (icount_enabled()) {
+        icount_process_data(cpu);
+    }
+    bql_lock();
+
+    return ret;
+}
+
 /*
  * In the single-threaded case each vCPU is simulated in turn. If
  * there is more than a single vCPU we create a simple timer to kick
@@ -254,17 +273,7 @@ static void *rr_cpu_thread_fn(void *arg)
                               (cpu->singlestep_enabled & SSTEP_NOTIMER) == 0);
 
             if (cpu_can_run(cpu)) {
-                int r;
-
-                bql_unlock();
-                if (icount_enabled()) {
-                    icount_prepare_for_run(cpu, cpu_budget);
-                }
-                r = tcg_cpu_exec(cpu);
-                if (icount_enabled()) {
-                    icount_process_data(cpu);
-                }
-                bql_lock();
+                int r = rr_cpu_exec(cpu, cpu_budget);
 
                 if (r == EXCP_DEBUG) {
                     cpu_handle_guest_debug(cpu);
-- 
2.49.0


