Return-Path: <kvm+bounces-70416-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EIMCC2BuhWnqBQQAu9opvQ
	(envelope-from <kvm+bounces-70416-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:30:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CD62FA15A
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:30:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 98C7E3044D11
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 04:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09711347BC3;
	Fri,  6 Feb 2026 04:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nOJ4a5WI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB771346AF1
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 04:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770351727; cv=none; b=NQkWdyey6Vca9xK0m3fqXekggKinmGQHagYbK9m7eRXzj+jxT9x6shSqMKEvpZJJtH6O/EYXhw7iI0UIK6X0qwGbGbON/6EO5FmDhb7PdPFF/SepuwNNzQzG2rr2O3wzJyCDpCUKWRQEH7EVg8VtlZQoORhqn5xzgjPSOmJNrRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770351727; c=relaxed/simple;
	bh=D0bhT7PCieYa8POT94rgxCUTtFEU7xaKwmQnLhi0r1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js5ekdHaI+MZnxd/5BqCbodr9eJUWpA2XVuQqU2MdcE6VnmTLAuP0coNwR6sWPTTa5hz2dncGXQ/Pdy/9QIAXoKB6DEhnWsOuSiSugRZPdhQIshfRDvtQ4c7DCm92RR8ZE2tcrAvjQ59qHQ5MU6AbZhcRn38+ik2cKG1lfN/ZY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nOJ4a5WI; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-81f4e36512aso351809b3a.3
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 20:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770351726; x=1770956526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xUFdts3CrD2LjojjXcJUcXjopBDfFEshkWcx0O/wm9M=;
        b=nOJ4a5WItXmnrhm/RNUBj8w6hn4ISKUBLgrleRKRa/O1tA153x2v/paWRX8YH4SXAl
         vt83OHjfngT6cGaGZKPf+7o2UYW5KETbt8iGFqQWk1RcLDllKIm9+sCjZf9iYqHqfYdq
         A/1Kxu2Tm7s+0OiFwIs0NubN6By+GVjfmWTRv3YXB77XIE9ah4IxiH/wSx7dVBsCjUoC
         35jkGVFzpJZIEqH6KsSVnxFoSvv+90SBtrT3C0xCgYUACl3cZ7UP3jnQx+cmW7QJsbuD
         4Nh29yCgq+xxetNYTRKr89t5ULfTqNWxqkFAXMzFa0lAf/W17mFq5x1nv4px9ROw2W9Z
         tJLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770351726; x=1770956526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xUFdts3CrD2LjojjXcJUcXjopBDfFEshkWcx0O/wm9M=;
        b=iZMSk9EmugYCz5kF1ywDMaPFa7QAACCZsJxrtBm37AD+q4RYmgNaQE4dwUva0koz9f
         4xD8kxokB/K0/8J+TzParlWVLBIQsxO+RwZr5eio5gevumxx2heiqYC1LBhQd6jnVkr0
         db7yJPsHYFRQsihb4/J9e6di8sexqp/qErxOG+I5NVW600BcX0xvmSQfLClHnG2422cC
         w6/zQlOfZrVcqJ1wiLmUxTftgZ8kX0OrgZzyEcA12mE1Cf/EVV9ioAdjtD5hBQOQeurj
         WZfxgMNQeSKrvSZMuj6N5jCaeCHq4RJOu+rJ/E7/ru/LwkazFdqPaCzO+ve+pK68Dn2q
         upRg==
X-Forwarded-Encrypted: i=1; AJvYcCVJbe8ESXNjWTOLlMtrYC0OJm1ltCt0Rn6CCmXuPAqRqDTdEaIcjcBkxFLvLqv8hMwAWSo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3RY8Jt1ZN+Z71Hk8lwAlbHl17V/a/cNFL0YJqjfP8AyOH9Y0O
	M50Tcb/5vbKA2DFcgBFt9a7/4CjznpjQYsmFX/77XBO+H+xCpiIfacNKHJM8FDZDTec=
X-Gm-Gg: AZuq6aKZ+vjL01iuiku5gp08gFK15fKBAKRZpG8+OW/KlK7RyaMZQ8yaJYNebxsH2FW
	5bpDW1i1Wi0D6/l6obQ1+JbwnWwmV9KyfbCvR+1K4Sh+a0vjysEPjRQyrvjuyyzpbw7ys+DOXYJ
	L+pea++r7MKzTgLpYFrNViiQY5Rh0AYk/HEySqr+W5A1husQ/iJDlivZ52LlpKrgCkCQZbN+kHV
	6RWs61i61Edbt/LRoZAZ4Lgr3eFxHd/fPD1b1HDvRE+Wp1tBPB8RzxDhoRjQhAmWCp/Mmm+Qf5u
	C5EdxcH93+OGETccu4hThIqzVpyi+P1euKLGbifAvkfQp1ws9c0PWPFNv5Ubgtz4HLnY0fsZXed
	zKtCsE+HvXVja2eEqV1P8BdjpFQ8HKMqkwmw8TNDf1ETV7NmUY5EzbRbag1JT6Ql484OPhNVnP2
	ukljB3VszIpy/xveGzvdbGz5BTu7RhbinSSZThuB5yAzj4YfyeQ7+/TNuB9b/iLF4qi5plx4A83
	ok=
X-Received: by 2002:a05:6a00:4185:b0:81f:3957:2772 with SMTP id d2e1a72fcca58-8244160c6e6mr1317363b3a.3.1770351726160;
        Thu, 05 Feb 2026 20:22:06 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244168fdf5sm926914b3a.17.2026.02.05.20.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 20:22:05 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng,
	Richard Henderson <richard.henderson@linaro.org>,
	Jim MacArthur <jim.macarthur@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 07/12] target/arm: move exec/helper-* plumbery to helper.h
