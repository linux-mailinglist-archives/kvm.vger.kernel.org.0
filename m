Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9EED761850
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 14:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbjGYM1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 08:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbjGYM1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 08:27:03 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373C21FE5
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 05:26:34 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-992acf67388so804944166b.1
        for <kvm@vger.kernel.org>; Tue, 25 Jul 2023 05:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1690287963; x=1690892763;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=S9g/QXvNb+Lw5hryvZ+h5Q3ejbTwi1aaqLCSFFIeoFk=;
        b=B1pG80vbUbbmEYYjsv8ikBP+qr22ahaM2RuukWwfy0lTFnOS31O76cRS2eZ1GVIHnW
         37Zz0ZJ+cQMLLXui9SV7ArPor3JxyhgO1L+TXcHIXviqznohkcmDq4WggcWD1U5S/Gbx
         wofvGXykFdIYav9v8DDONmziDdYPj59/JhmXgJrFfxN8msdSAgktB+Y0Pie/zhOgMRWQ
         Ac4Hch1I5G2aXVnUTO1rc63DKjQES3zEpBS9O8/fZkvQhI5eWobqBA2gjYZ4mUHtTDQ6
         31M4Zqzli1QqAaaJCPPQ0pq1u2b2dpg2oNN9jZ0i+OoWbYAQPF+KwXbrMMR40vhl1rbv
         Wr1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690287963; x=1690892763;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=S9g/QXvNb+Lw5hryvZ+h5Q3ejbTwi1aaqLCSFFIeoFk=;
        b=eAC71KXN7rQ65AWmRK1MHNzi6A8cqLhFg9a30KhisCwE5ph97Hc/OGCrRpeJxH9Nv8
         FDaxxLnuxp8Dp2TinSBs+TEUEANzeX6wIVbbsXMoJslbaXoKD++lRqzXAD2gVua219wj
         Iex67Hri0z32B5+jHt081jpXSgSqIyv+LNJvmYZ69PG1ulINXy14vL9c9EHv+Xc+VrgL
         1Z29SUltAmK2yVX9rucpWBoHgWzbP3lhqJFDsR2f3cuT2uXMUHNtXGDx1V/XZRpfMoQ/
         Hc9/ykpg6pQmnnPiN143zBmRjzfBclyVdwZz6sDX7ORhlHZmeHRYgsYyjHpYw43QzmQH
         Z6Kg==
X-Gm-Message-State: ABy/qLax4jAgcHQjhZSc54PgwC2Hxb/VocEHDpUx0xULibUabZ03zC8U
        4pn+Ssg7vSL86DK2sRxVJLVgRw==
X-Google-Smtp-Source: APBJJlGByS2FBy6hlFISQqdKBfSpm9tqzfHPMfoM9ZaEhm5fqOmk8jqIGO0W3SmqS03wfQeNYeaCrw==
X-Received: by 2002:a17:906:31d8:b0:994:2fa9:7446 with SMTP id f24-20020a17090631d800b009942fa97446mr11292939ejf.46.1690287963359;
        Tue, 25 Jul 2023 05:26:03 -0700 (PDT)
Received: from localhost (2001-1ae9-1c2-4c00-20f-c6b4-1e57-7965.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:20f:c6b4:1e57:7965])
        by smtp.gmail.com with ESMTPSA id b19-20020a170906039300b0099364d9f0e2sm8180676eja.98.2023.07.25.05.26.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 05:26:02 -0700 (PDT)
From:   Andrew Jones <ajones@ventanamicro.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, mtosatti@redhat.com, peter.maydell@linaro.org,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, thuth@redhat.com,
        dbarboza@ventanamicro.com, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, qemu-s390x@nongnu.org
Subject: [PATCH v2] kvm: Remove KVM_CREATE_IRQCHIP support assumption
Date:   Tue, 25 Jul 2023 14:26:02 +0200
Message-ID: <20230725122601.424738-2-ajones@ventanamicro.com>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-type: text/plain
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

