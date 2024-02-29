Return-Path: <kvm+bounces-10404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B71D686C117
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 07:44:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 443941F21FB0
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 06:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 200C044C69;
	Thu, 29 Feb 2024 06:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hvFgn3kI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5CF446D3
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 06:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709188972; cv=none; b=NztUd3CMcWjj1xFrjpyswIbM39JJg5iXa5da2peg3K1MF/n3v0I8Sa9HVZa51Z/Y5NJYEL+sVxhTd2qS1ZjVAEpPuC3LzZvUDRC3bzNwNMVzS2NXqKfKMRo4ZrGs4KmHs6w+6Qk+OpQ2G54PHz+A3XYR9B47mQBX8B0VMEGd29I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709188972; c=relaxed/simple;
	bh=9olk6u2edKnH4Bi10jruA+8Gww18GBRcuJrmFqqHlUU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TZQ2vvGwcdeZdSm0rW+u+mqlf+M27thTq3o5npDheWcVsFOWqepNIJd3338c3t0A0viBp+xeKO7aTp4GE9/ANS/AruUdecgdPOQf8NNMT2WcF1R9fSpOztMBNNB9ewTNW2jeAkELj7iIJ8p0VGUzOePfvyc7lXBhcIRDQSfQ3TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hvFgn3kI; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709188970; x=1740724970;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9olk6u2edKnH4Bi10jruA+8Gww18GBRcuJrmFqqHlUU=;
  b=hvFgn3kIIAdeLRFreZe0YzLzJCU4ZeF7Q++ZsJAYgogFG6mdNsrc3Uvz
   HPM50+8bxmA8h68ZnI/g3nUmGzghMFg0cK6gL++OJV70vM775hhzGtXcC
   cPOe5DRIPkhfJihftXBraMACnmEHrTu2+8XAB5GCnQ27qW4lMrYy0rGhC
   LH3EW0RsEwMWB0pP0SpGL8trN06ewcoD3ZXkfRMffSOVjTYJdDZ+yJIlK
   d4wU7OScvwYy5YgXtJ2AcNEiURkBs3Fiv0PE2itYeuk2ESoC4LBBkrgeu
   O6fwbETpaGL88UmosKjI06Wn/REJUKv7uKLMmu0Yef1F7aHuSPDXdOfpL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3803086"
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="3803086"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2024 22:42:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,192,1705392000"; 
   d="scan'208";a="8076081"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa007.jf.intel.com with ESMTP; 28 Feb 2024 22:42:44 -0800
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
Subject: [PATCH v5 48/65] i386/tdx: handle TDG.VP.VMCALL<SetupEventNotifyInterrupt>
Date: Thu, 29 Feb 2024 01:37:09 -0500
Message-Id: <20240229063726.610065-49-xiaoyao.li@intel.com>
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

For SetupEventNotifyInterrupt, record interrupt vector and the apic id
of the vcpu that received this TDVMCALL.

Later it can inject interrupt with given vector to the specific vcpu
that received SetupEventNotifyInterrupt.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 target/i386/kvm/kvm.c      |  8 ++++++
 target/i386/kvm/tdx-stub.c |  5 ++++
 target/i386/kvm/tdx.c      | 53 ++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h      | 14 ++++++++++
 4 files changed, 80 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4f998b2d6d37..2748086231d5 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5413,6 +5413,14 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
         ret = kvm_xen_handle_exit(cpu, &run->xen);
         break;
 #endif
+    case KVM_EXIT_TDX:
+        if (!is_tdx_vm()) {
+            error_report("KVM: get KVM_EXIT_TDX for a non-TDX VM.");
+            ret = -1;
+            break;
+        }
+        ret = tdx_handle_exit(cpu, &run->tdx);
+        break;
     default:
         fprintf(stderr, "KVM: unknown exit reason %d\n", run->exit_reason);
         ret = -1;
diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
index a064d583d393..57cd25793842 100644
--- a/target/i386/kvm/tdx-stub.c
+++ b/target/i386/kvm/tdx-stub.c
@@ -11,3 +11,8 @@ int tdx_parse_tdvf(void *flash_ptr, int size)
 {
     return -EINVAL;
 }
+
+int tdx_handle_exit(X86CPU *cpu, struct kvm_tdx_exit *tdx_exit)
+{
+    return -EINVAL;
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index d445d4b70f77..49f94d9d46f4 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -866,6 +866,56 @@ int tdx_parse_tdvf(void *flash_ptr, int size)
     return tdvf_parse_metadata(&tdx_guest->tdvf, flash_ptr, size);
 }
 
