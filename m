Return-Path: <kvm+bounces-69475-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aHYlKVi3emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69475-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:26:48 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 12D94AAB82
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:26:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 05FD930740CF
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90CA834DB54;
	Thu, 29 Jan 2026 01:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2R9nd942"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B283733D6D6
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649378; cv=none; b=gXqtFBLUCMnOCJKn/cTDyjI9opslVwCZDYbJM1SRsuvEZo8yB6B0rdzeljbGVCOmB4XZkbB8Zr4Q9lRePu67sqRP0EOQ9A6X7CNIZ8TSh0NgvTe87Z7n1VXuJxWforvbOAv61BE4mMrzPs/yn4dKbw6am7ApFOAjwTtLoF//wgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649378; c=relaxed/simple;
	bh=MXp9XA/Uy7hh/qURkarvwWX9R8yNmxnCcj1ibUkwNqY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R3ZRWETtQQcbVDTaMgqhkUOAG+QpHX5Bz7KdCG0Pd/8OziEyBwOzJvUFBC2C9UHE5be+a9XDTSHlCTXHefjYmT6YBw64SyGopVmp2kqZL2YxIrN7Dcbs7pbmGVe1tpBdOAuMwEaO5lyjC2e6kIWgoZTLuTu8LvHGXlUO2wMrU9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2R9nd942; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a351686c17so3385695ad.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649376; x=1770254176; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=WBiU3c3o5EnYCzpzOQ+YM8lgZxAVBivBH7B1NpdVc/o=;
        b=2R9nd9426KsSkF7W/JaFUA5+r6NRTptWvVzI5O3VSAM5x8HGqYk1Ee53MzU4vu4/G9
         Z5VBRm70sKiI1/KELI85iAw45dKfSg+dVeWiuLQas3YQ7/wrirM56qrwyY2S6lnppH0Z
         azGEns2XYotea3ANj5gYujS8PYUKzABjpQJOwryxSjQCDLgk0T2WB7Aszwy9ewDMYD4+
         YNR1MrIl/OR94XEtff1Ba+AB7kUU6zNYNo+lQUqFv7wseeoFGRyZb4r8nGza2r84NlOi
         SHYe15N+iN3APR5p+CBke506oo+YbVwidILVVYXSa8VD1dyp1Hpg/pZ+Zvg+079+zJEV
         7CPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649376; x=1770254176;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WBiU3c3o5EnYCzpzOQ+YM8lgZxAVBivBH7B1NpdVc/o=;
        b=ftlamZFTAI/e/xPzuTD90hTtVyC7bqx1jZTULQednPr+C2rtfQT4cZPwgwCdDRWZ/L
         LQqvbIVE7oxOF6vSR5Nqp+76e1hx37N51jJnjNuX0+QXgPMeiMiCR5YQGSoXKiMZA1lA
         rlfFicqwUlhQUf2yjFxymFM/8NJUlXZMO2/GuWbdOV6slYj7OYUSUz0NJMXWv2GdGOyx
         4fMA0j5SgqsVWeAgSa38ec7ziC0hvxzbyYvNX23RSU3p9egXuIYYPohdsdDko43tKybv
         ojegw8bfSoc2H+RZ2NfFrNrZaO6yArVUqbfbUwtPsdrnZQdpigkDbk8qhqP6/nMzEdud
         TtKg==
X-Forwarded-Encrypted: i=1; AJvYcCWg06BKk1V0WOsZiBF0Q291blWQ1RmT00HxL5FdLybF0M5gBsfWs26O26Sx8bif5N8FQcM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrQgrb9dYeasV+uQBOxuHH5UyALnSr/PMvRs7G4oB/YhTt8bJ5
	hapLNHMPWQE/QWpyciRHnuL+t/2u1a/TmFw9thi/TacxXJm5/gl619a9wFkvRL+OdHx0Wxf2WbP
	EP/9ikg==
