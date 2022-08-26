Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1961E5A3268
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 01:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345444AbiHZXMv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 19:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345436AbiHZXMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 19:12:49 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB30FEA14F
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:46 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-33da75a471cso47479617b3.20
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 16:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc;
        bh=uCyv6i8mEx63HGeVnpkclCAYwfuPo59tGsDRd2/sWwE=;
        b=E49sNwDQnr+V5Dgqc1sIHJdcP8ACoS/XxKW4bwe4yMifG3KoVutECUp47PrvG44pJR
         YxWcNMQj/1xulfE7ESYhrtlFbS4a+acCa0EJwRO7uBNkJPtQLl7Guy7bH54VFJoGM0df
         1SJLu7QZ39qpjKJQuelTYYFnoTy+FoWwBCJoLCz8sUoM0LT6Zu6giq5M1X8NIwMepbC7
         7uSZIhMRx+ogfRmUL2TNAdiE3cOQHCvdk+szpXZmNJ6Z65Mba66d+AvrYBwtcfDtWUJL
         h0GiBm/XkCTlzYPiVx3zKJ2pXJCG9bf04opxPXkzIK66wB2e3oumEDtFte1dhBJ6Lki6
         oNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=uCyv6i8mEx63HGeVnpkclCAYwfuPo59tGsDRd2/sWwE=;
        b=Gm3+259Qct99pO0aQDfxl7u58ADGR/SgmNNlusnStjIzZAbl5D68TREkwD7+yYYZDJ
         2LGxz7oLFOtUP7In6Z2bDt97piV+sDp6gGqwICIRrZ6m845B9C09IEL/mAl99XsmZ3Kj
         67++5/A/tIqIHWBTn75qsIwZxFOcU18jt01WA+YHgldVLAKVSvcViqITqI/bXm8oIthT
         WhpikShx4DykHDUuG7+WHTFqehxjLJSK3Ei+SHOBScKM7t02zNCShVP9oYuY0QDcKxXo
         3vsUToUJuYIWUiHBK2wX0gqi4FZav5kKuIRMFOY815TPkLQnv6FOAJqbvQIz9mkKphGA
         iyGA==
X-Gm-Message-State: ACgBeo1QAdHRRXjLfHec90+7vlwV/HyqGwzwyIrZb3/f/bGL3pG2IZkB
        vjDJWfDH6rOoxTsTy0Sb54beOJOs8UnKWA==
X-Google-Smtp-Source: AA6agR7AIZCbunQyDG1/dtX86PT7xaywbXtVKJQvAgQyBPt0WhDatNCajH8y4EQstnyFIpIqyX8lwbbFTDiQVg==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a81:1058:0:b0:336:d111:278 with SMTP id
 85-20020a811058000000b00336d1110278mr2093338ywq.140.1661555565760; Fri, 26
 Aug 2022 16:12:45 -0700 (PDT)
Date:   Fri, 26 Aug 2022 16:12:24 -0700
In-Reply-To: <20220826231227.4096391-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220826231227.4096391-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826231227.4096391-8-dmatlack@google.com>
Subject: [PATCH v2 07/10] KVM: x86/mmu: Initialize fault.{gfn,slot} earlier
 for direct MMUs
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the initialization of fault.{gfn,slot} earlier in the page fault
handling code for fully direct MMUs. This will enable a future commit to
split out TDP MMU page fault handling without needing to duplicate the
initialization of these 2 fields.

Opportunistically take advantage of the fact that fault.gfn is
initialized in kvm_tdp_page_fault() rather than recomputing it from
fault->addr.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 5 +----
 arch/x86/kvm/mmu/mmu_internal.h | 5 +++++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 86282df37217..a185599f4d1d 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4245,9 +4245,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
 	int r;
 
-	fault->gfn = fault->addr >> PAGE_SHIFT;
-	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
-
 	if (page_fault_handle_page_track(vcpu, fault))
 		return RET_PF_EMULATE;
 
@@ -4351,7 +4348,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	if (shadow_memtype_mask && kvm_arch_has_noncoherent_dma(vcpu->kvm)) {
 		for ( ; fault->max_level > PG_LEVEL_4K; --fault->max_level) {
 			int page_num = KVM_PAGES_PER_HPAGE(fault->max_level);
-			gfn_t base = (fault->addr >> PAGE_SHIFT) & ~(page_num - 1);
+			gfn_t base = fault->gfn & ~(page_num - 1);
 
 			if (kvm_mtrr_check_gfn_range_consistency(vcpu, base, page_num))
 				break;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1c0a1e7c796d..1e91f24bd865 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -279,6 +279,11 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	};
 	int r;
 
+	if (vcpu->arch.mmu->root_role.direct) {
+		fault.gfn = fault.addr >> PAGE_SHIFT;
+		fault.slot = kvm_vcpu_gfn_to_memslot(vcpu, fault.gfn);
+	}
+
 	/*
 	 * Async #PF "faults", a.k.a. prefetch faults, are not faults from the
 	 * guest perspective and have already been counted at the time of the
-- 
2.37.2.672.g94769d06f0-goog

