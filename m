Return-Path: <kvm+bounces-69457-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iK4qDaC1emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69457-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:19:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D3535AA9B9
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:19:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 903FA308FEBD
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6279B331A76;
	Thu, 29 Jan 2026 01:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3TPPBt9x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF2031DD98
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649344; cv=none; b=lJsazmwaIAcaoSkNtqhL0cErEE00zhWltxPshZUFs4FlSi7hvr3ovJw5bTZE/kq/LVb9MWObjDC0X2FEtO4Oa/E7R2Qnw3TBgqiIhi1jLEqfCWw7uQs6J1goDj/YUJ8M47PakjnIuuMZOYqO0DyJq1ujwj1hSgUwsQTsYS+wcS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649344; c=relaxed/simple;
	bh=u2c/NHbwd0lYBbUDVthgSs2By7odK2wgvzMf1mYm8nw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XMIAyu3tkBGi2ItmvbQLnMioVHWxPlCLTREJAWiTDPrbpGjL1Uv20gErN7KAnfN7U1Z3wguC6bwRafnEvK8/2S2+RlLUi70xZBl6OyL7QpNBWgoePGQ/G9Whinb+tozBNJUCbcf7CSxc3PeJ0NLuyDTvwHqagWF8jcgxBZhE3sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3TPPBt9x; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a773db3803so4003775ad.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:15:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649341; x=1770254141; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=yG0aJZj9vYemOuZH1z1kqzk7rC62lJqsq0W3///tL/M=;
        b=3TPPBt9xfC4daULq855+G1xZ8/MD3fU3A6zDwIlq59gwqQ61ijTWwM00lcrAn+KZid
         wUnNpw85dMlXJ3fdV4JOjEO5UhL8INXoJesshXjCq+sh3JcYeds5FB7jO81t135r6MTJ
         KYzZI1S0MudJDLBu5vfHSSL++YZQ/UUL6YQxnw0sq+AnTaUC2pyvDo6OHSFUIUFwzzQO
         Nc2oc1C6MiZHLf2uCZlZZH33+xoGeSvt6IukZX3vCLnNwkjyxLx6cue7kadxwTUt2pTe
         vkaiqwAORkfidawGhOdCtHQfe/OEbuA17XxIxJ9u8unXjfG5UMC2soUKLXAt6hud+w2B
         I9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649341; x=1770254141;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yG0aJZj9vYemOuZH1z1kqzk7rC62lJqsq0W3///tL/M=;
        b=HR5WgS5uvaUREX4uBxXjgr6up9Bu0317RJRtXEcDmTQnX0SFYPPObQXTROhJRkIJST
         BjTjRYScylK6O8VT+FGZZln72qMS+aPmPFAT803ab0mFkz2HKIhAVNegaUrhXhId0NEV
         ms9E5+xr8VYzdiC3ONmCIXQ8d6EQbc8g4sDPyHQqc7x3RHCbLjGYtDyiVLQ3mysuzhkP
         U2hkARAMDRPdu9wfOoWx2yd7AcD8CnnN8L0Jzy1O5wwTG/+h/Ryg8zwxgDVvqGKQnQrq
         SSk+25twTSEOVDurIb6WMk/D/B3cz1Y3lNHQoJqKps7qBWJdVDiWVUl+fdUmG+5jloL0
         zHuw==
X-Forwarded-Encrypted: i=1; AJvYcCUY0S0UQ2R2IpRE9VWgXjQSxKk5Bm8MxoRAwayncKPAZBxm78d0b0kQeq62y9FQEtvormM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxcTBpZQxSocN8rZSboQw20Mzg/QPgYf4DsI3OqQWyV3qpeSrBI
	7fslU/D0hH7bafVf7GFnGuYLqjpa3ER3MKbipRRmKSebZNruzJhBj5DGpdgT4z5G+OlFQhE2dlP
	FBkJ+Eg==
X-Received: from pgbcq1.prod.google.com ([2002:a05:6a02:4081:b0:bc3:ac3:8769])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:a41:b0:389:94e1:25c1
 with SMTP id adf61e73a8af0-38ec658ba91mr6736564637.70.1769649340957; Wed, 28
 Jan 2026 17:15:40 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:39 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-8-seanjc@google.com>
Subject: [RFC PATCH v5 07/45] KVM: x86/mmu: Plumb the SPTE _pointer_ into the
 TDP MMU's handle_changed_spte()
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69457-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: D3535AA9B9
X-Rspamd-Action: no action

Plumb the SPTE pointer into handle_changed_spte() so that remove leaf
mirror entries can be forwarded to TDX in handle_changed_spte(), instead
of effectively requiring callers to manually do so.  Relying on each
caller to invoke .remove_external_spte() is confusing and brittle, e.g.
subtly relies tdp_mmu_set_spte_atomic() never removing SPTEs.  This will
also allow consolidating all S-EPT updates into a single kvm_x86_ops hook.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6fb48b217f5b..8743cd020d12 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -320,9 +320,9 @@ void kvm_tdp_mmu_alloc_root(struct kvm_vcpu *vcpu, bool mirror)
 	}
 }
 
-static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared);
+static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
+				gfn_t gfn, u64 old_spte, u64 new_spte,
+				int level, bool shared);
 
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
@@ -471,7 +471,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 			old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte,
 							  FROZEN_SPTE, level);
 		}
-		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), gfn,
+		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), sptep, gfn,
 				    old_spte, FROZEN_SPTE, level, shared);
 
 		if (is_mirror_sp(sp)) {
@@ -499,6 +499,7 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
  * @as_id: the address space of the paging structure the SPTE was a part of
+ * @sptep: pointer to the SPTE
  * @gfn: the base GFN that was mapped by the SPTE
  * @old_spte: The value of the SPTE before the change
  * @new_spte: The value of the SPTE after the change
@@ -511,9 +512,9 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
  * dirty logging updates are handled in common code, not here (see make_spte()
  * and fast_pf_fix_direct_spte()).
  */
-static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-				u64 old_spte, u64 new_spte, int level,
-				bool shared)
+static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
+				gfn_t gfn, u64 old_spte, u64 new_spte,
+				int level, bool shared)
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
@@ -685,8 +686,8 @@ static inline int __must_check tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	if (ret)
 		return ret;
 
-	handle_changed_spte(kvm, iter->as_id, iter->gfn, iter->old_spte,
-			    new_spte, iter->level, true);
+	handle_changed_spte(kvm, iter->as_id, iter->sptep, iter->gfn,
+			    iter->old_spte, new_spte, iter->level, true);
 
 	return 0;
 }
@@ -720,7 +721,7 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
 	old_spte = kvm_tdp_mmu_write_spte(sptep, old_spte, new_spte, level);
 
-	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
+	handle_changed_spte(kvm, as_id, sptep, gfn, old_spte, new_spte, level, false);
 
 	/*
 	 * Users that do non-atomic setting of PTEs don't operate on mirror
-- 
2.53.0.rc1.217.geba53bf80e-goog


