Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD04325822
	for <lists+kvm@lfdr.de>; Thu, 25 Feb 2021 21:56:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234663AbhBYUzv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Feb 2021 15:55:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234703AbhBYUwj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Feb 2021 15:52:39 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1C87C061A30
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:58 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id j4so7503584ybt.23
        for <kvm@vger.kernel.org>; Thu, 25 Feb 2021 12:48:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=y8jiycfjUxxVO938X7a576VwC4HXLrVyvTnTPoiD+9s=;
        b=eNCsODt7UEHMvR1/ED+Zj+vz21xpXM/UQzn/+fZ0hiti6zgJjcBXAFJGQHgoD/KcQy
         xc3OLsfeE+yFMC3MvjVP05B16WvpjlNqzE1NopMAgH438ueOh4228lgH4WSj0nAXgqcA
         mva+SKPevaWJ3y9nlYApr3VMpwnHODzAu+a7GOwByn1VoWZcVNk5UQGztQ0s8Uy4Bun/
         ljpouolUDjt+bWiDo1feIAzeqKADIObgXHOHoJVmm5AN6K4tuJ62PAzDAQhe9qEJAMAc
         bAi251md3xfZs0xP3GRNhRf9F2s4LdBLL0qoF0OIac0BzUlZO4KiDMGb4j07161ctLbO
         wTmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=y8jiycfjUxxVO938X7a576VwC4HXLrVyvTnTPoiD+9s=;
        b=t6maTwcIoNiRe2i4E6NavBeGVIoeLfetqkSVQJAE26fC7+N9Va4wEW9zqEYRcJ+gGa
         q4zSiYZKpQqsKmQGbA4d5XTtQ9CHsRgGymwOp5c0u9N0TuM12b3jDjXAPWksfzxez6fm
         aXYhUYA1pN4puVvc11j4APj6ACWbP2/BpwdPwRjDKtWk+GYmJVCVJJSm3ee0dcp6sTBu
         SmCbnkDkgUaU3gks75XJ/nXpOljRt3AU3QZGVkdP6bNvAJtyx5933cSoOa/XxX4jvpzZ
         RLYZd49fzz4SG8uY6jMnWzZw9+8a7chJgnm+2fAYOBUlZc8EOUtKLIsrIpDKXGb1XsrZ
         ZpdA==
X-Gm-Message-State: AOAM531skiaM9GM7spx4N8IVRuZcxfEAvrDv4WicaqRbdcoMxnGV+S/W
        8UilVmmxLXeDkcRkDWsiw47zZ/4ufTo=
X-Google-Smtp-Source: ABdhPJwJMDv/GfYEkzf+62vi+Eu4Ngvn08CT2146trjLMXX0WtWN34n3K9I88D3lijgn6A2CyulqkDQl0pE=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:34c4:7c1d:f9ba:4576])
 (user=seanjc job=sendgmr) by 2002:a25:6191:: with SMTP id v139mr6967857ybb.447.1614286137935;
 Thu, 25 Feb 2021 12:48:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Feb 2021 12:47:47 -0800
In-Reply-To: <20210225204749.1512652-1-seanjc@google.com>
Message-Id: <20210225204749.1512652-23-seanjc@google.com>
Mime-Version: 1.0
References: <20210225204749.1512652-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 22/24] KVM: x86/mmu: Use is_removed_spte() instead of open
 coded equivalents
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

Use the is_removed_spte() helper instead of open coding the check.

No functional change intended.

Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index bef0e1908e82..7f2c4760b84d 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -490,7 +490,7 @@ static inline bool tdp_mmu_set_spte_atomic(struct kvm *kvm,
 	 * Do not change removed SPTEs. Only the thread that froze the SPTE
 	 * may modify it.
 	 */
-	if (iter->old_spte == REMOVED_SPTE)
+	if (is_removed_spte(iter->old_spte))
 		return false;
 
 	if (cmpxchg64(rcu_dereference(iter->sptep), iter->old_spte,
@@ -565,7 +565,7 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	 * should be used. If operating under the MMU lock in write mode, the
 	 * use of the removed SPTE should not be necessary.
 	 */
-	WARN_ON(iter->old_spte == REMOVED_SPTE);
+	WARN_ON(is_removed_spte(iter->old_spte));
 
 	WRITE_ONCE(*rcu_dereference(iter->sptep), new_spte);
 
-- 
2.30.1.766.gb4fecdf3b7-goog

