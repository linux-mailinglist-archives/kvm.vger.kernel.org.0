Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390FA78092D
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359492AbjHRJ6B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:58:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359507AbjHRJ5i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:57:38 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDDC3A8B
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352636; x=1723888636;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7ZLBT0rG0ATJUv31+x8JWdiJhQCgvVwu5lEu9uCBHiI=;
  b=OlH0HlhwtTHV11tRnzISjiQDXUgaW0WaJRIlc0oSMVa0hMTf14kL0/Gx
   AegTFC6AEAICNGL/hgx1LF7eToSN49neGsB/f9rdY1GsD4U3iUz6KbCRf
   mB/PtqFNCrVctfgFmzLX/TjYJApYE2z0UfA5g7Ii+QFD6FcUZKFiiON1a
   LOgUvXCToMUsdbOET43K+pYVRMsZ1JHhRxMuT5QO0aCYPMDo1gmMvz5qF
   fg5yVTM59t1EHBmkG4LSD4sOvWoP2kc0L/8qM94xB2T6bXBXLFrR8Qacf
   kqCPicSXnCt+DjIafcrKCu1qIL2p9Gt1SOdKuSejMsWqGl6RcgKsA5NsL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966070"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966070"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:56:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235186"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235186"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:56:22 -0700
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
Subject: [PATCH v2 23/58] i386/tdx: Make memory type private by default
Date:   Fri, 18 Aug 2023 05:50:06 -0400
Message-Id: <20230818095041.1973309-24-xiaoyao.li@intel.com>
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

By default (due to the recent UPM change), restricted memory attribute is
shared.  Convert the memory region from shared to private at the memory
slot creation time.

add kvm region registering function to check the flag
and convert the region, and add memory listener to TDX guest code to set
the flag to the possible memory region.

Without this patch
- Secure-EPT violation on private area
- KVM_MEMORY_FAULT EXIT (kvm -> qemu)
- qemu converts the 4K page from shared to private
- Resume VCPU execution
- Secure-EPT violation again
- KVM resolves EPT Violation
This also prevents huge page because page conversion is done at 4K
granularity.  Although it's possible to merge 4K private mapping into
2M large page, it slows guest boot.

With this patch
- After memory slot creation, convert the region from private to shared
- Secure-EPT violation on private area.
- KVM resolves EPT Violation

Originated-from: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 8a2491ed03c2..775110f8bd02 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -18,6 +18,7 @@
 #include "standard-headers/asm-x86/kvm_para.h"
 #include "sysemu/kvm.h"
 #include "sysemu/sysemu.h"
+#include "exec/address-spaces.h"
 
 #include "hw/i386/x86.h"
 #include "kvm_i386.h"
@@ -578,6 +579,21 @@ out:
     return r;
 }
 
+static void tdx_guest_region_add(MemoryListener *listener,
+                                 MemoryRegionSection *section)
+{
+    if (memory_region_can_be_private(section->mr)) {
+        memory_region_set_default_private(section->mr);
+    }
+}
+
+static MemoryListener tdx_memory_listener = {
+    .name = TYPE_TDX_GUEST,
+    .region_add = tdx_guest_region_add,
+    /* Higher than KVM memory listener = 10. */
+    .priority = MEMORY_LISTENER_PRIORITY_ACCEL_HIGH,
+};
+
 static bool tdx_guest_get_sept_ve_disable(Object *obj, Error **errp)
 {
     TdxGuest *tdx = TDX_GUEST(obj);
@@ -607,6 +623,12 @@ OBJECT_DEFINE_TYPE_WITH_INTERFACES(TdxGuest,
 static void tdx_guest_init(Object *obj)
 {
     TdxGuest *tdx = TDX_GUEST(obj);
+    static bool memory_listener_registered = false;
+
+    if (!memory_listener_registered) {
+        memory_listener_register(&tdx_memory_listener, &address_space_memory);
+        memory_listener_registered = true;
+    }
 
     qemu_mutex_init(&tdx->lock);
 
-- 
2.34.1