X-Received: from pjbkk8.prod.google.com ([2002:a17:90b:4a08:b0:34b:fe89:512c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2d20:b0:34f:ec81:bc3d
 with SMTP id adf61e73a8af0-38ec64225eemr6883378637.44.1769649375880; Wed, 28
 Jan 2026 17:16:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:57 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-26-seanjc@google.com>
Subject: [RFC PATCH v5 25/45] *** DO NOT MERGE *** x86/virt/tdx: Don't assume
 guest memory is backed by struct page
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69475-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 12D94AAB82
X-Rspamd-Action: no action

Remove the completely unnecessary assumptions that memory mapped into a
TDX guest is backed by refcounted struct page memory.  TDH_MEM_PAGE_ADD
and TDH_MEM_PAGE_AUG are glorified writes to PTEs, they have no business
placing requirements on how KVM and guest_memfd manage memory.

Rip out the misguided struct page assumptions/constraints before hugepage
support is added for S-EPT, e.g. so the kernel doesn't pick up even worse
assumptions like "a hugepage must be contained in a single folio".

TODO (before merge): Replace "u64 pfn" with something type-safe.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/tdx.h  | 25 ++++++---------
 arch/x86/kvm/vmx/tdx.c      | 33 ++++++++++---------
 arch/x86/virt/vmx/tdx/tdx.c | 63 +++++++++++++++++++------------------
 3 files changed, 59 insertions(+), 62 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 56bdfbce4289..1f57f7721286 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -154,10 +154,10 @@ static inline void tdx_init_pamt_cache(struct tdx_pamt_cache *cache)
 
 void tdx_free_pamt_cache(struct tdx_pamt_cache *cache);
 int tdx_topup_pamt_cache(struct tdx_pamt_cache *cache, unsigned long npages);
-int tdx_pamt_get(struct page *page, struct tdx_pamt_cache *cache);
-void tdx_pamt_put(struct page *page);
+int tdx_pamt_get(u64 pfn, struct tdx_pamt_cache *cache);
+void tdx_pamt_put(u64 pfn);
 
-void tdx_quirk_reset_page(struct page *page);
+void tdx_quirk_reset_page(u64 pfn);
 
 int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
@@ -206,23 +206,18 @@ struct tdx_vp {
 	struct page **tdcx_pages;
 };
 
-static inline u64 mk_keyed_paddr(u16 hkid, struct page *page)
+static inline u64 mk_keyed_paddr(u16 hkid, u64 pfn)
 {
-	u64 ret;
-
-	ret = page_to_phys(page);
-	/* KeyID bits are just above the physical address bits: */
-	ret |= (u64)hkid << boot_cpu_data.x86_phys_bits;
-
-	return ret;
+	/* KeyID bits are just above the physical address bits. */
+	return PFN_PHYS(pfn) | ((u64)hkid << boot_cpu_data.x86_phys_bits);
 }
 
 u64 tdh_vp_enter(struct tdx_vp *vp, struct tdx_module_args *args);
 u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
-u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page *source, u64 *ext_err1, u64 *ext_err2);
+u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, u64 pfn, struct page *source, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, enum pg_level level, struct page *page, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
-u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, enum pg_level level, struct page *page, u64 *ext_err1, u64 *ext_err2);
+u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, enum pg_level level, u64 pfn, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, enum pg_level level, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
@@ -237,12 +232,12 @@ u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data);
 u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
