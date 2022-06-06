Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5799053F21A
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 00:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234653AbiFFWVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 18:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235063AbiFFWVP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 18:21:15 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE0AA0D2F
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 15:21:14 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id i8-20020a170902c94800b0016517194819so8264556pla.7
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 15:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lCj5vf6+ANqLHv3122ZbLr+VtIsIBzbS/r0LeVNVl3w=;
        b=fhNqTQhqkFux/ukIEgHzIyWXf7nWgidEa7EZyE6ojT7eSM39dn6EJghTF0Wz+po+G8
         NrXJEpS7gJdVDOJob5aQvoGsOmcx+ynWrkIQ6mokqSgyj8IvYWY1o4fPwhteMr1UyxnN
         +cNHE3z/DMTyLaXYmsi6tOorj2M77FxEsSXaEjz/7pr793GUJ9HhGSRtQN77II9Kyt1x
         VCEb+fRiffbhSZD7SWq09vE6VbwZtBwVsEFs3id87zkSeTVMGB608xT5Z3874uG8vwE8
         TehuFGa8lHQuFkXATbjbgXalldhf4GeMOqL5oJbujtgTwTrXOyonxqdb6ZfbN2/Hk4qK
         UzxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lCj5vf6+ANqLHv3122ZbLr+VtIsIBzbS/r0LeVNVl3w=;
        b=GYEBbMLmhqLIk9U8fyz1431d528NzUtCTsB3fJdSWxmTTW9y2p5YwaI1/JxURv8vhh
         7Wyxe8OMDt6kV1qqz3HXTH6jBKjSJwhBTGE2ZNCm+xaK3u27O0qZ+dEAsebS02IuUrqm
         991Kgc2Rpi0705BAZIefoLNerd9sNMzFd6wTwqhuPx18v3WcQH56ZKSqTSiop5NHsI+e
         GmIERJPAKaHSnYLIqC8ft9ciwtA15gAolvfF8BmffDkQRsvM2zYQeMMFuzWdKfdTVSBk
         aAhK9GdVMv9gM1bd0H2dqPhTqv+d99wqGHxZsGREhA+4AZcu2FDAilsKrrQvhlCiHlV5
         2jwQ==
X-Gm-Message-State: AOAM532O+lqL8habT4Mti+4UgZbkpriKT0UKlIQFNF9TFLHb3gIFDt+R
        U+yqcFN8XyS2qHAS/6U1DsyrgbKWBu8ujaH5
X-Google-Smtp-Source: ABdhPJzBKxlko2XskCwZ7XghA3/1uxqpH481I1Y3w7YnTvGyWNqjKRB0PQYcZSZzhwqgcHglYMcExUynh375FBjd
X-Received: from yosry.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2327])
 (user=yosryahmed job=sendgmr) by 2002:a17:902:cf0f:b0:15a:24e0:d9b0 with SMTP
 id i15-20020a170902cf0f00b0015a24e0d9b0mr25703791plg.42.1654554074043; Mon,
 06 Jun 2022 15:21:14 -0700 (PDT)
Date:   Mon,  6 Jun 2022 22:20:58 +0000
In-Reply-To: <20220606222058.86688-1-yosryahmed@google.com>
Message-Id: <20220606222058.86688-5-yosryahmed@google.com>
Mime-Version: 1.0
References: <20220606222058.86688-1-yosryahmed@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [PATCH v5 4/4] KVM: arm64/mmu: count KVM s2 mmu usage in secondary
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
Cc:     cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        Yosry Ahmed <yosryahmed@google.com>
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

Count the pages used by KVM in arm64 for stage2 mmu in secondary pagetable
stats.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 arch/arm64/kvm/mmu.c | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index f5651a05b6a85..80bc92601fd96 100644
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
2.36.1.255.ge46751e96f-goog

