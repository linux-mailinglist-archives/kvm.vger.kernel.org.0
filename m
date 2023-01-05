Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8948065E863
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 10:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbjAEJ5w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 04:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbjAEJ5l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 04:57:41 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22414FD53;
        Thu,  5 Jan 2023 01:57:39 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id b145so20857316pfb.2;
        Thu, 05 Jan 2023 01:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7cSnQZtfOkc0nUwfeL6JgSa31TSiifLjEgKqY7YlAA=;
        b=XQDTYyfsrmhNgLvGzoVS5XkpzkqSziUmhaTw6oBQiA4k0nlkV8caq/WYT6adKmJTAA
         0SfkxW5noGqfvRZgsTSOqKUc21QZKbZTa3MHGsPw/IM5OAdjYyE+9xlOfz+i4RCszfCv
         bHKKlLvYFEtqJCbWGNJVlqTuWDA56WGANA6+T5gBoH8KkZ0KSgMP3zrK7G48TUS0y5GH
         ThAsBi2V35S2IZFEcKPivThc7sberYMDEzzMdUy2aBLhFjdQ3aSDytDA972qT0mULgsp
         Q3H24+zP+palAKCoBEm8zILd/GIFyU5DU0qjtCkrZMC6Sl/qBw2s3j8tUqPvee3Xn5Ym
         Svig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g7cSnQZtfOkc0nUwfeL6JgSa31TSiifLjEgKqY7YlAA=;
        b=r0drdT0LD7fVkb3+yBf7rV3w1qcc1f2bDvinBggKBWZAz0XE/O20XthXrWujgV+/Uw
         O55p0zozJVcOy//WAVraAqUmKbgb8cX+rmSbFtdJEKrvVgeEQNilUDCqkiJytV5W3U0V
         W4/WY+a/00YprUOOlJnwVUxliWHXf0qixkGs4CcKPrT8ak+2QWal3ueH2XXA0JKcRY5u
         U715w64oZ+9q2QWY9pzID2Hx78S4m8Gs/MN0QG2aqNbZlJv7+vzMQs0AiqLd5t3s/d5i
         JbJdk9EvFE8ST01CKNDCNTx0+MKkwOfl3Mp/5rpSKKxo6S38r9p7JhE1KREAyAF+Fml4
         ahpg==
X-Gm-Message-State: AFqh2kqxohkxhcu0SOtyobzjvK22FKj4gpPU82oSbK4PVy9z9lG2gik0
        mKlSzLgYzIST54IL3nqYO6HTt3Geatg=
X-Google-Smtp-Source: AMrXdXvv9E13hRW+atwVuESSkXXQ1OtpZh4Zr0GgqpMH5mfs0Qc2cF3GQQ65jSwGXnlbUmDHc/T8LA==
X-Received: by 2002:a62:19cd:0:b0:580:9935:ffdb with SMTP id 196-20020a6219cd000000b005809935ffdbmr39899653pfz.20.1672912658832;
        Thu, 05 Jan 2023 01:57:38 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id x30-20020aa79a5e000000b005827d78ff27sm7362308pfj.32.2023.01.05.01.57.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Jan 2023 01:57:38 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH 1/7] kvm: x86/mmu: Use KVM_MMU_ROOT_XXX for kvm_mmu_invalidate_gva()
Date:   Thu,  5 Jan 2023 17:58:42 +0800
Message-Id: <20230105095848.6061-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230105095848.6061-1-jiangshanlai@gmail.com>
References: <20230105095848.6061-1-jiangshanlai@gmail.com>
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

The @root_hpa for kvm_mmu_invalidate_gva() is called with @mmu->root.hpa
or INVALID_PAGE.

Replace them with KVM_MMU_ROOT_XXX.

No fuctionalities changed.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 39 ++++++++++++++++-----------------
 arch/x86/kvm/x86.c              |  2 +-
 3 files changed, 21 insertions(+), 22 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2f5bf581d00a..dbea616bccce 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2026,7 +2026,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			    gva_t gva, hpa_t root_hpa);
+			    gva_t gva, ulong roots_to_invalidate);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 5407649de547..90339b71bd56 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5693,8 +5693,9 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
+/* roots_to_invalidte must be some combination of the KVM_MMU_ROOT_* flags */
 void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			    gva_t gva, hpa_t root_hpa)
+			    gva_t gva, ulong roots_to_invalidate)
 {
 	int i;
 
@@ -5710,31 +5711,29 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	if (!mmu->invlpg)
 		return;
 
-	if (root_hpa == INVALID_PAGE) {
+	if ((roots_to_invalidate & KVM_MMU_ROOT_CURRENT) && VALID_PAGE(mmu->root.hpa))
 		mmu->invlpg(vcpu, gva, mmu->root.hpa);
 
-		/*
-		 * INVLPG is required to invalidate any global mappings for the VA,
-		 * irrespective of PCID. Since it would take us roughly similar amount
-		 * of work to determine whether any of the prev_root mappings of the VA
-		 * is marked global, or to just sync it blindly, so we might as well
-		 * just always sync it.
-		 *
-		 * Mappings not reachable via the current cr3 or the prev_roots will be
-		 * synced when switching to that cr3, so nothing needs to be done here
-		 * for them.
-		 */
-		for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
-			if (VALID_PAGE(mmu->prev_roots[i].hpa))
-				mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
-	} else {
-		mmu->invlpg(vcpu, gva, root_hpa);
-	}
+	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
+		if ((roots_to_invalidate & KVM_MMU_ROOT_PREVIOUS(i)) &&
+		    VALID_PAGE(mmu->prev_roots[i].hpa))
+			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
 }
 
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva)
 {
-	kvm_mmu_invalidate_gva(vcpu, vcpu->arch.walk_mmu, gva, INVALID_PAGE);
+	/*
+	 * INVLPG is required to invalidate any global mappings for the VA,
+	 * irrespective of PCID. Since it would take us roughly similar amount
+	 * of work to determine whether any of the prev_root mappings of the VA
+	 * is marked global, or to just sync it blindly, so we might as well
+	 * just always sync it.
+	 *
+	 * Mappings not reachable via the current cr3 or the prev_roots will be
+	 * synced when switching to that cr3, so nothing needs to be done here
+	 * for them.
+	 */
+	kvm_mmu_invalidate_gva(vcpu, vcpu->arch.walk_mmu, gva, KVM_MMU_ROOTS_ALL);
 	++vcpu->stat.invlpg;
 }
 EXPORT_SYMBOL_GPL(kvm_mmu_invlpg);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c936f8d28a53..4696cbb40545 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -799,7 +799,7 @@ void kvm_inject_emulated_page_fault(struct kvm_vcpu *vcpu,
 	if ((fault->error_code & PFERR_PRESENT_MASK) &&
 	    !(fault->error_code & PFERR_RSVD_MASK))
 		kvm_mmu_invalidate_gva(vcpu, fault_mmu, fault->address,
-				       fault_mmu->root.hpa);
+				       KVM_MMU_ROOT_CURRENT);
 
 	fault_mmu->inject_page_fault(vcpu, fault);
 }
-- 
2.19.1.6.gb485710b

