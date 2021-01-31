Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A08CC309C57
	for <lists+kvm@lfdr.de>; Sun, 31 Jan 2021 14:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhAaNbR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 31 Jan 2021 08:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbhAaLwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 31 Jan 2021 06:52:23 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFB5DC061573
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:50:54 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id c12so13511232wrc.7
        for <kvm@vger.kernel.org>; Sun, 31 Jan 2021 03:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ELWTSu1rl/DhvuIH4cal4USbDecgDqC8O4/05ndhpXE=;
        b=atxpO5/Camn9p7jABxjl2WTPortxY8V1F0jxEhdR2VF0SBEfPL9LK5Vq47+Eod8YM4
         aSZuSFtkdwJyK3FzZaGake8jsnv3T1MqlWW+JvnWt/YTtBuI0fzJvdhdooOiQHAYpA8U
         UVFjEvV4zBNtllHFhkwQzhLAeGmiSs62p2SIMZjyQGGHFYpj8/nWFB0rzW5VU5sTmUgU
         qArFne3BXB4GxsdEsUtx2RothKht8yJaLcLGwCRcFLJ64xxggBPETOdIxL3w2xWx/eHW
         kp9nxOa9ngRX8eU7jbkiS5Yj9hDjtee2VaqEn0fy7cAe7jyw4/p9JLsxgkBb5WKz3a/P
         MdEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=ELWTSu1rl/DhvuIH4cal4USbDecgDqC8O4/05ndhpXE=;
        b=ubZ3zaggJk8ZHTiGv+hPLB6fP8Bfx/g6T/1AvgCRCjyFhfummoTJJuXhSaoy5I2fYo
         ms6shuTw5Xv7b5sJV80upQtlXLOQM6EVK2CfKLNZtDeY8xmE9OU/re+GvKSWgTQO3D8S
         +QCoYawKxgH1W9rFdmjI2yAf5jIdPhSuU17TJ+ArIpr52/ihrDHsM7Pr8JGBOxIeBWMH
         3K5C8peylseQOQP0RoRdwvB16Jrop8zdSlDVV1GxJXlkWJEd3hqqgBlwob1XjZif98e2
         hRovQD74GFp34c4o4KCkRazwIIozZD54bFxoD1I72M7IonvBGKi/JNC+0dkZaEPGV49T
         NWbw==
X-Gm-Message-State: AOAM531junpUhch1s/0u1FS75bHMAk55grVf9ZdH/kOXLNmsrqGR0xii
        iiLertVyIgkhW7xNq0pxiY0=
X-Google-Smtp-Source: ABdhPJw052bc5n0sg8qrUOVnPuK+eGRq0Nn6pE/jzM3JbJxgQX3UIdClky2OLAwF4K5l6GeEHLBoOw==
X-Received: by 2002:adf:9427:: with SMTP id 36mr13393596wrq.271.1612093853746;
        Sun, 31 Jan 2021 03:50:53 -0800 (PST)
Received: from localhost.localdomain (7.red-83-57-171.dynamicip.rima-tde.net. [83.57.171.7])
        by smtp.gmail.com with ESMTPSA id w4sm2862428wrt.69.2021.01.31.03.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 03:50:53 -0800 (PST)
Sender: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= 
        <philippe.mathieu.daude@gmail.com>
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Fam Zheng <fam@euphon.net>, Claudio Fontana <cfontana@suse.de>,
        Paolo Bonzini <pbonzini@redhat.com>, qemu-block@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>,
        qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        John Snow <jsnow@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v6 05/11] target/arm: Restrict ARMv6 cpus to TCG accel
Date:   Sun, 31 Jan 2021 12:50:16 +0100
Message-Id: <20210131115022.242570-6-f4bug@amsat.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210131115022.242570-1-f4bug@amsat.org>
References: <20210131115022.242570-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM requires the target cpu to be at least ARMv8 architecture
(support on ARMv7 has been dropped in commit 82bf7ae84ce:
"target/arm: Remove KVM support for 32-bit Arm hosts").

Only enable the following ARMv6 CPUs when TCG is available:

  - ARM1136
  - ARM1176
  - ARM11MPCore
  - Cortex-M0

