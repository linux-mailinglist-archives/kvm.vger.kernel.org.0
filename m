Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0196015973E
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 18:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730739AbgBKRx0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 12:53:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:56986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730637AbgBKRxZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 12:53:25 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07D0A20578;
        Tue, 11 Feb 2020 17:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581443605;
        bh=6qEfnPAQpmbL6mkKK1EQQA1y8FQyNR3EaGGAZea+tbk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C2hxYCSBr8A2cGVap21mWjhMt72gIg1HgqTKuOrdCTVW4rkT+XN8MmJXbILHounYV
         sku3e/hkzreGyEo5shAsbkuwL8odH4tzmlWRDYQjnYuWjGmzmZ2r4eL+Pnl7utC925
         U3GQaUkOsj5HYl856LkVthyKy8D1I+RdICX9srbU=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1j1Zg4-004O7k-ON; Tue, 11 Feb 2020 17:50:28 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 60/94] arm64: KVM: nv: Restrict S2 RD/WR permissions to match the guest's
Date:   Tue, 11 Feb 2020 17:49:04 +0000
Message-Id: <20200211174938.27809-61-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When mapping a page in a shadow stage-2, special care must be
taken not to be more permissive than the guest is (writable or
readable page when the guest hasn't set that permission).

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/include/asm/kvm_mmu.h      | 18 ++++++++++++++++++
 arch/arm64/include/asm/kvm_mmu.h    | 18 ++++++++++++++++++
 arch/arm64/include/asm/kvm_nested.h | 10 ++++++++++
 virt/kvm/arm/mmu.c                  | 21 ++++++++++++++++++++-
 4 files changed, 66 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
index 1d0d5f00f0af..be7be6583e54 100644
--- a/arch/arm/include/asm/kvm_mmu.h
+++ b/arch/arm/include/asm/kvm_mmu.h
@@ -113,6 +113,12 @@ static inline pud_t kvm_s2pud_mkexec(pud_t pud)
 	return pud;
 }
 
+static inline pud_t kvm_s2pud_revoke_read(pud_t pud)
+{
+	WARN_ON(1);
+	return pud;
+}
+
 static inline bool kvm_s2pud_exec(pud_t *pud)
 {
 	WARN_ON(1);
@@ -155,6 +161,18 @@ static inline pmd_t kvm_s2pmd_mkexec(pmd_t pmd)
 	return pmd;
 }
 
+static inline pte_t kvm_s2pte_revoke_read(pte_t pte)
+{
+	pte_val(pte) &= ~L_PTE_S2_RDONLY;
+	return pte;
+}
+
+static inline pmd_t kvm_s2pmd_revoke_read(pmd_t pmd)
+{
+	pmd_val(pmd) &= ~L_PMD_S2_RDONLY;
+	return pmd;
+}
+
 static inline void kvm_set_s2pte_readonly(pte_t *pte)
 {
 	pte_val(*pte) = (pte_val(*pte) & ~L_PTE_S2_RDWR) | L_PTE_S2_RDONLY;
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 9c0bf878fb3b..b390bba466e9 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -228,6 +228,24 @@ static inline pud_t kvm_s2pud_mkexec(pud_t pud)
 	return pud;
 }
 
+static inline pte_t kvm_s2pte_revoke_read(pte_t pte)
+{
+	pte_val(pte) &= ~PTE_S2_RDONLY;
+	return pte;
+}
+
+static inline pmd_t kvm_s2pmd_revoke_read(pmd_t pmd)
+{
+	pmd_val(pmd) &= ~PMD_S2_RDONLY;
+	return pmd;
+}
+
+static inline pud_t kvm_s2pud_revoke_read(pud_t pud)
+{
+	pud_val(pud) &= ~PUD_S2_RDONLY;
+	return pud;
+}
+
 static inline void kvm_set_s2pte_readonly(pte_t *ptep)
 {
 	pteval_t old_pteval, pteval;
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 45c013c0c856..7cd0c5b0fec9 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -43,6 +43,16 @@ static inline u32 kvm_s2_trans_esr(struct kvm_s2_trans *trans)
 	return trans->esr;
 }
 
+static inline bool kvm_s2_trans_readable(struct kvm_s2_trans *trans)
+{
+	return trans->readable;
+}
+
+static inline bool kvm_s2_trans_writable(struct kvm_s2_trans *trans)
+{
+	return trans->writable;
+}
+
 extern int kvm_walk_nested_s2(struct kvm_vcpu *vcpu, phys_addr_t gipa,
 			      struct kvm_s2_trans *result);
 
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 0086b42237af..7da72c2b7f0f 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1721,7 +1721,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  unsigned long hva, unsigned long fault_status)
 {
 	int ret;
-	bool write_fault, writable;
+	bool write_fault, writable, readable = true;
 	bool exec_fault, needs_exec;
 	unsigned long mmu_seq;
 	phys_addr_t ipa = fault_ipa;
@@ -1841,6 +1841,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (exec_fault && is_iomap(flags))
 		return -ENOEXEC;
 
+	/*
+	 * Potentially reduce shadow S2 permissions to match the guest's own
+	 * S2. For exec faults, we'd only reach this point if the guest
+	 * actually allowed it (see kvm_s2_handle_perm_fault).
+	 */
+	if (kvm_is_shadow_s2_fault(vcpu)) {
+		writable &= kvm_s2_trans_writable(nested);
+		readable &= kvm_s2_trans_readable(nested);
+	}
+
 	spin_lock(&kvm->mmu_lock);
 	if (mmu_notifier_retry(kvm, mmu_seq))
 		goto out_unlock;
@@ -1886,6 +1896,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (writable)
 			new_pud = kvm_s2pud_mkwrite(new_pud);
 
+		if (!readable)
+			new_pud = kvm_s2pud_revoke_read(new_pud);
+
 		if (needs_exec)
 			new_pud = kvm_s2pud_mkexec(new_pud);
 
@@ -1898,6 +1911,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		if (writable)
 			new_pmd = kvm_s2pmd_mkwrite(new_pmd);
 
+		if (!readable)
+			new_pmd = kvm_s2pmd_revoke_read(new_pmd);
+
 		if (needs_exec)
 			new_pmd = kvm_s2pmd_mkexec(new_pmd);
 
@@ -1910,6 +1926,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			mark_page_dirty(kvm, gfn);
 		}
 
+		if (!readable)
+			new_pte = kvm_s2pte_revoke_read(new_pte);
+
 		if (needs_exec)
 			new_pte = kvm_s2pte_mkexec(new_pte);
 
-- 
2.20.1

