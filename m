Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA93332B5A8
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382352AbhCCHTN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:19:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47881 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1836016AbhCBTfg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 2 Mar 2021 14:35:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614713643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tKAfQA+Yp2E5ojEhfmhPTA+zsn8ukh8qVrY3IHNZpdg=;
        b=RfMv3tqwlpMZzpWsclq06TBhtQfbw0NlNfKhivN8DaGvZ3pKnuR5sPZ1BR++Dy46MY5MJe
        uGBMyd0GMGDV7JVb9m9QuFnl9biJkVcELQDMqHyyO9GHXL2Kd3mzeHhbsaH8Fwjk4/8Eyg
        lm/j80Ud/YwrdtDxHMaJe5fsQBm7geo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-pTWHNfSYMguoxMz7tk8Knw-1; Tue, 02 Mar 2021 14:33:59 -0500
X-MC-Unique: pTWHNfSYMguoxMz7tk8Knw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54B41804023;
        Tue,  2 Mar 2021 19:33:58 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF5D218996;
        Tue,  2 Mar 2021 19:33:57 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com, Babu Moger <babu.moger@amd.com>
Subject: [PATCH 23/23] KVM: SVM: Add support for Virtual SPEC_CTRL
Date:   Tue,  2 Mar 2021 14:33:43 -0500
Message-Id: <20210302193343.313318-24-pbonzini@redhat.com>
In-Reply-To: <20210302193343.313318-1-pbonzini@redhat.com>
References: <20210302193343.313318-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Newer AMD processors have a feature to virtualize the use of the
SPEC_CTRL MSR. Presence of this feature is indicated via CPUID
function 0x8000000A_EDX[20]: GuestSpecCtrl. Hypervisors are not
required to enable this feature since it is automatically enabled on
processors that support it.

A hypervisor may wish to impose speculation controls on guest
execution or a guest may want to impose its own speculation controls.
Therefore, the processor implements both host and guest
versions of SPEC_CTRL.

When in host mode, the host SPEC_CTRL value is in effect and writes
update only the host version of SPEC_CTRL. On a VMRUN, the processor
loads the guest version of SPEC_CTRL from the VMCB. When the guest
writes SPEC_CTRL, only the guest version is updated. On a VMEXIT,
the guest version is saved into the VMCB and the processor returns
to only using the host SPEC_CTRL for speculation control. The guest
SPEC_CTRL is located at offset 0x2E0 in the VMCB.

The effective SPEC_CTRL setting is the guest SPEC_CTRL setting or'ed
with the hypervisor SPEC_CTRL setting. This allows the hypervisor to
ensure a minimum SPEC_CTRL if desired.

This support also fixes an issue where a guest may sometimes see an
inconsistent value for the SPEC_CTRL MSR on processors that support
this feature. With the current SPEC_CTRL support, the first write to
SPEC_CTRL is intercepted and the virtualized version of the SPEC_CTRL
MSR is not updated. When the guest reads back the SPEC_CTRL MSR, it
will be 0x0, instead of the actual expected value. There isn’t a
security concern here, because the host SPEC_CTRL value is or’ed with
the Guest SPEC_CTRL value to generate the effective SPEC_CTRL value.
KVM writes with the guest's virtualized SPEC_CTRL value to SPEC_CTRL
MSR just before the VMRUN, so it will always have the actual value
even though it doesn’t appear that way in the guest. The guest will
only see the proper value for the SPEC_CTRL register if the guest was
to write to the SPEC_CTRL register again. With Virtual SPEC_CTRL
support, the save area spec_ctrl is properly saved and restored.
So, the guest will always see the proper value when it is read back.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Message-Id: <161188100955.28787.11816849358413330720.stgit@bmoger-ubuntu>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/svm.h |  4 +++-
 arch/x86/kvm/svm/nested.c  | 15 +++++++++++++++
 arch/x86/kvm/svm/svm.c     | 26 +++++++++++++++++++++-----
 3 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 1c561945b426..772e60efe243 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -269,7 +269,9 @@ struct vmcb_save_area {
 	 * SEV-ES guests when referenced through the GHCB or for
 	 * saving to the host save area.
 	 */
-	u8 reserved_7[80];
+	u8 reserved_7[72];
+	u32 spec_ctrl;		/* Guest version of SPEC_CTRL at 0x2E0 */
+	u8 reserved_7b[4];
 	u32 pkru;
 	u8 reserved_7a[20];
 	u64 reserved_8;		/* rax already available at 0x01f8 */
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index cda0ed49d4cb..90a1704b5752 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -512,6 +512,18 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	recalc_intercepts(svm);
 }
 
