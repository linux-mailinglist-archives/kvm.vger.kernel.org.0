Return-Path: <kvm+bounces-45931-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C8C5AAAFE82
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:11:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9C12B98059E
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:09:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F8B27A475;
	Thu,  8 May 2025 15:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E3ysYxWH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092351A239F
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716783; cv=none; b=pvsshjCsjmCPGvgQ+ZrCbBBKoHYbyDDjeJj+cs6ackKkhtx9d1JjuO/gOOa8nbdl38rqYPnGnpSId8vSyktQP4bFeKD76ObQatE7neSKzkS21FAjoL9CTUQnEKEjLKBY3CCIRTbPO25RPGg3pRBlL+UEpxnzxaWsIPaPp18vAPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716783; c=relaxed/simple;
	bh=ULaUPFgAxDsLHz3qW1U4r8DmCBmHXlIyTtbwtrVIr8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T20/hLmB4/0DdHebmm7BBIbirWOaRhJrXI6XncEsAa1QOOOUV3y0NNj2xEGKJ6ZOrvuVNq3qcwJ8rrRu2Jdb4+uZDwxYdMhjv/J+R7JsfKtO4DBA6SunEOIXkPPRKYPhWRrSGCUn84AUqsIHEB5oAXPTKvN5ndI/aoXN1CL8Z0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E3ysYxWH; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716782; x=1778252782;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ULaUPFgAxDsLHz3qW1U4r8DmCBmHXlIyTtbwtrVIr8k=;
  b=E3ysYxWHwr1zCg0HOtGfz+mRM98Y521c4so+JhQiTUG3KPZ6CdkGIn+4
   bFQSwYa4vP/c4Rqq7a9Ippj7lYA39nsnoWyKB7ZmVYYfMZ7kqDVQTVWy5
   tYw2xO8q6hybQgkYyEY/JEC/gfzEc5mIUm2Y1Xxr2eZTnktFthSUa40QG
   dUgXGHyVxqefRlfbp0Xf9Gc3xpOrIGbjPudkXc5Bfyh4zCCVdBArBa4eu
   MjfnSRLp73TQb9+p+hvqzDB9fGU1MWpT7Awz7U1+l5omhmNNS4VNBU739
   C4KWnIvkuJSC6/zEeUeruXVi2dh5Z7uHb9zoxDmvDTavPtZWTPoaFHpwE
   w==;
X-CSE-ConnectionGUID: WXbuQB4ZT2Cg9PqSfd2QCA==
X-CSE-MsgGUID: DIB637MnT/Wu6CscJ/O4Cg==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888236"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888236"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:06:22 -0700
X-CSE-ConnectionGUID: RcgWsWjHTY6PVf70nf2rpw==
X-CSE-MsgGUID: Rsm7gqm0SCWp6suZb7Dugw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141440097"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:06:18 -0700
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Francesco Lavra <francescolavra.fl@gmail.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 28/55] i386/tdx: Handle KVM_SYSTEM_EVENT_TDX_FATAL
Date: Thu,  8 May 2025 10:59:34 -0400
Message-ID: <20250508150002.689633-29-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250508150002.689633-1-xiaoyao.li@intel.com>
References: <20250508150002.689633-1-xiaoyao.li@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

TD guest can use TDG.VP.VMCALL<REPORT_FATAL_ERROR> to request
termination. KVM translates such request into KVM_EXIT_SYSTEM_EVENT with
type of KVM_SYSTEM_EVENT_TDX_FATAL.

Add hanlder for such exit. Parse and print the error message, and
terminate the TD guest in the handler.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
---
Changes in v9:
 - Move the definition of MACRO TDX_FATAL_MESSAGE_MAX out of the
   function; (Zhao Liu)

Changes in v8:
 - update to the new data ABI of KVM_SYSTEM_EVENT_TDX_FATAL;

Changes in v6:
 - replace the patch " i386/tdx: Handle TDG.VP.VMCALL<REPORT_FATAL_ERROR>"
   in v5;
