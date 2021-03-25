Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92540349AC8
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 21:02:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhCYUB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 16:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbhCYUB2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 16:01:28 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B13C06174A
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 13:01:27 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l83so7333733ybf.22
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 13:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=yA9J77wXUIWrSXtUENTF1TLxJMmfYoo+ymZDASSQ5I4=;
        b=MUfpIgzNxXqM+9SYZWpE6LQPiit96Qt4CxHII71lm7AHRdta5iBZ4CpMhZuZGxc+2a
         KcvmlOyfNizGtIW/5rjBPtJP1SWQEyisDUsGvOo3KaaYoU2CGFd/5bygbuJK9rZdgDqj
         75QrH6z2ibfmCZkdx73FYWt/lqw8m1e29FK0SnNW4aNuJp57ix3+CnLRCUpviZxObu9K
         ioI7iRONBnG5gfe8I/I2RICMmjO3b7ZZhXLuRZks7prrhKoE9WDbapxHtJVlhQhe3szS
         2L6NBfXd+Uu82huRC1HenqefOn1w81LNGBefeeX3UnOCpWEtHVmG9z4ileaD+kh0EILo
         x7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=yA9J77wXUIWrSXtUENTF1TLxJMmfYoo+ymZDASSQ5I4=;
        b=iYKZCdukbl7sXinQTwKAA/6sLxEurRkoX6c8j3ZhaXWLPThnyjKUz9w4lfNV+m8i6v
         5Kzh50E7RSSkBAX/+iZPY40RkwJa4XMryJCdmZhCQJIrPkeOskARmaSusu85K4S5Hd2z
         Y4nolZzY5xpV5bycX5elsMbnyc4E3ckNalwFbm0nqkaKzd8dHKgFJwqqX3HRNNaCpTGc
         p/7spV2iHl2K3dT71n81HUKgn0jXyhmcDTXhO1UfIxEkHChjK+qEYn/Wzrdh+7OsEEA+
         oBTRpyLrmlr5hDZszu7T875/vDWMjXmXKD6+Jim93PWvA0Ck1iYm8Ed+veKYcPRvN2DV
         9yCA==
X-Gm-Message-State: AOAM530nUaao5ZOFJkT/dxPUSeENoIybsQpbgKXNVQQI+6LU2eaHA1NA
        7SvSpKuGBGpDdYSDR7HfV0/cysiSOSE=
X-Google-Smtp-Source: ABdhPJxg3N+77We77GtBfU3HO3KbnyCUWQPL/gyrOIpei/f9u+atdKELAq49x9XX6H8sfk20ORwaCt3mK4g=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:b1bb:fab2:7ef5:fc7d])
 (user=seanjc job=sendgmr) by 2002:a25:4802:: with SMTP id v2mr14633309yba.162.1616702487273;
 Thu, 25 Mar 2021 13:01:27 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Mar 2021 13:01:18 -0700
In-Reply-To: <20210325200119.1359384-1-seanjc@google.com>
Message-Id: <20210325200119.1359384-3-seanjc@google.com>
Mime-Version: 1.0
References: <20210325200119.1359384-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH v2 2/3] KVM: x86/mmu: Ensure TLBs are flushed for TDP MMU
 during NX zapping
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Honor the "flush needed" return from kvm_tdp_mmu_zap_gfn_range(), which
does the flush itself if and only if it yields (which it will never do in
this particular scenario), and otherwise expects the caller to do the
flush.  If pages are zapped from the TDP MMU but not the legacy MMU, then
no flush will occur.

Fixes: 29cf0f5007a2 ("kvm: x86/mmu: NX largepage recovery for TDP MMU")
Cc: stable@vger.kernel.org
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index c6ed633594a2..5a53743b37bc 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5939,6 +5939,8 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 	struct kvm_mmu_page *sp;
 	unsigned int ratio;
 	LIST_HEAD(invalid_list);
+	bool flush = false;
+	gfn_t gfn_end;
 	ulong to_zap;
 
 	rcu_idx = srcu_read_lock(&kvm->srcu);
@@ -5960,19 +5962,20 @@ static void kvm_recover_nx_lpages(struct kvm *kvm)
 				      lpage_disallowed_link);
 		WARN_ON_ONCE(!sp->lpage_disallowed);
 		if (is_tdp_mmu_page(sp)) {
-			kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn,
-				sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level));
+			gfn_end = sp->gfn + KVM_PAGES_PER_HPAGE(sp->role.level);
+			flush = kvm_tdp_mmu_zap_gfn_range(kvm, sp->gfn, gfn_end);
 		} else {
 			kvm_mmu_prepare_zap_page(kvm, sp, &invalid_list);
 			WARN_ON_ONCE(sp->lpage_disallowed);
 		}
 
 		if (need_resched() || rwlock_needbreak(&kvm->mmu_lock)) {
-			kvm_mmu_commit_zap_page(kvm, &invalid_list);
+			kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 			cond_resched_rwlock_write(&kvm->mmu_lock);
+			flush = false;
 		}
 	}
-	kvm_mmu_commit_zap_page(kvm, &invalid_list);
+	kvm_mmu_remote_flush_or_zap(kvm, &invalid_list, flush);
 
 	write_unlock(&kvm->mmu_lock);
 	srcu_read_unlock(&kvm->srcu, rcu_idx);
-- 
2.31.0.291.g576ba9dcdaf-goog

