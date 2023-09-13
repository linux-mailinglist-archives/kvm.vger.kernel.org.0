Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6371079E3BC
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 11:30:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239190AbjIMJao (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 05:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239011AbjIMJan (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 05:30:43 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0807319AF
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:30:39 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-402cc6b8bedso74613815e9.1
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694597437; x=1695202237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Qlz4UlYziPNq8F2NThvhMEsqE2XcvVN84mcny9xQ0s=;
        b=zcjb62H4DVS0SdX3uTes0QRgQY088CCPBq9drDHDWweC35BFgWw9NpPUmVRcHOh9iC
         JdY0Proq+D+1mGBYecRAlcrh8RaHXWjv1AvwrP58GGHb6/I/6gqtSO8B8dNArqCEKs5Q
         bZUgGWLgejtRPSZ0LHlBWeuW+3QryXNLbGNSMHSCEYrOzE9rbNQJENfY2RdlpjNspP1p
         eq5pIxhjQJdpzfT7PImtSdwF7duiC+y6dOMDXZ5Cp7lqGhmJ0vKvw9iMAxS8RLX5p7/T
         Lrb5MYCOUNTM4IS0g/4IkHOQEhEeL0bS51GGTUjP4sXCUNpWlFYXO17ilKtfd6R0BITt
         bNXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694597437; x=1695202237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Qlz4UlYziPNq8F2NThvhMEsqE2XcvVN84mcny9xQ0s=;
        b=hvd2wE2eN77nGm9pouNi0PkP0wHAr2ACld4t61lehpB+3Rz2ay4wXeKnt10iYF8azH
         TguV9XYoJQKF/ASnzjtqJ08Jq4PIQvjdVUUSMtVO0NyWaCkNUpUCar2YJSWeKukSrYdO
         gTm3bU4krWmagydUTwCIR52bAtUvqHiZb7Mpcih2A6TI2md4/PkKPg6IYoS6r91QKCLG
         Up0oawHAQ1rKffpv8dQStEmNJAEzNYBRewsN5VVdNa/dtjsu76rJRvG4mRyZWusll9vl
         XwJ2oVEl5bPiTO685iEXIxAhx1m5Yx3ERHhD/pFsiBYrWfwgpEYyNlGc71P0QDvqkD2L
         sVfw==
X-Gm-Message-State: AOJu0YxuHWZAFQ9ILq5+ll3tbLyZXWfghBzO2iHFEmFArbacTVVOfpJv
        TzTCkmRbz/BwQvzM1csk+3H3Dg==
X-Google-Smtp-Source: AGHT+IEWpdoM+WDhrPjgODkxBAhlOnSq5m//vf86ss/9hM1maxstZ2t2i4/KaLoJUfi0o2DpthLKLQ==
X-Received: by 2002:a05:600c:1c89:b0:402:cf9f:c02d with SMTP id k9-20020a05600c1c8900b00402cf9fc02dmr1480014wms.8.1694597437459;
        Wed, 13 Sep 2023 02:30:37 -0700 (PDT)
Received: from m1x-phil.lan (176-131-211-241.abo.bbox.fr. [176.131.211.241])
        by smtp.gmail.com with ESMTPSA id x20-20020a05600c2a5400b003fe601a7d46sm1452383wme.45.2023.09.13.02.30.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Sep 2023 02:30:37 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Kevin Wolf <kwolf@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v5 4/6] target/i386: Move x86_cpu_get_migratable_flags() around
Date:   Wed, 13 Sep 2023 11:30:06 +0200
Message-ID: <20230913093009.83520-5-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230913093009.83520-1-philmd@linaro.org>
References: <20230913093009.83520-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86_cpu_get_migratable_flags() is only used once in
x86_cpu_get_supported_feature_word(). Move it the
code just before its caller, to reduce #ifdef'ry
in the next commit, when we restrict both functions
to system emulation.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/cpu.c | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index b2a20365e1..3df85a6347 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -1664,29 +1664,6 @@ static inline uint64_t x86_cpu_xsave_xss_components(X86CPU *cpu)
            cpu->env.features[FEAT_XSAVE_XSS_LO];
 }
 
-/*
- * Returns the set of feature flags that are supported and migratable by
- * QEMU, for a given FeatureWord.
- */
-static uint64_t x86_cpu_get_migratable_flags(FeatureWord w)
-{
-    FeatureWordInfo *wi = &feature_word_info[w];
-    uint64_t r = 0;
-    int i;
-
-    for (i = 0; i < 64; i++) {
-        uint64_t f = 1ULL << i;
-
-        /* If the feature name is known, it is implicitly considered migratable,
-         * unless it is explicitly set in unmigratable_flags */
-        if ((wi->migratable_flags & f) ||
-            (wi->feat_names[i] && !(wi->unmigratable_flags & f))) {
-            r |= f;
-        }
-    }
-    return r;
-}
-
 void host_cpuid(uint32_t function, uint32_t count,
                 uint32_t *eax, uint32_t *ebx, uint32_t *ecx, uint32_t *edx)
 {
@@ -5679,6 +5656,29 @@ CpuDefinitionInfoList *qmp_query_cpu_definitions(Error **errp)
 
 #endif /* !CONFIG_USER_ONLY */
 
+/*
+ * Returns the set of feature flags that are supported and migratable by
+ * QEMU, for a given FeatureWord.
+ */
+static uint64_t x86_cpu_get_migratable_flags(FeatureWord w)
+{
+    FeatureWordInfo *wi = &feature_word_info[w];
+    uint64_t r = 0;
+    int i;
+
+    for (i = 0; i < 64; i++) {
+        uint64_t f = 1ULL << i;
+
+        /* If the feature name is known, it is implicitly considered migratable,
+         * unless it is explicitly set in unmigratable_flags */
+        if ((wi->migratable_flags & f) ||
+            (wi->feat_names[i] && !(wi->unmigratable_flags & f))) {
+            r |= f;
+        }
+    }
+    return r;
+}
+
 uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
                                             bool migratable_only)
 {
-- 
2.41.0

