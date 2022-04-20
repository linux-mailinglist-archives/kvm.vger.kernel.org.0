Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0276C50894A
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 15:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379068AbiDTN2x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 09:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379059AbiDTN2t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 09:28:49 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB3E842A00;
        Wed, 20 Apr 2022 06:26:01 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id j8so1747558pll.11;
        Wed, 20 Apr 2022 06:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hj08weOnMiNuvuHVFNgvhLkhm3HK1Sro404l1Lgvx5w=;
        b=dQ+WiKwx0u/NmwBwydj2yJ1x8OVhFo/mHdn0LkOYsir5MmvEhpCLhJm/Yzyes8fgwu
         qQjJ65wunCxFnKvDDMmJfnTTGYHbHXrUzUKzBwmYme61y0syvzoFbZGXHSBMAXSgtFP9
         2Q2Ad6VtfEmcpqBVTlFXKeSxCxfEt4hTXShrSkJfrCCcGv0PF0esZ8fOcR6xxgXx54wE
         QtYKsX0irPO8Sl3teQ7Fet+7UQiVW2A7Ed1rd/NZFAg7tickWu7hPWAxnOU/Twe7J4W0
         PftUVvquEjFyvq75OqeD45O/THW+Ihrgkw0NLqIOoAvyS1yy6REzdUMqTHI+aHIFdo3H
         4q1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hj08weOnMiNuvuHVFNgvhLkhm3HK1Sro404l1Lgvx5w=;
        b=s0OopmQllmra15MOtWImzk+T3Hc0ZIM8OEwhLfCp4yw/879gwxrGllFg5u1dELSQBJ
         sLedOzmlbTjxl9MOBfUSayE7sYgSOXEhlyrVX5To6Pv4RXBPc70ZDn/D+jvQock/M5cm
         LMC1k8BwK8UXRdkHQeOMoHGcU6vhdsY5ZzHKAJGNIZpOxzWqLhs7t7qCIQp1D8t6QLDo
         RDK5K1kdu5cMy5kU5jHGpOTqzDMJwu7MueXZBA+gWg/ZCy6YpFRLfLBf8DQff/hR99Q8
         jc8TVIyFJeZWcDv+tkrxRiFBYyl7ZKnjn4bFi7GrtWfVTk51DMPVGf2xuvF9q75AFxmy
         C+dQ==
X-Gm-Message-State: AOAM533NFxiY3X3uu6Y3MV+1W0McT5rD0x7ks8RPZATmeyqR2gwZ5gqs
        VRw6x//OAc2O2xAhTYY+4iMgMcBDsRg=
X-Google-Smtp-Source: ABdhPJy486mRkFHpISnRUJKz6ZAlNggZCTjfunDQffEZynbc8jWDKiMf6Zrhc5uO/NzhUIZj1gKGtQ==
X-Received: by 2002:a17:902:8b8a:b0:158:fbd0:45ab with SMTP id ay10-20020a1709028b8a00b00158fbd045abmr14527557plb.110.1650461161319;
        Wed, 20 Apr 2022 06:26:01 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id f187-20020a6251c4000000b005058e59604csm20451115pfb.217.2022.04.20.06.26.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Apr 2022 06:26:01 -0700 (PDT)
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
Subject: [PATCH 7/7] KVM: X86/MMU: Remove mmu_alloc_special_roots()
Date:   Wed, 20 Apr 2022 21:26:05 +0800
Message-Id: <20220420132605.3813-8-jiangshanlai@gmail.com>
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

mmu_alloc_special_roots() allocates mmu->pae_root for non-PAE paging
(as for shadowing 32bit NPT on 64 bit host) and mmu->pml4_root and
mmu->pml5_root.

But mmu->pml4_root and mmu->pml5_root is not used, neither mmu->pae_root
for non-PAE paging.

So remove mmu_alloc_special_roots(), mmu->pml4_root and mmu->pml5_root.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |  3 --
 arch/x86/kvm/mmu/mmu.c          | 76 ---------------------------------
 2 files changed, 79 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d4f8f4784d87..8bfebe509c09 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -462,9 +462,6 @@ struct kvm_mmu {
 	u32 pkru_mask;
 
 	u64 *pae_root;
-	u64 *pml4_root;
-	u64 *pml5_root;
-
 	/*
 	 * check zero bits on shadow page table entries, these
 	 * bits include not only hardware reserved bits but also
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2f590779ee39..b16255c00c5a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3571,77 +3571,6 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	return r;
 }
 
-static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
-{
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
-	bool need_pml5 = mmu->shadow_root_level > PT64_ROOT_4LEVEL;
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
-	if (mmu->direct_map || mmu->root_level >= PT64_ROOT_4LEVEL ||
-	    mmu->shadow_root_level < PT64_ROOT_4LEVEL)
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
@@ -5074,9 +5003,6 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	r = mmu_alloc_pae_root(vcpu);
 	if (r)
 		return r;
-	r = mmu_alloc_special_roots(vcpu);
-	if (r)
-		goto out;
 	if (vcpu->arch.mmu->direct_map)
 		r = mmu_alloc_direct_roots(vcpu);
 	else
@@ -5534,8 +5460,6 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
 	if (!tdp_enabled && mmu->pae_root)
 		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
 	free_page((unsigned long)mmu->pae_root);
-	free_page((unsigned long)mmu->pml4_root);
-	free_page((unsigned long)mmu->pml5_root);
 }
 
 static void __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
-- 
2.19.1.6.gb485710b

