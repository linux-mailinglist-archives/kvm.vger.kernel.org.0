Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33CCC1E2896
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389403AbgEZRYD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:24:03 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:48177 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389433AbgEZRYD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 13:24:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513841;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nthGi7o8BLKrMhIE3EU4Zi//GEaDHLHa41l0hjYgwAU=;
        b=Sh5VeqiZk6YesoSHRFQxsWEBN6lQ+DOwKdaQD1COt0hLhxa+N5BfWWQSjZWF/JStafeHmN
        Wu4CHgX6Ioaw+HQVURG4OUaPms1+OFS/p4oVoIihlzy/Zd4eV1DwPWtcqucMZbKVGCgtws
        m4llgmy7TD2BOjrfoZnMki+iMQs2gUs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-xCAQ1cyMMhiikt3Ld5-Fmw-1; Tue, 26 May 2020 13:23:57 -0400
X-MC-Unique: xCAQ1cyMMhiikt3Ld5-Fmw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A0BB5835B43;
        Tue, 26 May 2020 17:23:56 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5ACF5D9E7;
        Tue, 26 May 2020 17:23:55 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 28/28] KVM: nSVM: implement KVM_GET_NESTED_STATE and KVM_SET_NESTED_STATE
Date:   Tue, 26 May 2020 13:23:08 -0400
Message-Id: <20200526172308.111575-29-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Similar to VMX, the state that is captured through the currently available
IOCTLs is a mix of L1 and L2 state, dependent on whether the L2 guest was
running at the moment when the process was interrupted to save its state.

In particular, the SVM-specific state for nested virtualization includes
the L1 saved state (including the interrupt flag), the cached L2 controls,
and the GIF.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/uapi/asm/kvm.h |  17 +++-
 arch/x86/kvm/cpuid.h            |   5 ++
 arch/x86/kvm/svm/nested.c       | 147 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/svm/svm.c          |   1 +
 arch/x86/kvm/vmx/nested.c       |   5 --
 arch/x86/kvm/x86.c              |   3 +-
 6 files changed, 171 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 3f3f780c8c65..12075a9de1c1 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -385,18 +385,22 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
-#define KVM_STATE_NESTED_FORMAT_SVM	1	/* unused */
+#define KVM_STATE_NESTED_FORMAT_SVM	1
 
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
 #define KVM_STATE_NESTED_MTF_PENDING	0x00000008
+#define KVM_STATE_NESTED_GIF_SET	0x00000100
 
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
 
 #define KVM_STATE_NESTED_VMX_VMCS_SIZE	0x1000
 
+#define KVM_STATE_NESTED_SVM_VMCB_SIZE	0x1000
+
+
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
@@ -411,6 +415,15 @@ struct kvm_vmx_nested_state_hdr {
 	} smm;
 };
 
