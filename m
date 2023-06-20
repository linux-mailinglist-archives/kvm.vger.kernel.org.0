Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F60736640
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 10:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231974AbjFTIdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 04:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjFTIcp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 04:32:45 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C85C10D5
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 01:32:41 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9891c73e0fbso116875366b.1
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 01:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687249959; x=1689841959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2fWrVTkrh+bhxulRnGVYi7XRu+z1AiTWlgw98CXAeJI=;
        b=SOnhA91BKwLw20oxQ7Deu+EZBvp12+SO/nRM9MirPrl1jRsI5NjJUhnurnJNs6BR9q
         nBq52fa3Nb+Ga+3YlccTxEm5xU4s7GsxUA0eg6bpv5MfcWogS2Flp1XWsYbBfTOJSOmu
         A6/HzEk5O8wTO2jeJcnHVSj3Gehtn16el8oVkz1YfTNf+mjGT9RofjTbg3IaHCGXVd/T
         djp6Oa6O69TJO16H1cxgtk1R+2FpNLZ4o8w0o7lVqIV4a52ackRgdbECu7M4FT4LyIEf
         JPBdUmJRmFcjHtY3Jf6vUx+fBReGCSlNklpaEZ9czKLnPJvspNH6c4rVVdM3uhYcobBA
         7+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687249959; x=1689841959;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2fWrVTkrh+bhxulRnGVYi7XRu+z1AiTWlgw98CXAeJI=;
        b=J6LKytpO/XgR4jkY1O6/SsyRZ5m3C5d34zZgR6Bi8j701bcZrVYJ/x5L9TEmxlZhpe
         qJtCGs3qFzy3f42WfcEIz3ULqysk/b7/FiG1XJ4TtgPWNEYI+by3HfeJafh1GXX226Ys
         FAme6A2Zxok40f8wjV/3BwxxY9BqkRh0D/+7Xb0ECcrZiHyKlSGcuDNvwOD6eDz4vTRJ
         22UeIwIwp8e3GkUVXghWgmGlrbpy+PyvdQlb+j36sNIQ9744XC6ocYihtWYlSWkTZxOt
         oc9jmfibcjLqPM9QoeXVnaC57g4fXNFTCJC/2HLlW2/MPVwKZxz3hJmBXdgn4DARIFMm
         Uh4Q==
X-Gm-Message-State: AC+VfDx1hCW7qcwxWzS+0zAT9S4ylKs/IgKAJOZjv29qSbgPZWyxWIj7
        gdv0obA2adAH96ztYpUf5/GgvzhVW1X7iMmDJ1IEBQ==
X-Google-Smtp-Source: ACHHUZ7oqvtsCEH2H0pVIvI62fTmZU22tNpVGN4sTvY9bwRm64+jLUGifNJtnWRyBxOtlihXSS5sBA==
X-Received: by 2002:a17:907:6d26:b0:988:2037:c687 with SMTP id sa38-20020a1709076d2600b009882037c687mr6360386ejc.37.1687249959548;
        Tue, 20 Jun 2023 01:32:39 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.183.29])
        by smtp.gmail.com with ESMTPSA id l11-20020a170906644b00b00988956f244csm966198ejn.6.2023.06.20.01.32.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Jun 2023 01:32:39 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 1/2] hw/i386: Remove unuseful kvmclock_create() stub
Date:   Tue, 20 Jun 2023 10:32:27 +0200
Message-Id: <20230620083228.88796-2-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230620083228.88796-1-philmd@linaro.org>
References: <20230620083228.88796-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We shouldn't call kvmclock_create() when KVM is not available
or disabled:
 - check for kvm_enabled() before calling it
 - assert KVM is enabled once called
Since the call is elided when KVM is not available, we can
remove the stub (it is never compiled).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/kvm/clock.h | 10 ----------
 hw/i386/kvm/clock.c    |  4 +++-
 hw/i386/microvm.c      |  4 +++-
 hw/i386/pc_piix.c      |  2 +-
 hw/i386/pc_q35.c       |  4 +++-
 5 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/include/hw/kvm/clock.h b/include/hw/kvm/clock.h
index 7994071c4f..3efe0a871c 100644
--- a/include/hw/kvm/clock.h
+++ b/include/hw/kvm/clock.h
@@ -13,16 +13,6 @@
 #ifndef HW_KVM_CLOCK_H
 #define HW_KVM_CLOCK_H
 
-#ifdef CONFIG_KVM
-
 void kvmclock_create(bool create_always);
 
-#else /* CONFIG_KVM */
-
-static inline void kvmclock_create(bool create_always)
-{
-}
-
-#endif /* !CONFIG_KVM */
-
 #endif
diff --git a/hw/i386/kvm/clock.c b/hw/i386/kvm/clock.c
index df70b4a033..0824c6d313 100644
--- a/hw/i386/kvm/clock.c
+++ b/hw/i386/kvm/clock.c
@@ -332,8 +332,10 @@ void kvmclock_create(bool create_always)
 {
     X86CPU *cpu = X86_CPU(first_cpu);
 
-    if (!kvm_enabled() || !kvm_has_adjust_clock())
+    assert(kvm_enabled());
+    if (!kvm_has_adjust_clock()) {
         return;
+    }
 
     if (create_always ||
         cpu->env.features[FEAT_KVM] & ((1ULL << KVM_FEATURE_CLOCKSOURCE) |
diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index 7227a2156c..6b762bc18e 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -180,7 +180,9 @@ static void microvm_devices_init(MicrovmMachineState *mms)
         x86ms->ioapic2 = ioapic_init_secondary(gsi_state);
     }
 
-    kvmclock_create(true);
+    if (kvm_enabled()) {
+        kvmclock_create(true);
+    }
 
     mms->virtio_irq_base = 5;
     mms->virtio_num_transports = 8;
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 44146e6ff5..715c063eec 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -193,7 +193,7 @@ static void pc_init1(MachineState *machine,
     pc_machine_init_sgx_epc(pcms);
     x86_cpus_init(x86ms, pcmc->default_cpu_version);
 
-    if (pcmc->kvmclock_enabled) {
+    if (kvm_enabled() && pcmc->kvmclock_enabled) {
         kvmclock_create(pcmc->kvmclock_create_always);
     }
 
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index a9a59ed42b..a0553f70f7 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -184,7 +184,9 @@ static void pc_q35_init(MachineState *machine)
     pc_machine_init_sgx_epc(pcms);
     x86_cpus_init(x86ms, pcmc->default_cpu_version);
 
-    kvmclock_create(pcmc->kvmclock_create_always);
+    if (kvm_enabled()) {
+        kvmclock_create(pcmc->kvmclock_create_always);
+    }
 
     /* pci enabled */
     if (pcmc->pci_enabled) {
-- 
2.38.1

