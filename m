Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0EDE1DBB3D
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 19:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgETRWv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 13:22:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31373 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728201AbgETRWZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 13:22:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589995343;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=sA7KU69CrSpCKwMi1qZQq/oq6j1VkGR88tbNNKk0nb4=;
        b=hvhq1ZBFi1SZTsZmZcVlrX1i3lC2pmJp1wFJ4NyprIKCtB1KGfG09EFqSLO2rSQloVNQdO
        A67PqpQ5W2UT9aD1fJy81orgPAUjPP9yuJSbM/NXJclVDnfGOHso/m7+bWC8ZPakW7apTv
        Sy0fsIhkHN9IN0jlDiEObLIqQS2mcPo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-286-fKrAhJzsNRe3nmIDSTmG8Q-1; Wed, 20 May 2020 13:22:17 -0400
X-MC-Unique: fKrAhJzsNRe3nmIDSTmG8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B50AA1009639;
        Wed, 20 May 2020 17:22:12 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AD66760554;
        Wed, 20 May 2020 17:22:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 21/24] KVM: x86: always update CR3 in VMCB
Date:   Wed, 20 May 2020 13:21:42 -0400
Message-Id: <20200520172145.23284-22-pbonzini@redhat.com>
In-Reply-To: <20200520172145.23284-1-pbonzini@redhat.com>
References: <20200520172145.23284-1-pbonzini@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_load_mmu_pgd is delaying the write of GUEST_CR3 to prepare_vmcs02 as
an optimization, but this is only correct before the nested vmentry.
If userspace is modifying CR3 with KVM_SET_SREGS after the VM has
already been put in guest mode, the value of CR3 will not be updated.
Remove the optimization, which almost never triggers anyway.

This also applies to SVM, where the code was added in commit 689f3bf21628
("KVM: x86: unify callbacks to load paging root", 2020-03-16) just to keep the
two vendor-specific modules closer.

Fixes: 04f11ef45810 ("KVM: nVMX: Always write vmcs02.GUEST_CR3 during nested VM-Enter")
Fixes: 689f3bf21628 ("KVM: x86: unify callbacks to load paging root")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/nested.c |  6 +-----
 arch/x86/kvm/svm/svm.c    | 16 +++++-----------
 arch/x86/kvm/vmx/vmx.c    |  5 +----
 3 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 19b6a7c954e8..087a04ae74e4 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -260,11 +260,7 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
 	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
 	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
 	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
-	if (npt_enabled) {
-		svm->vmcb->save.cr3 = nested_vmcb->save.cr3;
-		svm->vcpu.arch.cr3 = nested_vmcb->save.cr3;
-	} else
-		(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
+	(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
 
 	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
 	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index d8187d25fe04..56be704ffe95 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3465,7 +3465,6 @@ static fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
 static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	bool update_guest_cr3 = true;
 	unsigned long cr3;
 
 	cr3 = __sme_set(root);
@@ -3474,18 +3473,13 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root)
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
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 55712dd86baf..7daf6a50e774 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3085,10 +3085,7 @@ void vmx_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long pgd)
 			spin_unlock(&to_kvm_vmx(kvm)->ept_pointer_lock);
 		}
 
-		/* Loading vmcs02.GUEST_CR3 is handled by nested VM-Enter. */
-		if (is_guest_mode(vcpu))
-			update_guest_cr3 = false;
-		else if (!enable_unrestricted_guest && !is_paging(vcpu))
+		if (!enable_unrestricted_guest && !is_paging(vcpu))
 			guest_cr3 = to_kvm_vmx(kvm)->ept_identity_map_addr;
 		else if (test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
 			guest_cr3 = vcpu->arch.cr3;
-- 
2.18.2


