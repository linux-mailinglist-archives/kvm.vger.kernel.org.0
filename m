Return-Path: <kvm+bounces-50318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 844C4AE3FA0
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 14:20:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DEBC27A1EE1
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 12:19:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 393C22459D2;
	Mon, 23 Jun 2025 12:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bGu4wlvD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A2BA2441B4
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 12:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750681167; cv=none; b=NOd5fvpAjmn46UKk+uQt+3q6mzsLLoQeRnXjmjcCJjYGMp1dzPCYJtJNL2sun9SqciOHKjh8NJwHAoY5uGH4hvJBzixkEu9MEUBiPPc5PIcTe4h0XsdEUPEl9quySBp6U9uHD8GsvXJ7vUxiG6+g8XIZlAhBZzmhGOok0lsZH+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750681167; c=relaxed/simple;
	bh=3VukFEdhlsNLMFcSNZ8ZFWCjR5FibiT23CL7CmiaqQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CZNrx2YxgdbU31PLHnk02c+Vmlu2ogYi9nw9IQzlgqS6K8RiZ9fPBrXQ8fmw4wS/NWM7CHti+fJ91r/WocvgZ0D37cNb+4X5G2NvhVQUPD5nOkjtHBNZFGlbrO2INwoeXwSr9wFTZGjJnshZFQI+9tjK3ZW8kHPPr4NUMZfWU4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bGu4wlvD; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a50fc7ac4dso2234487f8f.0
        for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:19:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750681164; x=1751285964; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GyiBFk3PHsFTGgxQWIJAhORaZcy53iNw0vUcB4RUUDE=;
        b=bGu4wlvD8BoWUyZK51wHxYiLRb41/HyYRBr22UQQuaKkVZm1Zp7byiISOFtjoQRPa+
         hhKssSA+QIIWcizghKZqLe30ZudNfB3MITS8sXuxouNLwXSoLXLOP1eAELbVX733GNh3
         bUS1q8x1ywY8ii3sczdj8lTsoD/G/LGQiGz0RpKiUjm2KLdGL2g6wjmYF3yMlcqZCIp8
         CsyIdF0xBly5snNVOX+pJfu4iquL0XqTBObHc7b7cl1eP9Q9vFqU0ncU/Q/xgei0QbzM
         12vq6eZhQN7sVc5BnaJH0hvzEuz6F4f5cPKELhhclVLDtwoIDuUHKawn5EjC3giaOxLG
         94ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750681164; x=1751285964;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GyiBFk3PHsFTGgxQWIJAhORaZcy53iNw0vUcB4RUUDE=;
        b=Q0QeQU/hqRb1sYnd4mOf+I86LzPbsJjx//YW0yqBggZa1QC/Se98t28y69sCZ3ByHO
         GFZ2PRz7aqJYelQMdDOS+f2YuLIwV9AVcVjflI4564puVuy8l+g772xIerIlWZlpWCmd
         bXj1Egqqd8pdKI6mPJtl/f7iD1gG97JF2mi281cSdlTiDkaXI3w1GWu2hSbb9rIIHZEq
         JVuoIw00X6u8Rkgx0sM/zDgEul9jGs2TGvFJodMTCvGhmyYGVMYb9GqOC+4cYkJhpCSU
         2b8PRf09xQ8MswwE158f29DAL5lz8iN9pGy8k3ItwpeckHcL84YtqUw8Ri+52tqBqq98
         11bg==
X-Forwarded-Encrypted: i=1; AJvYcCWdW+mUewdMXXzzlNfTYaWhYboWNez8JMpjX08y1tTJcWgWZnrxppplOpHNpZQ5dRxmZ58=@vger.kernel.org
X-Gm-Message-State: AOJu0YzeAbxtsiuVTtzeUcraC0p3+QS9YAbHuA2HrKUdFVaHsNq+I8Sw
	0XxXgfVwDndYmvjh/nkGgCrPmCVec4My5Gj1EBSNkS2Uh+cmjU+CMx8gkCfGbYCEmvk=
X-Gm-Gg: ASbGncsZlXNSoP3NH8fcydsM5wnvuZeqtRELjf057uVCMv64OFjRWbSlKtXECODPUaL
	YEkVni0oH2TPNT0X1gdY98MyPIy0e5OJErUiwMJGQpn+Y83ZWJUHlTqINOunuMvgzQ+WejRbeuB
	QDf9V4VddxgufjMHnClyjo/5ZVZdmFo7Hs+agKH9FccCFSRN+GGAK+Cba2ktrRpJCzAoCTH7AqV
	vUHo8RtAvElm50kaTQWqhZWo1i5sRA9X+XjgG4G3eyfW3YPir0oK4JkF9Pt5qmbjqsjUb/yk3qL
	JwaqLQWoubAJixvf4ZoszIr+L/86QKqv3icDM+P70yQYvHTGuAGRbIvYmvg1Xrf3Pqb1F2+idqN
	S7jrgKCwlrH5DXkgL+zuKFjq4OKO9hQi/brxW
X-Google-Smtp-Source: AGHT+IE/ShLC0BNfarjCGNMSpPGAS0rfS+vL7cCj12GXMkaCbIYQsstL056tugsSAblfUqd+SodRWA==
X-Received: by 2002:a05:6000:38e:b0:3a4:fc37:70e4 with SMTP id ffacd0b85a97d-3a6d1331ec7mr9866453f8f.58.1750681163851;
        Mon, 23 Jun 2025 05:19:23 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4535eada7adsm144615895e9.35.2025.06.23.05.19.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Jun 2025 05:19:23 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alexander Graf <agraf@csgraf.de>,
	Bernhard Beschow <shentey@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	kvm@vger.kernel.org,
	Eric Auger <eric.auger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cameron Esfahani <dirty@apple.com>,
	Cleber Rosa <crosa@redhat.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
Subject: [PATCH v3 07/26] accel/hvf: Trace VM memory mapping
Date: Mon, 23 Jun 2025 14:18:26 +0200
Message-ID: <20250623121845.7214-8-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250623121845.7214-1-philmd@linaro.org>
References: <20250623121845.7214-1-philmd@linaro.org>
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
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
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


