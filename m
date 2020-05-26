Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78501CB710
	for <lists+kvm@lfdr.de>; Fri,  8 May 2020 20:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgEHSYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 14:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726756AbgEHSY3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 8 May 2020 14:24:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B571FC061A0C
        for <kvm@vger.kernel.org>; Fri,  8 May 2020 11:24:29 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n7so3060151ybh.13
        for <kvm@vger.kernel.org>; Fri, 08 May 2020 11:24:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=1V7q5o/ItajItDx2fBMJH7Cm/96EukZlRI5pzOV5Nh0=;
        b=EsInb96PWReVQg3NpHEVUBr/5zp2mwXiQdj8C/5KnpjyUPjK/GVTmMZr/3tf2YpiF6
         nCUDpMXRvZu2cZRjHsoMqjonTZQ6QPmtElreMhkQ+SBFvqcYTqY9XriUhCNSLKGAeAWV
         cRFj6xoNF7XP0I1iTYbFALuMgSrB87IIx5RnbfwFdV2FnCtMdLl2zOSRLqG1mqJb7+7e
         O9ZBP/LlJBy2ODeomKEFpGbSwe+rxGoqGykCcIGCveC+QC8Am4Ln9Ea+DRZQmQ3qzb94
         si2Ehl6+ry3xT78xc0UxSbXVamCqGl0b8VuHUWFPvZOA9mly58BrZilrUn0lh6dFYwxn
         Ef1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=1V7q5o/ItajItDx2fBMJH7Cm/96EukZlRI5pzOV5Nh0=;
        b=jtlIz+S4jB8x80Wn4unB3fnj8EjdKvn3rss3IV2M5Ai3MDcvQdywswL0yAj8ciAaqY
         tj7UPNOrUpsZB7sNXysTb99R0t6lv+2qtpZYNvCGcHfMpQrpSwd36ctJQWRrDtrS8A+F
         SIPnbjFpGpcJNVyIU+gQPiGSYGdj88HrjWSa7PTUw9161Yqvdy2ZkES5yBWTWXY46cI2
         aQ+w3xUJCFCxm8YTVXtNs8pnT2qSLNOVh4bVhiGYDWYd/FxxxsBmcPJMkfHJx43Vf+Mn
         Ls+yDcDhagO1WyOu07sEC7/cLXRdMUxq1R9ZQWzcyni8nRSv9fEjCh/ZKSk67gKTHXPX
         pZ4w==
X-Gm-Message-State: AGi0PuYVNaakwH34aEYC9dID0SNgy9+eaD7Vq7R0No73YaV4bWyt2SxZ
        fpbmkQjhOYc7KpjYojSh3Yp9jzuYCB/ZGA==
X-Google-Smtp-Source: APiQypKJdA2qSGfKe9pCHnZTDpUzjjbVa8/7G8r1CHKpUvyWadRcy0iS07qo8g1yjey1kHax0zr+qD5q6+heBA==
X-Received: by 2002:a25:d757:: with SMTP id o84mr6996891ybg.144.1588962268930;
 Fri, 08 May 2020 11:24:28 -0700 (PDT)
Date:   Fri,  8 May 2020 11:24:25 -0700
Message-Id: <20200508182425.69249-1-jcargill@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.645.ge9eca65c58-goog
Subject: [PATCH] kvm: x86 mmu: avoid mmu_page_hash lookup for direct_map-only VM
From:   Jon Cargille <jcargill@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Peter Feiner <pfeiner@google.com>,
        Jon Cargille <jcargill@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peter Feiner <pfeiner@google.com>

Optimization for avoiding lookups in mmu_page_hash. When there's a
single direct root, a shadow page has at most one parent SPTE
(non-root SPs have exactly one; the root has none). Thus, if an SPTE
is non-present, it can be linked to a newly allocated SP without
first checking if the SP already exists.

This optimization has proven significant in batch large SP shattering
where the hash lookup accounted for 95% of the overhead.

