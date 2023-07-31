Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67F8769C5A
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbjGaQZw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbjGaQZu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:25:50 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E751A19AC
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820733; x=1722356733;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Kl0SGGt7OdcIiPqVNrEI2K05JRMW2feCGQzusuuxZsU=;
  b=ZSaeIIX8vVJPb6dR9lChMuNLK0ZDDBoc/La/u7JWVwjnRuo07H0CkrX6
   St6L9uxfEILQ1cIZy8MbINgUCNKmWvhC7zJ0eMYqtTtRCef6aFWoC4UNQ
   LHq+Dm3Rg8bIINKUYF8UD8BhJYLfZmpllrYvBH4JAaAYMQCaL4b5x3SHu
   beyMvFvH1sAtEfEYqlI667Pm0ZNYKIsGO1cKt6qjBeD1pqV/PiUDs3nvo
   xjiuV7umh55Cnjo5hD7XDMC4JRULXRL8N7r5cB8vclM0sRS923ZygFFbD
   Qw72wHGLiDItIYAXeJYJswXyaJ5Vt9unokEI7FImoPkLb7nx/ujIcNrC8
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993482"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993482"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:25:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984213"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984213"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:25:29 -0700
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
Subject: [RFC PATCH 09/19] i386/kvm: Create gmem fd for KVM_X86_SW_PROTECTED_VM
Date:   Mon, 31 Jul 2023 12:21:51 -0400
Message-Id: <20230731162201.271114-10-xiaoyao.li@intel.com>
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

Register a memory listener for KVM_X86_SW_PROVTED_VM. It creates gmem
for the backend who sets the private property.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/exec/memory.h |  1 +
 target/i386/kvm/kvm.c | 38 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index e119d3ce1a1d..ddf0e14970b0 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -814,6 +814,7 @@ struct IOMMUMemoryRegion {
 #define MEMORY_LISTENER_PRIORITY_MIN            0
 #define MEMORY_LISTENER_PRIORITY_ACCEL          10
 #define MEMORY_LISTENER_PRIORITY_DEV_BACKEND    10
+#define MEMORY_LISTENER_PRIORITY_ACCEL_HIGH     20
 
 /**
  * struct MemoryListener: callbacks structure for updates to the physical memory map
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7971f0fd74b1..df3a5f89396e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -37,6 +37,7 @@
 #include "hyperv-proto.h"
 
 #include "exec/gdbstub.h"
+#include "exec/ramblock.h"
 #include "qemu/host-utils.h"
 #include "qemu/main-loop.h"
 #include "qemu/ratelimit.h"
@@ -2591,8 +2592,41 @@ static void register_smram_listener(Notifier *n, void *unused)
                                  &smram_address_space, 1, "kvm-smram");
 }
 
+static void kvm_x86_sw_protected_vm_region_add(MemoryListener *listenr,
+                                       MemoryRegionSection *section)
+{
+    MemoryRegion *mr = section->mr;
+    Object *owner = memory_region_owner(mr);
+    int fd;
+
+    if (owner && object_dynamic_cast(owner, TYPE_MEMORY_BACKEND) &&
+        object_property_get_bool(owner, "private", NULL) &&
+        mr->ram_block && mr->ram_block->gmem_fd < 0) {
+        struct kvm_create_guest_memfd gmem = {
+            .size = memory_region_size(mr),
+            /* TODO: to decide whether KVM_GUEST_MEMFD_ALLOW_HUGEPAGE is supported */
+            .flags = KVM_GUEST_MEMFD_ALLOW_HUGEPAGE,
+        };
+
+        fd = kvm_vm_ioctl(kvm_state, KVM_CREATE_GUEST_MEMFD, &gmem);
+        if (fd < 0) {
+            error_report("%s: error creating gmem: %s\n", __func__, strerror(-fd));
+            exit(1);
+        }
+        memory_region_set_gmem_fd(mr, fd);
+    }
+}
+
+static MemoryListener kvm_x86_sw_protected_vm_memory_listener = {
+    .name = "kvm_x86_sw_protected_vm_memory_listener",
+    .region_add = kvm_x86_sw_protected_vm_region_add,
+    /* Higher than KVM memory listener = 10. */
+    .priority = MEMORY_LISTENER_PRIORITY_ACCEL_HIGH,
+};
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
+    X86MachineState *x86ms = X86_MACHINE(ms);
     uint64_t identity_base = 0xfffbc000;
     uint64_t shadow_mem;
     int ret;
@@ -2617,6 +2651,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         return ret;
     }
 
+    if (x86ms->vm_type == KVM_X86_SW_PROTECTED_VM) {
+        memory_listener_register(&kvm_x86_sw_protected_vm_memory_listener, &address_space_memory);
+    }
+
     if (!kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
         error_report("kvm: KVM_CAP_IRQ_ROUTING not supported by KVM");
         return -ENOTSUP;
-- 
2.34.1

