Return-Path: <kvm+bounces-71781-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KFirJA+InmnwVwQAu9opvQ
	(envelope-from <kvm+bounces-71781-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:26:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F6019203C
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:26:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B24AA3053F0D
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16DF72D481F;
	Wed, 25 Feb 2026 05:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pYCxU9kw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2832226A1B9
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 05:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771996410; cv=none; b=F6oF96hum2cb9/zr4HhUKe4oWzMrzkDkkss1MEsxwaNhCxYGRAAG2MQN0ZmpA7vKTt4mYFd7PYsCQkNesIBhDZSDuVUPloHc3XMKgPfnw1GMvw2Km1eK+bEpU5eq7tu8VygZkDJZvh8JMVJbpWd2ZnpDVhjP9aebSZfz7KADFy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771996410; c=relaxed/simple;
	bh=2AoKr92T49E06+jsYhmPs/e1jUdJ5zet6oC8aXDwv6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kENUBpU5m7B7EdFFtbzdu9pc48+YLdoHc3uxUpYo3XwkwAF+4H3xocwhoGg649w5DSoNsacrUczS5NwecRkXJ43OvT28u65OAEJ2mB8Nl3VKUIzYd5ztxSPy5rqT/F+UpCDBoSo+kdrL7oYfrYn7l4/Hch8mf/N1lPyNu3YPKkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=pYCxU9kw; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4806f3fc50bso69997225e9.0
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 21:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771996407; x=1772601207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9StylsjjkPu8pnZ8zwuRErmCy8w6JuJLaaJ30WKTm3g=;
        b=pYCxU9kwOyCvKVr/PQQCJtWZpNfrYMB7L6N9gBTR65BcU0hBl0Ngg0cssFoyys954b
         dP81EcHZP6vGPw3K92JJQ7do31QQyal+KUGVEEwbNegCXMaqOy7IRDbwHsmygQWnML86
         nmXFGiCG9DlIoYse7JvPeEbHiCP1EVYgI6KzSse0jXMGuqyq/WcmrOSimCROe5304N3b
         pRz6Tbuej5UhBgVpQ1j+MNLRIKBlHPZNeWjZe1U9eYbOeTl3MoadBOqpsxlcCSkwTH6u
         RRnJDp7E4E9IaYIVqrxFiUlgiT5z1SIJ18T6qm6pNUgg2O1zrM/AepslNRYc4BzRUEK3
         xkMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771996407; x=1772601207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9StylsjjkPu8pnZ8zwuRErmCy8w6JuJLaaJ30WKTm3g=;
        b=qErNF4wAKoevEp967PiqbBMrUX5gAeSCLu513bKluNLS5AQPvrvEchcWlYCqaz85Sq
         HxCiXbyn09tgGTmFPhhuDxUhFt9Tl7gDKHUKgYjeQa2pukH7qsbzaM7bzMhKW10mkgOA
         uQEQ1sF90DSZKIEHqtwspQvqAKe2UDU3XKBdITeJ38gTHX1Kgmo66L23LbJdn6bpNLmh
         pHA9TN0xaVBuJ2wN/8npytqJkWEvhG/hEuTCQdepcW937tpPTfFU9SarJrmwrfObu8hs
         b48eapPKN8CKhgahihhbYHo1kzwHPxqNaTa13W0qPjbV9JxZ0dAAevf/Cre5vWyQpQRM
         TJ/g==
X-Gm-Message-State: AOJu0YwCbt3a/QsyOCs8b90MiCHMADKXlIQLGNI25m6vHs9OBlD8X9TE
	pDSk3zJJlhM5PkUl15Q7q8Ow5vJ6bQKuHaz+uQHwjFYDXzwooYN5xyoJ1Koprq8gFkc=
X-Gm-Gg: ATEYQzyaW2Y60CeavpEB9rSh+qxOQBZV5R4xvG66hSpuw6WvxL2gVv11IgFll8XjaDT
	8RJH0l2M7RApWm/fBCwwCJTiqxBjeGOWmiwmEND8Dqge4x5m4JB2TC0tWIy1G0fm/hdDUdyjEQX
	0o5YwsdlL+Tg/MSz9gQUI/WiKaK32Te7Tj2l+B52jXtDLtrYH7ROtBzwL6FVNP0QAg0kqfg5Ksh
	IYTLcD4gcThqQKARRAlEalg89Mx+PoV8QYAtz8VLdaW/47BW1E4P+RwbiSZWYF9EUlFXCesEKEy
	ZbHU5ZaRDL+I1tVU2vcFK4Gi2hHDrs+aWGnYErvvudlSAQlOothY+LZZ4Q2mMZqH5vUri5lIvlH
	hVE1ys6WM3NK4TiiK435ntaN2pzIk8YoLSry0clK4cST6q6QQeVDPsb6LQWYA2jIYQ1lvi1U7Vn
	r8GmY3Az8TZkm5HvIDGN1wZEmUwQzEyxkwmn/5uCbSdvdJAovZGrEfl00UVANmftdPn4YVUDqZ
X-Received: by 2002:a05:600c:3e8e:b0:47e:e946:3a72 with SMTP id 5b1f17b1804b1-483bef5aac0mr18344565e9.27.1771996407557;
        Tue, 24 Feb 2026 21:13:27 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd702e7bsm48222585e9.5.2026.02.24.21.13.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 24 Feb 2026 21:13:27 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Magnus Kulke <magnus.kulke@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 3/5] accel/mshv: Build without target-specific knowledge
Date: Wed, 25 Feb 2026 06:13:01 +0100
Message-ID: <20260225051303.91614-4-philmd@linaro.org>
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
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71781-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[philmd@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:mid,linaro.org:dkim,linaro.org:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 07F6019203C
X-Rspamd-Action: no action

Code in accel/ aims to be target-agnostic. Enforce that
by moving the MSHV file units to system_ss[], which is
target-agnostic.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/mshv/meson.build | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/accel/mshv/meson.build b/accel/mshv/meson.build
index d3a2b325811..c1b1787c5e6 100644
--- a/accel/mshv/meson.build
+++ b/accel/mshv/meson.build
@@ -1,9 +1,6 @@
-mshv_ss = ss.source_set()
-mshv_ss.add(if_true: files(
+system_ss.add(when: 'CONFIG_MSHV', if_true: files(
   'irq.c',
   'mem.c',
   'msr.c',
   'mshv-all.c'
 ))
-
-specific_ss.add_all(when: 'CONFIG_MSHV', if_true: mshv_ss)
-- 
2.52.0


