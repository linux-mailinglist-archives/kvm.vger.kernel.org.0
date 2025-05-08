Return-Path: <kvm+bounces-45908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D7EE3AAFE4F
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 17:07:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BCDC77AC0EF
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:06:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA86427B4FC;
	Thu,  8 May 2025 15:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LJEfMe7B"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2706A27BF6D
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 15:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716710; cv=none; b=tb/V4+mQ2Utiv3HqtDvggHQ36EqWyGaf3ZhwtoTlMx4zz7K7qICMBUZ7LbaRDwfOBVJTarbhblu9o3zq+zmVKXCqstWCRoORlogXgPrXS0Eaj4EKlRogagLI3xfKcqEBGHnMz4MA2wqtl3ulIf+NKCZRB19R/+sVMbLdhVyTo3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716710; c=relaxed/simple;
	bh=6zjzxZ36ZpLCHxUaVNTeoqy3IP35XZo69poU2bBv4ZI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dBsUgL5RYAAa3qOpi/+d8NzXPhWSWzT1oPvOKFT7bOI6d9LhlOd/F7QVBtVE8fyk5yimS+VUspdh/Kur2PLAZ5YsbMBGVoimPJaU1qyhVOdErRUZenGB4Y/UXOQeOcCGTsO/g8MA7O9LqDomkX0eQ6lvUduLzp1MMJ5r4GltR3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LJEfMe7B; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746716709; x=1778252709;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6zjzxZ36ZpLCHxUaVNTeoqy3IP35XZo69poU2bBv4ZI=;
  b=LJEfMe7BBENWSfklVL6Xi2MQiviQFPCCjfsSA4XEqnz+RVkPn8g9lmCV
   E6zaZYKte4HtVcNIzGaUbZbMHozzXQoGOQn2baF3+ZVWaZT9EryVAqJWK
   h8+3jxcw8urOLcDlrpKV5lYlsCFhbD6gHRynJRRqbm5S4sMJHwIOlwu0/
   vC6PVmSBE37J/I8bQU4JhRXuqdmaUKbrErwkO3oVL151Omr/GRMEAcQen
   spxFm5quaQ9QxygzqBubjJ1pNMLsNbR0w1wsX7upIRmH+a/qqhlHUewQa
   R+roHSbFt6Vn816ZGxpjQV306Gh95TVyPGZlCAeNBUILwaD94skjQtLfb
   Q==;
X-CSE-ConnectionGUID: M7E3/ZXpTHiQW7IZAFmSDw==
X-CSE-MsgGUID: SN+ABuaST826C33aJJ1Elw==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="73888013"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="73888013"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:05:09 -0700
X-CSE-ConnectionGUID: O/oI6tobTZ6eweq2gxSJdQ==
X-CSE-MsgGUID: 8TS4X2uVRKmjAYa18PEBLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="141439797"
Received: from lxy-clx-4s.sh.intel.com ([10.239.48.52])
  by orviesa005.jf.intel.com with ESMTP; 08 May 2025 08:05:05 -0700
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
Subject: [PATCH v9 05/55] i386/tdx: Get tdx_capabilities via KVM_TDX_CAPABILITIES
Date: Thu,  8 May 2025 10:59:11 -0400
Message-ID: <20250508150002.689633-6-xiaoyao.li@intel.com>
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
Changes in v7:
- refine and unifiy the error handling; (Daniel)

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
 target/i386/kvm/kvm.c      |   2 -
 target/i386/kvm/kvm_i386.h |   2 +
 target/i386/kvm/tdx.c      | 107 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 108 insertions(+), 3 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 1af4710556ad..b4fa35405fe1 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -1779,8 +1779,6 @@ static int hyperv_init_vcpu(X86CPU *cpu)
 
 static Error *invtsc_mig_blocker;
 
-#define KVM_MAX_CPUID_ENTRIES  100
-
 static void kvm_init_xsave(CPUX86State *env)
 {
     if (has_xsave2) {
diff --git a/target/i386/kvm/kvm_i386.h b/target/i386/kvm/kvm_i386.h
index 88565e8dbac1..ed1e61fb8ba9 100644
--- a/target/i386/kvm/kvm_i386.h
+++ b/target/i386/kvm/kvm_i386.h
@@ -13,6 +13,8 @@
 
 #include "system/kvm.h"
 
+#define KVM_MAX_CPUID_ENTRIES  100
+
 /* always false if !CONFIG_KVM */
 #define kvm_pit_in_kernel() \
     (kvm_irqchip_in_kernel() && !kvm_irqchip_is_split())
diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 4ff94860815d..c67be5e618e2 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -10,17 +10,122 @@
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
+                              int cmd_id, __u32 flags, void *data,
+                              Error **errp)
+{
+    struct kvm_tdx_cmd tdx_cmd = {};
+    int r;
+
+    const char *tdx_ioctl_name[] = {
+        [KVM_TDX_CAPABILITIES] = "KVM_TDX_CAPABILITIES",
+        [KVM_TDX_INIT_VM] = "KVM_TDX_INIT_VM",
+        [KVM_TDX_INIT_VCPU] = "KVM_TDX_INIT_VCPU",
+        [KVM_TDX_INIT_MEM_REGION] = "KVM_TDX_INIT_MEM_REGION",
+        [KVM_TDX_FINALIZE_VM] = "KVM_TDX_FINALIZE_VM",
+        [KVM_TDX_GET_CPUID] = "KVM_TDX_GET_CPUID",
+    };
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
+        error_setg(errp, "Invalid tdx_ioctl_level %d", level);
+        return -EINVAL;
+    }
+
+    if (r < 0) {
+        error_setg_errno(errp, -r, "TDX ioctl %s failed, hw_errors: 0x%llx",
+                         tdx_ioctl_name[cmd_id], tdx_cmd.hw_error);
+    }
+    return r;
+}
+
+static inline int tdx_vm_ioctl(int cmd_id, __u32 flags, void *data,
+                               Error **errp)
+{
+    return tdx_ioctl_internal(TDX_VM_IOCTL, NULL, cmd_id, flags, data, errp);
+}
+
+static inline int tdx_vcpu_ioctl(CPUState *cpu, int cmd_id, __u32 flags,
+                                 void *data, Error **errp)
+{
+    return  tdx_ioctl_internal(TDX_VCPU_IOCTL, cpu, cmd_id, flags, data, errp);
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
+        Error *local_err = NULL;
+        size = sizeof(struct kvm_tdx_capabilities) +
+                      nr_cpuid_configs * sizeof(struct kvm_cpuid_entry2);
+        caps = g_malloc0(size);
+        caps->cpuid.nent = nr_cpuid_configs;
+
+        r = tdx_vm_ioctl(KVM_TDX_CAPABILITIES, 0, caps, &local_err);
+        if (r == -E2BIG) {
+            g_free(caps);
+            nr_cpuid_configs *= 2;
+            if (nr_cpuid_configs > KVM_MAX_CPUID_ENTRIES) {
+                error_report("KVM TDX seems broken that number of CPUID entries"
+                             " in kvm_tdx_capabilities exceeds limit: %d",
+                             KVM_MAX_CPUID_ENTRIES);
+                error_propagate(errp, local_err);
+                return r;
+            }
+            error_free(local_err);
+        } else if (r < 0) {
+            g_free(caps);
+            error_propagate(errp, local_err);
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
2.43.0


