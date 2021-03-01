Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71E53290D2
	for <lists+kvm@lfdr.de>; Mon,  1 Mar 2021 21:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbhCAUQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 15:16:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:49949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241170AbhCAUKV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Mar 2021 15:10:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614629329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=DeZRAZaCcq5fOAnPyHfLItpaonWuUNdGVglPpA6ptmQ=;
        b=NoDoisBQX8cueJ+5Fl8Y38EmJEAtj1Ylzz+pM0KXsMJLzyLGGk3wHfIzaRUX5QgJ5hgsVX
        TK1MmktRjxVfUJIa2Sw9dwEo9svK8HHyLNVVNvnQbqZ2oByXG63YqJkN7pU3X2lsl9Il5m
        C9cczjmCW+irc03PIDRfDkB8JTH3g1Q=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-JYFXC9iyNFCbyNZVNyRsNQ-1; Mon, 01 Mar 2021 15:08:46 -0500
X-MC-Unique: JYFXC9iyNFCbyNZVNyRsNQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C355D801978;
        Mon,  1 Mar 2021 20:08:45 +0000 (UTC)
Received: from virtlab710.virt.lab.eng.bos.redhat.com (virtlab710.virt.lab.eng.bos.redhat.com [10.19.152.252])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 45FEF5C1C4;
        Mon,  1 Mar 2021 20:08:45 +0000 (UTC)
From:   Cathy Avery <cavery@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com
Cc:     vkuznets@redhat.com, wei.huang2@amd.com
Subject: [PATCH] KVM: nSVM: Optimize L12 to L2 vmcb.save copies
Date:   Mon,  1 Mar 2021 15:08:44 -0500
Message-Id: <20210301200844.2000-1-cavery@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the vmcb12 control clean field to determine which vmcb12.save
registers were marked dirty in order to minimize register copies
when switching from L1 to L2. Those L12 registers marked as dirty need
to be copied to L2's vmcb as they will be used to update the vmcb
state cache for the L2 VMRUN.  In the case where we have a different
vmcb12 from the last L2 VMRUN all vmcb12.save registers must be
copied over to L2.save.

Tested:
kvm-unit-tests
kvm selftests
Fedora L1 L2

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Cathy Avery <cavery@redhat.com>
---
 arch/x86/kvm/svm/nested.c | 43 ++++++++++++++++++++++++++-------------
 arch/x86/kvm/svm/svm.c    |  1 +
 arch/x86/kvm/svm/svm.h    |  6 ++++++
 3 files changed, 36 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 90a1704b5752..c1d5944ee473 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -422,39 +422,54 @@ void nested_vmcb02_compute_g_pat(struct vcpu_svm *svm)
 
 static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
+	bool new_vmcb12 = false;
+
 	nested_vmcb02_compute_g_pat(svm);
 
 	/* Load the nested guest state */
-	svm->vmcb->save.es = vmcb12->save.es;
-	svm->vmcb->save.cs = vmcb12->save.cs;
-	svm->vmcb->save.ss = vmcb12->save.ss;
-	svm->vmcb->save.ds = vmcb12->save.ds;
-	svm->vmcb->save.cpl = vmcb12->save.cpl;
-	vmcb_mark_dirty(svm->vmcb, VMCB_SEG);
 
-	svm->vmcb->save.gdtr = vmcb12->save.gdtr;
-	svm->vmcb->save.idtr = vmcb12->save.idtr;
-	vmcb_mark_dirty(svm->vmcb, VMCB_DT);
+	if (svm->nested.vmcb12_gpa != svm->nested.last_vmcb12_gpa) {
+		new_vmcb12 = true;
+		svm->nested.last_vmcb12_gpa = svm->nested.vmcb12_gpa;
+	}
+
+	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_SEG))) {
+		svm->vmcb->save.es = vmcb12->save.es;
+		svm->vmcb->save.cs = vmcb12->save.cs;
+		svm->vmcb->save.ss = vmcb12->save.ss;
+		svm->vmcb->save.ds = vmcb12->save.ds;
+		svm->vmcb->save.cpl = vmcb12->save.cpl;
+		vmcb_mark_dirty(svm->vmcb, VMCB_SEG);
+	}
+
+	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DT))) {
+		svm->vmcb->save.gdtr = vmcb12->save.gdtr;
+		svm->vmcb->save.idtr = vmcb12->save.idtr;
+		vmcb_mark_dirty(svm->vmcb, VMCB_DT);
+	}
 
 	kvm_set_rflags(&svm->vcpu, vmcb12->save.rflags | X86_EFLAGS_FIXED);
 	svm_set_efer(&svm->vcpu, vmcb12->save.efer);
 	svm_set_cr0(&svm->vcpu, vmcb12->save.cr0);
 	svm_set_cr4(&svm->vcpu, vmcb12->save.cr4);
 
-	svm->vcpu.arch.cr2 = vmcb12->save.cr2;
+	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = vmcb12->save.cr2;
+
 	kvm_rax_write(&svm->vcpu, vmcb12->save.rax);
 	kvm_rsp_write(&svm->vcpu, vmcb12->save.rsp);
 	kvm_rip_write(&svm->vcpu, vmcb12->save.rip);
 
 	/* In case we don't even reach vcpu_run, the fields are not updated */
-	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2;
 	svm->vmcb->save.rax = vmcb12->save.rax;
 	svm->vmcb->save.rsp = vmcb12->save.rsp;
 	svm->vmcb->save.rip = vmcb12->save.rip;
 
-	svm->vmcb->save.dr7 = vmcb12->save.dr7 | DR7_FIXED_1;
-	svm->vcpu.arch.dr6  = vmcb12->save.dr6 | DR6_ACTIVE_LOW;
-	vmcb_mark_dirty(svm->vmcb, VMCB_DR);
+	/* These bits will be set properly on the first execution when new_vmc12 is true */
+	if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_DR))) {
+		svm->vmcb->save.dr7 = vmcb12->save.dr7 | DR7_FIXED_1;
+		svm->vcpu.arch.dr6  = vmcb12->save.dr6 | DR6_ACTIVE_LOW;
+		vmcb_mark_dirty(svm->vmcb, VMCB_DR);
+	}
 }
 
 static void nested_vmcb02_prepare_control(struct vcpu_svm *svm)
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 54610270f66a..9761a7ca8100 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1232,6 +1232,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	svm->asid = 0;
 
 	svm->nested.vmcb12_gpa = 0;
+	svm->nested.last_vmcb12_gpa = 0;
 	vcpu->arch.hflags = 0;
 
 	if (!kvm_pause_in_guest(vcpu->kvm)) {
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index fbbb26dd0f73..911868d4584c 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -93,6 +93,7 @@ struct svm_nested_state {
 	u64 hsave_msr;
 	u64 vm_cr_msr;
 	u64 vmcb12_gpa;
+	u64 last_vmcb12_gpa;
 
 	/* These are the merged vectors */
 	u32 *msrpm;
@@ -247,6 +248,11 @@ static inline void vmcb_mark_dirty(struct vmcb *vmcb, int bit)
 	vmcb->control.clean &= ~(1 << bit);
 }
 
+static inline bool vmcb_is_dirty(struct vmcb *vmcb, int bit)
+{
+        return !test_bit(bit, (unsigned long *)&vmcb->control.clean);
+}
+
 static inline struct vcpu_svm *to_svm(struct kvm_vcpu *vcpu)
 {
 	return container_of(vcpu, struct vcpu_svm, vcpu);
-- 
2.26.2

