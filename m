Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7A0D6F14DD
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 12:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345778AbjD1KB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 06:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230302AbjD1KA7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 06:00:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3462B5BA9
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 02:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682675940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wQmH/h07VcoDbgOeY9+f2WBqaMnVguFCiHes1+6R3Fc=;
        b=hhCxIH9O+O3RE05yMhJer+KOeLICzPT+Z7edu7WhsEYojqqn9aAjiW1M2cvZx8FXZ1cUbZ
        ocyakVyxK2w+syUHjTIJDBVv3ugWazdhtxGll6yzufVbvImIZLG6CgIOlgPgwuXRswAT1B
        IA/XYfo/qVfSLSYXoeMhxM+GZMN7Yq0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-451-IlMtwPrsNuqedzGk4uh4uA-1; Fri, 28 Apr 2023 05:55:41 -0400
X-MC-Unique: IlMtwPrsNuqedzGk4uh4uA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 47D1A185A790;
        Fri, 28 Apr 2023 09:55:41 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.39.193.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 414041121314;
        Fri, 28 Apr 2023 09:55:39 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Andrea Bolognani <abologna@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v7 1/1] arm/kvm: add support for MTE
Date:   Fri, 28 Apr 2023 11:55:33 +0200
Message-Id: <20230428095533.21747-2-cohuck@redhat.com>
In-Reply-To: <20230428095533.21747-1-cohuck@redhat.com>
References: <20230428095533.21747-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Extend the 'mte' property for the virt machine to cover KVM as
well. For KVM, we don't allocate tag memory, but instead enable the
capability.

If MTE has been enabled, we need to disable migration, as we do not
yet have a way to migrate the tags as well. Therefore, MTE will stay
off with KVM unless requested explicitly.

Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 hw/arm/virt.c        | 69 +++++++++++++++++++++++++-------------------
 target/arm/cpu.c     |  9 +++---
 target/arm/cpu.h     |  4 +++
 target/arm/kvm.c     | 35 ++++++++++++++++++++++
 target/arm/kvm64.c   |  5 ++++
 target/arm/kvm_arm.h | 19 ++++++++++++
 6 files changed, 107 insertions(+), 34 deletions(-)

diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index a89d699f0b76..544a6c5bec8f 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -2146,7 +2146,7 @@ static void machvirt_init(MachineState *machine)
         exit(1);
     }
 
-    if (vms->mte && (kvm_enabled() || hvf_enabled())) {
+    if (vms->mte && hvf_enabled()) {
         error_report("mach-virt: %s does not support providing "
                      "MTE to the guest CPU",
                      current_accel_name());
@@ -2216,39 +2216,48 @@ static void machvirt_init(MachineState *machine)
         }
 
         if (vms->mte) {
-            /* Create the memory region only once, but link to all cpus. */
-            if (!tag_sysmem) {
-                /*
-                 * The property exists only if MemTag is supported.
-                 * If it is, we must allocate the ram to back that up.
-                 */
-                if (!object_property_find(cpuobj, "tag-memory")) {
-                    error_report("MTE requested, but not supported "
-                                 "by the guest CPU");
-                    exit(1);
+            if (tcg_enabled()) {
+                /* Create the memory region only once, but link to all cpus. */
+                if (!tag_sysmem) {
+                    /*
+                     * The property exists only if MemTag is supported.
+                     * If it is, we must allocate the ram to back that up.
+                     */
+                    if (!object_property_find(cpuobj, "tag-memory")) {
+                        error_report("MTE requested, but not supported "
+                                     "by the guest CPU");
+                        exit(1);
+                    }
+
+                    tag_sysmem = g_new(MemoryRegion, 1);
+                    memory_region_init(tag_sysmem, OBJECT(machine),
+                                       "tag-memory", UINT64_MAX / 32);
+
+                    if (vms->secure) {
+                        secure_tag_sysmem = g_new(MemoryRegion, 1);
+                        memory_region_init(secure_tag_sysmem, OBJECT(machine),
+                                           "secure-tag-memory",
+                                           UINT64_MAX / 32);
+
+                        /* As with ram, secure-tag takes precedence over tag. */
+                        memory_region_add_subregion_overlap(secure_tag_sysmem,
+                                                            0, tag_sysmem, -1);
+                    }
                 }
 
-                tag_sysmem = g_new(MemoryRegion, 1);
-                memory_region_init(tag_sysmem, OBJECT(machine),
-                                   "tag-memory", UINT64_MAX / 32);
-
+                object_property_set_link(cpuobj, "tag-memory",
+                                         OBJECT(tag_sysmem), &error_abort);
                 if (vms->secure) {
-                    secure_tag_sysmem = g_new(MemoryRegion, 1);
-                    memory_region_init(secure_tag_sysmem, OBJECT(machine),
-                                       "secure-tag-memory", UINT64_MAX / 32);
-
-                    /* As with ram, secure-tag takes precedence over tag.  */
-                    memory_region_add_subregion_overlap(secure_tag_sysmem, 0,
-                                                        tag_sysmem, -1);
+                    object_property_set_link(cpuobj, "secure-tag-memory",
+                                             OBJECT(secure_tag_sysmem),
+                                             &error_abort);
                 }
-            }
-
-            object_property_set_link(cpuobj, "tag-memory", OBJECT(tag_sysmem),
-                                     &error_abort);
-            if (vms->secure) {
-                object_property_set_link(cpuobj, "secure-tag-memory",
-                                         OBJECT(secure_tag_sysmem),
-                                         &error_abort);
+            } else if (kvm_enabled()) {
+                if (!kvm_arm_mte_supported()) {
+                    error_report("MTE requested, but not supported by KVM");
+                    exit(1);
+                }
+                kvm_arm_enable_mte(cpuobj, &error_abort);
             }
         }
 
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index 5182ed0c9113..f6a88e52ac21 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1480,6 +1480,7 @@ void arm_cpu_post_init(Object *obj)
                                      qdev_prop_allow_set_link_before_realize,
                                      OBJ_PROP_LINK_STRONG);
         }
+        cpu->has_mte = true;
     }
 #endif
 }
