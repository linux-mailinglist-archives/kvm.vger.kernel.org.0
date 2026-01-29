Return-Path: <kvm+bounces-69456-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4AaTNdO0emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69456-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:16:03 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 02F3EAA8DC
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:16:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 04F0B3010630
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA0033509E;
	Thu, 29 Jan 2026 01:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ypv5dFtP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3E61FBEB0
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649343; cv=none; b=IxdYOoV5iCuksJl4ipKl5OdpKMoqnndLK9QdmPKNEYZ8FpEv60V2MEpFzepq5GqkZ3jX7EYouNC+FycmUMSi05CnYZBqI1SU6WSZrc9BJFiK+Iizijctex8JIvwVMDgq/Kr59ticfNcI6DQmNrlZOqDX3UdUM8/3mCjf3RZWgxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649343; c=relaxed/simple;
	bh=52WHRYcBaF84cq4d9eTCRiZcdWMBb91+paCcx/t1GiQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d4W+NLyvzkje1vy5nwNkiGa/v1ekr6xAjOr3jCETF0S1mn/NGViEuWBd10oqk/szPt8tetGG6TtN1wPrjCSObbsJCWbUcitk0kV8/3xcwVEz73f5xVoActcDXWoXluYqMDdr/w8G6A6Zzp66rCOWUtgfJdqN6Kt9qgzuXnFBSKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ypv5dFtP; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29f1f69eec6so5189915ad.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649339; x=1770254139; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=34WkAZh0eO1zmQ97gxROYaaRFi2k1TsiQe3th+qNzkY=;
        b=Ypv5dFtPf/9Y0aL6OHDXtJ0YZkdkzx6d2/0qMrCxo6Eixo0KRKCOeVYwmKoTmbjcT/
         hbBMR7DFDJ7EKasj9z363MZYnN+/1+HRuwZUWAspb2EKdSmYUvpFXz/L6zHwM+vwr0P0
         r1bJSvDshwobZfBavWF3KWweWkirRQy7MDASZPC1zpMIL8scfCaN64sS+3amKHHhMSsw
         tNKPP0PyN3JCjE8m+IBstWK5EB+VU0I7uptBIGLfIdAdQqTRKmz8MTTUg/xklhJD9MGM
         tArVUIjTpdszC42rT88t5VKhbEgiCIZBtXtGz7Tloo4GIHgnVJEofEVoL1XWtDB0cp1Y
         f2Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649339; x=1770254139;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=34WkAZh0eO1zmQ97gxROYaaRFi2k1TsiQe3th+qNzkY=;
        b=Ua5DCmnn0SVwNn/dFIk4WYlXiOVx4Q8uq8+a+pYZEf18HH0cpY2V2y2i4LdvcpndHT
         Lcj3vHwVpDbwFHmO5J/cN1Mf+DDC78QAUB+BpPt02SzFrRdJdUdxSNVnJkYkvG3GHPzU
         ZDS2KUOUtjQKKEqaKt//3pMSqa5k2Pd+OigyUDI1Gz2hECz62zeKIfJsR27NfVdApti2
         LdK0JhihWkAUc1/N3poVLDwwv4eTwA7BELop5j75JZqaPP6D4nVhF9OR5X6joObJAuDN
         UHbHNK12clvjWsEfcIVXInEJfJJgttD8MsNzxmFJAspVb9th2VPlk8VBNHKjTn2ndap8
         DwvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUk206nhxaYoUFVI56HarKDaiuiQcGaxj7fa5OBnibIQzS9qzLrJR7IWpxE1fxdRNSO6is=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJzwTg4Iirh49uIDc5xJPlUc0+utzEfflFu/ffVwU7UcWHgLC4
	C5G1nRwkJ4PCSZlR1Ln6pF4DxFDq/+Fz9Ql84/P3vOJQjO93K9J7VM2qRGo6JcDA/fQehmfFqgt
	DJgv2mA==
