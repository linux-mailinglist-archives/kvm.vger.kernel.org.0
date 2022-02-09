Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532224AF772
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 18:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237765AbiBIRBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 12:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237695AbiBIRA4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 12:00:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F651C0613C9
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 09:00:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644426059;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tR1GvTEwRwp3TbS3xow6kXaZGlbaFMOGHUB9ngIKM98=;
        b=SdP1jldyPNNiOp4857xBbZaFYZFYKep47C3MfbTJU8VqGa9Nh4OMt0hjZwPSEqOYDm8paT
        Kqj2x/kyrFhvnKVbubxaKPWudAySR9kSnOCGI63sUZafuvddlBQ8kNY9S2ZNCPoNonhddk
        5XiPEhipyK0u/Z28t2Lx9SwHa06Fd5U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-615-vilrr8bKP26rBZunguo2ng-1; Wed, 09 Feb 2022 12:00:57 -0500
X-MC-Unique: vilrr8bKP26rBZunguo2ng-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B7B9992504;
        Wed,  9 Feb 2022 17:00:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3966574E8C;
        Wed,  9 Feb 2022 17:00:54 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com,
        seanjc@google.com
Subject: [PATCH 10/12] KVM: MMU: load new PGD after the shadow MMU is initialized
Date:   Wed,  9 Feb 2022 12:00:18 -0500
Message-Id: <20220209170020.1775368-11-pbonzini@redhat.com>
In-Reply-To: <20220209170020.1775368-1-pbonzini@redhat.com>
References: <20220209170020.1775368-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that __kvm_mmu_new_pgd does not look at the MMU's root_level and
shadow_root_level anymore, pull the PGD load after the initialization of
the shadow MMUs.

Besides being more intuitive, this enables future simplifications
and optimizations because it's not necessary anymore to compute the
role outside kvm_init_mmu.  In particular, kvm_mmu_reset_context was not
attempting to use a cached PGD to avoid having to figure out the new role.
It will soon be able to follow what nested_{vmx,svm}_load_cr3 are doing,
and avoid unloading all the cached roots.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c    | 37 +++++++++++++++++--------------------
 arch/x86/kvm/svm/nested.c |  6 +++---
 arch/x86/kvm/vmx/nested.c |  6 +++---
 3 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f61208ccce43..df9e0a43513c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4882,9 +4882,8 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 
 	new_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);
 
-	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
-
 	shadow_mmu_init_context(vcpu, context, &regs, new_role);
+	__kvm_mmu_new_pgd(vcpu, nested_cr3, new_role.base);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
 
@@ -4922,27 +4921,25 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		kvm_calc_shadow_ept_root_page_role(vcpu, accessed_dirty,
 						   execonly, level);
 
-	__kvm_mmu_new_pgd(vcpu, new_eptp, new_role.base);
-
-	if (new_role.as_u64 == context->mmu_role.as_u64)
-		return;
-
-	context->mmu_role.as_u64 = new_role.as_u64;
+	if (new_role.as_u64 != context->mmu_role.as_u64) {
+		context->mmu_role.as_u64 = new_role.as_u64;
 
-	context->shadow_root_level = level;
+		context->shadow_root_level = level;
 
-	context->ept_ad = accessed_dirty;
-	context->page_fault = ept_page_fault;
-	context->gva_to_gpa = ept_gva_to_gpa;
-	context->sync_page = ept_sync_page;
-	context->invlpg = ept_invlpg;
-	context->root_level = level;
-	context->direct_map = false;
+		context->ept_ad = accessed_dirty;
+		context->page_fault = ept_page_fault;
+		context->gva_to_gpa = ept_gva_to_gpa;
+		context->sync_page = ept_sync_page;
+		context->invlpg = ept_invlpg;
+		context->root_level = level;
+		context->direct_map = false;
+		update_permission_bitmask(context, true);
+		context->pkru_mask = 0;
+		reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
+		reset_ept_shadow_zero_bits_mask(context, execonly);
+	}
 
-	update_permission_bitmask(context, true);
-	context->pkru_mask = 0;
-	reset_rsvds_bits_mask_ept(vcpu, context, execonly, huge_page_level);
-	reset_ept_shadow_zero_bits_mask(context, execonly);
+	__kvm_mmu_new_pgd(vcpu, new_eptp, new_role.base);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index f284e61451c8..96bab464967f 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -492,14 +492,14 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	    CC(!load_pdptrs(vcpu, cr3)))
 		return -EINVAL;
 
-	if (!nested_npt)
-		kvm_mmu_new_pgd(vcpu, cr3);
-
 	vcpu->arch.cr3 = cr3;
 
 	/* Re-initialize the MMU, e.g. to pick up CR4 MMU role changes. */
 	kvm_init_mmu(vcpu);
 
+	if (!nested_npt)
+		kvm_mmu_new_pgd(vcpu, cr3);
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 29289ecca223..abfcd71f787f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1126,15 +1126,15 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 		return -EINVAL;
 	}
 
-	if (!nested_ept)
-		kvm_mmu_new_pgd(vcpu, cr3);
-
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
 
 	/* Re-initialize the MMU, e.g. to pick up CR4 MMU role changes. */
 	kvm_init_mmu(vcpu);
 
+	if (!nested_ept)
+		kvm_mmu_new_pgd(vcpu, cr3);
+
 	return 0;
 }
 
-- 
2.31.1


