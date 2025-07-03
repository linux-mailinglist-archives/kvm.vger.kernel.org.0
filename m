Return-Path: <kvm+bounces-51426-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C51A2AF7124
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:58:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA4021C8154A
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:58:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 23DAD2E3382;
	Thu,  3 Jul 2025 10:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uFIIMSRU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967242DE70E
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540268; cv=none; b=tbzXCK3mu80T9iORCJxwk3id4aAwpKIHXblSEcmN905J9F+XRxqWo7SBfenZ3OaTQNGUtXe+lLT/HIpwG5CIngZsk7kJQImCSpt28TaYeY/Uzcia0r47Yx6+aZfRo9HTaCG2+R2LbDKmJcx643kNmEiNqVyPHet+i/Oy4opbUnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540268; c=relaxed/simple;
	bh=rxxmSz/UGDTwdiMe9kMe6KsavaA1ML1IxAxbYaq04pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DBQ6RnfMk5DoqxyCEYhcYXtnJ0P4/wbrFz+BNW0hwAYiJdCb67/WtgQgqmnCpKF4ytWC/xj8UW4jlTaBWG56+uNC9eaO4LsNoTYhkz31IQr41rc8PUHDizcOWVzewMHtS88pC96OiZZ9+uK4LwCt9XizXF78HWLx1Qjoqojl/ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uFIIMSRU; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-450cf0120cdso55533765e9.2
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540265; x=1752145065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BFzHeo6jxPUlGKhVCEILVY0U1JHXp5cH2Es3I4orHXM=;
        b=uFIIMSRU/N+AMh79559AXUVJvvTaQUzuMqKAgaTjrUjgLCqEn+21FxuqkE1RdsdzbR
         TcSDuDTMIygvBZbMX9VVtlALisO3Vmy+4hp0gC1EpymL20da/wrbwblnY6mNR9JzhxlY
         KmaGgwI6d8RFYMXrTh16htk9FRaELMMC5VvQSn95khG2AhHsU3qy5hXnFf6eVtjc4EmA
         Mi4a2OM9miogxKK37sGi2+Dp4hEwjfabW8pqvDWHvEXd6PBSiXUz0OEyHGYEI1cr+8zv
         uJWLbdWFPcFKvx8yKUJF9iLgTr+IQWc7N96t4gdAIaa2d2EwrIfnCEgjbJXxlQ7J/5FX
         p88g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540265; x=1752145065;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BFzHeo6jxPUlGKhVCEILVY0U1JHXp5cH2Es3I4orHXM=;
        b=u9vk/+d7fOL/QyDSiumPFNnCNhqkYuI8XlPGlBUqNoq5iwU30zu9PoJB748KFeaUxn
         crBGyGJJbce8h/xY5htPpKgWlwGS+zpPBY2nNI3W74bPIIPQUH7DL36BsNqi6QEB9HZv
         dzetm43iRzUnex08tg26PM9JeV+DABGhQZ7Z3Mcnreala8lbl3mtzdqBxgCY3W7fbi+W
         OiTZRbs330x5o6QyY1NR2O9domC4kXTP+s9gl26RgJqZyKAC+Nb1V4bSXg0wzTFTfBNV
         qpBvEKkJwL7h2qQ5MXHoBAxBpnmu52H5UvE6ZzXyWfulG7qZGSeihwpEKv+jarcSuQS/
         J1Og==
X-Forwarded-Encrypted: i=1; AJvYcCUAPhQzgpU1my87tBqNWIzQuS4Ag0Wu5AKm94/zDtEuGDvaumsEQbWSpHTiSgNywWB0aUk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVWojaH5EoFuqSdWvB1/PiAOxaT0s/rxMnFkEnmsB0EHa/j1my
	C+6ntDxZaamK3A1ceWysziomKAP8t2qQpnVighC1ybH5OTM5ZxIO2vs0OCZA0YB2QiI=
X-Gm-Gg: ASbGncuvSZFuwzbqiqTNT1chZn1fNl+KsRmxGn5kfPU6wUMYjPKCr8YSk1AHVvp29ui
	a5HoXgUkdCJZ3NxJsG8xbVCcq23Y0HASuKTTAPUTN3z4FkFLw9HIT9cgvoFc32gn8GwmaT8gKDD
	dsoaxW3QW194eY78U7LjigDhp5Y/0qLKtusXxOTO66awJpJQXAbvez5AIzoKd//jQI2qFfPvy74
	EAiLCf61xFoEoL06CHqZW8dkvBfs7JBPXMdHli1fcksmAfZAhrj42Vsl2442m305tQpCIPsaRlf
	AjrkK605nUHMeY42FtpgMYUJPgZAVHrjaG9B0UM/yVK1Kx/Dch4eIbpiIn4TIzyxlCZYLwh+Sct
	xgGq0fo2lsPI=
