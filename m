Return-Path: <kvm+bounces-18331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5449D8D3DF7
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 20:06:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B49C285189
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 18:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 483EA1C231B;
	Wed, 29 May 2024 18:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nr+vZDlF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239701C2306
	for <kvm@vger.kernel.org>; Wed, 29 May 2024 18:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717005925; cv=none; b=ZbsPmY9mh8zNvQ1Xhvk74dFuJ7HNMCeeFGWe4DUvlQyGJwHaDYp3+d8QEtoaA21Jm1Qp/dQranTyvaagYc74E95rh+VuKR1lJSA4ULbfPiEffRj3MIK6mWwtZXV3i2Xt77uYc7Oxcc+qHKLO8ht9hEIrkpa8zxvpTkEYvW4xv44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717005925; c=relaxed/simple;
	bh=OQY9Vqs+HI1vENbDn3dmIDSRIhipNfSPU1lQ5OD7EjA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B4o1K9/EzIRxQUy0MOJigaL/2A0KkNYJMc71iYlc6qQZp+ntl9+hrIzKNCBPuFZR1k6/cYzHXUXK6JrnkOTkS1vt+Js8/QJe3ymxkAb7FiKylrJDIDmvGlbPLhBdbTR62mkkKyKhPXH8/5Se7uFklmMPkmhLRamTFBjp5Mj4Vlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nr+vZDlF; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df78ea30f83so315099276.1
        for <kvm@vger.kernel.org>; Wed, 29 May 2024 11:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717005921; x=1717610721; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CwoKXote5Ew7Jsdz/aAIUFFvPSk6A909NzRQYNohjtE=;
        b=nr+vZDlFmFPPDf1BdF4SN97EzlKcU6OGEc4xYlLk50PgwNpqqTTkWRsW0xEzUTGkUi
         2gAhWlBEBw6upS9M6/RN06tHmg4UapKGbwLiiluYqH4hZp4OEuKUAK76EX9ckE3rffVi
         69xXeCTTcH6rT1F170dg7svsF10cKVeDLInlwhNFfHnDtWXklVfgSmMt6qAmdofKta4y
         8wBPPXo238gApUq6tRRn9n/NtUHTqCYIQHvuppg5fHEDU0fe60AvfeYRljjt4aQdvEQq
         l4nt82Oz5spVSo91F0XLS8da8iBGIGGZqflW/V6Rgr7vVKUjjc3sRod9OodOsjAfQXe2
         kq4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717005921; x=1717610721;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CwoKXote5Ew7Jsdz/aAIUFFvPSk6A909NzRQYNohjtE=;
        b=sYIDleDVVazRcIx+ll59AT76MCc+RpzBi1TuQlKUnG5jPoFxP0mhBrLX0oRJSp+qDF
         swQfCExi+knRPe1N0APJidSAaRbVgm/rQ8uuY1YGcnWKdZjr2x1G/GetOme421z9FNx0
         ta0XNj2jppW7q5gGY1iITTIhwYxQ/FYF0eylqYK5sjuWe0M+YzUmJ/2YSv2B4f3CJgQN
         5/15a2hPpjCfFNl8kDrSXQyxX5AGkIo8/KXZrf21wMGduz8/ksyIC6YnP3V6K+TUY034
         FZshAbs7seBt0yDd1ksyA2NsFDPSeD6RCFnCNxEPTci/vfyc0jFKqswWh2FiBClnL+06
         g/DQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYr/19FG2dLQ55Wdl2o70Hu7phdLIQ9uJEnTwVXXAjEYBAP2KEC2DEUneU/JqYKIj61Pmv/q8vyNaWNCVsYfoXSneL
X-Gm-Message-State: AOJu0Yy59/iYx4bviuB3oqEcyIks9xiiLbfGAvn0j8g+pOLVByUGxB/b
	7VxK5ufGwYxPt8gfv7c1PyfBc152Cvva8uaivX7U4nAId5Kx0xPVa4DQ3oH18L1ow2wM1xb/k2C
	NpQ9uVW/dp8G4/7mnHw==
X-Google-Smtp-Source: AGHT+IF9TgFBMPkNgtG0hPNwMJ317N5S8DzPgfu78mJAr8hsxOfUSU1lJMom0dwIl649roanAV0XRBVJc/tZTtZp
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6902:1005:b0:df7:9df5:4bbc with
 SMTP id 3f1490d57ef6-dfa462d091bmr641866276.0.1717005921060; Wed, 29 May 2024
 11:05:21 -0700 (PDT)
