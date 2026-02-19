Return-Path: <kvm+bounces-71314-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6DQkClSLlmm+hAIAu9opvQ
	(envelope-from <kvm+bounces-71314-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 85BFD15BEFE
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 224A2302EABF
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 04:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABBB4280CF6;
	Thu, 19 Feb 2026 04:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="d9OFBOmm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBCA2848BA
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 04:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771473735; cv=none; b=OmTGcXzlSCG/2SiLTzXt8tf1eBid0XKps8MG4SEZIS1LKjxs/H2KOMspOTMQYILxA4CcXFNGpZ1t/6eCEjnRXBwZXC68DTl/HzCQ9OXSVFS/8jTeXnSrzoZER0TMBWrtry4O9ri1W7VL2iZ/fvB3Xr/171N0zunpWCmS83MVJ+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771473735; c=relaxed/simple;
	bh=KGm0VlJfdwaeZVRu514LxDN4Sflih0FfKoBOmU38bRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HE61Di7WAq91FmLxde9LoZQozVhlzPW6vqfQpiAPwjon1246g/ZKr1zhAp9Viq2OUNVpnsXvJyBzpB8kX9hFsZ3vNSWIHgKgm7keuWiau0ijYhWlMleAyZwgGOrnWy7A0gydA+zVot5lQiizL3tlNhaRhzUNA9OrX3DAEjYCtJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=d9OFBOmm; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a962230847so3860235ad.3
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 20:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771473734; x=1772078534; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H0/6jyx5lBSzvidGPzp44soUpJA5ox0vbl/G+VGissc=;
        b=d9OFBOmmnbqkxPlhXD43vNXv+hS8GXn2SLIeL+hrdju68/zqRFWJOPpLAZuk6e6tN4
         0ApN+R1eFZYqjYYj5UHymblegsjrw4kIOqfxZBfuU+66ncy4mGqCQXyyjS/B4P3yB+pK
         1KITLZGX05wCsk/CetVAwWjHVrTfao6JsAoAyrrC8FiJv8WpWcVwIaNFVz2YFwXQuo8b
         A42FOVaR9hiklvOr9/LYXCHWi3FHigO/eZ3k+pk2c6OzJHMUO9znFjqxk77TWCBd/78t
         uJAdkq4pg+ARA76lvMFTxQyvUvr04gvrhKmpLN2iaDeLK4MFSFhs8f4TTca8A+PcPwB4
         7Qpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771473734; x=1772078534;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H0/6jyx5lBSzvidGPzp44soUpJA5ox0vbl/G+VGissc=;
        b=CwU5zmqZz+CDlDggBLyUPjjfRbzZRaxp3Y7Y3jjIqRZOlDIiRjMIsAXAkB5YTwOzeh
         BwMEUz/cdtfEuHX5D3YflXmoAzVTrvvDS/smb6qM3/LbEo3W66jqCi53FMnX+bkuCovJ
         kNTjwFiC0OcSSOkwxrj6fhOPMy7n3Z5dj35jyx+UkJQRUIzsuTlx6LTaRGzS227Iy72o
         SrRT9MxXWRLRRxIQ6fcuy/NsiULnU1v9BnoVkwjdTmAhCIZP4JXKYYs8UjW3cGMrkdkl
         U3wYyCLMvTvT7s5Cy5h5njqbrBIyfIjZLXj2ripuIeMeCQa6zme48EAqwBPjIv2HgOgQ
         fYDw==
X-Forwarded-Encrypted: i=1; AJvYcCWgldNRH37Un4ZrhyEMhvnrVlWyJlgjP/NhyFN1PXB0n1tKBjY9OC81qZrGiOuwnvnJPDY=@vger.kernel.org
X-Gm-Message-State: AOJu0YypXqf3aI3I+Z32vlJjUzUBSqwTBVeTWfoibj6ryIbEgkwN4DvC
	M837EnzVlxbwv1Z7+feplrzORuRKG7FYkN7EI22gRijz6iWgKJd48y6tsUiKpPte18I=
X-Gm-Gg: AZuq6aL7ifHycSqsV2fZAyGzl8qZeAz83QelXc26fIRa8oo/J24MHFPPI2O2ne2V4HI
	BsGLZ/8qGs7sxgjvhdecJo/vGZgFssns65rvadNvRQ29Dcz5/Qc4K1kvTlF4dMr2KDsPdit6oUS
	6VlfDpAxwWCcmdV9eDQn4bBZS3q4cagR/Yl+w5RStI408l9SsCrT3LBL4G1Rz3+sEHsdDTPVO3Q
	4efXSgJzdxuNU/Bk2ecS0LH3k7tvgpUz6B+uTlb3yqc+VOLsZDyNKr09UHIK8Vyb6FH0UwItd2C
	StDDe4DVxPOMi/zjplZOobcXpfTfsvUhQj1xldT/QC8i+OXt4VgEVjf7NJr7DwN+iZ/hchQ0SJD
	AJtPdCaKQOF1goyTjUZ2hPEd5OK8IMZEwdId2fnTD5YO8Ex0plDm6mr0krVVwMpU79XxDXWzdVy
	KfDYNK8CAmY91QscdYia1yilDqsHYsW1wLmgqCOlatHo47qyi81eiVPgaCp4IbDAXjhZ2sHkiIJ
	msq
X-Received: by 2002:a17:902:d48c:b0:2aa:e6c8:2c73 with SMTP id d9443c01a7336-2ad50f33f69mr42566625ad.37.1771473733869;
        Wed, 18 Feb 2026 20:02:13 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73200asm147636225ad.36.2026.02.18.20.02.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:02:13 -0800 (PST)
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
Subject: [PATCH v4 05/14] target/arm: extract helper-sve.h from helper.h
Date: Wed, 18 Feb 2026 20:01:41 -0800
Message-ID: <20260219040150.2098396-6-pierrick.bouvier@linaro.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71314-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 85BFD15BEFE
X-Rspamd-Action: no action

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/helper-sve.h                            | 14 ++++++++++++++
 target/arm/helper.h                                |  1 -
 target/arm/tcg/{helper-sve.h => helper-sve-defs.h} |  0
 target/arm/tcg/gengvec64.c                         |  3 ++-
 target/arm/tcg/sve_helper.c                        |  3 +++
 target/arm/tcg/translate-a64.c                     |  1 +
 target/arm/tcg/translate-sme.c                     |  2 ++
 target/arm/tcg/translate-sve.c                     |  2 ++
 target/arm/tcg/vec_helper.c                        |  1 +
 9 files changed, 25 insertions(+), 2 deletions(-)
 create mode 100644 target/arm/helper-sve.h
 rename target/arm/tcg/{helper-sve.h => helper-sve-defs.h} (100%)

diff --git a/target/arm/helper-sve.h b/target/arm/helper-sve.h
new file mode 100644
index 00000000000..ae4f46c70a0
--- /dev/null
+++ b/target/arm/helper-sve.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+
+#ifndef HELPER_SVE_H
+#define HELPER_SVE_H
+
+#include "exec/helper-proto-common.h"
+#include "exec/helper-gen-common.h"
+
+#define HELPER_H "tcg/helper-sve-defs.h"
+#include "exec/helper-proto.h.inc"
+#include "exec/helper-gen.h.inc"
+#undef HELPER_H
+
+#endif /* HELPER_SVE_H */
diff --git a/target/arm/helper.h b/target/arm/helper.h
index 79f8de1e169..2f724643d39 100644
--- a/target/arm/helper.h
+++ b/target/arm/helper.h
@@ -3,6 +3,5 @@
 #include "tcg/helper.h"
 
 #ifdef TARGET_AARCH64
-#include "tcg/helper-sve.h"
 #include "tcg/helper-sme.h"
 #endif
diff --git a/target/arm/tcg/helper-sve.h b/target/arm/tcg/helper-sve-defs.h
similarity index 100%
rename from target/arm/tcg/helper-sve.h
rename to target/arm/tcg/helper-sve-defs.h
diff --git a/target/arm/tcg/gengvec64.c b/target/arm/tcg/gengvec64.c
index c425d2b1490..c7bdd1ea82f 100644
--- a/target/arm/tcg/gengvec64.c
+++ b/target/arm/tcg/gengvec64.c
@@ -18,10 +18,11 @@
  */
 
 #include "qemu/osdep.h"
+#include "cpu.h"
+#include "helper-sve.h"
 #include "translate.h"
 #include "translate-a64.h"
 
-
 static void gen_rax1_i64(TCGv_i64 d, TCGv_i64 n, TCGv_i64 m)
 {
     tcg_gen_rotli_i64(d, m, 1);
diff --git a/target/arm/tcg/sve_helper.c b/target/arm/tcg/sve_helper.c
index 0600eea47c7..16e528e41a6 100644
--- a/target/arm/tcg/sve_helper.c
+++ b/target/arm/tcg/sve_helper.c
@@ -25,6 +25,7 @@
 #include "exec/target_page.h"
 #include "exec/tlb-flags.h"
 #include "helper-a64.h"
+#include "helper-sve.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "fpu/softfloat.h"
 #include "tcg/tcg.h"
@@ -38,6 +39,8 @@
 #include "user/page-protection.h"
 #endif
 
+#define HELPER_H "tcg/helper-sve-defs.h"
+#include "exec/helper-info.c.inc"
 
 /* Return a value for NZCV as per the ARM PredTest pseudofunction.
  *
diff --git a/target/arm/tcg/translate-a64.c b/target/arm/tcg/translate-a64.c
index 1a54337b6a8..31fb2ea9cc3 100644
--- a/target/arm/tcg/translate-a64.c
+++ b/target/arm/tcg/translate-a64.c
@@ -19,6 +19,7 @@
 #include "qemu/osdep.h"
 #include "exec/target_page.h"
 #include "helper-a64.h"
+#include "helper-sve.h"
 #include "translate.h"
 #include "translate-a64.h"
 #include "qemu/log.h"
diff --git a/target/arm/tcg/translate-sme.c b/target/arm/tcg/translate-sme.c
index 091c56da4f4..463ece97ab8 100644
--- a/target/arm/tcg/translate-sme.c
+++ b/target/arm/tcg/translate-sme.c
@@ -18,6 +18,8 @@
  */
 
 #include "qemu/osdep.h"
+#include "cpu.h"
+#include "helper-sve.h"
 #include "translate.h"
 #include "translate-a64.h"
 
diff --git a/target/arm/tcg/translate-sve.c b/target/arm/tcg/translate-sve.c
index 64adb5c1ce3..c68a44aff8c 100644
--- a/target/arm/tcg/translate-sve.c
+++ b/target/arm/tcg/translate-sve.c
@@ -18,6 +18,8 @@
  */
 
 #include "qemu/osdep.h"
+#include "cpu.h"
+#include "helper-sve.h"
 #include "translate.h"
 #include "translate-a64.h"
 #include "fpu/softfloat.h"
diff --git a/target/arm/tcg/vec_helper.c b/target/arm/tcg/vec_helper.c
index 7451a283efa..bc64c8ff374 100644
--- a/target/arm/tcg/vec_helper.c
+++ b/target/arm/tcg/vec_helper.c
@@ -21,6 +21,7 @@
 #include "cpu.h"
 #include "exec/helper-proto.h"
 #include "helper-a64.h"
+#include "helper-sve.h"
 #include "tcg/tcg-gvec-desc.h"
 #include "fpu/softfloat.h"
 #include "qemu/int128.h"
-- 
2.47.3


