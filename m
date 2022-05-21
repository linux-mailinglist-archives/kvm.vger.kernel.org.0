Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCC152FCCC
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 15:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355215AbiEUNSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 09:18:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355286AbiEUNRV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 09:17:21 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 905015711A;
        Sat, 21 May 2022 06:16:55 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id z7-20020a17090abd8700b001df78c7c209so13669711pjr.1;
        Sat, 21 May 2022 06:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7UpZ3vIydYQbJynx9tacn2HIuDZ985w6Pm7fWZXYM7w=;
        b=EJWfcKYnX1rQp5r6kuYIXe1wjGTHsJYqMxVi5VudrwxjdyVc58p7R1dws9TWHRztkc
         2sPS30RSdGAAczzjtJEVTdQAxvXZmr1s4LyJTRGU2FY1j3haLZrEFHdqWmi1UKPjyDya
         4Ewiou/3alhfuaGRx2wxx5ibL5yiJ9mpASzUuvDuOnX9rfura0iAFaA/+VqAi5nb5cad
         szE3YVcWeKekXqNwYJc89glgsLp0JivjUJsVl+qNKxGCbN15DURC0a/UBCd9PtFCoj8w
         tMONC3Y3I4/yTRuKwJVyZAQJnFVOypUjkapBjnuvUTzLs/hVSjMHr+ddQpiA9B5+2r2f
         CBjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7UpZ3vIydYQbJynx9tacn2HIuDZ985w6Pm7fWZXYM7w=;
        b=Bejzkt9J1hH33e8WgNNETHoJrvcmvLWayRkdO2rGjL3bYm6QSPrAw6IiTaEA3iRZ1t
         P0NJLt2vJ2QhmVhKYnKtFehRF9GRfa5nKIX9F+2ebYCBCawIDJSS6QHG9hFJbdKuq6rC
         vh3p3RkCGg4UlQK+r9iujhY47cpR5GsJrTNLp440nRYSHapVf5xLoMLHTJUlHtr6jh5m
         tGevegX8PIOqnArfZxV//RQiE1y51bMV8MkBmT5W0FfQjHljLs4i52ZFfTvXdzuZKana
         2cDGs5K9nSykE08BoeBnLkqhnGtReUxb1ObFXkfs9rSVEx0enWSunqJQx9+1e5qjt+Xa
         faVg==
X-Gm-Message-State: AOAM5322nOQpeN5qE1Dz5OCBLFJgG1ebOThwhpyh2xvnIH4mH2KBbxCC
        pGewJt8GQ1Ka4HwXXR4BmCk1AYJSI9w=
X-Google-Smtp-Source: ABdhPJxjzMuiA+NbmaXQWcxLn28moQWTn0wy0OgupI8O1H4w7hXVHwDDeognYbk3aS3Hgpddq1Q7Pg==
X-Received: by 2002:a17:90b:4a8d:b0:1dc:3769:20fc with SMTP id lp13-20020a17090b4a8d00b001dc376920fcmr17013667pjb.114.1653139009561;
        Sat, 21 May 2022 06:16:49 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id z24-20020a62d118000000b005182d505389sm3514208pfg.72.2022.05.21.06.16.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 May 2022 06:16:49 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V3 12/12] KVM: X86/MMU: Remove mmu_alloc_special_roots()
Date:   Sat, 21 May 2022 21:17:00 +0800
Message-Id: <20220521131700.3661-13-jiangshanlai@gmail.com>
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
index fb9751dfc1a7..ec44e6c3d5ea 100644
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
index 73e6a8e1e1a9..b8eed217314d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3691,78 +3691,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
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
@@ -5166,9 +5094,6 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	r = mmu_alloc_pae_root(vcpu);
 	if (r)
 		return r;
-	r = mmu_alloc_special_roots(vcpu);
-	if (r)
-		goto out;
 	if (vcpu->arch.mmu->root_role.direct)
 		r = mmu_alloc_direct_roots(vcpu);
 	else
@@ -5626,8 +5551,6 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
 	if (!tdp_enabled && mmu->pae_root)
 		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
 	free_page((unsigned long)mmu->pae_root);
-	free_page((unsigned long)mmu->pml4_root);
-	free_page((unsigned long)mmu->pml5_root);
 }
 
 static void __kvm_mmu_create(struct kvm_mmu *mmu)
-- 
2.19.1.6.gb485710b

