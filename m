Return-Path: <kvm+bounces-70415-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QLsHOa1uhWnqBQQAu9opvQ
	(envelope-from <kvm+bounces-70415-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:31:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 78EA6FA186
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:31:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B57A23077983
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 04:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF9B7346AD4;
	Fri,  6 Feb 2026 04:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xw13XdrU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED232345CDC
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 04:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770351726; cv=none; b=qsFKSRou9mrJ5B+cgdqzEakr/hROmMxZbq7o+6HqVJsB8pqIHhriMfLTJ4IwvNIf4PxrQ0bURQ2bEdA4ZZS8LGzdx8QGwt+geKg4Umte1B9kK35ORg2Cda/jmu4ySMokgPm6fMAc/WhbdKRnAPsX/4VC3ZlGL9FZwjNR8hkvyS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770351726; c=relaxed/simple;
	bh=/Z9mDI13T+VnYEHkTgB5k5gFAdYXQbonH45Y29nEzz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isykx9zC3uWdSNIdvyLcS/AgSqaindx0cdPxWpTkY5pYLZX1yvQJvCgMotBgLlCKTWAl74Ag9nvBOh+bU6t/06Wl3Iu2jiVQFaVqpc4iUfHI+epsw2VXoAUeiEcVTjkPyzOA8MwkYvCFtTkri+ST8RMldRqpXZmYzgq1bpV7xMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xw13XdrU; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-34c868b197eso1241373a91.2
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 20:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770351725; x=1770956525; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H5cXOVfc0cfcELp2wbWGKaUPyMU0neuGXQOK5SCrE88=;
        b=xw13XdrUFvvHfDqdyvgzYlCor9g/MFbX14BurVN/x2OCXrqiGSexj9EIO1SiwjaT0R
         681EGTMjD8hTq2O1rfPK1oLsXoQIs9w7BRJeh9N9u1PyG/KZGX3ug7RQaAeyg+q9hVjy
         22HUhBUzztUpVoo97cd8TGY/3q+xw82b/1ChOvBjI9YDqHj76GPOgsDgiWmuZQuUWC4n
         8+pI6zhPtzgk47iL2aRqQgmNvZ4PjhlsATV/E9NJzm1/5VshhEPPH8GuYNa6K7W2rTAX
         4sn5CvejtLxE28knklj6uAs7rXHopiB2YGNNIiFxQIsa1WMUC4X8BwHdxkiQvUkYXmJN
         qs1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770351725; x=1770956525;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H5cXOVfc0cfcELp2wbWGKaUPyMU0neuGXQOK5SCrE88=;
        b=RqdINAqsKczi3ctCNgx/SFGtElkwe0QcEJe4g8cHFnFf3eiT6sSUzXQ8ADbHFhVz+V
         f4IR8w4Jc4M0PIbk56LILkjjNulEuSqtezRtUtQLkFD92ZYYUYqo2QZPmCk7j8OHysyD
         wqX91WCr70nXR3TIqQ24p91O8iOEZ/16GpmoF/QYDcuP0N3C1MxNQl0EM9esRqG+g7L0
         S8dLxQ9D0FGFnKsDC8ILGdpPJ+ad/pCBcrPOXscqgRVRAYfKt2Sww+mMICyAiTPFa32g
         r3VKqC8phIbxbZ59NMPo/0WmxyQKVvdAHyOQKjEh00S/JtHI8RxgpCxV9YTXitPyQQDn
         Lfgw==
X-Forwarded-Encrypted: i=1; AJvYcCXuaUj/oRs0qHboAIT2e3lGuo3CfXvE59rWgmN6ZreRn77Q81qfBwymnW1SwG4sJ8unUgI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoiMbHwS5UXPM31nambBlVRM4PRhD4d3TMxgL+fqTb7AdzIwpr
	M6inC7sRdycmV4ikSfrJQrQ6ku5pbJOU4NHb5te/0eDngAv8vS1B8i/aVxILNTkuE6s=
X-Gm-Gg: AZuq6aL7Y7Hr3igsYRV1k6rr2A4swjhcagVDNSBItMcCnkcaY4lMN7bsf1uBwJiCpgO
	wAgMUZifcrOhHW8uNg6QF/ufi4TYl4xMYz1Ox/ykl0sb43JN6l/qM7H+tEyCuNmPoCq5+NYGs4u
	NnpPPAENXMIZb8VDz9Is8RbFTmGUJA7uDWhGDwfpho+9EpHvmdmDbPQiupm4arSqTgu6RRGFWb2
	YAG3XUuBejeMdLW3M7sK6/qvznqL5hWyHghKFr/NtZ9wjh5T6fJiJvzORtDtwgo/EnMFJK5lXgG
	uXuOdz2C2jXGEYZidRCuWTMXA0ba/tbw2MyHu4zAqm+A95DuviZ9o87osa08VaJxx/2FNA1v8Pf
	AcfjIz2702jFV5TdoSbixuTepE6+C1yWW54z+Zp0sjoamUCLkRanby8ZfSm9slQCO+2WP4owWTS
	3pCKAMQ6xJfXpK7wjNNbo2LG2gwozYJ9+irZ8GfqROTzCsIg9EdGa4Se9X/6NcCnDL
X-Received: by 2002:a17:90b:35c5:b0:34c:f92a:ad05 with SMTP id 98e67ed59e1d1-354b3bc38ebmr1131436a91.11.1770351725298;
        Thu, 05 Feb 2026 20:22:05 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244168fdf5sm926914b3a.17.2026.02.05.20.22.04
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
Subject: [PATCH v2 06/12] target/arm/tcg: duplicate tcg/arith_helper.c and tcg/crypto_helper.c between user/system
Date: Thu,  5 Feb 2026 20:21:44 -0800
Message-ID: <20260206042150.912578-7-pierrick.bouvier@linaro.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70415-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:email,linaro.org:dkim,linaro.org:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 78EA6FA186
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

There is a single occurrence of CONFIG_USER_ONLY, for defining variable
tcg_use_softmmu. The fix seemed simple, always define it.
However, it prevents some dead code elimination which ends up triggering:
include/qemu/osdep.h:283:35: error: call to 'qemu_build_not_reached_always' declared with attribute error: code path is reachable
  283 | #define qemu_build_not_reached()  qemu_build_not_reached_always()
      |                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
tcg/x86_64/tcg-target.c.inc:1907:45: note: in expansion of macro 'qemu_build_not_reached'
 1907 | # define x86_guest_base (*(HostAddress *)({ qemu_build_not_reached(); NULL; }))
      |                                             ^~~~~~~~~~~~~~~~~~~~~~
tcg/x86_64/tcg-target.c.inc:1934:14: note: in expansion of macro 'x86_guest_base'
 1934 |         *h = x86_guest_base;
      |              ^~~~~~~~~~~~~~

So, roll your eyes, then rollback code, and simply duplicate the two
files concerned. We could also do a "special include trick" to prevent
pulling helper-*-common.h but it would be sad since the whole point of
the series up to here is to have something coherent using the exact same
pattern.

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/meson.build | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 1b115656c46..41cf9bad4f1 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -58,20 +58,20 @@ arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
 
 arm_common_ss.add(zlib)
 
-arm_common_ss.add(files(
-  'arith_helper.c',
-  'crypto_helper.c',
-))
-
 arm_common_system_ss.add(files(
+  'arith_helper.c',
+  'crypto_helper.c',
   'cpregs-at.c',
   'hflags.c',
   'neon_helper.c',
   'tlb_helper.c',
   'tlb-insns.c',
   'vfp_helper.c',
+  'crypto_helper.c',
 ))
 arm_user_ss.add(files(
+  'arith_helper.c',
+  'crypto_helper.c',
   'hflags.c',
   'neon_helper.c',
   'tlb_helper.c',
-- 
2.47.3


