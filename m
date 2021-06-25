Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 191B13B4192
	for <lists+kvm@lfdr.de>; Fri, 25 Jun 2021 12:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhFYK04 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Jun 2021 06:26:56 -0400
Received: from smtp-fw-80006.amazon.com ([99.78.197.217]:59604 "EHLO
        smtp-fw-80006.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbhFYK0y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Jun 2021 06:26:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1624616673; x=1656152673;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=uRsQqgTK+aUKa+iPFFwN/xEXyo2o9xgMWDsa/xJb4bU=;
  b=t6zXujTxWH4qIt2QvyrpNHcfGrB5BvPAmq+R0v67amRu5hyT8aTFX4CT
   bBYr1wpQLB5+r38v1z14zd46l4QrDW6AmhHD58CvxttSTqCSOFMA1XZPv
   1FPHhOnP3TKx+43UKIM/5ifI+vm3K5WF/Z8zYYZHGYiPI+VI79L4lr0NP
   g=;
X-IronPort-AV: E=Sophos;i="5.83,298,1616457600"; 
   d="scan'208";a="8698652"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 25 Jun 2021 10:24:26 +0000
Received: from EX13D28EUC003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-1c1b5cdd.us-west-2.amazon.com (Postfix) with ESMTPS id D6C04A19CD;
        Fri, 25 Jun 2021 10:24:26 +0000 (UTC)
Received: from uc8bbc9586ea454.ant.amazon.com (10.43.161.183) by
 EX13D28EUC003.ant.amazon.com (10.43.164.43) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Fri, 25 Jun 2021 10:24:22 +0000
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
Subject: [PATCH v2 5/6] kvm/i386: Add support for user space MSR filtering
Date:   Fri, 25 Jun 2021 12:23:30 +0200
Message-ID: <678fba871629cc645cfe5b95292327cd8ae3e61f.1624615713.git.sidcha@amazon.de>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1624615713.git.sidcha@amazon.de>
References: <cover.1624615713.git.sidcha@amazon.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.43.161.183]
X-ClientProxiedBy: EX13D05UWC004.ant.amazon.com (10.43.162.223) To
 EX13D28EUC003.ant.amazon.com (10.43.164.43)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Check and enable user space MSR filtering capability and handle new exit
reason KVM_EXIT_X86_WRMSR. This will be used in a follow up patch to
implement hyper-v overlay pages.

Signed-off-by: Siddharth Chandrasekaran <sidcha@amazon.de>
---
 target/i386/kvm/kvm.c | 67 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index bcf1b4f2d0..b89b343acc 100644
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
@@ -2183,6 +2185,42 @@ static void register_smram_listener(Notifier *n, void *unused)
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
+    int r;
+    struct kvm_msr_filter filter = { };
+
+    filter.flags = KVM_MSR_FILTER_DEFAULT_ALLOW;
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
@@ -2314,6 +2352,17 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
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
 
@@ -4587,6 +4636,18 @@ static bool host_supports_vmx(void)
     return ecx & CPUID_EXT_VMX;
 }
 
+static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
+{
+    run->msr.error = 1;
+    return 0;
+}
+
+static int kvm_handle_wrmsr(X86CPU *cpu, struct kvm_run *run)
+{
+    run->msr.error = 1;
+    return 0;
+}
+
 #define VMX_INVALID_GUEST_STATE 0x80000021
 
 int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
@@ -4645,6 +4706,12 @@ int kvm_arch_handle_exit(CPUState *cs, struct kvm_run *run)
         ioapic_eoi_broadcast(run->eoi.vector);
         ret = 0;
         break;
+    case KVM_EXIT_X86_RDMSR:
+        ret = kvm_handle_rdmsr(cpu, run);
+        break;
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



