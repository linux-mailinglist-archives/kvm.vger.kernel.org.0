Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BECF77B6209
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 09:04:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbjJCHEw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 03:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjJCHEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 03:04:50 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D2390
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 00:04:47 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-406618d0991so5596065e9.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 00:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696316686; x=1696921486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bgpXhinNPnFvZKdeMS+qc/3fubRg8oTbm/EUaTedB+8=;
        b=oUZo/vplvuB/UfvKmOz4RxA31p2aUCtn2ORjNULHo0XEh8bk1Q6sWrOyp3ejMXO08u
         M6zMiaceRjvZca19sB52FvXXE87E1DHXgcl5pQaTLjLfSo1a6pY87+snUPOyfH6TY7Wf
         JS0++yomf1qKwQMBONHUBVFWVH+3yfw6enwMsvBm4C9ch3srjX3pRTJEeGtHZa2oZYn5
         iMv0OFzWkU+dnUCgPwUpG3znUuN6sWphLG/D6VBk5JbyH7+QrVTwuC5Bn3dUPQEl0BHa
         fXAXjLduhJXLqd52JjN6byY+5uQPjCcRttE4ZoEpGhczgX5Ax/2OzHmWQ8O5/zeWnbyF
         AXew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696316686; x=1696921486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bgpXhinNPnFvZKdeMS+qc/3fubRg8oTbm/EUaTedB+8=;
        b=waHHFbNjh3z372ItnujAkN98KwaYg2lWx9Q3nSxV/r/bP2kb2Iduk5/OUlKotAsRu5
         PbkzCDQhoksTz4Z5Hf7TCIIPeIjuLkaN+5w52oiiHxeRncfeAKhI3CAsqx9+duC0Aru7
         Hjz4gCd4GO0iI2EoZVSJOGt9qUK+nceigspIurzR0AUR4x0BsnEwq1TLgt/fwWWvglz1
         n6B1As8eBfp+SpJPqkPySwKu37UR7iO4A1qd/wXJ6mQTOOA7H/hDbZ/HAEeL6i5rKDji
         d80Gglu7ly2wzmWsU9px2pfoHeqsxUAdhDCDniEnye3TX3xSgt2Mqzp1XE5Rl13vxC8L
         wItg==
X-Gm-Message-State: AOJu0Yx6ksT6+5ytiRvJYBDJNmnaRBlzYGLW4LFV9OMcLs+JPgkR8r9A
        OgA8FJFM78Mk+MqFMyK09ekL3g==
X-Google-Smtp-Source: AGHT+IFbWPwhAeJVn1i9Pd2IS7QiJyQb6QTE0n/sRe1vRSJsLtP8IpfLi2Zi7CWQx7wnFWTnTIvUsw==
X-Received: by 2002:a7b:ce89:0:b0:402:f07c:4b48 with SMTP id q9-20020a7bce89000000b00402f07c4b48mr10778116wmj.28.1696316685763;
        Tue, 03 Oct 2023 00:04:45 -0700 (PDT)
Received: from m1x-phil.lan (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id y18-20020a1c4b12000000b0040642a1df1csm548808wma.25.2023.10.03.00.04.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Oct 2023 00:04:45 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Michael Tokarev <mjt@tls.msk.ru>, Greg Kurz <groug@kaod.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 2/4] hw/ppc/e500: Restrict ppce500_init_mpic_kvm() to KVM
Date:   Tue,  3 Oct 2023 09:04:24 +0200
Message-ID: <20231003070427.69621-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231003070427.69621-1-philmd@linaro.org>
References: <20231003070427.69621-1-philmd@linaro.org>
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

Inline and guard the single call to kvm_openpic_connect_vcpu()
allows to remove kvm-stub.c.

Reviewed-by: Michael Tokarev <mjt@tls.msk.ru>
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
index 4c2635039e..0bff3e39e5 100644
--- a/target/ppc/meson.build
+++ b/target/ppc/meson.build
@@ -30,7 +30,7 @@ gen = [
 ]
 ppc_ss.add(when: 'CONFIG_TCG', if_true: gen)
 
-ppc_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'), if_false: files('kvm-stub.c'))
+ppc_ss.add(when: 'CONFIG_KVM', if_true: files('kvm.c'))
 ppc_ss.add(when: 'CONFIG_USER_ONLY', if_true: files('user_only_helper.c'))
 
 ppc_system_ss = ss.source_set()
-- 
2.41.0

