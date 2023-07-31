Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 158EB769C65
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbjGaQ0k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjGaQ0a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:26:30 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A77851BE6
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:26:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820769; x=1722356769;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GSbcff0w9eBcLKQoepD8WEW33V5SkOKmuZmwcCsYEA0=;
  b=SlMpFOkoV2LU7GqQxNn4PM/Cyo9NjOE4I8o05F3Pq+G4lI328PbR3Q11
   /Ja/2uaf0BTQiTyO2VlnsuPWPPOU8vXmdl90UxvmuP5JEkE0EPzyf3qEc
   f7dxO0Rj9/agNsU0Gp7+a2poSQ1O+J8NODZkXLEvUIUywGKpJQKF6yylA
   xv8gr3OO3vonMzjzhAvBvuR66Mt6DnD8EF3zw2XtJTm0GlcV39Gl1URqP
   ruYaCzCjvS3pGKTA0SdFNkAF5Ijr7o+aRh/Sg412hy6nwspm2P+M6QNTs
   0CWeJ8AJRn/qfqjSDHFizpzIcy5ndvdT4sR6CGLRdGWItlYMP7FTE0a3T
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993571"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993571"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:26:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984336"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984336"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:25:56 -0700
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
Subject: [RFC PATCH 15/19] kvm: handle KVM_EXIT_MEMORY_FAULT
Date:   Mon, 31 Jul 2023 12:21:57 -0400
Message-Id: <20230731162201.271114-16-xiaoyao.li@intel.com>
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

From: Chao Peng <chao.p.peng@linux.intel.com>

Currently only KVM_MEMORY_EXIT_FLAG_PRIVATE in flags is valid when
KVM_EXIT_MEMORY_FAULT happens. It indicates userspace needs to do
the memory conversion on the RAMBlock to turn the memory into desired
attribute, i.e., private/shared.

Note, KVM_EXIT_MEMORY_FAULT makes sense only when the RAMBlock has
gmem memory backend.

Signed-off-by: Chao Peng <chao.p.peng@linux.intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c | 52 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index f9b5050b8885..72d50b923bf2 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3040,6 +3040,48 @@ static void kvm_eat_signals(CPUState *cpu)
     } while (sigismember(&chkset, SIG_IPI));
 }
 
+static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
+{
+    MemoryRegionSection section;
+    void *addr;
+    RAMBlock *rb;
+    ram_addr_t offset;
+    int ret = -1;
+
+    section = memory_region_find(get_system_memory(), start, size);
+    if (!section.mr) {
+        return ret;
+    }
+
+    if (memory_region_can_be_private(section.mr)) {
+        if (to_private) {
+            ret = kvm_set_memory_attributes_private(start, size);
+        } else {
+            ret = kvm_set_memory_attributes_shared(start, size);
+        }
+
+        if (ret) {
+            return ret;
+        }
+
+        addr = memory_region_get_ram_ptr(section.mr) +
+               section.offset_within_region;
+        rb = qemu_ram_block_from_host(addr, false, &offset);
+        /*
+         * With KVM_SET_MEMORY_ATTRIBUTES by kvm_set_memory_attributes(),
+         * operation on underlying file descriptor is only for releasing
+         * unnecessary pages.
+         */
+        ram_block_convert_range(rb, offset, size, to_private);
+    } else {
+        warn_report("Convert non guest-memfd backed memory region (0x%"HWADDR_PRIx" ,+ 0x%"HWADDR_PRIx") to %s",
+                    start, size, to_private ? "private" : "shared");
+    }
+
+    memory_region_unref(section.mr);
+    return ret;
+}
+
 int kvm_cpu_exec(CPUState *cpu)
 {
     struct kvm_run *run = cpu->kvm_run;
@@ -3198,6 +3240,16 @@ int kvm_cpu_exec(CPUState *cpu)
                 break;
             }
             break;
+        case KVM_EXIT_MEMORY_FAULT:
+            if (run->memory.flags & ~KVM_MEMORY_EXIT_FLAG_PRIVATE) {
+                error_report("KVM_EXIT_MEMORY_FAULT: Unknown flag 0x%" PRIx64,
+                             (uint64_t)run->memory.flags);
+                ret = -1;
+                break;
+            }
+            ret = kvm_convert_memory(run->memory.gpa, run->memory.size,
+                                     run->memory.flags & KVM_MEMORY_EXIT_FLAG_PRIVATE);
+            break;
         default:
             DPRINTF("kvm_arch_handle_exit\n");
             ret = kvm_arch_handle_exit(cpu, run);
-- 
2.34.1

