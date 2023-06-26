Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E61773D7FB
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 08:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbjFZGuY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 02:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjFZGuW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 02:50:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574541B7
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 23:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687762187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WX90kZNBwe7dwYkh6anqQDpSify7IhqnpPmXu2ebVnc=;
        b=EXO2ugRB8e2sjs+Pl/hxy9yeur5KxNx223x7MeIcVp1zg6G8BZuVlhOuH/lJY0H8iK7gcm
        hZ6+ODEGLhJcf9mW7G6SoxhP03+uJeoCCpdng0iSLIql1Pya37qhmhO1vV4+d+sh9Vq4bM
        Ok5ABaHN8nWiwMY7BJEiuRDET5jwhwg=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-329-k4yhj1csPmSg0UdimX50_Q-1; Mon, 26 Jun 2023 02:49:44 -0400
X-MC-Unique: k4yhj1csPmSg0UdimX50_Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7FF7A3C0F671;
        Mon, 26 Jun 2023 06:49:43 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 76ADF200BA8D;
        Mon, 26 Jun 2023 06:49:43 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     oliver.upton@linux.dev, salil.mehta@huawei.com,
        james.morse@arm.com, gshan@redhat.com,
        Shaoqin Huang <shahuang@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v1 4/5] arm/kvm: add skeleton implementation for userspace SMCCC call handling
Date:   Mon, 26 Jun 2023 02:49:08 -0400
Message-Id: <20230626064910.1787255-5-shahuang@redhat.com>
In-Reply-To: <20230626064910.1787255-1-shahuang@redhat.com>
References: <20230626064910.1787255-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SMCCC call filtering provide the ability to forward the SMCCC call
to userspace, so we provide a new option `user-smccc` to enable handling
SMCCC call in userspace, the default value is off.

And add the skeleton implementation for userspace SMCCC call
initialization and handling.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 docs/system/arm/virt.rst |  4 +++
 hw/arm/virt.c            | 21 ++++++++++++++++
 include/hw/arm/virt.h    |  1 +
 target/arm/kvm.c         | 54 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 80 insertions(+)

diff --git a/docs/system/arm/virt.rst b/docs/system/arm/virt.rst
index 1cab33f02e..ff43d52f04 100644
--- a/docs/system/arm/virt.rst
+++ b/docs/system/arm/virt.rst
@@ -155,6 +155,10 @@ dtb-randomness
   DTB to be non-deterministic. It would be the responsibility of
   the firmware to come up with a seed and pass it on if it wants to.
 
+user-smccc
+  Set ``on``/``off`` to enable/disable handling smccc call in userspace
+  instead of kernel.
+
 dtb-kaslr-seed
   A deprecated synonym for dtb-randomness.
 
diff --git a/hw/arm/virt.c b/hw/arm/virt.c
index 9b9f7d9c68..767720321c 100644
--- a/hw/arm/virt.c
+++ b/hw/arm/virt.c
@@ -42,6 +42,7 @@
 #include "hw/vfio/vfio-amd-xgbe.h"
 #include "hw/display/ramfb.h"
 #include "net/net.h"
+#include "qom/object.h"
 #include "sysemu/device_tree.h"
 #include "sysemu/numa.h"
 #include "sysemu/runstate.h"
@@ -2511,6 +2512,19 @@ static void virt_set_oem_table_id(Object *obj, const char *value,
     strncpy(vms->oem_table_id, value, 8);
 }
 
+static bool virt_get_user_smccc(Object *obj, Error **errp)
+{
+    VirtMachineState *vms = VIRT_MACHINE(obj);
+
+    return vms->user_smccc;
+}
+
+static void virt_set_user_smccc(Object *obj, bool value, Error **errp)
+{
+    VirtMachineState *vms = VIRT_MACHINE(obj);
+
+    vms->user_smccc = value;
+}
 
 bool virt_is_acpi_enabled(VirtMachineState *vms)
 {
@@ -3155,6 +3169,13 @@ static void virt_machine_class_init(ObjectClass *oc, void *data)
                                           "in ACPI table header."
                                           "The string may be up to 8 bytes in size");
 
+    object_class_property_add_bool(oc, "user-smccc",
+                                   virt_get_user_smccc,
+                                   virt_set_user_smccc);
+    object_class_property_set_description(oc, "user-smccc",
+                                          "Set on/off to enable/disable "
+                                          "handling smccc call in userspace");
+
 }
 
 static void virt_instance_init(Object *obj)
diff --git a/include/hw/arm/virt.h b/include/hw/arm/virt.h
index e1ddbea96b..4f1bc12680 100644
--- a/include/hw/arm/virt.h
+++ b/include/hw/arm/virt.h
@@ -160,6 +160,7 @@ struct VirtMachineState {
     bool ras;
     bool mte;
     bool dtb_randomness;
+    bool user_smccc;
     OnOffAuto acpi;
     VirtGICType gic_version;
     VirtIOMMUType iommu;
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 84da49332c..579c6edd49 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -9,6 +9,8 @@
  */
 
 #include "qemu/osdep.h"
+#include <asm-arm64/kvm.h>
+#include <linux/arm-smccc.h>
 #include <sys/ioctl.h>
 
 #include <linux/kvm.h>
@@ -247,6 +249,20 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
     return ret > 0 ? ret : 40;
 }
 
+static int kvm_arm_init_smccc_filter(KVMState *s)
+{
+    int ret = 0;
+
+    if (kvm_vm_check_attr(s, KVM_ARM_VM_SMCCC_CTRL, KVM_ARM_VM_SMCCC_FILTER)) {
+        error_report("ARM SMCCC filter not supported");
+        ret = -EINVAL;
+        goto out;
+    }
+
+out:
+    return ret;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     int ret = 0;
@@ -282,6 +298,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
 
     kvm_arm_init_debug(s);
 
+    if (ret == 0 && object_property_get_bool(OBJECT(ms), "user-smccc", NULL)) {
+        ret = kvm_arm_init_smccc_filter(s);
+    }
+
     return ret;
 }
 
@@ -912,6 +932,37 @@ static int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
     return -1;
 }
 
+static void kvm_arm_smccc_return_result(CPUState *cs, struct arm_smccc_res *res)
+{
+    ARMCPU *cpu = ARM_CPU(cs);
+    CPUARMState *env = &cpu->env;
+
+    env->xregs[0] = res->a0;
+    env->xregs[1] = res->a1;
+    env->xregs[2] = res->a2;
+    env->xregs[3] = res->a3;
+}
+
+static int kvm_arm_handle_hypercall(CPUState *cs, struct kvm_run *run)
+{
+    uint32_t fn = run->hypercall.nr;
+    struct arm_smccc_res res = {
+        .a0     = SMCCC_RET_NOT_SUPPORTED,
+    };
+    int ret = 0;
+
+    kvm_cpu_synchronize_state(cs);
+
+    switch (ARM_SMCCC_OWNER_NUM(fn)) {
+    default:
+        break;
+    }
+
+    kvm_arm_smccc_return_result(cs, &res);
+
+    return ret;
+}
+
 int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
 {
     int ret = 0;
@@ -927,6 +978,9 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
         ret = kvm_arm_handle_dabt_nisv(cs, run->arm_nisv.esr_iss,
                                        run->arm_nisv.fault_ipa);
         break;
+    case KVM_EXIT_HYPERCALL:
+        ret = kvm_arm_handle_hypercall(cs, run);
+        break;
     default:
         qemu_log_mask(LOG_UNIMP, "%s: un-handled exit reason %d\n",
                       __func__, run->exit_reason);
-- 
2.39.1

