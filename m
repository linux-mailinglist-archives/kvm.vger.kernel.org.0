Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 632FF6D74EB
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 09:02:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237041AbjDEHCz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 03:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjDEHCx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 03:02:53 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49998210E
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 00:02:52 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id r7-20020a17090b050700b002404be7920aso34587532pjz.5
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 00:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112; t=1680678172; x=1683270172;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1Z0+1ZY20suxjwfAVbU4A3dZMNsDAUXYruoP0iRlgbw=;
        b=bfaJ5rgori6YxbwThhAhcny8+ENaOqPdj/1ZnE9RI31Lv3I3x+6Gvu2ifum+YFYYBC
         wAIbyuSUG+NQMKwqXJtTozuIyZVATuETlQC6yNS9aKzCnzbqyiFmb24tkccR4IGdtbGO
         cWRg2R/m05LjbIrBhxsYvuPYXnn11H9lQ4U+9+3CUYRMmEvxUUvmL8YyUzrgTPpoQb47
         VVK2Xcm54c+lFgHmFOeKfQHlT3prb4nuZWe/WYi8V21kfAIM1028hVbMue518YORaBsC
         rzRduTy5WG3pMRVCA02ADpf/v+F5M7qWbKf69QSjWspqM/zE08rWm8PZTTtCTA+YGHUP
         npMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680678172; x=1683270172;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Z0+1ZY20suxjwfAVbU4A3dZMNsDAUXYruoP0iRlgbw=;
        b=FFdcdGinxwN9kg0UEo337HCfXsLV7PijZbxxgqWGWexLymNmVsYZH57GfSY58OEjp/
         +4vgbXqprtYZZZmFJFTGKmizEshyygbkP10hhdG/veo7KePqxYMxPcklhCnEYAWZMT7q
         kQYFGVZ1RKhWz6np0tSjlX6tnoFaj03w4nZhTsNawMtmpxwRnIy+Kg38dzJdMfG6p8aB
         rUY1O+DEmcDv5zMlHW2Z960soR700R1snUVf7D+ch23xYELAsL6SK31p5dn1kF2a6066
         vu5k/5lNrIYXOYh7CK6yRQOZi6en0pu/DOXboh+v0k3iGNjim7YQIw7D/IESqGLa3Zjn
         oaVw==
X-Gm-Message-State: AAQBX9dnSNakzruO29GnKhLxdIs7pLogYrP59QxK5wUg7j7DtO5g3WbK
        ilR9Wk0ggFrWblDiZRBOjB26Z7zPYnYj0cHojb7fqQ==
X-Google-Smtp-Source: AKy350YQjZiQjCktP674kxJT8eArvKfhUjlrzD/of8AUdwEKqspv9wC0kUD9MfsqmUdmA5zaHr151Q==
X-Received: by 2002:a05:6a20:2a28:b0:dd:abea:7a78 with SMTP id e40-20020a056a202a2800b000ddabea7a78mr4352261pzh.16.1680678171826;
        Wed, 05 Apr 2023 00:02:51 -0700 (PDT)
Received: from alarm.flets-east.jp ([2400:4050:a840:1e00:4457:c267:5e09:481b])
        by smtp.gmail.com with ESMTPSA id n9-20020aa79049000000b00625e885a6ffsm10210421pfo.18.2023.04.05.00.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 00:02:51 -0700 (PDT)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH] target/arm: Check if debug is already initialized
Date:   Wed,  5 Apr 2023 16:02:44 +0900
Message-Id: <20230405070244.23464-1-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When virtualizing SMP system, kvm_arm_init_debug() will be called
multiple times. Check if the debug feature is already initialized when the
function is called; otherwise it will overwrite pointers to memory
allocated with the previous call and leak it.

Fixes: e4482ab7e3 ("target-arm: kvm - add support for HW assisted debug")
Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 target/arm/kvm64.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index 1197253d12..d2fce5e582 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -32,7 +32,11 @@
 #include "hw/acpi/ghes.h"
 #include "hw/arm/virt.h"
 
-static bool have_guest_debug;
+static enum {
+    GUEST_DEBUG_UNINITED,
+    GUEST_DEBUG_INITED,
+    GUEST_DEBUG_UNAVAILABLE,
+} guest_debug;
 
 /*
  * Although the ARM implementation of hardware assisted debugging
@@ -84,8 +88,14 @@ GArray *hw_breakpoints, *hw_watchpoints;
  */
 static void kvm_arm_init_debug(CPUState *cs)
 {
-    have_guest_debug = kvm_check_extension(cs->kvm_state,
-                                           KVM_CAP_SET_GUEST_DEBUG);
+    if (guest_debug) {
+        return;
+    }
+
+    if (!kvm_check_extension(cs->kvm_state, KVM_CAP_SET_GUEST_DEBUG)) {
+        guest_debug = GUEST_DEBUG_UNAVAILABLE;
+        return;
+    }
 
     max_hw_wps = kvm_check_extension(cs->kvm_state, KVM_CAP_GUEST_DEBUG_HW_WPS);
     hw_watchpoints = g_array_sized_new(true, true,
@@ -94,7 +104,8 @@ static void kvm_arm_init_debug(CPUState *cs)
     max_hw_bps = kvm_check_extension(cs->kvm_state, KVM_CAP_GUEST_DEBUG_HW_BPS);
     hw_breakpoints = g_array_sized_new(true, true,
                                        sizeof(HWBreakpoint), max_hw_bps);
-    return;
+
+    guest_debug = GUEST_DEBUG_INITED;
 }
 
 /**
@@ -1483,7 +1494,7 @@ static const uint32_t brk_insn = 0xd4200000;
 
 int kvm_arch_insert_sw_breakpoint(CPUState *cs, struct kvm_sw_breakpoint *bp)
 {
-    if (have_guest_debug) {
+    if (guest_debug == GUEST_DEBUG_INITED) {
         if (cpu_memory_rw_debug(cs, bp->pc, (uint8_t *)&bp->saved_insn, 4, 0) ||
             cpu_memory_rw_debug(cs, bp->pc, (uint8_t *)&brk_insn, 4, 1)) {
             return -EINVAL;
@@ -1499,7 +1510,7 @@ int kvm_arch_remove_sw_breakpoint(CPUState *cs, struct kvm_sw_breakpoint *bp)
 {
     static uint32_t brk;
 
-    if (have_guest_debug) {
+    if (guest_debug == GUEST_DEBUG_INITED) {
         if (cpu_memory_rw_debug(cs, bp->pc, (uint8_t *)&brk, 4, 0) ||
             brk != brk_insn ||
             cpu_memory_rw_debug(cs, bp->pc, (uint8_t *)&bp->saved_insn, 4, 1)) {
-- 
2.40.0

