Return-Path: <kvm+bounces-50074-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAA01AE1B77
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 15:08:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 437EF174587
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 13:08:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49585284662;
	Fri, 20 Jun 2025 13:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J7iph0sR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B479828BAA8
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 13:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750424874; cv=none; b=iOmwM4kuFBpRIVJXmAOAscewBXG/40MGucfOcFwea26qjpUFf5bxHhFXlwo2bINwuZd7nO5X0L+cdm0sQ/XWvr7PkgqHcdkawQrjZkDHX/DNt6263U0lhJHYnuLO7Sk52ktWquEHfcfP5gZVG2EdC2588hNY36SdAc/lbPwwzEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750424874; c=relaxed/simple;
	bh=Y8RKXOkRyOm8pXorqe+vvzLu24/YWcvYhGF5gqNeea4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l1Gc2HxJQE1YPsqJQnVDc0w4XbAO6Zd+dvpG7SiMVTY2j8ijlRtB2v0XE5VuCUJYM/V1Ek5exzh/5hxMkInsSN89zguZtgne3FZZvQ10TwNGQUwTxyAVK2uG+7+iH5yqvimAI8/erGCugeAgI4salAaxpqTNC2V9Ovyjj7sZ6wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=J7iph0sR; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45363645a8eso8216665e9.1
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 06:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750424871; x=1751029671; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q43gncpn959Q6vZG2TfwFzrP1CTDyk3SKCOoBpm/1fs=;
        b=J7iph0sRZrnBECLxqEnnRQ2IyZtqzLbie3XbqRdSpQenOBYBTwaPKATygUEvSwVki2
         1rwn/OBhLjhxWTIuMdOlKD0EvlIprjR8n7i+dgmkxNU7723/LxavCe09/clepmgK2/Vu
         J5UJeno/PEsOKt+4kdr8DYzlaK48bv35DENYhftU2t4LRKjSQrJZnjaO4kw0QC3d7G0F
         w6FqH+felFMFI4vqP9bIbKlcZ8PVP4Rk86ddVqJn/85ippFc3JiqT2NrkhbiXwUE1BMe
         115h3+01LSheRmfMYwOWZoPVtknzi4a3j5f1J288/wIUiX9cimIBuk3LX3unsuCMANvA
         6WzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750424871; x=1751029671;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q43gncpn959Q6vZG2TfwFzrP1CTDyk3SKCOoBpm/1fs=;
        b=az6klxD4hAg27eMIoysHrn0gD+PpInJmmN6Orxh5n0RN7ZZ8NYsCxVjvwmvWEZH6My
         K9HZPJ97XKi/myhtxzJb0yA5m6rxr1EiBJAZa5ITL7PmrS+FkolAWGUDptIPOB8gaeIv
         l3fWUqMfy7SIHmmxKOyQHuJdbLkMb2qwMOXYtxHGGSaPgf3VOiiYB0NKfKjJTA0d9OnY
         sAeK9B3zMMuL5hjd/SBGTjbTN6Aw5PEzrMhsMUYv9l+jDzjBcwDHoJnubsnt8SGa/Xjg
         KJOBdfCfd1fTDKaPPiYvC+iSYv5/k3Dt7JPxcjG2Kfb5N9lSEJbDYvZ51elumJI0ue1z
         kT/w==
X-Forwarded-Encrypted: i=1; AJvYcCVP1BOUk3FChTnYrHyOg9HRgFP9QdYNQq4Chlj/zwROkphg/pNSg1c/lYq5JCvDeeWyaMI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzmqtm8ZZIfpORWntqnsOFGttM4c+ayjEQIuItDZQMhEASP5SA5
	VK7BpsuOzon8VBykdPXt47LBYmSe4N+aYhFwn1MlbVsxp5YqMyWmfA+n3KUGQh9tAtA=
X-Gm-Gg: ASbGncs7RO/pILCZT8Os3EvQ7v795H0NQlzrDyJGyx60H2UWvQmLRCaQy1dzoM/aViI
	QPKtNFv0FMMzcCYDJ6M1Vsvjsdoz6Iv0Y6E8BkiEEaZEuy6Y7xaBi4Rmaetz7DEGy3xdaf58Jdj
	i8GP9Ca8ESnXJyWq9XNCW1/29Ki8ciLAy6jJvU3yV+2142WajRV7koP/QOWmJl74P80X1vmFUtW
	4V9HTMgv3sjP/lgV/UATVl8QvfzHe6I8KV460Q01fAkA0kqSxCA+NOisKn5H/QbCBoxYIR4u3QS
	J9DMYl22czBZ7rzkFsViyoqgzCUtncOubY/L1mhsZLaTDFqAxmff+V4X7Tvqkp8/t6Nw2Gb44qm
	c/wRN7d3dr+CrGr8+ZoRD/8FTHWG3Zm164jII
