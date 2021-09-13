Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C644092E6
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 16:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344303AbhIMOQ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 10:16:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33967 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344402AbhIMOLX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 10:11:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631542207;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mQ6CJL6x0uNKYfYGzFiEUsEyGvjG7GOIKW+WA7LhBjY=;
        b=JMeb5DRTB4r8CbcSjZ4VOiw7tdSpCHZzH33hpWIxzqhCWyRBpy9s5beTHRdevcKBZMQo8A
        Lqqso173mfL1h6Ujaf6hm4jbu41G+lBNFlu07RHuV58xGTkiNjY7Ej1b3BomuPmnuhqq5Q
        NroQjCVYi0YPUH1r0qpyvSWdL36uyrI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-XHHbKISGOyaca8tGCBOSYg-1; Mon, 13 Sep 2021 10:10:05 -0400
X-MC-Unique: XHHbKISGOyaca8tGCBOSYg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E173A1800D41;
        Mon, 13 Sep 2021 14:10:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 78A1A19724;
        Mon, 13 Sep 2021 14:10:00 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3 1/7] KVM: x86: nSVM: refactor svm_leave_smm and smm_enter_smm
Date:   Mon, 13 Sep 2021 17:09:48 +0300
Message-Id: <20210913140954.165665-2-mlevitsk@redhat.com>
In-Reply-To: <20210913140954.165665-1-mlevitsk@redhat.com>
References: <20210913140954.165665-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use return statements instead of nested if, and fix error
path to free all the maps that were allocated.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 129 +++++++++++++++++++++--------------------
 1 file changed, 65 insertions(+), 64 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1a70e11f0487..a75dafbfa4a6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4284,43 +4284,44 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 	struct kvm_host_map map_save;
 	int ret;
 
-	if (is_guest_mode(vcpu)) {
-		/* FED8h - SVM Guest */
-		put_smstate(u64, smstate, 0x7ed8, 1);
-		/* FEE0h - SVM Guest VMCB Physical Address */
-		put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb12_gpa);
+	if (!is_guest_mode(vcpu))
+		return 0;
 
-		svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
-		svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
-		svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
+	/* FED8h - SVM Guest */
+	put_smstate(u64, smstate, 0x7ed8, 1);
+	/* FEE0h - SVM Guest VMCB Physical Address */
+	put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb12_gpa);
 
-		ret = nested_svm_vmexit(svm);
-		if (ret)
-			return ret;
+	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
+	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
+	svm->vmcb->save.rip = vcpu->arch.regs[VCPU_REGS_RIP];
 
-		/*
-		 * KVM uses VMCB01 to store L1 host state while L2 runs but
-		 * VMCB01 is going to be used during SMM and thus the state will
-		 * be lost. Temporary save non-VMLOAD/VMSAVE state to the host save
-		 * area pointed to by MSR_VM_HSAVE_PA. APM guarantees that the
-		 * format of the area is identical to guest save area offsetted
-		 * by 0x400 (matches the offset of 'struct vmcb_save_area'
-		 * within 'struct vmcb'). Note: HSAVE area may also be used by
-		 * L1 hypervisor to save additional host context (e.g. KVM does
-		 * that, see svm_prepare_guest_switch()) which must be
-		 * preserved.
-		 */
-		if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.hsave_msr),
-				 &map_save) == -EINVAL)
-			return 1;
+	ret = nested_svm_vmexit(svm);
+	if (ret)
+		return ret;
+
+	/*
+	 * KVM uses VMCB01 to store L1 host state while L2 runs but
+	 * VMCB01 is going to be used during SMM and thus the state will
+	 * be lost. Temporary save non-VMLOAD/VMSAVE state to the host save
+	 * area pointed to by MSR_VM_HSAVE_PA. APM guarantees that the
+	 * format of the area is identical to guest save area offsetted
+	 * by 0x400 (matches the offset of 'struct vmcb_save_area'
+	 * within 'struct vmcb'). Note: HSAVE area may also be used by
+	 * L1 hypervisor to save additional host context (e.g. KVM does
+	 * that, see svm_prepare_guest_switch()) which must be
+	 * preserved.
+	 */
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.hsave_msr),
+			 &map_save) == -EINVAL)
+		return 1;
 
-		BUILD_BUG_ON(offsetof(struct vmcb, save) != 0x400);
+	BUILD_BUG_ON(offsetof(struct vmcb, save) != 0x400);
 
-		svm_copy_vmrun_state(map_save.hva + 0x400,
-				     &svm->vmcb01.ptr->save);
+	svm_copy_vmrun_state(map_save.hva + 0x400,
+			     &svm->vmcb01.ptr->save);
 
-		kvm_vcpu_unmap(vcpu, &map_save, true);
-	}
+	kvm_vcpu_unmap(vcpu, &map_save, true);
 	return 0;
 }
 
@@ -4328,50 +4329,50 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	struct kvm_host_map map, map_save;
-	int ret = 0;
-
-	if (guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
-		u64 saved_efer = GET_SMSTATE(u64, smstate, 0x7ed0);
-		u64 guest = GET_SMSTATE(u64, smstate, 0x7ed8);
-		u64 vmcb12_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
-		struct vmcb *vmcb12;
+	u64 saved_efer, vmcb12_gpa;
+	struct vmcb *vmcb12;
+	int ret;
 
-		if (guest) {
-			if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
-				return 1;
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
+		return 0;
 
-			if (!(saved_efer & EFER_SVME))
-				return 1;
+	/* Non-zero if SMI arrived while vCPU was in guest mode. */
+	if (!GET_SMSTATE(u64, smstate, 0x7ed8))
+		return 0;
 
-			if (kvm_vcpu_map(vcpu,
-					 gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
-				return 1;
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
+		return 1;
 
-			if (svm_allocate_nested(svm))
-				return 1;
+	saved_efer = GET_SMSTATE(u64, smstate, 0x7ed0);
+	if (!(saved_efer & EFER_SVME))
+		return 1;
 
-			vmcb12 = map.hva;
+	vmcb12_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
+		return 1;
 
-			nested_load_control_from_vmcb12(svm, &vmcb12->control);
+	ret = 1;
+	if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.hsave_msr), &map_save) == -EINVAL)
+		goto unmap_map;
 
-			ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
-			kvm_vcpu_unmap(vcpu, &map, true);
+	if (svm_allocate_nested(svm))
+		goto unmap_save;
 
-			/*
-			 * Restore L1 host state from L1 HSAVE area as VMCB01 was
-			 * used during SMM (see svm_enter_smm())
-			 */
-			if (kvm_vcpu_map(vcpu, gpa_to_gfn(svm->nested.hsave_msr),
-					 &map_save) == -EINVAL)
-				return 1;
+	vmcb12 = map.hva;
+	nested_load_control_from_vmcb12(svm, &vmcb12->control);
+	ret = enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12);
 
-			svm_copy_vmrun_state(&svm->vmcb01.ptr->save,
-					     map_save.hva + 0x400);
+	/*
+	 * Restore L1 host state from L1 HSAVE area as VMCB01 was
+	 * used during SMM (see svm_enter_smm())
+	 */
 
-			kvm_vcpu_unmap(vcpu, &map_save, true);
-		}
-	}
+	svm_copy_vmrun_state(&svm->vmcb01.ptr->save, map_save.hva + 0x400);
 
+unmap_save:
+	kvm_vcpu_unmap(vcpu, &map_save, true);
+unmap_map:
+	kvm_vcpu_unmap(vcpu, &map, true);
 	return ret;
 }
 
-- 
2.26.3

