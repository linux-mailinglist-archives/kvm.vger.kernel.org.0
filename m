Return-Path: <kvm+bounces-45541-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BD28CAAB807
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:24:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AB9E1C22FCF
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:18:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 170134B1E61;
	Tue,  6 May 2025 00:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WFJzkpiQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0BC2FC10A
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487455; cv=none; b=UJsV4iE2fF4FgG98leyQwL7NKtFrtal89yYvhinpAvyWu395LY/xZGI51icEschhFI8IhwMpWxUBEOtrHlX3yPqhNijLFTrxy8om8uiP6poJA+jhcp36Dp4kmUhtrYyh1uC4FIvChddpu5Xpg8gf/6f8p6jj6UNmAPU5wUcEcM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487455; c=relaxed/simple;
	bh=rPnBVA9EeIg48h2PLgQzGtpbKj9OnayG+Iw2d1TQwzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vpqryw7U6dpHAXLXxIFABJKOx27muFT1QQnb1TdghyJypnNbXjMeiEqJ0k8eohCv7kcPUJPKkzvY+BcppMIC9aTyVjLutqq5f36jGe+Rd1RTIz8sN1OID0swdmpRkOMFwo+KxBnO7l2r1T6uQr2Kedm9LYYt75EkuFC+yPjl4AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WFJzkpiQ; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2295d78b45cso65362345ad.0
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487453; x=1747092253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tCOIjYNw0nrrfgNh5tW9ScxZaAXWwfrCxDZEIXL0aSo=;
        b=WFJzkpiQ669QRbhhHlQaIV5GbAST213CwsKe+LVtIV+ZXIHy2wDxxbNKKcgbOjQyxw
         COqcJxRCMuKWX2dHC7ArkUjgjx/AQBEqwywTb/VXZtHKPtvCSLFT30qs80sJ9bdgPAa2
         yza9P/XsHz+lwbtfmJuxGbuuEQ/yGfJMOLI5wvdcN0lEERUSF7Wvcp7QFlkBVC/+vz6y
         cHa/8CzfMjlVoK6dsPc9mpZQKep3jL6lvBHMpcfMfbwj+IuDfmuEz/5FUBwUA+J9ydjV
         1RJ3z+KSGV4+gCrwufR0LzCFhErM/KzCP757PqQYFGIB9nXoniSJIxm8aVgJtQAhqXhv
         Of4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487453; x=1747092253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tCOIjYNw0nrrfgNh5tW9ScxZaAXWwfrCxDZEIXL0aSo=;
        b=GG9agYJLZBK8k/LTrAy1nQ6F6Qmss5tT+LLkuWc8Ks57kPUazJNUL6Pq34QiaToG9u
         44APukQzu8BVdrt6O0DBtv+c8MH84himiRJWILiyNsx3cTatXhNcNUyF0BLA63kC1MKJ
         sJJa2oSkwEypicZswurjpVzmH80FFvU/MNZ57P0tCvlEdfhve5zWd3yG7YCyPFA5NFZa
         lK2ZkZL2mzWpDxZf+CxeLsNKbd9/gDvAFuFnwXAaorRUOphAHmCEWRkwcu3uPaSufxaJ
         lt91cF6+ytXDlnWZ7NLRzQpysn7hPSpRQDJ5URpndB77+J+5JPBSoC3zWzr8NUUouiHB
         2ptg==
X-Forwarded-Encrypted: i=1; AJvYcCX1iibVkxAO0REoHsx/FTSn3gtTCh1vLarjiMGxZ5BG1ZRwQSqFCeU+/YP7K5k1ZlNu+/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHpjKqcylbwSnU06ckx0Xb703QyirDNlSlyz6j2uaTINvaj5jU
	gRFbNjs/1k5XvPpXVnGO0KCeZY24JLYdMGJr6DawEkKrF47GbbHAObCef/+cSCE=
X-Gm-Gg: ASbGncvSfsDmQWbnAezNHepwbItZK2GkUAOTdez3X9l4NLqCRqCa9XF8gXq/9ooUWGq
	cxF7Dhsc3twfTRmzWY48IAsk+S4PIZPF3VsIEQHTpdZZu1lC9RWxXsVUovy6K4esFum8qm5EOAp
	cNvL2K8C2MMdtZWdJWpQT1a7lpEtf8G1zI3rYfVfRdTUpz8Y7lHI9PkdAyAXG+lk4Cefn0WmL5x
	c6eA5TN3aFPMX3UMAtPvZL1vv7NV8komoxZJzdQusCLxeXEPmTmoa1ia4Amjhh9Z6iQwAFBCIGP
	GGD1Kyj9OQApnYSBN2QUy1zo5Sx8m5iKwel+lOIs5TIQJPqrGQI=
X-Google-Smtp-Source: AGHT+IFjxaZn4mAfiKBNjulls3ChlwCP6Nku+tbKpjjt1EV7oV6tV5Sau1TaU3st3hFyaMq+a/8qAA==
X-Received: by 2002:a17:903:32c9:b0:224:5a8:ba29 with SMTP id d9443c01a7336-22e33012cf3mr16530595ad.43.1746487453415;
        Mon, 05 May 2025 16:24:13 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e16348edasm58705265ad.28.2025.05.05.16.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:24:13 -0700 (PDT)
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
Subject: [PATCH v6 46/50] target/arm/tcg/tlb_helper: compile file twice (system, user)
Date: Mon,  5 May 2025 16:20:11 -0700
Message-ID: <20250505232015.130990-47-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
References: <20250505232015.130990-1-pierrick.bouvier@linaro.org>
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
 target/arm/tcg/tlb_helper.c | 3 ++-
 target/arm/tcg/meson.build  | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/tlb_helper.c b/target/arm/tcg/tlb_helper.c
index 4e3e96a2af0..feaa6025fc6 100644
--- a/target/arm/tcg/tlb_helper.c
+++ b/target/arm/tcg/tlb_helper.c
@@ -10,8 +10,9 @@
 #include "internals.h"
 #include "cpu-features.h"
 #include "exec/exec-all.h"
-#include "exec/helper-proto.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
 
 /*
  * Returns true if the stage 1 translation regime is using LPAE format page
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index af786196d2f..49c8f4390a1 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -33,7 +33,6 @@ arm_ss.add(files(
   'm_helper.c',
   'mve_helper.c',
   'op_helper.c',
-  'tlb_helper.c',
   'vec_helper.c',
   'tlb-insns.c',
   'arith_helper.c',
@@ -68,9 +67,11 @@ arm_common_system_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
   'neon_helper.c',
+  'tlb_helper.c',
 ))
 arm_user_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
   'neon_helper.c',
+  'tlb_helper.c',
 ))
-- 
2.47.2


