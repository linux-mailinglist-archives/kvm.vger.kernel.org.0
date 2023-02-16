Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F27D699915
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 16:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbjBPPku (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 10:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjBPPkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 10:40:47 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F165155E4F;
        Thu, 16 Feb 2023 07:40:34 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id be8so2405911plb.7;
        Thu, 16 Feb 2023 07:40:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tswCNRF4PJXn2AcdPflQ9tzBOQNHiMw8By26m9aOmgc=;
        b=GZ7mCdSJ36N/eYmbu2fpeXXACqfefgjdCsoNWOHbF88B3CS2dGak856gIY0WlhueP/
         H5OhaZyx0VYKNrlaza3/5YxVgnSGZLYas37e/Lr5aRCNBRx9mxxt6qV2W1Bca245RLcb
         jBZ1efPApB3py1T3BzAkOV3rR7B2MrCdm7WUUpfN4CJk8GU4ChtNY/3eMcgAmRWHPuXe
         JSYUtGhrkd5ezMqPG40EkNdEIaoYoYdW6Je8Raoj68bDkJnU6RQSrtOwlwYOy6vLmsxT
         WuypL0ddKch+fv62V574Uk0UGvAnXkMjWl8qL3rQbqCYlhNwMKsA1m+07xcvK9v41r18
         nOyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tswCNRF4PJXn2AcdPflQ9tzBOQNHiMw8By26m9aOmgc=;
        b=tfKqvlPnDDYol6HuHfZbnWyWo3FtAnslbYJkSa151q6x8dJ3rVD/ulf43hzs4SZje5
         GTx3TWq+eKyWsp6BpvE9nA7ydPTp9Y7hbFNdrx9LbieCvUqAbDx23oqglogEJ80KxzUY
         LZkbDiiUw6+UESEHTJFkGLFB31XfiGVJfP6J1FNHDfuf/FpfyJ6wasIq9S34pJcJGx/8
         OeB5OQPKX3LDgS4Povf3m2tLhLHzo1RdgliKTXqtPRQ8l3UCrRXXNPmhIZJ6rCqtJNNb
         OUbA8XOpAUhtCgNClEMQAL7gz0T1kTcnRauffXFOGL4PtJ+o8MQ0AjZ6OySsWmMPnt3M
         fHMw==
X-Gm-Message-State: AO0yUKWbUkAfRIhxB+vnaSnsMG3ahUE0Vbe9rzq2nqgOC2rbjHB2HI4Y
        rpItC60Qd2bU1P/EQvEnd3SEdMDhE4g=
X-Google-Smtp-Source: AK7set+PutRRY6v8CCKBJMUWwCwjVrR7lRXM7XZ5QoG1D3+at7OGK9t8fOWGcCmXBda6O5EJugqJ7w==
X-Received: by 2002:a17:90b:180c:b0:234:b23:eadb with SMTP id lw12-20020a17090b180c00b002340b23eadbmr7368122pjb.41.1676562034174;
        Thu, 16 Feb 2023 07:40:34 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id o98-20020a17090a0a6b00b0021904307a53sm1394429pjo.19.2023.02.16.07.40.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Feb 2023 07:40:33 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V3 05/14] kvm: x86/mmu: Move the code out of FNAME(sync_page)'s loop body into mmu.c
Date:   Thu, 16 Feb 2023 23:41:11 +0800
Message-Id: <20230216154115.710033-6-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230216154115.710033-1-jiangshanlai@gmail.com>
References: <20230216154115.710033-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Rename mmu->sync_page to mmu->sync_spte and move the code out
of FNAME(sync_page)'s loop body into mmu.c.

No functionalities change intended.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/mmu/mmu.c          |  34 ++++++++--
 arch/x86/kvm/mmu/paging_tmpl.h  | 114 +++++++++++++-------------------
 3 files changed, 76 insertions(+), 76 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5466f4152c67..b71b52fdb5ee 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -441,8 +441,8 @@ struct kvm_mmu {
 	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 			    gpa_t gva_or_gpa, u64 access,
 			    struct x86_exception *exception);
-	int (*sync_page)(struct kvm_vcpu *vcpu,
-			 struct kvm_mmu_page *sp);
+	int (*sync_spte)(struct kvm_vcpu *vcpu,
+			 struct kvm_mmu_page *sp, int i);
 	void (*invlpg)(struct kvm_vcpu *vcpu, u64 addr, hpa_t root_hpa);
 	struct kvm_mmu_root_info root;
 	union kvm_cpu_role cpu_role;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f50f82bb3662..a8231b73ad4d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1934,7 +1934,7 @@ static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 	 * differs then the memslot lookup (SMM vs. non-SMM) will be bogus, the
 	 * reserved bits checks will be wrong, etc...
 	 */
