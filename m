Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1643944CCCA
	for <lists+kvm@lfdr.de>; Wed, 10 Nov 2021 23:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbhKJWdo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 17:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233911AbhKJWdh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 17:33:37 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC132C061766
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:48 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id y124-20020a623282000000b0047a09271e49so2701303pfy.16
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 14:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HnZqtlOQ63wNQv89kCvwlZXyDDrYIYxEA2ngT/q/LPk=;
        b=SiP3qz5fosLZDiKoqRIEqpSSPNPujrrnDHdmqmki+XBhmlrA6Mo4LFT21Wyh7HNGh2
         KYjigbtNUZ0oEpp+En0Cw1iizfZ+tw5zJYqIEbK01Ok0TVIPHG7d1637lXz0wzi5WjQ1
         aEcbY4qEfUn8BgV2LSmQvJOZFalNxMhlRmvuIZCE43c8q9ml0wnw9KEVa+znQBpmOgcW
         MQa48NfdHZii4bky+VlPw6YQ05geOw7UVVdyKz6RZjwvvW56eVIAaA+A2dlYu25CzTCw
         l52ERhDGsxK/AOe5HJaHBAnoprA0MwvtV6aJ8GMbD3u6YND+tlDgtb4xkHS6i+FP8YMp
         7lwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HnZqtlOQ63wNQv89kCvwlZXyDDrYIYxEA2ngT/q/LPk=;
        b=NSzAjeTFETNLw/p6/f/ZPnG2isk8SNpWcqd7YxTpPKBUwZwqEhelNDnRSuS+Qez+R9
         8NhGZaPAF/4j74QLv5/nPdeRXMp2o/LOghWlFYV00A1TfF2CBQ4Mtq4WUMFOgC9OmE3L
         85mfjL274HfX+x5W+XK8XvMx+OAlvQe0OHMrUkpIEsOUTNs7t3Ib5mDH75Vy/F0zCl/C
         1dpg2AFKPv9kRzAenvykAC0ntiaAchcRT6rxQ3iTGuEvKUKcRt41tbg+6Mf+H7Ot+LLe
         VlCc81+yaNHPcwhKouARDVa9fA8okBD/VWY9EnAIBeFkHv4+tLny+81WnRsbShRC5KJM
         PLRQ==
X-Gm-Message-State: AOAM531Zwr0tf5piUjI7GWKhsDwErUVoZ5dDRHl0NNA1RXUteAIHlO43
        wNwHdh0EoSlgQLBhZd7ABtPbfcsNVIU0
X-Google-Smtp-Source: ABdhPJxZRHSUHtHsNtP0gv5OKCFs+Ww73ld1gIG8wmXR7CC0f7LvNYe4mKbiCbH6Z+LjVmW5vyN6rKt9gvzi
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6586:7b2f:b259:2011])
 (user=bgardon job=sendgmr) by 2002:a17:902:c202:b0:142:2441:aa25 with SMTP id
 2-20020a170902c20200b001422441aa25mr2672775pll.68.1636583448361; Wed, 10 Nov
 2021 14:30:48 -0800 (PST)
Date:   Wed, 10 Nov 2021 14:30:00 -0800
In-Reply-To: <20211110223010.1392399-1-bgardon@google.com>
Message-Id: <20211110223010.1392399-10-bgardon@google.com>
Mime-Version: 1.0
References: <20211110223010.1392399-1-bgardon@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [RFC 09/19] KVM: x86/mmu: Remove need for a vcpu from kvm_slot_page_track_is_active
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
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

kvm_slot_page_track_is_active only uses its vCPU argument to get a
pointer to the assoicated struct kvm, so just pass in the struct KVM to
remove the need for a vCPU pointer.

No functional change intended.


Signed-off-by: Ben Gardon <bgardon@google.com>
---
 arch/x86/include/asm/kvm_page_track.h | 2 +-
 arch/x86/kvm/mmu/mmu.c                | 4 ++--
 arch/x86/kvm/mmu/page_track.c         | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/kvm_page_track.h b/arch/x86/include/asm/kvm_page_track.h
index 9d4a3b1b25b9..e99a30a4d38b 100644
--- a/arch/x86/include/asm/kvm_page_track.h
+++ b/arch/x86/include/asm/kvm_page_track.h
@@ -63,7 +63,7 @@ void kvm_slot_page_track_add_page(struct kvm *kvm,
 void kvm_slot_page_track_remove_page(struct kvm *kvm,
 				     struct kvm_memory_slot *slot, gfn_t gfn,
 				     enum kvm_page_track_mode mode);
-bool kvm_slot_page_track_is_active(struct kvm_vcpu *vcpu,
+bool kvm_slot_page_track_is_active(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   enum kvm_page_track_mode mode);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2ada6dee920a..7d0da79668c0 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2587,7 +2587,7 @@ int mmu_try_to_unsync_pages(struct kvm_vcpu *vcpu, struct kvm_memory_slot *slot,
 	 * track machinery is used to write-protect upper-level shadow pages,
 	 * i.e. this guards the role.level == 4K assertion below!
 	 */
-	if (kvm_slot_page_track_is_active(vcpu, slot, gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(vcpu->kvm, slot, gfn, KVM_PAGE_TRACK_WRITE))
 		return -EPERM;
 
 	/*
@@ -3884,7 +3884,7 @@ static bool page_fault_handle_page_track(struct kvm_vcpu *vcpu,
 	 * guest is writing the page which is write tracked which can
 	 * not be fixed by page fault handler.
 	 */
-	if (kvm_slot_page_track_is_active(vcpu, fault->slot, fault->gfn, KVM_PAGE_TRACK_WRITE))
+	if (kvm_slot_page_track_is_active(vcpu->kvm, fault->slot, fault->gfn, KVM_PAGE_TRACK_WRITE))
 		return true;
 
 	return false;
diff --git a/arch/x86/kvm/mmu/page_track.c b/arch/x86/kvm/mmu/page_track.c
index cc4eb5b7fb76..35c221d5f6ce 100644
--- a/arch/x86/kvm/mmu/page_track.c
+++ b/arch/x86/kvm/mmu/page_track.c
@@ -173,7 +173,7 @@ EXPORT_SYMBOL_GPL(kvm_slot_page_track_remove_page);
 /*
  * check if the corresponding access on the specified guest page is tracked.
  */
-bool kvm_slot_page_track_is_active(struct kvm_vcpu *vcpu,
+bool kvm_slot_page_track_is_active(struct kvm *kvm,
 				   struct kvm_memory_slot *slot, gfn_t gfn,
 				   enum kvm_page_track_mode mode)
 {
@@ -186,7 +186,7 @@ bool kvm_slot_page_track_is_active(struct kvm_vcpu *vcpu,
 		return false;
 
 	if (mode == KVM_PAGE_TRACK_WRITE &&
-	    !kvm_page_track_write_tracking_enabled(vcpu->kvm))
+	    !kvm_page_track_write_tracking_enabled(kvm))
 		return false;
 
 	index = gfn_to_index(gfn, slot->base_gfn, PG_LEVEL_4K);
-- 
2.34.0.rc0.344.g81b53c2807-goog

