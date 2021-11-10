Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C225244CCC9
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:31:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233716AbhKJWdl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbhKJWdb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:31 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02D4C061208
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:42 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id k63-20020a628442000000b004812ea67c34so2755458pfd.2
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7mdCvtcLdHr4CBiJSM0JyhidXjaakUIXa0mwfIITG4U=;
        b=XN6a3I6PjHvm5Ar/2g+NNS3gv+POg2AhfK/2qSa/WIUkP5Unpm2fS1p2roOVcCTF2E
         ak5fz8+RtInZGm/GxLJDAl5DPUvywcDbiLqh0akEy6T25/vLL4QsbK6XLdSHe2sZLgeP
         63/6uu05RAXgqcmvtOMr2p4bK0bPa55sBHKzAPngPb7tiOHQ/+QAYTdV1AJm+fsLbuLp
         q8Hl+HOHGDF1DmkLv2LEB7SrHOGCRJZgvPw/W3iCar35oKr/OTrC34ecbo7YShyIA7Tk
         TFrQc+T+78K8bXiPjwG5DazWhnUNxmeaDBTtXB/wxj5xKTgA6ieBuGy+ugssRzH3PWjZ
         LjYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7mdCvtcLdHr4CBiJSM0JyhidXjaakUIXa0mwfIITG4U=;
        b=pxFlnepDUrJ1w4WuiJtGy4JhpzrnqD6XMYO9BCsKy6trh6ix5ojvLhNQxbnLmubLz1
         rv1vSbsxzjPwmADROSg8oZvepfPaqasHJG8j2rUXC1woWM8J5+WyBxRBNqvnRCgDgGUn
         mY5kmARiHMi8JvR9GQ+uUAg1DiC7prm0SqbFGHTvTe96SD/ad2WE05aiCcHCUFJwmC0n
         ayyCAlK5idPwRT5TkL2vZGT3eRZCMMPX3KiIV6Ann1250d+aYK32CqRGQ7J1TUtuwXF3
         0tQwEGHQ0uquoni9I4iO/jbZGVIVSkbxxM3HYkqtgibZaC9xQud1kBA+wZ4vfKwEky0F
         eMeg==
X-Gm-Message-State: AOAM530AkGp48gomFYJxpIDnubFgmSFyCR2sA9lTWK4dTpTngKyZxIXj
        YXtHH6UCyhTDG69WfFhA8EwrfObzWVpJ
X-Google-Smtp-Source: ABdhPJzgUfoZW15hmkTkx4ifInPQGv4C5+MNkhrE8JA+yI2RTx3AKNuUgQK/Us4wcCAzHAXrVvzbwGpbNnyS
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a65:6a4a:: with SMTP id
 o10mr1488725pgu.357.1636583442186; Wed, 10 Nov 2021 14:30:42 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:29:58 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-8-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 07/19] KVM: x86/mmu: Factor wrprot for nested PML out of make_spte
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

When running a nested VM, KVM write protects SPTEs in the EPT/NPT02
instead of using PML for dirty tracking. This avoids expensive
translation later, when emptying the Page Modification Log. In service
of removing the vCPU pointer from make_spte, factor the check for nested
PML out of the function.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/spte.c | 10 +++++++---
 arch/x86/kvm/mmu/spte.h |  3 ++-
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 04d26e913941..3cf08a534a16 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -92,7 +92,8 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       struct kvm_memory_slot *slot, unsigned int pte_access,
 	       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
-	       bool can_unsync, bool host_writable, u64 *new_spte)
+	       bool can_unsync, bool host_writable, bool ad_need_write_protect,
+	       u64 *new_spte)
 {
 	int level = sp->role.level;
 	u64 spte = SPTE_MMU_PRESENT_MASK;
@@ -100,7 +101,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 
 	if (sp->role.ad_disabled)
 		spte |= SPTE_TDP_AD_DISABLED_MASK;
-	else if (kvm_vcpu_ad_need_write_protect(vcpu))
+	else if (ad_need_write_protect)
 		spte |= SPTE_TDP_AD_WRPROT_ONLY_MASK;
 
 	/*
@@ -195,8 +196,11 @@ bool vcpu_make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		    gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
 		    bool can_unsync, bool host_writable, u64 *new_spte)
 {
+	bool ad_need_write_protect = kvm_vcpu_ad_need_write_protect(vcpu);
+
 	return make_spte(vcpu, sp, slot, pte_access, gfn, pfn, old_spte,
-			 prefetch, can_unsync, host_writable, new_spte);
+			 prefetch, can_unsync, host_writable,
+			 ad_need_write_protect, new_spte);
 
 }
 
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 14f18082d505..bcf58602f224 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -332,7 +332,8 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	       struct kvm_memory_slot *slot, unsigned int pte_access,
 	       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
-	       bool can_unsync, bool host_writable, u64 *new_spte);
+	       bool can_unsync, bool host_writable, bool ad_need_write_protect,
+	       u64 *new_spte);
 bool vcpu_make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		    struct kvm_memory_slot *slot,
 		    unsigned int pte_access, gfn_t gfn, kvm_pfn_t pfn,
-- 
2.34.0.rc0.344.g81b53c2807-goog

