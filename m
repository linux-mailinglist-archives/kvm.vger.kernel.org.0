Return-Path: <kvm+bounces-60455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA1A3BEEC8B
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 23:03:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73DB33E460E
	for <lists+kvm@lfdr.de>; Sun, 19 Oct 2025 21:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8480D238C1A;
	Sun, 19 Oct 2025 21:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nRCz5K+P"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0064F156661
	for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 21:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760907812; cv=none; b=DNjKRE03FgK6d+9BQCrp5hgWIDJWrxDcGckL+JJwVhNxxIB/7ZB2gR9V3JByWgoMYzZKj1GZInQpLh5wMV9B845xgr63dw8Tqw03/bQOS5Qk77Y4UbwWeLzKC4F7ofS9+hYPynj9udVU+2T1ACGr43aomZ2Q80EY3zDR+h6sZ+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760907812; c=relaxed/simple;
	bh=urUGjh+zmzKrus48UzWrAAEygWKSORrP1adlA+qumHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8oEHWjz9drP5Z3UX7nR0J+xag+qdQpsi45sBM1pQoeI+LhW0bZIDoHR8xiS7zDst214OY/98l2o2DINH5q3bL4WzOXMuIvewjdi2fHQw9uSzCn/c+6FFl+v7D1vDldpO39xAY5ZlogVIvQa4awtH7ellf36abvvM+f253Bnkw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nRCz5K+P; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-63c12ff0c5eso7265584a12.0
        for <kvm@vger.kernel.org>; Sun, 19 Oct 2025 14:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760907809; x=1761512609; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYtLEyH2FfideJwdnFZ4JM8eULzVedauT+XtbsfYWyM=;
        b=nRCz5K+Pqa+ZErAncGZ8n97wy8p5K/+BS7q84BZQjQzkRMDfo6M4RGwJvcojuywmx+
         EpKc+ipk4+UwyHvNo1O6HB47rdcjUqJuNpB7avjBM3nlbG2cTwk+IANCOznM6ZWAOfKn
         QFumjRR3gU6NpF2Rxdfp0ELvljCAJQPW+Ht3oAiUqhH8DkuLu9nX66wAMCxqPc51/EZJ
         ifrr0kTYfz2K6LaZlLW4WcYRaL80q9d10KrwHG4ysTXIvzweSoKfP9ubKWw+k/2Kfmdw
         aqr8vP08ivwnFdDrHIn3LoMWuyrm/pKmA70BxVEe/X2oO1ukxLHOTQrFgy61PWab83u1
         +POA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760907809; x=1761512609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NYtLEyH2FfideJwdnFZ4JM8eULzVedauT+XtbsfYWyM=;
        b=OzBgBdJTXkVJ3pX3M9WQhMHKFTAIwAcyb8Y+ovx8Z5WB0vrIEzz9+K3YKBFh2rO1vn
         z7owXL40UI7lLXBfsJEx+kDRxsGZAn0Wd7MJnptnjU7nl8ly0pudlcWf8SqJoC09KUwm
         JQIaTcMDieKw6oFhGQ9xsrNPi3VchGf+wnbz+ktxcMpxfUXvlQM0g+gD+oxyjPMjheze
         /wWYlIzUSLe+qTfv5LIwH5SrBZZboj5ULWno4f0erYQSU1FoZywTDIgdOQMysoTRVjak
         LY+IY15dx+wyd12yBD1ZJN3mbA78NWkVfCDN3sUOLxYn+ybDNxUU3FchUAESyouSp2A9
         v4fA==
X-Forwarded-Encrypted: i=1; AJvYcCUWN4hwPgJgbReGAi887wtx2a45b5Us6SzupPadgsWaERcYD5XpQaa2kEel/UDfbqDl3iQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzKyy/ZnRpE4AVpbCrbwIHjnUyXqkNvjfF5FBOBfcRqOmpCLzN8
	LO8nE08FUaBgeBDzHAIyTAShL3rqNk1prQhkDBHgQCXGirjCz3rKznNc
