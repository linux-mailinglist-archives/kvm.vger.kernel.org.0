Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64F9552FCCB
	for <lists+kvm@lfdr.de>; Sat, 21 May 2022 15:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355250AbiEUNR1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 May 2022 09:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355181AbiEUNRQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 May 2022 09:17:16 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07C3A4BB9C;
        Sat, 21 May 2022 06:16:45 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y41so9856164pfw.12;
        Sat, 21 May 2022 06:16:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hnKZJ+lERgc4n/q9nnaVzYKEdHblpgWM0rWz+Lvu+Mc=;
        b=QPsRUKAOR+ryfVPMvsudsn3ngPhDRRPdZl0GI9yJ+LF4O/Vv+movozqHk/1gAlhl6Y
         bM73DVMLpI2J7LEwahTbQy4Sp+DqUFW11ozGhhOJUApAjjsHF5NByEBmDeJWeaZcdUZD
         iJojaM1+yHM2jNxyDpconiP8+a/YBqVo76V3U/3oDl3DIxO9g9bBcwryaJh9xKzl/GnJ
         wz+lqlBxvqptoq7TPTFL+9xGDvIJg6nI4iSXHcwuVJ9KnuYCYWo52bdMpBMSIn1FnQGx
         QyGrXMEngTQWSeoY1zLHkd19AWdlo/qsLjR57LxYN+TZ38gvzyC2LJ/sUTQ/yM7dLRgi
         pabg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hnKZJ+lERgc4n/q9nnaVzYKEdHblpgWM0rWz+Lvu+Mc=;
        b=rP4ctB9m3CDvsjpvpJpJSzLJ8ry6+dId88f/k7u2Qhyce2p4pUuEr7vGAZ0Ptus2JL
         kM0Wn/rqKukYZ7qBQuc+8bAsD5v+5OTpaWLuQebi+TvHjFTgT/FiVcsfKsKY0YYX472v
         4XtXc1xVsmKZitAmX3hkpGXmcNgj2RFLDccAypoA1rmzX2+SlGwRYCc9DpbMuasTkl80
         1mvk2UJ5LBUTYY0pviHMHs8/eKnKt24pfAtdzNTs3MEka2Yy+tKHSRa2WWJyq1TiO+rJ
         x51U7njlKI3BwdfDSXTKgInV9OlME2Kfae0H5JMUruKejKbvi50/TCu3pNwa3dI5MJMH
         D07w==
X-Gm-Message-State: AOAM530+foDDkvREw7UPT4R5yQONWcCA0ph+G8MW2sHPkX+OBdcEaNHb
        ge1ZySenapEo4ii5odCmG4PsMZSetCk=
X-Google-Smtp-Source: ABdhPJyIpe53uFrbLytFOPNgD8/LCRbJTnt6w46nKP7pAPlITIBqWOjCJkrsE/mse7OjdcLnZfhR/g==
X-Received: by 2002:a05:6a00:2311:b0:4e1:52bf:e466 with SMTP id h17-20020a056a00231100b004e152bfe466mr14767799pfh.77.1653138994662;
        Sat, 21 May 2022 06:16:34 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id n23-20020a056a00213700b0050dc762815esm3611551pfj.56.2022.05.21.06.16.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 May 2022 06:16:34 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Subject: [PATCH V3 08/12] KVM: X86/MMU: Allocate mmu->pae_root for PAE paging on-demand
Date:   Sat, 21 May 2022 21:16:56 +0800
Message-Id: <20220521131700.3661-9-jiangshanlai@gmail.com>
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

mmu->pae_root for non-PAE paging is allocated on-demand, but
mmu->pae_root for PAE paging is allocated early when struct kvm_mmu is
being created.

Simplify the code to allocate mmu->pae_root for PAE paging and make
it on-demand.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h |   2 +-
 arch/x86/kvm/mmu/mmu.c          | 101 +++++++++++++-------------------
 arch/x86/kvm/x86.c              |   4 +-
 3 files changed, 44 insertions(+), 63 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9cdc5bbd721f..fb9751dfc1a7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1615,7 +1615,7 @@ int kvm_mmu_vendor_module_init(void);
 void kvm_mmu_vendor_module_exit(void);
 
 void kvm_mmu_destroy(struct kvm_vcpu *vcpu);
-int kvm_mmu_create(struct kvm_vcpu *vcpu);
+void kvm_mmu_create(struct kvm_vcpu *vcpu);
 int kvm_mmu_init_vm(struct kvm *kvm);
 void kvm_mmu_uninit_vm(struct kvm *kvm);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 90b715eefe6a..63c2b2c6122c 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -668,6 +668,41 @@ static void walk_shadow_page_lockless_end(struct kvm_vcpu *vcpu)
 	}
 }
 
