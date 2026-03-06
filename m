Return-Path: <kvm+bounces-73060-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YMuQFtveqmlqXwEAu9opvQ
	(envelope-from <kvm+bounces-73060-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:04:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 56FAE22242A
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:04:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 69654303088B
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 14:03:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 900A43AE6FE;
	Fri,  6 Mar 2026 14:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3PYK83n3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77CE3ACEFA
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 14:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805764; cv=none; b=LwbCDDaYFXzCdnspOnzFfA3ji+3eFdBZ+Dqy0GpQ0E/abPgHmkujlGe7vuz+RVo3ToDR2IQaREtuGxm80jMoYMZESPoB31d1gHbzwLXXBhF4Y8mjkZ/vY+PVvgDb1sqZ20YovDZCL5ZYhDizkMN+6zR0WPswMBeRvrAGXAZydd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805764; c=relaxed/simple;
	bh=EFWfxpnjqxfetJ7tbsDK4e4T3YbFsx9lD0banru7E9s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mGtV58wrtaCB4fNf3HVBCPyOi9N3qgEz70AmNHfJmWsGkhm+RHx9iCy3U/YDa4Y9cuhoxUXcNjIMCDG+xXeVnQTVwHusXtdLLdexVqss1d3NUpgQbOyXoBlnYh+4FB/ZU+r1wkXv8aciMes0nf5k65RQeLO0fK1Nz/b/FM8ZogY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3PYK83n3; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-661aae3a881so1286009a12.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 06:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805758; x=1773410558; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJF5wl0idW47D9GCd6ULDgMs+egUo0RLejd/z4xiKdQ=;
        b=3PYK83n3zj7gmCwpHgfiEhtnaUWL2515z9EPvdLzPzYItgK7kFVksMX5ayrnvXURoD
         zyAdQq9id6tM6CI7YIdjHctt6BMsxK0CVVEdAEwgBPGfTCcvTw8tGka6Pe0LxXyGpM3p
         rIabqePh5mLsNyM3jG6HUfiK0g7vTjLYTDsU6tBolZCfHNmVWTsVk1p6JXO9n361ni+/
         /pKy+VaAH7gNgKde7CLLGBOKoCaMmR/QQ1ZtZJIEzSP+lwUCk7PjUo9v8ZPvcrEO8xsY
         TRg0GGVv3IdknKLUqjMIcaeB6PPXJTc0stfYahgpCkI3fyEF9qxQxEF6+DhyHil16Z+q
         d7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805758; x=1773410558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJF5wl0idW47D9GCd6ULDgMs+egUo0RLejd/z4xiKdQ=;
        b=Ng+ufrWTC2nBj8AL9Fa9vY7XltOAIe0Yowu4FrEpRl46rNsl3CYkcnagzPLtEP8lpv
         L2HIwWNjUH+OIlQFypnx96w6J3fqYCiUQnDPW8oA6xteq22y22jz08FQIqNmmBGtcVB1
         sCUwfglNnKpGvaOt4njIseNQNG94Z0l4l1SQRf7HIAObbgpwjT0YlabWwk3JVcnv3ona
         dXdsmRKnKttXHMn2kKW7hdUtGjSdi/QNa8nXeGJz31B3yBaSRE8A0fSC6M4gljBqwXhy
         Hcu+Fhwbznz/kK8x2D05hnX2SFQXrPu6IMEBmo+zGAb4xcIsUn1pP70iV1VhzgyHBXf+
         1nJQ==
X-Gm-Message-State: AOJu0YzFmYFVNdjBYdyE/ErCBrWGDIC0k7sYMqqzh6EfEgAVIVhxhzW6
	UNOTgUtt8qEpks+5xWNaEOOztenNWSvszSBO2CA7C8sdE9XCTHrrJun2ydNbGJAMrfysYzjbPsr
	qEv5Kfjv1FxqtDtiHJfmWJ+ex6h54zxZgNFKJS+G8AbHNoXlTbUUPujq83hzSfFNIER6SqRZ6rw
	yYSFWXVx3XRemntmbOh5zlSTPaxHs=
X-Received: from edai24.prod.google.com ([2002:a05:6402:f18:b0:660:af3b:aad3])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:4303:b0:65a:3526:50e0
 with SMTP id 4fb4d7f45d1cf-6619d4ff435mr1156859a12.30.1772805757678; Fri, 06
 Mar 2026 06:02:37 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:22 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-4-tabba@google.com>
Subject: [PATCH v1 03/13] KVM: arm64: Extract PFN resolution in user_mem_abort()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 56FAE22242A
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73060-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

Extract the section of code responsible for pinning the physical page
frame number (PFN) backing the faulting IPA into a new helper,
kvm_s2_fault_pin_pfn().

This helper encapsulates the critical section where the mmap_read_lock
is held, the VMA is looked up, the mmu invalidate sequence is sampled,
and the PFN is ultimately resolved via __kvm_faultin_pfn(). It also
handles the early exits for hardware poisoned pages and noslot PFNs.

By isolating this region, we can begin to organize the state variables
required for PFN resolution into the kvm_s2_fault struct, clearing out
a significant amount of local variable clutter from user_mem_abort().

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 105 ++++++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 419b793c5891..d56c6422ca5f 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1740,55 +1740,11 @@ struct kvm_s2_fault {
 	vm_flags_t vm_flags;
 };
 
-static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
-			  struct kvm_s2_trans *nested,
-			  struct kvm_memory_slot *memslot, unsigned long hva,
-			  bool fault_is_perm)
+static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
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
 	struct vm_area_struct *vma;
-	void *memcache;
-	struct kvm_pgtable *pgt;
-	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
+	struct kvm *kvm = fault->vcpu->kvm;
 
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
 	mmap_read_lock(current->mm);
 	vma = vma_lookup(current->mm, fault->hva);
 	if (unlikely(!vma)) {
@@ -1842,6 +1798,63 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	if (is_error_noslot_pfn(fault->pfn))
 		return -EFAULT;
 
+	return 1;
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
+	struct kvm *kvm = vcpu->kvm;
+	void *memcache;
+	struct kvm_pgtable *pgt;
+	enum kvm_pgtable_walk_flags flags = KVM_PGTABLE_WALK_SHARED;
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
 	/*
 	 * Check if this is non-struct fault->page memory PFN, and cannot support
 	 * CMOs. It could potentially be unsafe to access as cacheable.
-- 
2.53.0.473.g4a7958ca14-goog


