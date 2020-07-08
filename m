Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC892183EB
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 11:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgGHJga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 05:36:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:36799 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728282AbgGHJg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 05:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594200985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0ch8uULRQ2eBy6MnhXZkwyEhlau2JCPGdpOTRmLuBXg=;
        b=i2XPVDZZdKu0Qpu7IRMuitqOxlILcCk/MvP+DDM74iWw98+swVyUH+i3ozWKvNrlarNdbT
        1+7uTUpoze7NnD/J9zAwm4Oe5k0HsE3jtAY3LGM60W8eO8dwx8POqY5afeUDzK/3KiZqqo
        HcogRi5g/CYYRItZxBdVG+2UDsl0rHU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-t0u0OeNXNfeWi3kqKl7lSw-1; Wed, 08 Jul 2020 05:36:21 -0400
X-MC-Unique: t0u0OeNXNfeWi3kqKl7lSw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C62C97BB1;
        Wed,  8 Jul 2020 09:36:19 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BA3D5C3F8;
        Wed,  8 Jul 2020 09:36:17 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] KVM: nSVM: properly call kvm_mmu_new_pgd() upon switching to guest
Date:   Wed,  8 Jul 2020 11:36:10 +0200
Message-Id: <20200708093611.1453618-3-vkuznets@redhat.com>
In-Reply-To: <20200708093611.1453618-1-vkuznets@redhat.com>
References: <20200708093611.1453618-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Undesired triple fault gets injected to L1 guest on SVM when L2 is
launched with certain CR3 values. #TF is raised by mmu_check_root()
check in fast_pgd_switch() and the root cause is that when
kvm_set_cr3() is called from nested_prepare_vmcb_save() with NPT
enabled CR3 points to a nGPA so we can't check it with
kvm_is_visible_gfn().

Calling kvm_mmu_new_pgd() with L2's CR3 idea when NPT is in use
seems to be wrong, an acceptable place for it seems to be
kvm_init_shadow_npt_mmu(). This also matches nVMX code.

Fixes: 7c390d350f8b ("kvm: x86: Add fast CR3 switch code path")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 7 ++++++-
 arch/x86/kvm/mmu/mmu.c          | 2 ++
 arch/x86/kvm/svm/nested.c       | 2 +-
 arch/x86/kvm/x86.c              | 8 +++++---
 4 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index be5363b21540..49b62f024f51 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1459,7 +1459,12 @@ int kvm_task_switch(struct kvm_vcpu *vcpu, u16 tss_selector, int idt_index,
 		    int reason, bool has_error_code, u32 error_code);
 
 int kvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0);
-int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3);
+int __kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool cr3_is_nested);
+static inline int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
+{
+	return __kvm_set_cr3(vcpu, cr3, false);
+}
+
 int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8);
 int kvm_set_dr(struct kvm_vcpu *vcpu, int dr, unsigned long val);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 167d12ab957a..ebf0cb3f1ce0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4987,6 +4987,8 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
 	union kvm_mmu_role new_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
 
+	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base, true, true);
+
 	if (new_role.as_u64 != context->mmu_role.as_u64)
 		shadow_mmu_init_context(vcpu, cr0, cr4, efer, new_role);
 }
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index e424bce13e6c..b467917a9784 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -324,7 +324,7 @@ static void nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_v
 	svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
 	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
 	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
-	(void)kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3);
+	(void)__kvm_set_cr3(&svm->vcpu, nested_vmcb->save.cr3, npt_enabled);
 
 	svm->vmcb->save.cr2 = svm->vcpu.arch.cr2 = nested_vmcb->save.cr2;
 	kvm_rax_write(&svm->vcpu, nested_vmcb->save.rax);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3b92db412335..3761135eb052 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1004,7 +1004,7 @@ int kvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 }
 EXPORT_SYMBOL_GPL(kvm_set_cr4);
 
-int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
+int __kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool cr3_is_nested)
 {
 	bool skip_tlb_flush = false;
 #ifdef CONFIG_X86_64
@@ -1031,13 +1031,15 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
-	kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);
+	if (!cr3_is_nested)
+		kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);
+
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(kvm_set_cr3);
+EXPORT_SYMBOL_GPL(__kvm_set_cr3);
 
 int kvm_set_cr8(struct kvm_vcpu *vcpu, unsigned long cr8)
 {
-- 
2.25.4

