Return-Path: <kvm+bounces-60303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B927BE86B5
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 13:39:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9939C5E109B
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:38:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4836332EB6;
	Fri, 17 Oct 2025 11:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JJWLDIdl"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 021D7280331
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 11:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760700843; cv=none; b=tA/hn56re7K4cIcbugliAJ1byCMOGVGEEoccRa6mZhGPbVh7+3QR8ef1ndeKR5LXHCHzfJPPXRRmbKk0AwJedg1Zhk8mPHYkaVeBdH6Car4UUqvSPhRsB0mBqPhCQvdWK5Xf8GF25MN4pUnnqdziUXWa4vMqemd1881aUIQaB0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760700843; c=relaxed/simple;
	bh=Z2eGPAoZqy99gdXMSjpslK+AFkoC3DJO4J/cN8nJhFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwH8/pbFGb39ETHy+uYbuuXNLNCuLJ2GNdaXJkkPlh4f/lx6Du2CinMyWDxQDlSt0/mraAhsKJce2U13p/ptCh9fUDTNrhL32G8rbEMvV4Hk6jBDe7GXLZLg/Nee3InrrGXFqzut5+HSUxp99m8qAJ1EJj+4FtRBep6C+fdE4d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JJWLDIdl; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-471193a9d9eso8510955e9.2
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 04:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760700840; x=1761305640; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n8oXWw/dktgNDXuS33Gpiga0QxIzazhu/qxi0riXcZ8=;
        b=JJWLDIdlbHiAGz0JaIjZnJ8kUd9SirrLCGSlxAPrJ6n6TB1AVB/LPzXXlV2rJaCDQF
         5HkGl081SEda4oomS1xnoY6xP2KHe2RXy9ldIKX/p38qwyT2HKSb5oeADEsOXdi3qJjF
         Vf5i2OeX98FYVN4f6MLR3pewl5965x33ZCtMOhXkhojk6pNm3CJQEX510w785ARgM+cZ
         GckrG3dKezPMdY45nnd5bjDJWQOHsb+hI1GhfvBaPu6ZHKvv58OWQvQhpdusM8/VpTMt
         fD9+UwaKLooj61wfDxeqTXlJInX0qb9f2+XofzXL9xsE4PKW5zKLma8mthbKVO0OxLe4
         fZ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760700840; x=1761305640;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n8oXWw/dktgNDXuS33Gpiga0QxIzazhu/qxi0riXcZ8=;
        b=jfdnFglUg+JvQ8tefe+TCFHKiqIDN8e/Yw73RDYAAPIyoAKhgp1+6fdRiv2gbQtvyd
         Rho66YZrzWneYePZDCHTHHVaflT4Qjxsy00ReOjUrMjEPA/LMTvxd5KSeIqpEE3GnwlS
         40gKc71sOK2b7bCkl1CeSDYoq5UzD9VaPNU5f23hzFE681XHign19BoqFFCW7dLV+hNC
         rmUeqy7699Bye7ExTSYgQw+es4jAWT3KiWMoaJSVeEAZV0ohaQ6wBT0wkkerIyhVHamG
         1vuJedQIaY2743Lt1lQt/evtI/6uz6VbJzqMpgPSBzEBClwmztskVQy06vg1dp4BxevJ
         aZqA==
X-Forwarded-Encrypted: i=1; AJvYcCWDP39DMzIXKhMtOItVLH8V0U2JEZLTlWrjzZVTwoie09I0pJvpBkGZtVFBp3fw84qqS50=@vger.kernel.org
X-Gm-Message-State: AOJu0YxtyScAc6oDm3DoSYo6bz5jtgR5XTxF/tlm9k7rqHd8iwHIJ25z
	SwwkFTlIjmvjZQ5XM8r6S1yA2HkNpHJOrL4rhwZEThnLXQnL06dKVxie
X-Gm-Gg: ASbGncvUEcpI38xVA8MINMUEOI8LyAuQMFaqAt4Mj4uPqn98/jVy4N/e8MG4F8o4iZC
	kdPAPTf3AgjOQIifG/g8Ylhtb2tIJeR59doW10TAOZvUGkT2Z6xWZOH1Fs+zx+4Fcxr0DXZIKAQ
	QPH1CIDxSULcGwzQ3E551xEDB7K6C9H7KYO7r3b0sGfbJqF1o67o2XuUKLRd+dRZKtPzw+a3fuS
	KjqftQU1dUFCufABlUbv2w5ckIhIMtEf2vg/1vEFRqoKwBWv5OylwM6cmrMa6+6hNSe3Y2v8Y9J
	I13R7Y2AXKgKAojOwntVprU74/Q8RlJPQRASx/IQNCA01VFs32GdWd0DQb+7Z4P/HeCEKxrBYkf
	FTRz1+1FchnZ5f30c9VpH09ZdJd8V33wBylHknwyzN1Oee/kaTALT4Qczek7zK2RRzsCqvbflxO
	vfe643je44a4aWR04QTkoKCfQrSEA+HjHcS8tu6dLg3HQ=
X-Google-Smtp-Source: AGHT+IHChLP+fEi3IjSJ8xuUf0OcbY0gfQ2DOrnMB0thW11DyqUS6nTY7XHhnqI2um9SOjKmvUz9UQ==
X-Received: by 2002:a05:600c:4ec6:b0:46f:b327:ecfb with SMTP id 5b1f17b1804b1-4711787bfe8mr25755445e9.9.1760700840070;
        Fri, 17 Oct 2025 04:34:00 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711444c8adsm80395435e9.13.2025.10.17.04.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 04:33:59 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Laurent Vivier <lvivier@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	John Snow <jsnow@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <laurent@vivier.eu>,
	kvm@vger.kernel.org,
	Zhao Liu <zhao1.liu@intel.com>,
	qemu-trivial@nongnu.org,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Michael Tokarev <mjt@tls.msk.ru>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-block@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH 3/8] hw/rtc/mc146818rtc: Convert CMOS_DPRINTF() into trace events
Date: Fri, 17 Oct 2025 13:33:33 +0200
Message-ID: <20251017113338.7953-4-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251017113338.7953-1-shentey@gmail.com>
References: <20251017113338.7953-1-shentey@gmail.com>
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


