Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF694C8DE1
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 15:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235333AbiCAOiJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 09:38:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235341AbiCAOh7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 09:37:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BD66CA1BE0
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 06:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646145436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6SLfiy1DvqPVPSSiAtLTk/wwtGYenAsIRWiYa+i62Mw=;
        b=jNHAqnYkk5L/F3xnG7RSKjojVgisIFQqIyJt3h8QaahOGRAEN40GFcv1nacu1mKUclMPXv
        y6Y4liwOZW9kQc6b8srJd4XKvfMvyzr/7bWbox6rsOJ+r6/i6wqdSCRtVoYDLINMO5mIZK
        UoHcCEBj4xjV0krJ3KJwU28KIl8ZoYo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-U-OsYJiTNf2ZuTpzjRhLOw-1; Tue, 01 Mar 2022 09:37:13 -0500
X-MC-Unique: U-OsYJiTNf2ZuTpzjRhLOw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3092F835DE0;
        Tue,  1 Mar 2022 14:37:12 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 213A9842C9;
        Tue,  1 Mar 2022 14:37:07 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v3 1/7] KVM: x86: nSVM: correctly virtualize LBR msrs when L2 is running
Date:   Tue,  1 Mar 2022 16:36:44 +0200
Message-Id: <20220301143650.143749-2-mlevitsk@redhat.com>
In-Reply-To: <20220301143650.143749-1-mlevitsk@redhat.com>
References: <20220301143650.143749-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When L2 is running without LBR virtualization, we should ensure
that L1's LBR msrs continue to update as usual.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 11 +++++
 arch/x86/kvm/svm/svm.c    | 98 +++++++++++++++++++++++++++++++--------
 arch/x86/kvm/svm/svm.h    |  2 +
 3 files changed, 92 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 96bab464967f2..d026f89ee94e6 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -564,6 +564,9 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		svm->vcpu.arch.dr6  = svm->nested.save.dr6 | DR6_ACTIVE_LOW;
 		vmcb_mark_dirty(svm->vmcb, VMCB_DR);
 	}
+
+	if (unlikely(svm->vmcb01.ptr->control.virt_ext & LBR_CTL_ENABLE_MASK))
+		svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
 }
 
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
@@ -621,6 +624,9 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
 	svm->vmcb->control.event_inj           = svm->nested.ctl.event_inj;
 	svm->vmcb->control.event_inj_err       = svm->nested.ctl.event_inj_err;
 
+	svm->vmcb->control.virt_ext            = svm->vmcb01.ptr->control.virt_ext &
+						 LBR_CTL_ENABLE_MASK;
+
 	nested_svm_transition_tlb_flush(vcpu);
 
 	/* Enter Guest-Mode */
@@ -883,6 +889,11 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	svm_switch_vmcb(svm, &svm->vmcb01);
 
