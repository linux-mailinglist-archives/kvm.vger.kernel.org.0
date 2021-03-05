Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E12632DEE2
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 02:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhCEBLh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Mar 2021 20:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230135AbhCEBLe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Mar 2021 20:11:34 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76014C06175F
        for <kvm@vger.kernel.org>; Thu,  4 Mar 2021 17:11:32 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 127so637374ybc.19
        for <kvm@vger.kernel.org>; Thu, 04 Mar 2021 17:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CpyO1bLY+et4cnAiq5PgmaeBbmTTXBzXB805b0dBnqM=;
        b=dttg1qcgKTyMunJKlRAKnYO2ttxUKcj6h43TL3OI6ijvDFUi+DndTw3BGQBJ0lNChq
         1i8i0Bp17Tm5KKxPcd0tWZSGsglTop8xkyUkelC7kf9wD9Np9Cgk+LGL0YqjVjR+jMlR
         Ie2aW6hDAV4io4aJjOsJQGbOYCeirgsizB1c8NI36KqmzzEsJJQIA47NbVsOTlS78DMc
         ULC07sjVLx2DaNZCiukX8zcgxguk2eVXzxULG5wNaNMj0LfADr1fvBjbClgf75BXXJzb
         hTrVD/fBfS1G+Gno71KAxkmvU/vxH1mb/FCP4QG/9Wu/K/WoTfpppCJN1vExPM5vSNHI
         L4Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CpyO1bLY+et4cnAiq5PgmaeBbmTTXBzXB805b0dBnqM=;
        b=Riuu7cZ+G+DmnabSc/3SndlTCbSH33qmB5zYHTmP1xAeCTVAA+toEHFNLjFGZ7x5ks
         ETBAqJm3icHSbUZAiNH/r9XIrT2CnRuK962mFdNG0WnnbVyLcHpVef6aZrjaJ5IN6dW8
         wlWpGZ7aCn8uzT/G8aNDyXw+UB3hGHO4ayqH9uT397qjmNm/7QZI5HDmMxTQC3hUpdGY
         OEWs1HixyTNJdsi/OwWnhgVDZlMJrxVuFWOX59OJbuyq2iq+V1PgQHa+osQaYnWxpZf1
         FV1uj/DE+LwCwM3sSmaPxxU5TtqiwO9wBK4MCaDNpOahXGHma/hrki8VaLd1gzRoaL9N
         xtyA==
X-Gm-Message-State: AOAM5328OQ1CLQiEXCasq24XYLlLw76tzdMrxtZCUB3Dr1Z514MEVOlu
        9JATX1LBWxKv4E0sTlevO0IOWwM8eXs=
X-Google-Smtp-Source: ABdhPJx8YVPFShL/JS75Gpw21pe+cAeXntITW+nY/6EOdR/wf3gaDcO2AiNXsF6B4wK8ePCbPksmVxQfS3M=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
 (user=seanjc job=sendgmr) by 2002:a25:442:: with SMTP id 63mr10110082ybe.131.1614906691755;
 Thu, 04 Mar 2021 17:11:31 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Mar 2021 17:10:55 -0800
In-Reply-To: <20210305011101.3597423-1-seanjc@google.com>
Message-Id: <20210305011101.3597423-12-seanjc@google.com>
Mime-Version: 1.0
References: <20210305011101.3597423-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v2 11/17] KVM: x86/mmu: Mark the PAE roots as decrypted for
 shadow paging
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
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
 arch/x86/kvm/mmu/mmu.c | 24 +++++++++++++++++++++++-
 arch/x86/kvm/svm/svm.c |  7 +++++--
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 09310c35fcf4..fa1aca21f6eb 100644
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
@@ -3377,7 +3378,10 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
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
@@ -5264,6 +5268,8 @@ slot_handle_leaf(struct kvm *kvm, struct kvm_memory_slot *memslot,
 
 static void free_mmu_pages(struct kvm_mmu *mmu)
 {
+	if (!tdp_enabled && mmu->pae_root)
+		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
 	free_page((unsigned long)mmu->pae_root);
 	free_page((unsigned long)mmu->lm_root);
 }
@@ -5301,6 +5307,22 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	for (i = 0; i < 4; ++i)
 		mmu->pae_root[i] = 0;
 
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
+	for (i = 0; i < 4; ++i)
+		mmu->pae_root[i] = 0;
+
 	return 0;
 }
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 54610270f66a..4769cf8bf2fd 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3908,15 +3908,18 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long cr3;
 
-	cr3 = __sme_set(root);
 	if (npt_enabled) {
-		svm->vmcb->control.nested_cr3 = cr3;
+		svm->vmcb->control.nested_cr3 = __sme_set(root);
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 
 		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
 		if (!test_bit(VCPU_EXREG_CR3, (ulong *)&vcpu->arch.regs_avail))
 			return;
 		cr3 = vcpu->arch.cr3;
+	} else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
+		cr3 = __sme_set(root);
+	} else {
+		cr3 = root;
 	}
 
 	svm->vmcb->save.cr3 = cr3;
-- 
2.30.1.766.gb4fecdf3b7-goog