X-Received: from plnx1.prod.google.com ([2002:a17:902:8201:b0:2a0:f5f5:419d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:dac4:b0:2a0:c5b8:24b0
 with SMTP id d9443c01a7336-2a870dd56edmr73393065ad.46.1769649338679; Wed, 28
 Jan 2026 17:15:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:38 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-7-seanjc@google.com>
Subject: [RFC PATCH v5 06/45] KVM: x86/mmu: Fold set_external_spte_present()
 into its sole caller
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
	TAGGED_FROM(0.00)[bounces-69456-lists,kvm=lfdr.de];
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
X-Rspamd-Queue-Id: 02F3EAA8DC
X-Rspamd-Action: no action

Fold set_external_spte_present() into __tdp_mmu_set_spte_atomic() in
anticipation of supporting hugepage splitting, at which point other paths
will also set shadow-present external SPTEs.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 82 +++++++++++++++++---------------------
 1 file changed, 36 insertions(+), 46 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 56ad056e6042..6fb48b217f5b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -495,33 +495,6 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
 
-static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
-						 gfn_t gfn, u64 *old_spte,
-						 u64 new_spte, int level)
-{
-	int ret;
-
-	lockdep_assert_held(&kvm->mmu_lock);
-
-	if (KVM_BUG_ON(is_shadow_present_pte(*old_spte), kvm))
-		return -EIO;
-
-	/*
-	 * We need to lock out other updates to the SPTE until the external
-	 * page table has been modified. Use FROZEN_SPTE similar to
-	 * the zapping case.
-	 */
-	if (!try_cmpxchg64(rcu_dereference(sptep), old_spte, FROZEN_SPTE))
-		return -EBUSY;
-
-	ret = kvm_x86_call(set_external_spte)(kvm, gfn, level, new_spte);
-	if (ret)
-		__kvm_tdp_mmu_write_spte(sptep, *old_spte);
-	else
-		__kvm_tdp_mmu_write_spte(sptep, new_spte);
-	return ret;
-}
-
 /**
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
@@ -626,6 +599,8 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
 							 struct tdp_iter *iter,
 							 u64 new_spte)
 {
+	u64 *raw_sptep = rcu_dereference(iter->sptep);
+
 	/*
 	 * The caller is responsible for ensuring the old SPTE is not a FROZEN
 	 * SPTE.  KVM should never attempt to zap or manipulate a FROZEN SPTE,
@@ -638,31 +613,46 @@ static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
 		int ret;
 
 		/*
-		 * Users of atomic zapping don't operate on mirror roots,
-		 * so don't handle it and bug the VM if it's seen.
+		 * KVM doesn't currently support zapping or splitting mirror
+		 * SPTEs while holding mmu_lock for read.
 		 */
-		if (KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
+		if (KVM_BUG_ON(is_shadow_present_pte(iter->old_spte), kvm) ||
+		    KVM_BUG_ON(!is_shadow_present_pte(new_spte), kvm))
 			return -EBUSY;
 
-		ret = set_external_spte_present(kvm, iter->sptep, iter->gfn,
-						&iter->old_spte, new_spte, iter->level);
+		/*
+		 * Temporarily freeze the SPTE until the external PTE operation
+		 * has completed, e.g. so that concurrent faults don't attempt
+		 * to install a child PTE in the external page table before the
+		 * parent PTE has been written.
+		 */
+		if (!try_cmpxchg64(raw_sptep, &iter->old_spte, FROZEN_SPTE))
+			return -EBUSY;
+
+		/*
+		 * Update the external PTE.  On success, set the mirror SPTE to
+		 * the desired value.  On failure, restore the old SPTE so that
+		 * the SPTE isn't frozen in perpetuity.
+		 */
+		ret = kvm_x86_call(set_external_spte)(kvm, iter->gfn,
+						      iter->level, new_spte);
 		if (ret)
-			return ret;
-	} else {
-		u64 *sptep = rcu_dereference(iter->sptep);
-
-		/*
-		 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs
-		 * and does not hold the mmu_lock.  On failure, i.e. if a
-		 * different logical CPU modified the SPTE, try_cmpxchg64()
-		 * updates iter->old_spte with the current value, so the caller
-		 * operates on fresh data, e.g. if it retries
-		 * tdp_mmu_set_spte_atomic()
-		 */
-		if (!try_cmpxchg64(sptep, &iter->old_spte, new_spte))
-			return -EBUSY;
+			__kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte);
+		else
+			__kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
+		return ret;
 	}
 
+	/*
+	 * Note, fast_pf_fix_direct_spte() can also modify TDP MMU SPTEs and
+	 * does not hold the mmu_lock.  On failure, i.e. if a different logical
+	 * CPU modified the SPTE, try_cmpxchg64() updates iter->old_spte with
+	 * the current value, so the caller operates on fresh data, e.g. if it
+	 * retries tdp_mmu_set_spte_atomic()
+	 */
+	if (!try_cmpxchg64(raw_sptep, &iter->old_spte, new_spte))
+		return -EBUSY;
+
 	return 0;
 }
 
-- 
2.53.0.rc1.217.geba53bf80e-goog


