Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB7130CACC
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239302AbhBBTAW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239224AbhBBS6d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 13:58:33 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582B3C0617A7
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:57:48 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id ob3so2800504pjb.0
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=S0cDnClyNXVmiNLA5hLSJx8SJQB7LRWr/4TdaU7WpUo=;
        b=k6lsxzxMOHiG3jn878FlFd/+cJBmOZ7515ZJaBd70/fv3l+PBs9d4XeoR86VagEQnJ
         vqgxy2Acft/z4PMvGQMb2DbcEeTXas8mhJcPGTREotijfldn30nOupg6v0N5sic85aJ4
         UHBvEPTTPIgPoooWsdTyr1trW2LHBId/ebXoy6eE2CuYcMSRq5Um+vurBy58i1PjtuKz
         K9M2yA9yW6ux+HtHRrNMFXttVYVGNxid0HD6AREamfWnxS34lmjVxz6uSthTSpbkM5Ws
         LqwY+ZVkpVeBgriwbtpYWBPvBi03AUEyGAj+NISyRZgRourkWwh7mQmj1A6GIQB76p0d
         0dJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=S0cDnClyNXVmiNLA5hLSJx8SJQB7LRWr/4TdaU7WpUo=;
        b=CRl5587SLilCEP+H7xlAFk7yyUPEhAvh0vIao+CsHS1pHJ+4+Yns0KNHDVLM892NhV
         qRvPEreRpBK72uSR501tsuNsv8SBJ3IjRGYg3cMTrQS+YGewNnO/hbG12wiCRGccVTjG
         SJC6GWDPQGvG7+3Ia89PkWWvA5uhV0eZJF4EUhdvQQ+0ZQX7Lv4VnGyO9VXiMXqt7GwE
         B6s6X3gE4ZcUUevZMT6si1w5OWKg5PxXsPrzBTUnPuqo3n71/IlQu2WxGmyYBL/Od3jn
         E5E/RGsZMQisxjw63b2V3OYxRA6+XO0zVvyJwREiSvj89cOYl9iA1BRhjk5WsnWidLRE
         SFAA==
X-Gm-Message-State: AOAM532NvOS1GAG290n0Dme8xMIkdZpLu45O1jXQ7//noH5Laj2THWBU
        j3Vqi/4J0x6tI3mQmSnYs/lpmmKHSzd2
X-Google-Smtp-Source: ABdhPJyiZhfioFp9ZR8ukB4iQqIctGnZxjQDsamWD+u2WGwSEaC0G2JbsA68uNvl7vEnnIfb0kiqIcRapPSP
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a17:90a:8d83:: with SMTP id
 d3mr614547pjo.0.1612292267530; Tue, 02 Feb 2021 10:57:47 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:11 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-6-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 05/28] KVM: x86/mmu: Factor out handling of removed page tables
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Factor out the code to handle a disconnected subtree of the TDP paging
structure from the code to handle the change to an individual SPTE.
Future commits will build on this to allow asynchronous page freeing.

No functional change intended.

Reviewed-by: Peter Feiner <pfeiner@google.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Gardon <bgardon@google.com>

---

v1 -> v2
- Replaced "disconnected" with "removed" updated derivative
  comments and code

 arch/x86/kvm/mmu/tdp_mmu.c | 71 ++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3828c0e83466..c3075fb568eb 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -234,6 +234,45 @@ static void handle_changed_spte_dirty_log(struct kvm *kvm, int as_id, gfn_t gfn,
 	}
 }
 
+/**
+ * handle_removed_tdp_mmu_page - handle a pt removed from the TDP structure
+ *
+ * @kvm: kvm instance
+ * @pt: the page removed from the paging structure
+ *
+ * Given a page table that has been removed from the TDP paging structure,
+ * iterates through the page table to clear SPTEs and free child page tables.
+ */
+static void handle_removed_tdp_mmu_page(struct kvm *kvm, u64 *pt)
+{
+	struct kvm_mmu_page *sp = sptep_to_sp(pt);
+	int level = sp->role.level;
+	gfn_t gfn = sp->gfn;
+	u64 old_child_spte;
+	int i;
+
+	trace_kvm_mmu_prepare_zap_page(sp);
+
+	list_del(&sp->link);
+
+	if (sp->lpage_disallowed)
+		unaccount_huge_nx_page(kvm, sp);
+
+	for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
+		old_child_spte = READ_ONCE(*(pt + i));
+		WRITE_ONCE(*(pt + i), 0);
+		handle_changed_spte(kvm, kvm_mmu_page_as_id(sp),
+			gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
+			old_child_spte, 0, level - 1);
+	}
+
+	kvm_flush_remote_tlbs_with_address(kvm, gfn,
+					   KVM_PAGES_PER_HPAGE(level));
+
+	free_page((unsigned long)pt);
+	kmem_cache_free(mmu_page_header_cache, sp);
+}
+
 /**
  * handle_changed_spte - handle bookkeeping associated with an SPTE change
  * @kvm: kvm instance
@@ -254,10 +293,6 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	bool pfn_changed = spte_to_pfn(old_spte) != spte_to_pfn(new_spte);
-	u64 *pt;
-	struct kvm_mmu_page *sp;
-	u64 old_child_spte;
-	int i;
 
 	WARN_ON(level > PT64_ROOT_MAX_LEVEL);
 	WARN_ON(level < PG_LEVEL_4K);
@@ -321,31 +356,9 @@ static void __handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 	 * Recursively handle child PTs if the change removed a subtree from
 	 * the paging structure.
 	 */
-	if (was_present && !was_leaf && (pfn_changed || !is_present)) {
-		pt = spte_to_child_pt(old_spte, level);
-		sp = sptep_to_sp(pt);
-
-		trace_kvm_mmu_prepare_zap_page(sp);
-
-		list_del(&sp->link);
-
-		if (sp->lpage_disallowed)
-			unaccount_huge_nx_page(kvm, sp);
-
-		for (i = 0; i < PT64_ENT_PER_PAGE; i++) {
-			old_child_spte = READ_ONCE(*(pt + i));
-			WRITE_ONCE(*(pt + i), 0);
-			handle_changed_spte(kvm, as_id,
-				gfn + (i * KVM_PAGES_PER_HPAGE(level - 1)),
-				old_child_spte, 0, level - 1);
-		}
-
-		kvm_flush_remote_tlbs_with_address(kvm, gfn,
-						   KVM_PAGES_PER_HPAGE(level));
-
-		free_page((unsigned long)pt);
-		kmem_cache_free(mmu_page_header_cache, sp);
-	}
+	if (was_present && !was_leaf && (pfn_changed || !is_present))
+		handle_removed_tdp_mmu_page(kvm,
+				spte_to_child_pt(old_spte, level));
 }
 
 static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
-- 
2.30.0.365.g02bc693789-goog

