Return-Path: <kvm+bounces-71313-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cPygGlCLlmm+hAIAu9opvQ
	(envelope-from <kvm+bounces-71313-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:24 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 834EA15BEF5
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 48F6D3009F11
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 04:02:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFF5A27B4E1;
	Thu, 19 Feb 2026 04:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eOcgX6b/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C060B280A5A
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 04:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771473735; cv=none; b=NcfoN5nebLd4eFd7LZt49VRn8AEE8LcGmp2jABkXAjlkqGfyeFFejf5Ij9zyd5b6RaUhGMHPuiwqIOKgN778SLGKGOwmPGqJu4f/neeeV6psCe3iV8KmMifOAo8KH5YVM8ryJA9c7ad2lkLss0ZU0UC4P+NJ+ciJGHr96eWW4u4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771473735; c=relaxed/simple;
	bh=XEl6n04O+T1nmeMd9qHeIWpLP10lVhNztNOqxE4iLTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWVKLeWKZqkOgQcflP+jaQhFvSmek+oZd3kZZ9LMV5y1Uq3VFMnMseaaiKY6wU4NHNeKbO1l04qzZjiRXDpqSFebzYjVJtSVXsYKeU4S1MPuvA82m1tL32C/Etn4upQBet5+sWny3KkBTUMIjjtlpCHj21tEmLPXX1CTXvdMJjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eOcgX6b/; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a9296b3926so3220555ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 20:02:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771473733; x=1772078533; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UdK2rOS2bitRzrDxI30pyU/TEy+Znetuyj+EjMa6JSY=;
        b=eOcgX6b/yCJEz35C6VAHuhlOKkvMcdTdDtECjO0CkDobFk8f3KsNVFf+HYpzwC6TBZ
         2BGIvDxBwBYvoG1WzX3ljTU9Kyt6LgcafDqETRz6SVXb/qoOdnncyLh1sk9V1SmTGQon
         8aXwPAhZ2rvTG6OWJYQXDTKQUW5Pv+rQ6uLzphYPOexKdOlI7HU6YQ3MrhFX6gD2sfiL
         4K35LJJCsC4Y6HrTYg4lH0LOOiB8JOJqF66HEEIie2oYrLjxEFQi4HENqnNjI0XMy/bR
         ND05JppV6W2AItqCLE9caw1CJEetiIatPiP3KsYQNJS0Xxir2vlpOW1bXU8mB8+iBVkt
         V/ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771473733; x=1772078533;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UdK2rOS2bitRzrDxI30pyU/TEy+Znetuyj+EjMa6JSY=;
        b=iIIPJJmO+XUtkX2Du0G8H77QNzYAp6C0dYIf6iJLmslSwx+KcTWoF8gMtLdKgf6Isu
         wavhXe+CnnAU8AdAgf415LTcpyBPbTKG17PPb7ideJtQWhrJ/CF/kr+8o3p/rxmNCmP3
         XegXrA1F/kRhw2m/eWDwOIwjiIZc2MFQ/IN9RsCSSpayNuAnpU4rznanUQWWMQDIL4QR
         DXJNbRs3mDFw2Om7rdoqp+q/e2QvbXQCkAdK1TIO5n8FfcLRRRR2yaFjLPvQgJRbfOhN
         IRYo0R1IMAwJ/pUgJV1E4ts7axaRf3c584NA6Ta8G15fBTaSOMiwvCRZ6gwTD0sCxiQ1
         gwyw==
X-Forwarded-Encrypted: i=1; AJvYcCVo3B8bFQuEevSTechN5Am71NuIt6sqHG7yDOXn5HnMuZfH7WYsXBzAfu65Q2hfwKcE/1U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7XO8R/KaviGawsXR4vqns31yHrcSXRL2vOoD4bNVEQ2gm7FjY
	7YaXy0JmsXSX/fmzrGkfrxDiTfhzU1h/TJvs5LMjkbAEmfm8AgiM0WaQjiuBfvJAxKA=
X-Gm-Gg: AZuq6aIbgWcHUgxZXf5HrYaJKIUl6knW8JvqOKRTlFxIMJwB99yiQwQZXmXdi4G8l1A
	QeVgStEomJ6VIzJ1P0YcCdVgFriL915NUAAZkOL6x7CNhs6OnAleYluYqn4vYzwVppTd9MSla0K
	CQgH61D24W8HQHRyd0fTG2Zuk9n2DTpPNGrPiOnh54ziXPJLb5XjetqSc43C/pIk9L95G9/bWrG
	9MgJgKJrlFBYlLzJGoiWUpUsvq+qcfXLPJPo2j236AEyOd1Q52YnRA5JmN+vI7PhbcqSyCzICJr
	BiCtM4yF3HezmOq5ebd0PBKPgcJlfuOAJK2PCMNws3ZPijJCG5ROUjT7qqyWrMq2EW8yvX2oQrt
	6/0/KB4cP3Q8LTBn2j3JeeImKTPzSZAUrW08GEmqtIocLxZfhe5t69Fpd/8Flyz3mPR1lnX0EeF
	zqbtpb8yJopFolZ2RX83iglGbt39EBwlaO6XL6A1hjhYD4lqKb3fLsm+3smbXjmmiHH77txMSyC
	it7
X-Received: by 2002:a17:903:3b84:b0:2a9:616c:1711 with SMTP id d9443c01a7336-2ad50f8b526mr36135435ad.42.1771473733004;
        Wed, 18 Feb 2026 20:02:13 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73200asm147636225ad.36.2026.02.18.20.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:02:12 -0800 (PST)
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
Subject: [PATCH v4 04/14] target/arm: extract helper-a64.h from helper.h
Date: Wed, 18 Feb 2026 20:01:40 -0800
Message-ID: <20260219040150.2098396-5-pierrick.bouvier@linaro.org>
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
	TAGGED_FROM(0.00)[bounces-71313-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 834EA15BEF5
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


