Return-Path: <kvm+bounces-60257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D27EBE5F2D
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 02:37:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73E5B1887A9A
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 00:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B528829B776;
	Fri, 17 Oct 2025 00:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CQcpuwIZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6A329617D
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 00:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661197; cv=none; b=RUPxC4PRqcsCwAsbHjmQNwDu9MYS4oefaQRxe48g0Il0JUvec7XAoX/eUfQ/MUr2sEN48panh/xy4vrfvLDpPbvPZYkB2uojWqnSq+/kY6UI7eRyCWhcB7e8kEAk1o4BYxoHX6XTvb2z0hJgnCWZy7wyQ3Hgi27Lyfh9nZM5BBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661197; c=relaxed/simple;
	bh=jbwKuImiIrIw8Noi4RxeEMR04KFlxna3AZNfFvD8+0A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aUozMZ1JILAdNd17CQOD0XS4CW66VkfHokDbfZcpR/CpMiFOyxFi79WhdFKMAJJxKP+hnab3+V+YjG9abSMeN/F/dlam9DZNwOoM6giJTpSuoEz10pNZJ6d4eJb6i8H3KDthg/BwnskjYfeD9ZtgexFJw4PH9s69oeuuGQlAyWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CQcpuwIZ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bcb7796d4so677138a91.0
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661194; x=1761265994; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=24WL3/XVrWtQShgQMVnGZkUPAQhnwZjEdj9gk6jqvRM=;
        b=CQcpuwIZowrBlg0KVJrWZ/HUjrsj4Sahqh5r4Wv/LzUsBZhwqaRchpFaE2tyAmhVv5
         PaUP1QyCyUDn9LkxvnnVr6/bQ8bOXxFuddIMFXRVy6bxUqETXW1hQeZTEIcYm0CLTJzZ
         14JTgNpjDmaJePUZOFBsIcxTH/gTF9Qr72Mk1RFYM4tFJn8hxjSNQZNnfhHrAB+SVJCV
         o8n1r6skEQ5oyG3Vmh3ah/XcdIuQRkI9M5Cwum5TBZL6HVzKZ9XxDTgwFq6K+qoROfj0
         XswUCopiaFeqlwjc7GZRaOpjjDM1dhCy5DvWDbc9Q/H4EU+Iz0YGGcgqaSLmB5TK1mUt
         K1GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661194; x=1761265994;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=24WL3/XVrWtQShgQMVnGZkUPAQhnwZjEdj9gk6jqvRM=;
        b=OYk2rrSuihf03Of2QC5kVwycaaG4Qfvguh64UwKUW3w7uAOyEa9Jhar0MV7dcHLNeo
         Rx0Jp2Q3aWaUS8i7izVQzXumZyVYjl8MQlwElk1a8adxAPtE5UpfbvhdKWkP5TvJXLlF
         JsDjkcYWQFxLHV6UvJZqlY2707we29d3OnIKdjyedmkdShzIfIRzUK16pjeHVda04rIc
         5f4Sb5HZnlzmlNPQYgy5HVaFTrxky/nxY0BNrxRR2kOBXw+1wPn3KDHapG3rqBRjMMLe
         2RrnuK0JNBC0iamGPeU0Lrk50orJ4/Zfew4cPV70mX3uyiKXR21XnQ/ebkl+1WoKRBBe
         HdSw==
X-Forwarded-Encrypted: i=1; AJvYcCXRCCgI6Uc2ud/Sx5RiJPJUUCptwL6bVceaucXnhIS0E8YljtoS5E6A83nIB3EtZXK23A0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7jT35oVO45Yf1zSs/u5GlthQuWbs1bcMP+4b7kxltu443xRC4
	1cjAcPsQNlIl9XZJtur5rcNgqJjo8ncw6NXSpMvU3yByUTmDTH4wI7YymvvYlkcR/6gYZDRewzY
	pec7P5w==
