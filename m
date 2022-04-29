Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B1F15140F3
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 05:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbiD2DV2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 23:21:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235757AbiD2DVZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 23:21:25 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6BD856C1A
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 20:18:05 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f4dfd09d7fso64927647b3.0
        for <kvm@vger.kernel.org>; Thu, 28 Apr 2022 20:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=UFcuh802XbKYlv+ES2ZLQ9M3Af182PmyKcuzk4JSsQ4=;
        b=Lsa21VYZWQ8h+FTnvqoeto/N6eqbwdtbZpI4PNgA6ZLRrhfPeumYxVFCazoJREIZIS
         TU/w/n80w7BsgEP1SVEOniBrt6yivQgiyIyT+gKMG17HNHHSm/ukk7Y3LyWvA6vEtRHw
         M4txzuT/RXDKAnA/t8YtNv8rWWf3PZkVHBzFMT/dGNv3o72KUZLmjGE+/Doyq2l6ccWd
         Uu2P4J/saKGPPhUCmTT2dsnac7JEjZpdPZ/nxUKAVqMgHZ2Z4zuf9ka6yaBtSlrhi9QG
         lqFo9rlhl6gczzXp92KUuXB0dhYcMUxXAGAzrfBXfglSwI04L5QkL6x/mS3gk8YGfIKP
         SS6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=UFcuh802XbKYlv+ES2ZLQ9M3Af182PmyKcuzk4JSsQ4=;
        b=KEdzQoA3MHv/miHfE0bQKJLKHhVy1+IKNwbOKCivF/0XiWK//hjCb0LQ5YKUCm+ftZ
         2iiQIYFl7JPwDH36UlKwkNoNI6xZfL56/+V2nsvEEOqQCSH+l6HOZICxAADWwZK9C9se
         o3bHcpEyTr8TcLe/Ck1hKHgEuYPoNCkYAe8Bip5iB8BGqM4kdasINolCLwdl0s+E7Byg
         PqGiYTNApeD5wU+KF4PPBoG0NsxSJ/qAtbySzS8un4qvQsxPl7ObHzJJFW6y25tBwOFT
         fqV3gNxg+81xXlEyedALTxr/Nan+ViNiFA83OnmEkk6rsbv5KY+lDqQ/qaeCRwLgmNmS
         qjYg==
X-Gm-Message-State: AOAM53027wkxon+Am3GRxVfXtW63q5rG3+a4IIxil3iBMw+SDy8RLNOV
        NxGPTqhXHCReTUrC8hNpDSDuhc8RoaX+
X-Google-Smtp-Source: ABdhPJxh1eXns0UK7rI+EI9kMaEm80jJyEvyHtEqYupPScamCw8auMmXnWvpzF16yQgL2yyqEhibLnofUuGU
X-Received: from mizhang-super2.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:61c])
 (user=mizhang job=sendgmr) by 2002:a25:bf88:0:b0:633:93e9:b2fc with SMTP id
 l8-20020a25bf88000000b0063393e9b2fcmr32758806ybk.202.1651202284688; Thu, 28
 Apr 2022 20:18:04 -0700 (PDT)
Reply-To: Mingwei Zhang <mizhang@google.com>
Date:   Fri, 29 Apr 2022 03:17:57 +0000
Message-Id: <20220429031757.2042406-1-mizhang@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH] KVM: x86/mmu: fix potential races when walking host page table
From:   Mingwei Zhang <mizhang@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Implement a KVM function for walking host page table in x86 architecture
and stop using lookup_address_in_mm(). lookup_address_in_mm() is basically
lookup_address_in_pgd() in mm. This function suffer from several issues:

 - no usage of READ_ONCE(*). This allows multiple dereference of the same
   page table entry. The TOCTOU problem because of that may cause kernel
   incorrectly thinks a newly generated leaf entry as a nonleaf one and
   dereference the content by using its pfn value.

 - Incorrect information returned. lookup_address_in_mm() returns pte_t
   pointer and level regardless of the 'presentness' of the entry, ie.,
   even if an PXE entry is 'non-present', as long as it is not 'none', the
   function still returns its level. In comparison, KVM needs the level
   information of only 'present' entries. This is a clear bug and may cause
   KVM incorrectly regard a non-present PXE entry as a present large page
   mapping.

