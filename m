Return-Path: <kvm+bounces-22137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C63E093AA5C
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 03:11:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4AE581F23B82
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2024 01:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A1B199A2;
	Wed, 24 Jul 2024 01:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J5te9TcT"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vs1-f74.google.com (mail-vs1-f74.google.com [209.85.217.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02696BE4F
	for <kvm@vger.kernel.org>; Wed, 24 Jul 2024 01:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721783478; cv=none; b=EcN6j56gQ87Od4FBOdDx0iWzpx/7vh3rKUUzJ5INPYws9f7ZGXQ/FnXPe1ll9wycoFNHIv5OkNSoEUGtPOicGLgVf29Eyepm9LohiCOB3fzHHIw8DgdMnV0fsAvocHfjKbzyNAPMTo66Ov0viz1xSE3sFOU/pc0Dp+F9ZMW2X+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721783478; c=relaxed/simple;
	bh=1NEDLMlAcgA+MMNk6fOt7BsCAxzszK5ZEjRx8pLHX9Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Lerz7oBhs4/EQlM7NoXa4MU0jThwKTcBOfxosy57AGsmBba8RBZp2cf8bKpDQrBFzwpt6PsCohMOzM1SzGqIgNS6or8GF813dA/Pw/OKUN8MIWrwvBSBjRhBk/taiUJ2b9xU7I0W3W6Yy/kvOWD1Am8V4/qHm4gTYsAkWNXkEwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J5te9TcT; arc=none smtp.client-ip=209.85.217.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vs1-f74.google.com with SMTP id ada2fe7eead31-4928cea3c69so1738205137.3
        for <kvm@vger.kernel.org>; Tue, 23 Jul 2024 18:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721783476; x=1722388276; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lX17S5nNca5CiBEi8R7tHh84KKPLmRWb0mcnxRYOK88=;
        b=J5te9TcTh0mvgv+OTNazh46We+qAqqhNK1V9Efc92i1i3/dl1dg9k6NCz7Jj3iCUuq
         12tCPLWqKz7yWa7ItB5Z2vZZL/HIqqX2OGTVt3XdUUzqYCbVxOD1GK985CM8dd4rRQvl
         U1U9OcaURM5MQmYnbNILWzhNbFp9HIC/n+tQnIx/aANaDV8HZL2Nold+ZNGKm0HuoE7A
         5u+wb0xsoZd3HFfcmKce7LYVW8ayvf9uUYyFpGoOsxYO6kuhcztn3J3P7tbPYd+Gd7kz
         diTh2TxxxoFyCpwNIgXQ9y0k1eTK++2Z5OCH3Lu4UJYBi77GXk6jFOVDBNYxOqwLoVUE
         +8Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721783476; x=1722388276;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lX17S5nNca5CiBEi8R7tHh84KKPLmRWb0mcnxRYOK88=;
        b=wMcCSAUKn1/pXfOICj3sAYqEAZocJVOJfw3I3VXT/OTdIoOBGq7tCvwnf9lv1y/Qq7
         2REHc9XDYOhsd4iI35vvpk1nrZtZ8f7dpVPklOJ/U4RCEzMKmHS/cln4QDwbnQJC4EJc
         0WP6DIMOGJOBg9IczMiw8kuLNaGopiE1CAeXo3u65H5P/uCxlfrP5/CdqUsFGry2Wwsz
         62vlrjytm3MuXo62M8A2KoiE2cCsLKQOGYlsE5r5IEhpxKuim1hs6cXYG5IH1TRolUxW
         1x+EOzc/RIHsTKumSFO4+r1yZfChqVId2AXs0OCm2+1P/cixcPcLgzK6ZsLK+oJ0fBec
         QEPw==
X-Forwarded-Encrypted: i=1; AJvYcCVbghyubMC/yMxCPkP+izEOUZbU3sMtKGgAAQ860+HcBQauRwPdnmJv7EiSXk8e0IEC9DCj8ZxYbb2GKFvOdpI3KvKl
X-Gm-Message-State: AOJu0YyCVqJMW0fwqAkA8Zf687HyOn2r3XQCVzuwDUUAcwihKI6tqA72
	UpOrwu71dn6WIuQEHWYM5lYomNelK1lu1rQq1gLeObZzKvJsb4Us58ePEG88b2QMPlUsGlK0b27
	xFGDoAAAXe77Z4SW4YQ==