Date: Thu,  5 Feb 2026 20:21:45 -0800
Message-ID: <20260206042150.912578-8-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70416-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linaro.org:email,linaro.org:dkim,linaro.org:mid]
X-Rspamd-Queue-Id: 9CD62FA15A
X-Rspamd-Action: no action

Since we cleaned helper.h, we can continue further and remove
all exec/helper-* inclusion. This way, all helpers use the same pattern,
and helper include details are limited to those headers.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper.h                        | 13 ++++++++++++-
 target/arm/tcg/{helper.h => helper-defs.h} |  0
 target/arm/tcg/translate.h                 |  2 +-
 target/arm/debug_helper.c                  |  4 +---
 target/arm/helper.c                        |  5 +++--
 target/arm/tcg/arith_helper.c              |  4 +---
 target/arm/tcg/crypto_helper.c             |  4 +---
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
 target/arm/tcg/translate.c                 |  6 +-----
 target/arm/tcg/vec_helper.c                |  2 +-
 target/arm/tcg/vfp_helper.c                |  4 +---
 22 files changed, 34 insertions(+), 40 deletions(-)
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
 
diff --git a/target/arm/debug_helper.c b/target/arm/debug_helper.c
index 579516e1541..ec6a2b0c179 100644
--- a/target/arm/debug_helper.c
+++ b/target/arm/debug_helper.c
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
 #ifdef CONFIG_TCG
 /* Return the Exception Level targeted by debug exceptions. */
 static int arm_debug_target_el(CPUARMState *env)
diff --git a/target/arm/helper.c b/target/arm/helper.c
index e86ceb130ce..70227263612 100644
--- a/target/arm/helper.c
+++ b/target/arm/helper.c
@@ -10,6 +10,7 @@
 #include "qemu/log.h"
 #include "trace.h"
 #include "cpu.h"
+#include "helper.h"
 #include "internals.h"
 #include "cpu-features.h"
 #include "exec/page-protection.h"
@@ -36,8 +37,8 @@
 #include "target/arm/gtimer.h"
 #include "qemu/plugin.h"
 
-#define HELPER_H "tcg/helper.h"
-#include "exec/helper-proto.h.inc"
+#define HELPER_H "tcg/helper-defs.h"
+#include "exec/helper-info.c.inc"
 
 static void switch_mode(CPUARMState *env, int mode);
 
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
index 3fb24c77900..5a75e8b3e11 100644
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
index 4fbd219555d..5a510730ece 100644
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
index febb7f1532a..982c83ef42a 100644
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


