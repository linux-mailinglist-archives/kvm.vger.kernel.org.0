Return-Path: <kvm+bounces-69458-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2Ne7Bwm1emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69458-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:16:57 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DC17AA916
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:16:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EC3223048BEA
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9527531ED7B;
	Thu, 29 Jan 2026 01:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nDjEaaSE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C4D32E724
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649346; cv=none; b=rhphjebqqcHn6Az/Hn/V/g6kEf/HfgDdmXoTkUr5Kfv4KFKMP4a8yDa5npNsNu0rg0oIYfrSRvuOE89/DUWP/Aiiaq+R/vCpU5H1vgajY+ewfzUQJsXlKQUNVVuMYjXFRw7NlVBOU4++Iqxvcr6QJ5Q0HWZvoXb2tXkpXNFMDT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649346; c=relaxed/simple;
	bh=kkghoN8ozlhuTfHP923gQ1EuVfkrW8+BxHy4JMV4lfQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Tqi+KKEwAUT+CFwn1phYwk+0sARcU2/okmC2iK5KfbaaHPvXzfvErcnMBPOCQocDAxh7SVU0bh99uIF4SaLYPkijNGUhKxhTpyxsJloOGAqtfaLKCX48b2DQxlsAftH5WuJn4Pelr3YXgkDw7ukAr8O2RNQENfXaTXWcfjfX1g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nDjEaaSE; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c5454bf50e0so862262a12.2
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:15:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649342; x=1770254142; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=SAUKDZ4/BIicH8X7DG5XUGdjBDs3Mzg+V7hlpmye//I=;
        b=nDjEaaSELq7tsG+ZZmKg2Ii3ysgvGBmoIxvjEKOc32tQwuzJvNBjFhXgZMrx+p1hHJ
         rF1n01/Z2iOp5Jpl1hP2ZRXC4C2BuHVTD+bNGbyfzP0nz6Gx73APfGsKmE6eydovc4ok
         klmP99k5WzoIM1fHglVMXV8kpADvRSnJKrEWoZjaKND/m4UhQj7faJ5q45wQjdgyVJ5M
         RCe5mMVLmUNCpbmMQVKQBn5FGGhrAwUC+xB2//QWSQpfHgpplacvag7C4MzT7M+dSHCH
         RUveKjkGnGlIfpNPt36Tq2dTZp5zHK0c6cR6bfihRgBg56y7lMoreW13aVj1In4ii6os
         jwqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649342; x=1770254142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SAUKDZ4/BIicH8X7DG5XUGdjBDs3Mzg+V7hlpmye//I=;
        b=X3MsBbToaO5Eqhui7La1VLO8mIrgCHsLr2Y7hqLDE8o7P3EyaL1dVKzH4DmGGnvHP1
         nsevdpF9AtDdomytzWy3mBf4U2PDYf9lHBikhEDQideQxaAxmSFULYH9tI/Au44dJQoi
         NfH5pObMjblWmMLI+hWcvf3LfBXlrgE308VeYiJliRmud5w1BPOTwv+UYiuyrM1SfYk1
         8toWm6M7+zvaeMkiotvU6u/eX6NBbI9UMKVPiLq52XKTm2OJ4AKNyhu5gKLbRHXBJJ3n
         fJfO/vJ2eyqZP3vqPy+Q4DrxhQ4tDMGqrBPqNkt0h66741mh7KXXgHp+v4ZoM4g8REnV
         W8kA==
X-Forwarded-Encrypted: i=1; AJvYcCWsZ9P1DYKH1F4GXlakvavbLpIr59OqhpTQ4NcktwZLBRUM7LCd65weMWrE1eVqy/EY82U=@vger.kernel.org
X-Gm-Message-State: AOJu0YzR0N1ETQCVwvVf88UfyWgNqI0LOUOq4wRM4ofRZ6o3eJoCrvO/
	WeGEv7buE55Plbbar1cZ1cmNomVla2luy92efUvhJjHCcVxhVLiTRkrdzg437/AJ9Giw2ASCsXl
	ODalEcg==
