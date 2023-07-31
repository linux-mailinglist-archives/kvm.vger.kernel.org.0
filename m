Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7FD769C5B
	for <lists+kvm@lfdr.de>; Mon, 31 Jul 2023 18:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbjGaQ0A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 12:26:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233025AbjGaQZz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 12:25:55 -0400
Received: from mgamail.intel.com (unknown [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413E919A5
        for <kvm@vger.kernel.org>; Mon, 31 Jul 2023 09:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690820739; x=1722356739;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vc/AA0VTFSVygJctuEuxWBeG2HxDcS51m4hly05CELA=;
  b=GUPLHFSHSkscfc67A30+H4NptkD4P86sE6btL89ZnMGR1Bsae0t84xVY
   +GW7ug1mCTxt2zz6FwnZ/zlTW9ku9ZxpxhVC3m65Sk8eihzZkEcg/iKFM
   Vz8eLE+CUVEYSiNj2PJTnsJDNt2UYKcv+6GsKQLkDdGlYWTjtFEUA0kCV
   72ZGoh4cDxBKqHxnviPh5CFIS9pFLf+zFmAiv1JMTl2SkkVFvFpbzHIOY
   Arg2EV19vBZEMsipi6WBlAhqKbgS0uO8O8Nv3yoYJVMMfHEi5Y/9Iw+wt
   TV46U5zhAXuDAZO0U8FHd3P102jmD2cS6fzxtt66YA1aad3hMwHG5Q8Qk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="353993494"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="353993494"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2023 09:25:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10788"; a="757984252"
X-IronPort-AV: E=Sophos;i="6.01,244,1684825200"; 
   d="scan'208";a="757984252"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by orsmga008.jf.intel.com with ESMTP; 31 Jul 2023 09:25:33 -0700
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
Subject: [RFC PATCH 10/19] kvm: Introduce support for memory_attributes
Date:   Mon, 31 Jul 2023 12:21:52 -0400
Message-Id: <20230731162201.271114-11-xiaoyao.li@intel.com>
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

Introcude the helper functions to set the attributes of a range of
memory to private and shared.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c  | 43 +++++++++++++++++++++++++++++++++++++++++++
 include/sysemu/kvm.h |  3 +++
 2 files changed, 46 insertions(+)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 7b1818334ba7..6dd22fa4fd6f 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -105,6 +105,7 @@ bool kvm_msi_use_devid;
 bool kvm_has_guest_debug;
 static int kvm_sstep_flags;
 static bool kvm_immediate_exit;
+static uint64_t kvm_supported_memory_attributes;
 static hwaddr kvm_max_slot_size = ~0;
 
 static const KVMCapabilityInfo kvm_required_capabilites[] = {
@@ -1343,6 +1344,44 @@ void kvm_set_max_memslot_size(hwaddr max_slot_size)
     kvm_max_slot_size = max_slot_size;
 }
 
+static int kvm_set_memory_attributes(hwaddr start, hwaddr size, uint64_t attr)
+{
+    struct kvm_memory_attributes attrs;
+    int r;
+
+    attrs.attributes = attr;
+    attrs.address = start;
+    attrs.size = size;
+    attrs.flags = 0;
+
+    r = kvm_vm_ioctl(kvm_state, KVM_SET_MEMORY_ATTRIBUTES, &attrs);
+    if (r) {
+        warn_report("%s: failed to set memory (0x%lx+%#zx) with attr 0x%lx error '%s'",
+                     __func__, start, size, attr, strerror(errno));
+    }
+    return r;
+}
+
+int kvm_set_memory_attributes_private(hwaddr start, hwaddr size)
+{
+    if (!(kvm_supported_memory_attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+        error_report("KVM doesn't support PRIVATE memory attribute\n");
+        return -EINVAL;
+    }
+
+    return kvm_set_memory_attributes(start, size, KVM_MEMORY_ATTRIBUTE_PRIVATE);
+}
+
+int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size)
+{
+    if (!(kvm_supported_memory_attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+        error_report("KVM doesn't support PRIVATE memory attribute\n");
+        return -EINVAL;
+    }
+
+    return kvm_set_memory_attributes(start, size, 0);
+}
+
 /* Called with KVMMemoryListener.slots_lock held */
 static void kvm_set_phys_mem(KVMMemoryListener *kml,
                              MemoryRegionSection *section, bool add)
@@ -2556,6 +2595,10 @@ static int kvm_init(MachineState *ms)
     }
     s->as = g_new0(struct KVMAs, s->nr_as);
 
+    if (kvm_check_extension(s, KVM_CAP_MEMORY_ATTRIBUTES)) {
+        kvm_supported_memory_attributes = kvm_ioctl(s, KVM_GET_SUPPORTED_MEMORY_ATTRIBUTES, 0);
+    }
+
     if (object_property_find(OBJECT(current_machine), "kvm-type")) {
         g_autofree char *kvm_type = object_property_get_str(OBJECT(current_machine),
                                                             "kvm-type",
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 115f0cca79d1..49c896d8a512 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -580,4 +580,7 @@ bool kvm_arch_cpu_check_are_resettable(void);
 bool kvm_dirty_ring_enabled(void);
 
 uint32_t kvm_dirty_ring_size(void);
+
+int kvm_set_memory_attributes_private(hwaddr start, hwaddr size);
+int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size);
 #endif
-- 
2.34.1

