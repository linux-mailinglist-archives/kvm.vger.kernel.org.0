Return-Path: <kvm+bounces-73065-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QGt7GvzfqmlqXwEAu9opvQ
	(envelope-from <kvm+bounces-73065-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:09:00 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B1BB3222545
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:08:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1C103318C8D0
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 14:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FC0A3AE71D;
	Fri,  6 Mar 2026 14:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hkjniBmv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F58E3AE190
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 14:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805768; cv=none; b=G+4pHgqLe3dXKH8+EL9VkyNDAg849hX3rJHaGkeAwlj8QS6lfL0QcQxm0dA1BVcx+yDQkSmw6zzLosLPuxz7Sc6YGN1XcyLjp7aIifEtlFyvVJkh4YjBL1BE/enSCqLYm8lGnq3JmRLp86XyApBDMTEYSfzSNZ1EbE2MjWlNI3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805768; c=relaxed/simple;
	bh=ulXlCU/gFt1vNFQq7ZcdgkCRx5AlFlt38S6K5GWCz10=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N9sgizc43INSjXzmeKEhkQTbN9ujlpnl4hOyc8GMJrxlzc6UE+Mb3s09yG4CxWfjC1G9Doa4wYWHvFUlbwCLjqJo0KGCnX6dnwvJHZK9oO0y0q4/ws9Rexlzk6rm/1LRNBAGhrXuE9jbCslC6K5cInhOXuWLYAIJS61316MJ3fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hkjniBmv; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-483a24db6ecso117033415e9.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 06:02:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805762; x=1773410562; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dq2CFWg/s/4LGPe7PH75WI1RwQG3qN/TUDsxF12q5kw=;
        b=hkjniBmvnSHirbJvUIBshkv3eqh8CkIoX0NU8AxxDGvkhfhZdJwgN19/N2lSaTYWkj
         BrJoJulgln57U0gMR/UlFY4nF1eXxTD12ESK/EXvOeDLHl0LmqIGWIFMNP3Q8nqrI9H9
         Isv2N3g7o3jMQXadkFNKKGBgsKw6f2Z5apiofrpzhkXe8jDHFrN/sM+cFqxdidZgwEQ1
         2WMYXg3SxMDlageHUOhrYUNOXOGJ6gm4ZRdJy3c4M++vBN67233/vdeSR9Syi0MUlzXr
         MANnizHFibjtwfF/wTluk9y/7FHCHNoIgcZoQbKSAhXD5d3TDdeDKxxu6NrJUAd70pUo
         vr2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805762; x=1773410562;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dq2CFWg/s/4LGPe7PH75WI1RwQG3qN/TUDsxF12q5kw=;
        b=B7SPDp7KyquGCwhAofb1UHJRRHsvrlV1MKaDgAxw4+wpfEadyZ8DBi+EsKrfFlpSdZ
         MGgXnzhR6+5QT1eZvfvC6igSGYnSxcyDAoaOTrEPO0WhlAQ7BvM1/J9e4YIb3n3EaiVQ
         prOn3jVEFwA/Pild+ovCyAZ3a9W8dF424O94lxuudmmciigw+12DG/G7KadIDzMJzyB7
         T3ByKOlZY3QmTodVetzTBD8EK3bsEf207wJMWfi8CqYeq3/DLFERrkssMxS3ffl2OEwp
         7xdpWpzzt/HgXW/ZxqmGL30pwwageHLf6W6cWkxF8NFrLKGdBZWVz7Zzg1Hppmti23s5
         m89w==
X-Gm-Message-State: AOJu0Yxv+TRS8K9ANCvdr13fRrP87WklxGWN8iZIPJK3olA3jBBDJKux
	AAHfOdGNk9p3GdYJEhzMQpR1j5jiHEGTsCp5qqeNkH09UKWxKXOYxPlg4xxIyW2m/K4DZ7DVsDx
	PqfhHybn3nfe0iMttN5OALt1Ytn4n9MW4XOwm64zK88TcUfUekcB90cdQwYYimHMAjexsxPLh/L
	hozfjdCu0H6iRnDSphS6Y61tlYWQA=
X-Received: from wmbjw16.prod.google.com ([2002:a05:600c:5750:b0:480:4a03:7b6f])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:474f:b0:477:af8d:203a
 with SMTP id 5b1f17b1804b1-48526964c79mr37178325e9.27.1772805761667; Fri, 06
 Mar 2026 06:02:41 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:25 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-7-tabba@google.com>
Subject: [PATCH v1 06/13] KVM: arm64: Extract page table mapping in user_mem_abort()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B1BB3222545
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73065-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Extract the code responsible for locking the KVM MMU and mapping the PFN
into the stage-2 page tables into a new helper, kvm_s2_fault_map().

This helper manages the kvm_fault_lock, checks for MMU invalidation
retries, attempts to adjust for transparent huge pages (THP), handles
MTE sanitization if needed, and finally maps or relaxes permissions on
the stage-2 entries.

With this change, the main user_mem_abort() function is now a sequential
dispatcher that delegates to specialized helper functions.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 128 +++++++++++++++++++++++--------------------
 1 file changed, 68 insertions(+), 60 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index b328299cc0f5..833a7f769467 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1892,68 +1892,13 @@ static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
 	return 0;
 }
 
