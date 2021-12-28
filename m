Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9654F480C7C
	for <lists+kvm@lfdr.de>; Tue, 28 Dec 2021 19:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbhL1SYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Dec 2021 13:24:03 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:53532 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231811AbhL1SYD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Dec 2021 13:24:03 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B28BB816F3
        for <kvm@vger.kernel.org>; Tue, 28 Dec 2021 18:24:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A44C36AEC;
        Tue, 28 Dec 2021 18:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640715840;
        bh=lRL3mGYYt6TApsrZ0KqfGyxx50dFQ5n+tjaGT/fDdQU=;
        h=From:To:Cc:Subject:Date:From;
        b=Ze9NmLF91pBA6WFf81RxyU8wmYc5EsavrMgCBmOcFaO007Tuwu3xRYWtiwzB9JMWw
         uFuw0jXBdEPvTkeQph0AfE6FbvkLe7y4EfZSMIeqjmaWFCy79w0bo2hOrcYf+8xihs
         Aytdivla/ptptj65SKQ4IvzZMYQ0dDT2So7ak0eoExefJHVM6b7r1aHC0Fe6u+zhlz
         jdga8uHjBxuroWykR5uLubNOaSeX2kobN0fbZFcNTCYpSaIFLftjQkabeNTGug8oVw
         lRu0y6eCaecw5FiPCfhje026d5yCYyQoiDCMmzJZJ7e3hxpS8OGj2PcFBV4szicArR
         AE4xwYL0arQMg==
Received: from cfbb000407.r.cam.camfibre.uk ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n2H8g-00Elcr-Mk; Tue, 28 Dec 2021 18:23:58 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Eric Auger <eric.auger@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH] hw/arm/virt: KVM: Enable PAuth when supported by the host
Date:   Tue, 28 Dec 2021 18:23:47 +0000
Message-Id: <20211228182347.1025501-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: qemu-devel@nongnu.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com, eric.auger@redhat.com, drjones@redhat.com, richard.henderson@linaro.org, peter.maydell@linaro.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add basic support for Pointer Authentication when running a KVM
guest and that the host supports it, loosely based on the SVE
support.

Although the feature is enabled by default when the host advertises
it, it is possible to disable it by setting the 'pauth=off' CPU
property.

Tested on an Apple M1 running 5.16-rc6.

Cc: Eric Auger <eric.auger@redhat.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 docs/system/arm/cpu-features.rst |  5 +++++
 target/arm/cpu.c                 |  1 +
 target/arm/cpu.h                 |  1 +
 target/arm/cpu64.c               | 36 ++++++++++++++++++++++++++++++++
 target/arm/kvm.c                 | 13 ++++++++++++
 target/arm/kvm64.c               | 10 +++++++++
 target/arm/kvm_arm.h             |  7 +++++++
 7 files changed, 73 insertions(+)

diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
index 584eb17097..c9e39546a5 100644
--- a/docs/system/arm/cpu-features.rst
+++ b/docs/system/arm/cpu-features.rst
@@ -211,6 +211,11 @@ the list of KVM VCPU features and their descriptions.
                            influence the guest scheduler behavior and/or be
                            exposed to the guest userspace.
 
+  pauth                    Enable or disable ``FEAT_Pauth``, pointer
+                           authentication.  By default, the feature is enabled
+                           with ``-cpu host`` if supported by both the host
+                           kernel and the hardware.
+
 TCG VCPU Features
 =================
 
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index a211804fd3..68b09cbc6a 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -2091,6 +2091,7 @@ static void arm_host_initfn(Object *obj)
     kvm_arm_set_cpu_features_from_host(cpu);
     if (arm_feature(&cpu->env, ARM_FEATURE_AARCH64)) {
         aarch64_add_sve_properties(obj);
+        aarch64_add_pauth_properties(obj);
     }
 #else
     hvf_arm_set_cpu_features_from_host(cpu);
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index e33f37b70a..c6a4d50e82 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1076,6 +1076,7 @@ void aarch64_sve_narrow_vq(CPUARMState *env, unsigned vq);
 void aarch64_sve_change_el(CPUARMState *env, int old_el,
                            int new_el, bool el0_a64);
 void aarch64_add_sve_properties(Object *obj);
