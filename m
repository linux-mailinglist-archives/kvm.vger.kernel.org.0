Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE706615C43
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 07:24:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiKBGYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 02:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229557AbiKBGYY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 02:24:24 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC91B2610C;
        Tue,  1 Nov 2022 23:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667370263; x=1698906263;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mIYUSSuIsu0WgSRrE7tEoP8B3O0y+uo/P/amOMScs7w=;
  b=eGr4OEXoOWokIF6IEkvhMIXRsUgp/yZ1qmhYY00N6WRG2ic9thLIk4gv
   wTkBAqAJ5Dcf7OzlIAQjvmTPvWY1XXrnJbrh1QwwBEgGPERNTjTLFKciP
   /4n3/kKjFR0O9tp7VosR5DcJzQfVn52zITYH4cR+mcs5qJvObZ2X3VaMB
   vq2RyM/LphnlDFCZL7vzXGU5lveK6AYLBXPyYW0mMvh59RI/G6aJqROyS
   yv6b51ZznqVM8H4UOkAdmsGyp6Izh7JkpTVifFB/ZXBACmtf/mkX9EAI9
   88mv2FVXXjmnsVP2w2Ci8lOUBxRCIKV1lIaT+ohnrh01ntEFuLBMWX3qb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="296765017"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="296765017"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 23:24:22 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10518"; a="703146410"
X-IronPort-AV: E=Sophos;i="5.95,232,1661842800"; 
   d="scan'208";a="703146410"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Nov 2022 23:24:21 -0700
From:   isaku.yamahata@intel.com
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com
Subject: [PATCH 4/4] KVM: arm64: Simplify the CPUHP logic
Date:   Tue,  1 Nov 2022 23:24:11 -0700
Message-Id: <c358e8afc54517ebbb69f10666937e802a24527d.1667369456.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1667369456.git.isaku.yamahata@intel.com>
References: <cover.1667369456.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

For a number of historical reasons, the KVM/arm64 hotplug setup is pretty
complicated, and we have two extra CPUHP notifiers for vGIC and timers.

It looks pretty pointless, and gets in the way of further changes.
So let's just expose some helpers that can be called from the core
CPUHP callback, and get rid of everything else.

This gives us the opportunity to drop a useless notifier entry,
as well as tidy-up the timer enable/disable, which was a bit odd.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/arm64/kvm/arch_timer.c     | 27 ++++++++++-----------------
 arch/arm64/kvm/arm.c            | 13 +++++++++++++
 arch/arm64/kvm/vgic/vgic-init.c | 19 ++-----------------
 include/kvm/arm_arch_timer.h    |  4 ++++
 include/kvm/arm_vgic.h          |  4 ++++
 include/linux/cpuhotplug.h      |  3 ---
 6 files changed, 33 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index bb24a76b4224..33fca1a691a5 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -811,10 +811,18 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
 	ptimer->host_timer_irq_flags = host_ptimer_irq_flags;
 }
 
-static void kvm_timer_init_interrupt(void *info)
+void kvm_timer_cpu_up(void)
 {
 	enable_percpu_irq(host_vtimer_irq, host_vtimer_irq_flags);
-	enable_percpu_irq(host_ptimer_irq, host_ptimer_irq_flags);
+	if (host_ptimer_irq)
+		enable_percpu_irq(host_ptimer_irq, host_ptimer_irq_flags);
+}
+
+void kvm_timer_cpu_down(void)
+{
+	disable_percpu_irq(host_vtimer_irq);
+	if (host_ptimer_irq)
+		disable_percpu_irq(host_ptimer_irq);
 }
 
 int kvm_arm_timer_set_reg(struct kvm_vcpu *vcpu, u64 regid, u64 value)
@@ -976,18 +984,6 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
 	preempt_enable();
 }
 
-static int kvm_timer_starting_cpu(unsigned int cpu)
-{
-	kvm_timer_init_interrupt(NULL);
-	return 0;
-}
-
-static int kvm_timer_dying_cpu(unsigned int cpu)
-{
-	disable_percpu_irq(host_vtimer_irq);
-	return 0;
-}
-
 static int timer_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
 {
 	if (vcpu)
@@ -1185,9 +1181,6 @@ int kvm_timer_hyp_init(bool has_gic)
 		goto out_free_irq;
 	}
 
