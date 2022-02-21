Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CACAC4BE0B5
	for <lists+kvm@lfdr.de>; Mon, 21 Feb 2022 18:52:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380278AbiBUQX1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Feb 2022 11:23:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380200AbiBUQXP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Feb 2022 11:23:15 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B6E927161
        for <kvm@vger.kernel.org>; Mon, 21 Feb 2022 08:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645460569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2XJ0yshtegx69ruzpbBfy1QKJqb0fPwNdzHSAhgukq8=;
        b=hQb4rAcKJxSVJ03FpoQmvFHVhW1+sRPl3Z8clufF782SgnbXGjKRTWVKpV1z5gnCDWzLZf
        KnvyZwECReyCJDnG9rnO5OwkrAXT1MWpxosc+1t9NjaRUSPk4s4mHpX2Stah/Q3Qw6bmrT
        ZbJtsBEQT5e55MMpjJViwki2I6z1E58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-140-eXY4jakrOzSVHFt96THSvA-1; Mon, 21 Feb 2022 11:22:45 -0500
X-MC-Unique: eXY4jakrOzSVHFt96THSvA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7232B1006AA3;
        Mon, 21 Feb 2022 16:22:44 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1577B77474;
        Mon, 21 Feb 2022 16:22:44 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v2 01/25] KVM: x86/mmu: avoid indirect call for get_cr3
Date:   Mon, 21 Feb 2022 11:22:19 -0500
Message-Id: <20220221162243.683208-2-pbonzini@redhat.com>
In-Reply-To: <20220221162243.683208-1-pbonzini@redhat.com>
References: <20220221162243.683208-1-pbonzini@redhat.com>
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

Most of the time, calls to get_guest_pgd result in calling kvm_read_cr3
(the exception is only nested TDP).  Check if that is the case if
retpolines are enabled, thus avoiding an expensive indirect call.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h             | 10 ++++++++++
 arch/x86/kvm/mmu/mmu.c         | 15 ++++++++-------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 arch/x86/kvm/x86.c             |  2 +-
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 1d0c1904d69a..6ee4436e46f1 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -116,6 +116,16 @@ static inline void kvm_mmu_load_pgd(struct kvm_vcpu *vcpu)
 					  vcpu->arch.mmu->shadow_root_level);
 }
 
+extern unsigned long kvm_get_guest_cr3(struct kvm_vcpu *vcpu);
+static inline unsigned long kvm_mmu_get_guest_pgd(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
+{
+#ifdef CONFIG_RETPOLINE
+	if (mmu->get_guest_pgd == kvm_get_guest_cr3)
+		return kvm_read_cr3(vcpu);
+#endif
+	return mmu->get_guest_pgd(vcpu);
+}
+
 struct kvm_page_fault {
 	/* arguments to kvm_mmu_do_page_fault.  */
 	const gpa_t addr;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b2c1c4eb6007..7051040e15b3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3435,7 +3435,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	unsigned i;
 	int r;
 
-	root_pgd = mmu->get_guest_pgd(vcpu);
+	root_pgd = kvm_mmu_get_guest_pgd(vcpu, mmu);
 	root_gfn = root_pgd >> PAGE_SHIFT;
 
 	if (mmu_check_root(vcpu, root_gfn))
@@ -3854,12 +3854,13 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
 static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 				    gfn_t gfn)
 {
+	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct kvm_arch_async_pf arch;
 
 	arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
 	arch.gfn = gfn;
-	arch.direct_map = vcpu->arch.mmu->direct_map;
-	arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
+	arch.direct_map = mmu->direct_map;
+	arch.cr3 = kvm_mmu_get_guest_pgd(vcpu, mmu);
 
 	return kvm_setup_async_pf(vcpu, cr2_or_gpa,
 				  kvm_vcpu_gfn_to_hva(vcpu, gfn), &arch);
@@ -4208,7 +4209,7 @@ void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd)
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_new_pgd);
 
-static unsigned long get_cr3(struct kvm_vcpu *vcpu)
+unsigned long kvm_get_guest_cr3(struct kvm_vcpu *vcpu)
 {
 	return kvm_read_cr3(vcpu);
 }
@@ -4767,7 +4768,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu)
 	context->invlpg = NULL;
 	context->shadow_root_level = kvm_mmu_get_tdp_level(vcpu);
 	context->direct_map = true;
-	context->get_guest_pgd = get_cr3;
+	context->get_guest_pgd = kvm_get_guest_cr3;
 	context->get_pdptr = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 	context->root_level = role_regs_to_root_level(&regs);
@@ -4942,7 +4943,7 @@ static void init_kvm_softmmu(struct kvm_vcpu *vcpu)
 
 	kvm_init_shadow_mmu(vcpu, &regs);
 
-	context->get_guest_pgd     = get_cr3;
+	context->get_guest_pgd	   = kvm_get_guest_cr3;
 	context->get_pdptr         = kvm_pdptr_read;
 	context->inject_page_fault = kvm_inject_page_fault;
 }
@@ -4974,7 +4975,7 @@ static void init_kvm_nested_mmu(struct kvm_vcpu *vcpu)
 		return;
 
 	g_context->mmu_role.as_u64 = new_role.as_u64;
-	g_context->get_guest_pgd     = get_cr3;
+	g_context->get_guest_pgd     = kvm_get_guest_cr3;
 	g_context->get_pdptr         = kvm_pdptr_read;
 	g_context->inject_page_fault = kvm_inject_page_fault;
 	g_context->root_level        = new_role.base.level;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 252c77805eb9..80b4b291002a 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -362,7 +362,7 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	trace_kvm_mmu_pagetable_walk(addr, access);
 retry_walk:
 	walker->level = mmu->root_level;
-	pte           = mmu->get_guest_pgd(vcpu);
+	pte           = kvm_mmu_get_guest_pgd(vcpu, mmu);
 	have_ad       = PT_HAVE_ACCESSED_DIRTY(mmu);
 
 #if PTTYPE == 64
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6552360d8888..da33d3a88a8d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12190,7 +12190,7 @@ void kvm_arch_async_page_ready(struct kvm_vcpu *vcpu, struct kvm_async_pf *work)
 		return;
 
 	if (!vcpu->arch.mmu->direct_map &&
-	      work->arch.cr3 != vcpu->arch.mmu->get_guest_pgd(vcpu))
+	      work->arch.cr3 != kvm_mmu_get_guest_pgd(vcpu, vcpu->arch.mmu))
 		return;
 
 	kvm_mmu_do_page_fault(vcpu, work->cr2_or_gpa, 0, true);
-- 
2.31.1


