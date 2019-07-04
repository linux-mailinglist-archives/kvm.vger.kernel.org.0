Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 604975F5A4
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 11:34:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfGDJdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 05:33:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35553 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbfGDJdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 05:33:02 -0400
Received: by mail-wr1-f67.google.com with SMTP id c27so5877376wrb.2;
        Thu, 04 Jul 2019 02:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UqWiooHq5j8Ew9WEk0aj8+8Yrq5uPGrk8n3zQP9fKKU=;
        b=HqPBl+sR8JPEDRf9enYLsB7j7gT0C/OGYvMwp4sIHT2Xvgo5u5IJ2V5JmbeWUoHOW3
         L/b2xeWftvHwrp67fP3ILqip2YMsw1kknUHZePTr3rehcHL55Z54x2B0Mql8IOWUCNqT
         hXsrwyZWIFnVu63OHT1n2ve2U+eBkupq7sAP/bDHUY2XF4HjM+GbinWjdXHOBgHmqLfH
         Y8kfKN+n7mGyzKWzW67gCcjO5FLseo0r8xNnTF3qUqO1tHNueapME/A5d3v1zXj6ckGx
         xvuBDoX+MVfOx5D+AvBjNFrioj1CEaHfN3SAmD50nDYclW1Z4OU2lr/npvm7TqCzLd+B
         5skQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=UqWiooHq5j8Ew9WEk0aj8+8Yrq5uPGrk8n3zQP9fKKU=;
        b=WNPN3kbRlhxJFm3e7PoZYBbkazMQ6VfjK2w6qs7c7q9GfRBj3QGRUC9vpBxRATb8TY
         sQClhUWHk0jUYoGo/ItEErE1pVKeZz7hMqA83EOupfH1TsT7XBc3ubr8pFl8GQjlqYY9
         ISVh9rLcFm7DO1IHenXITRyC6TjllWCMHicJeCLQ2ZRaHWyV0Sx1cWShu5ZyOdrrtIyk
         QLZairr0UZeenoGhr+SzYPH6wfamtLyqJcmeO0N+iwvD9vRD508n0nbT28Mk/R48aKJu
         BcbwbxpoGU5iwLmHUZ1gE8vYErxMXpa2Ammxw908DwQNdubZd3+RnNOVf0NlWN8gq7AO
         KIuQ==
X-Gm-Message-State: APjAAAUkeKRCxklrGZkYkrQFfgL5zd1bJyO5p3HHyEFkp4c15Zdam1sG
        J51FOK1uxET5e1QPmg2VuPsgPdcgVWk=
X-Google-Smtp-Source: APXvYqxw0spNmWoC6OG4NWhD6eVeBhwY6RPkrkVwHhEmQO2QSe6OcfkRddA+1a+pRBNxYwigW0vBXQ==
X-Received: by 2002:adf:eb49:: with SMTP id u9mr3321589wrn.215.1562232780406;
        Thu, 04 Jul 2019 02:33:00 -0700 (PDT)
Received: from donizetti.redhat.com (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id m9sm4868320wrn.92.2019.07.04.02.32.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 02:32:59 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com
Subject: [PATCH 2/5] KVM: x86: make FNAME(fetch) and __direct_map more similar
Date:   Thu,  4 Jul 2019 11:32:53 +0200
Message-Id: <20190704093256.12989-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190704093256.12989-1-pbonzini@redhat.com>
References: <20190704093256.12989-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These two functions are basically doing the same thing through
kvm_mmu_get_page, link_shadow_page and mmu_set_spte; yet, for historical
reasons, their code looks very different.  This patch tries to take the
best of each and make them very similar, so that it is easy to understand
changes that apply to both of them.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.c         | 53 ++++++++++++++++++--------------------
 arch/x86/kvm/paging_tmpl.h | 30 ++++++++++-----------
 2 files changed, 39 insertions(+), 44 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 6fc5c389f5a1..af9dafa54f85 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3181,40 +3181,39 @@ static void direct_pte_prefetch(struct kvm_vcpu *vcpu, u64 *sptep)
 	__direct_pte_prefetch(vcpu, sp, sptep);
 }
 
