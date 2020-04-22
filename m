Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 662071B43C5
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 14:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728599AbgDVMBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 08:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728559AbgDVMBE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 08:01:04 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA1E12098B;
        Wed, 22 Apr 2020 12:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587556864;
        bh=45MpXPQkAGSOngMz8CNnOYOg2Hgv55iMDDHXXHgoxc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HJ7ZSQi4bbv34suGYS0tBmP5vSF7NPKOIzFcejFJWhZkZPICWi7xc4IuSnnaDDSFd
         6EDLSML1tbPkBCRiQ5S1U4a/CE96migX5alsW7C+jace9eW5fix6tjZSUmYcoQFeYq
         XfmfupAeWmwVo1p3dRr6kT75rygMLfE7kY5jShXQ=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRE3q-005UI7-8n; Wed, 22 Apr 2020 13:01:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 08/26] KVM: arm64: Use TTL hint in when invalidating stage-2 translations
Date:   Wed, 22 Apr 2020 13:00:32 +0100
Message-Id: <20200422120050.3693593-9-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422120050.3693593-1-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we always have a precide idea of the level we're dealing with
when invalidating TLBs, we can provide it to as a hint to our
invalidation helper.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/stage2_pgtable.h |  9 +++++++++
 virt/kvm/arm/mmu.c                      | 27 +++++++++++++------------
 2 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index 326aac658b9da..7ed5c1a769a9b 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -230,4 +230,13 @@ stage2_pgd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
 	return (boundary - 1 < end - 1) ? boundary : end;
 }
 
+/*
+ * Level values for the ARMv8.4-TTL extension, mapping PUD/PMD/PTE and
+ * the architectural page-table level.
+ */
+#define S2_NO_LEVEL_HINT	0
+#define S2_PUD_LEVEL		1
+#define S2_PMD_LEVEL		2
+#define S2_PTE_LEVEL		3
+
 #endif	/* __ARM64_S2_PGTABLE_H_ */
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 611234e0aef12..2c132f5595c4b 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -58,9 +58,10 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
 }
 
-static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
+static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
+				   int level)
 {
-	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa, 0);
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa, level);
 }
 
 /*
@@ -102,7 +103,7 @@ static void stage2_dissolve_pmd(struct kvm_s2_mmu *mmu, phys_addr_t addr, pmd_t
 		return;
 
 	pmd_clear(pmd);
-	kvm_tlb_flush_vmid_ipa(mmu, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PMD_LEVEL);
 	put_page(virt_to_page(pmd));
 }
 
@@ -122,7 +123,7 @@ static void stage2_dissolve_pud(struct kvm_s2_mmu *mmu, phys_addr_t addr, pud_t
 		return;
 
 	stage2_pud_clear(kvm, pudp);
-	kvm_tlb_flush_vmid_ipa(mmu, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PUD_LEVEL);
 	put_page(virt_to_page(pudp));
 }
 
@@ -164,7 +165,7 @@ static void clear_stage2_pgd_entry(struct kvm_s2_mmu *mmu, pgd_t *pgd, phys_addr
 
 	pud_t *pud_table __maybe_unused = stage2_pud_offset(kvm, pgd, 0UL);
 	stage2_pgd_clear(kvm, pgd);
-	kvm_tlb_flush_vmid_ipa(mmu, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
 	stage2_pud_free(kvm, pud_table);
 	put_page(virt_to_page(pgd));
 }
@@ -176,7 +177,7 @@ static void clear_stage2_pud_entry(struct kvm_s2_mmu *mmu, pud_t *pud, phys_addr
 	pmd_t *pmd_table __maybe_unused = stage2_pmd_offset(kvm, pud, 0);
 	VM_BUG_ON(stage2_pud_huge(kvm, *pud));
 	stage2_pud_clear(kvm, pud);
-	kvm_tlb_flush_vmid_ipa(mmu, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
 	stage2_pmd_free(kvm, pmd_table);
 	put_page(virt_to_page(pud));
 }
@@ -186,7 +187,7 @@ static void clear_stage2_pmd_entry(struct kvm_s2_mmu *mmu, pmd_t *pmd, phys_addr
 	pte_t *pte_table = pte_offset_kernel(pmd, 0);
 	VM_BUG_ON(pmd_thp_or_huge(*pmd));
 	pmd_clear(pmd);
-	kvm_tlb_flush_vmid_ipa(mmu, addr);
+	kvm_tlb_flush_vmid_ipa(mmu, addr, S2_NO_LEVEL_HINT);
 	free_page((unsigned long)pte_table);
 	put_page(virt_to_page(pmd));
 }
@@ -256,7 +257,7 @@ static void unmap_stage2_ptes(struct kvm_s2_mmu *mmu, pmd_t *pmd,
 			pte_t old_pte = *pte;
 
 			kvm_set_pte(pte, __pte(0));
-			kvm_tlb_flush_vmid_ipa(mmu, addr);
+			kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PTE_LEVEL);
 
 			/* No need to invalidate the cache for device mappings */
 			if (!kvm_is_device_pfn(pte_pfn(old_pte)))
@@ -285,7 +286,7 @@ static void unmap_stage2_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
 				pmd_t old_pmd = *pmd;
 
 				pmd_clear(pmd);
-				kvm_tlb_flush_vmid_ipa(mmu, addr);
+				kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PMD_LEVEL);
 
 				kvm_flush_dcache_pmd(old_pmd);
 
@@ -315,7 +316,7 @@ static void unmap_stage2_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
 				pud_t old_pud = *pud;
 
 				stage2_pud_clear(kvm, pud);
-				kvm_tlb_flush_vmid_ipa(mmu, addr);
+				kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PUD_LEVEL);
 				kvm_flush_dcache_pud(old_pud);
 				put_page(virt_to_page(pud));
 			} else {
@@ -1129,7 +1130,7 @@ static int stage2_set_pmd_huge(struct kvm_s2_mmu *mmu,
 		 */
 		WARN_ON_ONCE(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
 		pmd_clear(pmd);
-		kvm_tlb_flush_vmid_ipa(mmu, addr);
+		kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PMD_LEVEL);
 	} else {
 		get_page(virt_to_page(pmd));
 	}
@@ -1171,7 +1172,7 @@ static int stage2_set_pud_huge(struct kvm_s2_mmu *mmu,
 
 		WARN_ON_ONCE(kvm_pud_pfn(old_pud) != kvm_pud_pfn(*new_pudp));
 		stage2_pud_clear(kvm, pudp);
-		kvm_tlb_flush_vmid_ipa(mmu, addr);
+		kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PUD_LEVEL);
 	} else {
 		get_page(virt_to_page(pudp));
 	}
@@ -1320,7 +1321,7 @@ static int stage2_set_pte(struct kvm_s2_mmu *mmu,
 			return 0;
 
 		kvm_set_pte(pte, __pte(0));
-		kvm_tlb_flush_vmid_ipa(mmu, addr);
+		kvm_tlb_flush_vmid_ipa(mmu, addr, S2_PTE_LEVEL);
 	} else {
 		get_page(virt_to_page(pte));
 	}
-- 
2.26.1

