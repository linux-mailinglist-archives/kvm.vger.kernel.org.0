Return-Path: <kvm+bounces-69495-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4AUPEJK3emkr9gEAu9opvQ
	(envelope-from <kvm+bounces-69495-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:27:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ADBF6AABBD
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:27:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 820383055032
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B575C3793C1;
	Thu, 29 Jan 2026 01:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VUa1+a90"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D640378D89
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649412; cv=none; b=LZqqSidkkUVnkjgV1ghUdmz0mAUutrodJHon2wYVqgchVCbT4Co6XVN4amUJeNCQdyNEI9AQmbHT7PyOmYu2TaqTKKhYKj9YdwoD6IA5p0Tup0Jza6tMhPOJVImdG6yH8m/2qXFrjX0PyPuab15J0N7bIC2pLjmCNTshx4PvpHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649412; c=relaxed/simple;
	bh=0iJukulF0iDMEL1IfL1RkxcCyzPuMdALrMtRBvNIXvg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hXOPHOKb3kAPIrYbWavqbiCyOmUEaRDo61YjUWIJQctyCuJnLi4XkrXKTsNJMoiDR7EGgGJuHmL7rq+m487xQcZe5CUJ25U9xCmw8dOuJfkaIaWZ2hHJeRsKMdtCACRJkLxszOcXbow56uM29og96cJ/aIf3BSGx8vbbir2oPHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VUa1+a90; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a7b7f04a11so10103425ad.3
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649410; x=1770254210; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=h+1tpJHrAZljj9M61rOSFv1VCgBL5A8paE4Q/bTQIJs=;
        b=VUa1+a903Fj7EnH257x8AzflrDL/v0e0gAM74zHv4y9goH13SSbhc/Bkbo6wPMUyiK
         OY+ep38XLw25X9LzK01V+ZT0r0daE580nEIKRU5v/wSatm9Dcl8umN5G2ZfLsF9h7yBl
         TViTaZSENQcrlCm5pvPFE9IjhSE41woYCZp+Etx7dh2pnO91vzWkhOVhNlRppva7xGOi
         x42ALQfW0itu05NfA6aFnj1htVA5ji0DF1woTMcR1m9e342HLu+R+zEvtG5nB9keZ+VX
         wDgEpfS3n/peBIf0d6IBmU8f/J0B5HKschUM+D0MT+e063G6w99PYPHnYOyIuJ2tee9x
         5joQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649410; x=1770254210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h+1tpJHrAZljj9M61rOSFv1VCgBL5A8paE4Q/bTQIJs=;
        b=hEFrpYdPOvA4MyXqQmXbYyy7GLJs4JjUYTfLDKLDWirfc1xTjFeBeUeaBHWAiZvf9q
         5zlNNZpn1eeZMnYaYJQPtNfmwYF6TVoVKAGPCwI4DSaba9Hr9B9kko7+lIXr5CyJWaZO
         NcU8VzsDAEZzatZVQET22vm9dP0Ohla9GP4Nh378OEOpvXeuvHqe1xYKAVskgta11oCO
         j9sHbNqfTotpwKZgR43X/7nlu79Limkj+pjyf8FGamfoJJFtJGZTl1PzFKt0CtmivoSK
         nAh7T+Zy15GIQn4/YJoDIVN88iuH9HEp/XBs4F1EBDa4JuJbjbThTtCs1DFffpsZGqUH
         STQg==
X-Forwarded-Encrypted: i=1; AJvYcCWF0WmtkTmkWGG/72JGSF6XkQWM6xJ2J2ll2PjzrOY5Z1S9y6HFFlOc048TyT3ZMuYwb94=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEsOEWtDELUCxMSK3tIQA1chRrfxIODGYz0dhOrdAsaVCBpFLc
	NL05nee7+qrkFi+v1ByNRZcaNmg2SAihG1+MjPPNxl+Dqfre52CIrSzlL8qapQWiH+NRlHRuFyc
	OKD39fQ==
X-Received: from pgbcu5.prod.google.com ([2002:a05:6a02:2185:b0:c0e:da74:78ee])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:918f:b0:34f:1623:2354
 with SMTP id adf61e73a8af0-38ec6421854mr6633861637.42.1769649410126; Wed, 28
 Jan 2026 17:16:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:16 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-45-seanjc@google.com>
Subject: [RFC PATCH v5 44/45] KVM: x86/mmu: Add support for splitting S-EPT
 hugepages on conversion
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69495-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: ADBF6AABBD
X-Rspamd-Action: no action

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
 arch/x86/include/asm/kvm_host.h |  8 +++-
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 72 +++++++++++++++++++++++++++++++--
 arch/x86/kvm/vmx/tdx.c          | 34 +++++++++++++---
 arch/x86/kvm/vmx/tdx.h          |  2 +
 5 files changed, 107 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 385f1cf32d70..54dea90a53dc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1563,6 +1563,12 @@ struct kvm_arch {
 	 * the code to do so.
 	 */
 	spinlock_t tdp_mmu_pages_lock;
+
+	/*
+	 * Protect the per-VM cache of pre-allocate pages used to populate the
+	 * Dynamic PAMT when splitting S-EPT huge pages without a vCPU.
+	 */
+	struct mutex tdp_mmu_external_cache_lock;
 #endif /* CONFIG_X86_64 */
 
 	/*
@@ -1861,7 +1867,7 @@ struct kvm_x86_ops {
 				 u64 new_spte, enum pg_level level);
 	void (*reclaim_external_sp)(struct kvm *kvm, gfn_t gfn,
 				    struct kvm_mmu_page *sp);
-	int (*topup_external_cache)(struct kvm_vcpu *vcpu, int min);
+	int (*topup_external_cache)(struct kvm *kvm, struct kvm_vcpu *vcpu, int min);
 
 
 	bool (*has_wbinvd_exit)(void);
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
index c46ebdacdb50..3181406c5e0b 100644
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
@@ -1631,9 +1632,74 @@ int kvm_tdp_mmu_split_huge_pages(struct kvm_vcpu *vcpu, gfn_t start, gfn_t end,
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_tdp_mmu_split_huge_pages);
 
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT
+static int __tdp_mmu_split_mirror_huge_pages(struct kvm *kvm,
+					     struct kvm_mmu_page *root,
+					     gfn_t gfn, int target_level)
+{
+	gfn_t end = gfn + KVM_PAGES_PER_HPAGE(target_level + 1);
+
+	return tdp_mmu_split_huge_pages_root(kvm, root, gfn, end, target_level, false);
+}
+
+static int tdp_mmu_split_mirror_huge_pages(struct kvm *kvm,
+					    struct kvm_mmu_page *root,
+					    gfn_t start, gfn_t end, int level)
+{
+
+	gfn_t head = gfn_round_for_level(start, level + 1);
+	gfn_t tail = gfn_round_for_level(end, level + 1);
+	int r;
+
+	if (head != start) {
+		r = __tdp_mmu_split_mirror_huge_pages(kvm, root, head, level);
+		if (r)
+			return r;
+	}
+
+	if (tail != end && (head != tail || head == start)) {
+		r = __tdp_mmu_split_mirror_huge_pages(kvm, root, tail, level);
+		if (r)
+			return r;
+	}
+
+	return 0;
+}
+
 int kvm_arch_gmem_convert(struct kvm *kvm, gfn_t start, gfn_t end,
 			  bool to_private)
 {
+	struct kvm_mmu_page *root;
+	int r;
+
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
+	guard(mutex)(&kvm->arch.tdp_mmu_external_cache_lock);
+
+	guard(write_lock)(&kvm->mmu_lock);
+
+	/*
+	 * TODO: Also split from PG_LEVEL_1G => PG_LEVEL_2M when KVM supports
+	 *       1GiB S-EPT pages.
+	 */
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, 0, KVM_MIRROR_ROOTS) {
+		r = tdp_mmu_split_mirror_huge_pages(kvm, root, start, end, PG_LEVEL_4K);
+		if (r)
+			return r;
+	}
 	return 0;
 }
 #endif /* CONFIG_HAVE_KVM_ARCH_GMEM_CONVERT */
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 098954f5e07c..774d395e5c73 100644
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
@@ -1621,15 +1625,32 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
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
+	lockdep_assert_held(&kvm->arch.tdp_mmu_external_cache_lock);
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
@@ -1792,8 +1813,8 @@ static struct page *tdx_spte_to_external_spt(struct kvm *kvm, gfn_t gfn,
 static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 				       u64 new_spte, enum pg_level level)
 {
-	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_pamt_cache *pamt_cache;
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
 	struct page *external_spt;
@@ -1804,7 +1825,8 @@ static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 	if (!external_spt)
 		return -EIO;
 
-	if (KVM_BUG_ON(!vcpu || vcpu->kvm != kvm, kvm))
+	pamt_cache = tdx_get_pamt_cache(kvm, kvm_get_running_vcpu());
+	if (!pamt_cache)
 		return -EIO;
 
 	err = tdh_do_no_vcpus(tdh_mem_range_block, kvm, &kvm_tdx->td, gpa,
@@ -1816,7 +1838,7 @@ static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 
 	err = tdh_do_no_vcpus(tdh_mem_page_demote, kvm, &kvm_tdx->td, gpa,
 			      level, spte_to_pfn(old_spte), external_spt,
-			      &to_tdx(vcpu)->pamt_cache, &entry, &level_state);
+			      pamt_cache, &entry, &level_state);
 	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_DEMOTE, entry, level_state, kvm))
 		return -EIO;
 
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index f444fc84d93b..57d7e70ffe7d 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -48,6 +48,8 @@ struct kvm_tdx {
 	 * Set/unset is protected with kvm->mmu_lock.
 	 */
 	bool wait_for_sept_zap;
+
+	struct tdx_pamt_cache pamt_cache;
 };
 
 /* TDX module vCPU states */
-- 
2.53.0.rc1.217.geba53bf80e-goog


