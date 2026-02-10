Return-Path: <kvm+bounces-70787-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id INGBFBiSi2kTWQAAu9opvQ
	(envelope-from <kvm+bounces-70787-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id CB22411EF1E
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 21:16:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 01845305F324
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 20:16:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A767335081;
	Tue, 10 Feb 2026 20:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qs6efzjV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76F6332EA0
	for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 20:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770754550; cv=none; b=kZEdPgS+FKLEoyhhQquzXgnkGbIaXoLBi4yHoE4YUnkU497bXF6jfz1E5GmHxy3izSzpKuJKxxoMYq/tAh/UMv7Q3WqqfkdCUzyGhLIyQLbYMuhri9HxtmzGJdgnGBQ1oVJ7IzfPy7ARg+rqIeCy8LcZBnUEsb+cguIDHszJnn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770754550; c=relaxed/simple;
	bh=pnl/P8w5pEw7A/CmN9dmaLblHe/ecSGFStwTB2gtr3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fC/sZa1V8X0a18I6YB80bSR/pXZbqwFg3XISOKq1kwou0jBsOnsx6RW82aljv0am5Vv/aTPUOknz0oPfUowOxKE5nOJqrW4osVi1I8aKc/INGD42NMdu4oWy9amsS8xjUKpn1l2jtUVXUs/LPU687JUm3dyGAexJ/g0pv53tGiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qs6efzjV; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c6541e35fc0so665954a12.3
        for <kvm@vger.kernel.org>; Tue, 10 Feb 2026 12:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770754549; x=1771359349; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4N3HX+SvrJxNpLSjRFYSmasI3xjsp55w7IRFqv+Mp/s=;
        b=qs6efzjVhhe1UfnqJDTVrOm/U/+3Yjor7hM/VWb/FP1rEpl2E3RahsAAFPiVk7Piqe
         ZAnCHVGyl3bHFjZeLqtZcEsasnOXV3KgdhOiJJMXyg142ry5aHuxa1j6XZ7jQJ4NVrp5
         U0JZ/enA9qG657YD7CbL/62frE91lB40CK/ySlQLwijEU54tXnCJQrxfeUPeOVuY91/i
         J+me9+GYwpGwYMEn2bqZbm31UPh5moEBzpQLI09q3sBvgjXlv3bBJLKqcwOA7TIuTWbI
         nESrZiG3FAHNOIrKiWdSNUac6Wq8btuke8o3/p9V/7Eo8qGVPhgB3cHzZBRV52wtb4Vm
         JRHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770754549; x=1771359349;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4N3HX+SvrJxNpLSjRFYSmasI3xjsp55w7IRFqv+Mp/s=;
        b=lJH2zz8mDPozyR0oR+VUHtQ1coByxPNIuNuWF5bgK6YLPwzZt3fy2y67LRoQhpJ2sQ
         XceHD1UClL1KE6ln9dHQgHiDby6M66q/onMXHRFumo330BL1ZgsldlI1qjsufOx/O+Hh
         qO6ZoG+I9CNahcrSYUNr/jcPFhJuEPMacBU+YY4DNLWQTbGt3A29cyT+wlTravUaUC6x
         clRpWGut7zFeYxQcxOIL1NCOvznMUTJloC/aTw6hrWXHtUNUYxiiitGoCLtis+Oc605M
         P1a7oZkdQd3B6Cm//OiQPUfa0ODXniE1KqSuC95C+FZL7IojSKPjLIazrB1GD9KT72ym
         NsaQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhx8tkd1PjrNCZElzbiE1hXY5ySv6TgKzbEdVFpHzHc1D/T1yOqBb3UmP8uVAR0MjF2WM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9NtzT8MVlwVJppi4WLls3iNjm/vvv1eJLdNUobKm1efxwbs9s
	ktWwWGGFwcbH1hrX8cgBb8752NfXz0bj5IsHOJ3nCogpMwN536A+Al5ybMfEs6tnWiE=
X-Gm-Gg: AZuq6aLap8/m9gkj8AJFipREewrkmcGDuTvTPkguRUISNoXXWCKyHqUsHxIDPpVAVO2
	Oy1ns2LACdA9yjZwJlhx6ZUQzWkl1hYpEVJD/sB7oCvjA/d4qP9u6rIw7u5ubN0CTiya4a9Neqh
	bGbMsgOScRx5lF7P+xNUKZ9LthDxn8VazK15SkC896+ptyHWFzaxKxHbkxm0ofyvZSAmevpJdkt
	HSd85WbLeKr84fsjBag9azNhn0WBE+gak9KsfV0ZtjF9OuJj1tn3dnOAOqD7RKtadPlBRAnuIec
	RfG4I/gWRz9p0ZVKFm7lFFm4XaEN0QgIJLVADRClBF2MAAGsasUMgc+kmhKi1jtfRUkTIGNj9Bi
	tcCuLFdqgESEPQ23PgfvKl9iuCrCetVghacN83EAAWFmB07sh7Z9L4w7zypHVaQ4XGRieJp1GES
	uV7KMbSiU5Y/R8ZmFLpkiqHRDI0zJANnMo56Z6KpsptB5cbgZsQwm5pO+FLTekrizWcrYfcyKIR
	pZL
X-Received: by 2002:a17:902:e951:b0:2a9:62ce:1c0f with SMTP id d9443c01a7336-2a962ce20aemr124796015ad.55.1770754548813;
        Tue, 10 Feb 2026 12:15:48 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ab0b392cb5sm38523225ad.70.2026.02.10.12.15.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 12:15:48 -0800 (PST)
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
Subject: [PATCH v3 04/12] target/arm: extract helper-sme.h from helper.h
Date: Tue, 10 Feb 2026 12:15:32 -0800
Message-ID: <20260210201540.1405424-5-pierrick.bouvier@linaro.org>
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
	TAGGED_FROM(0.00)[bounces-70787-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: CB22411EF1E
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