+static int mmu_alloc_pae_root(struct kvm_vcpu *vcpu)
+{
+	struct page *page;
+
+	if (vcpu->arch.mmu->root_role.level != PT32E_ROOT_LEVEL)
+		return 0;
+	if (vcpu->arch.mmu->pae_root)
+		return 0;
+
+	/*
+	 * Allocate a page to hold the four PDPTEs for PAE paging when emulating
+	 * 32-bit mode.  CR3 is only 32 bits even on x86_64 in this case.
+	 * Therefore we need to allocate the PDP table in the first 4GB of
+	 * memory, which happens to fit the DMA32 zone.
+	 */
+	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_DMA32);
+	if (!page)
+		return -ENOMEM;
+	vcpu->arch.mmu->pae_root = page_address(page);
+
+	/*
+	 * CR3 is only 32 bits when PAE paging is used, thus it's impossible to
+	 * get the CPU to treat the PDPTEs as encrypted.  Decrypt the page so
+	 * that KVM's writes and the CPU's reads get along.  Note, this is
+	 * only necessary when using shadow paging, as 64-bit NPT can get at
+	 * the C-bit even when shadowing 32-bit NPT, and SME isn't supported
+	 * by 32-bit kernels (when KVM itself uses 32-bit NPT).
+	 */
+	if (!tdp_enabled)
+		set_memory_decrypted((unsigned long)vcpu->arch.mmu->pae_root, 1);
+	else
+		WARN_ON_ONCE(shadow_me_value);
+	return 0;
+}
+
 static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 {
 	int r;
@@ -5127,6 +5162,9 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	r = mmu_topup_memory_caches(vcpu, !vcpu->arch.mmu->root_role.direct);
 	if (r)
 		goto out;
+	r = mmu_alloc_pae_root(vcpu);
+	if (r)
+		return r;
 	r = mmu_alloc_special_roots(vcpu);
 	if (r)
 		goto out;
@@ -5591,63 +5629,18 @@ static void free_mmu_pages(struct kvm_mmu *mmu)
 	free_page((unsigned long)mmu->pml5_root);
 }
 
-static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
+static void __kvm_mmu_create(struct kvm_mmu *mmu)
 {
-	struct page *page;
 	int i;
 
 	mmu->root.hpa = INVALID_PAGE;
 	mmu->root.pgd = 0;
 	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++)
 		mmu->prev_roots[i] = KVM_MMU_ROOT_INFO_INVALID;
-
-	/* vcpu->arch.guest_mmu isn't used when !tdp_enabled. */
-	if (!tdp_enabled && mmu == &vcpu->arch.guest_mmu)
-		return 0;
-
-	/*
-	 * When using PAE paging, the four PDPTEs are treated as 'root' pages,
-	 * while the PDP table is a per-vCPU construct that's allocated at MMU
-	 * creation.  When emulating 32-bit mode, cr3 is only 32 bits even on
-	 * x86_64.  Therefore we need to allocate the PDP table in the first
-	 * 4GB of memory, which happens to fit the DMA32 zone.  TDP paging
-	 * generally doesn't use PAE paging and can skip allocating the PDP
-	 * table.  The main exception, handled here, is SVM's 32-bit NPT.  The
-	 * other exception is for shadowing L1's 32-bit or PAE NPT on 64-bit
-	 * KVM; that horror is handled on-demand by mmu_alloc_special_roots().
-	 */
-	if (tdp_enabled && kvm_mmu_get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
-		return 0;
-
-	page = alloc_page(GFP_KERNEL_ACCOUNT | __GFP_DMA32);
-	if (!page)
-		return -ENOMEM;
-
-	mmu->pae_root = page_address(page);
-
-	/*
-	 * CR3 is only 32 bits when PAE paging is used, thus it's impossible to
-	 * get the CPU to treat the PDPTEs as encrypted.  Decrypt the page so
-	 * that KVM's writes and the CPU's reads get along.  Note, this is
-	 * only necessary when using shadow paging, as 64-bit NPT can get at
-	 * the C-bit even when shadowing 32-bit NPT, and SME isn't supported
-	 * by 32-bit kernels (when KVM itself uses 32-bit NPT).
-	 */
-	if (!tdp_enabled)
-		set_memory_decrypted((unsigned long)mmu->pae_root, 1);
-	else
-		WARN_ON_ONCE(shadow_me_value);
-
-	for (i = 0; i < 4; ++i)
-		mmu->pae_root[i] = INVALID_PAE_ROOT;
-
-	return 0;
 }
 
-int kvm_mmu_create(struct kvm_vcpu *vcpu)
+void kvm_mmu_create(struct kvm_vcpu *vcpu)
 {
-	int ret;
-
 	vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
 	vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
 
@@ -5659,18 +5652,8 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
 
-	ret = __kvm_mmu_create(vcpu, &vcpu->arch.guest_mmu);
-	if (ret)
-		return ret;
-
-	ret = __kvm_mmu_create(vcpu, &vcpu->arch.root_mmu);
-	if (ret)
-		goto fail_allocate_root;
-
-	return ret;
- fail_allocate_root:
-	free_mmu_pages(&vcpu->arch.guest_mmu);
-	return ret;
+	__kvm_mmu_create(&vcpu->arch.guest_mmu);
+	__kvm_mmu_create(&vcpu->arch.root_mmu);
 }
 
 #define BATCH_ZAP_PAGES	10
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04812eaaf61b..064aecb188dc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11285,9 +11285,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	else
 		vcpu->arch.mp_state = KVM_MP_STATE_UNINITIALIZED;
 
-	r = kvm_mmu_create(vcpu);
-	if (r < 0)
-		return r;
+	kvm_mmu_create(vcpu);
 
 	if (irqchip_in_kernel(vcpu->kvm)) {
 		r = kvm_create_lapic(vcpu, lapic_timer_advance_ns);
-- 
2.19.1.6.gb485710b

