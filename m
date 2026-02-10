Return-Path: <kvm+bounces-70786-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4KGUNBCSi2kTWQAAu9opvQ
	(envelope-from <kvm+bounces-70786-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C7CC11EF0F
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 256F7305BD6B
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:15:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 931DF329E5A;
	Tue, 10 Feb 2026 20:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BbiC1gqh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB2B1330305
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770754549; cv=none; b=LUPz1PmiKC48xd2DmRHuw8wC469LgMqMvCyw6RMG3DZ9fGSU8AKeoMjMQMniRbkhnUDlYsDEJqr5y/M4Vy3PmG27YM8+Pk7dTiRuKSBhwYThZbx9L4zB+eXC0cd8BUOr77HyMyJX/96aN65ZgM6gZnag6LS98d3fV0bmJGTsmUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770754549; c=relaxed/simple;
	bh=KGm0VlJfdwaeZVRu514LxDN4Sflih0FfKoBOmU38bRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OEHLNffKTc6cAJYVqqnW0B+VlrCyb3Wv6iw6EH2qQ2msnfm6047HiF7LfkOFoCIWhF/Oc5x0PMQg2YtMe3dWDMWX2fzA97N7dGxxoMQwKOJC+dhamQW2BGeoj5zl1lacybVoQ0XyxEUKg1IC988oKxesR6XwYNGcoPcvmB+3pKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BbiC1gqh; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c6de0527ce1so690216a12.2
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 12:15:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770754548; x=1771359348; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H0/6jyx5lBSzvidGPzp44soUpJA5ox0vbl/G+VGissc=;
        b=BbiC1gqh5zRI6OFyWQi1pqql7eB8gu9vVqJPg/HQYQwqYHZd7OARTE60wmAtebbH59
         b07SHskM2bz4QbAPbhhNxHW8fFuxhcUUABRDBHoE/fMS16mB8iomlk7/rHQY1YsN0A/8
         WkP9z8Zg1bmXgDkdMnccgW6jVrpocT9yip8YyXuTx4EC20YfbA/8y0ltyrQPDRCrONkj
         I9roR4PLW6hH9FYu8OZKOOmSn85KbVUrSMqCPBGGId4oZQ+8WbWnmFNJ7pZfGOROL/xU
         jZ8YjnXT8IVBimT6Za2RP8ElDrivXYlt+JpRhX3Wh8Dp9xfjWOA9Iw/9ACOmSUxvBC+D
         InPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770754548; x=1771359348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H0/6jyx5lBSzvidGPzp44soUpJA5ox0vbl/G+VGissc=;
        b=aum3LhiPbJa9OlnO8mqgkqNLbMqjD5Aht8A2QLyHQ/Hx18e9Hcg+qAUSZXelAOZrPg
         5XFxoN5/XpYN8R8OE9zaZeRdT5RzhUaNor5vG5rGqF1aGxLntg5E9brzJrFiQua345gi
         UeBQnL4BbmUcjgrkJfwi2ccuSi2rmq9K7xo+rATMG86QJDwhTGxts7kKHMiATuUBrBKw
         /DQ4Y3ry5LcmooorajB2d/S8647FapkApHNEZq8Uo/qwlF46pw03qFPhAft5nK4JHuju
         Q2grvwUSM//wCSKZh4/SCbsHSOevyqTren6y5eIwoINsxm9uMFoVtP1uMLkjEayTPhlk
         I4qA==
X-Forwarded-Encrypted: i=1; AJvYcCUNLlcSAUkbCuQR7UntU2MKCYsP1AI/nh3mpCvofjM92UHzVx61IQ9hZbnoZ4n9Iy3cWEM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjZq5wWep5T5IEhVT+Il+rCiIXtt6AduYt5O29gbdqkC/XF973
	suye0ypRlIeAR0kGsKtD5Uqd1qXq19Lf4KiqF2k6YRz/YW5Oa+HD+PdblT+7P0lzIGM=
X-Gm-Gg: AZuq6aLwJSgG3k3O0fiLm+dm/4zrD2NihW83GJcLDg6mJmCG01Vt+2SXaL0CEcDWA0I
	iEZ9e6zMy+TnJ2t/sL5xlWlUlZnaZJ/C44aTWtfTew2HmbX7N4AP8uYZPs4tELSkme6HU25uIkD
	jdq90575EEs7qMqa0LXYU3UdYS5q8WHgz/4kUDDuerTrBQCOgH7na+W0yO3R3ar4cguZG+gux3q
	7vIid4in+nzhCOhXE2at7+EZ0VITJ4QQIxUSB15WsmK5EuGdiY+cZBXBLZB64SuEH8ftlL6ZshH
	0un6VUnxRkW9mRcT4ORO/PPr6Vw8q17K8JALQ047il0wi/M7uOYuoPfD5mCmj7osQY1aIYkd6KS
	QrrKGx3DaSxWvkE2Jvju8Mpx/n74vQL4Y7yUIVeoaUxvvwTiZrJkJdOyY2lNKZa9zX+bHRz+wfa
	ILIbLn9VRQRxyZb4gfbTmr+htGWtHUzgs3hdAMUfB/fi+s0YhEg7uPP5UXPmEWLKnpem+HWPOXG
	jwA
X-Received: by 2002:a17:902:da91:b0:2a0:c5a6:c8df with SMTP id d9443c01a7336-2a9516cd2fbmr174890375ad.21.1770754547963;
        Tue, 10 Feb 2026 12:15:47 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab0b392cb5sm38523225ad.70.2026.02.10.12.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 12:15:47 -0800 (PST)
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
Subject: [PATCH v3 03/12] target/arm: extract helper-sve.h from helper.h
Date: Tue, 10 Feb 2026 12:15:31 -0800
Message-ID: <20260210201540.1405424-4-pierrick.bouvier@linaro.org>
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
	TAGGED_FROM(0.00)[bounces-70786-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 8C7CC11EF0F
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


