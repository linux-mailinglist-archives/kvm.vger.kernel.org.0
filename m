Return-Path: <kvm+bounces-69560-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cJWpCpN/e2kQFAIAu9opvQ
	(envelope-from <kvm+bounces-69560-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:41:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 84D5DB1967
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 16:41:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BA783302351A
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 15:39:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7245B330D29;
	Thu, 29 Jan 2026 15:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Od8vCXXv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25911E32CF
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 15:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769701171; cv=none; b=LItItK2LcX4Zngh6V/w6NqUUUiDKc7MoRvWiknHDlP2hJk8my+/WrRA9HjNEWEbxM7vHaEalt7Yz+FYNyFB1MeekuuXNgRr5epoTCMyohLbqd5spOpri6FWm03OhIM3xqCaspPU7qCKl4modU3O4tFSBJHl/fg2BnIdftTOYIJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769701171; c=relaxed/simple;
	bh=5CSw8Z8uKnx+wwLGWPU7IzUKdgUP9oPiOxjrsFm1mOU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=hKJ+QIrPkdYDN5KgoMmZ+fx17Hscq0tn5/T7cvwFlEPR0i8xnDBc9TCjtXh169+O5FaY/8ZZgg5mZcpqm/YqTPBBoqSwvI6K48dGGBnUPLU2n1E1W/8D7hHIrDO/wxRR9Fb+EkH/eNsPbTRhqoI1B0arAkfWUYY76YP7aZtBEkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Od8vCXXv; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a0bb1192cbso9593785ad.1
        for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 07:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769701169; x=1770305969; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yGhht+/DoV3CAeeVj+EgdI4sTUNvMsYLCfS4ZJ8M+Do=;
        b=Od8vCXXvSS/5xMD0hv5sn0eehdiHgTFI/N1fSWUPbGJWKD4M+cxeZ+ZSzOXB8ywKjy
         V97ZiSPhnYM8en2CStCcSGKnDYmuVoV6OT4fpiyvWGk4cCt/fo5WHMrQ2HI6AhntauIM
         jIfI5baGjPCrC+tjiZUCZopaUc4NLMF5CcUJQit8P3KwSvKnXpD76CSnns9PG6wYRYsV
         IEUz0puowwbMM6K4kdy7eC7EZasbfPPvehc/mrTwa3pViEpRDFEFyj3QctwTdwr8p6i1
         4nTMUMhlyUVJ+25hL3yZQ1K0n7ZDd1S8QgrE1U1schh2H3w98rv/NH2IpMtrLNrpR/jt
         IYfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769701169; x=1770305969;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yGhht+/DoV3CAeeVj+EgdI4sTUNvMsYLCfS4ZJ8M+Do=;
        b=fv8SWp9bsab7fo+E9aRh8wD3o2lk+/EjiM1vwn2ayhkh+adYxkPvFiaZZq5RusuFpY
         EDJ6ekWZfChXVo/FKgNbuIJeh8BiHSFOYjW3KjaqDlgMVPiEkekdTFhV8xZ65rfLRNBs
         HTaAi1xh09oRqIPNhSedcIQh7g047xd1F1uT08vdfCqj8kWB+Uk0JiJ509lIpFRp0o7K
         6SuFJdVnjzd+Xr8nD8JUyZODBibhZdkUNks3XxtRq1xHvOPgvfvLGXdmziQyF+1U3OlD
         QvOfOHLVN9UniDbZajSm05i6hTpUaQD/LbCkOtMnSlX04hP7KLkCVeCloVjq6PZM357D
         MCTw==
X-Forwarded-Encrypted: i=1; AJvYcCWDWJjl/1gXjqlfgIhltp2GlbCPZ1yXx+Mg/NAoInQVehbVj0H4jmNGlwerjFJHf9EliLU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFNDshQKocO97yeN3RfJQageV+atat6Jk2UktY1g05BPbsTbun
	SiORGaPzORvIp/G6DJrwwEinYv84Yy9ao/TYBZk4dSMuNX5MVnOR/1rb1X2/kiVaV7DoBS9dP0B
	XdrHkGA==
X-Received: from pljc7.prod.google.com ([2002:a17:903:3b87:b0:297:d4ca:8805])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d4c8:b0:2a7:77ce:d75d
 with SMTP id d9443c01a7336-2a870e2c1abmr93139365ad.61.1769701169190; Thu, 29
 Jan 2026 07:39:29 -0800 (PST)
Date: Thu, 29 Jan 2026 07:39:27 -0800
In-Reply-To: <20260129011517.3545883-45-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com> <20260129011517.3545883-45-seanjc@google.com>
Message-ID: <aXt_L6QKB9CSTZcW@google.com>
Subject: Re: [RFC PATCH v5 44/45] KVM: x86/mmu: Add support for splitting
 S-EPT hugepages on conversion
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Sagi Shahar <sagis@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69560-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 84D5DB1967
X-Rspamd-Action: no action

On Wed, Jan 28, 2026, Sean Christopherson wrote:
>  #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
> +static int __tdp_mmu_split_mirror_huge_pages(struct kvm *kvm,
> +					     struct kvm_mmu_page *root,
> +					     gfn_t gfn, int target_level)
> +{
> +	gfn_t end = gfn + KVM_PAGES_PER_HPAGE(target_level + 1);
> +
> +	return tdp_mmu_split_huge_pages_root(kvm, root, gfn, end, target_level, false);
> +}
> +
> +static int tdp_mmu_split_mirror_huge_pages(struct kvm *kvm,
> +					    struct kvm_mmu_page *root,
> +					    gfn_t start, gfn_t end, int level)
> +{
> +
> +	gfn_t head = gfn_round_for_level(start, level + 1);
> +	gfn_t tail = gfn_round_for_level(end, level + 1);
> +	int r;
> +
> +	if (head != start) {
> +		r = __tdp_mmu_split_mirror_huge_pages(kvm, root, head, level);
> +		if (r)
> +			return r;
> +	}
> +
> +	if (tail != end && (head != tail || head == start)) {
> +		r = __tdp_mmu_split_mirror_huge_pages(kvm, root, tail, level);
> +		if (r)
> +			return r;
> +	}
> +
> +	return 0;
> +}
> +
>  int kvm_arch_gmem_convert(struct kvm *kvm, gfn_t start, gfn_t end,
>  			  bool to_private)
>  {
> +	struct kvm_mmu_page *root;
> +	int r;
> +
> +	/*
> +	 * When converting from private=>shared, KVM must first split potential
> +	 * hugepages, as KVM mustn't overzap private mappings for TDX guests,
> +	 * i.e. must zap _exactly_ [start, end).  Split potential hugepages at
> +	 * the head and tail of the to-be-converted (and thus zapped) range so
> +	 * that KVM doesn't overzap due to dropping a hugepage that doesn't
> +	 * fall wholly inside the range.
> +	 */
> +	if (to_private || !kvm_has_mirrored_tdp(kvm))
> +		return 0;
> +
> +	/*
> +	 * Acquire the external cache lock, a.k.a. the Dynamic PAMT lock, to
> +	 * protect the per-VM cache of pre-allocate pages used to populate the
> +	 * Dynamic PAMT when splitting S-EPT huge pages.
> +	 */
> +	guard(mutex)(&kvm->arch.tdp_mmu_external_cache_lock);
> +
> +	guard(write_lock)(&kvm->mmu_lock);
> +
> +	/*
> +	 * TODO: Also split from PG_LEVEL_1G => PG_LEVEL_2M when KVM supports
> +	 *       1GiB S-EPT pages.
> +	 */
> +	__for_each_tdp_mmu_root_yield_safe(kvm, root, 0, KVM_MIRROR_ROOTS) {
> +		r = tdp_mmu_split_mirror_huge_pages(kvm, root, start, end, PG_LEVEL_4K);
> +		if (r)

This needs to call kvm_tdp_mmu_put_root() on failure.  But if we instead add
kvm_tdp_mmu_mirrors_split_huge_pages() for use in handling mismatched ACCEPT,
this code goes away.

And then the bulk of this code can live in tdx.c instead of tdp_mmu.c, and the
pamt mutex can live in kvm_tdx instead of kvm_arch.

Compile tested only...

---
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 Jan 2026 07:36:47 -0800
Subject: [PATCH] KVM: x86/mmu: Add support for splitting S-EPT hugepages on
 conversion

Add support for splitting S-EPT hugepages in preparation for converting a
subset of a hugepage to be shared, as KVM must precisely zap/remove S-EPT
entries to avoid clobbering guest memory (the lifetime of guest private
memory is tied to the S-EPT).  I.e. KVM needs to first split a hugepage so
that only the to-be-converted small pages can be zapped.

To avoid unnecessary work, e.g. if only the tail/end page of massive region
isn't aligned to the conversion, explicitly detect unaligned head and tail
pages relative to the max page size support by KVM, i.e. head/tail pages
that will undergo partial conversion.

To support splitting an S-EPT hugepage without a vCPU, add a per-VM PAMT
cache, along with a mutex to guard the cache.  Using a mutex, e.g. versus
a spinlock, is important at it allows KVM to allocate memory *without*
dropping the lock, i.e. so that the PAMT cache can be topped-up as needed
without needed to juggle arch.tdp_mmu_external_cache_lock.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  3 +-
 arch/x86/kvm/mmu/mmu.c             |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c         |  7 ++-
 arch/x86/kvm/vmx/tdx.c             | 96 ++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.h             |  3 +
 arch/x86/kvm/x86.c                 |  2 +-
 7 files changed, 102 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 3ca56fe6b951..6083fb07cd3b 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -149,6 +149,7 @@ KVM_X86_OP_OPTIONAL(alloc_apic_backing_page)
 KVM_X86_OP_OPTIONAL_RET0(gmem_prepare)
 KVM_X86_OP_OPTIONAL_RET0(gmem_max_mapping_level)
 KVM_X86_OP_OPTIONAL(gmem_invalidate)
+KVM_X86_OP_OPTIONAL_RET0(gmem_convert)
 
 #undef KVM_X86_OP
 #undef KVM_X86_OP_OPTIONAL
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 385f1cf32d70..cd3e7dc6ab9b 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1861,7 +1861,7 @@ struct kvm_x86_ops {
 				 u64 new_spte, enum pg_level level);
 	void (*reclaim_external_sp)(struct kvm *kvm, gfn_t gfn,
 				    struct kvm_mmu_page *sp);
-	int (*topup_external_cache)(struct kvm_vcpu *vcpu, int min);
+	int (*topup_external_cache)(struct kvm *kvm, struct kvm_vcpu *vcpu, int min);
 
 
 	bool (*has_wbinvd_exit)(void);
@@ -1950,6 +1950,7 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
+	int (*gmem_convert)(struct kvm *kvm, gfn_t start, gfn_t end, bool to_private);
 	int (*gmem_max_mapping_level)(struct kvm *kvm, kvm_pfn_t pfn, bool is_private);
 };
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c2765bfc8492..62bf6bec2df2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -606,7 +606,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 		if (r)
 			return r;
 
-		r = kvm_x86_call(topup_external_cache)(vcpu, PT64_ROOT_MAX_LEVEL);
+		r = kvm_x86_call(topup_external_cache)(vcpu->kvm, vcpu, PT64_ROOT_MAX_LEVEL);
 		if (r)
 			return r;
 	}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index a45d8ee91481..a32192c35099 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1447,7 +1447,8 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct tdp_iter *iter)
