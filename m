Return-Path: <kvm+bounces-71311-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CLgRJEuLlmm+hAIAu9opvQ
	(envelope-from <kvm+bounces-71311-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:19 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 053A815BEEE
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5FD5F3018C2D
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 04:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 934B528688E;
	Thu, 19 Feb 2026 04:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FGbb4f0R"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9396B2773EC
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 04:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771473733; cv=none; b=MaU+15b0diX6sMbfANpz4ibFWi7rTNmNI8TJyO4H7FkUYmNGIUAwfq2Rn485360EEPBImbsMSO5/0FKtK6EcV0js+E5GlVrzhXXmGlzglf7BRkrad2AgRwROfnsbnOAjiVZZt+L/VGQNDWJBAh+lHG/FVaHVu670ExjV9pouUxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771473733; c=relaxed/simple;
	bh=JMiEeVoEYHBS1zUa79XppoJtYW0sLpMtlyr3eRl1gM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6VXOKacS0te7drxvV1+dcFkxDlSoKjb7NsL5B45MgXJKGJybWuf3KGveUw7f2IjDbnLO7mzIcY58hgodiMM2EwUfIvxfYFDgbm3/z48AaLAMjPUGOVBrKN7yHVfm5kMH7cNJfv+tWnITNVxqUX+/3YxuwnXhGYBpMGQZZxsWow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FGbb4f0R; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a962230847so3860125ad.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 20:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771473732; x=1772078532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZBh+fW1mApPtLG6aGnrKPAIWmAmzNuN5929rjSWR418=;
        b=FGbb4f0R64WQ23UHp+0IcfkZhWlfBlJH2Kk5vfElPgYGg6yt9FuM8gFZlbplv8ayn4
         qAohg7ITemA2AnlysjsaTzH3n7dufQMA29HnFIEXeD75KaqLsg+2nQ9mrTKgQVVOLXtU
         9ppvJBA3nMkrgVnjtgjt4W0CrZuf0/FHefjz4KvORN/3m3iWXahW8Sb+jTGZWNmQ3ohh
         WRE8iltvYeu8cWMn360oAq6PfQ9OCRwIGbQ5yyKWSRT4OQAXo2CFkzo7f+iPxkUlpW3C
         5eNAP1vFVjtWKHFVeuxTio37qG7ahi83pRtHYDi6qW4jNBKJ0oKybFtmTETaNnysvdOa
         AB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771473732; x=1772078532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZBh+fW1mApPtLG6aGnrKPAIWmAmzNuN5929rjSWR418=;
        b=qhY3k5/FtQiRJhcS5fqadAhIGpVBBDIbfawWJ73ooTp+qoLOFrnMkd5xjINeVJlJKo
         ad11wd2x2rpZFguodF1Im1fup/9TQYdvhc+LybCXspvdFU9eXNgcx1Z8YKrez+wb5Mwg
         KXA/uRi+uB7w48Yqnwb8u/6BVb0ZMxUTa7RxWov+xY2RNyQa4hbCGI87N3tREncInxjD
         /nQ+ySopI9OVzF1AGBusF2CFCYrr1R4PKHQz9zvlD+5uH65kQuhRJgammSgJBKZgKxhI
         KPH+XJRaj628v0yTg4hoQI1tUgk8ZTH4G0M29IQ/DcIPX4YaFOgZZB7qJGMVP3Xs++bL
         AKVg==
X-Forwarded-Encrypted: i=1; AJvYcCWMsGOOjgms9yY46apFM1zc1bTemL6LJ9aB1dS8KDq7Jwknj4tgkS3qN9Zot2zmkVzEyM0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzXNcItPGnm1CfAeYnq1l9HUhKj32s9wt9FCfjBOVUCA+JwKp9y
	vV5uYzr4kbqBpQVE/A1vUhLG+anPuA5sBZOG+F+yeKLDXEKsr+601XI1ErMHrYOQKZg=
X-Gm-Gg: AZuq6aLfkymgsvTIj/FD7UcBTP0K/KwxAAsQrvHgwMuT26fcD1rxtvSQ37YVoSoyx8J
	nM75pe6h6xBVvEZ5SvYR8L52s1LT2pPgKhCBDIkUFBv6Lr0FDukZb3i21dRaCQaqKnxnNkH0qac
	uj9bPxC+1ytkkPRhBRY7IqZUWo9E+Bu0onjlUHxtV2I/FABpxYBt8fgGLpEvbhukFF2MuQurr7S
	/0dMV52dHCTRS8eaNOJYPLarf5vjEVDnZxKskxzfV2VHwO6JPXd45VZlWgDTZoKrJEQ2feqBqhM
	7W0AtYJcb5CqyMxFOYwVFdYQ+shUEPzbhtI67kxnlEcUkKyYVt4k6Bx3zb3WLaa4teP6MecmVHx
	SHeLCz2NqI6E+9iNBqQInDXdwPnwOu72BZve/1Kh85PVRI0uGEQm/4NnxCqngrLYW0geetHfw8E
	BVRdskQFL4qh1AVLOMzX1W+u+rwATDluOQ43bNCm1tAB4vptQXamC/Bf3TTOreBa6SOK24I3kzg
	DiF
X-Received: by 2002:a17:903:46cc:b0:2a9:48ce:b5f5 with SMTP id d9443c01a7336-2ad50f8e23cmr33186185ad.51.1771473731894;
        Wed, 18 Feb 2026 20:02:11 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73200asm147636225ad.36.2026.02.18.20.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:02:11 -0800 (PST)
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
Subject: [PATCH v4 03/14] target/arm: extract helper-mve.h from helper.h
Date: Wed, 18 Feb 2026 20:01:39 -0800
Message-ID: <20260219040150.2098396-4-pierrick.bouvier@linaro.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71311-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 053A815BEEE
X-Rspamd-Action: no action

A few points to mention:
- We mix helper prototypes and gen_helper definitions in a single header
for convenience and to avoid headers boilerplate.
- We rename existing tcg/helper-mve.h to helper-mve-defs.h to avoid
conflict when including helper-mve.h.
- We move mve helper_info definitions to tcg/mve_helper.c

We'll repeat the same for other helpers.
This allow to get rid of TARGET_AARCH64 in target/arm/helper.h.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper-mve.h                            | 14 ++++++++++++++
 target/arm/helper.h                                |  2 --
 target/arm/tcg/{helper-mve.h => helper-mve-defs.h} |  0
 target/arm/tcg/mve_helper.c                        |  4 ++++
 target/arm/tcg/translate-mve.c                     |  1 +
 target/arm/tcg/translate.c                         |  1 +
 6 files changed, 20 insertions(+), 2 deletions(-)
 create mode 100644 target/arm/helper-mve.h
 rename target/arm/tcg/{helper-mve.h => helper-mve-defs.h} (100%)

diff --git a/target/arm/helper-mve.h b/target/arm/helper-mve.h
new file mode 100644
index 00000000000..32ef3f64661
--- /dev/null
+++ b/target/arm/helper-mve.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef HELPER_MVE_H
+#define HELPER_MVE_H
+
+#include "exec/helper-proto-common.h"
+#include "exec/helper-gen-common.h"
+
+#define HELPER_H "tcg/helper-mve-defs.h"
+#include "exec/helper-proto.h.inc"
+#include "exec/helper-gen.h.inc"
+#undef HELPER_H
+
+#endif /* HELPER_MVE_H */
diff --git a/target/arm/helper.h b/target/arm/helper.h
index f340a49a28a..44c7f3ed751 100644
--- a/target/arm/helper.h
+++ b/target/arm/helper.h
@@ -7,5 +7,3 @@
 #include "tcg/helper-sve.h"
 #include "tcg/helper-sme.h"
 #endif
-
-#include "tcg/helper-mve.h"
diff --git a/target/arm/tcg/helper-mve.h b/target/arm/tcg/helper-mve-defs.h
similarity index 100%
rename from target/arm/tcg/helper-mve.h
rename to target/arm/tcg/helper-mve-defs.h
diff --git a/target/arm/tcg/mve_helper.c b/target/arm/tcg/mve_helper.c
index 63ddcf3fecf..f33642df1f9 100644
--- a/target/arm/tcg/mve_helper.c
+++ b/target/arm/tcg/mve_helper.c
@@ -19,6 +19,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
+#include "helper-mve.h"
 #include "internals.h"
 #include "vec_internal.h"
 #include "exec/helper-proto.h"
@@ -27,6 +28,9 @@
 #include "fpu/softfloat.h"
 #include "crypto/clmul.h"
 
+#define HELPER_H "tcg/helper-mve-defs.h"
+#include "exec/helper-info.c.inc"
+
 static uint16_t mve_eci_mask(CPUARMState *env)
 {
     /*
diff --git a/target/arm/tcg/translate-mve.c b/target/arm/tcg/translate-mve.c
index b1a8d6a65c0..4ca88f4d3a3 100644
--- a/target/arm/tcg/translate-mve.c
+++ b/target/arm/tcg/translate-mve.c
@@ -18,6 +18,7 @@
  */
 
 #include "qemu/osdep.h"
+#include "helper-mve.h"
 #include "translate.h"
 #include "translate-a32.h"
 
diff --git a/target/arm/tcg/translate.c b/target/arm/tcg/translate.c
index c90b0106f75..580ec86c68c 100644
--- a/target/arm/tcg/translate.c
+++ b/target/arm/tcg/translate.c
@@ -28,6 +28,7 @@
 #include "cpregs.h"
 #include "exec/helper-proto.h"
 #include "exec/target_page.h"
+#include "helper-mve.h"
 
 #define HELPER_H "helper.h"
 #include "exec/helper-info.c.inc"
-- 
2.47.3


