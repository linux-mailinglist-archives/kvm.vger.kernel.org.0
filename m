Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0B18786987
	for <lists+kvm@lfdr.de>; Thu, 24 Aug 2023 10:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240522AbjHXIGo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Aug 2023 04:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240489AbjHXIGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Aug 2023 04:06:22 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C541991
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:05:42 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-26d4264493bso4264282a91.0
        for <kvm@vger.kernel.org>; Thu, 24 Aug 2023 01:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1692864323; x=1693469123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8pInsN0R9Jrj5G4DiNtaAqgrOTWh2xmTbeohTUBqU+0=;
        b=SNN3TBN+2El1oNqHuodXqkb+5HS1GQGpVa9ijD5Zr72npYE0GqK9C0GS+tal51GSM3
         QWaEWMWVPJ8vzhQWVs+fRBUmp5Fk5aZOK4tK1T4gtNEHXiyaELrNaoB8zkOIbXIz3F/0
         3ft/zWiNEmq8UdzMxAIvMNOTURLYSy8oxiORo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692864323; x=1693469123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8pInsN0R9Jrj5G4DiNtaAqgrOTWh2xmTbeohTUBqU+0=;
        b=IOvCWPRxdd92QjnLrj/kRVUd5qOQgu3MsjsOrLo2FCP2Cqyds33a8cEhkkHupG3VtZ
         M3TdJhri/YKuZ/6EmZMsdotB14eXi1skgqAJeGSEP7h/Zj2bXCwcghkkxciNNbY7IEeU
         eZMt3dWJsmVOkeG/rQ+aJVMsbgNjtpZEeVRJuXrcrpytNhQkAlZ6SW7aQWms36cUg5np
         ZDsrJCEDavgVWUfXCrUd0xUqJ27GhlR4+JTlGSMhjTO0PfUXuMtUjLIHEvz0QVIO+Sxq
         454U3GhNRizycyC/iuKrl2npF4pFlVGGPgkQxe60gSmoSB20C0rGHGf590xgXU8+gqWd
         GlBA==
X-Gm-Message-State: AOJu0Yxm2ZKIQk3PkMQlEUjcteJpZo8n2lHFCA1DxMr6yB7GpWyGrklM
        j8gECvXku128uMQyY40iOtN4Sg==
X-Google-Smtp-Source: AGHT+IGdSjMwqhsbz44+KiD8gA7voTpvuuFsAPy+9CTgub6hQrFAaqcxjKO/IO30vietUV2rKmrNqA==
X-Received: by 2002:a17:90a:34c9:b0:268:3ea0:7160 with SMTP id m9-20020a17090a34c900b002683ea07160mr13435610pjf.0.1692864323554;
        Thu, 24 Aug 2023 01:05:23 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:515:8b2a:90c3:b79e])
        by smtp.gmail.com with UTF8SMTPSA id n14-20020a17090ac68e00b002636dfcc6f5sm966246pjt.3.2023.08.24.01.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 01:05:23 -0700 (PDT)
From:   David Stevens <stevensd@chromium.org>
X-Google-Original-From: David Stevens <stevensd@google.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Marc Zyngier <maz@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Peter Xu <peterx@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, David Stevens <stevensd@chromium.org>
Subject: [PATCH v8 7/8] KVM: PPC: Migrate to __kvm_follow_pfn
Date:   Thu, 24 Aug 2023 17:04:07 +0900
Message-ID: <20230824080408.2933205-8-stevensd@google.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230824080408.2933205-1-stevensd@google.com>
References: <20230824080408.2933205-1-stevensd@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Stevens <stevensd@chromium.org>

Migrate from __gfn_to_pfn_memslot to __kvm_follow_pfn. As part of the
refactoring, remove the redundant calls to get_user_page_fast_only,
since the check for !async && !atomic was removed from the KVM generic
code in b9b33da2aa74. Also, remove the kvm_ro parameter because the KVM
generic code handles RO memslots.

