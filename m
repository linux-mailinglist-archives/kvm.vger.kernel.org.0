Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55EF04FA0B5
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 02:39:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240169AbiDIAlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 20:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiDIAk7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 20:40:59 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B2EC6F17
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 17:38:54 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id w3-20020a17090ac98300b001b8b914e91aso6319388pjt.0
        for <kvm@vger.kernel.org>; Fri, 08 Apr 2022 17:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=thKGaxk6frVBmncPag9ccep8XhtdrO9GVerkqMqzUPE=;
        b=ep/jovrnXHVIN9Nk/1jRrewEmcxWCM//ePr/E+Alga7Hh1Xud3+PHOb1HiNXOp5uh3
         NF71FC3S7yN85uySpok+zQsY3dxStuqCjXQ9xtESfxXtJyBJrh6tAEcmVClcAMe++DP6
         Ztc44q2CpRE4TRVOYkW6voo5lTNtbu6LjIfS9zfzX+K4Wsl9ySrmDKffyzMezTRS86nk
         OqFX5bYqJIAniksa3haR6EnT8zVz6/8l49HyTG3HqSDiHBVzpqQPxsoaLlrRyc1zSS8Z
         t8HEwHSsTLlbqQyXAHhma7LqPz5PiAFUcOCF0WFYajvcAXXZLWik9X6WUYQp9f6Vk7zM
         qJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=thKGaxk6frVBmncPag9ccep8XhtdrO9GVerkqMqzUPE=;
        b=krSSxeGbWnlMptdAwbyN3cOLpTqKp8vsz7aKHCQz0Z4hBlDQtTbsSSfU8VQbIfB8ef
         p7G9mmeNnbnSbbjSYb3r6iiq9zDm2w7Imlx1DatpOSibebYdnyHPVsqx1Pz2h+d9U6SC
         bK+7gYDbRKMax18dn0E006M6HfXmGjJMAtUQZ6hWIIJmXjT2c5ysDdBwwEag+yzf3lOO
         V+HM4agfL49/0nAk0fQviJLKFLRha+re8rTchf+wYhP9Gi9qVD9hplHNZJHeq2y1zqVQ
         RG8sDRbHU7LZ5DUcs1Y5PVjt1QLKjLWONuY4VfcdLYnH26z6CwFCt3edRD7KBFcdADDC
         /7dA==
X-Gm-Message-State: AOAM531MQYf6v1KpOojM9hUs433SEpkcnEOfVXBIEvUaaCuW744B4SsB
        94EzyzjMVDVdzP2pl7Hxzlhlzo4txwQ=
X-Google-Smtp-Source: ABdhPJxHLp7HdoEpNZv6Y8JV/wtuM6oq38rqtJtHP6r/yBc59CRj4JfPm6X7xcHDWTNaz5CC1327h2bB/NQ=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:1a0a:b0:4fc:d6c5:f3f1 with SMTP id
 g10-20020a056a001a0a00b004fcd6c5f3f1mr22302197pfv.45.1649464734306; Fri, 08
 Apr 2022 17:38:54 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  9 Apr 2022 00:38:43 +0000
In-Reply-To: <20220409003847.819686-1-seanjc@google.com>
Message-Id: <20220409003847.819686-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220409003847.819686-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH 2/6] KVM: x86/mmu: Properly account NX huge page workaround
 for nonpaging MMUs
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mingwei Zhang <mizhang@google.com>
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
toggled so there're no security or performance concerns.  But getting
make_spte() to play nice now and in the future is unnecessarily complex.
In the current code base, make_spte() can enforce the mitigation if TDP
is enabled or the MMU is indirect, but other in-flight patches aim to
drop the @vcpu param[*].  Without a @vcpu, KVM could either pass in the
correct information and/or derive it from the shadow page, but the former
is ugly and the latter subtly non-trivial due to the possitibility of
direct shadow pages in indirect MMUs.  Given that using shadow paging
with an unpaged guest is far from top priority in terms of performance,
_and_ has been subjected to the workaround since its inception, keep it
simple and just fix the accounting glitch.

[*] https://lore.kernel.org/all/20220321224358.1305530-5-bgardon@google.com

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu.h      |  9 +++++++++
 arch/x86/kvm/mmu/mmu.c  |  2 +-
 arch/x86/kvm/mmu/spte.c | 11 +++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 671cfeccf04e..89df062d5921 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -191,6 +191,15 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		.user = err & PFERR_USER_MASK,
 		.prefetch = prefetch,
 		.is_tdp = likely(vcpu->arch.mmu->page_fault == kvm_tdp_page_fault),
+
+		/*
+		 * Note, enforcing the NX huge page mitigation for nonpaging
+		 * MMUs (shadow paging, CR0.PG=0 in the guest) is completely
+		 * unnecessary.  The guest doesn't have any page tables to
+		 * abuse and is guaranteed to switch to a different MMU when
+		 * CR0.PG is toggled on (may not always be guaranteed when KVM
+		 * is using TDP).  See make_spte() for details.
+		 */
 		.nx_huge_page_workaround_enabled = is_nx_huge_page_enabled(),
 
 		.max_level = KVM_MAX_HUGEPAGE_LEVEL,
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d230d2d78ace..9416445afa3e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2954,7 +2954,7 @@ static int __direct_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 				      it.level - 1, true, ACC_ALL);
 
 		link_shadow_page(vcpu, it.sptep, sp);
-		if (fault->is_tdp && fault->huge_page_disallowed)
+		if (fault->huge_page_disallowed)
 			account_nx_huge_page(vcpu->kvm, sp,
 					     fault->req_level >= it.level);
 	}
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4739b53c9734..14ad821cb0c7 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -115,6 +115,17 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
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
 	    is_nx_huge_page_enabled()) {
 		pte_access &= ~ACC_EXEC_MASK;
-- 
2.35.1.1178.g4f1659d476-goog

