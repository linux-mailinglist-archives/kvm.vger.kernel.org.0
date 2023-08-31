Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D29578EDE4
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 15:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243878AbjHaNAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 09:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjHaNAL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 09:00:11 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5BBCFE
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 06:00:08 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-401f503b529so7264365e9.0
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 06:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693486807; x=1694091607; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RBqrh3+OwbRO0FKJwz0pOQZiq7Hglu3XVSiWyrHauk4=;
        b=M8JsGWTgcBtNahj08KNwq8Kut9eWuSEpAofT7yTsYbcNbX4/0ZZpfgOLd/slI2pvYQ
         YKQ+quw98zk/Um2JJgqbefPPoYLUhJjQiPmdX9C4u2opY2EwQ3b1bjV48FBGehLpYb7w
         d2pR/G8WX613C5Jk+lcpl47fygQcTcknNqDpzI1q8dLAJPXdVQYnaHsVjwwcwKo3L8zV
         RcUyBaXEqHOJJXBaWdb29j1lZMX2RAgnZzy5OFwGmriXBx1GRg6i4kGjiyrD1IC6wWyh
         04cLwrQD2nFE8ZlOyfQgJjAhbQkgDS/2TU5gDgV+LLKEQquTfKDNKKFVLZbEloLnjR5o
         hRAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693486807; x=1694091607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RBqrh3+OwbRO0FKJwz0pOQZiq7Hglu3XVSiWyrHauk4=;
        b=QEkVvGMMfJ6s5N4sEDfaumTtfCvDh5p2snlOlLPntY5mQoHy2bWw6rrdmsqVnIzARC
         h16tyqbkqFeKJNGaUPjtekkiIkDpCQJdxPW2qsy+zob2V1od3UySmUJrGuG+EA0oC1fI
         NWOTiCN+gV+Ks+x0p+L2z5rV9JOqqGMhx7BcY+jB6e3z72jrvjBSes5frPQko44xETmy
         6/joIo+dYHY2pRS1z5mmKxx0iAvwtU48Q5Fb3PWsVqh+KNjJj4wobuRPEdvLgaoxb2Bb
         HTHi/ejoDihQq8oGFgoFFEozgS97Uy+lWzRRIfrL+ERApo1WegqLkDzslYDy98H/aplf
         ARGg==
X-Gm-Message-State: AOJu0YzSvex62udI8mmOzxuFVfwGSPCQPOLCLSRDII25gxZw+EnAuJ8Y
        X5ESe8NW3uG516QbDa1JI+jQoQ==
X-Google-Smtp-Source: AGHT+IHFtn1g4oVr4OxUDyOHvfLkdRRms95A80KEEeJytluOw9x87dJtzVPYJS4DW6y4OFRSEbfikw==
X-Received: by 2002:adf:e5cf:0:b0:317:e542:80a8 with SMTP id a15-20020adfe5cf000000b00317e54280a8mr3780210wrn.15.1693486807461;
        Thu, 31 Aug 2023 06:00:07 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.199.245])
        by smtp.gmail.com with ESMTPSA id i16-20020adffc10000000b0031c5ee51638sm2147619wrr.109.2023.08.31.06.00.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 31 Aug 2023 06:00:07 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-arm@nongnu.org, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        qemu-riscv@nongnu.org, qemu-block@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org
Subject: [PULL 33/41] hw/i386: Remove unuseful kvmclock_create() stub
Date:   Thu, 31 Aug 2023 14:56:35 +0200
Message-ID: <20230831125646.67855-34-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230831125646.67855-1-philmd@linaro.org>
References: <20230831125646.67855-1-philmd@linaro.org>
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

We shouldn't call kvmclock_create() when KVM is not available
or disabled:
 - check for kvm_enabled() before calling it
 - assert KVM is enabled once called
Since the call is elided when KVM is not available, we can
remove the stub (it is never compiled).

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Message-Id: <20230620083228.88796-2-philmd@linaro.org>
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
index ce1ac95274..3de8e0d741 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -192,7 +192,7 @@ static void pc_init1(MachineState *machine,
     pc_machine_init_sgx_epc(pcms);
     x86_cpus_init(x86ms, pcmc->default_cpu_version);
 
-    if (pcmc->kvmclock_enabled) {
+    if (kvm_enabled() && pcmc->kvmclock_enabled) {
         kvmclock_create(pcmc->kvmclock_create_always);
     }
 
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 37c4814bed..a95c5d046e 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -183,7 +183,9 @@ static void pc_q35_init(MachineState *machine)
     pc_machine_init_sgx_epc(pcms);
     x86_cpus_init(x86ms, pcmc->default_cpu_version);
 
-    kvmclock_create(pcmc->kvmclock_create_always);
+    if (kvm_enabled()) {
+        kvmclock_create(pcmc->kvmclock_create_always);
+    }
 
     /* pci enabled */
     if (pcmc->pci_enabled) {
-- 
2.41.0

