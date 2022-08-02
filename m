Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EA1587843
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 09:49:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236180AbiHBHtQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 03:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236174AbiHBHs4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 03:48:56 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A57704BD0D
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 00:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659426535; x=1690962535;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3TWTH6DVHDtYd4mhcblFfo639B1xzWKXEQFDJ90i5hI=;
  b=APDjBywqflTU5zqM6OQQpyYZ8SA1l7dDyNR2b9JFTmQeSw4AjwG9jsg3
   78rsFPSmBseWyyw4CplI4R9N6nq7J9gigXchC9GJXwOaY7AbEgOzcoTDm
   I4wfKunGZUndXOBuBmcUK9/+IbYzhFrrkFq8mzeQjyEpijKK48VZfbhHs
   bg28Yh810ORZUpxhQWdAbZnWOBat9LWLqWpmbpQOZKvjMzwXa0LyNLSSc
   F0W9BI9J/ta4vPEBfLGxtfcRR4+Qos3SPVMA84alSXi8SP93WkzkizosD
   rkUgXS14P2KdcNb7e4fd/lbczAtWcSEtLvPO1+Nr8L8c2nJyaQClzQbaV
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="286908583"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="286908583"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 00:48:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="630603998"
Received: from lxy-dell.sh.intel.com ([10.239.48.38])
  by orsmga008.jf.intel.com with ESMTP; 02 Aug 2022 00:48:51 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        =?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>,
        Eric Blake <eblake@redhat.com>
Cc:     Connor Kuehl <ckuehl@redhat.com>, erdemaktas@google.com,
        kvm@vger.kernel.org, qemu-devel@nongnu.org, seanjc@google.com,
        xiaoyao.li@intel.com
Subject: [PATCH v1 14/40] i386/tdx: Initialize TDX before creating TD vcpus
Date:   Tue,  2 Aug 2022 15:47:24 +0800
Message-Id: <20220802074750.2581308-15-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220802074750.2581308-1-xiaoyao.li@intel.com>
References: <20220802074750.2581308-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
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
 accel/kvm/kvm-all.c        |  9 ++++++++-
 target/i386/kvm/kvm.c      |  8 ++++++++
 target/i386/kvm/tdx-stub.c |  5 +++++
 target/i386/kvm/tdx.c      | 34 ++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h      |  4 ++++
 5 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index c26d602f5476..c1348c380680 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -473,10 +473,17 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
 
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
 
@@ -484,11 +491,11 @@ int kvm_init_vcpu(CPUState *cpu, Error **errp)
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
     cpu->throttle_us_per_full = 0;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 9c0d5be5cc23..4f491f871f3e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2197,6 +2197,14 @@ int kvm_arch_init_vcpu(CPUState *cs)
     return r;
 }
 
+int kvm_arch_pre_create_vcpu(CPUState *cpu)
+{
+    if (is_tdx_vm())
+        return tdx_pre_create_vcpu(cpu);
+
+    return 0;
+}
+
 int kvm_arch_destroy_vcpu(CPUState *cs)
 {
     X86CPU *cpu = X86_CPU(cs);
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
index 6fe47cf4e29e..ecb0205651bd 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -458,6 +458,38 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
     return 0;
 }
 
+int tdx_pre_create_vcpu(CPUState *cpu)
+{
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
+    memset(&init_vm, 0, sizeof(init_vm));
+    init_vm.cpuid.nent = kvm_x86_arch_cpuid(env, init_vm.entries, 0);
+
+    init_vm.attributes = tdx_guest->attributes;
+    init_vm.max_vcpus = ms->smp.cpus;
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
@@ -470,6 +502,8 @@ static void tdx_guest_init(Object *obj)
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

