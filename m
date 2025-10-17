Return-Path: <kvm+bounces-60320-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4493FBE91D5
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:13:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 4EB494FEB07
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 14:13:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51634393DCF;
	Fri, 17 Oct 2025 14:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ppy/ypg3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D625B332EDB
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 14:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760710372; cv=none; b=O2iMyqgzOMl/Gjns2XK1LJQEKB86F8ljlkQcwoS1tr9BKXocOM5vEoVLTDcCRWN41mlYW27UCEGqBTh9SduECrEa+kaA3wYy9Zb6O2b1AJwLQxZQAZIL7Q7C8Nab3XpdaAnEIMXN2VrLUgJ11yF+eSpWskOArBZZto9W/3uG6ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760710372; c=relaxed/simple;
	bh=AApBZrW4/cbMt1+Vke4JMf44nirXxFVVoLL6xILURP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PkD+PfJFPyobTkV6WMhtYA/8O30uw9imTsrFi0+0pdi5CSCjsT2R7NgcuUZtB8lyWAaK9NQZWwmgMHO0BZboJ5dEUlveNL+yaYrtd4NPyuQUaGJBXp6Mswtg3qF4Cxp8xxM8DpMq3J+Xf6ooSPvwIiVBQNhZEDRfNmV4YbIsm+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ppy/ypg3; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47118259fd8so6875435e9.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 07:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760710369; x=1761315169; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HtQk0GJuCq/JgD3T73Q/ujEtbCnLstw5lfgjKUjPFqo=;
        b=Ppy/ypg3QhUMgFXKaGU9Of2tgnhYUf1BLUdJ76VplnF4XqI/z4Dt4pjp0AP2x7iLuk
         RLPb+oprHFMth1maanvE3hwxPll/UM/lanzcprdPiSy2qfN1rH+818SJjPvGD1Fzakv+
         KPBgtSyZPNu2UgQfYcdHAMSNJvykIixT2volu5IMDPpMjIVYhwoKERYKdrsa1K16tHEi
         ProAUN9quJQoAmrB7tlgPt1Zc4CA5eQdxro1N/E+49Er2ox6hX9MIWY2L8ZehN847fb0
         s7vkU+Gk9I4Xvg+T9XJoIk4W9xH6NVTYwgLFIQa+pI7gQfeXk2wL3gmX8XBcAjLY6Iom
         8zFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760710369; x=1761315169;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HtQk0GJuCq/JgD3T73Q/ujEtbCnLstw5lfgjKUjPFqo=;
        b=vnAlUc7nKecI2faC0V+hp652PNG6W2W7Cty4YCNU/C8rpYYQ9mkcHBQ/rLIjb9MhGF
         Ybb2hs0kIryBADHwEHL204xtzOAlThsafYXffMzwGvFjagdwlqe8VhiBcoRmnjocKgiY
         VpObIqKl0ZQdY6/xpQqWVo38vcqBDn5ayD7Q1VjWAE+Fpy1srJUxu+vj9P7ImLXLFIl5
         /BG2yK9eoVNIkxW6QnPMTwQgsfIIzCgN25Y4AFGBrrcgqhiTpk9lz/4jeqeBa9BszTSw
         kq8t2iwQeWruxeNgmBsD1boTY1NqWgBboqIDfDFrDjyoXn3wBxCzcVhZdujO2aSs5Zxv
         +YIg==
X-Forwarded-Encrypted: i=1; AJvYcCU6V8dQ8GYY1DEDcV93PzaXRU4fRUmbpflZO9CfEEjuPETDCUrpUBHUnhN3rgpWiYcKhYA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZTbHzsJSIthu472DOFIuTACM9mxUoD8CfY7qiFLuI8ZV1wrQA
	JBP+Ce65XvH4SMJkA63HlrPjxS8ZoEE49BlznBvZfxfnxl9Y4kqO01nI
X-Gm-Gg: ASbGnctoepsikbLxnvnnKFLOvZ5OmJhsjhToH7eR+yl9cvAaoooIaTTgMbYTlCwFvq5
	P9SooIX4X0FnCRctcCX+HIhySw1GVdHMwTFO6KxSTCNgYcszYzehXNiy4Z8LFKK61eD3/8l6ike
	8aUhqpMjj7kMvBbAaymoRnHMjTbvckxt3H18wddH/8DT03J2PTcQTewIyM6x37b6XHSmmFuUbBl
	cs8g2vAv+UKXzfvNnr3AJ/8b870GstSKidGYykQRWBPnaVPgp7df/B1MqQRRttTfzT5/9zQs3fh
	6AkmeQ5QnDFs5iisOGeQkIQ1WvglrCz8mvPUfCPeGg8xlctd9A/ft3PujW2frP/xzsmqmEBA379
	ERs37+FZ7BZXthGhHpk+dlz/DmA+kOiZ5BTkjm+Iw4y1F9NPyC1pEIuMuSovuE+mt3VlfWwQM/u
	waALTOu0whLi2go7KEB88BtnJ5Sw1MJpAH926r9GoBdFI=
X-Google-Smtp-Source: AGHT+IElsIb/+OVACplDy763YqEHBwFhKZ/w/iY2OrFjr2q46IPQug3eVaWvEqAmJxYiR/ktjpqWEQ==
X-Received: by 2002:a05:600c:3e8f:b0:46f:a95d:e9e7 with SMTP id 5b1f17b1804b1-471177ab11dmr32479285e9.0.1760710369052;
        Fri, 17 Oct 2025 07:12:49 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710cb36e7csm51359675e9.2.2025.10.17.07.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 07:12:48 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Roman Bolshakov <rbolshakov@ddn.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Eduardo Habkost <eduardo@habkost.net>,
	Cameron Esfahani <dirty@apple.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-trivial@nongnu.org,
	Gerd Hoffmann <kraxel@redhat.com>,
	qemu-block@nongnu.org,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Michael Tokarev <mjt@tls.msk.ru>,
	John Snow <jsnow@redhat.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH v2 04/11] hw/rtc/mc146818rtc: Use ARRAY_SIZE macro
Date: Fri, 17 Oct 2025 16:11:10 +0200
Message-ID: <20251017141117.105944-5-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251017141117.105944-1-shentey@gmail.com>
References: <20251017141117.105944-1-shentey@gmail.com>
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


