Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF164A77B9
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 19:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346468AbiBBSSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 13:18:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23691 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238083AbiBBSSS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 2 Feb 2022 13:18:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643825897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Km7sFont8AeGrnOT2/QC+/8Ywtf1kDR067FynIPPUaY=;
        b=BU3af14efWNl5OCd+CTEi0IW7qm6msgR+1Rwm38SWv2QnkXpOWg+Wiiu8IDM+eTNdnLggX
        DKDX0tAKoWX+nzCuZkb23W5vNPWsW4KU0K4bgxTHKN6SUPVS2xLlgmQIG4wStmHeEC/fxR
        iYUiVncerSVyeKcx/DTypi2svvvN91g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-I9vHjKyDMgaYYlyQWf87jA-1; Wed, 02 Feb 2022 13:18:16 -0500
X-MC-Unique: I9vHjKyDMgaYYlyQWf87jA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3080112F980;
        Wed,  2 Feb 2022 18:18:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4CD297745C;
        Wed,  2 Feb 2022 18:18:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 2/5] KVM: x86: mark NULL-able kvm_x86_ops
Date:   Wed,  2 Feb 2022 13:18:10 -0500
Message-Id: <20220202181813.1103496-3-pbonzini@redhat.com>
In-Reply-To: <20220202181813.1103496-1-pbonzini@redhat.com>
References: <20220202181813.1103496-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The original use of KVM_X86_OP_NULL, which was to mark calls
that do not follow a specific naming convention, is not in use
anymore.  Repurpose it to identify calls that are invoked within
conditionals or with static_call_cond.  Those that are _not_,
i.e. those that are defined with KVM_X86_OP, must be defined by
both vendor modules or some kind of NULL pointer dereference
is bound to happen at runtime.

In the case of apicv_post_status_restore, rather than changing
the kvm-x86-ops.h declaration, I decided to use static_call_cond;
there's no absolute requirement for vendor modules to support
APIC virtualization.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 30 ++++++++++++++----------------
 arch/x86/kvm/lapic.c               |  4 ++--
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 9e37dc3d8863..a842f10f5778 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -6,16 +6,14 @@ BUILD_BUG_ON(1)
 /*
  * KVM_X86_OP() and KVM_X86_OP_NULL() are used to help generate
  * "static_call()"s. They are also intended for use when defining
- * the vmx/svm kvm_x86_ops. KVM_X86_OP() can be used for those
- * functions that follow the [svm|vmx]_func_name convention.
- * KVM_X86_OP_NULL() can leave a NULL definition for the
- * case where there is no definition or a function name that
- * doesn't match the typical naming convention is supplied.
+ * the vmx/svm kvm_x86_ops. KVM_X86_OP_NULL() can be used for those
+ * functions that can have a NULL definition, for example if
+ * "static_call_cond()" will be used at the call sites.
  */
-KVM_X86_OP_NULL(hardware_enable)
-KVM_X86_OP_NULL(hardware_disable)
-KVM_X86_OP_NULL(hardware_unsetup)
-KVM_X86_OP_NULL(cpu_has_accelerated_tpr)
+KVM_X86_OP(hardware_enable)
+KVM_X86_OP(hardware_disable)
+KVM_X86_OP(hardware_unsetup)
+KVM_X86_OP(cpu_has_accelerated_tpr)
 KVM_X86_OP(has_emulated_msr)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(vm_init)
@@ -33,7 +31,7 @@ KVM_X86_OP(get_segment_base)
 KVM_X86_OP(get_segment)
 KVM_X86_OP(get_cpl)
 KVM_X86_OP(set_segment)
-KVM_X86_OP_NULL(get_cs_db_l_bits)
+KVM_X86_OP(get_cs_db_l_bits)
 KVM_X86_OP(set_cr0)
 KVM_X86_OP_NULL(post_set_cr3)
 KVM_X86_OP(is_valid_cr4)
@@ -57,8 +55,8 @@ KVM_X86_OP(flush_tlb_gva)
 KVM_X86_OP(flush_tlb_guest)
 KVM_X86_OP(vcpu_pre_run)
 KVM_X86_OP(vcpu_run)
-KVM_X86_OP_NULL(handle_exit)
-KVM_X86_OP_NULL(skip_emulated_instruction)
+KVM_X86_OP(handle_exit)
+KVM_X86_OP(skip_emulated_instruction)
 KVM_X86_OP_NULL(update_emulated_instruction)
 KVM_X86_OP(set_interrupt_shadow)
 KVM_X86_OP(get_interrupt_shadow)
@@ -73,7 +71,7 @@ KVM_X86_OP(get_nmi_mask)
 KVM_X86_OP(set_nmi_mask)
 KVM_X86_OP(enable_nmi_window)
 KVM_X86_OP(enable_irq_window)
-KVM_X86_OP(update_cr8_intercept)
+KVM_X86_OP_NULL(update_cr8_intercept)
 KVM_X86_OP(check_apicv_inhibit_reasons)
 KVM_X86_OP(refresh_apicv_exec_ctrl)
 KVM_X86_OP(hwapic_irr_update)
@@ -88,7 +86,7 @@ KVM_X86_OP(set_tss_addr)
 KVM_X86_OP(set_identity_map_addr)
 KVM_X86_OP(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
-KVM_X86_OP_NULL(has_wbinvd_exit)
+KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
 KVM_X86_OP(write_tsc_offset)
@@ -96,7 +94,7 @@ KVM_X86_OP(write_tsc_multiplier)
 KVM_X86_OP(get_exit_info)
 KVM_X86_OP(check_intercept)
 KVM_X86_OP(handle_exit_irqoff)
-KVM_X86_OP_NULL(request_immediate_exit)
+KVM_X86_OP(request_immediate_exit)
 KVM_X86_OP(sched_in)
 KVM_X86_OP_NULL(update_cpu_dirty_logging)
 KVM_X86_OP_NULL(vcpu_blocking)
@@ -123,7 +121,7 @@ KVM_X86_OP(apic_init_signal_blocked)
 KVM_X86_OP_NULL(enable_direct_tlbflush)
 KVM_X86_OP_NULL(migrate_timers)
 KVM_X86_OP(msr_filter_changed)
-KVM_X86_OP_NULL(complete_emulated_msr)
+KVM_X86_OP(complete_emulated_msr)
 KVM_X86_OP(vcpu_deliver_sipi_vector)
 
 #undef KVM_X86_OP
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0da7d0960fcb..09bbb6a01c1d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2369,7 +2369,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vcpu->arch.pv_eoi.msr_val = 0;
 	apic_update_ppr(apic);
 	if (vcpu->arch.apicv_active) {
-		static_call(kvm_x86_apicv_post_state_restore)(vcpu);
+		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call(kvm_x86_hwapic_irr_update)(vcpu, -1);
 		static_call(kvm_x86_hwapic_isr_update)(vcpu, -1);
 	}
@@ -2634,7 +2634,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	kvm_apic_update_apicv(vcpu);
 	apic->highest_isr_cache = -1;
 	if (vcpu->arch.apicv_active) {
-		static_call(kvm_x86_apicv_post_state_restore)(vcpu);
+		static_call_cond(kvm_x86_apicv_post_state_restore)(vcpu);
 		static_call(kvm_x86_hwapic_irr_update)(vcpu,
 				apic_find_highest_irr(apic));
 		static_call(kvm_x86_hwapic_isr_update)(vcpu,
-- 
2.31.1