Signed-off-by: Peter Feiner <pfeiner@google.com>
Signed-off-by: Jon Cargille <jcargill@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

---
 arch/x86/include/asm/kvm_host.h | 13 ++++++++
 arch/x86/kvm/mmu/mmu.c          | 55 +++++++++++++++++++--------------
 2 files changed, 45 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a239a297be33..9b70d764b626 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -913,6 +913,19 @@ struct kvm_arch {
 	struct kvm_page_track_notifier_node mmu_sp_tracker;
 	struct kvm_page_track_notifier_head track_notifier_head;
 
+	/*
+	 * Optimization for avoiding lookups in mmu_page_hash. When there's a
+	 * single direct root, a shadow page has at most one parent SPTE
+	 * (non-root SPs have exactly one; the root has none). Thus, if an SPTE
+	 * is non-present, it can be linked to a newly allocated SP without
+	 * first checking if the SP already exists.
+	 *
+	 * False initially because there are no indirect roots.
+	 *
+	 * Guarded by mmu_lock.
+	 */
+	bool shadow_page_may_have_multiple_parents;
+
 	struct list_head assigned_dev_head;
 	struct iommu_domain *iommu_domain;
 	bool iommu_noncoherent;
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e618472c572b..d94552b0ed77 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2499,35 +2499,40 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
 		quadrant &= (1 << ((PT32_PT_BITS - PT64_PT_BITS) * level)) - 1;
 		role.quadrant = quadrant;
 	}
-	for_each_valid_sp(vcpu->kvm, sp, gfn) {
-		if (sp->gfn != gfn) {
-			collisions++;
-			continue;
-		}
 
-		if (!need_sync && sp->unsync)
-			need_sync = true;
+	if (vcpu->kvm->arch.shadow_page_may_have_multiple_parents ||
+	    level == vcpu->arch.mmu->root_level) {
+		for_each_valid_sp(vcpu->kvm, sp, gfn) {
+			if (sp->gfn != gfn) {
+				collisions++;
+				continue;
+			}
 
-		if (sp->role.word != role.word)
-			continue;
+			if (!need_sync && sp->unsync)
+				need_sync = true;
 
-		if (sp->unsync) {
-			/* The page is good, but __kvm_sync_page might still end
-			 * up zapping it.  If so, break in order to rebuild it.
-			 */
-			if (!__kvm_sync_page(vcpu, sp, &invalid_list))
-				break;
+			if (sp->role.word != role.word)
+				continue;
 
-			WARN_ON(!list_empty(&invalid_list));
-			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
-		}
+			if (sp->unsync) {
+				/* The page is good, but __kvm_sync_page might
+				 * still end up zapping it.  If so, break in
+				 * order to rebuild it.
+				 */
+				if (!__kvm_sync_page(vcpu, sp, &invalid_list))
+					break;
 
-		if (sp->unsync_children)
-			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+				WARN_ON(!list_empty(&invalid_list));
+				kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+			}
 
-		__clear_sp_write_flooding_count(sp);
-		trace_kvm_mmu_get_page(sp, false);
-		goto out;
+			if (sp->unsync_children)
+				kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
+
+			__clear_sp_write_flooding_count(sp);
+			trace_kvm_mmu_get_page(sp, false);
+			goto out;
+		}
 	}
 
 	++vcpu->kvm->stat.mmu_cache_miss;
@@ -3735,6 +3740,10 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	gfn_t root_gfn, root_pgd;
 	int i;
 
+	spin_lock(&vcpu->kvm->mmu_lock);
+	vcpu->kvm->arch.shadow_page_may_have_multiple_parents = true;
+	spin_unlock(&vcpu->kvm->mmu_lock);
+
 	root_pgd = vcpu->arch.mmu->get_guest_pgd(vcpu);
 	root_gfn = root_pgd >> PAGE_SHIFT;
 
-- 
2.26.2.303.gf8c07b1a785-goog

