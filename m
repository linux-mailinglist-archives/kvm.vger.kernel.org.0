Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABB64B7E8B
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 04:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344148AbiBPDQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 22:16:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344145AbiBPDQZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 22:16:25 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CA0E7F60;
        Tue, 15 Feb 2022 19:16:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644981374; x=1676517374;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FfUoAo4oDorQPqjCfrO87NTW/6QExAqQMSQCENI5GwQ=;
  b=IiX1mMQeYrfc/o4oOVKPCLFhiU+fVoDJ3kgwqGqyD72ErTQ+jObs8dDd
   foC+zUbL6gS3+AijAhlElJi7u/MuWsIDILuO1u8Eaqth5oVK10oc/+Ikt
   ADKrf9uuSajivuDngXyb2WMClV4VVpWheOPV/5octl1ESKQg+AiYwIf0/
   d4Bi/Qx4wLklqwODXceKBw5gmd4qVFEmMA6JXq5I4Ny+yCwzG0RnHqR7F
   MzVnDMxodTBv3lUEB+ilbjP+jwkuF+3Nc5nwrroFQY7DsN2qVAkelUKo/
   nGymjqQqKOBUQdmrzFDAjqjN5r9NVaTUM9Dsda0lPCdNblBG6MqDs2ALE
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="249344539"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="249344539"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 19:16:14 -0800
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="773798287"
Received: from hyperv-sh4.sh.intel.com ([10.239.48.22])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 19:16:09 -0800
From:   Chao Gao <chao.gao@intel.com>
To:     seanjc@google.com, maz@kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, kevin.tian@intel.com, tglx@linutronix.de
Cc:     Chao Gao <chao.gao@intel.com>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Eric Auger <eric.auger@redhat.com>,
        Oliver Upton <oupton@google.com>, Jia He <justin.he@arm.com>,
        John Garry <john.garry@huawei.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Richter <tmricht@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/6] KVM: arm64: Simplify the CPUHP logic
Date:   Wed, 16 Feb 2022 11:15:19 +0800
Message-Id: <20220216031528.92558-5-chao.gao@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220216031528.92558-1-chao.gao@intel.com>
References: <20220216031528.92558-1-chao.gao@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
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
Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/arm64/kvm/arch_timer.c     | 27 ++++++++++-----------------
 arch/arm64/kvm/arm.c            |  4 ++++
 arch/arm64/kvm/vgic/vgic-init.c | 19 ++-----------------
 include/kvm/arm_arch_timer.h    |  4 ++++
 include/kvm/arm_vgic.h          |  4 ++++
 include/linux/cpuhotplug.h      |  3 ---
 6 files changed, 24 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 6e542e2eae32..f9d14c6dc0b4 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -796,10 +796,18 @@ void kvm_timer_vcpu_init(struct kvm_vcpu *vcpu)
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
@@ -961,18 +969,6 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
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
@@ -1170,9 +1166,6 @@ int kvm_timer_hyp_init(bool has_gic)
 		goto out_free_irq;
 	}
 
-	cpuhp_setup_state(CPUHP_AP_KVM_ARM_TIMER_STARTING,
-			  "kvm/arm/timer:starting", kvm_timer_starting_cpu,
-			  kvm_timer_dying_cpu);
 	return 0;
 out_free_irq:
 	free_percpu_irq(host_vtimer_irq, kvm_get_running_vcpus());
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0165cf3aac3a..31b049e48b19 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1658,6 +1658,8 @@ static void _kvm_arch_hardware_enable(void *discard)
 {
 	if (!__this_cpu_read(kvm_arm_hardware_enabled)) {
 		cpu_hyp_reinit();
+		kvm_vgic_cpu_up();
+		kvm_timer_cpu_up();
 		__this_cpu_write(kvm_arm_hardware_enabled, 1);
 	}
 }
@@ -1671,6 +1673,8 @@ int kvm_arch_hardware_enable(void)
 static void _kvm_arch_hardware_disable(void *discard)
 {
 	if (__this_cpu_read(kvm_arm_hardware_enabled)) {
+		kvm_timer_cpu_down();
+		kvm_vgic_cpu_down();
 		cpu_hyp_reset();
 		__this_cpu_write(kvm_arm_hardware_enabled, 0);
 	}
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index fc00304fe7d8..60038a8516de 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -460,17 +460,15 @@ int kvm_vgic_map_resources(struct kvm *kvm)
 
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
@@ -579,19 +577,6 @@ int kvm_vgic_hyp_init(void)
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
index 51c19381108c..16a2f65fcfb4 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -106,4 +106,8 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
 u32 timer_get_ctl(struct arch_timer_context *ctxt);
 u64 timer_get_cval(struct arch_timer_context *ctxt);
 
+/* CPU HP callbacks */
+void kvm_timer_cpu_up(void);
+void kvm_timer_cpu_down(void);
+
 #endif
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index bb30a6803d9f..a2a0cca05a73 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -427,4 +427,8 @@ int vgic_v4_load(struct kvm_vcpu *vcpu);
 void vgic_v4_commit(struct kvm_vcpu *vcpu);
 int vgic_v4_put(struct kvm_vcpu *vcpu, bool need_db);
 
+/* CPU HP callbacks */
+void kvm_vgic_cpu_up(void);
+void kvm_vgic_cpu_down(void);
+
 #endif /* __KVM_ARM_VGIC_H */
diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
index 411a428ace4d..4345b8eafc03 100644
--- a/include/linux/cpuhotplug.h
+++ b/include/linux/cpuhotplug.h
@@ -183,9 +183,6 @@ enum cpuhp_state {
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

