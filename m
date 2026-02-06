Return-Path: <kvm+bounces-70412-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0CiuK49uhWnqBQQAu9opvQ
	(envelope-from <kvm+bounces-70412-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:31:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 294FFFA171
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:31:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 47229306EC95
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 04:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5278D344D8F;
	Fri,  6 Feb 2026 04:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S8IjDQL1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA8D34404B
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 04:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770351723; cv=none; b=vDT7i7hvb8FVDo220CxUeeNMx/F8cQespFWbo7XtoJGicAFEKHZ8dn0NoJ7p6TGHmhFu84wgJV8AgrLvw7ZN41rXcbr/FiaksVLb5AjDgjLMXMCpUaYhosVGvXOITGVZOqXIPTCMJL9m/GSckdTFJIh4eTrIG1M/fx5cASWmCgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770351723; c=relaxed/simple;
	bh=jPI7mC3Y5rhaHy3Z3hG7ywAzHNCkmXgZY8j3MNhlWNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ESpYOeA1TuFPn7jNPRsAk2nNN+uxnATlSln24k5BfPmKKvzjTFwEaGVIXSRBw6oSW91E4HNR0mR7FCeI9jICQNKilOphQzY7PcHAnNYknAoHirbHXDbcCwilMxYFMaaNs/MY2waw/CwxA1V94vazWQ0q9272MfIfdGbGT7mFBNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S8IjDQL1; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-823f9f81da5so896344b3a.1
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 20:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770351723; x=1770956523; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Lk/jdHTDjt74Lp5Po40mEBHEbq+K7p4bEQ2ho7U/vE=;
        b=S8IjDQL1lX/w7Bruszf6z6q6B+0+glvrfEijI6OicUPzGC2i44qQMTr6d3BUuVfgFT
         Ivre7dkvn/6z4zr0bNBpjqZXFhb0ub3C1kZOXA2zdbYjFDLkgARILA8NTkCL8KddYtGi
         2WGwxALHn5XuO18MqQALiTCkfq/tN7Y0LE/q6tksU2REepjGDkmLOJQNkn5C3SmP+nat
         IChi0dbU2ov73j5ULkwZkPa7PpQrpSBTkLMxLqwWCQHSUtoA3GsZ8jhlwHsFK4/AbMJk
         OIKuSHEq4rvsR80UFAjlfq19tB+FkjF99XdFsGsMqnJIQopaarCKpvVUKwld2GiTUdOH
         WxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770351723; x=1770956523;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3Lk/jdHTDjt74Lp5Po40mEBHEbq+K7p4bEQ2ho7U/vE=;
        b=Th7OOJEis+aKKoLeSe8PL+Fuesb7KoUA0qdU+zm0RhMY6q0ULg1EbZanSq6XMoZVMu
         IHlTZV8a+MqCYuOSN0ZIH4hVQEWDliRp8Atnur2peWL/gFnBD/1qrcTFoD/ioSrQWycP
         E8wHC4q2xp9TBstApAKrqgJ2sbZbTM32A0TTdZgc1abpmcoMJ1k5K93PnvN9rfOTqJwv
         GT4g/ao6d6QwBIjx3p0pzgp+4jwTp4YQczoNZ/DSPJEQz/Mulc5gnMrgz4ZNwolazMfr
         2P6D0w88XfYtw/ZKbxhufP5WfA+oVlNj4a0A4HWdugXRwloTdUcWJDP8MmFeS5Twtqcc
         A45g==
X-Forwarded-Encrypted: i=1; AJvYcCX1NAgLVgOpTl5H9PkyREsP2uKx4na0bsEfmq/st6VBPPrmtKzlUE7nrQi89zZitAMrWuQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxbvZ4ae+GzxWvdqdwaaoO5EQ8uXpaOBoFas+QKdg2DfEJItBRB
	43c1Pyd6mjwOWSGN76VhQ++KX7iLiUkvJiZPJm/EIGgYc54aOS7HzQ8yR4SLwTNbH2c=
X-Gm-Gg: AZuq6aLPR5mPXtxCmlnmO4ozLwUoDjT5cDzmjLgsN/HGhZefRkyL01WCyvGMkfONRmz
	QVDPGKslbMycz62GVTz9UJm5FUd+XS1HGSRRNUN0smeQckMUVI2Qj47SFhbCbXH1icVjW91aadp
	6ISrOpPKRdyVHHQynXPAm040TwKebG8kaCZX2/YGHUpRS413wHxZkktijlIyhM462/8Xamw479M
	FNDKagej+5zRF5Yn8xZ2fDCW99XnhH28Pn5rA3n8PsaOQcBO816NS598N0jb8FKp5Zi96HvDot5
	SjpxwsePD/gX6wYde3GOSZT1i5p1vmH+RzeX9SnSjNw+dEdGN9KrjCxkTztWYSP+kKiRwQU4mpA
	+UtWU15LYdXGQaf1Od05LIJqboTaeyN867yniuwRqAkPIMvfGx6v1okSwpV3rAKiDEeIYw8vkw0
	t7+ekXI1dnBANidlfN1SUlXInQ4oGeT0wSTPAR8zLI9vUZayDbMZYyuNqnDOXbAqJC
X-Received: by 2002:a05:6a00:4215:b0:81f:3d13:e07b with SMTP id d2e1a72fcca58-824416f29bfmr1053511b3a.43.1770351722621;
        Thu, 05 Feb 2026 20:22:02 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244168fdf5sm926914b3a.17.2026.02.05.20.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 20:22:02 -0800 (PST)
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
Subject: [PATCH v2 03/12] target/arm: extract helper-a64.h from helper.h
Date: Thu,  5 Feb 2026 20:21:41 -0800
Message-ID: <20260206042150.912578-4-pierrick.bouvier@linaro.org>
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
	TAGGED_FROM(0.00)[bounces-70412-lists,kvm=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:email,linaro.org:dkim,linaro.org:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 294FFFA171
X-Rspamd-Action: no action

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper-a64.h                            | 14 ++++++++++++++
 target/arm/helper.h                                |  1 -
 target/arm/tcg/{helper-a64.h => helper-a64-defs.h} |  0
 target/arm/tcg/helper-a64.c                        |  4 ++++
 target/arm/tcg/mte_helper.c                        |  1 +
 target/arm/tcg/pauth_helper.c                      |  1 +
 target/arm/tcg/sve_helper.c                        |  1 +
 target/arm/tcg/translate-a64.c                     |  1 +
 target/arm/tcg/vec_helper.c                        |  1 +
 9 files changed, 23 insertions(+), 1 deletion(-)
 create mode 100644 target/arm/helper-a64.h
 rename target/arm/tcg/{helper-a64.h => helper-a64-defs.h} (100%)

diff --git a/target/arm/helper-a64.h b/target/arm/helper-a64.h
new file mode 100644
index 00000000000..cda7e039b72
--- /dev/null
+++ b/target/arm/helper-a64.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef HELPER_A64_H
+#define HELPER_A64_H
+
+#include "exec/helper-proto-common.h"
+#include "exec/helper-gen-common.h"
+
+#define HELPER_H "tcg/helper-a64-defs.h"
+#include "exec/helper-proto.h.inc"
+#include "exec/helper-gen.h.inc"
+#undef HELPER_H
+
+#endif /* HELPER_A64_H */
diff --git a/target/arm/helper.h b/target/arm/helper.h
index 44c7f3ed751..79f8de1e169 100644
--- a/target/arm/helper.h
+++ b/target/arm/helper.h
@@ -3,7 +3,6 @@
 #include "tcg/helper.h"
 
 #ifdef TARGET_AARCH64
-#include "tcg/helper-a64.h"
 #include "tcg/helper-sve.h"
 #include "tcg/helper-sme.h"
 #endif
diff --git a/target/arm/tcg/helper-a64.h b/target/arm/tcg/helper-a64-defs.h
similarity index 100%
rename from target/arm/tcg/helper-a64.h
rename to target/arm/tcg/helper-a64-defs.h
diff --git a/target/arm/tcg/helper-a64.c b/target/arm/tcg/helper-a64.c
index e4d2c2e3928..07ddfb895dd 100644
--- a/target/arm/tcg/helper-a64.c
+++ b/target/arm/tcg/helper-a64.c
@@ -22,6 +22,7 @@
 #include "cpu.h"
 #include "gdbstub/helpers.h"
 #include "exec/helper-proto.h"
+#include "helper-a64.h"
 #include "qemu/host-utils.h"
 #include "qemu/log.h"
 #include "qemu/main-loop.h"
@@ -43,6 +44,9 @@
 #endif
 #include "vec_internal.h"
 
+#define HELPER_H "tcg/helper-a64-defs.h"
+#include "exec/helper-info.c.inc"
+
 /* C2.4.7 Multiply and divide */
 /* special cases for 0 and LLONG_MIN are mandated by the standard */
 uint64_t HELPER(udiv64)(uint64_t num, uint64_t den)
diff --git a/target/arm/tcg/mte_helper.c b/target/arm/tcg/mte_helper.c
index 08b8e7176a6..01b7f099f4a 100644
--- a/target/arm/tcg/mte_helper.c
+++ b/target/arm/tcg/mte_helper.c
@@ -31,6 +31,7 @@
 #endif
 #include "accel/tcg/cpu-ldst.h"
 #include "accel/tcg/probe.h"
+#include "helper-a64.h"
 #include "exec/helper-proto.h"
 #include "exec/tlb-flags.h"
 #include "accel/tcg/cpu-ops.h"
diff --git a/target/arm/tcg/pauth_helper.c b/target/arm/tcg/pauth_helper.c
index c591c3052c3..5a20117ae89 100644
--- a/target/arm/tcg/pauth_helper.c
+++ b/target/arm/tcg/pauth_helper.c
@@ -22,6 +22,7 @@
 #include "internals.h"
 #include "cpu-features.h"
 #include "accel/tcg/cpu-ldst.h"
+#include "helper-a64.h"
 #include "exec/helper-proto.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "qemu/xxhash.h"
diff --git a/target/arm/tcg/sve_helper.c b/target/arm/tcg/sve_helper.c
index c442fcb540d..0600eea47c7 100644
--- a/target/arm/tcg/sve_helper.c
+++ b/target/arm/tcg/sve_helper.c
@@ -24,6 +24,7 @@
 #include "exec/helper-proto.h"
 #include "exec/target_page.h"
 #include "exec/tlb-flags.h"
+#include "helper-a64.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "fpu/softfloat.h"
 #include "tcg/tcg.h"
diff --git a/target/arm/tcg/translate-a64.c b/target/arm/tcg/translate-a64.c
index 7a8cd99e004..1a54337b6a8 100644
--- a/target/arm/tcg/translate-a64.c
+++ b/target/arm/tcg/translate-a64.c
@@ -18,6 +18,7 @@
  */
 #include "qemu/osdep.h"
 #include "exec/target_page.h"
+#include "helper-a64.h"
 #include "translate.h"
 #include "translate-a64.h"
 #include "qemu/log.h"
diff --git a/target/arm/tcg/vec_helper.c b/target/arm/tcg/vec_helper.c
index 33a136b90a6..7451a283efa 100644
--- a/target/arm/tcg/vec_helper.c
+++ b/target/arm/tcg/vec_helper.c
@@ -20,6 +20,7 @@
 #include "qemu/osdep.h"
 #include "cpu.h"
 #include "exec/helper-proto.h"
+#include "helper-a64.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "fpu/softfloat.h"
 #include "qemu/int128.h"
-- 
2.47.3


