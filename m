Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A963E5B1B71
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 13:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiIHLbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 07:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiIHLbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 07:31:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AA0C7437
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 04:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662636676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BXcShm0xkab//SpG2GV/N8lmXLzqOSC/0tZzxx8ejts=;
        b=aHowfLoCeScQXHR299I/ew4eJWLe5Xdf82HbEjUxfFs+pnhJs14kyOBvgFOyEGcuXK+ez3
        5qwFTj64uof8XQ25cwEMSiyPaM5a3tjQe++d5O5O3k5k4/YOlLARH7pFmitwsDSmszlcn2
        J7sXlJfyMlFN/k0OMO2tulBtL7jwKkE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-rPXqXCNgP_yS99PcbP1u6w-1; Thu, 08 Sep 2022 07:31:13 -0400
X-MC-Unique: rPXqXCNgP_yS99PcbP1u6w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1D2EE1018AA1;
        Thu,  8 Sep 2022 11:31:13 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.194.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C4B122026D4C;
        Thu,  8 Sep 2022 11:31:12 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id C9ADC18017EC; Thu,  8 Sep 2022 13:31:09 +0200 (CEST)
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v2 2/2] [RfC] expose host-phys-bits to guest
Date:   Thu,  8 Sep 2022 13:31:09 +0200
Message-Id: <20220908113109.470792-3-kraxel@redhat.com>
In-Reply-To: <20220908113109.470792-1-kraxel@redhat.com>
References: <20220908113109.470792-1-kraxel@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move "host-phys-bits" property from cpu->host_phys_bits to
cpu->env.features[FEAT_KVM_HINTS] (KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID bit).

This has the effect that the guest can see whenever host-phys-bits
is turned on or not and act accordingly.

Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
---
 target/i386/cpu.h      | 3 ---
 hw/i386/microvm.c      | 7 ++++++-
 target/i386/cpu.c      | 3 +--
 target/i386/host-cpu.c | 5 ++++-
 target/i386/kvm/kvm.c  | 1 +
 5 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 82004b65b944..b9c6d3d9cac6 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -1898,9 +1898,6 @@ struct ArchCPU {
     /* if true fill the top bits of the MTRR_PHYSMASKn variable range */
     bool fill_mtrr_mask;
 
-    /* if true override the phys_bits value with a value read from the host */
-    bool host_phys_bits;
-
     /* if set, limit maximum value for phys_bits when host_phys_bits is true */
     uint8_t host_phys_bits_limit;
 
diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index 52cafa003d8a..316bbc8ef946 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -54,6 +54,8 @@
 #include "kvm/kvm_i386.h"
 #include "hw/xen/start_info.h"
 
+#include "standard-headers/asm-x86/kvm_para.h"
+
 #define MICROVM_QBOOT_FILENAME "qboot.rom"
 #define MICROVM_BIOS_FILENAME  "bios-microvm.bin"
 
@@ -424,7 +426,10 @@ static void microvm_device_pre_plug_cb(HotplugHandler *hotplug_dev,
 {
     X86CPU *cpu = X86_CPU(dev);
 
-    cpu->host_phys_bits = true; /* need reliable phys-bits */
+    /* need reliable phys-bits */
+    cpu->env.features[FEAT_KVM_HINTS] |=
+        (1 << KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID);
+
     x86_cpu_pre_plug(hotplug_dev, dev, errp);
 }
 
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 1db1278a599b..d60f4498a3c3 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -778,7 +778,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
     [FEAT_KVM_HINTS] = {
         .type = CPUID_FEATURE_WORD,
         .feat_names = {
-            "kvm-hint-dedicated", NULL, NULL, NULL,
+            "kvm-hint-dedicated", "host-phys-bits", NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
             NULL, NULL, NULL, NULL,
@@ -7016,7 +7016,6 @@ static Property x86_cpu_properties[] = {
     DEFINE_PROP_BOOL("x-force-features", X86CPU, force_features, false),
     DEFINE_PROP_BOOL("kvm", X86CPU, expose_kvm, true),
     DEFINE_PROP_UINT32("phys-bits", X86CPU, phys_bits, 0),
-    DEFINE_PROP_BOOL("host-phys-bits", X86CPU, host_phys_bits, false),
     DEFINE_PROP_UINT8("host-phys-bits-limit", X86CPU, host_phys_bits_limit, 0),
     DEFINE_PROP_BOOL("fill-mtrr-mask", X86CPU, fill_mtrr_mask, true),
     DEFINE_PROP_UINT32("level-func7", X86CPU, env.cpuid_level_func7,
diff --git a/target/i386/host-cpu.c b/target/i386/host-cpu.c
index 10f8aba86e53..a1d6b3ac962e 100644
--- a/target/i386/host-cpu.c
+++ b/target/i386/host-cpu.c
@@ -13,6 +13,8 @@
 #include "qapi/error.h"
 #include "sysemu/sysemu.h"
 
+#include "standard-headers/asm-x86/kvm_para.h"
+
 /* Note: Only safe for use on x86(-64) hosts */
 static uint32_t host_cpu_phys_bits(void)
 {
@@ -68,7 +70,8 @@ static uint32_t host_cpu_adjust_phys_bits(X86CPU *cpu)
         warned = true;
     }
 
-    if (cpu->host_phys_bits) {
+    if (cpu->env.features[FEAT_KVM_HINTS] &
+        (1 << KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID)) {
         /* The user asked for us to use the host physical bits */
         phys_bits = host_phys_bits;
         if (cpu->host_phys_bits_limit &&
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a1fd1f53791d..3335c57b21b2 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -459,6 +459,7 @@ uint32_t kvm_arch_get_supported_cpuid(KVMState *s, uint32_t function,
         }
     } else if (function == KVM_CPUID_FEATURES && reg == R_EDX) {
         ret |= 1U << KVM_HINTS_REALTIME;
+        ret |= 1U << KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID;
     }
 
     return ret;
-- 
2.37.3

