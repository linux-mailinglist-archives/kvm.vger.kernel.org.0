Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A603C7443
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230137AbhGMQWG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:22:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229848AbhGMQWF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 12:22:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626193154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7O3CvfIBEw7rwxou/BiqiGDW4NmHuSaInEFhwPzgRyk=;
        b=EMqFHLJx43TfNWaGUaM6bzn3C2J2ZMqoaQm1WKTsZUYTgGpUn2A8EQoziKbyNz0wTL5rxj
        o1myVhWSIX+szpLKunZeg8DXqKCC+NS/vf75Lf6m2FJZpEAaubowPW8WtxKk4v+HcCa3KY
        y3AWluLBZ40Nw19OXRkXXMclqXhKywE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-447-xQ4STHPWNua5aBcRnQ7k5Q-1; Tue, 13 Jul 2021 12:19:13 -0400
X-MC-Unique: xQ4STHPWNua5aBcRnQ7k5Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32922DF8A3;
        Tue, 13 Jul 2021 16:19:12 +0000 (UTC)
Received: from localhost (ovpn-113-28.rdu2.redhat.com [10.10.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ECD695D9CA;
        Tue, 13 Jul 2021 16:19:11 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PULL 05/11] i386: kill off hv_cpuid_check_and_set()
Date:   Tue, 13 Jul 2021 12:09:51 -0400
Message-Id: <20210713160957.3269017-6-ehabkost@redhat.com>
In-Reply-To: <20210713160957.3269017-1-ehabkost@redhat.com>
References: <20210713160957.3269017-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

hv_cpuid_check_and_set() does too much:
- Checks if the feature is supported by KVM;
- Checks if all dependencies are enabled;
- Sets the feature bit in cpu->hyperv_features for 'passthrough' mode.

To reduce the complexity, move all the logic except for dependencies
check out of it. Also, in 'passthrough' mode we don't really need to
check dependencies because KVM is supposed to provide a consistent
set anyway.

Reviewed-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20210608120817.1325125-7-vkuznets@redhat.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/kvm/kvm.c | 104 +++++++++++++++---------------------------
 1 file changed, 36 insertions(+), 68 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 556815db13d..945d24300c0 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1148,16 +1148,12 @@ static bool hyperv_feature_supported(CPUState *cs, int feature)
     return true;
 }
 
-static int hv_cpuid_check_and_set(CPUState *cs, int feature, Error **errp)
+/* Checks that all feature dependencies are enabled */
+static bool hv_feature_check_deps(X86CPU *cpu, int feature, Error **errp)
 {
-    X86CPU *cpu = X86_CPU(cs);
     uint64_t deps;
     int dep_feat;
 
-    if (!hyperv_feat_enabled(cpu, feature) && !cpu->hyperv_passthrough) {
-        return 0;
-    }
-
     deps = kvm_hyperv_properties[feature].dependencies;
     while (deps) {
         dep_feat = ctz64(deps);
@@ -1165,26 +1161,12 @@ static int hv_cpuid_check_and_set(CPUState *cs, int feature, Error **errp)
             error_setg(errp, "Hyper-V %s requires Hyper-V %s",
                        kvm_hyperv_properties[feature].desc,
                        kvm_hyperv_properties[dep_feat].desc);
-            return 1;
+            return false;
         }
         deps &= ~(1ull << dep_feat);
     }
 
-    if (!hyperv_feature_supported(cs, feature)) {
-        if (hyperv_feat_enabled(cpu, feature)) {
-            error_setg(errp, "Hyper-V %s is not supported by kernel",
-                       kvm_hyperv_properties[feature].desc);
-            return 1;
-        } else {
-            return 0;
-        }
-    }
-
-    if (cpu->hyperv_passthrough) {
-        cpu->hyperv_features |= BIT(feature);
-    }
-
-    return 0;
+    return true;
 }
 
 static uint32_t hv_build_cpuid_leaf(CPUState *cs, uint32_t func, int reg)
@@ -1223,6 +1205,8 @@ static uint32_t hv_build_cpuid_leaf(CPUState *cs, uint32_t func, int reg)
 bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp)
 {
     CPUState *cs = CPU(cpu);
+    Error *local_err = NULL;
+    int feat;
 
     if (!hyperv_enabled(cpu))
         return true;
@@ -1278,53 +1262,37 @@ bool kvm_hyperv_expand_features(X86CPU *cpu, Error **errp)
 
         cpu->hyperv_spinlock_attempts =
             hv_cpuid_get_host(cs, HV_CPUID_ENLIGHTMENT_INFO, R_EBX);
-    }
 
-    /* Features */
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_RELAXED, errp)) {
-        return false;
-    }
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_VAPIC, errp)) {
-        return false;
-    }
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_TIME, errp)) {
-        return false;
-    }
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_CRASH, errp)) {
-        return false;
-    }
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_RESET, errp)) {
-        return false;
-    }
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_VPINDEX, errp)) {
-        return false;
-    }
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_RUNTIME, errp)) {
-        return false;
-    }
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_SYNIC, errp)) {
-        return false;
-    }
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_STIMER, errp)) {
-        return false;
-    }
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_FREQUENCIES, errp)) {
-        return false;
-    }
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_REENLIGHTENMENT, errp)) {
-        return false;
-    }
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_TLBFLUSH, errp)) {
-        return false;
-    }
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_EVMCS, errp)) {
-        return false;
-    }
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_IPI, errp)) {
-        return false;
-    }
-    if (hv_cpuid_check_and_set(cs, HYPERV_FEAT_STIMER_DIRECT, errp)) {
-        return false;
+        /*
+         * Mark feature as enabled in 'cpu->hyperv_features' as
+         * hv_build_cpuid_leaf() uses this info to build guest CPUIDs.
+         */
+        for (feat = 0; feat < ARRAY_SIZE(kvm_hyperv_properties); feat++) {
+            if (hyperv_feature_supported(cs, feat)) {
+                cpu->hyperv_features |= BIT(feat);
+            }
+        }
+    } else {
+        /* Check features availability and dependencies */
+        for (feat = 0; feat < ARRAY_SIZE(kvm_hyperv_properties); feat++) {
+            /* If the feature was not requested skip it. */
+            if (!hyperv_feat_enabled(cpu, feat)) {
+                continue;
+            }
+
+            /* Check if the feature is supported by KVM */
+            if (!hyperv_feature_supported(cs, feat)) {
+                error_setg(errp, "Hyper-V %s is not supported by kernel",
+                           kvm_hyperv_properties[feat].desc);
+                return false;
+            }
+
+            /* Check dependencies */
+            if (!hv_feature_check_deps(cpu, feat, &local_err)) {
+                error_propagate(errp, local_err);
+                return false;
+            }
+        }
     }
 
     /* Additional dependencies not covered by kvm_hyperv_properties[] */
-- 
2.31.1

