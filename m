Return-Path: <kvm+bounces-70414-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cNL6IbRthWnqBQQAu9opvQ
	(envelope-from <kvm+bounces-70414-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:27:32 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 10BE1FA0D5
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:27:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8148F30420B1
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 04:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22620346765;
	Fri,  6 Feb 2026 04:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bpKIX6tL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C323451BA
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 04:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770351725; cv=none; b=i0LYV4vRSJOVZwuDPm0YIos+WhT8Z5b+sYmH4vzW+UGPBzOv2a8XJrQjU98Y6LyjNQpvuGwfhzBqEwxDtjzHZIx7P4UnhM2MhGFBjvoXxq/jAq5lNSfE7SynFdSsgPUPKn3R9M483sHkHKuhAYA7r+ugPjzRIXATyyMcsj/mtAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770351725; c=relaxed/simple;
	bh=QKSIBqkCGdy3J9ll5fTneHV92ZixMqOTyuRe4rTDKsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BHUbkZo4ZSWyJZIkz4DDxGBjLYWwnRYmhA5MvrZSri8/tKe3BJwcf0FnwrLmBsR3rwcojbNv4AqKngJKwpMlgdPjBnGGbnOM8y6mrXWAziVPeXyXX7irrsIPH52xX6RJ+raODMszcs5gVR0+eH7gNbHnkIWelZ8bhTLmzwrTbEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bpKIX6tL; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-8230f8f27cfso779445b3a.0
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 20:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770351724; x=1770956524; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NNi8czf1/CFVr3JdN24WUseqYsA6Bdj1+/T6IG97cXc=;
        b=bpKIX6tLnm09o7EiQ+1YYLG03dTE4lFbZLk3q4V2ErSSa4daJmY2+QOdZBOxWNBR7z
         BNr2fv5i4GODdqg43JM7gonxNVuzI5Sfga9QKoT1JNMgilvDacCSYdjSTXlrevBX/5uI
         xTfJSSppUjy4qHUr38BIW+YK1Q9X0sq4dSBsCUys/yU28hDWX7aPYh9I72wSg5Wzcui3
         UqZH581yB7wxsOxD9A6Kwwcfo6GpLKEN3F8h8PwZ4ZAJxSFrQO0dUoWSM3v07QYANYBd
         LpHUkeRyT7H/XeEokyowFRyl8iNdsFBAXqXos4dvU4mvqv8YLZsxRFnFaRGdTp8CHWks
         SDuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770351724; x=1770956524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NNi8czf1/CFVr3JdN24WUseqYsA6Bdj1+/T6IG97cXc=;
        b=BvB9YdmR1VBcOwMKWFVvJgPJ4bcsL0TzOzSBQlmWlAtsRKxBlQAncEE2fzUNPqlH8y
         bl0YeQmn3W1dw93Tklho8FCVGjSn+vMWgdjBRavfp7oMXYA8hI+Y3jisI3GoUAQGEoOl
         MK3obiAhd9dzo2qmaalfefvOOUpwAva8m9WT5BTiG7C8uwxVvt/EYwTjRoglxP92QitV
         kSS7ONRy1crdwIhNpLAK3e8JAv92Hgxemg9ydlMCPggnkPXK1aZlvLGg7RE5Gvbss20Y
         lgf9tKPDWGZc2sSqXDoRFsTAf9iSgDlwVlJ0zZn24tSujwpXY9gwAxl4DTm5KHpyqO/A
         4OBA==
X-Forwarded-Encrypted: i=1; AJvYcCUCW+l9rNK0R/jANjE9WMu3a/MmeeNOOtHziSrGFCfRDTh/6QweVa8a8q9gmoVxL6ZjgfQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywitm2xhgLC+4/i8f+MojwRWHtOKbLr1umlunnbi1sSX8KDVmpF
	T3KtOhVdLbf3WjrWEBkSEGXEwHM5g6pmobTUDDLZqQiQRu1yVs+WmSWwaeB6keqIlro=
X-Gm-Gg: AZuq6aLzzxNfvq6jasoksiGGjqdGpKpqsrG5pGPjXqmUqhUeez7DQWPpp4QDqUiFsiU
	ouiWpd/2swF/TD216iAb83YFAlP49cAb8mbGsommpOEu5sG7aCkaCoYMnRVkKG/r2+Y4NfYa8n4
	lRllBjqtBJGgJcJgkz/FyIL1yn789i7IDTkhM160d1GPLH9VVj8qB2aO4yS/iO3iZSiNljUP72e
	OfnixrFe5DVbUYtVuR4aEHHZ2hoMU2PjfXUX+RFtuseWCJ/SsZpeqhGNkwdTxspWUjuRUrG4oBM
	kPTYJki4fuYGG8hEVDr2PZXlMotU02uoEaYBo3Nn10GViEAb7/FVpBkkPfYUDGZOXqMkpvhf1hc
	cvG6b/Rn7he+Lh4rzURfslk37cQBhlOeqe5MJMzUISMQuTrathIdP2QQPpy2c3Iv02Ou+rOVkIP
	Jhu4RtDs5p/6nYIIiBhjp9M5PeVkPWBtMxjpdLRrJWDs30H8KnQHlP2MqYEqxIlRNocGpO0OYS+
	sQ=
X-Received: by 2002:a05:6a00:1790:b0:81f:49cc:ea11 with SMTP id d2e1a72fcca58-824417b8d66mr1225060b3a.65.1770351724414;
        Thu, 05 Feb 2026 20:22:04 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244168fdf5sm926914b3a.17.2026.02.05.20.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 20:22:04 -0800 (PST)
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
Subject: [PATCH v2 05/12] target/arm: extract helper-sme.h from helper.h
Date: Thu,  5 Feb 2026 20:21:43 -0800
Message-ID: <20260206042150.912578-6-pierrick.bouvier@linaro.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70414-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linaro.org:email,linaro.org:dkim,linaro.org:mid]
X-Rspamd-Queue-Id: 10BE1FA0D5
X-Rspamd-Action: no action

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper-sme.h                            | 14 ++++++++++++++
 target/arm/helper.h                                |  4 ----
 target/arm/tcg/{helper-sme.h => helper-sme-defs.h} |  0
 target/arm/tcg/sme_helper.c                        |  3 +++
 target/arm/tcg/translate-a64.c                     |  1 +
 target/arm/tcg/translate-sme.c                     |  1 +
 target/arm/tcg/translate-sve.c                     |  1 +
 target/arm/tcg/vec_helper.c                        |  1 +
 8 files changed, 21 insertions(+), 4 deletions(-)
 create mode 100644 target/arm/helper-sme.h
 rename target/arm/tcg/{helper-sme.h => helper-sme-defs.h} (100%)

