Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB04554809
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:13:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353513AbiFVJWu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 05:22:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233679AbiFVJWs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 05:22:48 -0400
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724A535261;
        Wed, 22 Jun 2022 02:22:47 -0700 (PDT)
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1o3wZ9-0000gW-BV; Wed, 22 Jun 2022 09:22:27 +0000
Received: from 54-240-197-231.amazon.com ([54.240.197.231] helo=debian.cbg12.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1o3wZ8-0002BS-VW; Wed, 22 Jun 2022 09:22:27 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] KVM: x86/xen: Update Xen CPUID Leaf 4 (tsc info) sub-leaves, if present
Date:   Wed, 22 Jun 2022 10:22:02 +0100
Message-Id: <20220622092202.15548-1-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_ADSP_ALL,
        RCVD_IN_DNSWL_MED,SPF_FAIL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The scaling information in sub-leaf 1 should match the values in the
'vcpu_info' sub-structure 'time_info' (a.k.a. pvclock_vcpu_time_info) which
is shared with the guest. The offset values are not set since a TSC offset
is already applied.
The host TSC frequency should also be set in sub-leaf 2.

This patch adds a new kvm_xen_set_cpuid() function that scans for the
relevant CPUID leaf when the CPUID information is updated by the VMM and
stashes pointers to the sub-leaves in the kvm_vcpu_xen structure.
The values are then updated by a call to the, also new,
kvm_xen_setup_tsc_info() function made at the end of
kvm_guest_time_update() just before entering the guest.

Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/kvm/cpuid.c            |  2 ++
 arch/x86/kvm/x86.c              |  1 +
 arch/x86/kvm/xen.c              | 41 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/xen.h              | 10 ++++++++
 5 files changed, 56 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 1038ccb7056a..f77a4940542f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -638,6 +638,8 @@ struct kvm_vcpu_xen {
 	struct hrtimer timer;
 	int poll_evtchn;
 	struct timer_list poll_timer;
+	struct kvm_cpuid_entry2 *tsc_info_1;
+	struct kvm_cpuid_entry2 *tsc_info_2;
 };
 
 struct kvm_vcpu_arch {
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index d47222ab8e6e..eb6cd88c974a 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -25,6 +25,7 @@
 #include "mmu.h"
 #include "trace.h"
 #include "pmu.h"
+#include "xen.h"
 
 /*
  * Unlike "struct cpuinfo_x86.x86_capability", kvm_cpu_caps doesn't need to be
@@ -310,6 +311,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
 
 	kvm_hv_set_cpuid(vcpu);
+	kvm_xen_set_cpuid(vcpu);
 
 	/* Invoke the vendor callback only after the above state is updated. */
 	static_call(kvm_x86_vcpu_after_set_cpuid)(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 00e23dc518e0..8b45f9975e45 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3123,6 +3123,7 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	if (vcpu->xen.vcpu_time_info_cache.active)
 		kvm_setup_guest_pvclock(v, &vcpu->xen.vcpu_time_info_cache, 0);
 	kvm_hv_setup_tsc_page(v->kvm, &vcpu->hv_clock);
+	kvm_xen_setup_tsc_info(v);
 	return 0;
 }
 
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index 610beba35907..a016ff85264d 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -10,6 +10,9 @@
 #include "xen.h"
 #include "hyperv.h"
 #include "lapic.h"
+#include "cpuid.h"
+
+#include <asm/xen/cpuid.h>
 
 #include <linux/eventfd.h>
 #include <linux/kvm_host.h>
@@ -1855,3 +1858,41 @@ void kvm_xen_destroy_vm(struct kvm *kvm)
 	if (kvm->arch.xen_hvm_config.msr)
 		static_branch_slow_dec_deferred(&kvm_xen_enabled);
 }
+
+void kvm_xen_set_cpuid(struct kvm_vcpu *vcpu)
+{
+	u32 base = 0;
+	u32 function;
+
+	for_each_possible_hypervisor_cpuid_base(function) {
+		struct kvm_cpuid_entry2 *entry = kvm_find_cpuid_entry(vcpu, function, 0);
+
+		if (entry &&
+		    entry->ebx == XEN_CPUID_SIGNATURE_EBX &&
+		    entry->ecx == XEN_CPUID_SIGNATURE_ECX &&
+		    entry->edx == XEN_CPUID_SIGNATURE_EDX) {
+			base = function;
+			break;
+		}
+	}
+	if (!base)
+		return;
+
+	function = base | XEN_CPUID_LEAF(3);
+	vcpu->arch.xen.tsc_info_1 = kvm_find_cpuid_entry(vcpu, function, 1);
+	vcpu->arch.xen.tsc_info_2 = kvm_find_cpuid_entry(vcpu, function, 2);
+}
+
+void kvm_xen_setup_tsc_info(struct kvm_vcpu *vcpu)
+{
+	struct kvm_cpuid_entry2 *entry = vcpu->arch.xen.tsc_info_1;
+
+	if (entry) {
+		entry->ecx = vcpu->arch.hv_clock.tsc_to_system_mul;
+		entry->edx = vcpu->arch.hv_clock.tsc_shift;
+	}
+
+	entry = vcpu->arch.xen.tsc_info_2;
+	if (entry)
+		entry->eax = vcpu->arch.hw_tsc_khz;
+}
diff --git a/arch/x86/kvm/xen.h b/arch/x86/kvm/xen.h
index 532a535a9e99..1afb663318a9 100644
--- a/arch/x86/kvm/xen.h
+++ b/arch/x86/kvm/xen.h
@@ -32,6 +32,8 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe,
 int kvm_xen_setup_evtchn(struct kvm *kvm,
 			 struct kvm_kernel_irq_routing_entry *e,
 			 const struct kvm_irq_routing_entry *ue);
+void kvm_xen_set_cpuid(struct kvm_vcpu *vcpu);
+void kvm_xen_setup_tsc_info(struct kvm_vcpu *vcpu);
 
 static inline bool kvm_xen_msr_enabled(struct kvm *kvm)
 {
@@ -135,6 +137,14 @@ static inline bool kvm_xen_timer_enabled(struct kvm_vcpu *vcpu)
 {
 	return false;
 }
+
+static inline void kvm_xen_set_cpuid(struct kvm_vcpu *vcpu)
+{
+}
+
+static inline void kvm_xen_setup_tsc_info(struct kvm_vcpu *vcpu)
+{
+}
 #endif
 
 int kvm_xen_hypercall(struct kvm_vcpu *vcpu);
-- 
2.20.1

