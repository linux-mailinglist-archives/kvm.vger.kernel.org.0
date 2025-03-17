Return-Path: <kvm+bounces-41299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8784A65CC5
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 19:36:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51DD418892E0
	for <lists+kvm@lfdr.de>; Mon, 17 Mar 2025 18:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 751211F3B85;
	Mon, 17 Mar 2025 18:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rAocUVsi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBE81EDA19
	for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 18:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742236480; cv=none; b=P7oHjj+Naq+nMX0g1hu3RDpS2EZRe/xTq3lkC5p9Acu7V3t8QQLjy5jGZqC2ZNmcb1Q6MLcFXfawa0POK/PEiTXNpNAJ3p7TjHCU5NHo4z5wOUDZ5KofRs01//Nas+aAab4u5Akr7TU6kkWdoZdYfZ1IOeUUDjavdFIElqkDtyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742236480; c=relaxed/simple;
	bh=iKKLIJd9FNajHq7HD2C4hiCWB531yc/zeXL34A64mgQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=N1r6IvH3hVdZ+Bw98TeANi7zjKI0LLn3+Oc42Z42bzZBf+R3t/04gtapfiYwSmXt5HpxFj0Y5nZf1qxFsaUkbXwtV+X4nDu0w05m19TePqEA2exMBXuFJ6/Bsg6veJ/NRlZkhfxXXv/hGVjrYYnLiHoANUapGr4ipeaxPnCJaFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rAocUVsi; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2239c066347so99592355ad.2
        for <kvm@vger.kernel.org>; Mon, 17 Mar 2025 11:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742236478; x=1742841278; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=59c6JEMS6FIy924v+CKtazEU0ebGAiMufvTS4mzCbJo=;
        b=rAocUVsiFgzbN4fDEaLlR1lnRABls8yHiDyeRWQxlqw6iKHz0BWcmdz4vgFXTG7AWp
         /0Poj+FPpIEtl9MUD3syE/7o4AkxbnT14JgtNkHYEziASMLaH+VN1nUJMlaASOjHWjMM
         hLRA9Xi/FW/SIXNGJ5Tw7yZMSl7OGLf2gf/u0kNpxcvQ0m4fGEz1M3/oLt54DQOXRDgr
         UEBjfV3+clP8P8LT28XRQJu+IClVaqcDk2AErhpGSZBqJ1EDQi0+/MPCqtUkuAQPuAzq
         LQMHjwuOKnocimXMZgVlgtKg9vGaMHlEhXWUhumFfGuOqHTbpWT2pkxQpKbYOpmCQzah
         NNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742236478; x=1742841278;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=59c6JEMS6FIy924v+CKtazEU0ebGAiMufvTS4mzCbJo=;
        b=FUnodSGjSiu0QwvEoWofFJ15jFnVDekd2FZN3B1xEoMpE95HW5VG4vuoPwzs55jWAn
         SOreJtTb1rN3R/IZZVg+fBciZjnDWggYcDvXJ246o2ttSyohYK0fHfbSrPjG6nNWvCxq
         I/NpeZuah5H1dCR5+c5t3S+SzXkul6T/jP1MobanpE7wrpp/0b5BN509uPVZq7bfyKWL
         doYXeXLJsV7Mn/MLkM50eeHJT51dwgU7fx9uL2aacQF4r3FNPeMq5nqCsUXfY3XNnMkH
         m0UKKqFBctz1By7TUXifbOcN7E2o/QjyCXAwy9YT0wHYMRY1KeCVTKl7nH/wQFH1mRxR
         +CcQ==
X-Forwarded-Encrypted: i=1; AJvYcCU56U6iOy1inrCJl+3i29sNSY2eaZDk3YNXb/+5URTbatBcc2TXYICSre2+5JP7v/BwPec=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUPZJEfpmAbqp3KEKcDgCLnqwcsW5XfRa9I8rv9FEWvdlJskU2
	nsRJ83QrifQvqzLI+jhrCmUMrzJx1HS422q7ZNbD1FssSQ05LFNuC87UY1HlBWE=
