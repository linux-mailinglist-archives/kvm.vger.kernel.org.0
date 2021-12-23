Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A2247E97B
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 23:27:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350526AbhLWW0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 17:26:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350514AbhLWWZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Dec 2021 17:25:49 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94846C061D72
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:24 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id o9-20020a637309000000b0033fba59a89dso3877443pgc.17
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 14:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=VKRhc2W30aJ+XXbCyNQ1ulY913smbN678/b9erLTCZg=;
        b=TraPH2v75kx8IbE8VZzkiytfqpmKpo7bA6i3wHFNH8kWiJsWoKxjs5qifY9XeUUgX2
         tq7skiqLI75wwsk+cjIoklE8kfO4Q026KdxSxhwOPCtGvLtOhmEwScoigtyX1CHem8so
         zkagxCu8O7dAfUgZFPfJkFwQSPFdHLQ1V2UtzGQHphYQQNHGEZllckQfQUX7cmuix4h2
         nfcB7Hrux6pUuz9oXT0nkK1872SuYu0vCiaN3hkcW7oo3lT3LOG6nAbpjSDrgIL5zhwj
         LNRA0yctE8lTsttvPbZFQKIEkvpm5A9lSF7rYmq4mQ+6kupPT8W6/HfKU/DtISQgrr8F
         G76Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=VKRhc2W30aJ+XXbCyNQ1ulY913smbN678/b9erLTCZg=;
        b=xZmWJ2gpARyrNP27spEvnunPrlVMPjIs8sxkBN6rQ0muWk/Q+Ypcrp1c7sJOgbcxoR
         xhW4FGy+u2+uUMGVaR89kM433ciuMrSrj7/0CUeiSQ7Eq64i62AI+ELvZ67AGX6PhGbs
         rzm2bdMkftcdpR2oQhAymAY+GybvWdO6VjVkQJzmiQt3kh7ybt4OTOQEA8fHW2hPUoub
         QG3/OJrGJbrK4BtEaK4gn6rdSpttEPen+FVEdawZvVVfpD6jiZ4sJKqe8BrFWaYAaoLU
         65vdzzFRC1Yv/Ff3nNoFpPbTADRduhmt3/M7zvPk3cCisS/kca/RDIX44+mZ0Z5COu+7
         vKgA==
X-Gm-Message-State: AOAM5321uMskWvJuC09e2lWOQU+IcHP9xln7rGH+ftnhdesst8qdko6k
        ShKGtPj/1FRN9hkV0uVpeti1HaaWRzg=
X-Google-Smtp-Source: ABdhPJwddrNiJwRWA7gbWwHjC4Wsxlj0igcrrMuVa5jSNsVjb5YY/gIuu5OqR0d5fzyshMBMmcf917Kvr00=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:db0c:: with SMTP id
 g12mr5043010pjv.233.1640298264139; Thu, 23 Dec 2021 14:24:24 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 23 Dec 2021 22:23:14 +0000
In-Reply-To: <20211223222318.1039223-1-seanjc@google.com>
Message-Id: <20211223222318.1039223-27-seanjc@google.com>
Mime-Version: 1.0
References: <20211223222318.1039223-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
Subject: [PATCH v2 26/30] KVM: x86/mmu: Zap defunct roots via asynchronous worker
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

Zap defunct roots, a.k.a. roots that have been invalidated after their
last reference was initially dropped, asynchronously via the system work
queue instead of forcing the work upon the unfortunate task that happened
to drop the last reference.

If a vCPU task drops the last reference, the vCPU is effectively blocked
by the host for the entire duration of the zap.  If the root being zapped
happens be fully populated with 4kb leaf SPTEs, e.g. due to dirty logging
being active, the zap can take several hundred seconds.  Unsurprisingly,
most guests are unhappy if a vCPU disappears for hundreds of seconds.

E.g. running a synthetic selftest that triggers a vCPU root zap with
~64tb of guest memory and 4kb SPTEs blocks the vCPU for 900+ seconds.
Offloading the zap to a worker drops the block time to <100ms.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu_internal.h |  2 +
 arch/x86/kvm/mmu/tdp_mmu.c      | 65 ++++++++++++++++++++++++++++-----
 2 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 8ce3d58fdf7f..ac365631e4fe 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -69,6 +69,8 @@ struct kvm_mmu_page {
 		DECLARE_BITMAP(unsync_child_bitmap, 512);
 		struct {
 			bool tdp_mmu_defunct_root;
+			struct work_struct tdp_mmu_async_work;
+			void *tdp_mmu_async_data;
 		};
 	};
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2e28f5e4b761..a706328a5658 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -81,6 +81,38 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 static void tdp_mmu_zap_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			     bool shared);
 
