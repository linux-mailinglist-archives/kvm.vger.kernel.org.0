Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C21476265C
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbjGYWWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjGYWUg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:20:36 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79932D7B;
        Tue, 25 Jul 2023 15:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323436; x=1721859436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KRXC9I21JsF+xyBURR85AdI/MBUQ0zzUdk4fG5aW4II=;
  b=BJG5KHrSEgCmh6xOcOcWl3R34j+VebLbUmxNvn1Bjn/nC4/YHdz/XR+v
   pEALLeUDgjfM646wU+UH6Iwd7M5DT2G2VV2n5biC0IlG+XCHCAky4qNUE
   4UlWerafwtGG8FemZuV125mq8Vkxgqr1tcZynbUqqn05hHjnIaS/TyuMd
   chZt0bgWekdovTmDOqVcSpZ2bdtWNu7Qt3pEbJQ0DNMtve6wmYc+/EWdD
   oenlAoWwBJeTnL9JP6RgsCxxV/nNSHXwXq0W6ZlDL1A5W7zuMKWR5vyY4
   NPJhllBaECPZCfjC+ZeARbmdiKLqbU+E3ydLwTbMIkM0CYl9nMOe8Xwp+
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="367882608"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="367882608"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="840001835"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="840001835"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:15:56 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 076/115] KVM: TDX: remove use of struct vcpu_vmx from posted_interrupt.c
Date:   Tue, 25 Jul 2023 15:14:27 -0700
Message-Id: <128b752995728d5b39db8c71056d2d346ffb59f4.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
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
index 0afffdbf24e0..8ffef0dac24e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -521,6 +521,7 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
 
 	fpstate_set_confidential(&vcpu->arch.guest_fpu);
 	vcpu->arch.apic->guest_apic_protected = true;
+	INIT_LIST_HEAD(&tdx->pi_wakeup_list);
 
 	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index da7e83dc34b8..45c1df7b2e40 100644
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
index 0c97328fc3d5..3802b1dcbc1c 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -233,6 +233,14 @@ struct nested_vmx {
 
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
 
@@ -302,12 +310,6 @@ struct vcpu_vmx {
 
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