-static int __direct_map(struct kvm_vcpu *vcpu, int write, int map_writable,
-			int level, gfn_t gfn, kvm_pfn_t pfn, bool prefault)
+static int __direct_map(struct kvm_vcpu *vcpu, gpa_t gpa, int write,
+			int map_writable, int level, kvm_pfn_t pfn,
+			bool prefault)
 {
-	struct kvm_shadow_walk_iterator iterator;
+	struct kvm_shadow_walk_iterator it;
 	struct kvm_mmu_page *sp;
-	int emulate = 0;
-	gfn_t pseudo_gfn;
+	int ret;
+	gfn_t gfn = gpa >> PAGE_SHIFT;
+	gfn_t base_gfn = gfn;
 
 	if (!VALID_PAGE(vcpu->arch.mmu->root_hpa))
-		return 0;
+		return RET_PF_RETRY;
 
-	for_each_shadow_entry(vcpu, (u64)gfn << PAGE_SHIFT, iterator) {
-		if (iterator.level == level) {
-			emulate = mmu_set_spte(vcpu, iterator.sptep, ACC_ALL,
-					       write, level, gfn, pfn, prefault,
-					       map_writable);
-			direct_pte_prefetch(vcpu, iterator.sptep);
-			++vcpu->stat.pf_fixed;
+	for_each_shadow_entry(vcpu, gpa, it) {
+		base_gfn = gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
+		if (it.level == level)
 			break;
-		}
 
-		drop_large_spte(vcpu, iterator.sptep);
-		if (!is_shadow_present_pte(*iterator.sptep)) {
-			u64 base_addr = iterator.addr;
+		drop_large_spte(vcpu, it.sptep);
+		if (!is_shadow_present_pte(*it.sptep)) {
+			sp = kvm_mmu_get_page(vcpu, base_gfn, it.addr,
+					      it.level - 1, true, ACC_ALL);
 
-			base_addr &= PT64_LVL_ADDR_MASK(iterator.level);
-			pseudo_gfn = base_addr >> PAGE_SHIFT;
-			sp = kvm_mmu_get_page(vcpu, pseudo_gfn, iterator.addr,
-					      iterator.level - 1, 1, ACC_ALL);
-
-			link_shadow_page(vcpu, iterator.sptep, sp);
+			link_shadow_page(vcpu, it.sptep, sp);
 		}
 	}
-	return emulate;
+
+	ret = mmu_set_spte(vcpu, it.sptep, ACC_ALL,
+			   write, level, base_gfn, pfn, prefault,
+			   map_writable);
+	direct_pte_prefetch(vcpu, it.sptep);
+	++vcpu->stat.pf_fixed;
+	return ret;
 }
 
 static void kvm_send_hwpoison_signal(unsigned long address, struct task_struct *tsk)
@@ -3538,8 +3537,7 @@ static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, u32 error_code,
 		goto out_unlock;
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
-	r = __direct_map(vcpu, write, map_writable, level, gfn, pfn, prefault);
-
+	r = __direct_map(vcpu, v, write, map_writable, level, pfn, prefault);
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
@@ -4165,8 +4163,7 @@ static int tdp_page_fault(struct kvm_vcpu *vcpu, gva_t gpa, u32 error_code,
 		goto out_unlock;
 	if (likely(!force_pt_level))
 		transparent_hugepage_adjust(vcpu, &gfn, &pfn, &level);
-	r = __direct_map(vcpu, write, map_writable, level, gfn, pfn, prefault);
-
+	r = __direct_map(vcpu, gpa, write, map_writable, level, pfn, prefault);
 out_unlock:
 	spin_unlock(&vcpu->kvm->mmu_lock);
 	kvm_release_pfn_clean(pfn);
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 2db96401178e..bfd89966832b 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -623,6 +623,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 	struct kvm_shadow_walk_iterator it;
 	unsigned direct_access, access = gw->pt_access;
 	int top_level, ret;
+	gfn_t base_gfn;
 
 	direct_access = gw->pte_access;
 
@@ -667,31 +668,29 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gva_t addr,
 			link_shadow_page(vcpu, it.sptep, sp);
 	}
 
-	for (;
-	     shadow_walk_okay(&it) && it.level > hlevel;
-	     shadow_walk_next(&it)) {
-		gfn_t direct_gfn;
+	base_gfn = gw->gfn;
 
+	for (; shadow_walk_okay(&it); shadow_walk_next(&it)) {
 		clear_sp_write_flooding_count(it.sptep);
+		base_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
+		if (it.level == hlevel)
+			break;
+
 		validate_direct_spte(vcpu, it.sptep, direct_access);
 
 		drop_large_spte(vcpu, it.sptep);
 
-		if (is_shadow_present_pte(*it.sptep))
-			continue;
-
-		direct_gfn = gw->gfn & ~(KVM_PAGES_PER_HPAGE(it.level) - 1);
-
-		sp = kvm_mmu_get_page(vcpu, direct_gfn, addr, it.level-1,
-				      true, direct_access);
-		link_shadow_page(vcpu, it.sptep, sp);
+		if (!is_shadow_present_pte(*it.sptep)) {
+			sp = kvm_mmu_get_page(vcpu, base_gfn, addr,
+					      it.level - 1, true, direct_access);
+			link_shadow_page(vcpu, it.sptep, sp);
+		}
 	}
 
-	clear_sp_write_flooding_count(it.sptep);
 	ret = mmu_set_spte(vcpu, it.sptep, gw->pte_access, write_fault,
-			   it.level, gw->gfn, pfn, prefault, map_writable);
+			   it.level, base_gfn, pfn, prefault, map_writable);
 	FNAME(pte_prefetch)(vcpu, gw, it.sptep);
-
+	++vcpu->stat.pf_fixed;
 	return ret;
 
 out_gpte_changed:
@@ -854,7 +853,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, gva_t addr, u32 error_code,
 		transparent_hugepage_adjust(vcpu, &walker.gfn, &pfn, &level);
 	r = FNAME(fetch)(vcpu, addr, &walker, write_fault,
 			 level, pfn, map_writable, prefault);
-	++vcpu->stat.pf_fixed;
 	kvm_mmu_audit(vcpu, AUDIT_POST_PAGE_FAULT);
 
 out_unlock:
-- 
2.21.0