Date: Wed, 29 May 2024 18:05:07 +0000
In-Reply-To: <20240529180510.2295118-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240529180510.2295118-1-jthoughton@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <20240529180510.2295118-5-jthoughton@google.com>
Subject: [PATCH v4 4/7] KVM: Move MMU lock acquisition for test/clear_young to architecture
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>, Ankit Agrawal <ankita@nvidia.com>, 
	Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Bibo Mao <maobibo@loongson.cn>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Huacai Chen <chenhuacai@kernel.org>, 
	James Houghton <jthoughton@google.com>, James Morse <james.morse@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvm-riscv@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

For implementation mmu_notifier_{test,clear}_young, the KVM memslot
walker used to take the MMU lock for us. Now make the architectures
take it themselves.

Don't relax locking for any architecture except powerpc e500; its
implementations of kvm_age_gfn and kvm_test_age_gfn simply return false,
so there is no need to grab the KVM MMU lock.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/kvm/mmu.c      | 30 ++++++++++++++++++++++--------
 arch/loongarch/kvm/mmu.c  | 20 +++++++++++++++-----
 arch/mips/kvm/mmu.c       | 21 ++++++++++++++++-----
 arch/powerpc/kvm/book3s.c | 14 ++++++++++++--
 arch/riscv/kvm/mmu.c      | 26 ++++++++++++++++++++------
 arch/x86/kvm/mmu/mmu.c    |  8 ++++++++
 virt/kvm/kvm_main.c       |  4 ++--
 7 files changed, 95 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 8bcab0cc3fe9..8337009dde77 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1773,25 +1773,39 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
+	bool young = false;
+
+	write_lock(&kvm->mmu_lock);
 
 	if (!kvm->arch.mmu.pgt)
-		return false;
+		goto out;
 
-	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
-						   range->start << PAGE_SHIFT,
-						   size, true);
+	young = kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
+						    range->start << PAGE_SHIFT,
+						    size, true);
+
+out:
+	write_unlock(&kvm->mmu_lock);
+	return young;
 }
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
+	bool young = false;
+
+	write_lock(&kvm->mmu_lock);
 
 	if (!kvm->arch.mmu.pgt)
-		return false;
+		goto out;
 
-	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
-						   range->start << PAGE_SHIFT,
-						   size, false);
+	young = kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
+						    range->start << PAGE_SHIFT,
+						    size, false);
+
+out:
+	write_unlock(&kvm->mmu_lock);
+	return young;
 }
 
 phys_addr_t kvm_mmu_get_httbr(void)
diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index 98883aa23ab8..5eb262bcf6b0 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -497,24 +497,34 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	kvm_ptw_ctx ctx;
+	bool young;
+
+	spin_lock(&kvm->mmu_lock);
 
 	ctx.flag = 0;
 	ctx.ops = kvm_mkold_pte;
 	kvm_ptw_prepare(kvm, &ctx);
 
-	return kvm_ptw_top(kvm->arch.pgd, range->start << PAGE_SHIFT,
+	young = kvm_ptw_top(kvm->arch.pgd, range->start << PAGE_SHIFT,
 				range->end << PAGE_SHIFT, &ctx);
+
+	spin_unlock(&kvm->mmu_lock);
+	return young;
 }
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	gpa_t gpa = range->start << PAGE_SHIFT;
-	kvm_pte_t *ptep = kvm_populate_gpa(kvm, NULL, gpa, 0);
+	kvm_pte_t *ptep;
+	bool young;
 
-	if (ptep && kvm_pte_present(NULL, ptep) && kvm_pte_young(*ptep))
-		return true;
+	spin_lock(&kvm->mmu_lock);
+	ptep = kvm_populate_gpa(kvm, NULL, gpa, 0);
 
