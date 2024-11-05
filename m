Return-Path: <kvm+bounces-30639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 506DC9BC57C
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 07:37:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 752C41C2142A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 745011DB54C;
	Tue,  5 Nov 2024 06:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QfcUpqq7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133E01F16B
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 06:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730788604; cv=none; b=R7pbejagWLzk9bLHLD9WNyYGVyh26LXO61/1wEs5K/BbqQ+enWctfmQyiCjv8syuKCpCg3N7nVdtvbFEaIzM0XbVyByM6zfPUKKjKGFaN+lUsBed2Lc8jsuuNfmYm5m/3ujBoQssoomF6AyvdL4McYtt1d67BmwMEP+LqVHu7RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730788604; c=relaxed/simple;
	bh=0vj+lC4sTbpC830FiXMO0t8VM8X6DjsBEWbC13OZKiM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ca2I5Y8GvnzlMudtqM+UVHeJimBAlMS+TltECLAPoDmM+2/W5uGDOyoJynEHDfxgY4AG8a8dfQAgCcM2G6y1CjxEmgIg811oLi3TA/4HVQbgVAeJhxd7J3VhKL1TNuZ5IQbgUr3rpGM/MOt0KFvKX7WRpWOwnKd+I1o6stotCP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QfcUpqq7; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730788603; x=1762324603;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0vj+lC4sTbpC830FiXMO0t8VM8X6DjsBEWbC13OZKiM=;
  b=QfcUpqq7BYNtb3EkBCl08xVhDq+PBjH06xpupoY9/bds2xXvOSr47TNF
   pt16IN09iDs+kO/HL2jdGja+FpF4Gpoat3ZVoYlRNwVgItsi6wyDeHi+z
   jc1Ob+bVLQiIfm02RyXN0hlP+YTmLORGXtq62JkW+ivsHV1GZQwDrl9Mn
   JgU4SZwk1/uuKuLMxDCCoqYplXVSRLdLSfdINjKcOwZGX7u98bSpiomNi
   jx4nYlOSLb/UEyw3MO5AGwPJ0XocGyUOhgsa9f5mjZZZn9aqvwk/dFE0y
   Sw6BqNRhMTjaNzS+iyHx7/yzdun5hssKmBEvt40RbWb3fcoXYz9y8C5Wk
   g==;
X-CSE-ConnectionGUID: 4Fdr5HQgR9mZKvSMPg2z8g==
X-CSE-MsgGUID: HP0JiSxfR4yhtNkLJHP3Hw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="30689274"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="30689274"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 22:36:43 -0800
X-CSE-ConnectionGUID: 3W+DpMZgTHWMuO4ZzHvdzA==
X-CSE-MsgGUID: 6O5LboUeRWak91gSXFK5fQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="83988621"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by fmviesa009.fm.intel.com with ESMTP; 04 Nov 2024 22:36:39 -0800
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
Subject: [PATCH v6 05/60] i386/tdx: Get tdx_capabilities via KVM_TDX_CAPABILITIES
Date: Tue,  5 Nov 2024 01:23:13 -0500
Message-Id: <20241105062408.3533704-6-xiaoyao.li@intel.com>
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

KVM provides TDX capabilities via sub command KVM_TDX_CAPABILITIES of
IOCTL(KVM_MEMORY_ENCRYPT_OP). Get the capabilities when initializing
TDX context. It will be used to validate user's setting later.

Since there is no interface reporting how many cpuid configs contains in
KVM_TDX_CAPABILITIES, QEMU chooses to try starting with a known number
and abort when it exceeds KVM_MAX_CPUID_ENTRIES.

Besides, introduce the interfaces to invoke TDX "ioctls" at VCPU scope
in preparation.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
Changes in v6:
- Pass CPUState * to tdx_vcpu_ioctl();
- update commit message to remove platform scope thing;
- dump hw_error when it's non-zero to help debug;

Changes in v4:
- use {} to initialize struct kvm_tdx_cmd, to avoid memset();
- remove tdx_platform_ioctl() because no user;

Changes in v3:
- rename __tdx_ioctl() to tdx_ioctl_internal()
- Pass errp in get_tdx_capabilities();

changes in v2:
  - Make the error message more clear;

changes in v1:
  - start from nr_cpuid_configs = 6 for the loop;
  - stop the loop when nr_cpuid_configs exceeds KVM_MAX_CPUID_ENTRIES;
