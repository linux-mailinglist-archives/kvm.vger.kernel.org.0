Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEE9B31A908
	for <lists+kvm@lfdr.de>; Sat, 13 Feb 2021 01:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbhBMAwd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Feb 2021 19:52:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232307AbhBMAwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Feb 2021 19:52:14 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBA63C061222
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:45 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id u17so1553132ybi.10
        for <kvm@vger.kernel.org>; Fri, 12 Feb 2021 16:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5iYKiaJj9dDMogv04/M2zPHef+mxHxjSzdzarzVZBMA=;
        b=KhzN85JTB4LyOGgVmIAOxAsftbf/3k1ZB1SASfN+AvgZoI/b1RjJJFqg0IbhJ0/cFW
         7UJeBWp+VvM8iczpzTL3dyqZNM6+ZudU1tEG86mnIw3xcDzxIqNWcatHxE143iXzgOIP
         WndlzEM7NTni7SVoomPCsq2498tc7s62Z1svZSLgyJiHyOu0rapwvPXgScNQgwYCrbI8
         iLKVI2Ss8sHMdU6N+lVosYXD0AQbnHLjuUQOMLL1ZFo71o55zWdlRgwpfsk2NMlHN+4s
         9MvkMl2nTc8Hvi4DkIHAaXrDO2KLGiQ6opbvPZ3493dnNxOjwHZ/gnX2JHHzSZYxzATA
         t3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5iYKiaJj9dDMogv04/M2zPHef+mxHxjSzdzarzVZBMA=;
        b=p/UhEzghakQorqP7RlMmn+i3mI+Gzm02nV7o5jV4PyO8pZcjV/+zlNnC8VbAI7B4oN
         isP67I0RMnekt7Tmtt0sEG1ofPbFgTA3sxYKq2ySZMcuPI7+NhAXt0PoeNT3oUYHbGp+
         KrWM/tUXE1kSLG3XaoEp6FraY2sHA2q1SrYRRnAz5/TkW+j5AcOdow3YXAyrX+pzflBw
         V2SI5FeQqoomejbkwigTTT93GQgnmTVk0QzKHoiyWYlbgA4M/j6llXu/kArgerDJNMZ3
         t+sHIiD1pqdqieubdpdmhWqZ4M/6XBdWbZIfWDETzbgj3TxZl2N/HVcJ+jm0lhQftQcT
         rraQ==
X-Gm-Message-State: AOAM532NG+pKT5FoMMN8MJJALjuRnXaRx5F0/A/0rxqc4pxmoq/yL+jc
        eSXUOGcnvEqLJDpbk9/O1/zlCDu4gbU=
X-Google-Smtp-Source: ABdhPJyF5LeQQ9Cl9wea1QgnVNkw9hArbt+rlKxJm5d2zLnjlmnkopI6K8sIbrRa4Bb4y0OkwUZemlDZgpQ=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b407:1780:13d2:b27])
 (user=seanjc job=sendgmr) by 2002:a25:4252:: with SMTP id p79mr7480566yba.492.1613177445027;
 Fri, 12 Feb 2021 16:50:45 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 Feb 2021 16:50:11 -0800
In-Reply-To: <20210213005015.1651772-1-seanjc@google.com>
Message-Id: <20210213005015.1651772-11-seanjc@google.com>
Mime-Version: 1.0
References: <20210213005015.1651772-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH 10/14] KVM: x86: Further clarify the logic and comments for
 toggling log dirty
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a sanity check in kvm_mmu_slot_apply_flags to assert that the
LOG_DIRTY_PAGES flag is indeed being toggled, and explicitly rely on
that holding true when zapping collapsible SPTEs.  Manipulating the
CPU dirty log (PML) and write-protection also relies on this assertion,
but that's not obvious in the current code.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e89fe98a0099..c0d22f19aed0 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10761,12 +10761,20 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 				     enum kvm_mr_change change)
 {
 	/*
-	 * Nothing to do for RO slots or CREATE/MOVE/DELETE of a slot.
-	 * See comments below.
+	 * Nothing to do for RO slots (which can't be dirtied and can't be made
+	 * writable) or CREATE/MOVE/DELETE of a slot.  See comments below.
 	 */
 	if ((change != KVM_MR_FLAGS_ONLY) || (new->flags & KVM_MEM_READONLY))
 		return;
 
+	/*
+	 * READONLY and non-flags changes were filtered out above, and the only
+	 * other flag is LOG_DIRTY_PAGES, i.e. something is wrong if dirty
+	 * logging isn't being toggled on or off.
+	 */
+	if (WARN_ON_ONCE(!((old->flags ^ new->flags) & KVM_MEM_LOG_DIRTY_PAGES)))
+		return;
+
 	/*
 	 * Dirty logging tracks sptes in 4k granularity, meaning that large
 	 * sptes have to be split.  If live migration is successful, the guest
@@ -10784,8 +10792,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
 	 * MOVE/DELETE: The old mappings will already have been cleaned up by
 	 *		kvm_arch_flush_shadow_memslot()
 	 */
-	if ((old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
-	    !(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
+	if (!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
 		kvm_mmu_zap_collapsible_sptes(kvm, new);
 
 	/*
-- 
2.30.0.478.g8a0d178c01-goog

