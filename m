Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D479B457B88
	for <lists+kvm@lfdr.de>; Sat, 20 Nov 2021 05:54:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237241AbhKTEzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 23:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236900AbhKTEyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 23:54:46 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E58EC0613B3
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:20 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id h134-20020a25d08c000000b005f5cd3befbbso842023ybg.10
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 20:51:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=5jSoienwu2EmQOFwC5eYL0nZeslWeLTguu5n+4aZuFQ=;
        b=s4dD3+6VYlLhcv66XkqJRvRBAUDhX5CksHNJcZ+vbxMaHEYu0sTmyfb0wcvMc8LYkL
         ko8CDsSC0npN1JD/73980BUYUF3JvGw6DCngO4Nfso9fRKj9MHU+CRILd+JnRuqpkCDp
         bFniUTcdHwF10jSOUa/0Ri1Smv6nRBHh8vWg+T4SrPgc99JCXci+1v8j55BkU8p9JGkI
         8Wj+ks5XFgKjbiy9jfb229VoP8PYE+xydJSnIMJWxrFt2TZN20ERLnOFenCo7Th/rFHa
         kk0/w+rN9XXblron+ISNzLbyeEyiPLz9LLjEfogoaLim7wR5e8/QpZ9STPzstAdapj2b
         h+uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=5jSoienwu2EmQOFwC5eYL0nZeslWeLTguu5n+4aZuFQ=;
        b=PuvEpzUQ3bT1Iz+O5ueu8fflqnALt+oY5asy+q9JgtfFM2Z1qrezI/NAMEalujVQKt
         6ldQ/tvAdXZZwPOtFoTUYCh/mj2Sdonja1CcIN0HemoxavgMt5olW/IdTYF55Iv8bV0C
         VKR1m9WG7ICb8fcgFs5/YxgQg9HKBBgwDq5f+AgVlNCzqmRH/t8H6rFt+VRbyvu0OQoA
         usdTawaqseYz90gjYPk5xY+aeTc2dkpxyFvzyd8ZYUUQLzsfjQPHTjpGO190wGlaWSBu
         Af0DiwC2NIvAYwZfesUXbtrBE2MKplWnAsCgOKgTDOgMT0MNFNR2abk7X2o22OmYn9Kw
         hPVg==
X-Gm-Message-State: AOAM532u59BkfVsmmWdoPB6SzV0CQHRDmUEquhbGigFT4pdG33jchd0Y
        zifwns4tq9AnzXEaWDv+MVaBMdHtv+0=
X-Google-Smtp-Source: ABdhPJxbdy+I6Hql4u/1zRTRDXVZETSx8iioHLVbrSAgX4s52XvY3QTZxioyq1Jzc9vDvc8T1m94bvU2NO4=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a25:a427:: with SMTP id f36mr41341862ybi.245.1637383879396;
 Fri, 19 Nov 2021 20:51:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat, 20 Nov 2021 04:50:34 +0000
In-Reply-To: <20211120045046.3940942-1-seanjc@google.com>
Message-Id: <20211120045046.3940942-17-seanjc@google.com>
Mime-Version: 1.0
References: <20211120045046.3940942-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [PATCH 16/28] KVM: x86/mmu: WARN if old _or_ new SPTE is REMOVED in
 non-atomic path
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

WARN if the new_spte being set by __tdp_mmu_set_spte() is a REMOVED_SPTE,
which is called out by the comment as being disallowed but not actually
checked.  Keep the WARN on the old_spte as well, because overwriting a
REMOVED_SPTE in the non-atomic path is also disallowed (as evidence by
lack of splats with the existing WARN).

Fixes: 08f07c800e9d ("KVM: x86/mmu: Flush TLBs after zap in TDP MMU PF handler")
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 085f6b09e5f3..d9524b387221 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -638,13 +638,13 @@ static inline void __tdp_mmu_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	/*
-	 * No thread should be using this function to set SPTEs to the
+	 * No thread should be using this function to set SPTEs to or from the
 	 * temporary removed SPTE value.
 	 * If operating under the MMU lock in read mode, tdp_mmu_set_spte_atomic
 	 * should be used. If operating under the MMU lock in write mode, the
 	 * use of the removed SPTE should not be necessary.
 	 */
-	WARN_ON(is_removed_spte(iter->old_spte));
+	WARN_ON(is_removed_spte(iter->old_spte) || is_removed_spte(new_spte));
 
 	kvm_tdp_mmu_write_spte(iter->sptep, new_spte);
 
-- 
2.34.0.rc2.393.gf8c9666880-goog

