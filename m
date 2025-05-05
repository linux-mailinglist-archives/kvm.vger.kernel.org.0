Return-Path: <kvm+bounces-45538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C48A8AAB833
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7898D3A6077
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 937FF4B1402;
	Tue,  6 May 2025 00:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vOvMm3kR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4AA2FC0F4
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487453; cv=none; b=gGCCUqFvWvPmKk74uMFL8TWtla+4D0EuOeijeNenB/JVWcV7LON4zzYvwvHnhBNsXi6uWCQY4jGDP/MIBaKkeFTPyMFVkfB7+VDFKm41VbNo+vT42EvP7135UZqTyMsQsv5O0HL67ititP22nmLy8cNEGM1O5G1KppIq6eP1/hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487453; c=relaxed/simple;
	bh=SmP4boOpTknvA/4Ql+fe7CxPP6lY0TSM0h7CgEQP/MU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0TErCjny6UdVR54hlNS3kyviDn1MXRzwdazT65pfd4/XEtDdzOiHq4nH43F2tGRe5xbTEhbwfbxKXGsOgTCQmmb82bES6zYvYGjNib9S8IAqrsYw54ujv5RiOzX7r0Hy4lBWeyT13kymRJfS7evwF4FqdlsfKv/jcwYnTzJd+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vOvMm3kR; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-224191d92e4so57116885ad.3
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487450; x=1747092250; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qOUfFrwLeRqpVBNih8GreOXz04iy2wn0t5LFbPNHip4=;
        b=vOvMm3kROxsSyR1JYDqhgXqV5/MIUkFhZ8MyNmxQIwUPEfJxRLP4s09ATpSYhDU4L8
         A2GJqRuTSx9bIXU3xykbJ+nlnY+AJjZHYgkkF85tbXUe+0sv/gK9Z5uw7N70VUpWwsaa
         rtJfwSDmSz10g17WtjBRkOIiC7Ko5OapLWkmaVKa4Z6oA5p4jo4pacfwhmsMWJedbaul
         qrk9wGdC9ZslxhSr929Ecj0UQlO53dMqQyOsS4a8kGEU7t4SEg4xHQe0Dj7hzUbVOIxc
         lwiZNVZfY+52ZJieRRQxRKIch63M96KbbeP7LMc50/4I9goHk1xO32zmVBMkqFV4M0XS
         28Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487450; x=1747092250;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qOUfFrwLeRqpVBNih8GreOXz04iy2wn0t5LFbPNHip4=;
        b=LCI2xjTZki9SaqHBffm7Hr3Bq2wJXRYwuF+N2QU0svlvmYiTGE1ovV0EsWscuTiWa1
         NKtARmoqK+RixAqCUB3tdZbmbEiS1nkErCGCNASCMFjGpYja4hrAlQkAoPSBH79syYBk
         xGNFIk9Xinl+tkRpeKHsjH9Sxzuz+wMxFzfLr8DXVI3Gf5ZfNovkAmHBMf/LKFXV+qXC
         gedWPf2r0h13U0OHpV3jBJqhxJTdGCjg3FX//zRnHVDM8Am66+ygka6j43f3p//SDhNZ
         Fb33bZhJllKcZkEdBpQWxeulqdIvzHlR7/DpfqqFAmetQISa79bCm5d0dtF7lYJtodpA
         DnHg==
X-Forwarded-Encrypted: i=1; AJvYcCUYzJTQdkIthKUI2bmrVuVu9Afic70KUKrlOXfF5BF1OsUw0Xi8AWkkY5kTNtmMzac0BjQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXFtcQHFcow3o20kflluNpgAU8pjN0axrC1U9prkaEPECYD22I
	dnA/2X9SZ8oIvxuXfsPuJvv6l0vmoySjWqWUyB79b2IYM4sqfUfca5DTVCjICNc=
X-Gm-Gg: ASbGncusXiD0qWDCdhCZV9MhxgiRsisylEUkenESSlWFTkP7+h4orqIg05wTZpdZXyk
	pFMz69s3lQRtLLPRgwD+BXVc5kxno/42nmChYmAuR/Umx05cbb6b8u6BZWtgmcDiVc8a4EQEdhS
	f3/wUruhd3ZVuuV3T889bI04GrVO7GK3oLjb0L5+2Bm3/Q+6q/N6spTrJWNbbPnpqmHubXdw+uq
	kQNI7ZIKiIldSSafAIPsvlAmVNps8yDr1WgTSAYIZQW8krLV0AEe9xp9c0c6Tcsczin4xvDVwz6
	6QbvyxFizrhYvpdxJPxc+lljmUf+p1RKO2t08Ie8
X-Google-Smtp-Source: AGHT+IGrHHd6JwKe4CB3ehPMic8Dfrp4H+VJC4ilP9lT2i332N5/mNnvyzxXdEJSk1HP47igUbZz7w==
X-Received: by 2002:a17:903:1107:b0:21f:6546:9af0 with SMTP id d9443c01a7336-22e33112daemr17025355ad.44.1746487449971;
        Mon, 05 May 2025 16:24:09 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e16348edasm58705265ad.28.2025.05.05.16.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:24:09 -0700 (PDT)
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
Subject: [PATCH v6 42/50] target/arm/tcg/crypto_helper: compile file once
Date: Mon,  5 May 2025 16:20:07 -0700
Message-ID: <20250505232015.130990-43-pierrick.bouvier@linaro.org>
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

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/crypto_helper.c | 6 ++++--
 target/arm/tcg/meson.build     | 5 ++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/target/arm/tcg/crypto_helper.c b/target/arm/tcg/crypto_helper.c
index 7cadd61e124..3428bd1bf0b 100644
--- a/target/arm/tcg/crypto_helper.c
+++ b/target/arm/tcg/crypto_helper.c
@@ -10,14 +10,16 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/bitops.h"
 
-#include "cpu.h"
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
index dd12ccedb18..2f73eefe383 100644
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
@@ -63,3 +62,7 @@ arm_system_ss.add(files(
 
 arm_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
 arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
+
+arm_common_ss.add(files(
+  'crypto_helper.c',
+))
-- 
2.47.2