X-Google-Smtp-Source: AGHT+IGlIuIrgkANC0pZBbk8z8He5iptT26RG1V2ZrvO9VkU9yoaN+aGYmYAd60aeXGiO8520IPOKzxK6pnBSRdv
X-Received: from jthoughton.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:2a4f])
 (user=jthoughton job=sendgmr) by 2002:a05:6102:2ac6:b0:492:9449:c33e with
 SMTP id ada2fe7eead31-493c19d19c5mr46187137.5.1721783475890; Tue, 23 Jul 2024
 18:11:15 -0700 (PDT)
Date: Wed, 24 Jul 2024 01:10:28 +0000
In-Reply-To: <20240724011037.3671523-1-jthoughton@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240724011037.3671523-1-jthoughton@google.com>
X-Mailer: git-send-email 2.46.0.rc1.232.g9752f9e123-goog
Message-ID: <20240724011037.3671523-4-jthoughton@google.com>
Subject: [PATCH v6 03/11] KVM: arm64: Relax locking for kvm_test_age_gfn and kvm_age_gfn
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, James Houghton <jthoughton@google.com>, 
	James Morse <james.morse@arm.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Raghavendra Rao Ananta <rananta@google.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>, Yu Zhao <yuzhao@google.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"

Replace the MMU write locks (taken in the memslot iteration loop) for
read locks.

Grabbing the read lock instead of the write lock is safe because the
only requirement we have is that the stage-2 page tables do not get
deallocated while we are walking them. The stage2_age_walker() callback
is safe to race with itself; update the comment to reflect the
synchronization change.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 arch/arm64/kvm/Kconfig       |  1 +
 arch/arm64/kvm/hyp/pgtable.c | 15 +++++++++------
 arch/arm64/kvm/mmu.c         | 30 ++++++++++++++++++++++--------
 3 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 58f09370d17e..7a1af8141c0e 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -22,6 +22,7 @@ menuconfig KVM
 	select KVM_COMMON
 	select KVM_GENERIC_HARDWARE_ENABLING
 	select KVM_GENERIC_MMU_NOTIFIER
+	select KVM_MMU_NOTIFIER_YOUNG_LOCKLESS
 	select HAVE_KVM_CPU_RELAX_INTERCEPT
 	select KVM_MMIO
 	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9e2bbee77491..a24a2a857456 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1319,10 +1319,10 @@ static int stage2_age_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	data->young = true;
 
 	/*
-	 * stage2_age_walker() is always called while holding the MMU lock for
-	 * write, so this will always succeed. Nonetheless, this deliberately
-	 * follows the race detection pattern of the other stage-2 walkers in
-	 * case the locking mechanics of the MMU notifiers is ever changed.
+	 * This walk is not exclusive; the PTE is permitted to change from
+	 * under us. If there is a race to update this PTE, then the GFN is
+	 * most likely young, so failing to clear the AF is likely to be
+	 * inconsequential.
 	 */
 	if (data->mkold && !stage2_try_set_pte(ctx, new))
 		return -EAGAIN;
@@ -1345,10 +1345,13 @@ bool kvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr,
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_age_walker,
 		.arg		= &data,
-		.flags		= KVM_PGTABLE_WALK_LEAF,
+		.flags		= KVM_PGTABLE_WALK_LEAF |
+				  KVM_PGTABLE_WALK_SHARED,
 	};
+	int r;
 
-	WARN_ON(kvm_pgtable_walk(pgt, addr, size, &walker));
+	r = kvm_pgtable_walk(pgt, addr, size, &walker);
+	WARN_ON_ONCE(r && r != -EAGAIN);
 	return data.young;
 }
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6981b1bc0946..e37765f6f2a1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1912,29 +1912,43 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
+	bool young = false;
+
+	read_lock(&kvm->mmu_lock);
 
 	if (!kvm->arch.mmu.pgt)
-		return false;
+		goto out;
 
-	return kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
-						   range->start << PAGE_SHIFT,
-						   size, true);
+	young = kvm_pgtable_stage2_test_clear_young(kvm->arch.mmu.pgt,
+						    range->start << PAGE_SHIFT,
+						    size, true);
 	/*
 	 * TODO: Handle nested_mmu structures here using the reverse mapping in
 	 * a later version of patch series.
 	 */
+
+out:
+	read_unlock(&kvm->mmu_lock);
+	return young;
 }
 
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
+	bool young = false;
+
+	read_lock(&kvm->mmu_lock);
 
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
+	read_unlock(&kvm->mmu_lock);
+	return young;
 }
 
 phys_addr_t kvm_mmu_get_httbr(void)
-- 
2.46.0.rc1.232.g9752f9e123-goog


