Return-Path: <kvm+bounces-15256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E805B8AADBD
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 13:31:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 29750B21F14
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 11:31:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3604126F3F;
	Fri, 19 Apr 2024 11:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PPR2+si5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9878085632;
	Fri, 19 Apr 2024 11:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713526210; cv=none; b=t53+1J8A2777Yr6UohwjJXfiyD4aUiBIehXb2542u55nBCO/gerNjx/jB+wARvyd+frrqP7FCErcBzreK9QO1IH0O/y75cANffrYO+wcTg8oJJ43pfaNHeRhSEVVobzuMQq2xmLStMlTBjVY2vTUsTK4zssn6qJWOd3V8wKA2vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713526210; c=relaxed/simple;
	bh=SXevR4Ol2K1ipIbmGK4hqz1uCQLNlVCZj5VNtNRfzws=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X2UoXOROeDK6M4hs2+CFt8k78yC+t42BrdNn0WVDrGiplbovhRD0ZijR/LYe3Soux3Z1fuf4ymBhPYwWavIx+etFMoAw+z+U/wylnJrNH5sOhw0VX3bvOuD+uCEwPNg4c2XXQo/Qdc2hljAXjic+zd4iiSqTd9LXfCN2vR96fto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PPR2+si5; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713526209; x=1745062209;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SXevR4Ol2K1ipIbmGK4hqz1uCQLNlVCZj5VNtNRfzws=;
  b=PPR2+si5/r1RLY7V3xBuiQmCE/krYrWMf1z8AlH02mCW+afhpRq0aIpl
   8f+hSBrxFMkzRmYldOP7OXuw5rAXlPXr9jlN8QbaMXRZqXvX3o44SZ14T
   baMVkzVtGHvAVt89pSLa09WlTXtNj6ESEXkXNPI1j/e3PPfJKvt9ws/Ky
   oumLUTFC2PNzi+Z1p5ZEg3R3xCR5tFc3rQMWA+UYVsTJF3e5nlrxh1GVP
   MseaEoGuC5FPF/Ris5phnnSlXANZ1JK/kb3Qf7q9XXcFnqLLLTuCjklt1
   5WGtaPPPrkRGPxGnCstiMX5efdBC5kkCGvpKLcEuvFvQ8Tj/7IIUvLij3
   w==;
X-CSE-ConnectionGUID: 5orxi/YKRNS5fWKRGcWBYQ==
X-CSE-MsgGUID: eTb5bVyDS1KA8S8Daisoiw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="20513178"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="20513178"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 04:30:08 -0700
X-CSE-ConnectionGUID: Y8bC8wAJQuag2V9/y/FBKw==
X-CSE-MsgGUID: fk4u/JfRSpqWQWQ4LF2Hvg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23389404"
Received: from tdx-lm.sh.intel.com ([10.239.53.27])
  by fmviesa008.fm.intel.com with ESMTP; 19 Apr 2024 04:30:07 -0700
From: Wei Wang <wei.w.wang@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com
Cc: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wei Wang <wei.w.wang@intel.com>
Subject: [RFC PATCH v2 4/5] KVM: x86: Remove KVM_X86_OP_OPTIONAL
Date: Fri, 19 Apr 2024 19:29:51 +0800
Message-Id: <20240419112952.15598-5-wei.w.wang@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20240419112952.15598-1-wei.w.wang@intel.com>
References: <20240419112952.15598-1-wei.w.wang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

KVM_X86_OP and KVM_X86_OP_OPTIONAL were utilized to define and execute
static_call_update() calls on mandatory and optional hooks, respectively.
Mandatory hooks were invoked via static_call() and necessitated definition
due to the presumption that an undefined hook (i.e., NULL) would cause
static_call() to fail. This assumption no longer holds true as
static_call() has been updated to treat a "NULL" hook as a NOP on x86.
Consequently, the so-called mandatory hooks are no longer required to be
defined, rendering them non-mandatory. This eliminates the need to
differentiate between mandatory and optional hooks, allowing a single
KVM_X86_OP to suffice.

