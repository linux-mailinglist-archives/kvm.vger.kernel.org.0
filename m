Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E233379F91B
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 05:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbjINDw2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Sep 2023 23:52:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234463AbjINDw0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Sep 2023 23:52:26 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAA299
        for <kvm@vger.kernel.org>; Wed, 13 Sep 2023 20:52:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694663542; x=1726199542;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eKloPCcRi+HIRDzS+h7jCyuEt7bYm6PhIvGdqysJsx8=;
  b=BuUtMj89OCK+I+9fyUDaNhvZfKxwCyk3FPC19ROViY0N9m+PvHQE61su
   LP1s7wL3eF6/69r2MV53knm2EsAasRHjwDECpVskkIQcRCub8bio2JdcL
   +UE/RhvVEf82ibXlVnYpv++MJUD51qBhkVgmPXIWTWSUkMUsD2mNCvjsy
   993/ZzjtgtBrKBUWerXT3rya2hQm5OclvG4ej9sSYoa9yTIZX0J2tkpgC
   75eNdd2PU5y5bta67qReWM/VHIJ/V90pe3anMYG8PXnh+EMS/XVBNkhem
   lQkVN9tYr4xMBLCsuFAJTml2FTrQOIM/omRfdjHzYcV5HHkwMXlRo7awC
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="381528478"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="381528478"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2023 20:52:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10832"; a="814500625"
X-IronPort-AV: E=Sophos;i="6.02,144,1688454000"; 
   d="scan'208";a="814500625"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmsmga004.fm.intel.com with ESMTP; 13 Sep 2023 20:52:18 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, xiaoyao.li@intel.com,
        Michael Roth <michael.roth@amd.com>, isaku.yamahata@gmail.com,
        Sean Christopherson <seanjc@google.com>,
        Claudio Fontana <cfontana@suse.de>
Subject: [RFC PATCH v2 13/21] i386/kvm: Set memory to default private for KVM_X86_SW_PROTECTED_VM
Date:   Wed, 13 Sep 2023 23:51:09 -0400
Message-Id: <20230914035117.3285885-14-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230914035117.3285885-1-xiaoyao.li@intel.com>
References: <20230914035117.3285885-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Register a memory listener for KVM_X86_SW_PROVTED_VM. It set RAM to
private by default.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 include/exec/memory.h             |  1 +
 target/i386/kvm/sw-protected-vm.c | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 2c738b5dc420..a2602b783a38 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -820,6 +820,7 @@ struct IOMMUMemoryRegion {
 #define MEMORY_LISTENER_PRIORITY_MIN            0
 #define MEMORY_LISTENER_PRIORITY_ACCEL          10
 #define MEMORY_LISTENER_PRIORITY_DEV_BACKEND    10
+#define MEMORY_LISTENER_PRIORITY_ACCEL_HIGH     20
 
 /**
  * struct MemoryListener: callbacks structure for updates to the physical memory map
diff --git a/target/i386/kvm/sw-protected-vm.c b/target/i386/kvm/sw-protected-vm.c
index 3cfcc89202a6..f47ac383e1dd 100644
--- a/target/i386/kvm/sw-protected-vm.c
+++ b/target/i386/kvm/sw-protected-vm.c
@@ -12,14 +12,32 @@
 #include "qemu/osdep.h"
 #include "qapi/error.h"
 #include "qom/object_interfaces.h"
+#include "exec/address-spaces.h"
+#include "sysemu/kvm.h"
 
 #include "hw/i386/x86.h"
 #include "sw-protected-vm.h"
 
+static void kvm_x86_sw_protected_vm_region_add(MemoryListener *listenr,
+                                               MemoryRegionSection *section)
+{
+    memory_region_set_default_private(section->mr);
+}
+
+static MemoryListener kvm_x86_sw_protected_vm_memory_listener = {
+    .name = "kvm_x86_sw_protected_vm_memory_listener",
+    .region_add = kvm_x86_sw_protected_vm_region_add,
+    /* Higher than KVM memory listener = 10. */
+    .priority = MEMORY_LISTENER_PRIORITY_ACCEL_HIGH,
+};
+
 int sw_protected_vm_kvm_init(MachineState *ms, Error **errp)
 {
     SwProtectedVm *spvm = SW_PROTECTED_VM(OBJECT(ms->cgs));
 
+    memory_listener_register(&kvm_x86_sw_protected_vm_memory_listener,
+                             &address_space_memory);
+
     spvm->parent_obj.ready = true;
     return 0;
 }
-- 
2.34.1

