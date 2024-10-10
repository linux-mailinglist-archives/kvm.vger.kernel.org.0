Return-Path: <kvm+bounces-28485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7322A99901B
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 20:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 917601C20CD2
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 18:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DC0E1E8844;
	Thu, 10 Oct 2024 18:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kbknugbz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4355C1E5730
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 18:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728584712; cv=none; b=eLM8UOvOll3b/l4nwnMFC/CyovnoRpi6ymy1EeYDhr0xVR+D3B9DSGclh3YA70skC+Gavq6fa9pf46J7kkIxk9ZJzZjgWaIpP4NnSJ9g7aVzfhcTWz83o/mTv2Zdko1/3cBq0jNbUCBCPAO3+ON2Gh1/tBhfZbjgiOBuaLLOsco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728584712; c=relaxed/simple;
	bh=VkZarLC+Eu//G+0PeVKNSmckYM6o8fYMsW2puWWES3Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g20mxCQdv9FB44HkEXLAu5CiK5igxrY5WF6tKBaTMSgySAdqTfaRXpNmEnY9vwOK1eT53/U/DGPwxn59iq/uhT9oMegsJONMFftXgE77tm78aDnMMQLvmlKdMSHwVEdyRTiS519GQQ18LBz4lyWyV08prz42PzLMpw48C/J12yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kbknugbz; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7e6af43d0c5so1107917a12.3
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 11:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1728584709; x=1729189509; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e3d7DBw/sg5cuh+IKhcM0BkpGN0EJ0d/2DHG844pD6k=;
        b=KbknugbzdNUXpNoKARsIRLpx8PRqlV/FblB8LCRY3jXCEL8YQWp2+5e1SPcnpU1anA
         /Un1XGepnDYvRE8uMn1M8sNXDKThkOYuLMTMY4dvsf3kPUPmzir5ncOXQFn7+bv1p4hy
         H2jRB4kxAnETZzMSlESoEbGU/tyiL4jS3pm3WzUHXkieibovGZ1NPgTsV7+P+Cesmr1y
         Fs2xH6iupE8taJ7d1TWULgnebCuHG6dRZWs4+QPnv+cXQLB2p6C1WBwO4XLulqfa6dO3
         cUBm6987ZwMn/Cpfa5BrC69Oqg5CqfZ6FFkwpWMqFmwwGgxbzBJ359J9aVrp/AaSSVAN
         8DSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728584709; x=1729189509;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e3d7DBw/sg5cuh+IKhcM0BkpGN0EJ0d/2DHG844pD6k=;
        b=u3ol48iM6E5zLnO/ta/nJEx8Fy1kYNLaq21HFPfoZJVI37A+/3EJNYeQnUS9OFmqPr
         TUgJ2h4DgMMD0uywPYHfDJ/Toxfz12cqis7W4RrTrSJHPdPmUem+IOrMT4oMg0jdEEXN
         kv3lYgzFx2dMVDVBccPeGjPZy6McEbL3FL9BEH3mbYq4CZM3QvTL1luqHH1DJSfIgrdZ
         DoglPpbTrhCvkhKFy5gSjgAg0bi9mEh/Prh0MEr/45lVb4VWgHRmXCh9So6CfG3mh92c
         2qJ6qGftdqfWtdLSDeRsH6XhXYCj4ehH5gsf5y0/5/4HvGcC1OeOJgp65CWWIcIAGYH3
         jMvw==
X-Gm-Message-State: AOJu0YxijHi/jcg6Lnhu78oPD45jn72DvXvO8PrCIwHf+YjoigDFheuV
	03YguRl7tMGwuK5meRngxAXI04vflT6+FjXRh1QI6O0qVSO6PFqHB7AvIgeWnsKot48HwKscOuj
	AcQ==
X-Google-Smtp-Source: AGHT+IFvOj1YmixVIm2giqrxikolLV70YR7/zWjxlJNmhfeSXdlwSACqKd64r4Is1alzH3q275ZQuugRXZo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a17:90b:153:b0:2e2:af66:c33e with SMTP id
 98e67ed59e1d1-2e2f0ae73f3mr37a91.1.1728584708343; Thu, 10 Oct 2024 11:25:08
 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 10 Oct 2024 11:23:10 -0700
