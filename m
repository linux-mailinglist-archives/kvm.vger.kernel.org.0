Return-Path: <kvm+bounces-51427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B60AF7127
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:58:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F31F517C792
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 584302E3AEB;
	Thu,  3 Jul 2025 10:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y8A03KuN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DEB29B789
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540273; cv=none; b=UDHTnwN3LzUPQSh6E39sc9HRfphhPIea/tBbjZrcjdHpAUc3hhuStp1/sthg2oIquaYuLzkr/w/3P0qLlfe/8kncD6Bb4JxPm4pRTeB2Tg50ImBnPAxvEuHicHaPwgy9snV1x7Ycubil8NqTZArQwjEIud4PdIkIv+/3/h8CS38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540273; c=relaxed/simple;
	bh=fW+b7x2KyzVxSDFDm634cRm5G5wNPZTNrAE0hoFHOSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c3yW8NpHMntVQKXLMglQ9PjIlWOP7FwLsYArZYgyR54CxkcVJt6gaVo0E+xO53qfooMlvrC8GxzdKzkB8LO9ciprpHy58+9bTtCpthxuRrMCzBO7kpXrMSlBXzXqcPvQjVhooucPvWoy4IU/9NhMKMsp6qW9KTDuR/Q4wFT8FoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Y8A03KuN; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4539cd7990cso5156155e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540270; x=1752145070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LpujPKNmLzr2YCI+n9fjeIzsX6AjXIBIk5d4rtXU8jY=;
        b=Y8A03KuNl8uc8WKyNfs3UPhLDP2bYst90cB1qiou9aaBYw1v6uj1PTcw/lDxoddKfZ
         gay05ZA9Tx6tkO6C1GmlMdCXJf2ILT7Ij3AygNEn7Zmtvn0Vfn6GTeGeBhF10oQjSnBy
         SwVQXpLzISMXRarqDh6YXYSrdtVeuQyCsuQ+NkqqbXlMpGX4ChXZqPdh/hGOK3fk6/f/
         nSt+oT+HZDKJoVYHvLQCkLZocgDX/TQiXByul+QpBmai4PtlRlfVWYUDsfZCnWNudOVw
         M4o1a/bUWbQCzeWbE6t8EmVipnm0Dafrm9EMl7fKDHFAkBKnbRzUWd0Z9bByfkDDu0EA
         FOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540270; x=1752145070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LpujPKNmLzr2YCI+n9fjeIzsX6AjXIBIk5d4rtXU8jY=;
        b=gEMeTDk8SCDKTdQd+kpRPWCsyTzws5DnnxfC33CVznP3SHa1G4eVLgKRPeVpFrcNKH
         I9IkJr0jvjD7OkzMSDJBnqKddmGyljraWCxtD8wuYgxnmYHnRBXxdrztt8FOoedp3LmD
         ycWi65lrJR5g1eQdYWvIty5X+06uQgS+oeekx9j3J2s7RWykXYMDUGJ7g98uv6yXqddu
         n/4ekZNH8u+tgji9Rb8FkCxdrbXsnEZGS+NQVUUFS9/rzayaFt51uwhhy9lzL5lwqYlJ
         1/9gtIDXwLnJkBGiTkS7IzMMgY1mvCAHB9G8YyebjX2oum1f5OOl7SsDQbqXfna/YC9G
         UF/Q==
X-Forwarded-Encrypted: i=1; AJvYcCU1MxlhRpQT96UghyplGhfMv+FH9IzFI1U2qRqLkUsGjQ3OxbXlLquWDB3cSrMcajOW3vk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4y4r7rF0O4S4apgBpUg5pCmW/2F2AmrLtTLVd3g/il6oODG4D
	DenM0DlkTFxtWgAuqlDe6YOVJdlxS6j782YKbv9oGy0/Uzlm8Upd+T0GhF8QJYf25Gs=
X-Gm-Gg: ASbGncsnASEPUsoPCzE25QSWqHsO66j0eXXFgMgcBItaqScVZOo08C2L2dBee6uOXM7
	taguVMWxpl+LtEilcxKT2dIpQcnUEV5qsMNXrpwoX1MofMZqIKECybc4VqfScRk/mJ27TscLLC0
	o3Fu672vQO/SMJQyw6eYA2Ho2DssvKsHiZ28FB6CB7zCx9DZQnaokjon1Br4LgyrG3m043feDRm
	/OFhvBpXS/eeXYBY4n8QNHKoUcNq7KPSEcgiuzF1PDO2eilcsaSy94eMAfRLxEGr45xFhYLaby/
	Yb8fmW8pENLlGKQGwTH9WA1WBkbkqnvbM0SfoCD+968DlyeYs7niEa3FKNqy8yxUGA7mFlD/jTH
	lCa7LSPqg/YzpAaMVO3awrA==
X-Google-Smtp-Source: AGHT+IF9IKQZECBZi/S5op3MGZrBBvJrgZce9jUGHoXUct1Tc3R7UnwtXNQQsSeG2xM+tHMugsII/A==
X-Received: by 2002:a05:600c:3b89:b0:453:84a:e8d6 with SMTP id 5b1f17b1804b1-454ab2ecdafmr23671555e9.1.1751540270071;
        Thu, 03 Jul 2025 03:57:50 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a999c8cdsm23658325e9.24.2025.07.03.03.57.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:57:49 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 24/69] accel/tcg: Remove profiler leftover
Date: Thu,  3 Jul 2025 12:54:50 +0200
Message-ID: <20250703105540.67664-25-philmd@linaro.org>
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

TCG profiler was removed in commit 1b65b4f54c7.

Fixes: 1b65b4f54c7 ("accel/tcg: remove CONFIG_PROFILER")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/tcg/monitor.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/accel/tcg/monitor.c b/accel/tcg/monitor.c
index 7c686226b21..344ec500473 100644
--- a/accel/tcg/monitor.c
+++ b/accel/tcg/monitor.c
@@ -141,11 +141,6 @@ static void tlb_flush_counts(size_t *pfull, size_t *ppart, size_t *pelide)
     *pelide = elide;
 }
 
-static void tcg_dump_info(GString *buf)
-{
-    g_string_append_printf(buf, "[TCG profiler not compiled]\n");
-}
-
 static void dump_exec_info(GString *buf)
 {
     struct tb_tree_stats tst = {};
@@ -196,7 +191,6 @@ static void dump_exec_info(GString *buf)
     g_string_append_printf(buf, "TLB full flushes    %zu\n", flush_full);
     g_string_append_printf(buf, "TLB partial flushes %zu\n", flush_part);
     g_string_append_printf(buf, "TLB elided flushes  %zu\n", flush_elide);
-    tcg_dump_info(buf);
 }
 
 HumanReadableText *qmp_x_query_jit(Error **errp)
-- 
2.49.0


