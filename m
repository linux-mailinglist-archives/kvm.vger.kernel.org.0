Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6A5487C93
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbiAGS4J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:56:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232164AbiAGSzc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 13:55:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641581731;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NINV2YOtmNjTbWv389ZkR66m3PFc6xJNaksQbL5uTtk=;
        b=JLIUEYzzhk/uu1GG1RDKACn5xwaikWicgLZXOLkB5LIn3Oae/s71nlukh+ZB7Mqw1eMZIa
        bgJnN5PPrT49E/peYaI9ARTzWPS9uF8qmVqYdx9WnUxLSd18TDpPnGKIACpXrQFA8bMRhq
        ho6PT9w8gci5BQgr0otD9oyAOMxLgJI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-517-ziJ0mW6dOQGWpp8E5IQXZA-1; Fri, 07 Jan 2022 13:55:26 -0500
X-MC-Unique: ziJ0mW6dOQGWpp8E5IQXZA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 77725101F000;
        Fri,  7 Jan 2022 18:55:24 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C09A792FAF;
        Fri,  7 Jan 2022 18:55:23 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     guang.zeng@intel.com, jing2.liu@intel.com, kevin.tian@intel.com,
        seanjc@google.com, tglx@linutronix.de, wei.w.wang@intel.com,
        yang.zhong@intel.com
Subject: [PATCH v6 12/21] kvm: x86: Intercept #NM for saving IA32_XFD_ERR
Date:   Fri,  7 Jan 2022 13:55:03 -0500
Message-Id: <20220107185512.25321-13-pbonzini@redhat.com>
In-Reply-To: <20220107185512.25321-1-pbonzini@redhat.com>
References: <20220107185512.25321-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Jing Liu <jing2.liu@intel.com>

Guest IA32_XFD_ERR is generally modified in two places:

  - Set by CPU when #NM is triggered;
  - Cleared by guest in its #NM handler;

Intercept #NM for the first case when a nonzero value is written
to IA32_XFD. Nonzero indicates that the guest is willing to do
dynamic fpstate expansion for certain xfeatures, thus KVM needs to
manage and virtualize guest XFD_ERR properly. The vcpu exception
bitmap is updated in XFD write emulation according to guest_fpu::xfd.

Save the current XFD_ERR value to the guest_fpu container in the #NM
VM-exit handler. This must be done with interrupt disabled, otherwise
the unsaved MSR value may be clobbered by host activity.

The saving operation is conducted conditionally only when guest_fpu:xfd
includes a non-zero value. Doing so also avoids misread on a platform
which doesn't support XFD but #NM is triggered due to L1 interception.

Queueing #NM to the guest is postponed to handle_exception_nmi(). This
goes through the nested_vmx check so a virtual vmexit is queued instead
when #NM is triggered in L2 but L1 wants to intercept it.

Restore the host value (always ZERO outside of the host #NM
handler) before enabling interrupt.

Restore the guest value from the guest_fpu container right before
entering the guest (with interrupt disabled).

Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jing Liu <jing2.liu@intel.com>
Signed-off-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yang Zhong <yang.zhong@intel.com>
Message-Id: <20220105123532.12586-13-yang.zhong@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmcs.h |  5 +++++
 arch/x86/kvm/vmx/vmx.c  | 48 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c      |  6 ++++++
 3 files changed, 59 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index 6e5de2e2b0da..e325c290a816 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -129,6 +129,11 @@ static inline bool is_machine_check(u32 intr_info)
 	return is_exception_n(intr_info, MC_VECTOR);
 }
 
+static inline bool is_nm_fault(u32 intr_info)
+{
+	return is_exception_n(intr_info, NM_VECTOR);
+}
+
 /* Undocumented: icebp/int1 */
 static inline bool is_icebp(u32 intr_info)
 {
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7b5abe25e1e5..84f6904cdb6e 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -36,6 +36,7 @@
 #include <asm/debugreg.h>
 #include <asm/desc.h>
 #include <asm/fpu/api.h>
+#include <asm/fpu/xstate.h>
 #include <asm/idtentry.h>
 #include <asm/io.h>
 #include <asm/irq_remapping.h>
@@ -761,6 +762,13 @@ void vmx_update_exception_bitmap(struct kvm_vcpu *vcpu)
 		vmcs_write32(PAGE_FAULT_ERROR_CODE_MATCH, match);
 	}
 