-u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
+u64 tdh_phymem_page_reclaim(u64 pfn, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
 u64 tdh_mem_track(struct tdx_td *tdr);
 u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, enum pg_level level, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
-u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
+u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, u64 pfn);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index d74a2547e512..4ac312376ac9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -318,11 +318,11 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
 })
 
 /* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
-static int __tdx_reclaim_page(struct page *page)
+static int __tdx_reclaim_page(kvm_pfn_t pfn)
 {
 	u64 err, rcx, rdx, r8;
 
-	err = tdh_phymem_page_reclaim(page, &rcx, &rdx, &r8);
+	err = tdh_phymem_page_reclaim(pfn, &rcx, &rdx, &r8);
 
 	/*
 	 * No need to check for TDX_OPERAND_BUSY; all TD pages are freed
@@ -337,11 +337,12 @@ static int __tdx_reclaim_page(struct page *page)
 
 static int tdx_reclaim_page(struct page *page)
 {
+	kvm_pfn_t pfn = page_to_pfn(page);
 	int r;
 
-	r = __tdx_reclaim_page(page);
+	r = __tdx_reclaim_page(pfn);
 	if (!r)
-		tdx_quirk_reset_page(page);
+		tdx_quirk_reset_page(pfn);
 	return r;
 }
 
@@ -583,7 +584,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 	if (!kvm_tdx->td.tdr_page)
 		return;
 
-	if (__tdx_reclaim_page(kvm_tdx->td.tdr_page))
+	if (__tdx_reclaim_page(page_to_pfn(kvm_tdx->td.tdr_page)))
 		return;
 
 	/*
@@ -595,7 +596,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 	if (TDX_BUG_ON(err, TDH_PHYMEM_PAGE_WBINVD, kvm))
 		return;
 
-	tdx_quirk_reset_page(kvm_tdx->td.tdr_page);
+	tdx_quirk_reset_page(page_to_pfn(kvm_tdx->td.tdr_page));
 
 	__tdx_free_control_page(kvm_tdx->td.tdr_page);
 	kvm_tdx->td.tdr_page = NULL;
@@ -1640,8 +1641,8 @@ static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 	    KVM_BUG_ON(!kvm_tdx->page_add_src, kvm))
 		return -EIO;
 
-	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
-			       kvm_tdx->page_add_src, &entry, &level_state);
+	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn, kvm_tdx->page_add_src,
+			       &entry, &level_state);
 	if (unlikely(IS_TDX_OPERAND_BUSY(err)))
 		return -EBUSY;
 
@@ -1655,12 +1656,11 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 			    enum pg_level level, kvm_pfn_t pfn)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	struct page *page = pfn_to_page(pfn);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 entry, level_state;
 	u64 err;
 
-	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, level, page, &entry, &level_state);
+	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, level, pfn, &entry, &level_state);
 	if (unlikely(IS_TDX_OPERAND_BUSY(err)))
 		return -EBUSY;
 
@@ -1712,7 +1712,6 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	kvm_pfn_t pfn = spte_to_pfn(mirror_spte);
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
-	struct page *page = pfn_to_page(pfn);
 	int ret;
 
 	if (KVM_BUG_ON(!vcpu, kvm))
@@ -1730,7 +1729,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	WARN_ON_ONCE((mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
 
-	ret = tdx_pamt_get(page, &tdx->pamt_cache);
+	ret = tdx_pamt_get(pfn, &tdx->pamt_cache);
 	if (ret)
 		return ret;
 
@@ -1752,7 +1751,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 		ret = tdx_mem_page_add(kvm, gfn, level, pfn);
 
 	if (ret)
-		tdx_pamt_put(page);
+		tdx_pamt_put(pfn);
 
 	return ret;
 }
@@ -1828,8 +1827,8 @@ static void tdx_sept_reclaim_private_sp(struct kvm *kvm, gfn_t gfn,
 static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 					 enum pg_level level, u64 mirror_spte)
 {
-	struct page *page = pfn_to_page(spte_to_pfn(mirror_spte));
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	kvm_pfn_t pfn = spte_to_pfn(mirror_spte);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
 
@@ -1868,12 +1867,12 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_REMOVE, entry, level_state, kvm))
 		return;
 
-	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
+	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, pfn);
 	if (TDX_BUG_ON(err, TDH_PHYMEM_PAGE_WBINVD, kvm))
 		return;
 
-	tdx_quirk_reset_page(page);
-	tdx_pamt_put(page);
+	tdx_quirk_reset_page(pfn);
+	tdx_pamt_put(pfn);
 }
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 90407493bb45..85c31ed9b9d1 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -799,9 +799,9 @@ static void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
 	mb();
 }
 
-void tdx_quirk_reset_page(struct page *page)
+void tdx_quirk_reset_page(u64 pfn)
 {
-	tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);
+	tdx_quirk_reset_paddr(PFN_PHYS(pfn), PAGE_SIZE);
 }
 EXPORT_SYMBOL_FOR_KVM(tdx_quirk_reset_page);
 
@@ -1665,6 +1665,11 @@ static void tdx_clflush_page(struct page *page)
 	clflush_cache_range(page_to_virt(page), PAGE_SIZE);
 }
 
+static void tdx_clflush_pfn(u64 pfn)
+{
+	clflush_cache_range(__va(PFN_PHYS(pfn)), PAGE_SIZE);
+}
+
 static int pg_level_to_tdx_sept_level(enum pg_level level)
 {
 	WARN_ON_ONCE(level == PG_LEVEL_NONE);
@@ -1691,17 +1696,17 @@ u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page)
 }
 EXPORT_SYMBOL_FOR_KVM(tdh_mng_addcx);
 
-u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page *source, u64 *ext_err1, u64 *ext_err2)
+u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, u64 pfn, struct page *source, u64 *ext_err1, u64 *ext_err2)
 {
 	struct tdx_module_args args = {
 		.rcx = gpa,
 		.rdx = tdx_tdr_pa(td),
-		.r8 = page_to_phys(page),
+		.r8 = PFN_PHYS(pfn),
 		.r9 = page_to_phys(source),
 	};
 	u64 ret;
 
-	tdx_clflush_page(page);
+	tdx_clflush_pfn(pfn);
 	ret = seamcall_ret(TDH_MEM_PAGE_ADD, &args);
 
 	*ext_err1 = args.rcx;
@@ -1743,17 +1748,17 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
 }
 EXPORT_SYMBOL_FOR_KVM(tdh_vp_addcx);
 
-u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, enum pg_level level,
-		     struct page *page, u64 *ext_err1, u64 *ext_err2)
+u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, enum pg_level level, u64 pfn,
+		     u64 *ext_err1, u64 *ext_err2)
 {
 	struct tdx_module_args args = {
 		.rcx = gpa | pg_level_to_tdx_sept_level(level),
 		.rdx = tdx_tdr_pa(td),
-		.r8 = page_to_phys(page),
+		.r8 = PFN_PHYS(pfn),
 	};
 	u64 ret;
 
-	tdx_clflush_page(page);
+	tdx_clflush_pfn(pfn);
 	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
 
 	*ext_err1 = args.rcx;
@@ -1997,10 +2002,10 @@ EXPORT_SYMBOL_FOR_KVM(tdh_vp_init);
  * So despite the names, they must be interpted specially as described by the spec. Return
  * them only for error reporting purposes.
  */
