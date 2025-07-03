Return-Path: <kvm+bounces-51428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E75BAF7129
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:58:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B39D917F196
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 608F62E3B01;
	Thu,  3 Jul 2025 10:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BXclq9uA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E0A2E3AE1
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540278; cv=none; b=uNfXyExLH+/QRSsNU5s465BDLibznMe4ZVwXKS3Nnbw6SgXjjHqfyEqvNL+Ky9c9IC3kqOt0UV72gDTOYf6jfhEDzu0+G7Fwpi5ng9+3bgIXXyfqx0w4Q72yaOyAtFtSMev1IOxgbx76bqUCsx3ucZgBSQuDN6dkRC/kpwIslDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540278; c=relaxed/simple;
	bh=2OUtf0xFlE/XSMD0KwkFHWdvSCKdxbEhtq/Z+xr5luI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h3/scRuDn4gQ9FVpU59PgwaVPNjLZuqfW0yZAMaCXoK6/OksQrb6VOFgIdK+r5FVdb+9Pd3MAeLrZm/DiskF2mR6WmcjpiXTsJKOcfWZsd76xyC/xyLvD24SHRqjM6iJdPpbi+ffqdp2I/esAElVJSNatCoRs+Qw3v+oqcb3wQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BXclq9uA; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-454ac069223so2977555e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540275; x=1752145075; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KA0b8Mx/diMOpz5eVRAgzHisGcdWtT3pud+mD+Gv0yw=;
        b=BXclq9uAV2KRXWFbsSGqdSWuAeDmaImkSJ+kRE+o+Iwm+2tkFfbLTDxfovBHZ2r419
         w8KNOzUx5+lc6z6aZBD6WKv3aP6I5e/fIS2ivdprtgPEZIt2tJMF207/tHiP71/YBP8z
         bpp3F72DkRvKKfrD5orhY7kCyFs+zLensWNVlAk6PKnwTwNlvJg0tgkaNX+C9+mfNKwi
         X8W8j0y3dWIPWNztfI4sgCIPCtTqhmSHhHhe0cNE13Un5LtCPsCtPF/rg7GlJVjsuWUs
         m/FIhIYmdyxQwwt/IS5MvX++15M5n1V+lVJnBOy5Seny2yS+yIBBn4VTtop0w5vo52ms
         ijmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540275; x=1752145075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KA0b8Mx/diMOpz5eVRAgzHisGcdWtT3pud+mD+Gv0yw=;
        b=Y7w5pUYBSV/RjEQ29PBYSKcslik3+VGmU+F1SDQEvXbA7/4VMy0qm2QQOedCDu6/PU
         ntDgX7FkxovBpISoxhVkZ1giYgRfuGd//4aO1YQ8w2gltnf9Mkjlnexh2xvqrfY4L6I5
         BOJqpD81VF9utaZgVlW3QTou9KxQkoOxmVNzftoYIJuW1RvFa2bAf8IovD5tDPtUqOzW
         xnwvOQ8cMlJ05Sga6SrrXCRPoXz15kMR2oWhgU5X3g8TjMfXAqcpNfeTtY3+gDohwGnR
         xqyhbfg72FLYBbm6uID2s+JWZP4xRGeu9zQz6iPBqQ7vP5a8a+0ygP96XDM7B7iGdYMs
         ST3g==
X-Forwarded-Encrypted: i=1; AJvYcCVR0dcDhrIlbMBfeK9a0EbBq7SLhaXaktfjFp2ctzRR7i/612qjpx+4Sgkh/DQmexU5ejc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjJXflC90bWlgarx7aJp3KqtFUaaPXe6ztU9pycdI7yBO7DjPQ
	y1styQ7jHcAcuU4wQzpbtY9tR/NumtzsEjRhikGpjC404IN0R3D97HV/hMB2KRf5UZk=