X-Gm-Gg: ASbGncudwuyP8GepZyk2GzG98WC0+iVOYNwzwlnxFD34Ql4mc0UVR5Ijv0zPBLqkBZ3
	eCBC6ZPsYCyj5ywuzi2/6JPGXBt2dFArU3f0mhG6Z9iLZPqbhShc31YpipZSFECk1W+/svQwrcW
	W0FGwnXqFPj+x0mN9f2vYMPLw+siQWKBCj8x8AyPr/exp1te5nU+n+/hoLiOTAUXqjaq5nWpXTG
	KlrSzmYJJNUSwqknFW/HIcacf31CU8bx4dYJ70oA2pbzacneypkjIPWPYMZSZ36Ch+YS3tG+QaN
	g4DtVwWMG/E1q87pOGRhWDuMn/fLJWLTYRZERRoaOb2ob8FeL6oEq1T4YxySyfKHO1zSVPA4Wwc
	WT5yw8RaoYlX9outEb4DNV3Z033sukmGUUJKuftHqEAlaUuRmetPNZZ+SElMmLZe3RvsKlYvxn8
	zShgzinRYDfxZQwNRNRtdIW/7QNwXxVaZUijw93Ke9G+s2jAT5D2oUEKXzag==
X-Google-Smtp-Source: AGHT+IGYnIE2LGluxdoaFLFcoZghgUMjydsnhpN1IFNQiDdS64MjZIRWB4CUyErfVctu0dYes/zOGQ==
X-Received: by 2002:aa7:d1c4:0:b0:633:14bb:dcb1 with SMTP id 4fb4d7f45d1cf-63bfde71dc3mr10725278a12.11.1760907809154;
        Sun, 19 Oct 2025 14:03:29 -0700 (PDT)
Received: from archlinux (dynamic-002-245-026-170.2.245.pool.telefonica.de. [2.245.26.170])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63c4945f003sm5107655a12.27.2025.10.19.14.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Oct 2025 14:03:28 -0700 (PDT)
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
Subject: [PATCH v3 02/10] hw/audio/pcspk: Add I/O trace events
Date: Sun, 19 Oct 2025 23:02:55 +0200
Message-ID: <20251019210303.104718-3-shentey@gmail.com>
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

Allows to see how the guest interacts with the device.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 hw/audio/pcspk.c      | 10 +++++++++-
 hw/audio/trace-events |  4 ++++
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/hw/audio/pcspk.c b/hw/audio/pcspk.c
index a419161b5b..f8020593b0 100644
--- a/hw/audio/pcspk.c
+++ b/hw/audio/pcspk.c
@@ -34,6 +34,7 @@
 #include "hw/audio/pcspk.h"
 #include "qapi/error.h"
 #include "qom/object.h"
+#include "trace.h"
 
 #define PCSPK_BUF_LEN 1792
 #define PCSPK_SAMPLE_RATE 32000
@@ -137,13 +138,18 @@ static uint64_t pcspk_io_read(void *opaque, hwaddr addr,
 {
     PCSpkState *s = opaque;
     PITChannelInfo ch;
+    uint8_t val;
 
     pit_get_channel_info(s->pit, 2, &ch);
 
     s->dummy_refresh_clock ^= (1 << 4);
 
-    return ch.gate | (s->data_on << 1) | s->dummy_refresh_clock |
+    val = ch.gate | (s->data_on << 1) | s->dummy_refresh_clock |
        (ch.out << 5);
+
+    trace_pcspk_io_read(s->iobase, val);
+
+    return val;
 }
 
 static void pcspk_io_write(void *opaque, hwaddr addr, uint64_t val,
@@ -152,6 +158,8 @@ static void pcspk_io_write(void *opaque, hwaddr addr, uint64_t val,
     PCSpkState *s = opaque;
     const int gate = val & 1;
 
+    trace_pcspk_io_write(s->iobase, val);
+
     s->data_on = (val >> 1) & 1;
     pit_set_gate(s->pit, 2, gate);
     if (s->voice) {
diff --git a/hw/audio/trace-events b/hw/audio/trace-events
index b8ef572767..30f5921545 100644
--- a/hw/audio/trace-events
+++ b/hw/audio/trace-events
@@ -23,6 +23,10 @@ hda_audio_format(const char *stream, int chan, const char *fmt, int freq) "st %s
 hda_audio_adjust(const char *stream, int pos) "st %s, pos %d"
 hda_audio_overrun(const char *stream) "st %s"
 
+# pcspk.c
+pcspk_io_read(uint16_t addr, uint8_t val) "[0x%"PRIx16"] -> 0x%"PRIx8
+pcspk_io_write(uint16_t addr, uint8_t val) "[0x%"PRIx16"] <- 0x%"PRIx8
+
 #via-ac97.c
 via_ac97_codec_write(uint8_t addr, uint16_t val) "0x%x <- 0x%x"
 via_ac97_sgd_fetch(uint32_t curr, uint32_t addr, char stop, char eol, char flag, uint32_t len) "curr=0x%x addr=0x%x %c%c%c len=%d"
-- 
2.51.1.dirty


