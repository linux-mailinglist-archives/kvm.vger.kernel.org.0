Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7159079E3B9
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 11:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbjIMJa1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 05:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238981AbjIMJa0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 05:30:26 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3C419B2
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:30:20 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-313e742a787so444889f8f.1
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694597419; x=1695202219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Ef+xjoTCq+y/8i7W8/XmeY8Z3xpQKPoxBTn9z9VDh0=;
        b=cXtWB/NCjF3ofwT5uJMMJdq+jax3RFQ1KjwaW1SY0nSvBAC9B1+HnRdza/OlnIIMkO
         kjYLXBwUME3dU8SmxLa8jPfK6y/qdZc25bC944/Jcz97jRn6uDIbFTbdl4FAN6Ko5ebj
         7KPHEupaaOJdyftYH85DnuRCE4kh+2ffNBJ+FzMfdaAbWK1ShiXI8RbCrbfvcj19qKOm
         U8c0iW1opidCw22eAjUP6rF/ylAyTH5EZNBRUAt95fkRuFj16i0i2T5HD2/pBaShuQ5z
         zgSwger0BvSPpPSCXwdD12XX/n8j7pBYL0lJ9dl1Gn3MxV2b6b1lq7HIaPiCKVAlgn0H
         ru1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694597419; x=1695202219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Ef+xjoTCq+y/8i7W8/XmeY8Z3xpQKPoxBTn9z9VDh0=;
        b=royIUBJ/G/OSFWbEwLmeWlLpflY7CY32o2hs2jgUbGia16f5dGq6eQ0l23Z45eqfJV
         kidjdzftuXujr9afIWt781n1ZD1at0YmQBHykhUfUeT5GLCmxCvbpMKd2y2m1ZFcEm0U
         Fo5rALYD4ObAs/uTtxE8HJ6nmgR1sOxh+iPQVCJvz/+VR0a8X6xpKkmvxo2XhnjwR8ex
         WcpM1YE+jysc+vUWJvXpSTQjZ8ki1cbYQHsw7dsCJ84bTY+3ZoQOPUi3ojh0zU9b4dC8
         vDvyFMCsmwrsVJ8v5/HxO15VPF6KRVUOO7R4KPEa1mFDSdS6TH5u6K5Fxl28+iqHtlhE
         Matg==
X-Gm-Message-State: AOJu0Yx/SoISE3ryywatLWVv/jhlWYZRWGmqK0CGcaKwq7wrtDEo/d5/
        GDZcVe5fXE3oDJ5nP9MFDZpE4Q==
X-Google-Smtp-Source: AGHT+IF81qLWQLTZIurHyfB6n9nBdI6JMAN0Bl+M0T/v9Rb/vaARKtVVv7S5cMZos75Ep62Qy+3cVg==
X-Received: by 2002:adf:e403:0:b0:31f:7324:d47d with SMTP id g3-20020adfe403000000b0031f7324d47dmr3941318wrm.1.1694597419050;
        Wed, 13 Sep 2023 02:30:19 -0700 (PDT)
Received: from m1x-phil.lan (176-131-211-241.abo.bbox.fr. [176.131.211.241])
        by smtp.gmail.com with ESMTPSA id l9-20020a5d4bc9000000b003180027d67asm14946210wrt.19.2023.09.13.02.30.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Sep 2023 02:30:18 -0700 (PDT)
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
Subject: [PATCH v5 1/6] target/i386: Check kvm_hyperv_expand_features() return value
Date:   Wed, 13 Sep 2023 11:30:03 +0200
Message-ID: <20230913093009.83520-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230913093009.83520-1-philmd@linaro.org>
References: <20230913093009.83520-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In case more code is added after the kvm_hyperv_expand_features()
call, check its return value (since it can fail).

Fixes: 071ce4b03b ("i386: expand Hyper-V features during CPU feature expansion time")
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/cpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 24ee67b42d..bd6a932d08 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7121,8 +7121,8 @@ void x86_cpu_expand_features(X86CPU *cpu, Error **errp)
         env->cpuid_xlevel2 = env->cpuid_min_xlevel2;
     }
 
-    if (kvm_enabled()) {
-        kvm_hyperv_expand_features(cpu, errp);
+    if (kvm_enabled() && !kvm_hyperv_expand_features(cpu, errp)) {
+        return;
     }
 }
 
-- 
2.41.0

