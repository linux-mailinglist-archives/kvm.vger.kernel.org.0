Return-Path: <kvm+bounces-73063-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qJSNMKveqmlqXwEAu9opvQ
	(envelope-from <kvm+bounces-73063-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:03:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FE612223FE
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 15:03:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 351ED300F968
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 14:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E8583A9D8C;
	Fri,  6 Mar 2026 14:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xo38AeoO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D28D3ACF19
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 14:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772805766; cv=none; b=s4cBxQv/q+6DtdvFOZysWngQZxTaqQAeJKSSED499V4RiHYaywfxrJEQycz17hmIJhcH84WPsFGTbyWgi1XABcEE69cMvPgr6Ot0pTznuXnHwQr1oyxiGmiY9DfYvWzNtqyqbVOCRus3AGZ2Pwn89lalb43si9vaB+iJneVXvO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772805766; c=relaxed/simple;
	bh=74/F3MjC37i63LXDp2dGzW2ZRKZ+msQg6vKn+ht000s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E31t9VGyicVA1qMGE7aXYAesjJxyi8GFZTNxqWaclbn5Pq8QkgmLDOHLHKLLB7US0R3LI3tmno4ow1jD0fFbrkKcXvBTto8VZHdUtyaf6bSPIvM+AzhbRfOdftdVE0h20d57mH4Ziw+1VPXLT+Zqsr4FNM6Z55JS71QZyYhluuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xo38AeoO; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b8fbaa0787cso1145421366b.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2026 06:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772805761; x=1773410561; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TocInmoOWJ8fFP1iH0uGrF2E0/0ArBixtXbl/xtyH9I=;
        b=xo38AeoOYeImvMDaN44OiWM+2PRe5BfF3ONthWjr3aOBkjb1BLSQ4voveWW03mRWbb
         DH5DFimdy7xjNskj5+EvJNgywzoIpkQsQ0LZYPxMaxBjQd4HQxycBx/rxT5+xi7Uk4tl
         Vu2V7pBZ7hnulvGH4bnJpoIEiPl+jrkX0WK53cF+7NFiX6ieAL1VREUug9JIW7fZAh/9
         kL9Hz/wUf/ULoeU8+v5KKx7fkiC+pkdgl/vsZCpq7wyDxBfbO09NpY6TNWVkQDaJQmD5
         DsfE9zvFmj0MsVYYF5Ir0KydOfP6cVxwvZa6B15aeSYtT0swY5wtcWttDdsLly0/5Q1V
         TXMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772805761; x=1773410561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TocInmoOWJ8fFP1iH0uGrF2E0/0ArBixtXbl/xtyH9I=;
        b=fA4ldu3kujnrsvy1jFhjYduGOoR95lXVdFIm2b4LsSDAkfz1ar35irhU0ZWKCKITH1
         WdyNxbeg91oMoXf1SY6ztmlx3SxRi8cDMdtvw9Kk5DWFXk+oQTpy8azBuHxhYKg2wJUc
         1lp1beymeAPBsq+32q9lZ3HVPwEcs4F+7DxcYirHrKrtadtfepJ7OTGux8qx57NhxLl0
         fBIroFgEUzq9TPDj2SlpjBw1LX6RWSaIm/NQFNN4dmUcoNAIrrqob+281M6iQQSC4Mrk
         SbU7v7HPNGBiPpAVHv23y6WNiHY4WZGU4/b3R01ln7MWH+vU571U2T7fEjnc6cVhkZ1P
         HJ+g==
X-Gm-Message-State: AOJu0YwcPtCPBW0WewMuTvU+mI3p2f+m079ielIyYSEYyVIi0G9tCyr+
	kBPjnJUGpkIG6zJmOJXBR1VgV74QUFRrL/IzSOyGupZ2+OVeXTExPGJxnurB3b1XwCOZSBJs1zg
	NKpjFJL2XABdPlrAPhvED0E2ssYdAqTtvsT3/0f3IkD/shMzVef1oZYPSImtQEFTVDn9lRnVtYE
	OkZ4aXmverLDo3rK4ntE0aZ4cOPJY=
X-Received: from edtb21.prod.google.com ([2002:aa7:c915:0:b0:661:344d:ea14])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:96ac:b0:b8e:dab6:82a6
 with SMTP id a640c23a62f3a-b942e0261f6mr129346866b.57.1772805760166; Fri, 06
 Mar 2026 06:02:40 -0800 (PST)
Date: Fri,  6 Mar 2026 14:02:24 +0000
In-Reply-To: <20260306140232.2193802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260306140232.2193802-1-tabba@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260306140232.2193802-6-tabba@google.com>
Subject: [PATCH v1 05/13] KVM: arm64: Extract stage-2 permission logic in user_mem_abort()
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3FE612223FE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-73063-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[tabba@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_TWELVE(0.00)[13];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo]
X-Rspamd-Action: no action

Extract the logic that computes the stage-2 protections and checks for
various permission faults (e.g., execution faults on non-cacheable
memory) into a new helper function, kvm_s2_fault_compute_prot(). This
helper also handles injecting atomic/exclusive faults back into the
guest when necessary.

This refactoring step separates the permission computation from the
mapping logic, making the main fault handler flow clearer.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/mmu.c | 163 +++++++++++++++++++++++--------------------
 1 file changed, 87 insertions(+), 76 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 344a477e1bff..b328299cc0f5 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1809,6 +1809,89 @@ static int kvm_s2_fault_pin_pfn(struct kvm_s2_fault *fault)
 	return 1;
 }
 
