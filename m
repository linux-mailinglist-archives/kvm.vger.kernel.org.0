Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCABC3331AA
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 23:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbhCIWme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 17:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbhCIWmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Mar 2021 17:42:24 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5E0C06175F
        for <kvm@vger.kernel.org>; Tue,  9 Mar 2021 14:42:23 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id s187so19045058ybs.22
        for <kvm@vger.kernel.org>; Tue, 09 Mar 2021 14:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ZCcijjOapg1QfLSW5pXm/pEGIGsY5zGSFUclPuMLRrU=;
        b=Ka6Q2KV9oKbUwNMAtkfqhzyygrpwjUKJVNSh9cGOTU+JKNsOmL2ijkXvlzh/7xllPH
         GT94sUKQ+TeH08Yu3/t61gUG3ysV/FHOjeXupzOwY386eJA7lYJbe8VBbwNndoojIr8O
         dQ5CP8HbuHA/+W96UJVeec3rFWquzFDD8WdggMb+tMzPgeP4nDC3avsqDx2Fuqw0xC12
         tincV7nAebvFMSHX+3+QG6vCs5wzZybIliv2YggU/ECUPlz0iHtZ26OMv7DV3AFjUz5S
         dS0Vf3ufhu3U+9o3XD5Nr+ADZ5aj80sMJUSeQ0bEYrReuPTj5u/GIksGYi8iUvZ0oW/B
         2Qjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ZCcijjOapg1QfLSW5pXm/pEGIGsY5zGSFUclPuMLRrU=;
        b=Q4yITVlLlxsVMDsl9cuO/vhxHEbhhjAS8sg51hFiorlcVAdPpiyWDUii600mmeDTwY
         bokfSKbCVQcS9Qb7+74BIyF5IW7FgpN3zkbMuCfr4WP6SYlSc88qRY3aNcSbBzmk0t7C
         alfqSCmOIovYuqYi6xwlHuRLCTsukqnuaUSmWCpUMWYIbuD0phlmaV7j4lPQigpgdtDg
         B0g61RYpJcFQt+dpEfm7tkK+Jj38AFySqZA5YByBBURBZkdyyzYimPCI70L4H723iYOK
         qiYWE5k8xNfzUoAPMZItnBX4+QWwxg8CrOp15ilbtAN/ZT7aS6KwCUplkPSCeYZCG1aZ
         fHAA==
X-Gm-Message-State: AOAM530YMb74Ks2DsnZV4xOTSXBi55bK7uql1e4jYyZ5jFOCgD9NBl+w
        N2EHrlgG4/156alCfiB4idO2yB//qN0=
X-Google-Smtp-Source: ABdhPJw7Ygss7b6NJViF19DgNNTwghaiMvMFHvfIkteutHyQ89ttNtYn5UuFtFI3UEt3A4eUl5v3SWkTzio=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e4dd:6c31:9463:f8da])
 (user=seanjc job=sendgmr) by 2002:a25:c793:: with SMTP id w141mr91195ybe.29.1615329743155;
 Tue, 09 Mar 2021 14:42:23 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue,  9 Mar 2021 14:42:07 -0800
In-Reply-To: <20210309224207.1218275-1-seanjc@google.com>
Message-Id: <20210309224207.1218275-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210309224207.1218275-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 4/4] KVM: x86/mmu: Mark the PAE roots as decrypted for
 shadow paging
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set the PAE roots used as decrypted to play nice with SME when KVM is
using shadow paging.  Explicitly skip setting the C-bit when loading
CR3 for PAE shadow paging, even though it's completely ignored by the
CPU.  The extra documentation is nice to have.

Note, there are several subtleties at play with NPT.  In addition to
legacy shadow paging, the PAE roots are used for SVM's NPT when either
KVM is 32-bit (uses PAE paging) or KVM is 64-bit and shadowing 32-bit
NPT.  However, 32-bit Linux, and thus KVM, doesn't support SME.  And
64-bit KVM can happily set the C-bit in CR3.  This also means that
keeping __sme_set(root) for 32-bit KVM when NPT is enabled is
conceptually wrong, but functionally ok since SME is 64-bit only.
Leave it as is to avoid unnecessary pollution.

Fixes: d0ec49d4de90 ("kvm/x86/svm: Support Secure Memory Encryption within KVM")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 22 +++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c |  5 ++---
 2 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6b0576ff2846..c6ed633594a2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -48,6 +48,7 @@
 #include <asm/memtype.h>
 #include <asm/cmpxchg.h>
 #include <asm/io.h>
+#include <asm/set_memory.h>
 #include <asm/vmx.h>
 #include <asm/kvm_page_track.h>
 #include "trace.h"
@@ -3388,7 +3389,10 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->lm_root))
 		return -EIO;
 
-	/* Unlike 32-bit NPT, the PDP table doesn't need to be in low mem. */
+	/*
+	 * Unlike 32-bit NPT, the PDP table doesn't need to be in low mem, and
+	 * doesn't need to be decrypted.
+	 */
 	pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!pae_root)
 		return -ENOMEM;
@@ -5274,6 +5278,8 @@ slot_handle_leaf(struct kvm *kvm, struct kvm_memory_slot *memslot,
 
 static void free_mmu_pages(struct kvm_mmu *mmu)
 {
+	if (!tdp_enabled && mmu->pae_root)
+		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
 	free_page((unsigned long)mmu->pae_root);
 	free_page((unsigned long)mmu->lm_root);
 }
@@ -5308,6 +5314,20 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 		return -ENOMEM;
 
 	mmu->pae_root = page_address(page);
+
+	/*
+	 * CR3 is only 32 bits when PAE paging is used, thus it's impossible to
+	 * get the CPU to treat the PDPTEs as encrypted.  Decrypt the page so
+	 * that KVM's writes and the CPU's reads get along.  Note, this is
+	 * only necessary when using shadow paging, as 64-bit NPT can get at
+	 * the C-bit even when shadowing 32-bit NPT, and SME isn't supported
+	 * by 32-bit kernels (when KVM itself uses 32-bit NPT).
+	 */
+	if (!tdp_enabled)
+		set_memory_decrypted((unsigned long)mmu->pae_root, 1);
+	else
+		WARN_ON_ONCE(shadow_me_mask);
+
 	for (i = 0; i < 4; ++i)
 		mmu->pae_root[i] = INVALID_PAE_ROOT;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58f4dc0e7864..271196400495 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3907,9 +3907,8 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long cr3;
 
-	root_hpa = __sme_set(root_hpa);
 	if (npt_enabled) {
-		svm->vmcb->control.nested_cr3 = root_hpa;
+		svm->vmcb->control.nested_cr3 = __sme_set(root_hpa);
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 
 		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
@@ -3917,7 +3916,7 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			return;
 		cr3 = vcpu->arch.cr3;
 	} else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
-		cr3 = root_hpa | kvm_get_active_pcid(vcpu);
+		cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
 	} else {
 		/* PCID in the guest should be impossible with a 32-bit MMU. */
 		WARN_ON_ONCE(kvm_get_active_pcid(vcpu));
-- 
2.30.1.766.gb4fecdf3b7-goog

