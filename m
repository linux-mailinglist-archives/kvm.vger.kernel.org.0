Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB34780952
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359592AbjHRJ7y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:59:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359654AbjHRJ72 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:59:28 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A91530DC
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352752; x=1723888752;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/H6irGWQBE1Vlux9V2bGZaDyfdDjrk/4WuCDu3qovd8=;
  b=HtLjn5F4syPbAmLMlhSUsb9JBbaNKkb9jVcZ2uHh9lwzZYDhDjvfRKiH
   YDhXe80iUeRDiezGVeCGcrhVM59inwG1pkinWbijQEOz5h+gAxhVqQJVH
   jrnH+t0PbZM+bNqeLgP66U3OYGC454PzTp3nNDPjxlB8Y8asPo7rF30J0
   eMzYKLW1waIXbAuRUWq3yBnRDaPjJDtyjSrxpAAik+n5wsqr6JORfZkkj
   5j0XhOVoEQ4O3HyyMlarypvKvkKEiqOeQZxMcdbUQWUl+yEpbkcVpAX30
   cKdTFiK07yHmAdhIz7SoOpqswEdU20TwzyLLYiUqO1CrCRwYIGxEmj5US
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966468"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966468"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:57:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235407"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235407"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:57:29 -0700
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
Subject: [PATCH v2 36/58] memory: Introduce memory_region_init_ram_gmem()
Date:   Fri, 18 Aug 2023 05:50:19 -0400
Message-Id: <20230818095041.1973309-37-xiaoyao.li@intel.com>
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

Introduce memory_region_init_ram_gmem() to allocate private gmem on the
MemoryRegion initialization. It's for the usercase of TDVF, which must
be private on TDX case.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/exec/memory.h |  6 +++++
 softmmu/memory.c      | 52 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 759f797b6acd..127ffb6556b9 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -1564,6 +1564,12 @@ void memory_region_init_ram(MemoryRegion *mr,
                             uint64_t size,
                             Error **errp);
 
+void memory_region_init_ram_gmem(MemoryRegion *mr,
+                                 Object *owner,
+                                 const char *name,
+                                 uint64_t size,
+                                 Error **errp);
+
 /**
  * memory_region_init_rom: Initialize a ROM memory region.
  *
diff --git a/softmmu/memory.c b/softmmu/memory.c
index af6aa3c1e3c9..ded44dcef1aa 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -25,6 +25,7 @@
 #include "qom/object.h"
 #include "trace.h"
 
+#include <linux/kvm.h>
 #include "exec/memory-internal.h"
 #include "exec/ram_addr.h"
 #include "sysemu/kvm.h"
@@ -3602,6 +3603,57 @@ void memory_region_init_ram(MemoryRegion *mr,
     vmstate_register_ram(mr, owner_dev);
 }
 
+#ifdef CONFIG_KVM
+void memory_region_init_ram_gmem(MemoryRegion *mr,
+                                 Object *owner,
+                                 const char *name,
+                                 uint64_t size,
+                                 Error **errp)
+{
+    DeviceState *owner_dev;
+    Error *err = NULL;
+    int priv_fd;
+
+    memory_region_init_ram_nomigrate(mr, owner, name, size, &err);
+    if (err) {
+        error_propagate(errp, err);
+        return;
+    }
+
+    if (object_dynamic_cast(OBJECT(current_accel()), TYPE_KVM_ACCEL)) {
+        KVMState *s = KVM_STATE(current_accel());
+        struct kvm_create_guest_memfd gmem = {
+            .size = size,
+            /* TODO: add property to hostmem backend for huge pmd */
+            .flags = KVM_GUEST_MEMFD_ALLOW_HUGEPAGE,
+        };
+
+        priv_fd = kvm_vm_ioctl(s, KVM_CREATE_GUEST_MEMFD, &gmem);
+        if (priv_fd < 0) {
+            fprintf(stderr, "%s: error creating gmem: %s\n", __func__,
+                    strerror(-priv_fd));
+            abort();
+        }
+    } else {
+        fprintf(stderr, "%s: gmem unsupported accel: %s\n", __func__,
+                current_accel_name());
+        abort();
+    }
+
+    memory_region_set_gmem_fd(mr, priv_fd);
+    memory_region_set_default_private(mr);
+
+    /* This will assert if owner is neither NULL nor a DeviceState.
+     * We only want the owner here for the purposes of defining a
+     * unique name for migration. TODO: Ideally we should implement
+     * a naming scheme for Objects which are not DeviceStates, in
+     * which case we can relax this restriction.
+     */
+    owner_dev = DEVICE(owner);
+    vmstate_register_ram(mr, owner_dev);
+}
+#endif
+
 void memory_region_init_rom(MemoryRegion *mr,
                             Object *owner,
                             const char *name,
-- 
2.34.1

