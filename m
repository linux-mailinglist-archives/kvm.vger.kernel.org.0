Return-Path: <kvm+bounces-46366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 91160AB5A1D
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 18:37:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 657DC4A7A1E
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 16:36:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F8482C0334;
	Tue, 13 May 2025 16:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c8WteXlp"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689CA2BF3E9
	for <kvm@vger.kernel.org>; Tue, 13 May 2025 16:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747154108; cv=none; b=d5XZ3EjFXDMIcNaO2g7ggX1B/s/Zg54Pr+fnJE5g/c9v6dnnGYe1V27z9CkrnpQobKqgzrGLrkKmTI3HAFbgXaStdA5nocTrB1+deczCWBZ4j+kdNzPdeivTPdQdjJ1RNCHf0ELnOHZm8rVBgkEVxAH5tG3191hgO4mRqBSLkkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747154108; c=relaxed/simple;
	bh=o+7g7TGRMBkFIwd+yhmtjHUJT97QY+563PoPTnNJLwk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GQmuzeLbqagz2tq7cUDvORw5LrMq+lfJLRvxvg7V5d3YUWWNB+jL24uh2nFiE4FqFfP7KSZ0/tM1FPoDvA47OJyo1zKJboFiFkVurqUHs37HaC4TKYDTn+8SoD+TW1zbSOluxpbivOnVdDPeWYulpgRz+8Jiyt1oxc5B2F/nuoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c8WteXlp; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-442dc6f0138so16259015e9.0
        for <kvm@vger.kernel.org>; Tue, 13 May 2025 09:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747154105; x=1747758905; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Be1AlR+JPJhKhyuHrgiYClfCDGQ2SZI+bIXk4D2xVD8=;
        b=c8WteXlpLwOMOxuY7qeyCupbLgbK3VEHOSAoHQGbONfod8xRKnZJ+A7USDhmYYNigy
         SqsdgCIJNqsPMJ9L8km7gjMwVAriTaR+nb1k15Tk4lU2zZRECEQcOMay+1C1a6Q/Cvn/
         HBQkLsKLYrCeIe20gQPBP2F4JxgUF+6OCyhA7G2NXK/VHyIJVpFfgiLTOnxVl3YhtaY5
         IcHRYXnQsCwa04xRbJJ3ZENwGqPH1nXmijmcJ4QGda4QncQNHtwcUw6e2cs+UM5qIIGe
         pMylUr/8S+OPfiEwCa3Fmsral0Q/N0UETLuyiuANEKu6QQVHRmG+GM9DuUrPAcfU2xCx
         AAkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747154105; x=1747758905;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Be1AlR+JPJhKhyuHrgiYClfCDGQ2SZI+bIXk4D2xVD8=;
        b=xL8s0UTup38xQbwZHEL9HNG0iw1PssLuTeDIo1y4WZm+ZD1i7M4NaD7ZFikyJ3TWOd
         lZtFZMyqvlLjv6entNO8vGx7dCot3NVsOAdDAm2yCQPuzQ9i4w2tqQFd7O5Rzow+r+6w
         E6BFcgQPQFKDsP7XAQQ0haoKTChVT5qacV/Lbyv3evYy//osQ05psqxyb7+5xvfLPZNF
         meJXkzNtrOs0ZtAC1jtOGmwqn1dKYXFX0kcyM7k8J3zvdKLqOjJnag0FsKi99j6ZTiB7
         CjjFJO39OA1mBxWu5AtilsbXG7xoA6gprqRjySm9wYWDqZw0DhqmBER/lI7y3jJQJlc8
         nBrw==
