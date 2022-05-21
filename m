Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB5A52FCB9
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 15:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355026AbiEUNQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 09:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355009AbiEUNQY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 09:16:24 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4282CE11;
        Sat, 21 May 2022 06:16:20 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id j6so9849592pfe.13;
        Sat, 21 May 2022 06:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dCHtMiFFfpy1WrNe8a2M3hfIOd/KYtkFI9AjmBMluLs=;
        b=gPDgv1291pERaHb1SFkM2xHDBxCquTe+3Utjd2os45xKKcX4aYIwHRc5mnHTr91yXL
         6+89cjsy+vDoYlXW7g5vNkf8mmMdREbwGNkXFMcVhYjdEuCjtvLmWfKIjhechliFiXR1
         Shx/of2zzYXJmYWoWG75hXdW819FV29Sw8SXuq0541dFmX7dX5oJmsdnl5vMzEzTMfs5
         DsA82mM1eg4M9TG4V4hKNS3qw66aX03he89pbIuMPY/G+023SGqy1jNo7Kbn3KgrZIeX
         TrzZhlmRaNb7vBGPunuBmgswOFEzmXTOW/l0La74ZhJ/Aj9+7GCNCu4OuarpRDwMx5eZ
         Knsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dCHtMiFFfpy1WrNe8a2M3hfIOd/KYtkFI9AjmBMluLs=;
        b=TtJ1bJ3KdjPZE8AwU5SNvjWQ+GJPPmS9U3Kqihdsm+5td+ybdyLjKYSvegnL8HKyyL
         K8FwTGFGBkF77I++7eOliz6z4aPFtI4331V7kG9kc8lQmpj35xBuXghWm52hHM0it+91
         fxrJaxNDpdN71A9hhLgjxh+KwObl6+bvy7EJ4RtJxY6xE0/BXMZeCg4boXbMvCbRgPv/
         C14wNRpOwlq6Bl1W5FQU4/KRi5lEgZDLiy7jdpvmIccrLVZTjbDUlroXcVR194cCo5dB
         XOK1ZfGdH4K6TnCsCrv1JjzCZwG7udSW4Qq/MeFO6lalDasXIdQ5hhT4oChzgf4uM7ul
         c+qQ==
X-Gm-Message-State: AOAM530EEBn0Tom8iClMVU5/SFYgwGcG19AcD7w9GlNj4DZlSBlc21tf
        wc6A0f2fExLt95znT90d6o4+q8rrR0c=
X-Google-Smtp-Source: ABdhPJyHJU5m8PuEWW2l/FQ0rvO0beZRBkRtL35MdGnFtms/U3GEtnYjTVNWcuhm8ev5DVdTyd2YRg==
X-Received: by 2002:aa7:9217:0:b0:518:367d:fa85 with SMTP id 23-20020aa79217000000b00518367dfa85mr14679610pfo.9.1653138979618;
        Sat, 21 May 2022 06:16:19 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id c2-20020a62f842000000b0051800111b2fsm3691795pfm.216.2022.05.21.06.16.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 May 2022 06:16:19 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V3 04/12] KVM: X86/MMU: Add local shadow pages
Date:   Sat, 21 May 2022 21:16:52 +0800
Message-Id: <20220521131700.3661-5-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220521131700.3661-1-jiangshanlai@gmail.com>
References: <20220521131700.3661-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

Local shadow pages are shadow pages to hold PDPTEs for 32bit guest or
higher level shadow pages having children local shadow pages when
shadowing nested NPT for 32bit L1 in 64 bit L0.

Current code use mmu->pae_root, mmu->pml4_root, and mmu->pml5_root to
setup local root page.  The initialization code is complex and the root
pages are not associated with struct kvm_mmu_page which causes the code
more complex.

Add kvm_mmu_alloc_local_shadow_page() and mmu_free_local_root_page() to
allocate and free local shadow pages and prepare for using local
shadow pages to replace current logic and share the most logic with
non-local shadow pages.

The code is not activated since using_local_root_page() is false in
the place where it is inserted.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 109 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 108 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 240ebe589caf..c941a5931bc3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1764,6 +1764,76 @@ static bool using_local_root_page(struct kvm_mmu *mmu)
 		return mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL;
 }
 
