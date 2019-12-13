Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF1811EA29
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2019 19:27:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728788AbfLMS1x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Dec 2019 13:27:53 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:34588 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728712AbfLMS1x (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Dec 2019 13:27:53 -0500
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:DHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1ifpdG-0001O7-Df; Fri, 13 Dec 2019 19:25:42 +0100
From:   Marc Zyngier <maz@kernel.org>
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Hogan <jhogan@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH 3/7] KVM: arm/arm64: Condition cache maintenance on unmap with a flag
Date:   Fri, 13 Dec 2019 18:24:59 +0000
Message-Id: <20191213182503.14460-4-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191213182503.14460-1-maz@kernel.org>
References: <20191213182503.14460-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, jhogan@kernel.org, paulus@ozlabs.org, pbonzini@redhat.com, rkrcmar@redhat.com, sean.j.christopherson@intel.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm-ppc@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
To:     unlisted-recipients:; (no To-header on input)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In order to allow the elision of cache maintenance operations
on unmap, add a new flag (KVM_UNMAP_ELIDE_CMO) that a caller
can use to indicate that CMOs are not required.

Nobody is passing this flag yet, hence no functional change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/mmu.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0fed7c19c6d5..ebf8c87cc007 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -35,6 +35,9 @@ static unsigned long io_map_base;
 
 #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
 
+/* Flags controlling S2 unmapping */
+#define KVM_UNMAP_ELIDE_CMO		(1UL << 0)
+
 #define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
 #define KVM_S2_FLAG_LOGGING_ACTIVE	(1UL << 1)
 
@@ -253,7 +256,8 @@ static void unmap_stage2_ptes(struct kvm *kvm, pmd_t *pmd,
 			kvm_tlb_flush_vmid_ipa(kvm, addr);
 
 			/* No need to invalidate the cache for device mappings */
-			if (!kvm_is_device_pfn(pte_pfn(old_pte)))
+			if (!kvm_is_device_pfn(pte_pfn(old_pte)) &&
+			    !(flags & KVM_UNMAP_ELIDE_CMO))
 				kvm_flush_dcache_pte(old_pte);
 
 			put_page(virt_to_page(pte));
@@ -281,7 +285,8 @@ static void unmap_stage2_pmds(struct kvm *kvm, pud_t *pud,
 				pmd_clear(pmd);
 				kvm_tlb_flush_vmid_ipa(kvm, addr);
 
-				kvm_flush_dcache_pmd(old_pmd);
+				if (!(flags & KVM_UNMAP_ELIDE_CMO))
+					kvm_flush_dcache_pmd(old_pmd);
 
 				put_page(virt_to_page(pmd));
 			} else {
@@ -310,7 +315,8 @@ static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
 
 				stage2_pud_clear(kvm, pud);
 				kvm_tlb_flush_vmid_ipa(kvm, addr);
-				kvm_flush_dcache_pud(old_pud);
+				if (!(flags & KVM_UNMAP_ELIDE_CMO))
+					kvm_flush_dcache_pud(old_pud);
 				put_page(virt_to_page(pud));
 			} else {
 				unmap_stage2_pmds(kvm, pud, addr, next, flags);
-- 
2.20.1

