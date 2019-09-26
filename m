Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF6BDBFBC5
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 01:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728908AbfIZXSf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 19:18:35 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:46968 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbfIZXSe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 19:18:34 -0400
Received: by mail-pg1-f201.google.com with SMTP id f11so2341662pgn.13
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 16:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=MsYuIFS52UvWa5jHwwGrflQKqhDfm/npA1PP2h6zMVw=;
        b=dmvNTfFRAfmgqjRIow3+4tr3+T3CR/V1ZpL0e/6Z+3eYra/ze8Fg1MejzLzKoBk5n5
         5imZ3mD0ncRykvBifGIR05f1TkEmXl57G8EOEuLXpCHICAdjc0DLDkm1Wy80OgHlKKNg
         4adRmJUvmC1zgHAGOwz6gJqQbVQFrmyJ+YPZ32KzS/bbG7hQPPf6HnmnctwZGTr1hf7r
         K0/sulvUUZOD6KcmOMe4T1snYHLCgTZ+7qRL06S5YUUk0WbaHRL1Ih5a2ejAdMqXpDOL
         x8xi0A/6ifJ7A+My9p7gHmKl4bkWAIyMKRIQ4OhRU4j4W6f9GVhcXJO00CD4SJNu/Bwh
         o2IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=MsYuIFS52UvWa5jHwwGrflQKqhDfm/npA1PP2h6zMVw=;
        b=o/9/sHUaOephE0Kbo/cvHbQLchBunKAEuKwSJ/AQ3D6SAGP2kZf6ZcjtZXzdPPPQlN
         FRUuB42ZCU3lE2oCOlgtCR/H8xxnbGVhAXI76tr1gL7lVtAZDHVQUw1Rf8tfdGWJ5oWR
         o2vJITMS/UQH4VpZgEkqiZ36iNC3Rq3mdKjipl95UUQEgO1lYYlSQTnFfIDoB5Dy4C71
         3vaMLjb2uiF5Jvl78WGQ1dPIe8bWg53kUC79F0pt+Z0TaUJ7JSl/Bun8QhuWxS7eLri4
         gY0iQqbXL/m2WkAPnhjxSB2xc2GRnVca7RM7TS4m3WkdUVq1PB7qE4leWHJyXk9ZbYVs
         b8dA==
X-Gm-Message-State: APjAAAXrH6alRUkst6OEI+GmKhLroSPuuyi+iXmwU9/7PmCH76qu+Zm0
        6HIxGw7BlqijHSwIRs4o+KWxmUYZCSVkv/KW4e40gxcFFoa9/fgdeUNg7x0ZoKZrDGMzRhls0EU
        O0hrwvXsbtfgwwsEN0+ddDCCwN57QH+toeEcT95GSf0DeQAwl3OgCcdEsGc9b
X-Google-Smtp-Source: APXvYqwkVYPjKqGlcFvLB8KxIMEEpxNz37P80wxlXoS6/iSadDfZ3hRlM4rj6Prr34mh/lvB+VyyaQWoduxh
X-Received: by 2002:a63:5050:: with SMTP id q16mr5862350pgl.451.1569539912730;
 Thu, 26 Sep 2019 16:18:32 -0700 (PDT)
Date:   Thu, 26 Sep 2019 16:17:58 -0700
In-Reply-To: <20190926231824.149014-1-bgardon@google.com>
Message-Id: <20190926231824.149014-3-bgardon@google.com>
Mime-Version: 1.0
References: <20190926231824.149014-1-bgardon@google.com>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
Subject: [RFC PATCH 02/28] kvm: mmu: Separate pte generation from set_spte
From:   Ben Gardon <bgardon@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Peter Feiner <pfeiner@google.com>,
        Peter Shier <pshier@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Separate the functions for generating leaf page table entries from the
function that inserts them into the paging structure. This refactoring
will allow changes to the MMU sychronization model to use atomic
compare / exchanges (which are not guaranteed to succeed) instead of a
monolithic MMU lock.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/mmu.c | 93 ++++++++++++++++++++++++++++------------------
 1 file changed, 57 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 781c2ca7455e3..7e5ab9c6e2b09 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2964,21 +2964,15 @@ static bool kvm_is_mmio_pfn(kvm_pfn_t pfn)
 #define SET_SPTE_WRITE_PROTECTED_PT	BIT(0)
 #define SET_SPTE_NEED_REMOTE_TLB_FLUSH	BIT(1)
 
