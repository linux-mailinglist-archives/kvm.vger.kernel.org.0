Return-Path: <kvm+bounces-40733-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DB8A9A5B7D8
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:10:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84EF03B0999
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:10:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9495222156B;
	Tue, 11 Mar 2025 04:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SEqJ0+E5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D38821421F
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 04:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741666152; cv=none; b=LVjGXrLJHqTbbDcDf9j/vRjszf4bBOUX55J5ayEn37fL3Hg4sUc4TS1Bj31eoSHHIEhTsP3uA+7iBzdMDCrp+ZOnnHH19rCfODpd+PsUrV2dzFCMBN86l63f2Ueu7mPZqBhDXPG+OUigj7EwqMc/RO3K5bpXimlMSmEy01R2T/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741666152; c=relaxed/simple;
	bh=2BGYv29y1gAuWbOxLdSmdLhzjdPFXu3kgq+kOyRsd60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XE4e3GSjlN7C9EFPLC0HrqCMZ4i+opt8XSfSt37c7v6JBY1bmkLkXkrvPh7iCdZY7WGRzoTII2CePn0NYd2IgNoSjBo6KZEEk0XTGHHFqo10Rls5kbU6uEp+FBQIr8php5mvFq4Cgqr7lqTqGZvvMlTYVisrcbH2oUx5RFWK1sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SEqJ0+E5; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2ff04f36fd2so8358062a91.1
        for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 21:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741666150; x=1742270950; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZcwoIie6BtZ5Bqo8BYW0CKBTK95znA0iA8YHmiy7v4=;
        b=SEqJ0+E5RpUIDI+bhZuTyk5LnYpMTz+Tbig1ni/+F6RusMpIddhmIJ3POvbATCIIJR
         quIZd6TDcDj7dTk+fi66Sd263vez8TUPNrduiF3U3SBcjJjivmLqjXoTkKMwAney7Mpl
         jye9CaCCsjr64SLwf3SnKdF/PYEN+krzsBQu6cF7/168bA73CgcIu47Zc5W1qZoDjSPg
         AcJrSbg9ATRwDp346Ic3iJl+HIuYxQeRuHn3jWEMCPzbWSjeaxBN+lF6zGQmSFVKYEjh
         pwb+Nh+p5swzSRj1mHgabjotby6H6EOVFJchHl2Jxz/CTVVNeuJNRFklhqCGFNYjrbsW
         H3fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741666150; x=1742270950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZcwoIie6BtZ5Bqo8BYW0CKBTK95znA0iA8YHmiy7v4=;
        b=LYZk/9CJhDHmHKs4h2dC/1zaEY93gxAdnDNiOIRWxdijzaB9bfkOpc9wi9uSvJ+xqQ
         8AXFlO4OHDAp/m8jTt/WKJavKdVKWAu8EA1wyAuJpIC52V2kn7FIy1o6GDj1vBejK0bg
         P2JQ/VD4JskIs0Ei7AfGA/o8lifQ53xshlz8zdK3JcV6CmAPW8ybfV4XeIuaEjG4Je0L
         fzwAYK+D+pdqhTBpK6YpkKYxBeN9caLU1nFDdKbYAi3iLbPt+WN8Ira7kmr1wO0NRtsp
         blypCkuh77PbgrEuEF1H9rgAPAeaZtV21I0pYa7sE4F7reRZyjlaxVj59tMPrts8F1w1
         rRvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXgEaU804Eszh138p2cY7mukDUYe9ZIa1miwK5Jz2rq7ZVEafKVUx3Ki2qyyg82pdqNUVQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4asGFLpgQNOmt037Bjnm+63IeGFXXPAEp1sTFjp+5GeYLPTKY
	5giTEnegb/BvUvKdLlS4tY9dq0/IhqHDmh48f1ZNcxXna4ML3e+fvwl3i155HsA=
X-Gm-Gg: ASbGncvyVVK9ANPsLWqCMtXDKGa25/vKjURS9n3Ni8XE7RFO5EdagyN+IdA2+zyLELU
	g+SQCZwiF00C7VnZKkKl+Bj1uA3J5D+2J3K60LMc+Y6Jf1QNQlwegm+9IHlofkm3BuCdEggmlOr
	6a6IpuUpMzkGiTlo8vDJIGFYSXT0PGVDlcDQkM32TTUBfHPScumZEDmXILdz/9eNotgfjzzbp7I
	AVSIzMpx67UEEo1RCzJqfGbLZnAhYFP7HRWiIFMGwdcIcInqT0gS1gn7UlbhOzMZXZ7PXjFtOPg
	bUdNhtMsKJj7FGkgsRyeCCS8Kc0+xZphg1bZTDXv3S1Z
X-Google-Smtp-Source: AGHT+IHJmCe2dJrkKZuUg8Hp5UUMBrSHtlgnmpF6Gn789stb7ihIio5wxKC4BVHFee5F9pMJvA7mBw==
X-Received: by 2002:a05:6a21:3941:b0:1f0:e42e:fb1d with SMTP id adf61e73a8af0-1f544c7fc7fmr33091101637.36.1741666150581;
        Mon, 10 Mar 2025 21:09:10 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af28c0339cesm7324454a12.46.2025.03.10.21.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 21:09:10 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	xen-devel@lists.xenproject.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 12/16] hw/xen: add stubs for various functions
Date: Mon, 10 Mar 2025 21:08:34 -0700
Message-Id: <20250311040838.3937136-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
References: <20250311040838.3937136-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Those functions are used by system/physmem.c, and are called only if
xen is enabled (which happens only if CONFIG_XEN is not set).

So we can crash in case those are called.

Acked-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/xen/xen_stubs.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++
 hw/xen/meson.build |  3 +++
 2 files changed, 59 insertions(+)
 create mode 100644 hw/xen/xen_stubs.c

diff --git a/hw/xen/xen_stubs.c b/hw/xen/xen_stubs.c
new file mode 100644
index 00000000000..19cee84bbb4
--- /dev/null
+++ b/hw/xen/xen_stubs.c
@@ -0,0 +1,56 @@
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
+void xen_invalidate_map_cache(void)
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


