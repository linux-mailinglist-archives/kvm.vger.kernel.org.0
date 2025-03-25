Return-Path: <kvm+bounces-41896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E9F2A6E8FB
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 06:00:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F40C71686CF
	for <lists+kvm@lfdr.de>; Tue, 25 Mar 2025 05:00:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 644011CBEAA;
	Tue, 25 Mar 2025 04:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KG+b7rPm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33151ADC86
	for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 04:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742878769; cv=none; b=Fbt9l6CeIMOoCMq2vVAtSd0LkT6bfyreY0fzdXsLKb2XwbeMH51mOCZ7P/mH0VVtlexWLGGiP97baSDectkRFZiDrKcOFARK4EdpjhKmOUKp6UFAxHgKo5NF+oRYAuOSiPmzHVWZeNyjRHEfo139z+0/1u0O6lH1YnTu8sJN5AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742878769; c=relaxed/simple;
	bh=WiwsOarTqmO2txbtbD8shAW4FHL3+9Cu+Olriz4yahU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JFzgLbYgeUOEDD0DjW5a6RAPeF6yI4uQ7KesOHxwIeWmOxi3cw9vqEHbz1o6fftR0OGNDeA2RZksS96LYMyqfu0NON+Sih/EvzwRd1dH1CrUaKUlCcso4QpE+gmPQbbrscSxOxgXpOb4hA24tBFX8Kmi0VMnz0Z74U9vazC6rng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KG+b7rPm; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3015001f862so6434652a91.3
        for <kvm@vger.kernel.org>; Mon, 24 Mar 2025 21:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742878767; x=1743483567; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7u9igk3DJeYNJ4kHlFRAOur7C++4prjQF3K5i5oOOhU=;
        b=KG+b7rPmWgPlUdQUCx0lTLnF/eXHoB61YBP/zZfud2gVg7OyQN/nEW3gpWwmzzCjKf
         lrvVG+dF9nno0zAF4I9osCngoHKez6VnKxIAOGGeNoGSTT27TU1i+B8g51B/rySCTjhL
         HJ6yiwcDPIJmD8VaoC1YIh6A28I+I0iTBOoxVYgV2LWExdEh+eSuENUoDxeOxQ17EE+L
         lCz6EBm8g9xdyFzfTEwFEfgjBBbc/rzWniBgbjzNclECNzNZq4L3kAqs+sSXFrDxjJcJ
         LkilNMx9OwfJo6IWvmbqAVhEPP3zrqGGrcynOFFvElBeJRxo5QevDvSK9pglbP3zQOXt
         fMHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742878767; x=1743483567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7u9igk3DJeYNJ4kHlFRAOur7C++4prjQF3K5i5oOOhU=;
        b=O1SKgdPfqK0Zi71PSIf/MFgqEYeo9rtP+tzTbKzziSFmMgxcPC4LgLWqTxcPO4gVf3
         rWSOsgwOpQho+iuRAyVom2wrx98q/2iCgWNbL/ac4wavNyFMD+jdTVdDXj/PGSuaFVjl
         AlSKoKxIjGsF0KcB0Gdn6bCETB68QpfpJtuX4sh/XJBSZ/1K060hStMca3LMPb3GFf+f
         jKEwF4E6pcH41RJThm9VowyEBoKVcxTpiUnSi4L4iQdGAJkaEW+w4Ye+/HXDU01QLZXL
         nNtQODbwqj1SwsSjS8gnnWZk6WgpNVnTgmeBC17lZ2jY7tyvW3+2m1xbywFAT8eDISIM
         9KOA==
X-Forwarded-Encrypted: i=1; AJvYcCXG7749eHg/kw9hil+YgKlnHWYUQmwilXHdJYi/5sbXH6zGW45uajcac7CLTug24tgZR74=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMDm0CCaVRUbJe2Jgmn9qopeHSaJpEtfrUMCOdbM/gZB/GcDQU
	1fE1hvR5++OlyG7VNjKeflT/NsuYnLEcpui6QtZNn/P8D7+KEevbsqqRMDxck3c=
