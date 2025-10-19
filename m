Return-Path: <kvm+bounces-60457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FF54BEEC8E
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 23:03:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DAD504E74C5
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 21:03:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DCCA239E6C;
	Sun, 19 Oct 2025 21:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C8gLWPvi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38B722129F
	for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760907816; cv=none; b=WL4Ux8CmPUEmvAUJFeZC2XvwtKLviKxcOxAZr/dIBMRzDA4CLDBJFarsjj3JvmXPRAqEuM9v6XaXeR/NuP2a9eys8LrYKDdN0IyCLNeKwdqKB//zf7gdjs+u17YePBGPZZgEv7DW5sUSOu0zQITIvKImlBVbcvREB5Ftvm+a4Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760907816; c=relaxed/simple;
	bh=Z2eGPAoZqy99gdXMSjpslK+AFkoC3DJO4J/cN8nJhFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqPZhKlKXBVD359009jyDs26gUCYGf3Cn+rV9TdVf6ZVhryBYKSahY8zjv++4zXyS9cH+tDhTNRgrRLElK2MCQ969LtvFiVJYsKI0O8/ikqrhub+Jqtjqax7gPh8OJMlzq6f8CEzviifkr/r/Vib4QPodTo5MwsPrsxPzTkLfhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C8gLWPvi; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-63c09141cabso5419326a12.0
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 14:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760907812; x=1761512612; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n8oXWw/dktgNDXuS33Gpiga0QxIzazhu/qxi0riXcZ8=;
        b=C8gLWPvisrE6wz67my+3C4Ohr8xzRqt2B9P3umE6Hz+nd8pUkeetq87fmrG6P2uPdv
         y1oZqA6EJCtqo6nOkmwoyLllovN4G2ymsDvigwPB9gSgW5oV8/h4pY3f8AFrCXJ5LXrA
         EbjqSPmAhwGU7P+D832mUoTKgbyGxpGdHc2l3+OEjud1qWwql96IySEEfEobMuqPuhji
         cms7ywJA5GHbEoaXiiW9BYAXwFBftWtWdo6wPtf9j9J9ie4fgsx6Qx0c+ThjmUMjAuBI
         0+X/jNrxHjBIy131Dn3IO1XC1gxU8A7Os3WX3Al8qwV16IqPUvltqrqp6QMxe6lN4bah
         rJ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760907812; x=1761512612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n8oXWw/dktgNDXuS33Gpiga0QxIzazhu/qxi0riXcZ8=;
        b=POJmebvBGsZoAJufnJOf/l0C7k0upYTismnz75Qk9MTQwKeQPjWWA5qGR0lmz954Sn
         m94QoI16kkG0dJ9BiFHoVIuS0P9hQGE3tUFsrPSviQJYDhMiM3zqpvY/oxPqrBkogEnp
         BuuVB72P/ARLkKunc45pBLWtRjmgXCAg297Q28f7MAsWdwkebScFJtVc9ec3dralUbyj
         Jdq+6hojCUaLk9Z1OuCRt9X9WWor0nqOBtLmPKgQuoA64duD5HTqe0EDi/71zZ9uivX3
         sMMQaflnMDPNB7UQcfc8AoiLHzfDhk5sOZbd85cyNN4SeWTzBXdBN6jsV7v85GlFRBdW
         7X2A==
X-Forwarded-Encrypted: i=1; AJvYcCUwfeM8DNCXarG18ElcOxmlBOChtNuKo1yIzrq6NFsZ00cBKIYE6r98w7RzVo1U7EuX9Ww=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx+SktuaeZH96x53l7jti+JNbOVAkq+g90f94trS5shFXAuQcU
	bJorvDECrxT2sINUYHHxvAo1wr4IZOpF0kyvwKfpuReDLBFYp0VanTjt
X-Gm-Gg: ASbGncu9NL/vDck1mfx0fcMhCCT56VU9UzW1fkFC99g/SMbj1UvvuQUJG2Nrde1arwP
	Cd0k8IoHPm0eY+/7CyZXHYcGp4qioZ8phaEn+mEHbZPxelLyYpe1oVw+qaodNzsGzwZ7ynP1lZx
	FMCH2H59iByD5zuL3gb9TLWzI0jTzVmj00W9uqw0dcXs4Xr+Rw/YuThpDxWgkjzHQct1Q2mN7au
	VBn3RKtjJTAb2patnJo9/U9VY9wK81BykZObkje5fpJ6MPYw80Br80+v6IhpqSskWgWMrxJpkeF
	ARPA/Pkg5MWC4yqTr2Sr0TcZ2k6EEDZd1eOst2Z/Q8h0cYLT3zz+dxYL+d+FbbMzRHUuwDIpENE
	5nSfUxjpKql+e1+A6hiQVZnfKpJc73VTzgJaMWsqANl9p7QunXxAAtGkCXyZ9z4gwCsIv2HBDzU
	7TCs0URlZsUJRyKRf4Au1MLdJnVdidTH96u2yfzEaI2GXNcD84w6sGVaFWhfz4sV4xfWSL1C2vd
	6/GJjU=
