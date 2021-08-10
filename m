Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5079F3E8594
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 23:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234434AbhHJVnG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 17:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbhHJVmH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Aug 2021 17:42:07 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09895C061799
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 14:41:45 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id s9-20020ad450090000b029034fef0edad8so27556qvo.21
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 14:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=6T8kuGllm12i4AuXiwQMGaDrKXSO7/R3/mvtZjeRHCQ=;
        b=H/qsAt80kcJhaAKAsak2GSMbVjCfFZEKXW2JMzcN4rgCZ/+VaE1VFOpCI+O5DMCb6z
         LoBWk+AFRtla0luLatwOPsI6wabKDi32DfU118HyrybXNI2mObYUUHK/0y+LZba8F6OB
         i1VbI8MFo6FFgckULfSdum0ZWnTZlVPDQzH8yg+StJbL4+PRHOo/Mu9B1fWM+mmEer3M
         OVSCxr09cUVTvKxuXVnvTs0Mo8ugHiZVdiTiEFPBDxCtaF6yhDIpm4h2d019rzdGVQg7
         rVnLvtHVQrkg+8hWN1pLx8tkeYx8DJdYoA7LELevfC2TV7G4vdktDKvyUOINRTMCXRMk
         Ig1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=6T8kuGllm12i4AuXiwQMGaDrKXSO7/R3/mvtZjeRHCQ=;
        b=PSwiw/V2x6ANye06NJn+3yiiiWqUiZYh79LMnZHBexuZyvUVB/21yAzM9+lI9Sjccm
         zXlVNnmPBr7z8JMVea7Bigg4I8iVii5FZkXlxoECmK2SdFOOxVrDazqkX6hH+gbpJF8T
         DIyo2c6KIOF0bFrK5SsWjmJL/nMZaYq8OvxI35iQr1MqTmqh8s+0vVDV/kevr2rRP7l1
         l+sR/jKBJHu+t/o0mzhiyN4q5s5QZnemRMQ6gDx37IxB0wt2urDIqy+bAfq+M7R1OnWy
         GOFHr+vEIxZ18w+BuQixNhs3SRZXwLPk0Cv61XCN95nJWDkKEx/GsXc7QIbTxLJ9VYFA
         v3bw==
X-Gm-Message-State: AOAM532CLpuzmXHGIlVThG7dfaFIEHiM1nFFlT//cGwzuj/EtXb7jxsU
        Thy1mqLP22+BblzzsoQ2u8ELMH07Ucu/u+GuIL5oWa6fHyV7pycRl2wwxikDenEojtnNt0h1rlT
        42NwYlvT7gMPpYhwcKTPyOPgkuH1uuUKyFmK2iXs1igq9esfYW4caFrVEwuS9
X-Google-Smtp-Source: ABdhPJzX5OaEa19+8oWok58HuvhMoS6bJKK0GSzWR1DzofNNjqZZI6Wr2MQYlKtg3oiYGwYhaCX7Sclyw8U+
X-Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:202:c658:fef4:ccc5:cd0f])
 (user=junaids job=sendgmr) by 2002:ad4:5bae:: with SMTP id
 14mr30820273qvq.22.1628631704144; Tue, 10 Aug 2021 14:41:44 -0700 (PDT)
Date:   Tue, 10 Aug 2021 14:41:32 -0700
Message-Id: <20210810214132.2811875-1-junaids@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v2] kvm: vmx: Sync all matching EPTPs when injecting nested
 EPT fault
From:   Junaid Shahid <junaids@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     seanjc@google.com, jmattson@google.com, bgardon@google.com,
        pshier@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v2:
- Changed references to L1 EPTP to EPTP12

When a nested EPT violation/misconfig is injected into the guest,
the shadow EPT PTEs associated with that address need to be synced.
This is done by kvm_inject_emulated_page_fault() before it calls
nested_ept_inject_page_fault(). However, that will only sync the
shadow EPT PTE associated with the current EPTP12. Since the ASID
is based on EP4TA rather than the full EPTP, so syncing the current
EPTP12 is not enough. The SPTEs associated with any other EPTP12s
in the prev_roots cache with the same EP4TA also need to be synced.

Signed-off-by: Junaid Shahid <junaids@google.com>
---
 arch/x86/kvm/vmx/nested.c | 53 ++++++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1a52134b0c42..2eeaa2de76b5 100644
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
+		 * tables for the current EPTP12, we also need to sync it for
+		 * any other cached EPTP12s that share the same EP4TA, since
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

