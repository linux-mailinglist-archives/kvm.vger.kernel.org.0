Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168E621A2A3
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 16:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728196AbgGIOyw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 10:54:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53720 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728087AbgGIOyd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 10:54:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594306471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eiO0bqykdIfX8XkrwUHFjxLGiTADWODuOymhIF0LHCQ=;
        b=ZBX/seHXX8uYGo91HihE6pzW50cIg1iNv5ZllUDdv/L0DmQHgg/yMjGU++JAWrlAHMIU6Q
        nyigM6DzolzRaOy9CCX8YO2tJFUPU+K6VukmdXTsbZQE9o8N8U5WWMpfurgY/rLaByh7v6
        m9dY1CBkhxsuZY76c1RhnC3hqLdflNk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-_BHG_arCN3izW_KlglzW9Q-1; Thu, 09 Jul 2020 10:54:29 -0400
X-MC-Unique: _BHG_arCN3izW_KlglzW9Q-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A8F3D100A8F7;
        Thu,  9 Jul 2020 14:54:28 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.35])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 86D9C60E1C;
        Thu,  9 Jul 2020 14:54:26 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Junaid Shahid <junaids@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/9] KVM: nSVM: implement nested_svm_load_cr3() and use it for host->guest switch
Date:   Thu,  9 Jul 2020 16:53:56 +0200
Message-Id: <20200709145358.1560330-8-vkuznets@redhat.com>
In-Reply-To: <20200709145358.1560330-1-vkuznets@redhat.com>
References: <20200709145358.1560330-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

Using generic kvm_set_cr3() when switching to nested guest is not
a great idea as we'll have to distinguish between 'real' CR3s and
'nested' CR3s to e.g. not call kvm_mmu_new_pgd() with nGPA. Following
nVMX implement nested-specific nested_svm_load_cr3() doing the job.

Note: the current implementation is sub-optimal as we always do TLB
flush/MMU sync but this is still an improvement as we at least stop doing
kvm_mmu_reset_context().

Fixes: 7c390d350f8b ("kvm: x86: Add fast CR3 switch code path")
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c    |  2 ++
 arch/x86/kvm/svm/nested.c | 33 +++++++++++++++++++++++++--------
 2 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 69fa51af8cbf..1c3a231f825b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4986,6 +4986,8 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, u32 cr0, u32 cr4, u32 efer,
 	union kvm_mmu_role new_role =
 		kvm_calc_shadow_mmu_root_page_role(vcpu, false);
 
+	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base, false, false);
+
 	if (new_role.as_u64 != context->mmu_role.as_u64)
 		shadow_mmu_init_context(vcpu, context, cr0, cr4, efer, new_role);
 }
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 5f001d2c41d1..5ddf20941cf9 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -323,7 +323,28 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 			       bool nested_npt)
 {
-	return kvm_set_cr3(vcpu, cr3);
+	if (cr3 & rsvd_bits(cpuid_maxphyaddr(vcpu), 63))
+		return -EINVAL;
+
+	if (!nested_npt && is_pae_paging(vcpu) &&
+	    (cr3 != kvm_read_cr3(vcpu) || pdptrs_changed(vcpu))) {
+		if (!load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+			return -EINVAL;
+	}
+
+	/*
+	 * TODO: optimize unconditional TLB flush/MMU sync here and in
+	 * kvm_init_shadow_npt_mmu().
+	 */
+	if (!nested_npt)
+		kvm_mmu_new_pgd(vcpu, cr3, false, false);
+
+	vcpu->arch.cr3 = cr3;
+	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
+
+	kvm_init_mmu(vcpu, false);
+
+	return 0;
 }
 
 static int nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vmcb)
@@ -342,6 +363,9 @@ static int nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vm
 	svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
 	svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
 
+	if (nested_npt_enabled(svm))
+		nested_svm_init_mmu_context(&svm->vcpu);
+
 	ret = nested_svm_load_cr3(&svm->vcpu, nested_vmcb->save.cr3,
 				  nested_npt_enabled(svm));
 
@@ -364,13 +388,6 @@ static int nested_prepare_vmcb_save(struct vcpu_svm *svm, struct vmcb *nested_vm
 static void nested_prepare_vmcb_control(struct vcpu_svm *svm)
 {
 	const u32 mask = V_INTR_MASKING_MASK | V_GIF_ENABLE_MASK | V_GIF_MASK;
-	if (nested_npt_enabled(svm))
-		nested_svm_init_mmu_context(&svm->vcpu);
-
-	/* Guest paging mode is active - reset mmu */
-	kvm_mmu_reset_context(&svm->vcpu);
-
-	svm_flush_tlb(&svm->vcpu);
 
 	svm->vmcb->control.tsc_offset = svm->vcpu.arch.tsc_offset =
 		svm->vcpu.arch.l1_tsc_offset + svm->nested.ctl.tsc_offset;
-- 
2.25.4

