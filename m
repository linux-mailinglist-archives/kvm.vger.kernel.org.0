Return-Path: <kvm+bounces-70784-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kJEaMgCSi2kVWQAAu9opvQ
	(envelope-from <kvm+bounces-70784-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id E25B011EF00
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:15:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 944BA30131DE
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B4993321B1;
	Tue, 10 Feb 2026 20:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d8ihLdTP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2AC29A9C3
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770754548; cv=none; b=r5JHr9uZ8swA8SqUKiXVLJWq76Dna3QZ48iXcTabX4wrBh+eK1PLYOfni/YnCDmEh7b6Gs/XmjNLTJQ6kXJ+az3P/BceBwlpMwn59/F+3Fn9SdA23H+vnohbyX9g5ExMVOfFWk2vbyGiqb9rVSEJqr4H5iNJvkG4vMKRyjdcBHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770754548; c=relaxed/simple;
	bh=ZDUExGIJRv02qRGXLYBupE4GuTM41hei9uBet5bTl2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfbZ8POZWjMRI3avkU55Oj1TlGlRDJ1eBKJ+pyArTXvYdF2fWxUHARp3lUpc5oh+cTIeUEQgDl0RA48Es8fNx2+lWb7W7NL7tqpcm31M2Bun3nAsi++Se80VJneKoy5ycJ9U6kPD4JrGjsHYTdShGiUDBw4b52q+1LXO4Mk6dE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d8ihLdTP; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c698873a1deso562805a12.0
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 12:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770754546; x=1771359346; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2plFct/EpqGzjEx7nOv5ScJhI5BtmBrKmQ1/sromkc=;
        b=d8ihLdTPbGxsQ+SaEQmIodh/FQCQC7OqT4jaV3GPOK91yEsamwCJcse1D59cXwbk18
         w3wtSjXa1Rbg4QQC0vnWI/V1a6CCLOs/t2IpFGjrsEmNoo3KobG6A2d2eD8DLuf5774t
         BH2BmIQGCW9u9BvZumPGCSMZwuTOuGPlJ2dDwPk3+EmNmFztpUKWkbAtf3d1uZr/a2jA
         5fArcCDUm7+2NrCyKWpPGa/hvFqZMwux0Ku6sRnd+Z75j8hYQ7lROKqigengFRqb7ZlY
         mRms7b8eGOheU2HGMDkRDsHemDQixRbfBcfLhPk76GG6MJPrONZfG7c7LH9V8SQ/Ebli
         Y6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770754546; x=1771359346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h2plFct/EpqGzjEx7nOv5ScJhI5BtmBrKmQ1/sromkc=;
        b=B54PXoYvF0LXUrZmv+E/iGEC/0Ngop6eZTy0JO9GcD9bpX6auO1H2+LSYBLq6TgAuU
         m/KeJue6SF8kiyWB2EcBtK0vMaLopQXKcAEoYxo7buBxRWa0N6Fyg/q19YwG29VjctB7
         LlEHamg3UAFcXNXGPRwH4tOohsIQeP5SRzFPEtERQbmh6ZRvsagus4gapFUZaFWH+Tnv
         +rlCHCrOGSi78/cArpmaiuxcSoQyBYRrweK4NGYajb4ImA5R2FyzNStiMisOGa+4gVNb
         +F2lLvsu/DdwHxk6nVV8AMJX9atD49SkxyMm3Q6B0S3uaz2dClvS0XcmpS4uh4QGS83z
         f5uQ==
X-Forwarded-Encrypted: i=1; AJvYcCVPuTgHhnHGiIirmI663MWGlnoOv7GJYXGHOz5bC0UcvwLIl4an6pBt/ZoVTExk/m3fL4w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJYK32uu36FXhn5a3xc3lOILMW3Xc3N5v9gMDY5NuDW/fF/FeM
	S4lt68NVpsHX7ZvZfTrdOsR5vBde8oxhsQEQ1588vgZ9abpROt1vGM3AUPZ3EeVKq58=
X-Gm-Gg: AZuq6aKVCCurVDAO8v1RSWHBlzCTFBVy6E+Ghdye2FKGOrKCf+1kzbrpqXVJviH6sr8
	k0TxXM2sFemKC306UtaAosaKEAE95387/fDJ6VcLwaFvcK+7SdrAExkfI8WB0xaBmaGIty6Jj8G
	aRVPY/ZoTNi5McZJgacy/AAjnGmfFwpnVL8e6CBgCg+hRZ5itQK825KCBefOXANeJ6kE7y+41We
	XNzxVktDRgpd+/m9Auzj4TmJopyk3G/1nHmEsBtpmd2oypMegMdz8Q6vVpj+n6LicCDYXHbABvm
	IuiIuy53m1DsVNHTuSoYLqFxmCmCDuZT6stsMOQ6/33xAbmCnNzH5XkzsgE8saIMkqesv2tIZqn
	g3ogwiR8tq0nc2J8Krl3ljVSfAIOX2a/3eudzcZyvaBSiUqBp8YHvh+/aAAcJuJboWce9h4kqxI
	SNASUVF0/pHh+5d5HbKvyZ+3+dWx7AuFFzweKExztpuZAJ9V7I2R7FF83k/lpHKJaKTIm1N0G2N
	KsH
X-Received: by 2002:a17:902:db07:b0:2a5:8c1c:7451 with SMTP id d9443c01a7336-2a9519f5b02mr181073635ad.58.1770754546416;
        Tue, 10 Feb 2026 12:15:46 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab0b392cb5sm38523225ad.70.2026.02.10.12.15.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 12:15:46 -0800 (PST)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: anjo@rev.ng,
	Jim MacArthur <jim.macarthur@linaro.org>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	qemu-arm@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>
Subject: [PATCH v3 01/12] target/arm: extract helper-mve.h from helper.h
Date: Tue, 10 Feb 2026 12:15:29 -0800
Message-ID: <20260210201540.1405424-2-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
References: <20260210201540.1405424-1-pierrick.bouvier@linaro.org>
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
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70784-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:mid,linaro.org:dkim,linaro.org:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E25B011EF00
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
index 63735d97898..febb7f1532a 100644
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


