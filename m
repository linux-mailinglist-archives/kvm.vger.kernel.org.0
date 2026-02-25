Return-Path: <kvm+bounces-71778-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cN2LDcOFnmnRVwQAu9opvQ
	(envelope-from <kvm+bounces-71778-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:16:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 89811191E65
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:16:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 062683061E1F
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:13:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7032D3A7B;
	Wed, 25 Feb 2026 05:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eBt8U2aL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C12219319
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 05:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771996389; cv=none; b=doDHrkLF3c8nAA8qorNy905oFNWbHaQH0QcOipZ2obFHD/1rEC7bZXU86iIG6DxrR7J/jNuKvfbLbnFIPg5Yigzt2kC17A4x2CzNS5rqQ0xwzJH33W7LHq7i4tZbnfSAvMiC/eucyOpFBBRb7t56IfZMb64LhPCQ+nh2gqzCXtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771996389; c=relaxed/simple;
	bh=4beV1EVhUwtqC/BeZtnfhBmTiW7lhyn9ApX6B2Rv4Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ShVNtoYWw1HyGW8ZxwQIyfNuDBlNQlsdVv+bm/rxKNCSx87QH7Lx+e/Vyk+eVR0xyQeVmBcoR6+ibL3N16rpOVC1yvy981ybhj25pybxSNYuZO74DR1qvLadjnTCuggudAD+k0nY/ZqY7BTLfa+gs87FgquzEamC+bgoEaFcrrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=eBt8U2aL; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4837f27cf2dso53081565e9.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 21:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771996386; x=1772601186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j0v0q58T93WLY+QFmTAFfQHATj0wMqCjYTuLixMjNSE=;
        b=eBt8U2aLl9xboyIjiI1SNV39vFQSse/OXOl9hc48LWvOHpdPV6QFm4qESD/TK92T9F
         00VtV6BlzQfmrYcbDMeUFxGcKnX0IE6t8E5+xTAO971DnX64eHeYYgR/Pld28kT59jGe
         qhCfLYIn+RH9NmQVTTH68ZXjYfXddmq96S76NKzQcVlu+cS3uejF19rSgBz0WzUSYSqz
         wEM8ZJZ9z1ltfiRmGWQ6j8sIO9xtuh/B4JcZEPd2k0K1SUX0dV24comp1YsKMGqV71sr
         lRVYPLxvS8Q2rFRyMNKcts0Gb1lhDGNMRgit8gfCP19yJywbCea8A5EoT7JZTE9CEPVE
         WOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771996386; x=1772601186;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j0v0q58T93WLY+QFmTAFfQHATj0wMqCjYTuLixMjNSE=;
        b=NrfnQPQmUlkPG0E511uTTIobbw+yrTpitATn0IfSmGbegNOy9q4gU2KxQ9GpfcbweY
         g7Qo13j0itHcskyCyI3j7QsiwEjmzShvgPZ6rtAXqOXHZDj2892EY136Zaw+5JjkCuIf
         2ZY3exm28VPLkUG8fk0+0ouBUEQkE2KYUAHUExYsYSFcdHE40903HPmtNrVqy/HfpUCP
         VMGphLuGiGC1HYCychALkZPhct3c3V1OY7xzIYAOH27m7YtuJodymdY2cerJZMy+Vg27
         N4bbO4HobdUq8dvhStNrutUoXZGBVfL/++R6i2Ew71doMRpPbeGV8Wh/7Ei8+lIRt/7/
         cx0Q==
X-Gm-Message-State: AOJu0YxPOaQx1kYiXkSUrNemy1TezjwoIE3twQiOu6FXF263Ufs6e+yZ
	MROBWBfNXODplq2wyQeu3ij00OZwbmkyRBs8uEokrI0QrHIuXz0nnVOSIDaw6tphc0Q=
X-Gm-Gg: ATEYQzxTQSzt58qyw881ZiZ22nQVp16LcWNRAzoZNiKe7fN4L7ImciAxul0kfsPxdlI
	LcacbEwNXQF/FFtV/xye9pqugmrAx34QnIHM1CVQIGkJhrctBx7u9TnXGNtK0qcVlntLlMy0hOG
	mgKIji/BiKMDfuQhK92Z/nfy1u+tdgoxgodzPU5EXcOn67tu3FJrGUqj4DhSHd8hv/UfYHtBHvs
	Y1JqlUYV8wkiccnr91oZzI5pCBpEGo5F7TUiNZF18eXzx342073ZezoWvq22ZQ2wTUlYPy6oSCn
	RVhLGa535OAMgCMAB0qiX2UggmbXjFWsjQKcUjE3+DGQ2HDtDTKDboWEDfxPx4j0zaYJbnYARIR
	4hA85lnm5KxCPpU7yyDLUt/Ch0vHLdiHI3RyCjsz1nnY7YhxVybWYngzAt6JR1lLwo1WeK+WqMJ
	J9+kHpVj6mQHPHc8MlOqYcR5e99cyUEkDkE95KuIh6PU4c3n+7yFjfetedOlx+V0eQGnlPPye6
X-Received: by 2002:a05:600c:4fd3:b0:47e:e20e:bb9c with SMTP id 5b1f17b1804b1-483a95fb0a0mr214322895e9.8.1771996386044;
        Tue, 24 Feb 2026 21:13:06 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd750701sm46374715e9.11.2026.02.24.21.13.04
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 24 Feb 2026 21:13:05 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 0/5] accel: Try to build without target-specific knowledge
Date: Wed, 25 Feb 2026 06:12:58 +0100
Message-ID: <20260225051303.91614-1-philmd@linaro.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71778-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[philmd@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim]
X-Rspamd-Queue-Id: 89811191E65
X-Rspamd-Action: no action

Code in accel/ aims to be target-agnostic. Not all accelerators
are ready for that, but start by enforcing a few easy ones.

Philippe Mathieu-Daudé (5):
  accel/kvm: Include missing 'exec/cpu-common.h' header
  accel/mshv: Forward-declare mshv_root_hvcall structure
  accel/mshv: Build without target-specific knowledge
  accel/hvf: Build without target-specific knowledge
  accel/xen: Build without target-specific knowledge

 include/system/mshv_int.h | 5 ++---
 accel/kvm/kvm-accel-ops.c | 1 +
 accel/mshv/mshv-all.c     | 2 +-
 accel/hvf/meson.build     | 5 +----
 accel/mshv/meson.build    | 5 +----
 accel/xen/meson.build     | 2 +-
 6 files changed, 7 insertions(+), 13 deletions(-)

-- 
2.52.0