So KVM_X86_OP_OPTIONAL and the WARN_ON() associated with KVM_X86_OP are
removed to simplify usage, and KVM_X86_OP_OPTIONAL_RET0 is renamed to
KVM_X86_OP_RET0, as the term "optional" is now redundant (every hook
can be optional).

Signed-off-by: Wei Wang <wei.w.wang@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 100 ++++++++++++++---------------
 arch/x86/include/asm/kvm_host.h    |   3 +-
 arch/x86/kvm/x86.c                 |  11 +---
 3 files changed, 52 insertions(+), 62 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 110d7f29ca9a..306c9820e373 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -1,18 +1,15 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#if !defined(KVM_X86_OP) || !defined(KVM_X86_OP_OPTIONAL)
+#if !defined(KVM_X86_OP)
 BUILD_BUG_ON(1)
 #endif
 
 /*
- * KVM_X86_OP() and KVM_X86_OP_OPTIONAL() are used to help generate
- * both DECLARE/DEFINE_STATIC_CALL() invocations and
- * "static_call_update()" calls.
- *
- * KVM_X86_OP_OPTIONAL() can be used for those functions that can have
- * a NULL definition, for example if "static_call_cond()" will be used
- * at the call sites.  KVM_X86_OP_OPTIONAL_RET0() can be used likewise
- * to make a definition optional, but in this case the default will
- * be __static_call_return0.
+ * KVM_X86_OP() is used to help generate both DECLARE/DEFINE_STATIC_CALL()
+ * invocations and static_call_update() calls. All the hooks defined can be
+ * optional now, as invocation to an undefined hook (i.e.) has now been treated
+ * as a NOP by static_call().
+ * KVM_X86_OP_RET0() can be used to make an undefined operation be
+ * __static_call_return0.
  */
 KVM_X86_OP(check_processor_compatibility)
 KVM_X86_OP(hardware_enable)
@@ -21,8 +18,8 @@ KVM_X86_OP(hardware_unsetup)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(vm_init)
-KVM_X86_OP_OPTIONAL(vm_destroy)
-KVM_X86_OP_OPTIONAL_RET0(vcpu_precreate)
+KVM_X86_OP(vm_destroy)
+KVM_X86_OP_RET0(vcpu_precreate)
 KVM_X86_OP(vcpu_create)
 KVM_X86_OP(vcpu_free)
 KVM_X86_OP(vcpu_reset)
@@ -39,7 +36,7 @@ KVM_X86_OP(set_segment)
 KVM_X86_OP(get_cs_db_l_bits)
 KVM_X86_OP(is_valid_cr0)
 KVM_X86_OP(set_cr0)
-KVM_X86_OP_OPTIONAL(post_set_cr3)
+KVM_X86_OP(post_set_cr3)
 KVM_X86_OP(is_valid_cr4)
 KVM_X86_OP(set_cr4)
 KVM_X86_OP(set_efer)
@@ -56,8 +53,8 @@ KVM_X86_OP(get_if_flag)
 KVM_X86_OP(flush_tlb_all)
 KVM_X86_OP(flush_tlb_current)
 #if IS_ENABLED(CONFIG_HYPERV)
-KVM_X86_OP_OPTIONAL(flush_remote_tlbs)
-KVM_X86_OP_OPTIONAL(flush_remote_tlbs_range)
+KVM_X86_OP(flush_remote_tlbs)
+KVM_X86_OP(flush_remote_tlbs_range)
 #endif
 KVM_X86_OP(flush_tlb_gva)
 KVM_X86_OP(flush_tlb_guest)
@@ -65,14 +62,14 @@ KVM_X86_OP(vcpu_pre_run)
 KVM_X86_OP(vcpu_run)
 KVM_X86_OP(handle_exit)
 KVM_X86_OP(skip_emulated_instruction)
-KVM_X86_OP_OPTIONAL(update_emulated_instruction)
+KVM_X86_OP(update_emulated_instruction)
 KVM_X86_OP(set_interrupt_shadow)
 KVM_X86_OP(get_interrupt_shadow)
 KVM_X86_OP(patch_hypercall)
 KVM_X86_OP(inject_irq)
 KVM_X86_OP(inject_nmi)
