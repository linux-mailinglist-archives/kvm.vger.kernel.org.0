Return-Path: <kvm+bounces-1782-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 413797EBDE3
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 08:22:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EF6C9281376
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 07:22:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90D49BA29;
	Wed, 15 Nov 2023 07:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jh43BsJ0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EBC0B670
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 07:22:41 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5971C9E
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 23:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700032960; x=1731568960;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XQvEk1+ah0pgpmFOmh/FSPSPEu7bLWQNERBsI+mWVMA=;
  b=Jh43BsJ0jB+LC7tP60w+00146bGkXy5kM/r7TcwDP37XLVD6NyhMPHNo
   fhbx4s6UJPVg07du/OX+FHsexQyONN7//euAy5SB+1TlxKCN+/GInZSC6
   LOgFEkonXV/9+6rL5YgzdPAk1ZIxDoUiN16BZPE288fZDGVeSfI+Eaeir
   i1lasXcG8Jf4Qgt2tTwQBmZhDrFhe/Qm2nEpmSvPagZc2ACOcXvJcsAtM
   CPn5P9uIiQD6XzwlNDibgo5kCwtFkP3/pEOqPozqjB8LIppA8ibPpHHw+
   no8la2xGN3Lhd0ohPkD/Ke8RHYHJvqcisTnnHHsZNF+sMY9inIHZf8/bZ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="390623472"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="390623472"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Nov 2023 23:22:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10894"; a="714800283"
X-IronPort-AV: E=Sophos;i="6.03,304,1694761200"; 
   d="scan'208";a="714800283"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orsmga003.jf.intel.com with ESMTP; 14 Nov 2023 23:22:34 -0800
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
Subject: [PATCH v3 54/70] i386/tdx: handle TDG.VP.VMCALL<MapGPA> hypercall
Date: Wed, 15 Nov 2023 02:15:03 -0500
Message-Id: <20231115071519.2864957-55-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231115071519.2864957-1-xiaoyao.li@intel.com>
References: <20231115071519.2864957-1-xiaoyao.li@intel.com>
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
 target/i386/kvm/tdx.c | 37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 89e7183a2738..65bc92265369 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2929,7 +2929,7 @@ static void kvm_eat_signals(CPUState *cpu)
     } while (sigismember(&chkset, SIG_IPI));
 }
 
-static int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
+int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
 {
     MemoryRegionSection section;
     ram_addr_t offset;
diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index 2f6592859ac6..e0061848b053 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -544,4 +544,6 @@ int kvm_create_guest_memfd(uint64_t size, uint64_t flags, Error **errp);
 
 int kvm_set_memory_attributes_private(hwaddr start, hwaddr size);
 int kvm_set_memory_attributes_shared(hwaddr start, hwaddr size);
+
+int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private);
 #endif
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 3b87c36c485e..b17258f17fd0 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -1001,6 +1001,7 @@ static void tdx_guest_class_init(ObjectClass *oc, void *data)
 {
 }
 
+#define TDG_VP_VMCALL_MAP_GPA                           0x10001ULL
 #define TDG_VP_VMCALL_GET_QUOTE                         0x10002ULL
 #define TDG_VP_VMCALL_SETUP_EVENT_NOTIFY_INTERRUPT      0x10004ULL
 
@@ -1060,6 +1061,39 @@ static hwaddr tdx_shared_bit(X86CPU *cpu)
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
@@ -1455,6 +1489,9 @@ static void tdx_handle_vmcall(X86CPU *cpu, struct kvm_tdx_vmcall *vmcall)
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