-	return false;
+	young = ptep && kvm_pte_present(NULL, ptep) && kvm_pte_young(*ptep);
+
+	spin_unlock(&kvm->mmu_lock);
+	return young;
 }
 
 /*
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index c17157e700c0..db3b7cf22db1 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -446,17 +446,28 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm_mips_mkold_gpa_pt(kvm, range->start, range->end);
+	bool young;
+
+	spin_lock(&kvm->mmu_lock);
+	young = kvm_mips_mkold_gpa_pt(kvm, range->start, range->end);
+	spin_unlock(&kvm->mmu_lock);
+	return young;
 }
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	gpa_t gpa = range->start << PAGE_SHIFT;
-	pte_t *gpa_pte = kvm_mips_pte_for_gpa(kvm, NULL, gpa);
+	pte_t *gpa_pte;
+	bool young = false;
 
-	if (!gpa_pte)
-		return false;
-	return pte_young(*gpa_pte);
+	spin_lock(&kvm->mmu_lock);
+	gpa_pte = kvm_mips_pte_for_gpa(kvm, NULL, gpa);
+
+	if (gpa_pte)
+		young = pte_young(*gpa_pte);
+
+	spin_unlock(&kvm->mmu_lock);
+	return young;
 }
 
 /**
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index ff6c38373957..f503ab9ac3a5 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -887,12 +887,22 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm->arch.kvm_ops->age_gfn(kvm, range);
+	bool young;
+
+	spin_lock(&kvm->mmu_lock);
+	young = kvm->arch.kvm_ops->age_gfn(kvm, range);
+	spin_unlock(&kvm->mmu_lock);
+	return young;
 }
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	return kvm->arch.kvm_ops->test_age_gfn(kvm, range);
+	bool young;
+
+	spin_lock(&kvm->mmu_lock);
+	young = kvm->arch.kvm_ops->test_age_gfn(kvm, range);
+	spin_unlock(&kvm->mmu_lock);
+	return young;
 }
 
 int kvmppc_core_init_vm(struct kvm *kvm)
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index b63650f9b966..c78abe8041fb 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -555,17 +555,24 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	pte_t *ptep;
 	u32 ptep_level = 0;
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
+	bool young = false;
+
+	spin_lock(&kvm->mmu_lock);
 
 	if (!kvm->arch.pgd)
-		return false;
+		goto out;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
 
 	if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
 				   &ptep, &ptep_level))
-		return false;
+		goto out;
+
+	young = ptep_test_and_clear_young(NULL, 0, ptep);
 
-	return ptep_test_and_clear_young(NULL, 0, ptep);
+out:
+	spin_unlock(&kvm->mmu_lock);
+	return young;
 }
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
@@ -573,17 +580,24 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	pte_t *ptep;
 	u32 ptep_level = 0;
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
+	bool young = false;
+
+	spin_lock(&kvm->mmu_lock);
 
 	if (!kvm->arch.pgd)
-		return false;
+		goto out;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
 
 	if (!gstage_get_leaf_entry(kvm, range->start << PAGE_SHIFT,
 				   &ptep, &ptep_level))
-		return false;
+		goto out;
+
+	young = pte_young(ptep_get(ptep));
 
-	return pte_young(ptep_get(ptep));
+out:
+	spin_unlock(&kvm->mmu_lock);
+	return young;
 }
 
 int kvm_riscv_gstage_map(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 662f62dfb2aa..6a2a557c2c31 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1630,12 +1630,16 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
+	write_lock(&kvm->mmu_lock);
+
 	if (kvm_memslots_have_rmaps(kvm))
 		young = kvm_handle_gfn_range(kvm, range, kvm_age_rmap);
 
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_age_gfn_range(kvm, range);
 
+	write_unlock(&kvm->mmu_lock);
+
 	return young;
 }
 
@@ -1643,12 +1647,16 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
+	write_lock(&kvm->mmu_lock);
+
 	if (kvm_memslots_have_rmaps(kvm))
 		young = kvm_handle_gfn_range(kvm, range, kvm_test_age_rmap);
 
 	if (tdp_mmu_enabled)
 		young |= kvm_tdp_mmu_test_age_gfn(kvm, range);
 
+	write_unlock(&kvm->mmu_lock);
+
 	return young;
 }
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d197b6725cb3..8d2d3acf18d8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -901,7 +901,7 @@ static int kvm_mmu_notifier_clear_young(struct mmu_notifier *mn,
 	 * more sophisticated heuristic later.
 	 */
 	return kvm_handle_hva_range_no_flush(mn, start, end,
-					     kvm_age_gfn, false);
+					     kvm_age_gfn, true);
 }
 
 static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
@@ -911,7 +911,7 @@ static int kvm_mmu_notifier_test_young(struct mmu_notifier *mn,
 	trace_kvm_test_age_hva(address);
 
 	return kvm_handle_hva_range_no_flush(mn, address, address + 1,
-					     kvm_test_age_gfn, false);
+					     kvm_test_age_gfn, true);
 }
 
 static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
-- 
2.45.1.288.g0e0cd299f1-goog