-static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-			  struct kvm_s2_trans *nested,
-			  struct kvm_memory_slot *memslot, unsigned long hva,
-			  bool fault_is_perm)
+static int kvm_s2_fault_map(struct kvm_s2_fault *fault, void *memcache)
 {
-	int ret = 0;
-	struct kvm_s2_fault fault_data = {
-		.vcpu = vcpu,
-		.fault_ipa = fault_ipa,
-		.nested = nested,
-		.memslot = memslot,
-		.hva = hva,
-		.fault_is_perm = fault_is_perm,
-		.ipa = fault_ipa,
-		.logging_active = memslot_is_logging(memslot),
-		.force_pte = memslot_is_logging(memslot),
-		.s2_force_noncacheable = false,
-		.vfio_allow_any_uc = false,
-		.prot = KVM_PGTABLE_PROT_R,
-	};
-	struct kvm_s2_fault *fault = &fault_data;
-	struct kvm *kvm = vcpu->kvm;
-	void *memcache;
+	struct kvm *kvm = fault->vcpu->kvm;
 	struct kvm_pgtable *pgt;
+	int ret;
 	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
 
-	if (fault->fault_is_perm)
-		fault->fault_granule = kvm_vcpu_trap_get_perm_fault_granule(fault->vcpu);
-	fault->write_fault = kvm_is_write_fault(fault->vcpu);
-	fault->exec_fault = kvm_vcpu_trap_is_exec_fault(fault->vcpu);
-	VM_WARN_ON_ONCE(fault->write_fault && fault->exec_fault);
-
-	/*
-	 * Permission faults just need to update the existing leaf entry,
-	 * and so normally don't require allocations from the memcache. The
-	 * only exception to this is when dirty logging is enabled at runtime
-	 * and a write fault needs to collapse a block entry into a table.
-	 */
-	fault->topup_memcache = !fault->fault_is_perm ||
-				(fault->logging_active && fault->write_fault);
-	ret = prepare_mmu_memcache(fault->vcpu, fault->topup_memcache, &memcache);
-	if (ret)
-		return ret;
-
-	/*
-	 * Let's check if we will get back a huge fault->page backed by hugetlbfs, or
-	 * get block mapping for device MMIO region.
-	 */
-	ret = kvm_s2_fault_pin_pfn(fault);
-	if (ret != 1)
-		return ret;
-
-	ret = 0;
-
-	ret = kvm_s2_fault_compute_prot(fault);
-	if (ret == 1) {
-		ret = 1; /* fault injected */
-		goto out_put_page;
-	}
-	if (ret)
-		goto out_put_page;
-
 	kvm_fault_lock(kvm);
 	pgt = fault->vcpu->arch.hw_mmu->pgt;
 	if (mmu_invalidate_retry(kvm, fault->mmu_seq)) {
@@ -2001,8 +1946,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * PTE, which will be preserved.
 		 */
 		fault->prot &= ~KVM_NV_GUEST_MAP_SZ;
-		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault->fault_ipa, fault->prot,
-								 flags);
+		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault->fault_ipa,
+								 fault->prot, flags);
 	} else {
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault->fault_ipa, fault->vma_pagesize,
 							 __pfn_to_phys(fault->pfn), fault->prot,
@@ -2018,6 +1963,69 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		mark_page_dirty_in_slot(kvm, fault->memslot, fault->gfn);
 
 	return ret != -EAGAIN ? ret : 0;
+}
+
+static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
+			  struct kvm_s2_trans *nested,
+			  struct kvm_memory_slot *memslot, unsigned long hva,
+			  bool fault_is_perm)
+{
+	int ret = 0;
+	struct kvm_s2_fault fault_data = {
+		.vcpu = vcpu,
+		.fault_ipa = fault_ipa,
+		.nested = nested,
+		.memslot = memslot,
+		.hva = hva,
+		.fault_is_perm = fault_is_perm,
+		.ipa = fault_ipa,
+		.logging_active = memslot_is_logging(memslot),
+		.force_pte = memslot_is_logging(memslot),
+		.s2_force_noncacheable = false,
+		.vfio_allow_any_uc = false,
+		.prot = KVM_PGTABLE_PROT_R,
+	};
+	struct kvm_s2_fault *fault = &fault_data;
+	void *memcache;
+
+	if (fault->fault_is_perm)
+		fault->fault_granule = kvm_vcpu_trap_get_perm_fault_granule(fault->vcpu);
+	fault->write_fault = kvm_is_write_fault(fault->vcpu);
+	fault->exec_fault = kvm_vcpu_trap_is_exec_fault(fault->vcpu);
+	VM_WARN_ON_ONCE(fault->write_fault && fault->exec_fault);
+
+	/*
+	 * Permission faults just need to update the existing leaf entry,
+	 * and so normally don't require allocations from the memcache. The
+	 * only exception to this is when dirty logging is enabled at runtime
+	 * and a write fault needs to collapse a block entry into a table.
+	 */
+	fault->topup_memcache = !fault->fault_is_perm ||
+				(fault->logging_active && fault->write_fault);
+	ret = prepare_mmu_memcache(fault->vcpu, fault->topup_memcache, &memcache);
+	if (ret)
+		return ret;
+
+	/*
+	 * Let's check if we will get back a huge fault->page backed by hugetlbfs, or
+	 * get block mapping for device MMIO region.
+	 */
+	ret = kvm_s2_fault_pin_pfn(fault);
+	if (ret != 1)
+		return ret;
+
+	ret = 0;
+
+	ret = kvm_s2_fault_compute_prot(fault);
+	if (ret == 1) {
+		ret = 1; /* fault injected */
+		goto out_put_page;
+	}
+	if (ret)
+		goto out_put_page;
+
+	ret = kvm_s2_fault_map(fault, memcache);
+	return ret;
 
 out_put_page:
 	kvm_release_page_unused(fault->page);
-- 
2.53.0.473.g4a7958ca14-goog