+static void nested_svm_copy_common_state(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
+{
+	/*
+	 * Some VMCB state is shared between L1 and L2 and thus has to be
+	 * moved at the time of nested vmrun and vmexit.
+	 *
+	 * VMLOAD/VMSAVE state would also belong in this category, but KVM
+	 * always performs VMLOAD and VMSAVE from the VMCB01.
+	 */
+	to_vmcb->save.spec_ctrl = from_vmcb->save.spec_ctrl;
+}
+
 int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 			 struct vmcb *vmcb12)
 {
@@ -536,6 +548,7 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 
 	WARN_ON(svm->vmcb == svm->nested.vmcb02.ptr);
 
+	nested_svm_copy_common_state(svm->vmcb01.ptr, svm->nested.vmcb02.ptr);
 	nested_load_control_from_vmcb12(svm, &vmcb12->control);
 
 	svm_switch_vmcb(svm, &svm->nested.vmcb02);
@@ -720,6 +733,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	vmcb12->control.pause_filter_thresh =
 		svm->vmcb->control.pause_filter_thresh;
 
+	nested_svm_copy_common_state(svm->nested.vmcb02.ptr, svm->vmcb01.ptr);
+
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b68f795db792..c4f2f2f6b945 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1245,6 +1245,13 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 
 	svm_check_invpcid(svm);
 
+	/*
+	 * If the host supports V_SPEC_CTRL then disable the interception
+	 * of MSR_IA32_SPEC_CTRL.
+	 */
+	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
+
 	if (kvm_vcpu_apicv_active(vcpu))
 		avic_init_vmcb(svm);
 
@@ -2712,7 +2719,10 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
-		msr_info->data = svm->spec_ctrl;
+		if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+			msr_info->data = svm->vmcb->save.spec_ctrl;
+		else
+			msr_info->data = svm->spec_ctrl;
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
@@ -2810,7 +2820,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (kvm_spec_ctrl_test_value(data))
 			return 1;
 
-		svm->spec_ctrl = data;
+		if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+			svm->vmcb->save.spec_ctrl = data;
+		else
+			svm->spec_ctrl = data;
 		if (!data)
 			break;
 
@@ -3804,7 +3817,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * is no need to worry about the conditional branch over the wrmsr
 	 * being speculatively taken.
 	 */
-	x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
+	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		x86_spec_ctrl_set_guest(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	svm_vcpu_enter_exit(vcpu);
 
@@ -3823,13 +3837,15 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * If the L02 MSR bitmap does not intercept the MSR, then we need to
 	 * save it.
 	 */
-	if (unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
+	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL) &&
+	    unlikely(!msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL)))
 		svm->spec_ctrl = native_read_msr(MSR_IA32_SPEC_CTRL);
 
 	if (!sev_es_guest(vcpu->kvm))
 		reload_tss(vcpu);
 
-	x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
+	if (!static_cpu_has(X86_FEATURE_V_SPEC_CTRL))
+		x86_spec_ctrl_restore_host(svm->spec_ctrl, svm->virt_spec_ctrl);
 
 	if (!sev_es_guest(vcpu->kvm)) {
 		vcpu->arch.cr2 = svm->vmcb->save.cr2;
-- 
2.26.2

