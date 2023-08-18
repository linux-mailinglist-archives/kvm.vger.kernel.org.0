Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0176678096C
	for <lists+kvm@lfdr.de>; Fri, 18 Aug 2023 12:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359582AbjHRKAk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 06:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359697AbjHRKAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 06:00:23 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18AD23C23
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 02:59:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692352793; x=1723888793;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wjdFC1hf9Xs8TsTDb4kUPELkrCVmj+p3V1t46B9Lvw4=;
  b=RSofvBQ4Dlnitz2d29c06V7wttm4tRVDcnlL6ycsxik8hrDcXzdmma6T
   sFybLSaL2lnmtAusqJfoPw85sSfoywS9+xnDZ3jm7LXWLtJ/iTVZvW+oE
   zDH4PRQfOamyzAN47QmymZMG0n0/wuAr7UGWtTFO0VmnIhiEJjNjfFh+g
   OniraU5GUxuVHuodd1QiVQrc98ZbzlpwrvMvlblyeYIWTAmewyncB9VNQ
   PienKnl0L3Vmx0CzZ7IdpeoseAFOY4dQirrpprzgGjKG5ZC+W+yYaWq27
   wcJuEwBIWgir6IyDl13GrIKxOKK9sCGHgz8OxmD6bSefifudfCfYA3HWq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="371966712"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="371966712"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2023 02:58:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10805"; a="849235526"
X-IronPort-AV: E=Sophos;i="6.01,182,1684825200"; 
   d="scan'208";a="849235526"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.46])
  by fmsmga002.fm.intel.com with ESMTP; 18 Aug 2023 02:58:11 -0700
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
Subject: [PATCH v2 44/58] i386/tdx: handle TDG.VP.VMCALL<MapGPA> hypercall
Date:   Fri, 18 Aug 2023 05:50:27 -0400
Message-Id: <20230818095041.1973309-45-xiaoyao.li@intel.com>
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

MapGPA is a hypercall to convert GPA from/to private GPA to/from shared GPA.
As the conversion function is already implemented as kvm_convert_memory,
wire it to TDX hypercall exit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c   |  2 +-
 include/sysemu/kvm.h  |  2 ++
 target/i386/kvm/tdx.c | 37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 8d53c89e9dbf..b0a18800fd63 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3059,7 +3059,7 @@ static void kvm_eat_signals(CPUState *cpu)
     } while (sigismember(&chkset, SIG_IPI));
 }
 
-static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
+int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
 {
     MemoryRegionSection section;
     void *addr;
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index d89ec87072d7..7e0f56d1c5c5 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -584,4 +584,6 @@ uint32_t kvm_dirty_ring_size(void);
 
 int kvm_set_memory_attributes_private(hwaddr start, hwaddr size);
 int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size);
+
+int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private);
 #endif
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index fa658ce1f2e4..0c43c1f7759f 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -934,6 +934,7 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
 {
 }
 
+#define TDG_VP_VMCALL_MAP_GPA                           0x10001ULL
 #define TDG_VP_VMCALL_GET_QUOTE                         0x10002ULL
 #define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT      0x10004ULL
 
@@ -993,6 +994,39 @@ static hwaddr tdx_shared_bit(X86CPU *cpu)
     return (cpu->phys_bits > 48) ? BIT_ULL(51) : BIT_ULL(47);
 }
 
+static void tdx_handle_map_gpa(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
+{
+    hwaddr shared_bit = tdx_shared_bit(cpu);
+    hwaddr gpa = vmcall->in_r12 & ~shared_bit;
+    bool private = !(vmcall->in_r12 & shared_bit);
+    hwaddr size = vmcall->in_r13;
+    int ret = 0;
+
+    vmcall->status_code = TDG_VP_VMCALL_INVALID_OPERAND;
+
+    if (!QEMU_IS_ALIGNED(gpa, 4096) || !QEMU_IS_ALIGNED(size, 4096)) {
+        vmcall->status_code = TDG_VP_VMCALL_ALIGN_ERROR;
+        return;
+    }
+
+    /* Overflow case. */
+    if (gpa + size < gpa) {
+        return;
+    }
+    if (gpa >= (1ULL << cpu->phys_bits) ||
+        gpa + size >= (1ULL << cpu->phys_bits)) {
+        return;
+    }
+
+    if (size > 0) {
+        ret = kvm_convert_memory(gpa, size, private);
+    }
+
+    if (!ret) {
+        vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
+    }
+}
+
 struct tdx_get_quote_task {
     uint32_t apic_id;
     hwaddr gpa;
@@ -1384,6 +1418,9 @@ static void tdx_handle_vmcall(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
     }
 
     switch (vmcall->subfunction) {
+    case TDG_VP_VMCALL_MAP_GPA:
+        tdx_handle_map_gpa(cpu, vmcall);
+        break;
     case TDG_VP_VMCALL_GET_QUOTE:
         tdx_handle_get_quote(cpu, vmcall);
         break;
-- 
2.34.1

