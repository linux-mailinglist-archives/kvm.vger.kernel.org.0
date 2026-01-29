Return-Path: <kvm+bounces-69470-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AGr/GBi2emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69470-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:21:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC817AAA14
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:21:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DCE0D30B191C
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:17:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9313346783;
	Thu, 29 Jan 2026 01:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="03AoZWhu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EE5325732
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649370; cv=none; b=VysO0YlQT2JZ03VMZ9+QG4zQ26faokya6WhfuMZZgIHZe0/ZBoi+u9aF7vFRJN813Eqp83R5CX8kZENYuIB4qP0uXYmu4QLFRT/Nyzi5pjoDnM5Dq5mmHQiXekYRol55zX1TJUUWmt4+VtGKXhg3M1Pqwmrp36advmYLIu1uUEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649370; c=relaxed/simple;
	bh=TBS3NOuTU/+p9r5oAffOOIjvCTELnp6C8dm3U+EJwg4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RHgp7+eHZtX5PkMgwKVxLfptI1G9MBLEXSDiwz/KwqgRd8gdsTja0jsCqHuYQhiLwdj25rX+1HXrAcg4jlW+P/v0yDQiYNQ/Il8FYNq8sgntcfMA2QOOPgEFq9zeV2cwNtUqRSy9FjLZxm9Q2zwrNgSDcUIOPItCbeSK0f9W02A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=03AoZWhu; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a784b2234dso11226145ad.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649367; x=1770254167; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8HnFAQrxQ92neYQA/fX8/fYTn2bGdwSiVHNlc5IdWqw=;
        b=03AoZWhuYRB0gFY+FBCitsqfcVgW10jhnpRK8GHP9Y9WUn75EaoT6q2+3viPq6MQwd
         q0FKavLqd8u4WAOY5jrPXOJK+U2K1qs2fpQGXXg+A1sOuCGFALsCmxHGpjPG1rKPtrGF
         iZPbdhZ6wwlOp+BEMuZvgGvbj41t2IoNqa2v6mwQl/LqAOpAYROxkRJS7rG36XHp4nI5
         ifjl13e6tuyF1Q3G6yhffzYFLmv6kw8YxTrG1C8y59ti06zmXFRHNBZryfeT2f652RYV
         +5LpvEXlPA2I97EKE/dM75pJFrGm9DW2taPuYm34j13t9tNeQaBgGdzJvlPoWlf2j0wr
         VLOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649367; x=1770254167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8HnFAQrxQ92neYQA/fX8/fYTn2bGdwSiVHNlc5IdWqw=;
        b=U/p6XeIMOBJoPMKn/eVRzkqvw0OTD/UPlSZ0Pz3SuGaMGsaOCiuwzUa/bXnUYDCUz/
         VMHnt1lxA8MjpLX9K+XoNCPRQgj7upl3AjwhUtPAfMriQccDsZ6KmAwwXihb70fSB4Po
         dNWyvbTh27VwDCGz2eJP1FMj5o7ftfojhnWUTYFvC3xqAKGYvrmyKdy6JP5tmo1xf5Qs
         LaX4CzpAq+6OwVYYiuJpVFYEK0VQCxhTDN/FtUaoSyjlDYqUICpGGx6KnEfofVDtFS0B
         wldIiaXKo5Y3IqZdrIF4jTFSvHWKPfDOFB3p0bOKsIozfvYBdmeVhQT126CNlLoZfVOg
         UCvA==
X-Forwarded-Encrypted: i=1; AJvYcCW238LgoyHYbUMGDd7tYDTx9zzd7/ey71j7eWcZ/RabLs09KNheWrsG8q7bhDJRT6ZF/is=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6pfpqoIw45/gqb+irzkITfVcUX3pDd7T/MHgixJTLBeM2oonJ
	CgjjKaOTKvHeEXCaYpyDhFGkPUeP6JyU96ts4JmL9B+s+U3tN0s+2CMX1aVrIhNais9l5/bXe3O
	7a319iQ==
