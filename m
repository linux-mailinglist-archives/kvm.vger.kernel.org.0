Return-Path: <kvm+bounces-30663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DCE89BC5A1
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:39:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 914241C20B65
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B411FEFC2;
	Tue,  5 Nov 2024 06:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IaC2yiIM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E3B1FCF71
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788709; cv=none; b=ljQAH8WAVRhyY/+MhjCG6PXC/ThNjjJ7o5AGHYMWVVqzBQOzB010hM4EnFe/0awZBqZOiN7HJr9FhB9rgQ+S5DjB+21dvfCjKS4cOE6XkJepPxTE2jgYemSTxwyXGPQvL3JyAUS8J/EyEz1hDHGJLnl2TLtKVJGeXAn1EXCNJxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788709; c=relaxed/simple;
	bh=hTO3AoGf1nt//dmP+tTmzwZEz/P9eM+x0h2usNJWysY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sgT86NbS0nr42ROMvofwOWWAQQUKNCB0dc2JKapUIAd/UO20F78FYyfNkqBsnm9IludYByhhXpKVqwUvh1naDfrA7NyioQLNPJHJYxMSh2JIPHYWGp/86EbHlgzU7hWArtY8giT78czq1HeZnRIO7y7qV3EC1K9YG4Hbo+Kc1Bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IaC2yiIM; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788708; x=1762324708;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hTO3AoGf1nt//dmP+tTmzwZEz/P9eM+x0h2usNJWysY=;
  b=IaC2yiIM4D/To+hIxfY8Pj3bCHo0xgMdJ+9KAsph4m4O3/DWaF9xdlMS
   QBAbi73OBY04FubFH0tkV5a0CDXN0K4fleRj3FUvmjPKnII2Ym4gO265x
   7xMq1avRn2rFkxpg2otN52A85tqwiJLtSdZJQXZ6NNMgMtvN8VxXtE02t
   Ek/hZO2t0HCrBb6qdreKCSN6tJVjdLHlCfiW/lP9MRRTdO/60+p2uRZPg
   rmUxtKInJKd1eMb5KuKYJ3T7q5MdkSMebUyZQzUO3ASiqfQyhTpPymvE3
   9LJnkkPXKKjoEx94FNn480Re6fBm5xrf1lLNaRVtKru9LwlL0KrDPq4j9
   w==;
X-CSE-ConnectionGUID: VjMS+1XxS22psOaqXA6I9A==
X-CSE-MsgGUID: QvCtgYofRtaQYvXgNDWnZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689636"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689636"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:38:27 -0800
X-CSE-ConnectionGUID: 6+S6bBOERHqqKH31mEtJoA==
X-CSE-MsgGUID: 0k0dK/97R56/U3RTPqjZig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83989108"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:38:23 -0800
From: Xiaoyao Li <xiaoyao.li@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Cornelia Huck <cohuck@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	rick.p.edgecombe@intel.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org,
	xiaoyao.li@intel.com
Subject: [PATCH v6 29/60] i386/tdx: Handle KVM_SYSTEM_EVENT_TDX_FATAL
Date: Tue,  5 Nov 2024 01:23:37 -0500
Message-Id: <20241105062408.3533704-30-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241105062408.3533704-1-xiaoyao.li@intel.com>
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
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
---
Changes in v6:
 - replace the patch " i386/tdx: Handle TDG.VP.VMCALL<REPORT_FATAL_ERROR>"
   in v5;
---
 target/i386/kvm/kvm.c      | 10 ++++++++++
 target/i386/kvm/tdx-stub.c |  5 +++++
 target/i386/kvm/tdx.c      | 24 ++++++++++++++++++++++++
 target/i386/kvm/tdx.h      |  2 ++
 4 files changed, 41 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 4fafc003e9a7..dea0f83370d5 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -6116,6 +6116,16 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
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
index a064d583d393..b5cb6d56c46a 100644
--- a/target/i386/kvm/tdx-stub.c
+++ b/target/i386/kvm/tdx-stub.c
@@ -11,3 +11,8 @@ int tdx_parse_tdvf(void *flash_ptr, int size)
 {
     return -EINVAL;
 }
+
+int tdx_handle_report_fatal_error(X86CPU *cpu, struct kvm_run *run)
+{
+    return -EINVAL;
+}
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index b34707e93f4d..3f44dfbf6585 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -574,6 +574,30 @@ int tdx_parse_tdvf(void *flash_ptr, int size)
     return tdvf_parse_metadata(&tdx_guest->tdvf, flash_ptr, size);
 }
 
+int tdx_handle_report_fatal_error(X86CPU *cpu, struct kvm_run *run)
+{
+    uint64_t error_code = run->system_event.data[0];
+    char *message = NULL;
+
+    if (error_code & 0xffff) {
+        error_report("TDX: REPORT_FATAL_ERROR: invalid error code: 0x%lx",
+                     error_code);
+        return -1;
+    }
+
+    /* It has optional message */
+    if (run->system_event.data[2]) {
+#define TDX_FATAL_MESSAGE_MAX        64
+        message = g_malloc0(TDX_FATAL_MESSAGE_MAX + 1);
+
+        memcpy(message, &run->system_event.data[2], TDX_FATAL_MESSAGE_MAX);
+        message[TDX_FATAL_MESSAGE_MAX] = '\0';
+    }
+
+    error_report("TD guest reports fatal error. %s", message ? : "");
+    return -1;
+}
+
 static bool tdx_guest_get_sept_ve_disable(Object *obj, Error **errp)
 {
     TdxGuest *tdx = TDX_GUEST(obj);
diff --git a/target/i386/kvm/tdx.h b/target/i386/kvm/tdx.h
index c669e0d0daca..7222a5d31359 100644
--- a/target/i386/kvm/tdx.h
+++ b/target/i386/kvm/tdx.h
@@ -6,6 +6,7 @@
 #endif
 
 #include "confidential-guest.h"
+#include "cpu.h"
 #include "hw/i386/tdvf.h"
 
 #define TYPE_TDX_GUEST "tdx-guest"
@@ -57,5 +58,6 @@ bool is_tdx_vm(void);
 int tdx_pre_create_vcpu(CPUState *cpu, Error **errp);
 void tdx_set_tdvf_region(MemoryRegion *tdvf_mr);
 int tdx_parse_tdvf(void *flash_ptr, int size);
+int tdx_handle_report_fatal_error(X86CPU *cpu, struct kvm_run *run);
 
 #endif /* QEMU_I386_TDX_H */
-- 
2.34.1


