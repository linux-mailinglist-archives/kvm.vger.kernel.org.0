Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7E5375A53
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 20:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236434AbhEFSoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 14:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236425AbhEFSoJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 14:44:09 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18574C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 11:43:10 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i8-20020a0569020688b02904ef3bd00ce7so7017084ybt.7
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 11:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GtG2Li1hJ2c1X8OEHWNaHyM594B8YKHryUGcXMN1QiU=;
        b=UGdCOIsg0ebAZn3jpN09cWq9TXHe1QXf/zoSXe1jv/0Ps9l5vGgvoRcLMEXFvn2lrt
         WbZKA/EJN2oBPzBeho7RxLmzFTPUadL+2yb/6dapxHNN6LQ+K4M2BjpAPLTNeLe+M7BC
         xENE+nRNAOSl8H+Q69u25sP6qnhT383oDxSXhi2ik5u3RlF2wE5w4FUzF/T2GsZ1+nTN
         4fI+/Ec2ILIAEkAQKiKKENxVrBH5pR9JzkJToEPMHZv/6u7FLlyaJzyX30f7snbZbRg8
         kgLBIWiGtQnyMPvE9cvUWrHENpl1BjXwg+4jfpMSG66jcOQkQtF+ai3rugKwkIqL6DCk
         +rDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GtG2Li1hJ2c1X8OEHWNaHyM594B8YKHryUGcXMN1QiU=;
        b=nlrRpW5wXx2k5bYaWLxpYOUob/aYDtL+ZUatx0I0gkJT6AwFA/KgurSbbRMTH40dCe
         Bf8OHY8ftPqS4JzMmEnCLv95Zbd++LXuI+VQ7vjL3bUy6t1ktfyDbE2doWEgKoywJybU
         YenkEzsvmpe5LM2XfJzZIsfB+68wOHD0NPcM6WkWh+X1Fky+Y8cUBuhtIPijP8NaK23l
         HXbVw15GLj3EsrQttd5qoMQ2Tg0mZE21x13BhAacyAXR5WYVeUoBhKuIXP/ZA4ywLcdz
         ewZhLo9kQJpDvuHqAfGPUFKrTRpdz0HmE73HtsLSV5yNrhO49XzWJy0Z61jKl3rN2GYN
         Wu0Q==
X-Gm-Message-State: AOAM530nL123N372skTjSkZxVlaLI71N/THz8kuGsnpk2WmnDwF62vU2
        4mhz/yk1kUyQnaXB+A7CkSjYfWt/B1fs
X-Google-Smtp-Source: ABdhPJxByY6b5f68Uhs/L0Xk9/1m581bhjl2gLChMB2+Ols6AXQeyTICiiycd7fELsn4qllVfYVs37NIyKFh
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9258:9474:54ca:4500])
 (user=bgardon job=sendgmr) by 2002:a25:b993:: with SMTP id
 r19mr8209402ybg.445.1620326589319; Thu, 06 May 2021 11:43:09 -0700 (PDT)
Date:   Thu,  6 May 2021 11:42:38 -0700
In-Reply-To: <20210506184241.618958-1-bgardon@google.com>
Message-Id: <20210506184241.618958-6-bgardon@google.com>
Mime-Version: 1.0
References: <20210506184241.618958-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.1.607.g51e8a6a459-goog
Subject: [PATCH v3 5/8] KVM: x86/mmu: Add a field to control memslot rmap allocation
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
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a field to control whether new memslots should have rmaps allocated
for them. As of this change, it's not safe to skip allocating rmaps, so
the field is always set to allocate rmaps. Future changes will make it
safe to operate without rmaps, using the TDP MMU. Then further changes
will allow the rmaps to be allocated lazily when needed for nested
oprtation.

No functional change expected.

Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_host.h |  8 ++++++++
 arch/x86/kvm/mmu/mmu.c          |  2 ++
 arch/x86/kvm/x86.c              | 18 +++++++++++++-----
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index ad22d4839bcc..00065f9bbc5e 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1122,6 +1122,12 @@ struct kvm_arch {
 	 */
 	spinlock_t tdp_mmu_pages_lock;
 #endif /* CONFIG_X86_64 */
+
+	/*
+	 * If set, rmaps have been allocated for all memslots and should be
+	 * allocated for any newly created or modified memslots.
+	 */
+	bool memslots_have_rmaps;
 };
 
 struct kvm_vm_stat {
@@ -1853,4 +1859,6 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 
 int kvm_cpu_dirty_log_size(void);
 
+inline bool kvm_memslots_have_rmaps(struct kvm *kvm);
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 930ac8a7e7c9..8761b4925755 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5469,6 +5469,8 @@ void kvm_mmu_init_vm(struct kvm *kvm)
 
 	kvm_mmu_init_tdp_mmu(kvm);
 
+	kvm->arch.memslots_have_rmaps = true;
+
 	node->track_write = kvm_mmu_pte_write;
 	node->track_flush_slot = kvm_mmu_invalidate_zap_pages_in_memslot;
 	kvm_page_track_register_notifier(kvm, node);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fc32a7dbe4c4..d7a40ce342cc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10868,7 +10868,13 @@ static int alloc_memslot_rmap(struct kvm_memory_slot *slot,
 	return -ENOMEM;
 }
 
-static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
+bool kvm_memslots_have_rmaps(struct kvm *kvm)
+{
+	return kvm->arch.memslots_have_rmaps;
+}
+
+static int kvm_alloc_memslot_metadata(struct kvm *kvm,
+				      struct kvm_memory_slot *slot,
 				      unsigned long npages)
 {
 	int i;
@@ -10881,9 +10887,11 @@ static int kvm_alloc_memslot_metadata(struct kvm_memory_slot *slot,
 	 */
 	memset(&slot->arch, 0, sizeof(slot->arch));
 
-	r = alloc_memslot_rmap(slot, npages);
-	if (r)
-		return r;
+	if (kvm_memslots_have_rmaps(kvm)) {
+		r = alloc_memslot_rmap(slot, npages);
+		if (r)
+			return r;
+	}
 
 	for (i = 1; i < KVM_NR_PAGE_SIZES; ++i) {
 		struct kvm_lpage_info *linfo;
@@ -10954,7 +10962,7 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 				enum kvm_mr_change change)
 {
 	if (change == KVM_MR_CREATE || change == KVM_MR_MOVE)
-		return kvm_alloc_memslot_metadata(memslot,
+		return kvm_alloc_memslot_metadata(kvm, memslot,
 						  mem->memory_size >> PAGE_SHIFT);
 	return 0;
 }
-- 
2.31.1.607.g51e8a6a459-goog

