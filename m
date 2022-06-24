Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C3055A4C7
	for <lists+kvm@lfdr.de>; Sat, 25 Jun 2022 01:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiFXX1p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 19:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiFXX1n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 19:27:43 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0472A8858B
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 16:27:43 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id l6-20020a170902ec0600b0016a1fd93c28so1954400pld.17
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 16:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Hd7uhzYTgX4OWWaspLXhbEFuAzQ6PoZou88pG/GGeng=;
        b=Oy0xH78K8YH7p35tSKeKIPT+Vp/pVw6ZGVUzHplDVSKQeVM2RXjf4HZkSbhmh24idu
         Eg6jH2VSR6va0LEstY/KTWzDy+YSgjvbjSQ4tXZPMFYlO5YK6YcjSScGAq68Q4Cc5OWZ
         55WFFEsytwDm7nbX3IUal1wZDsv74yswtY3jbD/YceEdTJ+4wuLRdINLosXir8tjtrrK
         kh13j4qdTkejeC1JMAzGMqtxuL2O3VO20DooCEU3LZ5u9cVO4rTbE9E5nLe9JdYa5/ws
         7ghIywcI2h8X0PVzB48BElFJPAHKMVHbtlTPNtThnHpRdTn1Z6JZa5SekgpwknMcflqw
         P9Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Hd7uhzYTgX4OWWaspLXhbEFuAzQ6PoZou88pG/GGeng=;
        b=UEowCyOzmsPohLH/YW/9Nkv9zOjzr22V7qjKBBbpyXQKjW11ORQftTLLfW/M/MCZFB
         cxFhssj8IyGMohjE0K8zfhtmHrINUt/taSZ0e7kumvP8x00cvDiXrmWDqHoiBjzFvQTs
         0Rifyb3gnAGUdJXMXIgqtQ//SsJenEGh30qHOZcwSxZt3S/zMAgJbHDhfu0jSG5nSt9D
         XIDU3L+2mS5WhtA0O5YLR1/bAwheghbO3sWJpaqwm/Wjo9Ch1iXCjxR/N8pdFUfb9taK
         raThLhNyv53AqQDQRaYKKpnq2fWgAdokauKO0To04fjDRVHoA1txau9UXiT1o1BEXyIN
         bHSA==
X-Gm-Message-State: AJIora936HqT5ZgHbuBcXB9KsOs/EkmMAsXqcivkwJri2q4ghh7Etm3I
        sLXNSWIb77ZlQ93Sm/6QzK342AjgkWM=
X-Google-Smtp-Source: AGRyM1uEPD5gytvepUOGJm9DMXLeca69zKD0tELw8UOHWCz9vRZohVVToXW7zzKBlWM49Tx6TIzpicy4Z2o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:7b90:b0:16a:3e1:bb1b with SMTP id
 w16-20020a1709027b9000b0016a03e1bb1bmr1464322pll.37.1656113262557; Fri, 24
 Jun 2022 16:27:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 24 Jun 2022 23:27:34 +0000