-	cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
-			  "kvm/arm/timer:starting", kvm_timer_starting_cpu,
-			  kvm_timer_dying_cpu);
 	return 0;
 out_free_irq:
 	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 94d33e296e10..a15d9933edbd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1675,7 +1675,15 @@ static void _kvm_arch_hardware_enable(void *discard)
 
 int kvm_arch_hardware_enable(void)
 {
+	int was_enabled = __this_cpu_read(kvm_arm_hardware_enabled);
+
 	_kvm_arch_hardware_enable(NULL);
+
+	if (!was_enabled) {
+		kvm_vgic_cpu_up();
+		kvm_timer_cpu_up();
+	}
+
 	return 0;
 }
 
@@ -1689,6 +1697,11 @@ static void _kvm_arch_hardware_disable(void *discard)
 
 void kvm_arch_hardware_disable(void)
 {
+	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
+		kvm_timer_cpu_down();
+		kvm_vgic_cpu_down();
+	}
+
 	if (!is_protected_kvm_enabled())
 		_kvm_arch_hardware_disable(NULL);
 }
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index f6d4f4052555..6c7f6ae21ec0 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -465,17 +465,15 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 
 /* GENERIC PROBE */
 
-static int vgic_init_cpu_starting(unsigned int cpu)
+void kvm_vgic_cpu_up(void)
 {
 	enable_percpu_irq(kvm_vgic_global_state.maint_irq, 0);
-	return 0;
 }
 
 
-static int vgic_init_cpu_dying(unsigned int cpu)
+void kvm_vgic_cpu_down(void)
 {
 	disable_percpu_irq(kvm_vgic_global_state.maint_irq);
-	return 0;
 }
 
 static irqreturn_t vgic_maintenance_handler(int irq, void *data)
@@ -584,19 +582,6 @@ int kvm_vgic_hyp_init(void)
 		return ret;
 	}
 
-	ret = cpuhp_setup_state(CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
-				"kvm/arm/vgic:starting",
-				vgic_init_cpu_starting, vgic_init_cpu_dying);
-	if (ret) {
-		kvm_err("Cannot register vgic CPU notifier\n");
-		goto out_free_irq;
-	}
-
 	kvm_info("vgic interrupt IRQ%d\n", kvm_vgic_global_state.maint_irq);
 	return 0;
-
-out_free_irq:
-	free_percpu_irq(kvm_vgic_global_state.maint_irq,
-			kvm_get_running_vcpus());
-	return ret;
 }
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index cd6d8f260eab..1638418f72dd 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -104,4 +104,8 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
 u32 timer_get_ctl(struct arch_timer_context *ctxt);
 u64 timer_get_cval(struct arch_timer_context *ctxt);
 
+/* CPU HP callbacks */
+void kvm_timer_cpu_up(void);
+void kvm_timer_cpu_down(void);
+
 #endif
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4df9e73a8bb5..fc4acc91ba06 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -431,4 +431,8 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
 
+/* CPU HP callbacks */
+void kvm_vgic_cpu_up(void);
+void kvm_vgic_cpu_down(void);
+
 #endif /* __KVM_ARM_VGIC_H */
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index f61447913db9..7337414e4947 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -186,9 +186,6 @@ enum cpuhp_state {
 	CPUHP_AP_TI_GP_TIMER_STARTING,
 	CPUHP_AP_HYPERV_TIMER_STARTING,
 	CPUHP_AP_KVM_STARTING,
-	CPUHP_AP_KVM_ARM_VGIC_INIT_STARTING,
-	CPUHP_AP_KVM_ARM_VGIC_STARTING,
-	CPUHP_AP_KVM_ARM_TIMER_STARTING,
 	/* Must be the last timer callback */
 	CPUHP_AP_DUMMY_TIMER_STARTING,
 	CPUHP_AP_ARM_XEN_STARTING,
-- 
2.25.1

