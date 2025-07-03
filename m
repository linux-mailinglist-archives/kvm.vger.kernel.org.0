Return-Path: <kvm+bounces-51458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4ACB5AF716C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6BBD53A304A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AF02E4278;
	Thu,  3 Jul 2025 11:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mq6PAGTa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CC92E498A
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 11:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540436; cv=none; b=jXqKRFketm8E02iyg3+qyS5hFx6fDOEh4awVNU0w3iRnF+HoLVvJ/26vM0zIyRf6s9p5bYygZACPctQHGLffpQQiquCg0erwzTTiygtEslpe/T/Xk/l2AVjU/h59+hwIAXuXba9ci80j/XJMI2rPTX9znlag89C6wU3KX7fFQNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540436; c=relaxed/simple;
	bh=rSgHRjfdml2353YFoMGxMwdXnPV64AbTBSpMC8v9jXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nl+BEWnlzEj/NzgQL2c7dsDFWMAShz9V/irFUOvsYFLSfk0J5A1W3UUP0Xe7SCnnE/1oJVPFDl+Q2ufVQzolfDNgINnWT/buUOLdIBKR9lc0watmfPeqQbaZAw3DFG4mZs+p1F5SEhNsXKhRGreuOUlI3X4NeN2C7fzpLRbEPP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mq6PAGTa; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4530921461aso52379665e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 04:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540433; x=1752145233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0cde8O5fgh1/x3P/3o29/Z35Bz+QAbkT/6eRH+3hSMk=;
        b=mq6PAGTaYrpeTExg/Bch5TCqSYWJKoaKzkFgrimKb02ety8cYWjT9pqxYVwUgFWyRT
         Q9PixyDxEpVu05MQB19lhzkxxWqLhv3awoyue8Zucg/PY59gy+zlFOrMTNJOfWDxMFPx
         9EGbdZ4gKGvlhuG0CmKb1UWU2DMTHKNnnS9Stp6rhijbHYWb+r3k0X3oXOSMPb6PmkhA
         wEfeTU14iYVOHiGE/mMVr9EegwsTgqU2tjunaDRFydXVf7tUpcn6X6UNmZlmISepx6fQ
         7etwvSdmXHCFODyYYA2wnB8hLLvcIkSDMyUg05YWG/TMqE7SUDT5udy70vTQRDdHJ8eu
         7wbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540433; x=1752145233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0cde8O5fgh1/x3P/3o29/Z35Bz+QAbkT/6eRH+3hSMk=;
        b=CVazpZiH7TqKw7iQB9pq7yeqhBHU6G8LCWma3x+Wm1+Ahtw9gQu8/jzbBcUOvPQu0P
         HammA+4GdpKE5gzAAGjkc9yHIwXiUWLEy09vvUM6XvVvlGFFdH6UIRXOSVHeHaG9Dh3l
         Qcg2vd9yzf0COtL4NwqF7PqxQeJ7JI8ZZE4q3l9zBspczncjoxcRu0dpfTYCJXt/zfWm
         Yqjlj7nOwsWzUz9t/BYsDRZtEuTMFHaVwMdKaUvxV0QLr/XCWnq+B4KTpkKcSf0+a/GL
         m+jBAmwcwxSgHGFMvX2+elqvN51+iqM58asjJyO4ClcTPh52SqB1R4tD1L4+f/5yF7aZ
         Ap/A==
X-Forwarded-Encrypted: i=1; AJvYcCUOaT/VS0QF6t29r1D/HVk2CxNFcZLHn940/aZmuCHEp1OhfNlsrx8wKlp+URtz0VCdHFg=@vger.kernel.org
X-Gm-Message-State: AOJu0YysEzskWhTKuhSpvKKY2WOiJT2PqBRlk5HiZuN9TtktlbSiLzwe
	97x2nhmbra2B/CTzQQ/2QOVUj7MGSDkzBf82RQEwWVEUb0Iu/OrQcEz7QnV4hWZY8hM=
X-Gm-Gg: ASbGncv3ofPzjk1e5B16OdhTcL/W+nZNkj+4pJiAeIQWrZk9t78p73eUTdNxW2iLbZB
	xZtvSyphG9m+3d3K41vMO/HnzhAtpdnMbZmAU/tBOAWX6PbVWHEWiV01S+PX2hdwMg9bwjX5Sb3
	O6YNXbzuHF/pqYCw+XUwIwlcfnXJo/IIJRpDfLfnfM2BMltdLqKBEuH/+BKbKU7oJ5NHj4TrZRn
	AnLU6JIH+uqrLUwACtJRt5O2GEGbAo15f0RUQQmPVp7ycr7QMqnjTugMOYcmkYUs/vJFMmoc0Z/
	lzMfz6BQiIsXKWonHDW/8+8fJpWK6oLOfrtWQOgFldnVg67ctNjugOmNpmrLEedGrYf83ZcuHoU
	O6/SSTUwXevk=
X-Google-Smtp-Source: AGHT+IECVqwRCSSkNFpfwCHWC/LhOuR7wElBIZCz+M6yLqqaGvOgS9qRHb9tjN2lU6wMIaMMj74Yeg==
X-Received: by 2002:a05:600c:3eca:b0:43b:cc42:c54f with SMTP id 5b1f17b1804b1-454ad20bde2mr20247315e9.14.1751540432626;
        Thu, 03 Jul 2025 04:00:32 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a892e52ca4sm18489036f8f.58.2025.07.03.04.00.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 04:00:32 -0700 (PDT)
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
	Mads Ynddal <mads@ynddal.dk>
Subject: [PATCH v5 55/69] accel/hvf: Convert to AccelOpsClass::cpu_thread_routine
Date: Thu,  3 Jul 2025 12:55:21 +0200
Message-ID: <20250703105540.67664-56-philmd@linaro.org>
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

By converting to AccelOpsClass::cpu_thread_routine we can
let the common accel_create_vcpu_thread() create the thread.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/hvf/hvf-accel-ops.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index c91e18bc3dd..b61f08330f1 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -207,22 +207,6 @@ static void *hvf_cpu_thread_fn(void *arg)
     return NULL;
 }
 
-static void hvf_start_vcpu_thread(CPUState *cpu)
-{
-    char thread_name[VCPU_THREAD_NAME_SIZE];
-
-    /*
-     * HVF currently does not support TCG, and only runs in
-     * unrestricted-guest mode.
-     */
-    assert(hvf_enabled());
-
-    snprintf(thread_name, VCPU_THREAD_NAME_SIZE, "CPU %d/HVF",
-             cpu->cpu_index);
-    qemu_thread_create(cpu->thread, thread_name, hvf_cpu_thread_fn,
-                       cpu, QEMU_THREAD_JOINABLE);
-}
-
 struct hvf_sw_breakpoint *hvf_find_sw_breakpoint(CPUState *cpu, vaddr pc)
 {
     struct hvf_sw_breakpoint *bp;
@@ -369,7 +353,7 @@ static void hvf_accel_ops_class_init(ObjectClass *oc, const void *data)
 
     ops->cpu_target_realize = hvf_arch_cpu_realize;
 
-    ops->create_vcpu_thread = hvf_start_vcpu_thread;
+    ops->cpu_thread_routine = hvf_cpu_thread_fn,
     ops->kick_vcpu_thread = hvf_kick_vcpu_thread;
 
     ops->synchronize_post_reset = hvf_cpu_synchronize_post_reset;
-- 
2.49.0


