Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D19F3BF30C
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 02:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbhGHA6s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 20:58:48 -0400
Received: from mga18.intel.com ([134.134.136.126]:19318 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230192AbhGHA6h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 20:58:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10038"; a="196696074"
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="196696074"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:55 -0700
X-IronPort-AV: E=Sophos;i="5.84,222,1620716400"; 
   d="scan'208";a="423770034"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2021 17:55:55 -0700
From:   isaku.yamahata@gmail.com
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com, erdemaktas@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH v2 14/44] i386/tdx: Frame in the call for KVM_TDX_INIT_VCPU
Date:   Wed,  7 Jul 2021 17:54:44 -0700
Message-Id: <b91795422d48efad960d086cfc723b69a6458e7c.1625704981.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1625704980.git.isaku.yamahata@intel.com>
References: <cover.1625704980.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 include/sysemu/tdx.h       |  1 +
 target/i386/kvm/kvm.c      |  8 ++++++++
 target/i386/kvm/tdx-stub.c |  4 ++++
 target/i386/kvm/tdx.c      | 20 ++++++++++++++++----
 4 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/include/sysemu/tdx.h b/include/sysemu/tdx.h
index 36a901e723..03461b6ae8 100644
--- a/include/sysemu/tdx.h
+++ b/include/sysemu/tdx.h
@@ -8,5 +8,6 @@ bool kvm_has_tdx(KVMState *s);
 #endif
 
 void tdx_pre_create_vcpu(CPUState *cpu);
+void tdx_post_init_vcpu(CPUState *cpu);
 
 #endif
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 25dcecd60c..af6b5f350e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4122,6 +4122,14 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
 
     assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
 
+    /*
+     * level == KVM_PUT_FULL_STATE is only set by
+     * kvm_cpu_synchronize_post_init() after initialization
+     */
+    if (vm_type == KVM_X86_TDX_VM && level == KVM_PUT_FULL_STATE) {
+        tdx_post_init_vcpu(cpu);
+    }
+
     /* TODO: Allow accessing guest state for debug TDs. */
     if (vm_type == KVM_X86_TDX_VM) {
         return 0;
diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
index 93d5913c89..93afe07ddb 100644
--- a/target/i386/kvm/tdx-stub.c
+++ b/target/i386/kvm/tdx-stub.c
@@ -12,3 +12,7 @@ bool kvm_has_tdx(KVMState *s)
 void tdx_pre_create_vcpu(CPUState *cpu)
 {
 }
+
+void tdx_post_init_vcpu(CPUState *cpu)
+{
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index b1e4f27c9a..67fb03b4b5 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -38,7 +38,7 @@ bool kvm_has_tdx(KVMState *s)
     return !!(kvm_check_extension(s, KVM_CAP_VM_TYPES) & BIT(KVM_X86_TDX_VM));
 }
 
-static void __tdx_ioctl(int ioctl_no, const char *ioctl_name,
+static void __tdx_ioctl(void *state, int ioctl_no, const char *ioctl_name,
                         __u32 metadata, void *data)
 {
     struct kvm_tdx_cmd tdx_cmd;
@@ -51,17 +51,21 @@ static void __tdx_ioctl(int ioctl_no, const char *ioctl_name,
     tdx_cmd.data = (__u64)(unsigned long)data;
 
     if (ioctl_no == KVM_TDX_CAPABILITIES) {
-        r = kvm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+        r = kvm_ioctl(state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+    } else if (ioctl_no == KVM_TDX_INIT_VCPU) {
+        r = kvm_vcpu_ioctl(state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
     } else {
-        r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+        r = kvm_vm_ioctl(state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
     }
     if (r) {
         error_report("%s failed: %s", ioctl_name, strerror(-r));
         exit(1);
     }
 }
+#define _tdx_ioctl(cpu, ioctl_no, metadata, data) \
+        __tdx_ioctl(cpu, ioctl_no, stringify(ioctl_no), metadata, data)
 #define tdx_ioctl(ioctl_no, metadata, data) \
-        __tdx_ioctl(ioctl_no, stringify(ioctl_no), metadata, data)
+        _tdx_ioctl(kvm_state, ioctl_no, metadata, data)
 
 static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
@@ -219,6 +223,14 @@ out:
     qemu_mutex_unlock(&tdx->lock);
 }
 
+void tdx_post_init_vcpu(CPUState *cpu)
+{
+    CPUX86State *env = &X86_CPU(cpu)->env;
+
+    _tdx_ioctl(cpu, KVM_TDX_INIT_VCPU, 0,
+               (void *)(unsigned long)env->regs[R_ECX]);
+}
+
 static bool tdx_guest_get_debug(Object *obj, Error **errp)
 {
     TdxGuest *tdx = TDX_GUEST(obj);
-- 
2.25.1