-	if (WARN_ON_ONCE(sp->role.direct || !vcpu->arch.mmu->sync_page ||
+	if (WARN_ON_ONCE(sp->role.direct || !vcpu->arch.mmu->sync_spte ||
 			 (sp->role.word ^ root_role.word) & ~sync_role_ign.word))
 		return false;
 
@@ -1943,10 +1943,30 @@ static bool kvm_sync_page_check(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 
 static int __kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
 {
+	int flush = 0;
+	int i;
+
 	if (!kvm_sync_page_check(vcpu, sp))
 		return -1;
 
-	return vcpu->arch.mmu->sync_page(vcpu, sp);
+	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
+		int ret = vcpu->arch.mmu->sync_spte(vcpu, sp, i);
+
+		if (ret < -1)
+			return -1;
+		flush |= ret;
+	}
+
+	/*
+	 * Note, any flush is purely for KVM's correctness, e.g. when dropping
+	 * an existing SPTE or clearing W/A/D bits to ensure an mmu_notifier
+	 * unmap or dirty logging event doesn't fail to flush.  The guest is
+	 * responsible for flushing the TLB to ensure any changes in protection
+	 * bits are recognized, i.e. until the guest flushes or page faults on
+	 * a relevant address, KVM is architecturally allowed to let vCPUs use
+	 * cached translations with the old protection bits.
+	 */
+	return flush;
 }
 
 static int kvm_sync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
@@ -4504,7 +4524,7 @@ static void nonpaging_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = nonpaging_page_fault;
 	context->gva_to_gpa = nonpaging_gva_to_gpa;
-	context->sync_page = NULL;
+	context->sync_spte = NULL;
 	context->invlpg = NULL;
 }
 
@@ -5095,7 +5115,7 @@ static void paging64_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = paging64_page_fault;
 	context->gva_to_gpa = paging64_gva_to_gpa;
-	context->sync_page = paging64_sync_page;
+	context->sync_spte = paging64_sync_spte;
 	context->invlpg = paging64_invlpg;
 }
 
@@ -5103,7 +5123,7 @@ static void paging32_init_context(struct kvm_mmu *context)
 {
 	context->page_fault = paging32_page_fault;
 	context->gva_to_gpa = paging32_gva_to_gpa;
-	context->sync_page = paging32_sync_page;
+	context->sync_spte = paging32_sync_spte;
 	context->invlpg = paging32_invlpg;
 }
 
