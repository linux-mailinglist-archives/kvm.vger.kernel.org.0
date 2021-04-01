Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9010335240A
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236257AbhDAXiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236000AbhDAXiB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:38:01 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1929C061788
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:38:00 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id v22so4081895pgk.16
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jkU0X6lH1nT6JChtEfu1ZcCu5Uk+xRm36wUm87+EYeQ=;
        b=CBDXQQf10SL5ESvrA7aPxaFeANWvO2aPC7LuZ8edV0BIpTvfM2vRzTSRMDdxlcHSoJ
         JGXVdCM1Cen59iyTTwitQ8c/OOiQlDCHVs6XZhlWSiLZPT095FYOHgdZb4UIATIIEu9y
         tJobj4/J5cSbcf9/Uh/vQZ2xJCaQEESihzksYLRtkng4emsr3kKHN3jTVKAgNzS7TZ2m
         v4lfSp+rxVG2V+pRtLu1N68dYkHSDobP01henck0sp7qqsi3NUfldCvGgfMzPwWlM3WI
         wBsVxEBL6k1HT6pQmYpYCjxXXa3ZPQw/8qH1lwJ9oSsZRcS+3GAikqIy85iTnvV9yHQn
         zmBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jkU0X6lH1nT6JChtEfu1ZcCu5Uk+xRm36wUm87+EYeQ=;
        b=dS8ROMnMRXsyNWlnPle03Ea8LejeF9z/Gl00uiqMfjqJ8pUJ170lbnn094cxaAPxi7
         hgXaIpEEU1d2z8sTf5ndVLXhEqdCr1LJPaAvEvYEUpJFp/COsFjwBNeEXAJ5QAc8/dgd
         XLHXiOJkDNMIn485zR1VFHH5ljLuHjwHU54Fvzy6cJfpB6PIXDRniU2G1g/0hNNiCome
         giEtPGT4ZBtPFn4GLj7lenWD795RHSGTLEsSnZm1HUCAni7QJ4gC+PZ8OdoXNqqVNuHe
         I00qp+dsmmBByozXuQAZRWWpjXXwIK/otiRHus8HGvNdbMROkj4jGHuPcoST+V1UqAWG
         5Hbw==
X-Gm-Message-State: AOAM531ORgP5C4ajHhK8uDsxjI1QJ2tWd2UkZLdQd8y1/UyE/I9zg4Nc
        TEanIQwxQkG4ln+D/KsICZdVs961US7k
X-Google-Smtp-Source: ABdhPJyxl78H4XmmWYAeicb00/m0QaM6SpxH4G4z65fCj6OVsxcYb3Fgf0Lx2VDD8PVFcoKwi7eFFEjE3AOo
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e088:88b8:ea4a:22b6])
 (user=bgardon job=sendgmr) by 2002:a17:90b:1198:: with SMTP id
 gk24mr11172810pjb.84.1617320280335; Thu, 01 Apr 2021 16:38:00 -0700 (PDT)
Date:   Thu,  1 Apr 2021 16:37:26 -0700
In-Reply-To: <20210401233736.638171-1-bgardon@google.com>
Message-Id: <20210401233736.638171-4-bgardon@google.com>
Mime-Version: 1.0
References: <20210401233736.638171-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 03/13] KVM: x86/mmu: use tdp_mmu_free_sp to free roots
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Minor cleanup to deduplicate the code used to free a struct kvm_mmu_page
in the TDP MMU.

No functional change intended.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6f612ac755a0..320cc4454737 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -92,6 +92,12 @@ static inline struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			  gfn_t start, gfn_t end, bool can_yield, bool flush);
 
+static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
+{
+	free_page((unsigned long)sp->spt);
+	kmem_cache_free(mmu_page_header_cache, sp);
+}
+
 void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 {
 	gfn_t max_gfn = 1ULL << (shadow_phys_bits - PAGE_SHIFT);
@@ -105,8 +111,7 @@ void kvm_tdp_mmu_free_root(struct kvm *kvm, struct kvm_mmu_page *root)
 
 	zap_gfn_range(kvm, root, 0, max_gfn, false, false);
 
-	free_page((unsigned long)root->spt);
-	kmem_cache_free(mmu_page_header_cache, root);
+	tdp_mmu_free_sp(root);
 }
 
 static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
@@ -168,12 +173,6 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 	return __pa(root->spt);
 }
 
-static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
-{
-	free_page((unsigned long)sp->spt);
-	kmem_cache_free(mmu_page_header_cache, sp);
-}
-
 /*
  * This is called through call_rcu in order to free TDP page table memory
  * safely with respect to other kernel threads that may be operating on
-- 
2.31.0.208.g409f899ff0-goog

