Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1104455285
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 03:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242469AbhKRCPc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 21:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242462AbhKRCPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Nov 2021 21:15:31 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED144C061570
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 18:12:31 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so4253158pjb.1
        for <kvm@vger.kernel.org>; Wed, 17 Nov 2021 18:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A4BA9drk3T915Gv5BUziX7aipJ2k8U9h+N8xeIjFfWY=;
        b=RYTMLpgJFpGPSbbh5jqrW6uo91lleQGsSoLGj5Lo6/gpUtPAXzczZPTTl2vm/aCdOj
         /2n5VTnIQZxIh0TD1PkodzMm5Ui39R2BbaKWV/9ogRhX65JBZrrB9zVonBSOiOJuGUF9
         dIZPYoPaUMkX5mZ0D2n94sf0xcxPVB0ifGqtMc1UgWrtdQGWVI+FSd3UgJ69BVt1hTsT
         OeG+fO4XJ+40wzpGicy8JZaMXKBzGTSuSV5qxgBnNHaonPHFGbURJ/58GY1hsbdZhqd0
         K0Cm2Bx0Lx2LWaujNexKoM2KGUCmBWuhuiRXav/xmlCFOZMqGsdCynDabe3FCoahdh3S
         zYUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A4BA9drk3T915Gv5BUziX7aipJ2k8U9h+N8xeIjFfWY=;
        b=SkKWA1t8T1H3jtbxVtZqAj4/yPrxiajupbdqCY1scR/U3nW99VYdCes7AU777uV8uM
         54FN3xva+ZRqs/2TgAVF+TE1viSIGuM48WSYjUi8BOHAIQ1A4TO8m3k/BpoR61QWnpb8
         t/VfsMf8yMA1+1CpHRvY86r6/eYM6F8dvn5ccuJkf7af6DNCv+e0GgaiH+3oyn1Tc+8e
         ijmyGT1igWcr8J4H7GsB2o0aRO4qvOGrzlG3xjhD4yln2koTbvTTqR+9+BrHRNvSf98/
         RBeNZymp5eZOOhp18qaYzbU+frnya6BXF0VFCWtQGizy5zM05R4fzVTNGkeU5ZT3rtrq
         /cIg==
X-Gm-Message-State: AOAM532xPHNxt1HrcL4iNsBQ0xh2C9s5w9ZALN7D3ztMSu1iwct5ogyl
        B+gxXg9Jr5e5dSprbMnjPyWsLiduX7h2Kg==
X-Google-Smtp-Source: ABdhPJx4HUTSi1tcC4By2b4tFJQCysvVDAyNsAqdsK1ez/bi/mQTw5ipWI21Iz23z60sJBjTwdYDnQ==
X-Received: by 2002:a17:902:d488:b0:141:f3a3:d2f4 with SMTP id c8-20020a170902d48800b00141f3a3d2f4mr62011801plg.86.1637201551314;
        Wed, 17 Nov 2021 18:12:31 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id s15sm826250pjs.51.2021.11.17.18.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 18:12:30 -0800 (PST)
Date:   Thu, 18 Nov 2021 02:12:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [RFC 07/19] KVM: x86/mmu: Factor wrprot for nested PML out of
 make_spte
Message-ID: <YZW2i7GnORD+X5NT@google.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-8-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211110223010.1392399-8-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021, Ben Gardon wrote:
> When running a nested VM, KVM write protects SPTEs in the EPT/NPT02
> instead of using PML for dirty tracking. This avoids expensive
> translation later, when emptying the Page Modification Log. In service
> of removing the vCPU pointer from make_spte, factor the check for nested
> PML out of the function.

Aha!  The dependency on @vcpu can be avoided without having to take a flag from
the caller.  The shadow page has everything we need.  The check is really "is this
a page for L2 EPT".  The kvm_x86_ops.cpu_dirty_log_size gets us the EPT part, and
kvm_mmu_page.guest_mode gets us the L2 part.

Compile tested only...

From 773414e4fd7010c38ac89221d16089f3dcc57467 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 17 Nov 2021 18:08:42 -0800
Subject: [PATCH] KVM: x86/mmu: Use shadow page role to detect PML-unfriendly
 pages for L2

Rework make_spte() to query the shadow page's role, specifically whether
or not it's a guest_mode page, a.k.a. a page for L2, when determining if
the SPTE is compatible with PML.  This eliminates a dependency on @vcpu,
with a future goal of being able to create SPTEs without a specific vCPU.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h | 7 +++----
 arch/x86/kvm/mmu/spte.c         | 2 +-
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 8ede43a826af..03882b2624c8 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -109,7 +109,7 @@ static inline int kvm_mmu_page_as_id(struct kvm_mmu_page *sp)
 	return kvm_mmu_role_as_id(sp->role);
 }

-static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
+static inline bool kvm_mmu_page_ad_need_write_protect(struct kvm_mmu_page *sp)
 {
 	/*
 	 * When using the EPT page-modification log, the GPAs in the CPU dirty
@@ -117,10 +117,9 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 	 * on write protection to record dirty pages, which bypasses PML, since
 	 * writes now result in a vmexit.  Note, the check on CPU dirty logging
 	 * being enabled is mandatory as the bits used to denote WP-only SPTEs
-	 * are reserved for NPT w/ PAE (32-bit KVM).
+	 * are reserved for PAE paging (32-bit KVM).
 	 */
-	return vcpu->arch.mmu == &vcpu->arch.guest_mmu &&
-	       kvm_x86_ops.cpu_dirty_log_size;
+	return kvm_x86_ops.cpu_dirty_log_size && sp->role.guest_mode;
 }

 int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 0c76c45fdb68..84e64dbdd89e 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -101,7 +101,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,

 	if (sp->role.ad_disabled)
 		spte |= SPTE_TDP_AD_DISABLED_MASK;
-	else if (kvm_vcpu_ad_need_write_protect(vcpu))
+	else if (kvm_mmu_page_ad_need_write_protect(sp))
 		spte |= SPTE_TDP_AD_WRPROT_ONLY_MASK;

 	/*
--
