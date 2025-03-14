Return-Path: <kvm+bounces-41099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 281FFA617C7
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:33:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5DE6A16FBD6
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A7C205501;
	Fri, 14 Mar 2025 17:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K4mU9KFI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC332054E5
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973521; cv=none; b=iQB8wmtvEqHmA9u/5YhuvBx1x5vpQL38nZrO7SnHpUAhue6GapUDTO6YUt/+v71mb1KLdXy55qusqdMJfkIzpS+78Cpqhq+TmwqMAZ2l/u3m0mOJTS92u3/2taHpcRNEEwL6mc1GzK5dEBDBwWwaDbaYSZ2bZgrjAC/nNT2RClQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973521; c=relaxed/simple;
	bh=eqUIDEnU/5APjJtIqGx7rUlsYwr9cl7qn6R488WO+nY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mZzoUSdcYg0vwGN+pYNII7nQbjdRNz4Reyk3jFyD7qPqk43rwHPFK8Ecoz3sH+F0ZRKQTzBDMf3tGNE/LiYC6F5QK9hjf3hasO7VI3KLid4VQq1ChiFY9f3ilptQsxvxXzxouFwt/3KyUJeFI1pVuyoq4a3/gfcvFaQ4NPD6vgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=K4mU9KFI; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-22409077c06so62105895ad.1
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973519; x=1742578319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WZK4IDfbpcoj/UHXYNBc9hj61CH/qnmJNHrSERoWz24=;
        b=K4mU9KFIbL+WIcens6KH6b74ShticqlAdmuSeRQ/1icv0JPOv7CEPQO39xOnZ9ZAFg
         +lWhOQwAqBNw0X8RM/tv/VrdBpKz2l2/wCm3RcsQDlts1cW3AuF+zrZOoBr0W5l/CjCA
         KCcZ+Zdf0SfyjBrD3Gsac0htOeUQGeGl4VVVHPUqTjcqW3TzVShSgwdjuWmBAvTHwLSj
         LCe+pL9x+myE995romvXaWftDbNEu9elao9naS8gALOvH0MtXE0sQ9r5Owv5yFpzafQd
         V6SGzoG1IRd8/Jpq4Rd+2lwhZKVZM2eDrdDoE0dvsb/tWrjjCcLqZIHq5c11CABJppJe
         68ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973519; x=1742578319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WZK4IDfbpcoj/UHXYNBc9hj61CH/qnmJNHrSERoWz24=;
        b=AG5UeLfHubMfSValEykjBqrHqi6/oY5o09fMDsovhqKzSmIPc06zAXMm81XnDwUCMa
         gAp5zJKWBaTH8B+vTqY/1avburbyXOxsi83/n9aclk9kpn6OVwVNfQlSgGZRruP8xCoS
         K3ri0d/t4b4o6M4bodTDxRu9COovLmTJjCyKGvzhQ8B9qfmXsyqNbJ5lxIXktnb9Shor
         7PMgtwpt3j3leJj+Qv8H1kCdcU11OKK82I9BevNhVZl5eNQ+Re+hxEjGbWkxFKXLRFsH
         0c/RI19HZKmnUQl6fWRJjO3ikVbkR+3StkwSZd/m4cHRNNkWQBBAtYQVdoC+qVCdGUAU
         D0eg==
X-Forwarded-Encrypted: i=1; AJvYcCUb/mT/vPfzca3JL9zWBnfj3SwPIKQ3d591DKNNQL9tIAJp5JaFBnNhtLShSeN5Z1d6Bzg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9gHtRxoSFQpgR6nFBlyoLvqhjcJQnVeKz0o8oiRedtedxKmGf
	gzlT2NXsZXPYRzLhdJElu7FlVsTFczTIMyxcWiOb19fwYuVQ5E/jfYMu1DNesQ0=
X-Gm-Gg: ASbGnctUadMyJhAcGEzJLy3EuRRzVT6hL8uo58Vjn0onUVq84XsCwjuTq73L1c5Ghp8
	slF5gZyZ6jDHs0jCR368S8oG7szo+9r68Ojzau3C3//lLt6FipaZScdGtBBzeYJpWXgEFfpWtqv
	jXYpX9ZiCKYzVCgGrwnKJZp/u/rkuNcuU6DEUE6eYaT6AtJnps4yugiPlLT2vYVphiqWj0xOu11
	Ba+lNznKMJHITRc+/fsj3tjEaJ4yKIXp3I2zSgdOzcgvB8TNz8w+TKFsMbh6H4QggKtf0IpawEd
	Q22S68Gi7oEVzZQ+fsATcYpX9tnd0rhp7NpPrGfgkFl8
X-Google-Smtp-Source: AGHT+IFO+PDwMeyLa4EGhItdNdod3PivHdGg2tuOsQqj5N7me/+24tmsBkj8Jw+BltKmizpirWlssg==
X-Received: by 2002:a05:6a00:b4e:b0:736:533b:f6fa with SMTP id d2e1a72fcca58-737223bf5e7mr3790179b3a.13.1741973518933;
        Fri, 14 Mar 2025 10:31:58 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-af56e9cd03bsm2990529a12.8.2025.03.14.10.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Mar 2025 10:31:58 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Paul Durrant <paul@xen.org>,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-riscv@nongnu.org,
	manos.pitsidianakis@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Anthony PERARD <anthony@xenproject.org>,
	kvm@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Anthony PERARD <anthony.perard@vates.tech>
Subject: [PATCH v5 12/17] hw/xen: add stubs for various functions
Date: Fri, 14 Mar 2025 10:31:34 -0700
Message-Id: <20250314173139.2122904-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
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
Acked-by: Anthony PERARD <anthony.perard@vates.tech>
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


