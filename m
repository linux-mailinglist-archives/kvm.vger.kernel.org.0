Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EADA5187E2
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 17:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237834AbiECPKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 11:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237822AbiECPKr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 11:10:47 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C546F3A5EF;
        Tue,  3 May 2022 08:07:11 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l11-20020a17090a49cb00b001d923a9ca99so2250797pjm.1;
        Tue, 03 May 2022 08:07:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qb1OZfWcrX3s64nlMigeTB4+OfsMRNk6EH8LkinW9Lc=;
        b=HS2d5+Rm8wskMXOrHiKXD21jBfs/ZZ2ImowGDsRpYjcX+inhb84xmhl7UMFHLD5BR6
         EJfcpxkF2xhTqqgTfzI8iP3Wm0l4Y40N2BQkQqytrlfySoiNtd6RWsPDhzn4wLEq7IYA
         cfG1jEhyz1emjb3lUIZyPmGQw1lKfUPBD/ViXomD9QSdCDb1kndALpsPgqCYVRC7dKoa
         4UbnXYNB1Mw5lvdYVduEFY/NG3P+71b3hCOWFTDZhdNdF2CecuibkBKkjru+mnabwxxp
         ny4H23c1/j7NS+DGI+NxoSUMRGOPVQZfpIgK+1uBTmCcSE3P48dZLRd/ruTKpsFkMDDJ
         sUYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qb1OZfWcrX3s64nlMigeTB4+OfsMRNk6EH8LkinW9Lc=;
        b=DVvyM1eYvBbIMY59X77z0A0QW+HqZDMSDrF0QLGiyAqWTO+77B0kQAtH3POiXoOaZv
         mDusUIHEUrD/NWc21Ke4w/JGFHgN3N34ftJ3wND67VlRoWnOowqG6MWSM11209340Jm+
         CJU+kkjz4+u+9UmaSsHQ/e3Tmlj/Xl9dB9rZbjmDcVpwYdzOCkog5Jo/R35n6R+AJ+kL
         gf4LT9Xk8hotH8Y9UifujgCSnjiPn6WmKtbR0Nj0yb9Js6lrqPyBy6GcvjuYaNXjsYXV
         cnoVdxDL0WObVP1LhKh1PdL9cN2+EfbGr4OI3Kh1LJrqO+XrXDDU+HRXo4CgxdXyGyxq
         WkZw==
X-Gm-Message-State: AOAM531LLP1+PYDEe9VAGYwglMKAjWWvzlyR8gcpaQ2M6KtnrxpPcNLJ
        3tuclz0oFEwFw7IG+vQ7JgueBIA7yfk=
X-Google-Smtp-Source: ABdhPJy5qUj8xjcOlYeyubqBE4phbRukJvviCi7XahmDe2GER2lcY93+EhRYbsil1gTEh8Z8qPGCVg==
X-Received: by 2002:a17:902:9f97:b0:15d:1b87:6164 with SMTP id g23-20020a1709029f9700b0015d1b876164mr16603468plq.71.1651590431074;
        Tue, 03 May 2022 08:07:11 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id x7-20020a1709028ec700b0015e8d4eb205sm6424499plo.79.2022.05.03.08.07.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 May 2022 08:07:10 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH V2 2/7] KVM: X86/MMU: Add special shadow pages
Date:   Tue,  3 May 2022 23:07:30 +0800
Message-Id: <20220503150735.32723-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220503150735.32723-1-jiangshanlai@gmail.com>
References: <20220503150735.32723-1-jiangshanlai@gmail.com>
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

Special pages are pages to hold PDPTEs for 32bit guest or higher
level pages linked to special page when shadowing NPT.

Current code use mmu->pae_root, mmu->pml4_root, and mmu->pml5_root to
setup special root.  The initialization code is complex and the roots
are not associated with struct kvm_mmu_page which causes the code more
complex.

