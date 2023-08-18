Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1988780937
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 11:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359502AbjHRJ7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 05:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243622AbjHRJ6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 05:58:33 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5573C3F
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352695; x=1723888695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XabXP6JP3sejMLekoNMw0ETqyZk6aS55bs9uwl4rtrA=;
  b=aADaYQATSuk8ny8T6K3miPJ+eAZ+Mnsr3l32X2pBh4HiKNLcLpnFnDUR
   rOh4tKPnjMbpRPCTN25ULsKIs06Js78Vwd9t1MsRWrNo6Do6A6LQx+QzM
   VNipVPOT6bndchTpo/Ql6cZc9Po5TxuIHZnRztP4wMBf0tTWGPyMPWafG
   xWFHM69K1Mhn6dWRqdE4JKRQVHPdQAJeICoOaJYMRZHdhxq5dVzcfU8Mh
   93s/7N7US+MGw8N9CvsU77R+U2ckMySwvccFXOD5cVYScdASFumfn4Yzu
   7kL1Z2pFDvmgly1c8sEXnpPxb5STKP7OKXT5xbFyR5t0KLH9VHGd60EzY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966105"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966105"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:56:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235196"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235196"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:56:27 -0700
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
Subject: [PATCH v2 24/58] i386/tdx: Create kvm gmem for TD
Date:   Fri, 18 Aug 2023 05:50:07 -0400
Message-Id: <20230818095041.1973309-25-xiaoyao.li@intel.com>
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

From: Isaku Yamahata <isaku.yamahata@intel.com>

Allocate private gmem for TD guest, if the MemoryRegion is memory
backend and has private property on.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/tdx.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 775110f8bd02..f1305191e939 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -19,6 +19,7 @@
 #include "sysemu/kvm.h"
 #include "sysemu/sysemu.h"
 #include "exec/address-spaces.h"
+#include "exec/ramblock.h"
 
 #include "hw/i386/x86.h"
 #include "kvm_i386.h"
@@ -582,8 +583,30 @@ out:
 static void tdx_guest_region_add(MemoryListener *listener,
                                  MemoryRegionSection *section)
 {
-    if (memory_region_can_be_private(section->mr)) {
-        memory_region_set_default_private(section->mr);
+    MemoryRegion *mr = section->mr;
+    Object *owner = memory_region_owner(mr);
+
+    if (owner && object_dynamic_cast(owner, TYPE_MEMORY_BACKEND) &&
+        object_property_get_bool(owner, "private", NULL) &&
+        mr->ram_block && mr->ram_block->gmem_fd < 0) {
+        struct kvm_create_guest_memfd gmem = {
+            .size = memory_region_size(mr),
+            /* TODO: add property to hostmem backend for huge pmd */
+            .flags = KVM_GUEST_MEMFD_ALLOW_HUGEPAGE,
+        };
+        int fd;
+
+        fd = kvm_vm_ioctl(kvm_state, KVM_CREATE_GUEST_MEMFD, &gmem);
+        if (fd < 0) {
+            fprintf(stderr, "%s: error creating gmem: %s\n", __func__,
+                    strerror(-fd));
+            abort();
+        }
+        memory_region_set_gmem_fd(mr, fd);
+    }
+
+    if (memory_region_can_be_private(mr)) {
+        memory_region_set_default_private(mr);
     }
 }
 
-- 
2.34.1

