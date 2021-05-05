Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A785373AEE
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 14:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233395AbhEEMSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 08:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233518AbhEEMRx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 08:17:53 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E31C06138F;
        Wed,  5 May 2021 05:15:26 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id p17so697332pjz.3;
        Wed, 05 May 2021 05:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oyHwnIbZLLevfNDzdT6CM1DYrT1P/eF7j4L5Cf+qIR4=;
        b=SXSIIPseqld8EsKpB9fNO9vdeGXr/v8noETf6vr642IHwFrh+spYCo9atcasz023yS
         qVySb6P9Rie9BqVrrHATGQ9EatZvDd6J12fGDf944ukVwjuZXIWPZIvwkD0LC7kAM+03
         aTZBk6o02Zaxp5+pSZ471MByxYyjc3/h4fj6C1dO10L0Jk6e2zsID1tuuoIBvIgJrkk9
         9Tqok7EnUvdb0Kg4cj8GnzYuGcZ6il4/WoqmPmIADolprN+RSdPhML+S9G3SknGuVeZm
         crO5+UMTC5IW7UvqqR1KRd5ZaRUaIiIpBBzx0WaMxG7Ij91x1/Nw+8OcCNTLNhKrRHnB
         qD+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oyHwnIbZLLevfNDzdT6CM1DYrT1P/eF7j4L5Cf+qIR4=;
        b=j0XYQp1xlXSpUoRY3e/HuIf5AmkPOa28QHjjgvtejm/D2xEF7oTUTU9dZ82vvBmxW0
         kF7CiNcFL4+3GjerTRvVgKLgeiyFHEsPaKGs0sgNn3P/RGOIave7SkaFOFV/8c+p21k5
         UX7ObuvgklNrDrwvl1gwDo9Yn6hyZQ9dC7qe0GBNFQfg8jZ9xI1jRG5R1ZXIu4WDbkvQ
         L42LoUIgv0z8xLiZRh33XflzpIXv6O1DycY5fXgHRgnqlz4lB1FzpHKOMqrjuEW4QLKQ
         3cGPbfX7XrbR0zP7pyoGwg+PuvGQ9+pFlm+z2bHstBHsrLyd1RDPh7NxUJRuGigkIVOc
         s5jw==
X-Gm-Message-State: AOAM533F152lJlkxqE3RiENP+7gksnM1Ohc3xK4biqF1RFUPfTtxjEWF
        FZy0DXPfeGmB+6QK2KevEb9NsqiK7a4=
X-Google-Smtp-Source: ABdhPJwqGY80yo9FMB+w8ED2zdJKVQ2H2OOCk9+HBaaFhnPzYsKRiWudVo7ZrYUfKFfCx45R6y5zTg==
X-Received: by 2002:a17:902:8b86:b029:e5:bef6:56b0 with SMTP id ay6-20020a1709028b86b02900e5bef656b0mr30448266plb.76.1620216926016;
        Wed, 05 May 2021 05:15:26 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com ([61.68.127.20])
        by smtp.gmail.com with ESMTPSA id cv24sm14655694pjb.7.2021.05.05.05.15.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 05:15:25 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     kvm-ppc@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Sean Christopherson <seanjc@google.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Bharata B Rao <bharata@linux.ibm.com>
Subject: [PATCH] KVM: PPC: Book3S HV: Fix conversion to gfn-based MMU notifier callbacks
Date:   Wed,  5 May 2021 22:15:09 +1000
Message-Id: <20210505121509.1470207-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU notifier
callbacks") causes unmap_gfn_range and age_gfn callbacks to only work
on the first gfn in the range. It also makes the aging callbacks call
into both radix and hash aging functions for radix guests. Fix this.

Add warnings for the single-gfn calls that have been converted to range
callbacks, in case they ever receieve ranges greater than 1.

Fixes: b1c5356e873c ("KVM: PPC: Convert to the gfn-based MMU notifier callbacks")
Reported-by: Bharata B Rao <bharata@linux.ibm.com>
Tested-by: Bharata B Rao <bharata@linux.ibm.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
The e500 change in that commit also looks suspicious, why is it okay
to remove kvm_flush_remote_tlbs() there? Also is the the change from
returning false to true intended?

Thanks,
Nick

 arch/powerpc/include/asm/kvm_book3s.h  |  2 +-
 arch/powerpc/kvm/book3s_64_mmu_hv.c    | 46 ++++++++++++++++++--------
 arch/powerpc/kvm/book3s_64_mmu_radix.c |  5 ++-
 3 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index a6e9a5585e61..e6b53c6e21e3 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -210,7 +210,7 @@ extern void kvmppc_free_pgtable_radix(struct kvm *kvm, pgd_t *pgd,
 				      unsigned int lpid);
 extern int kvmppc_radix_init(void);
 extern void kvmppc_radix_exit(void);
-extern bool kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
+extern void kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			    unsigned long gfn);
 extern bool kvm_age_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			  unsigned long gfn);
