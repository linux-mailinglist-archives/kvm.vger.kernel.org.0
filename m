Return-Path: <kvm+bounces-46242-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 083C1AB42E9
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:28:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BB90B3AD90A
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A24DC29993C;
	Mon, 12 May 2025 18:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jfq+64Ki"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 309C3262FD8
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073334; cv=none; b=huL/S7mHX+jxsU2UQMyqHv3UjDLZYXy4vLYi8eaeSWNwza2PSVlZfL0m5+N6efybNO+GYoSvfhEUYkq5wy71yK9ThGU7AG0qAIOdA0TLn1TwpFxW0MPeWNXFrKKR9hHbhklhFWri94eXlcHseWLzs/OukOZrol7zyWetmgiZSIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073334; c=relaxed/simple;
	bh=/lu3KcFQJp1ktQSA3dnNuTLGiYbSSIW7YxN3jDC7Nyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fT2lW380JOcCtLMFZBzOOPHiiPFAfTJXqX2qSL5uk3XftSXe/IQJgDlfNnqNG+kxiCRnohfehuuemuMtKuHNsbmrSR+V8lrFbVE/18z5g5FonNxmMvzLAYCh8qsshkU2PXbpgUtc4GRuiURwOtGqqdpq2wy0vVm5Ki3Ek1I8a9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jfq+64Ki; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-73972a54919so4773578b3a.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073332; x=1747678132; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45kfheSbx4dAVwou8HhqFlnvbUQXjacWSTonOtivRHk=;
        b=jfq+64KiM6uAQ4WQAsWmVyuq4UrlWB3aqS5eOcxsjv1Ahhx2pNCeHVZIo9wHoQ7RNs
         soWXNArtidegXaUXhP7RA1Q15JTqQ27uIaJ92CyitIABXOsaCVMacM2cFloss68iAlQY
         88nMPeRh2RJGfovTZwUNNj4jopmnHAlT/f9sCpkXeaRKGU+HQeLxiU/JKc+FpMAuECTo
         Wv8bywJXVYZvu8jIfZcy4bwXHa2dv5bvWQYRNf93YAcZNLNqblos+mDYOqsIHX2aWvQs
         FqC5TrBhl8+7xGJj2SkMMnBk29ZuL6csOjZvKvBnDSANxUVIxriqXmCp3CF6AKbHo2Ma
         CnAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073332; x=1747678132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=45kfheSbx4dAVwou8HhqFlnvbUQXjacWSTonOtivRHk=;
        b=t8koNd+G2XQVmCAprt22wGVpp7es/CqfaSc4Ay3aVZxyFNL3/RrtW5uH9e9mDxt6kj
         Iv32jOqRByl+6pk5sIBxafiy1o+9D8Iy1xb2MqE5CD53AWnBtBSuwqIga4mHmXlWnLXF
         XmuKLSMa24CX98HcMsF3jEqa1n1tKYEmMUrauRLR5G9PcG+lZ1xGnuHGB9/hQIPBENDF
         r6/h4Yc4XtfMn9G2atDldPyfuOQ94QQTDTBLFZDy32zz3cV9/x0UyaMziLe12E57moxb
         Vh83I34xmuLnnb8jB7cO2hoh/ccNC5qIG9W+QSW15fHxRDEoysHLa9L0mPis1sTdqVKs
         glvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXV46GI7Eyu6Ax9Ya1/+6EfUTIsi38DGsyvd8ZMcyRkUa4EgvvIB82dlKq6Q/MUHZR/Kqo=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMZrScGnkEG6IgB6RFatoStvWBt2D/aqfFfMf63U3+4gtjd3SG
	NgCr//aE7E4e8MVslfB2IbPZZZtjGSw0wY0x2XXIu8WpyIoA/lzwuUFWjjWUaYY=
X-Gm-Gg: ASbGncvwH55QEYDMgLgEuBdy2sGsRJ4qrdQYvGc8xWc5aTrmO9DRIXs+T4S8qr86r/G
	32LgqKh1sHXurjl4/9DeNj+/PtblMTCnHG72DLIVmeh3FdWMXOYPmJZ1kfoGAzoYTxsp7Ivqo4G
	7qk1n37kTHreNSkaHjutmfITZgudnAOJJqz33Nn9pfyZ+2oPYtxqMcLZma8A2Nu3wHzsyQqDbKd
	8g9vrXRlxpydSUwQLhxcyGc9gy10ZyJ5//9fHtT9qCk+q9jxfWP+T71u+Q16QckUpIjT0OMI3tS
	5C75w33ldEsfzy5s8Rs7MCm78lIaEFMkKglBFpApTFMNahsDiEw=
X-Google-Smtp-Source: AGHT+IFhUEj8B0jzi2eY3hecuRh90QxHVyJSzWdBkDPS+yb9VWe1l8ymSiC5MeyMfg79bhe3uOQ8HA==
X-Received: by 2002:a05:6a00:a16:b0:732:5164:3cc with SMTP id d2e1a72fcca58-7423bffde33mr21159796b3a.19.1747073332366;
        Mon, 12 May 2025 11:08:52 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237705499sm6438580b3a.33.2025.05.12.11.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:08:52 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	alex.bennee@linaro.org,
	anjo@rev.ng,
	qemu-arm@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v8 40/48] target/arm/tcg/crypto_helper: compile file once
Date: Mon, 12 May 2025 11:04:54 -0700
Message-ID: <20250512180502.2395029-41-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
References: <20250512180502.2395029-1-pierrick.bouvier@linaro.org>
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


