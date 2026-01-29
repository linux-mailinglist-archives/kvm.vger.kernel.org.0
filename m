Return-Path: <kvm+bounces-69485-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CE63Li+3emkr9gEAu9opvQ
	(envelope-from <kvm+bounces-69485-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:26:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3967AAAB55
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:26:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C6FCB3088B11
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:19:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CD2136D518;
	Thu, 29 Jan 2026 01:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w5peNNh2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EB223314C4
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649396; cv=none; b=sdaNsUuf6+i9a0GwzHiqAOBwfwa0ZGTmQ3CGaDfGvFOtlYzkpgE6xxLzJnzVB2adimLxiaz01DrevDyrh30otJk8DSS+9IrwSTT43tLtuojEcFBAiSIsw/L8u/dFEy6ALw6es2VMQ/7vNF8igWccDfRxIe6nvwCuAnAJC0YM6Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649396; c=relaxed/simple;
	bh=Y+c4aNyIIj8WvslN5Bwj78lT0iBBJf1QhhvlZTFeuW0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=h21pyYx/9nqiXkaf+2bNrGMXbzKxBNhmGVBG/3umlplDTlkEuHqCePAkJTw4Lioi4QxuL3sUFbeyu/o8qBbGynm9zkS2JPvJT++mKvFzc6C+9/Pa4DBYr6GO+qDb+xkb3cgGGnJQm1lQYheDtJLz2Mp3eA7G+42RQ2mM5tQxFts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w5peNNh2; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6187bdadcdso216472a12.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649392; x=1770254192; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0KZFqHRSBZl8QkQW9ClCrTtdFCm69ml2u4d1T0I6oYw=;
        b=w5peNNh22085kspSprL3mtRockrJMiRN3mV8CBqL0zoKOOg23CP1x7beK/6VS1hi7R
         sWGNC2z5bGrSdaIBrR1/FIKX9/1puKBip1iihNpLCEvXEB2ERBwadQ9fZ2yINAr7nGBY
         zpaeyA1omqxTMiLvLojijUrvVyvllriXSqi+73RBZ0E1jxF0m1M+ggFhYLGsseXhKsQY
         4pywNMxK2aHhMZxKZG4EBWLypp+j8xak/89JD+9OzxEyntAzHBRnetD77StttKeHTWL+
         sA5S0UUvVhYHAxxhcX6eNRHehCKOWScJi08a5pq3hc4X1w8h1FRbgfm5Mwq2Dl+5eMw5
         ePvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649392; x=1770254192;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0KZFqHRSBZl8QkQW9ClCrTtdFCm69ml2u4d1T0I6oYw=;
        b=IDWEbGku7cVq6X2nzXNHtFyJm5B6CXeuwKx2VlL92FGng5hUFpNo+FO0YABQgw/HYj
         3w5uA6PNzLMjG4QqC+XKgU9cDQ6Ap9WvEjasxvUSuXwG8O2x0p9Oc/RqA2hiqFNT19Xh
         VOnW0YmPaQd0Cuv3w9EFOgHOYmZhYI57/M3mhVNZ2q5f9vlTtheqzMgy9El225hBqk1l
         ENmTpQPrQMw3lgW9jXpc4Mas6XRmtJxIE3KzdXLumvkzI5L95B5WmtEIxXFl67eYBwNO
         GRjAELTi3RGXayLEYv249e2yX+CfGJB225bBnfvEjBtnUC1TgV/gXxAD27F5xYsoBq2c
         Yu2w==
X-Forwarded-Encrypted: i=1; AJvYcCW5BK2U0R6WXejDR0lwFoKtWHEiheHdYdoSIOXZlu58LjXhJyAB33IK7Qg+nyZt1577ktM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq3/P+dlzYqZMZlsCRZNkjtn+R30/6wb0h0qKTPpMFMZlr0GOL
	fxyunDBQh3U6Ao51c4Ps3BwRUtJ4TeUA+mwRlCprL/r4zBSIW4d2uy3jEzpEQsoW5IowWTehuwD
	svfXZOQ==
X-Received: from pjd16.prod.google.com ([2002:a17:90b:54d0:b0:32e:ca6a:7ca9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d12:b0:34f:14d6:15f5
 with SMTP id adf61e73a8af0-38ec62dddd6mr5885937637.29.1769649392490; Wed, 28
 Jan 2026 17:16:32 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:06 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-35-seanjc@google.com>
Subject: [RFC PATCH v5 34/45] KVM: TDX: Handle removal of leaf SPTEs in .set_private_spte()
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69485-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 3967AAAB55
X-Rspamd-Action: no action

Drop kvm_x86_ops.remove_external_spte(), and instead handling the removal
of leaf SPTEs in the S-EPT (a.k.a. external root) in .set_private_spte().
This will allow extending tdx_sept_set_private_spte() to support splitting
a huge S-EPT entry without needing yet another kvm_x86_ops hook.

Bug the VM if the callback fails, as redundant KVM_BUG_ON() calls are
benign (the WARN will fire if and only if the VM isn't already bugged) and
handle_changed_spte() is most definitely not prepared to handle failure.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 -
 arch/x86/include/asm/kvm_host.h    |  2 --
 arch/x86/kvm/mmu/tdp_mmu.c         | 20 +++++++++++---------
 arch/x86/kvm/vmx/tdx.c             | 21 ++++++++++++---------
 4 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 394dc29483a7..3ca56fe6b951 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -97,7 +97,6 @@ KVM_X86_OP(load_mmu_pgd)
 KVM_X86_OP_OPTIONAL(alloc_external_sp)
 KVM_X86_OP_OPTIONAL(free_external_sp)
 KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
-KVM_X86_OP_OPTIONAL(remove_external_spte)
 KVM_X86_OP_OPTIONAL(reclaim_external_sp)
 KVM_X86_OP_OPTIONAL_RET0(topup_external_cache)
 KVM_X86_OP(has_wbinvd_exit)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 67deec8e205e..385f1cf32d70 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1861,8 +1861,6 @@ struct kvm_x86_ops {
 				 u64 new_spte, enum pg_level level);
 	void (*reclaim_external_sp)(struct kvm *kvm, gfn_t gfn,
 				    struct kvm_mmu_page *sp);
-	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				     u64 mirror_spte);
 	int (*topup_external_cache)(struct kvm_vcpu *vcpu, int min);
 
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 271dd6f875a6..d49aecba18d8 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -559,20 +559,22 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	 * SPTE being converted to a hugepage (leaf) or being zapped.  Shadow
 	 * pages are kernel allocations and should never be migrated.
 	 *
-	 * When removing leaf entries from a mirror, immediately propagate the
-	 * changes to the external page tables.  Note, non-leaf mirror entries
-	 * are handled by handle_removed_pt(), as TDX requires that all leaf
-	 * entries are removed before the owning page table.  Note #2, writes
-	 * to make mirror PTEs shadow-present are propagated to external page
-	 * tables by __tdp_mmu_set_spte_atomic(), as KVM needs to ensure the
-	 * external page table was successfully updated before marking the
-	 * mirror SPTE present.
+	 * When modifying leaf entries in mirrored page tables, propagate the
+	 * changes to the external SPTE.  Bug the VM on failure, as callers
+	 * aren't prepared to handle errors, e.g. due to lock contention in the
+	 * TDX-Module.  Note, changes to non-leaf mirror SPTEs are handled by
+	 * handle_removed_pt() (the TDX-Module requires that child entries are
+	 * removed before the parent SPTE), and changes to non-present mirror
+	 * SPTEs are handled by __tdp_mmu_set_spte_atomic() (KVM needs to set
+	 * the external SPTE while the mirror SPTE is frozen so that installing
+	 * a new SPTE is effectively an atomic operation).
 	 */
 	if (was_present && !was_leaf &&
 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
 	else if (was_leaf && is_mirror_sptep(sptep) && !is_leaf)
-		kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_spte);
+		KVM_BUG_ON(kvm_x86_call(set_external_spte)(kvm, gfn, old_spte,
+							   new_spte, level), kvm);
 }
 
 static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0f3d27699a3d..9f7789c5f0a7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1751,11 +1751,11 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
-static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
-					 enum pg_level level, u64 mirror_spte)
+static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
+					enum pg_level level, u64 old_spte)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	kvm_pfn_t pfn = spte_to_pfn(mirror_spte);
+	kvm_pfn_t pfn = spte_to_pfn(old_spte);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
 
