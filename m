Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CC648368D
	for <lists+kvm@lfdr.de>; Mon,  3 Jan 2022 19:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233921AbiACSFW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Jan 2022 13:05:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiACSFV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Jan 2022 13:05:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F80C061761
        for <kvm@vger.kernel.org>; Mon,  3 Jan 2022 10:05:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA0B3B8106E
        for <kvm@vger.kernel.org>; Mon,  3 Jan 2022 18:05:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8FCC36AED;
        Mon,  3 Jan 2022 18:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641233118;
        bh=46LzaabE5JO+VdKf/ZcHCIviP0rFsFeqsrT763OHO+c=;
        h=From:To:Cc:Subject:Date:From;
        b=cTfBL0kiT+IgyMzFYIHYcnfl9MTrJFb4oj3cUL4RwTeUS4XaMA8HOHl5JLJikKHee
         P2CcNKbUFFn/OjAkH+ZfpK+5IbR2+X/tz1FXBZ6RK03JADxwIYXVeFfK29pFKt6OWl
         PCyr0ujtjjR/vb9NcOXZPOEuXKIZbmlzfwDSQisYOaQi33K46hCMlGcLxYjGcz5cSD
         gI64RDDtebpgF9w7jdob316RRK/o/1SihFlDJevRuUJwIJ6/CP+UdC7ktRmPCYDN9T
         bM3gOj/x9BbGsfyWtHNP1W0jIdxt1qt/eAbdUu6IdUB+SLDr5vo+qmHs71eOS1mxs5
         VSGW+ogtC88Gg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1n4Rhs-00Fl0p-D0; Mon, 03 Jan 2022 18:05:16 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     qemu-devel@nongnu.org
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com, Eric Auger <eric.auger@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>
Subject: [PATCH v2] hw/arm/virt: KVM: Enable PAuth when supported by the host
Date:   Mon,  3 Jan 2022 18:05:07 +0000
Message-Id: <20220103180507.2190429-1-maz@kernel.org>
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
property. The 'pauth' comment is removed from cpu-features.rst,
as it is now common to both TCG and KVM.

Tested on an Apple M1 running 5.16-rc6.

Cc: Eric Auger <eric.auger@redhat.com>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Richard Henderson <richard.henderson@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
* From v1:
  - Drop 'pauth' documentation
  - Make the TCG path common to both TCG and KVM
  - Some tidying up

 docs/system/arm/cpu-features.rst |  4 ----
 target/arm/cpu.c                 | 14 ++++----------
 target/arm/cpu.h                 |  1 +
 target/arm/cpu64.c               | 33 ++++++++++++++++++++++++++++----
 target/arm/kvm64.c               | 21 ++++++++++++++++++++
 5 files changed, 55 insertions(+), 18 deletions(-)

diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
index 584eb17097..3e626c4b68 100644
--- a/docs/system/arm/cpu-features.rst
+++ b/docs/system/arm/cpu-features.rst
@@ -217,10 +217,6 @@ TCG VCPU Features
 TCG VCPU features are CPU features that are specific to TCG.
 Below is the list of TCG VCPU features and their descriptions.
 
-  pauth                    Enable or disable ``FEAT_Pauth``, pointer
-                           authentication.  By default, the feature is
-                           enabled with ``-cpu max``.
-
   pauth-impdef             When ``FEAT_Pauth`` is enabled, either the
                            *impdef* (Implementation Defined) algorithm
                            is enabled or the *architected* QARMA algorithm
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index a211804fd3..d96cc4ef18 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1380,18 +1380,11 @@ void arm_cpu_finalize_features(ARMCPU *cpu, Error **errp)
             return;
         }
 
