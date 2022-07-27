Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3305833F2
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 22:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbiG0UKg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 16:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbiG0UKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 16:10:34 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1A150733
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 13:10:32 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j2-20020a2597c2000000b0064b3e54191aso10950ybo.20
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 13:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=Xrg5fsxfgCKrpJtcWo9CLpQP9jQ9W4vM9fX7J1EurO0=;
        b=AScBAcm3Re2O3Fg6GlcjSQVr1BWuzhUzLNHpp+d9HelEPkbzU6i3yEPlGv3ExLoFbs
         hgQD66/rEuxtNyAJA7oD/e6VKLXUB7Qm0UuYj9loXif6QHbWiJtkj+9j9CdnALEPOhfO
         LePhWGcIu+4LtuzMq2b2OqxacpKPnuuEN3anp5xHvdWd4HbvcvAwWQFDWA/9af4zk3EL
         bfHT9mBkKPMTZ1H3KIScv3iD7WKUA/uRZIXzYmvRUxLS6gG2NHxzbAcnC9z2BWQJCetp
         2lYzQxW/exOzeF777ZIMBzZhwqAgnXdU3VsrOfdEQE7raGD84Zy0FDPEz84z3XqjTepI
         aXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=Xrg5fsxfgCKrpJtcWo9CLpQP9jQ9W4vM9fX7J1EurO0=;
        b=dPhJ02blbyVf6B6YNaU4Jo6zjI+h1hVcLM7hwmamkZtCbSIBwQ8RH6TbjB6IyWq4ZN
         i5Qo1+1IfKcB2rwT2BJXokoOVpS43BTjN/tFoablsDASOQvMvtZ3DPl6TrzVsCJdzJQq
         uuxbLS0FuDADfZnhmO/j0wQawEiupxjz4/7brfvlkhUN9KTUEOquN0D22VGwoAoCxIND
         ZHBb6mbVmV74fF29h/bw7+JUl+rAbny2BYJ9fhH1wzP88bD8O3V+h7SUw853A3RVj8cv
         viRQM+IlW+6kxTPedBfBetksg8fq7WoAxrw+He7T8QLmExE0bu1U7GYCvMxEdDiD7JnF
         ga4w==
X-Gm-Message-State: AJIora/PcD8MYnVm5TLn35AB0yxG/fhKRb5yrrvIpmyxsmGYosXpDrZ6
        35hYUd4ARphMbwSlrLOjE3KU2qFZnkY=
X-Google-Smtp-Source: AGRyM1vxrNbnqLCXSp+l4Je/r+EA2/Jh7TiHr4S9XS1rXcVezoBgRhNcJqea7p9gHID7WZWEQ12ffMvjFwg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:830:b0:31f:5f93:a63f with SMTP id
 by16-20020a05690c083000b0031f5f93a63fmr4735362ywb.197.1658952631413; Wed, 27
 Jul 2022 13:10:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 27 Jul 2022 20:10:29 +0000
Message-Id: <20220727201029.2758052-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH] KVM: x86/mmu: Remove unused "pfn" in kvm_mmu_zap_collapsible_spte()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove kvm_mmu_zap_collapsible_spte()'s local "pfn" variable, which is
set but not used now that kvm_mmu_max_mapping_level() doesn't require a
pfn.

No functional change intended.

Fixes: fe631a464094 ("KVM: x86/mmu: Don't require refcounted "struct page" to create huge SPTEs")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 8e477333a263..c1cba921c091 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -6416,13 +6416,11 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 	u64 *sptep;
 	struct rmap_iterator iter;
 	int need_tlb_flush = 0;
-	kvm_pfn_t pfn;
 	struct kvm_mmu_page *sp;
 
 restart:
 	for_each_rmap_spte(rmap_head, &iter, sptep) {
 		sp = sptep_to_sp(sptep);
-		pfn = spte_to_pfn(*sptep);
 
 		/*
 		 * We cannot do huge page mapping for indirect shadow pages,

base-commit: 1a4d88a361af4f2e91861d632c6a1fe87a9665c2
-- 
2.37.1.359.gd136c6c3e2-goog

