Return-Path: <kvm+bounces-69483-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cMESGxC2emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69483-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:21:20 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 270C6AAA05
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:21:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6FCCF302BEB6
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:19:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3F2236A009;
	Thu, 29 Jan 2026 01:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hgqCWAGB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C51364EA9
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649390; cv=none; b=MJ0l6JgAudrmVRsSoWD//YiciR21dmvUUgD41pQBuR7Hhjlnf6RtyNBFNiheICtRacdeC4QlVI/3ZTYFJp72V4jS3grcK/0xfMG6gXdioL0jkTNERsyfJpDatPWCkDNT7ycsp8xxBgT53IxstjJd35NMvrOIrIP9s1/1n3wW1OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649390; c=relaxed/simple;
	bh=ZKA4gxILOiT4uKjve2aBLdSG8+EEE+GNTcKmwrKf7To=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LntJah/oAkjyla0P3N0Eu6oVxguh7giOdPsEKTVCnmF/gb0C8ajCzWeCWOwzKycgaDLDOKkMxPZYk+O1lVITNTU/Ti2zAWzv3QiO5rT1r+0yK4FXflK7ii89yww356KxswR7PZQzlW8gu41YSwI9ub3E9hhIaReYuWls7pAOGp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hgqCWAGB; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-34e70e2e363so375384a91.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649388; x=1770254188; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=jjjDLQ+c4+Lcjknb+8jLsLWn/cseIOYcFr4v4eW8m5k=;
        b=hgqCWAGBoHQRtHlm3K3k4oVqB/Q+7jCPcLeHglUbNCia3HLJCxBlpgdaHI+a3nDtWT
         rwKjfCvk4/L818DaCzIyGDUk0/+OZM2l2wqRFVrI+TH6MLGncAKOvFN5i6AsWnLyYJOY
         haXn+z+Pma74CW+RuVNNHF7yiLHl2R2u4DAfaggIPU/EIEL5u7YwlFjSzhTFRvtfkeFt
         azmNhNfJaTxSfo4CLRjFucPdMzG3dtZBGS7idKe/wWRkXp+os1gqjmrJqCDhJoNtDDoX
         cVwS0oMuAlnr64sFWNfw9DkDcMS8rhiIy8J80Hs2NY9zMIxaxyQ/sQdvHerbAAFRVe9Z
         TG6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649388; x=1770254188;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jjjDLQ+c4+Lcjknb+8jLsLWn/cseIOYcFr4v4eW8m5k=;
        b=g5vJrVLTvKvYs85kndWAeFAeoEdKJ6/ReRP1h70vmupqD16Zz/89kaMy4VOL+uIP80
         HdYSLEPIHDjE3Mzt0ZwLfgh9Kcyvv+BAivijXm2Z3Zbjk2WDSCaLNtN8GEI6+UGY+PPD
         jbTbaKM/kb+cQ0E/YaIi0ftWnppgMYp2sfkYh25U3inRyZDtkb/FPMLdrhtouypqrdMW
         m8PL/jLNPymCIx4CdgDlSfyZMWbTZjw0EJvq7N3MujEGSROzRJ8arbnpk7J3DpSKayN5
         jlhkAfX49mOn7bfB1N2CjKNNs9IG6ZUbz1y/rIctD/Vsrvmlzmu6JimPh3cbQj81kdlt
         metg==
X-Forwarded-Encrypted: i=1; AJvYcCUJFsl3cgfMbpSLVWQB0THF3UZYajyEMkQaiiOJ91bc5px7rw307yJk08etcBl8M+5zyK8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzCT8WJJlBgk7nbs0tZkY1/kqivM4ofHX+fiuG3O4nSAxheNwp5
	thcn4cbcu1VDY4yczp6VLekD5UQSvdEKnO35VZRLNm+E+ydFzQPf0rzQ+2aEtPt7WgwgZtplekc
	KP4mNBw==
X-Received: from pjboj17.prod.google.com ([2002:a17:90b:4d91:b0:34c:2f52:23aa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2888:b0:343:c3d1:8bb1
 with SMTP id 98e67ed59e1d1-353fed9b231mr5381792a91.28.1769649388060; Wed, 28
 Jan 2026 17:16:28 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:15:04 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-33-seanjc@google.com>
Subject: [RFC PATCH v5 32/45] KVM: x86/mmu: Plumb the old_spte into kvm_x86_ops.set_external_spte()
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69483-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 270C6AAA05
X-Rspamd-Action: no action

Plumb the old SPTE into .set_external_spte() so that the callback can be
used to handle removal and splitting of leaf SPTEs.  Rename mirror_spte to
new_spte to follow the TDP MMU's naming, and to make it more obvious what
value the parameter holds.

Opportunistically tweak the ordering of parameters to match the pattern of
most TDP MMU functions, which do "old, new, level".

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  4 ++--
 arch/x86/kvm/mmu/tdp_mmu.c      |  4 ++--
 arch/x86/kvm/vmx/tdx.c          | 14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a6e4ab76b1b2..67deec8e205e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1857,8 +1857,8 @@ struct kvm_x86_ops {
 	 */
 	unsigned long (*alloc_external_sp)(gfp_t gfp);
 	void (*free_external_sp)(unsigned long addr);
-	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				 u64 mirror_spte);
+	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, u64 old_spte,
+				 u64 new_spte, enum pg_level level);
 	void (*reclaim_external_sp)(struct kvm *kvm, gfn_t gfn,
 				    struct kvm_mmu_page *sp);
 	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index f8ebdd0c6114..271dd6f875a6 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -614,8 +614,8 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
 		 * the desired value.  On failure, restore the old SPTE so that
 		 * the SPTE isn't frozen in perpetuity.
 		 */
-		ret = kvm_x86_call(set_external_spte)(kvm, iter->gfn,
-						      iter->level, new_spte);
+		ret = kvm_x86_call(set_external_spte)(kvm, iter->gfn, iter->old_spte,
+						      new_spte, iter->level);
 		if (ret)
 			__kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte);
 		else
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index bd5d902da303..e451acdb0978 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1705,29 +1705,29 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
-static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
-				     enum pg_level level, u64 mirror_spte)
+static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
+				     u64 new_spte, enum pg_level level)
 {
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	kvm_pfn_t pfn = spte_to_pfn(mirror_spte);
+	kvm_pfn_t pfn = spte_to_pfn(new_spte);
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	int ret;
 
 	if (KVM_BUG_ON(!vcpu, kvm))
 		return -EINVAL;
 
-	if (KVM_BUG_ON(!is_shadow_present_pte(mirror_spte), kvm))
+	if (KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
 		return -EIO;
 
-	if (!is_last_spte(mirror_spte, level))
-		return tdx_sept_link_private_spt(kvm, gfn, level, mirror_spte);
+	if (!is_last_spte(new_spte, level))
+		return tdx_sept_link_private_spt(kvm, gfn, level, new_spte);
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
 		return -EIO;
 
-	WARN_ON_ONCE((mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
+	WARN_ON_ONCE((new_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
 
 	ret = tdx_pamt_get(pfn, level, &tdx->pamt_cache);
 	if (ret)
-- 
2.53.0.rc1.217.geba53bf80e-goog