@@ -5192,7 +5212,7 @@ static void init_kvm_tdp_mmu(struct kvm_vcpu *vcpu,
 	context->cpu_role.as_u64 = cpu_role.as_u64;
 	context->root_role.word = root_role.word;
 	context->page_fault = kvm_tdp_page_fault;
-	context->sync_page = NULL;
+	context->sync_spte = NULL;
 	context->invlpg = NULL;
 	context->get_guest_pgd = get_cr3;
 	context->get_pdptr = kvm_pdptr_read;
@@ -5324,7 +5344,7 @@ void kvm_init_shadow_ept_mmu(struct kvm_vcpu *vcpu, bool execonly,
 
 		context->page_fault = ept_page_fault;
 		context->gva_to_gpa = ept_gva_to_gpa;
-		context->sync_page = ept_sync_page;
+		context->sync_spte = ept_sync_spte;
 		context->invlpg = ept_invlpg;
 
 		update_permission_bitmask(context, true);
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index e0aae0a7f646..0ea938276ba8 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -978,87 +978,67 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
  *   can't change unless all sptes pointing to it are nuked first.
  *
  * Returns
- * < 0: the sp should be zapped
- *   0: the sp is synced and no tlb flushing is required
- * > 0: the sp is synced and tlb flushing is required
+ * < 0: failed to sync spte
+ *   0: the spte is synced and no tlb flushing is required
+ * > 0: the spte is synced and tlb flushing is required
  */
-static int FNAME(sync_page)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+static int FNAME(sync_spte)(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp, int i)
 {
-	int i;
 	bool host_writable;
 	gpa_t first_pte_gpa;
-	bool flush = false;
-
-	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
-
-	for (i = 0; i < SPTE_ENT_PER_PAGE; i++) {
-		u64 *sptep, spte;
-		struct kvm_memory_slot *slot;
-		unsigned pte_access;
-		pt_element_t gpte;
-		gpa_t pte_gpa;
-		gfn_t gfn;
-
-		if (!sp->spt[i])
-			continue;
+	u64 *sptep, spte;
+	struct kvm_memory_slot *slot;
+	unsigned pte_access;
+	pt_element_t gpte;
+	gpa_t pte_gpa;
+	gfn_t gfn;
 
-		pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
+	if (!sp->spt[i])
+		return 0;
 
-		if (kvm_vcpu_read_guest_atomic(vcpu, pte_gpa, &gpte,
-					       sizeof(pt_element_t)))
-			return -1;
+	first_pte_gpa = FNAME(get_level1_sp_gpa)(sp);
+	pte_gpa = first_pte_gpa + i * sizeof(pt_element_t);
 
-		if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte)) {
-			flush = true;
-			continue;
-		}
+	if (kvm_vcpu_read_guest_atomic(vcpu, pte_gpa, &gpte,
+				       sizeof(pt_element_t)))
+		return -1;
 
-		gfn = gpte_to_gfn(gpte);
-		pte_access = sp->role.access;
-		pte_access &= FNAME(gpte_access)(gpte);
-		FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
+	if (FNAME(prefetch_invalid_gpte)(vcpu, sp, &sp->spt[i], gpte))
+		return 1;
 
-		if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
-			continue;
+	gfn = gpte_to_gfn(gpte);
+	pte_access = sp->role.access;
+	pte_access &= FNAME(gpte_access)(gpte);
+	FNAME(protect_clean_gpte)(vcpu->arch.mmu, &pte_access, gpte);
 
-		/*
-		 * Drop the SPTE if the new protections would result in a RWX=0
-		 * SPTE or if the gfn is changing.  The RWX=0 case only affects
-		 * EPT with execute-only support, i.e. EPT without an effective
-		 * "present" bit, as all other paging modes will create a
-		 * read-only SPTE if pte_access is zero.
-		 */
-		if ((!pte_access && !shadow_present_mask) ||
-		    gfn != kvm_mmu_page_get_gfn(sp, i)) {
-			drop_spte(vcpu->kvm, &sp->spt[i]);
-			flush = true;
-			continue;
-		}
+	if (sync_mmio_spte(vcpu, &sp->spt[i], gfn, pte_access))
+		return 0;
 
-		/* Update the shadowed access bits in case they changed. */
-		kvm_mmu_page_set_access(sp, i, pte_access);
+	/*
+	 * Drop the SPTE if the new protections would result in a RWX=0
+	 * SPTE or if the gfn is changing.  The RWX=0 case only affects
+	 * EPT with execute-only support, i.e. EPT without an effective
+	 * "present" bit, as all other paging modes will create a
+	 * read-only SPTE if pte_access is zero.
+	 */
+	if ((!pte_access && !shadow_present_mask) ||
+	    gfn != kvm_mmu_page_get_gfn(sp, i)) {
+		drop_spte(vcpu->kvm, &sp->spt[i]);
+		return 1;
+	}
 
-		sptep = &sp->spt[i];
-		spte = *sptep;
-		host_writable = spte & shadow_host_writable_mask;
-		slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
-		make_spte(vcpu, sp, slot, pte_access, gfn,
-			  spte_to_pfn(spte), spte, true, false,
-			  host_writable, &spte);
+	/* Update the shadowed access bits in case they changed. */
+	kvm_mmu_page_set_access(sp, i, pte_access);
 
-		flush |= mmu_spte_update(sptep, spte);
-	}
+	sptep = &sp->spt[i];
+	spte = *sptep;
+	host_writable = spte & shadow_host_writable_mask;
+	slot = kvm_vcpu_gfn_to_memslot(vcpu, gfn);
+	make_spte(vcpu, sp, slot, pte_access, gfn,
+		  spte_to_pfn(spte), spte, true, false,
+		  host_writable, &spte);
 
-	/*
-	 * Note, any flush is purely for KVM's correctness, e.g. when dropping
-	 * an existing SPTE or clearing W/A/D bits to ensure an mmu_notifier
-	 * unmap or dirty logging event doesn't fail to flush.  The guest is
-	 * responsible for flushing the TLB to ensure any changes in protection
-	 * bits are recognized, i.e. until the guest flushes or page faults on
-	 * a relevant address, KVM is architecturally allowed to let vCPUs use
-	 * cached translations with the old protection bits.
-	 */
-	return flush;
+	return mmu_spte_update(sptep, spte);
 }
 
 #undef pt_element_t
-- 
2.19.1.6.gb485710b