+/*
+ * Local shadow pages are shadow pages to hold PDPTEs for 32bit guest or higher
+ * level shadow pages having children local shadow pages when shadowing nested
+ * NPT for 32bit L1 in 64 bit L0.
+ *
+ * Local shadow pages are often local shadow root pages (or local root pages for
+ * short) except when shadowing nested NPT for 32bit L1 in 64 bit L0 which has
+ * 2 or 3 levels of local shadow pages on top of non-local shadow pages.
+ *
+ * Local shadow pages are locally allocated.  If the local shadow page's level
+ * is PT32E_ROOT_LEVEL, it will use the preallocated mmu->pae_root for its
+ * sp->spt.  Because sp->spt may need to be put in the 32 bits CR3 (even in
+ * x86_64) or decrypted.  Using the preallocated one to handle these
+ * requirements makes the allocation simpler.
+ *
+ * Local shadow pages are only visible to local VCPU except through
+ * sp->parent_ptes rmap from their children, so they are not in the
+ * kvm->arch.active_mmu_pages nor in the hash.
+ *
+ * And they are neither accounted nor write-protected since they don't shadow a
+ * guest page table.
+ *
+ * Because of above, local shadow pages can not be freed nor zapped like
+ * non-local shadow pages.  They are freed directly when the local root page
+ * is freed, see mmu_free_local_root_page().
+ *
+ * Local root page can not be put on mmu->prev_roots because the comparison
+ * must use PDPTEs instead of CR3 and mmu->pae_root can not be shared for multi
+ * local root pages.
+ *
+ * Except above limitations, all the other abilities are the same as other
+ * shadow page, like link, parent rmap, sync, unsync etc.
+ *
+ * Local shadow pages can be obsoleted in a little different way other than
+ * the non-local shadow pages.  When the obsoleting process is done, all the
+ * obsoleted non-local shadow pages are unlinked from the local shadow pages
+ * by the help of the sp->parent_ptes rmap and the local shadow pages become
+ * theoretically valid again except sp->mmu_valid_gen may be still outdated.
+ * If there is no other event to cause a VCPU to free the local root page and
+ * the VCPU is being preempted by the host during two obsoleting processes,
+ * sp->mmu_valid_gen might become valid again and the VCPU can reuse it when
+ * the VCPU is back.  It is different from the non-local shadow pages which
+ * are always freed after obsoleted.
+ */
+static struct kvm_mmu_page *
+kvm_mmu_alloc_local_shadow_page(struct kvm_vcpu *vcpu, union kvm_mmu_page_role role)
+{
+	struct kvm_mmu_page *sp;
+
+	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
+	sp->gfn = 0;
+	sp->role = role;
+	/*
+	 * Use the preallocated mmu->pae_root when the shadow page's
+	 * level is PT32E_ROOT_LEVEL which may need to be put in the 32 bits
+	 * CR3 (even in x86_64) or decrypted.  The preallocated one is prepared
+	 * for the requirements.
+	 */
+	if (role.level == PT32E_ROOT_LEVEL &&
+	    !WARN_ON_ONCE(!vcpu->arch.mmu->pae_root))
+		sp->spt = vcpu->arch.mmu->pae_root;
+	else
+		sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	/* sp->gfns is not used for local shadow page */
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
+
+	return sp;
+}
+
 static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
 {
 	struct kvm_mmu_page *sp;
@@ -2121,6 +2191,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	if (level <= vcpu->arch.mmu->cpu_role.base.level)
 		role.passthrough = 0;
 
+	if (unlikely(level >= PT32E_ROOT_LEVEL && using_local_root_page(vcpu->arch.mmu)))
+		return kvm_mmu_alloc_local_shadow_page(vcpu, role);
+
 	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
 		if (sp->gfn != gfn) {
@@ -3351,6 +3424,37 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	*root_hpa = INVALID_PAGE;
 }
 
+static void mmu_free_local_root_page(struct kvm *kvm, struct kvm_mmu *mmu)
+{
+	u64 spte = mmu->root.hpa;
+	struct kvm_mmu_page *sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
+	int i;
+
+	/* Free level 5 or 4 roots for shadow NPT for 32 bit L1 */
+	while (sp->role.level > PT32E_ROOT_LEVEL)
+	{
+		spte = sp->spt[0];
+		mmu_page_zap_pte(kvm, sp, sp->spt + 0, NULL);
+		free_page((unsigned long)sp->spt);
+		kmem_cache_free(mmu_page_header_cache, sp);
+		if (!is_shadow_present_pte(spte))
+			return;
+		sp = to_shadow_page(spte & PT64_BASE_ADDR_MASK);
+	}
+
+	if (WARN_ON_ONCE(sp->role.level != PT32E_ROOT_LEVEL))
+		return;
+
+	/* Disconnect PAE root from the 4 PAE page directories */
+	for (i = 0; i < 4; i++)
+		mmu_page_zap_pte(kvm, sp, sp->spt + i, NULL);
+
+	if (sp->spt != mmu->pae_root)
+		free_page((unsigned long)sp->spt);
+
+	kmem_cache_free(mmu_page_header_cache, sp);
+}
+
 /* roots_to_free must be some combination of the KVM_MMU_ROOT_* flags */
 void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 			ulong roots_to_free)
@@ -3384,7 +3488,10 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 
 	if (free_active_root) {
 		if (to_shadow_page(mmu->root.hpa)) {
-			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
+			if (using_local_root_page(mmu))
+				mmu_free_local_root_page(kvm, mmu);
+			else
+				mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
 		} else if (mmu->pae_root) {
 			for (i = 0; i < 4; ++i) {
 				if (!IS_VALID_PAE_ROOT(mmu->pae_root[i]))
-- 
2.19.1.6.gb485710b

