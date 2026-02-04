Return-Path: <kvm+bounces-70199-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QAKVI9FNg2lrlAMAu9opvQ
	(envelope-from <kvm+bounces-70199-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 14:46:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 01185E6A07
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 14:46:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8E950302962B
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 13:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 435A215ECCC;
	Wed,  4 Feb 2026 13:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="W7XfmUOO"
X-Original-To: kvm@vger.kernel.org
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C49624290D;
	Wed,  4 Feb 2026 13:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770212730; cv=none; b=I/cBQK+YIqjMdB0wL3zyzmUqfAQaNp+cSSxudiGWWi3qBp0KXxNnB3V64RwmaQugrMOOuIuMmjuZ0A0A1Nie437WbyN3slfDYf5wz5zPn+cqmsY8DuzUrvfA/dyRHKIEwmqm3haQBIyyVyAkz9Hc7NuisPnozGI9TgXiEt9zDFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770212730; c=relaxed/simple;
	bh=l2QoocVh1MkjJ/OASEXnWhSzB3evRgqizqlv/TPBEXw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Y6z/dsk3IhjacWa20FWOEvgXoHH4rca1lcXfOkZoxxvcfRxl+LNdR5rIMFxpvdCvcche/GNtgC4Ro7oVC2eP8xV3ylNSwsVjzNx2rmHe59Eomt5LTezlF1cXEkwregXt32YjkpNjgMPJwOV1L7XW5deaPBIzM9GV5DZvrXdDvWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=W7XfmUOO; arc=none smtp.client-ip=115.124.30.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770212720; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=UcyR3qVHV1UnQIcaNKvbBmMhNxOrCjCwN5PBTCop7RA=;
	b=W7XfmUOOkD0ttS2lj29fhqKkkTc4DfUvF0ehdCA27RmroEXc1qLRx8Wvs7GlQ1iDEEOy727+0oSqRpENIScmLARUjpNHEvX3Yu+XbLNvUMYADf8XdZW9htfPH0Q7cUuQGRfNzr/ABWzXRJ7Zkgp62PT2MxMX+zMLzVY9lsqjO8M=
Received: from localhost.localdomain(mailfrom:fangyu.yu@linux.alibaba.com fp:SMTPD_---0WyXBz83_1770212716 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Feb 2026 21:45:18 +0800
From: fangyu.yu@linux.alibaba.com
To: pbonzini@redhat.com,
	corbet@lwn.net,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: guoren@kernel.org,
	radim.krcmar@oss.qualcomm.com,
	andrew.jones@oss.qualcomm.com,
	linux-doc@vger.kernel.org,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>
Subject: [PATCH v5 1/3] RISC-V: KVM: Support runtime configuration for per-VM's HGATP mode
Date: Wed,  4 Feb 2026 21:45:05 +0800
Message-Id: <20260204134507.33912-2-fangyu.yu@linux.alibaba.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260204134507.33912-1-fangyu.yu@linux.alibaba.com>
References: <20260204134507.33912-1-fangyu.yu@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-7.66 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70199-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[17];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_NO_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[fangyu.yu@linux.alibaba.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[alibaba.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 01185E6A07
X-Rspamd-Action: no action

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

Introduces one per-VM architecture-specific fields to support runtime
configuration of the G-stage page table format:

- kvm->arch.kvm_riscv_gstage_pgd_levels: the corresponding number of page
  table levels for the selected mode.

These fields replace the previous global variables
kvm_riscv_gstage_mode and kvm_riscv_gstage_pgd_levels, enabling different
virtual machines to independently select their G-stage page table format
instead of being forced to share the maximum mode detected by the kernel
at boot time.

Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
---
 arch/riscv/include/asm/kvm_gstage.h | 20 +++++----
 arch/riscv/include/asm/kvm_host.h   | 19 +++++++++
 arch/riscv/kvm/gstage.c             | 65 ++++++++++++++---------------
 arch/riscv/kvm/main.c               | 12 +++---
 arch/riscv/kvm/mmu.c                | 20 +++++----
 arch/riscv/kvm/vm.c                 |  2 +-
 arch/riscv/kvm/vmid.c               |  3 +-
 7 files changed, 84 insertions(+), 57 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_gstage.h b/arch/riscv/include/asm/kvm_gstage.h
index 595e2183173e..b12605fbca44 100644
--- a/arch/riscv/include/asm/kvm_gstage.h
+++ b/arch/riscv/include/asm/kvm_gstage.h
@@ -29,16 +29,22 @@ struct kvm_gstage_mapping {
 #define kvm_riscv_gstage_index_bits	10
 #endif
 
-extern unsigned long kvm_riscv_gstage_mode;
-extern unsigned long kvm_riscv_gstage_pgd_levels;
+extern unsigned long kvm_riscv_gstage_max_pgd_levels;
 
 #define kvm_riscv_gstage_pgd_xbits	2
 #define kvm_riscv_gstage_pgd_size	(1UL << (HGATP_PAGE_SHIFT + kvm_riscv_gstage_pgd_xbits))
-#define kvm_riscv_gstage_gpa_bits	(HGATP_PAGE_SHIFT + \
-					 (kvm_riscv_gstage_pgd_levels * \
-					  kvm_riscv_gstage_index_bits) + \
-					 kvm_riscv_gstage_pgd_xbits)
-#define kvm_riscv_gstage_gpa_size	((gpa_t)(1ULL << kvm_riscv_gstage_gpa_bits))
+
+static inline unsigned long kvm_riscv_gstage_gpa_bits(struct kvm_arch *ka)
+{
+	return (HGATP_PAGE_SHIFT +
+		ka->kvm_riscv_gstage_pgd_levels * kvm_riscv_gstage_index_bits +
+		kvm_riscv_gstage_pgd_xbits);
+}
+
+static inline gpa_t kvm_riscv_gstage_gpa_size(struct kvm_arch *ka)
+{
+	return BIT_ULL(kvm_riscv_gstage_gpa_bits(ka));
+}
 
 bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
 			       pte_t **ptepp, u32 *ptep_level);
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 24585304c02b..0ace5e98c133 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -87,6 +87,23 @@ struct kvm_vcpu_stat {
 struct kvm_arch_memory_slot {
 };
 
+static inline unsigned long kvm_riscv_gstage_mode(unsigned long pgd_levels)
+{
+	switch (pgd_levels) {
+	case 2:
+		return HGATP_MODE_SV32X4;
+	case 3:
+		return HGATP_MODE_SV39X4;
+	case 4:
+		return HGATP_MODE_SV48X4;
+	case 5:
+		return HGATP_MODE_SV57X4;
+	default:
+		WARN_ON_ONCE(1);
+		return HGATP_MODE_OFF;
+	}
+}
+
 struct kvm_arch {
 	/* G-stage vmid */
 	struct kvm_vmid vmid;
@@ -103,6 +120,8 @@ struct kvm_arch {
 
 	/* KVM_CAP_RISCV_MP_STATE_RESET */
 	bool mp_state_reset;
+
+	unsigned long kvm_riscv_gstage_pgd_levels;
 };
 
 struct kvm_cpu_trap {
diff --git a/arch/riscv/kvm/gstage.c b/arch/riscv/kvm/gstage.c
index b67d60d722c2..2d0045f502d1 100644
--- a/arch/riscv/kvm/gstage.c
+++ b/arch/riscv/kvm/gstage.c
@@ -12,22 +12,21 @@
 #include <asm/kvm_gstage.h>
 
 #ifdef CONFIG_64BIT
-unsigned long kvm_riscv_gstage_mode __ro_after_init = HGATP_MODE_SV39X4;
-unsigned long kvm_riscv_gstage_pgd_levels __ro_after_init = 3;
+unsigned long kvm_riscv_gstage_max_pgd_levels __ro_after_init = 3;
 #else
-unsigned long kvm_riscv_gstage_mode __ro_after_init = HGATP_MODE_SV32X4;
-unsigned long kvm_riscv_gstage_pgd_levels __ro_after_init = 2;
+unsigned long kvm_riscv_gstage_max_pgd_levels __ro_after_init = 2;
 #endif
 
 #define gstage_pte_leaf(__ptep)	\
 	(pte_val(*(__ptep)) & (_PAGE_READ | _PAGE_WRITE | _PAGE_EXEC))
 
-static inline unsigned long gstage_pte_index(gpa_t addr, u32 level)
+static inline unsigned long gstage_pte_index(struct kvm_gstage *gstage,
+					     gpa_t addr, u32 level)
 {
 	unsigned long mask;
 	unsigned long shift = HGATP_PAGE_SHIFT + (kvm_riscv_gstage_index_bits * level);
 
-	if (level == (kvm_riscv_gstage_pgd_levels - 1))
+	if (level == gstage->kvm->arch.kvm_riscv_gstage_pgd_levels - 1)
 		mask = (PTRS_PER_PTE * (1UL << kvm_riscv_gstage_pgd_xbits)) - 1;
 	else
 		mask = PTRS_PER_PTE - 1;
@@ -40,12 +39,13 @@ static inline unsigned long gstage_pte_page_vaddr(pte_t pte)
 	return (unsigned long)pfn_to_virt(__page_val_to_pfn(pte_val(pte)));
 }
 
-static int gstage_page_size_to_level(unsigned long page_size, u32 *out_level)
+static int gstage_page_size_to_level(struct kvm_gstage *gstage, unsigned long page_size,
+				     u32 *out_level)
 {
 	u32 i;
 	unsigned long psz = 1UL << 12;
 
-	for (i = 0; i < kvm_riscv_gstage_pgd_levels; i++) {
+	for (i = 0; i < gstage->kvm->arch.kvm_riscv_gstage_pgd_levels; i++) {
 		if (page_size == (psz << (i * kvm_riscv_gstage_index_bits))) {
 			*out_level = i;
 			return 0;
@@ -55,21 +55,23 @@ static int gstage_page_size_to_level(unsigned long page_size, u32 *out_level)
 	return -EINVAL;
 }
 
-static int gstage_level_to_page_order(u32 level, unsigned long *out_pgorder)
+static int gstage_level_to_page_order(struct kvm_gstage *gstage, u32 level,
+				      unsigned long *out_pgorder)
 {
-	if (kvm_riscv_gstage_pgd_levels < level)
+	if (gstage->kvm->arch.kvm_riscv_gstage_pgd_levels < level)
 		return -EINVAL;
 
 	*out_pgorder = 12 + (level * kvm_riscv_gstage_index_bits);
 	return 0;
 }
 
-static int gstage_level_to_page_size(u32 level, unsigned long *out_pgsize)
+static int gstage_level_to_page_size(struct kvm_gstage *gstage, u32 level,
+				     unsigned long *out_pgsize)
 {
 	int rc;
 	unsigned long page_order = PAGE_SHIFT;
 
-	rc = gstage_level_to_page_order(level, &page_order);
+	rc = gstage_level_to_page_order(gstage, level, &page_order);
 	if (rc)
 		return rc;
 
@@ -81,11 +83,11 @@ bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
 			       pte_t **ptepp, u32 *ptep_level)
 {
 	pte_t *ptep;
-	u32 current_level = kvm_riscv_gstage_pgd_levels - 1;
+	u32 current_level = gstage->kvm->arch.kvm_riscv_gstage_pgd_levels - 1;
 
 	*ptep_level = current_level;
 	ptep = (pte_t *)gstage->pgd;
-	ptep = &ptep[gstage_pte_index(addr, current_level)];
+	ptep = &ptep[gstage_pte_index(gstage, addr, current_level)];
 	while (ptep && pte_val(ptep_get(ptep))) {
 		if (gstage_pte_leaf(ptep)) {
 			*ptep_level = current_level;
@@ -97,7 +99,7 @@ bool kvm_riscv_gstage_get_leaf(struct kvm_gstage *gstage, gpa_t addr,
 			current_level--;
 			*ptep_level = current_level;
 			ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
-			ptep = &ptep[gstage_pte_index(addr, current_level)];
+			ptep = &ptep[gstage_pte_index(gstage, addr, current_level)];
 		} else {
 			ptep = NULL;
 		}
@@ -110,7 +112,7 @@ static void gstage_tlb_flush(struct kvm_gstage *gstage, u32 level, gpa_t addr)
 {
 	unsigned long order = PAGE_SHIFT;
 
-	if (gstage_level_to_page_order(level, &order))
+	if (gstage_level_to_page_order(gstage, level, &order))
 		return;
 	addr &= ~(BIT(order) - 1);
 
@@ -125,9 +127,9 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
 			     struct kvm_mmu_memory_cache *pcache,
 			     const struct kvm_gstage_mapping *map)
 {
-	u32 current_level = kvm_riscv_gstage_pgd_levels - 1;
+	u32 current_level = gstage->kvm->arch.kvm_riscv_gstage_pgd_levels - 1;
 	pte_t *next_ptep = (pte_t *)gstage->pgd;
-	pte_t *ptep = &next_ptep[gstage_pte_index(map->addr, current_level)];
+	pte_t *ptep = &next_ptep[gstage_pte_index(gstage, map->addr, current_level)];
 
 	if (current_level < map->level)
 		return -EINVAL;
@@ -151,7 +153,7 @@ int kvm_riscv_gstage_set_pte(struct kvm_gstage *gstage,
 		}
 
 		current_level--;
-		ptep = &next_ptep[gstage_pte_index(map->addr, current_level)];
+		ptep = &next_ptep[gstage_pte_index(gstage, map->addr, current_level)];
 	}
 
 	if (pte_val(*ptep) != pte_val(map->pte)) {
@@ -175,7 +177,7 @@ int kvm_riscv_gstage_map_page(struct kvm_gstage *gstage,
 	out_map->addr = gpa;
 	out_map->level = 0;
 
-	ret = gstage_page_size_to_level(page_size, &out_map->level);
+	ret = gstage_page_size_to_level(gstage, page_size, &out_map->level);
 	if (ret)
 		return ret;
 
@@ -217,7 +219,7 @@ void kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
 	u32 next_ptep_level;
 	unsigned long next_page_size, page_size;
 
-	ret = gstage_level_to_page_size(ptep_level, &page_size);
+	ret = gstage_level_to_page_size(gstage, ptep_level, &page_size);
 	if (ret)
 		return;
 
@@ -229,7 +231,7 @@ void kvm_riscv_gstage_op_pte(struct kvm_gstage *gstage, gpa_t addr,
 	if (ptep_level && !gstage_pte_leaf(ptep)) {
 		next_ptep = (pte_t *)gstage_pte_page_vaddr(ptep_get(ptep));
 		next_ptep_level = ptep_level - 1;
-		ret = gstage_level_to_page_size(next_ptep_level, &next_page_size);
+		ret = gstage_level_to_page_size(gstage, next_ptep_level, &next_page_size);
 		if (ret)
 			return;
 
@@ -263,7 +265,7 @@ void kvm_riscv_gstage_unmap_range(struct kvm_gstage *gstage,
 
 	while (addr < end) {
 		found_leaf = kvm_riscv_gstage_get_leaf(gstage, addr, &ptep, &ptep_level);
-		ret = gstage_level_to_page_size(ptep_level, &page_size);
+		ret = gstage_level_to_page_size(gstage, ptep_level, &page_size);
 		if (ret)
 			break;
 
@@ -297,7 +299,7 @@ void kvm_riscv_gstage_wp_range(struct kvm_gstage *gstage, gpa_t start, gpa_t end
 
 	while (addr < end) {
 		found_leaf = kvm_riscv_gstage_get_leaf(gstage, addr, &ptep, &ptep_level);
-		ret = gstage_level_to_page_size(ptep_level, &page_size);
+		ret = gstage_level_to_page_size(gstage, ptep_level, &page_size);
 		if (ret)
 			break;
 
@@ -319,39 +321,34 @@ void __init kvm_riscv_gstage_mode_detect(void)
 	/* Try Sv57x4 G-stage mode */
 	csr_write(CSR_HGATP, HGATP_MODE_SV57X4 << HGATP_MODE_SHIFT);
 	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV57X4) {
-		kvm_riscv_gstage_mode = HGATP_MODE_SV57X4;
-		kvm_riscv_gstage_pgd_levels = 5;
+		kvm_riscv_gstage_max_pgd_levels = 5;
 		goto done;
 	}
 
 	/* Try Sv48x4 G-stage mode */
 	csr_write(CSR_HGATP, HGATP_MODE_SV48X4 << HGATP_MODE_SHIFT);
 	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV48X4) {
-		kvm_riscv_gstage_mode = HGATP_MODE_SV48X4;
-		kvm_riscv_gstage_pgd_levels = 4;
+		kvm_riscv_gstage_max_pgd_levels = 4;
 		goto done;
 	}
 
 	/* Try Sv39x4 G-stage mode */
 	csr_write(CSR_HGATP, HGATP_MODE_SV39X4 << HGATP_MODE_SHIFT);
 	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV39X4) {
-		kvm_riscv_gstage_mode = HGATP_MODE_SV39X4;
-		kvm_riscv_gstage_pgd_levels = 3;
+		kvm_riscv_gstage_max_pgd_levels = 3;
 		goto done;
 	}
 #else /* CONFIG_32BIT */
 	/* Try Sv32x4 G-stage mode */
 	csr_write(CSR_HGATP, HGATP_MODE_SV32X4 << HGATP_MODE_SHIFT);
 	if ((csr_read(CSR_HGATP) >> HGATP_MODE_SHIFT) == HGATP_MODE_SV32X4) {
-		kvm_riscv_gstage_mode = HGATP_MODE_SV32X4;
-		kvm_riscv_gstage_pgd_levels = 2;
+		kvm_riscv_gstage_max_pgd_levels = 2;
 		goto done;
 	}
 #endif
 
 	/* KVM depends on !HGATP_MODE_OFF */
-	kvm_riscv_gstage_mode = HGATP_MODE_OFF;
-	kvm_riscv_gstage_pgd_levels = 0;
+	kvm_riscv_gstage_max_pgd_levels = 0;
 
 done:
 	csr_write(CSR_HGATP, 0);
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index 45536af521f0..786c0025e2c3 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -105,17 +105,17 @@ static int __init riscv_kvm_init(void)
 		return rc;
 
 	kvm_riscv_gstage_mode_detect();
-	switch (kvm_riscv_gstage_mode) {
-	case HGATP_MODE_SV32X4:
+	switch (kvm_riscv_gstage_max_pgd_levels) {
+	case 2:
 		str = "Sv32x4";
 		break;
-	case HGATP_MODE_SV39X4:
+	case 3:
 		str = "Sv39x4";
 		break;
-	case HGATP_MODE_SV48X4:
+	case 4:
 		str = "Sv48x4";
 		break;
-	case HGATP_MODE_SV57X4:
+	case 5:
 		str = "Sv57x4";
 		break;
 	default:
@@ -164,7 +164,7 @@ static int __init riscv_kvm_init(void)
 			 (rc) ? slist : "no features");
 	}
 
-	kvm_info("using %s G-stage page table format\n", str);
+	kvm_info("Max G-stage page table format %s\n", str);
 
 	kvm_info("VMID %ld bits available\n", kvm_riscv_gstage_vmid_bits());
 
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 4ab06697bfc0..458a2ed98818 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -67,7 +67,7 @@ int kvm_riscv_mmu_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
 		if (!writable)
 			map.pte = pte_wrprotect(map.pte);
 
-		ret = kvm_mmu_topup_memory_cache(&pcache, kvm_riscv_gstage_pgd_levels);
+		ret = kvm_mmu_topup_memory_cache(&pcache, kvm->arch.kvm_riscv_gstage_pgd_levels);
 		if (ret)
 			goto out;
 
@@ -186,7 +186,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	 * space addressable by the KVM guest GPA space.
 	 */
 	if ((new->base_gfn + new->npages) >=
-	    (kvm_riscv_gstage_gpa_size >> PAGE_SHIFT))
+	     kvm_riscv_gstage_gpa_size(&kvm->arch) >> PAGE_SHIFT)
 		return -EFAULT;
 
 	hva = new->userspace_addr;
@@ -332,7 +332,7 @@ int kvm_riscv_mmu_map(struct kvm_vcpu *vcpu, struct kvm_memory_slot *memslot,
 	memset(out_map, 0, sizeof(*out_map));
 
 	/* We need minimum second+third level pages */
-	ret = kvm_mmu_topup_memory_cache(pcache, kvm_riscv_gstage_pgd_levels);
+	ret = kvm_mmu_topup_memory_cache(pcache, kvm->arch.kvm_riscv_gstage_pgd_levels);
 	if (ret) {
 		kvm_err("Failed to topup G-stage cache\n");
 		return ret;
@@ -431,6 +431,7 @@ int kvm_riscv_mmu_alloc_pgd(struct kvm *kvm)
 		return -ENOMEM;
 	kvm->arch.pgd = page_to_virt(pgd_page);
 	kvm->arch.pgd_phys = page_to_phys(pgd_page);
+	kvm->arch.kvm_riscv_gstage_pgd_levels = kvm_riscv_gstage_max_pgd_levels;
 
 	return 0;
 }
@@ -446,10 +447,12 @@ void kvm_riscv_mmu_free_pgd(struct kvm *kvm)
 		gstage.flags = 0;
 		gstage.vmid = READ_ONCE(kvm->arch.vmid.vmid);
 		gstage.pgd = kvm->arch.pgd;
-		kvm_riscv_gstage_unmap_range(&gstage, 0UL, kvm_riscv_gstage_gpa_size, false);
+		kvm_riscv_gstage_unmap_range(&gstage, 0UL,
+			kvm_riscv_gstage_gpa_size(&kvm->arch), false);
 		pgd = READ_ONCE(kvm->arch.pgd);
 		kvm->arch.pgd = NULL;
 		kvm->arch.pgd_phys = 0;
+		kvm->arch.kvm_riscv_gstage_pgd_levels = 0;
 	}
 	spin_unlock(&kvm->mmu_lock);
 
@@ -459,11 +462,12 @@ void kvm_riscv_mmu_free_pgd(struct kvm *kvm)
 
 void kvm_riscv_mmu_update_hgatp(struct kvm_vcpu *vcpu)
 {
-	unsigned long hgatp = kvm_riscv_gstage_mode << HGATP_MODE_SHIFT;
-	struct kvm_arch *k = &vcpu->kvm->arch;
+	struct kvm_arch *ka = &vcpu->kvm->arch;
+	unsigned long hgatp = kvm_riscv_gstage_mode(ka->kvm_riscv_gstage_pgd_levels)
+			      << HGATP_MODE_SHIFT;
 
-	hgatp |= (READ_ONCE(k->vmid.vmid) << HGATP_VMID_SHIFT) & HGATP_VMID;
-	hgatp |= (k->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;
+	hgatp |= (READ_ONCE(ka->vmid.vmid) << HGATP_VMID_SHIFT) & HGATP_VMID;
+	hgatp |= (ka->pgd_phys >> PAGE_SHIFT) & HGATP_PPN;
 
 	ncsr_write(CSR_HGATP, hgatp);
 
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index 66d91ae6e9b2..4b2156df40fc 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -200,7 +200,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = KVM_USER_MEM_SLOTS;
 		break;
 	case KVM_CAP_VM_GPA_BITS:
-		r = kvm_riscv_gstage_gpa_bits;
+		r = kvm_riscv_gstage_gpa_bits(&kvm->arch);
 		break;
 	default:
 		r = 0;
diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
index cf34d448289d..c15bdb1dd8be 100644
--- a/arch/riscv/kvm/vmid.c
+++ b/arch/riscv/kvm/vmid.c
@@ -26,7 +26,8 @@ static DEFINE_SPINLOCK(vmid_lock);
 void __init kvm_riscv_gstage_vmid_detect(void)
 {
 	/* Figure-out number of VMID bits in HW */
-	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode << HGATP_MODE_SHIFT) | HGATP_VMID);
+	csr_write(CSR_HGATP, (kvm_riscv_gstage_mode(kvm_riscv_gstage_max_pgd_levels) <<
+			      HGATP_MODE_SHIFT) | HGATP_VMID);
 	vmid_bits = csr_read(CSR_HGATP);
 	vmid_bits = (vmid_bits & HGATP_VMID) >> HGATP_VMID_SHIFT;
 	vmid_bits = fls_long(vmid_bits);
-- 
2.50.1


