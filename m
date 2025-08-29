Return-Path: <kvm+bounces-56210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EDA20B3AED2
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 02:07:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA350A00CCE
	for <lists+kvm@lfdr.de>; Fri, 29 Aug 2025 00:07:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D8151B4247;
	Fri, 29 Aug 2025 00:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K78A8uzY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399341990D9
	for <kvm@vger.kernel.org>; Fri, 29 Aug 2025 00:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756425992; cv=none; b=cU3SRirbGypyAgQiAq0/g2hTQ5zt2Phw98IBQBDR7er1zohEl0vccNZsECOAp3v8nB3MuomiflMFVes02EpG+dGkCe8loNIWSNmezwGoHSQaoFE+rgH5opGijEQekGBDe7QG6seW06GBPlP2ky1bBH5MQbw59ULoUVBcGzg8+Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756425992; c=relaxed/simple;
	bh=mJfwIk8zt4v2vwPMXySyeVbwDMhDnveaRkJ0ykfhjFE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j2hsQciehAJWD5P+gzfPNJMkvpPUfNnysZ+CE8vKQ2FnKxMbd1mb584comhUarJbkd6D2V8SXT5Ht26HPl/HDCDUQT4qAN4tjNn2M8uC0tweYc+Gn4NJezR+q4NMNlpvc9Rr6K6TtJbDmsIs7P0NNbN5hhg+xBcxc2SAY9J2vqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K78A8uzY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-325e31cecd6so1350065a91.3
        for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 17:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756425990; x=1757030790; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=wV1Wcluuc6pxP1WLIJ1v7G0uRRxI7XfMddwIt6Dax6U=;
        b=K78A8uzYtqvFpR8f47ABNQ2qnhkr0v3hzt8C7x731dpBd6vCDRxlzzNNuYyhA2k6xf
         S+qAxGH1SSArqNhF+uFvtSjPOALkP5eeF0wubW4B9eDbx3YoLeBSGrQxxaBd3ndr9SNv
         ESWxGmDqsdJI/socji+OgUfplCgftzi5ch7ZC4OjkqzOBsXOKOIzdgo+/4jUSMTY7ok7
         fNj4u2XwVAJetY/z/J6teWVRnwITMJDgwEbhzuGN5egMEgum8U9JeCAU8N7iU7YtoGUQ
         r3/625ud/xjB1KJuZXNmWL8xqcoc+nQEQIPigqoxVfsiv9FMO6xL9SkBiQrQkarXf0u0
         47Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756425990; x=1757030790;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wV1Wcluuc6pxP1WLIJ1v7G0uRRxI7XfMddwIt6Dax6U=;
        b=qvyk0YHXHy5pNXyzvFsRepUvXs8vwsstokG52zR0IPCU1mqvbkGKdd0AHA3Sa5AuMD
         OWKdRMnSi0AwKiggOE+akGcqLoz6L1NnAgkGxdxxZFlqFSU1ITRU5nxjUMfG7A8uE488
         xVLtRUUnlUaX0+X5TuJMiccrLl74zwZ6WYWVLhqHfpw8JGdzt7rd2vN6y7enYAJOExP9
         CEmjA72hre9W6uzeOfIIwF+EBF5Xb1HHnrFdM/11Pmg7NpysI1mOMj/L/3nygSGrhJ+Y
         Oj55E1fZfrNEASgCFeLryZTvTmZpoLAn9eD1UV1o9IkkZ4kRK+kBhlcVf6FLGV/d2qLS
         cH9g==
X-Gm-Message-State: AOJu0YwJ5oprF5uuOX9TD6D5ccMFL4pIZsPR5EYj+pR2tTKKxQjtkU+2
	fPBuyEOBaUHZc27ayDAtjNzcrtKUb6/Egn8A1wSZsByBHBvr/Cvn6ihf/bX1Bm10njbCVBCPZ7w
	mep/+bg==
X-Google-Smtp-Source: AGHT+IGfNSHJC1tKpnIi9nf7ERhW+CnNYjAM/RgFZvKWfrFvpVxfSo19+e7Hp391VLd1R2FN0hILyDkjQJU=
X-Received: from pjyp15.prod.google.com ([2002:a17:90a:e70f:b0:312:e266:f849])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:384c:b0:31e:d9f0:9b96
 with SMTP id 98e67ed59e1d1-32515ef8acbmr32399421a91.14.1756425990471; Thu, 28
 Aug 2025 17:06:30 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 28 Aug 2025 17:06:05 -0700
In-Reply-To: <20250829000618.351013-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250829000618.351013-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
Message-ID: <20250829000618.351013-6-seanjc@google.com>
Subject: [RFC PATCH v2 05/18] KVM: TDX: Drop superfluous page pinning in S-EPT management
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ira Weiny <ira.weiny@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Yan Zhao <yan.y.zhao@intel.com>

