Return-Path: <kvm+bounces-60458-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 840D9BEEC9A
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 23:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 050703E4944
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 21:03:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D828523A9B0;
	Sun, 19 Oct 2025 21:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iC8fW7a3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A93122B5A3
	for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760907818; cv=none; b=pOnpZB2hZ74eaol3k1EaKApbDVxsTw4JGuvlF6NYkvSg52DQjX1IdTLcZI3yclXollZ6tX9VsRd7pKR/gLx403KSRSBjaaIEglGcYi3M1s2WfzWpoOO6CrKI3Y5XqBXY4Jg0Gci26j8X2JFavjbwZ8THATlFkYVevjYmOG0VJYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760907818; c=relaxed/simple;
	bh=IYKz6FzNw9Zm+ebVMpftVMfze2A0oxz+bYsYGv0M3ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCP020r6sp9C+7zqcjsOM7LTyIzfr9arB5yGZ81/Q3/vRipfDpLcuWuqHS2KlvYV6F2jS0wbG8TYEzdFNa1IjJUV+h6xeTN4Zj9wVgWmYssy9et1SC+tMkd7/3DQxw/2aKBpVip16v/gyzGWzTicyGNrlC6VjV0UXrczKt2+qFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iC8fW7a3; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b50645ecfbbso736176066b.1
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 14:03:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760907815; x=1761512615; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WqDslS9NKjHnUWYR3Oq3CSi9/FfiBOz9NHEnZxcZS80=;
        b=iC8fW7a3a2sMGgeSpK3HzU560kEcbPF8NzDUSOKBkw1scf9FzELP+Aqi+FS8IjV2zB
         Sqwozj5qwl0qAZpg+d6y1RpAE75nTD8Eub/7/1tgsaz5lzlVZEFpsGP5argx0gZyGWWa
         48tHZ+LIpW6YX+2Ib+hGJxQ4SOQs4y9DX3Xg0nUILEr/SBEcsL4FqEdF0fNHAjMlu0yj
         cmnYHZXlp/KFaI0GHfuISucysluE5VFXQ9IUxiDU+esNuIrPHhBDh8lUPyEFT3CUATLo
         Z3MPSiPFgpoGe3ggXsQqYUBtGLQKQ6eu2478hiE/uz35MbPrigU3DPyNH8GzrdfSgVJ7
         ck4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760907815; x=1761512615;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WqDslS9NKjHnUWYR3Oq3CSi9/FfiBOz9NHEnZxcZS80=;
        b=WFTom2U/TfQABw3IuXtXzkuoDbMNZ5iWLaMU3nsc/zw+Lrz3njVGIl755xrpzfqnSd
         WnMbGAT+YdF+OW4gxCmfPXt/owOXxIiJioMVT9l1VGtAzFQq+4tjBetMYbD07rl0aAk2
         Hp7MZl8wGBmkT2THyeoy4+ThRVwl7aI/SRxTnUVGj3kgAoeDM/e8cE1G2/0sjLyvOvjR
         kaxsBg4IOqpk1FWUPF/OLx2f+87Xq0CMMwReiWXX2fjeLYFRj/KxOHK1zaCyF7B8S4ux
         q9e88q/I1VKK4Nx7usfDu9ONMtxhBz9+5J1WVUj09RyXksEzkBh9JH0vd9mvK6bTutJl
         bIsQ==
X-Forwarded-Encrypted: i=1; AJvYcCWUU9J0AORL/e7F7GcEdbbj6ZQ4ItqWAuJn5u0SjNKvlsckQ8dh8nGr78Ybn1hokX46FGc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYIjNNLEGp6mSpYHTrhi1qVFyVYJRKpNCZrOLmut5YJGog6xaJ
	QnHDNRhPGjxZvWTViVEAGFlpQ0a32leAmVeQ1VRac62kpIaB1swNFswG
X-Gm-Gg: ASbGncsVUbUm5pmYAwXNz6nL6nydpgXOY/6JaGenaIBa7y79/ZRZwgQ0Og0NeZ2wWTd
	h1LlHqiW2AD7VGWsz+wtyZ67O6wwGiNqI7Fn9VYuP+P7jfzoXguGTZrE7h3UJGJTQL6XpOv7C/Z
	dvFCEbDRXxlDddE7koUinGAmALq3qFjUWQ9oUYyXwudB7GolfRQa2gCCDRStkwxZjF524EGP/lp
	dayFvmQkhS/RLaA9YYJBikgjhCD9jV5Is1Muif/DZMknX65W8H4PlGTmVB9tj6Mt82C9QYQEbnZ
	ox+KSAGkMcOuJts1wrpQzb4iFMQ/llaF2vJM5JyMwkIDuLl0ou16Eqd2tivfqiCK0eWoHG00dee
	mWIUdf2qJEmU8KVqROVlgQqBeJ1ZKFzOEHKLPsIu327vf01+lzZc5uyH1XlBmjvFJMA4jBoNhoy
	P/KDeypnmrram74wB4RZexkzL1RMmENPaT969WLFMoi2sRDexRgBJ51vhiw+4OWngd34vK
X-Google-Smtp-Source: AGHT+IGPfPy34v/udZLQXvm5jDIXrAZ61l/oD9nGQpnV8TbdI46dqjRmVUAcVk/yLDzjHgyLvbFqIQ==
X-Received: by 2002:a17:907:728c:b0:b57:5353:1032 with SMTP id a640c23a62f3a-b6472b5fab6mr1140469866b.5.1760907814623;
        Sun, 19 Oct 2025 14:03:34 -0700 (PDT)
Received: from archlinux (dynamic-002-245-026-170.2.245.pool.telefonica.de. [2.245.26.170])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c4945f003sm5107655a12.27.2025.10.19.14.03.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Oct 2025 14:03:34 -0700 (PDT)
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
Subject: [PATCH v3 05/10] hw/rtc/mc146818rtc: Assert correct usage of mc146818rtc_set_cmos_data()
Date: Sun, 19 Oct 2025 23:02:58 +0200
Message-ID: <20251019210303.104718-6-shentey@gmail.com>
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

The offset is never controlled by the guest, so any misuse constitutes a
programming error and shouldn't be silently ignored. Fix this by using assert().

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 hw/rtc/mc146818rtc.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/hw/rtc/mc146818rtc.c b/hw/rtc/mc146818rtc.c
index 5a89062b4c..8631386b9f 100644
--- a/hw/rtc/mc146818rtc.c
+++ b/hw/rtc/mc146818rtc.c
@@ -726,9 +726,8 @@ static uint64_t cmos_ioport_read(void *opaque, hwaddr addr,
 
 void mc146818rtc_set_cmos_data(MC146818RtcState *s, int addr, int val)
 {
-    if (addr >= 0 && addr < ARRAY_SIZE(s->cmos_data)) {
-        s->cmos_data[addr] = val;
-    }
+    assert(addr >= 0 && addr < ARRAY_SIZE(s->cmos_data));
+    s->cmos_data[addr] = val;
 }
 
 int mc146818rtc_get_cmos_data(MC146818RtcState *s, int addr)
-- 
2.51.1.dirty


