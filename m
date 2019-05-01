Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B84C10692
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 11:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfEAJsR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 05:48:17 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:55028 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726193AbfEAJsR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 May 2019 05:48:17 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id CCCB721BE0C0F1547E36;
        Wed,  1 May 2019 17:48:14 +0800 (CST)
Received: from HGHY2Y004646261.china.huawei.com (10.184.12.158) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Wed, 1 May 2019 17:48:08 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
CC:     <marc.zyngier@arm.com>, <christoffer.dall@arm.com>,
        <linux@armlinux.org.uk>, <catalin.marinas@arm.com>,
        <will.deacon@arm.com>, <james.morse@arm.com>,
        <julien.thierry@arm.com>, <suzuki.poulose@arm.com>,
        <steve.capper@arm.com>, <wanghaibin.wang@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/5] KVM: arm/arm64: Re-factor building the stage2 page table entries
Date:   Wed, 1 May 2019 09:44:24 +0000
Message-ID: <1556703867-22396-3-git-send-email-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.6.4.windows.1
In-Reply-To: <1556703867-22396-1-git-send-email-yuzenghui@huawei.com>
References: <1556703867-22396-1-git-send-email-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As we're going to support creating CONT_{PTE,PMD}_SIZE huge mappings in
user_mem_abort(), the logic to check vma_pagesize and build page table
entries will become longer, and looks almost the same (but actually they
dont). Refactor this part to make it a bit cleaner.

Add contiguous as a parameter of stage2_build_{pmd,pte}, to indicate
if we're creating contiguous huge mappings.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 virt/kvm/arm/mmu.c | 81 ++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 57 insertions(+), 24 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 27c9583..cf8b035 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1616,6 +1616,56 @@ static void kvm_send_hwpoison_signal(unsigned long address,
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
 }
 
+static pud_t stage2_build_pud(kvm_pfn_t pfn, pgprot_t mem_type, bool writable,
+			      bool needs_exec)
+{
+	pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
+
+	new_pud = kvm_pud_mkhuge(new_pud);
+	if (writable)
+		new_pud = kvm_s2pud_mkwrite(new_pud);
+
+	if (needs_exec)
+		new_pud = kvm_s2pud_mkexec(new_pud);
+
+	return new_pud;
+}
+
+static pmd_t stage2_build_pmd(kvm_pfn_t pfn, pgprot_t mem_type, bool writable,
+			      bool needs_exec, bool contiguous)
+{
+	pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
+
+	new_pmd = kvm_pmd_mkhuge(new_pmd);
+	if (writable)
+		new_pmd = kvm_s2pmd_mkwrite(new_pmd);
+
+	if (needs_exec)
+		new_pmd = kvm_s2pmd_mkexec(new_pmd);
+
+	if (contiguous)
+		new_pmd = kvm_s2pmd_mkcont(new_pmd);
+
+	return new_pmd;
+}
+
+static pte_t stage2_build_pte(kvm_pfn_t pfn, pgprot_t mem_type, bool writable,
+			      bool needs_exec, bool contiguous)
+{
+	pte_t new_pte = kvm_pfn_pte(pfn, mem_type);
+
+	if (writable)
+		new_pte = kvm_s2pte_mkwrite(new_pte);
+
+	if (needs_exec)
+		new_pte = kvm_s2pte_mkexec(new_pte);
+
+	if (contiguous)
+		new_pte = kvm_s2pte_mkcont(new_pte);
+
+	return new_pte;
+}
+
 static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
 					       unsigned long hva,
 					       unsigned long map_size)
@@ -1807,38 +1857,21 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		(fault_status == FSC_PERM && stage2_is_exec(kvm, fault_ipa));
 
 	if (vma_pagesize == PUD_SIZE) {
-		pud_t new_pud = kvm_pfn_pud(pfn, mem_type);
-
-		new_pud = kvm_pud_mkhuge(new_pud);
-		if (writable)
-			new_pud = kvm_s2pud_mkwrite(new_pud);
-
-		if (needs_exec)
-			new_pud = kvm_s2pud_mkexec(new_pud);
+		pud_t new_pud = stage2_build_pud(pfn, mem_type, writable,
+						 needs_exec);
 
 		ret = stage2_set_pud_huge(kvm, memcache, fault_ipa, &new_pud);
 	} else if (vma_pagesize == PMD_SIZE) {
-		pmd_t new_pmd = kvm_pfn_pmd(pfn, mem_type);
-
-		new_pmd = kvm_pmd_mkhuge(new_pmd);
-
-		if (writable)
-			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
-
-		if (needs_exec)
-			new_pmd = kvm_s2pmd_mkexec(new_pmd);
+		pmd_t new_pmd = stage2_build_pmd(pfn, mem_type, writable,
+						 needs_exec, false);
 
 		ret = stage2_set_pmd_huge(kvm, memcache, fault_ipa, &new_pmd);
 	} else {
-		pte_t new_pte = kvm_pfn_pte(pfn, mem_type);
+		pte_t new_pte = stage2_build_pte(pfn, mem_type, writable,
+						 needs_exec, false);
 
-		if (writable) {
-			new_pte = kvm_s2pte_mkwrite(new_pte);
+		if (writable)
 			mark_page_dirty(kvm, gfn);
-		}
-
-		if (needs_exec)
-			new_pte = kvm_s2pte_mkexec(new_pte);
 
 		ret = stage2_set_pte(kvm, memcache, fault_ipa, &new_pte, flags);
 	}
-- 
1.8.3.1


