Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 252D03E31B3
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 00:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245490AbhHFWWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 18:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242400AbhHFWWv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 18:22:51 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F593C0613CF
        for <kvm@vger.kernel.org>; Fri,  6 Aug 2021 15:22:34 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i32-20020a25b2200000b02904ed415d9d84so10841947ybj.0
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 15:22:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=g3qzh/XYkFSuJH17Zhqk8ubyu4zK8wp1E2+k23JA6dY=;
        b=V43k8sAyNKVDT4vX59eGRgubbPPFIsQCVsfVoX2fpaNNxu42SzwwjGZxvAhXJMraIk
         UcWYb6dO/e53CDmtno1ZUeAo3fI2g4BDq+beWKOYcZMaTCiHaoLgubXttL6KRkgdkWBR
         Ty9F471RHLj6sQlc1x8nfDa6WV1HO0xRP4KhTwgHxwwI7Q+iD0tHXerOt0mrsFAzcyoA
         CrvBCHbzU550YG7RgWlFuz3IOqdbRp0tcQaY6a1VxTtJEfLV687pWrDwqUKHQOq1Wr9X
         /OyFSgF6RpyYtA+JpTqlCP0sgf+EfzNRm34+c4cBkk1u4YELMTgDUdZxoctBZPO3HmNz
         fegw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=g3qzh/XYkFSuJH17Zhqk8ubyu4zK8wp1E2+k23JA6dY=;
        b=XJFcRijxeaLdCB0In4M9pSIUdZdZgyDcFWBA/hAQ0zCjuefM2caRayN4QQ5wgNfhiI
         lXgVH4UIzkV3DhpQ8ZfHz0g/9YUd790DWuYvKtzQgrBig9Fjfw7rXjlpVQkpGCJ3rct7
         EWrJwJX0qJAL9t4clpR6VJGVKLeSwYkalFKnRHfbDnVXDey/LwMkqPV7SOksI200VgQL
         tKBZuF6x8XX63TzW6l2dNUF3VFQmHNqOnRCHtX1aOpf5nSzd4090uykcEy4ikKEYCgpp
         P5GOLl2HOw37WfzLXaLqCnw2JWNJeb2pBFZX/69Y1u1HmHJ1UmTYGZwQv/nPjjw4HqAp
         WQdA==
X-Gm-Message-State: AOAM5318iU1leB/NN61OuyebyK0Ib+/jRYFpdfPp93jUgZAVfNjLbY2Y
        nRZ+3ajVIEO2cQw6/OLFB8WrHi0uyzBCr2CALkvihQq5N6+A+C7K2uHiSlH1PLy9DLOD1h/wtRF
        zgYmvMG6DuEG5pLeWm8Tw2cn1kzQGeIgET+/qKmSPgSOx7dqyP05ybVeqS3Nu
X-Google-Smtp-Source: ABdhPJyme9SdTT3QWg11+t6l7nNXKrbpNxOq9neWn5CWS3RHjjj5yht+S7nYe2LhlYL+GAiYegCybekQ9WBl
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:fd69:7ebb:28df:b2cf])
 (user=junaids job=sendgmr) by 2002:a25:5cc:: with SMTP id 195mr15624095ybf.304.1628288553630;
 Fri, 06 Aug 2021 15:22:33 -0700 (PDT)
Date:   Fri,  6 Aug 2021 15:22:29 -0700
Message-Id: <20210806222229.1645356-1-junaids@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH] kvm: vmx: Sync all matching EPTPs when injecting nested EPT fault
From:   Junaid Shahid <junaids@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, jmattson@google.com, bgardon@google.com,
        pshier@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When a nested EPT violation/misconfig is injected into the guest,
the shadow EPT PTEs associated with that address need to be synced.
This is done by kvm_inject_emulated_page_fault() before it calls
nested_ept_inject_page_fault(). However, that will only sync the
shadow EPT PTE associated with the current L1 EPTP. Since the ASID
is based on EP4TA rather than the full EPTP, so syncing the current
EPTP is not enough. The SPTEs associated with any other L1 EPTPs
in the prev_roots cache with the same EP4TA also need to be synced.

Signed-off-by: Junaid Shahid <junaids@google.com>
---
 arch/x86/kvm/vmx/nested.c | 53 ++++++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1a52134b0c42..cd506af1d1b6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -330,6 +330,31 @@ void nested_vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	vcpu_put(vcpu);
 }
 
+#define EPTP_PA_MASK   GENMASK_ULL(51, 12)
+
+static bool nested_ept_root_matches(hpa_t root_hpa, u64 root_eptp, u64 eptp)
+{
+	return VALID_PAGE(root_hpa) &&
+	       ((root_eptp & EPTP_PA_MASK) == (eptp & EPTP_PA_MASK));
+}
+
+static void nested_ept_invalidate_addr(struct kvm_vcpu *vcpu, gpa_t eptp,
+				       gpa_t addr)
+{
+	uint i;
+	struct kvm_mmu_root_info *cached_root;
+
+	WARN_ON_ONCE(!mmu_is_nested(vcpu));
+
+	for (i = 0; i < KVM_MMU_NUM_PREV_ROOTS; i++) {
+		cached_root = &vcpu->arch.mmu->prev_roots[i];
+
+		if (nested_ept_root_matches(cached_root->hpa, cached_root->pgd,
+					    eptp))
+			vcpu->arch.mmu->invlpg(vcpu, addr, cached_root->hpa);
+	}
+}
+
 static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 		struct x86_exception *fault)
 {
@@ -342,10 +367,22 @@ static void nested_ept_inject_page_fault(struct kvm_vcpu *vcpu,
 		vm_exit_reason = EXIT_REASON_PML_FULL;
 		vmx->nested.pml_full = false;
 		exit_qualification &= INTR_INFO_UNBLOCK_NMI;
-	} else if (fault->error_code & PFERR_RSVD_MASK)
-		vm_exit_reason = EXIT_REASON_EPT_MISCONFIG;
-	else
-		vm_exit_reason = EXIT_REASON_EPT_VIOLATION;
+	} else {
+		if (fault->error_code & PFERR_RSVD_MASK)
+			vm_exit_reason = EXIT_REASON_EPT_MISCONFIG;
+		else
+			vm_exit_reason = EXIT_REASON_EPT_VIOLATION;
+
+		/*
+		 * Although the caller (kvm_inject_emulated_page_fault) would
+		 * have already synced the faulting address in the shadow EPT
+		 * tables for the current L1 EPTP, we also need to sync it for
+		 * any other cached L1 EPTPs that share the same EP4TA, since
+		 * the ASID is derived from the EP4TA rather than the full EPTP.
+		 */
+		nested_ept_invalidate_addr(vcpu, vmcs12->ept_pointer,
+					   fault->address);
+	}
 
 	nested_vmx_vmexit(vcpu, vm_exit_reason, 0, exit_qualification);
 	vmcs12->guest_physical_address = fault->address;
@@ -5325,14 +5362,6 @@ static int handle_vmptrst(struct kvm_vcpu *vcpu)
 	return nested_vmx_succeed(vcpu);
 }
 
-#define EPTP_PA_MASK   GENMASK_ULL(51, 12)
-
-static bool nested_ept_root_matches(hpa_t root_hpa, u64 root_eptp, u64 eptp)
-{
-	return VALID_PAGE(root_hpa) &&
-		((root_eptp & EPTP_PA_MASK) == (eptp & EPTP_PA_MASK));
-}
-
 /* Emulate the INVEPT instruction */
 static int handle_invept(struct kvm_vcpu *vcpu)
 {
-- 
2.32.0.605.g8dce9f2422-goog