Don't explicitly pin pages when mapping pages into the S-EPT, guest_memfd
doesn't support page migration in any capacity, i.e. there are no migrate
callbacks because guest_memfd pages *can't* be migrated.  See the WARN in
kvm_gmem_migrate_folio().

Eliminating TDX's explicit pinning will also enable guest_memfd to support
in-place conversion between shared and private memory[1][2].  Because KVM
cannot distinguish between speculative/transient refcounts and the
intentional refcount for TDX on private pages[3], failing to release
private page refcount in TDX could cause guest_memfd to indefinitely wait
on decreasing the refcount for the splitting.

Under normal conditions, not holding an extra page refcount in TDX is safe
because guest_memfd ensures pages are retained until its invalidation
notification to KVM MMU is completed. However, if there're bugs in KVM/TDX
module, not holding an extra refcount when a page is mapped in S-EPT could
result in a page being released from guest_memfd while still mapped in the
S-EPT.  But, doing work to make a fatal error slightly less fatal is a net
negative when that extra work adds complexity and confusion.

Several approaches were considered to address the refcount issue, including
  - Attempting to modify the KVM unmap operation to return a failure,
    which was deemed too complex and potentially incorrect[4].
 - Increasing the folio reference count only upon S-EPT zapping failure[5].
 - Use page flags or page_ext to indicate a page is still used by TDX[6],
   which does not work for HVO (HugeTLB Vmemmap Optimization).
  - Setting HWPOISON bit or leveraging folio_set_hugetlb_hwpoison()[7].

Due to the complexity or inappropriateness of these approaches, and the
fact that S-EPT zapping failure is currently only possible when there are
bugs in the KVM or TDX module, which is very rare in a production kernel,
a straightforward approach of simply not holding the page reference count
in TDX was chosen[8].

When S-EPT zapping errors occur, KVM_BUG_ON() is invoked to kick off all
vCPUs and mark the VM as dead. Although there is a potential window that a
private page mapped in the S-EPT could be reallocated and used outside the
VM, the loud warning from KVM_BUG_ON() should provide sufficient debug
information. To be robust against bugs, the user can enable panic_on_warn
as normal.

Link: https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com [1]
Link: https://youtu.be/UnBKahkAon4 [2]
Link: https://lore.kernel.org/all/CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com [3]
Link: https://lore.kernel.org/all/aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com [4]
Link: https://lore.kernel.org/all/aE%2Fq9VKkmaCcuwpU@yzhao56-desk.sh.intel.com [5]
Link: https://lore.kernel.org/all/aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com [6]
Link: https://lore.kernel.org/all/diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com [7]
Link: https://lore.kernel.org/all/53ea5239f8ef9d8df9af593647243c10435fd219.camel@intel.com [8]
Suggested-by: Vishal Annapurve <vannapurve@google.com>
Suggested-by: Ackerley Tng <ackerleytng@google.com>
Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
[sean: extract out of hugepage series, massage changelog accordingly]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c83e1ff02827..f24f8635b433 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1586,29 +1586,22 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
 }
 
-static void tdx_unpin(struct kvm *kvm, struct page *page)
-{
-	put_page(page);
-}
-
 static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
-			    enum pg_level level, struct page *page)
+			    enum pg_level level, kvm_pfn_t pfn)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct page *page = pfn_to_page(pfn);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 entry, level_state;
 	u64 err;
 
 	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &entry, &level_state);
-	if (unlikely(tdx_operand_busy(err))) {
-		tdx_unpin(kvm, page);
+	if (unlikely(tdx_operand_busy(err)))
 		return -EBUSY;
-	}
 
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state);
-		tdx_unpin(kvm, page);
 		return -EIO;
 	}
 
@@ -1642,29 +1635,18 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, kvm_pfn_t pfn)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	struct page *page = pfn_to_page(pfn);
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
 		return -EINVAL;
 
-	/*
-	 * Because guest_memfd doesn't support page migration with
-	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
-	 * migration.  Until guest_memfd supports page migration, prevent page
-	 * migration.
-	 * TODO: Once guest_memfd introduces callback on page migration,
-	 * implement it and remove get_page/put_page().
-	 */
-	get_page(page);
-
 	/*
 	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
 	 * barrier in tdx_td_finalize().
 	 */
 	smp_rmb();
 	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
-		return tdx_mem_page_aug(kvm, gfn, level, page);
+		return tdx_mem_page_aug(kvm, gfn, level, pfn);
 
 	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
 }
@@ -1715,7 +1697,6 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 	}
 	tdx_clear_page(page);
-	tdx_unpin(kvm, page);
 	return 0;
 }
 
@@ -1795,7 +1776,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
 	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
 		atomic64_dec(&kvm_tdx->nr_premapped);
-		tdx_unpin(kvm, page);
 		return 0;
 	}
 
-- 
2.51.0.318.gd7df087d1a-goog


