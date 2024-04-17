Return-Path: <kvm+bounces-14979-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 421B08A86EB
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 17:04:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6510F1C21345
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 15:04:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8684146D7A;
	Wed, 17 Apr 2024 15:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WgPZdzqx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1E641422A2;
	Wed, 17 Apr 2024 15:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713366245; cv=none; b=Dqykp0mn6Csfz5esIpQvmb1dkhw4jJV/18E3DNTdBCqOilKr2yNdLuGZN0f/hQLXSR2Z1+xGoT/qE6YWreIkiyuDWECjG3H1FGsuaZPzfcCHs7wureWxrqkliMyO6GqmHfqqAYJf5e2zG+lfDsWQ2Uy0DblsYqFcnmpVKYZeki8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713366245; c=relaxed/simple;
	bh=yD/GVU8gzpEmXReGiXnKRSGrjA4ZEXtYPUhvlIkvaH4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=FQxHLEKbzeIGkTMsABMov2MERiBcZ9mn/RugB+OHQZnJNfERzvDSjMq9rDRfulAFLuZ1bVoseXV43OYz/37Azw7r5gqSQ2HV2jhRDuHMxBV+Y46zwHTOxZOgl73MjzZ4n+dHbth3BFhXj3364Z3z31eML+dAHeldheikA4YVa+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WgPZdzqx; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713366240; x=1744902240;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=yD/GVU8gzpEmXReGiXnKRSGrjA4ZEXtYPUhvlIkvaH4=;
  b=WgPZdzqxBmoz6whHY6YGlZULbpCPQ5B0kF8kBACA9V2w9gCO/R+iX/BA
   NuSfV1eNkDo2AUWF4l8NUjkx/64WCTINCY2njkovjwAOCq2HLYZdMPaqc
   j0XlK0HGLfpitnGNMtUCd7EMVbRXNhJDGjkzQMigxj62k+Or++J0/+m+0
   C3TO2BJraJJCtq+c2nKdcjSQy9fjaw8Ee83sIovKqY2fryDG2Dgm2DODT
   h++S9zK74dyOzsktLlqT2nJO+Uy2+UPRi/FZaC8hRlJbPXu7BvGrioLXa
   wzr3V8UNjm2Jc0nCWdWtxmS1JMuQUR+5fkd9LQVS43HDA41OQ6UgA6ZGj
   w==;
X-CSE-ConnectionGUID: /VqOaUB4TPO+SwWyR+Xrgw==
X-CSE-MsgGUID: MD5O+mwyStuTSZqYC28tRw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="9033004"
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="9033004"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 08:03:59 -0700
X-CSE-ConnectionGUID: nNXqD5nJQW+jsjxN5FY3Aw==
X-CSE-MsgGUID: wuqkGQ1sTy+Ac0+VybYAHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,209,1708416000"; 
   d="scan'208";a="22740314"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmviesa007.fm.intel.com with ESMTP; 17 Apr 2024 08:03:57 -0700
From: Wei Wang <wei.w.wang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Wang <wei.w.wang@intel.com>
Subject: [RFC PATCH v1] KVM: x86: Introduce macros to simplify KVM_X86_OPS static calls
Date: Wed, 17 Apr 2024 23:03:54 +0800
Message-Id: <20240417150354.275353-1-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduces two new macros, KVM_X86_SC() and KVM_X86_SCC(), to streamline
the usage of KVM_X86_OPS static calls. The current implementation of these
calls is verbose and can lead to alignment challenges due to the two pairs
of parentheses. This makes the code susceptible to exceeding the "80
columns per single line of code" limit as defined in the coding-style
document. The two macros are added to improve code readability and
maintainability, while adhering to the coding style guidelines.

Please note that this RFC only updated a few callsites for demonstration
purposes. If the approach looks good, all callsites will be updated in
the next version.

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  3 +++
 arch/x86/kvm/lapic.c            | 15 ++++++++-------
 arch/x86/kvm/trace.h            |  3 ++-
 arch/x86/kvm/x86.c              |  8 ++++----
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6efd1497b026..42f6450c10ec 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1856,6 +1856,9 @@ extern struct kvm_x86_ops kvm_x86_ops;
 	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
 #define KVM_X86_OP_OPTIONAL KVM_X86_OP
 #define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
