Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7F65C055C
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 19:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbiIURgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 13:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiIURgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 13:36:05 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3501AA2869
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:36:04 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-3451e7b0234so57573207b3.23
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 10:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=glnAthJ1ZVuR8FtpSWEyu9eNeNWHww8uzn3egQlazAY=;
        b=TGMzpnXuNZnMI3x+IULgXwfwYj9hosKR4RLofz8C2gppQZO08QnyANuPpkwOH/RG4E
         0jxElkggc6/sm+0PENdaDwzAQBSRNiwCuxN0oucrJtvF9PCjpU2ZdB+RV6Tf/1DmceKW
         CxRUzkPaw3LolUJqHkHEfRwbqNsZooCvGhsLHoPTVglWOqeOyzAaGBwBovHHEsEJytqC
         q+kFbFlMfN465VNbBZy7+Sk2H1ooLvq8QwtUckfbUtHD1LHGVAw5SAtOUp7pucEs+k1w
         +BVVcNymBgeh173O2DRy3e8Yrj5oU8hL2NFJZubIhxPiRUF7d/WP7kOFtpbcS2AdNCPb
         1byQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=glnAthJ1ZVuR8FtpSWEyu9eNeNWHww8uzn3egQlazAY=;
        b=GAOr6Mow/Pya1EUUioE1Cv5jtMgdSR7+KG5h5Z8Dz48lXMiVlRE17fwC2sZExoC5ud
         7U+fjJX0/McRSrB34ciBxUhHWam7lYftGfQsj0kZmFXpwinF4XGu2NnNk9bc6m+mo6YK
         s+9QTQN7c2HcQ3rR/jtPoWLE2qh0wENo245rckp3b37yOMSS3zzrb03gJY6njH8AywSD
         V5EXk4dmXtZaua0PiZ1jIfRxkvUp3wfA28W5LnWHcjxk1l8Ts2Pe3b4T9RstymkmkZFq
         Wn/XrLGLlzPvDBPQVY8SE+WNRBVVkMqLEKxBYadqF+n62ki6hP2yAIfjy1ZGA10+1Iub
         P8Hg==
X-Gm-Message-State: ACrzQf2sItoZYDXuMgEzBz+Q6KKJ4aUsxNbfCgdQJUdAJviolvBJB6HD
        YqpCGdw2p2IMrzBHzWXqY986Em+3TBFKaQ==
X-Google-Smtp-Source: AMsMyM7cvFiaKL+el75IaEoofWiGhBswzRW4eqGQSRBXZzNcgm4mB1Qaau5bRhyMjH0L8CxZw6yGN2KutFvWTw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:ccd7:0:b0:6a9:72d6:a1c1 with SMTP id
 l206-20020a25ccd7000000b006a972d6a1c1mr25158077ybf.390.1663781763509; Wed, 21
 Sep 2022 10:36:03 -0700 (PDT)
Date:   Wed, 21 Sep 2022 10:35:43 -0700
In-Reply-To: <20220921173546.2674386-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20220921173546.2674386-1-dmatlack@google.com>
X-Mailer: git-send-email 2.37.3.998.g577e59143f-goog
Message-ID: <20220921173546.2674386-8-dmatlack@google.com>
Subject: [PATCH v3 07/10] KVM: x86/mmu: Initialize fault.{gfn,slot} earlier
 for direct MMUs
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
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
index e3b248385154..dc203973de83 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4241,9 +4241,6 @@ static int direct_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	bool is_tdp_mmu_fault = is_tdp_mmu(vcpu->arch.mmu);
 	int r;
 
-	fault->gfn = fault->addr >> PAGE_SHIFT;
-	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
-
 	if (page_fault_handle_page_track(vcpu, fault))
 		return RET_PF_EMULATE;
 
@@ -4347,7 +4344,7 @@ int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
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
2.37.3.998.g577e59143f-goog