-static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
-		    unsigned pte_access, int level,
-		    gfn_t gfn, kvm_pfn_t pfn, bool speculative,
-		    bool can_unsync, bool host_writable)
+static int generate_pte(struct kvm_vcpu *vcpu, unsigned pte_access, int level,
+		    gfn_t gfn, kvm_pfn_t pfn, u64 old_pte, bool speculative,
+		    bool can_unsync, bool host_writable, bool ad_disabled,
+		    u64 *ptep)
 {
-	u64 spte = 0;
+	u64 pte;
 	int ret = 0;
-	struct kvm_mmu_page *sp;
-
-	if (set_mmio_spte(vcpu, sptep, gfn, pfn, pte_access))
-		return 0;
 
-	sp = page_header(__pa(sptep));
-	if (sp_ad_disabled(sp))
-		spte |= shadow_acc_track_value;
+	*ptep = 0;
 
 	/*
 	 * For the EPT case, shadow_present_mask is 0 if hardware
@@ -2986,36 +2980,39 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 	 * ACC_USER_MASK and shadow_user_mask are used to represent
 	 * read access.  See FNAME(gpte_access) in paging_tmpl.h.
 	 */
-	spte |= shadow_present_mask;
+	pte = shadow_present_mask;
+
+	if (ad_disabled)
+		pte |= shadow_acc_track_value;
+
 	if (!speculative)
-		spte |= spte_shadow_accessed_mask(spte);
+		pte |= spte_shadow_accessed_mask(pte);
 
 	if (pte_access & ACC_EXEC_MASK)
-		spte |= shadow_x_mask;
+		pte |= shadow_x_mask;
 	else
-		spte |= shadow_nx_mask;
+		pte |= shadow_nx_mask;
 
 	if (pte_access & ACC_USER_MASK)
-		spte |= shadow_user_mask;
+		pte |= shadow_user_mask;
 
 	if (level > PT_PAGE_TABLE_LEVEL)
-		spte |= PT_PAGE_SIZE_MASK;
+		pte |= PT_PAGE_SIZE_MASK;
 	if (tdp_enabled)
-		spte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
+		pte |= kvm_x86_ops->get_mt_mask(vcpu, gfn,
 			kvm_is_mmio_pfn(pfn));
 
 	if (host_writable)
-		spte |= SPTE_HOST_WRITEABLE;
+		pte |= SPTE_HOST_WRITEABLE;
 	else
 		pte_access &= ~ACC_WRITE_MASK;
 
 	if (!kvm_is_mmio_pfn(pfn))
-		spte |= shadow_me_mask;
+		pte |= shadow_me_mask;
 
-	spte |= (u64)pfn << PAGE_SHIFT;
+	pte |= (u64)pfn << PAGE_SHIFT;
 
 	if (pte_access & ACC_WRITE_MASK) {
-
 		/*
 		 * Other vcpu creates new sp in the window between
 		 * mapping_level() and acquiring mmu-lock. We can
@@ -3024,9 +3021,9 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 */
 		if (level > PT_PAGE_TABLE_LEVEL &&
 		    mmu_gfn_lpage_is_disallowed(vcpu, gfn, level))
-			goto done;
+			return 0;
 
-		spte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
+		pte |= PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE;
 
 		/*
 		 * Optimization: for pte sync, if spte was writable the hash
@@ -3034,30 +3031,54 @@ static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
 		 * is responsibility of mmu_get_page / kvm_sync_page.
 		 * Same reasoning can be applied to dirty page accounting.
 		 */
-		if (!can_unsync && is_writable_pte(*sptep))
-			goto set_pte;
+		if (!can_unsync && is_writable_pte(old_pte)) {
+			*ptep = pte;
+			return 0;
+		}
 
 		if (mmu_need_write_protect(vcpu, gfn, can_unsync)) {
 			pgprintk("%s: found shadow page for %llx, marking ro\n",
 				 __func__, gfn);
-			ret |= SET_SPTE_WRITE_PROTECTED_PT;
+			ret = SET_SPTE_WRITE_PROTECTED_PT;
 			pte_access &= ~ACC_WRITE_MASK;
-			spte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
+			pte &= ~(PT_WRITABLE_MASK | SPTE_MMU_WRITEABLE);
 		}
 	}
 
-	if (pte_access & ACC_WRITE_MASK) {
-		kvm_vcpu_mark_page_dirty(vcpu, gfn);
-		spte |= spte_shadow_dirty_mask(spte);
-	}
+	if (pte_access & ACC_WRITE_MASK)
+		pte |= spte_shadow_dirty_mask(pte);
 
 	if (speculative)
-		spte = mark_spte_for_access_track(spte);
+		pte = mark_spte_for_access_track(pte);
+
+	*ptep = pte;
+	return ret;
+}
+
+static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep, unsigned pte_access,
+		    int level, gfn_t gfn, kvm_pfn_t pfn, bool speculative,
+		    bool can_unsync, bool host_writable)
+{
+	u64 spte;
+	int ret;
+	struct kvm_mmu_page *sp;
+
+	if (set_mmio_spte(vcpu, sptep, gfn, pfn, pte_access))
+		return 0;
+
+	sp = page_header(__pa(sptep));
+
+	ret = generate_pte(vcpu, pte_access, level, gfn, pfn, *sptep,
+			   speculative, can_unsync, host_writable,
+			   sp_ad_disabled(sp), &spte);
+	if (!spte)
+		return 0;
+
+	if (spte & PT_WRITABLE_MASK)
+		kvm_vcpu_mark_page_dirty(vcpu, gfn);
 
-set_pte:
 	if (mmu_spte_update(sptep, spte))
 		ret |= SET_SPTE_NEED_REMOTE_TLB_FLUSH;
-done:
 	return ret;
 }
 
-- 
2.23.0.444.g18eeb5a265-goog