X-Received: from pgo32.prod.google.com ([2002:a63:e60:0:b0:c65:be00:c5c9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6f09:b0:38e:9acd:97d0
 with SMTP id adf61e73a8af0-38ec632f1cbmr6748652637.34.1769649366694; Wed, 28
 Jan 2026 17:16:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:52 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-21-seanjc@google.com>
Subject: [RFC PATCH v5 20/45] KVM: x86/mmu: Allocate/free S-EPT pages using tdx_{alloc,free}_control_page()
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
	TAGGED_FROM(0.00)[bounces-69470-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,intel.com:email];
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
X-Rspamd-Queue-Id: CC817AAA14
X-Rspamd-Action: no action

Now that kvm_mmu_memory_cache supports custom page allocators, wire up the
S-EPT cache to use tdx_{alloc,free}_control_page() (arguably S-EPT pages
aren't "control" pages, but they're not guest pages either).  Using the
TDX APIs will make S-EPT pages naturally play nice with Dynamic PAMT, by
virtue of adding/removing PAMT entries when S-EPT pages are allocated and
freed, as opposed to when they are added/removed from the S-EPT tree.

Inserting into the PAMT entries on allocation does mean KVM will create
unnecessary PAMT entries, e.g. once a vCPU stops faulting in memory, the
remaining pages in the MMU cache will go unused.  But in practice, odds
are very good the containing 2MiB page will have other in-use S-EPT pages,
i.e. will create PAMT entries anyways.  And _if_ creating PAMT entries on
allocation is problematic for memory consumption, that can be resolved by
tweaking KVM's cache size.

Suggested-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  2 ++
 arch/x86/include/asm/kvm_host.h    | 18 +++++++++---------
 arch/x86/kvm/mmu/mmu.c             |  6 ++++--
 arch/x86/kvm/mmu/mmu_internal.h    | 11 -----------
 arch/x86/kvm/mmu/tdp_mmu.c         |  5 +++--
 arch/x86/kvm/vmx/tdx.c             | 13 ++++++++++++-
 6 files changed, 30 insertions(+), 25 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index c17cedc485c9..17dddada69fc 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -94,6 +94,8 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
 KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
 KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
 KVM_X86_OP(load_mmu_pgd)
+KVM_X86_OP_OPTIONAL(alloc_external_sp)
+KVM_X86_OP_OPTIONAL(free_external_sp)
 KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
 KVM_X86_OP_OPTIONAL(remove_external_spte)
 KVM_X86_OP_OPTIONAL(reclaim_external_sp)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b35a07ed11fb..6e84dbc89e79 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -867,10 +867,7 @@ struct kvm_vcpu_arch {
 	struct kvm_mmu_memory_cache mmu_shadow_page_cache;
 	struct kvm_mmu_memory_cache mmu_shadowed_info_cache;
 	struct kvm_mmu_memory_cache mmu_page_header_cache;
-	/*
-	 * This cache is to allocate external page table. E.g. private EPT used
-	 * by the TDX module.
-	 */
+	/* Used to allocate S-EPT pages (gifted to the TDX-Module). */
 	struct kvm_mmu_memory_cache mmu_external_spt_cache;
 
 	/*
@@ -1853,18 +1850,21 @@ struct kvm_x86_ops {
 	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			     int root_level);
 
-	/* Update the external page table from spte getting set. */
+	/*
+	 * Callbacks to allocate and free external page tables, a.k.a. S-EPT,
+	 * and to propagate changes in mirror page tables to the external page
+	 * tables.
+	 */
+	unsigned long (*alloc_external_sp)(gfp_t gfp);
+	void (*free_external_sp)(unsigned long addr);
 	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				 u64 mirror_spte);
-
-	/* Update external page tables for page table about to be freed. */
 	void (*reclaim_external_sp)(struct kvm *kvm, gfn_t gfn,
 				    struct kvm_mmu_page *sp);
-
-	/* Update external page table from spte getting removed, and flush TLB. */
 	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				     u64 mirror_spte);
 
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3911ac9bddfd..9b5a6861e2a4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6690,11 +6690,13 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
 	vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
 
-	vcpu->arch.mmu_shadow_page_cache.init_value =
-		SHADOW_NONPRESENT_VALUE;
+	vcpu->arch.mmu_shadow_page_cache.init_value = SHADOW_NONPRESENT_VALUE;
 	if (!vcpu->arch.mmu_shadow_page_cache.init_value)
 		vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
 
+	vcpu->arch.mmu_external_spt_cache.page_get = kvm_x86_ops.alloc_external_sp;
+	vcpu->arch.mmu_external_spt_cache.page_free = kvm_x86_ops.free_external_sp;
+
 	vcpu->arch.mmu = &vcpu->arch.root_mmu;
 	vcpu->arch.walk_mmu = &vcpu->arch.root_mmu;
 
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 73cdcbccc89e..6bb97f660793 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -157,17 +157,6 @@ static inline bool is_mirror_sp(const struct kvm_mmu_page *sp)
 	return sp->role.is_mirror;
 }
 
