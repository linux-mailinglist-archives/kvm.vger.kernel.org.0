Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D375F65FF08
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 11:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbjAFKhC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 05:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbjAFKgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 05:36:47 -0500
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A85AD6C280;
        Fri,  6 Jan 2023 02:36:45 -0800 (PST)
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1pDk5O-0003oH-OG; Fri, 06 Jan 2023 10:36:30 +0000
Received: from 54-240-197-227.amazon.com ([54.240.197.227] helo=debian.cbg12.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1pDk5O-0001wX-EX; Fri, 06 Jan 2023 10:36:30 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     x86@kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v7 2/2] KVM: x86/xen: update Xen CPUID Leaf 4 (tsc info) sub-leaves, if present
Date:   Fri,  6 Jan 2023 10:36:00 +0000
Message-Id: <20230106103600.528-3-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230106103600.528-1-pdurrant@amazon.com>
References: <20230106103600.528-1-pdurrant@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_ADSP_ALL,
        RCVD_IN_DNSWL_MED,SPF_FAIL,SPF_HELO_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The scaling information in subleaf 1 should match the values set by KVM in
the 'vcpu_info' sub-structure 'time_info' (a.k.a. pvclock_vcpu_time_info)
which is shared with the guest, but is not directly available to the VMM.
The offset values are not set since a TSC offset is already applied.
The TSC frequency should also be set in sub-leaf 2.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: David Woodhouse <dwmw2@infradead.org>

v7:
 - Add a definition of XEN_SIGNATURE into asm/xen/hypervisor.h
   and use that

v6:
 - Stash Xen cpuid base and limit values when cpuid is set
 - Re-name kvm_xen_setup_tsc_info() to kvm_xen_update_tsc_info()

v5:
 - Drop the caching of the CPUID entry pointers and only update the
   sub-leaves if the CPU frequency has actually changed

v4:
 - Update commit comment

v3:
 - Add leaf limit check in kvm_xen_set_cpuid()

v2:
 - Make sure sub-leaf pointers are NULLed if the time leaf is removed
---
 arch/x86/include/asm/kvm_host.h       |  1 +
 arch/x86/include/asm/xen/hypervisor.h |  4 +++-
 arch/x86/kvm/cpuid.c                  |  2 ++
 arch/x86/kvm/x86.c                    |  1 +
 arch/x86/kvm/xen.c                    | 26 ++++++++++++++++++++++++++
 arch/x86/kvm/xen.h                    |  7 +++++++
 6 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 85cbe4571ac9..f3e9f6e4b3ea 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -703,6 +703,7 @@ struct kvm_vcpu_xen {
 	struct hrtimer timer;
 	int poll_evtchn;
 	struct timer_list poll_timer;
+	struct kvm_hypervisor_cpuid cpuid;
 };
 
 struct kvm_queued_exception {
diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index 16f548a661cf..5fc35f889cd1 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -38,9 +38,11 @@ extern struct start_info *xen_start_info;
 
 #include <asm/processor.h>
 
+#define XEN_SIGNATURE "XenVMMXenVMM"
+
 static inline uint32_t xen_cpuid_base(void)
 {
-	return hypervisor_cpuid_base("XenVMMXenVMM", 2);
+	return hypervisor_cpuid_base(XEN_SIGNATURE, 2);
 }
 
 struct pci_dev;
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index db5a4d38fcd0..560f880cc9fd 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -25,6 +25,7 @@
 #include "mmu.h"
 #include "trace.h"
 #include "pmu.h"
+#include "xen.h"
 
 /*
  * Unlike "struct cpuinfo_x86.x86_capability", kvm_cpu_caps doesn't need to be
@@ -442,6 +443,7 @@ static int kvm_set_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 	vcpu->arch.cpuid_nent = nent;
 
 	vcpu->arch.kvm_cpuid = kvm_get_hypervisor_cpuid(vcpu, KVM_SIGNATURE);
+	vcpu->arch.xen.cpuid = kvm_get_hypervisor_cpuid(vcpu, XEN_SIGNATURE);
 	kvm_vcpu_after_set_cpuid(vcpu);
 
 	return 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index f6ef44dc8a0e..e849a5445cac 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3158,6 +3158,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 				   &vcpu->hv_clock.tsc_shift,
 				   &vcpu->hv_clock.tsc_to_system_mul);
 		vcpu->hw_tsc_khz = tgt_tsc_khz;
+		kvm_xen_update_tsc_info(v);
 	}
 
 	vcpu->hv_clock.tsc_timestamp = tsc_timestamp;
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 2e29bdc2949c..fbfc7c17defd 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -22,6 +22,9 @@
 #include <xen/interface/event_channel.h>
 #include <xen/interface/sched.h>
 
+#include <asm/xen/cpuid.h>
+
+#include "cpuid.h"
 #include "trace.h"
 
 static int kvm_xen_set_evtchn(struct kvm_xen_evtchn *xe, struct kvm *kvm);
@@ -2067,6 +2070,29 @@ void kvm_xen_destroy_vcpu(struct kvm_vcpu *vcpu)
 	del_timer_sync(&vcpu->arch.xen.poll_timer);
 }
 
+void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *entry;
+	u32 function;
+
+	if (!vcpu->arch.xen.cpuid.base)
+		return;
+
+	function = vcpu->arch.xen.cpuid.base | XEN_CPUID_LEAF(3);
+	if (function > vcpu->arch.xen.cpuid.limit)
+		return;
+
+	entry = kvm_find_cpuid_entry_index(vcpu, function, 1);
+	if (entry) {
+		entry->ecx = vcpu->arch.hv_clock.tsc_to_system_mul;
+		entry->edx = vcpu->arch.hv_clock.tsc_shift;
+	}
+
+	entry = kvm_find_cpuid_entry_index(vcpu, function, 2);
+	if (entry)
+		entry->eax = vcpu->arch.hw_tsc_khz;
+}
+
 void kvm_xen_init_vm(struct kvm *kvm)
 {
 	idr_init(&kvm->arch.xen.evtchn_ports);
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index ea33d80a0c51..f8f1fe22d090 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -9,6 +9,8 @@
 #ifndef __ARCH_X86_KVM_XEN_H__
 #define __ARCH_X86_KVM_XEN_H__
 
+#include <asm/xen/hypervisor.h>
+
 #ifdef CONFIG_KVM_XEN
 #include <linux/jump_label_ratelimit.h>
 
@@ -32,6 +34,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe,
 int kvm_xen_setup_evtchn(struct kvm *kvm,
 			 struct kvm_kernel_irq_routing_entry *e,
 			 const struct kvm_irq_routing_entry *ue);
+void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 {
@@ -135,6 +138,10 @@ static inline bool kvm_xen_timer_enabled(struct kvm_vcpu *vcpu)
 {
 	return false;
 }
+
+static inline void kvm_xen_update_tsc_info(struct kvm_vcpu *vcpu)
+{
+}
 #endif
 
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
-- 
2.20.1