@@ -1616,7 +1617,7 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
         }
         if (cpu->tag_memory) {
             error_setg(errp,
-                       "Cannot enable %s when guest CPUs has MTE enabled",
+                       "Cannot enable %s when guest CPUs has tag memory enabled",
                        current_accel_name());
             return;
         }
@@ -1996,10 +1997,10 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
     }
 
 #ifndef CONFIG_USER_ONLY
-    if (cpu->tag_memory == NULL && cpu_isar_feature(aa64_mte, cpu)) {
+    if (!cpu->has_mte && cpu_isar_feature(aa64_mte, cpu)) {
         /*
-         * Disable the MTE feature bits if we do not have tag-memory
-         * provided by the machine.
+         * Disable the MTE feature bits if we do not have the feature
+         * setup by the machine.
          */
         cpu->isar.id_aa64pfr1 =
             FIELD_DP64(cpu->isar.id_aa64pfr1, ID_AA64PFR1, MTE, 0);
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index d469a2637b32..c3463e39bcdf 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -935,6 +935,9 @@ struct ArchCPU {
      */
     uint32_t psci_conduit;
 
+    /* CPU has Memory Tag Extension */
+    bool has_mte;
+
     /* For v8M, initial value of the Secure VTOR */
     uint32_t init_svtor;
     /* For v8M, initial value of the Non-secure VTOR */
@@ -1053,6 +1056,7 @@ struct ArchCPU {
     bool prop_pauth;
     bool prop_pauth_impdef;
     bool prop_lpa2;
+    OnOffAuto prop_mte;
 
     /* DCZ blocksize, in log_2(words), ie low 4 bits of DCZID_EL0 */
     uint32_t dcz_blocksize;
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 84da49332c4b..9553488ecd13 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -31,6 +31,7 @@
 #include "hw/boards.h"
 #include "hw/irq.h"
 #include "qemu/log.h"
+#include "migration/blocker.h"
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_LAST_INFO
@@ -1064,3 +1065,37 @@ bool kvm_arch_cpu_check_are_resettable(void)
 void kvm_arch_accel_class_init(ObjectClass *oc)
 {
 }
+
+void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
+{
+    static bool tried_to_enable;
+    static bool succeeded_to_enable;
+    Error *mte_migration_blocker = NULL;
+    int ret;
+
+    if (!tried_to_enable) {
+        /*
+         * MTE on KVM is enabled on a per-VM basis (and retrying doesn't make
+         * sense), and we only want a single migration blocker as well.
+         */
+        tried_to_enable = true;
+
+        ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_ARM_MTE, 0);
+        if (ret) {
+            error_setg_errno(errp, -ret, "Failed to enable KVM_CAP_ARM_MTE");
+            return;
+        }
+
+        /* TODO: add proper migration support with MTE enabled */
+        error_setg(&mte_migration_blocker,
+                   "Live migration disabled due to MTE enabled");
+        if (migrate_add_blocker(mte_migration_blocker, errp)) {
+            error_free(mte_migration_blocker);
+            return;
+        }
+        succeeded_to_enable = true;
+    }
+    if (succeeded_to_enable) {
+        object_property_set_bool(cpuobj, "has_mte", true, NULL);
+    }
+}
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index 810db33ccbd6..1893f3879363 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -756,6 +756,11 @@ bool kvm_arm_steal_time_supported(void)
     return kvm_check_extension(kvm_state, KVM_CAP_STEAL_TIME);
 }
 
+bool kvm_arm_mte_supported(void)
+{
+    return kvm_check_extension(kvm_state, KVM_CAP_ARM_MTE);
+}
+
 QEMU_BUILD_BUG_ON(KVM_ARM64_SVE_VQ_MIN != 1);
 
 uint32_t kvm_arm_sve_get_vls(CPUState *cs)
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index 330fbe5c7220..2083547bf604 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -313,6 +313,13 @@ bool kvm_arm_pmu_supported(void);
  */
 bool kvm_arm_sve_supported(void);
 
+/**
+ * kvm_arm_mte_supported:
+ *
+ * Returns: true if KVM can enable MTE, and false otherwise.
+ */
+bool kvm_arm_mte_supported(void);
+
 /**
  * kvm_arm_get_max_vm_ipa_size:
  * @ms: Machine state handle
@@ -377,6 +384,8 @@ void kvm_arm_pvtime_init(CPUState *cs, uint64_t ipa);
 
 int kvm_arm_set_irq(int cpu, int irqtype, int irq, int level);
 
+void kvm_arm_enable_mte(Object *cpuobj, Error **errp);
+
 #else
 
 /*
@@ -403,6 +412,11 @@ static inline bool kvm_arm_steal_time_supported(void)
     return false;
 }
 
+static inline bool kvm_arm_mte_supported(void)
+{
+    return false;
+}
+
 /*
  * These functions should never actually be called without KVM support.
  */
@@ -451,6 +465,11 @@ static inline uint32_t kvm_arm_sve_get_vls(CPUState *cs)
     g_assert_not_reached();
 }
 
+static inline void kvm_arm_enable_mte(Object *cpuobj, Error **errp)
+{
+    g_assert_not_reached();
+}
+
 #endif
 
 static inline const char *gic_class_name(void)
-- 
2.40.0

