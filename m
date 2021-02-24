Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1255C324246
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 17:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbhBXQjQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 11:39:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235410AbhBXQhW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Feb 2021 11:37:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184555;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5oZ0gBbOu96k/6wK9MgGNZa/Ac7X58KCvMjW+JEN0KE=;
        b=L5gH8zM63ZL102Id4ogNAGi4aoaIALsJZ1jhEZcXdyZJw2plfR5P6qzDjK1qXcXekdsReP
        ow2bcOjFrGXgP2dsyIx8IL/TFRB9sLjOaAqNsBAJieAnIYi6MLweiviRfcZljHwZV5a69L
        ajpEXmQ2KRmNdwhuxKqezlmfjJA7yrE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-gnQqpUl7OvecR-6HBP-yyg-1; Wed, 24 Feb 2021 11:35:53 -0500
X-MC-Unique: gnQqpUl7OvecR-6HBP-yyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9691384E240
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 16:35:52 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.221])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 885FA19C46;
        Wed, 24 Feb 2021 16:35:51 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH kvm-unit-tests v2 2/4] x86: hyperv_stimer: define union hv_stimer_config
Date:   Wed, 24 Feb 2021 17:35:45 +0100
Message-Id: <20210224163547.197100-3-vkuznets@redhat.com>
In-Reply-To: <20210224163547.197100-1-vkuznets@redhat.com>
References: <20210224163547.197100-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As a preparation to enabling direct synthetic timers properly define
hv_stimer_config.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 x86/hyperv.h        | 22 +++++++++++++++++-----
 x86/hyperv_stimer.c | 21 ++++++++-------------
 2 files changed, 25 insertions(+), 18 deletions(-)

diff --git a/x86/hyperv.h b/x86/hyperv.h
index e135221fa28a..9a83da483467 100644
--- a/x86/hyperv.h
+++ b/x86/hyperv.h
@@ -60,11 +60,23 @@
 #define HV_SYNIC_SINT_VECTOR_MASK               (0xFF)
 #define HV_SYNIC_SINT_COUNT                     16
 
-#define HV_STIMER_ENABLE                (1ULL << 0)
-#define HV_STIMER_PERIODIC              (1ULL << 1)
-#define HV_STIMER_LAZY                  (1ULL << 2)
-#define HV_STIMER_AUTOENABLE            (1ULL << 3)
-#define HV_STIMER_SINT(config)          (__u8)(((config) >> 16) & 0x0F)
+/*
+ * Synthetic timer configuration.
+ */
+union hv_stimer_config {
+	u64 as_uint64;
+	struct {
+		u64 enable:1;
+		u64 periodic:1;
+		u64 lazy:1;
+		u64 auto_enable:1;
+		u64 apic_vector:8;
+		u64 direct_mode:1;
+		u64 reserved_z0:3;
+		u64 sintx:4;
+		u64 reserved_z1:44;
+	};
+};
 
 #define HV_SYNIC_STIMER_COUNT           (4)
 
diff --git a/x86/hyperv_stimer.c b/x86/hyperv_stimer.c
index fa00dac4d66a..1e4eff270406 100644
--- a/x86/hyperv_stimer.c
+++ b/x86/hyperv_stimer.c
@@ -163,20 +163,15 @@ static void stimer_start(struct stimer *timer,
                          bool auto_enable, bool periodic,
                          u64 tick_100ns)
 {
-    u64 config, count;
+    u64 count;
+    union hv_stimer_config config = {.as_uint64 = 0};
 
     atomic_set(&timer->fire_count, 0);
 
-    config = 0;
-    if (periodic) {
-        config |= HV_STIMER_PERIODIC;
-    }
-
-    config |= ((u8)(timer->sint & 0xFF)) << 16;
-    config |= HV_STIMER_ENABLE;
-    if (auto_enable) {
-        config |= HV_STIMER_AUTOENABLE;
-    }
+    config.periodic = periodic;
+    config.enable = 1;
+    config.auto_enable = auto_enable;
+    config.sintx = timer->sint;
 
     if (periodic) {
         count = tick_100ns;
@@ -186,9 +181,9 @@ static void stimer_start(struct stimer *timer,
 
     if (!auto_enable) {
         wrmsr(HV_X64_MSR_STIMER0_COUNT + timer->index*2, count);
-        wrmsr(HV_X64_MSR_STIMER0_CONFIG + timer->index*2, config);
+        wrmsr(HV_X64_MSR_STIMER0_CONFIG + timer->index*2, config.as_uint64);
     } else {
-        wrmsr(HV_X64_MSR_STIMER0_CONFIG + timer->index*2, config);
+        wrmsr(HV_X64_MSR_STIMER0_CONFIG + timer->index*2, config.as_uint64);
         wrmsr(HV_X64_MSR_STIMER0_COUNT + timer->index*2, count);
     }
 }
-- 
2.29.2