In-Reply-To: <20220624232735.3090056-1-seanjc@google.com>
Message-Id: <20220624232735.3090056-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220624232735.3090056-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.0.rc0.161.g10f37bed90-goog
Subject: [PATCH 3/4] KVM: x86/mmu: Shrink pte_list_desc size when KVM is using TDP
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dynamically size struct pte_list_desc's array of sptes based on whether
or not KVM is using TDP.  Commit dc1cff969101 ("KVM: X86: MMU: Tune
PTE_LIST_EXT to be bigger") bumped the number of entries in order to
improve performance when using shadow paging, but its analysis that the
larger size would not affect TDP was wrong.  Consuming pte_list_desc
objects for nested TDP is indeed rare, but _allocating_ objects is not,
as KVM allocates 40 objects for each per-vCPU cache.  Reducing the size
from 128 bytes to 32 bytes reduces that per-vCPU cost from 5120 bytes to
1280, and also provides similar savings when eager page splitting for
nested MMUs kicks in.

The per-vCPU overhead could be further reduced by using a custom, smaller
capacity for the per-vCPU caches, but that's more of an "and" than
an "or" change, e.g. it wouldn't help the eager page split use case.

Set the list size to the bare minimum without completely defeating the
purpose of an array (and because pte_list_add() assumes the array is at
least two entries deep).  A larger size, e.g. 4, would reduce the number
of "allocations", but those "allocations" only become allocations in
truth if a single vCPU depletes its cache to where a topup is needed,
i.e. if a single vCPU "allocates" 30+ lists.  Conversely, those 2 extra
entries consume 16 bytes * 40 * nr_vcpus in the caches the instant nested
TDP is used.

In the unlikely event that performance of aliased gfns for nested TDP
really is (or becomes) a priority for oddball workloads, KVM could add a
knob to let the admin tune the array size for their environment.

Note, KVM also unnecessarily tops up the per-vCPU caches even when not
using rmaps; this can also be addressed separately.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 49 +++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index ceb81e04aea3..2db328d28b7b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -101,6 +101,7 @@ bool tdp_enabled = false;
 static int max_huge_page_level __read_mostly;
 static int tdp_root_level __read_mostly;
 static int max_tdp_level __read_mostly;
+static int nr_sptes_per_pte_list __read_mostly;
 
 #ifdef MMU_DEBUG
 bool dbg = 0;
@@ -111,24 +112,21 @@ module_param(dbg, bool, 0644);
 
 #include <trace/events/kvm.h>
 
-/* make pte_list_desc fit well in cache lines */
-#define PTE_LIST_EXT 14
-
 /*
  * Slight optimization of cacheline layout, by putting `more' and `spte_count'
  * at the start; then accessing it will only use one single cacheline for
- * either full (entries==PTE_LIST_EXT) case or entries<=6.  On 32-bit kernels,
- * the entire struct fits in a single cacheline.
+ * either full (entries==nr_sptes_per_pte_list) case or entries<=6.  On 32-bit
+ * kernels, the entire struct fits in a single cacheline.
  */
 struct pte_list_desc {
 	struct pte_list_desc *more;
 	/*
 	 * The number of valid entries in sptes[].  Use an unsigned long to
 	 * naturally align sptes[] (a u8 for the count would suffice).  When
-	 * equal to PTE_LIST_EXT, this particular list is full.
+	 * equal to nr_sptes_per_pte_list, this particular list is full.
 	 */
 	unsigned long spte_count;
-	u64 *sptes[PTE_LIST_EXT];
+	u64 *sptes[];
 };
 
 struct kvm_shadow_walk_iterator {
@@ -883,8 +881,8 @@ static int pte_list_add(struct kvm_mmu_memory_cache *cache, u64 *spte,
 	} else {
 		rmap_printk("%p %llx many->many\n", spte, *spte);
 		desc = (struct pte_list_desc *)(rmap_head->val & ~1ul);
-		while (desc->spte_count == PTE_LIST_EXT) {
-			count += PTE_LIST_EXT;
+		while (desc->spte_count == nr_sptes_per_pte_list) {
+			count += nr_sptes_per_pte_list;
 			if (!desc->more) {
 				desc->more = kvm_mmu_memory_cache_alloc(cache);
 				desc = desc->more;
@@ -1102,7 +1100,7 @@ static u64 *rmap_get_next(struct rmap_iterator *iter)
 	u64 *sptep;
 
 	if (iter->desc) {
-		if (iter->pos < PTE_LIST_EXT - 1) {
+		if (iter->pos < nr_sptes_per_pte_list - 1) {
 			++iter->pos;
 			sptep = iter->desc->sptes[iter->pos];
 			if (sptep)
@@ -5642,8 +5640,27 @@ void kvm_configure_mmu(bool enable_tdp, int tdp_forced_root_level,
 	tdp_root_level = tdp_forced_root_level;
 	max_tdp_level = tdp_max_root_level;
 
-	BUILD_BUG_ON_MSG((sizeof(struct pte_list_desc) % 64),
+	/*
+	 * Size the array of sptes in pte_list_desc based on whether or not KVM
+	 * is using TDP.  When using TDP, the shadow MMU is used only to shadow
+	 * L1's TDP entries for L2.  For TDP, prioritize the per-vCPU memory
+	 * footprint (due to using per-vCPU caches) as aliasing L2 gfns to L1
+	 * gfns is rare.  When using shadow paging, prioritize performace as
+	 * aliasing gfns with multiple gvas is very common, e.g. L1 will have
+	 * kernel mappings and multiple userspace mappings for a given gfn.
+	 *
+	 * For TDP, size the array for the bare minimum of two entries (without
+	 * requiring a "list" for every single entry).
+	 *
+	 * For !TDP, size the array so that the overall size of pte_list_desc
+	 * is a multiple of the cache line size (assert this as well).
+	 */
+	BUILD_BUG_ON_MSG((sizeof(struct pte_list_desc) + 14 * sizeof(u64 *)) % 64,
 			 "pte_list_desc is not a multiple of cache line size (on modern CPUs)");
+	if (tdp_enabled)
+		nr_sptes_per_pte_list = 2;
+	else
+		nr_sptes_per_pte_list = 14;
 
 	/*
 	 * max_huge_page_level reflects KVM's MMU capabilities irrespective
@@ -6691,11 +6708,17 @@ void kvm_mmu_vendor_module_init(void)
 
 int kvm_mmu_hardware_setup(void)
 {
+	int pte_list_desc_size;
 	int ret = -ENOMEM;
 
+	if (WARN_ON_ONCE(!nr_sptes_per_pte_list))
+		return -EIO;
+
+	pte_list_desc_size = sizeof(struct pte_list_desc) +
+			     nr_sptes_per_pte_list * sizeof(u64 *);
 	pte_list_desc_cache = kmem_cache_create("pte_list_desc",
-					    sizeof(struct pte_list_desc),
-					    0, SLAB_ACCOUNT, NULL);
+						pte_list_desc_size, 0,
+						SLAB_ACCOUNT, NULL);
 	if (!pte_list_desc_cache)
 		goto out;
 
-- 
2.37.0.rc0.161.g10f37bed90-goog