In-Reply-To: <20241010182427.1434605-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241010182427.1434605-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.rc1.288.g06298d1525-goog
Message-ID: <20241010182427.1434605-9-seanjc@google.com>
Subject: [PATCH v13 08/85] KVM: x86/mmu: Mark folio dirty when creating SPTE,
 not when zapping/modifying
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	"=?UTF-8?q?Alex=20Benn=C3=A9e?=" <alex.bennee@linaro.org>, Yan Zhao <yan.y.zhao@intel.com>, 
	David Matlack <dmatlack@google.com>, David Stevens <stevensd@chromium.org>, 
	Andrew Jones <ajones@ventanamicro.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Mark pages/folios dirty when creating SPTEs to map PFNs into the guest,
not when zapping or modifying SPTEs, as marking folios dirty when zapping
or modifying SPTEs can be extremely inefficient.  E.g. when KVM is zapping
collapsible SPTEs to reconstitute a hugepage after disbling dirty logging,
KVM will mark every 4KiB pfn as dirty, even though _at least_ 512 pfns are
guaranteed to be in a single folio (the SPTE couldn't potentially be huge
if that weren't the case).  The problem only becomes worse for 1GiB
HugeTLB pages, as KVM can mark a single folio dirty 512*512 times.

Marking a folio dirty when mapping is functionally safe as KVM drops all
relevant SPTEs in response to an mmu_notifier invalidation, i.e. ensures
that the guest can't dirty a folio after access has been removed.

And because KVM already marks folios dirty when zapping/modifying SPTEs
for KVM reasons, i.e. not in response to an mmu_notifier invalidation,
there is no danger of "prematurely" marking a folio dirty.  E.g. if a
filesystems cleans a folio without first removing write access, then there
already exists races where KVM could mark a folio dirty before remote TLBs
are flushed, i.e. before guest writes are guaranteed to stop.  Furthermore,
x86 is literally the only architecture that marks folios dirty on the
backend; every other KVM architecture marks folios dirty at map time.

x86's unique behavior likely stems from the fact that x86's MMU predates
mmu_notifiers.  Long, long ago, before mmu_notifiers were added, marking
pages dirty when zapping SPTEs was logical, and perhaps even necessary, as
KVM held references to pages, i.e. kept a page's refcount elevated while
the page was mapped into the guest.  At the time, KVM's rmap_remove()
simply did:

        if (is_writeble_pte(*spte))
                kvm_release_pfn_dirty(pfn);
        else
                kvm_release_pfn_clean(pfn);

i.e. dropped the refcount and marked the page dirty at the same time.
After mmu_notifiers were introduced, commit acb66dd051d0 ("KVM: MMU:
don't hold pagecount reference for mapped sptes pages") removed the
refcount logic, but kept the dirty logic, i.e. converted the above to:

	if (is_writeble_pte(*spte))
		kvm_release_pfn_dirty(pfn);

And for KVM x86, that's essentially how things have stayed over the last
~15 years, without anyone revisiting *why* KVM marks pages/folios dirty at
zap/modification time, e.g. the behavior was blindly carried forward to
the TDP MMU.

Practically speaking, the only downside to marking a folio dirty during
mapping is that KVM could trigger writeback of memory that was never
actually written.  Except that can't actually happen if KVM marks folios
dirty if and only if a writable SPTE is created (as done here), because
KVM always marks writable SPTEs as dirty during make_spte().  See commit
9b51a63024bd ("KVM: MMU: Explicitly set D-bit for writable spte."), circa
2015.

Note, KVM's access tracking logic for prefetched SPTEs is a bit odd.  If a
guest PTE is dirty and writable, KVM will create a writable SPTE, but then
mark the SPTE for access tracking.  Which isn't wrong, just a bit odd, as
it results in _more_ precise dirty tracking for MMUs _without_ A/D bits.

To keep things simple, mark the folio dirty before access tracking comes
into play, as an access-tracked SPTE can be restored in the fast page
fault path, i.e. without holding mmu_lock.  While writing SPTEs and
accessing memslots outside of mmu_lock is safe, marking a folio dirty is
not.  E.g. if the fast path gets interrupted _just_ after setting a SPTE,
the primary MMU could theoretically invalidate and free a folio before KVM
marks it dirty.  Unlike the shadow MMU, which waits for CPUs to respond to
an IPI, the TDP MMU only guarantees the page tables themselves won't be
freed (via RCU).

Opportunistically update a few stale comments.

Cc: David Matlack <dmatlack@google.com>
Tested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c         | 30 ++++--------------------------
 arch/x86/kvm/mmu/paging_tmpl.h |  6 +++---
 arch/x86/kvm/mmu/spte.c        | 20 ++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.c     | 12 ------------
 4 files changed, 25 insertions(+), 43 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0f21d6f76cab..1ae823ebd12b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -547,10 +547,8 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 		kvm_set_pfn_accessed(spte_to_pfn(old_spte));
 	}
=20
-	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte)) {
+	if (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte))
 		flush =3D true;
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
-	}
=20
 	return flush;
 }
