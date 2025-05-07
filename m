Return-Path: <kvm+bounces-45814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8F84AAEF95
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:48:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCA113BE56C
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C7E2918FD;
	Wed,  7 May 2025 23:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S7Sw2ZRs"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3336D2918DD
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661621; cv=none; b=eoHZzDJHuAb2pl1uHIRshsge2l6NWHApeJjPaBU7PspdE84WO10hjOtHrY0Krb3v8Mf8j7eRnLTRtNQ5toHy9pRCTpo3Bs0rMHZG5OroQDN2jIvubCMvgWON6FM0UbNMmy5jYuGHxd5f3pwPBV20mOs+rqGStrsJ3uVnBvttxwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661621; c=relaxed/simple;
	bh=uhyN6OagJHA/8qpwacuXulq1J5vw7t7rKBFxacIElLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X1jfTdMEG5y6WqxWihMvPSRopWEw1VZiOwpiChOI71jntXfSt/H7SL90yJo1eYC514mgL+PuEpX8G2Ak9xKA6UASUCeHWcGpvqzx3VpOosni1t9XpjhlwE/+o5grr40gC5tHh8yWgxmnEOQA/OjTDJwLuzjKrkLgGnMze068Bcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S7Sw2ZRs; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22e15aea506so4850095ad.1
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661618; x=1747266418; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D50FgSNi0pKqcQ8O05hlTOFeOSvMmvlw2mBrg4KVMZU=;
        b=S7Sw2ZRsr22c1pov4kdLM3XoObcyxVV4JilBwmKf3XHKDbseSKSz7DhD/dMUuzbokH
         3cLrJvX7pP7Eqq73h7x9Ta2ihPLIHyhRKFAKmAqRqMt/RnSNnBAMiU0jeTI83C8FZDO/
         lb3H+mw1zkGUauWbxTeycKW0Zwi9Oa1exSWsFtlgcZ0yf/myd0/9XnRz1m7OAGgLX3xr
         2T0mrp9yxGwgHTS3VDLNhHTTnfIgdoJw+jcTt3LgXOoCgUxtf8/7YVOhg6Wr10RFB1l8
         cfGe487qbGgVg5cyAVJddBe8bS36JjoefWvtnPhMayV+fhp6QKi/ep+IXecYzlweV+ZC
         e7nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661618; x=1747266418;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D50FgSNi0pKqcQ8O05hlTOFeOSvMmvlw2mBrg4KVMZU=;
        b=QgQgqI2M8ikTy+lTN/0/k9fH+pncYbyUSJY340sDFVtUtS62t9kMMK/LPJyyi26cH4
         4tmt/+P/PTMOx59k9jitTV0vVnFj4JWiNaQGwd/Dxah+tQfccBOexWZRxLUZgYmdD6yK
         1vpu20T7ugmBZRr3QtIeWGZxAVieT5MxKG/YRSp3j/pJx6KtQhEWYMLsu/Er9islCwHr
         SVkjFFJFgu6b47rKwj4j9TJqYOaZrUw61xVykCKBGbO6tjk5lDhFizSlyB/yV5lJSSh5
         VgBKYI0fT99lzhR56DCZLMdLhhG6SWkwO01XinoT7SVPVtkQlzGlYFl6rFlME7nOkMUN
         90dw==
X-Forwarded-Encrypted: i=1; AJvYcCWbVmh1jZsYZCdRHC49Hp5KSAphUAKEat3vC0Wsj98URE/0MNo0sRvkyCZpGvctQu0zfF4=@vger.kernel.org
X-Gm-Message-State: AOJu0YybzzB00HxZAyaL0YA4hFgFsHJdT9y9YEo8wjANSLe4PotgOgcS
	zQ84Xbkju9z5nMKnpCc4x+fKCh5QRQ9seaUqXrexJx25VprSN0x1Zc8xZbFtaKA=
X-Gm-Gg: ASbGncvblzWV18DApLN20Lghzupsw8yKJ+g/Arl85numdNJYAfD8e+F4lzx1SWziiur
	SCvaiftgLa0xvogGACNIV+2l1dU2cEbQmPutbbdUI2cZRhSTQAJuJovyPp9fANNUVV5WSrs4urW
	4d2foJA+zhVQ9pZsEVX6OkHv07aoQwK+R7cBr+1S8NeBlvLMKvMf/XdvCQhj2Yp9efbZGVBikLt
	FNysCFWw0TL1cAoS1d+FSHpj4vAekgAiJwkYpthNi+VVjuQJqfzfECwRu5dNevov+qtUkvrUp+F
	2Br9fztptvxgEL1Ra1SF0vx3GsgFQJC8FfpwBUOk2MIR+ZB2oJQ=
X-Google-Smtp-Source: AGHT+IE28ol+YDSzIaHNx/fWYHVNSAxgPO8DVfTcMd3Ok+UpVl+BHuET78YD7yz4jHw8Fo5Kw2Cbmg==
X-Received: by 2002:a17:902:ec8a:b0:224:23be:c569 with SMTP id d9443c01a7336-22e863f13bdmr20015575ad.22.1746661618682;
        Wed, 07 May 2025 16:46:58 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151e97absm100792435ad.62.2025.05.07.16.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:46:58 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-arm@nongnu.org,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	alex.bennee@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v7 48/49] target/arm/tcg/arith_helper: compile file once
Date: Wed,  7 May 2025 16:42:39 -0700
Message-ID: <20250507234241.957746-49-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
References: <20250507234241.957746-1-pierrick.bouvier@linaro.org>
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
 target/arm/tcg/arith_helper.c | 5 +++--
 target/arm/tcg/meson.build    | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/target/arm/tcg/arith_helper.c b/target/arm/tcg/arith_helper.c
index 9a555c7966c..670139819df 100644
--- a/target/arm/tcg/arith_helper.c
+++ b/target/arm/tcg/arith_helper.c
@@ -6,11 +6,12 @@
  * SPDX-License-Identifier: GPL-2.0-or-later
  */
 #include "qemu/osdep.h"
-#include "cpu.h"
-#include "exec/helper-proto.h"
 #include "qemu/crc32c.h"
 #include <zlib.h> /* for crc32 */
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 /*
  * Note that signed overflow is undefined in C.  The following routines are
  * careful to use unsigned types where modulo arithmetic is required.
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 5d326585401..7502c5cded6 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -34,7 +34,6 @@ arm_ss.add(files(
   'mve_helper.c',
   'op_helper.c',
   'vec_helper.c',
-  'arith_helper.c',
   'vfp_helper.c',
 ))
 
@@ -59,6 +58,7 @@ arm_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
 arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
 
 arm_common_ss.add(files(
+  'arith_helper.c',
   'crypto_helper.c',
 ))
 
-- 
2.47.2


