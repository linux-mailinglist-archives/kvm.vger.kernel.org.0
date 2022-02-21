Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527694BE263
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:55:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380373AbiBUQX6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380269AbiBUQX0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44DD2275CD
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:23:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dPlOBPn8ErB7X42yhcpXa0pXThH6x0ky6io51/DXKJ4=;
        b=YHFnVSu8NNQuxHBVqxsye9bFDOIKLwR9PdBsPlzgnk1ciZNS4fjJJDaySz0Huqer9x2AHE
        1moHQQ39v0W9MMZ1Sv+LJXbJqcg4ynDIhVK0yOKd88TTYq7Ua66BfC0fraPWUxOhmcbvzS
        YD1WWyqC+I73pYMy8rsvC35XmkNsugo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-xOUV900ENwCCOIjIo3B4nA-1; Mon, 21 Feb 2022 11:22:58 -0500
X-MC-Unique: xOUV900ENwCCOIjIo3B4nA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B780C801B04;
        Mon, 21 Feb 2022 16:22:56 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 597D084A14;
        Mon, 21 Feb 2022 16:22:56 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 24/25] KVM: x86/mmu: initialize constant-value fields just once
Date:   Mon, 21 Feb 2022 11:22:42 -0500
Message-Id: <20220221162243.683208-25-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The get_guest_pgd, get_pdptr and inject_page_fault pointers are constant
for all three of root_mmu, guest_mmu and nested_mmu.  In fact, the guest_mmu
function pointers depend on the processor vendor and need to be retrieved
from three new nested_ops, but the others are absolutely the same.

Opportunistically stop initializing get_pdptr for nested EPT, since it does
not have PDPTRs.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  5 +++
 arch/x86/kvm/mmu/mmu.c          | 65 +++++++++++++++++----------------
 arch/x86/kvm/svm/nested.c       |  9 +++--
 arch/x86/kvm/vmx/nested.c       |  5 +--
 4 files changed, 46 insertions(+), 38 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index af90d0653139..b70965235c31 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1503,6 +1503,11 @@ struct kvm_x86_nested_ops {
 	uint16_t (*get_evmcs_version)(struct kvm_vcpu *vcpu);
 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
 				  struct x86_exception *fault);
+	void (*inject_nested_tdp_vmexit)(struct kvm_vcpu *vcpu,
+					 struct x86_exception *fault);
+
+	unsigned long (*get_nested_pgd)(struct kvm_vcpu *vcpu);
+	u64 (*get_nested_pdptr)(struct kvm_vcpu *vcpu, int index);
 };
 
 struct kvm_x86_init_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8eb2c0373309..27cb6ba5a3b0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4743,12 +4743,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_paging_mode cp
 
 	context->cpu_mode.as_u64 = cpu_mode.as_u64;
 	context->root_role.word = root_role.word;
-	context->page_fault = kvm_tdp_page_fault;
-	context->sync_page = nonpaging_sync_page;
-	context->invlpg = NULL;
-	context->get_guest_pgd = kvm_get_guest_cr3;
-	context->get_pdptr = kvm_pdptr_read;
-	context->inject_page_fault = kvm_inject_page_fault;
 
 	if (!is_cr0_pg(context))
 		context->gva_to_gpa = nonpaging_gva_to_gpa;
@@ -4758,7 +4752,6 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_paging_mode cp
 		context->gva_to_gpa = paging32_gva_to_gpa;
 
 	reset_guest_paging_metadata(vcpu, context);
-	reset_tdp_shadow_zero_bits_mask(context);
 }
 
 static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
@@ -4783,8 +4776,8 @@ static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *conte
 	reset_shadow_zero_bits_mask(vcpu, context);
 }
 