X-Gm-Message-State: AOJu0YzwFTeXpi452kc6GOtme9Ci2RiZGoXxfxfy0G92owbdguMmZ4Ej
	IRmMbdhTbEAb20VvWbLdzZcX1RuGNafQRDlmN1FGCUE4IedZea4TUDfn56T4tDSe3tlRSenht/r
	8tWoyqU1lhRaHBCxIn2LGjaw9Pl3OHxGCXn5b3TQ/gH+Z7jdF2XdTpdNS28B/J2Zf4GYjQ/4qv1
	kMtfQZXizRPl9wCSwkFIKbWZ8=
X-Google-Smtp-Source: AGHT+IEsMEetoV4YK4SV4vFb6l1Ng9DKZZK9MFFHNiIzxliX7gPauq7tpe88BFecnM4+cLCAaJyauy01cw==
X-Received: from wmbhc10.prod.google.com ([2002:a05:600c:870a:b0:442:cd39:5ca4])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:8207:b0:43c:ee62:33f5
 with SMTP id 5b1f17b1804b1-442d6ddcf2dmr152785155e9.27.1747154104922; Tue, 13
 May 2025 09:35:04 -0700 (PDT)
Date: Tue, 13 May 2025 17:34:33 +0100
In-Reply-To: <20250513163438.3942405-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250513163438.3942405-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.1045.g170613ef41-goog
Message-ID: <20250513163438.3942405-13-tabba@google.com>
Subject: [PATCH v9 12/17] KVM: arm64: Rename variables in user_mem_abort()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	isaku.yamahata@intel.com, mic@digikod.net, vbabka@suse.cz, 
	vannapurve@google.com, ackerleytng@google.com, mail@maciej.szmigiero.name, 
	david@redhat.com, michael.roth@amd.com, wei.w.wang@intel.com, 
	liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, peterx@redhat.com, pankaj.gupta@amd.com, 
	ira.weiny@intel.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Guest memory can be backed by guest_memfd or by anonymous memory. Rename
vma_shift to page_shift and vma_pagesize to page_size to ease
readability in subsequent patches.

Suggested-by: James Houghton <jthoughton@google.com>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 54 ++++++++++++++++++++++----------------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 9865ada04a81..d756c2b5913f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1479,13 +1479,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	phys_addr_t ipa = fault_ipa;
 	struct kvm *kvm = vcpu->kvm;
 	struct vm_area_struct *vma;
-	short vma_shift;
+	short page_shift;
 	void *memcache;
 	gfn_t gfn;
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
 	bool force_pte = logging_active || is_protected_kvm_enabled();
-	long vma_pagesize, fault_granule;
+	long page_size, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
 	struct page *page;
@@ -1538,11 +1538,11 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	}
 
 	if (force_pte)
-		vma_shift = PAGE_SHIFT;
+		page_shift = PAGE_SHIFT;
 	else
-		vma_shift = get_vma_page_shift(vma, hva);
+		page_shift = get_vma_page_shift(vma, hva);
 
