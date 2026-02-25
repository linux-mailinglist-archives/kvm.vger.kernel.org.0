Return-Path: <kvm+bounces-71783-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0FTiLwOGnmnRVwQAu9opvQ
	(envelope-from <kvm+bounces-71783-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:17:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 26FFB191EA9
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:17:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4C70A30A6442
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:13:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD3BD271A94;
	Wed, 25 Feb 2026 05:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Ctwzpqtd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C2D2C237F
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 05:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771996425; cv=none; b=n5nKOLlTPo8SgCWlRS31M1uVp3HAOtbwIlF5YPhX3FSHwhaxrnZ2ReWbu/YmYCQT3lJCiaSBnwMwzmEl2A7qVNOPEh0q4GjbTm+GY1tBsndWmpfVzkhDPZu+DABHwicrrSeLylO5yexytRFEgHR0G1DZeitUotDEoU09djeeo6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771996425; c=relaxed/simple;
	bh=Cnn4R+ZjT29i7taKpc5Hbtn3rBWvU1vkGfDgSH5QUTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VUlbrzcMwB+9PJ9RwegCQvlpXGTQhesXl0aX+hHllmuazMlZOXOa8otltqoHLz+krYGxTvpt/n/XaaOBttTmAmgMWcH0zEm2hNPswYE8Iywez+p0Mch9FOUq086Q7ZG9hWvVqiTQYBNpzBySTeOB28UYrAQ6XvgXk6C48IKT+EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Ctwzpqtd; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43591b55727so6026952f8f.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 21:13:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771996422; x=1772601222; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CGvKgLHeevLALbSBED4Jn7ttMmQ4t+uZlwFqVihbumU=;
        b=CtwzpqtdaRbhZJH17nGLjRRsKO++ndg7llY8d8XXmqUgbqdejq3mR5YJYin0ED/jl3
         l59kK083/8BZopsp86ieoTOPRhk8Q0UdhuGcpEQWTztBNlc3QsfVQrSPSlIBdjdFOKpX
         rvr14KiBk0JFumnK04hJw0iJJrn/nu2irvDfEFmxTPQ+xiZwjbIk2SqcKVOmk3azT1bB
         KXh/rq2N5AJy4nYm/6N8gXxAoquqVqmfkpwfbnfwqS/puHLNvaWKV/dRUAK00a6lyPYN
         MH04oY83Ihmwe18rzLENb1Wh0kHmv3N2XyHdBUE/VvM8777d5g3C8PEaghDyDstOASUZ
         IglQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771996422; x=1772601222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CGvKgLHeevLALbSBED4Jn7ttMmQ4t+uZlwFqVihbumU=;
        b=V6eVnI1MGxmn0lCSpLXD2p4uIMwLQKeTxLSqXb4f02SezuOsm3R/TvoFHX5D+27RqD
         PQjfo0CXQ000yPzCbJSqqaG0VWU0/tw3q3VKDxvrCe0WX6p7MiFt9vsxbT+9SNyEa8Kg
         obZuxegRvXdrnx1yAP8jBflQVozCgSvjJRrG3dRpxyWnLozm0+avo50Qyg61fiUuJRCi
         ZHDYyBkZjQBTSjUS5WYUf8nhlGOG+L6U6UknLYTugTb+0DoQKcramxFF8ys6OaDqF/Ht
         SL61NcEYDelfRzwCamfN4tdHx91glMtaQK3eQYFpxjNUmZ34k9GGLfNgH0u46Izg1X+v
         zymA==
X-Gm-Message-State: AOJu0Yw249AbfB80g5Ln3AEZlM1imM5fdmAgnl9e7kKery0K7fxo6WHt
	g1ckxsLyNLeQtnq2S4vl+bW4d3mxK2bCJIDBsJ/PE/rLkfKlbA9df2VWW5rqKLiRBV4=
X-Gm-Gg: ATEYQzzm6tYNWBPOcExwBAVOe0fTI1Ru7RYK1Vfjay4ZLWn7U1f0xqy35I88f44jWRa
	Iimu4At5f3frQOBVRFB/Ha6T7KAdMBEiaDLwgMkpIlTH/9fUtdihigZpD/510F4MA9DMF0BEKks
	pdIMTli2StSfPyAZZfgc9k0W0myyieFSk+peR8cetPCO09YFZLIOrCjXajj8LJJ84CAqk7ZsXjR
	9ubpbIJ4KR5ZqPYCGWWRF5hGtYdRusBjweNLmKrR/3feTIgbhUhTQS32G3GC7lieN83pi4dRAbf
	JY8ZEzrVIna3MYvNsHrIXKy3mMJlVxnQBaw8lOAQxUNdCT0Cy7cwuc8KD2+tzZscKsEpDXn7T5X
	jJshGcuvGwKHNgr3enw6LzyKyRY7ld1xIHfuqIe2JMUFaNwjLNNiy5ObaOFQ/aqeIQJ7ljszjqk
	qjRQvZk3/asqYdOIFCyrL1QzQpDcitjfDptNT+KRpiImyODOX0DcUr3NNtEYb6xwqpcBuENi24
X-Received: by 2002:a05:6000:26c3:b0:437:6758:ce70 with SMTP id ffacd0b85a97d-4398fa70637mr1467991f8f.26.1771996422125;
        Tue, 24 Feb 2026 21:13:42 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d4bf89sm29682387f8f.29.2026.02.24.21.13.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 24 Feb 2026 21:13:41 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: [PATCH 5/5] accel/xen: Build without target-specific knowledge
Date: Wed, 25 Feb 2026 06:13:03 +0100
Message-ID: <20260225051303.91614-6-philmd@linaro.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260225051303.91614-1-philmd@linaro.org>
References: <20260225051303.91614-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.34 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,linaro.org,redhat.com,lists.xenproject.org,kernel.org,xenproject.org,xen.org,gmail.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71783-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[philmd@linaro.org,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,linaro.org:email]
X-Rspamd-Queue-Id: 26FFB191EA9
X-Rspamd-Action: no action

Code in accel/ aims to be target-agnostic. Enforce that
by moving the MSHV file units to system_ss[], which is
target-agnostic.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/xen/meson.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/accel/xen/meson.build b/accel/xen/meson.build
index 002bdb03c62..455ad5d6be4 100644
--- a/accel/xen/meson.build
+++ b/accel/xen/meson.build
@@ -1 +1 @@
-specific_ss.add(when: 'CONFIG_XEN', if_true: files('xen-all.c'))
+system_ss.add(when: 'CONFIG_XEN', if_true: files('xen-all.c'))
-- 
2.52.0


