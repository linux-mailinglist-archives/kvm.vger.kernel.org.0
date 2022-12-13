Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64D1464B57E
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 13:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbiLMMyp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 07:54:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234798AbiLMMyi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 07:54:38 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E78ACE04;
        Tue, 13 Dec 2022 04:54:37 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id p24so15528939plw.1;
        Tue, 13 Dec 2022 04:54:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=32oEvW/qjBrorDFOC0ja37QGIM1fHIEyzxuuxD9e5H4=;
        b=XwWtd0ZhcM+fkcvP9/0iEfibDEe1ztdJqD72E+pui4GY14QoiCUSqrpBPyG8h9j6XF
         qEkTI7hmVEI3RS29JtOFkF153Et1/OrTL5KCYM1xkaPnWlW4KMZ+1e00x6P/DzqXRf6v
         VwC1/mSZjFFRJ6PToFFP1mmOUugQSMLkJol2b6cotgJtmkDGpHiAUI4d57JDZbZB2VrX
         p0w+s+kssI9yLC6+DaB1RlWkgyhGH4lBgT3rH/cizWTW3FVVA2ds/imyEbe6VGmtdoZ+
         UvQLLRwYyGUklfDOZh3cY4blyeHVbzCWPzfSMd4n/E4M5eJhUYbNE9x7IX/PbO5czS4J
         FP9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=32oEvW/qjBrorDFOC0ja37QGIM1fHIEyzxuuxD9e5H4=;
        b=gwvRHs1eRlMWCRbNllXbaHYGlHUGfvbZGyFSSJsMf41K8BPQquD1bgwigL+tqpC6hn
         ANyB44NTGHEtw2WC5+6bEkGlUdDcjs5mZ7ML1sMn4fjR1GpPE0mBeOF1sSiAK2rZ/oDp
         7CrFuiXW1w3hP+jp1TqFJvIYorIRzXbsbM+sW0GcjtB3NisSZXVkbpKRLtAEUm13EQcd
         VBb+F8mKUDoWAn0SK4Q532edDVGD5kZGzq6JZkCyYeiP6XDftSdz0v54kilOLSjH77ak
         Eqi16pCNJaZZAQCOesdt6EJjomTcglwoK4mg8VbQoFHafMSchcj8JLUcnPEeOHgusgOf
         XtxQ==
X-Gm-Message-State: ANoB5pmYkd0k+C0mohklNmMsRp88iHnk/ajC1klXLy4Yj/DoP4hgv8Tk
        rEhdegH9rq1stgkhavjoVoTIIJu9kpw=
X-Google-Smtp-Source: AA0mqf7K1k6c/yRJub7J3JwQ5JJIZQhEX2K6MEml9/oOiTCBkraX1df2qBcl8eoxjpWrVgpQxBS8kw==
X-Received: by 2002:a17:902:bc89:b0:18f:8f1e:e69f with SMTP id bb9-20020a170902bc8900b0018f8f1ee69fmr8339611plb.19.1670936075845;
        Tue, 13 Dec 2022 04:54:35 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id n15-20020a170903110f00b00186bc66d2cbsm8451895plh.73.2022.12.13.04.54.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Dec 2022 04:54:35 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org
Subject: [PATCH] kvm: x86/mmu: Remove FNAME(is_self_change_mapping)
Date:   Tue, 13 Dec 2022 20:55:38 +0800
Message-Id: <20221213125538.81209-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

FNAME(is_self_change_mapping) has two functionalities.

  If the fault is on a huge page but at least one of the pagetable on
  the walk is also on the terminal huge page, disable the huge page
  mapping for the fault.

  If the fault is modifying at least one of the pagetable on the walk,
  set something to tell the emulator.

The first functionality is much better handled by kvm_mmu_hugepage_adjust()
now, and it has a defect that it blindly disables the huge page mapping
rather than trying to reduce the size of the huge page first.

Huang Hang reported that when a guest is writing to a 1G page, but
only a 4K page is mapped because of the first functionality in a case
in which we think a 2M page should be mapped.  The 1G page includes
a pagetable on the pagetable-walk, but the narrowed 2M page doesn't.

To fix the problem, remove FNAME(is_self_change_mapping) for its first
functionality is already and better handled by kvm_mmu_hugepage_adjust(),
and re-implement the second functionality in FNAME(fetch).

