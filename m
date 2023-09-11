Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAC4E79C299
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 04:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbjILCRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Sep 2023 22:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236033AbjILCRm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Sep 2023 22:17:42 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5395710ACF
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 14:27:08 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-52c88a03f99so5928476a12.2
        for <kvm@vger.kernel.org>; Mon, 11 Sep 2023 14:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694467523; x=1695072323; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=krYgPPa35VQ/Pn0yOr01dbPDQetUwcBiBN86SxBA8xI=;
        b=KxFAJZzmn/mYaRYJooHN2w2mx7TUloezXSuIwyeD7OR4rXzbtC1IFkZ6si3hBsphDQ
         l0Ie49dilIsdXfGTHI5hyaO2pEDwOAuHmEkai55Em99xjduA1iqCdcNIVCm/lnTVd4F6
         L62L3PbxQyxxnwzyXnNtB5LIrsPioWIoGlsOO8+tJHGVNPlMA+bI7LS7FrAzLUMbHuje
         HlMib9GsFG6fz5Gp0oizoEBzND6T0cZDM1WfROvgJ6wdSECg1h/LPf4dSTQpht5lQykx
         5D8E6jxD4cdhF7TSaPP9CGEvfqDOqcjn5FAh+YX1qLinkeJlytrj6utJ1deG8RRaNzaI
         9+0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694467523; x=1695072323;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=krYgPPa35VQ/Pn0yOr01dbPDQetUwcBiBN86SxBA8xI=;
        b=AsaQYuBY1fGcITwCRzZA5XKwkl8V58bGvP09mhHHWwOUQs+utENR1jYOgMO0YBJUE8
         knB5oFOaB47FAzFNVclRbi8Qshw/YFiIFN1l14UIKhycdyIMm4YqajEn2fKy0FU48q6E
         ZSSHx8B7/VuOzRfBvfTKyb9Vs8lKzvsrCudM4H2eY+oJP8pKkpVZu4KETliV8WUIziLj
         ZFbzaOvhM+m/9uJ5o1oY3E+plcGq0e9Y5dfOoJVDZ4Py6/brvdm/I5381uVCECj2HOwR
         CHQsx/sgtJH3pU04IPDo/B+am0NMg2GiZWDEp+ZyOpyEyj4kTHLZYu5olgBP3jc8fIy/
         Dw3w==
X-Gm-Message-State: AOJu0YzECBXlmdh/cj34Kb+yZqPE70I+msqeSWhiZRrOQ02U39p7yrUB
        VSMJNWupi/+KGJWJqciGNGe69fWnyglOEkMMyYw=
X-Google-Smtp-Source: AGHT+IFb5xqfZhu6crzjkbBsTvKTmhmHOZhghmVtnzEZLh0+fZEAmQHgX4ItZFeAc78+suXTk4fGFg==
X-Received: by 2002:a17:906:749b:b0:9a5:852f:10bd with SMTP id e27-20020a170906749b00b009a5852f10bdmr8629126ejl.62.1694466807044;
        Mon, 11 Sep 2023 14:13:27 -0700 (PDT)
Received: from m1x-phil.lan (tfy62-h01-176-171-221-76.dsl.sta.abo.bbox.fr. [176.171.221.76])
        by smtp.gmail.com with ESMTPSA id gt34-20020a1709072da200b009ad8796a6aesm33004ejc.56.2023.09.11.14.13.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 11 Sep 2023 14:13:26 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v4 1/3] target/i386: Check kvm_hyperv_expand_features() return value
Date:   Mon, 11 Sep 2023 23:13:15 +0200
Message-ID: <20230911211317.28773-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911211317.28773-1-philmd@linaro.org>
References: <20230911211317.28773-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move kvm_hyperv_expand_features() call earlier (this will simplify
reviewing the next commit) and check its return value, since it can
fail.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/cpu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 24ee67b42d..760428d4dc 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7107,6 +7107,10 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
         }
     }
 
+    if (kvm_enabled() && !kvm_hyperv_expand_features(cpu, errp)) {
+        return;
+    }
+
     /* Set cpuid_*level* based on cpuid_min_*level, if not explicitly set */
     if (env->cpuid_level_func7 == UINT32_MAX) {
         env->cpuid_level_func7 = env->cpuid_min_level_func7;
@@ -7120,10 +7124,6 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
     if (env->cpuid_xlevel2 == UINT32_MAX) {
         env->cpuid_xlevel2 = env->cpuid_min_xlevel2;
     }
-
-    if (kvm_enabled()) {
-        kvm_hyperv_expand_features(cpu, errp);
-    }
 }
 
 /*
-- 
2.41.0

