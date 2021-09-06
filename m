Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51C84401B26
	for <lists+kvm@lfdr.de>; Mon,  6 Sep 2021 14:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242129AbhIFM0u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Sep 2021 08:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242113AbhIFM0t (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Sep 2021 08:26:49 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044B4C061757;
        Mon,  6 Sep 2021 05:25:45 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id c6so4225933pjv.1;
        Mon, 06 Sep 2021 05:25:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I3HTbZGnmQhuCRpqJcoadcvR9lL+3dFcEiwvvQl7ZAE=;
        b=KIz/krz9aHxarGABT+60ibqwskMFXDl4B/g6XXBW/dfVRi0Eb6OyZ0ck9j3H0Q8Z0i
         HhyHeiPbWEdNloYkn60BRn2pkAZ+W/nKWDBvAUelWhuvUph4bOJsMSBsB85fxxLCdYu3
         1izBaKg1LvpcUdG/8aj3gJz5kBa5x/4bCacbI+VzRAAxJB4kdbdm0pzVHeNtDs9njBlJ
         0aQEymo/fkT4HTCaOrz63HNEEjZbrAU/K+jyEvm56Id8xODOzGr3kSR6g0obeID5WNh/
         7i/PmevEkFHvg47Y6Qgze58Z96ZYV7c9fVNgYG15gRNUc68uuP2ohiZslDD4PCvJpryg
         EA8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I3HTbZGnmQhuCRpqJcoadcvR9lL+3dFcEiwvvQl7ZAE=;
        b=PfywD47B7QnzipSDKy7kzmfiI6J9OlM51+nd4zgzPFXcgBfdbrAGc2qvvAKUvxIQFE
         U3A98rWnuW6jvL8FfykeGR2smt/huF9GL8+q3rDD5TsKCX1GGZP08pIuz2V58pd+WFZk
         fzM9jdYkR8GaSJfPafl+P7v1/5ddmMCsfgNa2sphGj83N88i/xUhC2LEDKRw4HMkTI3K
         Rp4MNNB7mjmVL2CcvApg41IYRA8PJomHOtyPiLf5spvPOpnrqfYCWrqF4/6hoELqaSoV
         ALcVJnw7TmqwuERtb/W288TIzgO5n5QwCo8iO8XhJqx0z+F9JXgNZbBArXUsjwKOZr6d
         ZKsw==
X-Gm-Message-State: AOAM531msI6TK8hyNw1dKoYMuf2we6peOh83KTrtb6XUx84sZKj4QWf/
        wjLsfZJERgERmz/gq2TNPHVRACLoXYs=
X-Google-Smtp-Source: ABdhPJxwjRrQRSXqOGEpyc8qeRTjfXUfFbKTFoILhT+YtsQHKo4iHpgr3rkdr8UgXs/EFs7c4DlySw==
X-Received: by 2002:a17:90a:e2d1:: with SMTP id fr17mr13796575pjb.101.1630931144475;
        Mon, 06 Sep 2021 05:25:44 -0700 (PDT)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id d5sm7505940pfo.186.2021.09.06.05.25.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Sep 2021 05:25:44 -0700 (PDT)
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
Subject: [PATCH V3 2/2] KVM: X86: Move PTE present check from loop body to __shadow_walk_next()
Date:   Mon,  6 Sep 2021 20:25:47 +0800
Message-Id: <20210906122547.263316-2-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20210906122547.263316-1-jiangshanlai@gmail.com>
References: <YTE3bRcZv2BiVxzH@google.com>
 <20210906122547.263316-1-jiangshanlai@gmail.com>
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
removing unneeded is_shadow_present_pte() in the loop bodies.

Terminating on !is_shadow_present_pte() is 100% the correct behavior, as
walking past a !PRESENT SPTE would lead to attempting to read a the next
level SPTE from a garbage iter->shadow_addr.  Even some paths that do _not_
currently have a !is_shadow_present_pte() in the loop body is Ok since
they will install present non-leaf SPTEs and the additional present check
is just an NOP.

The checking result in __shadow_walk_next() will be propagated to
shadow_walk_okay() for being used in any for(;;) loop.

Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
Changed from V2:
	Fix typo in the changelog reported by Sean
	Add Reviewed-by from Sean
Changed from V1:
	Merge the two patches
	Update changelog
	Remove !is_shadow_present_pte() in FNAME(invlpg)
 arch/x86/kvm/mmu/mmu.c         | 13 ++-----------
 arch/x86/kvm/mmu/paging_tmpl.h |  2 +-
 2 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 538be037549d..26f6bd238a77 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2223,7 +2223,7 @@ static bool shadow_walk_okay(struct kvm_shadow_walk_iterator *iterator)
 static void __shadow_walk_next(struct kvm_shadow_walk_iterator *iterator,
 			       u64 spte)
 {
-	if (is_last_spte(spte, iterator->level)) {
+	if (!is_shadow_present_pte(spte) || is_last_spte(spte, iterator->level)) {
 		iterator->level = 0;
 		return;
 	}
@@ -3159,9 +3159,6 @@ static u64 *fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gpa_t gpa, u64 *spte)
 	for_each_shadow_entry_lockless(vcpu, gpa, iterator, old_spte) {
 		sptep = iterator.sptep;
 		*spte = old_spte;
-
-		if (!is_shadow_present_pte(old_spte))
-			break;
 	}
 
 	return sptep;
@@ -3721,9 +3718,6 @@ static int get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes, int *root_level
 		spte = mmu_spte_get_lockless(iterator.sptep);
 
 		sptes[leaf] = spte;
-
-		if (!is_shadow_present_pte(spte))
-			break;
 	}
 
 	return leaf;
@@ -3838,11 +3832,8 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
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
index 4d559d2d4d66..72f358613786 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -982,7 +982,7 @@ static void FNAME(invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa)
 			FNAME(update_pte)(vcpu, sp, sptep, &gpte);
 		}
 
-		if (!is_shadow_present_pte(*sptep) || !sp->unsync_children)
+		if (!sp->unsync_children)
 			break;
 	}
 	write_unlock(&vcpu->kvm->mmu_lock);
-- 
2.19.1.6.gb485710b

