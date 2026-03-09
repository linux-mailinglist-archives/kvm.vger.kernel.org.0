Return-Path: <kvm+bounces-73340-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2MesAzcJr2lzMQIAu9opvQ
	(envelope-from <kvm+bounces-73340-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:53:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6099B23DFFF
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:53:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0CE1A302768F
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 17:49:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 375962E040D;
	Mon,  9 Mar 2026 17:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="w6THNWI1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D022C0268
	for <kvm@vger.kernel.org>; Mon,  9 Mar 2026 17:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773078588; cv=none; b=lsSUcoqIAYRhC6Iz9RRINWrX7LITLdzEq9jJi3dziqUKgigtF5o3bJR1PG7SSqoDYti2IJZ/L8ycK7q731HSJu1fxkuvxKuopQr+k5S7bF4vxbHMePBe6bWCi9a8z09j9iti2TBL9vzxn5HowsE/oEb63UUw/aVrH39L+Np8/Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773078588; c=relaxed/simple;
	bh=f1Mc8hLDAD0BorrS5iApl4RfvnDanr+SF84U+cRZxlI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=fCdRnkxPCMei3qxhuf3GD8RJXDBwxA65F6iIj6d3JkUdd1JGNwRY0w9Jacz6OgM45xEy6FVv/9s3nSv7OQpmYqK2GYSC2pqlVma97PPCDNK/19i4t0sMI4LnGHv37rBp5UKYxNxDV0CDuBlVsB13Q7OmmcsaFqLG2h10+OXElr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=w6THNWI1; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so25693325e9.0
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2026 10:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1773078585; x=1773683385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IsNjI4BjTTn39ADNHcYY6cGNw6j3aYRSbYWW+jepIQ4=;
        b=w6THNWI1aWAyX3qCrj+cSkEI0JdkacnTmAfhMjCEBxrQ4hoVN4MXDJlEvmaQLJoMHu
         G3Ele27uwlnRePjfjmCSG34l5XiDSLszyjB9Lu5Oc3sxtwKoMbLDbvHVPlcIEqWkgWPC
         uMnvmllshMrJ236IGw/FNXJRk4HaI6D7fEL395EfodIKkZncQfKPGFUDfKTT+BQiJkR1
         /oiyFmBM+ywle3AfZRAfrzRhiCNzBYdSZfcg8SXENkhKqu8nFpphYn59EoLYy2R7ncFw
         jBKU1J6pcVQkyfSgz+PjXlbsSdNOP2Xl28Ho1QD+GiMgrLP/7bYysqXL0G+jIV2u072n
         nv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773078585; x=1773683385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IsNjI4BjTTn39ADNHcYY6cGNw6j3aYRSbYWW+jepIQ4=;
        b=lgnNJTAUVHb3wxBwpd0vrlHl7C7MKmOSboWZkL4X3reXdXHy3UvZCPKh6JjvXYQP25
         e8uTIfI9yyVis3hFLbENZTq8jBzfgptGNnYgIO3g2brYsFm7vXKNAarQUim+KCJFGN0t
         sfnUC/TwepBkUO5fyC4Jjh49ppWk43t+Qv7arftCYurXafCUJGVZvcPWU5PdCDvgS5jx
         xZLQDg590U4HG8+r3/wzharre+zOOufyvGaIFFIjluhf6oAKeSgpD6Hl0VX3KiwIIomi
         /r4dRf6d+q1pZE5IKriSDJZZ40CDwAaxUiPwOGc5ef9NQLjwIvy294ytRLkSND44c5oc
         c2yA==
X-Forwarded-Encrypted: i=1; AJvYcCX54QfGqueMuXQ+mhvdXGq3ZrpeKWt38icBLjk/HLsDgMdkrPxhyEGQHSRgltoRJpCeTMg=@vger.kernel.org
X-Gm-Message-State: AOJu0YwWVCp61R95MfHUgcDwAiauq2zFRAw3Hq7bGpv3XxTETZNtiJtr
	kfHeTanM8yVmroQ3Psbc4oE2Ar31xdjupv4enpjidW6AXq0pHXO9a+HFzqmGPdlclkDufLfS9xs
	ybal3EwI=
X-Gm-Gg: ATEYQzzxCpvYMzbXgPrBS168vRpkoQHh68/NlwUghGM6VRyK0yPssyDyhrxNdaCehmQ
	RGgyNRDPb9DwOQD2VLK5FkZwpz0pOBZ/6VJHw95AuI02th06T++vaXlqdobTjxKkthFDVKmByf3
	OAwKRmTRrDZ+cD2GIDekiIt5H3FaQwjUf/g7SDYrGQOnYg9PZRRyz/7hbcsHdGCWwKT4NFtMm/i
	/jqdNaQOwgyUSC5wo879WCLbxZfiwksgYfqTNi0tK691EhIV3bVOBK/uZseO0ZO45O7+vnaTCGO
	7svjwNAIPT9JSuC6Lpsas4wgTepFvZpzNT0kqPgmbMcQwuugMhJqb+u4MTyr/78Ipb9tYuLTelK
	2zI0mZ5oE9PfcWZz8sHJaIrrKJRRTU2JlMEjhv3Fzje1jolT09QFTKY3+Lw/jwOVPXo6fdNkQHM
	RFhjiQBixN2LjEa7o9/7Zw3fSMRHvJs8fZD4qRTtq7HuKHatusKTwXl67IvKrBTI5no5Zx62/mc
	ZehFlVVSe4=
X-Received: by 2002:a05:600c:4507:b0:485:34a2:919e with SMTP id 5b1f17b1804b1-48534a29447mr104839385e9.33.1773078584740;
        Mon, 09 Mar 2026 10:49:44 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48541b6f708sm9142425e9.11.2026.03.09.10.49.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Mar 2026 10:49:42 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 0/2] accel: Build stubs once
Date: Mon,  9 Mar 2026 18:49:39 +0100
Message-ID: <20260309174941.67624-1-philmd@linaro.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6099B23DFFF
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
	TAGGED_FROM(0.00)[bounces-73340-lists,kvm=lfdr.de];
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
	NEURAL_HAM(-0.00)[-0.999];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linaro.org:dkim,linaro.org:mid]
X-Rspamd-Action: no action

v2: Expose kvm_irqchip*notifier() declarations

Philippe Mathieu-Daudé (2):
  system/kvm: Make kvm_irqchip*notifier() declaration non
    target-specific
  accel: Build stubs once

 include/system/kvm.h    |  8 ++++----
 accel/stubs/meson.build | 21 ++++++++++-----------
 2 files changed, 14 insertions(+), 15 deletions(-)

-- 
2.53.0