X-Google-Smtp-Source: AGHT+IH6NwbtkR9KVaWZMruOH8E87GbFPMByc6ZZlCT4WKF8R8KBz5UNoPmnk9epw2Cnyh1bEEgmwg==
X-Received: by 2002:a05:6402:5247:b0:63c:4d42:9928 with SMTP id 4fb4d7f45d1cf-63c4d429ba7mr5372081a12.7.1760907811673;
        Sun, 19 Oct 2025 14:03:31 -0700 (PDT)
Received: from archlinux (dynamic-002-245-026-170.2.245.pool.telefonica.de. [2.245.26.170])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c4945f003sm5107655a12.27.2025.10.19.14.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Oct 2025 14:03:30 -0700 (PDT)
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
Subject: [PATCH v3 03/10] hw/rtc/mc146818rtc: Convert CMOS_DPRINTF() into trace events
Date: Sun, 19 Oct 2025 23:02:56 +0200
Message-ID: <20251019210303.104718-4-shentey@gmail.com>
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

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 hw/rtc/mc146818rtc.c | 14 +++-----------
 hw/rtc/trace-events  |  4 ++++
 2 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/hw/rtc/mc146818rtc.c b/hw/rtc/mc146818rtc.c
index f9f5cf396f..61e9c0bf99 100644
--- a/hw/rtc/mc146818rtc.c
+++ b/hw/rtc/mc146818rtc.c
@@ -43,16 +43,10 @@
 #include "qapi/error.h"
 #include "qapi/qapi-events-misc.h"
 #include "qapi/visitor.h"
+#include "trace.h"
 
-//#define DEBUG_CMOS
 //#define DEBUG_COALESCED
 
-#ifdef DEBUG_CMOS
-# define CMOS_DPRINTF(format, ...)      printf(format, ## __VA_ARGS__)
-#else
-# define CMOS_DPRINTF(format, ...)      do { } while (0)
-#endif
-
 #ifdef DEBUG_COALESCED
 # define DPRINTF_C(format, ...)      printf(format, ## __VA_ARGS__)
 #else
@@ -439,8 +433,7 @@ static void cmos_ioport_write(void *opaque, hwaddr addr,
     if ((addr & 1) == 0) {
         s->cmos_index = data & 0x7f;
     } else {
-        CMOS_DPRINTF("cmos: write index=0x%02x val=0x%02" PRIx64 "\n",
-                     s->cmos_index, data);
+        trace_mc146818_rtc_ioport_write(s->cmos_index, data);
         switch(s->cmos_index) {
         case RTC_SECONDS_ALARM:
         case RTC_MINUTES_ALARM:
@@ -726,8 +719,7 @@ static uint64_t cmos_ioport_read(void *opaque, hwaddr addr,
             ret = s->cmos_data[s->cmos_index];
             break;
         }
-        CMOS_DPRINTF("cmos: read index=0x%02x val=0x%02x\n",
-                     s->cmos_index, ret);
+        trace_mc146818_rtc_ioport_read(s->cmos_index, ret);
         return ret;
     }
 }
diff --git a/hw/rtc/trace-events b/hw/rtc/trace-events
index b9f2852d35..d2f36217cb 100644
--- a/hw/rtc/trace-events
+++ b/hw/rtc/trace-events
@@ -32,6 +32,10 @@ m48txx_nvram_io_write(uint64_t addr, uint64_t value) "io write addr:0x%04" PRIx6
 m48txx_nvram_mem_read(uint32_t addr, uint32_t value) "mem read addr:0x%04x value:0x%02x"
 m48txx_nvram_mem_write(uint32_t addr, uint32_t value) "mem write addr:0x%04x value:0x%02x"
 
+# mc146818rtc.c
+mc146818_rtc_ioport_read(uint8_t addr, uint8_t value) "[0x%02" PRIx8 "] -> 0x%02" PRIx8
+mc146818_rtc_ioport_write(uint8_t addr, uint8_t value) "[0x%02" PRIx8 "] <- 0x%02" PRIx8
+
 # goldfish_rtc.c
 goldfish_rtc_read(uint64_t addr, uint64_t value) "addr 0x%02" PRIx64 " value 0x%08" PRIx64
 goldfish_rtc_write(uint64_t addr, uint64_t value) "addr 0x%02" PRIx64 " value 0x%08" PRIx64
-- 
2.51.1.dirty


