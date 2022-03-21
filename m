Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C814E32E6
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 23:48:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbiCUWtk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 18:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiCUWtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 18:49:21 -0400
Received: from mail-oo1-xc4a.google.com (mail-oo1-xc4a.google.com [IPv6:2607:f8b0:4864:20::c4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3FF38BB49
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:04 -0700 (PDT)
Received: by mail-oo1-xc4a.google.com with SMTP id t31-20020a4a96e2000000b00320f7e020c3so10510010ooi.13
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 15:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hRh/aDRf4TFZL6zvr1bxrdAuUBcTWbp/rzavH8BxDmc=;
        b=N7QoakYla67hg2YwGMLs+8CQiTvN1le0Y1szw2+lTeF6J0oD3TknBPWha0WZdUSHBi
         vzJTf6ft6Z5Ecn9+Z5SLXjBG1V8G8zN+RUSvgOXdZzemZFwR+yb35QVxC7R8kFmswS+o
         eSAJeclif2PWNQXWk9ewedIX8yZxa8+2O7YNRS6KiQNb/g8IMlUY0bPgzWnWw00i6s/0
         8dwobgEeVzQ28Jq4sh8tAq54i6xRF32OHBlHqZF3dlFNdwLW7V/bS4HUBSpdFPNo0OFI
         U5Y1NQoL+Be8GUIwbsmJqSuBnlEF5HD7Ym5s4s4XKS+4aeBV86GzokV7jBmfBmfKjy4T
         a9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hRh/aDRf4TFZL6zvr1bxrdAuUBcTWbp/rzavH8BxDmc=;
        b=uYwW9IxXFL1mdh+xIFmypC1kDk3MiLD20xNXitkbqxRPG0Zsufo1g8co8k8PipWrZo
         krjzW2i6xE97xQg5G7VEI3ir1SSgm8LzKsh6NDuFm4aPB9+/TdHzDxbDjHnBwC/ZDsuo
         sXAlzDBsw+nppVafRGqrbxQukZpfz2lFdpGMRNIwl5pEEdjMYU3TtEpLkaFpKKYvtojR
         3RqVaYyeucrAPSW0bCKHh7Qh/KT24FJGBuscYUotNc7m3DehJ+d7nyerLn3dl0zMleCt
         UCU/XjVmF5t1vRjtJ27RlJGscJgcf5UhHqPYr4QtxirQ0KolWbDOBTiFWdRSfFxxmYP6
         u31A==
X-Gm-Message-State: AOAM532NcB6LLOcSrxu4szvqlBkdJhmv+t+dSMxf5s4kbo7exjxHWHKb
        Pknj9aZhqrP6oWSu8C6w7VdLySlk8c3R
X-Google-Smtp-Source: ABdhPJx/TZE9wohAlA7RmM4J8+LSEqgX4e7w4WODqSwLPP/ymPVzGNN5Wz4oKrcYJwE9RVAbBNatidr5DU7J
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:aca:2311:0:b0:2ec:cb84:c5bb with SMTP id
 e17-20020aca2311000000b002eccb84c5bbmr721672oie.246.1647902643700; Mon, 21
 Mar 2022 15:44:03 -0700 (PDT)
Date:   Mon, 21 Mar 2022 15:43:50 -0700
In-Reply-To: <20220321224358.1305530-1-bgardon@google.com>
Message-Id: <20220321224358.1305530-2-bgardon@google.com>
Mime-Version: 1.0
References: <20220321224358.1305530-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 1/9] KVM: x86/mmu: Move implementation of make_spte to a helper
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

Move the implementation of make_spte to a helper function. This will
facilitate factoring out all uses of the vCPU pointer from the helper
in subsequent commits.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/spte.c | 20 +++++++++++++++-----
 arch/x86/kvm/mmu/spte.h |  4 ++++
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 4739b53c9734..d3da0d3d41cb 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -90,11 +90,10 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 				     E820_TYPE_RAM);
 }
 
-bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
-	       const struct kvm_memory_slot *slot,
-	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-	       u64 old_spte, bool prefetch, bool can_unsync,
-	       bool host_writable, u64 *new_spte)
+bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+		 const struct kvm_memory_slot *slot, unsigned int pte_access,
+		 gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
+		 bool can_unsync, bool host_writable, u64 *new_spte)
 {
 	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
@@ -192,6 +191,17 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	return wrprot;
 }
 
+bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+	       const struct kvm_memory_slot *slot,
+	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
+	       u64 old_spte, bool prefetch, bool can_unsync,
+	       bool host_writable, u64 *new_spte)
+{
+	return __make_spte(vcpu, sp, slot, pte_access, gfn, pfn, old_spte,
+			   prefetch, can_unsync, host_writable, new_spte);
+
+}
+
 static u64 make_spte_executable(u64 spte)
 {
 	bool is_access_track = is_access_track_spte(spte);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 73f12615416f..3fae3c3124f7 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -410,6 +410,10 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
+bool __make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+		 const struct kvm_memory_slot *slot, unsigned int pte_access,
+		 gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
+		 bool can_unsync, bool host_writable, u64 *new_spte);
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       const struct kvm_memory_slot *slot,
 	       unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-- 
2.35.1.894.gb6a874cedc-goog