-        /*
-         * KVM does not support modifications to this feature.
-         * We have not registered the cpu properties when KVM
-         * is in use, so the user will not be able to set them.
-         */
-        if (!kvm_enabled()) {
-            arm_cpu_pauth_finalize(cpu, &local_err);
-            if (local_err != NULL) {
+	arm_cpu_pauth_finalize(cpu, &local_err);
+	if (local_err != NULL) {
                 error_propagate(errp, local_err);
                 return;
-            }
-        }
+	}
     }
 
     if (kvm_enabled()) {
@@ -2091,6 +2084,7 @@ static void arm_host_initfn(Object *obj)
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
index 15245a60a8..d5c0bce1c4 100644
--- a/target/arm/cpu64.c
+++ b/target/arm/cpu64.c
@@ -630,6 +630,17 @@ void arm_cpu_pauth_finalize(ARMCPU *cpu, Error **errp)
     int arch_val = 0, impdef_val = 0;
     uint64_t t;
 
+    if (kvm_enabled()) {
+        if (cpu->prop_pauth) {
+            if (!cpu_isar_feature(aa64_pauth, cpu)) {
+                error_setg(errp, "'pauth' feature not supported by KVM on this host");
+            }
+
+            return;
+        }
+        /* Fall through to disable PAuth */
+    }
+
     /* TODO: Handle HaveEnhancedPAC, HaveEnhancedPAC2, HaveFPAC. */
     if (cpu->prop_pauth) {
         if (cpu->prop_pauth_impdef) {
@@ -655,6 +666,23 @@ static Property arm_cpu_pauth_property =
 static Property arm_cpu_pauth_impdef_property =
     DEFINE_PROP_BOOL("pauth-impdef", ARMCPU, prop_pauth_impdef, false);
 
+void aarch64_add_pauth_properties(Object *obj)
+{
+    ARMCPU *cpu = ARM_CPU(obj);
+
+    /* Default to PAUTH on, with the architected algorithm on TCG. */
+    qdev_property_add_static(DEVICE(obj), &arm_cpu_pauth_property);
+    if (kvm_enabled()) {
+        /*
+         * Mirror PAuth support from the probed sysregs back into the
+         * property for KVM. Is it just a bit backward? Yes it is!
+         */
+        cpu->prop_pauth = cpu_isar_feature(aa64_pauth, cpu);
+    } else {
+        qdev_property_add_static(DEVICE(obj), &arm_cpu_pauth_impdef_property);
+    }
+}
+
 /* -cpu max: if KVM is enabled, like -cpu host (best possible with this host);
  * otherwise, a CPU with as many features enabled as our emulation supports.
  * The version of '-cpu max' for qemu-system-arm is defined in cpu.c;
@@ -829,13 +857,10 @@ static void aarch64_max_initfn(Object *obj)
         cpu->dcz_blocksize = 7; /*  512 bytes */
 #endif
 
-        /* Default to PAUTH on, with the architected algorithm. */
-        qdev_property_add_static(DEVICE(obj), &arm_cpu_pauth_property);
-        qdev_property_add_static(DEVICE(obj), &arm_cpu_pauth_impdef_property);
-
         bitmap_fill(cpu->sve_vq_supported, ARM_MAX_VQ);
     }
 
+    aarch64_add_pauth_properties(obj);
     aarch64_add_sve_properties(obj);
     object_property_add(obj, "sve-max-vq", "uint32", cpu_max_get_sve_max_vq,
                         cpu_max_set_sve_max_vq, NULL, NULL);
diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index e790d6c9a5..5c425bc074 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -491,6 +491,12 @@ static int read_sys_reg64(int fd, uint64_t *pret, uint64_t id)
     return ioctl(fd, KVM_GET_ONE_REG, &idreg);
 }
 
+static bool kvm_arm_pauth_supported(void)
+{
+    return (kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_ADDRESS) &&
+            kvm_check_extension(kvm_state, KVM_CAP_ARM_PTRAUTH_GENERIC));
+}
+
 bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
 {
     /* Identify the feature bits corresponding to the host CPU, and
@@ -521,6 +527,17 @@ bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
      */
     struct kvm_vcpu_init init = { .target = -1, };
 
+    /*
+     * Ask for Pointer Authentication if supported. We can't play the
+     * SVE trick of synthetising the ID reg as KVM won't tell us
+     * whether we have the architected or IMPDEF version of PAuth, so
+     * we have to use the actual ID regs.
+     */
+    if (kvm_arm_pauth_supported()) {
+        init.features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
+			     1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
+    }
+
     if (!kvm_arm_create_scratch_host_vcpu(cpus_to_try, fdarray, &init)) {
         return false;
     }
@@ -865,6 +882,10 @@ int kvm_arch_init_vcpu(CPUState *cs)
         assert(kvm_arm_sve_supported());
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_SVE;
     }
+    if (cpu_isar_feature(aa64_pauth, cpu)) {
+	    cpu->kvm_init_features[0] |= (1 << KVM_ARM_VCPU_PTRAUTH_ADDRESS |
+					  1 << KVM_ARM_VCPU_PTRAUTH_GENERIC);
+    }
 
     /* Do KVM_ARM_VCPU_INIT ioctl */
     ret = kvm_arm_vcpu_init(cs);
-- 
2.30.2

