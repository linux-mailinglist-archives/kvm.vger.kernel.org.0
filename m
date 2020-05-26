Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58181E28AE
	for <lists+kvm@lfdr.de>; Tue, 26 May 2020 19:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389128AbgEZRXV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 May 2020 13:23:21 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:45270 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388979AbgEZRXS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 May 2020 13:23:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590513796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HyUo5osn8O60giU9X+BI43bKXabBUWmHM+tPt7Ss3Cs=;
        b=BQFZW3GbIvAdbthhyuuc8oy7PJiZe1hrVpiOb871z4VlQJ618ELZvKzxPudHu1ch4fKYqC
        8TJ1U5kpoWfJfP7PLTbqhrZOu4gJhhVjCBxX32rbhQk4oBQESM1KnFWikU9q1dVCUsz8np
        QCWzTAvDjGk0MfGBOFzzltB8Id3LQtk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-yT8TsOWuOcOqxk2CWRgDYA-1; Tue, 26 May 2020 13:23:14 -0400
X-MC-Unique: yT8TsOWuOcOqxk2CWRgDYA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A940C107ACF6;
        Tue, 26 May 2020 17:23:13 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2076E10013DB;
        Tue, 26 May 2020 17:23:13 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH 06/28] KVM: SVM: always update CR3 in VMCB
Date:   Tue, 26 May 2020 13:22:46 -0400
Message-Id: <20200526172308.111575-7-pbonzini@redhat.com>
In-Reply-To: <20200526172308.111575-1-pbonzini@redhat.com>
References: <20200526172308.111575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

svm_load_mmu_pgd is delaying the write of GUEST_CR3 to prepare_vmcs02 as
an optimization, but this is only correct before the nested vmentry.
If userspace is modifying CR3 with KVM_SET_SREGS after the VM has
already been put in guest mode, the value of CR3 will not be updated.
Remove the optimization, which almost never triggers anyway.
This was was added in commit 689f3bf21628 ("KVM: x86: unify callbacks
to load paging root", 2020-03-16) just to keep the two vendor-specific
modules closer, but we'll fix VMX too.

Fixes: 689f3bf21628 ("KVM: x86: unify callbacks to load paging root")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c |  6 +-----
 arch/x86/kvm/svm/svm.c    | 16 +++++-----------
 2 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 166b88fc9509..81e0fbd5e267 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -256,11 +256,7 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
 	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
 	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
 	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
-	if (npt_enabled) {
-		svm->vmcb->save.cr3 = nested_vmcb->save.cr3;
-		svm->vcpu.arch.cr3 = nested_vmcb->save.cr3;
-	} else
-		(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
+	(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
 
 	/* Guest paging mode is active - reset mmu */
 	kvm_mmu_reset_context(&svm->vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 270061fa6cfa..abe277a3216b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3447,7 +3447,6 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	bool update_guest_cr3 = true;
 	unsigned long cr3;
 
 	cr3 = __sme_set(root);
@@ -3456,18 +3455,13 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root)
 		mark_dirty(svm->vmcb, VMCB_NPT);
 
 		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
-		if (is_guest_mode(vcpu))
-			update_guest_cr3 = false;
-		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
-			cr3 = vcpu->arch.cr3;
-		else /* CR3 is already up-to-date.  */
-			update_guest_cr3 = false;
+		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
+			return;
+		cr3 = vcpu->arch.cr3;
 	}
 
-	if (update_guest_cr3) {
-		svm->vmcb->save.cr3 = cr3;
-		mark_dirty(svm->vmcb, VMCB_CR);
-	}
+	svm->vmcb->save.cr3 = cr3;
+	mark_dirty(svm->vmcb, VMCB_CR);
 }
 
 static int is_disabled(void)
-- 
2.26.2