Since Linux commit 00f918f61c56 ("RISC-V: KVM: Skeletal in-kernel AIA
irqchip support") checking KVM_CAP_IRQCHIP returns non-zero when the
RISC-V platform has AIA. The cap indicates KVM supports at least one
of the following ioctls:

  KVM_CREATE_IRQCHIP
  KVM_IRQ_LINE
  KVM_GET_IRQCHIP
  KVM_SET_IRQCHIP
  KVM_GET_LAPIC
  KVM_SET_LAPIC

but the cap doesn't imply that KVM must support any of those ioctls
in particular. However, QEMU was assuming the KVM_CREATE_IRQCHIP
ioctl was supported. Stop making that assumption by introducing a
KVM parameter that each architecture which supports KVM_CREATE_IRQCHIP
sets. Adding parameters isn't awesome, but given how the
KVM_CAP_IRQCHIP isn't very helpful on its own, we don't have a lot of
options.

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
---

While this fixes booting guests on riscv KVM with AIA it's unlikely
to get merged before the QEMU support for KVM AIA[1] lands, which
would also fix the issue. I think this patch is still worth considering
though since QEMU's assumption is wrong.

[1] https://lore.kernel.org/all/20230714084429.22349-1-yongxuan.wang@sifive.com/

v2:
  - Move the s390x code to an s390x file. [Thomas]
  - Drop the KVM_CAP_IRQCHIP check from the top of kvm_irqchip_create(),
    as it's no longer necessary.

 accel/kvm/kvm-all.c    | 16 ++++------------
 include/sysemu/kvm.h   |  1 +
 target/arm/kvm.c       |  3 +++
 target/i386/kvm/kvm.c  |  2 ++
 target/s390x/kvm/kvm.c | 11 +++++++++++
 5 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 373d876c0580..cddcb6eca641 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -86,6 +86,7 @@ struct KVMParkedVcpu {
 };
 
 KVMState *kvm_state;
+bool kvm_has_create_irqchip;
 bool kvm_kernel_irqchip;
 bool kvm_split_irqchip;
 bool kvm_async_interrupts_allowed;
@@ -2358,17 +2359,6 @@ static void kvm_irqchip_create(KVMState *s)
     int ret;
 
     assert(s->kernel_irqchip_split != ON_OFF_AUTO_AUTO);
-    if (kvm_check_extension(s, KVM_CAP_IRQCHIP)) {
-        ;
-    } else if (kvm_check_extension(s, KVM_CAP_S390_IRQCHIP)) {
-        ret = kvm_vm_enable_cap(s, KVM_CAP_S390_IRQCHIP, 0);
-        if (ret < 0) {
-            fprintf(stderr, "Enable kernel irqchip failed: %s\n", strerror(-ret));
-            exit(1);
-        }
-    } else {
-        return;
-    }
 
     /* First probe and see if there's a arch-specific hook to create the
      * in-kernel irqchip for us */
@@ -2377,8 +2367,10 @@ static void kvm_irqchip_create(KVMState *s)
         if (s->kernel_irqchip_split == ON_OFF_AUTO_ON) {
             error_report("Split IRQ chip mode not supported.");
             exit(1);
-        } else {
+        } else if (kvm_has_create_irqchip) {
             ret = kvm_vm_ioctl(s, KVM_CREATE_IRQCHIP);
+        } else {
+            return;
         }
     }
     if (ret < 0) {
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 115f0cca79d1..84b1bb3dc91e 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -32,6 +32,7 @@
 #ifdef CONFIG_KVM_IS_POSSIBLE
 
 extern bool kvm_allowed;
+extern bool kvm_has_create_irqchip;
 extern bool kvm_kernel_irqchip;
 extern bool kvm_split_irqchip;
 extern bool kvm_async_interrupts_allowed;
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index b4c7654f4980..2fa87b495d68 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -250,6 +250,9 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     int ret = 0;
+
+    kvm_has_create_irqchip = kvm_check_extension(s, KVM_CAP_IRQCHIP);
+
     /* For ARM interrupt delivery is always asynchronous,
      * whether we are using an in-kernel VGIC or not.
      */
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ebfaf3d24c79..6363e67f092d 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2771,6 +2771,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    kvm_has_create_irqchip = kvm_check_extension(s, KVM_CAP_IRQCHIP);
+
     return 0;
 }
 
diff --git a/target/s390x/kvm/kvm.c b/target/s390x/kvm/kvm.c
index a9e5880349d9..bcc735227f7d 100644
--- a/target/s390x/kvm/kvm.c
+++ b/target/s390x/kvm/kvm.c
@@ -391,6 +391,17 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     }
 
     kvm_set_max_memslot_size(KVM_SLOT_MAX_BYTES);
+
+    kvm_has_create_irqchip = kvm_check_extension(s, KVM_CAP_S390_IRQCHIP);
+    if (kvm_has_create_irqchip) {
+        int ret = kvm_vm_enable_cap(s, KVM_CAP_S390_IRQCHIP, 0);
+
+        if (ret < 0) {
+            fprintf(stderr, "Enable kernel irqchip failed: %s\n", strerror(-ret));
+            exit(1);
+        }
+    }
+
     return 0;
 }
 
-- 
2.41.0

