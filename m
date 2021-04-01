Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7AC35241A
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 01:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236517AbhDAXib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 19:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236390AbhDAXi0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 19:38:26 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F07EC06178A
        for <kvm@vger.kernel.org>; Thu,  1 Apr 2021 16:38:25 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id i7so4261433qvh.22
        for <kvm@vger.kernel.org>; Thu, 01 Apr 2021 16:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=YE6UzfKVCMMZ4FmPHxQVQ73AQ/1CyoycUg8d9T2zy44=;
        b=CwnbxgidzNPuXnwFCcwLc0dnCKpIJlWSx1AvsEh15lhiQbUlAUFFLuyeIx9jEcbIR2
         NfOHt06yFwWyOmyqV5T7OW0pBvdkJRe+RlSIHOGgcCPK99OVVJbyApcCrHsIh+kLN7xj
         TT9s35RzNt+9zAi/s7zCnMZTKKaK7utN/gNVvLImzTxzQG1MV6NlAVpNtPpU7V+Pb8Jh
         o/lM7PAKtPi9+d9o1Q1r6OOs9kcFJMFXFUqZaJBYRRDWyGjBQS32zdwfHwWn4EHsG61b
         S7VwuTmol+jhNH0mHHXAabMT1zGiSD/dRAO8MlweJSxGrhZXOStfm9RIf5zjlAqxziuc
         q8zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=YE6UzfKVCMMZ4FmPHxQVQ73AQ/1CyoycUg8d9T2zy44=;
        b=coeARVBQAqUI9zCaHfqAJqhGeDU5kOuUyckwP7ImDQT7KJalmccRmHqNE3Yxq1AFAn
         mWWUlRnq125CUrY098e8xr8aTktq2dL/2cuO0mXpzfjErNcG7lkkbxKfK1ZvnB4xG+H4
         423mH3cdGuxP0kYjXYho15rIL74XRWa24VN8EGVYND8QVoOx9CgtNglGiuriHCdU+Y3k
         B82jhKlfeE8EbsRXQ36DFq5oCYhcYDAVucdqG74ldg3EdmMGEO5DcCu44168351bKbIh
         bvClopXuLJWlN25+R8IF7pr6KmOJb4Hq4YKTBeJdayw0RYY76jXrK/D9Q3xZl00a3/HF
         lA7w==
X-Gm-Message-State: AOAM5310iII/xoXtfRTO958lvIqxT10QANjyCeUFxZmBfEoL2762la0t
        l1lkLaOxt8idV+NxoyRV+aIyPEMsF0VE
X-Google-Smtp-Source: ABdhPJxCEndlAJ+pZNKpeF2guBvvAQXBNGg4bSKL89RTDPSsU7uP0y6Y5yqnEY78od/usyul99Ss6XBxrcV6
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:e088:88b8:ea4a:22b6])
 (user=bgardon job=sendgmr) by 2002:a0c:bd2f:: with SMTP id
 m47mr10623557qvg.53.1617320304345; Thu, 01 Apr 2021 16:38:24 -0700 (PDT)
Date:   Thu,  1 Apr 2021 16:37:35 -0700
In-Reply-To: <20210401233736.638171-1-bgardon@google.com>
Message-Id: <20210401233736.638171-13-bgardon@google.com>
Mime-Version: 1.0
References: <20210401233736.638171-1-bgardon@google.com>
X-Mailer: git-send-email 2.31.0.208.g409f899ff0-goog
Subject: [PATCH v2 12/13] KVM: x86/mmu: Fast invalidation for TDP MMU
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

Provide a real mechanism for fast invalidation by marking roots as
invalid so that their reference count will quickly fall to zero
and they will be torn down.

One negative side affect of this approach is that a vCPU thread will
likely drop the last reference to a root and be saddled with the work of
tearing down an entire paging structure. This issue will be resolved in
a later commit.

Signed-off-by: Ben Gardon <bgardon@google.com>
---

Changelog
v2:
--	open code root invalidation

 arch/x86/kvm/mmu/mmu.c     | 26 +++++++++++++++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.h |  3 +++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index a3837f8ad4ed..ba0c65076200 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5418,6 +5418,8 @@ static void kvm_zap_obsolete_pages(struct kvm *kvm)
  */
 static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 {
+	struct kvm_mmu_page *root;
+
 	lockdep_assert_held(&kvm->slots_lock);
 
 	write_lock(&kvm->mmu_lock);
@@ -5432,6 +5434,27 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 	 */
 	kvm->arch.mmu_valid_gen = kvm->arch.mmu_valid_gen ? 0 : 1;
 
+
+	if (is_tdp_mmu_enabled(kvm)) {
+		/*
+		 * Mark each TDP MMU root as invalid so that other threads
+		 * will drop their references and allow the root count to
+		 * go to 0.
+		 *
+		 * This has essentially the same effect for the TDP MMU
+		 * as updating mmu_valid_gen above does for the shadow
+		 * MMU.
+		 *
+		 * In order to ensure all threads see this change when
+		 * handling the MMU reload signal, this must happen in the
+		 * same critical section as kvm_reload_remote_mmus, and
+		 * before kvm_zap_obsolete_pages as kvm_zap_obsolete_pages
+		 * could drop the MMU lock and yield.
+		 */
+		list_for_each_entry(root, &kvm->arch.tdp_mmu_roots, link)
+			root->role.invalid = true;
+	}
+
 	/*
 	 * Notify all vcpus to reload its shadow page table and flush TLB.
 	 * Then all vcpus will switch to new shadow page table with the new
@@ -5444,9 +5467,6 @@ static void kvm_mmu_zap_all_fast(struct kvm *kvm)
 
 	kvm_zap_obsolete_pages(kvm);
 
-	if (is_tdp_mmu_enabled(kvm))
-		kvm_tdp_mmu_zap_all(kvm);
-
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index d703c6d6024a..8fa3e7421a93 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,6 +10,9 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm *kvm,
 						     struct kvm_mmu_page *root)
 {
+	if (root->role.invalid)
+		return false;
+
 	return refcount_inc_not_zero(&root->tdp_mmu_root_count);
 }
 
-- 
2.31.0.208.g409f899ff0-goog