-static void kvm_init_shadow_mmu(struct kvm_vcpu *vcpu,
-				union kvm_mmu_paging_mode cpu_mode)
+static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
+			     union kvm_mmu_paging_mode cpu_mode)
 {
 	struct kvm_mmu *context = &vcpu->arch.root_mmu;
 	union kvm_mmu_page_role root_role;
@@ -4880,18 +4873,6 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
-static void init_kvm_softmmu(struct kvm_vcpu *vcpu,
-			     union kvm_mmu_paging_mode cpu_mode)
-{
-	struct kvm_mmu *context = &vcpu->arch.root_mmu;
-
-	kvm_init_shadow_mmu(vcpu, cpu_mode);
-
-	context->get_guest_pgd	   = kvm_get_guest_cr3;
-	context->get_pdptr         = kvm_pdptr_read;
-	context->inject_page_fault = kvm_inject_page_fault_shadow;
-}
-
 static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_paging_mode new_mode)
 {
 	struct kvm_mmu *g_context = &vcpu->arch.nested_mmu;
@@ -4899,16 +4880,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu, union kvm_mmu_paging_mode
 	if (new_mode.as_u64 == g_context->cpu_mode.as_u64)
 		return;
 
-	g_context->cpu_mode.as_u64   = new_mode.as_u64;
-	g_context->get_guest_pgd     = kvm_get_guest_cr3;
-	g_context->get_pdptr         = kvm_pdptr_read;
-	g_context->inject_page_fault = kvm_inject_page_fault;
-
-	/*
-	 * L2 page tables are never shadowed, so there is no need to sync
-	 * SPTEs.
-	 */
-	g_context->invlpg            = NULL;
+	g_context->cpu_mode.as_u64 = new_mode.as_u64;
 
 	/*
 	 * Note that arch.mmu->gva_to_gpa translates l2_gpa to l1_gpa using
@@ -5477,6 +5449,37 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
+	vcpu->arch.root_mmu.get_guest_pgd = kvm_get_guest_cr3;
+	vcpu->arch.root_mmu.get_pdptr = kvm_pdptr_read;
+
+	if (tdp_enabled) {
+		vcpu->arch.root_mmu.inject_page_fault = kvm_inject_page_fault;
+		vcpu->arch.root_mmu.page_fault = kvm_tdp_page_fault;
+		vcpu->arch.root_mmu.sync_page = nonpaging_sync_page;
+		vcpu->arch.root_mmu.invlpg = NULL;
+		reset_tdp_shadow_zero_bits_mask(&vcpu->arch.root_mmu);
+
+		vcpu->arch.guest_mmu.get_guest_pgd = kvm_x86_ops.nested_ops->get_nested_pgd;
+		vcpu->arch.guest_mmu.get_pdptr = kvm_x86_ops.nested_ops->get_nested_pdptr;
+		vcpu->arch.guest_mmu.inject_page_fault = kvm_x86_ops.nested_ops->inject_nested_tdp_vmexit;
+	} else {
+		vcpu->arch.root_mmu.inject_page_fault = kvm_inject_page_fault_shadow;
+		/*
+		 * page_fault, sync_page, invlpg are set at runtime depending
+		 * on the guest paging mode.
+		 */
+	}
+
+	vcpu->arch.nested_mmu.get_guest_pgd     = kvm_get_guest_cr3;
+	vcpu->arch.nested_mmu.get_pdptr         = kvm_pdptr_read;
+	vcpu->arch.nested_mmu.inject_page_fault = kvm_inject_page_fault;
+
+	/*
+	 * L2 page tables are never shadowed, so there is no need to sync
+	 * SPTEs.
+	 */
+	vcpu->arch.nested_mmu.invlpg = NULL;
+
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index ff58c9ebc552..713c7531de99 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -109,10 +109,8 @@ static void nested_svm_init_mmu_context(struct kvm_vcpu *vcpu)
 	kvm_init_shadow_npt_mmu(vcpu, X86_CR0_PG, svm->vmcb01.ptr->save.cr4,
 				svm->vmcb01.ptr->save.efer,
 				svm->nested.ctl.nested_cr3);
-	vcpu->arch.mmu->get_guest_pgd     = nested_svm_get_tdp_cr3;
-	vcpu->arch.mmu->get_pdptr         = nested_svm_get_tdp_pdptr;
-	vcpu->arch.mmu->inject_page_fault = nested_svm_inject_npf_exit;
-	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
+
+	vcpu->arch.walk_mmu = &vcpu->arch.nested_mmu;
 }
 
 static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
@@ -1569,4 +1567,7 @@ struct kvm_x86_nested_ops svm_nested_ops = {
 	.get_state = svm_get_nested_state,
 	.set_state = svm_set_nested_state,
 	.inject_page_fault = svm_inject_page_fault_nested,
+	.inject_nested_tdp_vmexit = nested_svm_inject_npf_exit,
+	.get_nested_pgd = nested_svm_get_tdp_cr3,
+	.get_nested_pdptr = nested_svm_get_tdp_pdptr,
 };
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 564c60566da7..02df0f4fccef 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -414,9 +414,6 @@ static void nested_ept_init_mmu_context(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.mmu = &vcpu->arch.guest_mmu;
 	nested_ept_new_eptp(vcpu);
-	vcpu->arch.mmu->get_guest_pgd     = nested_ept_get_eptp;
-	vcpu->arch.mmu->inject_page_fault = nested_ept_inject_page_fault;
-	vcpu->arch.mmu->get_pdptr         = kvm_pdptr_read;
 
 	vcpu->arch.walk_mmu              = &vcpu->arch.nested_mmu;
 }
@@ -6805,4 +6802,6 @@ struct kvm_x86_nested_ops vmx_nested_ops = {
 	.enable_evmcs = nested_enable_evmcs,
 	.get_evmcs_version = nested_get_evmcs_version,
 	.inject_page_fault = vmx_inject_page_fault_nested,
+	.inject_nested_tdp_vmexit = nested_ept_inject_page_fault,
+	.get_nested_pgd = nested_ept_get_eptp,
 };
-- 
2.31.1