+	if (unlikely(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
+		svm_copy_lbrs(svm->nested.vmcb02.ptr, svm->vmcb);
+		svm_update_lbrv(vcpu);
+	}
+
 	/*
 	 * On vmexit the  GIF is set to false and
 	 * no event can be injected in L1.
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7038c76fa8410..aa6c04d15d2a7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -803,6 +803,17 @@ static void init_msrpm_offsets(void)
 	}
 }
 
+void svm_copy_lbrs(struct vmcb *from_vmcb, struct vmcb *to_vmcb)
+{
+	to_vmcb->save.dbgctl		= from_vmcb->save.dbgctl;
+	to_vmcb->save.br_from		= from_vmcb->save.br_from;
+	to_vmcb->save.br_to		= from_vmcb->save.br_to;
+	to_vmcb->save.last_excp_from	= from_vmcb->save.last_excp_from;
+	to_vmcb->save.last_excp_to	= from_vmcb->save.last_excp_to;
+
+	vmcb_mark_dirty(to_vmcb, VMCB_LBR);
+}
+
 static void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
@@ -812,6 +823,10 @@ static void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 1, 1);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 1, 1);
+
+	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
+	if (is_guest_mode(vcpu))
+		svm_copy_lbrs(svm->vmcb01.ptr, svm->vmcb);
 }
 
 static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
@@ -823,6 +838,63 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTBRANCHTOIP, 0, 0);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTFROMIP, 0, 0);
 	set_msr_interception(vcpu, svm->msrpm, MSR_IA32_LASTINTTOIP, 0, 0);
+
+	/*
+	 * Move the LBR msrs back to the vmcb01 to avoid copying them
+	 * on nested guest entries.
+	 */
+	if (is_guest_mode(vcpu))
+		svm_copy_lbrs(svm->vmcb, svm->vmcb01.ptr);
+}
+
+static int svm_get_lbr_msr(struct vcpu_svm *svm, u32 index)
+{
+	/*
+	 * If the LBR virtualization is disabled, the LBR msrs are always
+	 * kept in the vmcb01 to avoid copying them on nested guest entries.
+	 *
+	 * If nested, and the LBR virtualization is enabled/disabled, the msrs
+	 * are moved between the vmcb01 and vmcb02 as needed.
+	 */
+	struct vmcb *vmcb =
+		(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) ?
+			svm->vmcb : svm->vmcb01.ptr;
+
+	switch (index) {
+	case MSR_IA32_DEBUGCTLMSR:
+		return vmcb->save.dbgctl;
+	case MSR_IA32_LASTBRANCHFROMIP:
+		return vmcb->save.br_from;
+	case MSR_IA32_LASTBRANCHTOIP:
+		return vmcb->save.br_to;
+	case MSR_IA32_LASTINTFROMIP:
+		return vmcb->save.last_excp_from;
+	case MSR_IA32_LASTINTTOIP:
+		return vmcb->save.last_excp_to;
+	default:
+		KVM_BUG(false, svm->vcpu.kvm,
+			"%s: Unknown MSR 0x%x", __func__, index);
+		return 0;
+	}
+}
+
+void svm_update_lbrv(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_svm *svm = to_svm(vcpu);
+
+	bool enable_lbrv = svm_get_lbr_msr(svm, MSR_IA32_DEBUGCTLMSR) &
+					   DEBUGCTLMSR_LBR;
+
+	bool current_enable_lbrv = !!(svm->vmcb->control.virt_ext &
+				      LBR_CTL_ENABLE_MASK);
+
+	if (enable_lbrv == current_enable_lbrv)
+		return;
+
+	if (enable_lbrv)
+		svm_enable_lbrv(vcpu);
+	else
+		svm_disable_lbrv(vcpu);
 }
 
 void disable_nmi_singlestep(struct vcpu_svm *svm)
@@ -2588,25 +2660,12 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_TSC_AUX:
 		msr_info->data = svm->tsc_aux;
 		break;
-	/*
-	 * Nobody will change the following 5 values in the VMCB so we can
-	 * safely return them on rdmsr. They will always be 0 until LBRV is
-	 * implemented.
-	 */
 	case MSR_IA32_DEBUGCTLMSR:
-		msr_info->data = svm->vmcb->save.dbgctl;
-		break;
 	case MSR_IA32_LASTBRANCHFROMIP:
-		msr_info->data = svm->vmcb->save.br_from;
-		break;
 	case MSR_IA32_LASTBRANCHTOIP:
-		msr_info->data = svm->vmcb->save.br_to;
-		break;
 	case MSR_IA32_LASTINTFROMIP:
-		msr_info->data = svm->vmcb->save.last_excp_from;
-		break;
 	case MSR_IA32_LASTINTTOIP:
-		msr_info->data = svm->vmcb->save.last_excp_to;
+		msr_info->data = svm_get_lbr_msr(svm, msr_info->index);
 		break;
 	case MSR_VM_HSAVE_PA:
 		msr_info->data = svm->nested.hsave_msr;
@@ -2837,12 +2896,13 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		if (data & DEBUGCTL_RESERVED_BITS)
 			return 1;
 
-		svm->vmcb->save.dbgctl = data;
-		vmcb_mark_dirty(svm->vmcb, VMCB_LBR);
-		if (data & (1ULL<<0))
-			svm_enable_lbrv(vcpu);
+		if (svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK)
+			svm->vmcb->save.dbgctl = data;
 		else
-			svm_disable_lbrv(vcpu);
+			svm->vmcb01.ptr->save.dbgctl = data;
+
+		svm_update_lbrv(vcpu);
+
 		break;
 	case MSR_VM_HSAVE_PA:
 		/*
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 70850cbe5bcb5..2d0487968cba4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -488,6 +488,8 @@ u32 svm_msrpm_offset(u32 msr);
 u32 *svm_vcpu_alloc_msrpm(void);
 void svm_vcpu_init_msrpm(struct kvm_vcpu *vcpu, u32 *msrpm);
 void svm_vcpu_free_msrpm(u32 *msrpm);
+void svm_copy_lbrs(struct vmcb *from_vmcb, struct vmcb *to_vmcb);
+void svm_update_lbrv(struct kvm_vcpu *vcpu);
 
 int svm_set_efer(struct kvm_vcpu *vcpu, u64 efer);
 void svm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
-- 
2.26.3

