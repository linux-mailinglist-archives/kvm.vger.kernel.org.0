Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FAD436F34
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 03:00:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232381AbhJVBCb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 21:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232274AbhJVBC3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 21:02:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446C0C061766
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 18:00:13 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id p8-20020a056902114800b005bad2571fbeso2152344ybu.23
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 18:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CEz0cfqyCM1YyDBPzVH5K8gS+lZ/6FKI3lwCTpkXChk=;
        b=JOb+bIFN0HacDWgyRwY6VNvFaTuKUPGHZmjICmx3VcLLP/4rhG8aPWlawdn1qJzGWX
         nwpBsO3t64oSX6vfq9iyK1YQpYA9kWLwqTVzFntPlxYuGsUakbnb7WtHaGWvxNeMKPzc
         6rDKeKnKqE9LAn1klw2+nQN6VLQuCUyFwNPZcOxuKuwhZiPrV6RChvYm97OeK0lN9f+A
         6GZHkrRhymW7HNBgSkCZD+ZtFN+/G8cOzP4cAD26nKB7yHix+61ACF+eGmBBP6Es504U
         dqx77F+KmkIA9fZJBZbT8V1gX7FAckk4DDNF/oXZfKaaD4ymGjpQwmOQ3mm8suizAfhp
         MXFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CEz0cfqyCM1YyDBPzVH5K8gS+lZ/6FKI3lwCTpkXChk=;
        b=VTheNR6BQNbg4oG9TT1DgbSL7yOFqwe3ZvY+vR2hGLU2Rvvd/5T0VYncb9Q+j2YF2T
         qF9XPFJNC2rlJH4r0bCzojlgNcGDxgHHQKrrmE9byySMOVafUek4rqezSd5OIHe4KgzL
         N9lQIL5QcL5Kc9IdwA5Ho8nYv5tEDA03UDQLfQiCwanacVOAYrz0kOIe9X+MKw8NUjp6
         8g/J3RVTuWzCXSfZLyMQb+GYRYn8PYCk28ItRVzuW0E7iZfJaHJ90HWYyLj5rLwNG49X
         bCP1mWDOwQGKQ0ShjGOdKGmcb3VCgibnj4o41JSLoYwlKIvebJ/ASbj1lvHA6Urd+Ut6
         ihwQ==
X-Gm-Message-State: AOAM532TCXM39fsL/GsCfq+g66jRmRLJHUB5pYDeGaWOHfH3oDf7qxc+
        0EHXiGfdTEbl3YCGfj8TGh7J/QMP7VY=
X-Google-Smtp-Source: ABdhPJyvAeFY5DSnXh01pytX15xxReq4+Fub+mZQ0bKtNl31NsAju/a48GfejbdSbDI6R3rgKed6Py9hvDc=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:db63:c8c0:4e69:449d])
 (user=seanjc job=sendgmr) by 2002:a25:c84:: with SMTP id 126mr9369570ybm.540.1634864412515;
 Thu, 21 Oct 2021 18:00:12 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 21 Oct 2021 18:00:04 -0700
In-Reply-To: <20211022010005.1454978-1-seanjc@google.com>
Message-Id: <20211022010005.1454978-3-seanjc@google.com>
Mime-Version: 1.0
References: <20211022010005.1454978-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH 2/3] KVM: x86/mmu: Drop a redundant remote TLB flush in kvm_zap_gfn_range()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove an unnecessary remote TLB flush in kvm_zap_gfn_range() now that
said function holds mmu_lock for write for its entire duration.  The
flush was added by the now-reverted commit to allow TDP MMU to flush while
holding mmu_lock for read, as the transition from write=>read required
dropping the lock and thus a pending flush needed to be serviced.

Fixes: 5a324c24b638 ("Revert "KVM: x86/mmu: Allow zap gfn range to operate under the mmu read lock"")
Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index f82b192bba0b..e8b8a665e2e9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5700,9 +5700,6 @@ void kvm_zap_gfn_range(struct kvm *kvm, gfn_t gfn_start, gfn_t gfn_end)
 						end - 1, true, flush);
 			}
 		}
-		if (flush)
-			kvm_flush_remote_tlbs_with_address(kvm, gfn_start,
-							   gfn_end - gfn_start);
 	}
 
 	if (is_tdp_mmu_enabled(kvm)) {
-- 
2.33.0.1079.g6e70778dc9-goog