Reported-by: Huang Hang <hhuang@linux.alibaba.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/kvm/mmu/paging_tmpl.h | 66 ++++++++--------------------------
 1 file changed, 15 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 8b83abf1d8bc..c69e30737cd2 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -630,6 +630,13 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	top_level = vcpu->arch.mmu->cpu_role.base.level;
 	if (top_level == PT32E_ROOT_LEVEL)
 		top_level = PT32_ROOT_LEVEL;
+
+	/*
+	 * write_fault_to_shadow_pgtable will be set if the fault gfn is
+	 * currently used as its pagetable on the path of the pagetable walk.
+	 */
+	vcpu->arch.write_fault_to_shadow_pgtable = false;
+
 	/*
 	 * Verify that the top-level gpte is still there.  Since the page
 	 * is a root page, it is either write protected (and cannot be
@@ -685,8 +692,15 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 
 		if (sp != ERR_PTR(-EEXIST))
 			link_shadow_page(vcpu, it.sptep, sp);
+
+		if (fault->write && table_gfn == fault->gfn)
+			vcpu->arch.write_fault_to_shadow_pgtable = true;
 	}
 
+	/*
+	 * Adjust huge page after getting non-direct shadow page which might
+	 * affect the huge page info.
+	 */
 	kvm_mmu_hugepage_adjust(vcpu, fault);
 
 	trace_kvm_mmu_spte_requested(fault);
@@ -733,46 +747,6 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault,
 	return RET_PF_RETRY;
 }
 
- /*
- * To see whether the mapped gfn can write its page table in the current
- * mapping.
- *
- * It is the helper function of FNAME(page_fault). When guest uses large page
- * size to map the writable gfn which is used as current page table, we should
- * force kvm to use small page size to map it because new shadow page will be
- * created when kvm establishes shadow page table that stop kvm using large
- * page size. Do it early can avoid unnecessary #PF and emulation.
- *
- * @write_fault_to_shadow_pgtable will return true if the fault gfn is
- * currently used as its page table.
- *
- * Note: the PDPT page table is not checked for PAE-32 bit guest. It is ok
- * since the PDPT is always shadowed, that means, we can not use large page
- * size to map the gfn which is used as PDPT.
- */
-static bool
-FNAME(is_self_change_mapping)(struct kvm_vcpu *vcpu,
-			      struct guest_walker *walker, bool user_fault,
-			      bool *write_fault_to_shadow_pgtable)
-{
-	int level;
-	gfn_t mask = ~(KVM_PAGES_PER_HPAGE(walker->level) - 1);
-	bool self_changed = false;
-
-	if (!(walker->pte_access & ACC_WRITE_MASK ||
-	    (!is_cr0_wp(vcpu->arch.mmu) && !user_fault)))
-		return false;
-
-	for (level = walker->level; level <= walker->max_level; level++) {
-		gfn_t gfn = walker->gfn ^ walker->table_gfn[level - 1];
-
-		self_changed |= !(gfn & mask);
-		*write_fault_to_shadow_pgtable |= !gfn;
-	}
-
-	return self_changed;
-}
-
 /*
  * Page fault handler.  There are several causes for a page fault:
  *   - there is no shadow pte for the guest pte
@@ -791,7 +765,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 {
 	struct guest_walker walker;
 	int r;
-	bool is_self_change_mapping;
 
 	pgprintk("%s: addr %lx err %x\n", __func__, fault->addr, fault->error_code);
 	WARN_ON_ONCE(fault->is_tdp);
@@ -816,6 +789,7 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	}
 
 	fault->gfn = walker.gfn;
+	fault->max_level = walker.level;
 	fault->slot = kvm_vcpu_gfn_to_memslot(vcpu, fault->gfn);
 
 	if (page_fault_handle_page_track(vcpu, fault)) {
@@ -827,16 +801,6 @@ static int FNAME(page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault
 	if (r)
 		return r;
 
-	vcpu->arch.write_fault_to_shadow_pgtable = false;
-
-	is_self_change_mapping = FNAME(is_self_change_mapping)(vcpu,
-	      &walker, fault->user, &vcpu->arch.write_fault_to_shadow_pgtable);
-
-	if (is_self_change_mapping)
-		fault->max_level = PG_LEVEL_4K;
-	else
-		fault->max_level = walker.level;
-
 	r = kvm_faultin_pfn(vcpu, fault, walker.pte_access);
 	if (r != RET_PF_CONTINUE)
 		return r;
-- 
2.19.1.6.gb485710b