-	switch (vma_shift) {
+	switch (page_shift) {
 #ifndef __PAGETABLE_PMD_FOLDED
 	case PUD_SHIFT:
 		if (fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
@@ -1550,23 +1550,23 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		fallthrough;
 #endif
 	case CONT_PMD_SHIFT:
-		vma_shift = PMD_SHIFT;
+		page_shift = PMD_SHIFT;
 		fallthrough;
 	case PMD_SHIFT:
 		if (fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE))
 			break;
 		fallthrough;
 	case CONT_PTE_SHIFT:
-		vma_shift = PAGE_SHIFT;
+		page_shift = PAGE_SHIFT;
 		force_pte = true;
 		fallthrough;
 	case PAGE_SHIFT:
 		break;
 	default:
-		WARN_ONCE(1, "Unknown vma_shift %d", vma_shift);
+		WARN_ONCE(1, "Unknown page_shift %d", page_shift);
 	}
 
-	vma_pagesize = 1UL << vma_shift;
+	page_size = 1UL << page_shift;
 
 	if (nested) {
 		unsigned long max_map_size;
@@ -1592,7 +1592,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			max_map_size = PAGE_SIZE;
 
 		force_pte = (max_map_size == PAGE_SIZE);
-		vma_pagesize = min(vma_pagesize, (long)max_map_size);
+		page_size = min_t(long, page_size, max_map_size);
 	}
 
 	/*
@@ -1600,9 +1600,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * ensure we find the right PFN and lay down the mapping in the right
 	 * place.
 	 */
-	if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE) {
-		fault_ipa &= ~(vma_pagesize - 1);
-		ipa &= ~(vma_pagesize - 1);
+	if (page_size == PMD_SIZE || page_size == PUD_SIZE) {
+		fault_ipa &= ~(page_size - 1);
+		ipa &= ~(page_size - 1);
 	}
 
 	gfn = ipa >> PAGE_SHIFT;
@@ -1627,7 +1627,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	pfn = __kvm_faultin_pfn(memslot, gfn, write_fault ? FOLL_WRITE : 0,
 				&writable, &page);
 	if (pfn == KVM_PFN_ERR_HWPOISON) {
-		kvm_send_hwpoison_signal(hva, vma_shift);
+		kvm_send_hwpoison_signal(hva, page_shift);
 		return 0;
 	}
 	if (is_error_noslot_pfn(pfn))
@@ -1636,9 +1636,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (kvm_is_device_pfn(pfn)) {
 		/*
 		 * If the page was identified as device early by looking at
-		 * the VMA flags, vma_pagesize is already representing the
+		 * the VMA flags, page_size is already representing the
 		 * largest quantity we can map.  If instead it was mapped
-		 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
+		 * via __kvm_faultin_pfn(), page_size is set to PAGE_SIZE
 		 * and must not be upgraded.
 		 *
 		 * In both cases, we don't let transparent_hugepage_adjust()
@@ -1686,16 +1686,16 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 * If we are not forced to use page mapping, check if we are
 	 * backed by a THP and thus use block mapping if possible.
 	 */
-	if (vma_pagesize == PAGE_SIZE && !(force_pte || device)) {
+	if (page_size == PAGE_SIZE && !(force_pte || device)) {
 		if (fault_is_perm && fault_granule > PAGE_SIZE)
-			vma_pagesize = fault_granule;
+			page_size = fault_granule;
 		else
-			vma_pagesize = transparent_hugepage_adjust(kvm, memslot,
-								   hva, &pfn,
-								   &fault_ipa);
+			page_size = transparent_hugepage_adjust(kvm, memslot,
+								hva, &pfn,
+								&fault_ipa);
 
-		if (vma_pagesize < 0) {
-			ret = vma_pagesize;
+		if (page_size < 0) {
+			ret = page_size;
 			goto out_unlock;
 		}
 	}
@@ -1703,7 +1703,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (!fault_is_perm && !device && kvm_has_mte(kvm)) {
 		/* Check the VMM hasn't introduced a new disallowed VMA */
 		if (mte_allowed) {
-			sanitise_mte_tags(kvm, pfn, vma_pagesize);
+			sanitise_mte_tags(kvm, pfn, page_size);
 		} else {
 			ret = -EFAULT;
 			goto out_unlock;
@@ -1728,10 +1728,10 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
-	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
+	 * permissions only if page_size equals fault_granule. Otherwise,
 	 * kvm_pgtable_stage2_map() should be called to change block size.
 	 */
-	if (fault_is_perm && vma_pagesize == fault_granule) {
+	if (fault_is_perm && page_size == fault_granule) {
 		/*
 		 * Drop the SW bits in favour of those stored in the
 		 * PTE, which will be preserved.
@@ -1739,7 +1739,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		prot &= ~KVM_NV_GUEST_MAP_SZ;
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot, flags);
 	} else {
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, vma_pagesize,
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, page_size,
 					     __pfn_to_phys(pfn), prot,
 					     memcache, flags);
 	}
-- 
2.49.0.1045.g170613ef41-goog


