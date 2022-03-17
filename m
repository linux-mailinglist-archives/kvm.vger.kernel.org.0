Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040E64DC817
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 14:59:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234791AbiCQOAw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234782AbiCQOAs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:00:48 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BFDC125C8C
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 06:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525572; x=1679061572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dYwgyA4CmlVvqTrRWnPrKwx4UNncxHfR5e/EXpYyUxw=;
  b=jsf30uM+GSNlGZiVtXzjXu6NLfTPehg/oRE+V1WRt7axSk6Xwn1WBro0
   YClTrWU9q2svN7WLNGkOkMNCR8Hk1h+irC4KxggXOxjPPnUxdBtH3YwaV
   46s5SEF6RBqrWfEgwdzpMcD54jiea4zi3mSg+nrzdTNKqXo75thJSz4Wy
   QNBFQVp16elWdXZ5dbztlCdJuqsTAeAlfeLvSbFuGGam6vsm3mZ9M3dGs
   51FHBGn2Sq2rFg9gOZcQMPD+1tl7C8WO18pBKEuzeFYBPjeiPIFMXAXbc
   bG3VLP4J1YlU9VQvCbdriGIE+6L/oYTzwjUrXnMMKAw5J5RA8f8Zl2NFK
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="256600185"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="256600185"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 06:59:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541377842"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 06:59:27 -0700
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
Subject: [RFC PATCH v3 03/36] target/i386: Implement mc->kvm_type() to get VM type
Date:   Thu, 17 Mar 2022 21:58:40 +0800
Message-Id: <20220317135913.2166202-4-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220317135913.2166202-1-xiaoyao.li@intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TDX VM requires VM type KVM_X86_TDX_VM to be passed to
kvm_ioctl(KVM_CREATE_VM). Hence implement mc->kvm_type() for i386
architecture.

If tdx-guest object is specified to confidential-guest-support, like,

  qemu -machine ...,confidential-guest-support=tdx0 \
       -object tdx-guest,id=tdx0,...

it parses VM type as KVM_X86_TDX_VM. Otherwise, it's KVM_X86_DEFAULT_VM.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 hw/i386/x86.c              |  6 ++++++
 target/i386/kvm/kvm.c      | 30 ++++++++++++++++++++++++++++++
 target/i386/kvm/kvm_i386.h |  1 +
 3 files changed, 37 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 8e30daccdb7c..10a88faf4c0e 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -1330,6 +1330,11 @@ static void machine_set_sgx_epc(Object *obj, Visitor *v, const char *name,
     qapi_free_SgxEPCList(list);
 }
 
+static int x86_kvm_type(MachineState *ms, const char *vm_type)
+{
+    return kvm_get_vm_type(ms, vm_type);
+}
+
 static void x86_machine_initfn(Object *obj)
 {
     X86MachineState *x86ms = X86_MACHINE(obj);
@@ -1353,6 +1358,7 @@ static void x86_machine_class_init(ObjectClass *oc, void *data)
     mc->cpu_index_to_instance_props = x86_cpu_index_to_props;
     mc->get_default_cpu_node_id = x86_get_default_cpu_node_id;
     mc->possible_cpu_arch_ids = x86_possible_cpu_arch_ids;
+    mc->kvm_type = x86_kvm_type;
     x86mc->save_tsc_khz = true;
     x86mc->fwcfg_dma_enabled = true;
     nc->nmi_monitor_handler = x86_nmi;
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index ef2c68a6f475..89d5eb58cb3e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -30,6 +30,7 @@
 #include "sysemu/runstate.h"
 #include "kvm_i386.h"
 #include "sev.h"
+#include "tdx.h"
 #include "hyperv.h"
 #include "hyperv-proto.h"
 
@@ -139,6 +140,35 @@ static struct kvm_msr_list *kvm_feature_msrs;
 #define BUS_LOCK_SLICE_TIME 1000000000ULL /* ns */
 static RateLimit bus_lock_ratelimit_ctrl;
 
+static const char* vm_type_name[] = {
+    [KVM_X86_DEFAULT_VM] = "X86_DEFAULT_VM",
+    [KVM_X86_TDX_VM] = "X86_TDX_VM",
+};
+
+int kvm_get_vm_type(MachineState *ms, const char *vm_type)
+{
+    int kvm_type = KVM_X86_DEFAULT_VM;
+
+    if (ms->cgs && object_dynamic_cast(OBJECT(ms->cgs), TYPE_TDX_GUEST)) {
+        kvm_type = KVM_X86_TDX_VM;
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
index 4124912c202e..b434feaa6b1d 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -37,6 +37,7 @@ bool kvm_has_adjust_clock(void);
 bool kvm_has_adjust_clock_stable(void);
 bool kvm_has_exception_payload(void);
 void kvm_synchronize_all_tsc(void);
+int kvm_get_vm_type(MachineState *ms, const char *vm_type);
 void kvm_arch_reset_vcpu(X86CPU *cs);
 void kvm_arch_do_init_vcpu(X86CPU *cs);
 
-- 
2.27.0

