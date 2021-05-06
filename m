Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9D2374CF0
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 03:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbhEFBmJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 21:42:09 -0400
Received: from mga11.intel.com ([192.55.52.93]:9158 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230294AbhEFBmJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 21:42:09 -0400
IronPort-SDR: KQ9RUesta1th8Eg3RzpZUSCYGy6gMKt8EdhqOjn8igoDcUL2+eNHbw5y2KTKHgQtj5AFwtb17v
 MwllW5Fk+Zfw==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="195230473"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="195230473"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:11 -0700
IronPort-SDR: +aGY4EzyJD9S1GtGVUkEkdSKjoINddR0rLoGI2JG83jpe49jZ+WiJo9TCVl8LJzPPIZcsk8Ea0
 QgqzRgq49FlQ==
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="469220373"
Received: from yy-desk-7060.sh.intel.com ([10.239.159.38])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 18:41:08 -0700
From:   Yuan Yao <yuan.yao@linux.intel.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org, dgilbert@redhat.com,
        ehabkost@redhat.com, mst@redhat.com, armbru@redhat.com,
        mtosatti@redhat.com, ashish.kalra@amd.com, Thomas.Lendacky@amd.com,
        brijesh.singh@amd.com, isaku.yamahata@intel.com, yuan.yao@intel.com
Subject: [RFC][PATCH v1 04/10] Implements the common MemoryRegion::ram_debug_ops for encrypted guests
Date:   Thu,  6 May 2021 09:40:31 +0800
Message-Id: <20210506014037.11982-5-yuan.yao@linux.intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210506014037.11982-1-yuan.yao@linux.intel.com>
References: <20210506014037.11982-1-yuan.yao@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Yuan Yao <yuan.yao@intel.com>

The new functions are added into target/i386/kvm/kvm.c as common functions
to support encrypted guest for KVM on x86.

Now we enable these only for INTEL TD guests.

Signed-off-by: Yuan Yao <yuan.yao@intel.com>

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 05bf4f8b8b..5050b2a82f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -134,6 +134,9 @@ static struct kvm_msr_list *kvm_feature_msrs;
 
 static int vm_type;
 
+void kvm_encrypted_guest_set_memory_region_debug_ops(void *handle,
+                                                     MemoryRegion *mr);
+
 int kvm_set_vm_type(MachineState *ms, int kvm_type)
 {
     if (kvm_type == KVM_X86_LEGACY_VM ||
@@ -2228,6 +2231,10 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         return ret;
     }
 
+    if (kvm_tdx_enabled())
+        kvm_setup_memory_region_debug_ops(s,
+                                          kvm_encrypted_guest_set_memory_region_debug_ops);
+
     if (!kvm_check_extension(s, KVM_CAP_IRQ_ROUTING)) {
         error_report("kvm: KVM_CAP_IRQ_ROUTING not supported by KVM");
         return -ENOTSUP;
@@ -4917,3 +4924,62 @@ bool kvm_arch_cpu_check_are_resettable(void)
 {
     return !sev_es_enabled();
 }
+
+static int kvm_encrypted_guest_read_memory(uint8_t *dest,
+                                           const uint8_t *hva_src, hwaddr gpa_src,
+                                           uint32_t len, MemTxAttrs attrs)
+{
+    struct kvm_rw_memory rw;
+
+    /*
+      TODO:
+      Can we check SEV/TDX state to decide use
+      gpa_dest or hva_dest here ?
+
+      Also how shall we handle the kvm_vm_ioctl failure case ?
+      Some user like cpu_physical_memory_{read,write}() doesn't handle such
+      failure, because for non-encrypted guest these functions may do memory
+      reading/wrting with memcpy() dirctly before.
+      May memset() the buffer to a bad pattern (all 0x0 or 0xff)
+      for indicating this ?
+    */
+    rw.addr = gpa_src;
+    rw.buf = dest;
+    rw.len = len;
+
+    return kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_READ_MEMORY, &rw);
+}
+
+static int kvm_encrypted_guest_write_memory(uint8_t *hva_dest, hwaddr gpa_dest,
+                                            const uint8_t *src,
+                                            uint32_t len, MemTxAttrs attrs)
+{
+    struct kvm_rw_memory rw;
+
+    /*
+      TODO:
+      Can we check SEV/TDX state to decide use
+      gpa_dest or hva_dest here ?
+
+      Also how shall we handle the kvm_vm_ioctl failure case ?
+      Some user like cpu_physical_memory_{read,write}() doesn't handle such
+      failure, because for non-encrypted guest these functions may do memory
+      reading/wrting with memcpy() dirctly before.
+     */
+    rw.addr = gpa_dest;
+    rw.buf = (void*)src;
+    rw.len = len;
+
+    return kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_WRITE_MEMORY, &rw);
+}
+
+static MemoryRegionRAMReadWriteOps kvm_encrypted_guest_mr_debug_ops = {
+    .read = kvm_encrypted_guest_read_memory,
+    .write = kvm_encrypted_guest_write_memory,
+};
+
+void kvm_encrypted_guest_set_memory_region_debug_ops(void *handle,
+                                                     MemoryRegion *mr)
+{
+    memory_region_set_ram_debug_ops(mr, &kvm_encrypted_guest_mr_debug_ops);
+}
-- 
2.20.1

