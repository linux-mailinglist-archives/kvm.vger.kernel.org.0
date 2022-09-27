Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 210CB5EC5B2
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 16:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbiI0OPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 10:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiI0OPM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 10:15:12 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D76D079C
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 07:15:10 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id k3-20020a05600c1c8300b003b4fa1a85f8so5518401wms.3
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 07:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=jinC1E8FBpCtwExy5oEB2wbtRevFZPQmAbFk5PB8kRY=;
        b=gLTcB6Czzx3VJdWGNqcAsFy6R1+SJ8DAs8+LrUAwxlvZ0DQRJYm4UzukgAUx3G804/
         It5yr7e/JoxhrUch8KFQtTMV7w2oU5fyLZFtVelUWvw2gYJzt9nQRyho2BZ/2saA746y
         MQqesr8JPIRTmb2pB5lF0RJTrWI9suoghsWm6lxBCCznI+NUS5jwQTXbfP77UV/yTRsI
         +whj2hNU//YRUfHnwev5F6s1+KdDn3hJ2clhvk0bagJOq5mjG30gXxZl0THdon8WmTnu
         rnDm4iB/ayxzF8RJfIVFbgDakhp1KgGVaSylSdQMHTJ06wcxYjQlGtg+eMwX/w1mowAU
         ak7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jinC1E8FBpCtwExy5oEB2wbtRevFZPQmAbFk5PB8kRY=;
        b=8KTRoi2X/Ut5aiGlSeBk7zxuMzxxiDo7VzarNi6ic6r1grIopo+lX0JY6gysOn+U28
         sx0e64LQOoprKf9AtyCBkNMhitYeRUiGhsEsUH9YttPYsL3kEAxY6TarSdDoQyetGrea
         bTwkRTerSgreKefglgA3X1+mcel+QQ96tsb+RFcSNdZQ4Jyi5W/4ldA0WKd1R9yUBt24
         M3iSH9/HoM5JjTofu3tbJsKZsY8oScgSQN8Je9cBYv45JOklgnvRiZgr3nlapOSD/pbP
         nbEtKM9m3d/YMtIS2YJMcTYH7gbomy6TMNzoq6GqtIT9YJlkGJNT+kzKKZW8o4VWfeyH
         aWNw==
X-Gm-Message-State: ACrzQf2L2Jx/OCTZOgR6dzjqZduVGfTJgE17ywEnFWjrgBdZWNSwC10A
        zI6d1Dz/bb6zTLIywTaICNXkug==
X-Google-Smtp-Source: AMsMyM7nx4GBbJ6jrZNIdLSGvy4obHwUe2oEjfUVDrw3vMocX+vfP1s3I2fqZIY5WDNcBqEbsp2iqQ==
X-Received: by 2002:a05:600c:34d2:b0:3b4:a617:f3b9 with SMTP id d18-20020a05600c34d200b003b4a617f3b9mr2846431wmq.204.1664288109247;
        Tue, 27 Sep 2022 07:15:09 -0700 (PDT)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id az19-20020a05600c601300b003a83ca67f73sm2107341wmb.3.2022.09.27.07.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 07:15:07 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id DAF1D1FFBC;
        Tue, 27 Sep 2022 15:15:05 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-arm@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH  v3 04/15] target/arm: ensure KVM traps set appropriate MemTxAttrs
Date:   Tue, 27 Sep 2022 15:14:53 +0100
Message-Id: <20220927141504.3886314-5-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220927141504.3886314-1-alex.bennee@linaro.org>
References: <20220927141504.3886314-1-alex.bennee@linaro.org>
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

Although most KVM users will use the in-kernel GIC emulation it is
perfectly possible not to. In this case we need to ensure the
MemTxAttrs are correctly populated so the GIC can divine the source
CPU of the operation.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

---
v3
  - new for v3
---
 target/arm/kvm.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index e5c1bd50d2..05056562f4 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -801,13 +801,14 @@ MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
 {
     ARMCPU *cpu;
     uint32_t switched_level;
+    MemTxAttrs attrs = MEMTXATTRS_CPU(cs);
 
     if (kvm_irqchip_in_kernel()) {
         /*
          * We only need to sync timer states with user-space interrupt
          * controllers, so return early and save cycles if we don't.
          */
-        return MEMTXATTRS_UNSPECIFIED;
+        return attrs;
     }
 
     cpu = ARM_CPU(cs);
@@ -848,7 +849,7 @@ MemTxAttrs kvm_arch_post_run(CPUState *cs, struct kvm_run *run)
         qemu_mutex_unlock_iothread();
     }
 
-    return MEMTXATTRS_UNSPECIFIED;
+    return attrs;
 }
 
 void kvm_arm_vm_state_change(void *opaque, bool running, RunState state)
@@ -1003,6 +1004,10 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
     hwaddr xlat, len, doorbell_gpa;
     MemoryRegionSection mrs;
     MemoryRegion *mr;
+    MemTxAttrs attrs = {
+        .requester_type = MTRT_PCI,
+        .requester_id = pci_requester_id(dev)
+    };
 
     if (as == &address_space_memory) {
         return 0;
@@ -1012,8 +1017,7 @@ int kvm_arch_fixup_msi_route(struct kvm_irq_routing_entry *route,
 
     RCU_READ_LOCK_GUARD();
 
-    mr = address_space_translate(as, address, &xlat, &len, true,
-                                 MEMTXATTRS_UNSPECIFIED);
+    mr = address_space_translate(as, address, &xlat, &len, true, attrs);
 
     if (!mr) {
         return 1;
-- 
2.34.1

