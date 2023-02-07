Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238A868DD69
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 16:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbjBGP43 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 10:56:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbjBGP4X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 10:56:23 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8FE28850;
        Tue,  7 Feb 2023 07:56:22 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 78so10712657pgb.8;
        Tue, 07 Feb 2023 07:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=52gmGFk0S/EI3/tgfOzdMgf+mQOxiRfHBzVFZtJM5HI=;
        b=HjrTclXdWf1pzZiCYqcCUtzZBBqLeOZfUkCvLwpTsrVUEMkg9esqxssiIFn8Ysb+N2
         V92Q0Q9Llwc46gy4N22/9EBEX5i+buUK8llS9ztKyFUUOChzPBgeEL0ltxUc3yzmbYME
         D0FTrO2Df1Ong2tsYimdupTUa+lpsnX3kORzFe43gNB/ZFcpUrpfAUSF2HGtfz5Yi/KS
         iiJk8yYoToQrmzL8g0Sffci+TMK2EQN+hhWCCauxfWc+Oei+7jUXIEexseAtvuodkFKA
         gnpNw0vwhq7mrPqJigg7/UkzBm03f1J72g1KZ0ArhiVf0BanLxTJjNw5tVB2SI0giD5O
         BEzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=52gmGFk0S/EI3/tgfOzdMgf+mQOxiRfHBzVFZtJM5HI=;
        b=reX5psNJIUca6Vht99Sk7uIVTBE3T2AJaTKG5HuN6Hx5a/l4kJXPsAAMOX0/gXzaE9
         sc6T3yyfskeawDjdhVN9yHAV7P5GEIeghm0UtgV+8eAU5FkbotNccDwuW310e2dPBJoS
         LzgNxt/uvn9o/tGW4SGxtAlrLGJHki4CpXpR/kZyJdb1JsDl5QtmaPRP919WGcpNN3vd
         jhbwfamO/DyiK7fqPdhyn6nPvuhZrTPoqbS1oS6z8uQ8J7VZ2OTrnlKMk1Th7cD2FzHn
         M8hvBEJ9mcr9C9lUoATojjuNbDk51df19WTUX/PmzVbPTWol0nNu+d7LGNEbBhvX2DtB
         FtTA==
X-Gm-Message-State: AO0yUKXGdEcnKx/J4e7XLUmyxae3+KSbX0V//5U7JQex2f/3A/ZQG8ZV
        QlfmyJaOpHgko2LbQXsPBQ2rkmBBtZU=
X-Google-Smtp-Source: AK7set/Jd6stMkH3hTzys0MvdDjYSvqdc+G5YoiCol+EIwItiMiesIOcJa9KQQPjvZcYdJInKz4f2Q==
X-Received: by 2002:a62:1b43:0:b0:593:b37c:c7ad with SMTP id b64-20020a621b43000000b00593b37cc7admr3175876pfb.22.1675785381377;
        Tue, 07 Feb 2023 07:56:21 -0800 (PST)
Received: from localhost ([47.88.5.130])
        by smtp.gmail.com with ESMTPSA id a24-20020aa79718000000b00593b82ea1cesm9351115pfg.49.2023.02.07.07.56.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Feb 2023 07:56:20 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH V2 1/8] kvm: x86/mmu: Use KVM_MMU_ROOT_XXX for kvm_mmu_invalidate_gva()
Date:   Tue,  7 Feb 2023 23:57:27 +0800
Message-Id: <20230207155735.2845-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20230207155735.2845-1-jiangshanlai@gmail.com>
References: <20230207155735.2845-1-jiangshanlai@gmail.com>
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
or INVALID_PAGE where @mmu->root.hpa is to invalidate gva for the current
root (the same meaning as KVM_MMU_ROOT_CURRENT) and INVALID_PAGE is to
invalidate gva for all roots (the same meaning as KVM_MMU_ROOTS_ALL).

Change the argument type of kvm_mmu_invalidate_gva() and use
KVM_MMU_ROOT_XXX instead so that we can reuse the function for
kvm_mmu_invpcid_gva() and nested_ept_invalidate_addr() for invalidating
gva for different set of roots.

No fuctionalities changed.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 39 +++++++++++++++++----------------
 arch/x86/kvm/x86.c              |  2 +-
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4d2bc08794e4..81429a5640d6 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2026,7 +2026,7 @@ int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
 		       void *insn, int insn_len);
 void kvm_mmu_invlpg(struct kvm_vcpu *vcpu, gva_t gva);
 void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			    gva_t gva, hpa_t root_hpa);
+			    gva_t gva, unsigned long roots);
 void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid);
 void kvm_mmu_new_pgd(struct kvm_vcpu *vcpu, gpa_t new_pgd);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c91ee2927dd7..958e8eb977ed 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5707,10 +5707,12 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 EXPORT_SYMBOL_GPL(kvm_mmu_page_fault);
 
 void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
-			    gva_t gva, hpa_t root_hpa)
+			    gva_t gva, unsigned long roots)
 {
 	int i;
 
+	WARN_ON_ONCE(roots & ~KVM_MMU_ROOTS_ALL);
+
 	/* It's actually a GPA for vcpu->arch.guest_mmu.  */
 	if (mmu != &vcpu->arch.guest_mmu) {
 		/* INVLPG on a non-canonical address is a NOP according to the SDM.  */
@@ -5723,31 +5725,30 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	if (!mmu->invlpg)
 		return;
 
-	if (root_hpa == INVALID_PAGE) {
+	if ((roots & KVM_MMU_ROOT_CURRENT) && VALID_PAGE(mmu->root.hpa))
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
+	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+		if ((roots & KVM_MMU_ROOT_PREVIOUS(i)) &&
+		    VALID_PAGE(mmu->prev_roots[i].hpa))
+			mmu->invlpg(vcpu, gva, mmu->prev_roots[i].hpa);
 	}
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
index 508074e47bc0..a81937a8fe0c 100644
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

