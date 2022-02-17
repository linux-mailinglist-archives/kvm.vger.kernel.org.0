Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC9ED4BAB79
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 22:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244811AbiBQVEb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 16:04:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244222AbiBQVEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 16:04:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0E17712E173
        for <kvm@vger.kernel.org>; Thu, 17 Feb 2022 13:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645131833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R9Q0pLb8P4BlDqpXLzpYKuId39pvX37TO7tEfEhTs28=;
        b=REUqBdCyEf6UCd/mswcz8ajNCPF7ElCHPdKKgvK1AgTtmb3MpDhJj1emiZymsHT5+mJ/+E
        TznMsciUCg5V31Ycn+qdkldSXNTbOj5Z+tR86zaWddIv8kJl20KyA5xsGojaIcnxCzfvKb
        UVr7svT8XH+P88+xriJBTgEDTnGVfjo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-WKyzD1ubNqOHwUg7aB2yxQ-1; Thu, 17 Feb 2022 16:03:49 -0500
X-MC-Unique: WKyzD1ubNqOHwUg7aB2yxQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9C18F2F4D;
        Thu, 17 Feb 2022 21:03:48 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D2E36AB90;
        Thu, 17 Feb 2022 21:03:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 15/18] KVM: x86/mmu: rename kvm_mmu_new_pgd, introduce variant that calls get_guest_pgd
Date:   Thu, 17 Feb 2022 16:03:37 -0500
Message-Id: <20220217210340.312449-16-pbonzini@redhat.com>
In-Reply-To: <20220217210340.312449-1-pbonzini@redhat.com>
References: <20220217210340.312449-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the common case, the argument to kvm_mmu_new_pgd is already in
vcpu->arch.cr3, but that does not work when the guest_mmu is in use.
In that case, the root for L1 TDP tables needs to be retrieved via vendor
code.  Besides, kvm_mmu_new_pgd is a bad name: it can be used also when
the role bits change, not just when the PGD changes.

Kill two birds with one stone by renaming the old kvm_mmu_new_pgd
to __kvm_mmu_update_root.  The non-__ version, kvm_mmu_update_root,
covers the common case, including nested TDP, by calling the
get_guest_pgd callback to retrieve the desired PGD pointer.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 15 +++++++++++----
 arch/x86/kvm/svm/nested.c       |  2 +-
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/x86.c              |  2 +-
 5 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 79f37ccc8726..319ac0918aa2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1808,7 +1808,7 @@ void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gva_t gva, hpa_t root_hpa);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
-void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
+void kvm_mmu_update_root(struct kvm_vcpu *vcpu);
 
 void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 		       int tdp_max_root_level, int tdp_huge_page_level);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d422d0d2adf8..c44b5114f947 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4189,7 +4189,7 @@ static bool fast_pgd_switch(struct kvm *kvm, struct kvm_mmu *mmu,
 		return cached_root_find_without_current(kvm, mmu, new_pgd, new_role);
 }
 
-void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
+static void __kvm_mmu_update_root(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 {
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	union kvm_mmu_page_role new_role = mmu->mmu_role.base;
@@ -4228,7 +4228,14 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 		__clear_sp_write_flooding_count(
 				to_shadow_page(vcpu->arch.mmu->root.hpa));
 }
-EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
+
+void kvm_mmu_update_root(struct kvm_vcpu *vcpu)
+{
+	gpa_t new_pgd = kvm_mmu_get_guest_pgd(vcpu);
+
+	__kvm_mmu_update_root(vcpu, new_pgd);
+}
+EXPORT_SYMBOL_GPL(kvm_mmu_update_root);
 
 static bool sync_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, gfn_t gfn,
 			   unsigned int access)
@@ -4892,7 +4899,7 @@ void kvm_init_shadow_npt_mmu(struct kvm_vcpu *vcpu, unsigned long cr0,
 	new_role = kvm_calc_shadow_npt_root_page_role(vcpu, &regs);
 
 	shadow_mmu_init_context(vcpu, context, &regs, new_role);
-	kvm_mmu_new_pgd(vcpu, nested_cr3);
+	__kvm_mmu_update_root(vcpu, nested_cr3);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_npt_mmu);
 
@@ -4948,7 +4955,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 		reset_ept_shadow_zero_bits_mask(context, execonly);
 	}
 
-	kvm_mmu_new_pgd(vcpu, new_eptp);
+	__kvm_mmu_update_root(vcpu, new_eptp);
 }
 EXPORT_SYMBOL_GPL(kvm_init_shadow_ept_mmu);
 
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 96bab464967f..2386fadae9ed 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -498,7 +498,7 @@ static int nested_svm_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	kvm_init_mmu(vcpu);
 
 	if (!nested_npt)
-		kvm_mmu_new_pgd(vcpu, cr3);
+		kvm_mmu_update_root(vcpu);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1dfe23963a9e..2dbd7a9ada84 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -1133,7 +1133,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3,
 	kvm_init_mmu(vcpu);
 
 	if (!nested_ept)
-		kvm_mmu_new_pgd(vcpu, cr3);
+		kvm_mmu_update_root(vcpu);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index adcee7c305ca..9800c8883a48 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1189,7 +1189,7 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		return 1;
 
 	if (cr3 != kvm_read_cr3(vcpu))
-		kvm_mmu_new_pgd(vcpu, cr3);
+		kvm_mmu_update_root(vcpu);
 
 	vcpu->arch.cr3 = cr3;
 	kvm_register_mark_dirty(vcpu, VCPU_EXREG_CR3);
-- 
2.31.1


