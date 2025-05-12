Return-Path: <kvm+bounces-46249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7ED8DAB42CA
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 20:26:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44D1E4A29EE
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 18:26:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 817AD2C2ADF;
	Mon, 12 May 2025 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ja3FKcJ8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4CD2C2ABE
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 18:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073340; cv=none; b=aIf1z3f7qWUU0RuX7680npBeoL14lSVVZ0plKC6Kv5SY88mkjn8dWUcEBgpMmZy/kAHXvHm22OGKpeQKvdSkTPjIqLm9aw0JMBReve4IQpi8udTAv45LhiCE3wss7qh7D0WKVG6fwLcD/EuU7qUcjId7lYNy082ZQtbQsDEy34o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073340; c=relaxed/simple;
	bh=uhyN6OagJHA/8qpwacuXulq1J5vw7t7rKBFxacIElLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmDjS8GO1BLClz1QnFplnt0jVNCRHCEvzfTMWyQEEzpVl+Usv3XrtykcLNugFx1gpGVxDP8L8P6Wmy+pMklhJiMoj8gMlrJZ6pVmUNqwGeSfwvOlXEtjkncVVtxn5jJL1/uElcPD4XIVB0LfbkYbNT0GarQte0lYPT94tp7JMZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ja3FKcJ8; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7426159273fso1456631b3a.3
        for <kvm@vger.kernel.org>; Mon, 12 May 2025 11:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747073338; x=1747678138; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D50FgSNi0pKqcQ8O05hlTOFeOSvMmvlw2mBrg4KVMZU=;
        b=Ja3FKcJ8fppEnZ0zQbX5Gc2FgfyuR07QP/xYixBLFZPz99lDofXkx5AJNSe2nFpEaa
         OpXqNplTrQERc+QkETrtSgSsgAnl2kvIfm+pWKofT2tAAnDPPb75GpixHPHE5E/Ug4aS
         2zWBKEqQOBXgzTbMAtz8b0h+Xvb+LDtfJtLDLnncTamxJ5UM+94z87lIkq/xO9sOeNiM
         Lg+hrAv0890nNabpPGdUOZQ56ZeFoERf6Ijcgj9nPR4ft5Ao4H+rJ06ays6cg7gSlLy8
         IRt/RpJRRXMcZWszExbgYFw4QdZmoc890ZwQcCmE0oDvnM46/23CSG/GOdmNPrDgpjvM
         kNfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747073338; x=1747678138;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D50FgSNi0pKqcQ8O05hlTOFeOSvMmvlw2mBrg4KVMZU=;
        b=c6/BI7WXQj4Hgthl6S2qYXeLaglQgTiYykAb4YdsPJ3H0Tro+7+jo+OeEYFqoSYMCC
         E2bbhbKrkjHYcXvOnWP8/95t8mVq55HdZ3fmSz+tGVPkAQRtqmLUU2aB69DHhvWFtS/S
         nil/YO0AfB9aTkRd2xf81Ck5tZ4KfqGpXGLtEy3uTSKqojuxD+GGIlphrC11RqDTEsA+
         GoHxDm5H166N7Qz+c7oqwB+AsjWiN4Qa0vP0iARcX03EgGoiw4tOKGteUP83WQrPZqHs
         uK69+M1+25J3s+wizM9HBzVxH3EzRa7KqpNXSgMLvf7oJxkcBV4dZFyOxtvCaJa/94Sl
         Vymg==
X-Forwarded-Encrypted: i=1; AJvYcCXKz8f9lOvf2YXO8kbeKuEZ5fkAiz/do3M7Bh/I5EjqImfXwCsXaQDaC3MellQ/IX1KicA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK3ZcoJxvluZY2R5S0yZbIh3O2LZDP5aJTa2rzDdcf/b5dk42M
	HPplimLzlnqipByKvblsTGs1oVFLfkC4nqESc6McDW8LAYJWx2VISegwvTViRSY=
X-Gm-Gg: ASbGncvuCBiBSovDaATJGN6RbSRI0uaufXtYhjTVsQa3KK5FHgwJioYu15o/Atbvq6X
	RX89GpstxwfLwSijENwLCrEQ6Nss9OdYKHd2VAcnqe14XQSy2E/mB9b19ugqTXwEhOWlguNs5Ot
	GRASIvciXHUk55s0QPZsNWCygQ6Vt0a34HEe0ftGqcVHpE/TiFtW6iXY+zcfcAegPE5/1bYhAXN
	/a/mliJ+HaRT2dC8y/ewodLswdZG1z5D+Kvsc0U1CL3nRKLPpnrFfL4GmK9eWbYzZjEgf9OmQYO
	RZ06kHH59hQ4eqWnrEbhTbT66lEpVIxFrVebd6l/6T9hNfyBYDc=
X-Google-Smtp-Source: AGHT+IHa8ReBvuhLYNJVfoOgw0HWEvZH8paPUe8+ITjOAG70MzmSvDV21eTP7FYFx9n7u6IDXuMTaw==
X-Received: by 2002:aa7:88d5:0:b0:740:9d6b:db1a with SMTP id d2e1a72fcca58-7423c05b18bmr18505517b3a.15.1747073338398;
        Mon, 12 May 2025 11:08:58 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237705499sm6438580b3a.33.2025.05.12.11.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 May 2025 11:08:58 -0700 (PDT)
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
Subject: [PATCH v8 47/48] target/arm/tcg/arith_helper: compile file once
Date: Mon, 12 May 2025 11:05:01 -0700
Message-ID: <20250512180502.2395029-48-pierrick.bouvier@linaro.org>
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


