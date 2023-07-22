Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856F975DAE5
	for <lists+kvm@lfdr.de>; Sat, 22 Jul 2023 09:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjGVHxS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 22 Jul 2023 03:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231374AbjGVHxR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 22 Jul 2023 03:53:17 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79ADB272C
        for <kvm@vger.kernel.org>; Sat, 22 Jul 2023 00:53:16 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-55adfa61199so1838334a12.2
        for <kvm@vger.kernel.org>; Sat, 22 Jul 2023 00:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20221208.gappssmtp.com; s=20221208; t=1690012396; x=1690617196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kND/sAP1+EQqRnqZy1RjucLWpLyH8kHXjE52zNB0+ZU=;
        b=Moy59jSUR5Q5FfApC1LIDlkWsmSk+YrGjB3x+mEpsBzx5LtkqYZmv37L91WTkgV3QR
         6f84OPD0bRyh1ORn2Q6env+y3s28e3hps0HQ/o/N08pTh9R+jP2VB8TkdE3ao5l1KgLx
         +aWZSpE+XAO8Z9VEKWFt8aoIos/eH2FfdTo23jn6Y5qmofOtz0ZaUOargx8DiAiK8qGf
         NlfyD34mLhDuvRKmSRcWJcnEQnHIid/KV2rNnjPx5DhB1inRsMIuGRuLmwIcYaR59wAF
         1GcCw3cgFH/rUU71eyVo+m1YRQ3Bw18VWseSB7Zf8g4n37nXwm0kruY7r2D9XTDdz02N
         xjRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690012396; x=1690617196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kND/sAP1+EQqRnqZy1RjucLWpLyH8kHXjE52zNB0+ZU=;
        b=NO4RSL7ffajDAPUpm1LXhbur2Ywq6ia4bCecBD8buJpTPOp+bS6+0gaLwrxl59tBOO
         D1Jo168C/4vgPMdSzaj4LxfgizyGOUXWzmzaY47VvirpFYpSlvkGrIPauCc1pi6IIxpy
         gdiEgCoE7b9gC6nGmRn8QqlGjKDwhZPlZoygW4u0NtDXNdY39raFqLoT2C7vlXANKikT
         r2sMsEn/QCivjw/qq/L6++RuHQ6tlmwY0VOPrV6DxX4wIjLFO3xp6u/LVyOOK4gkkMHk
         CL7Yjzwt3Un3SBIMfwGYDGAVfYI1HJtDKKWkJWHqzy0qZnB0eznFTA+5+/Q/WTZJIxGH
         6QpA==
X-Gm-Message-State: ABy/qLZWeTao1XZXzXDueNEodCrc/2un7Mk+6R9SbVGinMOPaR97z3mO
        W+3lYKCQSu0FRuKj5ZmaiE71AA==
X-Google-Smtp-Source: APBJJlGhrffeFgp/eUmNMdD/FDTaf+VpGUAzUGGWFSfWygzljANFOq6Jmpu/R5I6ZwXnWmL+lZ9DCg==
X-Received: by 2002:a17:902:70c3:b0:1bb:59da:77f8 with SMTP id l3-20020a17090270c300b001bb59da77f8mr3910422plt.48.1690012395965;
        Sat, 22 Jul 2023 00:53:15 -0700 (PDT)
Received: from alarm.flets-east.jp ([2400:4050:a840:1e00:78d2:b862:10a7:d486])
        by smtp.gmail.com with ESMTPSA id i17-20020a17090332d100b001b86dd825e7sm4753119plr.108.2023.07.22.00.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jul 2023 00:53:15 -0700 (PDT)
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: [PATCH v4 1/2] kvm: Introduce kvm_arch_get_default_type hook
Date:   Sat, 22 Jul 2023 16:53:05 +0900
Message-ID: <20230722075308.26560-2-akihiko.odaki@daynix.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230722075308.26560-1-akihiko.odaki@daynix.com>
References: <20230722075308.26560-1-akihiko.odaki@daynix.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_arch_get_default_type() returns the default KVM type. This hook is
particularly useful to derive a KVM type that is valid for "none"
machine model, which is used by libvirt to probe the availability of
KVM.

For MIPS, the existing mips_kvm_type() is reused. This function ensures
the availability of VZ which is mandatory to use KVM on the current
QEMU.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 include/sysemu/kvm.h     | 2 ++
 target/mips/kvm_mips.h   | 9 ---------
 accel/kvm/kvm-all.c      | 4 +++-
 hw/mips/loongson3_virt.c | 2 --
 target/arm/kvm.c         | 5 +++++
 target/i386/kvm/kvm.c    | 5 +++++
 target/mips/kvm.c        | 2 +-
 target/ppc/kvm.c         | 5 +++++
 target/riscv/kvm.c       | 5 +++++
 target/s390x/kvm/kvm.c   | 5 +++++
 10 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 115f0cca79..ccaf55caf7 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -369,6 +369,8 @@ int kvm_arch_get_registers(CPUState *cpu);
 
 int kvm_arch_put_registers(CPUState *cpu, int level);
 
