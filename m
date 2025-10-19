Return-Path: <kvm+bounces-60456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83E2ABEEC8F
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 23:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E3313E4715
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 21:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50B69239E61;
	Sun, 19 Oct 2025 21:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iMntY920"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFF5156661
	for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760907816; cv=none; b=ungfZ+zH+yjLnGmvq0deIqUHW/Hp3Cuv6z+Fkvfh9SQMAriMf6nmBAUGwgmBbOX15J+wk/KaK6xKdTj8VefPm+HAo7Zd3awYDdjCnzgObU0M9ClGMNKoEgrdO+Mmvh8W8f1Nvu4NB39jbPW2RqSux+yqCwBTx7+55nmTzRhsJUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760907816; c=relaxed/simple;
	bh=AApBZrW4/cbMt1+Vke4JMf44nirXxFVVoLL6xILURP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfgPzfcup9yEz75CS1a1wVCRMgZ+yicV/3WzdK1uo6KyiOQ6fsNcBfXqzFhTh5/40iVUSGofENqJOeWHND/tLaCEJLC0/DLiVtJyP2rFRaX9PjRmquR6EVNgNTiPLhI+83Ky/umMli7AZN8OTsxIUk6ygWt5CXtnMk7BvjrL1GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iMntY920; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63c09ff13aeso6721137a12.0
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 14:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760907813; x=1761512613; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HtQk0GJuCq/JgD3T73Q/ujEtbCnLstw5lfgjKUjPFqo=;
        b=iMntY9203W38fn93L0GtwzwAMhvwQgpcpfQVQUg+LoKWs/wFwioh0rf3JaAD/jar2o
         VSv2KkohL1rdH4u/jE4Y+Q//HX3NhQetr4qBx9Z4xmvjKqY6TeOIZS5NfoSFOyZCozpQ
         xl59YmM0iCOT6gwMCLkbIcmF6J+FUZZ4WIo5LkW2OCEclLUCQWZk7wKH47j8xotqZsjd
         pebpu8KgdnIP7AA9u4fTMvetfAXskA3eA7Ic3AA/OnqwTHfwe5SJU5LLfDFjP71u4JHZ
         QaDy9FXPxQk5PPYHTPp2ooPbG2Kh24I7FoPVHUuUZBkh8v4CbtYjGPYLxXQo64JOCeZb
         S/8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760907813; x=1761512613;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HtQk0GJuCq/JgD3T73Q/ujEtbCnLstw5lfgjKUjPFqo=;
        b=t6bfE0RXDUHNa66RWnR2gkbWifRlcwzR5usrlUV2moVZ73QH3zIoWeqy3AayZlvk2J
         SI3Vt+8jJ9mQAwAi38YH2BN1BbGPt5MYTe/XdtN5u9Opun3hFHOWTQ1tqoTXhILGDNgL
         Mh6+xLSV4wjo9t0tqaNMqNRh4GsjlYhyK8qQ8Q1m0h4Hr59JCTADcc09/TU0IFYbhXqX
         BAuKWqMqNunpFrsGcY4LimjyAHAKBw8C2EVAaA322GCuifYFNg6WoDHAS4iFLZHNGMOg
         41MM8kzbW2yZdhc3XRExmDLrCNuR+R9ASgw5FiuL2aHFJApGWCrngaLbzzc+4pJHW8au
         twtg==
X-Forwarded-Encrypted: i=1; AJvYcCVtOm24sgBqTQs5qRf71CaPPYpL/iIh3+8S8rMf78YfeT6mV23Tp4O189LlYbvMXRc45a8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWgWY2JQXsxIBbRO/vyYE6eVsr1j9QugaJpJ0+d6xMx3SbCFSw
	efUqZ59253YfwMK7qmoGmB/89Lyeyd7cKd3rP80JNuowQgGF4C/JW3L3
X-Gm-Gg: ASbGncsLB7/9V4OTWUJDeFD1uFoXJcykOuLDCVVMAWjDI+KWKtbwAXtiqTdPouhclAY
	tiiMZxqyP7TOv0lPfbYbtzy5phSVLeY/q6BZUnP5c1sRx5rzPSsEm62jDVFtKYzosHqt+J+nhvR
	U1oTb/IWBumQfuyZqZUKlv+nsUUWEzdENDR/gcbIufVSLFQYLTdRAo2/k+g0bjXcn1U0GjHfV4z
	gFBUIxi3qgBfmXHhHnnZjO0iiVJ8PueETwvS1ZvyZ8cP2rvYTwyOA3Zd9OpjmXRk1bzUPuvHnbG
	+aj6Q/SCgNnselA8LdvUIK8vRCqjk5VxRpMni1Ihnnrz7bRYPWVXsPy4+iEZ06/JKd3F0ZZHFPN
	HGSTmuGr/Q0yMRTaIWuOCCYYin/+T2A/y5Qicqnnfebu5P3r7cKgeVJDFlFS9boEEItvDz3Fl2Q
	DlDbTv+FJBFbpoHB9n9VMXiMbE2mMhgB5lEHtfbgmEZE+7axPUnSLEKDO9VMkq8GxM6CNi
X-Google-Smtp-Source: AGHT+IHY1dRS1/AWHrm1rZJe4vZW5z0gZL042o9tHw8kn9F5IjQFgcfvzYbj4kRdNYLhXWOzFUb3tQ==
X-Received: by 2002:a05:6402:5189:b0:63c:3efe:d970 with SMTP id 4fb4d7f45d1cf-63c3efeee6emr6840546a12.31.1760907813103;
        Sun, 19 Oct 2025 14:03:33 -0700 (PDT)
Received: from archlinux (dynamic-002-245-026-170.2.245.pool.telefonica.de. [2.245.26.170])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c4945f003sm5107655a12.27.2025.10.19.14.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Oct 2025 14:03:32 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Zhao Liu <zhao1.liu@intel.com>,
	kvm@vger.kernel.org,
	Michael Tokarev <mjt@tls.msk.ru>,
	Cameron Esfahani <dirty@apple.com>,
	qemu-block@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-trivial@nongnu.org,
	Laurent Vivier <lvivier@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	John Snow <jsnow@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH v3 04/10] hw/rtc/mc146818rtc: Use ARRAY_SIZE macro
Date: Sun, 19 Oct 2025 23:02:57 +0200
Message-ID: <20251019210303.104718-5-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251019210303.104718-1-shentey@gmail.com>
References: <20251019210303.104718-1-shentey@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Avoids the error-prone repetition of the array size.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 hw/rtc/mc146818rtc.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/hw/rtc/mc146818rtc.c b/hw/rtc/mc146818rtc.c
index 61e9c0bf99..5a89062b4c 100644
--- a/hw/rtc/mc146818rtc.c
+++ b/hw/rtc/mc146818rtc.c
@@ -726,13 +726,14 @@ static uint64_t cmos_ioport_read(void *opaque, hwaddr addr,
 
 void mc146818rtc_set_cmos_data(MC146818RtcState *s, int addr, int val)
 {
-    if (addr >= 0 && addr <= 127)
+    if (addr >= 0 && addr < ARRAY_SIZE(s->cmos_data)) {
         s->cmos_data[addr] = val;
+    }
 }
 
 int mc146818rtc_get_cmos_data(MC146818RtcState *s, int addr)
 {
-    assert(addr >= 0 && addr <= 127);
+    assert(addr >= 0 && addr < ARRAY_SIZE(s->cmos_data));
     return s->cmos_data[addr];
 }
 
-- 
2.51.1.dirty


