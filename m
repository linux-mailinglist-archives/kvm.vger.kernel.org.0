Return-Path: <kvm+bounces-60319-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F47BBE91C9
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:13:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48C9C620A1E
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 14:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3787436CE1A;
	Fri, 17 Oct 2025 14:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="molW8CZ4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A488D36CDF4
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 14:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760710371; cv=none; b=mAmJUBecGhxl8DhNk3VvbQhJ74c9V3v2+ZGLjJ2doNZidq9EdyJUVH8X8PpRToeXBP6rPd7RRGprbirZ8jYqEBf4KdFKr510mbvTxzixQBI6jEpgYAGss1KWHqVQv79CMLZNmS7/R+c11Z1LG+Z5Jy3uHm/XMC9qdarMdeKKVEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760710371; c=relaxed/simple;
	bh=Z2eGPAoZqy99gdXMSjpslK+AFkoC3DJO4J/cN8nJhFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DvGZLx9nODDkXbqwDXMvAyiC/G02SfDJTSgLK7IRoWDVlWi13vpFV5ZbNryQRxjQUI2GykEGQ3yhUlWzXT7jjcSL7HZe47UIoXmkuF78Uf4k6aAsRIQCq/HDB7qofFgpFlAnfXAb6IE5Iat2CFz6Mloe0UBj5TjbXXuHuY/nSiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=molW8CZ4; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47114a40161so19688565e9.3
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 07:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760710368; x=1761315168; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n8oXWw/dktgNDXuS33Gpiga0QxIzazhu/qxi0riXcZ8=;
        b=molW8CZ45rYPgfvQ5zrCqoOTPdfLaDnyPccz50tt0JDYiU48sNaSjGUKq/VmfA0Djz
         tRoVpRBdmrQ80J61YdhdlynksMOzybnIOUcazCD4qqAvZwqEUnxupUwr0Sp5WYff/Gab
         uMErVmM4jVDaCzKOKfr38HsiWtY+GSoG4NU7PhmkPVHw5nLPjBIV0oOkvWp0D89Ia7F8
         gLr5DaWGkyMydA9hamMZLSx7RebeTKqYKO1xV2XXzrUgRX+GqrMl5OjI4lP/35AXkVTx
         0bTk94dIc1o55JgJA3txAVoyfNPUg60DfHuY0Deu1opqH+enZE/56gGMr2ggfvNsuOqA
         dtZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760710368; x=1761315168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n8oXWw/dktgNDXuS33Gpiga0QxIzazhu/qxi0riXcZ8=;
        b=SrlJnXTjUmjv+XwSsM1egnUbSEaB77RTJb0/J6hd0l31rFPhY2/Lo8XLMMnF/u9+mf
         3JcZv7Z957oZ5he3f+56LlKR15tH3nDq4PMTnu7ccQMohhCnz1HQb70eCFH0Gwz/wnPu
         XHfJE7ZVLyINp1bXLFhxztFAPD2LrA33iUo3Vsid9PYIZhNmGtK8ZFhaXDUrzNn8LiQM
         VBDR3VurzyV1K4YP5/1x9eNoO2TW+h4vDTDkTWFc98s62ncEOL6FDtz4Y7N/aDGz+RhZ
         SNXHAlVv0aa9na/ahMH0NRImjc6X5WLzSbT57SY/CQumY9HJSiqljkuCm61r66JXnYDR
         aJ3Q==
X-Forwarded-Encrypted: i=1; AJvYcCUOvkomSpv95QtjgPjJ4vQG1Zm8F7CA3C/ucKTpQLUATXAaijMsp+88ll5PLid3VqDOwTY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7WmSnIOY764EolC+rxl1TrBhWWpESNwbUjPGq2ziaSiia5bLz
	7ZjyjfF7L2z2m68TFw4PHkeOezq04gWrWVN+TPIn4hXHhl7wWszW+r6f
X-Gm-Gg: ASbGncs9M+fVFog84N61HQImBI7atvzKbjHJKqAcf8KG4VF9RCxlhKKbyCbyqH0yTpF
	sKgNC8FRuz0jeGlu3YWbjf4zKhytZD01dX3FLrcp+XD9OZQKkU6+9DE+eJuxhAVgaGBP694h1dS
	Q3DHcUnlISvSGoqHpeIQD8EQ0TDYz5Z9x0TO0JwzbGSS+Y9LqBvU8QPDAeh9FXX8SGuAG6MJto5
	nNXEyDMO7epAEEtKHAMQcK2foUKdbIYLAkDubcuXCNZg29UKzEVw0tMRTXU9vFZ1QmZgiZ+eTVX
	Mz4MTGUaABTo7Hr48xeVXhN71YiY6TSBeQ2fruHJacV7vjEXsU0+HgUZ1JToGuCFHFRwLonzInH
	6Gnx8pyn1FyPhF9mpXKG1aaQRVtVEdPkgWqoPeNZ5z22K0JqlgBlE2oNfYXq4HsUtbX5rfi7HbV
	t2YRvdDitDxKueJ30kXVdyK6twWsmhHm2aCEZ9jdwLdEg=
X-Google-Smtp-Source: AGHT+IGhiyzkzAr+6r0KBtkLRDLs2tlXhqCkwBqEUxcf5/lWQeWBHbLeSI13oIDWMKk0dtvqeisVSw==
X-Received: by 2002:a05:600c:3488:b0:459:e398:ed89 with SMTP id 5b1f17b1804b1-4711786c586mr30171665e9.1.1760710367930;
        Fri, 17 Oct 2025 07:12:47 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710cb36e7csm51359675e9.2.2025.10.17.07.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 07:12:47 -0700 (PDT)
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
Subject: [PATCH v2 03/11] hw/rtc/mc146818rtc: Convert CMOS_DPRINTF() into trace events
Date: Fri, 17 Oct 2025 16:11:09 +0200
Message-ID: <20251017141117.105944-4-shentey@gmail.com>
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


