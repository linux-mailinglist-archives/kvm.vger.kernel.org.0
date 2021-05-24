Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E33938F408
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 22:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233122AbhEXUDQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 16:03:16 -0400
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:27263 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbhEXUDQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 16:03:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1621886508; x=1653422508;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=xpGv7I/JVbWk3gCMlwhBWH3s3VAIfzbRaEG/9eDRB2o=;
  b=Ba/L+qNyQbscZNbkksQWky5fW4FX2HUtuSCq35nDjZ0BdJELwBy1W4NP
   7SWTSQjWpxQ0E9paeBp67OgMDA5AjizEz9vMuvvJHedqZDnUGIXdTxcsb
   LajK1kDi+zkJ85LKsmK5II+gdrKW1Of3U9t0IUuFrMOD6alnlPFncM2vt
   Q=;
X-IronPort-AV: E=Sophos;i="5.82,325,1613433600"; 
   d="scan'208";a="934796182"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-1e-c7f73527.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP; 24 May 2021 20:01:47 +0000
Received: from EX13D28EUC003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-c7f73527.us-east-1.amazon.com (Postfix) with ESMTPS id 1C54EA06B4;
        Mon, 24 May 2021 20:01:45 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.160.110) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 24 May 2021 20:01:41 +0000
From:   Siddharth Chandrasekaran <sidcha@amazon.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
CC:     Siddharth Chandrasekaran <sidcha@amazon.de>,
        Siddharth Chandrasekaran <sidcha.dev@gmail.com>,
        Alexander Graf <graf@amazon.com>,
        Evgeny Iakovlev <eyakovl@amazon.de>,
        Liran Alon <liran@amazon.com>,
        Ioannis Aslanidis <iaslan@amazon.de>, <qemu-devel@nongnu.org>,
        <kvm@vger.kernel.org>
Subject: [PATCH 5/6] kvm/i386: Add support for user space MSR filtering
Date:   Mon, 24 May 2021 22:01:20 +0200
Message-ID: <4c7ecaab0295e8420ee03baf37c7722e01bb81ce.1621885749.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1621885749.git.sidcha@amazon.de>
References: <cover.1621885749.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.160.110]
X-ClientProxiedBy: EX13D22UWC001.ant.amazon.com (10.43.162.192) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check and enable user space MSR filtering capability and handle new exit
reason KVM_EXIT_X86_WRMSR. This will be used in a follow up patch to
implement hyper-v overlay pages.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 target/i386/kvm/kvm.c | 72 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 72 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 362f04ab3f..3591f8cecc 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -117,6 +117,8 @@ static bool has_msr_ucode_rev;
 static bool has_msr_vmx_procbased_ctls2;
 static bool has_msr_perf_capabs;
 static bool has_msr_pkrs;
+static bool has_msr_filtering;
+static bool msr_filters_active;
 
 static uint32_t has_architectural_pmu_version;
 static uint32_t num_architectural_pmu_gp_counters;
@@ -2138,6 +2140,57 @@ static void register_smram_listener(Notifier *n, void *unused)
                                  &smram_address_space, 1);
 }
 
+static void kvm_set_msr_filter_range(struct kvm_msr_filter_range *range, uint32_t flags,
+                                     uint32_t base, uint32_t nmsrs, ...)
+{
+    int i, filter_to_userspace;
+    va_list ap;
+
+    range->flags = flags;
+    range->nmsrs = nmsrs;
+    range->base = base;
+
+    va_start(ap, nmsrs);
+    for (i = 0; i < nmsrs; i++) {
+        filter_to_userspace = va_arg(ap, int);
+        if (!filter_to_userspace) {
+            range->bitmap[i / 8] = 1 << (i % 8);
+        }
+    }
+    va_end(ap);
+}
+
+static int kvm_set_msr_filters(KVMState *s)
+{
+    int r, nmsrs, nfilt = 0, bitmap_pos = 0;
+    struct kvm_msr_filter filter = { };
+    struct kvm_msr_filter_range *range;
+    uint8_t bitmap_buf[KVM_MSR_FILTER_MAX_RANGES * 8] = {0};
+
+    filter.flags = KVM_MSR_FILTER_DEFAULT_ALLOW;
+
+    if (has_hyperv) {
+        /* Hyper-V overlay page MSRs */
+        nmsrs = 2;
+        range = &filter.ranges[nfilt++];
+        range->bitmap = &bitmap_buf[bitmap_pos];
+        kvm_set_msr_filter_range(range, KVM_MSR_FILTER_WRITE,
+                                 HV_X64_MSR_GUEST_OS_ID, nmsrs,
+                                 true, /* HV_X64_MSR_GUEST_OS_ID */
+                                 true  /* HV_X64_MSR_HYPERCALL */);
+        bitmap_pos += ROUND_UP(nmsrs, 8) / 8;
+        assert(bitmap_pos < sizeof(bitmap_buf));
+    }
+
+    r = kvm_vm_ioctl(s, KVM_X86_SET_MSR_FILTER, &filter);
+    if (r != 0) {
+        error_report("kvm: failed to set MSR filters");
+        return -1;
+    }
+
+    return 0;
+}
+
 int kvm_arch_init(MachineState *ms, KVMState *s)
 {
     uint64_t identity_base = 0xfffbc000;
@@ -2269,6 +2322,17 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    has_msr_filtering = kvm_check_extension(s, KVM_CAP_X86_USER_SPACE_MSR) &&
+                        kvm_check_extension(s, KVM_CAP_X86_MSR_FILTER);
+    if (has_msr_filtering) {
+        ret = kvm_vm_enable_cap(s, KVM_CAP_X86_USER_SPACE_MSR, 0,
+                                KVM_MSR_EXIT_REASON_FILTER);
+        if (ret == 0) {
+            ret = kvm_set_msr_filters(s);
+            msr_filters_active = (ret == 0);
+        }
+    }
+
     return 0;
 }
 
@@ -4542,6 +4606,11 @@ static bool host_supports_vmx(void)
     return ecx & CPUID_EXT_VMX;
 }
 
+static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
+{
+    return 0;
+}
+
 #define VMX_INVALID_GUEST_STATE 0x80000021
 
 int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
@@ -4600,6 +4669,9 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
         ioapic_eoi_broadcast(run->eoi.vector);
         ret = 0;
         break;
+    case KVM_EXIT_X86_WRMSR:
+        ret = kvm_handle_wrmsr(cpu, run);
+        break;
     default:
         fprintf(stderr, "KVM: unknown exit reason %d\n", run->exit_reason);
         ret = -1;
-- 
2.17.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



