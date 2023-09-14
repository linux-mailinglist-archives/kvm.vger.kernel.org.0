Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2665D79F914
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbjINDwL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbjINDwH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:52:07 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1341BE5
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 20:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694663520; x=1726199520;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8xg5bqjhBbAM8gPiQzHBRvDRVKCRRm1mhZpgTQ/bsFc=;
  b=Fr85sOnUuqL6b0ziat+8MIN7xtUzpqTvBsMQjkpIhTBXvmGCisi9a/iC
   qmGV9azdBaWOfYIh7Q6gVopkcdYSBV99rU4U80LB2Lo0VHAyR21Enjkkl
   CjG6sDuojAo1sUK0VGS6en3eluxpXQwb43WUbxoFlju/FXjIgqQH2J1DV
   l7Pe2ySTzKXXZy9zS2M2iMkf/jmUwzGhzMgYxaL+ipv1e6q05F8VdLHzL
   wgnygU+D9nFyqN3q2FhnS0RHuVK9jXEhivyXRR8aGBxcsSUSFYTo9R3LF
   Ettrgpic9TZ/72Eu/ge3ydOmTkIzFj6zBu/6+713ECIIZjx8edYzXugPg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="381528407"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="381528407"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 20:52:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814500596"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="814500596"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmsmga004.fm.intel.com with ESMTP; 13 Sep 2023 20:51:55 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
Subject: [RFC PATCH v2 08/21] target/i386: Implement mc->kvm_type() to get VM type
Date:   Wed, 13 Sep 2023 23:51:04 -0400
Message-Id: <20230914035117.3285885-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914035117.3285885-1-xiaoyao.li@intel.com>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement mc->kvm_type() for i386 machines. It provides a way for user
to create SW_PROTECTE_VM.

Also store the vm_type in machinestate to other code to query what the
VM type is.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 hw/i386/x86.c              | 12 ++++++++++++
 include/hw/i386/x86.h      |  1 +
 target/i386/kvm/kvm.c      | 30 ++++++++++++++++++++++++++++++
 target/i386/kvm/kvm_i386.h |  1 +
 4 files changed, 44 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index a88a126123be..660f83935315 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1382,6 +1382,17 @@ static void machine_set_sgx_epc(Object *obj, Visitor *v, const char *name,
     qapi_free_SgxEPCList(list);
 }
 
+static int x86_kvm_type(MachineState *ms, const char *vm_type)
+{
+    X86MachineState *x86ms = X86_MACHINE(ms);
+    int kvm_type;
+
+    kvm_type = kvm_get_vm_type(ms, vm_type);
+    x86ms->vm_type = kvm_type;
+
+    return kvm_type;
+}
+
 static void x86_machine_initfn(Object *obj)
 {
     X86MachineState *x86ms = X86_MACHINE(obj);
@@ -1406,6 +1417,7 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
     mc->cpu_index_to_instance_props = x86_cpu_index_to_props;
     mc->get_default_cpu_node_id = x86_get_default_cpu_node_id;
     mc->possible_cpu_arch_ids = x86_possible_cpu_arch_ids;
+    mc->kvm_type = x86_kvm_type;
     x86mc->save_tsc_khz = true;
     x86mc->fwcfg_dma_enabled = true;
     nc->nmi_monitor_handler = x86_nmi;
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index da19ae15463a..ab1d38569019 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -41,6 +41,7 @@ struct X86MachineState {
     MachineState parent;
 
     /*< public >*/
+    unsigned int vm_type;
 
     /* Pointers to devices and objects: */
     ISADevice *rtc;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f8cc8eb1fe70..d1cf6c1f63b3 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -32,6 +32,7 @@
 #include "sysemu/runstate.h"
 #include "kvm_i386.h"
 #include "sev.h"
+#include "sw-protected-vm.h"
 #include "xen-emu.h"
 #include "hyperv.h"
 #include "hyperv-proto.h"
@@ -154,6 +155,35 @@ static KVMMSRHandlers msr_handlers[KVM_MSR_FILTER_MAX_RANGES];
 static RateLimit bus_lock_ratelimit_ctrl;
 static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value);
 
+static const char* vm_type_name[] = {
+    [KVM_X86_DEFAULT_VM] = "default",
+    [KVM_X86_SW_PROTECTED_VM] = "sw-protected-vm",
+};
+
+int kvm_get_vm_type(MachineState *ms, const char *vm_type)
+{
+    int kvm_type = KVM_X86_DEFAULT_VM;
+
+    if (ms->cgs && object_dynamic_cast(OBJECT(ms->cgs), TYPE_SW_PROTECTED_VM)) {
+        kvm_type = KVM_X86_SW_PROTECTED_VM;
+    }
+
+    /*
+     * old KVM doesn't support KVM_CAP_VM_TYPES and KVM_X86_DEFAULT_VM
+     * is always supported
+     */
+    if (kvm_type == KVM_X86_DEFAULT_VM) {
+        return kvm_type;
+    }
+
+    if (!(kvm_check_extension(KVM_STATE(ms->accelerator), KVM_CAP_VM_TYPES) & BIT(kvm_type))) {
+        error_report("vm-type %s not supported by KVM", vm_type_name[kvm_type]);
+        exit(1);
+    }
+
+    return kvm_type;
+}
+
 int kvm_has_pit_state2(void)
 {
     return has_pit_state2;
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index e24753abfe6a..ea3a5b174ac0 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -37,6 +37,7 @@ bool kvm_has_adjust_clock(void);
 bool kvm_has_adjust_clock_stable(void);
 bool kvm_has_exception_payload(void);
 void kvm_synchronize_all_tsc(void);
+int kvm_get_vm_type(MachineState *ms, const char *vm_type);
 void kvm_arch_reset_vcpu(X86CPU *cs);
 void kvm_arch_after_reset_vcpu(X86CPU *cpu);
 void kvm_arch_do_init_vcpu(X86CPU *cs);
-- 
2.34.1