+static int kvm_s2_fault_compute_prot(struct kvm_s2_fault *fault)
+{
+	struct kvm *kvm = fault->vcpu->kvm;
+
+	/*
+	 * Check if this is non-struct page memory PFN, and cannot support
+	 * CMOs. It could potentially be unsafe to access as cacheable.
+	 */
+	if (fault->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
+		if (fault->is_vma_cacheable) {
+			/*
+			 * Whilst the VMA owner expects cacheable mapping to this
+			 * PFN, hardware also has to support the FWB and CACHE DIC
+			 * features.
+			 *
+			 * ARM64 KVM relies on kernel VA mapping to the PFN to
+			 * perform cache maintenance as the CMO instructions work on
+			 * virtual addresses. VM_PFNMAP region are not necessarily
+			 * mapped to a KVA and hence the presence of hardware features
+			 * S2FWB and CACHE DIC are mandatory to avoid the need for
+			 * cache maintenance.
+			 */
+			if (!kvm_supports_cacheable_pfnmap())
+				return -EFAULT;
+		} else {
+			/*
+			 * If the page was identified as device early by looking at
+			 * the VMA flags, vma_pagesize is already representing the
+			 * largest quantity we can map.  If instead it was mapped
+			 * via __kvm_faultin_pfn(), vma_pagesize is set to PAGE_SIZE
+			 * and must not be upgraded.
+			 *
+			 * In both cases, we don't let transparent_hugepage_adjust()
+			 * change things at the last minute.
+			 */
+			fault->s2_force_noncacheable = true;
+		}
+	} else if (fault->logging_active && !fault->write_fault) {
+		/*
+		 * Only actually map the page as writable if this was a write
+		 * fault.
+		 */
+		fault->writable = false;
+	}
+
+	if (fault->exec_fault && fault->s2_force_noncacheable)
+		return -ENOEXEC;
+
+	/*
+	 * Guest performs atomic/exclusive operations on memory with unsupported
+	 * attributes (e.g. ld64b/st64b on normal memory when no FEAT_LS64WB)
+	 * and trigger the exception here. Since the memslot is valid, inject
+	 * the fault back to the guest.
+	 */
+	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(fault->vcpu))) {
+		kvm_inject_dabt_excl_atomic(fault->vcpu, kvm_vcpu_get_hfar(fault->vcpu));
+		return 1;
+	}
+
+	if (fault->nested)
+		adjust_nested_fault_perms(fault->nested, &fault->prot, &fault->writable);
+
+	if (fault->writable)
+		fault->prot |= KVM_PGTABLE_PROT_W;
+
+	if (fault->exec_fault)
+		fault->prot |= KVM_PGTABLE_PROT_X;
+
+	if (fault->s2_force_noncacheable) {
+		if (fault->vfio_allow_any_uc)
+			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
+		else
+			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
+	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
+		fault->prot |= KVM_PGTABLE_PROT_X;
+	}
+
+	if (fault->nested)
+		adjust_nested_exec_perms(kvm, fault->nested, &fault->prot);
+
+	return 0;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_s2_trans *nested,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
@@ -1863,68 +1946,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 
 	ret = 0;
 
