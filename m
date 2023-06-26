Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5521273D7FF
	for <lists+kvm@lfdr.de>; Mon, 26 Jun 2023 08:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjFZGum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Jun 2023 02:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjFZGuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Jun 2023 02:50:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70C56E54
        for <kvm@vger.kernel.org>; Sun, 25 Jun 2023 23:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687762189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NMHucQZ4M31K7QXIgHBtRlKVAlpmIjZVnWfneYhxS0Q=;
        b=ZWseVts0Cg4wEHpuAbkToBoVB8rMliPH6l1HtdfGnfLipltTPhMyZ30UirBpWFL/0NBQXL
        e+RlyQZyRNRaDkKrJqfoCsuGxcdoodaiokQNyjzj9XHoO7UtnnU4vSrop4PsU24sStBz5L
        pA3RiG4d8n5eDZ6XwIjI8kOhSdtLGxY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-182-ByhBcNp3OFuVvfR_Cy2dMg-1; Mon, 26 Jun 2023 02:49:44 -0400
X-MC-Unique: ByhBcNp3OFuVvfR_Cy2dMg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A1D2B90ED33;
        Mon, 26 Jun 2023 06:49:43 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9452C200B677;
        Mon, 26 Jun 2023 06:49:43 +0000 (UTC)
From:   Shaoqin Huang <shahuang@redhat.com>
To:     qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc:     oliver.upton@linux.dev, salil.mehta@huawei.com,
        james.morse@arm.com, gshan@redhat.com,
        Shaoqin Huang <shahuang@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v1 5/5] arm/kvm: add support for userspace psci calls handling
Date:   Mon, 26 Jun 2023 02:49:09 -0400
Message-Id: <20230626064910.1787255-6-shahuang@redhat.com>
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

Use the SMCCC filter to start sending psci calls to userspace, qemu will
need to handle the psci calls. In qemu, reuse the psci handler which
used for tcg, while use it, we need to take care the reset vcpu process
which will reset the vcpu register and grab all vcpu locks when reset
gicv3.

So when reset vcpu, we need to mark it as dirty to force the vcpu to
sync its register to kvm, and when reset gicv3, we need to pause all
vcpus to grab the all vcpu locks, thus when handling the psci CPU_ON
call, the vcpu can be successfuly boot up.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 hw/intc/arm_gicv3_kvm.c | 10 +++++
 target/arm/kvm.c        | 94 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 103 insertions(+), 1 deletion(-)

diff --git a/hw/intc/arm_gicv3_kvm.c b/hw/intc/arm_gicv3_kvm.c
index 72ad916d3d..e42898c1d6 100644
--- a/hw/intc/arm_gicv3_kvm.c
+++ b/hw/intc/arm_gicv3_kvm.c
@@ -24,6 +24,7 @@
 #include "hw/intc/arm_gicv3_common.h"
 #include "qemu/error-report.h"
 #include "qemu/module.h"
+#include "sysemu/cpus.h"
 #include "sysemu/kvm.h"
 #include "sysemu/runstate.h"
 #include "kvm_arm.h"
@@ -695,10 +696,19 @@ static void arm_gicv3_icc_reset(CPUARMState *env, const ARMCPRegInfo *ri)
         return;
     }
 
+    /*
+     * When handling psci call in userspace like cpu hotplug, this shall be called
+     * when other vcpus might be running. Host kernel KVM to handle device
+     * access of IOCTLs KVM_{GET|SET}_DEVICE_ATTR might fail due to inability to
+     * grab vcpu locks for all the vcpus. Hence, we need to pause all vcpus to
+     * facilitate locking within host.
+     */
+    pause_all_vcpus();
     /* Initialize to actual HW supported configuration */
     kvm_device_access(s->dev_fd, KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS,
                       KVM_VGIC_ATTR(ICC_CTLR_EL1, c->gicr_typer),
                       &c->icc_ctlr_el1[GICV3_NS], false, &error_abort);
+    resume_all_vcpus();
 
     c->icc_ctlr_el1[GICV3_S] = c->icc_ctlr_el1[GICV3_NS];
 }
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index 579c6edd49..d2857a8499 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -10,6 +10,7 @@
 
 #include "qemu/osdep.h"
 #include <asm-arm64/kvm.h>
+#include <linux/psci.h>
 #include <linux/arm-smccc.h>
 #include <sys/ioctl.h>
 
