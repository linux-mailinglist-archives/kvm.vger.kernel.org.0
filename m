Return-Path: <kvm+bounces-45543-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0F70AAB802
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 08:24:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0DD61C26991
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 06:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ABEB4B1E66;
	Tue,  6 May 2025 00:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jOQcokKe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5F42F1549
	for <kvm@vger.kernel.org>; Mon,  5 May 2025 23:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746487460; cv=none; b=OvGPUVkiQ83p16QrPUR1hDTNlghHWgBKr26zXnuWbcSEM9AXHWYwC2Lhm6LQOiM1ScLv/eDnMG9eUdOVIKe3JDZmNCLrCOKnJw7sH1n8PMQNrAmXdDwZvCOuyGATJJle5G0Jmx94zvi9ROcpudbk65YqU7VHep1qcp9v0V6yR2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746487460; c=relaxed/simple;
	bh=V9mlepgrcDcM8aFNaP3qGNSESY0cvd4yGO+slRJ1cg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=up6lpQnmhbJF0Z5+X0R4iYAaFuK6pbW5LbHHzvktDwGMR8Kg3I7YDSYq7cSajT7FbPvQJxs4QnsiRr6IGn2V3gnt7wduEiUtxceA9YgfR/7wOsxKwr8aygS80I1A2acsQVnVX5nGO+YWaSf6J6b8MSTtAIPeoL14JDm6NVge6gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jOQcokKe; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22c33677183so59931495ad.2
        for <kvm@vger.kernel.org>; Mon, 05 May 2025 16:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746487457; x=1747092257; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JZyZRD3+F1iwfSbHdRXdy1kvrAVUcrfC5UGzBivz9WE=;
        b=jOQcokKe1dvubKd3LcpwHTS1tBM17/FnMa98TNWpjdpLqvb4M634HmvvV9LF5c0rS0
         LSvBNojLee/oRnS6htFyFnuAskYxrZg9oeyEhrSysLPdBHMUx8Z1d72Lv7jPrOdCoksH
         qb6aA7ONbt69IVNCmNKsyGEp4DBo6tz7fMpk4zRgoG8cQ0YxCkR7ZVMwHC4J8jpvj89+
         AfdnVS3pcjvu7O0XszQ3RdyoeStivO7QIFxcDUFvwCUJOkDHM0Lj7jkPekSV2X4mI10j
         JfnhKO3muX0jb7GjFVI2WAAF5UgQrHJZPnbRRxGKe8JM1m7mopM3DdclfUUCJnZB7e2M
         GFlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746487457; x=1747092257;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JZyZRD3+F1iwfSbHdRXdy1kvrAVUcrfC5UGzBivz9WE=;
        b=oKRyD7+JT65oR78X84m8lYphoK05/RhbX85fLz9q3QA9vHjHu8URVgDxvqhapsUtu4
         wNgFha8YnK0C39MmoJF5E7+3Bil0P6h4H/zg0RQ2ZQ0WgjPInUUrDS02snz44gWVyItp
         JP5kwkfVpiJSw74rjzyConeV+K6iCveEs0GQZRgy6mPESVti7ZUTustpZJq4/Z9LxguM
         8Tcus5v+yIg0WAt2uasJWszxr7lqw3u5GJH6ItKvUNGZfN4YgvicNMcAKzG1+0b+vkTc
         cVCdyuAGRGvPUtlZGwC6nxd7wGYXP9xbI7ozEcwOxwsHGPh3l6yPstECyjax3ptuWGDf
         XqvA==
X-Forwarded-Encrypted: i=1; AJvYcCWfqhgxxSFv10RAj+Si2agjNF1ypKDkxsCFPDJoMj/fPmNl2mPfYi75IMerlMtctmb1tZ0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyRbqOPco6y/pMDG1Jii+4SgrgQlZ0SQLH6BIJt7MnyQDNlulCa
	iVwjWCXJAqAZkC+gNGzSnofa7kvqxHHgRtryTK0rq16TacAtwB+uj1dNJWmQGEiYqysZpOqFCo7
	LZdM=
X-Gm-Gg: ASbGncvM+5xDOkW0lNahnu0Lqpjwavf3Ky4/g9I2CuFMBrme/X9KOKZPE8iPnuu0E6h
	gZPMNCiKggwNGvu12RxQqywY6pN2PQeMiuqlwPhNwVumnCHwGLbxwv3Tn0JDyyhSxwFKELlCONB
	AVraSKg4iK74WBPW4MN3zVeH33b5yye/HyuDT7D8sGGlEbKyLNfJKoVSqj+uBUUTEJ0m3nY1HNW
	ZrZwBb7Rgoah4SA+iTqNF52bzFOBLnzWzdSKlwnlGkRQH6Ua6pPnzGgyw0d0J27wo7rs8gPJuf5
	yrzjv0ElGpOfqLGMS6TW/YoDng+G4NcbEu/Au+4f
X-Google-Smtp-Source: AGHT+IFEA4+6Enx3vNjJJnWRowlGdPJWotti1f/99w5zc3Slf+B8+XCjIsdF9QTYHlr+hw5AzkI5eQ==
X-Received: by 2002:a17:902:fc84:b0:223:64bb:f657 with SMTP id d9443c01a7336-22e1ec35548mr130085795ad.46.1746487456895;
        Mon, 05 May 2025 16:24:16 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e16348edasm58705265ad.28.2025.05.05.16.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 16:24:16 -0700 (PDT)
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
Subject: [PATCH v6 50/50] target/arm/tcg/vfp_helper: compile file twice (system, user)
Date: Mon,  5 May 2025 16:20:15 -0700
Message-ID: <20250505232015.130990-51-pierrick.bouvier@linaro.org>
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
 target/arm/tcg/vfp_helper.c | 4 +++-
 target/arm/tcg/meson.build  | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/vfp_helper.c b/target/arm/tcg/vfp_helper.c
index b32e2f4e27c..b1324c5c0a6 100644
--- a/target/arm/tcg/vfp_helper.c
+++ b/target/arm/tcg/vfp_helper.c
@@ -19,12 +19,14 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/helper-proto.h"
 #include "internals.h"
 #include "cpu-features.h"
 #include "fpu/softfloat.h"
 #include "qemu/log.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 /*
  * Set the float_status behaviour to match the Arm defaults:
  *  * tininess-before-rounding
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 7502c5cded6..2d1502ba882 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -34,7 +34,6 @@ arm_ss.add(files(
   'mve_helper.c',
   'op_helper.c',
   'vec_helper.c',
-  'vfp_helper.c',
 ))
 
 arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
@@ -68,10 +67,12 @@ arm_common_system_ss.add(files(
   'neon_helper.c',
   'tlb_helper.c',
   'tlb-insns.c',
+  'vfp_helper.c',
 ))
 arm_user_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
   'neon_helper.c',
   'tlb_helper.c',
+  'vfp_helper.c',
 ))
-- 
2.47.2


