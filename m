Return-Path: <kvm+bounces-60249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD01BE5ED0
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 02:35:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AFF761A67CB4
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 00:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1D4E2701CE;
	Fri, 17 Oct 2025 00:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xDp0CWJm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F09625785F
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 00:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760661183; cv=none; b=StvCpCp/mkcmDJB5a8oxLm3sD/sM4fh8mHP3iORa5zwwf0DUEZMRr7EsZBA1Z8xhblhSIksHg71EcCLc47btsXjxRHHUT7WmMElLgjsNiuVQT4CVIMzpaTYV01GqgjEZgsTwJHomI7jcfBgNVtSc/qqHmRQxbfoBBiLCxRXUFA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760661183; c=relaxed/simple;
	bh=3mm/N8f8OCP3jzKgT6vjuBOSEtjI242afa4+FgXcNGc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OpZT7b7NPZm8bOxAjGX87Pl4w4RLce9M2eoXOlwrqyv9QNqSyntElUBSvJ0yOLZCzzwFwY3a/A0vD2S+oiFZW0xkNtV2TDW8i+jJh4ZPC+Aq13Wy8FDdZegM58GBZBrwy/iIeUphvqcCiPPZbWxy9ECEuiaQtEiTNsGcn7XMjuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xDp0CWJm; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b5527f0d39bso2012386a12.2
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 17:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760661181; x=1761265981; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=cf8N8Y56G5w6bizwE7Ci0y1MCMFb0ZkjYruE6L135MI=;
        b=xDp0CWJmVY3sva2IJSaUSpNPTcbI20xzw2p/R+PG4HGv2b6odOz79mt0LPrLMdC9XR
         0r0ys5MohshGFdWIA7bn8eOWUkRd/qiuzU4DMUFVFAHBRPT1wPBsGOASsNguc6QBMhKp
         c3bjBi2JRXYTfX9Za0v5TONW7if6vQUFiWFnFQPOXx5z7KN1W2QxNbKYp7Is9isBcGtD
         2xeX7P139uzaFdYzz0AjDpME0ZRcMuCu/20zXcdxPTQx7PjncCLIcYbLoZbLkFJSh0o8
         4D9VTmGUudMsH7C6mVdK70wF47fEOVbuvwetz7xCxYzTOEjwzQGPOdOCXJ+vYZIvOmBG
         ALVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760661181; x=1761265981;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cf8N8Y56G5w6bizwE7Ci0y1MCMFb0ZkjYruE6L135MI=;
        b=hpOSKE/+cKCXTGmR8Zb+EhL9d+DcdyWnL1PAVSk5/3GBPsLCjW1dl19nY3ptofd5oI
         0jaG40M4uouJp1TwDceRRwjmpo8QkZZiFVZfNjjqEurQjQ88bd86l8KHNDTtmBE2hVPd
         Avp8Ge2TBORaCutZuIOc6HB7h5hi0XVOE2VXUnaBDn3yea1frkLcUlkH9uHQgwq53jei
         5sIgmcCh9IxFyploq5I+tv15D6I0sYCPJdj+dukNnOhUSxkiekP7/f60hysQ0guGPHwF
         7Gd9OTYuf9aiqd7fYDYIcusItTZCWUMnmH8ulGkXreFdtVRHe+mOfh5ANd0JSRGTUpbe
         W7mg==
X-Forwarded-Encrypted: i=1; AJvYcCWHLliPTyjaU9nZNLHlLFsIXhOyjlYSLRXODeIX9CZXy767v2fNdHOLJmZUYmul+Ob2huE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0LnU5gaT26PrztN4AVM36CgB5ddvfGSHmTBMrgrCVac/9ngJH
	GqeRFseDKVYAAFYiobfUelgRK/XqJH38Yl9sHD33eSX6UeAz6x2kKhClRgWL1jbkLOfxiQ2jEWp
	8KYYVwg==
X-Google-Smtp-Source: AGHT+IFGX/O8rAylXetPrL4mM3U8URlaleqJu641GFX2gsiAqRo0BdBbaKA0U4x8ZGwd9In5RU4acPt36Xo=
X-Received: from pjbml22.prod.google.com ([2002:a17:90b:3616:b0:339:ae3b:2bc7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6300:2408:b0:334:a23e:2dff
 with SMTP id adf61e73a8af0-334a858f4e4mr1825671637.25.1760661180701; Thu, 16
 Oct 2025 17:33:00 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 17:32:25 -0700
In-Reply-To: <20251017003244.186495-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251017003244.186495-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251017003244.186495-8-seanjc@google.com>
Subject: [PATCH v3 07/25] KVM: TDX: Drop superfluous page pinning in S-EPT management
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
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/tdx.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 29f344af4cc2..c3bae6b96dc4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1583,29 +1583,22 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
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
 
@@ -1639,29 +1632,18 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
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
@@ -1712,7 +1694,6 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 	}
 	tdx_quirk_reset_page(page);
-	tdx_unpin(kvm, page);
 	return 0;
 }
 
@@ -1792,7 +1773,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
 	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
 		atomic64_dec(&kvm_tdx->nr_premapped);
-		tdx_unpin(kvm, page);
 		return 0;
 	}
 
-- 
2.51.0.858.gf9c4a03a3a-goog