---
 target/i386/kvm/kvm.c      | 10 +++++++++
 target/i386/kvm/tdx-stub.c |  5 +++++
 target/i386/kvm/tdx.c      | 46 ++++++++++++++++++++++++++++++++++++++
 target/i386/kvm/tdx.h      |  2 ++
 4 files changed, 63 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 7de5014051eb..a76f34537908 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -6128,6 +6128,16 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
     case KVM_EXIT_HYPERCALL:
         ret = kvm_handle_hypercall(run);
         break;
+    case KVM_EXIT_SYSTEM_EVENT:
+        switch (run->system_event.type) {
+        case KVM_SYSTEM_EVENT_TDX_FATAL:
+            ret = tdx_handle_report_fatal_error(cpu, run);
+            break;
+        default:
+            ret = -1;
+            break;
+        }
+        break;
     default:
         fprintf(stderr, "KVM: unknown exit reason %d\n", run->exit_reason);
         ret = -1;
diff --git a/target/i386/kvm/tdx-stub.c b/target/i386/kvm/tdx-stub.c
index 7748b6d0a446..720a4ff046ee 100644
--- a/target/i386/kvm/tdx-stub.c
+++ b/target/i386/kvm/tdx-stub.c
@@ -13,3 +13,8 @@ int tdx_parse_tdvf(void *flash_ptr, int size)
 {
     return -EINVAL;
 }
+
+int tdx_handle_report_fatal_error(X86CPU *cpu, struct kvm_run *run)
+{
+    return -EINVAL;
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 0a6db6095e3e..5a140e88eb92 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -622,6 +622,52 @@ int tdx_parse_tdvf(void *flash_ptr, int size)
     return tdvf_parse_metadata(&tdx_guest->tdvf, flash_ptr, size);
 }
 
+/*
+ * Only 8 registers can contain valid ASCII byte stream to form the fatal
+ * message, and their sequence is: R14, R15, RBX, RDI, RSI, R8, R9, RDX
+ */
+#define TDX_FATAL_MESSAGE_MAX        64
+
+int tdx_handle_report_fatal_error(X86CPU *cpu, struct kvm_run *run)
+{
+    uint64_t error_code = run->system_event.data[R_R12];
+    uint64_t reg_mask = run->system_event.data[R_ECX];
+    char *message = NULL;
+    uint64_t *tmp;
+
+    if (error_code & 0xffff) {
+        error_report("TDX: REPORT_FATAL_ERROR: invalid error code: 0x%lx",
+                     error_code);
+        return -1;
+    }
+
+    if (reg_mask) {
+        message = g_malloc0(TDX_FATAL_MESSAGE_MAX + 1);
+        tmp = (uint64_t *)message;
+
+#define COPY_REG(REG)                               \
+    do {                                            \
+        if (reg_mask & BIT_ULL(REG)) {              \
+            *(tmp++) = run->system_event.data[REG]; \
+        }                                           \
+    } while (0)
+
+        COPY_REG(R_R14);
+        COPY_REG(R_R15);
+        COPY_REG(R_EBX);
+        COPY_REG(R_EDI);
+        COPY_REG(R_ESI);
+        COPY_REG(R_R8);
+        COPY_REG(R_R9);
+        COPY_REG(R_EDX);
+        *((char *)tmp) = '\0';
+    }
+#undef COPY_REG
+
+    error_report("TD guest reports fatal error. %s", message ? : "");
+    return -1;
+}
+
 static bool tdx_guest_get_sept_ve_disable(Object *obj, Error **errp)
 {
     TdxGuest *tdx = TDX_GUEST(obj);
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index 36a7400e7480..04b5afe199f9 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -8,6 +8,7 @@
 #endif
 
 #include "confidential-guest.h"
+#include "cpu.h"
 #include "hw/i386/tdvf.h"
 
 #define TYPE_TDX_GUEST "tdx-guest"
@@ -59,5 +60,6 @@ bool is_tdx_vm(void);
 int tdx_pre_create_vcpu(CPUState *cpu, Error **errp);
 void tdx_set_tdvf_region(MemoryRegion *tdvf_mr);
 int tdx_parse_tdvf(void *flash_ptr, int size);
+int tdx_handle_report_fatal_error(X86CPU *cpu, struct kvm_run *run);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.43.0


