Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A12614DC81C
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 15:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbiCQOBH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 10:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbiCQOBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 10:01:04 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29D0B89322
        for <kvm@vger.kernel.org>; Thu, 17 Mar 2022 06:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647525587; x=1679061587;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aTSdZI82AokFH8X6Pn4bwj6RRQzCOVm0Q5ETJpyv4xg=;
  b=FuTM4vEv+Uc9iw2nPQlhCig0Rh/4Wus7TL0rRKJMtAaK3GfQoEMeEMz4
   2UaTPkSAwdnGbqaVtlXPUAHoJYweUV7k/iCOv1NQpF+/nju1WBLMN8g+c
   r7mPh/JiHl0E2s12it0c4BKKi9QsQKIxcq9eQxyxNPKftzauxAC6bk8PU
   9S8w2r4QrDUBjM7qcC57HLHny+h7JI1dMnhrmmeYLOVQztemEs5KfIWe4
   zwl4JUKKJDhO8yRbZerJ6vDcGXpVoKigAo3M0LPFdBRdHTNKIjzGvejgs
   p6jXBTyEIBYkIPzojdmvKIS86lggQPdmb8GqjVmQlVbs4AOxsPQuVgw5P
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10288"; a="257058245"
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="257058245"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 06:59:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,188,1643702400"; 
   d="scan'208";a="541377893"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga007.jf.intel.com with ESMTP; 17 Mar 2022 06:59:40 -0700
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
Subject: [RFC PATCH v3 06/36] i386/tdx: Get tdx_capabilities via KVM_TDX_CAPABILITIES
Date:   Thu, 17 Mar 2022 21:58:43 +0800
Message-Id: <20220317135913.2166202-7-xiaoyao.li@intel.com>
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

KVM provides TDX capabilities via sub command KVM_TDX_CAPABILITIES of
IOCTL(KVM_MEMORY_ENCRYPT_OP). Get the capabilities when initializing
TDX context. It will be used to validate user's setting later.

Besides, introduce the interfaces to invoke TDX "ioctls" at different
scope (VM and VCPU) in preparation.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 71 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 71 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index e3b94373b316..bed337e5ba18 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -14,10 +14,77 @@
 #include "qemu/osdep.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
+#include "sysemu/kvm.h"
 
 #include "hw/i386/x86.h"
 #include "tdx.h"
 
+enum tdx_ioctl_level{
+    TDX_VM_IOCTL,
+    TDX_VCPU_IOCTL,
+};
+
+static int __tdx_ioctl(void *state, enum tdx_ioctl_level level, int cmd_id,
+                        __u32 metadata, void *data)
+{
+    struct kvm_tdx_cmd tdx_cmd;
+    int r;
+
+    memset(&tdx_cmd, 0x0, sizeof(tdx_cmd));
+
+    tdx_cmd.id = cmd_id;
+    tdx_cmd.metadata = metadata;
+    tdx_cmd.data = (__u64)(unsigned long)data;
+
+    switch (level) {
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
+#define tdx_vm_ioctl(cmd_id, metadata, data) \
+        __tdx_ioctl(NULL, TDX_VM_IOCTL, cmd_id, metadata, data)
+
+#define tdx_vcpu_ioctl(cpu, cmd_id, metadata, data) \
+        __tdx_ioctl(cpu, TDX_VCPU_IOCTL, cmd_id, metadata, data)
+
+static struct kvm_tdx_capabilities *tdx_caps;
+
+static void get_tdx_capabilities(void)
+{
+    struct kvm_tdx_capabilities *caps;
+    int max_ent = 1;
+    int r, size;
+
+    do {
+        size = sizeof(struct kvm_tdx_capabilities) +
+               max_ent * sizeof(struct kvm_tdx_cpuid_config);
+        caps = g_malloc0(size);
+        caps->nr_cpuid_configs = max_ent;
+
+        r = tdx_vm_ioctl(KVM_TDX_CAPABILITIES, 0, caps);
+        if (r == -E2BIG) {
+            g_free(caps);
+            max_ent *= 2;
+        } else if (r < 0) {
+            error_report("KVM_TDX_CAPABILITIES failed: %s\n", strerror(-r));
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
     TdxGuest *tdx = (TdxGuest *)object_dynamic_cast(OBJECT(ms->cgs),
@@ -26,6 +93,10 @@ int tdx_kvm_init(MachineState *ms, Error **errp)
         return -EINVAL;
     }
 
+    if (!tdx_caps) {
+        get_tdx_capabilities();
+    }
+
     return 0;
 }
 
-- 
2.27.0