X-Google-Smtp-Source: AGHT+IEAxgYkber2BoZbpxWHNYmrPhoKyyUHP0ytzfvoDQ3IUz0aX+omL8kQvDgtuCyaaQmE9nYalg==
X-Received: by 2002:a05:6000:1a8a:b0:3a6:e1e7:2a88 with SMTP id ffacd0b85a97d-3b2019b825dmr5635776f8f.57.1751540264834;
        Thu, 03 Jul 2025 03:57:44 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b32fb30c05sm1788634f8f.44.2025.07.03.03.57.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:57:44 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Laurent Vivier <lvivier@redhat.com>
Subject: [PATCH v5 23/69] accel/tcg: Remove 'info opcount' and @x-query-opcount
Date: Thu,  3 Jul 2025 12:54:49 +0200
Message-ID: <20250703105540.67664-24-philmd@linaro.org>
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

Since commit 1b65b4f54c7 ("accel/tcg: remove CONFIG_PROFILER",
released with QEMU v8.1.0) we get pointless output:

  (qemu) info opcount
  [TCG profiler not compiled]

Remove that unstable and unuseful command.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 qapi/machine.json          | 18 ------------------
 accel/tcg/monitor.c        | 21 ---------------------
 tests/qtest/qmp-cmd-test.c |  1 -
 hmp-commands-info.hx       | 14 --------------
 4 files changed, 54 deletions(-)

diff --git a/qapi/machine.json b/qapi/machine.json
index d5bbb5e367e..acf6610efa5 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -1764,24 +1764,6 @@
   'returns': 'HumanReadableText',
   'features': [ 'unstable' ] }
 
-##
-# @x-query-opcount:
-#
-# Query TCG opcode counters
-#
-# Features:
-#
-# @unstable: This command is meant for debugging.
-#
-# Returns: TCG opcode counters
-#
-# Since: 6.2
-##
-{ 'command': 'x-query-opcount',
-  'returns': 'HumanReadableText',
-  'if': 'CONFIG_TCG',
-  'features': [ 'unstable' ] }
-
 ##
 # @x-query-ramblock:
 #
diff --git a/accel/tcg/monitor.c b/accel/tcg/monitor.c
index 1c182b6bfb5..7c686226b21 100644
--- a/accel/tcg/monitor.c
+++ b/accel/tcg/monitor.c
@@ -215,30 +215,9 @@ HumanReadableText *qmp_x_query_jit(Error **errp)
     return human_readable_text_from_str(buf);
 }
 
-static void tcg_dump_op_count(GString *buf)
-{
-    g_string_append_printf(buf, "[TCG profiler not compiled]\n");
-}
-
-HumanReadableText *qmp_x_query_opcount(Error **errp)
-{
-    g_autoptr(GString) buf = g_string_new("");
-
-    if (!tcg_enabled()) {
-        error_setg(errp,
-                   "Opcode count information is only available with accel=tcg");
-        return NULL;
-    }
-
-    tcg_dump_op_count(buf);
-
-    return human_readable_text_from_str(buf);
-}
-
 static void hmp_tcg_register(void)
 {
     monitor_register_hmp_info_hrt("jit", qmp_x_query_jit);
-    monitor_register_hmp_info_hrt("opcount", qmp_x_query_opcount);
 }
 
 type_init(hmp_tcg_register);
diff --git a/tests/qtest/qmp-cmd-test.c b/tests/qtest/qmp-cmd-test.c
index 040d042810b..cf718761861 100644
--- a/tests/qtest/qmp-cmd-test.c
+++ b/tests/qtest/qmp-cmd-test.c
@@ -51,7 +51,6 @@ static int query_error_class(const char *cmd)
         { "x-query-usb", ERROR_CLASS_GENERIC_ERROR },
         /* Only valid with accel=tcg */
         { "x-query-jit", ERROR_CLASS_GENERIC_ERROR },
-        { "x-query-opcount", ERROR_CLASS_GENERIC_ERROR },
         { "xen-event-list", ERROR_CLASS_GENERIC_ERROR },
         { NULL, -1 }
     };
diff --git a/hmp-commands-info.hx b/hmp-commands-info.hx
index 639a450ee51..d7979222752 100644
--- a/hmp-commands-info.hx
+++ b/hmp-commands-info.hx
@@ -256,20 +256,6 @@ SRST
     Show dynamic compiler info.
 ERST
 
-#if defined(CONFIG_TCG)
-    {
-        .name       = "opcount",
-        .args_type  = "",
-        .params     = "",
-        .help       = "show dynamic compiler opcode counters",
-    },
-#endif
-
-SRST
-  ``info opcount``
-    Show dynamic compiler opcode counters
-ERST
-
     {
         .name       = "sync-profile",
         .args_type  = "mean:-m,no_coalesce:-n,max:i?",
-- 
2.49.0


