Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB09F24BEF0
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 15:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbgHTNeC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 09:34:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54087 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729652AbgHTNd7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 09:33:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597930437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5tbhuoH+F/XUvQIBkdLHlm/rrWGTVjd0gX2q0SKCOLw=;
        b=cwXn0d/llRBeHFA9ZV12rXnBtfm3hfVTiVZ4vmgJ4Bg+B4dnwTSj7fw5kYsGPkwu9VMHNF
        5SrVkIjuaHfK2GhdDdJ486bo0Cba4hwb+bsh3jyjrd9xgzp+65wlWsddJb+fdiwT1K8jbd
        FI75wPxXTb6hyRxPyTfzxmiyi7rDw4I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-tkYdtdCwNCu2YNU4M6-V7Q-1; Thu, 20 Aug 2020 09:33:53 -0400
X-MC-Unique: tkYdtdCwNCu2YNU4M6-V7Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8519A801AE8;
        Thu, 20 Aug 2020 13:33:51 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 20BEB16E25;
        Thu, 20 Aug 2020 13:33:47 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 2/7] KVM: nSVM: rename nested 'vmcb' to vmcb12_gpa in few places
Date:   Thu, 20 Aug 2020 16:33:34 +0300
Message-Id: <20200820133339.372823-3-mlevitsk@redhat.com>
In-Reply-To: <20200820133339.372823-1-mlevitsk@redhat.com>
References: <20200820133339.372823-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No functional changes.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 10 +++++-----
 arch/x86/kvm/svm/svm.c    | 13 +++++++------
 arch/x86/kvm/svm/svm.h    |  2 +-
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index fb68467e6049..f5b17920a2ca 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -431,7 +431,7 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 {
 	int ret;
 
-	svm->nested.vmcb = vmcb_gpa;
+	svm->nested.vmcb12_gpa = vmcb_gpa;
 	load_nested_vmcb_control(svm, &nested_vmcb->control);
 	nested_prepare_vmcb_save(svm, nested_vmcb);
 	nested_prepare_vmcb_control(svm);
@@ -568,7 +568,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	struct vmcb *vmcb = svm->vmcb;
 	struct kvm_host_map map;
 
-	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb), &map);
+	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb12_gpa), &map);
 	if (rc) {
 		if (rc == -EINVAL)
 			kvm_inject_gp(&svm->vcpu, 0);
@@ -579,7 +579,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	/* Exit Guest-Mode */
 	leave_guest_mode(&svm->vcpu);
-	svm->nested.vmcb = 0;
+	svm->nested.vmcb12_gpa = 0;
 	WARN_ON_ONCE(svm->nested.nested_run_pending);
 
 	/* in case we halted in L2 */
@@ -1018,7 +1018,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 
 	/* First fill in the header and copy it out.  */
 	if (is_guest_mode(vcpu)) {
-		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb;
+		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb12_gpa;
 		kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
 		kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
 
@@ -1128,7 +1128,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
 	hsave->save = save;
 
-	svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
+	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
 	load_nested_vmcb_control(svm, &ctl);
 	nested_prepare_vmcb_control(svm);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 562a79e3e63a..d33013b9b4d7 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1102,7 +1102,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	}
 	svm->asid_generation = 0;
 
-	svm->nested.vmcb = 0;
+	svm->nested.vmcb12_gpa = 0;
 	svm->vcpu.arch.hflags = 0;
 
 	if (!kvm_pause_in_guest(svm->vcpu.kvm)) {
@@ -3884,7 +3884,7 @@ static int svm_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 		/* FED8h - SVM Guest */
 		put_smstate(u64, smstate, 0x7ed8, 1);
 		/* FEE0h - SVM Guest VMCB Physical Address */
-		put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb);
+		put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb12_gpa);
 
 		svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
 		svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
@@ -3903,17 +3903,18 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	struct vmcb *nested_vmcb;
 	struct kvm_host_map map;
 	u64 guest;
-	u64 vmcb;
+	u64 vmcb12_gpa;
 	int ret = 0;
 
 	guest = GET_SMSTATE(u64, smstate, 0x7ed8);
-	vmcb = GET_SMSTATE(u64, smstate, 0x7ee0);
+	vmcb12_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
 
 	if (guest) {
-		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb), &map) == -EINVAL)
+		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb12_gpa), &map) == -EINVAL)
 			return 1;
+
 		nested_vmcb = map.hva;
-		ret = enter_svm_guest_mode(svm, vmcb, nested_vmcb);
+		ret = enter_svm_guest_mode(svm, vmcb12_gpa, nested_vmcb);
 		kvm_vcpu_unmap(&svm->vcpu, &map, true);
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a798e1731709..ab913468f9cb 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -85,7 +85,7 @@ struct svm_nested_state {
 	struct vmcb *hsave;
 	u64 hsave_msr;
 	u64 vm_cr_msr;
-	u64 vmcb;
+	u64 vmcb12_gpa;
 	u32 host_intercept_exceptions;
 
 	/* These are the merged vectors */
-- 
2.26.2