diff --git a/arch/powerpc/kvm/book3s_64_mmu_hv.c b/arch/powerpc/kvm/book3s_64_mmu_hv.c
index b7bd9ca040b8..2d9193cd73be 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_hv.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_hv.c
@@ -795,7 +795,7 @@ static void kvmppc_unmap_hpte(struct kvm *kvm, unsigned long i,
 	}
 }
 
-static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
+static void kvm_unmap_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
 			    unsigned long gfn)
 {
 	unsigned long i;
@@ -829,15 +829,21 @@ static bool kvm_unmap_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		unlock_rmap(rmapp);
 		__unlock_hpte(hptep, be64_to_cpu(hptep[0]));
 	}
-	return false;
 }
 
 bool kvm_unmap_gfn_range_hv(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	if (kvm_is_radix(kvm))
-		return kvm_unmap_radix(kvm, range->slot, range->start);
+	gfn_t gfn;
+
+	if (kvm_is_radix(kvm)) {
+		for (gfn = range->start; gfn < range->end; gfn++)
+			kvm_unmap_radix(kvm, range->slot, gfn);
+	} else {
+		for (gfn = range->start; gfn < range->end; gfn++)
+			kvm_unmap_rmapp(kvm, range->slot, range->start);
+	}
 
-	return kvm_unmap_rmapp(kvm, range->slot, range->start);
+	return false;
 }
 
 void kvmppc_core_flush_memslot_hv(struct kvm *kvm,
@@ -924,10 +930,18 @@ static bool kvm_age_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
 
 bool kvm_age_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	if (kvm_is_radix(kvm))
-		kvm_age_radix(kvm, range->slot, range->start);
+	gfn_t gfn;
+	bool ret = false;
 
-	return kvm_age_rmapp(kvm, range->slot, range->start);
+	if (kvm_is_radix(kvm)) {
+		for (gfn = range->start; gfn < range->end; gfn++)
+			ret |= kvm_age_radix(kvm, range->slot, gfn);
+	} else {
+		for (gfn = range->start; gfn < range->end; gfn++)
+			ret |= kvm_age_rmapp(kvm, range->slot, gfn);
+	}
+
+	return ret;
 }
 
 static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
@@ -965,18 +979,24 @@ static bool kvm_test_age_rmapp(struct kvm *kvm, struct kvm_memory_slot *memslot,
 
 bool kvm_test_age_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	if (kvm_is_radix(kvm))
-		kvm_test_age_radix(kvm, range->slot, range->start);
+	WARN_ON(range->start + 1 != range->end);
 
-	return kvm_test_age_rmapp(kvm, range->slot, range->start);
+	if (kvm_is_radix(kvm))
+		return kvm_test_age_radix(kvm, range->slot, range->start);
+	else
+		return kvm_test_age_rmapp(kvm, range->slot, range->start);
 }
 
 bool kvm_set_spte_gfn_hv(struct kvm *kvm, struct kvm_gfn_range *range)
 {
+	WARN_ON(range->start + 1 != range->end);
+
 	if (kvm_is_radix(kvm))
-		return kvm_unmap_radix(kvm, range->slot, range->start);
+		kvm_unmap_radix(kvm, range->slot, range->start);
+	else
+		kvm_unmap_rmapp(kvm, range->slot, range->start);
 
-	return kvm_unmap_rmapp(kvm, range->slot, range->start);
+	return false;
 }
 
 static int vcpus_running(struct kvm *kvm)
diff --git a/arch/powerpc/kvm/book3s_64_mmu_radix.c b/arch/powerpc/kvm/book3s_64_mmu_radix.c
index ec4f58fa9f5a..d909c069363e 100644
--- a/arch/powerpc/kvm/book3s_64_mmu_radix.c
+++ b/arch/powerpc/kvm/book3s_64_mmu_radix.c
@@ -993,7 +993,7 @@ int kvmppc_book3s_radix_page_fault(struct kvm_vcpu *vcpu,
 }
 
 /* Called with kvm->mmu_lock held */
-bool kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
+void kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 		     unsigned long gfn)
 {
 	pte_t *ptep;
@@ -1002,14 +1002,13 @@ bool kvm_unmap_radix(struct kvm *kvm, struct kvm_memory_slot *memslot,
 
 	if (kvm->arch.secure_guest & KVMPPC_SECURE_INIT_DONE) {
 		uv_page_inval(kvm->arch.lpid, gpa, PAGE_SHIFT);
-		return false;
+		return;
 	}
 
 	ptep = find_kvm_secondary_pte(kvm, gpa, &shift);
 	if (ptep && pte_present(*ptep))
 		kvmppc_unmap_pte(kvm, ptep, gpa, shift, memslot,
 				 kvm->arch.lpid);
-	return false;
 }
 
 /* Called with kvm->mmu_lock held */
-- 
2.23.0