The following machines are no more built when TCG is disabled:

  - kzm                  ARM KZM Emulation Baseboard (ARM1136)
  - microbit             BBC micro:bit (Cortex-M0)
  - n800                 Nokia N800 tablet aka. RX-34 (OMAP2420)
  - n810                 Nokia N810 tablet aka. RX-44 (OMAP2420)
  - realview-eb-mpcore   ARM RealView Emulation Baseboard (ARM11MPCore)

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 default-configs/devices/arm-softmmu.mak | 2 --
 hw/arm/realview.c                       | 2 +-
 tests/qtest/cdrom-test.c                | 2 +-
 hw/arm/Kconfig                          | 6 ++++++
 target/arm/Kconfig                      | 4 ++++
 5 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/default-configs/devices/arm-softmmu.mak b/default-configs/devices/arm-softmmu.mak
index 0aad35da0c4..175530595ce 100644
--- a/default-configs/devices/arm-softmmu.mak
+++ b/default-configs/devices/arm-softmmu.mak
@@ -10,9 +10,7 @@ CONFIG_ARM_VIRT=y
 CONFIG_CUBIEBOARD=y
 CONFIG_EXYNOS4=y
 CONFIG_HIGHBANK=y
-CONFIG_FSL_IMX31=y
 CONFIG_MUSCA=y
-CONFIG_NSERIES=y
 CONFIG_STELLARIS=y
 CONFIG_REALVIEW=y
 CONFIG_VEXPRESS=y
diff --git a/hw/arm/realview.c b/hw/arm/realview.c
index 2dcf0a4c23e..0606d22da14 100644
--- a/hw/arm/realview.c
+++ b/hw/arm/realview.c
@@ -463,8 +463,8 @@ static void realview_machine_init(void)
 {
     if (tcg_builtin()) {
         type_register_static(&realview_eb_type);
+        type_register_static(&realview_eb_mpcore_type);
     }
-    type_register_static(&realview_eb_mpcore_type);
     type_register_static(&realview_pb_a8_type);
     type_register_static(&realview_pbx_a9_type);
 }
diff --git a/tests/qtest/cdrom-test.c b/tests/qtest/cdrom-test.c
index 1f1bc26fa7a..cb0409c5a11 100644
--- a/tests/qtest/cdrom-test.c
+++ b/tests/qtest/cdrom-test.c
@@ -224,8 +224,8 @@ int main(int argc, char **argv)
         const char *armmachines[] = {
 #ifdef CONFIG_TCG
             "realview-eb",
-#endif /* CONFIG_TCG */
             "realview-eb-mpcore",
+#endif /* CONFIG_TCG */
             "realview-pb-a8",
             "realview-pbx-a9", "versatileab", "versatilepb", "vexpress-a15",
             "vexpress-a9", "virt", NULL
diff --git a/hw/arm/Kconfig b/hw/arm/Kconfig
index 560442bfc5c..6c4bce4d637 100644
--- a/hw/arm/Kconfig
+++ b/hw/arm/Kconfig
@@ -123,6 +123,8 @@ config NETDUINOPLUS2
 
 config NSERIES
     bool
+    default y if TCG && ARM
+    select ARM_V6
     select OMAP
     select TMP105   # tempature sensor
     select BLIZZARD # LCD/TV controller
@@ -401,6 +403,8 @@ config FSL_IMX25
 
 config FSL_IMX31
     bool
+    default y if TCG && ARM
+    select ARM_V6
     select SERIAL
     select IMX
     select IMX_I2C
@@ -478,11 +482,13 @@ config FSL_IMX6UL
 
 config MICROBIT
     bool
+    default y if TCG && ARM
     select NRF51_SOC
 
 config NRF51_SOC
     bool
     select I2C
+    select ARM_V6
     select ARM_V7M
     select UNIMP
 
diff --git a/target/arm/Kconfig b/target/arm/Kconfig
index 9b3635617dc..fbb7bba9018 100644
--- a/target/arm/Kconfig
+++ b/target/arm/Kconfig
@@ -14,6 +14,10 @@ config ARM_V5
     bool
     depends on TCG && ARM
 
+config ARM_V6
+    bool
+    depends on TCG && ARM
+
 config ARM_V7M
     bool
     select PTIMER
-- 
2.26.2

