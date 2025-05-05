Return-Path: <kvm+bounces-45388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5039AA8AEA
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 03:56:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32D6F1680D4
	for <lists+kvm@lfdr.de>; Mon,  5 May 2025 01:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368CF19B3EC;
	Mon,  5 May 2025 01:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m9HX0HtI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17BD188734
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 01:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746410187; cv=none; b=DpyfqlNn3QbQ15949LBnP5AyHdmVzFhl469agD9rNR+o7iBDR7FzPv6EMAaLPZUcaSBAYkX5NeEudWgygLgAm5kdVnNACNZ+LFMcDTlA73e6zcCY+tNaMkZJluZnCAAkLQh6u3yPiohhEWl4B/Q9iZNBON2LdIkt1xy2qpFvN/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746410187; c=relaxed/simple;
	bh=M9Sw7B3oGU6wmjd8x6WAy6l/1uzP/LAmkVkfl4D/RKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8sxyqc6SV8UlItGilqPwntOi2dtQI7At37dPqojxo1OL4Obotwzl8yiLUHADq31oPPequoIirgQOspvDuV8ZZfGNZL6IZ/7p8MiZzFSFDYZxjZysQIv4YcTwvKugvKOB+ZNK7zNm2XA3l6m6SS7nEA51WlwRxngdXlXkXri5W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=m9HX0HtI; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-af589091049so2753075a12.1
        for <kvm@vger.kernel.org>; Sun, 04 May 2025 18:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746410185; x=1747014985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3FxyL5xQTQeKYw4fbOUfGUh6DzvIDzEt1jfdRlnRDo0=;
        b=m9HX0HtIyI4sWVHt7CKM5d3kjig2iCLuZq6rj3PnYcB94iGafPKyLeDNaMS010G5Fq
         jHSALG4vseGIaG9TYNgwHzdBTo2jvuwpXTFlKYcm14JiuCNk3G9lqTIvr6jSCmkTevPp
         frhiANzldRc/zlxyTCMI6qSnHZnAfB7l4yWqKustC50Cx/0vfdk9X58m9cUm1f50yzGj
         u3B4rhW/YIIl9TN8Q//KVC740pk7XxhySfpPV0nvW39yJWL8cCvNy88240zyezQM7J43
         MRxIzJszzMvWsZXQ9f8VCqMJ9xPLekHHGFfYO8OkoD2xc/2Alkj6cfdOv6aLyHsfsVUJ
         PTmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746410185; x=1747014985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3FxyL5xQTQeKYw4fbOUfGUh6DzvIDzEt1jfdRlnRDo0=;
        b=JvIFRLGTyw5C2edUqSN+KSC/aCNti05M3bZlCR6Ks2TmQ/fDDchnDn6UELMubTRym2
         nznHIdkUwAk8xYjfn/j7QUoSKnme5m3bXQdvPUhCsaD2CiYnV7cJaNd8iszw3QXg8iWa
         CrdMGNaZuicfG/Bdt02UtAu4XzXOlI4fcJYnGMlhJ9YdSdklJgxeAdFIIaMZnfqYjE2o
         RZzDikRb1iWJg9UOg1XFChG/amJmUYxqhKgBt3MtKEZrmc89pBK+suOnbfnrly/cu4pa
         EGTHS5Wx4mzAP84sQitK/otlmKlP5b+J7fyX23uqqCIqM1kGX9yO8ErGNQXG0cP3iGiv
         wRjw==
X-Forwarded-Encrypted: i=1; AJvYcCVR+3SDrz0vNsOJPxi7S9sers2o72GOzfaU7qEXrQSObL2SX12RKlKebl79GtabBIGkq/M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzng0kkftd+a+GH+33796z+1Qo/RK1VXAuvQq7C7MOyYlaA4/VS
	J/d8OsM2qVSKFdED553WItwiv4m223rpdF9ybRyNK3Y4bav3ySDSGpdt7+UW/4k=
X-Gm-Gg: ASbGnct/VXIbT+9bxnOm6B/lm/dz7RHLpfcBv4ir7+1uIEUKIutx+HoE3fjObxbtmoT
	PHAQlg0XtieKAuUjg1cq1PDeyg1yQjmFicDOkEjmSoVDbtteDxVVu7n1ie/AbMVa9fDTaZplCTM
	iHYr2IrLDOY5c9qHjcXr6ZWq6eTvD5XKoYQ0jmLig8j6JI7lghBGb4vjXlmM2uM/r049xRFILqC
	0MF3I9ptMpQH/6Q88vwMm43MtZ47++b1L988lzxUdRDyqHvZZMrc+RjbH3Al8ggmKyNJ+436+9b
	/96j9A16FqwbMLcxEvJhQaUeg2YfJrGIXY9ox4O3
X-Google-Smtp-Source: AGHT+IF08gkZkIRf18bKpe+h6dy7sLRJNTB7MMLMd8vtQdIpHc8Bzf6wKZHpeIbs8t/snEv3ZsWcRA==
X-Received: by 2002:a17:90b:586e:b0:2ee:6d08:7936 with SMTP id 98e67ed59e1d1-30a4e5c5ed2mr16612751a91.20.1746410185269;
        Sun, 04 May 2025 18:56:25 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a47640279sm7516495a91.44.2025.05.04.18.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 May 2025 18:56:24 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	richard.henderson@linaro.org,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	Peter Maydell <peter.maydell@linaro.org>,
	anjo@rev.ng,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v5 41/48] target/arm/tcg/crypto_helper: compile file twice (system, user)
Date: Sun,  4 May 2025 18:52:16 -0700
Message-ID: <20250505015223.3895275-42-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
References: <20250505015223.3895275-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/crypto_helper.c | 4 +++-
 target/arm/tcg/meson.build     | 8 +++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/crypto_helper.c b/target/arm/tcg/crypto_helper.c
index 7cadd61e124..ca14bd17a58 100644
--- a/target/arm/tcg/crypto_helper.c
+++ b/target/arm/tcg/crypto_helper.c
@@ -12,12 +12,14 @@
 #include "qemu/osdep.h"
 
 #include "cpu.h"
-#include "exec/helper-proto.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "crypto/aes-round.h"
 #include "crypto/sm4.h"
 #include "vec_internal.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 union CRYPTO_STATE {
     uint8_t    bytes[16];
     uint32_t   words[4];
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index dd12ccedb18..e3be0eb22b2 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -30,7 +30,6 @@ arm_ss.add(files(
   'translate-mve.c',
   'translate-neon.c',
   'translate-vfp.c',
-  'crypto_helper.c',
   'hflags.c',
   'iwmmxt_helper.c',
   'm_helper.c',
@@ -63,3 +62,10 @@ arm_system_ss.add(files(
 
 arm_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
 arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
+
+arm_common_system_ss.add(files(
+  'crypto_helper.c',
+))
+arm_user_ss.add(files(
+  'crypto_helper.c',
+))
-- 
2.47.2


