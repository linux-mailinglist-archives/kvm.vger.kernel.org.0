Return-Path: <kvm+bounces-71316-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WOVDC1mLlmm+hAIAu9opvQ
	(envelope-from <kvm+bounces-71316-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A108715BF0B
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:02:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E0AFE3024A05
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 04:02:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CBBE280A5A;
	Thu, 19 Feb 2026 04:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ydWScnAU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A20272868B5
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 04:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771473737; cv=none; b=e81nWh8c4t2scoozhYW2+yMjzezI5CptExBLJSzI6Dreai7ZZDWvOOH6GHqtifO+cofSoYdSBFvTBuOBL7YAaLn9h4VVlVE7RdBcgETOtYDit8IQN+WrvqUOMYgiFZT2ZMFJVBIvcrjLnX4OBhQG/6MydRKJ00HHL5KujMpIh3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771473737; c=relaxed/simple;
	bh=vq2c1rRSG0L4bWZMyy+WIYxOc6zrEcYn8r9S5+uf2bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iw1GZiKGAcgMNrgAzxR7Jp7HvkYnHYJl6FapK6jb75tdvcC0RPsSDshRJpU+5oYs5TA0eBYY9RzOQWrZFgtCFd+IOqyJQIYJvAR66HfGW8Snz5gc+DWwU8PRzuj6hSjWrPFPK0FUxReiA8fXTFEfNRSDOFQrVjIxh1Y4498aCLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ydWScnAU; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2aaed195901so2245865ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 20:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771473736; x=1772078536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VA/qlQJvE8uq8B0wfP8QzURuC1Jx2blScgULUKFJUFo=;
        b=ydWScnAUeTC/3brNzSJMjo6HcG1etwyGqAVQdPFqtViRksnkcjdAhVww0AAO8u8tmJ
         me4WVCrdXLwa/MZwSzTHEv7dXIsewk1MNdtGYOONdtfuwfAOYBHxG8QyG9JHI+67oNfC
         Ycv6VfHhYtPsG+G2iC+UEO5/T59CcN/fkAEvsOVWwkTLqYap5yy8Csox06XEqj333MWF
         5ddU48usik92cmUEdd07bdY1lFpmvO1F1Wz7b8/CK3cCcmeBcbr4DNw1x29j/xM9ITJ7
         hxYFbAAlWTvo6/VBBaFmE3LQTz+OwXb/bAMCgaRITcA2A/pW8nco236hEoTQ1lJE0+eN
         8Lew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771473736; x=1772078536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VA/qlQJvE8uq8B0wfP8QzURuC1Jx2blScgULUKFJUFo=;
        b=uNu2EWL5mluDmVX/iHVjweAvI3Hh0R1y6z5Si4sLRRc2w/lz97NTMYPdVPvPq5XcIa
         /UMPXgLpVR7v29eNDhSPIb6V0bwVYdJcmZvMaiN+SFbR0iv7ytKq9F6ROxUYFG2mbEzD
         6wKwoDVcTwcZJL6GCbvEtCK0FLI3ih/Dm+6WnQ/QtqXCnMk3WzeossZy1SZHu5sAxhUa
         X9dBxylEewq6MJ5nRKIDd7tOdyPMHzmEjqyhCunF2ul7RLAKaWM84G0MYF7lRyBh0S7Y
         P6oM7tHBbdkxt1i61Kc++SBZ5qOoz6wya4e9StQsi6hpjXcppLYjkjFpHUei8hc0qN3h
         p6Hw==
X-Forwarded-Encrypted: i=1; AJvYcCWKl4SX2qTLTbx0z3UdoH8jvDlJ+0x+nMczsn0BjDQirJ1eyZ/6OrkUPfIiEb93ZcxsE3s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwEOResl1mJmgu827dDmrzyc7lUz86kQPXbLtJDaoJ7CFs2+qV9
	PbSof29fZCSmdwjgFCPandXrKG6Ujcs7s3/o4a+7YXl1Au/E0TWmEChipaS//z9H/tw=
X-Gm-Gg: AZuq6aKTWFrrYpioITjlrWiiHvgnbwefXx7a4sCeqEvf5BYzhvG2xju+/gV168b4NR3
	q/igQJBzTpJ5Wt3TXRFEfDEhoPk9qsjp5oire1HF0vx4VOyfeA8Z/+3iupwk4xOIwGdn7pGIjuA
	PzTCEVAyGelBdgGsc4wOlge3aR5+EVE7YT4qGgMh+C8MglvJ9MlR+Uo4BLbWz66l6+hEk6NXUkG
	1lVD//lF49kVOEiC/wNrTVn7rcnryDofxgBRNt3hEgvGshEQiwHUZYbB6Yy9K3XDvAIhLyKRoDa
	E1arugPDzQWsaOSU8sL1jQ6yvzl/gmjHblcdUP5Q788xTI6exzvhdj9CWXoi3hs8vkTIhqfTsuj
	L7bmQ4P5jGi3cEvYevLxkgsCJmRy2CF5x3bejxIJyU5F1YenYKLk42TazehdRyQMwNk1CFIFvxG
	Si5KJxevfSU6sf8fd9cmrw58MSxYQDvsDvcV24iB/YB12KXmSknXvhAEiFrFJ+er8t891PlPWQ0
	woM
X-Received: by 2002:a17:903:320e:b0:2a9:5c0b:e5f4 with SMTP id d9443c01a7336-2ab505c0e87mr162715635ad.28.1771473735974;
        Wed, 18 Feb 2026 20:02:15 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73200asm147636225ad.36.2026.02.18.20.02.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:02:15 -0800 (PST)
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
Subject: [PATCH v4 07/14] tcg: move tcg_use_softmmu to tcg/tcg-internal.h
Date: Wed, 18 Feb 2026 20:01:43 -0800
Message-ID: <20260219040150.2098396-8-pierrick.bouvier@linaro.org>
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
	TAGGED_FROM(0.00)[bounces-71316-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: A108715BF0B
X-Rspamd-Action: no action

In next commit, we'll apply same helper pattern for base helpers
remaining.

Our new helper pattern always include helper-*-common.h, which ends up
including include/tcg/tcg.h, which contains one occurrence of
CONFIG_USER_ONLY.
Thus, common files not being duplicated between system and target
relying on helpers will fail to compile. Existing occurrences are:
- target/arm/tcg/arith_helper.c
- target/arm/tcg/crypto_helper.c

This occurrence of CONFIG_USER_ONLY is for defining variable
tcg_use_softmmu, and we rely on dead code elimination with it in various
tcg-target.c.inc.

Thus, move its definition to tcg/tcg-internal.h, so helpers can be
included by common files. Also, change it to a define, as it has fixed
values for now.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 include/tcg/tcg.h  | 6 ------
 tcg/tcg-internal.h | 6 ++++++
 tcg/tcg.c          | 4 ----
 3 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/include/tcg/tcg.h b/include/tcg/tcg.h
index 60942ce05c2..45c7e118c3d 100644
--- a/include/tcg/tcg.h
+++ b/include/tcg/tcg.h
@@ -445,12 +445,6 @@ static inline bool temp_readonly(TCGTemp *ts)
     return ts->kind >= TEMP_FIXED;
 }
 
-#ifdef CONFIG_USER_ONLY
-extern bool tcg_use_softmmu;
-#else
-#define tcg_use_softmmu  true
-#endif
-
 extern __thread TCGContext *tcg_ctx;
 extern const void *tcg_code_gen_epilogue;
 extern uintptr_t tcg_splitwx_diff;
diff --git a/tcg/tcg-internal.h b/tcg/tcg-internal.h
index 2cbfb5d5caa..26156846120 100644
--- a/tcg/tcg-internal.h
+++ b/tcg/tcg-internal.h
@@ -34,6 +34,12 @@ extern TCGContext **tcg_ctxs;
 extern unsigned int tcg_cur_ctxs;
 extern unsigned int tcg_max_ctxs;
 
+#ifdef CONFIG_USER_ONLY
+#define tcg_use_softmmu false
+#else
+#define tcg_use_softmmu true
+#endif
+
 void tcg_region_init(size_t tb_size, int splitwx, unsigned max_threads);
 bool tcg_region_alloc(TCGContext *s);
 void tcg_region_initial_alloc(TCGContext *s);
diff --git a/tcg/tcg.c b/tcg/tcg.c
index e7bf4dad4ee..3111e1f4265 100644
--- a/tcg/tcg.c
+++ b/tcg/tcg.c
@@ -236,10 +236,6 @@ static TCGAtomAlign atom_and_align_for_opc(TCGContext *s, MemOp opc,
                                            MemOp host_atom, bool allow_two_ops)
     __attribute__((unused));
 
-#ifdef CONFIG_USER_ONLY
-bool tcg_use_softmmu;
-#endif
-
 TCGContext tcg_init_ctx;
 __thread TCGContext *tcg_ctx;
 
-- 
2.47.3


