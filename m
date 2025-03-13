Return-Path: <kvm+bounces-40961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 097EDA5FC0F
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:40:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD4EA189350A
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:40:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F3526A1A4;
	Thu, 13 Mar 2025 16:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ziH/S451"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAF126A0FD
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741883967; cv=none; b=q8QBOsp1WjMJ/BzBCCMIj6/H4v8Q2D0nVqQXhvYh2q+1Ken+LwR0u7wYHJapKQMRS33PmVLcNp0NdiyZImPgRHvDbczDPRNChxOiNABdlRAplOCGp1tppRRLhqZ/62hWmY9qLNxv7LkQTWbulu5PrH6LmlbgpuDovQuFt9R+M9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741883967; c=relaxed/simple;
	bh=2BGYv29y1gAuWbOxLdSmdLhzjdPFXu3kgq+kOyRsd60=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SvqXaWRId4G0ADpXjboiUm/Omf73u6qUnl6k8+fPor8HZuSQTM4eX82CAE42T5aBaASCyHlulOh5tyFx+cVjc+8lT2CBF5gdT49txYqx54OCoSRPur9UkWaIUygy4yv/sMzhxHgvhp62tnvs61gV2j7J3PhehHeAVUMjm1/AkNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ziH/S451; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-225d66a4839so9569535ad.1
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741883965; x=1742488765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YZcwoIie6BtZ5Bqo8BYW0CKBTK95znA0iA8YHmiy7v4=;
        b=ziH/S4518cyxcO9fuZDeDpIErxYCxfwNT9HBRz3b/S34YdyKfIGkJ1Z3JVHpO/bHC7
         myyLwmUHqMO6B0m4D3a/lbmO2ETs1DyfAaDd+sMPrDBO3dlYozfHjNn+eZ4fqOfZjWrw
         e86xOezwNpG7G5UIFiS/jBgwtYxuWRw8xA9LzMKf+saQNGps77NRZKx47mzu4Ojac60W
         8mSqTY3+ur6UgogqmDpabJbOrcdQu5ygx9aMOptM56UEKY4rVScrBp5tvVyNHx7jS6Oz
         b+Ud+l85C4VrJmZMC0luW5Y0tbO04cF/ROQrEEH7tH3CxjgG59kEhb0xqOW8K3eC5I3E
         y+Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741883965; x=1742488765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YZcwoIie6BtZ5Bqo8BYW0CKBTK95znA0iA8YHmiy7v4=;
        b=ji37XLtCaEhtEqLv0EZJhNOvyovfcO1PseHSlpM+bzKG2JFgOwKN/iWe1zA3J5B1bn
         c/CYYcOnaKcYxUJPg85QT9WrAb4h2/lobaHKWju9AzWXjqmOUTcLzt4aYCk7jXqfVH0j
         AseyoMwA2F0GKdmzWUtRIcT7MMaXdZzU64Gg63WCIIpNBxQNFwxr/q/smSdut61lD+/b
         g9CyLz5fciBhO/cI1mDMYu8q1D1bmMPRr8/gxY694vgdZYAalcBKTcDMhyxstAaFJgq8
         d4PUjsHYXUW+8k9/n+MeB+nr3p2/o+N6EnKzX1a9N5yqhvzuA37F6N1LGJgp+LFCbzNm
         e78A==
X-Forwarded-Encrypted: i=1; AJvYcCUDki9sG+1D1vJQQgFEu9qciCq7+3k+t1QzCU902mlJhsrwm/+3OX5me/b/CdHfiVkmcZo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwcGbtOH+Rngs8HCcSreRFe+D3AAtRQMiKhYyoQmNOZalf9YJ3y
	y9MnDJcit4/vWELe49aBofTaX4Z06PXwcqhNGHW9eSAWLKpvw35baWLMYjN6BZ8=
X-Gm-Gg: ASbGncvFZodHLf0ciEMerW8qfC+oEI0brCrnhk3DDd4k3ylxTiJWaF5KjJN6si/C2UV
	GvfK/7uqsNNG63dJF34fhMgeGAo6YflebQenrTQOCzrZLKz3zBOKxbhHBn8XIFn5FdZUvBxQ+Tp
	9YVbix6oQ+377oJM2YG3LKa/vy03lUImFNOAPv38qTtXK9IbgLj2hMvh81UpiOz7g43pCBgpuMR
	1OWb3lkVqJBLipcThKGdyuWjTmeVOPegWlWfELvXifiluJTWPu+oThfJqLLTPlQQbZudMa6knrA
	Zet1O99f3KBpi2DZKXXA69Xz+vaAU16P+/UsovhVOuNq
X-Google-Smtp-Source: AGHT+IFiKP7Cv0cYdqEMV+MhGWK6VMcS4hFI6ysthSkCfjorg7zJkJOo9IS+PhkZP2SVMZhjn6kprA==
X-Received: by 2002:a17:90b:3502:b0:2fa:21d3:4332 with SMTP id 98e67ed59e1d1-30135f4d091mr4406058a91.12.1741883965232;
        Thu, 13 Mar 2025 09:39:25 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30119265938sm4020084a91.39.2025.03.13.09.39.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Mar 2025 09:39:24 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	xen-devel@lists.xenproject.org,
	Peter Xu <peterx@redhat.com>,
	alex.bennee@linaro.org,
	manos.pitsidianakis@linaro.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-ppc@nongnu.org,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Weiwei Li <liwei1518@gmail.com>,
	qemu-riscv@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v4 12/17] hw/xen: add stubs for various functions
Date: Thu, 13 Mar 2025 09:38:58 -0700
Message-Id: <20250313163903.1738581-13-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
References: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
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


