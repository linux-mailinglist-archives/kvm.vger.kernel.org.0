Return-Path: <kvm+bounces-68430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 130F0D38B20
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 02:19:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 6B4893024A2E
	for <lists+kvm@lfdr.de>; Sat, 17 Jan 2026 01:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E13123AB8D;
	Sat, 17 Jan 2026 01:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VG4nHrGZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CE8230BDB
	for <kvm@vger.kernel.org>; Sat, 17 Jan 2026 01:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768612693; cv=none; b=ctdbETMWtJXWMwjybyXyAT8cDHRRAvkiOtl2ViOgl7sZfOqPX2jLXwUSh9vteZy3NBihiL3IVTE2700QihVyKmVChy0ZwiZLWJDrl79EG/w+BklVt8vXdhL+ocx3ryT/kqXaKJ0Lct+K8emKs92xNq8UWmkbyMiwyKU5fapZz7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768612693; c=relaxed/simple;
	bh=vEIyTu/kBF1eBSOMPe+vyM/W3HEARflxO8H2okHBMss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BL90UloZ4EP+pA3v2l3IHAk9KWLOExB8sgFOgYua+ZxvAO1ulYufoMxT5Epb9/CfRnB2s2It6HQiddxLx18fS8OhaH4TM0rT7I7N7GQKkgcBMsw1dXKAbYa8K7TyusJE1klRDIsmeDMLri5Xqhv//GBhFQhiF+jvVwlWtWkTVgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VG4nHrGZ; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768612692; x=1800148692;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vEIyTu/kBF1eBSOMPe+vyM/W3HEARflxO8H2okHBMss=;
  b=VG4nHrGZZOje/58+JA6Zs+x9lRngDp/8W95qH1fgO+CIUIkUf9icaAXG
   hKRixOrUmogdmUSDkX+9X7Fgfs3DC22WoR5b04+o2YBLtUqg00cPRi+gJ
   BMv7ZMMz91f3xonCOYTm6OLZfDs0kQeNqYzh3Gm6rj2zSz33Hvkq/ZwyG
   Md/uwf2D/9iW/Xv/aRec9/o3tqw0Cv9HJ+04hlp0d3NFT2fjeAecKoe4e
   dPjP8H1sBS2CMWrxoL1D/tS9Pc+/ZLtw0z/F7p6PoNySqTcpcB5CHXqlz
   GDEVPNZtx3STXgS6ebNd6sISeSkc88Y4iL9kUoxNirlYVEWjWnVOqjbsL
   A==;
X-CSE-ConnectionGUID: rdwJ7mKHSXCW2r7DUcJVHQ==
X-CSE-MsgGUID: dsMyLhJhQJqxn5ZHZRuUSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="69131176"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="69131176"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:18:09 -0800
X-CSE-ConnectionGUID: BuQ5J8yQQzOdwChrgS8B7A==
X-CSE-MsgGUID: UnawozAMSbyGCXagXYsYAQ==
X-ExtLoop1: 1
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:18:09 -0800
From: Zide Chen <zide.chen@intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>
Cc: xiaoyao.li@intel.com,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH 7/7] target/i386: Increase MSR_BUF_SIZE and split KVM_[GET/SET]_MSRS calls
Date: Fri, 16 Jan 2026 17:10:53 -0800
Message-ID: <20260117011053.80723-8-zide.chen@intel.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260117011053.80723-1-zide.chen@intel.com>
References: <20260117011053.80723-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Newer Intel server CPUs support a large number of PMU MSRs.  Currently,
QEMU allocates cpu->kvm_msr_buf as a single-page buffer, which is not
sufficient to hold all possible MSRs.

Increase MSR_BUF_SIZE to 8192 bytes, providing space for up to 511 MSRs.
This is sufficient even for the theoretical worst case, such as
architectural LBR with a depth of 64.

KVM_[GET/SET]_MSRS is limited to 255 MSRs per call.  Raising this limit
to 511 would require changes in KVM and would introduce backward
compatibility issues.  Instead, split requests into multiple
KVM_[GET/SET]_MSRS calls when the number of MSRs exceeds the API limit.

Signed-off-by: Zide Chen <zide.chen@intel.com>
---
 target/i386/kvm/kvm.c | 109 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 92 insertions(+), 17 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 80974114a173..a72e4d60dfa2 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -98,9 +98,12 @@
 #define KVM_APIC_BUS_CYCLE_NS       1
 #define KVM_APIC_BUS_FREQUENCY      (1000000000ULL / KVM_APIC_BUS_CYCLE_NS)
 
-/* A 4096-byte buffer can hold the 8-byte kvm_msrs header, plus
- * 255 kvm_msr_entry structs */
-#define MSR_BUF_SIZE 4096
+/* A 8192-byte buffer can hold the 8-byte kvm_msrs header, plus
+ * 511 kvm_msr_entry structs */
+#define MSR_BUF_SIZE      8192
+
+/* Maximum number of MSRs in one single KVM_[GET/SET]_MSRS call. */
+#define KVM_MAX_IO_MSRS   255
 
 typedef bool QEMURDMSRHandler(X86CPU *cpu, uint32_t msr, uint64_t *val);
 typedef bool QEMUWRMSRHandler(X86CPU *cpu, uint32_t msr, uint64_t val);
