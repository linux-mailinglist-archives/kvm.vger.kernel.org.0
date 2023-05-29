Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B556271435A
	for <lists+kvm@lfdr.de>; Mon, 29 May 2023 06:35:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbjE2Eeg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 May 2023 00:34:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232167AbjE2E27 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 May 2023 00:28:59 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15BE4212A;
        Sun, 28 May 2023 21:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685334319; x=1716870319;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+Z5O8Xo1ft2OQKCLPDGRMuRD+ochICG1IfpSfQ7GCuA=;
  b=KZhw3f8H31j6VxiIMXK5lO6/p5TLO0g/Ug5v11Rk1RdOGmegtMmmMBwY
   9ZcLG6NwujMXp6xZkezbnBGIR6S0fU2JeSWlIMWETr32qwoZKz0JIWiPs
   kDrHff+07Fx5/KDW92sk+rr7wYLS6F2slbP7qUBQsuuqAM7eW53XPrSlk
   FThv9CONH27yUejqi75rGUDLRaslJU9f98CeajObi9IOgVUizatD6eDcg
   9Ec7vec8gu+7j4oMUX9fEy2sbevpQ7gqBjK22ZIM3SIDR0FKHk5T34c7/
   z9r88DHRmXsaFjy5VZV+el9HhWIFqlQSw3HIj0KfRfwpM89rv6GUmGzG4
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="334966194"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="334966194"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10724"; a="775784476"
X-IronPort-AV: E=Sophos;i="6.00,200,1681196400"; 
   d="scan'208";a="775784476"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2023 21:21:30 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com
Subject: [PATCH v14 076/113] KVM: TDX: remove use of struct vcpu_vmx from posted_interrupt.c
Date:   Sun, 28 May 2023 21:19:58 -0700
Message-Id: <20ee7ade96741bd293284e39a40f298955bbd2d5.1685333728.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1685333727.git.isaku.yamahata@intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

As TDX will use posted_interrupt.c, the use of struct vcpu_vmx is a
blocker.  Because the members of struct pi_desc pi_desc and struct
list_head pi_wakeup_list are only used in posted_interrupt.c, introduce
common structure, struct vcpu_pi, make vcpu_vmx and vcpu_tdx has same
layout in the top of structure.

To minimize the diff size, avoid code conversion like,
vmx->pi_desc => vmx->common->pi_desc.  Instead add compile time check
if the layout is expected.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/kvm/vmx/posted_intr.c | 41 ++++++++++++++++++++++++++--------
 arch/x86/kvm/vmx/posted_intr.h | 11 +++++++++
 arch/x86/kvm/vmx/tdx.c         |  1 +
 arch/x86/kvm/vmx/tdx.h         |  8 +++++++
 arch/x86/kvm/vmx/vmx.h         | 14 +++++++-----
 5 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index 94c38bea60e7..92de016852ca 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -11,6 +11,7 @@
 #include "posted_intr.h"
 #include "trace.h"
 #include "vmx.h"
+#include "tdx.h"
 
 /*
  * Maintain a per-CPU list of vCPUs that need to be awakened by wakeup_handler()
@@ -31,9 +32,29 @@ static DEFINE_PER_CPU(struct list_head, wakeup_vcpus_on_cpu);
  */
 static DEFINE_PER_CPU(raw_spinlock_t, wakeup_vcpus_on_cpu_lock);
 
+/*
+ * The layout of the head of struct vcpu_vmx and struct vcpu_tdx must match with
+ * struct vcpu_pi.
+ */
+static_assert(offsetof(struct vcpu_pi, pi_desc) ==
+	      offsetof(struct vcpu_vmx, pi_desc));
+static_assert(offsetof(struct vcpu_pi, pi_wakeup_list) ==
+	      offsetof(struct vcpu_vmx, pi_wakeup_list));
+#ifdef CONFIG_INTEL_TDX_HOST
+static_assert(offsetof(struct vcpu_pi, pi_desc) ==
+	      offsetof(struct vcpu_tdx, pi_desc));
+static_assert(offsetof(struct vcpu_pi, pi_wakeup_list) ==
+	      offsetof(struct vcpu_tdx, pi_wakeup_list));
+#endif
+
+static inline struct vcpu_pi *vcpu_to_pi(struct kvm_vcpu *vcpu)
+{
+	return (struct vcpu_pi *)vcpu;
+}
+
 static inline struct pi_desc *vcpu_to_pi_desc(struct kvm_vcpu *vcpu)
 {
-	return &(to_vmx(vcpu)->pi_desc);
+	return &vcpu_to_pi(vcpu)->pi_desc;
 }
 
 static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
