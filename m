Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E34652433F
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 05:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343673AbiELDS5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 23:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245697AbiELDSm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 23:18:42 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BB56D39A
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 20:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652325518; x=1683861518;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=my0QV5ZFuAy12zRKZ3VQ+CVRpN2ljFqiVkJVh+RWdF4=;
  b=itgZ8gNQA1ckyxHk2JWrp0I2WEw0pQPdu5cNdLOS4yH8TklwTd3WiGRt
   lAXgyv3QTHzzCZr57KK/UPqipJUGkLYzEc8hf47yw+Y5vVNhDf05Rjg+z
   lkQqht2RXSq8lKKkF9SoYGS60EnR4MhQMDAZkyvjvcZL8ECxZhTEDrX1I
   TN9vq7CnkfOhUDKmp/xjLa0YgUJt4O0bbn6zITV2MGhlCN4aBvaswZ9xn
   Sll+HkxHPypPcC011AzOIF8Y2rYOC+Pc0T1p2ozY+WQNauRuL5Y6GHN4t
   e0PTQu7eak+qd44XV9RgJIuXeBPP0LseWTXSWQya77hcl+rScQGbEApRe
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10344"; a="257424084"
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="257424084"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2022 20:18:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,218,1647327600"; 
   d="scan'208";a="594455498"
Received: from lxy-dell.sh.intel.com ([10.239.159.55])
  by orsmga008.jf.intel.com with ESMTP; 11 May 2022 20:18:32 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, Gerd Hoffmann <kraxel@redhat.com>,
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
Subject: [RFC PATCH v4 06/36] i386/tdx: Get tdx_capabilities via KVM_TDX_CAPABILITIES
Date:   Thu, 12 May 2022 11:17:33 +0800
Message-Id: <20220512031803.3315890-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220512031803.3315890-1-xiaoyao.li@intel.com>
References: <20220512031803.3315890-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM provides TDX capabilities via sub command KVM_TDX_CAPABILITIES of
IOCTL(KVM_MEMORY_ENCRYPT_OP). Get the capabilities when initializing
TDX context. It will be used to validate user's setting later.

Besides, introduce the interfaces to invoke TDX "ioctls" at different
scope (KVM, VM and VCPU) in preparation.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 85 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 85 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 77e33ae01147..68bedbad0ebe 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -14,12 +14,97 @@
 #include "qemu/osdep.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
+#include "sysemu/kvm.h"
 
 #include "hw/i386/x86.h"
 #include "tdx.h"
 
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
+static inline int tdx_platform_ioctl(int cmd_id, __u32 metadata, void *data)
+{
+    return __tdx_ioctl(NULL, TDX_PLATFORM_IOCTL, cmd_id, metadata, data);
+}
+
+static inline int tdx_vm_ioctl(int cmd_id, __u32 metadata, void *data)
+{
+    return __tdx_ioctl(NULL, TDX_VM_IOCTL, cmd_id, metadata, data);
+}
+
+static inline int tdx_vcpu_ioctl(void *vcpu_fd, int cmd_id, __u32 metadata,
+                                 void *data)
+{
+    return  __tdx_ioctl(vcpu_fd, TDX_VCPU_IOCTL, cmd_id, metadata, data);
+}
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
+        r = tdx_platform_ioctl(KVM_TDX_CAPABILITIES, 0, caps);
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
+    if (!tdx_caps) {
+        get_tdx_capabilities();
+    }
+
     return 0;
 }
 
-- 
2.27.0