X-Received: from plbkf12.prod.google.com ([2002:a17:903:5cc:b0:2a0:fb2a:79f0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:a8e:b0:38b:d9b5:5de2
 with SMTP id adf61e73a8af0-38ec63c6233mr5358315637.50.1769649342527; Wed, 28
 Jan 2026 17:15:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:40 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-9-seanjc@google.com>
Subject: [RFC PATCH v5 08/45] KVM: x86/mmu: Propagate mirror SPTE removal to
 S-EPT in handle_changed_spte()
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69458-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 8DC17AA916
X-Rspamd-Action: no action

Invoke .remove_external_spte() in handle_changed_spte() as appropriate
instead of relying on callers to do the right thing.  Relying on callers
to invoke .remove_external_spte() is confusing and brittle, e.g. subtly
relies tdp_mmu_set_spte_atomic() never removing SPTEs, and removing an
S-EPT entry in tdp_mmu_set_spte() is bizarre (yeah, the VM is bugged so
it doesn't matter in practice, but it's still weird).

Implementing rules-based logic in a common chokepoint will also make it
easier to reason about the correctness of splitting hugepages when support
for S-EPT hugepages comes along.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 43 +++++++++++++-------------------------
 1 file changed, 14 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 8743cd020d12..27ac520f2a89 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -359,25 +359,6 @@ static void tdp_mmu_unlink_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	spin_unlock(&kvm->arch.tdp_mmu_pages_lock);
 }
 
-static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
-				 int level)
-{
-	/*
-	 * External (TDX) SPTEs are limited to PG_LEVEL_4K, and external
-	 * PTs are removed in a special order, involving free_external_spt().
-	 * But remove_external_spte() will be called on non-leaf PTEs via
-	 * __tdp_mmu_zap_root(), so avoid the error the former would return
-	 * in this case.
-	 */
-	if (!is_last_spte(old_spte, level))
-		return;
-
-	/* Zapping leaf spte is allowed only when write lock is held. */
-	lockdep_assert_held_write(&kvm->mmu_lock);
-
-	kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_spte);
-}
-
 /**
  * handle_removed_pt() - handle a page table removed from the TDP structure
  *
@@ -473,11 +454,6 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
 		}
 		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp), sptep, gfn,
 				    old_spte, FROZEN_SPTE, level, shared);
-
-		if (is_mirror_sp(sp)) {
-			KVM_BUG_ON(shared, kvm);
-			remove_external_spte(kvm, gfn, old_spte, level);
-		}
 	}
 
 	if (is_mirror_sp(sp) &&
@@ -590,10 +566,21 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	 * the paging structure.  Note the WARN on the PFN changing without the
 	 * SPTE being converted to a hugepage (leaf) or being zapped.  Shadow
 	 * pages are kernel allocations and should never be migrated.
+	 *
+	 * When removing leaf entries from a mirror, immediately propagate the
+	 * changes to the external page tables.  Note, non-leaf mirror entries
+	 * are handled by handle_removed_pt(), as TDX requires that all leaf
+	 * entries are removed before the owning page table.  Note #2, writes
+	 * to make mirror PTEs shadow-present are propagated to external page
+	 * tables by __tdp_mmu_set_spte_atomic(), as KVM needs to ensure the
+	 * external page table was successfully updated before marking the
+	 * mirror SPTE present.
 	 */
 	if (was_present && !was_leaf &&
 	    (is_leaf || !is_present || WARN_ON_ONCE(pfn_changed)))
 		handle_removed_pt(kvm, spte_to_child_pt(old_spte, level), shared);
+	else if (was_leaf && is_mirror_sptep(sptep) && !is_leaf)
+		kvm_x86_call(remove_external_spte)(kvm, gfn, level, old_spte);
 }
 
 static inline int __must_check __tdp_mmu_set_spte_atomic(struct kvm *kvm,
@@ -725,12 +712,10 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 
 	/*
 	 * Users that do non-atomic setting of PTEs don't operate on mirror
-	 * roots, so don't handle it and bug the VM if it's seen.
+	 * roots.  Bug the VM as this path doesn't propagate such writes to the
+	 * external page tables.
 	 */
-	if (is_mirror_sptep(sptep)) {
-		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
-		remove_external_spte(kvm, gfn, old_spte, level);
-	}
+	KVM_BUG_ON(is_mirror_sptep(sptep) && is_shadow_present_pte(new_spte), kvm);
 
 	return old_spte;
 }
-- 
2.53.0.rc1.217.geba53bf80e-goog


