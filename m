Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588754DC821
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 15:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbiCQOB2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234809AbiCQOBZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:01:25 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCB41C1EEF
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 07:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525608; x=1679061608;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=q1Bv0zE7QJL5HRu3M4Mn9ubF+qQKJfAicxrXrBFlJxo=;
  b=ZIoKKv9cC9lQmBTTZ4fkbOrjGi7PketwC0L3laGcp3QC4rOkE0ZNhMVm
   tyuYwgBALErDZUgIKve+GrH8z3GZYMwM+j5r6mblbC9nqRwA9NhLhVAtx
   5Og0ItE0oEygj4uOv5S9Ors2yA8HACdudI632uaMHSe12q0i+Rk1M4cAl
   cfR73uD3yj91ewEOdlneU5+X5MjVhh7I45dRvlSJoSWtdky/Dw7QgjY3X
   OijwsEg86B0Bhs+D9586AjiRx228GOobHWqrYK7NkYDAEHOqhKW9v6flF
   AjPH8mhsZy8VSUL7wth4+H3rYKOx/Bpy5r/JZfhNcJNd6x4HKlwziv5xf
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="257058358"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="257058358"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 07:00:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541378080"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 07:00:03 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, isaku.yamahata@intel.com,
        xiaoyao.li@intel.com, erdemaktas@google.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, seanjc@google.com
Subject: [RFC PATCH v3 11/36] i386/tdx: Initialize TDX before creating TD vcpus
Date:   Thu, 17 Mar 2022 21:58:48 +0800
Message-Id: <20220317135913.2166202-12-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220317135913.2166202-1-xiaoyao.li@intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Invoke KVM_TDX_INIT in kvm_arch_pre_create_vcpu() that KVM_TDX_INIT
configures global TD state, e.g. the canonical CPUID config, and must
be executed prior to creating vCPUs.

Use kvm_x86_arch_cpuid() to setup the CPUID settings for TDX VM and
tie x86cpu->enable_pmu with TD's attributes.

Note, this doesn't address the fact that QEMU may change the CPUID
configuration when creating vCPUs, i.e. punts on refactoring QEMU to
provide a stable CPUID config prior to kvm_arch_init().

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c        |  9 ++++++-
 target/i386/kvm/kvm.c      |  3 +++
 target/i386/kvm/tdx-stub.c |  5 ++++
 target/i386/kvm/tdx.c      | 49 ++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h      |  4 ++++
 5 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index a4bb449737a6..fceb6b618b04 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -465,10 +465,17 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
 
     trace_kvm_init_vcpu(cpu->cpu_index, kvm_arch_vcpu_id(cpu));
 
+    /*
+     * tdx_pre_create_vcpu() may call cpu_x86_cpuid(). It in turn may call
+     * kvm_vm_ioctl(). Set cpu->kvm_state in advance to avoid NULL pointer
+     * dereference.
+     */
+    cpu->kvm_state = s;
     ret = kvm_arch_pre_create_vcpu(cpu);
     if (ret < 0) {
         error_setg_errno(errp, -ret,
                          "kvm_init_vcpu: kvm_arch_pre_create_vcpu() failed");
+        cpu->kvm_state = NULL;
         goto err;
     }
 
@@ -476,11 +483,11 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
     if (ret < 0) {
         error_setg_errno(errp, -ret, "kvm_init_vcpu: kvm_get_vcpu failed (%lu)",
                          kvm_arch_vcpu_id(cpu));
+        cpu->kvm_state = NULL;
         goto err;
     }
 
     cpu->kvm_fd = ret;
-    cpu->kvm_state = s;
     cpu->vcpu_dirty = true;
     cpu->dirty_pages = 0;
 
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 02849f6ef142..f2d71359b59d 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2112,6 +2112,9 @@ int kvm_arch_init_vcpu(CPUState *cs)
 
 int kvm_arch_pre_create_vcpu(CPUState *cpu)
 {
+    if (is_tdx_vm())
+        return tdx_pre_create_vcpu(cpu);
+
     return 0;
 }
 
diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
index 1df24735201e..2871de9d7b56 100644
--- a/target/i386/kvm/tdx-stub.c
+++ b/target/i386/kvm/tdx-stub.c
@@ -7,3 +7,8 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
 {
     return -EINVAL;
 }
+
+int tdx_pre_create_vcpu(CPUState *cpu)
+{
+    return -EINVAL;
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index e4ee55f30c79..a5cc187edbde 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -18,6 +18,7 @@
 #include "sysemu/kvm.h"
 
 #include "hw/i386/x86.h"
+#include "kvm_i386.h"
 #include "tdx.h"
 
 static TdxGuest *tdx_guest;
@@ -149,6 +150,52 @@ void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
     }
 }
 
+int tdx_pre_create_vcpu(CPUState *cpu)
+{
+    struct {
+        struct kvm_cpuid2 cpuid;
+        struct kvm_cpuid_entry2 entries[KVM_MAX_CPUID_ENTRIES];
+    } cpuid_data;
+
+    /*
+     * The kernel defines these structs with padding fields so there
+     * should be no extra padding in our cpuid_data struct.
+     */
+    QEMU_BUILD_BUG_ON(sizeof(cpuid_data) !=
+                      sizeof(struct kvm_cpuid2) +
+                      sizeof(struct kvm_cpuid_entry2) * KVM_MAX_CPUID_ENTRIES);
+
+    MachineState *ms = MACHINE(qdev_get_machine());
+    X86CPU *x86cpu = X86_CPU(cpu);
+    CPUX86State *env = &x86cpu->env;
+    struct kvm_tdx_init_vm init_vm;
+    int r = 0;
+
+    qemu_mutex_lock(&tdx_guest->lock);
+    if (tdx_guest->initialized) {
+        goto out;
+    }
+
+    memset(&cpuid_data, 0, sizeof(cpuid_data));
+    cpuid_data.cpuid.nent = kvm_x86_arch_cpuid(env, cpuid_data.entries, 0);
+
+    init_vm.cpuid = (__u64)(&cpuid_data);
+    init_vm.max_vcpus = ms->smp.cpus;
+    init_vm.attributes = tdx_guest->attributes;
+
+    r = tdx_vm_ioctl(KVM_TDX_INIT_VM, 0, &init_vm);
+    if (r < 0) {
+        error_report("KVM_TDX_INIT_VM failed %s", strerror(-r));
+        goto out;
+    }
+
+    tdx_guest->initialized = true;
+
+out:
+    qemu_mutex_unlock(&tdx_guest->lock);
+    return r;
+}
+
 /* tdx guest */
 OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
                                    tdx_guest,
@@ -161,6 +208,8 @@ static void tdx_guest_init(Object *obj)
 {
     TdxGuest *tdx = TDX_GUEST(obj);
 
+    qemu_mutex_init(&tdx->lock);
+
     tdx->attributes = 0;
 }
 
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 06599b65b827..46a24ee8c7cc 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -17,6 +17,9 @@ typedef struct TdxGuestClass {
 typedef struct TdxGuest {
     ConfidentialGuestSupport parent_obj;
 
+    QemuMutex lock;
+
+    bool initialized;
     uint64_t attributes;    /* TD attributes */
 } TdxGuest;
 
@@ -29,5 +32,6 @@ bool is_tdx_vm(void);
 int tdx_kvm_init(MachineState *ms, Error **errp);
 void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
                              uint32_t *ret);
+int tdx_pre_create_vcpu(CPUState *cpu);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.27.0

