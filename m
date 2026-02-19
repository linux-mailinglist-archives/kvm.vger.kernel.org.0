Return-Path: <kvm+bounces-71315-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aP35NlOLlmm+hAIAu9opvQ
	(envelope-from <kvm+bounces-71315-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:27 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5806F15BEFD
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 334EE300B8DE
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 04:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB8E284662;
	Thu, 19 Feb 2026 04:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M8ngdKM1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7392428640F
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 04:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771473736; cv=none; b=BCUtMY1L8LUxKKXlpcdN4PCSS+zUINTJrfQrg0JxPH+0N6KHoulGw/3QT5UsswX//lSm73fe0WYgyx9a8szOU97TBlHgXmRTYqIzRgIXdF2CvlVOnFyFTWEQ4nav/V3YPkVV7lBYS+vGW5Ho6nRWqM7egUGMDHt7BZJ97mKvA58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771473736; c=relaxed/simple;
	bh=pnl/P8w5pEw7A/CmN9dmaLblHe/ecSGFStwTB2gtr3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYuDB41XP8ZCU2WB35NHaoXPVpC80zquHMay79rhM0QUs7ensNn5hzwnqINJb5xanqpkJQ2uK5j1YPtKl7BHrkchlT79NQxNB9HucT9/z7fgHvQ/z4zaNKskkHa8tp7M9DLC6fGJVyzkfi1ydTUCF+4dA5wEIA8fhwL/ch5Ihyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=M8ngdKM1; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a871c8b171so2660985ad.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 20:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771473735; x=1772078535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4N3HX+SvrJxNpLSjRFYSmasI3xjsp55w7IRFqv+Mp/s=;
        b=M8ngdKM1VevoSv8o60EGTap2yJnlRn52zoPULkiVb24S0D8oBgB9GFTyaY5Um3c4cI
         UMDuNuBNkVNpkaztJwoyLzZJ47ie79pwzXOQGsmkGLhz1Bd+vkAjtynDHDLPSxFMOXOz
         c+eRur9MoxQdgluRPmabVjtgf5kfFsIWCzXjygvvgzH7fyrDikoBOHyGMrM7LTbYBEV4
         LQw0HeaD8RQMjQ/mvaynU2Fthd4em8bzd9zSapEpjyquni+vlTidJi+kw12pWG5ejb3m
         zNmumIkWbi0jOFi59obRZHyTUukVpC9tc+RrpM/ZkmGWQ1H1x4NohG2fnvrh6B/VeAAp
         3daw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771473735; x=1772078535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4N3HX+SvrJxNpLSjRFYSmasI3xjsp55w7IRFqv+Mp/s=;
        b=V7+w+nLkh6t+SVQM1YZHnZeBPvHE4COo4psUr4Pc0xPj+wrkH0NwwFxVi2ShaQm9pG
         O3O+TA+fQVcq/iUnAM5gcce951u9OrASKiQhUwsiCBUz6OH3YSGDXoBFeOK17aKnuoLZ
         8kWoo0/GP8kNRo8zAhxWNjzofk1o4lPf0zHKmHJcpTIgvFPV9rdqdSYW35Ey29S3kmZU
         mgX7g9fK6tHAmHgZ1Zxt1TSfrOahaWW4/uzCm8fYOAyD7SpA7DD5JWIKxpCUmJsyycd5
         TYkhPAu9kG08F5ItSbythCy5CaCwikYJ6p5qVh3oUnTgBEH/mJR68JZ+pmBuIyyll/yc
         MuZw==
X-Forwarded-Encrypted: i=1; AJvYcCU0DJ9IJuTZ1yspiLRnr3KJvfPzMxmKuiyp3qf3LmPfGa6l5DWLTcYoDxScxeqXu2UjbTw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs2uJyxTz1QYj9+DJOZCziZ+Eg8n6KUKNr+itRknxXOuoM+oGs
	3qriy0iRHkhUcizYYR/4A89he4U7r5eBxXwTMzSJATupK9UTbEZp8LRq8qjUXVfbma8=
X-Gm-Gg: AZuq6aJHyUZq85Z0dZn42AO5FQbqmHZEHy+2o3n1EgQ+O9TFpIEC+yolM/Vq5Q/kOnl
	1dPWo1kN0lv6GQaiaIppOoOfak0RUowyRsdMe0G7Ne7s9B1219qb/Z/K7hGS9Ah50avyeyPdDXF
	NfFITzGRTzq/vyJoqoPvqpZIcy8J+6vI+YcZmO/C0yRDVTsztk3GfZgJd+UIDdLg/Nsl9KL5tTj
	YVm1DKCcgOvXEwE6IwoKya2+cLlDuVLDI3JrLucyEpgqyAdn09oPRZ6xYrHcEwSei+oF00lmUkE
	GMNIDbzT/5dsZvEK8fyGH5Nb6Pcj26LJ35fMIoatqGsVu7WwhcuvfefOzkFQB0XRnwNmLdLn9pu
	76TYbt61ORT4XxG7wNjoe9dzYNygQBIv0jtdDD6f4uokH1Xrqalip/JcNEIEDHvZ1s9oQXz5Y5n
	Cn8a7l+Wl6Cl7dACOqgRxFNTsy/YdZURvsYdxp4JGxCf23b+ReRJcsmRmpVI9aLF7PP/LOY9WEG
	uly
X-Received: by 2002:a17:902:f687:b0:2a7:3dbe:353d with SMTP id d9443c01a7336-2ad50fc5f93mr37643785ad.53.1771473734769;
        Wed, 18 Feb 2026 20:02:14 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73200asm147636225ad.36.2026.02.18.20.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:02:14 -0800 (PST)
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
Subject: [PATCH v4 06/14] target/arm: extract helper-sme.h from helper.h
Date: Wed, 18 Feb 2026 20:01:42 -0800
Message-ID: <20260219040150.2098396-7-pierrick.bouvier@linaro.org>
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
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71315-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 5806F15BEFD
X-Rspamd-Action: no action

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


