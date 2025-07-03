Return-Path: <kvm+bounces-51429-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CB5DAF712A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:58:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 433A44A30D4
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:58:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613942E4242;
	Thu,  3 Jul 2025 10:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qcA1V8+x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22C72E3B1A
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540283; cv=none; b=hp0NFslnoRZA2zmjgqAfgfgckwDTQhXCqnxsEp2MkauNPOfo21wSeeo5HFmEhP5X2uq7V+7gluncUCr53cDHMk9ornXDM55PCdfCqg//Mp5lodiN4nGl8wzQ+XUDKs7Fv+mw832P2hYTAJy24FaMNqoj5hC9zxzJOoij87lM4As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540283; c=relaxed/simple;
	bh=XSHZofTH7tyEzqnpd9gF+UrZwDrF3YffWWkAiBSejxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HuCgyKQNRbMGr9Wxl/pINobw36ACWDansrZUKbqevBkXKNPRNs9YYuffer7Cw/4fSHbxWvfXr8UB4VBMxr80Cwgqex/J47h/FJFtQl3dy6j6+SCMQiBeJS/SvvWDZY9bm97TitH7wNeMQ9VP/9795LXZVTtdtpVNkPBsVqsVI9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qcA1V8+x; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-450cfb790f7so66295895e9.0
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540280; x=1752145080; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JdpUA+n17c1R3e2qTbyN3iueYfohDJviDhKsKtUO7c4=;
        b=qcA1V8+x/pIVWQ9sfFKATr9tnkbRSauJ42ivEHJJtZCkm1aPxSN7k5LkiAmFa2DWqm
         2x7Ct+MWrmHzhQOQ1GQSOXqC6VzrT085sFj4/5rh4zHJyMqp1QQwesUXVrOyGdnv81Xy
         0ypUxWtKdo571ICxuwDOp0d7+CBlTwakQw3b2QuiaDpuhjOTWzcqmUO0XBm02ZZc8UkO
         agSk3l5r2VnvldI3JpaxYpTQk4XqNJesHiK2BfNZYsG7B+uKhyetc9Hu/AWhljtoeLDS
         +ft+xs4vzk8HeiaZyAslgLPvqmSBhTAoax9eYOS3THsJuIVVMcxfbbNuB3roFZxLZllI
         KEiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540280; x=1752145080;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JdpUA+n17c1R3e2qTbyN3iueYfohDJviDhKsKtUO7c4=;
        b=TI9aCDNedWlym98fuSXMTMm9R8tTNuUrTOCP6kIP7ie5AuMoQRwS5r4vtjm6JPe76C
         ROpGfNve3HQHdo5WVWJobp5liD1Gh9fxrNlEi0xH11Hd6J2eIROaDrfdyv6oI9ljbJ6m
         6NpTL6y+LqjlAUmqyPAAVbHazExZ0b72dOE96lBKBxGgnkaq9eRZIO6HXB5EJgIG2oYe
         EYOXkhZgMfZsYVwFulh6R9hqNC6gshURo15f4ETKPLF9+QKz1+pTDOe38Y265B3XugXy
         uOPrOnXwWQQ36c3rykiFrfkhPlKkzNE/CKcl2wzr1LWMLtYX1ASvRRKoj47EdheSHcLz
         I/Kw==
X-Forwarded-Encrypted: i=1; AJvYcCXck/nMjXHt9gqrkZJZ6TpLIRZi9zxp4xoyG83nqkoOiPRsGQ8JLdfo2fUNIiClL/35FbU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyHbyzxzqKELmmJWZM9yrE6QJkExyx2jj4DSVQfbttB0CmwPFxA
	S+7c3a4nrThRjgYvOOEyBiH2dX1JFBBYR4K7LuSu3e1yy/i+lCZILBL/cHwtw71G/zo=
X-Gm-Gg: ASbGnctrxGzLN8Xqnlikq/UOLsLcVLoBF32aXQknhMVOGy6dwsMDZzEls6/0YidpjXs
	TQkEI0dWz3+TFXhKP3mYCiDazAGNdod2CGpxBfC8SjEqzSg90oWtUCeWZMEOlmMr2mwftp91Aq4
	yI4DqDW/1aF33F6KFOfUtgrZipumboivcjDZrO0JF3jHIR/7eTTwjcn6/ams7FM0BKfaLHiF5kS
	ttdhEwAxnxLeoPwOS5ZgRn56GEHqbWRO4AsacUZgRSWAhju/ZnaviIm4Pm7KhrnxPZHGRRYVkhi
	+OF1ImJrgtPo3AS+PQ827xJ9j18a62tXNjhRIqo+MbX4/84GpBfImNwXbEeBNhJgLiwJvGqTjrT
	3TUVgI1fBlDI=
X-Google-Smtp-Source: AGHT+IFYoy2jQHRxcLCpISz8RybYDo93PQPw4aLsWNTWwxU2T9z7OKjWchTrnK4NWLGFuMukr4V3Vw==
X-Received: by 2002:a05:6000:41de:b0:3a5:2949:6c38 with SMTP id ffacd0b85a97d-3b2012033e3mr6067660f8f.52.1751540280194;
        Thu, 03 Jul 2025 03:58:00 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a88c800eaasm18721782f8f.37.2025.07.03.03.57.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:57:59 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 26/69] accel/tcg: Factor tcg_dump_stats() out for re-use
Date: Thu,  3 Jul 2025 12:54:52 +0200
Message-ID: <20250703105540.67664-27-philmd@linaro.org>
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
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 accel/tcg/internal-common.h |  2 ++
 accel/tcg/monitor.c         | 11 ++++++++---
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/accel/tcg/internal-common.h b/accel/tcg/internal-common.h
index 1dbc45dd955..77a3a0684a5 100644
--- a/accel/tcg/internal-common.h
+++ b/accel/tcg/internal-common.h
@@ -139,4 +139,6 @@ G_NORETURN void cpu_io_recompile(CPUState *cpu, uintptr_t retaddr);
 void tb_phys_invalidate(TranslationBlock *tb, tb_page_addr_t page_addr);
 void tb_set_jmp_target(TranslationBlock *tb, int n, uintptr_t addr);
 
+void tcg_dump_stats(GString *buf);
+
 #endif
diff --git a/accel/tcg/monitor.c b/accel/tcg/monitor.c
index 6d9cc11d94c..e7ed7281a4b 100644
--- a/accel/tcg/monitor.c
+++ b/accel/tcg/monitor.c
@@ -200,6 +200,13 @@ static void dump_exec_info(GString *buf)
     tcg_dump_flush_info(buf);
 }
 
+void tcg_dump_stats(GString *buf)
+{
+    dump_accel_info(buf);
+    dump_exec_info(buf);
+    dump_drift_info(buf);
+}
+
 HumanReadableText *qmp_x_query_jit(Error **errp)
 {
     g_autoptr(GString) buf = g_string_new("");
@@ -209,9 +216,7 @@ HumanReadableText *qmp_x_query_jit(Error **errp)
         return NULL;
     }
 
-    dump_accel_info(buf);
-    dump_exec_info(buf);
-    dump_drift_info(buf);
+    tcg_dump_stats(buf);
 
     return human_readable_text_from_str(buf);
 }
-- 
2.49.0


