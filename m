Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4C4698281
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbjBORoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbjBORoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:44:22 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E14B3C294
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:44:19 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id az4-20020a05600c600400b003dff767a1f1so2132875wmb.2
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zRiYpacq2buGtsbzdt2U4edvI0iODkUmTaRGtL8ovas=;
        b=jDsZJRQLERfeLQ490jpStffMhiCHc+0Rwb7tmTYaJq0Kw6f+YIzHKeqnuJALZNPbAJ
         URQiKJ1Jgt4qncCRdljh3VUryyaUxWLFWFTt21xdoaz80sQlE1IArzmcK6mpuxHwqhDb
         ZOBcfs8MLY0rzQPRd9oHW2MVOm10HmIgfQ5tVRi9Qm1nHOWniVqlMJzjPEfq0GqVFEiD
         XmB7L3HDZoWo46KvkoyBicrBZ+xPsjAnYdi3OQiKxuvZKTlI4+3sZp+MN+LjvG98sSpB
         iuzEddUN4npG0E5L37O6WRfVOt3789FjxMaTxqx4YekzlaHL5ebxC6mC/eHo6c0ENmVn
         BH3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zRiYpacq2buGtsbzdt2U4edvI0iODkUmTaRGtL8ovas=;
        b=6plklb3Mlu48oOnj/rj/kTEt2sHH7Lt/VOHpjw6u2QSmFG9ITIPBvmqQMuo3Gtawn6
         wvBhgavqtYCHkhxyb8WLD/P6Tp5M/uR1j0mGdtZS50RrpXui0fyt8bCussUPP0DPOfwZ
         ++lx5z5LOd0D3CGH42k3UvD8lb8ObbblbHTcpY/TRKS+ly/9nrW5e6/RtPIgt8X1Zmi8
         n1Kujmb2ulfrB4SUpa59hI7yVoUGZIfiU/6F+kaVQM8qlJDPsPPugac+9Yme+aOnvH39
         XewN2qrtcd5toA2+HFNu+JW00XgNvWC2nfj1MPjUsctZV5S2oQ//QzxRSa/XfEBIHmCu
         jM7w==
X-Gm-Message-State: AO0yUKXXrNI5lXLyLgN7xJISOzDPg9EEtNenrFAF2Rz4J9Qa4smc5pnk
        Rg8dst7jwW4JrhQYkTD5Z6gsXQ==
X-Google-Smtp-Source: AK7set8jnVvjneWIxfxH9Bn5U/pjoZeBdZs+qd4MTX4M47EdU+EutDCEiNwQ6TNvB3qvIVBBMpJe7w==
X-Received: by 2002:a05:600c:318a:b0:3db:5f1:53a5 with SMTP id s10-20020a05600c318a00b003db05f153a5mr2757152wmp.20.1676483058010;
        Wed, 15 Feb 2023 09:44:18 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id 21-20020a05600c021500b003e209186c07sm414427wmi.19.2023.02.15.09.44.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Feb 2023 09:44:17 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Huacai Chen <chenhuacai@kernel.org>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>
Subject: [PATCH 4/5] hw/timer/i8254: Really inline i8254_pit_init()
Date:   Wed, 15 Feb 2023 18:43:52 +0100
Message-Id: <20230215174353.37097-5-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230215174353.37097-1-philmd@linaro.org>
References: <20230215174353.37097-1-philmd@linaro.org>
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

In-line the one-line i8254_pit_create() call.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/microvm.c        | 2 +-
 hw/isa/i82378.c          | 2 +-
 hw/isa/piix4.c           | 4 ++--
 hw/isa/vt82c686.c        | 2 +-
 hw/mips/jazz.c           | 2 +-
 include/hw/timer/i8254.h | 7 -------
 6 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index 29f30dd6d3..9204bb4ff2 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -261,7 +261,7 @@ static void microvm_devices_init(MicrovmMachineState *mms)
         if (kvm_pit_in_kernel()) {
             kvm_pit_init(isa_bus, 0x40);
         } else {
-            i8254_pit_init(isa_bus, 0x40, 0, NULL);
+            i8254_pit_create(isa_bus, 0x40, isa_bus_get_irq(isa_bus, 0));
         }
     }
 
