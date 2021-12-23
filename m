Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6034447E94B
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350466AbhLWWXw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234631AbhLWWXp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:23:45 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735F1C061756
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:45 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id n22-20020a6563d6000000b0029261ffde9bso3864903pgv.22
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:23:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=O0B5yHs9mrLguToeJUNtqwnxH46d2zShhuTlEqWnd2Y=;
        b=j3f476DX6cFUy1LeHxbgKU/39XYmfhXM7YCJPoGXYJXG4tzh/TIg4LDroE2Eh8ExsZ
         AszwXw0eWIPsVr7PnWBZcgNh6EpXOAOPb0XC3CmRJXBSR0HJsp62GWyPgDvuFruj8vHG
         PfjgOdZhKq9insutYDBhPQnerzAdn3MEPZpEXni76KbXEiDUAu39kuYLUx949LrpK2l1
         s/7T1AusdxAnqAKm683N6/qpuVdUd+mEwrFZpFkZm23/wPMb7dnPnFgoASe+Av8Kv9gF
         KGyCf757+Ogsd5v6vCHUBpuzle1TjAWrsR3KpYnAOnCNESSYhkGC/FZIGaJCqBdVbDsS
         uxWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=O0B5yHs9mrLguToeJUNtqwnxH46d2zShhuTlEqWnd2Y=;
        b=bW3Mdb6OUltv/ERxjaPA7eXumKBUjmeI6IxmC8R5xRVqWDtN49W48Kg5rLj5rp/Fng
         BtUqYASa0qc/IrqlGt0gzwQsjYV0bdzHjMWnVggFd2El1pohWBPWJkCOqCT9xooRQpv3
         6PQASs7AmxYMcbEs4BwdeDdJKfJd7drzHq7SpUGxXyqx42Ztahq6pRU5bH6ZMkaHePg4
         M+qJIZZHtAwqvXBNNMwMCj8AQqFOD4ZEX1nvbgk2zO8onyfOAFFRfZV+R0mEZLBi2OPX
         qPiPQ32szP2V5yo5gXtKZKGF0qggFJiM1ChRDRtMBTrRvdL1z8vKPDMldEos1FNuQkn+
         zBxg==
X-Gm-Message-State: AOAM531vkO4q3vMzG7fWXFssH/Rth0ue7x0igYPh1LQpCAkJ6vs4jeMq
        6Pl5SMf3EW1C1LO7jt1D4JbpJtbVgRA=
X-Google-Smtp-Source: ABdhPJwz12iTb+zG1EDREi+ibfO4OLS6nmunCF6taJTygfFDtz9t2fFNJG5TmDYp4Fppj1Dyf3gqG6psTDE=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2187:b0:4a7:fedf:8ff9 with SMTP id
 h7-20020a056a00218700b004a7fedf8ff9mr4129022pfi.9.1640298224993; Thu, 23 Dec
 2021 14:23:44 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:22:50 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 02/30] KVM: x86/mmu: Move "invalid" check out of kvm_tdp_mmu_get_root()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Move the check for an invalid root out kvm_tdp_mmu_get_root() and into
the one place it actually matters, tdp_mmu_next_root(), as the other user
already has an implicit validity check.  A future bug fix will need to
get references to invalid roots to honor mmu_notifier requests, there's
no point in forcing what will be a common path to open code getting a
reference to a root.

No functional change intended.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 12 ++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.h |  3 ---
 2 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index d320b56d5cd7..200001190fcf 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -121,9 +121,14 @@ static struct kvm_mmu_page *tdp_mmu_next_root(struct kvm *kvm,
 		next_root = list_first_or_null_rcu(&kvm->arch.tdp_mmu_roots,
 						   typeof(*next_root), link);
 
-	while (next_root && !kvm_tdp_mmu_get_root(kvm, next_root))
+	while (next_root) {
+		if (!next_root->role.invalid &&
+		    kvm_tdp_mmu_get_root(kvm, next_root))
+			break;
+
 		next_root = list_next_or_null_rcu(&kvm->arch.tdp_mmu_roots,
 				&next_root->link, typeof(*next_root), link);
+	}
 
 	rcu_read_unlock();
 
@@ -200,7 +205,10 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu)
 
 	role = page_role_for_level(vcpu, vcpu->arch.mmu->shadow_root_level);
 
-	/* Check for an existing root before allocating a new one. */
+	/*
+	 * Check for an existing root before allocating a new one.  Note, the
+	 * role check prevents consuming an invalid root.
+	 */
 	for_each_tdp_mmu_root(kvm, root, kvm_mmu_role_as_id(role)) {
 		if (root->role.word == role.word &&
 		    kvm_tdp_mmu_get_root(kvm, root))
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 3899004a5d91..08c917511fed 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -10,9 +10,6 @@ hpa_t kvm_tdp_mmu_get_vcpu_root_hpa(struct kvm_vcpu *vcpu);
 __must_check static inline bool kvm_tdp_mmu_get_root(struct kvm *kvm,
 						     struct kvm_mmu_page *root)
 {
-	if (root->role.invalid)
-		return false;
-
 	return refcount_inc_not_zero(&root->tdp_mmu_root_count);
 }
 
-- 
2.34.1.448.ga2b2bfdf31-goog