diff --git a/target/arm/helper-sme.h b/target/arm/helper-sme.h
new file mode 100644
index 00000000000..27c85fdeef1
--- /dev/null
+++ b/target/arm/helper-sme.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef HELPER_SME_H
+#define HELPER_SME_H
+
+#include "exec/helper-proto-common.h"
+#include "exec/helper-gen-common.h"
+
+#define HELPER_H "tcg/helper-sme-defs.h"
+#include "exec/helper-proto.h.inc"
+#include "exec/helper-gen.h.inc"
+#undef HELPER_H
+
+#endif /* HELPER_SME_H */
diff --git a/target/arm/helper.h b/target/arm/helper.h
index 2f724643d39..b1e83196b3b 100644
--- a/target/arm/helper.h
+++ b/target/arm/helper.h
@@ -1,7 +1,3 @@
 /* SPDX-License-Identifier: GPL-2.0-or-later */
 
 #include "tcg/helper.h"
-
-#ifdef TARGET_AARCH64
-#include "tcg/helper-sme.h"
-#endif
diff --git a/target/arm/tcg/helper-sme.h b/target/arm/tcg/helper-sme-defs.h
similarity index 100%
rename from target/arm/tcg/helper-sme.h
rename to target/arm/tcg/helper-sme-defs.h
diff --git a/target/arm/tcg/sme_helper.c b/target/arm/tcg/sme_helper.c
index 075360d8b8a..7729732369f 100644
--- a/target/arm/tcg/sme_helper.c
+++ b/target/arm/tcg/sme_helper.c
@@ -22,6 +22,7 @@
 #include "internals.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "exec/helper-proto.h"
+#include "helper-sme.h"
 #include "accel/tcg/cpu-ldst.h"
 #include "accel/tcg/helper-retaddr.h"
 #include "qemu/int128.h"
@@ -29,6 +30,8 @@
 #include "vec_internal.h"
 #include "sve_ldst_internal.h"
 
+#define HELPER_H "tcg/helper-sme-defs.h"
+#include "exec/helper-info.c.inc"
 
 static bool vectors_overlap(ARMVectorReg *x, unsigned nx,
                             ARMVectorReg *y, unsigned ny)
diff --git a/target/arm/tcg/translate-a64.c b/target/arm/tcg/translate-a64.c
index 31fb2ea9cc3..5d261a5e32b 100644
--- a/target/arm/tcg/translate-a64.c
+++ b/target/arm/tcg/translate-a64.c
@@ -19,6 +19,7 @@
 #include "qemu/osdep.h"
 #include "exec/target_page.h"
 #include "helper-a64.h"
+#include "helper-sme.h"
 #include "helper-sve.h"
 #include "translate.h"
 #include "translate-a64.h"
diff --git a/target/arm/tcg/translate-sme.c b/target/arm/tcg/translate-sme.c
index 463ece97ab8..7d25ac5a51f 100644
--- a/target/arm/tcg/translate-sme.c
+++ b/target/arm/tcg/translate-sme.c
@@ -19,6 +19,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
+#include "helper-sme.h"
 #include "helper-sve.h"
 #include "translate.h"
 #include "translate-a64.h"
diff --git a/target/arm/tcg/translate-sve.c b/target/arm/tcg/translate-sve.c
index c68a44aff8c..db25636fa3b 100644
--- a/target/arm/tcg/translate-sve.c
+++ b/target/arm/tcg/translate-sve.c
@@ -19,6 +19,7 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
+#include "helper-sme.h"
 #include "helper-sve.h"
 #include "translate.h"
 #include "translate-a64.h"
diff --git a/target/arm/tcg/vec_helper.c b/target/arm/tcg/vec_helper.c
index bc64c8ff374..a070ac90579 100644
--- a/target/arm/tcg/vec_helper.c
+++ b/target/arm/tcg/vec_helper.c
@@ -21,6 +21,7 @@
 #include "cpu.h"
 #include "exec/helper-proto.h"
 #include "helper-a64.h"
+#include "helper-sme.h"
 #include "helper-sve.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "fpu/softfloat.h"
-- 
2.47.3


