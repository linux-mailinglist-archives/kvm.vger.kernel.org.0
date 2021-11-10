Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A744044CCCC
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233959AbhKJWdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:33:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233947AbhKJWdk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:40 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04325C061208
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:52 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id 65-20020a630344000000b002d9865f61efso2198985pgd.16
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=42+d8YjAZxClfWgdhFomXy37B3KIO2GCLS50eyLEhmM=;
        b=Io7wOvgnheuOgfMytVU2lNhyzaqT1yMo7DnIxxVjg3AiREAoEdMqEOYFJEwc8qusVi
         brk8qH7Hn8m+rhZrHwzYHFlDS/t96TGUkgWbNW7tlbOm51sf/irvYkVc+3agDMVaYvwa
         LS4KSwNLvyXPv52GJHfxArHXpSGdD2EtuHSyAhfOupFdyWmw/uLz+qN2YoAzSpOUarwY
         W3CvNk1Kg1ifL3rbu0n7cY6OjCThFfEQqxkY8b1tyLhdfvdEzLnZd69DN7cg2JADv1vN
         LkHLSkdh5Ro5vtGgPwoUOZbJ+3fxG5dudh4JnMzyhbNIy9pF6VIQ69KdQvtgnR32oBnf
         Hc7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=42+d8YjAZxClfWgdhFomXy37B3KIO2GCLS50eyLEhmM=;
        b=MftPl+2LXX2w5xbZU5JwTlg3evuYHlDVlLrITk57Dn0YiF6pxbLj+KEQ3Tk5XSROrB
         7YReleOc6ivMnFnLP6aBH01fgSK/MRIooOBhsKfbaJVUf41/L7rccYgTtJycmZ69KLTi
         jJrSvnzKwgRRe+obterTguxYDdpWgrhJLFuChw+JnrRM8/4Q93dFMWeIlE6WkZVzDlUA
         C7brm/rwCtTuvcraypIpQZnCZpKOWEcZyy6f24y48gp3Wmfy4J2AU1f8anTewe41wHPZ
         ghxkRuRV7OVRwvjI8+3JpGdU2PSG74d/U9kqgtGSRKO2lardtylBbtu0VeUmmrs31/dV
         +n6g==
X-Gm-Message-State: AOAM533ZpMGRniE9uf3X88BP5aAufrZKw3nywnkCfgVdynqNxAleN2Vw
        03jSgm6oA3/lt/G8LDCPQdTBQc/ypcKS
X-Google-Smtp-Source: ABdhPJwwo4pGevtCowaRTd49LsoEZHU1m3kSXl8vfKEeqFOgmriW6TQS89bHjWS2JWZtAPzyZnz/XH5+2dK+
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a17:90a:284f:: with SMTP id
 p15mr48592pjf.1.1636583451110; Wed, 10 Nov 2021 14:30:51 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:30:01 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-11-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 10/19] KVM: x86/mmu: Remove need for a vcpu from mmu_try_to_unsync_pages
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

The vCPU argument to mmu_try_to_unsync_pages is now only used to get a
pointer to the associated struct kvm, so pass in the kvm pointer from
the beginning to remove the need for a vCPU when calling the function.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 16 ++++++++--------
 arch/x86/kvm/mmu/mmu_internal.h |  2 +-
 arch/x86/kvm/mmu/spte.c         |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7d0da79668c0..1e890509b93f 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2561,10 +2561,10 @@ static int kvm_mmu_unprotect_page_virt(struct kvm_vcpu *vcpu, gva_t gva)
 	return r;
 }
 
-static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
+static void kvm_unsync_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	trace_kvm_mmu_unsync_page(sp);
-	++vcpu->kvm->stat.mmu_unsync;
+	++kvm->stat.mmu_unsync;
 	sp->unsync = 1;
 
 	kvm_mmu_mark_parents_unsync(sp);
@@ -2576,7 +2576,7 @@ static void kvm_unsync_page(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp)
  * were marked unsync (or if there is no shadow page), -EPERM if the SPTE must
  * be write-protected.
  */
-int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+int mmu_try_to_unsync_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    gfn_t gfn, bool can_unsync, bool prefetch)
 {
 	struct kvm_mmu_page *sp;
@@ -2587,7 +2587,7 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	 * track machinery is used to write-protect upper-level shadow pages,
 	 * i.e. this guards the role.level == 4K assertion below!
 	 */
-	if (kvm_slot_page_track_is_active(vcpu->kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
 		return -EPERM;
 
 	/*
@@ -2596,7 +2596,7 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	 * that case, KVM must complete emulation of the guest TLB flush before
 	 * allowing shadow pages to become unsync (writable by the guest).
 	 */
-	for_each_gfn_indirect_valid_sp(vcpu->kvm, sp, gfn) {
+	for_each_gfn_indirect_valid_sp(kvm, sp, gfn) {
 		if (!can_unsync)
 			return -EPERM;
 
@@ -2615,7 +2615,7 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 		 */
 		if (!locked) {
 			locked = true;
-			spin_lock(&vcpu->kvm->arch.mmu_unsync_pages_lock);
+			spin_lock(&kvm->arch.mmu_unsync_pages_lock);
 
 			/*
 			 * Recheck after taking the spinlock, a different vCPU
@@ -2630,10 +2630,10 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 		}
 
 		WARN_ON(sp->role.level != PG_LEVEL_4K);
-		kvm_unsync_page(vcpu, sp);
+		kvm_unsync_page(kvm, sp);
 	}
 	if (locked)
-		spin_unlock(&vcpu->kvm->arch.mmu_unsync_pages_lock);
+		spin_unlock(&kvm->arch.mmu_unsync_pages_lock);
 
 	/*
 	 * We need to ensure that the marking of unsync pages is visible
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 52c6527b1a06..1073d10cce91 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -118,7 +118,7 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 	       kvm_x86_ops.cpu_dirty_log_size;
 }
 
-int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
+int mmu_try_to_unsync_pages(struct kvm *kvm, struct kvm_memory_slot *slot,
 			    gfn_t gfn, bool can_unsync, bool prefetch);
 
 void kvm_mmu_gfn_disallow_lpage(const struct kvm_memory_slot *slot, gfn_t gfn);
diff --git a/arch/x86/kvm/mmu/spte.c b/arch/x86/kvm/mmu/spte.c
index 75c666d3e7f1..b7271daa06c5 100644
--- a/arch/x86/kvm/mmu/spte.c
+++ b/arch/x86/kvm/mmu/spte.c
@@ -160,7 +160,7 @@ bool make_spte(struct kvm_vcpu *vcpu, struct kvm_mmu_page *sp,
 		 * e.g. it's write-tracked (upper-level SPs) or has one or more
 		 * shadow pages and unsync'ing pages is not allowed.
 		 */
-		if (mmu_try_to_unsync_pages(vcpu, slot, gfn, can_unsync, prefetch)) {
+		if (mmu_try_to_unsync_pages(vcpu->kvm, slot, gfn, can_unsync, prefetch)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
 			wrprot = true;
-- 
2.34.0.rc0.344.g81b53c2807-goog

