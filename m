Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99176767B42
	for <lists+kvm@lfdr.de>; Sat, 29 Jul 2023 03:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237746AbjG2Bim (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 21:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237712AbjG2BiM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 21:38:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E27F3C2F
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:37:28 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-cf4cb742715so2445213276.2
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 18:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690594593; x=1691199393;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=lQFySAI8ixNkwor8unzmA5lNJLwbWRJXY2r7PDxDqgA=;
        b=Vk09KIBuuFUtjM2rE+1nDWmYKQL5pm9DKxQFW0O+5hvfGSmawRS6O256mYyZYndNTj
         UjieXPs0KDQGbAiIJNNsT7QUCDcPUfSEphNC0wiZnfHp9UdPWPprMBTmwOTcCn91kOvJ
         iOIF5MpH8QvTlMjjwZ1wAKaj+csKGy8+L6OmaGzc7GosyiU8zk6dnFL8fT2n9TKG6vMZ
         HFGpzVx1iZvAL/sL6lUMT45dQMCMz4rYo4qZmLNwnqpaD8cpTcsXjjf1uVWbYwFZp3si
         q48A/0mIaRi5XKWBZnzdk6LLSQ+DLl7WR9M9ExoYtj5DSwRegg9lKxzVe8HjRSdgerTT
         mfpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690594593; x=1691199393;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lQFySAI8ixNkwor8unzmA5lNJLwbWRJXY2r7PDxDqgA=;
        b=EUV6E6klZ/PVSYKz5gUgIHVl6EcGyD/YgdIyUQZdAyGejhppjrKAPaTJuvA/sltTbg
         YhAq2ie9XUstT/EhLA6TuN4YTqMrd7Lu77TUO+dYzBSOLaWT+RIZCBVHjBy3a02uu6s1
         F8i5skkHg2IVsUX577Pn5k1oVCen7DlToK+zicizjXYx85cMhQi44yVvML935KVnzODJ
         j8j7T7gn746/6/Bjsx3VEmFX62hU5zPUhsFEQQtY0jyZKlmWTi+iawyzjWd3ewna1Xba
         RKD1sxt7RIQA7McuxpDbTBDHJ9MKTusqqSeBgXGsIlB/RTWBJUNAd3OiBBuQnlQUwyUy
         k4qg==
X-Gm-Message-State: ABy/qLa/rJMGuz2WtnMCylNsXhQ+Vmi9gTTpc3UcibqildaaCLjwfmOp
        KN0qIpQMukRZBmHX01//1Iezl2/rKGM=
X-Google-Smtp-Source: APBJJlFibJWXTKGEP5Hhvqbgc5csEaktnfkVuZvLD3ZY315FF6kCuS5mwmwwc+2rL+l4ooxXzKEqfkJcyy8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3626:0:b0:d0b:4b15:8136 with SMTP id
 d38-20020a253626000000b00d0b4b158136mr16700yba.12.1690594593340; Fri, 28 Jul
 2023 18:36:33 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jul 2023 18:35:32 -0700
In-Reply-To: <20230729013535.1070024-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230729013535.1070024-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.487.g6d72f3e995-goog
Message-ID: <20230729013535.1070024-27-seanjc@google.com>
Subject: [PATCH v4 26/29] KVM: x86/mmu: Bug the VM if write-tracking is used
 but not enabled
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
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Bug the VM if something attempts to write-track a gfn, but write-tracking
isn't enabled.  The VM is doomed (and KVM has an egregious bug) if KVM or
KVMGT wants to shadow guest page tables but can't because write-tracking
isn't enabled.

Tested-by: Yongwei Ma <yongwei.ma@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/page_track.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index 29ae61f1e303..eedb5889d73e 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -90,7 +90,7 @@ void kvm_write_track_add_gfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	lockdep_assert_once(lockdep_is_held(&kvm->slots_lock) ||
 			    srcu_read_lock_held(&kvm->srcu));
 
-	if (WARN_ON(!kvm_page_track_write_tracking_enabled(kvm)))
+	if (KVM_BUG_ON(!kvm_page_track_write_tracking_enabled(kvm), kvm))
 		return;
 
 	update_gfn_write_track(slot, gfn, 1);
@@ -122,7 +122,7 @@ void kvm_write_track_remove_gfn(struct kvm *kvm,
 	lockdep_assert_once(lockdep_is_held(&kvm->slots_lock) ||
 			    srcu_read_lock_held(&kvm->srcu));
 
-	if (WARN_ON(!kvm_page_track_write_tracking_enabled(kvm)))
+	if (KVM_BUG_ON(!kvm_page_track_write_tracking_enabled(kvm), kvm))
 		return;
 
 	update_gfn_write_track(slot, gfn, -1);
-- 
2.41.0.487.g6d72f3e995-goog

