Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F20F767B3C
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbjG2BiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:38:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237698AbjG2Bhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:37:55 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAA849F4
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:37:20 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-55c475c6da6so1696385a12.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690594591; x=1691199391;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=Cv+DsoDLVKC7M6FclOb2McPWSddb97LBT0B8H7opNaY=;
        b=T6dKn0Eqxyz2hq1pOTYEfIvzKdLREMUo3Eg9TGB/irJNqcwSL7N1U8s/qojB7Pomtd
         HajhioTnMF465M8X+PS/k6ettCzrCZomyoVuYFcv0Nz/JHAeLUu/JPrCRJs3IRY4Y3P+
         eY9C/JWu5kka2BzL4yTJsR+VP98afzcS2VbBYuLg7mbrhHcmSMJx1oQVVjfUUM65NxJw
         Mvmqplu8i0P/4ILWu1S78NWKp6Vz9QSIw7BZHTBZ/agXrwenZ/YSKCT1i4aZb6EvG3Tk
         CZIs+U82m251j7gMDbv/bLGUnBY17cIc3FNda3lpZHZWXsEku3CBzTn6AiLAuJCQM8Ro
         L+gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690594591; x=1691199391;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cv+DsoDLVKC7M6FclOb2McPWSddb97LBT0B8H7opNaY=;
        b=RD4GkLjoLBBuQIbn6SHW4UvR6nnYUq51rcZFUuVFkLoFBOqfOU2qUg6gnjfyfGnsVp
         O7HVhSOxRDnQoJDm/X8z4bfWF3vhFyvwuymSCLLEgFF5TkSvip/nQ6Ws0Qpr6uvB8YdL
         fomS8JvagRnbcFe+gEMZvs6Ub8giDUI32nRxWoy2xGTeZYeu14zjBl/h25U/qDpX2jXa
         5m6EFgMpF7YT3SVQdOKupDSEmc5yHJX3tc+jWDpxd1rnjaa7w6BDBTWRFVpPVRvINn/s
         OePIu9a+svkMwi6Uf9BxAHi1jBKVXgNAuZcpeBkVNTF1nsGs7Awg+dSl2vRRXh5iY9Hz
         nEiQ==
X-Gm-Message-State: ABy/qLZd/ZK4vuDHTJMWxJ/I4UiNIduxMLmEM2/dvS99ID+G6Nwrtqf9
        iW3JljHfhvD+wGstjO48Z79mIdmsJ1c=
X-Google-Smtp-Source: APBJJlHqtoyrZzkA1RBEZPijpbgeZu0MncV0t8E8AkPf499XEff/G9cn4OJ6eavuvETRp4yMIx/pcoD/6Lk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:d489:b0:1bb:83ec:841 with SMTP id
 c9-20020a170902d48900b001bb83ec0841mr12572plg.6.1690594591600; Fri, 28 Jul
 2023 18:36:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:35:31 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729013535.1070024-26-seanjc@google.com>
Subject: [PATCH v4 25/29] KVM: x86/mmu: Assert that correct locks are held for
 page write-tracking
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Yongwei Ma <yongwei.ma@intel.com>,
        Ben Gardon <bgardon@google.com>
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

When adding/removing gfns to/from write-tracking, assert that mmu_lock
is held for write, and that either slots_lock or kvm->srcu is held.
mmu_lock must be held for write to protect gfn_write_track's refcount,
and SRCU or slots_lock must be held to protect the memslot itself.

Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/page_track.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index b835ba7f325c..29ae61f1e303 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -12,6 +12,7 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/lockdep.h>
 #include <linux/kvm_host.h>
 #include <linux/rculist.h>
 
@@ -77,9 +78,6 @@ static void update_gfn_write_track(struct kvm_memory_slot *slot, gfn_t gfn,
  * add guest page to the tracking pool so that corresponding access on that
  * page will be intercepted.
  *
- * It should be called under the protection both of mmu-lock and kvm->srcu
- * or kvm->slots_lock.
- *
  * @kvm: the guest instance we are interested in.
  * @slot: the @gfn belongs to.
  * @gfn: the guest page.
@@ -87,6 +85,11 @@ static void update_gfn_write_track(struct kvm_memory_slot *slot, gfn_t gfn,
 void kvm_write_track_add_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 			     gfn_t gfn)
 {
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	lockdep_assert_once(lockdep_is_held(&kvm->slots_lock) ||
+			    srcu_read_lock_held(&kvm->srcu));
+
 	if (WARN_ON(!kvm_page_track_write_tracking_enabled(kvm)))
 		return;
 
@@ -107,9 +110,6 @@ EXPORT_SYMBOL_GPL(kvm_write_track_add_gfn);
  * remove the guest page from the tracking pool which stops the interception
  * of corresponding access on that page.
  *
- * It should be called under the protection both of mmu-lock and kvm->srcu
- * or kvm->slots_lock.
- *
  * @kvm: the guest instance we are interested in.
  * @slot: the @gfn belongs to.
  * @gfn: the guest page.
@@ -117,6 +117,11 @@ EXPORT_SYMBOL_GPL(kvm_write_track_add_gfn);
 void kvm_write_track_remove_gfn(struct kvm *kvm,
 				struct kvm_memory_slot *slot, gfn_t gfn)
 {
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	lockdep_assert_once(lockdep_is_held(&kvm->slots_lock) ||
+			    srcu_read_lock_held(&kvm->srcu));
+
 	if (WARN_ON(!kvm_page_track_write_tracking_enabled(kvm)))
 		return;
 
-- 
2.41.0.487.g6d72f3e995-goog

