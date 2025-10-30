Return-Path: <kvm+bounces-61545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E973C222FD
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 21:17:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BD62B4F35DA
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 20:15:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8BA1384BB0;
	Thu, 30 Oct 2025 20:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="essL5lre"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACDB385591
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 20:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761855043; cv=none; b=CaxgJoMkO9GF9IIeZ37W9xKbXfF6wkfdcTdJ877NbaTF2b2FoXHIPo68FzDj2tCNPrt/WS4YoGUaRhgtEK8MfHMbpzpr+CL0hm7MTjEB4Yo3/9CX8QAHDehgdixqi2ZXo21EEOgue8ynbKMdT3JV/VYjwO9RCdrJj16+btWZit8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761855043; c=relaxed/simple;
	bh=+XhvZIclD177VOUPtwPNVFoxhAZfUY1LBy39FhUfjiQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FESIapf0EtFnwm6nJO7D8g12/XRCzYtjxKi4sJSoXrsR9GIDfO4ff0I2D7ZiL1gJOCHnEe/lsQexs1HcjR0MKRp+XQwt3Tj9+s8pwL50TutRQE/K5g2nf1gu5rhg3Q9/lcW9aBX69uMTlV3aQAhbDS0qAN0bjgarYB3OGtmhqig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=essL5lre; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-290b13c5877so27973325ad.0
        for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 13:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761855041; x=1762459841; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hYFILgw2CVVObdwN7Nbx6skzXKtVXg762axcq16ft10=;
        b=essL5lreFVSM6gum8iNQwnds5Wgyq1DJDTP4WzzoZ3Ew7czCACL0Z8NxfEC5ppnJmc
         ENyXPOv0eHYoChyQ9v6e4hSVA/C9o0GCfvKbLz/O5la0LO7DJTI+PD6H21wwk0JFWNZC
         WpVa/l+FoWt0fUJK9jyBAR4DR6jOfb2Jzeh9MPI5qoHxk45f0/XD/gv8g/pRSMBuCmSP
         oe4d1qS0IpXlpsspTnXgSt8u7lzaAMAzUoVwK/iaSLMgRDeaskl/JnJN7C0im2sxM2k3
         P4PTcIyMrxTTGv/udDxAkAkPzRD+CNGtRotvpNMwDKTqQKgCzb2Fh5P2/GunCfeSA4/t
         sWJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761855041; x=1762459841;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hYFILgw2CVVObdwN7Nbx6skzXKtVXg762axcq16ft10=;
        b=ES3jDWC5Rc3egRvO7PW99ffihrSWepVL2yp7emno8fSOtOai0Gj2hE7NbjJ4YhxICF
         OtGbXWjmhBoIvslHBAvhplpDEGGTUZxyLjwNKxKkfOFYK+m5zzMETCPvNcfI3gMTye6w
         hyJs4BxqKBjnBJGE8MUT9qFer4YKtSJJmA4E5pkFZp2RLZ8cEU0c8JNQKjNAXmsMhs0d
         0eXoyqDZ+TKzItdzqOtowxGsbGquCWagfGCrgFJ0A75rl2Q5V12ny/yGwXKRhDeZPLWc
         uUbtfYQ7ZzoCYg2ohiLzJIl+T1tbro0E7iZQa0SZMDKBxJ3xx48BHO9SD3JXtlYkfGuA
         YX0w==
X-Forwarded-Encrypted: i=1; AJvYcCWWRz9PYYWWe0q5EUY32n1uqAacZZX0ulDJggIKglLh3a33LExfiFN77ce8lYGNY46kJyo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxwb3q67/0UTh6WeFT3pivTWHqYKE/ZrhzoWHvLB+Pp4eC0Df6n
	N6oEtusjYJDjo9tHFSDj62EVTME1zT8lU3crT+aL/lB0MC+q+tnLSvxkV7TeTVU6kC/Rq1iiu/3
	8KVIZ5Q==
X-Google-Smtp-Source: AGHT+IFdPBSucKFDy/U8TuJaqtYrp9bGJQyMq5Xu07f53oKQ6VYIKj4rbtZlkuu2LLkkKnC3ZIl4E+FjLT8=
X-Received: from plsh10.prod.google.com ([2002:a17:902:b94a:b0:28e:7ea0:ac4a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f682:b0:272:a900:c42e
 with SMTP id d9443c01a7336-2951a4dfd2emr11837385ad.35.1761855040990; Thu, 30
 Oct 2025 13:10:40 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 30 Oct 2025 13:09:39 -0700
In-Reply-To: <20251030200951.3402865-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251030200951.3402865-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.1.930.gacf6e81ea2-goog
Message-ID: <20251030200951.3402865-17-seanjc@google.com>
Subject: [PATCH v4 16/28] KVM: TDX: ADD pages to the TD image while populating
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
	Kai Huang <kai.huang@intel.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
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
overall cognitive load, as the management of nr_premapped with respect
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
S-EPT entries during KVM_TDX_INIT_MEM_REGION, then extending the
measurement can also be moved into the S-EPT mapping path (again, only if
absolutely necessary).  P.S. _If_ MR.EXTEND is moved into the S-EPT path,
take care not to return an error up the stack if TDH_MR_EXTEND fails, as
removing the M-EPT entry but not the S-EPT entry would result in
inconsistent state!

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 106 ++++++++++++++---------------------------
 arch/x86/kvm/vmx/tdx.h |   8 +++-
 2 files changed, 43 insertions(+), 71 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a30471c972ba..cfdf8d262756 100644
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
@@ -1628,19 +1654,10 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	/*
 	 * If the TD isn't finalized/runnable, then userspace is initializing
-	 * the VM image via KVM_TDX_INIT_MEM_REGION.  Increment the number of
-	 * pages that need to be mapped and initialized via TDH.MEM.PAGE.ADD.
-	 * KVM_TDX_FINALIZE_VM checks the counter to ensure all pre-mapped
-	 * pages have been added to the image, to prevent running the TD with a
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
@@ -1666,39 +1683,6 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
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
@@ -1718,12 +1702,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
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
@@ -2829,12 +2807,6 @@ static int tdx_td_finalize(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
 
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
@@ -3131,6 +3103,9 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	struct page *src_page;
 	int ret, i;
 
+	if (KVM_BUG_ON(kvm_tdx->page_add_src, kvm))
+		return -EIO;
+
 	/*
 	 * Get the source page if it has been faulted in. Return failure if the
 	 * source page has been swapped out or unmapped in primary memory.
@@ -3141,19 +3116,14 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
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
+	if (ret)
+		return ret;
 
 	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
 		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
@@ -3166,8 +3136,6 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 		}
 	}
 
-out:
-	put_page(src_page);
 	return ret;
 }
 
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
2.51.1.930.gacf6e81ea2-goog