@@ -593,9 +591,6 @@ static u64 mmu_spte_clear_track_bits(struct kvm *kvm, u=
64 *sptep)
 	if (is_accessed_spte(old_spte))
 		kvm_set_pfn_accessed(pfn);
=20
-	if (is_dirty_spte(old_spte))
-		kvm_set_pfn_dirty(pfn);
-
 	return old_spte;
 }
=20
@@ -1250,16 +1245,6 @@ static bool spte_clear_dirty(u64 *sptep)
 	return mmu_spte_update(sptep, spte);
 }
=20
-static bool spte_wrprot_for_clear_dirty(u64 *sptep)
-{
-	bool was_writable =3D test_and_clear_bit(PT_WRITABLE_SHIFT,
-					       (unsigned long *)sptep);
-	if (was_writable && !spte_ad_enabled(*sptep))
-		kvm_set_pfn_dirty(spte_to_pfn(*sptep));
-
-	return was_writable;
-}
-
 /*
  * Gets the GFN ready for another round of dirty logging by clearing the
  *	- D bit on ad-enabled SPTEs, and
@@ -1275,7 +1260,8 @@ static bool __rmap_clear_dirty(struct kvm *kvm, struc=
t kvm_rmap_head *rmap_head,
=20
 	for_each_rmap_spte(rmap_head, &iter, sptep)
 		if (spte_ad_need_write_protect(*sptep))
-			flush |=3D spte_wrprot_for_clear_dirty(sptep);
+			flush |=3D test_and_clear_bit(PT_WRITABLE_SHIFT,
+						    (unsigned long *)sptep);
 		else
 			flush |=3D spte_clear_dirty(sptep);
=20
@@ -1628,14 +1614,6 @@ static bool kvm_rmap_age_gfn_range(struct kvm *kvm,
 				clear_bit((ffs(shadow_accessed_mask) - 1),
 					(unsigned long *)sptep);
 			} else {
-				/*
-				 * Capture the dirty status of the page, so that
-				 * it doesn't get lost when the SPTE is marked
-				 * for access tracking.
-				 */
-				if (is_writable_pte(spte))
-					kvm_set_pfn_dirty(spte_to_pfn(spte));
-
 				spte =3D mark_spte_for_access_track(spte);
 				mmu_spte_update_no_track(sptep, spte);
 			}
