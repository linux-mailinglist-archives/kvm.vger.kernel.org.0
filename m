Return-Path: <kvm+bounces-45806-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 69387AAEF8D
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 01:47:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06DDF1C0390C
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 23:47:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AACF322F17A;
	Wed,  7 May 2025 23:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qBU1hkBn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E371DB34C
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 23:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746661614; cv=none; b=AhHTrxYgDaig156ZVPsGaF++K+u8AaH8PqRhqxDY4pMnLtasROoPfpbEBYfWN1gkZGQcwdVigySNTgf2CREjXUQOYuNOs51Pc0rlnZqk1y6cPmS0AdHergLDjwMo2XEmZPFgrcJcKxEZ0gUQqKhJTgdbyD4ujNp8cEoAEhV6sK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746661614; c=relaxed/simple;
	bh=/lu3KcFQJp1ktQSA3dnNuTLGiYbSSIW7YxN3jDC7Nyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c669CyoulBHxM7FKHPPPxVMWMtDNHd5SDI+BJYAP2m7zlvtbOCnsvJTF3JHMN7S6k7Gm6VWt4miJmU+3B/HUoPVF5XBs1I6iPkIFPzyL30hmyxKVn/tJsDtc0AaTRTxCfr0GwQfgopezBToWHScYHRAigBBbw3UDu8VFNp92WZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qBU1hkBn; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22e09f57ed4so17076195ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 16:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746661613; x=1747266413; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=45kfheSbx4dAVwou8HhqFlnvbUQXjacWSTonOtivRHk=;
        b=qBU1hkBnNuG/TbZncpjUbpE9aeeTAo7RENIPez3RkNk4feIT9kmJg1+2cU8XfLQdw3
         GOEJn60jbbRTCqzFe9U064WuS3xarkNfyxnklHv6bg6K+SZ1qswD6OaYV5RX9Fjo4mTK
         THY+veXXdlaN3RQncelC5EJ8Tn0P+pUJjQkRvFSKJRwYzQLfe9HPhs0Sh9Hx2OIXOh3Q
         Vz1VZRhg3DYlX/SM7rGq0HaDf//B0cl+Zv7Kd79ADsvQVc4NlJ0x3xprqIN6d30U7f8b
         goQmcgl+wEqfGrmbcTZOWsXsUwCQw4M3EvWe7zHGyyJ2haKX6PNcRtiPSdjjXd2o4uAo
         aOOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746661613; x=1747266413;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=45kfheSbx4dAVwou8HhqFlnvbUQXjacWSTonOtivRHk=;
        b=TkZVsXOLEBbJcw+5ljjh5khGCrjbLikY+7lL+qIL3JJA2hXNJ/D/bCBOmRvoxMkLxT
         wUU1x8MbwdmWvziad+oLj7vHBZOXQ82N92iJ8zGf9K8k+REC+/jhbGCkNXOsv7Zl6oj/
         Kj79ZMxCF1/i5JeDRmfHtN5KS/DSo4L+176vQTWp2KtK9MhubieJcI5oKOLx6uBqycCC
         xN4JFHkeo097sgnaMCqMBYfYvzr6IbSfak/b4Tz/W2Pd7ak9f+BM9qdWQ+459yMasBAX
         WJa6Xk6szJ9khc7EVmn2Lz8Q6PEM50/9BVTWTlxmq42ACGJz/0Odo6RX7Kja8n0uaGtV
         LsHA==
X-Forwarded-Encrypted: i=1; AJvYcCUOet7kjJrm0uG1nvJIKtEYMwWZcs+2/1FEsou/HI/kUfyeOOQZGPtKsOGGSfeZOU0vBwo=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywr4kZQ3EF8sJm5mJFJIlWlf+HV9N0HXI55GhBKHxqLI1A9aQBl
	yHDnxw00ruDe6y5BztNjSKNEHLaWaqX6V2DT2lu/ebVlxJvtPNw6/8UJaKKkTPA=
X-Gm-Gg: ASbGnctZKg7xW8yTNaxJiRXRw/75nHVje8VkVlUrDkrB7bOxIFkc0iNJvFTV0+N46Um
	pShB/uAFQ+Fs0zAbIqH/6o4acCJFt4RSKBp50MvvaAU6JwJFwMJefofOQzOYmdczZpCN6Vi3mqb
	6fx3HX3P6/ISdsRYgfYWJ2Z5Lql6bGeuX3PHBWbz+2DE5tI5aieC4LdM/T797bxzifFvMzOincQ
	d9BfEkxjY3hTZ+WISIx+bLtLnmX8pgA9N40QZkdmp/xTAe7SBuayHlxTS8ekSqZ4COTyrGON2xo
	86sH197a+e4wxlxsqWBgkVAhJIHSddOwmrYepKxZ
X-Google-Smtp-Source: AGHT+IGWvpZIZhAgezTm3+CpU6FhffPhuJ9OaI0G4/I1LkJJeHKcE9WZB+AxsD5YfZnzuRYarly32A==
X-Received: by 2002:a17:902:ea0e:b0:22e:491b:20d5 with SMTP id d9443c01a7336-22e847990b8mr19124445ad.26.1746661612749;
        Wed, 07 May 2025 16:46:52 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e151e97absm100792435ad.62.2025.05.07.16.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 16:46:52 -0700 (PDT)
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
Subject: [PATCH v7 41/49] target/arm/tcg/crypto_helper: compile file once
Date: Wed,  7 May 2025 16:42:32 -0700
Message-ID: <20250507234241.957746-42-pierrick.bouvier@linaro.org>
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


