Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA86392920
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 09:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbhE0H7w (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 03:59:52 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2432 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235109AbhE0H7e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 03:59:34 -0400
Received: from dggeml703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FrKqH3kS4z66nY;
        Thu, 27 May 2021 15:55:07 +0800 (CST)
Received: from dggpeml500023.china.huawei.com (7.185.36.114) by
 dggeml703-chm.china.huawei.com (10.3.17.136) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 27 May 2021 15:58:00 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 27 May 2021 15:58:00 +0800
From:   Shaokun Zhang <zhangshaokun@hisilicon.com>
To:     <x86@kernel.org>, <kvm@vger.kernel.org>
CC:     Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Ben Gardon <bgardon@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Sean Christopherson" <seanjc@google.com>
Subject: [PATCH v2] KVM: x86/mmu: Make is_nx_huge_page_enabled an inline function
Date:   Thu, 27 May 2021 15:57:51 +0800
Message-ID: <1622102271-63107-1-git-send-email-zhangshaokun@hisilicon.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500023.china.huawei.com (7.185.36.114)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Function 'is_nx_huge_page_enabled' is called only by kvm/mmu, so make
it as inline fucntion and remove the unnecessary declaration.

Cc: Ben Gardon <bgardon@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
---
ChangeLog:
v1-->v2:
    1. Address Sean's comment, make is_nx_huge_page_enabled it as
static inline function and remove the unnecessary declaration.

 arch/x86/kvm/mmu/mmu.c          | 7 +------
 arch/x86/kvm/mmu/mmu_internal.h | 9 ++++++---
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0144c40d09c7..d1e89e7ded17 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -55,7 +55,7 @@
 
 extern bool itlb_multihit_kvm_mitigation;
 
-static int __read_mostly nx_huge_pages = -1;
+int __read_mostly nx_huge_pages = -1;
 #ifdef CONFIG_PREEMPT_RT
 /* Recovery can cause latency spikes, disable it for PREEMPT_RT.  */
 static uint __read_mostly nx_huge_pages_recovery_ratio = 0;
@@ -208,11 +208,6 @@ void kvm_flush_remote_tlbs_with_address(struct kvm *kvm,
 	kvm_flush_remote_tlbs_with_range(kvm, &range);
 }
 
-bool is_nx_huge_page_enabled(void)
-{
-	return READ_ONCE(nx_huge_pages);
-}
-
 static void mark_mmio_spte(struct kvm_vcpu *vcpu, u64 *sptep, u64 gfn,
 			   unsigned int access)
 {
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index d64ccb417c60..ff4c6256f3f9 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -116,7 +116,12 @@ static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 	       kvm_x86_ops.cpu_dirty_log_size;
 }
 
-bool is_nx_huge_page_enabled(void);
+extern int nx_huge_pages;
+static inline bool is_nx_huge_page_enabled(void)
+{
+	return READ_ONCE(nx_huge_pages);
+}
+
 bool mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
 			    bool can_unsync);
 
@@ -158,8 +163,6 @@ int kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, gfn_t gfn,
 void disallowed_hugepage_adjust(u64 spte, gfn_t gfn, int cur_level,
 				kvm_pfn_t *pfnp, int *goal_levelp);
 
-bool is_nx_huge_page_enabled(void);
-
 void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 
 void account_huge_nx_page(struct kvm *kvm, struct kvm_mmu_page *sp);
-- 
2.7.4

