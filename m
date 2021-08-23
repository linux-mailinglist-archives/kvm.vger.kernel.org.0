Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9357B3F4A06
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 13:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbhHWLra (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 07:47:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60548 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236269AbhHWLrY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 07:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629719200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L+pQjb1/mMjT1TIEssLrWNAUqmp09RD1K/ELCisV2Aw=;
        b=I491CjE+kZjdrpR0GkchIZzVNrE6YtfjS8VX0Kah2ryr3xC3lE/y8a92/lenSj82uwZUR0
        uL+1xDLxTmsdVWEPGbaFwYNvwOpEFSAhL51YZvLWQVoCMuE0LsAbmvoV2NNgPJpXrea0bM
        qElBK3mAHQxCdGhJIKtgYQi2Xm/YIeo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-144-F0BIXbT7PTq3C4FbDLBYLA-1; Mon, 23 Aug 2021 07:46:39 -0400
X-MC-Unique: F0BIXbT7PTq3C4FbDLBYLA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D14D1008067;
        Mon, 23 Aug 2021 11:46:38 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 18B0B5F707;
        Mon, 23 Aug 2021 11:46:32 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v2 3/3] KVM: nSVM: call KVM_REQ_GET_NESTED_STATE_PAGES on exit from SMM mode
Date:   Mon, 23 Aug 2021 14:46:18 +0300
Message-Id: <20210823114618.1184209-4-mlevitsk@redhat.com>
In-Reply-To: <20210823114618.1184209-1-mlevitsk@redhat.com>
References: <20210823114618.1184209-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This allows nested SVM code to be more similar to nested VMX code.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 9 ++++++---
 arch/x86/kvm/svm/svm.c    | 8 +++++++-
 arch/x86/kvm/svm/svm.h    | 3 ++-
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5e13357da21e..678fd21f6077 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -572,7 +572,7 @@ static void nested_svm_copy_common_state(struct vmcb *from_vmcb, struct vmcb *to
 }
 
 int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
-			 struct vmcb *vmcb12)
+			 struct vmcb *vmcb12, bool from_entry)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	int ret;
@@ -602,13 +602,16 @@ int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb12_gpa,
 	nested_vmcb02_prepare_save(svm, vmcb12);
 
 	ret = nested_svm_load_cr3(&svm->vcpu, vmcb12->save.cr3,
-				  nested_npt_enabled(svm), true);
+				  nested_npt_enabled(svm), from_entry);
 	if (ret)
 		return ret;
 
 	if (!npt_enabled)
 		vcpu->arch.mmu->inject_page_fault = svm_inject_page_fault_nested;
 
+	if (!from_entry)
+		kvm_make_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
+
 	svm_set_gif(svm, true);
 
 	return 0;
@@ -674,7 +677,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 
 	svm->nested.nested_run_pending = 1;
 
-	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12))
+	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
 		goto out_exit_err;
 
 	if (nested_svm_vmrun_msrpm(svm))
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index ea7a4dacd42f..76ee15af8c48 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4354,6 +4354,12 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 			if (svm_allocate_nested(svm))
 				return 1;
 
+			/* Exit from the SMM to the non root mode also uses
+			 * the KVM_REQ_GET_NESTED_STATE_PAGES request,
+			 * but in this case the pdptrs must be always reloaded
+			 */
+			vcpu->arch.pdptrs_from_userspace = false;
+
 			/*
 			 * Restore L1 host state from L1 HSAVE area as VMCB01 was
 			 * used during SMM (see svm_enter_smm())
@@ -4368,7 +4374,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 
 			vmcb12 = map.hva;
 			nested_load_control_from_vmcb12(svm, &vmcb12->control);
-			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
+			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, false);
 
 			kvm_vcpu_unmap(vcpu, &map, true);
 			kvm_vcpu_unmap(vcpu, &map_save, true);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 524d943f3efc..51ffa46ab257 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -459,7 +459,8 @@ static inline bool nested_exit_on_nmi(struct vcpu_svm *svm)
 	return vmcb_is_intercept(&svm->nested.ctl, INTERCEPT_NMI);
 }
 
-int enter_svm_guest_mode(struct kvm_vcpu *vcpu, u64 vmcb_gpa, struct vmcb *vmcb12);
+int enter_svm_guest_mode(struct kvm_vcpu *vcpu,
+		u64 vmcb_gpa, struct vmcb *vmcb12, bool from_entry);
 void svm_leave_nested(struct vcpu_svm *svm);
 void svm_free_nested(struct vcpu_svm *svm);
 int svm_allocate_nested(struct vcpu_svm *svm);
-- 
2.26.3

