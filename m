Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CFA271F796
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 03:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbjFBBP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 21:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbjFBBP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 21:15:26 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A69D1A6
        for <kvm@vger.kernel.org>; Thu,  1 Jun 2023 18:15:23 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-561eb6c66f6so21327397b3.0
        for <kvm@vger.kernel.org>; Thu, 01 Jun 2023 18:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685668523; x=1688260523;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tmG5Gj4Mwq4ntwod8eDhcTKnVqwdZ3BWjaq2d7Ob80k=;
        b=uC2XLUjv1JyRrK7ep7CVM4ZlT2APqmo2uQ6DEC+UkTT7G4T5nodeNoub/YBwvFRguI
         PslfYWKsTdTj4HRUhOMESTHjjITLrF++g2d95YBnetmlqjkh4Lv7sHnfD84BU4IrrLr1
         Y5btKdmMLEjN0rli82gVKnmJetTXW7TIlzAhgKrhCFh2EB93DEqW98F0N4CKWyb3NKFe
         /4auYE/4xbSdPJJGl4joVAFDBd7DD7YCEKNCJGP22ATCcQktaQFTJ4boUisttl+4im18
         LgdVZ1pi3R27V3/VTdX4GGBBI6KUSrPwDxMKSZHt1pIbFB+sgE3lARNsbPLX286Nkozl
         rqlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685668523; x=1688260523;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tmG5Gj4Mwq4ntwod8eDhcTKnVqwdZ3BWjaq2d7Ob80k=;
        b=dj1O+ek9tJN/kdz07lh5p08MiUGGk0PpX0P1Qy9WytFx/KDsjmhJKtd2fJ++VMgH6B
         9uuLjO4rHEExxLTLx9w8UyKfKr+6nLKaVgOh7sd19wo6uh9Tl3tfDnrdaFfRxEHRLswF
         FGSNPySkNIhDmQXTQgyGgLTKivoUNlSAB6KfGMXGIQ0r/snx/Vjolq6BX7aVlXx+qQQW
         2KA7x6PHxgjpBl28yFg8rU8zgaAz4n+f36jkyJMNiic3FvMhKlV4ZSB4p5adnjAO9msC
         YypeBkzlbPqndHMDf8AbdXU6TROCwDCqsmc2mrTHwuCwt+23xl0fqqnu/tAJxtgp257Z
         9mPA==
X-Gm-Message-State: AC+VfDwzcUJ8+5+XdTB51gk3aZt3HF7AUqDqgXQL65UlR1pAh1j19vPf
        kH3l+q3eCrl7MmIAwLFAHxz/nOfP46I=
X-Google-Smtp-Source: ACHHUZ7j+p4pM6p9SvTqPZPmKRs6yjDhBW+n4Osich7yYjAeQUUKDzqfRrjSWym7Urrf7J8sCrbaGS8Bcjg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:c509:0:b0:552:b607:634b with SMTP id
 k9-20020a81c509000000b00552b607634bmr6259856ywi.4.1685668522848; Thu, 01 Jun
 2023 18:15:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  1 Jun 2023 18:15:16 -0700
In-Reply-To: <20230602011518.787006-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230602011518.787006-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.rc2.161.g9c6817b8e7-goog
Message-ID: <20230602011518.787006-2-seanjc@google.com>
Subject: [PATCH 1/3] KVM: VMX: Retry APIC-access page reload if invalidation
 is in-progress
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alistair Popple <apopple@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Re-request an APIC-access page reload if there is a relevant mmu_notifier
invalidation in-progress when KVM retrieves the backing pfn, i.e. stall
vCPUs until the backing pfn for the APIC-access page is "officially"
stable.  Relying on the primary MMU to not make changes after invoking
->invalidate_range() works, e.g. any additional changes to a PRESENT PTE
would also trigger an ->invalidate_range(), but using ->invalidate_range()
to fudge around KVM not honoring past and in-progress invalidations is a
bit hacky.

Honoring invalidations will allow using KVM's standard mmu_notifier hooks
to detect APIC-access page reloads, which will in turn allow removing
KVM's implementation of ->invalidate_range() (the APIC-access page case is
a true one-off).

Opportunistically add a comment to explain why doing nothing if a memslot
isn't found is functionally correct.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 50 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 45 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 44fb619803b8..59195f0dc7a5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6708,7 +6708,12 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
 
 static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 {
-	struct page *page;
+	const gfn_t gfn = APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT;
+	struct kvm *kvm = vcpu->kvm;
+	struct kvm_memslots *slots = kvm_memslots(kvm);
+	struct kvm_memory_slot *slot;
+	unsigned long mmu_seq;
+	kvm_pfn_t pfn;
 
 	/* Defer reload until vmcs01 is the current VMCS. */
 	if (is_guest_mode(vcpu)) {
@@ -6720,18 +6725,53 @@ static void vmx_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 	    SECONDARY_EXEC_VIRTUALIZE_APIC_ACCESSES))
 		return;
 
-	page = gfn_to_page(vcpu->kvm, APIC_DEFAULT_PHYS_BASE >> PAGE_SHIFT);
-	if (is_error_page(page))
+	/*
+	 * Grab the memslot so that the hva lookup for the mmu_notifier retry
+	 * is guaranteed to use the same memslot as the pfn lookup, i.e. rely
+	 * on the pfn lookup's validation of the memslot to ensure a valid hva
+	 * is used for the retry check.
+	 */
+	slot = id_to_memslot(slots, APIC_ACCESS_PAGE_PRIVATE_MEMSLOT);
+	if (!slot || slot->flags & KVM_MEMSLOT_INVALID)
 		return;
 
-	vmcs_write64(APIC_ACCESS_ADDR, page_to_phys(page));
+	/*
+	 * Ensure that the mmu_notifier sequence count is read before KVM
+	 * retrieves the pfn from the primary MMU.  Note, the memslot is
+	 * protected by SRCU, not the mmu_notifier.  Pairs with the smp_wmb()
+	 * in kvm_mmu_invalidate_end().
+	 */
+	mmu_seq = kvm->mmu_invalidate_seq;
+	smp_rmb();
+
+	/*
+	 * No need to retry if the memslot does not exist or is invalid.  KVM
+	 * controls the APIC-access page memslot, and only deletes the memslot
+	 * if APICv is permanently inhibited, i.e. the memslot won't reappear.
+	 */
+	pfn = gfn_to_pfn_memslot(slot, gfn);
+	if (is_error_noslot_pfn(pfn))
+		return;
+
+	read_lock(&vcpu->kvm->mmu_lock);
+	if (mmu_invalidate_retry_hva(kvm, mmu_seq,
+				     gfn_to_hva_memslot(slot, gfn))) {
+		kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
+		read_unlock(&vcpu->kvm->mmu_lock);
+		goto out;
+	}
+
+	vmcs_write64(APIC_ACCESS_ADDR, pfn_to_hpa(pfn));
+	read_unlock(&vcpu->kvm->mmu_lock);
+
 	vmx_flush_tlb_current(vcpu);
 
+out:
 	/*
 	 * Do not pin apic access page in memory, the MMU notifier
 	 * will call us again if it is migrated or swapped out.
 	 */
-	put_page(page);
+	kvm_release_pfn_clean(pfn);
 }
 
 static void vmx_hwapic_isr_update(int max_isr)
-- 
2.41.0.rc2.161.g9c6817b8e7-goog