X-Google-Smtp-Source: AGHT+IHsf5Q4hKwAqjzfrtBJQeOEWpiuWR1U3EUS3M0ncbeH1DJJyZF5orweh3oOIyC71bDEGVac2tYwtXY=
X-Received: from pjir1.prod.google.com ([2002:a17:90a:5c81:b0:31f:2a78:943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:270a:b0:32e:8c14:5d09
 with SMTP id 98e67ed59e1d1-33bcf86287fmr1924301a91.7.1760661194542; Thu, 16
 Oct 2025 17:33:14 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:33 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-16-seanjc@google.com>
Subject: [PATCH v3 15/25] KVM: TDX: ADD pages to the TD image while populating
 mirror EPT entries
From: Sean Christopherson <seanjc@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Ira Weiny <ira.weiny@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, Vishal Annapurve <vannapurve@google.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Ackerley Tng <ackerleytng@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

When populating the initial memory image for a TDX guest, ADD pages to the
TD as part of establishing the mappings in the mirror EPT, as opposed to
creating the mappings and then doing ADD after the fact.  Doing ADD in the
S-EPT callbacks eliminates the need to track "premapped" pages, as the
mirror EPT (M-EPT) and S-EPT are always synchronized, e.g. if ADD fails,
KVM reverts to the previous M-EPT entry (guaranteed to be !PRESENT).

Eliminating the hole where the M-EPT can have a mapping that doesn't exist
in the S-EPT in turn obviates the need to handle errors that are unique to
encountering a missing S-EPT entry (see tdx_is_sept_zap_err_due_to_premap()).

Keeping the M-EPT and S-EPT synchronized also eliminates the need to check
for unconsumed "premap" entries during tdx_td_finalize(), as there simply
can't be any such entries.  Dropping that check in particular reduces the
overall cognitive load, as the managemented of nr_premapped with respect
to removal of S-EPT is _very_ subtle.  E.g. successful removal of an S-EPT
entry after it completed ADD doesn't adjust nr_premapped, but it's not
clear why that's "ok" but having half-baked entries is not (it's not truly
"ok" in that removing pages from the image will likely prevent the guest
from booting, but from KVM's perspective it's "ok").

Doing ADD in the S-EPT path requires passing an argument via a scratch
field, but the current approach of tracking the number of "premapped"
pages effectively does the same.  And the "premapped" counter is much more
dangerous, as it doesn't have a singular lock to protect its usage, since
nr_premapped can be modified as soon as mmu_lock is dropped, at least in
theory.  I.e. nr_premapped is guarded by slots_lock, but only for "happy"
paths.

Note, this approach was used/tried at various points in TDX development,
but was ultimately discarded due to a desire to avoid stashing temporary
state in kvm_tdx.  But as above, KVM ended up with such state anyways,
and fully committing to using temporary state provides better access
rules (100% guarded by slots_lock), and makes several edge cases flat out
impossible.

Note #2, continue to extend the measurement outside of mmu_lock, as it's
a slow operation (typically 16 SEAMCALLs per page whose data is included
in the measurement), and doesn't *need* to be done under mmu_lock, e.g.
for consistency purposes.  However, MR.EXTEND isn't _that_ slow, e.g.
~1ms latency to measure a full page, so if it needs to be done under
mmu_lock in the future, e.g. because KVM gains a flow that can remove
S-EPT entries uring KVM_TDX_INIT_MEM_REGION, then extending the
measurement can also be moved into the S-EPT mapping path (again, only if
absolutely necessary).  P.S. _If_ MR.EXTEND is moved into the S-EPT path,
take care not to return an error up the stack if TDH_MR_EXTEND fails, as
removing the M-EPT entry but not the S-EPT entry would result in
inconsistent state!

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 114 ++++++++++++++---------------------------
 arch/x86/kvm/vmx/tdx.h |   8 ++-
 2 files changed, 45 insertions(+), 77 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index f4bab75d3ffb..76030461c8f7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1583,6 +1583,32 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
 }
 
+static int tdx_mem_page_add(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+			    kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	u64 err, entry, level_state;
+	gpa_t gpa = gfn_to_gpa(gfn);
+
+	lockdep_assert_held(&kvm->slots_lock);
+
+	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm) ||
+	    KVM_BUG_ON(!kvm_tdx->page_add_src, kvm))
+		return -EIO;
+
+	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
+			       kvm_tdx->page_add_src, &entry, &level_state);
+	if (unlikely(tdx_operand_busy(err)))
+		return -EBUSY;
+
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_PAGE_ADD, err, entry, level_state);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 			    enum pg_level level, kvm_pfn_t pfn)
 {
@@ -1624,19 +1650,10 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	/*
 	 * If the TD isn't finalized/runnable, then userspace is initializing
-	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
-	 * pages that need to be mapped and initialized via TDH.MEM.PAGE.ADD.
-	 * KVM_TDX_FINALIZE_VM checks the counter to ensure all mapped pages
-	 * have been added to the image, to prevent running the TD with a
-	 * valid mapping in the mirror EPT, but not in the S-EPT.
+	 * the VM image via KVM_TDX_INIT_MEM_REGION; ADD the page to the TD.
 	 */
-	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE)) {
-		if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
-			return -EIO;
-
-		atomic64_inc(&kvm_tdx->nr_premapped);
-		return 0;
-	}
+	if (unlikely(kvm_tdx->state != TD_STATE_RUNNABLE))
+		return tdx_mem_page_add(kvm, gfn, level, pfn);
 
 	return tdx_mem_page_aug(kvm, gfn, level, pfn);
 }
