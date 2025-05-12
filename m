Return-Path: <kvm+bounces-46245-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0969BAB42ED
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F0AC67B63C8
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AF1B2C2AAE;
	Mon, 12 May 2025 18:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Zotq9U0G"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC26C29993E
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073337; cv=none; b=jwH1p2IZXtIUBTRcNR5qydla+OxeRP9ZEDW/2jqLkkwkjIw+EXPbiGZqkWYejuaIBoI48nhw5WtvBQTxaA5VUgtmOjm1nHJ1PXwQZ8DMFPZ+QnboNCJdqsC1yn54WHva49Syq8YzQnDJ2HZgkRxmhlasQBe9ljTG4EhjOoVIiUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073337; c=relaxed/simple;
	bh=VnT71K8Ea2O5Onxo6pSBB5UNJtKdovZ2hzSFYNY+2bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YXBLf2rKU3VoF/+eO5j4wv6eS+HABoR/UrEB1T4diTS426QnqgCJCnzeMMq5udSsr83HrimhKbDb/OCv3mcjWUOZx9psr8/6CrtGvZWvfpdNm/9A6Hv3889WSqo3aY9dYv1oz1oYt0Wxebchim+APyWrc0zFstvJ3JDuPQkgIiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Zotq9U0G; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-739b3fe7ce8so4407162b3a.0
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073335; x=1747678135; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=11Q55+gMF5u6Eo9NyNW4V+s1ceVG/+YyEcTpuHMGI4c=;
        b=Zotq9U0GTWCdEXp4HFLJx9lC7ajsjXLz8ZHiuHb2Iiswox3r8BFDrrM7Q8DOr0Sxo1
         RcZl0jGrE6Qx5bEi+9m9rMs6acwXRz3NAkOWESDFOna4WhR90T4T/gF6sF9uylBvkdQx
         0iJDqpbDKIqCjnoxElRTP1RLkLNPL2fv2JXVaUkPRR9hkNZ4vMDjIJYIimMOipAIzjmX
         lpv+KK+O5rQjNx6V7xX6aZp4YiGADiLlq67QV1pMKIw7uJ6Y9Rl4OD7CPJ+Y/wcQHtXt
         FDsmpCq/RFIz5rTPBY5nKdcxpX13sw2QiQqLBPavzwRxnsxf4WXk7l11FQeqMXWke2fd
         wgOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073335; x=1747678135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=11Q55+gMF5u6Eo9NyNW4V+s1ceVG/+YyEcTpuHMGI4c=;
        b=HXKw/GLxdfJBHoKY1f5PKgy3MIBtI/BE3bEqd8LExggVzM/0Jdf1RASGrv+kyw3EGA
         522rAClsrxgl8LsKxqy8ooCwXGonwZ21n/OuCdzLNn1P2dm0CYfYLzjB5Gv59IZAWM43
         Ng1qX6S019vZ2LdBRoPCVENXIXlCJXFR6PE1HOOJ/L49Jnxj03Dwyg7/FgfEK32VMhhe
         GBwRQm89MFCYh3dxZinOaTdLYsbqQAzh4OVyijfPap/3oAIMt/e0gdpNUCeAdY3bf7Mu
         ydEn0V2AaQ3PUTWVc+fhmbkCLY51+KiWrunxRc+SH+p79p36uLCTaXDNmnONMSSsKkTy
         a4Yg==
X-Forwarded-Encrypted: i=1; AJvYcCU0BNA2/5d1Nj7f0m2ki4RviD+1186q8zkS76zcNcA8I2JIESSXymhFrIIZChFTQ/UJ1FI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1F6/sI6V7kVj/vUTEQ0OGdvkhCAq+kZK3ThVppD2AsDGrhg/Y
	QpN9qXJHJbUykDdOO5o4h+Sa6CQ5UD1OLNqX0o8OJFFW8xN/CMlSbD5dORLKb2w=
X-Gm-Gg: ASbGncuBn2unR3RRZIzlQmXq+X4Hhk5DoDbwbvYLkHjjfWfSQlakOBstIKF7I1KzMSF
	NuO1TrG5zUaj2Nupj1TClKSF/71CQJIeHD6gWWK+/WHkgf5NGYhJXvC0hZvbQ7Ovp+LpsJ1qPCv
	Frf21hVECG68eq540bSSzd2FsO3sw4ae/7BJCmvWefTsZ4PooRXm06qnWVg3Box41/HR+RTz3Vv
	4UYovDjGdXnlnTM5SXVbnRyJXP5JHlv7R14c5Hapvz6NQavkuxwGUZ7rVQRB2gxTxghMt0u05gM
	/2Ayj31Ma+nMNUbePWk6KE5ZLPXA7Je46p5Ba7U0jUbKiw5BIS8=
X-Google-Smtp-Source: AGHT+IHHZxH27Fblpk+T6nzSm6gwzWmiuunS0CeLF3GYhXIAV+SAz8d1QBV/IJKqUKfOEduj/U+Kxw==
X-Received: by 2002:a05:6a00:a10:b0:740:9d7c:aeb9 with SMTP id d2e1a72fcca58-7423c0737cdmr18544639b3a.21.1747073334907;
        Mon, 12 May 2025 11:08:54 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237705499sm6438580b3a.33.2025.05.12.11.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:08:54 -0700 (PDT)
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
Subject: [PATCH v8 43/48] target/arm/tcg/neon_helper: compile file twice (system, user)
Date: Mon, 12 May 2025 11:04:57 -0700
Message-ID: <20250512180502.2395029-44-pierrick.bouvier@linaro.org>
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
 target/arm/tcg/neon_helper.c | 4 +++-
 target/arm/tcg/meson.build   | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/target/arm/tcg/neon_helper.c b/target/arm/tcg/neon_helper.c
index e2cc7cf4ee6..2cc8241f1e4 100644
--- a/target/arm/tcg/neon_helper.c
+++ b/target/arm/tcg/neon_helper.c
@@ -9,11 +9,13 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/helper-proto.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "fpu/softfloat.h"
 #include "vec_internal.h"
 
+#define HELPER_H "tcg/helper.h"
+#include "exec/helper-proto.h.inc"
+
 #define SIGNBIT (uint32_t)0x80000000
 #define SIGNBIT64 ((uint64_t)1 << 63)
 
diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 02dfe768c5d..af786196d2f 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -32,7 +32,6 @@ arm_ss.add(files(
   'translate-vfp.c',
   'm_helper.c',
   'mve_helper.c',
-  'neon_helper.c',
   'op_helper.c',
   'tlb_helper.c',
   'vec_helper.c',
@@ -68,8 +67,10 @@ arm_common_ss.add(files(
 arm_common_system_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
+  'neon_helper.c',
 ))
 arm_user_ss.add(files(
   'hflags.c',
   'iwmmxt_helper.c',
+  'neon_helper.c',
 ))
-- 
2.47.2


