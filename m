Return-Path: <kvm+bounces-72724-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qT9JGfh3qGk4uwAAu9opvQ
	(envelope-from <kvm+bounces-72724-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:20:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 098C220630A
	for <lists+kvm@lfdr.de>; Wed, 04 Mar 2026 19:20:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id C61993026B4B
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 18:15:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A4535F174;
	Wed,  4 Mar 2026 18:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lToz6EWD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670C13CB2C8
	for <kvm@vger.kernel.org>; Wed,  4 Mar 2026 18:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772648117; cv=none; b=t5v5lwvbYSofNgqxYJP5o4z/OI4MA82Qwklog2JimcQ2jt0V3zHheLVLpe9906qZ3t34mNT/p3eM3KGVjCoUlbXrYrLY2mU8qouOBmZoU5mGgwR5Au7PKOiJzexBenTdpbW4uLgNOCC7F944v14nZG8CRwDoyUZc380VD2rjWPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772648117; c=relaxed/simple;
	bh=X0RhNp4kFh3eTI5/C0Btaql1BvfL9t2YBq/nYxoIqMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AwGjOp27OA07eknRkbRSUn5g9zy22uLY2kKQydsCm8jEN3tvcFmlQa6CbR0g5ox+el/e2bBDBUlqV1dmOeXpbnRBurSsTZryW/TV9jw3hd2wm49ZyKu7garModhR1/Bc50hISiYvvgVvtMuBMAUP4cVl1/cvoraPYjh0HZfzgd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lToz6EWD; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772648115; x=1804184115;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=X0RhNp4kFh3eTI5/C0Btaql1BvfL9t2YBq/nYxoIqMY=;
  b=lToz6EWDnz0+zqDxu8DJExk1x8dLgMtMNFBgDqwGEiaIXbTKhkJQpuUD
   Nem8L9G6fPNhXFZpPYYvijjW5vng3nI/ZfkYWeJK3GZuUX7hne66ip8Uc
   CWMD/FAK/o8MOp6rxOO6GpVwNE7lC9zguv11NzJLJjGxgK3rIZiD/FRpO
   UEmt0Hb1rNgOBuamQzMOX5pnxiTMlC49nq/9by/3KOnv4KBg9y+HKf2PR
   yZa6I9fGVhoj7eIt9p0J2BxlZWI2NCJxI06lXppBvTe/466iP7M1C+kLq
   zx70FDx8X5Z+/CSRlqb8/QBQy+t/+yL+jwzLfg5zikYJ4UFHqZARFw0vq
   A==;
X-CSE-ConnectionGUID: Ho62kFKBSamtDWqxfSJTqg==
X-CSE-MsgGUID: qimvD0ldTvaQ3gVDErFL+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73909324"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73909324"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:15 -0800
X-CSE-ConnectionGUID: 3kSr4sIlSxGMip9pgPb8jg==
X-CSE-MsgGUID: 7WJ63Z9eQkepkTpA1uHA1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="214542808"
Received: from 9cc2c43eec6b.jf.intel.com ([10.54.77.43])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 10:15:14 -0800
From: Zide Chen <zide.chen@intel.com>
To: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Sandipan Das <sandipan.das@amd.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>,
	Dongli Zhang <dongli.zhang@oracle.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH V3 06/13] target/i386: Increase MSR_BUF_SIZE and split KVM_[GET/SET]_MSRS calls
Date: Wed,  4 Mar 2026 10:07:05 -0800
Message-ID: <20260304180713.360471-7-zide.chen@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260304180713.360471-1-zide.chen@intel.com>
References: <20260304180713.360471-1-zide.chen@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 098C220630A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72724-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zide.chen@intel.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[intel.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid]
X-Rspamd-Action: no action

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
v3:
- Address Dapeng's comments.
---
 target/i386/kvm/kvm.c | 110 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 92 insertions(+), 18 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 39a67c58ac22..4ba54151320f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -97,9 +97,12 @@
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
@@ -4016,21 +4019,99 @@ static void kvm_msr_entry_add_perf(X86CPU *cpu, FeatureWordArray f)
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
-    return 0;
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
+static inline int kvm_buf_set_msrs(X86CPU *cpu)
+{
+    return kvm_buf_set_or_get_msrs(cpu, true);
+}
+
+static inline int kvm_buf_get_msrs(X86CPU *cpu)
+{
+    return kvm_buf_set_or_get_msrs(cpu, false);
 }
 
 static void kvm_init_msrs(X86CPU *cpu)
@@ -4066,7 +4147,7 @@ static void kvm_init_msrs(X86CPU *cpu)
     if (has_msr_ucode_rev) {
         kvm_msr_entry_add(cpu, MSR_IA32_UCODE_REV, cpu->ucode_rev);
     }
-    assert(kvm_buf_set_msrs(cpu) == 0);
+    kvm_buf_set_msrs(cpu);
 }
 
 static int kvm_put_msrs(X86CPU *cpu, KvmPutState level)
@@ -4959,18 +5040,11 @@ static int kvm_get_msrs(X86CPU *cpu)
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
2.53.0


