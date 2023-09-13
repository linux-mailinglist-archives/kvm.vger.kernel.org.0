Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DC179E3BE
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 11:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239020AbjIMJau (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 05:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239017AbjIMJat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 05:30:49 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C51A1726
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:30:45 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-31c73c21113so6209253f8f.1
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694597444; x=1695202244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eKbeAfeEWeYWq6ZMSQ2gP4OMkhbj3lmxF1/S1lGxkFI=;
        b=MrOwbK9QDbHD2/S4qLT81XZoAErz2IfrKknhx6WWqwZvu5Z+0rPciL2lwQy2h+u4/q
         Jq9GerXhvwzLIyPR88AZdBAXEgSR2J5qp9kQF0DSyVxdQibV16JyW6/tk5Nd7SJan9G0
         AvtLoeHxQ8HVEnJdbIAUDYFNUKz6EKaQ/uxGMFqubuBE5Kxs8KNxs+fzkoarX4R7kQ7p
         D6iGDoKBBlMjwyXzC78Uxhyr/4LY6F+6SobvEvHMM+75cJ+JDxrMGIgABYPsd6iWXeUu
         kXp+D7bxhv32iEIIDzf54gq4P3Gba7E0U7pLNoMZUjqiB3v8x1JH5MFfOoCTAn90+l5R
         3yrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694597444; x=1695202244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eKbeAfeEWeYWq6ZMSQ2gP4OMkhbj3lmxF1/S1lGxkFI=;
        b=A6TGPZy5bC1I3KclhPGeEnmWuP26Zk8uMoU5MD3GF63L/H7n8sTvDHfk/Wjp2fvbiE
         YswbKZbYMwEg9V+zX6o5o1RbwyKo08SRIcoH+90ESW4NTTvatFXo25xEO/hrs6P3MQ5Y
         +1VtOZ2EnnMM+nsSmUE6udN9tU097+AlmOJDu1xPL4VxUM3rYxlGZR0zdB2/0BMHI3KE
         eX+D3aJEBaEEMeWrRo/6MhMDcAaQXRRoHPLpSvFMhFzY/l278bhw361HKF07vz9bATlx
         BjzTNb6kx7Sa5zWDEYlckDGjxkgITmWzlhtYf6Yuuu7zXzNQylCboV6FhbE/s71LK9d9
         PYvw==
X-Gm-Message-State: AOJu0Yw2RX2BBoN8dUYSfuPepay51+u1zHaPI09cRWuCz1HTGB63xPa5
        W77XCDUNBByJmqC7QKGe92ADEw==
X-Google-Smtp-Source: AGHT+IFygu3BAr+7UcI3dOenQQ5WxeefjdnW+wv88rHPugEcR1Z+feWe0l1BCnKAc2a9M86WKXr2Zg==
X-Received: by 2002:adf:ebc8:0:b0:31a:e6c2:770d with SMTP id v8-20020adfebc8000000b0031ae6c2770dmr1565964wrn.36.1694597444117;
        Wed, 13 Sep 2023 02:30:44 -0700 (PDT)
Received: from m1x-phil.lan (176-131-211-241.abo.bbox.fr. [176.131.211.241])
        by smtp.gmail.com with ESMTPSA id u4-20020a5d6da4000000b0031fb91f23e9sm4107295wrs.43.2023.09.13.02.30.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Sep 2023 02:30:43 -0700 (PDT)
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
Subject: [RFC PATCH v5 5/6] target/i386: Restrict system-specific code from user emulation
Date:   Wed, 13 Sep 2023 11:30:07 +0200
Message-ID: <20230913093009.83520-6-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230913093009.83520-1-philmd@linaro.org>
References: <20230913093009.83520-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Restrict calls to:
 - kvm_arch_get_supported_cpuid()
 - kvm_arch_get_supported_msr_feature()
 - kvm_request_xsave_components()
 - kvm_hyperv_expand_features()
so we can remove restrict "kvm/kvm_i386.h" and all its
declarations to system emulation (see the next commit).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/cpu.c | 41 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 3df85a6347..c201ff26bd 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -5654,8 +5654,6 @@ CpuDefinitionInfoList *qmp_query_cpu_definitions(Error **errp)
     return cpu_list;
 }
 
-#endif /* !CONFIG_USER_ONLY */
-
 /*
  * Returns the set of feature flags that are supported and migratable by
  * QEMU, for a given FeatureWord.
@@ -5781,6 +5779,38 @@ static void x86_cpu_get_cache_cpuid(uint32_t func, uint32_t index,
     }
 }
 
+#else /* CONFIG_USER_ONLY */
+
+uint64_t x86_cpu_get_supported_feature_word(FeatureWord w,
+                                            bool migratable_only)
+{
+    FeatureWordInfo *wi = &feature_word_info[w];
+
+    return wi->tcg_features;
+}
+
+static void x86_cpu_get_supported_cpuid(uint32_t func, uint32_t index,
+                                        uint32_t *eax, uint32_t *ebx,
+                                        uint32_t *ecx, uint32_t *edx)
+{
+    *eax = 0;
+    *ebx = 0;
+    *ecx = 0;
+    *edx = 0;
+}
+
+static void x86_cpu_get_cache_cpuid(uint32_t func, uint32_t index,
+                                    uint32_t *eax, uint32_t *ebx,
+                                    uint32_t *ecx, uint32_t *edx)
+{
+    *eax = 0;
+    *ebx = 0;
+    *ecx = 0;
+    *edx = 0;
+}
+
+#endif /* !CONFIG_USER_ONLY */
+
 /*
  * Only for builtin_x86_defs models initialized with x86_register_cpudef_types.
  */
@@ -6918,7 +6948,6 @@ static void x86_cpu_enable_xsave_components(X86CPU *cpu)
     CPUX86State *env = &cpu->env;
     int i;
     uint64_t mask;
-    static bool request_perm;
 
     if (!(env->features[FEAT_1_ECX] & CPUID_EXT_XSAVE)) {
         env->features[FEAT_XSAVE_XCR0_LO] = 0;
@@ -6934,11 +6963,15 @@ static void x86_cpu_enable_xsave_components(X86CPU *cpu)
         }
     }
 
+#ifndef CONFIG_USER_ONLY
+    static bool request_perm;
+
     /* Only request permission for first vcpu */
     if (kvm_enabled() && !request_perm) {
         kvm_request_xsave_components(cpu, mask);
         request_perm = true;
     }
+#endif /* !CONFIG_USER_ONLY */
 
     env->features[FEAT_XSAVE_XCR0_LO] = mask & CPUID_XSTATE_XCR0_MASK;
     env->features[FEAT_XSAVE_XCR0_HI] = mask >> 32;
@@ -7119,9 +7152,11 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
         env->cpuid_xlevel2 = env->cpuid_min_xlevel2;
     }
 
+#ifndef CONFIG_USER_ONLY
     if (kvm_enabled() && !kvm_hyperv_expand_features(cpu, errp)) {
         return;
     }
+#endif /* !CONFIG_USER_ONLY */
 }
 
 /*
-- 
2.41.0

