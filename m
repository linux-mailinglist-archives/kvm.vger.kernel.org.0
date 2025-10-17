Return-Path: <kvm+bounces-60302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E665BE86AF
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 13:39:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CDF558081D
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 11:37:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90EBB345739;
	Fri, 17 Oct 2025 11:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NxnmX1Pn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF3721B1BC
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 11:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760700842; cv=none; b=nf5To54rPGtKQEvBG5NIXAUwMHXxCcKIbcjAl09E+7T2Qoy3rGGZIC8M6QLeFSJD9RI9sCCBHoLM9Ey/1/GTWqFTxwCQIA8vuuVUItM9/r7NHSx1Ea4Y9gN3DKlEw/pB6OJj29JM+bt+lKW+DTxxgm2/xU3jzq9zLkNF628pdEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760700842; c=relaxed/simple;
	bh=urUGjh+zmzKrus48UzWrAAEygWKSORrP1adlA+qumHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yhfv2BjT8gPlnxkkpWZ7Hiqi+1W05R4ZFFAuhNOGOlurWg14e8UkNz1o8G6a+IimxYtPmL2LmezXYIF86UMULymKAsEaDVXavU6k4nL8RyUvjcJ/rezREDCNMP4dSzLfQzQVtCI71/ZNEEsflHSwD9V4fM1f6E9lEMZUm9JA4dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NxnmX1Pn; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4711f156326so4639715e9.1
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 04:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760700839; x=1761305639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYtLEyH2FfideJwdnFZ4JM8eULzVedauT+XtbsfYWyM=;
        b=NxnmX1Pn4aDTO96H+f6afwUUijHi6umW0hOs4Ew5nap008BSKioKCjgAFDUNZ3hNOY
         WP/IeDd23QWm9qc77ILfdtrGHCBaOGHJVat3AobHf4QrNEzbiocqb/nFTGNCVIC2PJSG
         bSIH6UNQbQFIqZHL55RCqdLTY+Ms95Xk65dWu2Tcy3UxYcrpjxpWKLaW38ubh9Eck196
         N4jqNgMetRBJ24LTrS6UWTLcPXtNM/edf8BIkt+7hmua4QJVKLIcW7iCFQLbOGHlqvUB
         LQfom3lTpon0mZgOPUdxyey9huHAcAWV1gELTUf7fy9JDj8lFmHfwup7nTHbj+1dO9wk
         6X2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760700839; x=1761305639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NYtLEyH2FfideJwdnFZ4JM8eULzVedauT+XtbsfYWyM=;
        b=VI32BYeGXO0AS4DGEN43pqMMgqnqMMXIuPNHI5ylFPByXkTfEabfDMiv9TpBkfBviE
         uPuV9l8VxjBv3os8tdq0PIMpcxjfaJvQCTC1iPZQTWzm4JpYK/hsfvD8mA/4Pm4Srkr5
         SpbHuLzHeAhzpoyUCuCaxPp9I9Hi/IM6hOlZCLzD9R3ngdBVd/2aTFUGljZlma2koPMT
         8+2nfZ+N/n11FZXHJ0Iy2ydTq2xjfU/oFMCeoiwD4Ahy3Xn56VL9+NRv6mgjdP9DX0aD
         9/CvoeNHMmXLnIfATBFY9fb3iCSj78iLFqV3BdfZ5gJJ+Bt2mTYB6/9Bkey3UuzhYoqh
         jcVg==
X-Forwarded-Encrypted: i=1; AJvYcCWvTZoxjzvVNBEdnm/Pb83RgMUhx7QmE5/CUTv3okVJJSkaEkaOZPQYGWfSfRujc8vRlOs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz92my4GdNdmt5YNJuuw9AiAim0t6QIKKgWqV6EgQT7dLtzZaOM
	hY1W0UVCr/mNwwj4ErNHwVlf4NxHoOefadiZnzRyb94X/JH/tOdOGgHu
X-Gm-Gg: ASbGncvtBHtc+fIgW7ay2l8BpRoIkUhG08mz9Mnxg/DWfw+pArdH4+QnF6akZXLSMd2
	WtlZ2XneejwDkbERhvtq95hPyJWojOZOmBRz6r9Qqru8QCcW5SHqzHT+E2obqHeWxdPO8bDJT75
	IXMlUcut4XG8o/zV7esjOfBedzgUJEZRbSfppzdtebjRtCM8/1Gp3oijYpOVbRagCGVDFkmsm/a
	NoS5t9LJSMiPy2qLz8VDKKvPButGT1YoRbeZuAlDwdX0Z2RMxs8Ish8eteYVi1IxBFthrM2NYTC
	Sd34B6io2imXb9V7fwBQhFDR/xIcVQeWAnm+IJizGvhi/+b5lym0edZ++nGHZtGAcWzsjkTe/Qb
	+9Y3eMdd1+FtebsSxVMxZLK4wJX9LR5KuOhi8kgvJrC0UwKZj6OiEa6LWXIqxEPcT81YOZvmOtm
	N/TqEDwck8djFJGCN/XQ6ZEFpXV/RMtYCp4vSPQ36yQfeOnFcmeBz4aw==
X-Google-Smtp-Source: AGHT+IEpC0YXq4lxNd0tPQVqaII3/WfItW0xvbTEycBAe8uupL4fpuonmWCOMkLkt2on9PH29+CgFA==
X-Received: by 2002:a05:600c:19d4:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-47117907234mr29387625e9.19.1760700838815;
        Fri, 17 Oct 2025 04:33:58 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711444c8adsm80395435e9.13.2025.10.17.04.33.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 04:33:58 -0700 (PDT)
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
Subject: [PATCH 2/8] hw/audio/pcspk: Add I/O trace events
Date: Fri, 17 Oct 2025 13:33:32 +0200
Message-ID: <20251017113338.7953-3-shentey@gmail.com>
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


