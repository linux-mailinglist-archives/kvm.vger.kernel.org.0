Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF18457B8D
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237661AbhKTEzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236578AbhKTEyn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:43 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F712C06179C
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:10 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id y6-20020a17090322c600b001428ab3f888so5706834plg.8
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=3YA6l+nCWDobMPdwMK0h4ZN/J+oTuGq2DHmloikAhG4=;
        b=OT2ThxPI0Z+DmHbtqeAbhdVF5XfOWjPZhjJ7VgLpSyx54RZ6RaCRqT33imBho+6uVA
         2vhJdEuWK5SWg+ykQyXb4kr6gcymWsPO2qzs6OknhfsHMzyBBHC9lawd/Sj8WVBK1on3
         ZhR+NQlJj3doYgYIlZQAOsPWH56o5h/XirCxBG+i4kqTNh+3lcw1gLh+AhELnh97ZthC
         f1QKcS6t+D7BRbtUhAy8A/P0tJ0TkV+XmMj1oYUxd7wETacnSxOIU3TeCey/RDXCuXcc
         z1AvQwDfamppoyX+Az7bTOrMBOb6M1X8jWz9OskFyZlI0gCkDRZD2tnGOgvt8nKDZyvW
         2gew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=3YA6l+nCWDobMPdwMK0h4ZN/J+oTuGq2DHmloikAhG4=;
        b=FxJZIe63bfW+T4XgTNsBZy5djy/qSJJPWLqtAMBybZqam045RbUWY7nkIQsCHn4gcs
         PX4ESuRZEKcQB6V/F0DhnUReB6C/fW0ZUvyFkojA3XR6XQYfLJe/n3xiEYJi9KwPwBZ9
         909/1zgx608ItKLyfsmXfWBQczjb65KrY+kNeidny9ODflnE7n7Y7S4MYxYpFAHpgTqj
         hgN0fhd7/Vyg6QC/H4Rptzk64QDXBrWm8irR6QJHL+MVMzYptbM1qsj6iB8f9ARN9A1B
         KCLyjzMuSyX+lF3eDapvASSl8AtTqsoQwKheEwESEjkHFidz6pXvUZ+nS2pdcLijCH31
         V4Rw==
X-Gm-Message-State: AOAM533AZAtHO4JUuZLt/tpZ9+FRSLEmS3MIfr8l6BG20YwrVltr6So4
        QjMpooRmWs2YEUgZMZmz1ei6NaePdqk=
X-Google-Smtp-Source: ABdhPJybdVjiF4plk9xbZSXhzzMciJanivTRt10ixVPETWLvjRFOCdlOnjHRBMgAFvzEJd10JBUy4xUan/0=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:1bc5:: with SMTP id
 r5mr6738027pjr.90.1637383869917; Fri, 19 Nov 2021 20:51:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:28 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-11-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 10/28] KVM: x86/mmu: Allow yielding when zapping GFNs for
 defunct TDP MMU root
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Allow yielding when zapping SPTEs for a defunct TDP MMU root.  Yielding
is safe from a TDP perspective, as the root is unreachable.  The only
potential danger is putting a root from a non-preemptible context, and
KVM currently does not do so.

Yield-unfriendly iteration uses for_each_tdp_mmu_root(), which doesn't
take a reference to each root (it requires mmu_lock be held for the
entire duration of the walk).

tdp_mmu_next_root() is used only by the yield-friendly iterator.

kvm_tdp_mmu_zap_invalidated_roots() is explicitly yield friendly.

kvm_mmu_free_roots() => mmu_free_root_page() is a much bigger fan-out,
but is still yield-friendly in all call sites, as all callers can be
traced back to some combination of vcpu_run(), kvm_destroy_vm(), and/or
kvm_create_vm().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 3086c6dc74fb..138c7dc41d2c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -79,6 +79,11 @@ static void tdp_mmu_free_sp_rcu_callback(struct rcu_head *head)
 	tdp_mmu_free_sp(sp);
 }
 
+/*
+ * Note, putting a root might sleep, i.e. the caller must have IRQs enabled and
+ * must not explicitly disable preemption (it will be disabled by virtue of
+ * holding mmu_lock, hence the lack of a might_sleep()).
+ */
 void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 			  bool shared)
 {
@@ -101,7 +106,7 @@ void kvm_tdp_mmu_put_root(struct kvm *kvm, struct kvm_mmu_page *root,
 	 * intermediate paging structures, that may be zapped, as such entries
 	 * are associated with the ASID on both VMX and SVM.
 	 */
-	(void)zap_gfn_range(kvm, root, 0, -1ull, false, false, shared);
+	(void)zap_gfn_range(kvm, root, 0, -1ull, true, false, shared);
 
 	call_rcu(&root->rcu_head, tdp_mmu_free_sp_rcu_callback);
 }
-- 
2.34.0.rc2.393.gf8c9666880-goog

