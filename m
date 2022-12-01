Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A40663F8B0
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 20:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbiLAT6S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 14:58:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiLAT6D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 14:58:03 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1749AE41
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 11:57:36 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id pq17-20020a17090b3d9100b0020a4c65c3a9so2585930pjb.0
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 11:57:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=stKM1jMVwmhwoFpYP247nGWPPAXZf6A1zRPmUrHRQZA=;
        b=Bu8NSzFGappkbv1L7qwoURd3JHk2KgbJHy9Sdk05Usu/He/TEU7SnfHqTnnrUsn71m
         90z4y8EI02w7hoQIjL3LAKsdjTZNluksE5Z5q4dHqwNgYkGJcy2mGBsPaprsTVtVW4W0
         PeGWHCIX7JJ9LLDtOyJ6AqcfrAZtPWWDNRc7lSB0I00Skc/AgibNqGy5PgHIItnuDa0t
         XO03NNFTSJtQAYWfn/thSffywzTQYLvUL0MjvYCyXaCWxcajrZ5HIra1saG+xSfeEN12
         4CnwWMYMqAmiHaRTcTH7/Ki5BVRt2On9Rd5G2u0W8gtEbZn6p+eXX3gwW9HmO1J9NbBJ
         T2pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=stKM1jMVwmhwoFpYP247nGWPPAXZf6A1zRPmUrHRQZA=;
        b=5sYz6p1Q4XkeOWaO/PX0mlepyaSJaENqe8yKR2HFJJpnpWM1TLJpWE1Ox3+0czGaDl
         H6kiL0kquXp7RAFUP0Xgm6TVAypQJ9xnoXWd3OTK9hhq0iEOBDtt67nWB82xdhH0yp/2
         bL3Hz18NYhlHWuePxjej3I+F+AyxmJaFXsESyvYAgqGFkqWYf9x5PULvnIstHjRb96Qr
         qAxZujKtmGi4p3vL7R3bRm2NZO7kWsh0NmbFoWCi482ES82kd236HEX18K1HHmr0sc/C
         CgknZcHqczGB3dfWKXyNywRt1qbYspnk5coPbc7dkOqeB0jatux+pLRkrfQGncpltAA1
         G18Q==
X-Gm-Message-State: ANoB5pnajMw7wyP0d5siySMLTTj7pu4mDJZ02e8j+9iyTF35AKfZh7mn
        AhmVPHcHlndRiyJ85KDt9vFBcgAkNJOa
X-Google-Smtp-Source: AA0mqf7actV5acmjHcV5eBTZAyNqPGUvL0/LYW39R9wq+uENvgAom5E8W0UjQCCquvKOtkK0FYSUDL9H4La0
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:902:bb10:b0:189:6292:827e with SMTP id
 im16-20020a170902bb1000b001896292827emr36484510plb.97.1669924655797; Thu, 01
 Dec 2022 11:57:35 -0800 (PST)
Date:   Thu,  1 Dec 2022 11:57:17 -0800
In-Reply-To: <20221201195718.1409782-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221201195718.1409782-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201195718.1409782-2-vipinsh@google.com>
Subject: [Patch v2 1/2] KVM: x86/mmu: Allocate page table pages on TDP splits
 during dirty log enable on the underlying page's numa node
From:   Vipin Sharma <vipinsh@google.com>
To:     dmatlack@google.com, bgardon@google.com, seanjc@google.com,
        pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Huge pages are split when dirty log is enabled. New page table pages are
allocated based on the current thread NUMA node or mempolicy. This
causes inefficient page table accesses if underlying page is on a
different NUMA node

Allocate page table pages on the same NUMA node as the underlying huge
page when dirty log is enabled and huge pages are split.