+int kvm_arch_get_default_type(MachineState *ms);
+
 int kvm_arch_init(MachineState *ms, KVMState *s);
 
 int kvm_arch_init_vcpu(CPUState *cpu);
diff --git a/target/mips/kvm_mips.h b/target/mips/kvm_mips.h
index 171d53dbe1..c711269d0a 100644
--- a/target/mips/kvm_mips.h
+++ b/target/mips/kvm_mips.h
@@ -25,13 +25,4 @@ void kvm_mips_reset_vcpu(MIPSCPU *cpu);
 int kvm_mips_set_interrupt(MIPSCPU *cpu, int irq, int level);
 int kvm_mips_set_ipi_interrupt(MIPSCPU *cpu, int irq, int level);
 
-#ifdef CONFIG_KVM
-int mips_kvm_type(MachineState *machine, const char *vm_type);
-#else
-static inline int mips_kvm_type(MachineState *machine, const char *vm_type)
-{
-    return 0;
-}
-#endif
-
 #endif /* KVM_MIPS_H */
diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 373d876c05..d591b5079c 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2458,7 +2458,7 @@ static int kvm_init(MachineState *ms)
     KVMState *s;
     const KVMCapabilityInfo *missing_cap;
     int ret;
-    int type = 0;
+    int type;
     uint64_t dirty_log_manual_caps;
 
     qemu_mutex_init(&kml_slots_lock);
@@ -2523,6 +2523,8 @@ static int kvm_init(MachineState *ms)
         type = mc->kvm_type(ms, kvm_type);
     } else if (mc->kvm_type) {
         type = mc->kvm_type(ms, NULL);
+    } else {
+        type = kvm_arch_get_default_type(ms);
     }
 
     do {
diff --git a/hw/mips/loongson3_virt.c b/hw/mips/loongson3_virt.c
index 4018b8c1d3..a2c56f7a21 100644
--- a/hw/mips/loongson3_virt.c
+++ b/hw/mips/loongson3_virt.c
@@ -29,7 +29,6 @@
 #include "qemu/datadir.h"
 #include "qapi/error.h"
 #include "elf.h"
-#include "kvm_mips.h"
 #include "hw/char/serial.h"
 #include "hw/intc/loongson_liointc.h"
 #include "hw/mips/mips.h"
@@ -612,7 +611,6 @@ static void loongson3v_machine_class_init(ObjectClass *oc, void *data)
     mc->max_cpus = LOONGSON_MAX_VCPUS;
     mc->default_ram_id = "loongson3.highram";
     mc->default_ram_size = 1600 * MiB;
-    mc->kvm_type = mips_kvm_type;
     mc->minimum_page_bits = 14;
     mc->default_nic = "virtio-net-pci";
 }
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index b4c7654f49..40f577bfd5 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -247,6 +247,11 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
     return ret > 0 ? ret : 40;
 }
 
+int kvm_arch_get_default_type(MachineState *ms)
+{
+    return 0;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     int ret = 0;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ebfaf3d24c..b45ce20fd8 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2556,6 +2556,11 @@ static void register_smram_listener(Notifier *n, void *unused)
                                  &smram_address_space, 1, "kvm-smram");
 }
 
+int kvm_arch_get_default_type(MachineState *ms)
+{
+    return 0;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     uint64_t identity_base = 0xfffbc000;
diff --git a/target/mips/kvm.c b/target/mips/kvm.c
index c14e8f550f..e98aad01bd 100644
--- a/target/mips/kvm.c
+++ b/target/mips/kvm.c
@@ -1266,7 +1266,7 @@ int kvm_arch_msi_data_to_gsi(uint32_t data)
     abort();
 }
 
-int mips_kvm_type(MachineState *machine, const char *vm_type)
+int kvm_arch_get_default_type(MachineState *machine)
 {
 #if defined(KVM_CAP_MIPS_VZ)
     int r;
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index a8a935e267..dc1182cd37 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -108,6 +108,11 @@ static int kvm_ppc_register_host_cpu_type(void);
 static void kvmppc_get_cpu_characteristics(KVMState *s);
 static int kvmppc_get_dec_bits(void);
 
+int kvm_arch_get_default_type(MachineState *ms)
+{
+    return 0;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     cap_interrupt_unset = kvm_check_extension(s, KVM_CAP_PPC_UNSET_IRQ);
diff --git a/target/riscv/kvm.c b/target/riscv/kvm.c
index 9d8a8982f9..4266dce092 100644
--- a/target/riscv/kvm.c
+++ b/target/riscv/kvm.c
@@ -907,6 +907,11 @@ int kvm_arch_add_msi_route_post(struct kvm_irq_routing_entry *route,
     return 0;
 }
 
+int kvm_arch_get_default_type(MachineState *ms)
+{
+    return 0;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     return 0;
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index a9e5880349..9117fab6e8 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -340,6 +340,11 @@ static void ccw_machine_class_foreach(ObjectClass *oc, void *opaque)
     mc->default_cpu_type = S390_CPU_TYPE_NAME("host");
 }
 
+int kvm_arch_get_default_type(MachineState *ms)
+{
+    return 0;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     object_class_foreach(ccw_machine_class_foreach, TYPE_S390_CCW_MACHINE,
-- 
2.41.0

