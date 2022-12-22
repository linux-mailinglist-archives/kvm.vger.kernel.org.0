Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13845653AAE
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 03:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234991AbiLVCfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Dec 2022 21:35:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234935AbiLVCfO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Dec 2022 21:35:14 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E446725E85
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:35:08 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id u3-20020a056a00124300b0056d4ab0c7cbso302264pfi.7
        for <kvm@vger.kernel.org>; Wed, 21 Dec 2022 18:35:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Uy5Q2JyltsFU76SmhFR5SIPjgCJm3U7CWH+6Z0DXsQs=;
        b=Sxl6bgj9EJ9iuihYZp83JeZx6IvPl8UZ1m5+6Cm43HO2NjgEx1Ek/IP3Bjg0bBhZW0
         8ZsoHARIkAabw+eZ9yX3vNLtLVrs4JXFtNBZ9ix0k6roaGbDS77OSl0l9+SaY1BxFrgj
         WyVFHhz44Nzpglk0v7PrLxxRSm/7PGwcY/LPhH5DfSLZIQd9fxWJKRGLBAUCpaB23ERE
         haqSqyKBtrgEucB247ShrNEzUOq8CKDN0XA8iJ7Koj/0KmQ9/BF5rYF7mYrXvQ555RLf
         Rq3YPDdsAMh/1f7gLPWqTz9zIe10Nns6MnBvB6QXtJMsV0+jRLRhbINgIKNU9UmSqp05
         Sb4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Uy5Q2JyltsFU76SmhFR5SIPjgCJm3U7CWH+6Z0DXsQs=;
        b=Hm6tyD4gvglLabJhhR79nmD48fBiEYynwRUc7UZBGVyIR71WdDY9xH1NvmC7nIMAPk
         evo0QbUI3cl6E5X/CeE2yELCgoQU4GNmI0+P/NpuYRPwR3F28VOh1vzNyHbvpIThH0SH
         L4mv4SxpsjZVC6GG5JAGk5YChpMqYsNWWeCCmE/XKkhp4pmNXkx7Ppl7OI+L0ioOiPJe
         mnJC7uCVB8kmAeeiR6GyGwYzZJdynNIVoMtEaW/eh3ub4CZ8W4Eesvaoajmo06+VoFFR
         ntQ9ODmfXRP2c/7TzTJV7iXoaP6ApqHN6D8aoYFOk+h2W+HC9aLGsbMVsimlW0l0nqJ7
         M9mQ==
X-Gm-Message-State: AFqh2kp7LVLPZpLsyJNduNxgxQOm9o2hanphhjCGZCBOAVdY5VgID0js
        /lS3R3GepWpej4MsVx4aWzEqEaRw2u05
X-Google-Smtp-Source: AMrXdXv4l2iC4/6tj8LaLY8coRC0+QBvzj+rX/d00qDOyzqCHl1d07EeJQdXbmkvRo6dKHfncNl0vOPNS2s0
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:8e81:b0:219:c5b3:c543 with SMTP id
 f1-20020a17090a8e8100b00219c5b3c543mr494590pjo.200.1671676508473; Wed, 21 Dec
 2022 18:35:08 -0800 (PST)
Date:   Wed, 21 Dec 2022 18:34:53 -0800
In-Reply-To: <20221222023457.1764-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20221222023457.1764-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221222023457.1764-6-vipinsh@google.com>
Subject: [Patch v3 5/9] KVM: x86/mmu: Allocate TDP page table's page on
 correct NUMA node on split
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com, bgardon@google.com,
        dmatlack@google.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When dirty log is enabled, huge pages are split. Page table's pages
during the split are allocated based on the current thread NUMA node or
mempolicy. This causes inefficient page table accesses if underlying
page is on a different NUMA node

Allocate page table's pages on the same NUMA node as the underlying huge
page when dirty log is enabled and huge pages are split.

The performance gain during the pre-copy phase of live migrations of a
416 vCPUs and 11 TiB memory VM  on a 8 node host was seen in the range
of 130% to 150%.

Suggested-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++----
 include/linux/kvm_host.h   | 18 ++++++++++++++++++
 2 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 4974fa96deff..376b8dceb3f9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1403,7 +1403,7 @@ bool kvm_tdp_mmu_wrprot_slot(struct kvm *kvm,
 	return spte_set;
 }
 
-static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
+static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(int nid, gfp_t gfp)
 {
 	struct kvm_mmu_page *sp;
 
@@ -1413,7 +1413,8 @@ static struct kvm_mmu_page *__tdp_mmu_alloc_sp_for_split(gfp_t gfp)
 	if (!sp)
 		return NULL;
 
-	sp->spt = (void *)__get_free_page(gfp);
+	sp->spt = kvm_mmu_get_free_page(nid, gfp);
+
 	if (!sp->spt) {
 		kmem_cache_free(mmu_page_header_cache, sp);
 		return NULL;
@@ -1427,6 +1428,9 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 						       bool shared)
 {
 	struct kvm_mmu_page *sp;
+	int nid;
+
+	nid = kvm_pfn_to_page_table_nid(spte_to_pfn(iter->old_spte));
 
 	/*
 	 * Since we are allocating while under the MMU lock we have to be
@@ -1437,7 +1441,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 	 * If this allocation fails we drop the lock and retry with reclaim
 	 * allowed.
 	 */
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_NOWAIT | __GFP_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_NOWAIT | __GFP_ACCOUNT);
 	if (sp)
 		return sp;
 
@@ -1449,7 +1453,7 @@ static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(struct kvm *kvm,
 		write_unlock(&kvm->mmu_lock);
 
 	iter->yielded = true;
-	sp = __tdp_mmu_alloc_sp_for_split(GFP_KERNEL_ACCOUNT);
+	sp = __tdp_mmu_alloc_sp_for_split(nid, GFP_KERNEL_ACCOUNT);
 
 	if (shared)
 		read_lock(&kvm->mmu_lock);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d48064503b88..a262e15ebd19 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1583,6 +1583,24 @@ void kvm_arch_sync_events(struct kvm *kvm);
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
 
 struct page *kvm_pfn_to_refcounted_page(kvm_pfn_t pfn);
+
+/*
+ * Tells the appropriate NUMA node location of the page table's page based on
+ * pfn it will point to.
+ *
+ * Return the nid of the page if pfn is valid and backed by a refcounted page,
+ * otherwise, return the nearest memory node for the current CPU.
+ */
+static inline int kvm_pfn_to_page_table_nid(kvm_pfn_t pfn)
+{
+	struct page *page = kvm_pfn_to_refcounted_page(pfn);
+
+	if (page)
+		return page_to_nid(page);
+	else
+		return numa_mem_id();
+}
+
 bool kvm_is_zone_device_page(struct page *page);
 
 struct kvm_irq_ack_notifier {
-- 
2.39.0.314.g84b9a713c41-goog