X-Google-Smtp-Source: AGHT+IEV1rnW6Q6vc9usSp2h/xg/oNVsZIj/bM4fFPHRe8OtleGcivh/UCl8l6pejkhU6VSf44Ctdg==
X-Received: by 2002:a05:600c:3545:b0:43c:fffc:7886 with SMTP id 5b1f17b1804b1-453654cc009mr23346725e9.8.1750424870729;
        Fri, 20 Jun 2025 06:07:50 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6d117e520sm2053595f8f.56.2025.06.20.06.07.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 20 Jun 2025 06:07:50 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Alexander Graf <agraf@csgraf.de>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Bernhard Beschow <shentey@gmail.com>,
	Cleber Rosa <crosa@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	kvm@vger.kernel.org,
	qemu-arm@nongnu.org,
	Eric Auger <eric.auger@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	John Snow <jsnow@redhat.com>
Subject: [PATCH v2 07/26] accel/hvf: Trace VM memory mapping
Date: Fri, 20 Jun 2025 15:06:50 +0200
Message-ID: <20250620130709.31073-8-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250620130709.31073-1-philmd@linaro.org>
References: <20250620130709.31073-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Trace memory mapped / unmapped in the guest.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 meson.build               | 1 +
 accel/hvf/trace.h         | 2 ++
 accel/hvf/hvf-accel-ops.c | 6 ++++++
 accel/hvf/trace-events    | 7 +++++++
 4 files changed, 16 insertions(+)
 create mode 100644 accel/hvf/trace.h
 create mode 100644 accel/hvf/trace-events

diff --git a/meson.build b/meson.build
index 34729c2a3dd..5004678a26b 100644
--- a/meson.build
+++ b/meson.build
@@ -3633,6 +3633,7 @@ if have_block
 endif
 if have_system
   trace_events_subdirs += [
+    'accel/hvf',
     'accel/kvm',
     'audio',
     'backends',
diff --git a/accel/hvf/trace.h b/accel/hvf/trace.h
new file mode 100644
index 00000000000..83a1883343a
--- /dev/null
+++ b/accel/hvf/trace.h
@@ -0,0 +1,2 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#include "trace/trace-accel_hvf.h"
diff --git a/accel/hvf/hvf-accel-ops.c b/accel/hvf/hvf-accel-ops.c
index d60446b85b8..b38977207d2 100644
--- a/accel/hvf/hvf-accel-ops.c
+++ b/accel/hvf/hvf-accel-ops.c
@@ -59,6 +59,7 @@
 #include "system/hvf_int.h"
 #include "system/runstate.h"
 #include "qemu/guest-random.h"
+#include "trace.h"
 
 HVFState *hvf_state;
 
@@ -97,6 +98,7 @@ static int do_hvf_set_memory(hvf_slot *slot, hv_memory_flags_t flags)
     if (macslot->present) {
         if (macslot->size != slot->size) {
             macslot->present = 0;
+            trace_hvf_vm_unmap(macslot->gpa_start, macslot->size);
             ret = hv_vm_unmap(macslot->gpa_start, macslot->size);
             assert_hvf_ok(ret);
         }
@@ -109,6 +111,10 @@ static int do_hvf_set_memory(hvf_slot *slot, hv_memory_flags_t flags)
     macslot->present = 1;
     macslot->gpa_start = slot->start;
     macslot->size = slot->size;
+    trace_hvf_vm_map(slot->start, slot->size, slot->mem, flags,
+                     flags & HV_MEMORY_READ ?  'R' : '-',
+                     flags & HV_MEMORY_WRITE ? 'W' : '-',
+                     flags & HV_MEMORY_EXEC ?  'E' : '-');
     ret = hv_vm_map(slot->mem, slot->start, slot->size, flags);
     assert_hvf_ok(ret);
     return 0;
diff --git a/accel/hvf/trace-events b/accel/hvf/trace-events
new file mode 100644
index 00000000000..2fd3e127c74
--- /dev/null
+++ b/accel/hvf/trace-events
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0-or-later
+#
+# See docs/devel/tracing.rst for syntax documentation.
+
+# hvf-accel-ops.c
+hvf_vm_map(uint64_t paddr, uint64_t size, void *vaddr, uint8_t flags, const char r, const char w, const char e) "paddr:0x%016"PRIx64" size:0x%08"PRIx64" vaddr:%p flags:0x%02x/%c%c%c"
+hvf_vm_unmap(uint64_t paddr, uint64_t size) "paddr:0x%016"PRIx64" size:0x%08"PRIx64
-- 
2.49.0


