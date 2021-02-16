Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9ECF31C56C
	for <lists+kvm@lfdr.de>; Tue, 16 Feb 2021 03:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhBPCTd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Feb 2021 21:19:33 -0500
Received: from mga06.intel.com ([134.134.136.31]:39372 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229959AbhBPCQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Feb 2021 21:16:54 -0500
IronPort-SDR: IjRTl7wD7qCUKrvBqpruMdHhPwMxxc2cvVyz2VU5E6OBhCbuSZqTrwIL+wK7EjCanWOP1/v/we
 okvzxx9/uKSw==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="244270208"
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="244270208"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:52 -0800
IronPort-SDR: Y6imeHbdVjt4iWTEtlhYSAY/R8lUn0PatpDmvm2NovtK0pGt/ubFeuhTG21WBjzITGlRdpAbt3
 IhudWp4Evskw==
X-IronPort-AV: E=Sophos;i="5.81,182,1610438400"; 
   d="scan'208";a="591705426"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 18:14:52 -0800
From:   Isaku Yamahata <isaku.yamahata@intel.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com, alistair@alistair23.me,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, mst@redhat.com,
        cohuck@redhat.com, mtosatti@redhat.com, xiaoyao.li@intel.com,
        seanjc@google.com
Cc:     kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        isaku.yamahata@intel.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [RFC PATCH 14/23] i386/tdx: Frame in the call for KVM_TDX_INIT_VCPU
Date:   Mon, 15 Feb 2021 18:13:10 -0800
Message-Id: <623e79930a5a49734676f9aeb17e32aa737e7fbd.1613188118.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
In-Reply-To: <cover.1613188118.git.isaku.yamahata@intel.com>
References: <cover.1613188118.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
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
index e6f7015be8..52dbccedb5 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4034,6 +4034,14 @@ int kvm_arch_put_registers(CPUState *cpu, int level)
 
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
index 9d4195a705..d095dab662 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -36,7 +36,7 @@ bool kvm_has_tdx(KVMState *s)
     return !!(kvm_check_extension(s, KVM_CAP_VM_TYPES) & BIT(KVM_X86_TDX_VM));
 }
 
-static void __tdx_ioctl(int ioctl_no, const char *ioctl_name,
+static void __tdx_ioctl(void *state, int ioctl_no, const char *ioctl_name,
                         __u32 metadata, void *data)
 {
     struct kvm_tdx_cmd tdx_cmd;
@@ -49,17 +49,21 @@ static void __tdx_ioctl(int ioctl_no, const char *ioctl_name,
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
@@ -202,6 +206,14 @@ out:
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
2.17.1