+void aarch64_add_pauth_properties(Object *obj);
 
 /*
  * SVE registers are encoded in KVM's memory in an endianness-invariant format.
diff --git a/target/arm/cpu64.c b/target/arm/cpu64.c
index 15245a60a8..305c0e19fe 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -625,6 +625,42 @@ void aarch64_add_sve_properties(Object *obj)
 #endif
 }
 
+static bool cpu_arm_get_pauth(Object *obj, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    return cpu_isar_feature(aa64_pauth, cpu);
+}
+
+static void cpu_arm_set_pauth(Object *obj, bool value, Error **errp)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+    uint64_t t;
+
+    if (value) {
+        if (!kvm_arm_pauth_supported()) {
+            error_setg(errp, "'pauth' feature not supported by KVM on this host");
+        }
+
+        return;
+    }
+
+    /*
+     * If the host supports PAuth, we only end-up here if the user has
+     * disabled the support, and value is false.
+     */
+    t = cpu->isar.id_aa64isar1;
+    t = FIELD_DP64(t, ID_AA64ISAR1, APA, value);
+    t = FIELD_DP64(t, ID_AA64ISAR1, GPA, value);
+    t = FIELD_DP64(t, ID_AA64ISAR1, API, value);
+    t = FIELD_DP64(t, ID_AA64ISAR1, GPI, value);
+    cpu->isar.id_aa64isar1 = t;
+}
+
+void aarch64_add_pauth_properties(Object *obj)
+{
+    object_property_add_bool(obj, "pauth", cpu_arm_get_pauth, cpu_arm_set_pauth);
+}
+
 void arm_cpu_pauth_finalize(ARMCPU *cpu, Error **errp)
 {
     int arch_val = 0, impdef_val = 0;
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index bbf1ce7ba3..71e2f46ce8 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -84,6 +84,7 @@ bool kvm_arm_create_scratch_host_vcpu(const uint32_t *cpus_to_try,
     if (vmfd < 0) {
         goto err;
     }
+
     cpufd = ioctl(vmfd, KVM_CREATE_VCPU, 0);
     if (cpufd < 0) {
         goto err;
@@ -94,6 +95,18 @@ bool kvm_arm_create_scratch_host_vcpu(const uint32_t *cpus_to_try,
         goto finish;
     }
 
+    /*
+     * Ask for Pointer Authentication if supported. We can't play the
+     * SVE trick of synthetising the ID reg as KVM won't tell us
+     * whether we have the architected or IMPDEF version of PAuth, so
+     * we have to use the actual ID regs.
+     */
+    if (ioctl(vmfd, KVM_CHECK_EXTENSION, KVM_CAP_ARM_PTRAUTH_ADDRESS) > 0 &&
+        ioctl(vmfd, KVM_CHECK_EXTENSION, KVM_CAP_ARM_PTRAUTH_GENERIC) > 0) {
+        init->features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
+                              1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
+    }
+
     if (init->target == -1) {
         struct kvm_vcpu_init preferred;
 
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index e790d6c9a5..95b6902ca0 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -725,6 +725,12 @@ bool kvm_arm_sve_supported(void)
     return kvm_check_extension(kvm_state, KVM_CAP_ARM_SVE);
 }
 
+bool kvm_arm_pauth_supported(void)
+{
+    return (kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
+            kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
+}
+
 bool kvm_arm_steal_time_supported(void)
 {
     return kvm_check_extension(kvm_state, KVM_CAP_STEAL_TIME);
@@ -865,6 +871,10 @@ int kvm_arch_init_vcpu(CPUState *cs)
         assert(kvm_arm_sve_supported());
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_SVE;
     }
+    if (cpu_isar_feature(aa64_pauth, cpu)) {
+	    cpu->kvm_init_features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
+					  1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
+    }
 
     /* Do KVM_ARM_VCPU_INIT ioctl */
     ret = kvm_arm_vcpu_init(cs);
diff --git a/target/arm/kvm_arm.h b/target/arm/kvm_arm.h
index b7f78b5215..c26acf7866 100644
--- a/target/arm/kvm_arm.h
+++ b/target/arm/kvm_arm.h
@@ -306,6 +306,13 @@ bool kvm_arm_pmu_supported(void);
  */
 bool kvm_arm_sve_supported(void);
 
+/**
+ * kvm_arm_pauth_supported:
+ *
+ * Returns true if KVM can enable Pointer Authentication and false otherwise.
+ */
+bool kvm_arm_pauth_supported(void);
+
 /**
  * kvm_arm_get_max_vm_ipa_size:
  * @ms: Machine state handle
-- 
2.30.2

