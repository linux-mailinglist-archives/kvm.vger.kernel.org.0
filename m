Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E83559CD59
	for <lists+kvm@lfdr.de>; Tue, 23 Aug 2022 02:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238077AbiHWArC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Aug 2022 20:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239164AbiHWAqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Aug 2022 20:46:53 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E35A4D152
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 17:46:51 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id q193-20020a632aca000000b0041d95d7ee81so5372328pgq.3
        for <kvm@vger.kernel.org>; Mon, 22 Aug 2022 17:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=5niTR1/vKfTFRgtx85YXkvJ6CCfCYM2aDePdp0OgEpE=;
        b=G8TGuUcHSEHIGStRwECqzrlZj0Y0NjCpx35ggoYoz2hySK3lBHVk/kHKixSi+zm9uf
         MMELcNyl/ILyCYybMJq3NgCRXdRooTSjLTqNE95ShBUqpEYWDlVGs9X6/eOvD2uHKBnc
         1eOI6YdZW4CxnGDRVcfeukqj4Xq9UqrleMaIH6cnwLzBFm7Qf6vybqxxIvdJhNGOz+8C
         ihIqjvUkmeFHqLEqwJwD6UUnIrpd44ZFrMCykfwoRHmerknP9Og/MaOQQe6IQxIqTCT6
         M1HQPImVz1VcOhPzbblEqC4V49TpD0sAlHRGMGN/Ld5paJbwvTceb1Scd7ZEwI7OxFFk
         7weg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=5niTR1/vKfTFRgtx85YXkvJ6CCfCYM2aDePdp0OgEpE=;
        b=ZdYxJkn98NkIygtQkDcJMixO7XKSV3cF4zV4wvdOkj5OS1Cza/5n+hk3DgFKhJ+WfT
         jwaV1vdkR5ncM8+T3ax+hBE3pg13A2IuyPXlaaDYCHOXUcz7+hk7o7CFiWORbUHiiSNM
         4xzrMNoMnjI1+PDxH5d/zwfByQJPaxlt9gdXIuWZQ72cTr6TgoCQfKmDPUqQLLj1sJmX
         O8VZ7rYk7bCsbsBoT9vElPtwg8jsmUfrREGJ86Q/BUlsCk+Hz7+rlxKc6Pyo/9lj7BKd
         jZcwZ8+GcaFLflt0fGKTb1P2CRB9fFkQcw9gizSmm2tjxd2F8tx8bGt9v7+p/R3osAal
         Y6fA==
X-Gm-Message-State: ACgBeo1KRp7dVnvCMIAYHCOeSlF4oUlYazB909NlsggJchOn4ubRmhOS
        rSsr7TfW0cz7AFJmzFh6Z9s3tAMoDRrteucq
X-Google-Smtp-Source: AA6agR6PQbVcJtZOJoJgA+LAQcdkbmjco2mwIDMXQcfDdzMC5Biz4IRKLTO6FeVPDLne3VNXdMZ+DrmLbqf2VuOI
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP
 id t9-20020a17090a024900b001e0a8a33c6cmr78092pje.0.1661215610056; Mon, 22 Aug
 2022 17:46:50 -0700 (PDT)
Date:   Tue, 23 Aug 2022 00:46:39 +0000
In-Reply-To: <20220823004639.2387269-1-yosryahmed@google.com>
Message-Id: <20220823004639.2387269-5-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220823004639.2387269-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v7 4/4] KVM: arm64/mmu: count KVM s2 mmu usage in secondary
 pagetable stats
From:   Yosry Ahmed <yosryahmed@google.com>
To:     Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Shakeel Butt <shakeelb@google.com>,
        Oliver Upton <oupton@google.com>
Cc:     Huang@google.com, Shaoqin <shaoqin.huang@intel.com>,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Yosry Ahmed <yosryahmed@google.com>,
        Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Count the pages used by KVM in arm64 for stage2 mmu in memory stats
under secondary pagetable stats (e.g. "SecPageTables" in /proc/meminfo)
to give better visibility into the memory consumption of KVM mmu in a
similar way to how normal user page tables are accounted.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c9a13e487187..34c5feed9dc1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -92,9 +92,13 @@ static bool kvm_is_device_pfn(unsigned long pfn)
 static void *stage2_memcache_zalloc_page(void *arg)
 {
 	struct kvm_mmu_memory_cache *mc = arg;
+	void *virt;
 
 	/* Allocated with __GFP_ZERO, so no need to zero */
-	return kvm_mmu_memory_cache_alloc(mc);
+	virt = kvm_mmu_memory_cache_alloc(mc);
+	if (virt)
+		kvm_account_pgtable_pages(virt, 1);
+	return virt;
 }
 
 static void *kvm_host_zalloc_pages_exact(size_t size)
@@ -102,6 +106,21 @@ static void *kvm_host_zalloc_pages_exact(size_t size)
 	return alloc_pages_exact(size, GFP_KERNEL_ACCOUNT | __GFP_ZERO);
 }
 
+static void *kvm_s2_zalloc_pages_exact(size_t size)
+{
+	void *virt = kvm_host_zalloc_pages_exact(size);
+
+	if (virt)
+		kvm_account_pgtable_pages(virt, (size >> PAGE_SHIFT));
+	return virt;
+}
+
+static void kvm_s2_free_pages_exact(void *virt, size_t size)
+{
+	kvm_account_pgtable_pages(virt, -(size >> PAGE_SHIFT));
+	free_pages_exact(virt, size);
+}
+
 static void kvm_host_get_page(void *addr)
 {
 	get_page(virt_to_page(addr));
@@ -112,6 +131,15 @@ static void kvm_host_put_page(void *addr)
 	put_page(virt_to_page(addr));
 }
 
+static void kvm_s2_put_page(void *addr)
+{
+	struct page *p = virt_to_page(addr);
+	/* Dropping last refcount, the page will be freed */
+	if (page_count(p) == 1)
+		kvm_account_pgtable_pages(addr, -1);
+	put_page(p);
+}
+
 static int kvm_host_page_count(void *addr)
 {
 	return page_count(virt_to_page(addr));
@@ -625,10 +653,10 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 
 static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.zalloc_page		= stage2_memcache_zalloc_page,
-	.zalloc_pages_exact	= kvm_host_zalloc_pages_exact,
-	.free_pages_exact	= free_pages_exact,
+	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
+	.free_pages_exact	= kvm_s2_free_pages_exact,
 	.get_page		= kvm_host_get_page,
-	.put_page		= kvm_host_put_page,
+	.put_page		= kvm_s2_put_page,
 	.page_count		= kvm_host_page_count,
 	.phys_to_virt		= kvm_host_va,
 	.virt_to_phys		= kvm_host_pa,
-- 
2.37.1.595.g718a3a8f04-goog

