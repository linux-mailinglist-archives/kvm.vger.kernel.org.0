Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CFD97A4F4D
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbjIRQjL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:39:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjIRQi6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:38:58 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9A572B2
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:11:56 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-50308217223so2963411e87.3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695053515; x=1695658315; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I+18fO8c7Dk0qCgNhOL8JkONKbHnDNHi1cgc68a1fr4=;
        b=LzCn+vfH3n+LrDRQU6qdQlYv4/2HMwzGWSAVKSYbe+8Y5pAgOfc0ZXI3Sflufv2xTp
         sZSa6b/JAY6PNuQJmc5VnoPYYwoFhlM0U1PgC25oiiIXXiRWZ3BUuwUQlejFx59Gu93n
         dvdd0cO7URmQ/oh8Hcu+LS3V6eO5cC3ElJapV1n4oEn6IDuKHS8KWmbdsXLMkc4jXqK4
         EzyrVu2m3NhFGyiAXAQOkEPbIfglOh2bVkD1QxVlShC1fAPKjzs2TusEMZxIg3leswKM
         rCrw8zrTaoPaK/henG7OZLe+eoa7NyIU6ivbzSecsRRUNcS8CJRedcseMPbo0YFBrG/v
         FU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695053515; x=1695658315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I+18fO8c7Dk0qCgNhOL8JkONKbHnDNHi1cgc68a1fr4=;
        b=IU5xXOExvB/WRwZIYeDKqlpn8hzsGuZgsVMfao5cIUTyJBcHd+SHdCfckAegHoz9QY
         SezkZa9lZqFhLFP7Iifp0YVIoO6+lVstzE865DpI/aZJPVysVpiT39u6kcT13uP93OqE
         NZLVhgs/l1CLezgO8tzjKkvSOcXLtUaa4HEQY6KFvfJ0bnho2IJtGryIvo95IIOa7ZuL
         smISHVYzMHUmIe/xfW2LxfOkBm/e+bhZL3nk4zHQI893lad8u6owy/S2DYQCknC7SSe8
         LCe3E1U6e79hx0eoh9P0040uYBsv13njDE0hybUO/lKNpYh9M81iWW9TkecAb73ueEuN
         4zPA==
X-Gm-Message-State: AOJu0YwEkz/SscqpAdAuNSyGrH1qbbDrEd2DcW8z+MSIUiWAe2pJfFAH
        OERknoXThZBHT44678VuYiP30vWfBQwN6NjneGoa+yEN
X-Google-Smtp-Source: AGHT+IGkFn7qy0jz8oacmoGjjfPL41FojFiYCtkDQb0dCjnyLoNnL5YigEsFHJXz/34UHFIkqAHEBQ==
X-Received: by 2002:a17:906:74db:b0:9ad:e3f0:f335 with SMTP id z27-20020a17090674db00b009ade3f0f335mr6095624ejl.70.1695053037410;
        Mon, 18 Sep 2023 09:03:57 -0700 (PDT)
Received: from localhost.localdomain (static-212-193-78-212.thenetworkfactory.nl. [212.78.193.212])
        by smtp.gmail.com with ESMTPSA id qt11-20020a170906eceb00b009a19fa8d2e9sm6481188ejb.206.2023.09.18.09.03.55
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 18 Sep 2023 09:03:56 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Laurent Vivier <laurent@vivier.eu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        David Hildenbrand <david@redhat.com>,
        Peter Xu <peterx@redhat.com>, Anton Johansson <anjo@rev.ng>,
        Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org,
        Marek Vasut <marex@denx.de>,
        David Gibson <david@gibson.dropbear.id.au>,
        Brian Cain <bcain@quicinc.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        "Edgar E . Iglesias" <edgar.iglesias@gmail.com>,
        Claudio Fontana <cfontana@suse.de>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-ppc@nongnu.org,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Alistair Francis <alistair.francis@wdc.com>,
        Alessandro Di Federico <ale@rev.ng>,
        Song Gao <gaosong@loongson.cn>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Chris Wulff <crwulff@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Fabiano Rosas <farosas@suse.de>, qemu-s390x@nongnu.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Luc Michel <luc@lmichel.fr>, Weiwei Li <liweiwei@iscas.ac.cn>,
        Bin Meng <bin.meng@windriver.com>,
        Stafford Horne <shorne@gmail.com>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-arm@nongnu.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bernhard Beschow <shentey@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Greg Kurz <groug@kaod.org>, Michael Rolnik <mrolnik@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Markus Armbruster <armbru@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 11/22] target/nios2: Create IRQs *after* accelerator vCPU is realized
Date:   Mon, 18 Sep 2023 18:02:44 +0200
Message-ID: <20230918160257.30127-12-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230918160257.30127-1-philmd@linaro.org>
References: <20230918160257.30127-1-philmd@linaro.org>
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

Architecture specific hardware doesn't have a particular dependency
on the accelerator vCPU (created with cpu_exec_realizefn), and can
be initialized *after* the vCPU is realized. Doing so allows further
generic API simplification (in few commits).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/nios2/cpu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/target/nios2/cpu.c b/target/nios2/cpu.c
index 7a92fc5f2c..f500ca7ba2 100644
--- a/target/nios2/cpu.c
+++ b/target/nios2/cpu.c
@@ -201,14 +201,6 @@ static void nios2_cpu_realizefn(DeviceState *dev, Error **errp)
     Nios2CPUClass *ncc = NIOS2_CPU_GET_CLASS(dev);
     Error *local_err = NULL;
 
-#ifndef CONFIG_USER_ONLY
-    if (cpu->eic_present) {
-        qdev_init_gpio_in_named(DEVICE(cpu), eic_set_irq, "EIC", 1);
-    } else {
-        qdev_init_gpio_in_named(DEVICE(cpu), iic_set_irq, "IRQ", 32);
-    }
-#endif
-
     cpu_exec_realizefn(cs, &local_err);
     if (local_err != NULL) {
         error_propagate(errp, local_err);
@@ -220,6 +212,14 @@ static void nios2_cpu_realizefn(DeviceState *dev, Error **errp)
     /* We have reserved storage for cpuid; might as well use it. */
     cpu->env.ctrl[CR_CPUID] = cs->cpu_index;
 
+#ifndef CONFIG_USER_ONLY
+    if (cpu->eic_present) {
+        qdev_init_gpio_in_named(DEVICE(cpu), eic_set_irq, "EIC", 1);
+    } else {
+        qdev_init_gpio_in_named(DEVICE(cpu), iic_set_irq, "IRQ", 32);
+    }
+#endif
+
     ncc->parent_realize(dev, errp);
     cpu_reset(cs);
 }
-- 
2.41.0