lookup_address_in_mm() and its relevant functions are generally helpful
only for walking kernel addresses that have mostly static mappings and no
page table tear down would happen. Patching this function does not help
other callers, since its return value: a PTE pointer, is NEVER safe to
deference after the function returns.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>

Signed-off-by: Mingwei Zhang <mizhang@google.com>
---
 arch/x86/kvm/mmu/mmu.c |  8 +----
 arch/x86/kvm/x86.c     | 70 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h     |  2 ++
 3 files changed, 73 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 904f0faff2186..6db195e5eae94 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2822,8 +2822,6 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 				  const struct kvm_memory_slot *slot)
 {
 	unsigned long hva;
-	pte_t *pte;
-	int level;
 
 	if (!PageCompound(pfn_to_page(pfn)) && !kvm_is_zone_device_pfn(pfn))
 		return PG_LEVEL_4K;
@@ -2838,11 +2836,7 @@ static int host_pfn_mapping_level(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	 */
 	hva = __gfn_to_hva_memslot(slot, gfn);
 
-	pte = lookup_address_in_mm(kvm->mm, hva, &level);
-	if (unlikely(!pte))
-		return PG_LEVEL_4K;
-
-	return level;
+	return kvm_lookup_address_level_in_mm(kvm, hva);
 }
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 951d0a78ccdae..61406efe4ea7f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13044,6 +13044,76 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 }
 EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
 
+/*
+ * Lookup the valid mapping level for a virtual address in the current mm.
+ * Return the level of the mapping if there is present one. Otherwise, always
+ * return PG_LEVEL_NONE.
+ *
+ * Note: the information retrieved may be stale. Use it with causion.
+ */
+int kvm_lookup_address_level_in_mm(struct kvm *kvm, unsigned long address)
+{
+	pgd_t *pgdp, pgd;
+	p4d_t *p4dp, p4d;
+	pud_t *pudp, pud;
+	pmd_t *pmdp, pmd;
+	pte_t *ptep, pte;
+	unsigned long flags;
+	int level = PG_LEVEL_NONE;
+
+	/* Disable IRQs to prevent any tear down of page tables. */
+	local_irq_save(flags);
+
+	pgdp = pgd_offset(kvm->mm, address);
+	pgd = READ_ONCE(*pgdp);
+	if (pgd_none(pgd))
+		goto out;
+
+	p4dp = p4d_offset(pgdp, address);
+	p4d = READ_ONCE(*p4dp);
+	if (p4d_none(p4d) || !p4d_present(p4d))
+		goto out;
+
+	if (p4d_large(p4d)) {
+		level = PG_LEVEL_512G;
+		goto out;
+	}
+
+	pudp = pud_offset(p4dp, address);
+	pud = READ_ONCE(*pudp);
+	if (pud_none(pud) || !pud_present(pud))
+		goto out;
+
+	if (pud_large(pud)) {
+		level = PG_LEVEL_1G;
+		goto out;
+	}
+
+	pmdp = pmd_offset(pudp, address);
+	pmd = READ_ONCE(*pmdp);
+	if (pmd_none(pmd) || !pmd_present(pmd))
+		goto out;
+
+	if (pmd_large(pmd)) {
+		level = PG_LEVEL_2M;
+		goto out;
+	}
+
+	ptep = pte_offset_map(&pmd, address);
+	pte = ptep_get(ptep);
+	if (pte_present(pte)) {
+		pte_unmap(ptep);
+		level = PG_LEVEL_4K;
+		goto out;
+	}
+	pte_unmap(ptep);
+
+out:
+	local_irq_restore(flags);
+	return level;
+}
+EXPORT_SYMBOL_GPL(kvm_lookup_address_level_in_mm);
+
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_entry);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 588792f003345..f1cdcc8483bd0 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -454,4 +454,6 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
 			 unsigned int port, void *data,  unsigned int count,
 			 int in);
 
+int kvm_lookup_address_level_in_mm(struct kvm *kvm, unsigned long address);
+
 #endif

base-commit: 2a39d8b39bffdaf1a4223d0d22f07baee154c8f3
-- 
2.36.0.464.gb9c8b46e94-goog

