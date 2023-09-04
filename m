Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1F9791756
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 14:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236147AbjIDMoV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 08:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352874AbjIDMoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 08:44:21 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C20CFB
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 05:44:11 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9a5be3166a2so195183266b.1
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 05:44:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693831449; x=1694436249; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y1KRPJbXgs1nETBjJNmlr2PmeFCKIGRCFU9IErPdUTo=;
        b=v8OPqbdBSClRZU6+mP2XH7bhTZcQ9L3fiG2Ocq8VG6M7GM28+Y3fu7uZlazrXzoQ94
         yNyJwDVoEUUKqre7zA1AO9CRq02WzTyHIPL0/02LvKMwRogQNWmZwM28n4ApitKZEq42
         lLLhB/ydth8DSSu943RijAeczFCr1MU09Re+qJ+jp/SeBQoz/DL9Vu4uyK0PbI7zaPSC
         gOq24HE3CWR3YogWZhxUTSPSg13zwjONM2tVNEl6+AYXnKG1CSAD8mYrshepeNQlqKG5
         1HVvrQyLmBP1uKIy+nXstccy+jQiSYnciopHX1SUZmdmI2bzaAVNru/GWUurKviZ+9X4
         2VWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693831449; x=1694436249;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y1KRPJbXgs1nETBjJNmlr2PmeFCKIGRCFU9IErPdUTo=;
        b=Y7HCoAXxZ/51McEkef49KRNe2o90UUWgifJAlb5a0dBUsBndr0TQM9zDivUknNHFbK
         wbcyBraoV8DifVsgoFuSWUKWS517dwHRMZo6Bv0p+jmZ+Y8xEDx6+rQffNijVcAnvF8B
         94Vi+2F6mGkIo33Dk4Lnl/r/1wpC6msbLWnBMMYASYyvUzV6syJ2FhV2B+iJsZGZ310D
         mpsAQNDs/jKQzn/WjZCbN9SAJb/bR4Rmij72bxcSCDH5iakcel0ZGzKdLoRJrFIVTdwi
         Fgnri8h1yLjQL1DmzAjri3Ps0cAuBGbz+1H+L3Ngdd2++SGuUEK+E6hE7IQnszes4aWf
         bYuQ==
X-Gm-Message-State: AOJu0YxPc3ECTbAIWCkfksoHtzmdgS+DwQ2sxXcyKBCn0jtZCnv/X+vR
        6Qr0+SIacYMxDxKXK9D9PUhEWA==
X-Google-Smtp-Source: AGHT+IEWg2VEI4Vi7IulTZgNKdrHE2WZNrX8LJFTMhv1AYpEjEk8Q1zYIfhClVUZKE72XnRCdYjEhg==
X-Received: by 2002:a17:907:2c75:b0:9a1:d29c:6aa9 with SMTP id ib21-20020a1709072c7500b009a1d29c6aa9mr5782355ejc.11.1693831449576;
        Mon, 04 Sep 2023 05:44:09 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id lt14-20020a170906fa8e00b00977eec7b7e8sm6153822ejb.68.2023.09.04.05.44.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Sep 2023 05:44:09 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Peter Xu <peterx@redhat.com>, Jason Wang <jasowang@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
Subject: [PATCH 07/13] target/i386: Allow elision of kvm_enable_x2apic()
Date:   Mon,  4 Sep 2023 14:43:18 +0200
Message-ID: <20230904124325.79040-8-philmd@linaro.org>
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

Call kvm_enabled() before kvm_enable_x2apic() to
let the compiler elide its call.

Suggested-by: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/intel_iommu.c      | 2 +-
 hw/i386/x86.c              | 2 +-
 target/i386/kvm/kvm-stub.c | 7 -------
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/hw/i386/intel_iommu.c b/hw/i386/intel_iommu.c
index 3ca71df369..c9961ef752 100644
--- a/hw/i386/intel_iommu.c
+++ b/hw/i386/intel_iommu.c
@@ -4053,7 +4053,7 @@ static bool vtd_decide_config(IntelIOMMUState *s, Error **errp)
             error_setg(errp, "eim=on requires accel=kvm,kernel-irqchip=split");
             return false;
         }
-        if (!kvm_enable_x2apic()) {
+        if (kvm_enabled() && !kvm_enable_x2apic()) {
             error_setg(errp, "eim=on requires support on the KVM side"
                              "(X2APIC_API, first shipped in v4.7)");
             return false;
diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index a88a126123..d2920af792 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -136,7 +136,7 @@ void x86_cpus_init(X86MachineState *x86ms, int default_cpu_version)
      * With KVM's in-kernel lapic: only if X2APIC API is enabled.
      */
     if (x86ms->apic_id_limit > 255 && !xen_enabled() &&
-        (!kvm_irqchip_in_kernel() || !kvm_enable_x2apic())) {
+        kvm_enabled() && (!kvm_irqchip_in_kernel() || !kvm_enable_x2apic())) {
         error_report("current -smp configuration requires kernel "
                      "irqchip and X2APIC API support.");
         exit(EXIT_FAILURE);
diff --git a/target/i386/kvm/kvm-stub.c b/target/i386/kvm/kvm-stub.c
index f985d9a1d3..62cccebee4 100644
--- a/target/i386/kvm/kvm-stub.c
+++ b/target/i386/kvm/kvm-stub.c
@@ -12,13 +12,6 @@
 #include "qemu/osdep.h"
 #include "kvm_i386.h"
 
-#ifndef __OPTIMIZE__
-bool kvm_enable_x2apic(void)
-{
-    return false;
-}
-#endif
-
 bool kvm_hv_vpindex_settable(void)
 {
     return false;
-- 
2.41.0