@@ -3878,23 +3881,102 @@ static void kvm_msr_entry_add_perf(X86CPU *cpu, FeatureWordArray f)
     }
 }
 
-static int kvm_buf_set_msrs(X86CPU *cpu)
+static int __kvm_buf_set_msrs(X86CPU *cpu, struct kvm_msrs *msrs)
 {
-    int ret = kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MSRS, cpu->kvm_msr_buf);
+    int ret = kvm_vcpu_ioctl(CPU(cpu), KVM_SET_MSRS, msrs);
     if (ret < 0) {
         return ret;
     }
 
-    if (ret < cpu->kvm_msr_buf->nmsrs) {
-        struct kvm_msr_entry *e = &cpu->kvm_msr_buf->entries[ret];
+    if (ret < msrs->nmsrs) {
+        struct kvm_msr_entry *e = &msrs->entries[ret];
         error_report("error: failed to set MSR 0x%" PRIx32 " to 0x%" PRIx64,
                      (uint32_t)e->index, (uint64_t)e->data);
     }
 
-    assert(ret == cpu->kvm_msr_buf->nmsrs);
+    assert(ret == msrs->nmsrs);
+    return ret;
+}
+
+static int __kvm_buf_get_msrs(X86CPU *cpu, struct kvm_msrs *msrs)
+{
+    int ret;
+
+    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, msrs);
+    if (ret < 0) {
+        return ret;
+    }
+
+    if (ret < msrs->nmsrs) {
+        struct kvm_msr_entry *e = &msrs->entries[ret];
+        error_report("error: failed to get MSR 0x%" PRIx32,
+                     (uint32_t)e->index);
+    }
+
+    assert(ret == msrs->nmsrs);
+    return ret;
+}
+
+static int kvm_buf_set_or_get_msrs(X86CPU *cpu, bool is_write)
+{
+    struct kvm_msr_entry *entries = cpu->kvm_msr_buf->entries;
+    struct kvm_msrs *buf = NULL;
+    int current, remaining, ret = 0;
+    size_t buf_size;
+
+    buf_size = KVM_MAX_IO_MSRS * sizeof(struct kvm_msr_entry) +
+               sizeof(struct kvm_msrs);
+    buf = g_malloc(buf_size);
+
+    remaining = cpu->kvm_msr_buf->nmsrs;
+    current = 0;
+    while (remaining) {
+        size_t size;
+
+        memset(buf, 0, buf_size);
+
+        if (remaining > KVM_MAX_IO_MSRS) {
+            buf->nmsrs = KVM_MAX_IO_MSRS;
+        } else {
+            buf->nmsrs = remaining;
+        }
+
+        size = buf->nmsrs * sizeof(entries[0]);
+        memcpy(buf->entries, &entries[current], size);
+
+        if (is_write) {
+            ret = __kvm_buf_set_msrs(cpu, buf);
+        } else {
+            ret = __kvm_buf_get_msrs(cpu, buf);
+        }
+
+        if (ret < 0) {
+            goto out;
+        }
+
+        if (!is_write)
+            memcpy(&entries[current], buf->entries, size);
+
+        current += buf->nmsrs;
+        remaining -= buf->nmsrs;
+    }
+
+out:
+    g_free(buf);
+    return ret < 0 ? ret : cpu->kvm_msr_buf->nmsrs;
+}
+
+static int kvm_buf_set_msrs(X86CPU *cpu)
+{
+    kvm_buf_set_or_get_msrs(cpu, true);
     return 0;
 }
 
+static int kvm_buf_get_msrs(X86CPU *cpu)
+{
+    return kvm_buf_set_or_get_msrs(cpu, false);
+}
+
 static void kvm_init_msrs(X86CPU *cpu)
 {
     CPUX86State *env = &cpu->env;
@@ -3928,7 +4010,7 @@ static void kvm_init_msrs(X86CPU *cpu)
     if (has_msr_ucode_rev) {
         kvm_msr_entry_add(cpu, MSR_IA32_UCODE_REV, cpu->ucode_rev);
     }
-    assert(kvm_buf_set_msrs(cpu) == 0);
+    kvm_buf_set_msrs(cpu);
 }
 
 static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
@@ -4762,18 +4844,11 @@ static int kvm_get_msrs(X86CPU *cpu)
         }
     }
 
-    ret = kvm_vcpu_ioctl(CPU(cpu), KVM_GET_MSRS, cpu->kvm_msr_buf);
+    ret = kvm_buf_get_msrs(cpu);
     if (ret < 0) {
         return ret;
     }
 
-    if (ret < cpu->kvm_msr_buf->nmsrs) {
-        struct kvm_msr_entry *e = &cpu->kvm_msr_buf->entries[ret];
-        error_report("error: failed to get MSR 0x%" PRIx32,
-                     (uint32_t)e->index);
-    }
-
-    assert(ret == cpu->kvm_msr_buf->nmsrs);
     /*
      * MTRR masks: Each mask consists of 5 parts
      * a  10..0: must be zero
-- 
2.52.0


