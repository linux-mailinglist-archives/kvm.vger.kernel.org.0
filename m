Return-Path: <kvm+bounces-10401-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DFFE86C111
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:44:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 906241F212CD
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371AD4F1EA;
	Thu, 29 Feb 2024 06:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AlRwokhf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A6E4EB34
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188952; cv=none; b=Fb1hv4++Z7KvSX8KCczoGk/pSoJdjoYBbyFtgcQ5atAbrG4t52e84Jx3t4xj4ErUwIZMKVShOjArdopH/xM4IDkpUSos+zD8NKM3MHYKVeErGayNwfz9jVOgDi4d10FJC0UkrAT9I68NMJxAkgqKJE409sX2e+JK4oOKtKgOGNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188952; c=relaxed/simple;
	bh=z/FfjECQSUX/uPyyzFkqQxNReR6RwWQF44mKqaJHFI0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aGONMgwlOw0wtLh73ZnFEh3JiWqC+zO5d8tYoc44CnofLfizKWkjK1jrgiKgVsZVEpWY/xIynyahbARtUrDSCch2a9uzXvbKM3kGhYmxSgU4Rkbem6TtmSfzmmR3T2torbu2Nsq09jSCiVAyKqoWV3uxlzR791Iy+6dXxASjEZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AlRwokhf; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188951; x=1740724951;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=z/FfjECQSUX/uPyyzFkqQxNReR6RwWQF44mKqaJHFI0=;
  b=AlRwokhfAU5tfe4jAcJTdYuYlRaal88h5DjHiZCKEDGWS0Ii3PSls4Mh
   iLSyPrAMTn3g4auI3GFLZf8ZzVt4rmdTh4Wm9u9z0G2AptHSfeS+5NRJm
   mGQmR7RmkNyKq2Ndbm5jM8dzvrh4lJGAo4k9Af1kCZSrUi7rZtvfMlEdV
   bdBVKr+GsJaXz3qmGM2gcOraDJwmGGoDtcXDRj7RGXoMul7SI9yAzXl5X
   MO2sARIucP55DzrR4hjSC1EOMka4UFS1BhkWusoxyFAFdSbTfE3RyYzfg
   QFEzGFIi2qF+3ufBIoOx3Y24/TKaku+GPipoXtRUP05SZrLte70cQtvU3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3803030"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3803030"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:42:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8076054"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:42:24 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Ani Sinha <anisinha@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	Michael Roth <michael.roth@amd.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>,
	xiaoyao.li@intel.com
Subject: [PATCH v5 45/65] i386/tdx: Populate TDVF private memory via KVM_MEMORY_MAPPING
Date: Thu, 29 Feb 2024 01:37:06 -0500
Message-Id: <20240229063726.610065-46-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240229063726.610065-1-xiaoyao.li@intel.com>
References: <20240229063726.610065-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

TDVF firmware (CODE and VARS) needs to be copied to TD's private
memory, as well as TD HOB and TEMP memory.

If the TDVF section has TDVF_SECTION_ATTRIBUTES_MR_EXTEND set in the
flag, calling KVM_TDX_EXTEND_MEMORY to extend the measurement.

After populating the TDVF memory, the original image located in shared
ramblock can be discarded.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Acked-by: Gerd Hoffmann <kraxel@redhat.com>

---
Changes in v1:
  - rename variable @metadata to @flags
---
 target/i386/kvm/tdx.c | 47 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index fb9c60172fde..dcabe359eda5 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -595,6 +595,8 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
 {
     TdxFirmware *tdvf = &tdx_guest->tdvf;
     TdxFirmwareEntry *entry;
+    RAMBlock *ram_block;
+    int r;
 
     tdx_init_ram_entries();
 
@@ -620,6 +622,51 @@ static void tdx_finalize_vm(Notifier *notifier, void *unused)
           sizeof(TdxRamEntry), &tdx_ram_entry_compare);
 
     tdvf_hob_create(tdx_guest, tdx_get_hob_entry(tdx_guest));
+
+    for_each_tdx_fw_entry(tdvf, entry) {
+        struct kvm_memory_mapping mapping = {
+            .base_gfn = entry->address >> 12,
+            .nr_pages = entry->size >> 12,
+            .source = (__u64)entry->mem_ptr,
+        };
+
+        do {
+            r = kvm_vcpu_ioctl(first_cpu, KVM_MEMORY_MAPPING, &mapping);
+        } while (r == -EAGAIN);
+
+        if (r < 0) {
+             error_report("KVM_MEMORY_MAPPING failed %s", strerror(-r));
+             exit(1);
+        }
+
+        if (entry->attributes & TDVF_SECTION_ATTRIBUTES_MR_EXTEND) {
+            mapping = (struct kvm_memory_mapping) {
+                .base_gfn = entry->address >> 12,
+                .nr_pages = entry->size >> 12,
+            };
+
+            do {
+                r = tdx_vm_ioctl(KVM_TDX_EXTEND_MEMORY, 0, &mapping);
+            } while (r == -EAGAIN);
+            if (r < 0) {
+                error_report("KVM_TDX_EXTEND_MEMORY failed %s", strerror(-r));
+                exit(1);
+            }
+        }
+
+        if (entry->type == TDVF_SECTION_TYPE_TD_HOB ||
+            entry->type == TDVF_SECTION_TYPE_TEMP_MEM) {
+            qemu_ram_munmap(-1, entry->mem_ptr, entry->size);
+            entry->mem_ptr = NULL;
+        }
+    }
+
+    /*
+     * TDVF image has been copied into private region above via
+     * KVM_MEMORY_MAPPING. It becomes useless.
+     */
+    ram_block = tdx_guest->tdvf_mr->ram_block;
+    ram_block_discard_range(ram_block, 0, ram_block->max_length);
 }
 
 static Notifier tdx_machine_done_notify = {
-- 
2.34.1