+static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
+						       struct tdp_iter *iter)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1464,7 +1465,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct tdp_iter *iter)
 		if (!sp->external_spt)
 			goto err_external_spt;
 
-		if (kvm_x86_call(topup_external_cache)(kvm_get_running_vcpu(), 1))
+		if (kvm_x86_call(topup_external_cache)(kvm, kvm_get_running_vcpu(), 1))
 			goto err_external_split;
 	}
 
@@ -1556,7 +1557,7 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 			else
 				write_unlock(&kvm->mmu_lock);
 
-			sp = tdp_mmu_alloc_sp_for_split(&iter);
+			sp = tdp_mmu_alloc_sp_for_split(kvm, &iter);
 
 			if (shared)
 				read_lock(&kvm->mmu_lock);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 9f2ef46f87b0..c4050d94fb4d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -607,6 +607,8 @@ void tdx_vm_destroy(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 
+	tdx_free_pamt_cache(&kvm_tdx->pamt_cache);
+
 	tdx_reclaim_td_control_pages(kvm);
 
 	kvm_tdx->state = TD_STATE_UNINITIALIZED;
@@ -629,6 +631,8 @@ int tdx_vm_init(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 
+	tdx_init_pamt_cache(&kvm_tdx->pamt_cache);
+
 	kvm->arch.has_protected_state = true;
 	/*
 	 * TDX Module doesn't allow the hypervisor to modify the EOI-bitmap,
@@ -1285,6 +1289,66 @@ static int tdx_map_gpa(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int __tdx_sept_split_huge_pages(struct kvm *kvm, gfn_t gfn, int target_level)
+{
+	gfn_t end = gfn + KVM_PAGES_PER_HPAGE(target_level + 1);
+
+	return kvm_tdp_mmu_mirrors_split_huge_pages(kvm, gfn, end, target_level);
+}
+
+static int tdx_sept_split_huge_pages(struct kvm *kvm, gfn_t start, gfn_t end,
+				     int target_level)
+{
+
+	gfn_t head = gfn_round_for_level(start, target_level + 1);
+	gfn_t tail = gfn_round_for_level(end, target_level + 1);
+	int r;
+
+	if (head != start) {
+		r = __tdx_sept_split_huge_pages(kvm, head, target_level);
+		if (r)
+			return r;
+	}
+
+	if (tail != end && (head != tail || head == start)) {
+		r = __tdx_sept_split_huge_pages(kvm, tail, target_level);
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
+static int tdx_gmem_convert(struct kvm *kvm, gfn_t start, gfn_t end,
+			    bool to_private)
+{
+	/*
+	 * When converting from private=>shared, KVM must first split potential
+	 * hugepages, as KVM mustn't overzap private mappings for TDX guests,
+	 * i.e. must zap _exactly_ [start, end).  Split potential hugepages at
+	 * the head and tail of the to-be-converted (and thus zapped) range so
+	 * that KVM doesn't overzap due to dropping a hugepage that doesn't
+	 * fall wholly inside the range.
+	 */
+	if (to_private || !kvm_has_mirrored_tdp(kvm))
+		return 0;
+
+	/*
+	 * Acquire the external cache lock, a.k.a. the Dynamic PAMT lock, to
+	 * protect the per-VM cache of pre-allocate pages used to populate the
+	 * Dynamic PAMT when splitting S-EPT huge pages.
+	 */
+	guard(mutex)(&to_kvm_tdx(kvm)->pamt_cache_lock);
+
+	guard(write_lock)(&kvm->mmu_lock);
+
+	/*
+	 * TODO: Also split from PG_LEVEL_1G => PG_LEVEL_2M when KVM supports
+	 *       1GiB S-EPT pages.
+	 */
+	return tdx_sept_split_huge_pages(kvm, start, end, PG_LEVEL_4K);
+}
+
 static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -1621,15 +1685,32 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
 }
 