-KVM_X86_OP_OPTIONAL_RET0(is_vnmi_pending)
-KVM_X86_OP_OPTIONAL_RET0(set_vnmi_pending)
+KVM_X86_OP_RET0(is_vnmi_pending)
+KVM_X86_OP_RET0(set_vnmi_pending)
 KVM_X86_OP(inject_exception)
 KVM_X86_OP(cancel_injection)
 KVM_X86_OP(interrupt_allowed)
@@ -81,19 +78,19 @@ KVM_X86_OP(get_nmi_mask)
 KVM_X86_OP(set_nmi_mask)
 KVM_X86_OP(enable_nmi_window)
 KVM_X86_OP(enable_irq_window)
-KVM_X86_OP_OPTIONAL(update_cr8_intercept)
+KVM_X86_OP(update_cr8_intercept)
 KVM_X86_OP(refresh_apicv_exec_ctrl)
-KVM_X86_OP_OPTIONAL(hwapic_irr_update)
-KVM_X86_OP_OPTIONAL(hwapic_isr_update)
-KVM_X86_OP_OPTIONAL_RET0(guest_apic_has_interrupt)
-KVM_X86_OP_OPTIONAL(load_eoi_exitmap)
-KVM_X86_OP_OPTIONAL(set_virtual_apic_mode)
-KVM_X86_OP_OPTIONAL(set_apic_access_page_addr)
+KVM_X86_OP(hwapic_irr_update)
+KVM_X86_OP(hwapic_isr_update)
+KVM_X86_OP_RET0(guest_apic_has_interrupt)
+KVM_X86_OP(load_eoi_exitmap)
+KVM_X86_OP(set_virtual_apic_mode)
+KVM_X86_OP(set_apic_access_page_addr)
 KVM_X86_OP(deliver_interrupt)