-u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size)
+u64 tdh_phymem_page_reclaim(u64 pfn, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size)
 {
 	struct tdx_module_args args = {
-		.rcx = page_to_phys(page),
+		.rcx = PFN_PHYS(pfn),
 	};
 	u64 ret;
 
@@ -2056,17 +2061,17 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
 {
 	struct tdx_module_args args = {};
 
-	args.rcx = mk_keyed_paddr(tdx_global_keyid, td->tdr_page);
+	args.rcx = mk_keyed_paddr(tdx_global_keyid, page_to_pfn(td->tdr_page));
 
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
 EXPORT_SYMBOL_FOR_KVM(tdh_phymem_page_wbinvd_tdr);
 
-u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
+u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, u64 pfn)
 {
 	struct tdx_module_args args = {};
 
-	args.rcx = mk_keyed_paddr(hkid, page);
+	args.rcx = mk_keyed_paddr(hkid, pfn);
 
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
@@ -2136,11 +2141,9 @@ static void free_pamt_array(u64 *pa_array)
  * Calculate the arg needed for operating on the DPAMT backing for
  * a given 4KB page.
  */
-static u64 pamt_2mb_arg(struct page *page)
+static u64 pamt_2mb_arg(u64 pfn)
 {
-	unsigned long hpa_2mb = ALIGN_DOWN(page_to_phys(page), PMD_SIZE);
-
-	return hpa_2mb | TDX_PS_2M;
+	return ALIGN_DOWN(PFN_PHYS(pfn), PMD_SIZE) | TDX_PS_2M;
 }
 
 /*
@@ -2149,10 +2152,10 @@ static u64 pamt_2mb_arg(struct page *page)
  * error. In the case of TDX module error, the return code is stored
  * in tdx_err.
  */
-static u64 tdh_phymem_pamt_add(struct page *page, u64 *pamt_pa_array)
+static u64 tdh_phymem_pamt_add(u64 pfn, u64 *pamt_pa_array)
 {
 	struct tdx_module_args args = {
-		.rcx = pamt_2mb_arg(page)
+		.rcx = pamt_2mb_arg(pfn)
 	};
 
 	dpamt_copy_to_regs(&args, rdx, pamt_pa_array);
@@ -2161,10 +2164,10 @@ static u64 tdh_phymem_pamt_add(struct page *page, u64 *pamt_pa_array)
 }
 
 /* Remove PAMT backing for the given page. */
-static u64 tdh_phymem_pamt_remove(struct page *page, u64 *pamt_pa_array)
+static u64 tdh_phymem_pamt_remove(u64 pfn, u64 *pamt_pa_array)
 {
 	struct tdx_module_args args = {
-		.rcx = pamt_2mb_arg(page),
+		.rcx = pamt_2mb_arg(pfn),
 	};
 	u64 ret;
 
@@ -2180,7 +2183,7 @@ static u64 tdh_phymem_pamt_remove(struct page *page, u64 *pamt_pa_array)
 static DEFINE_SPINLOCK(pamt_lock);
 
 /* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
-int tdx_pamt_get(struct page *page, struct tdx_pamt_cache *cache)
+int tdx_pamt_get(u64 pfn, struct tdx_pamt_cache *cache)
 {
 	u64 pamt_pa_array[MAX_NR_DPAMT_ARGS];
 	atomic_t *pamt_refcount;
@@ -2190,7 +2193,7 @@ int tdx_pamt_get(struct page *page, struct tdx_pamt_cache *cache)
 	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
 		return 0;
 
-	pamt_refcount = tdx_find_pamt_refcount(page_to_pfn(page));
+	pamt_refcount = tdx_find_pamt_refcount(pfn);
 
 	/*
 	 * If the pamt page is already added (i.e. refcount >= 1),
@@ -2214,7 +2217,7 @@ int tdx_pamt_get(struct page *page, struct tdx_pamt_cache *cache)
 		}
 
 		/* Try to add the pamt page and take the refcount 0->1. */
-		tdx_status = tdh_phymem_pamt_add(page, pamt_pa_array);
+		tdx_status = tdh_phymem_pamt_add(pfn, pamt_pa_array);
 		if (IS_TDX_SUCCESS(tdx_status)) {
 			/*
 			 * The refcount is zero, and this locked path is the only way to
@@ -2257,7 +2260,7 @@ EXPORT_SYMBOL_FOR_KVM(tdx_pamt_get);
  * Drop PAMT refcount for the given page and free PAMT memory if it is no
  * longer needed.
  */
-void tdx_pamt_put(struct page *page)
+void tdx_pamt_put(u64 pfn)
 {
 	u64 pamt_pa_array[MAX_NR_DPAMT_ARGS];
 	atomic_t *pamt_refcount;
@@ -2266,7 +2269,7 @@ void tdx_pamt_put(struct page *page)
 	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
 		return;
 
-	pamt_refcount = tdx_find_pamt_refcount(page_to_pfn(page));
+	pamt_refcount = tdx_find_pamt_refcount(pfn);
 
 	/*
 	 * If the there are more than 1 references on the pamt page,
@@ -2285,7 +2288,7 @@ void tdx_pamt_put(struct page *page)
 			return;
 
 		/* Try to remove the pamt page and take the refcount 1->0. */
-		tdx_status = tdh_phymem_pamt_remove(page, pamt_pa_array);
+		tdx_status = tdh_phymem_pamt_remove(pfn, pamt_pa_array);
 
 		/*
 		 * Don't free pamt_pa_array as it could hold garbage when
@@ -2357,7 +2360,7 @@ struct page *__tdx_alloc_control_page(gfp_t gfp)
 	if (!page)
 		return NULL;
 
-	if (tdx_pamt_get(page, NULL)) {
+	if (tdx_pamt_get(page_to_pfn(page), NULL)) {
 		__free_page(page);
 		return NULL;
 	}
@@ -2375,7 +2378,7 @@ void __tdx_free_control_page(struct page *page)
 	if (!page)
 		return;
 
-	tdx_pamt_put(page);
+	tdx_pamt_put(page_to_pfn(page));
 	__free_page(page);
 }
 EXPORT_SYMBOL_FOR_KVM(__tdx_free_control_page);
-- 
2.53.0.rc1.217.geba53bf80e-goog