+
+#define KVM_X86_SC(func, ...) static_call(kvm_x86_##func)(__VA_ARGS__)
+#define KVM_X86_SCC(func, ...) static_call_cond(kvm_x86_##func)(__VA_ARGS__)
 #include <asm/kvm-x86-ops.h>
 
 int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index ebf41023be38..e819dbae8d79 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -728,8 +728,8 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 	if (unlikely(apic->apicv_active)) {
 		/* need to update RVI */
 		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
-		static_call_cond(kvm_x86_hwapic_irr_update)(apic->vcpu,
-							    apic_find_highest_irr(apic));
+		KVM_X86_SCC(hwapic_irr_update,
+			    apic->vcpu, apic_find_highest_irr(apic));
 	} else {
 		apic->irr_pending = false;
 		kvm_lapic_clear_vector(vec, apic->regs + APIC_IRR);
@@ -800,7 +800,7 @@ static inline void apic_clear_isr(int vec, struct kvm_lapic *apic)
 	 * and must be left alone.
 	 */
 	if (unlikely(apic->apicv_active))
-		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
+		KVM_X86_SCC(hwapic_isr_update, apic_find_highest_isr(apic));
 	else {
 		--apic->isr_count;
 		BUG_ON(apic->isr_count < 0);
@@ -2112,7 +2112,7 @@ static bool start_hv_timer(struct kvm_lapic *apic)
 	if (!ktimer->tscdeadline)
 		return false;
 
-	if (static_call(kvm_x86_set_hv_timer)(vcpu, ktimer->tscdeadline, &expired))
+	if (KVM_X86_SC(set_hv_timer, vcpu, ktimer->tscdeadline, &expired))
 		return false;
 
 	ktimer->hv_timer_in_use = true;
@@ -3041,9 +3041,10 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	kvm_apic_update_apicv(vcpu);
 	if (apic->apicv_active) {
-		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
-		static_call_cond(kvm_x86_hwapic_irr_update)(vcpu, apic_find_highest_irr(apic));
-		static_call_cond(kvm_x86_hwapic_isr_update)(apic_find_highest_isr(apic));
+		KVM_X86_SCC(apicv_post_state_restore, vcpu);
+		KVM_X86_SCC(hwapic_irr_update,
+			    vcpu, apic_find_highest_irr(apic));
+		KVM_X86_SCC(hwapic_isr_update, apic_find_highest_isr(apic));
 	}
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	if (ioapic_in_kernel(vcpu->kvm))
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index c6b4b1728006..a51f6c2d43f1 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -828,7 +828,8 @@ TRACE_EVENT(kvm_emulate_insn,
 		),
 
 	TP_fast_assign(
-		__entry->csbase = static_call(kvm_x86_get_segment_base)(vcpu, VCPU_SREG_CS);
+		__entry->csbase = KVM_X86_SC(get_segment_base,
+					     vcpu, VCPU_SREG_CS);
 		__entry->len = vcpu->arch.emulate_ctxt->fetch.ptr
 			       - vcpu->arch.emulate_ctxt->fetch.data;
 		__entry->rip = vcpu->arch.emulate_ctxt->_eip - __entry->len;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ebcc12d1e1de..146b88ded5d1 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2008,7 +2008,7 @@ static int complete_emulated_rdmsr(struct kvm_vcpu *vcpu)
 
 static int complete_fast_msr_access(struct kvm_vcpu *vcpu)
 {
-	return static_call(kvm_x86_complete_emulated_msr)(vcpu, vcpu->run->msr.error);
+	return KVM_X86_SC(complete_emulated_msr, vcpu, vcpu->run->msr.error);
 }
 
 static int complete_fast_rdmsr(struct kvm_vcpu *vcpu)
@@ -7452,7 +7452,7 @@ static void kvm_init_msr_lists(void)
 	}
 
 	for (i = 0; i < ARRAY_SIZE(emulated_msrs_all); i++) {
-		if (!static_call(kvm_x86_has_emulated_msr)(NULL, emulated_msrs_all[i]))
+		if (!KVM_X86_SC(has_emulated_msr, NULL, emulated_msrs_all[i]))
 			continue;
 
 		emulated_msrs[num_emulated_msrs++] = emulated_msrs_all[i];
@@ -10703,7 +10703,7 @@ static void vcpu_load_eoi_exitmap(struct kvm_vcpu *vcpu)
 		bitmap_or((ulong *)eoi_exit_bitmap,
 			  vcpu->arch.ioapic_handled_vectors,
 			  to_hv_synic(vcpu)->vec_bitmap, 256);
-		static_call_cond(kvm_x86_load_eoi_exitmap)(vcpu, eoi_exit_bitmap);
+		KVM_X86_SCC(load_eoi_exitmap, vcpu, eoi_exit_bitmap);
 		return;
 	}
 #endif
@@ -13497,7 +13497,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	 * when the irq is masked/disabled or the consumer side (KVM
 	 * int this case doesn't want to receive the interrupts.
 	*/
-	ret = static_call(kvm_x86_pi_update_irte)(irqfd->kvm, prod->irq, irqfd->gsi, 0);
+	ret = KVM_X86_SC(pi_update_irte, irqfd->kvm, prod->irq, irqfd->gsi, 0);
 	if (ret)
 		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
 		       " fails: %d\n", irqfd->consumer.token, ret);

base-commit: 49ff3b4aec51e3abfc9369997cc603319b02af9a
-- 
2.27.0