-	/*
-	 * Check if this is non-struct fault->page memory PFN, and cannot support
-	 * CMOs. It could potentially be unsafe to access as cacheable.
-	 */
-	if (fault->vm_flags & (VM_PFNMAP | VM_MIXEDMAP) && !pfn_is_map_memory(fault->pfn)) {
-		if (fault->is_vma_cacheable) {
-			/*
-			 * Whilst the VMA owner expects cacheable mapping to this
-			 * PFN, hardware also has to support the FWB and CACHE DIC
-			 * features.
-			 *
-			 * ARM64 KVM relies on kernel VA mapping to the PFN to
-			 * perform cache maintenance as the CMO instructions work on
-			 * virtual addresses. VM_PFNMAP region are not necessarily
-			 * mapped to a KVA and hence the presence of hardware features
-			 * S2FWB and CACHE DIC are mandatory to avoid the need for
-			 * cache maintenance.
-			 */
-			if (!kvm_supports_cacheable_pfnmap())
-				ret = -EFAULT;
-		} else {
-			/*
-			 * If the fault->page was identified as device early by looking at
-			 * the VMA flags, fault->vma_pagesize is already representing the
-			 * largest quantity we can map.  If instead it was mapped
-			 * via __kvm_faultin_pfn(), fault->vma_pagesize is set to PAGE_SIZE
-			 * and must not be upgraded.
-			 *
-			 * In both cases, we don't let transparent_hugepage_adjust()
-			 * change things at the last minute.
-			 */
-			fault->s2_force_noncacheable = true;
-		}
-	} else if (fault->logging_active && !fault->write_fault) {
-		/*
-		 * Only actually map the fault->page as fault->writable if this was a write
-		 * fault.
-		 */
-		fault->writable = false;
+	ret = kvm_s2_fault_compute_prot(fault);
+	if (ret == 1) {
+		ret = 1; /* fault injected */
+		goto out_put_page;
 	}
-
-	if (fault->exec_fault && fault->s2_force_noncacheable)
-		ret = -ENOEXEC;
-
 	if (ret)
 		goto out_put_page;
 
-	/*
-	 * Guest performs atomic/exclusive operations on memory with unsupported
-	 * attributes (e.g. ld64b/st64b on normal memory when no FEAT_LS64WB)
-	 * and trigger the exception here. Since the fault->memslot is valid, inject
-	 * the fault back to the guest.
-	 */
-	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(fault->vcpu))) {
-		kvm_inject_dabt_excl_atomic(fault->vcpu, kvm_vcpu_get_hfar(fault->vcpu));
-		ret = 1;
-		goto out_put_page;
-	}
-
-	if (fault->nested)
-		adjust_nested_fault_perms(fault->nested, &fault->prot, &fault->writable);
-
 	kvm_fault_lock(kvm);
 	pgt = fault->vcpu->arch.hw_mmu->pgt;
 	if (mmu_invalidate_retry(kvm, fault->mmu_seq)) {
@@ -1961,24 +1990,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		}
 	}
 
-	if (fault->writable)
-		fault->prot |= KVM_PGTABLE_PROT_W;
-
-	if (fault->exec_fault)
-		fault->prot |= KVM_PGTABLE_PROT_X;
-
-	if (fault->s2_force_noncacheable) {
-		if (fault->vfio_allow_any_uc)
-			fault->prot |= KVM_PGTABLE_PROT_NORMAL_NC;
-		else
-			fault->prot |= KVM_PGTABLE_PROT_DEVICE;
-	} else if (cpus_have_final_cap(ARM64_HAS_CACHE_DIC)) {
-		fault->prot |= KVM_PGTABLE_PROT_X;
-	}
-
-	if (fault->nested)
-		adjust_nested_exec_perms(kvm, fault->nested, &fault->prot);
-
 	/*
 	 * Under the premise of getting a FSC_PERM fault, we just need to relax
 	 * permissions only if fault->vma_pagesize equals fault->fault_granule. Otherwise,
-- 
2.53.0.473.g4a7958ca14-goog


