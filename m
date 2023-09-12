Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC04879CFEE
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 13:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234744AbjILLbL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 07:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbjILLa4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 07:30:56 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C078610D3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:30:51 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-502a7e1bdc7so5241172e87.0
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694518250; x=1695123050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/aSlGFqA9ubhB7ZC5gHBqxQU1rcWLkqloVAzPG4iLCg=;
        b=pC1GrUw3qz9tlmlBu9Vv65ySX+buIXsDjSy2R0sJpIupaKqMn0HTIv37X65aUi8N7Q
         +3udc7gI4vGQH64B/Q1469q8uGyj7DNu+kmvhrsuK1T0qZiu9OE4rhLbUk41zCthV5wW
         4ZgBiTzo9iByjiuVf1V3HdUPgi7hxTvPerpDmBj5QWkRYQkKB4yZk3w9F1yXYAEkDwhl
         nhJf0UEbzD95YJilMtKf1YORm2yEG6q9v6GCvIeYJ7kAYgyXqS3BIi21F9TYXKSzon10
         LVf6v5R1oBG5xDOJorMA7UnLy3LCwI3Mo7m/VPmqLusPwYmfWwblNzvshE5W80R8aKc9
         bGRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694518250; x=1695123050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/aSlGFqA9ubhB7ZC5gHBqxQU1rcWLkqloVAzPG4iLCg=;
        b=qzEkmdGkb7w2raby7YYeElFtCI1A9BkqvJff4I++athUFZ2XiYrstCGd2xj9YemseZ
         FELIRDnWFq5wiaoEHEpfDVYXv5pS1ME+lyHliWuN5AI3oiJB2TXtBav3sRA3sHQDPgN6
         aWjRWewqABio1tNNUzHdhKlz8HlpyzzYzS6efU8sgt/XCpfWyGpIf64HzeFFqxk7+NSl
         ECpwxcFvzrAsJi28MNtCdFzcAuDguTmUY4ecUst93SuI4M9dXwq02XS4BVyk58k5rqL8
         44t7qtGjgky0eg7A9XQwdQZAldvp91yzFu+iklp9wRqmg1dAacF1ZI0GE+GQFx/mupRt
         xc9w==
X-Gm-Message-State: AOJu0Yw9hcY8CWqRoW19rgz2L4/lKh8thjrztfVHdUlNJwkxe0Vk3IC7
        NkfIw4T8VGAoKun73YEtmaXgoQ==
X-Google-Smtp-Source: AGHT+IH1nDDr93QicJYxAxgnTc7nY/JwU0DHitp5fHJtl0TRbIOcDKW6MuHF8lvcCHq4T8Tl9fsYHA==
X-Received: by 2002:a05:6512:32d0:b0:4fb:7675:1ff9 with SMTP id f16-20020a05651232d000b004fb76751ff9mr11429892lfg.9.1694518250011;
        Tue, 12 Sep 2023 04:30:50 -0700 (PDT)
Received: from m1x-phil.lan (cou50-h01-176-172-50-150.dsl.sta.abo.bbox.fr. [176.172.50.150])
        by smtp.gmail.com with ESMTPSA id m16-20020aa7c490000000b005236410a16bsm5839285edq.35.2023.09.12.04.30.47
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 Sep 2023 04:30:49 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Greg Kurz <groug@kaod.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 3/4] hw/ppc/e500: Restrict ppce500_init_mpic_kvm() to KVM
Date:   Tue, 12 Sep 2023 13:30:25 +0200
Message-ID: <20230912113027.63941-4-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912113027.63941-1-philmd@linaro.org>
References: <20230912113027.63941-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Inline and guard the single call to kvm_openpic_connect_vcpu()
allows to remove kvm-stub.c. While it seems some code churn,
it allows forbidding user emulation to include "kvm_ppc.h" in
the next commit.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/ppc/e500.c          |  4 ++++
 target/ppc/kvm-stub.c  | 19 -------------------
 target/ppc/meson.build |  2 +-
 3 files changed, 5 insertions(+), 20 deletions(-)
 delete mode 100644 target/ppc/kvm-stub.c

diff --git a/hw/ppc/e500.c b/hw/ppc/e500.c
index d5b6820d1d..d0e199fb2c 100644
--- a/hw/ppc/e500.c
+++ b/hw/ppc/e500.c
@@ -834,6 +834,7 @@ static DeviceState *ppce500_init_mpic_qemu(PPCE500MachineState *pms,
 static DeviceState *ppce500_init_mpic_kvm(const PPCE500MachineClass *pmc,
                                           IrqLines *irqs, Error **errp)
 {
+#ifdef CONFIG_KVM
     DeviceState *dev;
     CPUState *cs;
 
@@ -854,6 +855,9 @@ static DeviceState *ppce500_init_mpic_kvm(const PPCE500MachineClass *pmc,
     }
 
     return dev;
+#else
+    g_assert_not_reached();
+#endif
 }
 
 static DeviceState *ppce500_init_mpic(PPCE500MachineState *pms,
diff --git a/target/ppc/kvm-stub.c b/target/ppc/kvm-stub.c
deleted file mode 100644
index b98e1d404f..0000000000
--- a/target/ppc/kvm-stub.c
+++ /dev/null
@@ -1,19 +0,0 @@
-/*
- * QEMU KVM PPC specific function stubs
- *
- * Copyright Freescale Inc. 2013
- *
- * Author: Alexander Graf <agraf@suse.de>
- *
- * This work is licensed under the terms of the GNU GPL, version 2 or later.
- * See the COPYING file in the top-level directory.
- *
- */
-#include "qemu/osdep.h"
-#include "cpu.h"
-#include "hw/ppc/openpic_kvm.h"
-
-int kvm_openpic_connect_vcpu(DeviceState *d, CPUState *cs)
-{
-    return -EINVAL;
-}
diff --git a/target/ppc/meson.build b/target/ppc/meson.build
index bf1c9319fa..44462f95cd 100644
--- a/target/ppc/meson.build
+++ b/target/ppc/meson.build
@@ -45,7 +45,7 @@ ppc_system_ss.add(when: 'CONFIG_TCG', if_true: files(
 ), if_false: files(
   'tcg-stub.c',
 ))
-ppc_system_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
+ppc_system_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
 
 ppc_system_ss.add(when: 'TARGET_PPC64', if_true: files(
   'compat.c',
-- 
2.41.0