@@ -251,7 +252,29 @@ int kvm_arm_get_max_vm_ipa_size(MachineState *ms, bool *fixed_ipa)
 
 static int kvm_arm_init_smccc_filter(KVMState *s)
 {
+    unsigned int i;
     int ret = 0;
+    struct kvm_smccc_filter filter_ranges[] = {
+        {
+            .base           = KVM_PSCI_FN_BASE,
+            .nr_functions   = 4,
+            .action         = KVM_SMCCC_FILTER_DENY,
+        },
+        {
+            .base           = PSCI_0_2_FN_BASE,
+            .nr_functions   = 0x20,
+            .action         = KVM_SMCCC_FILTER_FWD_TO_USER,
+        },
+        {
+            .base           = PSCI_0_2_FN64_BASE,
+            .nr_functions   = 0x20,
+            .action         = KVM_SMCCC_FILTER_FWD_TO_USER,
+        },
+    };
+    struct kvm_device_attr attr = {
+        .group = KVM_ARM_VM_SMCCC_CTRL,
+        .attr = KVM_ARM_VM_SMCCC_FILTER,
+    };
 
     if (kvm_vm_check_attr(s, KVM_ARM_VM_SMCCC_CTRL, KVM_ARM_VM_SMCCC_FILTER)) {
         error_report("ARM SMCCC filter not supported");
@@ -259,6 +282,16 @@ static int kvm_arm_init_smccc_filter(KVMState *s)
         goto out;
     }
 
+    for (i = 0; i < ARRAY_SIZE(filter_ranges); i++) {
+        attr.addr = (uint64_t)&filter_ranges[i];
+
+        ret = kvm_vm_ioctl(s, KVM_SET_DEVICE_ATTR, &attr);
+        if (ret < 0) {
+            error_report("KVM_SET_DEVICE_ATTR failed when SMCCC init");
+            goto out;
+        }
+    }
+
 out:
     return ret;
 }
@@ -654,6 +687,14 @@ void kvm_arm_reset_vcpu(ARMCPU *cpu)
      * for the same reason we do so in kvm_arch_get_registers().
      */
     write_list_to_cpustate(cpu);
+
+    /*
+     * When enabled userspace psci call handling, qemu will reset the vcpu if
+     * it's PSCI CPU_ON call. Since this will reset the vcpu register and
+     * power_state, we should sync these state to kvm, so manually set the
+     * vcpu_dirty to force the qemu to put register to kvm.
+     */
+    CPU(cpu)->vcpu_dirty = true;
 }
 
 /*
@@ -932,6 +973,51 @@ static int kvm_arm_handle_dabt_nisv(CPUState *cs, uint64_t esr_iss,
     return -1;
 }
 
+static int kvm_arm_handle_psci(CPUState *cs, struct kvm_run *run)
+{
+    if (run->hypercall.flags & KVM_HYPERCALL_EXIT_SMC) {
+        cs->exception_index = EXCP_SMC;
+    } else {
+        cs->exception_index = EXCP_HVC;
+    }
+
+    qemu_mutex_lock_iothread();
+    arm_cpu_do_interrupt(cs);
+    qemu_mutex_unlock_iothread();
+
+    /*
+     * We need to exit the run loop to have the chance to execute the
+     * qemu_wait_io_event() which will execute the psci function which queued in
+     * the cpu work queue.
+     */
+    return EXCP_INTERRUPT;
+}
+
+static int kvm_arm_handle_std_call(CPUState *cs, struct kvm_run *run,
+                                   struct arm_smccc_res *res,
+                                   bool *sync_reg)
+{
+    uint32_t fn = run->hypercall.nr;
+    int ret = 0;
+
+    switch (ARM_SMCCC_FUNC_NUM(fn)) {
+    /* PSCI */
+    case 0x00 ... 0x1F:
+        /*
+         * We will reuse the psci handler, but the handler directly get psci
+         * call parameter from register, and write the return value to register.
+         * So we no need to sync the value in arm_smccc_res.
+         */
+        *sync_reg = false;
+        ret = kvm_arm_handle_psci(cs, run);
+        break;
+    default:
+        break;
+    }
+
+    return ret;
+}
+
 static void kvm_arm_smccc_return_result(CPUState *cs, struct arm_smccc_res *res)
 {
     ARMCPU *cpu = ARM_CPU(cs);
@@ -949,16 +1035,22 @@ static int kvm_arm_handle_hypercall(CPUState *cs, struct kvm_run *run)
     struct arm_smccc_res res = {
         .a0     = SMCCC_RET_NOT_SUPPORTED,
     };
+    bool sync_reg = true;
     int ret = 0;
 
     kvm_cpu_synchronize_state(cs);
 
     switch (ARM_SMCCC_OWNER_NUM(fn)) {
+    case ARM_SMCCC_OWNER_STANDARD:
+        ret = kvm_arm_handle_std_call(cs, run, &res, &sync_reg);
+        break;
     default:
         break;
     }
 
-    kvm_arm_smccc_return_result(cs, &res);
+    if (sync_reg) {
+        kvm_arm_smccc_return_result(cs, &res);
+    }
 
     return ret;
 }
-- 
2.39.1

