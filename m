Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8465769C58
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbjGaQZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjGaQZd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:25:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF1331982
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820724; x=1722356724;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4pSQ7+7eqxjS895xnE1dyhv7L8BA0IkSr37vKkLRLiM=;
  b=c8wVvLE32bDKifubPxn0IkKIDfAg4gK9FT5G0n7s/V9oXvJaZpeNHlt0
   KOq5VJF88D64y4F2sXEOnTkNxn0ccY0gZn99qvGQBTQi5pto9li/32fPJ
   ncrJ9QS3uv6JHdggK/ehOO6d6fk+lnOJjmcDUEjajC42WbHGX31oS0zxt
   xD5j8o7tSKzMPxjAkZ55WNeX5SEJoLazfMFfX0ZQIYuC+5R5iK6EeaqmD
   BYxp1F3SEbhatv0UNRAIrya91J3Lkf490WqXFBJMdYdi1lm5Q65mrDnwI
   vrM9l3ZEYJbwUEJPU6wxHy0npQ0j/151jYk+xpf6FV3qHgWvHuiIVf3cC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993453"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993453"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:25:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984151"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984151"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:25:20 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Markus Armbruster <armbru@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        xiaoyao.li@intel.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: [RFC PATCH 07/19] target/i386: Implement mc->kvm_type() to get VM type
Date:   Mon, 31 Jul 2023 12:21:49 -0400
Message-Id: <20230731162201.271114-8-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230731162201.271114-1-xiaoyao.li@intel.com>
References: <20230731162201.271114-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement mc->kvm_type() for i386 machines. It provides a way for user
to create SW_PROTECTE_VM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 hw/i386/x86.c              | 27 +++++++++++++++++++++++++++
 include/hw/i386/x86.h      |  4 ++++
 target/i386/kvm/kvm.c      | 38 ++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/kvm_i386.h |  1 +
 4 files changed, 70 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index a88a126123be..3ccd06154249 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1382,6 +1382,26 @@ static void machine_set_sgx_epc(Object *obj, Visitor *v, const char *name,
     qapi_free_SgxEPCList(list);
 }
 
+static int x86_kvm_type(MachineState *ms, const char *vm_type)
+{
+    return kvm_get_vm_type(ms, vm_type);
+}
+
+static char *x86_machine_get_kvm_type(Object *obj, Error **errp)
+{
+    X86MachineState *x86ms = X86_MACHINE(obj);
+
+    return g_strdup(x86ms->kvm_type);
+}
+
+static void x86_machine_set_kvm_type(Object *obj, const char *value, Error **errp)
+{
+    X86MachineState *x86ms = X86_MACHINE(obj);
+
+    g_free(x86ms->kvm_type);
+    x86ms->kvm_type = g_strdup(value);
+}
+
 static void x86_machine_initfn(Object *obj)
 {
     X86MachineState *x86ms = X86_MACHINE(obj);
@@ -1406,6 +1426,7 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
     mc->cpu_index_to_instance_props = x86_cpu_index_to_props;
     mc->get_default_cpu_node_id = x86_get_default_cpu_node_id;
     mc->possible_cpu_arch_ids = x86_possible_cpu_arch_ids;
+    mc->kvm_type = x86_kvm_type;
     x86mc->save_tsc_khz = true;
     x86mc->fwcfg_dma_enabled = true;
     nc->nmi_monitor_handler = x86_nmi;
@@ -1464,6 +1485,12 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
         NULL, NULL);
     object_class_property_set_description(oc, "sgx-epc",
         "SGX EPC device");
+
+    object_class_property_add_str(oc, X86_MACHINE_KVM_TYPE,
+                                  x86_machine_get_kvm_type,
+                                  x86_machine_set_kvm_type);
+    object_class_property_set_description(oc, X86_MACHINE_KVM_TYPE,
+                                          "KVM guest type (default, sw_protected_vm)");
 }
 
 static const TypeInfo x86_machine_info = {
diff --git a/include/hw/i386/x86.h b/include/hw/i386/x86.h
index da19ae15463a..a3d03f78cefe 100644
--- a/include/hw/i386/x86.h
+++ b/include/hw/i386/x86.h
@@ -42,6 +42,9 @@ struct X86MachineState {
 
     /*< public >*/
 
+    char *kvm_type;
+    unsigned int vm_type;
+
     /* Pointers to devices and objects: */
     ISADevice *rtc;
     FWCfgState *fw_cfg;
@@ -91,6 +94,7 @@ struct X86MachineState {
 #define X86_MACHINE_OEM_ID           "x-oem-id"
 #define X86_MACHINE_OEM_TABLE_ID     "x-oem-table-id"
 #define X86_MACHINE_BUS_LOCK_RATELIMIT  "bus-lock-ratelimit"
+#define X86_MACHINE_KVM_TYPE         "kvm-type"
 
 #define TYPE_X86_MACHINE   MACHINE_TYPE_NAME("x86")
 OBJECT_DECLARE_TYPE(X86MachineState, X86MachineClass, X86_MACHINE)
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index f8cc8eb1fe70..7971f0fd74b1 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -154,6 +154,44 @@ static KVMMSRHandlers msr_handlers[KVM_MSR_FILTER_MAX_RANGES];
 static RateLimit bus_lock_ratelimit_ctrl;
 static int kvm_get_one_msr(X86CPU *cpu, int index, uint64_t *value);
 
+static const char* vm_type_name[] = {
+    [KVM_X86_DEFAULT_VM] = "default",
+    [KVM_X86_SW_PROTECTED_VM] = "sw-protected-vm",
+};
+
+int kvm_get_vm_type(MachineState *ms, const char *vm_type)
+{
+    X86MachineState *x86ms = X86_MACHINE(ms);
+    int kvm_type = KVM_X86_DEFAULT_VM;
+
+    if (vm_type) {
+        if (!g_ascii_strcasecmp(vm_type, "default") || !g_ascii_strcasecmp(vm_type, "")) {
+            kvm_type = KVM_X86_DEFAULT_VM;
+        } else if (!g_ascii_strcasecmp(vm_type, "sw-protected-vm")) {
+            kvm_type = KVM_X86_SW_PROTECTED_VM;
+        } else {
+            error_report("Unknown kvm-type specified '%s'", vm_type);
+            exit(1);
+        }
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
+    x86ms->vm_type = kvm_type;
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