---
 target/i386/kvm/kvm.c      |  2 -
 target/i386/kvm/kvm_i386.h |  2 +
 target/i386/kvm/tdx.c      | 93 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 94 insertions(+), 3 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 2bbac603da70..b843de7f2379 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1782,8 +1782,6 @@ static int hyperv_init_vcpu(X86CPU *cpu)
 
 static Error *invtsc_mig_blocker;
 
-#define KVM_MAX_CPUID_ENTRIES  100
-
 static void kvm_init_xsave(CPUX86State *env)
 {
     if (has_xsave2) {
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 9de9c0d30388..7ac4c3a91171 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -13,6 +13,8 @@
 
 #include "sysemu/kvm.h"
 
+#define KVM_MAX_CPUID_ENTRIES  100
+
 #ifdef CONFIG_KVM
 
 #define kvm_pit_in_kernel() \
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 85f006c1d6b4..907044910fec 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -12,17 +12,108 @@
  */
 
 #include "qemu/osdep.h"
+#include "qemu/error-report.h"
+#include "qapi/error.h"
 #include "qom/object_interfaces.h"
 
 #include "hw/i386/x86.h"
 #include "kvm_i386.h"
 #include "tdx.h"
 
+static struct kvm_tdx_capabilities *tdx_caps;
+
+enum tdx_ioctl_level {
+    TDX_VM_IOCTL,
+    TDX_VCPU_IOCTL,
+};
+
+static int tdx_ioctl_internal(enum tdx_ioctl_level level, void *state,
+                              int cmd_id, __u32 flags, void *data)
+{
+    struct kvm_tdx_cmd tdx_cmd = {};
+    int r;
+
+    tdx_cmd.id = cmd_id;
+    tdx_cmd.flags = flags;
+    tdx_cmd.data = (__u64)(unsigned long)data;
+
+    switch (level) {
+    case TDX_VM_IOCTL:
+        r = kvm_vm_ioctl(kvm_state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+        break;
+    case TDX_VCPU_IOCTL:
+        r = kvm_vcpu_ioctl(state, KVM_MEMORY_ENCRYPT_OP, &tdx_cmd);
+        break;
+    default:
+        error_report("Invalid tdx_ioctl_level %d", level);
+        exit(1);
+    }
+
+    if (r && tdx_cmd.hw_error) {
+        error_report("TDX ioctl %d return with %d, hw_errors: 0x%llx",
+                     cmd_id, r, tdx_cmd.hw_error);
+    }
+    return r;
+}
+
+static inline int tdx_vm_ioctl(int cmd_id, __u32 flags, void *data)
+{
+    return tdx_ioctl_internal(TDX_VM_IOCTL, NULL, cmd_id, flags, data);
+}
+
+static inline int tdx_vcpu_ioctl(CPUState *cpu, int cmd_id, __u32 flags,
+                                 void *data)
+{
+    return  tdx_ioctl_internal(TDX_VCPU_IOCTL, cpu, cmd_id, flags, data);
+}
+
+static int get_tdx_capabilities(Error **errp)
+{
+    struct kvm_tdx_capabilities *caps;
+    /* 1st generation of TDX reports 6 cpuid configs */
+    int nr_cpuid_configs = 6;
+    size_t size;
+    int r;
+
+    do {
+        size = sizeof(struct kvm_tdx_capabilities) +
+                      nr_cpuid_configs * sizeof(struct kvm_cpuid_entry2);
+        caps = g_malloc0(size);
+        caps->cpuid.nent = nr_cpuid_configs;
+
+        r = tdx_vm_ioctl(KVM_TDX_CAPABILITIES, 0, caps);
+        if (r == -E2BIG) {
+            g_free(caps);
+            nr_cpuid_configs *= 2;
+            if (nr_cpuid_configs > KVM_MAX_CPUID_ENTRIES) {
+                error_setg(errp, "%s: KVM TDX seems broken that number of CPUID"
+                           " entries in kvm_tdx_capabilities exceeds limit %d",
+                           __func__, KVM_MAX_CPUID_ENTRIES);
+                return r;
+            }
+        } else if (r < 0) {
+            g_free(caps);
+            error_setg_errno(errp, -r, "%s: KVM_TDX_CAPABILITIES failed", __func__);
+            return r;
+        }
+    } while (r == -E2BIG);
+
+    tdx_caps = caps;
+
+    return 0;
+}
+
 static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
+    int r = 0;
+
     kvm_mark_guest_state_protected();
 
-    return 0;
+    if (!tdx_caps) {
+        r = get_tdx_capabilities(errp);
+    }
+
+    return r;
 }
 
 static int tdx_kvm_type(X86ConfidentialGuest *cg)
-- 
2.34.1


