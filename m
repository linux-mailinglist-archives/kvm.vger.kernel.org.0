Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720096B56B1
	for <lists+kvm@lfdr.de>; Sat, 11 Mar 2023 01:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbjCKAZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 19:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbjCKAY5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 19:24:57 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2760213FF3A
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:24:02 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id cj27-20020a056a00299b00b005f1ef2e4e1aso3582324pfb.6
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 16:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678494229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/BQVuzY+1aniIxFwV3nAIhGW3ZAM3GsrQzHkvtpaNHU=;
        b=Ab0v8YmpDERByolnb028YKVIlfH4MiO7yQrc4RKRFL5GBnbXvna4+5GVmm19EWQOhj
         egIfhucrWh67+17xUMC+0ozgET86EcLL8gnfW3xTY437OsCd7ohRm5I91JQSjbDvGVei
         dxWVJkzKLqqg0c0shd3w8KO9sXN0xg9lUPSDNOCubHZ/a7B1QgL0e+FDanDFF0/DULCS
         LHcCjqWQV6U+85Rp05fZB7kujyhcAXUJtL7t5mdIK0oGB6Qi/WSWx7CHQVZHOz+RwLY5
         rrcbP1RyosYGKPBD9kFA2WvKZVxc6aJmOd7YPCqPh6RRazY0E+Z0WNTZjUfo5H8kFcEs
         IDpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678494229;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/BQVuzY+1aniIxFwV3nAIhGW3ZAM3GsrQzHkvtpaNHU=;
        b=vAH5+49p6gUTTCx8+X5hWAY9vz3qxZBO1udauJ18WDFPLiSZUyV8z61pRb//fkBmim
         jkBhtYNoyepKtrV8a3AykGRVTxXZmnHoSIUMYVf3LL7yjytst2fY7vJZ6dmBAbp7dGd3
         Iy8po/NE/RvCn+E3TRAu2p2xVer8/F2jPgmj5TAigS1CFKIXBEvxNRKJmbe4qZCcqan2
         3RMGuqrCXBfv5hgixXsGQvPPaKmi5XmskXS9vwaUBzylo2Hbth32HbKJOOnON+0vUveJ
         tMFwNH7L3AH56ihq8aI3kWo0OTGu8+asPoLZUOFYp0DvWA6IiB8oxViddm751IeZ+Uw6
         FzGg==
X-Gm-Message-State: AO0yUKV1RFDvrIY99FPIcZJq2ZvCFxlkPWkMi2h28LrcCv+DLhkS6yZ3
        4ooE427n6seryjzg6NBSpAkdhvlm8N8=
X-Google-Smtp-Source: AK7set/WL/vPfDG+0upzro4oNam3+F1L+Ja1Dx0YWA0HV59XxvzT36tQS14IvXsQT0H8w5tlcGKiql7qadE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:716:b0:231:1d90:7b1b with SMTP id
 l22-20020a17090a071600b002311d907b1bmr9612096pjl.2.1678494229325; Fri, 10 Mar
 2023 16:23:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 10 Mar 2023 16:22:54 -0800
In-Reply-To: <20230311002258.852397-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230311002258.852397-1-seanjc@google.com>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230311002258.852397-24-seanjc@google.com>
Subject: [PATCH v2 23/27] KVM: x86/mmu: Assert that correct locks are held for
 page write-tracking
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>
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

When adding/removing gfns to/from write-tracking, assert that mmu_lock
is held for write, and that either slots_lock or kvm->srcu is held.
mmu_lock must be held for write to protect gfn_write_track's refcount,
and SRCU or slots_lock must be held to protect the memslot itself.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/page_track.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 1993db4578e5..ffcd7ac66f9e 100644
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
2.40.0.rc1.284.g88254d51c5-goog