Signed-off-by: David Stevens <stevensd@chromium.org>
---
 arch/powerpc/include/asm/kvm_book3s.h  |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    | 38 +++++++++-----------
 arch/powerpc/kvm/book3s_64_mmu_radix.c | 50 +++++++++++---------------
 arch/powerpc/kvm/book3s_hv_nested.c    |  4 +--
 4 files changed, 38 insertions(+), 56 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index bbf5e2c5fe09..bf48c511e700 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -202,7 +202,7 @@ extern bool kvmppc_hv_handle_set_rc(struct kvm *kvm, bool nested,
 extern int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 				unsigned long gpa,
 				struct kvm_memory_slot *memslot,
-				bool writing, bool kvm_ro,
+				bool writing,
 				pte_t *inserted_pte, unsigned int *levelp);
 extern int kvmppc_init_vm_radix(struct kvm *kvm);
 extern void kvmppc_free_radix(struct kvm *kvm);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index 7f765d5ad436..4688046626af 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -523,6 +523,9 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 	unsigned long rcbits;
 	long mmio_update;
 	pte_t pte, *ptep;
+	struct kvm_follow_pfn foll = {
+		.try_map_writable = true,
+	};
 
 	if (kvm_is_radix(kvm))
 		return kvmppc_book3s_radix_page_fault(vcpu, ea, dsisr);
@@ -599,29 +602,20 @@ int kvmppc_book3s_hv_page_fault(struct kvm_vcpu *vcpu,
 	page = NULL;
 	writing = (dsisr & DSISR_ISSTORE) != 0;
 	/* If writing != 0, then the HPTE must allow writing, if we get here */
-	write_ok = writing;
-	hva = gfn_to_hva_memslot(memslot, gfn);
 
-	/*
-	 * Do a fast check first, since __gfn_to_pfn_memslot doesn't
-	 * do it with !atomic && !async, which is how we call it.
-	 * We always ask for write permission since the common case
-	 * is that the page is writable.
-	 */
-	if (get_user_page_fast_only(hva, FOLL_WRITE, &page)) {
-		write_ok = true;
-	} else {
-		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-					   writing, &write_ok, NULL);
-		if (is_error_noslot_pfn(pfn))
-			return -EFAULT;
-		page = NULL;
-		if (pfn_valid(pfn)) {
-			page = pfn_to_page(pfn);
-			if (PageReserved(page))
-				page = NULL;
-		}
+	foll.slot = memslot;
+	foll.gfn = gfn;
+	foll.flags = FOLL_GET | (writing ? FOLL_WRITE : 0);
+	pfn = __kvm_follow_pfn(&foll);
+	if (is_error_noslot_pfn(pfn))
+		return -EFAULT;
+	page = NULL;
+	write_ok = foll.writable;
+	hva = foll.hva;
+	if (pfn_valid(pfn)) {
+		page = pfn_to_page(pfn);
+		if (PageReserved(page))
+			page = NULL;
 	}
 
 	/*
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index 572707858d65..498f89128c3a 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -815,47 +815,39 @@ bool kvmppc_hv_handle_set_rc(struct kvm *kvm, bool nested, bool writing,
 int kvmppc_book3s_instantiate_page(struct kvm_vcpu *vcpu,
 				   unsigned long gpa,
 				   struct kvm_memory_slot *memslot,
-				   bool writing, bool kvm_ro,
+				   bool writing,
 				   pte_t *inserted_pte, unsigned int *levelp)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct page *page = NULL;
 	unsigned long mmu_seq;
-	unsigned long hva, gfn = gpa >> PAGE_SHIFT;
-	bool upgrade_write = false;
-	bool *upgrade_p = &upgrade_write;
+	unsigned long hva, pfn, gfn = gpa >> PAGE_SHIFT;
+	bool upgrade_write;
 	pte_t pte, *ptep;
 	unsigned int shift, level;
 	int ret;
 	bool large_enable;
+	struct kvm_follow_pfn foll = {
+		.slot = memslot,
+		.gfn = gfn,
+		.flags = FOLL_GET | (writing ? FOLL_WRITE : 0),
+		.try_map_writable = true,
+	};
 
 	/* used to check for invalidations in progress */
 	mmu_seq = kvm->mmu_invalidate_seq;
 	smp_rmb();
 
-	/*
-	 * Do a fast check first, since __gfn_to_pfn_memslot doesn't
-	 * do it with !atomic && !async, which is how we call it.
-	 * We always ask for write permission since the common case
-	 * is that the page is writable.
-	 */
-	hva = gfn_to_hva_memslot(memslot, gfn);
-	if (!kvm_ro && get_user_page_fast_only(hva, FOLL_WRITE, &page)) {
-		upgrade_write = true;
-	} else {
-		unsigned long pfn;
-
-		/* Call KVM generic code to do the slow-path check */
-		pfn = __gfn_to_pfn_memslot(memslot, gfn, false, false, NULL,
-					   writing, upgrade_p, NULL);
-		if (is_error_noslot_pfn(pfn))
-			return -EFAULT;
-		page = NULL;
-		if (pfn_valid(pfn)) {
-			page = pfn_to_page(pfn);
-			if (PageReserved(page))
-				page = NULL;
-		}
+	pfn = __kvm_follow_pfn(&foll);
+	if (is_error_noslot_pfn(pfn))
+		return -EFAULT;
+	page = NULL;
+	hva = foll.hva;
+	upgrade_write = foll.writable;
+	if (pfn_valid(pfn)) {
+		page = pfn_to_page(pfn);
+		if (PageReserved(page))
+			page = NULL;
 	}
 
 	/*
@@ -944,7 +936,6 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 	struct kvm_memory_slot *memslot;
 	long ret;
 	bool writing = !!(dsisr & DSISR_ISSTORE);
-	bool kvm_ro = false;
 
 	/* Check for unusual errors */
 	if (dsisr & DSISR_UNSUPP_MMU) {
@@ -997,7 +988,6 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 					ea, DSISR_ISSTORE | DSISR_PROTFAULT);
 			return RESUME_GUEST;
 		}
-		kvm_ro = true;
 	}
 
 	/* Failed to set the reference/change bits */
