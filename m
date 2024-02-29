Return-Path: <kvm+bounces-10406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61FC486C11A
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:44:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E48FD1F21C6D
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:44:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CC2C45950;
	Thu, 29 Feb 2024 06:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XfdRc22P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6CF45940
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188985; cv=none; b=AaSRPb9aT9lQgMfC0PgTvqMbTQxV9B5cWoy9Oj759KfKnnGVRepuaPscUGbJ1g8759KgDjzdPp5LHZLgh/yrbEVTchLoxcp1wlbcvgdG5xhTT4m2KsTV0tckONvQnzHZOmQx87CpKc3jVWaHwYUw1L9dPtqhpevRK7yQ+tTP0A0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188985; c=relaxed/simple;
	bh=b/U4nruw1qjODZgvFvpoah6U/tv+kV5zlGawoOJt6BU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Xqrise8PHdPOafnlR2fVZ8rvF7sOfUws4OIOEuYVKtHGI2kBto9gpynsjBnbuS+VYpb+rwXByUpLp6MH9Lf7625j8PdvHABsqGPI7o4ts/9Sr27WYa9vJ8OkPNFY6B8ZOiNBycDKz/bEYYsM2d85W+1jqRyThlMt17zSFGJRiw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XfdRc22P; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188984; x=1740724984;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=b/U4nruw1qjODZgvFvpoah6U/tv+kV5zlGawoOJt6BU=;
  b=XfdRc22PjI0oLG4ej5EYoVNAg9SUJC63p3rPuuy7/6N0D+XxlJW+Bh+/
   aT9NeQj86Vwbybbneh1K092ouvqEmUPMTvbNCDCbiV+pXUfPM794ArxwA
   MtCzsLtyOIABFqg/dD2G5t8CH+NfCpYYMzZ9n502wx0s96p1yycLz6UyP
   NsxDGPqu4aVK/VI1xL5uElcUvov2E10KqoWtf11rGWaL/XHnEjDQWr1Et
   0x/4Q7qVTcT/gAZfGAS6hxDeoa3RgyfW8GnhGZFtK5mzKmQrdMBfvOnAU
   YV9SR3b0J9CnOZkhYiw9IKeUzXh3FJo1ufHNS1BK2Pbtgg3fTOkBBYcY8
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3803109"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3803109"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:43:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8076121"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:42:57 -0800
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
Subject: [PATCH v5 50/65] i386/tdx: handle TDG.VP.VMCALL<MapGPA> hypercall
Date: Thu, 29 Feb 2024 01:37:11 -0500
Message-Id: <20240229063726.610065-51-xiaoyao.li@intel.com>
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

MapGPA is a hypercall to convert GPA from/to private GPA to/from shared GPA.
As the conversion function is already implemented as kvm_convert_memory,
wire it to TDX hypercall exit.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 accel/kvm/kvm-all.c   |  2 +-
 include/sysemu/kvm.h  |  2 ++
 target/i386/kvm/tdx.c | 54 +++++++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h |  1 +
 4 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 9dc17a1b5f43..2c83b6d270f7 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2930,7 +2930,7 @@ static void kvm_eat_signals(CPUState *cpu)
     } while (sigismember(&chkset, SIG_IPI));
 }
 
-static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
+int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
 {
     MemoryRegionSection section;
     ram_addr_t offset;
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 82b547848130..78fcf1c3a617 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -550,4 +550,6 @@ int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp);
 
 int kvm_set_memory_attributes_private(hwaddr start, hwaddr size);
 int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size);
+
+int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private);
 #endif
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 7dfda507cc8c..88d245577594 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -898,6 +898,58 @@ static hwaddr tdx_shared_bit(X86CPU *cpu)
     return (cpu->phys_bits > 48) ? BIT_ULL(51) : BIT_ULL(47);
 }
 
+/* 64MB at most in one call. What value is appropriate? */
+#define TDX_MAP_GPA_MAX_LEN     (64 * 1024 * 1024)
+
+static int tdx_handle_map_gpa(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
+{
+    hwaddr shared_bit = tdx_shared_bit(cpu);
+    hwaddr gpa = vmcall->in_r12 & ~shared_bit;
+    bool private = !(vmcall->in_r12 & shared_bit);
+    hwaddr size = vmcall->in_r13;
+    bool retry = false;
+    int ret = 0;
+
+    vmcall->status_code = TDG_VP_VMCALL_INVALID_OPERAND;
+
+    if (!QEMU_IS_ALIGNED(gpa, 4096) || !QEMU_IS_ALIGNED(size, 4096)) {
+        vmcall->status_code = TDG_VP_VMCALL_ALIGN_ERROR;
+        return 0;
+    }
+
+    /* Overflow case. */
+    if (gpa + size < gpa) {
+        return 0;
+    }
+    if (gpa >= (1ULL << cpu->phys_bits) ||
+        gpa + size >= (1ULL << cpu->phys_bits)) {
+        return 0;
+    }
+
+    if (size > TDX_MAP_GPA_MAX_LEN) {
+        retry = true;
+        size = TDX_MAP_GPA_MAX_LEN;
+    }
+
+    if (size > 0) {
+        ret = kvm_convert_memory(gpa, size, private);
+    }
+
+    if (!ret) {
+        if (retry) {
+            vmcall->status_code = TDG_VP_VMCALL_RETRY;
+            vmcall->out_r11 = gpa + size;
+            if (!private) {
+                vmcall->out_r11 |= shared_bit;
+            }
+        } else {
+            vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
+        }
+    }
+
+    return 0;
+}
+
 static void tdx_get_quote_completion(struct tdx_generate_quote_task *task)
 {
     int ret;
@@ -1070,6 +1122,8 @@ static int tdx_handle_vmcall(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
     }
 
     switch (vmcall->subfunction) {
+    case TDG_VP_VMCALL_MAP_GPA:
+        return tdx_handle_map_gpa(cpu, vmcall);
     case TDG_VP_VMCALL_GET_QUOTE:
         return tdx_handle_get_quote(cpu, vmcall);
     case TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT:
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index b7ce793d6037..b6b8742e79f7 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -18,6 +18,7 @@ typedef struct TdxGuestClass {
     ConfidentialGuestSupportClass parent_class;
 } TdxGuestClass;
 
+#define TDG_VP_VMCALL_MAP_GPA                           0x10001ULL
 #define TDG_VP_VMCALL_GET_QUOTE                         0x10002ULL
 #define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT      0x10004ULL
 
-- 
2.34.1