-static int tdx_topup_external_pamt_cache(struct kvm_vcpu *vcpu, int min)
+static struct tdx_pamt_cache *tdx_get_pamt_cache(struct kvm *kvm,
+						 struct kvm_vcpu *vcpu)
 {
+	if (KVM_BUG_ON(vcpu && vcpu->kvm != kvm, kvm))
+		return NULL;
+
+	if (vcpu)
+		return &to_tdx(vcpu)->pamt_cache;
+
+	lockdep_assert_held(&to_kvm_tdx(kvm)->pamt_cache_lock);
+	return &to_kvm_tdx(kvm)->pamt_cache;
+}
+
+static int tdx_topup_external_pamt_cache(struct kvm *kvm,
+					 struct kvm_vcpu *vcpu, int min)
+{
+	struct tdx_pamt_cache *pamt_cache;
+
 	if (!tdx_supports_dynamic_pamt(tdx_sysinfo))
 		return 0;
 
-	if (WARN_ON_ONCE(!vcpu))
+	pamt_cache = tdx_get_pamt_cache(kvm, vcpu);
+	if (!pamt_cache)
 		return -EIO;
 
-	return tdx_topup_pamt_cache(&to_tdx(vcpu)->pamt_cache, min);
+	return tdx_topup_pamt_cache(pamt_cache, min);
 }
 
 static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
