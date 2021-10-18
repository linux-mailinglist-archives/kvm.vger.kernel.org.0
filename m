Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9283943255B
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 19:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhJRRuC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 13:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbhJRRuB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Oct 2021 13:50:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0A1C06161C
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 10:47:50 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id z2-20020a254c02000000b005b68ef4fe24so21062814yba.11
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 10:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=LN2EW+FhOlDvvJE1i+15ukAh6MV3kz59tJtfZvheISw=;
        b=P//bfECtGnObbuw6zX5TJ5vV6NgxChc/T8P1QSduaEccD8/wOMZ8IgAHXuN8lehU1P
         xxlc4ToHC2sMO5pvs9SnWgfkiR+iwRiAJqCqC/1jyRQ5IRmESvvx6CwkalARpbKKH5yB
         7UviaXASE7kIDLXnUJ4F2RyBlYPK4bg0aeDQLediUYRQMgd6llLesWXAUxURcgA9oSIm
         xvPLIhHNgmF7kO4VRQmKOVs6rHFZUKYpELNa7hGwLQTBAJEUocLV8OtUpTIthrHKIMZQ
         wqMmyPcwoADrDfmmAsRMDCWTQ6AWrbfxcSvEsQ7zRLjP3THlavxqzRF1c0IsussgfQ1p
         RsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=LN2EW+FhOlDvvJE1i+15ukAh6MV3kz59tJtfZvheISw=;
        b=MWgka6+jl3zDnRZgW1Ao2IXNPtFLqGegaPf5GRL2CCxq1wBqe1QalHlp0ajmAZSepn
         PFe2Fl9fIsD64iaFLoBbupWjK2lZhDYu29xcvNo9TZ1eGXQ8GYN8vOLdlVLSGLurNiCE
         D4lPOYrR0JfAd+qhuesKcbZXwmPs62IkfqSAmNs88P/2UwNqGGvx1ZOvlUbsRePXfDsR
         HoiPTwEZuNweH5yh9YtZDbhHHYlLqsTGP620tDvHE41lmti+Dek8HPaQx4TMFpee+bdi
         G2nD88kErQxs5EvrFSmYLOUun9cq9FnEne/Xd9z2FN9GTyUmURJg8q4/5TpBb915K75g
         VVJQ==
X-Gm-Message-State: AOAM533aYt7uGkXdKCLp5Yzp5Y3BmmCoSsYTxQ2Jrz03Yn8ohvn0+DNP
        WKDdIQlH4FFIoJ5UE5IracE++ENeyOc=
X-Google-Smtp-Source: ABdhPJzE9kQckf1f+m6DkSbM+uy7v8ClcF9chJD1YhFw5CAxP2MFgXknFz/pitXnwQV7h6AVmx8uNUWk+44=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:ae71:c4e5:5609:3546])
 (user=seanjc job=sendgmr) by 2002:a25:408f:: with SMTP id n137mr32148992yba.10.1634579269421;
 Mon, 18 Oct 2021 10:47:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon, 18 Oct 2021 10:47:46 -0700
Message-Id: <20211018174746.890616-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH] KVM: x86/mmu: Set "shadow_root_alloced" accordingly when TDP
 is disabled
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Explicitly check kvm_shadow_root_alloced() when short-circuiting shadow
paging metadata allocations and skip setting "shadow_root_alloced" if and
only if its already true, i.e. set it when short-circuiting because TDP is
disabled.  This fixes a benign bug where KVM would always take
slots_arch_lock when allocating a shadow root due to "shadow_root_alloced"
never being set.

Opportunistically add comments to call out that not freeing successful
allocations on failure is intentional, and that freeing on failure isn't
straightforward so as to discourage incorrect cleanups in the future.

Fixes: 73f122c4f06f ("KVM: cleanup allocation of rmaps and page tracking data")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

Essentially code review for "KVM: cleanup allocation of rmaps and page
tracking data", which AFAICT didn't get posted (because it came in via a
a merge?).

 arch/x86/kvm/mmu/mmu.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c6ddb042b281..757e2a1ed149 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3412,21 +3412,30 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 
 	mutex_lock(&kvm->slots_arch_lock);
 
+	/* Recheck, under the lock, whether this is the first shadow root. */
+	if (kvm_shadow_root_alloced(kvm))
+		goto out_unlock;
+
 	/*
-	 * Check if anything actually needs to be allocated. This also
-	 * rechecks whether this is the first shadow root under the lock.
+	 * Check if anything actually needs to be allocated, e.g. all metadata
+	 * will be allocated upfront if TDP is disabled.
 	 */
 	if (kvm_memslots_have_rmaps(kvm) &&
 	    kvm_page_track_write_tracking_enabled(kvm))
-		goto out_unlock;
+		goto out_success;
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
 		slots = __kvm_memslots(kvm, i);
 		kvm_for_each_memslot(slot, slots) {
 			/*
-			 * Both of these functions are no-ops if the target
-			 * is already allocated, so unconditionally calling
-			 * both is safe.
+			 * Both of these functions are no-ops if the target is
+			 * already allocated, so unconditionally calling both
+			 * is safe.  Intentionally do NOT free allocations on
+			 * failure to avoid having to track which allocations
+			 * were made now versus when the memslot was created.
+			 * The metadata is guaranteed to be freed when the slot
+			 * is freed, and will be kept/used if userspace retries
+			 * KVM_RUN instead of killing the VM.
 			 */
 			r = memslot_rmap_alloc(slot, slot->npages);
 			if (r)
@@ -3441,6 +3450,7 @@ static int mmu_first_shadow_root_alloc(struct kvm *kvm)
 	 * Ensure that shadow_root_alloced becomes true strictly after
 	 * all the related pointers are set.
 	 */
+out_success:
 	smp_store_release(&kvm->arch.shadow_root_alloced, true);
 
 out_unlock:
-- 
2.33.0.1079.g6e70778dc9-goog

