Return-Path: <kvm+bounces-20725-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 073E691CCCC
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 14:51:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 38ABB1C21086
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 12:51:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983B47D417;
	Sat, 29 Jun 2024 12:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="vEi/5Lfd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950422B9BE
	for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 12:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719665463; cv=none; b=J/ezfau3Nc9LLLGZp8GDNsmj+8d0Qu4wI2R5K3hoVDPl1snnj7aoG2R5dQzCPcO1u/W7i5+jyiDCY2cog7e5QxmTzhffhWxYF+T7LVN1byZlwEqJKMq2dwje2laLZX0hyll8yhGHkcRcOx1ZsGVI8zOI7bdQq3LeqZZv3ombITQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719665463; c=relaxed/simple;
	bh=hH0C+hMRrQebClCKrwJVUyAUbkOPif1mOqS4Fo/9xAg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bq19xn2xwtm5ux1a/Scm47t3Rfd40XUfPjaO5N3R3LRTkXJFNIiaCs0UDRH6TsD+knm63UyYKtfI9y7f3XShfY3uxxE6C5Z2T/lOmqCzxOqXalvDdjmGRfVzLeD25Ke8ACQ+cwHVLlyMd7SyPBrhgHnvxCAc2X+47DRfA8by0ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=vEi/5Lfd; arc=none smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3d561d685e7so1026461b6e.1
        for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 05:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1719665460; x=1720270260; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DvpsKqJKseTB8512E3EM/mcg58HxToRdE8EyOPRZHqA=;
        b=vEi/5LfdoVG/qRwmualVJan0xlUsUECTPAeOXzDY/OKW4516YZLQnjtJsKjE3ofFom
         D8RXCGgyJwuaEIJyWZha3SJo2kEPSn2ARosjPeDOUDwq8j/Fks09NawlT+rLyGeVp78O
         U9MzLkGFkPjAUz0jGCfy5JBinqMwaljgQPvDROVSi4PIkAk2jQumdoEm7vQNT0C0voIm
         ftpTZHQlbNe2YoGs2nFO8phsFyYev9vNruFcXIvishE5C5zl80enhSwXHPFU/QcqYWFX
         mq0PChEk03PMhAiUAA4qWwnmignDwXm9iNpWv3g6b/AsB0DrtHOPg8CN4g6A6jFdBp9C
         KPIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719665460; x=1720270260;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DvpsKqJKseTB8512E3EM/mcg58HxToRdE8EyOPRZHqA=;
        b=lRCyf0McRtDKdqEx+/ILlj5KCm6QeUrl0FHPpuoYCYmF+DRbhSb2Apbg0MX9cl+OWj
         DWHHnmdSXKvRhlZwOuoyY77YzUUyMqXonew1r9Dg1WNfwe8VeRyI3FuWu/fYXzvO42gj
         QYl60Q4tFKWP5LqfrElkHJC58CF9TUFCwACWozGrqzuavIfEXJ3YAWnVUs4M/AAhUWJe
         WlW9yg3f415kfNz8GKWIud0Tpmtu/K70UHQujQjgVfBqxKui8AcKZnxmr5QvhuL8CrWz
         BBLLgLgXBW2rPp/0FFuvfwYZpWhxH1AGYTxbvtI5QszYNZGQ+iRrcZuMnbIRxxBjpKU/
         +vYw==
X-Forwarded-Encrypted: i=1; AJvYcCV/Mc4R6qcoxl8q6ToDvE0EBtG2I79ynZsERlzHqdUiyanwwnRTj+ctX5qeAGeiho3CtAdYR8eQheyfsjaDdsMIyMod
X-Gm-Message-State: AOJu0Yx/g2YRoQYpJ8bY5h7dbI7rc6AkurDVjKxjcNbIXMN8RSlKQEfP
	rfKX8TimsNCdm9sT7s4CWYBbGqBY7eoajb4mC9X8RCjEzR+VwFoxtSPktZM+jjU=
X-Google-Smtp-Source: AGHT+IGnFk33QJj7zRJvjq34kT9S5rKVUvKwNykZ5WrLJUb8d4LshvqBoKRYEFxOAjs4b/IKgR0gEg==
X-Received: by 2002:a05:6808:2204:b0:3d1:fc50:1aae with SMTP id 5614622812f47-3d6b2a2f0d4mr1188382b6e.7.1719665460603;
        Sat, 29 Jun 2024 05:51:00 -0700 (PDT)
Received: from localhost ([157.82.204.135])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-708043b7145sm3322714b3a.148.2024.06.29.05.50.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Jun 2024 05:51:00 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 29 Jun 2024 21:50:32 +0900
Subject: [PATCH 1/3] tests/arm-cpu-features: Do not assume PMU availability
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240629-pmu-v1-1-7269123b88a4@daynix.com>
References: <20240629-pmu-v1-0-7269123b88a4@daynix.com>
In-Reply-To: <20240629-pmu-v1-0-7269123b88a4@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.14-dev-fd6e3

Asahi Linux supports KVM but lacks PMU support.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 tests/qtest/arm-cpu-features.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tests/qtest/arm-cpu-features.c b/tests/qtest/arm-cpu-features.c
index 966c65d5c3e4..cfd6f7735354 100644
--- a/tests/qtest/arm-cpu-features.c
+++ b/tests/qtest/arm-cpu-features.c
@@ -509,6 +509,7 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
     assert_set_feature(qts, "host", "kvm-no-adjvtime", false);
 
     if (g_str_equal(qtest_get_arch(), "aarch64")) {
+        bool kvm_supports_pmu;
         bool kvm_supports_steal_time;
         bool kvm_supports_sve;
         char max_name[8], name[8];
@@ -537,11 +538,6 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
 
         assert_has_feature_enabled(qts, "host", "aarch64");
 
-        /* Enabling and disabling pmu should always work. */
-        assert_has_feature_enabled(qts, "host", "pmu");
-        assert_set_feature(qts, "host", "pmu", false);
-        assert_set_feature(qts, "host", "pmu", true);
-
         /*
          * Some features would be enabled by default, but they're disabled
          * because this instance of KVM doesn't support them. Test that the
@@ -551,11 +547,18 @@ static void test_query_cpu_model_expansion_kvm(const void *data)
         assert_has_feature(qts, "host", "sve");
 
         resp = do_query_no_props(qts, "host");
+        kvm_supports_pmu = resp_get_feature(resp, "pmu");
         kvm_supports_steal_time = resp_get_feature(resp, "kvm-steal-time");
         kvm_supports_sve = resp_get_feature(resp, "sve");
         vls = resp_get_sve_vls(resp);
         qobject_unref(resp);
 
+        if (kvm_supports_pmu) {
+            /* If we have pmu then we should be able to toggle it. */
+            assert_set_feature(qts, "host", "pmu", false);
+            assert_set_feature(qts, "host", "pmu", true);
+        }
+
         if (kvm_supports_steal_time) {
             /* If we have steal-time then we should be able to toggle it. */
             assert_set_feature(qts, "host", "kvm-steal-time", false);

-- 
2.45.2


