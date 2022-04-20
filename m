Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34E46508937
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:25:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379003AbiDTN2V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379004AbiDTN2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:28:17 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BC8427ED;
        Wed, 20 Apr 2022 06:25:31 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id s14-20020a17090a880e00b001caaf6d3dd1so4943137pjn.3;
        Wed, 20 Apr 2022 06:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u4JR4TrG0H2Ztu+GjBRHrn1iBgo6HKiDZ5uZ0oa5Bb8=;
        b=UsATndhIHRF6aIhKMAOsG7dQ9kILXn+YYfjH9L+Ypw/ARwAM1T4j3a/B/Gm3aGJ8E8
         AzvTtWqGsTjNeTIzcw54iPx2Q1g65kzOwAWwzLohbbcnd+ujgm+hAPyVl5r7yY1kZxEf
         5dcSjMQSolAneK7ub67uU2hmCkgr6qsiW771Toa+4CvYPpf9GX1a3K6NiJzmY4ArBh8Q
         8deYeGZdy0U72GJ3LHNOm6zhuCTqSNYMtKRzNd+ddkrv7GnX5rvXDRduh/EE79RDvJQS
         C3bEm221LV8Qm6pHn/LidL4tPWDsaFK/rBZaBzWJrm1En0cvxOsoyQKHgse6PXNf/Lae
         Tqjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u4JR4TrG0H2Ztu+GjBRHrn1iBgo6HKiDZ5uZ0oa5Bb8=;
        b=w1zcCUr8IWl3s+qk2Ihlg1j/xWcgedJ11iINV6W12Dy1mfu+pxZhHTyml/bSvNQ1FL
         ZwCAmdrgTYDn1vZB0xU9AKOiaVgmQntM8sNfyaGc3dQO6CqzsYugje7dtUTdlwnFEsER
         67ZNNPlmGbZvRHWSxnmN2VjaYkOujsvnNPqE6PlBb4k/KEUi3KC5BXqv/Y6Xjmokxw82
         HKCQBxSuHw9opZyM1LWF7wqAgp5SVsx7VWVp/EeVgBg7ES9wsTOeN29Mu1esUr+ltNq8
         ZaXdk6B0tyOpgEObGnpmj4Z4r8mw2H1hqOu6wHbsMTIoriLbrZKO/yWD2RfopRyiBqd0
         dVlQ==
X-Gm-Message-State: AOAM533mnRZtcP54liWQw1MlZSCoqMW2yV0Ggd9Ul9cJA+XlapMrp0lD
        SA4PZaizKZH9vPH1hByjOvDByOoupSo=
X-Google-Smtp-Source: ABdhPJwKkcZWHJi6rV+yveL/8P3vrSj3RQGriDszgVkuuqKgZ72L5odfXVBglqUjXW80THPCX+djCQ==
X-Received: by 2002:a17:902:aa8e:b0:158:e94b:7c92 with SMTP id d14-20020a170902aa8e00b00158e94b7c92mr19638339plr.126.1650461130320;
        Wed, 20 Apr 2022 06:25:30 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id y6-20020a17090a644600b001d2b4d3d406sm8255079pjm.33.2022.04.20.06.25.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 06:25:30 -0700 (PDT)
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
Subject: [PATCH 2/7] KVM: X86/MMU: Add special shadow pages
Date:   Wed, 20 Apr 2022 21:26:00 +0800
Message-Id: <20220420132605.3813-3-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20220420132605.3813-1-jiangshanlai@gmail.com>
References: <20220420132605.3813-1-jiangshanlai@gmail.com>
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
index 6461e499d305..f6eee1a2b1d6 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1722,6 +1722,58 @@ static bool using_special_root_page(struct kvm_mmu *mmu)
 		return mmu->root_level <= PT32E_ROOT_LEVEL;
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
+ * shadow page, like link, rmap, sync, unsync etc.
+ *
+ * Special pages can be obsoleted but might be possibly reused later.  When
+ * the obsoleting process is done, all the obsoleted shadow pages are unlinked
+ * from the special pages by the help of the rmap of the children and the
+ * special pages become theoretically valid again.  If there is no other event
+ * to cause a VCPU to free the root and the VCPU is being preempted by the host
+ * during two obsoleting processes, the VCPU can reuse its special pages when
+ * it is back.
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
+	    vcpu->arch.mmu->shadow_root_level == PT32E_ROOT_LEVEL)
+		sp->spt = vcpu->arch.mmu->pae_root;
+	else
+		sp->spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_shadow_page_cache);
+	/* sp->gfns is not used for special sp */
+	set_page_private(virt_to_page(sp->spt), (unsigned long)sp);
+	sp->mmu_valid_gen = vcpu->kvm->arch.mmu_valid_gen;
+
+	return sp;
+}
+
 static struct kvm_mmu_page *kvm_mmu_alloc_page(struct kvm_vcpu *vcpu, int direct)
 {
 	struct kvm_mmu_page *sp;
@@ -2081,6 +2133,9 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 	if (level <= vcpu->arch.mmu->root_level)
 		role.passthrough = 0;
 
+	if (unlikely(level >= PT32E_ROOT_LEVEL && using_special_root_page(vcpu->arch.mmu)))
+		return kvm_mmu_alloc_special_page(vcpu, role);
+
 	sp_list = &vcpu->kvm->arch.mmu_page_hash[kvm_page_table_hashfn(gfn)];
 	for_each_valid_sp(vcpu->kvm, sp, sp_list) {
 		if (sp->gfn != gfn) {
@@ -3250,6 +3305,37 @@ static void mmu_free_root_page(struct kvm *kvm, hpa_t *root_hpa,
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
@@ -3283,7 +3369,10 @@ void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 
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

