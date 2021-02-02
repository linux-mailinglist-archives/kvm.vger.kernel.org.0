Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A754930CAD9
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239311AbhBBTCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:02:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239309AbhBBTA3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:00:29 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FDA0C061224
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 10:58:05 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id o11so11986461pgn.1
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 10:58:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=TvzNxZEmeauTq2Q8+NC26kwWaevzAKsfhvaBGBmdGZw=;
        b=T+DimJrwM2NuQebN6GQIVbIHXPhvE6MCkly0TwLwZfbQAzn865KoEtBuZzk4JO3R1v
         pkgXztB7dyVKmSGuyYfBNMzHE6JbhBjNKjHfFnkxuO/LBRg8BQ4pmpxd0RjE6ZR+jOUw
         OTxW/3s9L2DcmM6t60b5OZZm26CfiQ97p0RLtZIOLom5oz7QW+MKJh3UDiV5P66CfoBH
         end2v+qmW3oic7P1yvm0YYujO6S29t9glJYKRRYHX11iNNEHXG8m8Ij6l5k9EPVd1bj+
         rUA9Yaq3tfSpD2e0a6z1SWatxGFl53QN1fL/D3uATKsvN62XdSxngWdyGsvO2cAeERZs
         UOVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TvzNxZEmeauTq2Q8+NC26kwWaevzAKsfhvaBGBmdGZw=;
        b=XcSrQ0QD5YPa+Krje4kdiqWaNVkRq43twS5EJHC3L9d7GRBJN1DpNWdxtEst1yCTRs
         84I1xnm5nzzR+CLtmhL0m+CuPUUOJrusJYRnW/5qs/LjGoEScFmQa3tDw6AmbLNrJYUd
         ZiCs2VAUZwRwsbd2RwcpyTy2MBIRgCUrZ8cUl5PYgmZJTwqwAuh73lx9jolZ56E7m4IN
         wNvfIpadOpwKCHAzWnPfb6HB2ammLbzf94Dobv5vSwU64AWiyocbSrgy3YieyI0Qwo0S
         sI/B1NoxiGOuKfP/OfY91xwkoncQJgcNuupzgLrjjbYTWPiTfwz5d82sjCva0D4pev2y
         J5jg==
X-Gm-Message-State: AOAM532erHSeSXScVxiO0YZ8p4Q06hOY9PsydhZIrf7oqUuPTEMS77mC
        jTlZFGyNI685pvqtuGRW6VP75NSop25l
X-Google-Smtp-Source: ABdhPJxAoifktld/mM+14GeUwIjNAf6XLVqMicqaxaKI0BFtXVEKCZdf91ZkAToJ7z7NNV1jwuaH7UXFTYdR
Sender: "bgardon via sendgmr" <bgardon@bgardon.sea.corp.google.com>
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:9090:561:5a98:6d47])
 (user=bgardon job=sendgmr) by 2002:a63:703:: with SMTP id 3mr23018613pgh.272.1612292285011;
 Tue, 02 Feb 2021 10:58:05 -0800 (PST)
Date:   Tue,  2 Feb 2021 10:57:21 -0800
In-Reply-To: <20210202185734.1680553-1-bgardon@google.com>
Message-Id: <20210202185734.1680553-16-bgardon@google.com>
Mime-Version: 1.0
References: <20210202185734.1680553-1-bgardon@google.com>
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH v2 15/28] KVM: x86/mmu: Skip no-op changes in TDP MMU functions
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Skip setting SPTEs if no change is expected.

Reviewed-by: Peter Feiner <pfeiner@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>

---

v1 -> v2
- Merged no-op checks into exiting old_spte check

 arch/x86/kvm/mmu/tdp_mmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index c8a1149cb229..aeb05f626b55 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -888,7 +888,8 @@ static bool wrprot_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 			continue;
 
 		if (!is_shadow_present_pte(iter.old_spte) ||
-		    !is_last_spte(iter.old_spte, iter.level))
+		    !is_last_spte(iter.old_spte, iter.level) ||
+		    !(iter.old_spte & PT_WRITABLE_MASK))
 			continue;
 
 		new_spte = iter.old_spte & ~PT_WRITABLE_MASK;
@@ -1065,7 +1066,8 @@ static bool set_dirty_gfn_range(struct kvm *kvm, struct kvm_mmu_page *root,
 		if (tdp_mmu_iter_cond_resched(kvm, &iter, false))
 			continue;
 
-		if (!is_shadow_present_pte(iter.old_spte))
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    iter.old_spte & shadow_dirty_mask)
 			continue;
 
 		new_spte = iter.old_spte | shadow_dirty_mask;
-- 
2.30.0.365.g02bc693789-goog

