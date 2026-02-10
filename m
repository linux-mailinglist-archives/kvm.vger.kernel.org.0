Return-Path: <kvm+bounces-70785-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cBoNHQqSi2n/WAAAu9opvQ
	(envelope-from <kvm+bounces-70785-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id C5C4011EF08
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 02F8230576AC
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F099D33342E;
	Tue, 10 Feb 2026 20:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YKWpNIyF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E69329E5A
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770754549; cv=none; b=EVVv76KRfbof70yRhJXnTTStFj/uziCToYhgTK9LjZUa/Llqktq7cRuiVNmyuyq1yqtx3HrE4zvqx3XVOWow4t5lreGat/+dOqHhccJZHsFM/wCFsHWV9q+dKbzeKokyopB6vtBUKK2Vw02jauBYnosf81ZpawNFfy6fMDmwz4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770754549; c=relaxed/simple;
	bh=XEl6n04O+T1nmeMd9qHeIWpLP10lVhNztNOqxE4iLTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e6OgpqShxNeX2B28TzN1IC1luX0m0HSFH42VZ/kGms6uLwDcLCIth8DAB+Uyzb+prxL2FXTlELY8DU6EcGoPm0dVh+aEO61JkmSKfx9nBQuLPYvWuitSJ+MJBlPtK4rLplNd2U0r38KWWYLjqkXm1GogYHXWdDWOiHiqpWb5V9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YKWpNIyF; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-8230c33f477so2807721b3a.2
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 12:15:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770754547; x=1771359347; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UdK2rOS2bitRzrDxI30pyU/TEy+Znetuyj+EjMa6JSY=;
        b=YKWpNIyFkneXGfziokLeze8Y9DKZ2tzG723EUkcHrBwZ5bzkEtyVq9IMlixnPLfrMA
         aUobV2nD7h9URyhghFmHwO8v/E6HvXvF7hHum/EFZXhR/TgWInSjaE3itraRGD0exMwN
         ATLNbv4mU1MIv+NCWrXabL/5Htpnrq5so6ScDwJfgX7XHYv5K5/6cdNoLEIan/6SxN++
         cmxkGxhEikmHztgzSm76sVqN5E4qEBHp3mwxwVjlrlcHK3oaDix62aVb1nDrR2IOynd5
         l66kwhK0+YUzkE6wxUBbvEIwt2KL0XfEAqMBMxagW/EVyzc2v/UmSUwlPS6bC6rb+YkS
         TSAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770754547; x=1771359347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UdK2rOS2bitRzrDxI30pyU/TEy+Znetuyj+EjMa6JSY=;
        b=iaWKky8A70lJQXuhi3RtU7ACVik9DKnst+UWf0dJ9RMlj4Ao4plOQy1Zu1qVRoU0OW
         2evZuQizZQxQJDBJTYB9EpRCEaJCtio1toDfMt/iA+34LGUS58bRM6LK+Ci2RZ5/uXco
         SFL77EZHSdOJu1VQ9f6nSRCWU5tWtLn6lKHxxsLGmD0s55LICVeRCRVrkFWUd/9+Dws6
         Riq/7y3Ql/8C2eE2jKHtRhbM/Ubph9NPKBQ7HZbDtShx2+kzrdD8CWPog+It021Ww7w8
         rSJTK8yomeajN+hBcWcgL/DsMrShNCzPKiE0ztlNX+8tepPyrren/L+44Dvm2sEWzTf+
         I/CA==
X-Forwarded-Encrypted: i=1; AJvYcCVIp6oq9F3QauymaYTYG2DkiGj+TIjaQnYH2ea47VYVvswCGXrNvCicjDss4EKlLgG4IEQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxHgXcQZOyL1VW6DSXrFAJ/N5DDlut3bzINweyIzCMduKT/6TPJ
	wO0FMg7O81iJJ1oAiWqguXo9H8BCRgryy6ToU+uQ1UosAYTxEi6aOi4+L7mB1o4za3w=
X-Gm-Gg: AZuq6aIMc0cv1ZY2wKPBXgNk329CiCM/NXEPSWRFYnAF9n15zCZhz6s1scEdGeVxPB9
	Af+YiooJGElHl+80dNT2vNx0TM7W73OwGtYFKPWUVb5q6lGP86HujJr13yKpfjsNh/PwymlZf8Y
	J2gjeje/FQ4UuT85HaRDhXeLWfFMePjIyfORqLi36MQRKmbhpdDw7S/YLYkkx9bDMwVp0/7JPRK
	sUt0UAV6KgKJCQUaa5S4mpeMeQWOYg2FNyEbfIHStKkGbxrutSp90olZ4vwAclQNJCOr5c7bxRh
	intYRYPvTYgT72h7/9E86AbW/AqCPraCOUrnnBm/nKekus/4UI1tpPBrG4kX3lOjVFj9Pr10kRZ
	bEPpDOPDCq8PEYhFMK6RdIzguMvFE4fWSHY1YDhk7krpEd+rHz7FzH7/67uQF1Bu+eb3KltrzDs
	Qq6sm9I+YhCtsPypzuopV2j2oW3XqEZGL/vHno4X0hs3JGHSN/uglhwkcfu3QbBgwM73ke2tfRl
	+TH
X-Received: by 2002:a17:902:ef0c:b0:2aa:dc84:251f with SMTP id d9443c01a7336-2aadc8429c0mr88006075ad.2.1770754547155;
        Tue, 10 Feb 2026 12:15:47 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab0b392cb5sm38523225ad.70.2026.02.10.12.15.46
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
Subject: [PATCH v3 02/12] target/arm: extract helper-a64.h from helper.h
Date: Tue, 10 Feb 2026 12:15:30 -0800
Message-ID: <20260210201540.1405424-3-pierrick.bouvier@linaro.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70785-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:mid,linaro.org:dkim,linaro.org:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C5C4011EF08
X-Rspamd-Action: no action

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


