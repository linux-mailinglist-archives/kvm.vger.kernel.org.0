Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFE47B68FF
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 14:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbjJCMar (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 08:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232198AbjJCMaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 08:30:46 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B43BB
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 05:30:43 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-3247d69ed2cso884268f8f.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 05:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696336242; x=1696941042; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJP8U3eqs5eoWVLjFoE8nfmBFTz8cZ5KMaYYsencWoY=;
        b=RdM4euCpZoJxuXCy4QmYBZ4kBeInVH1VbH8MfV94kNchlUBetlLqmCLW00VTWkRJZA
         2dGyRf+54xyA87jm67DjYX8tlAonMEOG3CKt9n2lu2vzr64RUTLySIECVp06vZmcXQUY
         0dQTgUuvC4k4ufLfOAEqqv8+m+GtHIlUS1MDv076SKTUtbGHPmOuSvCrHqAMhtunMUpg
         NwGnmN0P5C0+dT79Dpc1OG06a0yY2yWp5kT1hmn3/z7n4uvj+Mvh3uEj73WUFv39XfNy
         2n+Gnx3Xg2g1lR3ky4pCPnt0WXMu2AiYLed1COVmoc0UtDe31U1kz+vO160fbFMgQKsa
         iCgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696336242; x=1696941042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJP8U3eqs5eoWVLjFoE8nfmBFTz8cZ5KMaYYsencWoY=;
        b=l0uUfOTHKCC3WRM/VOgsTzt6R7DNX6TMlX56USBEtzLTpaDXpgDO1HnQbpuDu32d7p
         LNSSITZ3ajC2EQCLWjzBgpOfpT9jkujW8Nd7TrSLQTx6C7qAdFUDd2Sr1Wpw++3dW1V0
         /YQDmevwhpC7o+5liWkxTBnDouWRDFvtzn5WCIq1+NJOu7GBMzOUw4CL3V1uS1KZFJ5+
         OhheTNjK0FucWkvA4g6c62hDsdYW+9RCim66b1J4nx6pBSGovd6LH97Z/czh5fQDPFQB
         hXso4sdP/MQpyuCwIMR5FZ+GNB/sFNH4G+6yXKqbw5f1s59AZuxd7rPE5kHg7wVBNKBa
         Sk4w==
X-Gm-Message-State: AOJu0Yz55CY0yEnqYS1zFxl8VncBRX3Au71PNu2zbcy0ElSiFTzhAaX8
        e1DL9H9Gh70AnnXHk5hAnrEycA==
X-Google-Smtp-Source: AGHT+IGUR2wNUuIBOoLxXPGLs96PG6WE7nSADBCjWoauQJ7ZMRjhIbxyisKYzFjcYkRhDb1hGd57iQ==
X-Received: by 2002:a5d:4a05:0:b0:317:7af4:5294 with SMTP id m5-20020a5d4a05000000b003177af45294mr12996108wrq.44.1696336241902;
        Tue, 03 Oct 2023 05:30:41 -0700 (PDT)
Received: from m1x-phil.lan (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id c15-20020a05600c0acf00b003fe29f6b61bsm1193158wmr.46.2023.10.03.05.30.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Oct 2023 05:30:41 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <eduardo@habkost.net>,
        Yanan Wang <wangyanan55@huawei.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Claudio Fontana <cfontana@suse.de>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Fabiano Rosas <farosas@suse.de>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v2 2/7] accel: Rename AccelCPUClass::cpu_realizefn() -> cpu_target_realize()
Date:   Tue,  3 Oct 2023 14:30:20 +0200
Message-ID: <20231003123026.99229-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231003123026.99229-1-philmd@linaro.org>
References: <20231003123026.99229-1-philmd@linaro.org>
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

The AccelCPUClass::cpu_realizefn handler is meant for target
specific code, rename it using '_target_' to emphasis it.

Suggested-by: Claudio Fontana <cfontana@suse.de>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/core/accel-cpu.h | 2 +-
 accel/accel-common.c        | 4 ++--
 target/i386/hvf/hvf-cpu.c   | 2 +-
 target/i386/kvm/kvm-cpu.c   | 2 +-
 target/i386/tcg/tcg-cpu.c   | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/hw/core/accel-cpu.h b/include/hw/core/accel-cpu.h
index 5dbfd79955..24dad45ab9 100644
--- a/include/hw/core/accel-cpu.h
+++ b/include/hw/core/accel-cpu.h
@@ -32,7 +32,7 @@ typedef struct AccelCPUClass {
 
     void (*cpu_class_init)(CPUClass *cc);
     void (*cpu_instance_init)(CPUState *cpu);
-    bool (*cpu_realizefn)(CPUState *cpu, Error **errp);
+    bool (*cpu_target_realize)(CPUState *cpu, Error **errp);
 } AccelCPUClass;
 
 #endif /* ACCEL_CPU_H */
diff --git a/accel/accel-common.c b/accel/accel-common.c
index b953855e8b..2e30b9d8f0 100644
--- a/accel/accel-common.c
+++ b/accel/accel-common.c
@@ -123,8 +123,8 @@ bool accel_cpu_realize(CPUState *cpu, Error **errp)
 {
     CPUClass *cc = CPU_GET_CLASS(cpu);
 
-    if (cc->accel_cpu && cc->accel_cpu->cpu_realizefn) {
-        return cc->accel_cpu->cpu_realizefn(cpu, errp);
+    if (cc->accel_cpu && cc->accel_cpu->cpu_target_realize) {
+        return cc->accel_cpu->cpu_target_realize(cpu, errp);
     }
     return true;
 }
diff --git a/target/i386/hvf/hvf-cpu.c b/target/i386/hvf/hvf-cpu.c
index 333db59898..bb0da3947a 100644
--- a/target/i386/hvf/hvf-cpu.c
+++ b/target/i386/hvf/hvf-cpu.c
@@ -77,7 +77,7 @@ static void hvf_cpu_accel_class_init(ObjectClass *oc, void *data)
 {
     AccelCPUClass *acc = ACCEL_CPU_CLASS(oc);
 
-    acc->cpu_realizefn = host_cpu_realizefn;
+    acc->cpu_target_realize = host_cpu_realizefn;
     acc->cpu_instance_init = hvf_cpu_instance_init;
 }
 
diff --git a/target/i386/kvm/kvm-cpu.c b/target/i386/kvm/kvm-cpu.c
index 4474689f81..9a5e105e4e 100644
--- a/target/i386/kvm/kvm-cpu.c
+++ b/target/i386/kvm/kvm-cpu.c
@@ -190,7 +190,7 @@ static void kvm_cpu_accel_class_init(ObjectClass *oc, void *data)
 {
     AccelCPUClass *acc = ACCEL_CPU_CLASS(oc);
 
-    acc->cpu_realizefn = kvm_cpu_realizefn;
+    acc->cpu_target_realize = kvm_cpu_realizefn;
     acc->cpu_instance_init = kvm_cpu_instance_init;
 }
 static const TypeInfo kvm_cpu_accel_type_info = {
diff --git a/target/i386/tcg/tcg-cpu.c b/target/i386/tcg/tcg-cpu.c
index b942c306d6..5c3a508ddc 100644
--- a/target/i386/tcg/tcg-cpu.c
+++ b/target/i386/tcg/tcg-cpu.c
@@ -163,7 +163,7 @@ static void tcg_cpu_accel_class_init(ObjectClass *oc, void *data)
     AccelCPUClass *acc = ACCEL_CPU_CLASS(oc);
 
 #ifndef CONFIG_USER_ONLY
-    acc->cpu_realizefn = tcg_cpu_realizefn;
+    acc->cpu_target_realize = tcg_cpu_realizefn;
 #endif /* CONFIG_USER_ONLY */
 
     acc->cpu_class_init = tcg_cpu_class_init;
-- 
2.41.0

