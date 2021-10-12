Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5715142A0CB
	for <lists+kvm@lfdr.de>; Tue, 12 Oct 2021 11:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbhJLJQo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Oct 2021 05:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235175AbhJLJQo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Oct 2021 05:16:44 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FDEC06161C
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 02:14:42 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id m21so13319039pgu.13
        for <kvm@vger.kernel.org>; Tue, 12 Oct 2021 02:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gsikHghVru8/rUeORtbHI2W2haVRkZtoaZ66/GPgtEk=;
        b=BTCpRmH5elkD+Jip61aEsZhqzOhbyYC68+4YO7JMTwp1bwEBHq0ziGmzxw8IHiTfTS
         rUfWvgsS9AutyBX2aD7n7E3gcyuPG40NOsl/XgIMrKsEwqJP+5JjyUUhTnUvYMBzi6Zt
         Y93nJ74qJYgBTrPB8tJg8A2Q2iG+eDGrNNuII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gsikHghVru8/rUeORtbHI2W2haVRkZtoaZ66/GPgtEk=;
        b=dHBkd0mAHneePOKGgNskFEnbo/Jam/5rUzuaBt6//Cv4MBSfJyRVmJ/WXZCwWejooQ
         tUiz4Pa1QtsT0MwIGatrVK5KZFb+0C92DR1EiPe4rr//GYeRlyD8TpxZGSd6F3WTECVY
         TMAwAWhXyVqURaSLH/knkWIF2JPS8Vz2iH5MYbj9VsXNrk3tbAn5W0fPLjxedRGLQosO
         dSQ8Yxp4JGwK4NTAVUinaPd36KB+CK5DF97ptWm+JNs+4TMYCRGor4ybyL6BJXVWB7Wc
         xKfNmTbaK1Qn0Etntixo1P2oSIXJ+fuUK9Qic6kjPEL81i+w68llM7lWnvx/xa2JpYLA
         rvlg==
X-Gm-Message-State: AOAM531M1BDLfUF0UdC06XSKJh+aVdNunBBzVtlDQdZ/qrNrXQU3lQ7J
        ORyCAWWk5xih6yYjuEP9ZP3lUkZx87AUBw==
X-Google-Smtp-Source: ABdhPJw5yBZbuCINijJ1z7bpgu3MLsahMnCPdTPx9qxUIVs1uc0Ins3QkDWTVp8njKQGjB/U8k44rQ==
X-Received: by 2002:a63:1504:: with SMTP id v4mr22074972pgl.151.1634030082417;
        Tue, 12 Oct 2021 02:14:42 -0700 (PDT)
Received: from senozhatsky.flets-east.jp ([2409:10:2e40:5100:8b6f:6c85:edfe:b252])
        by smtp.gmail.com with ESMTPSA id i13sm5263233pgf.77.2021.10.12.02.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 02:14:41 -0700 (PDT)
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Suleiman Souhlal <suleiman@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCH] KVM: MMU: make PTE_PREFETCH_NUM tunable
Date:   Tue, 12 Oct 2021 18:14:30 +0900
Message-Id: <20211012091430.1754492-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Turn PTE_PREFETCH_NUM into a module parameter, so that it
can be tuned per-VM.

- /sys/module/kvm/parameters/pte_prefetch_num 8

             VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time         Avg time

       EPT_VIOLATION     760998    54.85%     7.23%      0.92us  31765.89us      7.78us ( +-   1.46% )
           MSR_WRITE     170599    12.30%     0.53%      0.60us   3334.13us      2.52us ( +-   0.86% )
  EXTERNAL_INTERRUPT     159510    11.50%     1.65%      0.49us  43705.81us      8.45us ( +-   7.54% )
[..]

Total Samples:1387305, Total events handled time:81900258.99us.

- /sys/module/kvm/parameters/pte_prefetch_num 16

             VM-EXIT    Samples  Samples%     Time%    Min Time    Max Time         Avg time

       EPT_VIOLATION     658064    52.58%     7.04%      0.91us  17022.84us      8.34us ( +-   1.52% )
           MSR_WRITE     163776    13.09%     0.54%      0.56us   5192.10us      2.57us ( +-   1.25% )
  EXTERNAL_INTERRUPT     144588    11.55%     1.62%      0.48us  97410.16us      8.75us ( +-  11.44% )
[..]

Total Samples:1251546, Total events handled time:77956187.56us.

Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
---
 arch/x86/kvm/mmu/mmu.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 24a9f4c3f5e7..0ab4490674ec 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -115,6 +115,8 @@ module_param(dbg, bool, 0644);
 #endif
 
 #define PTE_PREFETCH_NUM		8
+static uint __read_mostly pte_prefetch_num = PTE_PREFETCH_NUM;
+module_param(pte_prefetch_num, uint, 0644);
 
 #define PT32_LEVEL_BITS 10
 
@@ -732,7 +734,7 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 
 	/* 1 rmap, 1 parent PTE per level, and the prefetched rmaps. */
 	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_pte_list_desc_cache,
-				       1 + PT64_ROOT_MAX_LEVEL + PTE_PREFETCH_NUM);
+				       1 + PT64_ROOT_MAX_LEVEL + pte_prefetch_num);
 	if (r)
 		return r;
 	r = kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_shadow_page_cache,
@@ -2753,20 +2755,29 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 				    struct kvm_mmu_page *sp,
 				    u64 *start, u64 *end)
 {
-	struct page *pages[PTE_PREFETCH_NUM];
+	struct page **pages;
 	struct kvm_memory_slot *slot;
 	unsigned int access = sp->role.access;
 	int i, ret;
 	gfn_t gfn;
 
+	pages = kmalloc_array(pte_prefetch_num, sizeof(struct page *),
+			      GFP_KERNEL);
+	if (!pages)
+		return -1;
+
 	gfn = kvm_mmu_page_get_gfn(sp, start - sp->spt);
 	slot = gfn_to_memslot_dirty_bitmap(vcpu, gfn, access & ACC_WRITE_MASK);
-	if (!slot)
-		return -1;
+	if (!slot) {
+		ret = -1;
+		goto out;
+	}
 
 	ret = gfn_to_page_many_atomic(slot, gfn, pages, end - start);
-	if (ret <= 0)
-		return -1;
+	if (ret <= 0) {
+		ret = -1;
+		goto out;
+	}
 
 	for (i = 0; i < ret; i++, gfn++, start++) {
 		mmu_set_spte(vcpu, slot, start, access, gfn,
@@ -2774,7 +2785,9 @@ static int direct_pte_prefetch_many(struct kvm_vcpu *vcpu,
 		put_page(pages[i]);
 	}
 
-	return 0;
+out:
+	kfree(pages);
+	return ret;
 }
 
 static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
@@ -2785,10 +2798,10 @@ static void __direct_pte_prefetch(struct kvm_vcpu *vcpu,
 
 	WARN_ON(!sp->role.direct);
 
-	i = (sptep - sp->spt) & ~(PTE_PREFETCH_NUM - 1);
+	i = (sptep - sp->spt) & ~(pte_prefetch_num - 1);
 	spte = sp->spt + i;
 
-	for (i = 0; i < PTE_PREFETCH_NUM; i++, spte++) {
+	for (i = 0; i < pte_prefetch_num; i++, spte++) {
 		if (is_shadow_present_pte(*spte) || spte == sptep) {
 			if (!start)
 				continue;
-- 
2.33.0.882.g93a45727a2-goog