X-Gm-Gg: ASbGncvYjapjks0/Li/WuFZKQKJGLxC8teSdlukobZDUhAz3pP9vnvURMSqFql8R7qC
	/Grwufz7pb6nbUUYWR0ewU41MJKNNKduoj48tSJhDchtSf4l5c3hS748p2fJQlNvhPFiPEttErl
	MH6Xgs3mMRZm12jesDs8v/B/OaTUVD2rDivbQBcGiXCejwWDUdrvDrrJV+9BpR49PqtBk5BGbaD
	pVP4HFIsnQ1K9/iYhPP01B40i+8gUp9Fgz+1idcvRMDbmborF1wJCWTEqD9mnWd6Ph92IXoqJqH
	qFbIghDhMHM9Z1YoLHtPoaOqyFF7RRkIfi0KC/jwuioN8Jf5B5ZCKxw=
X-Google-Smtp-Source: AGHT+IGMBPlS4723f/QfXCi2z/TEFSVr/xLDSBzcEDnDoDIjYYHTKxD7//19rhfel7oXOjNf8/+suQ==
X-Received: by 2002:a17:902:f711:b0:220:fe51:1aab with SMTP id d9443c01a7336-225e0af4f9cmr187594395ad.38.1742236478508;
        Mon, 17 Mar 2025 11:34:38 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73711695a2esm8188770b3a.144.2025.03.17.11.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Mar 2025 11:34:38 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	xen-devel@lists.xenproject.org,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	qemu-riscv@nongnu.org,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Peter Xu <peterx@redhat.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Anthony PERARD <anthony@xenproject.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Anthony PERARD <anthony.perard@vates.tech>
Subject: [PATCH v6 12/18] hw/xen: add stubs for various functions
Date: Mon, 17 Mar 2025 11:34:11 -0700
Message-Id: <20250317183417.285700-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
References: <20250317183417.285700-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Those symbols are used by system/physmem.c, and are called only if
xen_enabled() (which happens only if CONFIG_XEN is set and xen is
available).

So we can crash the stubs in case those are called, as they are linked
only when CONFIG_XEN is not set.

Acked-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Anthony PERARD <anthony.perard@vates.tech>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/xen/xen_stubs.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++
 hw/xen/meson.build |  3 +++
 2 files changed, 54 insertions(+)
 create mode 100644 hw/xen/xen_stubs.c

diff --git a/hw/xen/xen_stubs.c b/hw/xen/xen_stubs.c
new file mode 100644
index 00000000000..5e565df3929
--- /dev/null
+++ b/hw/xen/xen_stubs.c
@@ -0,0 +1,51 @@
+/*
+ * Various stubs for xen functions
+ *
+ * Those functions are used only if xen_enabled(). This file is linked only if
+ * CONFIG_XEN is not set, so they should never be called.
+ *
+ * Copyright (c) 2025 Linaro, Ltd.
+ *
+ * SPDX-License-Identifier: GPL-2.0-or-later
+ */
+
+#include "qemu/osdep.h"
+#include "system/xen.h"
+#include "system/xen-mapcache.h"
+
+void xen_hvm_modified_memory(ram_addr_t start, ram_addr_t length)
+{
+    g_assert_not_reached();
+}
+
+void xen_ram_alloc(ram_addr_t ram_addr, ram_addr_t size,
+                   struct MemoryRegion *mr, Error **errp)
+{
+    g_assert_not_reached();
+}
+
+bool xen_mr_is_memory(MemoryRegion *mr)
+{
+    g_assert_not_reached();
+}
+
+void xen_invalidate_map_cache_entry(uint8_t *buffer)
+{
+    g_assert_not_reached();
+}
+
+ram_addr_t xen_ram_addr_from_mapcache(void *ptr)
+{
+    g_assert_not_reached();
+}
+
+uint8_t *xen_map_cache(MemoryRegion *mr,
+                       hwaddr phys_addr,
+                       hwaddr size,
+                       ram_addr_t ram_addr_offset,
+                       uint8_t lock,
+                       bool dma,
+                       bool is_write)
+{
+    g_assert_not_reached();
+}
diff --git a/hw/xen/meson.build b/hw/xen/meson.build
index 4a486e36738..a1850e76988 100644
--- a/hw/xen/meson.build
+++ b/hw/xen/meson.build
@@ -9,6 +9,9 @@ system_ss.add(when: ['CONFIG_XEN_BUS'], if_true: files(
 
 system_ss.add(when: ['CONFIG_XEN', xen], if_true: files(
   'xen-operations.c',
+),
+if_false: files(
+  'xen_stubs.c',
 ))
 
 xen_specific_ss = ss.source_set()
-- 
2.39.5


