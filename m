Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB40424B1ED
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 11:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbgHTJP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 05:15:57 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:27516 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726858AbgHTJNp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 05:13:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597914824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XTgJpN7YBqdgGpVTTMCcG6iRYP305urLEHU/3AJMw1s=;
        b=T97tt5QszDK+e2gW4/dETxCbzwRp+ckWqXkJHdL6zYaJEzoOSiTsxwGVm+FwEFW3xnra7F
        TXsYmo64nlLI6GQFfyDXSNzoJeuqnlVrWEPMKH7z/G17AMQuXN8ShcaYFPmzFvafIhi3Ap
        sPitRa1MrZT3YvtEzNKzK7YaR1N1dH4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-245-RrrfPBadO56fKwzoLAQwrQ-1; Thu, 20 Aug 2020 05:13:42 -0400
X-MC-Unique: RrrfPBadO56fKwzoLAQwrQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BD494801AAF;
        Thu, 20 Aug 2020 09:13:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.173])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B4E5747B0;
        Thu, 20 Aug 2020 09:13:37 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 2/8] KVM: nSVM: rename nested 'vmcb' to vmcb_gpa in few places
Date:   Thu, 20 Aug 2020 12:13:21 +0300
Message-Id: <20200820091327.197807-3-mlevitsk@redhat.com>
In-Reply-To: <20200820091327.197807-1-mlevitsk@redhat.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
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
index fb68467e6049..d9755eab2199 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -431,7 +431,7 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 {
 	int ret;
 
-	svm->nested.vmcb = vmcb_gpa;
+	svm->nested.vmcb_gpa = vmcb_gpa;
 	load_nested_vmcb_control(svm, &nested_vmcb->control);
 	nested_prepare_vmcb_save(svm, nested_vmcb);
 	nested_prepare_vmcb_control(svm);
@@ -568,7 +568,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	struct vmcb *vmcb = svm->vmcb;
 	struct kvm_host_map map;
 
-	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb), &map);
+	rc = kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(svm->nested.vmcb_gpa), &map);
 	if (rc) {
 		if (rc == -EINVAL)
 			kvm_inject_gp(&svm->vcpu, 0);
@@ -579,7 +579,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 
 	/* Exit Guest-Mode */
 	leave_guest_mode(&svm->vcpu);
-	svm->nested.vmcb = 0;
+	svm->nested.vmcb_gpa = 0;
 	WARN_ON_ONCE(svm->nested.nested_run_pending);
 
 	/* in case we halted in L2 */
@@ -1018,7 +1018,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 
 	/* First fill in the header and copy it out.  */
 	if (is_guest_mode(vcpu)) {
-		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb;
+		kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb_gpa;
 		kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
 		kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
 
@@ -1128,7 +1128,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 	copy_vmcb_control_area(&hsave->control, &svm->vmcb->control);
 	hsave->save = save;
 
-	svm->nested.vmcb = kvm_state->hdr.svm.vmcb_pa;
+	svm->nested.vmcb_gpa = kvm_state->hdr.svm.vmcb_pa;
 	load_nested_vmcb_control(svm, &ctl);
 	nested_prepare_vmcb_control(svm);
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 562a79e3e63a..4338d2a2596e 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1102,7 +1102,7 @@ static void init_vmcb(struct vcpu_svm *svm)
 	}
 	svm->asid_generation = 0;
 
-	svm->nested.vmcb = 0;
+	svm->nested.vmcb_gpa = 0;
 	svm->vcpu.arch.hflags = 0;
 
 	if (!kvm_pause_in_guest(svm->vcpu.kvm)) {
@@ -3884,7 +3884,7 @@ static int svm_pre_enter_smm(struct kvm_vcpu *vcpu, char *smstate)
 		/* FED8h - SVM Guest */
 		put_smstate(u64, smstate, 0x7ed8, 1);
 		/* FEE0h - SVM Guest VMCB Physical Address */
-		put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb);
+		put_smstate(u64, smstate, 0x7ee0, svm->nested.vmcb_gpa);
 
 		svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
 		svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
@@ -3903,17 +3903,18 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
 	struct vmcb *nested_vmcb;
 	struct kvm_host_map map;
 	u64 guest;
-	u64 vmcb;
+	u64 vmcb_gpa;
 	int ret = 0;
 
 	guest = GET_SMSTATE(u64, smstate, 0x7ed8);
-	vmcb = GET_SMSTATE(u64, smstate, 0x7ee0);
+	vmcb_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
 
 	if (guest) {
-		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb), &map) == -EINVAL)
+		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map) == -EINVAL)
 			return 1;
+
 		nested_vmcb = map.hva;
-		ret = enter_svm_guest_mode(svm, vmcb, nested_vmcb);
+		ret = enter_svm_guest_mode(svm, vmcb_gpa, nested_vmcb);
 		kvm_vcpu_unmap(&svm->vcpu, &map, true);
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index a798e1731709..03f2f082ef10 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -85,7 +85,7 @@ struct svm_nested_state {
 	struct vmcb *hsave;
 	u64 hsave_msr;
 	u64 vm_cr_msr;
-	u64 vmcb;
+	u64 vmcb_gpa;
 	u32 host_intercept_exceptions;
 
 	/* These are the merged vectors */
-- 
2.26.2

