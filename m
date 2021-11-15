Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D4545286C
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 04:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345842AbhKPDTl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 22:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238652AbhKPDSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 22:18:03 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47659C125D58
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:20 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id y6-20020a17090322c600b001428ab3f888so6875297plg.8
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=TaawULiB60gNJQHEA+L17NJPz8Ipx3YceDb8vfSdElI=;
        b=YVCMfqo7x3YELrx++SmAnLWSRYdYMvUd7XOA/7N2LvPPnYgV9V3xB+YIpK9MmoDWi4
         HmEf1vhRPiBq65CO6iUKDp7MSvrjcXJ06eftMiP862dpT0FYE8WdlmYbXBv6jzDL8Os5
         DCvtd0gTnj9vwFa/HxOrZE+p6KEWugMim2yyz5HDo9JKkHCVVls3vzRnd+U9tQSinIOy
         BQSaJCBC4/0pMzPqJQctunAYdgx8CYkANU8IARqArmObCYCXpvz6T3HDrUkKXzChIgO8
         XxuIGZYlum/js6ZZD4OsFd4vyydu5TYKvNrdcE/dYiJ2eeAyuF0phXdRg915MyswHCtp
         qbMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TaawULiB60gNJQHEA+L17NJPz8Ipx3YceDb8vfSdElI=;
        b=Jtb/mwmxyK0xr3UkZx3ejHIb/+d2ZYtdO5VCgmzWML4sQGrP6+/QHNQSTuMSjVtIZt
         6rzAfrRWUXI9GhjVK/gc2UJ0hYLqlUYl4JZGRK3AloU5SQHamwn/muna6+k4ubIF6nmF
         4FGckIAJU4RSD5Ljs0d3xK+TsDTtfpd7BiQnkYTIZHhYW3+DMZPIQSuWwJ7Am1a0Qkvb
         qjJ1BbWtVSCMZj+o594wj6l/6ciuUTgagz8ne/tzMNGNgooU/mleUKIKiMzJSTe84Jt2
         EPfoKbwN1Zl1vLU7JQK6lHc5LGQKAIg89och/uZVcjR0z06h8z4kYeZ74VKHnkTJ6wsX
         41bg==
X-Gm-Message-State: AOAM531X6tyKjd6DCQ1eL5g5VvVbzYR3dQZZk8TTVdW69uUySLBvEXZU
        ahwnXOOwVRlAQpOCSMm+JA+JDW8LpmNq
X-Google-Smtp-Source: ABdhPJxCRMs7bDESGivm495NoEttjPJVoSUQjlL6shijeGmoCpLiTsFIqbnUqe9igl8QeSsFe3yaAH4wl0vA
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:916d:2253:5849:9965])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:2496:b0:49f:eba0:6575 with SMTP
 id c22-20020a056a00249600b0049feba06575mr36565288pfv.78.1637019979746; Mon,
 15 Nov 2021 15:46:19 -0800 (PST)
Date:   Mon, 15 Nov 2021 15:45:55 -0800
In-Reply-To: <20211115234603.2908381-1-bgardon@google.com>
Message-Id: <20211115234603.2908381-8-bgardon@google.com>
Mime-Version: 1.0
References: <20211115234603.2908381-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 07/15] KVM: x86/mmu: Factor shadow_zero_check out of make_spte
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
2.34.0.rc1.387.gb447b232ab-goog

