Return-Path: <kvm+bounces-40799-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ADBEA5D031
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 20:59:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D28F9189C4F1
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 19:59:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803C025CC6B;
	Tue, 11 Mar 2025 19:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rJX4cJi0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BE7B264FA8
	for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 19:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741723106; cv=none; b=b7TtE6kONyFSp3figb4CYrNcNrEG7JTjKSqwetJzWBEaK5RKIq/5qSREt17+3DsZEDksOI2cGLXchKPbTk2xMXpykFFuERn07fn7ZCSM7QXPAZ/WxwO3pXqeHWeJPtdCB8nXvK0MBj9ZHn2sSYxqpNEMm8rmbr009x+AXBAvFwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741723106; c=relaxed/simple;
	bh=2BGYv29y1gAuWbOxLdSmdLhzjdPFXu3kgq+kOyRsd60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NojEez+VaUis54s4xkd1akPh5ioA/RZJBLQgs98rb16XyAXFAtduGz3yXBl9YyEvZ8NWxw1IM4bEIS7pBNmEmGKyuvbDLLYrQzGDbnPMFdvYJvuRuHC4s4ngu7DWSeTVNOIK6SXKQLUz2ypDrCBRJiDPnSLvD44IxDabzsNeVxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rJX4cJi0; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2235189adaeso4054725ad.0
        for <kvm@vger.kernel.org>; Tue, 11 Mar 2025 12:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741723104; x=1742327904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZcwoIie6BtZ5Bqo8BYW0CKBTK95znA0iA8YHmiy7v4=;
        b=rJX4cJi0dmaUt93sUvWSQXQmElh79kgiqadsHJxHIFKNpFQk8RzL37Em/2GaBviEUO
         rh2F2KI54f+RymMB5ozYcFIy3x1PgjwGzsEAUHDXgQ2QEqSRhax43bgewJ5l/+s1GOgt
         LKfcTLuz4tSrJ1fJwIH0L2HFDcT568pdIwRlwhMKD+72nLibAvbXg+z1YsiV9KRO/p7v
         YY5NhI/C8bYuwQDa/30Ar4a98IlLNgftSXmr9/h/GwSvIHrWLci7mKiSjqw4yYrGlRig
         MEiUEJQ5852bKjMH43DVVE7tmN9Uhxa6MejHh1+vH8m1LJnBUprGf62aU7RlycbHQdjR
         HupA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741723104; x=1742327904;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZcwoIie6BtZ5Bqo8BYW0CKBTK95znA0iA8YHmiy7v4=;
        b=FgLqrYjFVM8tioaBUHnsRURjWHPbSQ/aJS7Jnp/jtUwOi7PfgEVUEEEMUpnWV/PYbD
         YhYka55vGmEpRdk1UkxLl408Uym2/oqsC+mrsDC50VBCEgj16DyoxUsgxcoro/r7NVQm
         KTXt6ydkdHwaR7wDYg2oRxcsNxIprye/TrsjAeWCIAXC1EugFHLhCF4Fk3JQ1dSqWxqp
         MxW0tcwRKahECe/rCM8ZpKAJu94KOMkWJJE2L1ftHtd2TrOdV/+p8Ut8Wit1SWJe325S
         A3Rc3/SPeVtmnORSp4Rm17VsDcVdr9DSTNW/tmLYL9LndfR9IjMLzh8UfxRZEHUlRCaz
         iK8w==
X-Forwarded-Encrypted: i=1; AJvYcCUFGxid9jOhJGMfIEqAG/XxTyM8tmFX6RuLZqj485BZbLmJ3ZujWx60i8uDAD9dkodJqO4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz57538BZpwcP6kQsCr55A2CrThLHpkmylHso485Qaut0OzCFfJ
	eVROwBBp2ZsSVrG5LiZmkKmGCrtAW9bmXyI+DsMzXPvtbMNMRqI6M8iX9Y5K0Ho=
X-Gm-Gg: ASbGncsQ3rctAabEnbhIXlED9WwfsELX89nF6mUbJ3Z5UUueaOPClyVY/YDcwMuvXly
	lCZiCVAuWXw9jJmUeShob+HojmybNgesF51bazo37B7Kw9E51gK8mc7ze9eU9b3de9JT1XqI0ju
	9HE2V3uhD6fyyjdudljb5bWEhyJ1tTPP9LaRGDboM0c+9Uk5dnYZR9BRXUtFOsM94uhbfuq1OAt
	tcXtQDlmx2cpi/Q6OvmZ0MDGHsFdWojR4dcmg4iryIXPMdQMY6VGdDwsMvlqqEnSurHfSo875d7
	qiRyuwTlwG5LwfZwOjgimprhPhcvgeKZ+qpPMAwmRBpj
X-Google-Smtp-Source: AGHT+IEToni6mHy+/TOd0EQfFDFUNLQyZb+aNmkKXcJNYvCuHB4nuxbuNFqkwEKNu7S4yPPDELKJzQ==
X-Received: by 2002:a17:902:eccd:b0:21f:5063:d3ca with SMTP id d9443c01a7336-22593dc5076mr68139055ad.16.1741723104414;
        Tue, 11 Mar 2025 12:58:24 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736a6e5c13asm9646981b3a.157.2025.03.11.12.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Mar 2025 12:58:24 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: David Hildenbrand <david@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Anthony PERARD <anthony@xenproject.org>,
	xen-devel@lists.xenproject.org,
	Nicholas Piggin <npiggin@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Weiwei Li <liwei1518@gmail.com>,
	kvm@vger.kernel.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Paul Durrant <paul@xen.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	manos.pitsidianakis@linaro.org,
	Peter Xu <peterx@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	alex.bennee@linaro.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	qemu-riscv@nongnu.org,
	qemu-ppc@nongnu.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 12/17] hw/xen: add stubs for various functions
Date: Tue, 11 Mar 2025 12:57:58 -0700
Message-Id: <20250311195803.4115788-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
References: <20250311195803.4115788-1-pierrick.bouvier@linaro.org>
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


