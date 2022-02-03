Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A8B4A7D27
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 02:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234702AbiBCBBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 20:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345224AbiBCBBO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 20:01:14 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E87C061714
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 17:01:14 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 27-20020a63135b000000b0036285f54b6aso548537pgt.19
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 17:01:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FiCud8ItmVAz7EYTwAPbFj4Foo/9mt3PrXdDTZQK99E=;
        b=ZU9e3JwAD7nmDMlTFHM17n+7TdHTAA46fhVNdiATSYONfxK5KS+V1ZU9jZPrh4CJLX
         KcuZnRPE4YU0t8+lPdlavOeLoqgw1bjdZoRuQ8fro00z1brGspKFq+4obDjMZmalZmkk
         MqIwcWVIjdcscXpo2RhJfGfwMoPm8ignQ5BaRuHb68AXNH4VF2Sple1dNC9WCyTR9Urq
         if+/Yk9bZ5r35GGg3OEQ+4iFHR+O2gMF2K1rQkOIy0MdbS/NMitNVH3ArHEGgrwbK7bW
         Qqd+q3oTl53YXHmmQhCWLFPEjy7bEDeRTnbERLqtjvnJ2VNR6O0e2a1RoBFUuJn/5WHV
         ZAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FiCud8ItmVAz7EYTwAPbFj4Foo/9mt3PrXdDTZQK99E=;
        b=G5EP6z36TCHXqFjdyIsf6CSVb9mT5556rND02OVz1YsxJEonm/Guyc6ourv28kNEIN
         KivLEZkGsEe3tRNuoPxXSxRYbAsbJq/drvWL3Bk4GweAIDYzV4nqMY2qaYm9ZmfUi+oe
         YMnpO09ouUcSId3a2ZEs2ojszKP4fSLoxb57y10IDZTz+LIkx/v0mLw1+tinQ+tclJhH
         gk0JypAnM7TWBuF4IWLIy/oDFE0/q06c0qb4PDuP8y+GcnKpIW5ouXhdjtng7br+abqL
         RGihQCxkT4bKDF75wGMuJcD32zT09xSkc0BncyRlOXc515GyBe6pNnKZGq28nH3TQBrQ
         4B6A==
X-Gm-Message-State: AOAM531XWWrJ+lUglDaf3MkKX26l9dS4m4S97n0rCrFpx926aLLc8wiQ
        0i26LRRKe1WvVeV0yY8yRPTIEaO8iRzBAQ==
X-Google-Smtp-Source: ABdhPJz4JZExpZKil/jPdcDA6GrR7mzWDf+S8sIBRmVa5ScktNhlyZDYfILYuWYrUCRszNVSYOXGi0DIuLBkzQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:e552:: with SMTP id
 n18mr33380571plf.152.1643850073636; Wed, 02 Feb 2022 17:01:13 -0800 (PST)
Date:   Thu,  3 Feb 2022 01:00:36 +0000
In-Reply-To: <20220203010051.2813563-1-dmatlack@google.com>
Message-Id: <20220203010051.2813563-9-dmatlack@google.com>
Mime-Version: 1.0
References: <20220203010051.2813563-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
Subject: [PATCH 08/23] KVM: x86/mmu: Use common code to free kvm_mmu_page structs
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        leksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Feiner <pfeiner@google.com>,
        Andrew Jones <drjones@redhat.com>, maciej.szmigiero@oracle.com,
        kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use a common function to free kvm_mmu_page structs in the TDP MMU and
the shadow MMU. This reduces the amount of duplicate code and is needed
in subsequent commits that allocate and free kvm_mmu_pages for eager
page splitting.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 8 ++++----
 arch/x86/kvm/mmu/mmu_internal.h | 2 ++
 arch/x86/kvm/mmu/tdp_mmu.c      | 3 +--
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 3acdf372fa9a..09a178e64a04 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1680,11 +1680,8 @@ static inline void kvm_mod_used_mmu_pages(struct kvm *kvm, long nr)
 	percpu_counter_add(&kvm_total_used_mmu_pages, nr);
 }
 
-static void kvm_mmu_free_sp(struct kvm_mmu_page *sp)
+void kvm_mmu_free_sp(struct kvm_mmu_page *sp)
 {
-	MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
-	hlist_del(&sp->hash_link);
-	list_del(&sp->link);
 	free_page((unsigned long)sp->spt);
 	if (!sp->role.direct)
 		free_page((unsigned long)sp->gfns);
@@ -2505,6 +2502,9 @@ static void kvm_mmu_commit_zap_page(struct kvm *kvm,
 
 	list_for_each_entry_safe(sp, nsp, invalid_list, link) {
 		WARN_ON(!sp->role.invalid || sp->root_count);
+		MMU_WARN_ON(!is_empty_shadow_page(sp->spt));
+		hlist_del(&sp->hash_link);
+		list_del(&sp->link);
 		kvm_mmu_free_sp(sp);
 	}
 }
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 2c80028695ca..c68f45c4a745 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -162,4 +162,6 @@ void unaccount_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
 
 struct kvm_mmu_page *kvm_mmu_alloc_direct_sp_for_split(gfp_t gfp);
 
+void kvm_mmu_free_sp(struct kvm_mmu_page *sp);
+
 #endif /* __KVM_X86_MMU_INTERNAL_H */
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0d58c3d15894..60bb29cd2b96 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -59,8 +59,7 @@ static bool zap_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 
 static void tdp_mmu_free_sp(struct kvm_mmu_page *sp)
 {
-	free_page((unsigned long)sp->spt);
-	kmem_cache_free(mmu_page_header_cache, sp);
+	kvm_mmu_free_sp(sp);
 }
 
 /*
-- 
2.35.0.rc2.247.g8bbb082509-goog