X-Gm-Gg: ASbGnctV7fqm9ahhPm8jS2ez7al2uDGYj4ltaVzj5KQFG1ad3ZQ59WuipqtDWTbo+w3
	LHrl6ADwdc3abRX40XBG9F8gWE4fLQhNO4o+0c+rXIXbnBRxi0YM3x30umKDPNCFbc6tIT8gpfn
	mGyQvB4rwYel52DyT7wYBIbzGTs5KNkpXpvsMmM/ty83ajziyiVHvHFsM6V1NJi56O24HweF82d
	m0V2nLH+2Lv+Imde6TiDigSsuRt5dJzdAhi4Uc9No5Phk9lMHIY6nSw//JiaBskfDTjCXk4B67s
	N4E+GR+Wca3N6v7xTwipXcgOc+gaMmCniwbCTou6LAEdmkBmL9unbghmBP3kDodlsYMtICm1lSU
	nXYkJOa5Bo3E=
X-Google-Smtp-Source: AGHT+IF1BqFbX6Smxb354kb502BZiBNMi8R4AvGG4ddbQJ0e2Zfnpsx8TFJQRhgqCASJoYZJnBu/tA==
X-Received: by 2002:a05:6000:40dd:b0:3a4:e1f5:41f4 with SMTP id ffacd0b85a97d-3b344322977mr2374295f8f.17.1751540275136;
        Thu, 03 Jul 2025 03:57:55 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a997b492sm23522235e9.13.2025.07.03.03.57.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:57:54 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 25/69] accel/tcg: Factor tcg_dump_flush_info() out
Date: Thu,  3 Jul 2025 12:54:51 +0200
Message-ID: <20250703105540.67664-26-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 accel/tcg/monitor.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/accel/tcg/monitor.c b/accel/tcg/monitor.c
index 344ec500473..6d9cc11d94c 100644
--- a/accel/tcg/monitor.c
+++ b/accel/tcg/monitor.c
@@ -141,11 +141,26 @@ static void tlb_flush_counts(size_t *pfull, size_t *ppart, size_t *pelide)
     *pelide = elide;
 }
 
+static void tcg_dump_flush_info(GString *buf)
+{
+    size_t flush_full, flush_part, flush_elide;
+
+    g_string_append_printf(buf, "TB flush count      %u\n",
+                           qatomic_read(&tb_ctx.tb_flush_count));
+    g_string_append_printf(buf, "TB invalidate count %u\n",
+                           qatomic_read(&tb_ctx.tb_phys_invalidate_count));
+
+    tlb_flush_counts(&flush_full, &flush_part, &flush_elide);
+    g_string_append_printf(buf, "TLB full flushes    %zu\n", flush_full);
+    g_string_append_printf(buf, "TLB partial flushes %zu\n", flush_part);
+    g_string_append_printf(buf, "TLB elided flushes  %zu\n", flush_elide);
+}
+
 static void dump_exec_info(GString *buf)
 {
     struct tb_tree_stats tst = {};
     struct qht_stats hst;
-    size_t nb_tbs, flush_full, flush_part, flush_elide;
+    size_t nb_tbs;
 
     tcg_tb_foreach(tb_tree_stats_iter, &tst);
     nb_tbs = tst.nb_tbs;
@@ -182,15 +197,7 @@ static void dump_exec_info(GString *buf)
     qht_statistics_destroy(&hst);
 
     g_string_append_printf(buf, "\nStatistics:\n");
-    g_string_append_printf(buf, "TB flush count      %u\n",
-                           qatomic_read(&tb_ctx.tb_flush_count));
-    g_string_append_printf(buf, "TB invalidate count %u\n",
-                           qatomic_read(&tb_ctx.tb_phys_invalidate_count));
-
-    tlb_flush_counts(&flush_full, &flush_part, &flush_elide);
-    g_string_append_printf(buf, "TLB full flushes    %zu\n", flush_full);
-    g_string_append_printf(buf, "TLB partial flushes %zu\n", flush_part);
-    g_string_append_printf(buf, "TLB elided flushes  %zu\n", flush_elide);
+    tcg_dump_flush_info(buf);
 }
 
 HumanReadableText *qmp_x_query_jit(Error **errp)
-- 
2.49.0


