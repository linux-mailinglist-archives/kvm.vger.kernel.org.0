Return-Path: <kvm+bounces-71317-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EImaMI6Llmm+hAIAu9opvQ
	(envelope-from <kvm+bounces-71317-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:03:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 25D2215BF2F
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:03:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C5CC1306361B
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 04:02:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3119A284B58;
	Thu, 19 Feb 2026 04:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L94jZG8s"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18622857CD
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 04:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771473739; cv=none; b=Q11PoZmZ2FOmXKTgZlM9MBqkZgvtnB1bVLQ2qDQB/leuJwVAUH2iG6xS4sOuBIevuiHUvNwD15LzBlXkvht7JM/5Mwgz4OFYv0ZdfAx14x1w52M43aeCcFg13iBlZcCwxxXdR8qb+HFaz+6Av4b3g/C1dHrYeQDI41hilbxN7Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771473739; c=relaxed/simple;
	bh=d3u78220gquna+Mo384veeFur85Iin+rKmmd5VJwli4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yn8DqRMc5u8M1Cgw65hkvrsTV/p7C6TkcFvaFezL/nXGhzPDEC3B8GM8oJ5gyrqpmhnRYvZClEWi2MXVzNb5cm2lNiepX6V7d4JRxGf/Xq18QOvbf5Drl+KzsCxWIL68fhee+QAnV2RTGqRCo3yudx1NlVj6CfVvzKf48mHJvZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L94jZG8s; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a7a23f5915so2427285ad.2
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 20:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771473737; x=1772078537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZWRAyQhu2Io6unvYUCtXe2P61Hg6zFaFVtChf0tU2A=;
        b=L94jZG8sIO0qohe8qXlSY+KIFSpd18fGIUSGKahSvYnXInsgdRDcerFOavByqLgZcC
         BXjuIJKJNYHzXlgPJvKTYUbccF5zfMd7I95bw3UGruBROG6w2hN0ptW/UJnbqYGXiPbk
         mRHyuUfYVe6geID5brMmYz3/Tk+FQHon/1aK/TZdfUqXdm77+hXRI4TE9TwfNtX/48WC
         7jYXS2cddFRUVSIb9ieXK3bQqaMNmfHwXf+PBp3Px6Qvs/+DtTEMtj7RGxP5a0Y5sWUP
         fdgUTmUPT4QlPscKYDi5NQr8aExNbbnZRFGWYkLOnu4CT512uCpeFOPiU6BRfyYSXZyW
         O8vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771473737; x=1772078537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vZWRAyQhu2Io6unvYUCtXe2P61Hg6zFaFVtChf0tU2A=;
        b=o6wMoR0eZ2eIZCXV5dsHcaaYvDPF/Qm2K68iDZfXtfTJxZRMMH/di9zp14euM3Pes8
         pOnfPxwtZzmOroU3rR7zSi/hjZXqjcxG7guz4nE7+ku5xueOIvSnfnfBetqR6eHWINjB
         k2BDpUNdrFieLQDPBsQa0IrycPNjs67msjFGB8q5UsF5gWSDOeKuHG6TQWTUa8nLYC/Q
         Ysc1kzuGlMUQ6LDOuuh8KfTCPzpgBgjKoyG+EIZUhzTJm5kBGKHVPV4knQRDfyaecl+o
         +OqTwWtaRzGlMCm4WtUXaNelNLGT6cTcbhTinGGSeqWpNoGj2HWiW6TYIb6BJySVlABL
         7wGA==
X-Forwarded-Encrypted: i=1; AJvYcCWtvKzQ+qepy3wtKM7CcYycFd8Cciplti0ghUZlM5Jhd6K4SlWynYa1koSRifdkTvzoppQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvzYh6YigGzdCsg0MQJZmrZbfePPewtGbI3s8M9VOyG3QNBWO3
	SBo2GCVJvuZTcu13piqsviBDhRX4PqjeVxddsQ21Gz4oN3vHcbRq8NcYYjX+OdiGrZw=
X-Gm-Gg: AZuq6aL+0zf0A37si45N6xK2r9ejjt+RhpRo0G2AuqhnlYurRgjJ9HVH4VqcvQz120p
	bi3gfjOO4CJtUeHHwJMqa0+3GSM3C3gWJwSxbaHQbjnVANIQS66zfrsM53IUYq2xMhU3wrwjq2q
	4XVhMvtyzzg9ZFGo0heZMWHq1l57Um+zQCJ3q2+0VgwpWUtLZ0ELTzjfCTn8F+4yhdp/NY60qmi
	2Au2Jff9AdS2yqxm/GP3BMuipGqQ/6FZcoj83lWQ5suYw5wfHCZvXLaY+YSizeJxEQbzICI7eTm
	XN3WPC3vVE9ztRgmqeBWxo4Z6GV5/wvQJSIZafhI6WP8Lyyv0UOJL8FE25Ie23VsuqS4OATT86E
	Aoj8LTZFsNuR++ieWsObhc/RrJlUa2dltLpibT42ytsZVr5OUd2C3owkwI9H92am9Zhx4D52+dn
	+b+9Y3cV3N2974PiY7uL4k3rY6OEu5dx2UnUV3hVYNr+p0eWOXiEWECjNGhkx2EvwAW52JeqtU2
	WW3
X-Received: by 2002:a17:903:2445:b0:2aa:dd98:197e with SMTP id d9443c01a7336-2ad5b16c9a6mr11371225ad.51.1771473737000;
        Wed, 18 Feb 2026 20:02:17 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73200asm147636225ad.36.2026.02.18.20.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:02:16 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	anjo@rev.ng,
	Peter Maydell <peter.maydell@linaro.org>,
	Jim MacArthur <jim.macarthur@linaro.org>
Subject: [PATCH v4 08/14] target/arm: move exec/helper-* plumbery to helper.h
Date: Wed, 18 Feb 2026 20:01:44 -0800
Message-ID: <20260219040150.2098396-9-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
References: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71317-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,linaro.org:email]
X-Rspamd-Queue-Id: 25D2215BF2F
X-Rspamd-Action: no action

