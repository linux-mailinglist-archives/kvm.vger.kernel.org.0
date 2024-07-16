Return-Path: <kvm+bounces-21705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D19F9326E0
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 14:51:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2F7B41C2232B
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 12:51:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E9F719AD42;
	Tue, 16 Jul 2024 12:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="MBAfCvVK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D59919AA7A
	for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 12:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721134250; cv=none; b=QvGPNDkfdur8YmYglx7D6sHxf2fEQqVmH8Pq8oAh/LUv4qxCi7rEN/vWClbZT4/fkCFq5YYymFPq+fNPtb1qp96kuj8TNlag/urVzg/dnrUWE4BW+xMJ+l8I1OTB/HCZlaZ7uc4I9p661M9Pe80Ev+awjFSZ21GMYH/knReMTxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721134250; c=relaxed/simple;
	bh=EqGzyCtxoh2BYDp1cYbmhStn+reCe3kHll27w99QIDY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lIIj12NE2rQA6EpUDx80S17vkCUfff9s2mOtbvGnWSicAndAWJ/oqOSPToPl+bJfDdgwiY/D29QRfckO2uYSb06mclun5HJKzwARRGGzHjvUdoo449n2Bko4uuQA68BK/O17sadEzZr7/CBkHPyhH5UjAsBb/P/Fgowy9OUjxIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=none smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=MBAfCvVK; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=daynix.com
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-25e3bc751daso2895930fac.3
        for <kvm@vger.kernel.org>; Tue, 16 Jul 2024 05:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1721134248; x=1721739048; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YbyfiuQZejtjAK0lLgqdILt7MjxfEZc/Ti/4KzdWWdc=;
        b=MBAfCvVKS0Wj9RXoT6eSwyb5BrGT7CEzjgVDHX+GMTwXNhuoe8Qjq/JpFxwbhUE2Yv
         PWMgP6kX8WmK9umcggMfI6ZWLitGVSUUEJvoXlEwNLw2H9lZf03p8+vr2pyhg4OITZm+
         K3qR2QpTITWFztevU9HPJ6cFVlYCRjA1E2mPsJjd+E43p01KVkCoojHI2ac+aDfJAU++
         zSBzM7Zr+BUaStlRxULZWxGb8Uvw9Ra4IbyDCt/9o2jPY7wegJUGvEqQVS9CD8rvu6N3
         vE68huaoEcZUhqQRMIwOAMscr5Sg0sJPQbklnw0gkbB00nf3DRDASLI0lOCBPqT+lwd4
         lU2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721134248; x=1721739048;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YbyfiuQZejtjAK0lLgqdILt7MjxfEZc/Ti/4KzdWWdc=;
        b=hE6tiEpdlx1OOAwzvGtCgk6QL+Q+25q9cnhdWZ1kOe1jWe5pXvIqB9uatJnlID4VKP
         z28zCf3UVdSsNTmwCHNfyKUwC7b1WCrl60xKdZHxxQDOYONWDAnzKUrE7njLetgE0jZz
         s20VZIm0QaKg3kboYL3xMa9B8hFBS22E0eC8BlfFXyRkeyBZd5NHPenShQ6C+U/xbttY
         JRzoAHIMhzzG4GfUvMabqioZtww5ItgebhajwMq0meCRbqHlzmLFRgC/HiqN+oleZ9FS
         GeRCpQGfoDZb09hdNKA7KSqo5um46tRvad+i3fa53xMP/s7mj+79/SeoOWPdCIp1aEP4
         6pWw==
X-Forwarded-Encrypted: i=1; AJvYcCXm4iuk/V3+jsYxyYpYi/SSXyuWFl0RQ8649yxUJW+L9qIOjo8ei+FG6ltaGyj9JaFdbF3tC13HsKP80CpIaPq8huP/
X-Gm-Message-State: AOJu0YyLPOWwexvKn6d+IgcyShAKok00A04z6EOJSV1nCNrIa682XZM+
	cX/KLIsnC4cx7cm4u5pcXkOkdLyMSgWrzKA6dn1sU+Xsqqy/KoxIkDd+65TNBRc=
X-Google-Smtp-Source: AGHT+IGFBBm3xGktf8NTZcTnM8+UpM0LHi+BQkpIUqXaBQ9UZUEQ6ylj8rrem6a9LAOE3XQbO9WocA==
X-Received: by 2002:a05:6871:29d:b0:260:3bdb:93a6 with SMTP id 586e51a60fabf-260ba823174mr1786700fac.46.1721134248404;
        Tue, 16 Jul 2024 05:50:48 -0700 (PDT)
Received: from localhost ([157.82.202.230])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-78e32b6bbb7sm4683985a12.17.2024.07.16.05.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Jul 2024 05:50:48 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Tue, 16 Jul 2024 21:50:30 +0900
Subject: [PATCH v3 1/5] tests/arm-cpu-features: Do not assume PMU
 availability
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20240716-pmu-v3-1-8c7c1858a227@daynix.com>
References: <20240716-pmu-v3-0-8c7c1858a227@daynix.com>
In-Reply-To: <20240716-pmu-v3-0-8c7c1858a227@daynix.com>
To: Peter Maydell <peter.maydell@linaro.org>, 
 Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org, 
 Akihiko Odaki <akihiko.odaki@daynix.com>, 
 =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
X-Mailer: b4 0.14-dev-fd6e3

Asahi Linux supports KVM but lacks PMU support.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
Reviewed-by: Philippe Mathieu-Daudé <philmd@linaro.org>
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