-KVM_X86_OP_OPTIONAL(sync_pir_to_irr)
-KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
-KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
-KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
+KVM_X86_OP(sync_pir_to_irr)
+KVM_X86_OP_RET0(set_tss_addr)
+KVM_X86_OP_RET0(set_identity_map_addr)
+KVM_X86_OP_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
@@ -104,16 +101,16 @@ KVM_X86_OP(get_exit_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
 KVM_X86_OP(sched_in)
-KVM_X86_OP_OPTIONAL(update_cpu_dirty_logging)
-KVM_X86_OP_OPTIONAL(vcpu_blocking)
-KVM_X86_OP_OPTIONAL(vcpu_unblocking)
-KVM_X86_OP_OPTIONAL(pi_update_irte)
-KVM_X86_OP_OPTIONAL(pi_start_assignment)
-KVM_X86_OP_OPTIONAL(apicv_pre_state_restore)
-KVM_X86_OP_OPTIONAL(apicv_post_state_restore)
-KVM_X86_OP_OPTIONAL_RET0(dy_apicv_has_pending_interrupt)
-KVM_X86_OP_OPTIONAL(set_hv_timer)
-KVM_X86_OP_OPTIONAL(cancel_hv_timer)
+KVM_X86_OP(update_cpu_dirty_logging)
+KVM_X86_OP(vcpu_blocking)
+KVM_X86_OP(vcpu_unblocking)
+KVM_X86_OP(pi_update_irte)
+KVM_X86_OP(pi_start_assignment)
+KVM_X86_OP(apicv_pre_state_restore)
+KVM_X86_OP(apicv_post_state_restore)
+KVM_X86_OP_RET0(dy_apicv_has_pending_interrupt)
+KVM_X86_OP(set_hv_timer)
+KVM_X86_OP(cancel_hv_timer)
 KVM_X86_OP(setup_mce)
 #ifdef CONFIG_KVM_SMM
 KVM_X86_OP(smi_allowed)
@@ -121,24 +118,23 @@ KVM_X86_OP(enter_smm)
 KVM_X86_OP(leave_smm)
 KVM_X86_OP(enable_smi_window)
 #endif
-KVM_X86_OP_OPTIONAL(mem_enc_ioctl)
-KVM_X86_OP_OPTIONAL(mem_enc_register_region)
-KVM_X86_OP_OPTIONAL(mem_enc_unregister_region)
-KVM_X86_OP_OPTIONAL(vm_copy_enc_context_from)
-KVM_X86_OP_OPTIONAL(vm_move_enc_context_from)
-KVM_X86_OP_OPTIONAL(guest_memory_reclaimed)
+KVM_X86_OP(mem_enc_ioctl)
+KVM_X86_OP(mem_enc_register_region)
+KVM_X86_OP(mem_enc_unregister_region)
+KVM_X86_OP(vm_copy_enc_context_from)
+KVM_X86_OP(vm_move_enc_context_from)
+KVM_X86_OP(guest_memory_reclaimed)
 KVM_X86_OP(get_msr_feature)
 KVM_X86_OP(check_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
-KVM_X86_OP_OPTIONAL(enable_l2_tlb_flush)
-KVM_X86_OP_OPTIONAL(migrate_timers)
+KVM_X86_OP(enable_l2_tlb_flush)
+KVM_X86_OP(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
 KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
-KVM_X86_OP_OPTIONAL_RET0(vcpu_get_apicv_inhibit_reasons);
-KVM_X86_OP_OPTIONAL(get_untagged_addr)
-KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
+KVM_X86_OP_RET0(vcpu_get_apicv_inhibit_reasons);
+KVM_X86_OP(get_untagged_addr)
+KVM_X86_OP(alloc_apic_backing_page)
 
 #undef KVM_X86_OP
-#undef KVM_X86_OP_OPTIONAL
-#undef KVM_X86_OP_OPTIONAL_RET0
+#undef KVM_X86_OP_RET0
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 3a2e42bb6969..647e7ec7c381 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1857,8 +1857,7 @@ extern struct kvm_x86_ops kvm_x86_ops;
 
 #define KVM_X86_OP(func) \
 	DECLARE_STATIC_CALL(kvm_x86_##func, *(((struct kvm_x86_ops *)0)->func));
-#define KVM_X86_OP_OPTIONAL KVM_X86_OP
-#define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
+#define KVM_X86_OP_RET0 KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 
 int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2467e053cb35..58c13bf68057 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -138,8 +138,7 @@ struct kvm_x86_ops kvm_x86_ops __read_mostly;
 #define KVM_X86_OP(func)					     \
 	DEFINE_STATIC_CALL_NULL(kvm_x86_##func,			     \
 				*(((struct kvm_x86_ops *)0)->func));
-#define KVM_X86_OP_OPTIONAL KVM_X86_OP
-#define KVM_X86_OP_OPTIONAL_RET0 KVM_X86_OP
+#define KVM_X86_OP_RET0 KVM_X86_OP
 #include <asm/kvm-x86-ops.h>
 EXPORT_STATIC_CALL_GPL(kvm_x86_get_cs_db_l_bits);
 EXPORT_STATIC_CALL_GPL(kvm_x86_cache_reg);
@@ -9656,16 +9655,12 @@ static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 {
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
 
-#define __KVM_X86_OP(func) \
-	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
 #define KVM_X86_OP(func) \
-	WARN_ON(!kvm_x86_ops.func); __KVM_X86_OP(func)
-#define KVM_X86_OP_OPTIONAL __KVM_X86_OP
-#define KVM_X86_OP_OPTIONAL_RET0(func) \
+	static_call_update(kvm_x86_##func, kvm_x86_ops.func);
+#define KVM_X86_OP_RET0(func) \
 	static_call_update(kvm_x86_##func, (void *)kvm_x86_ops.func ? : \
 					   (void *)__static_call_return0);
 #include <asm/kvm-x86-ops.h>
-#undef __KVM_X86_OP
 
 	kvm_pmu_ops_update(ops->pmu_ops);
 }
-- 
2.27.0