Since we cleaned helper.h, we can continue further and remove
all exec/helper-* inclusion. This way, all helpers use the same pattern,
and helper include details are limited to those headers.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.h                        | 13 ++++++++++++-
 target/arm/tcg/{helper.h => helper-defs.h} |  0
 target/arm/tcg/translate.h                 |  2 +-
 target/arm/tcg/arith_helper.c              |  4 +---
 target/arm/tcg/crypto_helper.c             |  4 +---
 target/arm/tcg/debug.c                     |  4 +---
 target/arm/tcg/helper-a64.c                |  2 +-
 target/arm/tcg/hflags.c                    |  4 +---
 target/arm/tcg/m_helper.c                  |  2 +-
 target/arm/tcg/mte_helper.c                |  2 +-
 target/arm/tcg/mve_helper.c                |  2 +-
 target/arm/tcg/neon_helper.c               |  4 +---
 target/arm/tcg/op_helper.c                 |  2 +-
 target/arm/tcg/pauth_helper.c              |  2 +-
 target/arm/tcg/psci.c                      |  2 +-
 target/arm/tcg/sme_helper.c                |  2 +-
 target/arm/tcg/sve_helper.c                |  2 +-
 target/arm/tcg/tlb_helper.c                |  4 +---
 target/arm/tcg/translate.c                 |  9 ++++-----
 target/arm/tcg/vec_helper.c                |  2 +-
 target/arm/tcg/vfp_helper.c                |  4 +---
 21 files changed, 34 insertions(+), 38 deletions(-)
 rename target/arm/tcg/{helper.h => helper-defs.h} (100%)

diff --git a/target/arm/helper.h b/target/arm/helper.h
index b1e83196b3b..b1c26c180ea 100644
--- a/target/arm/helper.h
+++ b/target/arm/helper.h
@@ -1,3 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 
-#include "tcg/helper.h"
+#ifndef HELPER__H
+#define HELPER__H
+
+#include "exec/helper-proto-common.h"
+#include "exec/helper-gen-common.h"
+
+#define HELPER_H "tcg/helper-defs.h"
+#include "exec/helper-proto.h.inc"
+#include "exec/helper-gen.h.inc"
+#undef HELPER_H
+
+#endif /* HELPER__H */
diff --git a/target/arm/tcg/helper.h b/target/arm/tcg/helper-defs.h
similarity index 100%
rename from target/arm/tcg/helper.h
rename to target/arm/tcg/helper-defs.h
diff --git a/target/arm/tcg/translate.h b/target/arm/tcg/translate.h
index 1e30d7c77c3..027769271c9 100644
--- a/target/arm/tcg/translate.h
+++ b/target/arm/tcg/translate.h
@@ -6,7 +6,7 @@
 #include "tcg/tcg-op-gvec.h"
 #include "exec/translator.h"
 #include "exec/translation-block.h"
