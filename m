Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EA7D79E3BA
	for <lists+kvm@lfdr.de>; Wed, 13 Sep 2023 11:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238978AbjIMJac (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 05:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239020AbjIMJab (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 05:30:31 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9A919B4
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:30:26 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-402c46c49f4so70463885e9.1
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 02:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694597425; x=1695202225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJ4BcJE7pBMWigDDKZYpQ7Lkem5BrBoGp2n7HRl4RO0=;
        b=IF1fKi8YlnMC+H4U1ee0rO6jUFGc8aYw92Rv4JRZxRbWC2uQNOzDq08r9pWSL/CDe0
         2QBydslr7VvCtodyR6CgWGuxdLH/7dvokQc+nm5AhGzdYTaDF6OW0+/BWVsidYetHE3Z
         ibw/afZ9vilyLRQGcbQbvpG4d9TCen5EhgpYShLlJ3UMQ9rmcGUpAYv/543Jnl0p42JD
         b2R2u1KX6Mgp3YbQ2dq138tLmfunspD+PPIyW4298cS+7vVc5ZO6lAZM7j6w8V6n4onr
         83kv4p2Kj/9uQB4SPUpILip0D1akf7fpgmHdBx75Nd/U6J5d0zo19c5VF7S/QZz3vlHG
         H5mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694597425; x=1695202225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EJ4BcJE7pBMWigDDKZYpQ7Lkem5BrBoGp2n7HRl4RO0=;
        b=hGJ6D1mPDjDbB7tFaVmrFWe4duEFyRpR1XOLWVVDgWqQie3+5MC1582AjZlTWmK6Gd
         U+t5lVN8K1LRkfcM2sEHB26+zvYvIcCVRZMMXzQNjsp5zZo6mTgBm83CzhK29rORhXBZ
         JyajT3qdaKW0cn1o604ctPZFerSL4ICz3nnKg9sCyr+lce8mtL/xhnglyD+PljY2vNTq
         1Y3RcW1uYKUFqgSJFMHHPRKtUKr7+i5ha9Ww0gSfbmM6L+T7H6fEdrR7bjy1ZCG75iVX
         GXS5oE+M3toZR1e1qLL2qcMp01aGNT5mXMFkASjtbTYDei+j8dOOKDbVG9BZ8BWPcKDx
         e8WA==
X-Gm-Message-State: AOJu0YzLsZ8zFmZfCWsNmPoPEK3yad9BRwz8nM4HLlHvRs0xYIr7FAmM
        7BkojbzQhB/wbF1rdY5LOG5Xbg==
X-Google-Smtp-Source: AGHT+IFdROd97h4uzNRN61vFnZYaTWPh6qjyAOrmyyYqJyeWXB3VMK5YJssReCo2Y5Jy+veDjKYKRg==
X-Received: by 2002:a7b:c8d6:0:b0:402:8c7e:3fc4 with SMTP id f22-20020a7bc8d6000000b004028c7e3fc4mr1633611wml.30.1694597425050;
        Wed, 13 Sep 2023 02:30:25 -0700 (PDT)
Received: from m1x-phil.lan (176-131-211-241.abo.bbox.fr. [176.131.211.241])
        by smtp.gmail.com with ESMTPSA id b14-20020a05600c11ce00b003fee8502999sm1476159wmi.18.2023.09.13.02.30.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Sep 2023 02:30:24 -0700 (PDT)
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
Subject: [PATCH v5 2/6] target/i386: Drop accel_uses_host_cpuid before x86_cpu_get_supported_cpuid
Date:   Wed, 13 Sep 2023 11:30:04 +0200
Message-ID: <20230913093009.83520-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230913093009.83520-1-philmd@linaro.org>
References: <20230913093009.83520-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

x86_cpu_get_supported_cpuid() already checks for KVM/HVF
accelerators, so it is not needed to manually check it via
a call to accel_uses_host_cpuid() before calling it.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/cpu.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index bd6a932d08..94b1ba0cf1 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6207,7 +6207,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         break;
     case 0xA:
         /* Architectural Performance Monitoring Leaf */
-        if (accel_uses_host_cpuid() && cpu->enable_pmu) {
+        if (cpu->enable_pmu) {
             x86_cpu_get_supported_cpuid(0xA, count, eax, ebx, ecx, edx);
         } else {
             *eax = 0;
@@ -6247,8 +6247,7 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         *ebx &= 0xffff; /* The count doesn't need to be reliable. */
         break;
     case 0x1C:
-        if (accel_uses_host_cpuid() && cpu->enable_pmu &&
-            (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
+        if (cpu->enable_pmu && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
             x86_cpu_get_supported_cpuid(0x1C, 0, eax, ebx, ecx, edx);
             *edx = 0;
         }
@@ -6322,9 +6321,8 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
             } else {
                 *ecx &= ~XSTATE_ARCH_LBR_MASK;
             }
-        } else if (count == 0xf &&
-                   accel_uses_host_cpuid() && cpu->enable_pmu &&
-                   (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
+        } else if (count == 0xf && cpu->enable_pmu
+                   && (env->features[FEAT_7_0_EDX] & CPUID_7_0_EDX_ARCH_LBR)) {
             x86_cpu_get_supported_cpuid(0xD, count, eax, ebx, ecx, edx);
         } else if (count < ARRAY_SIZE(x86_ext_save_areas)) {
             const ExtSaveArea *esa = &x86_ext_save_areas[count];
-- 
2.41.0

