Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5793EB5EA
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 15:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240533AbhHMNB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 09:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235482AbhHMNB6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Aug 2021 09:01:58 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEEBC061756;
        Fri, 13 Aug 2021 06:01:30 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id w13-20020a17090aea0db029017897a5f7bcso15883269pjy.5;
        Fri, 13 Aug 2021 06:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bnLufpfO1M/I0xXk1CEZGAksMpuuRTVMW7Qe6CF1MNM=;
        b=qWyG8cDiK9tplNUY6xeZ+GTCqAL96tvC3AbXuBanDLBseByBHcN975QrMsaexrCh8t
         ZNYz9prevV+/MoRTMv1vn+Wn5rmLxqI3pt6Q3hr30/fm71wGygC0mGVDH3o7ho0T2lEp
         EVmZGvTv6Ebm1aIvzCycWM3EX92AAfApGOSMOaqCDi8L4pKFKDkf05VQS9dvGbIgm40a
         uptt6oauxH5oNvQhbsPW+FKZ5+lM53I1vWYOEdBPuQDi/IDMTptozg1WjrBL2GDfM3e7
         Dewja1QQ8U5cMHmo7GVd4ejeBCJ+Mff4/Yyh8hdiDJw5HliUJJXD3BRhmBBjznNBL90u
         0Q9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bnLufpfO1M/I0xXk1CEZGAksMpuuRTVMW7Qe6CF1MNM=;
        b=MzoT+PP2xvDluCGtfU5OqUIRCJ6XNwArFhjAiQ3sa2slEXLzhsM2NXMVJQgsEm1W4/
         2qbRvtRukLKNAANGdnOkJ0LiTFyfExI6XMFDn9bcym9NlDb/dNchyC0+PeiRjX8YxyvY
         beIZPrKhKT+5tql74qYN2OPmS2iAIfkZfBZivSfT3xXsDCj6FY5ZcKn+VFh+O+EcjR34
         uWOGn5UKu/G2O7ScW6Ehj/KHvtX4zS5ITxgkjv931rr5I4DXYl2oWxH3wXJUEwCqhHLP
         1I0XbeK2MHRvPWKs9OS5iRe0oZHuCYo30XsaOXdFgRvbozVCC/JcNUzG+V89H1qTAITP
         pduA==
X-Gm-Message-State: AOAM531QzJHwJAfWM7npaKa3yDMZgEH2zSh3JfwT5wLHk434t52I9a1O
        FzUOuSVNZUeAsKdOC9RvAmMHUZWQyEA=
X-Google-Smtp-Source: ABdhPJwWIJAyWWXRjchKYtPa3S08favAB92SPIop/1hS7R+V7f8QBr+73c7UZXdirV21DtbOd0MGAQ==
X-Received: by 2002:a63:a902:: with SMTP id u2mr2280975pge.123.1628859689239;
        Fri, 13 Aug 2021 06:01:29 -0700 (PDT)
Received: from localhost ([47.251.4.198])
        by smtp.gmail.com with ESMTPSA id o20sm2805425pgv.80.2021.08.13.06.01.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 13 Aug 2021 06:01:28 -0700 (PDT)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: [PATCH V2] KVM: X86: Move PTE present check from loop body to  __shadow_walk_next()
Date:   Fri, 13 Aug 2021 11:16:29 +0800
Message-Id: <20210813031629.78670-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <YRVGY1ZK8wl9ybBH@google.com>
References: <YRVGY1ZK8wl9ybBH@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

So far, the loop bodies already ensure the PTE is present before calling
__shadow_walk_next():  Some loop bodies simply exit with a !PRESENT
directly and some other loop bodies, i.e. FNAME(fetch) and __direct_map()
do not currently terminate their walks with a !PRESENT, but they get away
with it because they install present non-leaf SPTEs in the loop itself.

But checking pte present in __shadow_walk_next() is a more prudent way of
programing and loop bodies will not need to always check it. It allows us
removing unneded is_shadow_present_pte() in the loop bodies.

Terminating on !is_shadow_present_pte() is 100% the correct behavior, as
walking past a !PRESENT SPTE would lead to attempting to read a the next
level SPTE from a garbage iter->shadow_addr.  Even some paths that do _not_
currently have a !is_shadow_present_pte() in the loop body is Ok since
they will install present non-leaf SPTEs and the additinal present check
is just an NOP.

The checking result in __shadow_walk_next() will be propagated to
shadow_walk_okay() for being used in any for(;;) loop.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
Changed from V1:
	Merge the two patches
	Update changelog
	Remove !is_shadow_present_pte() in FNAME(invlpg)
 arch/x86/kvm/mmu/mmu.c         | 13 ++-----------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a272ccbddfa1..42eebba6782e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2231,7 +2231,7 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 static void __shadow_walk_next(struct kvm_shadow_walk_iterator *iterator,
 			       u64 spte)
 {
-	if (is_last_spte(spte, iterator->level)) {
+	if (!is_shadow_present_pte(spte) || is_last_spte(spte, iterator->level)) {
 		iterator->level = 0;
 		return;
 	}
@@ -3152,9 +3152,6 @@ static u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
 	for_each_shadow_entry_lockless(vcpu, gpa, iterator, old_spte) {
 		sptep = iterator.sptep;
 		*spte = old_spte;
-
-		if (!is_shadow_present_pte(old_spte))
-			break;
 	}
 
 	return sptep;
@@ -3694,9 +3691,6 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
 		spte = mmu_spte_get_lockless(iterator.sptep);
 
 		sptes[leaf] = spte;
-
-		if (!is_shadow_present_pte(spte))
-			break;
 	}
 
 	return leaf;
@@ -3811,11 +3805,8 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
 	u64 spte;
 
 	walk_shadow_page_lockless_begin(vcpu);
-	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte) {
+	for_each_shadow_entry_lockless(vcpu, addr, iterator, spte)
 		clear_sp_write_flooding_count(iterator.sptep);
-		if (!is_shadow_present_pte(spte))
-			break;
-	}
 	walk_shadow_page_lockless_end(vcpu);
 }
 
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index f70afecbf3a2..13138b03cc69 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -977,7 +977,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 			FNAME(update_pte)(vcpu, sp, sptep, &gpte);
 		}
 
-		if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)
+		if (!sp->unsync_children)
 			break;
 	}
 	write_unlock(&vcpu->kvm->mmu_lock);
-- 
2.19.1.6.gb485710b