-static inline void kvm_mmu_alloc_external_spt(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
-{
-	/*
-	 * external_spt is allocated for TDX module to hold private EPT mappings,
-	 * TDX module will initialize the page by itself.
-	 * Therefore, KVM does not need to initialize or access external_spt.
-	 * KVM only interacts with sp->spt for private EPT operations.
-	 */
-	sp->external_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_external_spt_cache);
-}
-
 static inline gfn_t kvm_gfn_root_bits(const struct kvm *kvm, const struct kvm_mmu_page *root)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 18764dbc97ea..01e3e4f4baa5 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -55,7 +55,8 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
-	free_page((unsigned long)sp->external_spt);
+	if (sp->external_spt)
+		kvm_x86_call(free_external_sp)((unsigned long)sp->external_spt);
 	free_page((unsigned long)sp->spt);
 	kmem_cache_free(mmu_page_header_cache, sp);
 }
@@ -1246,7 +1247,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 		sp = tdp_mmu_alloc_sp(vcpu);
 		tdp_mmu_init_child_sp(sp, &iter);
 		if (is_mirror_sp(sp))
-			kvm_mmu_alloc_external_spt(vcpu, sp);
+			sp->external_spt = kvm_mmu_memory_cache_alloc(&vcpu->arch.mmu_external_spt_cache);
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 323aae4300a1..0946eba2de23 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1790,7 +1790,9 @@ static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
 	 * TD's hkid is freed, when the TD is being torn down.
 	 *
 	 * If the S-EPT PTE can't be removed for any reason, intentionally leak
-	 * the page to prevent the kernel from accessing the encrypted page.
+	 * the page to prevent the kernel from accessing the encrypted page,
+	 * and if Dynamic PAMT is enabled, to avoid inducing a failure on
+	 * removal of the still-used PAMT entry.
 	 */
 	if (KVM_BUG_ON(is_hkid_assigned(to_kvm_tdx(kvm)), kvm) ||
 	    tdx_reclaim_page(virt_to_page(sp->external_spt)))
@@ -3600,6 +3602,15 @@ void __init tdx_hardware_setup(void)
 	 */
 	vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size, sizeof(struct kvm_tdx));
 
+	/*
+	 * TDX uses the external_spt cache to allocate S-EPT page table pages,
+	 * which (a) don't need to be initialized by KVM as the TDX-Module will
+	 * initialize the page (using the guest's encryption key), and (b) need
+	 * to use a custom allocator to be compatible with Dynamic PAMT.
+	 */
+	vt_x86_ops.alloc_external_sp = tdx_alloc_control_page;
+	vt_x86_ops.free_external_sp = tdx_free_control_page;
+
 	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
 	vt_x86_ops.reclaim_external_sp = tdx_sept_reclaim_private_sp;
 	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
-- 
2.53.0.rc1.217.geba53bf80e-goog