@@ -1015,7 +1005,7 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 
 	/* Try to insert a pte */
 	ret = kvmppc_book3s_instantiate_page(vcpu, gpa, memslot, writing,
-					     kvm_ro, NULL, NULL);
+					     NULL, NULL);
 
 	if (ret == 0 || ret == -EAGAIN)
 		ret = RESUME_GUEST;
diff --git a/arch/powerpc/kvm/book3s_hv_nested.c b/arch/powerpc/kvm/book3s_hv_nested.c
index 377d0b4a05ee..6d531051df04 100644
--- a/arch/powerpc/kvm/book3s_hv_nested.c
+++ b/arch/powerpc/kvm/book3s_hv_nested.c
@@ -1497,7 +1497,6 @@ static long int __kvmhv_nested_page_fault(struct kvm_vcpu *vcpu,
 	unsigned long n_gpa, gpa, gfn, perm = 0UL;
 	unsigned int shift, l1_shift, level;
 	bool writing = !!(dsisr & DSISR_ISSTORE);
-	bool kvm_ro = false;
 	long int ret;
 
 	if (!gp->l1_gr_to_hr) {
@@ -1577,7 +1576,6 @@ static long int __kvmhv_nested_page_fault(struct kvm_vcpu *vcpu,
 					ea, DSISR_ISSTORE | DSISR_PROTFAULT);
 			return RESUME_GUEST;
 		}
-		kvm_ro = true;
 	}
 
 	/* 2. Find the host pte for this L1 guest real address */
@@ -1599,7 +1597,7 @@ static long int __kvmhv_nested_page_fault(struct kvm_vcpu *vcpu,
 	if (!pte_present(pte) || (writing && !(pte_val(pte) & _PAGE_WRITE))) {
 		/* No suitable pte found -> try to insert a mapping */
 		ret = kvmppc_book3s_instantiate_page(vcpu, gpa, memslot,
-					writing, kvm_ro, &pte, &level);
+					writing, &pte, &level);
 		if (ret == -EAGAIN)
 			return RESUME_GUEST;
 		else if (ret)
-- 
2.42.0.rc1.204.g551eb34607-goog