The performance gain during the pre-copy phase of live migrations of a
416 vCPUs and 11 TiB memory VM  on a 8 node host was seen in the range
of 130% to 150%.

Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu.h         |  1 +
 arch/x86/kvm/mmu/mmu.c     | 19 +++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++----
 include/linux/kvm_host.h   | 15 +++++++++++++++
 4 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 6bdaacb6faa0..c960fb096e5c 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -119,6 +119,7 @@ void kvm_mmu_unload(struct kvm_vcpu *vcpu);
 void kvm_mmu_free_obsolete_roots(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_roots(struct kvm_vcpu *vcpu);
 void kvm_mmu_sync_prev_roots(struct kvm_vcpu *vcpu);
+void *kvm_mmu_get_free_page(int nid, gfp_t gfp);
 
 static inline int kvm_mmu_reload(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4736d7849c60..0554dfc55553 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -90,6 +90,9 @@ __MODULE_PARM_TYPE(nx_huge_pages_recovery_period_ms, "uint");
 static bool __read_mostly force_flush_and_sync_on_reuse;
 module_param_named(flush_on_reuse, force_flush_and_sync_on_reuse, bool, 0644);
 
+static bool __read_mostly numa_aware_pagetable = true;
+module_param_named(numa_aware_pagetable, numa_aware_pagetable, bool, 0644);
+
 /*
  * When setting this variable to true it enables Two-Dimensional-Paging
  * where the hardware walks 2 page tables:
@@ -6984,3 +6987,19 @@ void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
 	if (kvm->arch.nx_huge_page_recovery_thread)
 		kthread_stop(kvm->arch.nx_huge_page_recovery_thread);
 }
+
+void *kvm_mmu_get_free_page(int nid, gfp_t gfp)
+{
+	struct page *spt_page;
+	void *address = NULL;
+
+	if (numa_aware_pagetable) {
+		spt_page = alloc_pages_node(nid, gfp, 0);
+		if (spt_page)
+			address = page_address(spt_page);
+	} else {
+		address = (void *)__get_free_page(gfp);
+	}
+
+	return address;
+}
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 771210ce5181..1607afbfcc0b 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1413,7 +1413,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
+static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(int nid, gfp_t gfp)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1423,7 +1423,8 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
 	if (!sp)
 		return NULL;
 
-	sp->spt = (void *)__get_free_page(gfp);
+	sp->spt = kvm_mmu_get_free_page(nid, gfp);
+
 	if (!sp->spt) {
 		kmem_cache_free(mmu_page_header_cache, sp);
 		return NULL;
@@ -1437,6 +1438,9 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 						       bool shared)
 {
 	struct kvm_mmu_page *sp;
+	int nid;
+
+	nid = kvm_pfn_to_refcounted_page_nid(spte_to_pfn(iter->old_spte));
 
 	/*
 	 * Since we are allocating while under the MMU lock we have to be
@@ -1447,7 +1451,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	 * If this allocation fails we drop the lock and retry with reclaim
 	 * allowed.
 	 */
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_NOWAIT | __GFP_ACCOUNT);
 	if (sp)
 		return sp;
 
@@ -1459,7 +1463,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 
 	iter->yielded = true;
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_KERNEL_ACCOUNT);
 
 	if (shared)
 		read_lock(&kvm->mmu_lock);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8f874a964313..558ded73f660 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1596,6 +1596,21 @@ void kvm_arch_sync_events(struct kvm *kvm);
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 
 struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn);
+
+/*
+ * Returns the nid of a 'struct page' if pfn is valid and backed by a refcounted
+ * page, NUMA_NO_NODE otherwise.
+ */
+static inline int kvm_pfn_to_refcounted_page_nid(kvm_pfn_t pfn)
+{
+	struct page *page = kvm_pfn_to_refcounted_page(pfn);
+
+	if (page)
+		return page_to_nid(page);
+	else
+		return NUMA_NO_NODE;
+}
+
 bool kvm_is_zone_device_page(struct page *page);
 
 struct kvm_irq_ack_notifier {
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

