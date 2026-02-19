Return-Path: <kvm+bounces-71319-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0P00L52LlmkBhQIAu9opvQ
	(envelope-from <kvm+bounces-71319-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:03:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E25615BF4A
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 05:03:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C937D3033FAF
	for <lists+kvm@lfdr.de>; Thu, 19 Feb 2026 04:02:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F84228640F;
	Thu, 19 Feb 2026 04:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HjM2/ILq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3EA11990C7
	for <kvm@vger.kernel.org>; Thu, 19 Feb 2026 04:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771473741; cv=none; b=gKMmAp0XBEBxDyNZMGsbgH2WH7jjkvG1Ag9UKPxkSMH2UytTDXwe5vnikzlAF34tJcDLM4aoWIqD5upsIPzudBkOif1mvxzXlE3x+mocsYwkeDh6/Jn9yqnMBlp5115N4wi8rj3Izec/Pu2yQGEGlTvA92DX1FQnV+i1q03t6ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771473741; c=relaxed/simple;
	bh=M2tksZp8I/qc7dz7SkIQWKIi6CVRN+ZY319nLiCaqUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hO3U0zQpI6V2Jcj8ZWOdbJqqOMbaeX9lsh75mutqEj3YTrFr7Bnahg/guth0oRfYE3JuCJNTw7dM+2lWOLnVC45aoLQ4BwIZat4tJWJqGdoG2ejbelWGlDv/wpveYnmbG1NM3+eXQBdqs4S+OHXRLH4WpBqFl3fZTiJrXmRzQzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=HjM2/ILq; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2a95de4b5cbso4076315ad.1
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 20:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771473739; x=1772078539; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w731RNlMT2uStSKIDhJqip6UtoYH7ZCTQWwr2BG+eck=;
        b=HjM2/ILqP0KxbIVcDm4yoX8vfMb9LFOG3siZzRM5EodGe7Vr0VwO8ehHf84LiJjK6A
         fc68Mx5zntbwTXOV+nsbWo6V0EZnY9ylerOi32ZpGMULLBqRIWHwgoxht1NZAt6tdcxd
         QfWxRlh1rBFVLeNXZm8URPq3d95jLeOWgdsd6PtH+2joB54ryVafU36fvbYDoTjCP+Up
         QzBd+Ypid3V1cL19pRz3EnK/0+U9GedF0ay7lIaD3UV9DbDMxOF0yDKVBt71OHo3lp94
         P2m78JjQqi8ep/aMFK+AoSf+fUktif1hvpGpJeKaUdG83/hA+ex/C6csniBuAPsf1fpf
         hTtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771473739; x=1772078539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w731RNlMT2uStSKIDhJqip6UtoYH7ZCTQWwr2BG+eck=;
        b=LYa1eMgqnfW3YnfxwSTW/C9cnHkNjqJZ2hj16RptNfzGImkT818q8OUdkx5UdhcxOQ
         fUn5i4wGrG6+5rb3qJVLhGQj3jrUyxZ97/6Suwi9zJ/yKeEUhEAdpjrfYqRtx3+eT09/
         tU7rck2YhEuf+gpmvdsnnOU9Dn6JxpPgaS9yz5BVmd9iB3vbWN23E0H456VRk51Cq3DY
         n2pNH9w9nm+MvEPHTbgkjf4afXLWYCGf07Nc0LdnPLX7UxlNmlXsbJL9p28xghzbzN3D
         uIwIU1FDW78rA+HCd+s6Mxq41wbQAfQ0teo1BmZ3cWOsiXBMNO/l0MHXmoWG7pO89wMs
         /1RA==
X-Forwarded-Encrypted: i=1; AJvYcCXL3YTeaHcJJoqWhKjd6wnAqXguMULUBW/AhKGKbbnSUxYy3+OqiU1YvFzc3f8rdYafDbI=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywzt/+0LDWKzE+5zLpzQ3q5L4MqwK7Q+CU0xp2rCG0g7cBZ+sVy
	JBqPCpzHthek3uOlWQtkTCa28fEodggHCf3+o2tzKTj270XCWRw+3gq1VIobBZ0iIvc=
X-Gm-Gg: AZuq6aJOYeeLORxt1ZwNgUpicfBFcydu5n4oiLPOZHHushW4hSciHA4ESHu1wwnX8MG
	w5PeWN29pZ2n8MoRTVunpfENFoCckcgPVuBiAaOGqT08iMtf+IzzE5AqPTAN+Weq7F2EJtdsWyS
	iIvz16ftMM8pSazyAGcNkGPE0kQen6xL9y1ZKA1OOCSixhuKpmUnzWyxVzTGUkn4Si9h9OpMTR8
	AAcA5fBMFy053FL8NYvZ4eeDKG2KJ5ojxo9C5F2tzBRk0IfcEzlGviOjkPssbQZt/U87TFvVwrf
	Svr3Ew7aCnA4N26EkHXa4Izg27td2FDpQu80d327bFQHl15ZVsLqy8WU+RZtCFbE8ShbbCsFgOb
	frLwrdcJQUlYNVgpYb/kQeQeH5Vh9etE5FwO7EFK/CP49IQLkarGdo1kXNQg2nYMElkI0FfC61n
	EweQrwloPcvQ4OG73WZwPBSgf7bAuJ23gXFsLmuRonxG2Nvxnzo4W2nI5A2YDqHhF7uBaq3FuJv
	DzTG+0Cn7Pac0g=
X-Received: by 2002:a17:903:244a:b0:2ab:3cba:42fa with SMTP id d9443c01a7336-2ab4d06157dmr205990305ad.46.1771473739025;
        Wed, 18 Feb 2026 20:02:19 -0800 (PST)
Received: from pc.taild8403c.ts.net (216-71-219-44.dyn.novuscom.net. [216.71.219.44])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad1a73200asm147636225ad.36.2026.02.18.20.02.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 20:02:18 -0800 (PST)
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
Subject: [PATCH v4 10/14] target/arm/tcg/cpu-v7m.c: make compilation unit common
Date: Wed, 18 Feb 2026 20:01:46 -0800
Message-ID: <20260219040150.2098396-11-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
References: <20260219040150.2098396-1-pierrick.bouvier@linaro.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71319-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pierrick.bouvier@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[11];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,linaro.org:email]
X-Rspamd-Queue-Id: 1E25615BF4A
X-Rspamd-Action: no action

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 target/arm/tcg/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/arm/tcg/meson.build b/target/arm/tcg/meson.build
index 85277dba8da..cabf65e6236 100644
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


