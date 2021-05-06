Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C24B374CEE
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 03:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbhEFBmI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 21:42:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:9149 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhEFBmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 21:42:07 -0400
IronPort-SDR: KmIU8JnjBnhRkakjHKtxz5yzMbBrFks4s0mb4rCVrGmg8mEwS7ShbVfStvu72CsSMKfxs5A5Y/
 ytO+Hx1MrPbQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="195230462"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="195230462"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:08 -0700
IronPort-SDR: gsQl2CG711TFP2h5d0I0AByrDQOClSnXfc2qiNvEDN3PjPRLf/LL5/xuSbtHhEnI5NMKmHJJbs
 59ntSv8QpGIg==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="469220338"
Received: from yy-desk-7060.sh.intel.com ([10.239.159.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:40:57 -0700
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, dgilbert@redhat.com,
        ehabkost@redhat.com, mst@redhat.com, armbru@redhat.com,
        mtosatti@redhat.com, ashish.kalra@amd.com, Thomas.Lendacky@amd.com,
        brijesh.singh@amd.com, isaku.yamahata@intel.com, yuan.yao@intel.com
Subject: [RFC][PATCH v1 02/10] Currently, guest memory access for debugging purposes is performed using memcpy(). Extend the 'struct MemoryRegion' to include new callbacks that can be used to override the use of memcpy() with something else.
Date:   Thu,  6 May 2021 09:40:29 +0800
Message-Id: <20210506014037.11982-3-yuan.yao@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210506014037.11982-1-yuan.yao@linux.intel.com>
References: <20210506014037.11982-1-yuan.yao@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

The new callbacks can be used to display the guest memory of an SEV guest
by registering callbacks to the SEV memory encryption/decryption APIs.

Typical usage:

mem_read(uint8_t *dest,
         const uint8_t *hva_src, hwaddr gpa_src,
         uint32_t len, MemTxAttrs attrs);
mem_write(uint8_t *hva_dest, hwaddr gpa_des,
          const uint8_t *src, uint32_t len, MemTxAttrs attrs);

MemoryRegionRAMReadWriteOps ops;
ops.read = mem_read;
ops.write = mem_write;

memory_region_init_ram(mem, NULL, "memory", size, NULL);
memory_region_set_ram_debug_ops(mem, ops);

Yuan Yao:
 - Add the gpa_src/gpa_des for read/write interface

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Yuan Yao <yuan.yao@intel.com>

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 5728a681b2..7e6fdcb8e4 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -444,6 +444,19 @@ struct IOMMUMemoryRegionClass {
 typedef struct CoalescedMemoryRange CoalescedMemoryRange;
 typedef struct MemoryRegionIoeventfd MemoryRegionIoeventfd;
 
+/* Memory Region RAM debug callback */
+typedef struct MemoryRegionRAMReadWriteOps MemoryRegionRAMReadWriteOps;
+
+struct MemoryRegionRAMReadWriteOps {
+    /* Write data into guest memory */
+    int (*write) (uint8_t *hva_dest, hwaddr gpa_des,
+                  const uint8_t *src, uint32_t len, MemTxAttrs attrs);
+    /* Read data from guest memory */
+    int (*read) (uint8_t *dest,
+                 const uint8_t *hva_src, hwaddr gpa_src,
+                 uint32_t len, MemTxAttrs attrs);
+};
+
 /** MemoryRegion:
  *
  * A struct representing a memory region.
@@ -487,6 +500,7 @@ struct MemoryRegion {
     const char *name;
     unsigned ioeventfd_nb;
     MemoryRegionIoeventfd *ioeventfds;
+    const MemoryRegionRAMReadWriteOps *ram_debug_ops;
 };
 
 struct IOMMUMemoryRegion {
@@ -1130,6 +1144,20 @@ void memory_region_init_rom_nomigrate(MemoryRegion *mr,
                                       uint64_t size,
                                       Error **errp);
 
+/**
+ * memory_region_set_ram_debug_ops: Set access ops for a give memory region.
+ *
+ * @mr: the #MemoryRegion to be initialized
+ * @ops: a function that will be used when accessing @target region during
+ *       debug
+ */
+static inline void
+memory_region_set_ram_debug_ops(MemoryRegion *mr,
+                                const MemoryRegionRAMReadWriteOps *ops)
+{
+    mr->ram_debug_ops = ops;
+}
+
 /**
  * memory_region_init_rom_device_nomigrate:  Initialize a ROM memory region.
  *                                 Writes are handled via callbacks.
-- 
2.20.1