@@ -1792,8 +1873,8 @@ static struct page *tdx_spte_to_external_spt(struct kvm *kvm, gfn_t gfn,
 static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 				       u64 new_spte, enum pg_level level)
 {
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_pamt_cache *pamt_cache;
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
 	struct page *external_spt;
@@ -1804,7 +1885,8 @@ static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 	if (!external_spt)
 		return -EIO;
 
-	if (KVM_BUG_ON(!vcpu || vcpu->kvm != kvm, kvm))
+	pamt_cache = tdx_get_pamt_cache(kvm, kvm_get_running_vcpu());
+	if (!pamt_cache)
 		return -EIO;
 
 	err = tdh_do_no_vcpus(tdh_mem_range_block, kvm, &kvm_tdx->td, gpa,
@@ -1816,7 +1898,7 @@ static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 
 	err = tdh_do_no_vcpus(tdh_mem_page_demote, kvm, &kvm_tdx->td, gpa,
 			      level, spte_to_pfn(old_spte), external_spt,
-			      &to_tdx(vcpu)->pamt_cache, &entry, &level_state);
+			      pamt_cache, &entry, &level_state);
 	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_DEMOTE, entry, level_state, kvm))
 		return -EIO;
 
@@ -3776,6 +3858,8 @@ void __init tdx_hardware_setup(void)
 	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
 	vt_x86_ops.reclaim_external_sp = tdx_sept_reclaim_private_sp;
 
+	vt_x86_ops.gmem_convert = tdx_gmem_convert;
+
 	/*
 	 * FIXME: Wire up the PAMT hook iff DPAMT is supported, once VMXON is
 	 *        moved out of KVM and tdx_bringup() is folded into here.
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index f444fc84d93b..2bb4604a64ca 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -48,6 +48,9 @@ struct kvm_tdx {
 	 * Set/unset is protected with kvm->mmu_lock.
 	 */
 	bool wait_for_sept_zap;
+
+	struct tdx_pamt_cache pamt_cache;
+	struct mutex pamt_cache_lock;
 };
 
 /* TDX module vCPU states */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c80cc60e7862..c3d71ba9a1dc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14061,7 +14061,7 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 int kvm_arch_gmem_convert(struct kvm *kvm, gfn_t start, gfn_t end,
 			  bool to_private)
 {
-       return 0;
+       return kvm_x86_call(gmem_convert)(kvm, start, end, to_private);
 }
 #endif
 #endif

base-commit: b2791d61e9774d8575525816e864d2e09ee9090a
--

