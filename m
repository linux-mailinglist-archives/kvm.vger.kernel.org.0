Return-Path: <kvm+bounces-40559-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7D5FA58B65
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 06:00:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C988169149
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 05:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 865A41D63D9;
	Mon, 10 Mar 2025 04:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mKK48wqc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4811D5ADE
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 04:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741582747; cv=none; b=W2PpQ2wTZ529Fmj55Ei6lNT4WpMJ8+4GmE4gtm5+gFXbQAqwpTL2J3y6kfyVObH/vQ4zdFj3JVaxTEvqFMkQUORChpfM96DWxbMSUeXY+W5MbvdXPn9QRmgkG2hnL9JFum2GGZA46wYUgAzu54b/Rdjn20nwKuMRvOww54d7brs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741582747; c=relaxed/simple;
	bh=ow9vxYsUi3UBMwX4i0Mm+/JHWLFZXDADppKG6z1vgec=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PsRj4E7rifI/TZcOWoVIs++sQg+LTnGE50MGKAaQU7pZFkaQ70bv3ZacJMbQyFUj0WIWx+HJGgjCMNMSgpb2V9w0Pth3X09dG0HhqZiWm2ZlUMj9o86s3RDP56gcduODNiJp4a4XsK1oS+VPxFOFf7qmi+5Afi7CZLFT2YHSYnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mKK48wqc; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-224100e9a5cso67679065ad.2
        for <kvm@vger.kernel.org>; Sun, 09 Mar 2025 21:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741582745; x=1742187545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mz3bAPQKR6fBbshrwXBmzVU3oJFomZ1j01ZC38m+4VY=;
        b=mKK48wqcpIISDtUTTdUdwiaaSWGwr4YIoBulzL2BEEN/EWH9/AsCNHQyTcBiPiRQO+
         FAcsKrKD82jM+SQkMTyUWKoiLKfntMZXrCEgJJ+sQ5goHWG1mleP2q4X8oAoNLaXtr0n
         ZNZO4M7GkAC/iqPgzOzgWnjdIkwVvPdkNW/hwHcfsDK8Ya6/B/DMlGUtonjOgds9+9Wz
         8AaoTLx26Zeh93WKuif4oBrmDuA9jVWg2Y5kLOLK8J+lKSd/PGDfUrs8Fm3zVpWIybEC
         nqYic4oppyUEXZ7VIjUGlEyqtHt44borY/BNSKuaGXonRyS6yupkOC1GFZu5f0x0cK43
         2FHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741582745; x=1742187545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mz3bAPQKR6fBbshrwXBmzVU3oJFomZ1j01ZC38m+4VY=;
        b=Hryt2vIgeWSGbcBqqQ9AJoJ0cMrk/VrNaM5HSq7qfSMoBExfrJ7dvtVaShDnRPPt/L
         LjlgMODVIdBcY6tmrpowbdkOI18LkdXp0YKPxVeqqtYbTwUeUYdjKatfNZ5k9oQnxIAm
         WfxO/DC/da1OLk2wo8ycPth/aQ1G9JBtdXb00KRokPMZSqbs4cPbAoZ70t2rnIGispOY
         DNUPRJfXM3ij2cKQkT43IhR1VAxva3ZvikPwzWyzNzqG4pgWc4pGTYRExEauXwioY/4w
         P1GWC+Ck6Ps87lbEeuAOOrWQ1qzBbzSfrOhMdpeUKYDGKL34jO+eFqPESi69WdU06fEK
         KZgA==
X-Forwarded-Encrypted: i=1; AJvYcCX+GJ6+vRXVaFMvAiGByCQoYeaJw33I0skAyprRhlVvcq+8vy5k+1hjW055DAgc+ZokAnk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxEZvrJSekCw2gbrdGY/fm7YjVUt1z+v6XglHwcwCyFGusYX4Yn
	Bq6rPSACLhtQhjOSqco5KwN2B8to0Fwc9nRiWq4rbOWjNjdK8zGo1C2NUcBUQWA=
X-Gm-Gg: ASbGncvF/WDpxOKDuhM3RDj71Ms5PezPGecStiDXgIuUa0CgL8m/C9s1gFm7vTaRKje
	bG9lqRNB2ZvDb+Qt1wjcUkDMgOVzeWTGZrVqQLKZO0QcohJprQ5bUnL3M5sc7sVaBDMUWmdRqaT
	u+Sa7XEoElmwD5FuV9HwnB1+ipQFjoZudEoWaVSlZJeERp2BVtp9bU0GoR7Un9zC282WXsZ2vIr
	LThgL4i7YeKvlUvRHI/GEX5v7uHgjl1h+BRD1eCfDYAyEONri61AtoYW9pTn6gvLyUyAEadip2s
	jMRL+w3ouj8iPWf0IGiqnwVH4xMoQ+Omih9pU8zxjhQI2p1ckqVEnZ0=
X-Google-Smtp-Source: AGHT+IF05iTMc8yin7+8YVYQSgdEUPUj/50hW5+Z0DK0JGoSuS9iEibUeyOyOMAIIkH5mDIAK7kv9A==
X-Received: by 2002:a05:6a00:2e17:b0:736:3954:d78c with SMTP id d2e1a72fcca58-736aaa1ce42mr17690072b3a.6.1741582745578;
        Sun, 09 Mar 2025 21:59:05 -0700 (PDT)
Received: from pc.. ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-736d2ae318csm1708308b3a.53.2025.03.09.21.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Mar 2025 21:59:05 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org,
	Alistair Francis <alistair.francis@wdc.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	alex.bennee@linaro.org,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	kvm@vger.kernel.org,
	Peter Xu <peterx@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Paul Durrant <paul@xen.org>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Anthony PERARD <anthony@xenproject.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	manos.pitsidianakis@linaro.org,
	qemu-riscv@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 13/16] hw/xen: add stubs for various functions
Date: Sun,  9 Mar 2025 21:58:39 -0700
Message-Id: <20250310045842.2650784-14-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
References: <20250310045842.2650784-1-pierrick.bouvier@linaro.org>
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


