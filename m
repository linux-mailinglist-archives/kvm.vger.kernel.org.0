Return-Path: <kvm+bounces-71782-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mP19BfeFnmnRVwQAu9opvQ
	(envelope-from <kvm+bounces-71782-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:17:43 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A4121191E9B
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:17:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 32584309875C
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE0CF2D5410;
	Wed, 25 Feb 2026 05:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XyYY7nJL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC57326A1B9
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 05:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771996418; cv=none; b=qMTPVun75ZxNlhPDr1jbrtMUOSzsHwl8ZgGOYrMBBsWTSW1IsnTpgj/DDqsSmvOxVL+JmhxCAv4Q+pzc1PZAb73zYarAKo3wpqiX1kvQBiJDDB4qj7F5hUBkFppu0l/kWyON+I/voJZUD00oZnbHOt3U/EbBZsf/p6Z2PMjKLpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771996418; c=relaxed/simple;
	bh=FMgfL7q+UCNgApvyJEyBhhP5a4J68OH5VGrHVR5qIBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bxNltl22wOkfeSEdGZtikiwlCqHasZvEWdYIbK0/4q9JlQLCDJTTqWsdVKHFu8lDO/3cnYHEeTiikyC1GkRSojSUhl3GEPhcycwyrQyfGoEa9l7fq5KQ0tKu+EbGt/1gbfj9R9uoEjHYFQV2mGsbSEet4GiHScNwl204WSVo1zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XyYY7nJL; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-4398d9a12c6so474411f8f.2
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 21:13:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771996415; x=1772601215; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Fom4TdZ27OaWdE48V/WCmqpd1vRN9dFVw46MQX66F4=;
        b=XyYY7nJLEPx1OyGvRZSoDtnh8qKy+EJDgXHcBUHhkBBbnMfOXvjJZ9d2N3uybWWZi2
         9MJi51U8QUZ6n6PCRNqUiK8/MckXTZZmq86l/wc25KxELFqjBvzgeVx01FnyJzNQziMM
         wddFW3psF4oDfgUh67eRgyC5k914a5PliaxdV9GxBT9FPL6se5i2feWzlFqeMkwjNrRj
         7uJlvmRwrCxqmuYgP1zMiAJ0QvPSNVbyZpCkYcenYHjZIcIk03e6XPNJ6l7W0oY3ZZAL
         vVbhiwRbTOlbT7xUTsQ1EL3V0/cW0DmRJEHPOTyWSJKb+F/e6rehL0w8Nh1MjuzhBbLu
         Ie2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771996415; x=1772601215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9Fom4TdZ27OaWdE48V/WCmqpd1vRN9dFVw46MQX66F4=;
        b=OEptOEavVayZmYFl3pl9mJkJE8m8wbOQe1TbvcUxagomgdZyqztlEVf1whzmHfC6zd
         vLwLZgeNWhyWLZDNSQauOobQS5UBRV5qRz/XhJFKdujqm1VvqrenX/5+6qjEAXUNr6cc
         Lhb7wTx6HMDZZy+v8+ArDUO//OtQ4oz96/NUeqi4ZdxGetw2CAUV2SSiW8xJ9rOOLTpp
         AsKXKiGwtQccHxVcCLkoEybqU8fYXlvQwoxtN4hHsrvCk4CFhyD44MvcSyS/2BGYzpKb
         A4PJXBzJ1B1j30gT5m6z9aMJfGtXpY+4x7JaXs5nDLKVy8Q3c3lzSdY2ce2OypeLsXui
         Tt6Q==
X-Gm-Message-State: AOJu0Yw5N2ym0949fuUF1oGb8g0QYp18NCRoxkOKQCmQ0vMkRULYOLzZ
	AYpj2ufmikTrzFOqWiZ47bBl+myKFOHSrfrgMQDGjT9iYrmcRSBAYX+tQG/dJAFey+E=
X-Gm-Gg: ATEYQzwBlC66GWzcIEhLNmDY5y1Kg5i9dY/yk3qLWjrBb0omiMZXoTbCjWd6jtAfc0O
	4X6yxe4PUOOfVJWrqDOxH90jxPXhd4+tZhQuPjE7cwpWzNQu+K/45CZNjB0YcSoRHeirzhqgfhG
	WxH83GhoJqz8PHJ70hidrFxEAZybjPU0/5hpD3et/tepDSWl3k2O+Lvg8tuLCakKKIJuvl/K00y
	jZ2UZfiGDWq8T0h0elTf7jkWjxSmWC4bmgwc+SH2ZDQHVy1wOsxpMYqH2IvGmEaXyXzSZBI6vgC
	z/wRiTDeiP/aikBKlNQY8Cj7tSBoY3unYFaJvZohJqFRaB8pkDko9nx8nWdW9gkRI+vmW3733zo
	JFFcml1MoAOHTnqe82l3e1z0dKhnKz4DCVqqzA5a8Vq1RQsAjgkFZFiv2exThU1Z5usWTjo/FZS
	/GdxKmvfdvHEtVijg1Ws25lOSL9dN1/KGDr6Z54loYrvE2EQh1cHSyClhv57b1bicUYo8uDLFN
X-Received: by 2002:a05:6000:2406:b0:436:1872:63d0 with SMTP id ffacd0b85a97d-4396f15ce72mr27807237f8f.2.1771996415096;
        Tue, 24 Feb 2026 21:13:35 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d401aasm30576270f8f.23.2026.02.24.21.13.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 24 Feb 2026 21:13:34 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>
Subject: [PATCH 4/5] accel/hvf: Build without target-specific knowledge
Date: Wed, 25 Feb 2026 06:13:02 +0100
Message-ID: <20260225051303.91614-5-philmd@linaro.org>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71782-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[philmd@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,linaro.org:mid,linaro.org:dkim,linaro.org:email]
X-Rspamd-Queue-Id: A4121191E9B
X-Rspamd-Action: no action

Code in accel/ aims to be target-agnostic. Enforce that
by moving the MSHV file units to system_ss[], which is
target-agnostic.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/hvf/meson.build | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/accel/hvf/meson.build b/accel/hvf/meson.build
index fc52cb78433..6e2dcc4a5f0 100644
--- a/accel/hvf/meson.build
+++ b/accel/hvf/meson.build
@@ -1,7 +1,4 @@
-hvf_ss = ss.source_set()
-hvf_ss.add(files(
+system_ss.add(when: 'CONFIG_HVF', if_true: files(
   'hvf-all.c',
   'hvf-accel-ops.c',
 ))
-
-specific_ss.add_all(when: 'CONFIG_HVF', if_true: hvf_ss)
-- 
2.52.0


