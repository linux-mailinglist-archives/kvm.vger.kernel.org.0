Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7823E31AA
	for <lists+kvm@lfdr.de>; Sat,  7 Aug 2021 00:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241242AbhHFWVy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Aug 2021 18:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232178AbhHFWVt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Aug 2021 18:21:49 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4490BC0613CF
        for <kvm@vger.kernel.org>; Fri,  6 Aug 2021 15:21:33 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id j12-20020a05620a146cb02903ad9c5e94baso3296089qkl.16
        for <kvm@vger.kernel.org>; Fri, 06 Aug 2021 15:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=g3qzh/XYkFSuJH17Zhqk8ubyu4zK8wp1E2+k23JA6dY=;
        b=csQyV9i2lc0bXAaZdQoz0n3r/ol/xaKe6HYg2Ag8ApVK8wUC8wPrwAQqHA34iJGy0o
         AjcY/PxV8xNddboMO998g480sthGLu58l1yWDJF/7896siPn2iWLfZuONgi9pV8bFUZ1
         u4m3RQBERCmRDjDbbVae1Zmd/PSE9wsWtLPDV0s9YJawZczs2dKaLV8aoPW85UuxDCE4
         JkfzIDTyw1Fx/nIv8P5aFtURK5OnQEMwgn9TA5WySNWWAjVHgqBo6ByRowCahAZI0GcB
         SyuyCVocoO+9e24+B7xYP8HwcXAS+kvRttwk0zCjXllKUrebQH3dXIpSGRNmoConBvTX
         HZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=g3qzh/XYkFSuJH17Zhqk8ubyu4zK8wp1E2+k23JA6dY=;
        b=eQbHd8B7U4fHcO0w7JqKumOOzBLOr4QA+8B/YxauQaES4sgHGUXLR5i278aqRaafXn
         BfW9VCpYxAdjemby27tjRvZpEGwKG0xQxpTZOJn7o/o2SGiUH2XS3AtGGgRpDJAXv+AM
         d7k4jMQGF+iYfvhBDxt8JoAbQBycAX2uEJTpwhI93Td1UfLdE2DiBHQMmtVLbu5BwCSx
         2RKeMDFaSc8/mJ8TU5oMd1FrmMfX4zO135NSCym52c9UhisaD1lJYrX99g1Zpxbj4dvb
         81bZIvLsDO6MK7PWExDmJqPJ5IO7WlBBwT4OGeZXhEhIm897sAp2kGPWpQu+UwoVIOnT
         95WA==
X-Gm-Message-State: AOAM5327FG/3wJ3bpxMlnaaYUEsBenc5FLET61i3WXcOA6xDSIMnU5k0
        jwO4wX1YtNsI2ULIsX0W2RRm+mWQdU08Ix3uJWiFAY4rb7Nmrv1bR8U0Re+GrjSWo7imJnOQ3FC
        V07SPD+qOZvw+4Nc2gynjdhC5/pagW9tlaYHm/jqnJGTh19jQZlGEMYmPi2AJ
X-Google-Smtp-Source: ABdhPJyXwbTeKIfL8mIlp2ZFxEia732WFwwoM6BVvCF0cgnweZsDkR4wR6PK+BJUTcF6652kf9C4TerqPcq5
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:fd69:7ebb:28df:b2cf])
 (user=junaids job=sendgmr) by 2002:a05:6214:10e6:: with SMTP id
 q6mr13517476qvt.11.1628288492389; Fri, 06 Aug 2021 15:21:32 -0700 (PDT)
Date:   Fri,  6 Aug 2021 15:20:28 -0700
Message-Id: <20210806222028.1644677-1-junaids@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH] kvm: vmx: Sync all matching EPTPs when injecting nested EPT fault
From:   Junaid Shahid <junaids@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        bgardon@google.com, pshier@google.com
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