Add kvm_mmu_alloc_special_page() and mmu_free_special_root_page() to
allocate and free special shadow pages and prepare for using special
shadow pages to replace current logic and share the most logic with
normal shadow pages.

The code is not activated since using_special_root_page() is false in
the place where it is inserted.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/mmu.c | 91 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 90 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7f20796af351..126f0cd07f98 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1719,6 +1719,58 @@ static bool using_special_root_page(struct kvm_mmu *mmu)
 		return mmu->cpu_role.base.level <= PT32E_ROOT_LEVEL;
 }
 
+/*
+ * Special pages are pages to hold PAE PDPTEs for 32bit guest or higher level
+ * pages linked to special page when shadowing NPT.
+ *
+ * Special pages are specially allocated.  If sp->spt needs to be 32bit, it
+ * will use the preallocated mmu->pae_root.
+ *
+ * Special pages are only visible to local VCPU except through rmap from their
+ * children, so they are not in the kvm->arch.active_mmu_pages nor in the hash.
+ *
+ * And they are either accounted nor write-protected since they don't has gfn
+ * associated.
+ *
+ * Because of above, special pages can not be freed nor zapped like normal
+ * shadow pages.  They are freed directly when the special root is freed, see
+ * mmu_free_special_root_page().
+ *
+ * Special root page can not be put on mmu->prev_roots because the comparison
+ * must use PDPTEs instead of CR3 and mmu->pae_root can not be shared for multi
+ * root pages.
+ *
+ * Except above limitations, all the other abilities are the same as other
+ * shadow page, like link, parent rmap, sync, unsync etc.
+ *
+ * Special pages can be obsoleted but might be possibly reused later.  When
+ * the obsoleting process is done, all the obsoleted shadow pages are unlinked
+ * from the special pages by the help of the parent rmap of the children and
+ * the special pages become theoretically valid again.  If there is no other
+ * event to cause a VCPU to free the root and the VCPU is being preempted by
+ * the host during two obsoleting processes, the VCPU can reuse its special
+ * pages when it is back.
+ */
+static struct kvm_mmu_page *kvm_mmu_alloc_special_page(struct kvm_vcpu *vcpu,
+		union kvm_mmu_page_role role)
+{
+	struct kvm_mmu_page *sp;
+
+	sp = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_page_header_cache);
+	sp->gfn = 0;
+	sp->role = role;
+	if (role.level == PT32E_ROOT_LEVEL &&
+	    vcpu->arch.mmu->root_role.level == PT32E_ROOT_LEVEL)
+		sp->spt = vcpu->arch.mmu->pae_root;
+	else
+		sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	/* sp->gfns is not used for special shadow page */
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
+
+	return sp;
+}
+
 static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
 {
 	struct kvm_mmu_page *sp;
@@ -2076,6 +2128,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	if (level <= vcpu->arch.mmu->cpu_role.base.level)
 		role.passthrough = 0;
 
+	if (unlikely(level >= PT32E_ROOT_LEVEL && using_special_root_page(vcpu->arch.mmu)))
+		return kvm_mmu_alloc_special_page(vcpu, role);
+
 	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
 		if (sp->gfn != gfn) {
@@ -3290,6 +3345,37 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
 	*root_hpa = INVALID_PAGE;
 }
 
+static void mmu_free_special_root_page(struct kvm *kvm, struct kvm_mmu *mmu)
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
+	/* Free PAE roots */
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
@@ -3323,7 +3409,10 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 
 	if (free_active_root) {
 		if (to_shadow_page(mmu->root.hpa)) {
-			mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
+			if (using_special_root_page(mmu))
+				mmu_free_special_root_page(kvm, mmu);
+			else
+				mmu_free_root_page(kvm, &mmu->root.hpa, &invalid_list);
 		} else if (mmu->pae_root) {
 			for (i = 0; i < 4; ++i) {
 				if (!IS_VALID_PAE_ROOT(mmu->pae_root[i]))
-- 
2.19.1.6.gb485710b

