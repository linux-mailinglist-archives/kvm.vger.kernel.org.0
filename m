Return-Path: <kvm+bounces-60318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B8F0BE91CC
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:13:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 214A94FB88E
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 14:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29FAD36CE19;
	Fri, 17 Oct 2025 14:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JT3VLXFg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E62D36CDF2
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 14:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760710371; cv=none; b=jRwTzbiLKqeXOzWFlOksTqdoZo4z3OsbEq4dlHYKFJMwHIXHhSI4Tpcy3wAPMsTDNoJwqPQQcx/B9w53A4bdvd0lDxNlwd8LfLojQwCnTuZIksgfontcwwyEmU8PQB0oMCtuL90d9fCy6cigCOizSCw0iKFCTqkbwPExRE2yOKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760710371; c=relaxed/simple;
	bh=urUGjh+zmzKrus48UzWrAAEygWKSORrP1adlA+qumHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uattlK+OuuuQ3/KqCJQQxSale7obmS8TuQYdSICleL/Zy5ZO06tr3VNdV9xZwgq5Wfhh0jCfi1A3qA6hI0O74PsylTQcenRQdrzuJCoaQoVGwqnHGVE/hbr4f9cOxHPcA++9DTeQ1VNZ2xaKLornw48KwfAcqh3D66CP42zi3NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JT3VLXFg; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3ee12807d97so1843384f8f.0
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 07:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760710367; x=1761315167; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYtLEyH2FfideJwdnFZ4JM8eULzVedauT+XtbsfYWyM=;
        b=JT3VLXFgEVNEjzvEViyok1bDWBEf5oFYx8nIXFRbwKCNvunJZfcMLZw+kXlT9b3tsu
         DY3gXcX1HXKpFKHZctdjp3z9cG13SgXmx0bhS0dqSetfZ9cDF6gtEihCL4Sk/CN74/qE
         IfNAXJuQSYJrs50D9WLrvVymbwuKlPL+tdm5VgDV9EAFcIxwJZe70PCC+xjRRBVYgY3q
         1Na7Svsju1B+m7l4j9g+j8hIyXwyk/gyZX5RzgwN+JoZK8954c875t3LY8oz53oZ5zU8
         jzoYfYMye9QaKrW+FtbaoAPz0Je0F4e30O29pgaDpYDIMlMhlNTN8y20VzVe941m1jOn
         3iyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760710367; x=1761315167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NYtLEyH2FfideJwdnFZ4JM8eULzVedauT+XtbsfYWyM=;
        b=kIkJTlGMS6T9XjnIfG2MRS00IfEZK6fBfw3H0+36YDrFA5y7+wx5dIE++XBcM+Ef/2
         HT1uYnX60YHp8eTW+wM2RwgTd64focYlHuDAGFZTJttU/K2MiSNKAp2zOt1gF7PegwrO
         QUqHjhRQv1PhzfoyMYLIRBPU2YX5xQqYSNppPf3Qau7Pr03SnH0Qy0h4GYsaPyh0Dadl
         9P62lnGsLffCJqWFNbBazvbKmmVWi6lWJSKwecHDCgsx56X+1/WSoj6bRQKUkrY4/SQ8
         TH931+RYguZvozM8OnQW+4tUpnYxZvxaHw6vVAUTF8t4DzQ5l/7DJiuMDflzb3vLkVd3
         2lMA==
X-Forwarded-Encrypted: i=1; AJvYcCVFSHpFNXPofw4+bYGeG6ZwkYttuBl3/ukOE2JoDHzVNZZZ/6SvmOXZFXihauIsZEOC1Ho=@vger.kernel.org
X-Gm-Message-State: AOJu0YwAJSxeCJhOAM3s5S3znq2glELXFaMiYvQsV++Y8fyCV5EO/oKj
	Vbs4ZGyi3Z+sdqafLoP75idkkAe9rpxVTKWTZgkfT3M7xW6WO2RVZJht
X-Gm-Gg: ASbGncv4f77t9AUkGT+jCcW+UlwgPWpqmp5HE9a/IEJ26a3v+vjuVFgnhcR9KQuKdo8
	ZQZGHBJ15pN8+G4+AbyxhFx4cphEYetruvWQOkgeWehAhiPCphmqJ5MxB9FC6zKtJqBEzNmmosA
	g4gVNLtA/2k3C+F1HB5z+38tsetJhWTd1kFNLlcKPxxeupFdhCU5hSKU9AKuA7eFANLGVjbLVb+
	BCchkcmaXCW9UG1PmI5s2kcJ9MNpfTgier8Wz+Jqx1ezDji/h1z/h7KB3eMFbLqtjmza6kecsdM
	i51KRaQ14EdttzpKQEMMakPx+fDi1Q310I9KTDsuKuf3qAhpT2fBIIu0ETdPcDUo0Yh7o2QVcCY
	Hpjcu/EVc2WhM0f1YsQOxfOZNxYz00cG3diE7JCAC/xEyuUoVwcL6JldLCJPIqvWfyoJreu0hTd
	JaG4zDBmMUtGDUajFpUr9DaAzav5zDe4uDXrL716IR83s=
X-Google-Smtp-Source: AGHT+IEpVNrad4ULoYv87FWp8OQYnoQLnUzWsjxgBNny7ih8x0h9VPWd6hpnLRrzvILGi/tZVWmNGw==
X-Received: by 2002:a05:6000:250d:b0:3f8:8aa7:464d with SMTP id ffacd0b85a97d-42704d9b235mr3022647f8f.42.1760710366783;
        Fri, 17 Oct 2025 07:12:46 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710cb36e7csm51359675e9.2.2025.10.17.07.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 07:12:46 -0700 (PDT)
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
Subject: [PATCH v2 02/11] hw/audio/pcspk: Add I/O trace events
Date: Fri, 17 Oct 2025 16:11:08 +0200
Message-ID: <20251017141117.105944-3-shentey@gmail.com>
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


