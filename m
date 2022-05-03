Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 360135187F8
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 17:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbiECPLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 11:11:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237974AbiECPLe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 11:11:34 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 951FE3B003;
        Tue,  3 May 2022 08:07:44 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id z5-20020a17090a468500b001d2bc2743c4so2276026pjf.0;
        Tue, 03 May 2022 08:07:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CvIzqjRFmBZqDKM3YBA+6SE4L5Kw85emmH8U3ax6N1U=;
        b=oqhdLqtC6VpBhPrh+qFFKv1be2TnSACs+D+0e2CX7ik7ELqMptOxsJ2skPZUkwXV4Q
         st1U525pvycm/d1iK3WNfICsY+4I/td+fW/VTJbsLWTSiFSyAq7wMQcuygHkvGlSIXDS
         2Um2EBbyl/SmzNK1Q+m8M0Ocz+szthhsqhBfs+RDKPt5qczKEIKqxc9f4WL/Y4zdCgs1
         pRme6XDdW3WRjX1ZdzE8aVAIOhEe3gMxnCWAj4TSeoa3DBjhC5ed5or4oZsVf/N465mD
         mLqO8Q+sG6JlH51tD0yeG5H66tE+pykf+PrZ/8+079OKcxBGaE8bcwiJClMWJIjNZLV1
         uN4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CvIzqjRFmBZqDKM3YBA+6SE4L5Kw85emmH8U3ax6N1U=;
        b=IyXTGFIdKadqbEz3QY9sYIVMAY6BZR8VOF6Ag44gQ9trgd8jdf44qnXPspUDmqj1Er
         8b9rSYdZQmY31nDuyNDbDQP+vZvt6Xswzb0sIq66wwHhFIa6MeEkdxWZ+xTdqgcUDf9L
         bgPkm/XbD6wb9hiod9onjJ/K+OeEDFc6ZS2v2sq8vjJWt5z7Z15dC49qrMmVrYapOeQr
         PXAn/P30suP1LSS7SoNDGXjpUfZgtNOZ9wxRX1ePRYGTEr9JCemi9jppSyQScaGcC01l
         wfqKyiQjEyUiYdLYtQ6MuD/bzcmBKdaUOzWCCzCQjgn59idIirRDJweg02HQ+jVB7Dw6
         5dIw==
X-Gm-Message-State: AOAM530PWTcv9SeUTAlls2ui6FclSPLPmJ2Mcfz+8ZI0y9AV0AJ2hY7i
        WpQa3DZsqMlBOyF9vR9y0NfQCPQIKYM=
X-Google-Smtp-Source: ABdhPJxSGxrW4COyzE8eFw7nKWndA6yDljerOkbDVo3vABhxVSI3SNlxli6RIiBvTXpzCNXmprznhA==
X-Received: by 2002:a17:903:40c3:b0:15e:9d4a:5d24 with SMTP id t3-20020a17090340c300b0015e9d4a5d24mr12079516pld.77.1651590463801;
        Tue, 03 May 2022 08:07:43 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id o20-20020a17090ac09400b001cd4989ff65sm1449832pjs.44.2022.05.03.08.07.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 May 2022 08:07:43 -0700 (PDT)
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
Subject: [PATCH V2 7/7] KVM: X86/MMU: Remove mmu_alloc_special_roots()
Date:   Tue,  3 May 2022 23:07:35 +0800
Message-Id: <20220503150735.32723-8-jiangshanlai@gmail.com>
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

mmu_alloc_special_roots() allocates mmu->pae_root for non-PAE paging
(as for shadowing 32bit NPT on 64 bit host) and mmu->pml4_root and
mmu->pml5_root.

But mmu->pml4_root and mmu->pml5_root is not used, neither mmu->pae_root
for non-PAE paging.

So remove mmu_alloc_special_roots(), mmu->pml4_root and mmu->pml5_root.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |  3 --
 arch/x86/kvm/mmu/mmu.c          | 77 ---------------------------------
 2 files changed, 80 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c59fea4bdb6e..e647587d1d1f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -458,9 +458,6 @@ struct kvm_mmu {
 	u8 permissions[16];
 
 	u64 *pae_root;
-	u64 *pml4_root;
-	u64 *pml5_root;
-
 	/*
 	 * check zero bits on shadow page table entries, these
 	 * bits include not only hardware reserved bits but also
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c97f830c5f8c..9c04acf9728a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3611,78 +3611,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	return r;
 }
 
-static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
-{
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	bool need_pml5 = mmu->root_role.level > PT64_ROOT_4LEVEL;
-	u64 *pml5_root = NULL;
-	u64 *pml4_root = NULL;
-	u64 *pae_root;
-
-	/*
-	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
-	 * tables are allocated and initialized at root creation as there is no
-	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
-	 * on demand, as running a 32-bit L1 VMM on 64-bit KVM is very rare.
-	 */
-	if (mmu->root_role.direct ||
-	    mmu->cpu_role.base.level >= PT64_ROOT_4LEVEL ||
-	    mmu->root_role.level < PT64_ROOT_4LEVEL)
-		return 0;
-
-	/*
-	 * NPT, the only paging mode that uses this horror, uses a fixed number
-	 * of levels for the shadow page tables, e.g. all MMUs are 4-level or
-	 * all MMus are 5-level.  Thus, this can safely require that pml5_root
-	 * is allocated if the other roots are valid and pml5 is needed, as any
-	 * prior MMU would also have required pml5.
-	 */
-	if (mmu->pae_root && mmu->pml4_root && (!need_pml5 || mmu->pml5_root))
-		return 0;
-
-	/*
-	 * The special roots should always be allocated in concert.  Yell and
-	 * bail if KVM ends up in a state where only one of the roots is valid.
-	 */
-	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->pml4_root ||
-			 (need_pml5 && mmu->pml5_root)))
-		return -EIO;
-
-	/*
-	 * Unlike 32-bit NPT, the PDP table doesn't need to be in low mem, and
-	 * doesn't need to be decrypted.
-	 */
-	pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-	if (!pae_root)
-		return -ENOMEM;
-
-#ifdef CONFIG_X86_64
-	pml4_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-	if (!pml4_root)
-		goto err_pml4;
-
-	if (need_pml5) {
-		pml5_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-		if (!pml5_root)
-			goto err_pml5;
-	}
-#endif
-
-	mmu->pae_root = pae_root;
-	mmu->pml4_root = pml4_root;
-	mmu->pml5_root = pml5_root;
-
-	return 0;
-
-#ifdef CONFIG_X86_64
-err_pml5:
-	free_page((unsigned long)pml4_root);
-err_pml4:
-	free_page((unsigned long)pae_root);
-	return -ENOMEM;
-#endif
-}
-
 static bool is_unsync_root(hpa_t root)
 {
 	struct kvm_mmu_page *sp;
@@ -5069,9 +4997,6 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	r = mmu_alloc_pae_root(vcpu);
 	if (r)
 		return r;
-	r = mmu_alloc_special_roots(vcpu);
-	if (r)
-		goto out;
 	if (vcpu->arch.mmu->root_role.direct)
 		r = mmu_alloc_direct_roots(vcpu);
 	else
@@ -5529,8 +5454,6 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
 	if (!tdp_enabled && mmu->pae_root)
 		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
 	free_page((unsigned long)mmu->pae_root);
-	free_page((unsigned long)mmu->pml4_root);
-	free_page((unsigned long)mmu->pml5_root);
 }
 
 static void __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
-- 
2.19.1.6.gb485710b

