Return-Path: <kvm+bounces-54335-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B276FB1EE94
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 20:57:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B49AD1C24785
	for <lists+kvm@lfdr.de>; Fri,  8 Aug 2025 18:57:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897E6283FF8;
	Fri,  8 Aug 2025 18:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gAw17mz4"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149E6222577
	for <kvm@vger.kernel.org>; Fri,  8 Aug 2025 18:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754679412; cv=none; b=E0YpLfYmm8R1qcV+SAHUnogW9RgZPN6G/EPPgnsOWg/saxaQNCBmqGM6i/9Z1+2FBEpja3C13Y/dQS0RJfk4QJIo0G7kScrB8KeipSRQKNQkeOPVGdv70KrjC+BAdkoq7kZp8Ee/ADP+3IPxeC4TlJlwkKUW+cuBUwJpagfPCi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754679412; c=relaxed/simple;
	bh=d7RKzM3PHZ4V28N9/tZDIrTV+QQRyM6Rsb+C60eYCOE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s933WR4iphMn2AXwUWYQzGrs7/TGviup/2Xaof0Sg93ZujLQBvw6vTavqoIeR3yGCII30XlQrWSXI6cCEDYSLeGf9AKumM3dld94XC26edKULxiL+Ibahz8DsR3KhOexXUXAcQu8zNkntyzC7ivQWJgGm79uQi9mnYgt0JDSum0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gAw17mz4; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 8 Aug 2025 11:56:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754679398;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QQEweAiTXl7uCYmBR+Y/7n2oQdebFZHZYTNv96/JjXY=;
	b=gAw17mz4oym/aoBhLbPmslP80ZAYkNfurE+ctVswd2okrrijXyrbToCAVNrAAe8fdhfyzj
	imtF5PVuDWTUpkJCeACSS2BvlIGjH1LG9ampjXkJMrYpTanhieeCrPPoxznQXRLHVuKFIq
	mtuUzh5uO+R121iAWR5z4IHVfd1reB4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Mingwei Zhang <mizhang@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/2] KVM: arm64: Destroy the stage-2 page-table
 periodically
Message-ID: <aJZIXGDWxD1U0axK@linux.dev>
References: <20250724235144.2428795-1-rananta@google.com>
 <20250724235144.2428795-3-rananta@google.com>
 <aIjwalITY6CAj7TO@linux.dev>
 <CAJHc60wBNTP9SSt_skEXXv9N+tF_1RoV6vcQQx4hWphJF6EmkQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJHc60wBNTP9SSt_skEXXv9N+tF_1RoV6vcQQx4hWphJF6EmkQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Aug 07, 2025 at 11:58:01AM -0700, Raghavendra Rao Ananta wrote:
> Hi Oliver,
> 
> >
> > Protected mode is affected by the same problem, potentially even worse
> > due to the overheads of calling into EL2. Both protected and
> > non-protected flows should use stage2_destroy_range().
> >
> I experimented with this (see diff below), and it looks like it takes
> significantly longer to finish the destruction even for a very small
> VM. For instance, it takes ~140 seconds on an Ampere Altra machine.
> This is probably because we run cond_resched() for every breakup in
> the entire sweep of the possible address range, 0 to  ~(0ULL), even
> though there are no actual mappings there, and we context switch out
> more often.

This seems more like an issue with the upper bound on a pKVM walk rather
than a problem with the suggestion. The information in pgt->ia_bits is
actually derived from the VTCR value of the owning MMU.

Even though we never use the VTCR value in hardware, pKVM MMUs have a
valid VTCR value that encodes the size of the IPA space and we use that
in the common stage-2 abort path.

I'm attaching some fixups that I have on top of your series that'd allow
the resched logic to remain common, like it is in other MMU flows.

From 421468dcaa4692208c3f708682b058cfc072a984 Mon Sep 17 00:00:00 2001
From: Oliver Upton <oliver.upton@linux.dev>
Date: Fri, 8 Aug 2025 11:43:12 -0700
Subject: [PATCH 4/4] fixup! KVM: arm64: Destroy the stage-2 page-table
 periodically

---
 arch/arm64/kvm/mmu.c | 60 ++++++++++++++++++--------------------------
 1 file changed, 25 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b82412323054..fc93cc256bd8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -383,40 +383,6 @@ static void stage2_flush_vm(struct kvm *kvm)
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
-/*
- * Assume that @pgt is valid and unlinked from the KVM MMU to free the
- * page-table without taking the kvm_mmu_lock and without performing any
- * TLB invalidations.
- *
- * Also, the range of addresses can be large enough to cause need_resched
- * warnings, for instance on CONFIG_PREEMPT_NONE kernels. Hence, invoke
- * cond_resched() periodically to prevent hogging the CPU for a long time
- * and schedule something else, if required.
- */
-static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
-			      phys_addr_t end)
-{
-	u64 next;
-
-	do {
-		next = stage2_range_addr_end(addr, end);
-		kvm_pgtable_stage2_destroy_range(pgt, addr, next - addr);
-
-		if (next != end)
-			cond_resched();
-	} while (addr = next, addr != end);
-}
-
-static void kvm_destroy_stage2_pgt(struct kvm_pgtable *pgt)
-{
-	if (!is_protected_kvm_enabled()) {
-		stage2_destroy_range(pgt, 0, BIT(pgt->ia_bits));
-		kvm_pgtable_stage2_destroy_pgd(pgt);
-	} else {
-		pkvm_pgtable_stage2_destroy(pgt);
-	}
-}
-
 /**
  * free_hyp_pgds - free Hyp-mode page tables
  */
@@ -938,11 +904,35 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
 	return 0;
 }
 
+/*
+ * Assume that @pgt is valid and unlinked from the KVM MMU to free the
+ * page-table without taking the kvm_mmu_lock and without performing any
+ * TLB invalidations.
+ *
+ * Also, the range of addresses can be large enough to cause need_resched
+ * warnings, for instance on CONFIG_PREEMPT_NONE kernels. Hence, invoke
+ * cond_resched() periodically to prevent hogging the CPU for a long time
+ * and schedule something else, if required.
+ */
+static void stage2_destroy_range(struct kvm_pgtable *pgt, phys_addr_t addr,
+				 phys_addr_t end)
+{
+	u64 next;
+
+	do {
+		next = stage2_range_addr_end(addr, end);
+		KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, addr, next - addr);
+
+		if (next != end)
+			cond_resched();
+	} while (addr = next, addr != end);
+}
+
 static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
 {
 	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
 
-	KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, 0, BIT(ia_bits));
+	stage2_destroy_range(pgt, 0, BIT(ia_bits));
 	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
 }
 
-- 
2.39.5