+struct kvm_svm_nested_state_data {
+	/* Save area only used if KVM_STATE_NESTED_RUN_PENDING.  */
+	__u8 vmcb12[KVM_STATE_NESTED_SVM_VMCB_SIZE];
+};
+
+struct kvm_svm_nested_state_hdr {
+	__u64 vmcb_pa;
+};
+
 /* for KVM_CAP_NESTED_STATE */
 struct kvm_nested_state {
 	__u16 flags;
@@ -419,6 +432,7 @@ struct kvm_nested_state {
 
 	union {
 		struct kvm_vmx_nested_state_hdr vmx;
+		struct kvm_svm_nested_state_hdr svm;
 
 		/* Pad the header to 128 bytes.  */
 		__u8 pad[120];
@@ -431,6 +445,7 @@ struct kvm_nested_state {
 	 */
 	union {
 		struct kvm_vmx_nested_state_data vmx[0];
+		struct kvm_svm_nested_state_data svm[0];
 	} data;
 };
 
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 63a70f6a3df3..05434cd9342f 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -303,4 +303,9 @@ static __always_inline void kvm_cpu_cap_check_and_set(unsigned int x86_feature)
 		kvm_cpu_cap_set(x86_feature);
 }
 
+static inline bool page_address_valid(struct kvm_vcpu *vcpu, gpa_t gpa)
+{
+	return PAGE_ALIGNED(gpa) && !(gpa >> cpuid_maxphyaddr(vcpu));
+}
+
 #endif
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 840662e66976..0f02521550b9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -25,6 +25,7 @@
 #include "trace.h"
 #include "mmu.h"
 #include "x86.h"
+#include "cpuid.h"
 #include "lapic.h"
 #include "svm.h"
 
@@ -238,6 +239,8 @@ static void load_nested_vmcb_control(struct vcpu_svm *svm,
 {
 	copy_vmcb_control_area(&svm->nested.ctl, control);
 
+	/* Copy it here because nested_svm_check_controls will check it.  */
+	svm->nested.ctl.asid           = control->asid;
 	svm->nested.ctl.msrpm_base_pa &= ~0x0fffULL;
 	svm->nested.ctl.iopm_base_pa  &= ~0x0fffULL;
 }
@@ -930,6 +933,150 @@ int nested_svm_exit_special(struct vcpu_svm *svm)
 	return NESTED_EXIT_CONTINUE;
 }
 
+static int svm_get_nested_state(struct kvm_vcpu *vcpu,
+				struct kvm_nested_state __user *user_kvm_nested_state,
+				u32 user_data_size)
+{
+	struct vcpu_svm *svm;
+	struct kvm_nested_state kvm_state = {
+		.flags = 0,
+		.format = KVM_STATE_NESTED_FORMAT_SVM,
+		.size = sizeof(kvm_state),
+	};
+	struct vmcb __user *user_vmcb = (struct vmcb __user *)
+		&user_kvm_nested_state->data.svm[0];
+
+	if (!vcpu)
+		return kvm_state.size + KVM_STATE_NESTED_SVM_VMCB_SIZE;
+
+	svm = to_svm(vcpu);
+
+	if (user_data_size < kvm_state.size)
+		goto out;
+
+	/* First fill in the header and copy it out.  */
+	if (is_guest_mode(vcpu)) {
+		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb;
+		kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
+		kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
+
+		if (svm->nested.nested_run_pending)
+			kvm_state.flags |= KVM_STATE_NESTED_RUN_PENDING;
+	}
+
+	if (gif_set(svm))
+		kvm_state.flags |= KVM_STATE_NESTED_GIF_SET;
+
+	if (copy_to_user(user_kvm_nested_state, &kvm_state, sizeof(kvm_state)))
+		return -EFAULT;
+
+	if (!is_guest_mode(vcpu))
+		goto out;
+
+	/*
+	 * Copy over the full size of the VMCB rather than just the size
+	 * of the structs.
+	 */
+	if (clear_user(user_vmcb, KVM_STATE_NESTED_SVM_VMCB_SIZE))
+		return -EFAULT;
+	if (copy_to_user(&user_vmcb->control, &svm->nested.ctl,
+			 sizeof(user_vmcb->control)))
+		return -EFAULT;
+	if (copy_to_user(&user_vmcb->save, &svm->nested.hsave->save,
+			 sizeof(user_vmcb->save)))
+		return -EFAULT;
+
+out:
+	return kvm_state.size;
+}
+
+static int svm_set_nested_state(struct kvm_vcpu *vcpu,
+				struct kvm_nested_state __user *user_kvm_nested_state,
+				struct kvm_nested_state *kvm_state)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+	struct vmcb *hsave = svm->nested.hsave;
+	struct vmcb __user *user_vmcb = (struct vmcb __user *)
+		&user_kvm_nested_state->data.svm[0];
+	struct vmcb_control_area ctl;
+	struct vmcb_save_area save;
+	u32 cr0;
+
+	if (kvm_state->format != KVM_STATE_NESTED_FORMAT_SVM)
+		return -EINVAL;
+
+	if (kvm_state->flags & ~(KVM_STATE_NESTED_GUEST_MODE |
+				 KVM_STATE_NESTED_RUN_PENDING |
+				 KVM_STATE_NESTED_GIF_SET))
+		return -EINVAL;
+
+	/*
+	 * If in guest mode, vcpu->arch.efer actually refers to the L2 guest's
+	 * EFER.SVME, but EFER.SVME still has to be 1 for VMRUN to succeed.
+	 */
+	if (!(vcpu->arch.efer & EFER_SVME)) {
+		/* GIF=1 and no guest mode are required if SVME=0.  */
+		if (kvm_state->flags != KVM_STATE_NESTED_GIF_SET)
+			return -EINVAL;
+	}
+
+	/* SMM temporarily disables SVM, so we cannot be in guest mode.  */
+	if (is_smm(vcpu) && (kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
+		return -EINVAL;
+
+	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE)) {
+		svm_leave_nested(svm);
+		goto out_set_gif;
+	}
+
+	if (!page_address_valid(vcpu, kvm_state->hdr.svm.vmcb_pa))
+		return -EINVAL;
+	if (kvm_state->size < sizeof(*kvm_state) + KVM_STATE_NESTED_SVM_VMCB_SIZE)
+		return -EINVAL;
+	if (copy_from_user(&ctl, &user_vmcb->control, sizeof(ctl)))
+		return -EFAULT;
+	if (copy_from_user(&save, &user_vmcb->save, sizeof(save)))
+		return -EFAULT;
+
+	if (!nested_vmcb_check_controls(&ctl))
+		return -EINVAL;
+
+	/*
+	 * Processor state contains L2 state.  Check that it is
+	 * valid for guest mode (see nested_vmcb_checks).
+	 */
+	cr0 = kvm_read_cr0(vcpu);
+        if (((cr0 & X86_CR0_CD) == 0) && (cr0 & X86_CR0_NW))
+                return -EINVAL;
+
+	/*
+	 * Validate host state saved from before VMRUN (see
+	 * nested_svm_check_permissions).
+	 * TODO: validate reserved bits for all saved state.
+	 */
+	if (!(save.cr0 & X86_CR0_PG))
+		return -EINVAL;
+
+	/*
+	 * All checks done, we can enter guest mode.  L1 control fields
+	 * come from the nested save state.  Guest state is already
+	 * in the registers, the save area of the nested state instead
+	 * contains saved L1 state.
+	 */
+	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
+	hsave->save = save;
+
+	svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
+	load_nested_vmcb_control(svm, &ctl);
+	nested_prepare_vmcb_control(svm);
+
+out_set_gif:
+	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
+	return 0;
+}
+
 struct kvm_x86_nested_ops svm_nested_ops = {
 	.check_events = svm_check_nested_events,
+	.get_state = svm_get_nested_state,
+	.set_state = svm_set_nested_state,
 };
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c1e746ccd7da..f6a13685baa0 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1193,6 +1193,7 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 		svm->avic_is_running = true;
 
 	svm->nested.hsave = page_address(hsave_page);
+	clear_page(svm->nested.hsave);
 
 	svm->msrpm = page_address(msrpm_pages);
 	svm_vcpu_init_msrpm(svm->msrpm);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 51ebb60e1533..106fc6fceb97 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -437,11 +437,6 @@ static void vmx_inject_page_fault_nested(struct kvm_vcpu *vcpu,
 	}
 }
 
-static bool page_address_valid(struct kvm_vcpu *vcpu, gpa_t gpa)
-{
-	return PAGE_ALIGNED(gpa) && !(gpa >> cpuid_maxphyaddr(vcpu));
-}
-
 static int nested_vmx_check_io_bitmap_controls(struct kvm_vcpu *vcpu,
 					       struct vmcs12 *vmcs12)
 {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e03543488d37..3bb34d53460f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4628,7 +4628,8 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		if (kvm_state.flags &
 		    ~(KVM_STATE_NESTED_RUN_PENDING | KVM_STATE_NESTED_GUEST_MODE
-		      | KVM_STATE_NESTED_EVMCS | KVM_STATE_NESTED_MTF_PENDING))
+		      | KVM_STATE_NESTED_EVMCS | KVM_STATE_NESTED_MTF_PENDING
+		      | KVM_STATE_NESTED_GIF_SET))
 			break;
 
 		/* nested_run_pending implies guest_mode.  */
-- 
2.26.2