X-Gm-Gg: ASbGncuKB443O0anlroyy3vVkFadQmr/SG3v1Mb/VsCEt6lFcNFCOVGZsSHo7hVu100
	Jv7j3iaBM6WxiOub6Gzc3+3E0Va09RkQIsi+tfoq5zfFFQM7G8+F8gcueRqg7eF5OUHFS+g650e
	Fefht9JBoEVuG8o63AT6XXnnzKO7271oFV6z0haeaUdKbTO6lNqFYnw0RCzXtp/X7kYDUG8Cq54
	602xKvs45KXAFCdDerpVtfn6WUf+3OQUJUwFDMuy8cgAV02IfGK2HWYRKArF02rMoqDP/bSEoLy
	/5BVrt3ISdd2fD+RMHP5QMl91wqdB3ReZ19DUIHWdRV1
X-Google-Smtp-Source: AGHT+IEiLeBzJzC5jt8zA/2EUNgz/WuF2tstB2sh/pCZJeNAww/EeI683sYhypnoorCiSk/JT+KeeQ==
X-Received: by 2002:a17:90b:5108:b0:2ff:7b28:a519 with SMTP id 98e67ed59e1d1-3030ff24236mr23516938a91.30.1742878767084;
        Mon, 24 Mar 2025 21:59:27 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301bf58b413sm14595120a91.13.2025.03.24.21.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 21:59:26 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 06/29] exec/cpu-all: remove tswap include
Date: Mon, 24 Mar 2025 21:58:51 -0700
Message-Id: <20250325045915.994760-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
References: <20250325045915.994760-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/exec/cpu-all.h               | 1 -
 target/ppc/mmu-hash64.h              | 2 ++
 target/i386/tcg/system/excp_helper.c | 1 +
 target/i386/xsave_helper.c           | 1 +
 target/riscv/vector_helper.c         | 1 +
 5 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index 4a2cac1252d..1539574a22a 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -21,7 +21,6 @@
 
 #include "exec/cpu-common.h"
 #include "exec/cpu-interrupt.h"
-#include "exec/tswap.h"
 #include "hw/core/cpu.h"
 
 /* page related stuff */
diff --git a/target/ppc/mmu-hash64.h b/target/ppc/mmu-hash64.h
index ae8d4b37aed..b8fb12a9705 100644
--- a/target/ppc/mmu-hash64.h
+++ b/target/ppc/mmu-hash64.h
@@ -1,6 +1,8 @@
 #ifndef MMU_HASH64_H
 #define MMU_HASH64_H
 
+#include "exec/tswap.h"
+
 #ifndef CONFIG_USER_ONLY
 
 #ifdef TARGET_PPC64
diff --git a/target/i386/tcg/system/excp_helper.c b/target/i386/tcg/system/excp_helper.c
index b0b74df72fd..4badd739432 100644
--- a/target/i386/tcg/system/excp_helper.c
+++ b/target/i386/tcg/system/excp_helper.c
@@ -23,6 +23,7 @@
 #include "exec/cputlb.h"
 #include "exec/page-protection.h"
 #include "exec/tlb-flags.h"
+#include "exec/tswap.h"
 #include "tcg/helper-tcg.h"
 
 typedef struct TranslateParams {
diff --git a/target/i386/xsave_helper.c b/target/i386/xsave_helper.c
index 996e9f3bfef..24ab7be8e9a 100644
--- a/target/i386/xsave_helper.c
+++ b/target/i386/xsave_helper.c
@@ -5,6 +5,7 @@
 #include "qemu/osdep.h"
 
 #include "cpu.h"
+#include "exec/tswap.h"
 
 void x86_cpu_xsave_all_areas(X86CPU *cpu, void *buf, uint32_t buflen)
 {
diff --git a/target/riscv/vector_helper.c b/target/riscv/vector_helper.c
index 83978be0603..7fffa23bc8d 100644
--- a/target/riscv/vector_helper.c
+++ b/target/riscv/vector_helper.c
@@ -26,6 +26,7 @@
 #include "exec/page-protection.h"
 #include "exec/helper-proto.h"
 #include "exec/tlb-flags.h"
+#include "exec/tswap.h"
 #include "fpu/softfloat.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "internals.h"
-- 
2.39.5