diff --git a/hw/isa/i82378.c b/hw/isa/i82378.c
index e3322e03bf..f75f5a23ba 100644
--- a/hw/isa/i82378.c
+++ b/hw/isa/i82378.c
@@ -99,7 +99,7 @@ static void i82378_realize(PCIDevice *pci, Error **errp)
     isa_bus_irqs(isabus, s->i8259);
 
     /* 1 82C54 (pit) */
-    pit = i8254_pit_init(isabus, 0x40, 0, NULL);
+    pit = i8254_pit_create(isabus, 0x40, isa_bus_get_irq(isabus, 0));
 
     /* speaker */
     pcspk_init(isa_new(TYPE_PC_SPEAKER), isabus, pit);
diff --git a/hw/isa/piix4.c b/hw/isa/piix4.c
index 94e5dc7825..8ff118445f 100644
--- a/hw/isa/piix4.c
+++ b/hw/isa/piix4.c
@@ -214,8 +214,8 @@ static void piix4_realize(PCIDevice *dev, Error **errp)
     /* initialize ISA irqs */
     isa_bus_irqs(isa_bus, s->isa);
 
-    /* initialize pit */
-    i8254_pit_init(isa_bus, 0x40, 0, NULL);
+    /* PIT */
+    i8254_pit_create(isa_bus, 0x40, isa_bus_get_irq(isa_bus, 0));
 
     /* DMA */
     i8257_dma_init(isa_bus, 0);
diff --git a/hw/isa/vt82c686.c b/hw/isa/vt82c686.c
index 3f9bd0c04d..297bcda420 100644
--- a/hw/isa/vt82c686.c
+++ b/hw/isa/vt82c686.c
@@ -624,7 +624,7 @@ static void via_isa_realize(PCIDevice *d, Error **errp)
 
     s->isa_irqs = i8259_init(isa_bus, *isa_irq);
     isa_bus_irqs(isa_bus, s->isa_irqs);
-    i8254_pit_init(isa_bus, 0x40, 0, NULL);
+    i8254_pit_create(isa_bus, 0x40, isa_bus_get_irq(isa_bus, 0));
     i8257_dma_init(isa_bus, 0);
 
     /* RTC */
diff --git a/hw/mips/jazz.c b/hw/mips/jazz.c
index 6aefe9a61b..856acfe2a7 100644
--- a/hw/mips/jazz.c
+++ b/hw/mips/jazz.c
@@ -251,7 +251,7 @@ static void mips_jazz_init(MachineState *machine,
     i8259 = i8259_init(isa_bus, env->irq[4]);
     isa_bus_irqs(isa_bus, i8259);
     i8257_dma_init(isa_bus, 0);
-    pit = i8254_pit_init(isa_bus, 0x40, 0, NULL);
+    pit = i8254_pit_create(isa_bus, 0x40, isa_bus_get_irq(isa_bus, 0));
     pcspk_init(isa_new(TYPE_PC_SPEAKER), isa_bus, pit);
 
     /* Video card */
diff --git a/include/hw/timer/i8254.h b/include/hw/timer/i8254.h
index 0d837f3f41..aa48c44d39 100644
--- a/include/hw/timer/i8254.h
+++ b/include/hw/timer/i8254.h
@@ -56,13 +56,6 @@ OBJECT_DECLARE_TYPE(PITCommonState, PITCommonClass, PIT_COMMON)
  */
 ISADevice *i8254_pit_create(ISABus *bus, int iobase, qemu_irq irq_in);
 
-static inline ISADevice *i8254_pit_init(ISABus *bus, int base, int isa_irq,
-                                        qemu_irq alt_irq)
-{
-    assert(isa_irq == 0 && alt_irq == NULL);
-    return i8254_pit_create(bus, base, isa_bus_get_irq(bus, 0));
-}
-
 static inline ISADevice *kvm_pit_init(ISABus *bus, int base)
 {
     DeviceState *dev;
-- 
2.38.1

