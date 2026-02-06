Return-Path: <kvm+bounces-70411-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kC2wAIhuhWnqBQQAu9opvQ
	(envelope-from <kvm+bounces-70411-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:31:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 56A4DFA16A
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:31:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1351430C96C7
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 04:24:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 903F6344059;
	Fri,  6 Feb 2026 04:22:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PtUNDhDS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E33B343D6E
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 04:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770351722; cv=none; b=tlYg04cb1l/KMCm+BeekaaEnwMuy8F5FTokZ/YpAXqTtvN6bYehpxXhgR3Txy/q1UVNVf5GqLJ88aq/Bgb0Bc3W5lBZD8lV4RmEB0UGip6b0hy0uj/XjwLYrZmVWhfdX9M5WVJvw+0uU6r4bQnZb7sqFPjLivDrl43FV9s3L6kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770351722; c=relaxed/simple;
	bh=LEN2BBMfkrCiFTErrp36T7nYUoOlWHSZh/jA0QsmVYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhKeyDv6EmrxtkVd1ObiBPTfkUHofnzfCcX4T8sJ0Q7EJDuZSZC/0Bkss9k4fVarIppJvLcGN8G0qJXjO1l82KkbZbOY8MNHPZCp2gqxARNA0Yp/QIhYbYIqdBQB6/tegXMSt8mWJGkuqLQCHHiBHSvsPbnprnoasFRUrpvrCZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PtUNDhDS; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-bde0f62464cso107099a12.2
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 20:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770351722; x=1770956522; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SLG6GFjz6gMYPUgqxMsYfEaJwPICYaIcXQ6XuIJ4wGg=;
        b=PtUNDhDSqzqGuWILHAa625zoUdrUZfzmSxX0kQ9uua1nu235NsKxCL2YskmAej13kZ
         leEQMu8yfKXGehADP1B6vthBC1+bUPucurKtXhSTnyzFrmBjPWgli7LHdQvUwIBdCQlk
         ylNe/MF0xXWbFrmQIXXx0STk8weWaEdpgXqYZnZbnJuU4gHiEr225QClVbjGdIrCCTF0
         xbt0eQ9pKqUT7Xvx7i96Tf163y8Va7/bmB8AdppE7fyCS8217X7vG9iQvEykcHUygUNs
         0m6wP+EPQ8LNq6EuOTctkD3gS9Jqa/xAqCo2vOfYdfVbytTXtL9qI4f4mzYg8bqSAyj/
         qaAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770351722; x=1770956522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SLG6GFjz6gMYPUgqxMsYfEaJwPICYaIcXQ6XuIJ4wGg=;
        b=A74BBBZu3wTkxBPdUjBL/D7eRXRqNJYSiypJvVx+ruleb5kHcsrXIPysffD3WAf7as
         a1rXU8NgtpRhgEenKgam7PvoiXdSpSM5Sb8/bX5jsDcBDzrYaGBJfQWmEB+hHnYQySfM
         dXlwJcyN5AlJGlAgq5FwmpU9N6jqfEZnNESJ24qLP4nixATMfrtlvcrY0NEOPBgWp5nX
         6CkV8lXXGwyFenvI7ttEuuMcZ3PmATZgr9Hj4ivEZnLGzOex1AKbEv3kLkYLUCpwDngu
         AOffp7OCxGchfxa92cnkgO9uYx0Hc7wdyqSBVlBhKdIVN6qj6Yf35sn0eBykjYAe2P5c
         Nxvw==
X-Forwarded-Encrypted: i=1; AJvYcCXEfhBFugBFV6CwLykzNXMC+6Of9BGUPZOtLCYNpwphFJshqiVtQ2S0cUGIhYp/p4l6OJw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHT7izlMoebOCQNQmS/dGFORXQnV0qisGuN6JXHLrObAIwcy8i
	07gX9oz3slhDmpO79FdN08rPu8OEWu/H9/WZt2Ge5yyi746bQcl85QkGjNuNnGqyhfw=
X-Gm-Gg: AZuq6aIJXNKXtCpLKBTt/BG5UCUpWw1wtaDl+S6RltqAceUGot7oTIHAKvIuJHBf08H
	z21C4unWrX+JX0yCSrXDSbTXwUdpz3lu7aOWESdeI7VgosDHy02gOkRQJW90TnKT/Zn+yVyCN1c
	aI4OsFGZvOOtYrqZD8Bo9J4LumUzvC/RR65Yr+f1dqSuxKQ0Eg+SICVjEio2Yhcm6x/HOu9uM5D
	aUTLOSHBVZPUFNCgCIUQaNlK6nRgJbImPcQo9eVjNk07pBQgFi6c9ftN8R9AmdEWC94idyUlqid
	BaWW0RhlouyA2ngoYBhRMXgPx1hsWeFIL55qmEFud9Re7Awt9AVQP6kEOdR82P1r3Dyy2xdlMij
	RjGZqucAQjUSoCw5QhKM3H09Js37DEFiPw0AX9WLawHine5sthyX61rsI8qjk+jzjNaim6Oz5LD
	mvThOPTLAUWnTi3d/ZUh2YFPiSZ8tuic4InXGNrTC4S1ecDWK9Lxt+icmQwZeOLWA6
X-Received: by 2002:a17:90b:3a05:b0:33b:a906:e40 with SMTP id 98e67ed59e1d1-354b3c3823amr1156910a91.2.1770351721846;
        Thu, 05 Feb 2026 20:22:01 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244168fdf5sm926914b3a.17.2026.02.05.20.22.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 20:22:01 -0800 (PST)
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
Subject: [PATCH v2 02/12] target/arm: extract helper-mve.h from helper.h
Date: Thu,  5 Feb 2026 20:21:40 -0800
Message-ID: <20260206042150.912578-3-pierrick.bouvier@linaro.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70411-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,linaro.org:email,linaro.org:dkim,linaro.org:mid]
X-Rspamd-Queue-Id: 56A4DFA16A
X-Rspamd-Action: no action

A few points to mention:
- We mix helper prototypes and gen_helper definitions in a single header
for convenience and to avoid headers boilerplate.
- We rename existing tcg/helper-mve.h to helper-mve-defs.h to avoid
conflict when including helper-mve.h.
- We move mve helper_info definitions to tcg/mve_helper.c

We'll repeat the same for other helpers.
This allow to get rid of TARGET_AARCH64 in target/arm/helper.h.

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