+	/*
+	 * Trap #NM if guest xfd contains a non-zero value so guest XFD_ERR
+	 * can be saved timely.
+	 */
+	if (vcpu->arch.guest_fpu.fpstate->xfd)
+		eb |= (1u << NM_VECTOR);
+
 	vmcs_write32(EXCEPTION_BITMAP, eb);
 }
 
@@ -1967,6 +1975,12 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_KERNEL_GS_BASE:
 		vmx_write_guest_kernel_gs_base(vmx, data);
 		break;
+	case MSR_IA32_XFD:
+		ret = kvm_set_msr_common(vcpu, msr_info);
+		/* Update #NM interception according to guest xfd */
+		if (!ret)
+			vmx_update_exception_bitmap(vcpu);
+		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
 		if (is_guest_mode(vcpu))
@@ -4798,6 +4812,17 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
 	if (is_machine_check(intr_info) || is_nmi(intr_info))
 		return 1; /* handled by handle_exception_nmi_irqoff() */
 
+	/*
+	 * Queue the exception here instead of in handle_nm_fault_irqoff().
+	 * This ensures the nested_vmx check is not skipped so vmexit can
+	 * be reflected to L1 (when it intercepts #NM) before reaching this
+	 * point.
+	 */
+	if (is_nm_fault(intr_info)) {
+		kvm_queue_exception(vcpu, NM_VECTOR);
+		return 1;
+	}
+
 	if (is_invalid_opcode(intr_info))
 		return handle_ud(vcpu);
 
@@ -6399,6 +6424,26 @@ static void handle_interrupt_nmi_irqoff(struct kvm_vcpu *vcpu,
 	kvm_after_interrupt(vcpu);
 }
 
+static void handle_nm_fault_irqoff(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * Save xfd_err to guest_fpu before interrupt is enabled, so the
+	 * MSR value is not clobbered by the host activity before the guest
+	 * has chance to consume it.
+	 *
+	 * Do not blindly read xfd_err here, since this exception might
+	 * be caused by L1 interception on a platform which doesn't
+	 * support xfd at all.
+	 *
+	 * Do it conditionally upon guest_fpu::xfd. xfd_err matters
+	 * only when xfd contains a non-zero value.
+	 *
+	 * Queuing exception is done in vmx_handle_exit. See comment there.
+	 */
+	if (vcpu->arch.guest_fpu.fpstate->xfd)
+		rdmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
+}
+
 static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 {
 	const unsigned long nmi_entry = (unsigned long)asm_exc_nmi_noist;
@@ -6407,6 +6452,9 @@ static void handle_exception_nmi_irqoff(struct vcpu_vmx *vmx)
 	/* if exit due to PF check for async PF */
 	if (is_page_fault(intr_info))
 		vmx->vcpu.arch.apf.host_apf_flags = kvm_read_and_reset_apf_flags();
+	/* if exit due to NM, handle before interrupts are enabled */
+	else if (is_nm_fault(intr_info))
+		handle_nm_fault_irqoff(&vmx->vcpu);
 	/* Handle machine checks before interrupts are enabled */
 	else if (is_machine_check(intr_info))
 		kvm_machine_check();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b18d2838606f..bb9534590a3a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9952,6 +9952,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	if (test_thread_flag(TIF_NEED_FPU_LOAD))
 		switch_fpu_return();
 
+	if (vcpu->arch.guest_fpu.xfd_err)
+		wrmsrl(MSR_IA32_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
+
 	if (unlikely(vcpu->arch.switch_db_regs)) {
 		set_debugreg(0, 7);
 		set_debugreg(vcpu->arch.eff_db[0], 0);
@@ -10015,6 +10018,9 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	static_call(kvm_x86_handle_exit_irqoff)(vcpu);
 
+	if (vcpu->arch.guest_fpu.xfd_err)
+		wrmsrl(MSR_IA32_XFD_ERR, 0);
+
 	/*
 	 * Consume any pending interrupts, including the possible source of
 	 * VM-Exit on SVM and any ticks that occur between VM-Exit and now.
-- 
2.31.1


