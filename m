Return-Path: <kvm+bounces-6951-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B513983B82A
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 04:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2EDD51F21717
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 03:33:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D9FC11CBF;
	Thu, 25 Jan 2024 03:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N8upi7Z1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F4E11C92
	for <kvm@vger.kernel.org>; Thu, 25 Jan 2024 03:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706153433; cv=none; b=Fih3SOtKNYBUi2QMYDlRKgDFskLzlGDjYIPhHQARUmNs1K8BfTWfdSoezN/4JduZ6gsCuvSZhBiwjD39XOg42V3sd1Iew99Fq+HISPCh06cXRnre7tN3EtzrgIueRgfO5ZDefuMnxC7xdfnpJXvx7lw9s8LeAmvf1Owpp1jlhP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706153433; c=relaxed/simple;
	bh=u9KMXUEQeXh0mI5sy6l0uCUlYOKP73JuhfrwPW/W4eo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=q01joREuePxnIfz0wOK4j4BJc5Zf2vHldzaruku+WJIBBXbYIq3EepObJZRyCZ9Wew1XdzlWzAImozIarUNz8kaFWZHWtmcCqLJHVoq1TfExEeC/X9Eby/y7Ct440q13YHMuB9myuMT/1oUagZizLmgcv00LMIZSp+NuUF/AFH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N8upi7Z1; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706153432; x=1737689432;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u9KMXUEQeXh0mI5sy6l0uCUlYOKP73JuhfrwPW/W4eo=;
  b=N8upi7Z1mbw5fgCkZuroFNzLbLiljAsR1mJcIuQgCgdoFR3cLJsYV/2I
   DIbDkUWqdC4HT2LdsqgFfaxtsn2ClCg/fqGhM2iLyR80LrK5wjplPCeoD
   gKDxnfZwK0jzH+t1txrDJV1bP2gzQnDyg8rT/W2zKctqB8qGqsSuSJWlR
   hDmum+RWP2t33svEifLb7dIBkjLKVPPSo6iXRlQXoSXh0t+0sUeTsOBTY
   WkVic5lJpjHL6SIdNjbdGnDTpY72xdFS60CH50Q5h7Eik26bObRD7n5wu
   BlvJ7/V02aPABv8/OQ1kKtgRj0b11VU3EWC22QYfV7SEfbrGEZk1Qox2z
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="9429957"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9429957"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 19:28:06 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2086106"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 24 Jan 2024 19:28:01 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=20=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	xiaoyao.li@intel.com,
	Michael Roth <michael.roth@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Claudio Fontana <cfontana@suse.de>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Isaku Yamahata <isaku.yamahata@gmail.com>,
	Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v4 49/66] i386/tdx: handle TDG.VP.VMCALL<SetupEventNotifyInterrupt>
Date: Wed, 24 Jan 2024 22:23:11 -0500
Message-Id: <20240125032328.2522472-50-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240125032328.2522472-1-xiaoyao.li@intel.com>
References: <20240125032328.2522472-1-xiaoyao.li@intel.com>
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
index 348f76a9cb81..e36ece874246 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5426,6 +5426,14 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
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
index 587dbeeed196..ffaf659bc9be 100644
--- a/target/i386/kvm/tdx-stub.c
+++ b/target/i386/kvm/tdx-stub.c
@@ -16,3 +16,8 @@ int tdx_parse_tdvf(void *flash_ptr, int size)
 {
     return -EINVAL;
 }
+
+int tdx_handle_exit(X86CPU *cpu, struct kvm_tdx_exit *tdx_exit)
+{
+    return -EINVAL;
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 69a697608219..602b5656d462 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -852,6 +852,56 @@ int tdx_parse_tdvf(void *flash_ptr, int size)
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
 static void tdx_guest_region_add(MemoryListener *listener,
                                  MemoryRegionSection *section)
 {
@@ -961,6 +1011,9 @@ static void tdx_guest_init(Object *obj)
     object_property_add_str(obj, "mrownerconfig",
                             tdx_guest_get_mrownerconfig,
                             tdx_guest_set_mrownerconfig);
+
+    tdx->event_notify_vector = -1;
+    tdx->event_notify_apicid = -1;
 }
 
 static void tdx_guest_finalize(Object *obj)
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 5fb20a5f06bb..992916e4c905 100644
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
@@ -56,5 +69,6 @@ void tdx_get_supported_cpuid(uint32_t function, uint32_t index, int reg,
 int tdx_pre_create_vcpu(CPUState *cpu, Error **errp);
 void tdx_set_tdvf_region(MemoryRegion *tdvf_region);
 int tdx_parse_tdvf(void *flash_ptr, int size);
+int tdx_handle_exit(X86CPU *cpu, struct kvm_tdx_exit *tdx_exit);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1


