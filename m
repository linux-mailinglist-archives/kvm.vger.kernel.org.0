Return-Path: <kvm+bounces-70418-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WKYZM/ZthWnqBQQAu9opvQ
	(envelope-from <kvm+bounces-70418-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:28:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DEB9FA104
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 05:28:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 94606302DE11
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 04:25:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E446349AED;
	Fri,  6 Feb 2026 04:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RsN9QScz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E1E348866
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 04:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770351728; cv=none; b=FFSnXY6e6Wc6anBQvHcYITG/KaE/1/oejeWy5SuIUcl/Rku6p6Zf1QnacCmU3ZBO2NKHET7y78zEfbRuFkr/zDABUGcbuk3Haf6OUy3iN6/wjOuQDCyRLlznK1ZDFnw0swKOwqdwan700EflG/D08dQl57fi1mla4Maj5vInrYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770351728; c=relaxed/simple;
	bh=v8goVfDuf14zR0/BBK5OuObXtxk3NausOzDpiIrrrQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hRpagL4zYkfWEUUXkBsHZnm92LrTo/SKb/XDrD1gZ7EcxROeOSZ/9OTmZEXFACyMcoODkETJVTK0G9WumFkSCpXSBHq9tpaNe1t0jxNnsUsENoRcBV4itQLwM3SOEA27XUalFARXXKAw8cYgjXiC9OnMxPMoEWlWUb3AWzgbQnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RsN9QScz; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8230c33f477so760272b3a.2
        for <kvm@vger.kernel.org>; Thu, 05 Feb 2026 20:22:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1770351728; x=1770956528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q2HC49N+r3FDo4kaSsrqfKOmxBBKt7bfTNmIl3FbGEg=;
        b=RsN9QSczJC/xeAcEf3MgsFIyZ96PWzlXAzPOZMvolEutiYXoQWE+XASukKogG9Ndxg
         6lktvtjrhAAXL9eCK5LfD2nnqSpdK+WeaguU/6UUugUSjdagMHQdUjGz0/jd6x81owL2
         Fag0mtU4a7QqE9ZuWJ7lkv0rli1E8iFsImAMWfYpjpUx7c77aqjZD0rwhBo5KyIip0Hq
         aIe6x1fS+yzhQgD/Vjr8UohNJjeL/ylQWPKc0j8fXbwlOLAzsAClbZG7PY83B7LNfTCd
         jGhpvFj0NbA3sJ9NA8SNFyuF8nUznqtGGvEFb1lZjZFKsUtMAKrunjCDfW14YXcwRqx9
         7LOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770351728; x=1770956528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q2HC49N+r3FDo4kaSsrqfKOmxBBKt7bfTNmIl3FbGEg=;
        b=ZYn6peXlK+l2/r+yOEsBW2zkMGcFXYdztlXpEqH7w2o417dwB0HYWD9enD4vmPaHy3
         hQcqGMTodURSOVv1bacGXp+/oB8cFWqH42zGSBGy+GInOCahTX9tOLrrRcXkIt59PaG4
         cWGmeFrfMle1t4TIuIdxloWX+c9densdtkpJcvjImjszygUW+QM9se/QeeO9/HlTBqqS
         Rm164X84lr7QttIZeVv8uBpqi4f6DtL0wt2Sb2yffO9MOniZjHdqNamPeqL8sDqhLWRE
         r91L54DQysjMZaistkYRy3+kWl+KMqc/bMZsUgK5NwKL1XsB2VEbW6FmPCM+4QjOJme8
         S8lA==
X-Forwarded-Encrypted: i=1; AJvYcCVJY4WeFBvYHYdjKaz5LHeq93A6d1e0WFhkaAu6k+odxeChj+b2T5y1oOi7YSj+K6YIxOI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzxSHAt5AV7GoH3wLoYh7x07xi6hJkmsnNpO5TzptctM+hb8Zj
	t/3qcFfOXFsRHu/sAc5jUomesZDrUitJZkNiE7rjItlAIRoGApZMnnpS7E7cebDL2Js=
X-Gm-Gg: AZuq6aIQF7gdG1CyHVXrvJH7m8op3ntxlEPh28wg2ZmxtEJtN1b6Z2enok7kUMArXMY
	jSTEmcoF8KkLLh5xN45IwzAT6Bjey2wzrJ6tbzfV23gmU7otzznXODMcJd8o4ScNDKBoDlmV2Z0
	JTkRjrQlikD8HiqPX7Lc8wlTvs0gpOMesYqzqVtwXLi3K9C/wz2ZSo9fgs736/hRekovWQzy5v+
	tWk4RbiS123fqgS3X87tESLppJulOFnkrgzi3sQqgLGC3kf4/hZxhoJxhxniNM+da4s7z5oK/e2
	UpvKCabpS4R0k1pue6Ao+zWeHpc7sae+tSomda9Ep0jYm7LIv3JAINm7o9e8fFxrtNIB8QTkGtu
	+oQB/7BkGPajgDy2rtusfc8JVpRiSskmYwBNCissf19kSWStoMBmvHPYO9bWLI/LAihI+xKH505
	nlvX+x85ZcgStWkULTV+jWcfjoqNLlpBlND63gVFK5hI24X/5HOUlMrxKH+1pRe2ub
X-Received: by 2002:a05:6a00:4acb:b0:823:167a:4790 with SMTP id d2e1a72fcca58-824416244a9mr1289097b3a.26.1770351727946;
        Thu, 05 Feb 2026 20:22:07 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8244168fdf5sm926914b3a.17.2026.02.05.20.22.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 20:22:07 -0800 (PST)
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
Subject: [PATCH v2 09/12] target/arm/tcg/cpu-v7m.c: make compilation unit common
Date: Thu,  5 Feb 2026 20:21:47 -0800
Message-ID: <20260206042150.912578-10-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
References: <20260206042150.912578-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70418-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,linaro.org:email,linaro.org:dkim,linaro.org:mid]
X-Rspamd-Queue-Id: 6DEB9FA104
X-Rspamd-Action: no action

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 12f126c02cd..092ea218c92 100644
--- a/target/arm/tcg/meson.build
+++ b/target/arm/tcg/meson.build
@@ -49,7 +49,7 @@ arm_ss.add(when: 'TARGET_AARCH64', if_true: files(
   'sve_helper.c',
 ))
 
-arm_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
+arm_common_system_ss.add(when: 'CONFIG_ARM_V7M', if_true: files('cpu-v7m.c'))
 arm_user_ss.add(when: 'TARGET_AARCH64', if_false: files('cpu-v7m.c'))
 
 arm_common_ss.add(zlib)
-- 
2.47.3


