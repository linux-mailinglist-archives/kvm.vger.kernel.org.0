Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBBA791752
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 14:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352868AbjIDMoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 08:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239379AbjIDMoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 08:44:04 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7E8CCC
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 05:43:58 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2bd6611873aso20724951fa.1
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 05:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693831437; x=1694436237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J86j5mSNtE6sux8EpFhfC+5G/8PZx0ftCeNpTFb29eU=;
        b=SA4Ljt8izFTEjOIyGfH3mYL4G0sv5r9YmpB2UHQpi77HaGm06BUPhZjt6UVls0K/5e
         +q/pX8JHMtCBS2z6Q1B8hIL0Cln9etUQW38YokmiwE+Id20qwRthk2SjqrAlgeSG7LLJ
         qTWOjzLt/21x1oocOdJ+CZS9Wciafl30IuU8rdPbnBF82HpJutWk/6ye/x0vYVAZYHZc
         UCf84DohWnbBnASYheTZLRZqkiNNAp53qCgLySVJ/sXhUSbKfq9Sj4+hy2bHeOo5gXhq
         w8ixz9mbCkwPZ258Lk5NG/HEnwv6d9CwAlNi7J05E/CKg9GI8lkDdmxeqvbEzxPUUGCi
         O9fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693831437; x=1694436237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J86j5mSNtE6sux8EpFhfC+5G/8PZx0ftCeNpTFb29eU=;
        b=TEnW0LwvaMOHaP7A6BoIOy92IsIGTtPErAs7ee9VtYAvShqCTnYr0aTxpqDsgqYp+/
         joSJVUS9GsWOacCH5fn9QprsFUnv4uoNlmKAQqtgqJrJZqCXtiwLJAW+AeKNKKTkAG2F
         89DjKgWtKvi6fYWE9hwEyDMAQdwilsUyDYasIZVaT2hGQbirmGgmcJucho10h6kHkWZC
         ZwsyQ4o09IAam+PhRTaCxvcfFxXRGsuugJLUOwPufOY1rp3PADOAg3PsdAFckly4t5pN
         AkJ4T8ARPBOv6jkS8dtkcnLr3gqeBdUEtuCkjR0A/6udKyATW++NZBqSWj2+lc9uY9s2
         Hj+g==
X-Gm-Message-State: AOJu0Yw0tyJxIRvgC0DjJIhpNKfb7leTBRh6o08kbefUdRpnciaFuJWk
        8f99ohQ6EjxgzXEJvO3FPbjUrQ==
X-Google-Smtp-Source: AGHT+IHTKfewe5UyKQ+3sAtZlufz27CBCCuRSsD4I35Lg5dnHNAx7JD/gpJfXGmmCvEgfuCO6tDe+g==
X-Received: by 2002:a19:ca4e:0:b0:4fb:9050:1d92 with SMTP id h14-20020a19ca4e000000b004fb90501d92mr5895100lfj.51.1693831437006;
        Mon, 04 Sep 2023 05:43:57 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id qc8-20020a170906d8a800b009944e955e19sm6102288ejb.30.2023.09.04.05.43.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Sep 2023 05:43:56 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 05/13] target/i386/cpu-sysemu: Inline kvm_apic_in_kernel()
Date:   Mon,  4 Sep 2023 14:43:16 +0200
Message-ID: <20230904124325.79040-6-philmd@linaro.org>
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

In order to have cpu-sysemu.c become accelerator-agnostic,
inline kvm_apic_in_kernel() -- which is a simple wrapper
to kvm_irqchip_in_kernel() -- and use the generic "sysemu/kvm.h"
header.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/kvm/kvm_i386.h | 2 --
 target/i386/cpu-sysemu.c   | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index e24753abfe..470627b750 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -13,8 +13,6 @@
 
 #include "sysemu/kvm.h"
 
-#define kvm_apic_in_kernel() (kvm_irqchip_in_kernel())
-
 #ifdef CONFIG_KVM
 
 #define kvm_pit_in_kernel() \
diff --git a/target/i386/cpu-sysemu.c b/target/i386/cpu-sysemu.c
index 28115edf44..2375e48178 100644
--- a/target/i386/cpu-sysemu.c
+++ b/target/i386/cpu-sysemu.c
@@ -19,9 +19,9 @@
 
 #include "qemu/osdep.h"
 #include "cpu.h"
+#include "sysemu/kvm.h"
 #include "sysemu/xen.h"
 #include "sysemu/whpx.h"
-#include "kvm/kvm_i386.h"
 #include "qapi/error.h"
 #include "qapi/qapi-visit-run-state.h"
 #include "qapi/qmp/qdict.h"
@@ -253,7 +253,7 @@ APICCommonClass *apic_get_class(Error **errp)
 
     /* TODO: in-kernel irqchip for hvf */
     if (kvm_enabled()) {
-        if (!kvm_apic_in_kernel()) {
+        if (!kvm_irqchip_in_kernel()) {
             error_setg(errp, "KVM does not support userspace APIC");
             return NULL;
         }
-- 
2.41.0