@@ -1662,39 +1679,6 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
-/*
- * Check if the error returned from a SEPT zap SEAMCALL is due to that a page is
- * mapped by KVM_TDX_INIT_MEM_REGION without tdh_mem_page_add() being called
- * successfully.
- *
- * Since tdh_mem_sept_add() must have been invoked successfully before a
- * non-leaf entry present in the mirrored page table, the SEPT ZAP related
- * SEAMCALLs should not encounter err TDX_EPT_WALK_FAILED. They should instead
- * find TDX_EPT_ENTRY_STATE_INCORRECT due to an empty leaf entry found in the
- * SEPT.
- *
- * Further check if the returned entry from SEPT walking is with RWX permissions
- * to filter out anything unexpected.
- *
- * Note: @level is pg_level, not the tdx_level. The tdx_level extracted from
- * level_state returned from a SEAMCALL error is the same as that passed into
- * the SEAMCALL.
- */
-static int tdx_is_sept_zap_err_due_to_premap(struct kvm_tdx *kvm_tdx, u64 err,
-					     u64 entry, int level)
-{
-	if (!err || kvm_tdx->state == TD_STATE_RUNNABLE)
-		return false;
-
-	if (err != (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))
-		return false;
-
-	if ((is_last_spte(entry, level) && (entry & VMX_EPT_RWX_MASK)))
-		return false;
-
-	return true;
-}
-
 static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, struct page *page)
 {
@@ -1714,12 +1698,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 		err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
 		tdx_no_vcpus_enter_stop(kvm);
 	}
-	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level)) {
-		if (KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm))
-			return -EIO;
-
-		return 0;
-	}
 
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_RANGE_BLOCK, err, entry, level_state);
@@ -2825,12 +2803,6 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 
 	if (!is_hkid_assigned(kvm_tdx) || kvm_tdx->state == TD_STATE_RUNNABLE)
 		return -EINVAL;
-	/*
-	 * Pages are pending for KVM_TDX_INIT_MEM_REGION to issue
-	 * TDH.MEM.PAGE.ADD().
-	 */
-	if (atomic64_read(&kvm_tdx->nr_premapped))
-		return -EINVAL;
 
 	cmd->hw_error = tdh_mr_finalize(&kvm_tdx->td);
 	if (tdx_operand_busy(cmd->hw_error))
@@ -3127,6 +3099,9 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	struct page *src_page;
 	int ret, i;
 
+	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
+		return -EIO;
+
 	/*
 	 * Get the source page if it has been faulted in. Return failure if the
 	 * source page has been swapped out or unmapped in primary memory.
@@ -3137,22 +3112,14 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (ret != 1)
 		return -ENOMEM;
 
+	kvm_tdx->page_add_src = src_page;
 	ret = kvm_tdp_mmu_map_private_pfn(arg->vcpu, gfn, pfn);
-	if (ret < 0)
-		goto out;
+	kvm_tdx->page_add_src = NULL;
 
-	ret = 0;
-	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
-			       src_page, &entry, &level_state);
-	if (err) {
-		ret = unlikely(tdx_operand_busy(err)) ? -EBUSY : -EIO;
-		goto out;
-	}
+	put_page(src_page);
 
-	KVM_BUG_ON(atomic64_dec_return(&kvm_tdx->nr_premapped) < 0, kvm);
-
-	if (!(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
-		goto out;
+	if (ret || !(arg->flags & KVM_TDX_MEASURE_MEMORY_REGION))
+		return ret;
 
 	/*
 	 * Note, MR.EXTEND can fail if the S-EPT mapping is somehow removed
@@ -3165,14 +3132,11 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 		err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry, &level_state);
 		if (KVM_BUG_ON(err, kvm)) {
 			pr_tdx_error_2(TDH_MR_EXTEND, err, entry, level_state);
-			ret = -EIO;
-			goto out;
+			return -EIO;
 		}
 	}
 
-out:
-	put_page(src_page);
-	return ret;
+	return 0;
 }
 
 static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index ca39a9391db1..1b00adbbaf77 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -36,8 +36,12 @@ struct kvm_tdx {
 
 	struct tdx_td td;
 
-	/* For KVM_TDX_INIT_MEM_REGION. */
-	atomic64_t nr_premapped;
+	/*
+	 * Scratch pointer used to pass the source page to tdx_mem_page_add.
+	 * Protected by slots_lock, and non-NULL only when mapping a private
+	 * pfn via tdx_gmem_post_populate().
+	 */
+	struct page *page_add_src;
 
 	/*
 	 * Prevent vCPUs from TD entry to ensure SEPT zap related SEAMCALLs do
-- 
2.51.0.858.gf9c4a03a3a-goog