-#include "exec/helper-gen.h"
+#include "helper.h"
 #include "internals.h"
 #include "cpu-features.h"
 
diff --git a/target/arm/tcg/arith_helper.c b/target/arm/tcg/arith_helper.c
index 97c6362992c..cc081c8f966 100644
--- a/target/arm/tcg/arith_helper.c
+++ b/target/arm/tcg/arith_helper.c
@@ -8,11 +8,9 @@
 #include "qemu/osdep.h"
 #include "qemu/bswap.h"
 #include "qemu/crc32c.h"
+#include "helper.h"
 #include <zlib.h> /* for crc32 */
 
-#define HELPER_H "tcg/helper.h"
-#include "exec/helper-proto.h.inc"
-
 /*
  * Note that signed overflow is undefined in C.  The following routines are
  * careful to use unsigned types where modulo arithmetic is required.
diff --git a/target/arm/tcg/crypto_helper.c b/target/arm/tcg/crypto_helper.c
index 3428bd1bf0b..11977cb7723 100644
--- a/target/arm/tcg/crypto_helper.c
+++ b/target/arm/tcg/crypto_helper.c
@@ -15,11 +15,9 @@
 #include "tcg/tcg-gvec-desc.h"
 #include "crypto/aes-round.h"
 #include "crypto/sm4.h"
+#include "helper.h"
 #include "vec_internal.h"
 
-#define HELPER_H "tcg/helper.h"
-#include "exec/helper-proto.h.inc"
-
 union CRYPTO_STATE {
     uint8_t    bytes[16];
     uint32_t   words[4];
diff --git a/target/arm/tcg/debug.c b/target/arm/tcg/debug.c
index 7dfb291a9bf..5214e3c08a8 100644
--- a/target/arm/tcg/debug.c
+++ b/target/arm/tcg/debug.c
@@ -8,15 +8,13 @@
 #include "qemu/osdep.h"
 #include "qemu/log.h"
 #include "cpu.h"
+#include "helper.h"
 #include "internals.h"
 #include "cpu-features.h"
 #include "cpregs.h"
 #include "exec/watchpoint.h"
 #include "system/tcg.h"
 
-#define HELPER_H "tcg/helper.h"
-#include "exec/helper-proto.h.inc"
-
 /* Return the Exception Level targeted by debug exceptions. */
 static int arm_debug_target_el(CPUARMState *env)
 {
diff --git a/target/arm/tcg/helper-a64.c b/target/arm/tcg/helper-a64.c
index 07ddfb895dd..2dec587d386 100644
--- a/target/arm/tcg/helper-a64.c
+++ b/target/arm/tcg/helper-a64.c
@@ -21,7 +21,7 @@
 #include "qemu/units.h"
 #include "cpu.h"
 #include "gdbstub/helpers.h"
-#include "exec/helper-proto.h"
+#include "helper.h"
 #include "helper-a64.h"
 #include "qemu/host-utils.h"
 #include "qemu/log.h"
diff --git a/target/arm/tcg/hflags.c b/target/arm/tcg/hflags.c
index 5c9b9bec3b2..7e6f8d36475 100644
--- a/target/arm/tcg/hflags.c
+++ b/target/arm/tcg/hflags.c
@@ -7,15 +7,13 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
+#include "helper.h"
 #include "internals.h"
 #include "cpu-features.h"
 #include "exec/translation-block.h"
 #include "accel/tcg/cpu-ops.h"
 #include "cpregs.h"
 
-#define HELPER_H "tcg/helper.h"
-#include "exec/helper-proto.h.inc"
-
 static inline bool fgt_svc(CPUARMState *env, int el)
 {
     /*
diff --git a/target/arm/tcg/m_helper.c b/target/arm/tcg/m_helper.c
index 0c3832a47fd..a0cb8cb021e 100644
--- a/target/arm/tcg/m_helper.c
+++ b/target/arm/tcg/m_helper.c
@@ -8,10 +8,10 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
+#include "helper.h"
 #include "internals.h"
 #include "cpu-features.h"
 #include "gdbstub/helpers.h"
-#include "exec/helper-proto.h"
 #include "qemu/main-loop.h"
 #include "qemu/bitops.h"
 #include "qemu/log.h"
diff --git a/target/arm/tcg/mte_helper.c b/target/arm/tcg/mte_helper.c
index 01b7f099f4a..a9fb979f639 100644
--- a/target/arm/tcg/mte_helper.c
+++ b/target/arm/tcg/mte_helper.c
@@ -20,6 +20,7 @@
 #include "qemu/osdep.h"
 #include "qemu/log.h"
 #include "cpu.h"
+#include "helper.h"
 #include "internals.h"
 #include "exec/target_page.h"
 #include "exec/page-protection.h"
@@ -32,7 +33,6 @@
 #include "accel/tcg/cpu-ldst.h"
 #include "accel/tcg/probe.h"
 #include "helper-a64.h"
-#include "exec/helper-proto.h"
 #include "exec/tlb-flags.h"
 #include "accel/tcg/cpu-ops.h"
 #include "qapi/error.h"
diff --git a/target/arm/tcg/mve_helper.c b/target/arm/tcg/mve_helper.c
index f33642df1f9..a67d90d6c75 100644
--- a/target/arm/tcg/mve_helper.c
+++ b/target/arm/tcg/mve_helper.c
@@ -19,10 +19,10 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
+#include "helper.h"
 #include "helper-mve.h"
 #include "internals.h"
 #include "vec_internal.h"
-#include "exec/helper-proto.h"
 #include "accel/tcg/cpu-ldst.h"
 #include "tcg/tcg.h"
 #include "fpu/softfloat.h"
diff --git a/target/arm/tcg/neon_helper.c b/target/arm/tcg/neon_helper.c
index 8d288f3a700..69147969b23 100644
--- a/target/arm/tcg/neon_helper.c
+++ b/target/arm/tcg/neon_helper.c
@@ -9,13 +9,11 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
+#include "helper.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "fpu/softfloat.h"
 #include "vec_internal.h"
 
-#define HELPER_H "tcg/helper.h"
-#include "exec/helper-proto.h.inc"
-
 #define SIGNBIT (uint32_t)0x80000000
 #define SIGNBIT64 ((uint64_t)1 << 63)
 
diff --git a/target/arm/tcg/op_helper.c b/target/arm/tcg/op_helper.c
index c7ab462d1d1..4d708635068 100644
--- a/target/arm/tcg/op_helper.c
+++ b/target/arm/tcg/op_helper.c
@@ -19,8 +19,8 @@
 #include "qemu/osdep.h"
 #include "qemu/main-loop.h"
 #include "cpu.h"
-#include "exec/helper-proto.h"
 #include "exec/target_page.h"
+#include "helper.h"
 #include "internals.h"
 #include "cpu-features.h"
 #include "accel/tcg/cpu-ldst.h"
diff --git a/target/arm/tcg/pauth_helper.c b/target/arm/tcg/pauth_helper.c
index 5a20117ae89..67c0d59d9e9 100644
--- a/target/arm/tcg/pauth_helper.c
+++ b/target/arm/tcg/pauth_helper.c
@@ -19,11 +19,11 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
+#include "helper.h"
 #include "internals.h"
 #include "cpu-features.h"
 #include "accel/tcg/cpu-ldst.h"
 #include "helper-a64.h"
-#include "exec/helper-proto.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "qemu/xxhash.h"
 
diff --git a/target/arm/tcg/psci.c b/target/arm/tcg/psci.c
index 2d409301578..bca6058e41a 100644
--- a/target/arm/tcg/psci.c
+++ b/target/arm/tcg/psci.c
@@ -18,7 +18,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/helper-proto.h"
+#include "helper.h"
 #include "kvm-consts.h"
 #include "qemu/main-loop.h"
 #include "system/runstate.h"
diff --git a/target/arm/tcg/sme_helper.c b/target/arm/tcg/sme_helper.c
index 7729732369f..ab5999c5925 100644
--- a/target/arm/tcg/sme_helper.c
+++ b/target/arm/tcg/sme_helper.c
@@ -21,7 +21,7 @@
 #include "cpu.h"
 #include "internals.h"
 #include "tcg/tcg-gvec-desc.h"
-#include "exec/helper-proto.h"
+#include "helper.h"
 #include "helper-sme.h"
 #include "accel/tcg/cpu-ldst.h"
 #include "accel/tcg/helper-retaddr.h"
diff --git a/target/arm/tcg/sve_helper.c b/target/arm/tcg/sve_helper.c
index 16e528e41a6..062d8881bd0 100644
--- a/target/arm/tcg/sve_helper.c
+++ b/target/arm/tcg/sve_helper.c
@@ -21,9 +21,9 @@
 #include "cpu.h"
 #include "internals.h"
 #include "exec/page-protection.h"
-#include "exec/helper-proto.h"
 #include "exec/target_page.h"
 #include "exec/tlb-flags.h"
+#include "helper.h"
 #include "helper-a64.h"
 #include "helper-sve.h"
 #include "tcg/tcg-gvec-desc.h"
diff --git a/target/arm/tcg/tlb_helper.c b/target/arm/tcg/tlb_helper.c
index 5c689d3b69f..565954269f9 100644
--- a/target/arm/tcg/tlb_helper.c
+++ b/target/arm/tcg/tlb_helper.c
@@ -7,12 +7,10 @@
  */
 #include "qemu/osdep.h"
 #include "cpu.h"
+#include "helper.h"
 #include "internals.h"
 #include "cpu-features.h"
 
-#define HELPER_H "tcg/helper.h"
-#include "exec/helper-proto.h.inc"
-
 /*
  * Returns true if the stage 1 translation regime is using LPAE format page
  * tables. Used when raising alignment exceptions, whose FSR changes depending
diff --git a/target/arm/tcg/translate.c b/target/arm/tcg/translate.c
index 580ec86c68c..3f57006f9df 100644
--- a/target/arm/tcg/translate.c
+++ b/target/arm/tcg/translate.c
@@ -26,14 +26,10 @@
 #include "arm_ldst.h"
 #include "semihosting/semihost.h"
 #include "cpregs.h"
-#include "exec/helper-proto.h"
 #include "exec/target_page.h"
+#include "helper.h"
 #include "helper-mve.h"
 
-#define HELPER_H "helper.h"
-#include "exec/helper-info.c.inc"
-#undef  HELPER_H
-
 #define ENABLE_ARCH_4T    arm_dc_feature(s, ARM_FEATURE_V4T)
 #define ENABLE_ARCH_5     arm_dc_feature(s, ARM_FEATURE_V5)
 /* currently all emulated v5 cores are also v5TE, so don't bother */
@@ -45,6 +41,9 @@
 #define ENABLE_ARCH_7     arm_dc_feature(s, ARM_FEATURE_V7)
 #define ENABLE_ARCH_8     arm_dc_feature(s, ARM_FEATURE_V8)
 
+#define HELPER_H "tcg/helper-defs.h"
+#include "exec/helper-info.c.inc"
+
 /* These are TCG globals which alias CPUARMState fields */
 static TCGv_i32 cpu_R[16];
 TCGv_i32 cpu_CF, cpu_NF, cpu_VF, cpu_ZF;
diff --git a/target/arm/tcg/vec_helper.c b/target/arm/tcg/vec_helper.c
index a070ac90579..1223b843bf1 100644
--- a/target/arm/tcg/vec_helper.c
+++ b/target/arm/tcg/vec_helper.c
@@ -19,7 +19,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
-#include "exec/helper-proto.h"
+#include "helper.h"
 #include "helper-a64.h"
 #include "helper-sme.h"
 #include "helper-sve.h"
diff --git a/target/arm/tcg/vfp_helper.c b/target/arm/tcg/vfp_helper.c
index e156e3774ad..45f2eb0930f 100644
--- a/target/arm/tcg/vfp_helper.c
+++ b/target/arm/tcg/vfp_helper.c
@@ -19,14 +19,12 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
+#include "helper.h"
 #include "internals.h"
 #include "cpu-features.h"
 #include "fpu/softfloat.h"
 #include "qemu/log.h"
 
-#define HELPER_H "tcg/helper.h"
-#include "exec/helper-proto.h.inc"
-
 /*
  * Set the float_status behaviour to match the Arm defaults:
  *  * tininess-before-rounding
-- 
2.47.3


