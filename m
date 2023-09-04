Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E062279175E
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 14:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352919AbjIDMom (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 08:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352927AbjIDMok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 08:44:40 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1903DCDB
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 05:44:34 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-99bed101b70so220981766b.3
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 05:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693831472; x=1694436272; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wQp1ZwukkzwgrEJecGe85e61/jQRSJ79TXphHOkDcps=;
        b=ETXABFbqLFylxzdk8+kA/bWtEGV9pHYb6jtzy4Lg9cCZgjkRWIcRxt343U9UcaO/HR
         PlAig5rvIerqDXmcphNsp2YOXDE5qltlaCdARfVv4ZQYDgpJ6lKo8dcDo3puB7k04Onk
         tMlWB9BupNgQO7oe+lO2SUXmvvwMeuoT88+4HQRv93e8qJg1GY10w555saFhJtRcl9hR
         55DLX7d7V7YcynfSyGAiQSgZ9y4lYOrQrOSpe8XMamGd5RIXOJfy/NS0K+OZ7rwO4OWR
         jBDZiJBA1LAj1YR/eDDP61IBgGCriNIWF3IurVY8VKANwvBQcljG4P2VVSHKNcgSy42w
         t5Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693831472; x=1694436272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wQp1ZwukkzwgrEJecGe85e61/jQRSJ79TXphHOkDcps=;
        b=jFrENGK5a31tYy6ArL8qJeJoKavPvFNGgODvt+Zu7AvkUXf82lKzfIHa11suYscjyb
         HP13jrPYIG/hg6ZfuneTiwDMyH5LNDt1kE4ySpiprviGy9BNaIG/Zu8NPx9KaZK2lXKt
         wCoIS9wbtlLRFejZ0d+lmk5yjKTZclrIeQ7FabskGwP+mMVj1IvgMvbHjtq8kkUiIihe
         kKGPf9rQghyTpWdHStj4rwW44pG/eJgtog8PH8PklZO/HwGIwy37zZ81R8EoKuvnzaS4
         sK9/0CTEJYTQzVlx16+q25nMzZ8HIg8fzzEUOOPGRnVICdxTTeYznjYMwmzScjPEgyeL
         sH5Q==
X-Gm-Message-State: AOJu0Yx+Bn8hzYHQtxXPWjBVpOHH8IeEKFbprUjD427LNgIByLGPh2G1
        37/Gjfdi41VeHcI0ECywPJiKaw==
X-Google-Smtp-Source: AGHT+IHuyIx4y8Ds8coh9sd7t5uoyGE2ek+jqkPzJtAFpTx/gIGSHZIy1qj15vmm5PPTTvaYTKuKSw==
X-Received: by 2002:a17:907:2c64:b0:9a1:b43b:73a0 with SMTP id ib4-20020a1709072c6400b009a1b43b73a0mr8116583ejc.20.1693831472606;
        Mon, 04 Sep 2023 05:44:32 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id x24-20020a170906299800b0099cadcf13cesm6132052eje.66.2023.09.04.05.44.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Sep 2023 05:44:32 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 11/13] sysemu/kvm: Restrict kvm_get_apic_state() to x86 targets
Date:   Mon,  4 Sep 2023 14:43:22 +0200
Message-ID: <20230904124325.79040-12-philmd@linaro.org>
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

kvm_get_apic_state() is only defined for x86 targets (in
hw/i386/kvm/apic.c). Its declaration is pointless on all
other targets.

Since we include "linux-headers/asm-x86/kvm.h", no need
to forward-declare 'struct kvm_lapic_state'.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/sysemu/kvm.h       | 3 ---
 target/i386/kvm/kvm_i386.h | 1 +
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index a578961a5e..4326b53f90 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -188,7 +188,6 @@ extern bool kvm_msi_use_devid;
 #endif  /* CONFIG_KVM_IS_POSSIBLE */
 
 struct kvm_run;
-struct kvm_lapic_state;
 struct kvm_irq_routing_entry;
 
 typedef struct KVMCapabilityInfo {
@@ -407,8 +406,6 @@ void kvm_irqchip_add_change_notifier(Notifier *n);
 void kvm_irqchip_remove_change_notifier(Notifier *n);
 void kvm_irqchip_change_notify(void);
 
-void kvm_get_apic_state(DeviceState *d, struct kvm_lapic_state *kapic);
-
 struct kvm_guest_debug;
 struct kvm_debug_exit_arch;
 
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index b78e2feb49..d4a1239c68 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -54,6 +54,7 @@ bool kvm_has_adjust_clock_stable(void);
 bool kvm_has_exception_payload(void);
 void kvm_synchronize_all_tsc(void);
 
+void kvm_get_apic_state(DeviceState *d, struct kvm_lapic_state *kapic);
 void kvm_put_apicbase(X86CPU *cpu, uint64_t value);
 
 bool kvm_has_x2apic_api(void);
-- 
2.41.0

