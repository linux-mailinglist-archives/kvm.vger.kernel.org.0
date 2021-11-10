Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A9644CCCE
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:31:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbhKJWdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbhKJWdm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:42 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D13C06127A
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:54 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id u6-20020a63f646000000b002dbccd46e61so2188621pgj.18
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kuLHe6e00eLqYAgnzNJ6bYA8Sh2Prapi6rstCXNiDsA=;
        b=lnI1+kEabppgiUIHN+wwolHhYiIObAfxxJmXyqQ4dQLUkXQAXdoU3vOfmwZdlyEyWR
         1xY7S4WV4tbj7B6FbCdgqztWGP1YWwzjYbfPh7TdrtzPzYmV9WeDcH4aerdaujpPjxum
         lPGSfaJnHzO9E3dtYABLxaXZWcGealMZ/fXQBui4k7KUukcITmBdDxjrruRQKJvGukMb
         RQuMXtjJ9gJuPSktwQhvbBO/+A0boTU8OR4uEVRuPaO8JPRUb8uFXN6LaD8gColctetV
         4Yci/bND2JX7QM+MxIZlJp+eT61PleH+OgzHHTeByK00mXVBLgm+BsZOnJWSH6vm+agQ
         FtDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kuLHe6e00eLqYAgnzNJ6bYA8Sh2Prapi6rstCXNiDsA=;
        b=6fkm0e1+gYhmN2zMsV6D2UKLt0d64lwLSyqrsCEueXVT0DbImuV33Fb5T/cX+m+wCu
         M1yaF/3NGI6tSBhTOhD851E0nCjTLwecuQdZPjUFuBJ6xQb2vDoK5EME9v57ylJYTfTW
         Tonk06pVDpVzOM/govDD22h51BroG9K0Y/bSfH3b/TZ9XbsqF5dji3LszrGKQdebNcpA
         gXh7mMHGG4dwxwokgTrnge5Y6YeC8a5sglJ9/jW6VreTev5FPNGwjMKE7CatsqHB/8ZU
         fhODCLUMn/wnmrBFErLHeAMEt9fARGcCDXauBPx2bvXwg0wyMWP3xNxrxEu8aiTb/Q5m
         TPVA==
X-Gm-Message-State: AOAM532OdubLp+/O6tX63vwmaAlXbQxfyremRo+LsswSow/9QqiCLe0R
        FzmPQuBT311lglonauHEGUZ4Yy4dFoz5
X-Google-Smtp-Source: ABdhPJz01H22b5GUVOY5rp3KousEMs96eKNC+pb2NAZAn6edDHG5YGrvBlD81bLMGSnt78nu1exsqRQJlY0A
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:aa7:8059:0:b0:47e:5de6:5bc7 with SMTP id
 y25-20020aa78059000000b0047e5de65bc7mr2360482pfm.78.1636583454003; Wed, 10
 Nov 2021 14:30:54 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:30:02 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-12-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 11/19] KVM: x86/mmu: Factor shadow_zero_check out of make_spte
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the interest of devloping a version of make_spte that can function
without a vCPU pointer, factor out the shadow_zero_mask to be an
additional argument to the function.

No functional change intended.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/spte.c | 11 +++++++----
 arch/x86/kvm/mmu/spte.h |  3 ++-
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index b7271daa06c5..d3b059e96c6e 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -93,7 +93,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       struct kvm_memory_slot *slot, unsigned int pte_access,
 	       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
 	       bool can_unsync, bool host_writable, bool ad_need_write_protect,
-	       u64 mt_mask, u64 *new_spte)
+	       u64 mt_mask, struct rsvd_bits_validate *shadow_zero_check,
+	       u64 *new_spte)
 {
 	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
@@ -176,9 +177,9 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if (prefetch)
 		spte = mark_spte_for_access_track(spte);
 
-	WARN_ONCE(is_rsvd_spte(&vcpu->arch.mmu->shadow_zero_check, spte, level),
+	WARN_ONCE(is_rsvd_spte(shadow_zero_check, spte, level),
 		  "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
-		  get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
+		  get_rsvd_bits(shadow_zero_check, spte, level));
 
 	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
@@ -198,10 +199,12 @@ bool vcpu_make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	bool ad_need_write_protect = kvm_vcpu_ad_need_write_protect(vcpu);
 	u64 mt_mask = static_call(kvm_x86_get_mt_mask)(vcpu, gfn,
 						       kvm_is_mmio_pfn(pfn));
+	struct rsvd_bits_validate *shadow_zero_check = &vcpu->arch.mmu->shadow_zero_check;
 
 	return make_spte(vcpu, sp, slot, pte_access, gfn, pfn, old_spte,
 			 prefetch, can_unsync, host_writable,
-			 ad_need_write_protect, mt_mask, new_spte);
+			 ad_need_write_protect, mt_mask, shadow_zero_check,
+			 new_spte);
 
 }
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index e739f2ebf844..6134a10487c4 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -333,7 +333,8 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       struct kvm_memory_slot *slot, unsigned int pte_access,
 	       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
 	       bool can_unsync, bool host_writable, bool ad_need_write_protect,
-	       u64 mt_mask, u64 *new_spte);
+	       u64 mt_mask, struct rsvd_bits_validate *shadow_zero_check,
+	       u64 *new_spte);
 bool vcpu_make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		    struct kvm_memory_slot *slot,
 		    unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-- 
2.34.0.rc0.344.g81b53c2807-goog