+static int tdx_handle_setup_event_notify_interrupt(X86CPU *cpu,
+                                                   struct kvm_tdx_vmcall *vmcall)
+{
+    int vector = vmcall->in_r12;
+
+    if (32 <= vector && vector <= 255) {
+        qemu_mutex_lock(&tdx_guest->lock);
+        tdx_guest->event_notify_vector = vector;
+        tdx_guest->event_notify_apicid = cpu->apic_id;
+        qemu_mutex_unlock(&tdx_guest->lock);
+        vmcall->status_code = TDG_VP_VMCALL_SUCCESS;
+    } else {
+        vmcall->status_code = TDG_VP_VMCALL_INVALID_OPERAND;
+    }
+
+    return 0;
+}
+
+static int tdx_handle_vmcall(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
+{
+    vmcall->status_code = TDG_VP_VMCALL_INVALID_OPERAND;
+
+    /* For now handle only TDG.VP.VMCALL leaf defined in TDX GHCI */
+    if (vmcall->type != 0) {
+        error_report("Unknown TDG.VP.VMCALL type 0x%llx subfunction 0x%llx",
+                     vmcall->type, vmcall->subfunction);
+        return -1;
+    }
+
+    switch (vmcall->subfunction) {
+    case TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT:
+        return tdx_handle_setup_event_notify_interrupt(cpu, vmcall);
+    default:
+        error_report("Unknown TDG.VP.VMCALL type 0x%llx subfunction 0x%llx",
+                     vmcall->type, vmcall->subfunction);
+        return -1;
+    }
+}
+
+int tdx_handle_exit(X86CPU *cpu, struct kvm_tdx_exit *tdx_exit)
+{
+    switch (tdx_exit->type) {
+    case KVM_EXIT_TDX_VMCALL:
+        return tdx_handle_vmcall(cpu, &tdx_exit->u.vmcall);
+    default:
+        error_report("unknown tdx exit type 0x%x", tdx_exit->type);
+        return -1;
+    }
+}
+
 static bool tdx_guest_get_sept_ve_disable(Object *obj, Error **errp)
 {
     TdxGuest *tdx = TDX_GUEST(obj);
@@ -956,6 +1006,9 @@ static void tdx_guest_init(Object *obj)
     object_property_add_str(obj, "mrownerconfig",
                             tdx_guest_get_mrownerconfig,
                             tdx_guest_set_mrownerconfig);
+
+    tdx->event_notify_vector = -1;
+    tdx->event_notify_apicid = -1;
 }
 
 static void tdx_guest_finalize(Object *obj)
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 3fb4069268f6..b3d4462fe718 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -7,6 +7,7 @@
 
 #include "exec/confidential-guest-support.h"
 #include "hw/i386/tdvf.h"
+#include "sysemu/kvm.h"
 
 #define TYPE_TDX_GUEST "tdx-guest"
 #define TDX_GUEST(obj)  OBJECT_CHECK(TdxGuest, (obj), TYPE_TDX_GUEST)
@@ -15,6 +16,14 @@ typedef struct TdxGuestClass {
     ConfidentialGuestSupportClass parent_class;
 } TdxGuestClass;
 
+#define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT      0x10004ULL
+
+#define TDG_VP_VMCALL_SUCCESS           0x0000000000000000ULL
+#define TDG_VP_VMCALL_RETRY             0x0000000000000001ULL
+#define TDG_VP_VMCALL_INVALID_OPERAND   0x8000000000000000ULL
+#define TDG_VP_VMCALL_GPA_INUSE         0x8000000000000001ULL
+#define TDG_VP_VMCALL_ALIGN_ERROR       0x8000000000000002ULL
+
 enum TdxRamType{
     TDX_RAM_UNACCEPTED,
     TDX_RAM_ADDED,
@@ -42,6 +51,10 @@ typedef struct TdxGuest {
 
     uint32_t nr_ram_entries;
     TdxRamEntry *ram_entries;
+
+    /* runtime state */
+    uint32_t event_notify_vector;
+    uint32_t event_notify_apicid;
 } TdxGuest;
 
 #ifdef CONFIG_TDX
@@ -55,5 +68,6 @@ void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
 int tdx_pre_create_vcpu(CPUState *cpu, Error **errp);
 void tdx_set_tdvf_region(MemoryRegion *tdvf_mr);
 int tdx_parse_tdvf(void *flash_ptr, int size);
+int tdx_handle_exit(X86CPU *cpu, struct kvm_tdx_exit *tdx_exit);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1


