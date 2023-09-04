Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F345791754
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 14:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjIDMoK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 08:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238975AbjIDMoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 08:44:09 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A03ACDD
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 05:44:05 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-52bcb8b199aso1854425a12.3
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 05:44:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693831443; x=1694436243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uvgb1mY0EmO5+OIh91wyTfD/dyJ0WPXCogU6akizjwQ=;
        b=jlYMZFIkEus2toBx/LbjpMCmPsNi/F149iw0lpWJUPwmXfd/ZTG4pnpLrAcB/vcBPM
         iIoaIX3Br0LvtiSnR7KJm+1t2ky5TTz/vJox1pPzInq6fJUwb4CKVdlNkTEaAfZGt9KD
         dNrybxG9qGhWYrO0F1raRtyFo8g6VWm/6RSlp5cE/lEOVhr+f9ILvveCqEBk/dqz+Nbc
         fHOK49QBmIFVoumyb/nVgI8Zjso2rsEx0XAotPhpAEajJ3ctxxNk/HqMEiWgEwnKto3E
         cSq7QMSMYSVzS+2Jnw9hxecNkJLH3TPMPg49lBVq2wRKAmpbNgsxw/yh6C6gO5IGIxLU
         SU9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693831443; x=1694436243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uvgb1mY0EmO5+OIh91wyTfD/dyJ0WPXCogU6akizjwQ=;
        b=QUA/g6jS2pw8xMAJhg7iUp0SzocPoQSHXdcbKku2Jwo+V0Snr1FRQxcOMn4j9nZAmh
         aY8aOHlIhcousnjUl7sDbb+7I290e2fJKeNOpZJtsTMtm06rP5I+J/j67fkNoOwxsUOm
         0Drn6BJU0QUDGeo0Xg3/D5yRt582IlPAwJ5XfvgmwJV5Mvv485uCdtzmhaQdNCrCiSqS
         rH1EESPVhAQarB+/AyIbpnus4TdKz5+iJ3FgY0mTy2GQjwTJsvL6wh4Gw8ap6hCbpr4K
         Gk77wyyrGjtb5BB7LCWIertp4446utGPRbyNifnLVwhilkceITx1G4A8fRW3Y7j8fJc1
         JWKQ==
X-Gm-Message-State: AOJu0YwEtXIa99psGODHu0lTWADhz6G6v7hzuVsnD0ssC037S8LegjyU
        UlS5QDNlGM7VwtYlJnJVXIpptw==
X-Google-Smtp-Source: AGHT+IEKCW36+yHgpY2ZBNqNwkC4Vzs3gfJURNdlqSjhdC3qvST4PZ0o00mxq38nx3QQCXyG1+Hd8Q==
X-Received: by 2002:aa7:d699:0:b0:525:6588:b624 with SMTP id d25-20020aa7d699000000b005256588b624mr6061172edr.37.1693831443293;
        Mon, 04 Sep 2023 05:44:03 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id b22-20020aa7d496000000b0051dd19d6d6esm5820773edr.73.2023.09.04.05.44.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Sep 2023 05:44:02 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Subject: [PATCH 06/13] target/i386: Remove unused KVM stubs
Date:   Mon,  4 Sep 2023 14:43:17 +0200
Message-ID: <20230904124325.79040-7-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904124325.79040-1-philmd@linaro.org>
References: <20230904124325.79040-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All these functions:

 - kvm_arch_get_supported_cpuid()
 - kvm_has_smm(()
 - kvm_hyperv_expand_features()
 - kvm_set_max_apic_id()

are called after checking for kvm_enabled(), which is
false when KVM is not built. Since the compiler elides
these functions, their stubs are not used and can be
removed.

Inspired-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/kvm/kvm-stub.c | 26 --------------------------
 1 file changed, 26 deletions(-)

diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
index e052f1c7b0..f985d9a1d3 100644
--- a/target/i386/kvm/kvm-stub.c
+++ b/target/i386/kvm/kvm-stub.c
@@ -10,42 +10,16 @@
  *
  */
 #include "qemu/osdep.h"
-#include "cpu.h"
 #include "kvm_i386.h"
 
 #ifndef __OPTIMIZE__
-bool kvm_has_smm(void)
-{
-    return 1;
-}
-
 bool kvm_enable_x2apic(void)
 {
     return false;
 }
-
-/* This function is only called inside conditionals which we
- * rely on the compiler to optimize out when CONFIG_KVM is not
- * defined.
- */
-uint32_t kvm_arch_get_supported_cpuid(KVMState *env, uint32_t function,
-                                      uint32_t index, int reg)
-{
-    abort();
-}
 #endif
 
 bool kvm_hv_vpindex_settable(void)
 {
     return false;
 }
-
-bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp)
-{
-    abort();
-}
-
-void kvm_set_max_apic_id(uint32_t max_apic_id)
-{
-    return;
-}
-- 
2.41.0

