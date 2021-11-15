Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2404B452869
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 04:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245343AbhKPDTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Nov 2021 22:19:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239072AbhKPDSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Nov 2021 22:18:03 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B36C125D5A
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:22 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id m16-20020a628c10000000b004a282d715b2so5365825pfd.11
        for <kvm@vger.kernel.org>; Mon, 15 Nov 2021 15:46:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NK+8rYcOVoQTEX0gJ6Fr1MIpj494/IRugHRkqHwCiJU=;
        b=h6gkAhTxTIqpYt3pIdFjjD79PneayWjH+Kmp6eYcncUPoQ5fS0LdsmhoG90DPNXguz
         y5hRRppS0kc1q3IyJOrcWXAppggGAAuYSOvY21AmfBUlLLPYijYNfgyulKE0hZ4RgIt4
         DM7ipK8npI6H5ps/rfev9KyE0cHdW1BXB5/o2AJVqCNEN8ygBHDI0uj4sGQFR0I/Ky+n
         +XkypehF0mN7p3pwwLDHStg86m0NuLdV753adrYDj+nFMtI35G/69v4wZ9Xwmbx6A3TM
         WRnvIWKIBXoVzXH5iEx3iMN/yGluNHf4aBXnVixf65ayk8odyi52jMHF2z8uuidXslac
         AIhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NK+8rYcOVoQTEX0gJ6Fr1MIpj494/IRugHRkqHwCiJU=;
        b=wsVugdFyxRadRJPFV2uvfmPrKnxJF/phut0P13BuSF30dQ2vo8I+RAr5Maq+Rwf1L2
         pzzgjCNKXaTOz8BUFs5SVmUKzKdAxld+W/TzZ/MAmV03aGEIOTn/bbf1DUwBzvGkj+ES
         39qyy+/8Ow4Fs+F6qJO3MJMKp+9hv6uSNr5ZIW8cgL0WleMy4t+rTMbQEVd0cTj4ZSGn
         GLprT6V2DSee2oZtY4VfPawyvtUegyaW3XcfdD8GLBMVeO0rBatmAZaoDzvfnc7NKUVp
         a4ycNilUkGpCj3xjMwxnBRVxKflpE52bUWRLhxcApjwH/baWIlpyl8gEAHecfW7RPv92
         53zA==
X-Gm-Message-State: AOAM532StueBfZkU9XMha3ir6xHH6hx8kjQO0ecR7fetXFpZkmG9jFaY
        KC9/MQLoBcO976m9FhGVmpJ2bqiUULSN
X-Google-Smtp-Source: ABdhPJye/DO3A/CAHjinV+X6XSHTaIT7/Y4KHsao3Dc96K/pWGVR+UoPfq4WWIv0S5be28xFqsIIbeQNYaom
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:916d:2253:5849:9965])
 (user=bgardon job=sendgmr) by 2002:a65:6854:: with SMTP id
 q20mr1884133pgt.240.1637019981859; Mon, 15 Nov 2021 15:46:21 -0800 (PST)
Date:   Mon, 15 Nov 2021 15:45:56 -0800
In-Reply-To: <20211115234603.2908381-1-bgardon@google.com>
Message-Id: <20211115234603.2908381-9-bgardon@google.com>
Mime-Version: 1.0
References: <20211115234603.2908381-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc1.387.gb447b232ab-goog
Subject: [PATCH 08/15] KVM: x86/mmu: Replace vcpu argument with kvm pointer in make_spte
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

No that nothing in make_spte actually needs the vCPU argument, just
pass in a pointer to the struct kvm. This allows the function to be used
in situations where there is no relevant struct vcpu.

No functional change intended.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/spte.c | 8 ++++----
 arch/x86/kvm/mmu/spte.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index d3b059e96c6e..d98723b14cec 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -89,7 +89,7 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 				     E820_TYPE_RAM);
 }
 
-bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+bool make_spte(struct kvm *kvm, struct kvm_mmu_page *sp,
 	       struct kvm_memory_slot *slot, unsigned int pte_access,
 	       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
 	       bool can_unsync, bool host_writable, bool ad_need_write_protect,
@@ -161,7 +161,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 * e.g. it's write-tracked (upper-level SPs) or has one or more
 		 * shadow pages and unsync'ing pages is not allowed.
 		 */
-		if (mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, can_unsync, prefetch)) {
+		if (mmu_try_to_unsync_pages(kvm, slot, gfn, can_unsync, prefetch)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
 			wrprot = true;
@@ -184,7 +184,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 	if ((spte & PT_WRITABLE_MASK) && kvm_slot_dirty_track_enabled(slot)) {
 		/* Enforced by kvm_mmu_hugepage_adjust. */
 		WARN_ON(level > PG_LEVEL_4K);
-		mark_page_dirty_in_slot(vcpu->kvm, slot, gfn);
+		mark_page_dirty_in_slot(kvm, slot, gfn);
 	}
 
 	*new_spte = spte;
@@ -201,7 +201,7 @@ bool vcpu_make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 						       kvm_is_mmio_pfn(pfn));
 	struct rsvd_bits_validate *shadow_zero_check = &vcpu->arch.mmu->shadow_zero_check;
 
-	return make_spte(vcpu, sp, slot, pte_access, gfn, pfn, old_spte,
+	return make_spte(vcpu->kvm, sp, slot, pte_access, gfn, pfn, old_spte,
 			 prefetch, can_unsync, host_writable,
 			 ad_need_write_protect, mt_mask, shadow_zero_check,
 			 new_spte);
diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index 6134a10487c4..5bb055688080 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -329,7 +329,7 @@ static inline u64 get_mmio_spte_generation(u64 spte)
 	return gen;
 }
 
-bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
+bool make_spte(struct kvm *kvm, struct kvm_mmu_page *sp,
 	       struct kvm_memory_slot *slot, unsigned int pte_access,
 	       gfn_t gfn, kvm_pfn_t pfn, u64 old_spte, bool prefetch,
 	       bool can_unsync, bool host_writable, bool ad_need_write_protect,
-- 
2.34.0.rc1.387.gb447b232ab-goog

