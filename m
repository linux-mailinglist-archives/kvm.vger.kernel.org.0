Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF1E4C52A5
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:19:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241023AbiBZASc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241261AbiBZARw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:17:52 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AB9322D66E
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:47 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id j10-20020a17090a7e8a00b001bbef243093so6486396pjl.1
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:16:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=MilK8zUZX7tWJl2GgjJY8oNeKvoyoiy4aBCti+o2Dno=;
        b=azOeWuW+lWy8w8HIL49LW9KhszQbW+YNWD8IHPgIc79FX9F9n3TXODYKi2HAmjESdo
         HOXPis4YQybgWPgSa31snGdX4dlIAVkB9Yva2qwEEiqK/z6DI1r5iw8PVKGyV8sZFp26
         NKY9hJKEKL7NHbwOIm4FOe+6io3nDecTa17lwWjUGSyRR08BEvTKr9V1c2u071oaOFZD
         bC+F2p0SAaU18Xfrju7A1ThpQzKfyc7V0pHszBilaXsXz+TjfNJ1ZPCi7/KX24B4qLX4
         v6o/Zqfmx6jE5Ve7LSoUfC4V2CUgRoY05MqIfyWwuNZzJn1fAx39O7gmmUpXmE+sUR+h
         8GNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=MilK8zUZX7tWJl2GgjJY8oNeKvoyoiy4aBCti+o2Dno=;
        b=3RmpNa23gjcp3Gn0EedVTg5irltowhTFHfbteSIoUsW+vfEI64FZrk+awqq5/SF6k8
         K1dORsboOHk0wer9X7jhNe4PwJcF3M4JC73FRMS6Hq2ZffT8JE13CGYTEpGNnB2SfZj9
         PuqOJHE8k/voN9cO6ZX/xRsmTtGC9Ek3pTDrG6LDegzYVCdtWLjIqy8Tbp59REPFiozT
         186TnSuAulUJxm6YXmumQFAMBZFUKJgunrGJB0JTrwqC4deerRuco8Vwz6GeYj7KpCqJ
         m1uRwJlZwYHGZdc3dn/Qulxy+oWrTnezYOuB68/UrUOVjZwA8X9w1VRZxgZOnPNBGPhr
         KTuw==
X-Gm-Message-State: AOAM530q50Z6abKKOxOJWGC0geQJM73uQwcjOKQ9VEbw3ibjst36+f6p
        wDxJA8R81YPIK7gzREKeGQP0u3aLFfU=
X-Google-Smtp-Source: ABdhPJwQC0seS+f5AjDyQB4suBW4N+vPljL91EEY6uoAI/tRdabfBdxDkAHZXw+1PFBpgG1HwP5YTKG451I=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a65:5bcc:0:b0:378:4b73:4fe9 with SMTP id
 o12-20020a655bcc000000b003784b734fe9mr2939194pgr.533.1645834598449; Fri, 25
 Feb 2022 16:16:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 26 Feb 2022 00:15:40 +0000
In-Reply-To: <20220226001546.360188-1-seanjc@google.com>
Message-Id: <20220226001546.360188-23-seanjc@google.com>
Mime-Version: 1.0
References: <20220226001546.360188-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.1.574.g5d30c73bfb-goog
Subject: [PATCH v3 22/28] KVM: x86/mmu: Zap defunct roots via asynchronous worker
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
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
 arch/x86/kvm/mmu/mmu_internal.h |  8 +++-
 arch/x86/kvm/mmu/tdp_mmu.c      | 65 ++++++++++++++++++++++++++++-----
 2 files changed, 63 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index be063b6c91b7..1bff453f7cbe 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -65,7 +65,13 @@ struct kvm_mmu_page {
 		struct kvm_rmap_head parent_ptes; /* rmap pointers to parent sptes */
 		tdp_ptep_t ptep;
 	};
-	DECLARE_BITMAP(unsync_child_bitmap, 512);
+	union {
+		DECLARE_BITMAP(unsync_child_bitmap, 512);
+		struct {
+			struct work_struct tdp_mmu_async_work;
+			void *tdp_mmu_async_data;
+		};
+	};
 
 	struct list_head lpage_disallowed_link;
 #ifdef CONFIG_X86_32
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ec28a88c6376..4151e61245a7 100644
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
@@ -142,15 +174,26 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
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
@@ -954,7 +997,11 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm)
 
 	/*
 	 * Zap all roots, including invalid roots, as all SPTEs must be dropped
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
2.35.1.574.g5d30c73bfb-goog

