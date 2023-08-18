Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02D5780909
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359452AbjHRJzW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359412AbjHRJy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:54:58 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085652D7E
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352497; x=1723888497;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X629/XEUUlCOYunPLkm+fd58UGL1s1xQbaVC1vYqOcE=;
  b=CV8yIvAj32AcYLrcvblW2Ku/TzgGOoBsMHxIM4jmU4Osscksiaf9qy5D
   so8xPzsHi/h0I35uIA9EtCo3QcQcqKllOUytJXOPn7/UFhqopaPTpDl7e
   tl1KQkTh2IiJQeyoC40dPo0XzBOX/57PnFmO9qsr/H9j2FIoWzpCfKULu
   Ab9QTsPsQWv2lUSTBZWFzUPQLLHHmHZ7+q37N7irOikwdXx2nAqksi2Vi
   C/nefJ/WkeW7JiXP1Rn8zLPb+MrWR2GTemYoaf0qpnzQctIPySZ8V5ekc
   6rz/J1kdrua/gYMwMwYF2tccLjz7sUi993RvABqb1WGKKZN/4TF7seYFE
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371965654"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371965654"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:54:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849234816"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849234816"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:54:51 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Ani Sinha <anisinha@redhat.com>, Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Laszlo Ersek <lersek@redhat.com>, xiaoyao.li@intel.com,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        erdemaktas@google.com, Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v2 06/58] i386/tdx: Get tdx_capabilities via KVM_TDX_CAPABILITIES
Date:   Fri, 18 Aug 2023 05:49:49 -0400
Message-Id: <20230818095041.1973309-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230818095041.1973309-1-xiaoyao.li@intel.com>
References: <20230818095041.1973309-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM provides TDX capabilities via sub command KVM_TDX_CAPABILITIES of
IOCTL(KVM_MEMORY_ENCRYPT_OP). Get the capabilities when initializing
TDX context. It will be used to validate user's setting later.

Since there is no interface reporting how many cpuid configs contains in
KVM_TDX_CAPABILITIES, QEMU chooses to try starting with a known number
and abort when it exceeds KVM_MAX_CPUID_ENTRIES.

Besides, introduce the interfaces to invoke TDX "ioctls" at different
scope (KVM, VM and VCPU) in preparation.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
changes from v1:
  - Make the error message more clear;

changes from RFC v4:
  - start from nr_cpuid_configs = 6 for the loop;
  - stop the loop when nr_cpuid_configs exceeds KVM_MAX_CPUID_ENTRIES;
---
 target/i386/kvm/kvm.c      |  2 -
 target/i386/kvm/kvm_i386.h |  2 +
 target/i386/kvm/tdx.c      | 93 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index d6b988d6c2d1..ec5c07bffd38 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1751,8 +1751,6 @@ static int hyperv_init_vcpu(X86CPU *cpu)
 
 static Error *invtsc_mig_blocker;
 
-#define KVM_MAX_CPUID_ENTRIES  100
-
 static void kvm_init_xsave(CPUX86State *env)
 {
     if (has_xsave2) {
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index ea3a5b174ac0..769eadbba56c 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -13,6 +13,8 @@
 
 #include "sysemu/kvm.h"
 
+#define KVM_MAX_CPUID_ENTRIES  100
+
 #define kvm_apic_in_kernel() (kvm_irqchip_in_kernel())
 
 #ifdef CONFIG_KVM
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 77e33ae01147..255c47a2a553 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -12,14 +12,107 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/error-report.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
+#include "sysemu/kvm.h"
 
 #include "hw/i386/x86.h"
+#include "kvm_i386.h"
 #include "tdx.h"
 
+static struct kvm_tdx_capabilities *tdx_caps;
+
+enum tdx_ioctl_level{
+    TDX_PLATFORM_IOCTL,
+    TDX_VM_IOCTL,
+    TDX_VCPU_IOCTL,
+};
+
+static int __tdx_ioctl(void *state, enum tdx_ioctl_level level, int cmd_id,
+                        __u32 flags, void *data)
+{
+    struct kvm_tdx_cmd tdx_cmd;
+    int r;
+
+    memset(&tdx_cmd, 0x0, sizeof(tdx_cmd));
+
+    tdx_cmd.id = cmd_id;
+    tdx_cmd.flags = flags;
+    tdx_cmd.data = (__u64)(unsigned long)data;
+
+    switch (level) {
+    case TDX_PLATFORM_IOCTL:
+        r = kvm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+        break;
+    case TDX_VM_IOCTL:
+        r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+        break;
+    case TDX_VCPU_IOCTL:
+        r = kvm_vcpu_ioctl(state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+        break;
+    default:
+        error_report("Invalid tdx_ioctl_level %d", level);
+        exit(1);
+    }
+
+    return r;
+}
+
+static inline int tdx_platform_ioctl(int cmd_id, __u32 flags, void *data)
+{
+    return __tdx_ioctl(NULL, TDX_PLATFORM_IOCTL, cmd_id, flags, data);
+}
+
+static inline int tdx_vm_ioctl(int cmd_id, __u32 flags, void *data)
+{
+    return __tdx_ioctl(NULL, TDX_VM_IOCTL, cmd_id, flags, data);
+}
+
+static inline int tdx_vcpu_ioctl(void *vcpu_fd, int cmd_id, __u32 flags,
+                                 void *data)
+{
+    return  __tdx_ioctl(vcpu_fd, TDX_VCPU_IOCTL, cmd_id, flags, data);
+}
+
+static void get_tdx_capabilities(void)
+{
+    struct kvm_tdx_capabilities *caps;
+    /* 1st generation of TDX reports 6 cpuid configs */
+    int nr_cpuid_configs = 6;
+    int r, size;
+
+    do {
+        size = sizeof(struct kvm_tdx_capabilities) +
+               nr_cpuid_configs * sizeof(struct kvm_tdx_cpuid_config);
+        caps = g_malloc0(size);
+        caps->nr_cpuid_configs = nr_cpuid_configs;
+
+        r = tdx_vm_ioctl(KVM_TDX_CAPABILITIES, 0, caps);
+        if (r == -E2BIG) {
+            g_free(caps);
+            nr_cpuid_configs *= 2;
+            if (nr_cpuid_configs > KVM_MAX_CPUID_ENTRIES) {
+                error_report("KVM TDX seems broken that number of CPUID entries in kvm_tdx_capabilities exceeds limit");
+                exit(1);
+            }
+        } else if (r < 0) {
+            g_free(caps);
+            error_report("KVM_TDX_CAPABILITIES failed: %s", strerror(-r));
+            exit(1);
+        }
+    }
+    while (r == -E2BIG);
+
+    tdx_caps = caps;
+}
+
 int tdx_kvm_init(MachineState *ms, Error **errp)
 {
+    if (!tdx_caps) {
+        get_tdx_capabilities();
+    }
+
     return 0;
 }
 
-- 
2.34.1