+static void tdp_mmu_zap_root_async(struct work_struct *work)
+{
+	struct kvm_mmu_page *root = container_of(work, struct kvm_mmu_page,
+						 tdp_mmu_async_work);
+	struct kvm *kvm = root->tdp_mmu_async_data;
+
+	read_lock(&kvm->mmu_lock);
+
+	/*
+	 * A TLB flush is not necessary as KVM performs a local TLB flush when
+	 * allocating a new root (see kvm_mmu_load()), and when migrating vCPU
+	 * to a different pCPU.  Note, the local TLB flush on reuse also
+	 * invalidates any paging-structure-cache entries, i.e. TLB entries for
+	 * intermediate paging structures, that may be zapped, as such entries
+	 * are associated with the ASID on both VMX and SVM.
+	 */
+	tdp_mmu_zap_root(kvm, root, true);
+
+	/*
+	 * Drop the refcount using kvm_tdp_mmu_put_root() to test its logic for
+	 * avoiding an infinite loop.  By design, the root is reachable while
+	 * it's being asynchronously zapped, thus a different task can put its
+	 * last reference, i.e. flowing through kvm_tdp_mmu_put_root() for an
+	 * asynchronously zapped root is unavoidable.
+	 */
+	kvm_tdp_mmu_put_root(kvm, root, true);
+
+	read_unlock(&kvm->mmu_lock);
+
+	kvm_put_kvm(kvm);
+}
+
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared)
 {
@@ -143,15 +175,26 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	refcount_set(&root->tdp_mmu_root_count, 1);
 
 	/*
-	 * Zap the root, then put the refcount "acquired" above.   Recursively
-	 * call kvm_tdp_mmu_put_root() to test the above logic for avoiding an
-	 * infinite loop by freeing invalid roots.  By design, the root is
-	 * reachable while it's being zapped, thus a different task can put its
-	 * last reference, i.e. flowing through kvm_tdp_mmu_put_root() for a
-	 * defunct root is unavoidable.
+	 * Attempt to acquire a reference to KVM itself.  If KVM is alive, then
+	 * zap the root asynchronously in a worker, otherwise it must be zapped
+	 * directly here.  Wait to do this check until after the refcount is
+	 * reset so that tdp_mmu_zap_root() can safely yield.
+	 *
+	 * In both flows, zap the root, then put the refcount "acquired" above.
+	 * When putting the reference, use kvm_tdp_mmu_put_root() to test the
+	 * above logic for avoiding an infinite loop by freeing invalid roots.
+	 * By design, the root is reachable while it's being zapped, thus a
+	 * different task can put its last reference, i.e. flowing through
+	 * kvm_tdp_mmu_put_root() for a defunct root is unavoidable.
 	 */
-	tdp_mmu_zap_root(kvm, root, shared);
-	kvm_tdp_mmu_put_root(kvm, root, shared);
+	if (kvm_get_kvm_safe(kvm)) {
+		root->tdp_mmu_async_data = kvm;
+		INIT_WORK(&root->tdp_mmu_async_work, tdp_mmu_zap_root_async);
+		schedule_work(&root->tdp_mmu_async_work);
+	} else {
+		tdp_mmu_zap_root(kvm, root, shared);
+		kvm_tdp_mmu_put_root(kvm, root, shared);
+	}
 }
 
 enum tdp_mmu_roots_iter_type {
@@ -949,7 +992,11 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 
 	/*
 	 * Zap all roots, including defunct roots, as all SPTEs must be dropped
-	 * before returning to the caller.
+	 * before returning to the caller.  Zap directly even if the root is
+	 * also being zapped by a worker.  Walking zapped top-level SPTEs isn't
+	 * all that expensive and mmu_lock is already held, which means the
+	 * worker has yielded, i.e. flushing the work instead of zapping here
+	 * isn't guaranteed to be any faster.
 	 *
 	 * A TLB flush is unnecessary, KVM zaps everything if and only the VM
 	 * is being destroyed or the userspace VMM has exited.  In both cases,
-- 
2.34.1.448.ga2b2bfdf31-goog

