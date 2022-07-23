Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0170D57EB0C
	for <lists+kvm@lfdr.de>; Sat, 23 Jul 2022 03:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236951AbiGWBXt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 21:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236524AbiGWBXg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 21:23:36 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7238969F07
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:23:34 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id n8-20020a170902e54800b0016d4dffb9d6so414668plf.17
        for <kvm@vger.kernel.org>; Fri, 22 Jul 2022 18:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=9ulz7aLVAum1vSSwzpqx4oGCxXM6Qh5WmZWBpBwUqbk=;
        b=X2Xwpuogh9PUYk+auvdaLmWIyRy814YJlecxSvggqAJVj763zTof4nqo81oSrTKUq8
         DXZsV/AO3xzeDa/HfnJBEf7dl6PiS4rAZKrKfwkYMe3RKdn2A5/kWkFsB4JBDDY+dt8m
         /nuJXscaVhQkltmk2G2Srelw+pADI0+j7QevdKeJJ9WnDg8/nd0kZqL99l+BZvhx1e4Z
         wwIs2BMUjFwNNTVYRoWW1+u1yguWry2DQVm0IAWTIQTVAiddzZJQLJyY6VLItK+YMn1t
         a4T/2f3bE3uXziFF5ILsLCnRycf8HHbqTaCoL4W7PMeAIucpl8gKigbyxQv70uujoQj3
         3z/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=9ulz7aLVAum1vSSwzpqx4oGCxXM6Qh5WmZWBpBwUqbk=;
        b=kBUYJh3FCc9rIsF4GZ/ZX/MQKAw6xf1/dpetbrApAOQYBgfkRF4rfwTzSA2UtQ+lki
         GtVME3+Kl5q2KFZ966KfUAoquuZDKlcvMMGDxz6fZXtpklzYBRxcVzL92Yj86GYp9T6H
         y44UvCIeoOCrZadtTaoXouDGuqj6ol4CQyHhIaT5evJNblSXB3te//woeknfKooGP81o
         xvKH9RcUYHy/y4vyEaHsSDoQtknU5ADYuPrTd+UcI+4C6fY10MU6ODLqbsZZDCGMOgiz
         tx3xBMdG4FqH3RTPm36tOcKEkV/90dbgfy1QVoTqpHSSyofJL4hccIsCdDoTms4sn5Pm
         mY4w==
X-Gm-Message-State: AJIora+xsy98VWypTbEuA2lBe2QcgRbbAIs7EBgAMyFT4UvRpYEndEh8
        z3Rb3VeYafzvWMn5kZKXWCjpwFct9rQ=
X-Google-Smtp-Source: AGRyM1vpIdyEFymG5ISLUnC3Ku8tFg7vp3XjbYPACA9XQNydAU+pD8UhskJVVfFvEolesusg+plnaCHk83Y=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:2cc6:0:b0:411:4fd6:49cb with SMTP id
 s189-20020a632cc6000000b004114fd649cbmr2040088pgs.365.1658539413965; Fri, 22
 Jul 2022 18:23:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 23 Jul 2022 01:23:21 +0000
In-Reply-To: <20220723012325.1715714-1-seanjc@google.com>
Message-Id: <20220723012325.1715714-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220723012325.1715714-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.359.gd136c6c3e2-goog
Subject: [PATCH v2 2/6] KVM: x86/mmu: Properly account NX huge page workaround
 for nonpaging MMUs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yosry Ahmed <yosryahmed@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Ben Gardon <bgardon@google.com>
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

Account and track NX huge pages for nonpaging MMUs so that a future
enhancement to precisely check if shadow page cannot be replaced by a NX
huge page doesn't get false positives.  Without correct tracking, KVM can
get stuck in a loop if an instruction is fetching and writing data on the
same huge page, e.g. KVM installs a small executable page on the fetch
fault, replaces it with an NX huge page on the write fault, and faults
again on the fetch.

Alternatively, and perhaps ideally, KVM would simply not enforce the
workaround for nonpaging MMUs.  The guest has no page tables to abuse
and KVM is guaranteed to switch to a different MMU on CR0.PG being
toggled so there's no security or performance concerns.  However, getting
make_spte() to play nice now and in the future is unnecessarily complex.

In the current code base, make_spte() can enforce the mitigation if TDP
is enabled or the MMU is indirect, but make_spte() may not always have a
vCPU/MMU to work with, e.g. if KVM were to support in-line huge page
promotion when disabling dirty logging.

Without a vCPU/MMU, KVM could either pass in the correct information
and/or derive it from the shadow page, but the former is ugly and the
latter subtly non-trivial due to the possitibility of direct shadow pages
in indirect MMUs.  Given that using shadow paging with an unpaged guest
is far from top priority _and_ has been subjected to the workaround since
its inception, keep it simple and just fix the accounting glitch.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          |  2 +-
 arch/x86/kvm/mmu/mmu_internal.h |  8 ++++++++
 arch/x86/kvm/mmu/spte.c         | 11 +++++++++++
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1112e3a4cf3e..493cdf1c29ff 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3135,7 +3135,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 			continue;
 
 		link_shadow_page(vcpu, it.sptep, sp);
-		if (fault->is_tdp && fault->huge_page_disallowed)
+		if (fault->huge_page_disallowed)
 			account_nx_huge_page(vcpu->kvm, sp,
 					     fault->req_level >= it.level);
 	}
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index ff4ca54b9dda..83644a0167ab 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -201,6 +201,14 @@ struct kvm_page_fault {
 
 	/* Derived from mmu and global state.  */
 	const bool is_tdp;
+
+	/*
+	 * Note, enforcing the NX huge page mitigation for nonpaging MMUs
+	 * (shadow paging, CR0.PG=0 in the guest) is completely unnecessary.
+	 * The guest doesn't have any page tables to abuse and is guaranteed
+	 * to switch to a different MMU when CR0.PG is toggled on (may not
+	 * always be guaranteed when KVM is using TDP).  See also make_spte().
+	 */
 	const bool nx_huge_page_workaround_enabled;
 
 	/*
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 7314d27d57a4..9f3e5af088a5 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -147,6 +147,17 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (!prefetch)
 		spte |= spte_shadow_accessed_mask(spte);
 
+	/*
+	 * For simplicity, enforce the NX huge page mitigation even if not
+	 * strictly necessary.  KVM could ignore if the mitigation if paging is
+	 * disabled in the guest, but KVM would then have to ensure a new MMU
+	 * is loaded (or all shadow pages zapped) when CR0.PG is toggled on,
+	 * and that's a net negative for performance when TDP is enabled.  KVM
+	 * could ignore the mitigation if TDP is disabled and CR0.PG=0, as KVM
+	 * will always switch to a new MMU if paging is enabled in the guest,
+	 * but that adds complexity just to optimize a mode that is anything
+	 * but performance critical.
+	 */
 	if (level > PG_LEVEL_4K && (pte_access & ACC_EXEC_MASK) &&
 	    is_nx_huge_page_enabled(vcpu->kvm)) {
 		pte_access &= ~ACC_EXEC_MASK;
-- 
2.37.1.359.gd136c6c3e2-goog