@@ -3415,7 +3393,7 @@ static bool fast_pf_fix_direct_spte(struct kvm_vcpu *=
vcpu,
 	 * harm. This also avoids the TLB flush needed after setting dirty bit
 	 * so non-PML cases won't be impacted.
 	 *
-	 * Compare with set_spte where instead shadow_dirty_mask is set.
+	 * Compare with make_spte() where instead shadow_dirty_mask is set.
 	 */
 	if (!try_cmpxchg64(sptep, &old_spte, new_spte))
 		return false;
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.=
h
index 6e7bd8921c6f..fbaae040218b 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -892,9 +892,9 @@ static gpa_t FNAME(gva_to_gpa)(struct kvm_vcpu *vcpu, s=
truct kvm_mmu *mmu,
=20
 /*
  * Using the information in sp->shadowed_translation (kvm_mmu_page_get_gfn=
()) is
- * safe because:
- * - The spte has a reference to the struct page, so the pfn for a given g=
fn
- *   can't change unless all sptes pointing to it are nuked first.
+ * safe because SPTEs are protected by mmu_notifiers and memslot generatio=
ns, so
+ * the pfn for a given gfn can't change unless all SPTEs pointing to the g=
fn are
+ * nuked first.
  *
  * Returns
  * < 0: failed to sync spte
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 618059b30b8b..8e8d6ee79c8b 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -232,8 +232,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_pa=
ge *sp,
 		 * unnecessary (and expensive).
 		 *
 		 * The same reasoning applies to dirty page/folio accounting;
-		 * KVM will mark the folio dirty using the old SPTE, thus
-		 * there's no need to immediately mark the new SPTE as dirty.
+		 * KVM marked the folio dirty when the old SPTE was created,
+		 * thus there's no need to mark the folio dirty again.
 		 *
 		 * Note, both cases rely on KVM not changing PFNs without first
 		 * zapping the old SPTE, which is guaranteed by both the shadow
@@ -266,12 +266,28 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_=
page *sp,
 		  "spte =3D 0x%llx, level =3D %d, rsvd bits =3D 0x%llx", spte, level,
 		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
=20
+	/*
+	 * Mark the memslot dirty *after* modifying it for access tracking.
+	 * Unlike folios, memslots can be safely marked dirty out of mmu_lock,
+	 * i.e. in the fast page fault handler.
+	 */
 	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
 		WARN_ON_ONCE(level > PG_LEVEL_4K);
 		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
 	}
=20
+	/*
+	 * If the page that KVM got from the primary MMU is writable, i.e. if
+	 * it's host-writable, mark the page/folio dirty.  As alluded to above,
+	 * folios can't be safely marked dirty in the fast page fault handler,
+	 * and so KVM must (somewhat) speculatively mark the folio dirty even
+	 * though it isn't guaranteed to be written as KVM won't mark the folio
+	 * dirty if/when the SPTE is made writable.
+	 */
+	if (host_writable)
+		kvm_set_pfn_dirty(pfn);
+
 	*new_spte =3D spte;
 	return wrprot;
 }
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 76bca7a726c1..517b384473c1 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -511,10 +511,6 @@ static void handle_changed_spte(struct kvm *kvm, int a=
s_id, gfn_t gfn,
 	if (is_leaf !=3D was_leaf)
 		kvm_update_page_stats(kvm, level, is_leaf ? 1 : -1);
=20
-	if (was_leaf && is_dirty_spte(old_spte) &&
-	    (!is_present || !is_dirty_spte(new_spte) || pfn_changed))
-		kvm_set_pfn_dirty(spte_to_pfn(old_spte));
-
 	/*
 	 * Recursively handle child PTs if the change removed a subtree from
 	 * the paging structure.  Note the WARN on the PFN changing without the
@@ -1249,13 +1245,6 @@ static bool age_gfn_range(struct kvm *kvm, struct td=
p_iter *iter,
 							 iter->level);
 		new_spte =3D iter->old_spte & ~shadow_accessed_mask;
 	} else {
-		/*
-		 * Capture the dirty status of the page, so that it doesn't get
-		 * lost when the SPTE is marked for access tracking.
-		 */
-		if (is_writable_pte(iter->old_spte))
-			kvm_set_pfn_dirty(spte_to_pfn(iter->old_spte));
-
 		new_spte =3D mark_spte_for_access_track(iter->old_spte);
 		iter->old_spte =3D kvm_tdp_mmu_write_spte(iter->sptep,
 							iter->old_spte, new_spte,
@@ -1596,7 +1585,6 @@ static void clear_dirty_pt_masked(struct kvm *kvm, st=
ruct kvm_mmu_page *root,
 		trace_kvm_tdp_mmu_spte_changed(iter.as_id, iter.gfn, iter.level,
 					       iter.old_spte,
 					       iter.old_spte & ~dbit);
-		kvm_set_pfn_dirty(spte_to_pfn(iter.old_spte));
 	}
=20
 	rcu_read_unlock();
--=20
2.47.0.rc1.288.g06298d1525-goog