@@ -1767,16 +1767,16 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * there can't be anything populated in the private EPT.
 	 */
 	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
-		return;
+		return -EIO;
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return;
+		return -EIO;
 
 	err = tdh_do_no_vcpus(tdh_mem_range_block, kvm, &kvm_tdx->td, gpa,
 			      level, &entry, &level_state);
 	if (TDX_BUG_ON_2(err, TDH_MEM_RANGE_BLOCK, entry, level_state, kvm))
-		return;
+		return -EIO;
 
 	/*
 	 * TDX requires TLB tracking before dropping private page.  Do
@@ -1792,14 +1792,15 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	err = tdh_do_no_vcpus(tdh_mem_page_remove, kvm, &kvm_tdx->td, gpa,
 			      level, &entry, &level_state);
 	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_REMOVE, entry, level_state, kvm))
-		return;
+		return -EIO;
 
 	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, pfn, level);
 	if (TDX_BUG_ON(err, TDH_PHYMEM_PAGE_WBINVD, kvm))
-		return;
+		return -EIO;
 
 	__tdx_quirk_reset_page(pfn, level);
 	tdx_pamt_put(pfn, level);
+	return 0;
 }
 
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
@@ -1811,6 +1812,9 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	int ret;
 
+	if (is_shadow_present_pte(old_spte))
+		return tdx_sept_remove_private_spte(kvm, gfn, level, old_spte);
+
 	if (KVM_BUG_ON(!vcpu, kvm))
 		return -EINVAL;
 
@@ -3639,7 +3643,6 @@ void __init tdx_hardware_setup(void)
 
 	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
 	vt_x86_ops.reclaim_external_sp = tdx_sept_reclaim_private_sp;
-	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
 
 	/*
 	 * FIXME: Wire up the PAMT hook iff DPAMT is supported, once VMXON is
-- 
2.53.0.rc1.217.geba53bf80e-goog


