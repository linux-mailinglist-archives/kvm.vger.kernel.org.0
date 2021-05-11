Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABDA37ACE2
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 19:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhEKRRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 13:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbhEKRR2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 13:17:28 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B758DC061763
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:16:21 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id n1-20020a628f010000b02902a0e02b2be8so10108906pfd.6
        for <kvm@vger.kernel.org>; Tue, 11 May 2021 10:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uuu17mHGt/KubHNv6B4Puz8KNLHKsb7X5PjppcGXfqw=;
        b=lLwwzQ4KPOuibe32HUV2T1sr9kwP5TBQNFzot9w74MdDyGsF+uiGVnb8qWE+Hz0L08
         Yy5l7q6D5aOucPbnlpg7EQmY63WEIly0gHlowClLZoJMFDnNPAtH8L9IqX5q0hAsYy/m
         K5ShsqUGAbWzxwUT/d1NVm5+2YILtS+08fmvwYCjy7E99MRTPPV1Ify7JSD/dAjOSikI
         ufrwCi6dhW5ebSptucOd4bYo/iJ5YaVyrgFDLk3mUDXVAi/Q1Hk+BdGWtaeFScgqFqGN
         kJKHMOhPn+EhQ3+a+oR3itJYc8kqZNntih+7gA3i49cZFlJRsjg/kr0g+GaUrXXTn2BD
         +WyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uuu17mHGt/KubHNv6B4Puz8KNLHKsb7X5PjppcGXfqw=;
        b=OcDByoUZKM7y9RGpFguKlizqmKBKD7rzishum00d9vnL/804N8RlH6F/Zal68m8wPv
         H251r7tlKT3FqldQvzooZRVVD/G08YjCV+tzWhVsMH0vu34Jr1XVHDNFuSOKfX9KPEfO
         mBa/WH4qOSCFAV+7HFwJYhe1SwOTRfuk1+c61DTGmoACviIWMNnRglMFpItIz7iuzoGa
         m4+d0ssSyRYPaRWYbFOPUWh2YuQBQ+8Fgb8ydtiGCMETKqBCYMuQ72iJCG1BIgH0HgU4
         x2qEipznDyL104DvJxbsqoibWdEigDR1J5iMJwlbz74s26MsXSa+oM3mGBZG8MTQ2Gnh
         2rrQ==
X-Gm-Message-State: AOAM5327bi4js+pN5VH8O3wkwkeevmNHd8mxdHVlCoYyAGiXCYFuFH28
        09oIetEVbwL26sA2Yn1xeaoKCksnVOwz
X-Google-Smtp-Source: ABdhPJy/zQy0Jp1q7PjF3Oca69HRcxr3KMDVVo5y/U32nEDcmmanHHzxoBXFOioLLCo5qEQsbDlZmigT8XPF
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e050:3342:9ea6:6859])
 (user=bgardon job=sendgmr) by 2002:a17:90a:4487:: with SMTP id
 t7mr298411pjg.1.1620753380897; Tue, 11 May 2021 10:16:20 -0700 (PDT)
Date:   Tue, 11 May 2021 10:16:05 -0700
In-Reply-To: <20210511171610.170160-1-bgardon@google.com>
Message-Id: <20210511171610.170160-3-bgardon@google.com>
Mime-Version: 1.0
References: <20210511171610.170160-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v4 2/7] KVM: x86/mmu: Factor out allocating memslot rmap
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small refactor to facilitate allocating rmaps for all memslots at once.

No functional change expected.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/kvm/x86.c | 39 ++++++++++++++++++++++++++++++---------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1e1f4f31e586..cc0440b5b35d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10911,10 +10911,35 @@ void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *slot)
 	kvm_page_track_free_memslot(slot);
 }
 
+static int memslot_rmap_alloc(struct kvm_memory_slot *slot,
+			      unsigned long npages)
+{
+	int i;
+
+	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
+		int lpages;
+		int level = i + 1;
+
+		lpages = gfn_to_index(slot->base_gfn + npages - 1,
+				      slot->base_gfn, level) + 1;
+
+		slot->arch.rmap[i] =
+			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
+				 GFP_KERNEL_ACCOUNT);
+		if (!slot->arch.rmap[i]) {
+			memslot_rmap_free(slot);
+			return -ENOMEM;
+		}
+	}
+
+	return 0;
+}
+
 static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 				      unsigned long npages)
 {
 	int i;
+	int r;
 
 	/*
 	 * Clear out the previous array pointers for the KVM_MR_MOVE case.  The
@@ -10923,7 +10948,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 	 */
 	memset(&slot->arch, 0, sizeof(slot->arch));
 
-	for (i = 0; i < KVM_NR_PAGE_SIZES; ++i) {
+	r = memslot_rmap_alloc(slot, npages);
+	if (r)
+		return r;
+
+	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
 		struct kvm_lpage_info *linfo;
 		unsigned long ugfn;
 		int lpages;
@@ -10932,14 +10961,6 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 		lpages = gfn_to_index(slot->base_gfn + npages - 1,
 				      slot->base_gfn, level) + 1;
 
-		slot->arch.rmap[i] =
-			kvcalloc(lpages, sizeof(*slot->arch.rmap[i]),
-				 GFP_KERNEL_ACCOUNT);
-		if (!slot->arch.rmap[i])
-			goto out_free;
-		if (i == 0)
-			continue;
-
 		linfo = kvcalloc(lpages, sizeof(*linfo), GFP_KERNEL_ACCOUNT);
 		if (!linfo)
 			goto out_free;
-- 
2.31.1.607.g51e8a6a459-goog