@@ -52,8 +73,8 @@ static int pi_try_set_control(struct pi_desc *pi_desc, u64 *pold, u64 new)
 
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 {
-	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vcpu_pi *vcpu_pi = vcpu_to_pi(vcpu);
+	struct pi_desc *pi_desc = &vcpu_pi->pi_desc;
 	struct pi_desc old, new;
 	unsigned long flags;
 	unsigned int dest;
@@ -90,7 +111,7 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
 	 */
 	if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
 		raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
-		list_del(&vmx->pi_wakeup_list);
+		list_del(&vcpu_pi->pi_wakeup_list);
 		raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 	}
 
@@ -145,15 +166,15 @@ static bool vmx_can_use_vtd_pi(struct kvm *kvm)
  */
 static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
 {
-	struct pi_desc *pi_desc = vcpu_to_pi_desc(vcpu);
-	struct vcpu_vmx *vmx = to_vmx(vcpu);
+	struct vcpu_pi *vcpu_pi = vcpu_to_pi(vcpu);
+	struct pi_desc *pi_desc = &vcpu_pi->pi_desc;
 	struct pi_desc old, new;
 	unsigned long flags;
 
 	local_irq_save(flags);
 
 	raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
-	list_add_tail(&vmx->pi_wakeup_list,
+	list_add_tail(&vcpu_pi->pi_wakeup_list,
 		      &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
 	raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
 
@@ -190,7 +211,8 @@ static bool vmx_needs_pi_wakeup(struct kvm_vcpu *vcpu)
 	 * notification vector is switched to the one that calls
 	 * back to the pi_wakeup_handler() function.
 	 */
-	return vmx_can_use_ipiv(vcpu) || vmx_can_use_vtd_pi(vcpu->kvm);
+	return (vmx_can_use_ipiv(vcpu) && !is_td_vcpu(vcpu)) ||
+		vmx_can_use_vtd_pi(vcpu->kvm);
 }
 
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
@@ -200,7 +222,8 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu)
 	if (!vmx_needs_pi_wakeup(vcpu))
 		return;
 
-	if (kvm_vcpu_is_blocking(vcpu) && !vmx_interrupt_blocked(vcpu))
+	if (kvm_vcpu_is_blocking(vcpu) &&
+	    (is_td_vcpu(vcpu) || !vmx_interrupt_blocked(vcpu)))
 		pi_enable_wakeup_handler(vcpu);
 
 	/*
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index 26992076552e..2fe8222308b2 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -94,6 +94,17 @@ static inline bool pi_test_sn(struct pi_desc *pi_desc)
 			(unsigned long *)&pi_desc->control);
 }
 
+struct vcpu_pi {
+	struct kvm_vcpu	vcpu;
+
+	/* Posted interrupt descriptor */
+	struct pi_desc pi_desc;
+
+	/* Used if this vCPU is waiting for PI notification wakeup. */
+	struct list_head pi_wakeup_list;
+	/* Until here common layout betwwn vcpu_vmx and vcpu_tdx. */
+};
+
 void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu);
 void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
 void pi_wakeup_handler(void);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 442aa4e39871..599e6cfefaab 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -521,6 +521,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
 	vcpu->arch.apic->guest_apic_protected = true;
+	INIT_LIST_HEAD(&tdx->pi_wakeup_list);
 
 	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 85706c2cf539..c56a1bdfb8bb 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -4,6 +4,7 @@
 
 #ifdef CONFIG_INTEL_TDX_HOST
 
+#include "posted_intr.h"
 #include "pmu_intel.h"
 #include "tdx_ops.h"
 
@@ -67,6 +68,13 @@ union tdx_exit_reason {
 struct vcpu_tdx {
 	struct kvm_vcpu	vcpu;
 
+	/* Posted interrupt descriptor */
+	struct pi_desc pi_desc;
+
+	/* Used if this vCPU is waiting for PI notification wakeup. */
+	struct list_head pi_wakeup_list;
+	/* Until here same layout to struct vcpu_pi. */
+
 	unsigned long tdvpr_pa;
 	unsigned long *tdvpx_pa;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 9e8dfb0cfee5..5a18130f5c54 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -245,6 +245,14 @@ struct nested_vmx {
 
 struct vcpu_vmx {
 	struct kvm_vcpu       vcpu;
+
+	/* Posted interrupt descriptor */
+	struct pi_desc pi_desc;
+
+	/* Used if this vCPU is waiting for PI notification wakeup. */
+	struct list_head pi_wakeup_list;
+	/* Until here same layout to struct vcpu_pi. */
+
 	u8                    fail;
 	u8		      x2apic_msr_bitmap_mode;
 
@@ -314,12 +322,6 @@ struct vcpu_vmx {
 
 	union vmx_exit_reason exit_reason;
 
-	/* Posted interrupt descriptor */
-	struct pi_desc pi_desc;
-
-	/* Used if this vCPU is waiting for PI notification wakeup. */
-	struct list_head pi_wakeup_list;
-
 	/* Support for a guest hypervisor (nested VMX) */
 	struct nested_vmx nested;
 
-- 
2.25.1

